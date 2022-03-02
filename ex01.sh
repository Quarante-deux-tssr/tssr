#!/usr/bin/env bash

# Ecrire un script qui affiche le nombre d'arguments entrés par l'utilisateur et qui affiche les 4 
# premiers. S'il y en a moins que 4, afficher "inexistant" pour ceux qui manquent. 

for ((d=1;d<=4;d++)); do
    if [[ -z ${1} ]]; then
        echo "argument $d : inexistant"
    else
        echo "argument $d : ${1}"
        shift
    fi
done