#!/bin/bash
# Script de Instalação do Lacuna Web PKI

# Variáveis - Lacuna Web PKI
URL_LACUNA="https://get.webpkiplugin.com/Downloads/2.16.0/setup-deb-64"
ARQUIVO_DOWNLOAD="${HOME}/Downloads/setup-deb-64"
ARQUIVO_DEB="${HOME}/Downloads/setup-deb-64.deb"

# SHA256 do arquivo DEB (Lacuna Web PKI)
CHECKSUM_LACUNA="d98752344e050b7fb040df3fb224998ec466bbffb96ac5e96e1ce455adee0a49"

# Variáveis - dependência libicu74
URL_ICU="http://mirrors.kernel.org/ubuntu/pool/main/i/icu/libicu74_74.2-1ubuntu3_amd64.deb"
ARQUIVO_ICU="${HOME}/Downloads/libicu74_74.2-1ubuntu3_amd64.deb"

# SHA256 do arquivo DEB (libicu74)
CHECKSUM_ICU="d29c97a21a3e3254731cfac186e4d4e611e5e67d2c9a0430f6acfbd9acaefa2e"

echo "Baixando dependência libicu74..."
wget -P "${HOME}/Downloads" "${URL_ICU}"

echo "Verificando checksum do libicu74..."
if ! echo "${CHECKSUM_ICU} ${ARQUIVO_ICU}" | sha256sum -c --status; then
    echo "ERRO: Checksum SHA256 do libicu74 falhou!"
    exit 1
fi
echo "Checksum verificado com sucesso."

echo "Instalando dependência libicu74..."
apt install -y "${ARQUIVO_ICU}"

echo "Limpando arquivos do libicu74..."
rm "${ARQUIVO_ICU}"

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
