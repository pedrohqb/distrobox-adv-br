# Distrobox-adv-br

Trata-se de arquivo assemble para criar contêiner via distrobox com pacotes que fornecem ambiente para uso de certificado digital por advogados no Brasil em qualquer distribuição de Linux recente. 

Estão incluídos:

1) Driver denominado Safesign necessário para uso do token GD Burti, atualmente o mais utilizado pela advocacia;

2) Driver denominado SafeNet necessário para uso do token SafeNet 5100, o segundo mais utilizado pela advocacia;

3) Driver denominado SerproID, necessário para uso do certificado digital da nuvem da Serpro;
  
4) PJeOffice Pro, utilizado para assinatura eletrônica de documentos do sistema PJe, fornecido pelo Conselho Nacional de Justiça - CNJ;
   
5) Lacuna Webpki e Softplan Websigner, utilizado para assinatura eletrônica de documento em sistemas SAJ, fornecido pela Softplan;
   
6) Certisign WebSigner, utilizado no portal de assinatura eletrônica da OAB;
   
7) Okular, utilizado para visualização e assinatura digital de documentos em pdf; e

8) Firefox-ESR, utilizado para acessar sítios de internet, especialmente aqueles que demandam acesso ao token de certificado digital de modo direto, tais como Projudi e eproc.

---

## Instalação

1. Primeiramente, é necessário instalar o distrobox e podman em sua distribuição, além dos pacotes pcsc-lite e ccid - caso já não os tenha -, necessários para que seu sistema possa acessar o token.

Debian, Ubuntu, Linux Mint, Zorin e Pop!_OS:

```bash
sudo apt install pcscd libccid distrobox podman
```

Fedora Workstation e KDE Plasma:

```bash
sudo dnf install distrobox podman
```
Arch Linux:
  
```bash
pacman -S distrobox podman pcsclite ccid
```

openSUSE Tumbleweed:
```bash
sudo zypper in distrobox podman pcsc-ccid
```

**OBS:** Distribuições como Bluefin e Aurora já vêm com distrobox pré-instalado no sistema.

2. Habilitar o pcsc-lite no sistema caso já não esteja:
   
```bash
sudo systemctl enable --now pcscd.service
```

3. Instalar o distrobox-adv-br mediante o comando abaixo:

Para distros em geral:

```bash
distrobox-assemble create --file https://raw.githubusercontent.com/pedrohqb/distrobox-adv-br/refs/heads/main/distrobox-adv-br
```

Para Ubuntu 24.04 ou distros derivadas, tais com Linux Mint (versão principal), Zorin OS e Pop!_OS:

```bash
wget -P ${HOME}/Downloads https://raw.githubusercontent.com/pedrohqb/distrobox-adv-br/refs/heads/main/distrobox-adv-br-ubuntu-24-04 && distrobox-assemble create --file $HOME/Downloads/distrobox-adv-br-ubuntu-24-04
```

---

## Uso

Terminada a instalação, os aplicativos acima mencionados estarão disponíveis para acesso no menu ou equivalente de seu ambiente desktop devidamente identificados com o nome do projeto entre parenteses. Por exemplo: **Firefox-ESR (on distrobox-adv-br)**. Os token SafeNet e Safesign já estão habilitados no Firefox.

---

## Suporte

Havendo qualquer dificuldade no uso de ferramenta, forneça um issue e peça suporte no grupo oficial no [`Telegram`](https://t.me/advogados_linux).
