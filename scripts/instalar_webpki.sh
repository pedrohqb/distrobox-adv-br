#!/bin/bash
# Script de Instalação do Lacuna Web PKI

# Variáveis
URL_LACUNA="https://get.webpkiplugin.com/Downloads/2.13.3/setup-deb-64"
ARQUIVO_DOWNLOAD="${HOME}/Downloads/setup-deb-64"
ARQUIVO_DEB="${HOME}/Downloads/setup-deb-64.deb"
# SHA256 do arquivo DEB
CHECKSUM_LACUNA="8b43c49f07d720480afb90f35a2f159abe916c8ec161e9a64f301e9aebfe9949"

echo "Baixando Lacuna Web PKI..."
mkdir -p "${HOME}/Downloads"
wget -P "${HOME}/Downloads" "${URL_LACUNA}"

echo "Renomeando arquivo..."
mv "${ARQUIVO_DOWNLOAD}" "${ARQUIVO_DEB}"

# Verificação de Checksum
echo "Verificando checksum do Lacuna Web PKI..."
if ! echo "${CHECKSUM_LACUNA}  ${ARQUIVO_DEB}" | sha256sum -c --status; then
    echo "ERRO: Checksum SHA256 do Lacuna Web PKI falhou!"
    exit 1
fi
echo "Checksum verificado com sucesso."

echo "Instalando Lacuna Web PKI..."
apt update && apt install -y "${ARQUIVO_DEB}"

echo "Limpando arquivos do Lacuna Web PKI..."
rm "${ARQUIVO_DEB}"

echo "Instalação do Lacuna Web PKI concluída."
