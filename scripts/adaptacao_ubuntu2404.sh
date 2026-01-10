#!/bin/bash

# Define as URLs dos pacotes
URL_PCSCD="http://launchpadlibrarian.net/722181807/pcscd_2.0.3-1build1_amd64.deb"
URL_LIBPCSC="http://launchpadlibrarian.net/722181806/libpcsclite1_2.0.3-1build1_amd64.deb"

# Define os nomes dos arquivos locais
FILE_PCSCD="pcscd_2.0.3_amd64.deb"
FILE_LIBPCSC="libpcsclite1_2.0.3_amd64.deb"

echo "--- Iniciando o processo de instalação ---"

# 1. Baixando os pacotes
echo "Fechando download dos pacotes..."
wget -O $FILE_PCSCD $URL_PCSCD
wget -O $FILE_LIBPCSC $URL_LIBPCSC

# 2. Instalando os pacotes
# Usamos o 'apt install ./*.deb' para que ele resolva dependências extras automaticamente
echo "Instalando os pacotes baixados..."
sudo apt update
sudo apt install -y ./$FILE_LIBPCSC ./$FILE_PCSCD

# 3. Colocando os pacotes em 'hold'
# Isso impede que o 'apt upgrade' atualize esses pacotes no futuro
echo "Configurando 'apt-mark hold' para evitar upgrades..."
sudo apt-mark hold pcscd libpcsclite1

# 4. Verificação
echo "--- Verificação de status ---"
apt-mark showhold | grep -E 'pcscd|libpcsclite1'

# 5. Limpeza
echo "Limpando arquivos temporários..."
rm $FILE_PCSCD $FILE_LIBPCSC

echo "--- Concluído com sucesso! ---"
