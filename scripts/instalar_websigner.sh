#!/bin/bash
# Script de Instalação do Softplan WebSigner

# Variáveis
URL_WEBSIGNER="https://websigner.softplan.com.br/Downloads/2.15.0/webpki-chrome-64-deb"
ARQUIVO_DOWNLOAD="${HOME}/Downloads/webpki-chrome-64-deb"
ARQUIVO_DEB="${HOME}/Downloads/webpki-chrome-64-deb.deb"
# SHA256 do arquivo DEB
CHECKSUM_WEBSIGNER="04fa41e962d91e4d7337f4707479437bf660f19057fac63829fb46784ee08289"

echo "Baixando Softplan WebSigner..."
wget -P "${HOME}/Downloads" "${URL_WEBSIGNER}"

echo "Renomeando arquivo..."
mv "${ARQUIVO_DOWNLOAD}" "${ARQUIVO_DEB}"

# Verificação de Checksum
echo "Verificando checksum do Softplan WebSigner..."
if ! echo "${CHECKSUM_WEBSIGNER}  ${ARQUIVO_DEB}" | sha256sum -c --status; then
    echo "ERRO: Checksum SHA256 do Softplan WebSigner falhou!"
    exit 1
fi
echo "Checksum verificado com sucesso."

echo "Instalando Softplan WebSigner..."
apt install -y "${ARQUIVO_DEB}"

echo "Limpando arquivos do Softplan WebSigner..."
rm "${ARQUIVO_DEB}"

echo "Instalação do Softplan WebSigner concluída."
