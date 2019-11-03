#script para enumeracao completa de dns
#!/bin/bash

#variaveis armazenando cores
green=$'\e[0;32m'
purple=$'\e[0;35m'
nc=$'\033[0m'

if [ "$1" == "" ]
then
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
fi

#Descobrindo name servers (NS)
echo "${purple}############################################"
echo "           ${green} Name Servers${nc}        "
echo "${purple}############################################${nc}"
host -t ns $1 | cut -d " " -f 4

#Descobrindo mail servers(MX)
echo "${purple}###########################################"
echo "           ${green} Mail Servers${nc}                   "
echo "${purple}###########################################${nc}"
host -t mx $1 | cut -d " " -f 7

#Tentando tranferir zona de todos os name servers
echo "${purple}##########################################"
echo "         ${green}Tentando transferir zona${nc}         "
echo "${purple}##########################################${nc}"
for server in $(host -t ns $1 | cut -d " " -f4)
do
host -l $1 $server
echo " "
done

