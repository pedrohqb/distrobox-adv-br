#!/usr/bin/env python3
"""Download every pinned file and check it against its pinned SHA256 (and
size, where one is pinned). Run weekly by .github/workflows/check-downloads.yml.

Prints a Markdown report on stdout and exits 1 if any download is missing,
changed or unreachable, so the workflow can open an issue.

  check-downloads.py scripts DIR...        shell scripts: URL_X= / CHECKSUM_X= pairs
  check-downloads.py sigillum FILE         the COMPONENTES table of sigillum.sh
  check-downloads.py flatpak MANIFEST      extra-data sources (url, sha256, size)

Only the standard library is used.
"""
import hashlib
import re
import ssl
import sys
import urllib.error
import urllib.request
from pathlib import Path

UA = {"User-Agent": "Mozilla/5.0 (X11; Linux x86_64) check-downloads"}


def from_scripts(dirs):
    """(name, url, sha256, size) from the scripts' variable assignments.

    In each script, URL_<X>= pairs with CHECKSUM_<X>= (or SHA256_<X>=). A
    script with exactly one URL and one checksum pairs them whatever their
    names (instructions like URL= and SHA256SUM=).
    """
    var = re.compile(r'^\s*([A-Z0-9_]+)="([^"]+)"', re.M)
    for d in dirs:
        for script in sorted(Path(d).rglob("*.sh")):
            assigns = dict(var.findall(script.read_text(errors="replace")))
            urls = {k: v for k, v in assigns.items() if k.startswith("URL") and v.startswith("http")}
            sums = {
                k: v
                for k, v in assigns.items()
                if re.fullmatch(r"[0-9a-f]{64}", v) and ("CHECKSUM" in k or "SHA256" in k)
            }
            if len(urls) == 1 and len(sums) == 1:
                ((uk, url),), ((_, sha),) = urls.items(), sums.items()
                yield f"{script.name} ({uk})", url, sha, None
                continue
            for uk, url in sorted(urls.items()):
                suffix = uk[len("URL"):]
                sha = next((v for k, v in sums.items() if k.endswith(suffix) and suffix), None)
                if sha:
                    yield f"{script.name} ({uk})", url, sha, None
                else:
                    yield f"{script.name} ({uk})", url, None, None


def from_sigillum(path):
    """(name, url, sha256, size) from the COMPONENTES lines of sigillum.sh."""
    text = Path(path).read_text()
    block = re.search(r'^COMPONENTES="\n(.*?)^"', text, re.M | re.S)
    for line in (block.group(1) if block else "").splitlines():
        f = line.split("|")
        if len(f) >= 3:
            yield f[0], f[1], f[2], None


def from_flatpak(path):
    """(name, url, sha256, size) from the extra-data sources of a manifest."""
    text = Path(path).read_text()
    entry = re.compile(
        r"type: extra-data\s+filename: (\S+).*?url: (\S+)\s+sha256: ([0-9a-f]{64})\s+size: (\d+)", re.S
    )
    for name, url, sha, size in entry.findall(text):
        yield name, url, sha, int(size) or None  # 0: not filled in yet


def fetch(url, verify=True):
    ctx = None if verify else ssl._create_unverified_context()
    req = urllib.request.Request(url, headers=UA)
    h, size = hashlib.sha256(), 0
    with urllib.request.urlopen(req, timeout=300, context=ctx) as r:
        while chunk := r.read(1 << 20):
            h.update(chunk)
            size += len(chunk)
    return h.hexdigest(), size


def check(items):
    rows, failed = [], 0
    for name, url, sha, size in items:
        note = ""
        if not sha:
            rows.append((name, url, "⚠️ sem SHA256 fixado no script", ""))
            continue
        try:
            try:
                got, got_size = fetch(url)
            except urllib.error.URLError as e:
                if not isinstance(getattr(e, "reason", None), ssl.SSLError):
                    raise
                # Some vendors' servers have had certificate problems; the
                # SHA256 is what vouches for the file.
                got, got_size = fetch(url, verify=False)
                note = " (certificado do servidor inválido; o arquivo foi conferido pelo SHA256)"
        except Exception as e:  # noqa: BLE001 - every failure goes in the report
            failed += 1
            rows.append((name, url, f"❌ não baixou: {e}", ""))
            continue
        if got != sha:
            failed += 1
            rows.append((name, url, "❌ **o arquivo mudou**", f"fixado `{sha}`, baixado `{got}`"))
        elif size is not None and size != got_size:
            failed += 1
            rows.append((name, url, "❌ tamanho diferente", f"fixado {size}, baixado {got_size}"))
        else:
            rows.append((name, url, "✅ confere" + note, f"{got_size:,} bytes".replace(",", ".")))
    return rows, failed


def main():
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    mode, args = sys.argv[1], sys.argv[2:]
    items = {"scripts": lambda: from_scripts(args), "sigillum": lambda: from_sigillum(args[0]),
             "flatpak": lambda: from_flatpak(args[0])}[mode]()
    rows, failed = check(list(items))
    if not rows:
        print("Nenhum download fixado foi encontrado; confira o check-downloads.py.")
        return 1
    print("| Arquivo | Resultado | Detalhe |\n|---|---|---|")
    for name, url, result, detail in rows:
        print(f"| [{name}]({url}) | {result} | {detail} |")
    print()
    if failed:
        print(f"**{failed} download(s) com problema.** Um arquivo que mudou no mesmo endereço precisa de "
              "conferência antes de se trocar o SHA256 fixado; um que não baixou pode ter saído do ar ou "
              "mudado de endereço (versão nova).")
    else:
        print("Todos os downloads conferem com o SHA256 fixado.")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
