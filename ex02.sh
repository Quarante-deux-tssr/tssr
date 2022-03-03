#!/usr/bin/env bash

# Exercice 2 :
# Vous allez écrire un script prenant en paramètre(s) entre 1 et 3 noms de fichiers. 
# Vous afficherez alors pour chacun de ces fichiers : 
# - si c'est un fichier simple, un répertoire ou un autre type de fichier. 
# - Pour un fichier simple, vous donnerez les droits.

for a in $@; do
    if [[ -f $a ]];
    then
        echo "$a est un simple fichier"
        echo $(ls -l $a | cut -d " " -f 1)
    elif [[ -d $a ]];
    then
        echo "$a est un répértoire"
    elif [[ -e $a ]];
    then
        echo "$a est un autre type de fichier"
    else
        echo "$a n'existe pas"
    fi
done
