#!/bin/bash
# Script de Instalação do pcscd e libpcsclite1 do Ubuntu 24.04 (v2.0.3)

# Verificação de privilégios de root
if [ "$EUID" -ne 0 ]; then 
  echo "Erro: Por favor, execute este script como root."
  exit 1
fi

# Variáveis
DIR_DOWNLOAD="${HOME}/Downloads"
URL_LIBPCSC="http://launchpadlibrarian.net/722181806/libpcsclite1_2.0.3-1build1_amd64.deb"
URL_PCSCD="http://launchpadlibrarian.net/722181807/pcscd_2.0.3-1build1_amd64.deb"

ARQUIVO_LIBPCSC="${DIR_DOWNLOAD}/libpcsclite1_2.0.3-1build1_amd64.deb"
ARQUIVO_PCSCD="${DIR_DOWNLOAD}/pcscd_2.0.3-1build1_amd64.deb"

# SHA256 dos arquivos
CHECKSUM_LIBPCSC="561845811776949f50f44369a311140608643199c278912803b98c3979401824"
CHECKSUM_PCSCD="8b0227918a0033d59664531868470a24d29e31980838634177b9666014457635"

# Garantir que o diretório de download existe
mkdir -p "${DIR_DOWNLOAD}"

echo "Baixando pacotes pcscd e libpcsclite1..."
wget -P "${DIR_DOWNLOAD}" "${URL_LIBPCSC}"
wget -P "${DIR_DOWNLOAD}" "${URL_PCSCD}"

# Verificação de Checksum - libpcsclite1
echo "Verificando checksum do libpcsclite1..."
if ! echo "${CHECKSUM_LIBPCSC}  ${ARQUIVO_LIBPCSC}" | sha256sum -c --status; then
    echo "ERRO: Checksum SHA256 do libpcsclite1 falhou!"
    exit 1
fi
echo "Checksum do libpcsclite1 verificado com sucesso."

# Verificação de Checksum - pcscd
echo "Verificando checksum do pcscd..."
if ! echo "${CHECKSUM_PCSCD}  ${ARQUIVO_PCSCD}" | sha256sum -c --status; then
    echo "ERRO: Checksum SHA256 do pcscd falhou!"
    exit 1
fi
echo "Checksum do pcscd verificado com sucesso."

echo "Atualizando índices de pacotes..."
apt update

echo "Instalando pacotes..."
apt install -y "${ARQUIVO_LIBPCSC}" "${ARQUIVO_PCSCD}"

echo "Configurando pacotes em hold (bloqueando upgrades)..."
apt-mark hold libpcsclite1 pcscd

echo "Limpando arquivos de instalação..."
rm "${ARQUIVO_LIBPCSC}" "${ARQUIVO_PCSCD}"

echo "----------------------------------------------------"
echo "Instalação concluída e pacotes travados (hold)."
echo "Status atual:"
apt-mark showhold | grep -E 'pcscd|libpcsclite1'
echo "----------------------------------------------------"
