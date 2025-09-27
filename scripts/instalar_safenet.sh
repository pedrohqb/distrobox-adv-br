#!/bin/bash
# Script de Instalação do SafeNet Authentication Client (SAC)

# Variáveis
URL_SAFENET="https://www.digicert.com/StaticFiles/Linux_SAC_10.9_GA.zip"
ARQUIVO_ZIP="${HOME}/Downloads/Linux_SAC_10.9_GA.zip"
DIRETORIO_EXTRAIDO="${HOME}/Downloads/SAC_10.9 GA"
ARQUIVO_DEB="${DIRETORIO_EXTRAIDO}/Installation/withoutUI/Ubuntu-2204/safenetauthenticationclient-core_10.9.4723_amd64.deb"
# SHA256 do arquivo zip
CHECKSUM_SAFENET="46759cfe91d736af18a49d10e4749f264022db44e04ed4caf94e1ca77d6a013e"

echo "Baixando SafeNet Authentication Client..."
mkdir -p "${HOME}/Downloads"
wget -P "${HOME}/Downloads" "${URL_SAFENET}"

# Verificação de Checksum
echo "Verificando checksum do SafeNet..."
if ! echo "${CHECKSUM_SAFENET}  ${ARQUIVO_ZIP}" | sha256sum -c --status; then
    echo "ERRO: Checksum SHA256 do SafeNet falhou!"
    exit 1
fi
echo "Checksum verificado com sucesso."

echo "Descompactando SafeNet..."
unzip "${ARQUIVO_ZIP}" -d "${HOME}/Downloads"

echo "Instalando SafeNet..."
apt update && apt install -y "${ARQUIVO_DEB}"

echo "Limpando arquivos do SafeNet..."
rm -rf "${DIRETORIO_EXTRAIDO}" "${ARQUIVO_ZIP}"

echo "Instalação do SafeNet Authentication Client concluída."
