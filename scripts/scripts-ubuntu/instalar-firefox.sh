#!/bin/bash
# Este script tem como objetivo instalar ou atualizar o Firefox
# usando o Personal Package Archive (PPA) oficial da equipe Mozilla,
# garantindo que o sistema sempre prefira esta versão mais recente 
# sobre as versões padrão dos repositórios da distribuição (como o Snap ou a versão antiga do Ubuntu).

# 1. Adiciona o PPA da equipe Mozilla aos repositórios do sistema.
# Isso garante acesso às versões mais recentes e oficiais do Firefox.
apt install software-properties-common -y && \
add-apt-repository ppa:mozillateam/ppa -y && \

# 2. Cria um arquivo de 'APT Pinning' para dar preferência ao PPA.
cat << EOF > /etc/apt/preferences.d/mozillateamppa
# Define que as regras a seguir se aplicam a qualquer pacote que comece com 'firefox'.
Package: firefox*
# Define o repositório específico a ser priorizado, que é o PPA da equipe Mozilla.
Pin: release o=LP-PPA-mozillateam
# Define a prioridade do pacote. Valores acima de 500 (o padrão) forçam o sistema 
# a preferir este pacote sobre qualquer outro com o mesmo nome.
Pin-Priority: 501
EOF

# 3. Atualiza o índice de pacotes do sistema.
# Isso baixa as informações dos pacotes recém-adicionados do PPA.
apt update && \

# 4. Instala ou atualiza o pacote 'firefox'.
# Devido à regra de Pin-Priority 501, a versão instalada será a do PPA oficial.
# O '-y' confirma automaticamente a instalação.
apt install firefox -y
