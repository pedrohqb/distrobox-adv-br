#!/bin/bash
# Script de Instalação do Lacuna Web PKI

# Variáveis - Lacuna Web PKI
URL_LACUNA="https://get.webpkiplugin.com/Downloads/2.16.1/setup-deb-64"
ARQUIVO_DOWNLOAD="${HOME}/Downloads/setup-deb-64"
ARQUIVO_DEB="${HOME}/Downloads/setup-deb-64.deb"

# SHA256 do arquivo DEB (Lacuna Web PKI)
CHECKSUM_LACUNA="a4ef76b1f0f5ff4489211b459d147ef0e2dea2ecad97d8f9ba2b0b283d3e3d85"

echo "Baixando Lacuna Web PKI..."
wget -P "${HOME}/Downloads" "${URL_LACUNA}"

echo "Renomeando arquivo..."
mv "${ARQUIVO_DOWNLOAD}" "${ARQUIVO_DEB}"

# Verificação de Checksum
echo "Verificando checksum do Lacuna Web PKI..."
if ! echo "${CHECKSUM_LACUNA} ${ARQUIVO_DEB}" | sha256sum -c --status; then
    echo "ERRO: Checksum SHA256 do Lacuna Web PKI falhou!"
    exit 1
fi
echo "Checksum verificado com sucesso."

echo "Instalando Lacuna Web PKI..."
apt install -y "${ARQUIVO_DEB}"

echo "Limpando arquivos do Lacuna Web PKI..."
rm "${ARQUIVO_DEB}"

echo "Instalação do Lacuna Web PKI concluída."
