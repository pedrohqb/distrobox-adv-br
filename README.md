# Distrobox-adv-br

Trata-se de arquivo assemble para criar contêiner do Debian 13 (trixie) via distrobox com pacotes que fornecem ambiente para uso de certificado digital por advogados no Brasil em qualquer distribuição de Linux recente. 

Estão incluídos:

1) Driver denominado Safesign necessário para uso do token GD Burti, atualmente o mais utilizado pela advocacia;

2) PJeOffice Pro, utilizado para assinatura eletrônica de documentos do sistema PJe, fornecido pelo Conselho Nacional de Justiça - CNJ;
   
4) Lacuna Webpki e Softplan Websigner, utilizado para assinatura eletrônica de documento em sistemas SAJ, fornecido pela Softplan;
   
6) Okular, utilizado para visualização e assinatura digital de documentos em pdf; e

7) Firefox-OSR, utilizado para acessar sítios de internet, especialmente aqueles que demandam acesso ao token de certificado digital de modo direto, tais como Projudi e eproc.

---

## Instalação

1. Primeiramente, é necessário instalar o distrobox e podman em sua distribuição, além dos pacotes pcsc-lite e ccid - caso já não os tenha -, necessários para que seu sistema possa acessar o token.

Debian e Ubuntu:

```bash
sudo apt install pcsc-lite libccid distrobox podman
```

Fedora Workstation e KDE Plasma:

```bash
sudo dnf install distrobox podman
```
Arch Linux:
  
```bash
pacman -S distrobox podman pcsclite ccid
```

openSUSE:
```bash
sudo zypper in distrobox podman pcsc-ccid
```

**OBS:** Distribuições como Bluefin e Aurora já vêm com distrobox pré-instalado no sistema.

2. Habilitar o pcsc-lite no sistema caso já não esteja:
   
```bash
sudo systemctl enable --now pcscd.service
```

3. Instalar o distrobox-adv-br mediante o comando abaixo:

```bash
distrobox-assemble create --file https://raw.githubusercontent.com/pedrohqb/distrobox-adv-br/refs/heads/main/distrobox-adv-br
```

**OBS:** Também é possível instalar graficamente o distrobox-adv-br mediante DistroShelf, disponível no [`Flathub`](https://flathub.org/apps/com.ranfdev.DistroShelf), ou mediante [`Linux Toys`](https://github.com/psygreg/linuxtoys).

---

## Uso

Terminada a instalação, os aplicativos acima mencionados estarão disponíveis para acesso no menu ou equivalente de seu ambiente desktop devidamente identificados com o nome do projeto entre parenteses. Por exemplo: **Firefox-ESR (on distrobox-adv-br)**.

Feita a instalação, é importante habilitar o uso do Safesign pelo Firefox. Para tanto, basta iniciar o aplicativo **Utilitário de administração de token**, acessar o menu **Integração** e selecionar **Instalar o SafeSign no Firefox**.

---

## A fazer:

+ Adicionar suporte ao SafeNet, aparentemente o segundo mais utilizado token por advogados no Brasil; e
+ Automatizar a instalação do certificado digital como dispositivo de segurança no Firefox (possivelmente mediante uso do p11-kit).

---

## Suporte

Havendo qualquer dificuldade no uso de ferramenta, forneça um issue e peça suporte no grupo oficial no [`Telegram`](https://t.me/advogados_linux).
