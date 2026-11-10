#!/bin/bash
# Script de Instalação do SafeNet Authentication Client (SAC)

# Variáveis
# Pacote da Thales para Ubuntu 24.04 distribuído pela GlobalSign (22 MB, com
# assinatura PGP da Thales; o mesmo do sac-core no AUR)
URL_SAFENET="https://www.globalsign.com/en/safenet-drivers/USB/10.9/GlobalSign-SAC-Linux-Ubuntu-24.04.4-v10.9.zip"
ARQUIVO_ZIP="${HOME}/Downloads/GlobalSign-SAC-Linux-Ubuntu-24.04.4-v10.9.zip"
DIRETORIO_EXTRAIDO="${HOME}/Downloads/GlobalSign SAC Linux Ubuntu 24.04.4 v10.9"
ARQUIVO_DEB="${DIRETORIO_EXTRAIDO}/GlobalSign SAC Linux Ubuntu 24.04.4 v10.9 withoutUI/GlobalSign SAC Linux Ubuntu 24.04.4 v10.9/610-013349-004_RevB_safenetauthenticationclient-core_10.9.6885_amd64.deb"
# SHA256 do arquivo zip
CHECKSUM_SAFENET="c076c2ecb3842478e431ba81e1688f8c6386d7a374780c055047d2c9930cf428"

echo "Baixando SafeNet Authentication Client..."
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
apt install -y "${ARQUIVO_DEB}"

echo "Limpando arquivos do SafeNet..."
# As pastas do zip vêm somente leitura (0555)
chmod -R u+w "${DIRETORIO_EXTRAIDO}"
rm -rf "${DIRETORIO_EXTRAIDO}" "${ARQUIVO_ZIP}"

echo "Instalação do SafeNet Authentication Client concluída."
