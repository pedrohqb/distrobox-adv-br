#!/bin/bash
# Script de Instalação do Lacuna Web PKI

# Variáveis
URL_LACUNA="https://get.webpkiplugin.com/Downloads/2.14.2/setup-deb-64"
ARQUIVO_DOWNLOAD="${HOME}/Downloads/setup-deb-64"
ARQUIVO_DEB="${HOME}/Downloads/setup-deb-64.deb"
# SHA256 do arquivo DEB
CHECKSUM_LACUNA="79ba749827d4fc9afcbde6615d3bae0ff49ab32755d33dda6961a5f5de71d1a8"

echo "Baixando Lacuna Web PKI..."
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
apt install -y "${ARQUIVO_DEB}"

echo "Limpando arquivos do Lacuna Web PKI..."
rm "${ARQUIVO_DEB}"

echo "Instalação do Lacuna Web PKI concluída."
