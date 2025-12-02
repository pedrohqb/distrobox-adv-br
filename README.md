# Distrobox-adv-br

Trata-se de arquivo assemble para criar contêiner via distrobox com pacotes que fornecem ambiente para uso de certificado digital por advogados no Brasil em distribuições populares e recentes de Linux. 

**OBS**: A distribuições suportadas são Debian, Linux Mint Debian Edition (LMDE), MX Linux, Fedora, Bluefin, Aurora, Arch Linux, Manjaro, BigLinux, EndeavourOS, CachyOS e openSUSE Tumbleweed. **Não há suporte a Ubuntu nem a distribuições derivadas (p.e., Zorin OS, Pop!_OS, Linux Mint, etc.)**, seja por conta da dificuldade de lidar com snaps, seja por conta dos pacotes desatualizados que afetam o funcionamento do contêiner.

Estão incluídos:

1) Driver denominado Safesign necessário para uso do token GD Burti, atualmente o mais utilizado pela advocacia;

2) Driver denominado SafeNet necessário para uso do token SafeNet 5100, o segundo mais utilizado pela advocacia;

3) Driver denominado SerproID, necessário para uso do certificado digital na nuvem da Serpro;
  
4) PJeOffice Pro, utilizado para assinatura eletrônica de documentos do sistema PJe, fornecido pelo Conselho Nacional de Justiça - CNJ;
   
5) Assinador Serpro, utilizado para assinar documentos com certificado digital ou validar documentos já assinados;
   
6) Lacuna Webpki e Softplan Websigner, utilizado para assinatura eletrônica de documento em sistemas SAJ, fornecido pela Softplan;
   
7) Certisign WebSigner, utilizado no portal de assinatura eletrônica da OAB;

8) Firefox, utilizado para acessar sítios de internet, especialmente aqueles que demandam acesso ao token de certificado digital de modo direto, tais como Projudi e eproc; e
   
9) Chromium, utilizado para acessar sítios de internet, especialmente aqueles que demandam acesso ao token de certificado digital de modo direto, tais como Projudi e eproc.

![Exemplo de aplicações funcionando](https://raw.githubusercontent.com/pedrohqb/distrobox-adv-br/refs/heads/main/screenshots/screenshot1.png)

---

## Instalação

1. Primeiramente, é necessário instalar o distrobox e podman em sua distribuição, além dos pacotes pcsc-lite e ccid - caso já não os tenha -, necessários para que seu sistema possa acessar o token.

Debian, Linux Mint Debian Edition e MX Linux:

```bash
sudo apt install pcscd libccid distrobox podman
```

Fedora:

```bash
sudo dnf install distrobox podman
```

Arch Linux, Manjaro, BigLinux, EndeavourOS e CachyOS:
  
```bash
sudo pacman -S distrobox podman pcsclite ccid
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

```bash
distrobox-assemble create --file https://raw.githubusercontent.com/pedrohqb/distrobox-adv-br/refs/heads/main/distrobox-adv-br
```

---

## Uso

Terminada a instalação, os aplicativos acima mencionados estarão disponíveis para acesso no menu ou equivalente de seu ambiente desktop devidamente identificados com o nome do projeto entre parenteses. Por exemplo: **Firefox-ESR (on distrobox-adv-br)**. 

Os token SafeNet e Safesign já estão habilitados no Firefox; o certificado na nuvem SerproID é configurado automaticamente no Firefox após sua instalação na máquina. 

---

## Configuração SerproID

Para configurar o certificado SerproID no plugin do Lacuna Webpki, Softplan Websigner e Certisign WebSigner, deve-se aplicar as orientações a seguir:

1) Abrir o plugin no Firefox ou Chrome;
   
2) Acessar a aba "Cripto Dispositivos";
   
3) Em "Opções personalizadas", no campo "Nome do arquivo SO (com extensão), adicionar "/lib/libneoidp11.so" (sem aspas) e apertar o sinal de "+".

---

## Configuração Assinador Serpro

Para configurar o Assinador Serpro, deve-se aplicar as orientações a seguir:

1) Acessar a opção "Configurações" no aplicativo;
   
2) Acessar a aba "Carregar Driver";
   
3) Selecionar "Carregar driver local" e clicar em "Selecionar arquivo (.so ou .dll);
  
4) Abrir o arquivo /lib/libneoidp11.so, se for utilizar o certificado do SerproID; o arquivo /lib/libaetpkss.so, se for utilizar token SafeSign; ou o /lib/libeToken.so, se for utilizar token SafeNet.

5) Pressionar "Salvar".
   
---

## Desinstalação

Para desinstalar (inclusive para  fazer uma reinstalação limpa), basta rodar os seguintes comandos:

```bash
distrobox rm distrobox-adv-br
```

```bash
rm -rf ~/.distrobox-adv-br
```

---

## Limitações

Existem algumas limitações decorrentes do próprio uso de contêineres. As conhecidas encontram-se a seguir:
   
1) Assinador Serpro indica que não há conexão por internet. Trata-se de falso positivo, uma vez que a integração com outros sistemas funciona normalmente.

Nenhuma das limitações traz repercussões negativas ao uso das ferramentas.

---

## Suporte

Havendo qualquer dificuldade no uso de ferramenta, forneça um issue e peça suporte no grupo oficial no [`Telegram`](https://t.me/advogados_linux).
