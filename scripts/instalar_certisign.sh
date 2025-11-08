#!/bin/bash
# Script de Instalação do Certisign WebSigner

# Variáveis
URL_LACUNA="https://get.websignerplugin.com/Downloads/2.17.7/setup-deb-64"
ARQUIVO_DOWNLOAD="${HOME}/Downloads/setup-deb-64"
ARQUIVO_DEB="${HOME}/Downloads/setup-deb-64.deb"
# SHA256 do arquivo DEB
CHECKSUM_LACUNA="04981f073f61ac7e8662ec12f3d69be1cb8090131836935a111ef9d5b012abfb"

echo "Baixando Certisign WebSigner..."
wget -P "${HOME}/Downloads" "${URL_LACUNA}"

echo "Renomeando arquivo..."
mv "${ARQUIVO_DOWNLOAD}" "${ARQUIVO_DEB}"

# Verificação de Checksum
echo "Verificando checksum do Lacuna Web PKI..."
if ! echo "${CHECKSUM_LACUNA}  ${ARQUIVO_DEB}" | sha256sum -c --status; then
    echo "ERRO: Checksum SHA256 do Certisign WebSigner falhou!"
    exit 1
fi
echo "Checksum verificado com sucesso."

echo "Instalando Certisign WebSigner..."
apt install -y "${ARQUIVO_DEB}"

echo "Limpando arquivos do Certisign WebSigner..."
rm "${ARQUIVO_DEB}"

echo "Instalação do Certisign WebSigner concluída."
