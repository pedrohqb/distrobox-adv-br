#!/bin/bash
# Script de Instalação do Softplan WebSigner

# Variáveis
URL_WEBSIGNER="https://websigner.softplan.com.br/Downloads/2.12.1/webpki-chrome-64-deb"
ARQUIVO_DOWNLOAD="${HOME}/Downloads/webpki-chrome-64-deb"
ARQUIVO_DEB="${HOME}/Downloads/webpki-chrome-64-deb.deb"
# SHA256 do arquivo DEB (CONFIRME ESTE VALOR ANTES DE USAR)
CHECKSUM_WEBSIGNER="5da8fd36f1371f52bbaebede75fade1928f09cff2dd605b8da5663c6da505379"

echo "Baixando Softplan WebSigner..."
mkdir -p "${HOME}/Downloads"
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
