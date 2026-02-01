#!/bin/bash
# Script de Instalação do PJeOffice

# Variáveis
URL_PJEOFFICE="https://github.com/pedrohqb/pje-office-debian/releases/download/2.5.16u-3/pje-office_2.5.16u-3_amd64.deb"
ARQUIVO_DEB="${HOME}/Downloads/pje-office_2.5.16u-3_amd64.deb"
# SHA256 do arquivo DEB
CHECKSUM_PJEOFFICE="d91510730355ebb82cfc7a810a37840392fb25947422ce29ddf6f63a56775cc7"

echo "Baixando PJeOffice..."
wget -P "${HOME}/Downloads" "${URL_PJEOFFICE}"

# Verificação de Checksum
echo "Verificando checksum do PJeOffice..."
if ! echo "${CHECKSUM_PJEOFFICE}  ${ARQUIVO_DEB}" | sha256sum -c --status; then
    echo "ERRO: Checksum SHA256 do PJeOffice falhou!"
    exit 1
fi
echo "Checksum verificado com sucesso."

echo "Instalando PJeOffice..."
apt install -y "${ARQUIVO_DEB}"

echo "Limpando arquivos do PJeOffice..."
rm "${ARQUIVO_DEB}"

echo "Instalação do PJeOffice concluída."
