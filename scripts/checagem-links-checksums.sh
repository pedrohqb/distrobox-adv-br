#!/bin/bash

# Cores para facilitar a leitura
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # Sem cor

echo -e "${BLUE}=== Iniciando Checagem dos Links e Checksums ===${NC}\n"

# Lista de componentes: Nome | URL | SHA256_Esperado
# Nota: Alguns links usam redirecionamento, o curl com -L resolve isso.
check_list=(
    "Certisign WebSigner|https://get.websignerplugin.com/Downloads/2.17.7/setup-deb-64|04981f073f61ac7e8662ec12f3d69be1cb8090131836935a111ef9d5b012abfb"
    "Java Zulu 11|https://cdn.azul.com/zulu/bin/zulu11.82.19-ca-jdk11.0.28-linux_amd64.deb|1b5a3799dc5466137f3ef921d8e1ea50471aecbe895fdaf5afff8d722cfe3b37"
    "PJeOffice|https://github.com/pedrohqb/pje-office-debian/releases/download/2.5.16u-3/pje-office_2.5.16u-3_amd64.deb|d91510730355ebb82cfc7a810a37840392fb25947422ce29ddf6f63a56775cc7"
    "SafeNet SAC|https://www.digicert.com/StaticFiles/Linux_SAC_10.9_GA.zip|46759cfe91d736af18a49d10e4749f264022db44e04ed4caf94e1ca77d6a013e"
    "SafeSign IC|https://assets.ctfassets.net/zuadwp3l2xby/6vGICRnQgQ8TkcHTgcouIr/5acf96dcbc0364aa9228606d3969ef97/SafeSignICStandardLinux4.5.0.0-AET.000ub2404x86_64.deb|7742e21e3141e51e307d7613b4046886bc7c4aa203835dcf5c43cd348f2a1b91"
    "SerproID|https://storagegw.estaleiro.serpro.gov.br/instalador-desktop/SerproID-2.1.6-amd64.deb|0ffa9ffe5bc343cc758a12f28bd7f08aec4b6e843d1c043baf0b81572461e588"
    "Lacuna Web PKI|https://get.webpkiplugin.com/Downloads/2.14.0/setup-deb-64|24e132519f9f6b8a51553e5f4e6cc33d42a63f92c8d7db870563be1b759a00fe"
    "Softplan WebSigner|https://websigner.softplan.com.br/Downloads/2.12.1/webpki-chrome-64-deb|5da8fd36f1371f52bbaebede75fade1928f09cff2dd605b8da5663c6da505379"
)

for item in "${check_list[@]}"; do
    IFS="|" read -r nome url sha_esperado <<< "$item"
    
    echo -n "Checando $nome... "
    
    # Baixa o conteúdo via stream e calcula o hash
    # -L segue redirecionamentos | -s modo silencioso
    sha_atual=$(curl -L -s "$url" | sha256sum | awk '{print $1}')
    
    if [ -z "$sha_atual" ] || [ "$sha_atual" == "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" ]; then
        # O hash acima é de um arquivo vazio, indica erro no download
        echo -e "${RED}[FALHA DE DOWNLOAD / LINK OFF]${NC}"
    elif [ "$sha_atual" == "$sha_esperado" ]; then
        echo -e "${GREEN}[OK]${NC}"
    else
        echo -e "${RED}[ERRO: SHA256 MUDOU]${NC}"
        echo "   Esperado: $sha_esperado"
        echo "   Obtido:   $sha_atual"
    fi
done

echo -e "\n${BLUE}=== Fim da Verificação ===${NC}"
