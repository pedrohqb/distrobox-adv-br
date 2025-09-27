#!/bin/bash
# Script de Instalação do PJeCalc

# Variáveis
URL_PJECALC="https://github.com/pedrohqb/pjecalc-instalador-deb/releases/download/2.14.0-2/pjecalc-instalador-2.14.0-2.deb"
ARQUIVO_DEB="${HOME}/Downloads/pjecalc-instalador-2.14.0-2.deb"
# SHA256 do arquivo DEB
CHECKSUM_PJECALC="9a575783a5c5b1f00e39f50665eb9aa29c35ec519681fc2a4cf7a8a341a76f19"

echo "Baixando PJeCalc..."
wget -P "${HOME}/Downloads" "${URL_PJECALC}"

# Verificação de Checksum
echo "Verificando checksum do PJeCalc..."
if ! echo "${CHECKSUM_PJECALC}  ${ARQUIVO_DEB}" | sha256sum -c --status; then
    echo "ERRO: Checksum SHA256 do PJeCalc falhou!"
    exit 1
fi
echo "Checksum verificado com sucesso."

echo "Instalando PJeCalc..."
apt install -y "${ARQUIVO_DEB}"

echo "Limpando arquivos do PJeCalc..."
rm "${ARQUIVO_DEB}"

echo "Instalação do PJeCalc concluída."
