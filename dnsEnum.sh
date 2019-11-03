#!/usr/bin/env bash

################################################################################
# Titulo    : dns-enum                                                         #
# Versao    : 1.0                                                              #
# Data      : 03/11/2019                                                       #
# Tested on : Linux                                                            #
################################################################################

# ==============================================================================
# Constantes
# ==============================================================================

# Constantes para facilitar o uso de cores.
GREEN=$'\e[0;32m'
PURPLE=$'\e[0;35m'
END=$'\033[0m'
RED='\033[31;1m'

# Constantes armazenando os valores dos argumentos
ARG_01=$1
ARG_02=$2

# Constante armazenando a versão do programa.
VERSION='1.0'


# ==============================================================================
# Banner do programa
# ==============================================================================

__Banner__() {
    echo "#######################################################################"
    echo "                                                                       "
    echo "-----------------------------------------------------------------------"
    echo "--------------------- xFoo0T - DnsEnum - v1.0 -------------------------"
    echo "-----------------------------------------------------------------------"
    echo "                                                                       "
    echo "     ----- Uso Padrão: ./dsnEnum.sh alvo.com.br worldlist.txt -----    "
    echo "    @@  worldlist para brute-force para descoberta de subdominios @@   "
    echo "                                                                       "
    echo "#######################################################################"
    exit 0
}

# ==============================================================================
# Menu de ajuda
# ==============================================================================

__Help__() {
    printf "\
    \nNAME\n \
    \t$0 - Software para realizar a enumeração completa de DNS do host informado.\n \
    \nSYNOPSIS\n \
    \t$0 [Options] [URL]\n \
    \nOPTIONS\n \
    \t-h, --help\n \
    \t\tMostra o menu de ajuda.\n\n \
    \t-v, --version\n \
    \t\tMostra a versão do programa.\n\n \
    \n"
}

# ==============================================================================
# Verificação básica
# ==============================================================================

__basicCheck__() {
    # Verificando as dependências.
    if ! [[ -e /usr/bin/host ]]; then
        printf "\nFaltando programa ${RED}host${END} para funcionar.\n"
        exit 1
    fi

    # Verificando se não foi passado argumentos.
    if [[ $ARG_01 == "" ]]; then
        __Banner__
        exit 1
    fi
}

# ==============================================================================
# Descobrindo name servers (NS)
# ==============================================================================

__discoverNameServers__() {
    echo "${PURPLE}############################################"
    echo "           ${GREEN} Name Servers${END}        "
    echo "${PURPLE}############################################${END}"
    host -t ns $ARG_01 | cut -d " " -f 4
}

# ==============================================================================
# Descobrindo mail servers(MX)
# ==============================================================================

__discoverMailServers__() {
    echo "${PURPLE}###########################################"
    echo "           ${GREEN} Mail Servers${END}                   "
    echo "${PURPLE}###########################################${END}"
    host -t mx $ARG_01 | cut -d " " -f 7
}

# ==============================================================================
# Tentando transferir zona de todos os name servers
# ==============================================================================

__transferZone__() {
    echo "${PURPLE}##########################################"
    echo "         ${GREEN}Tentando transferir zona${END}         "
    echo "${PURPLE}##########################################${END}"
    for server in $(host -t ns $ARG_01 | cut -d " " -f4)
    do
        host -l $ARG_01 $server
        echo " "
    done
} 

# ==============================================================================
# Função principal do programa
# ==============================================================================

__Main__() {
    __basicCheck__

   case $ARG_01 in
        "-v"|"--version") printf "\nVersion: $VERSION\n"
              exit 0
        ;; 
        "-h"|"--help") __Help__
              exit 0
        ;;
        *) __discoverNameServers__
           __discoverMailServers__
           __transferZone__
        ;; 
	esac  
}

# ==============================================================================
# Inicio do programa
# ==============================================================================

__Main__



