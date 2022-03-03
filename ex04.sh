#!/usr/bin/env bash

# Vous allez écrire un script qui propose de calculer soit la factorielle d'un nombre n demandé à 
# l'utilisateur, soit de calculer la somme des entiers de 1 à n, soit qui dessine une pyramide de n 
# étoiles. Vous utiliserez les fonctions.

function pyramide() {
    local line=''
    local espace=" "
    local etoile="*"
    for ((i=0;i<${1};i++)); do
        for ((s=((${1}-$i-1));s>0;s--)); do
            line+=$espace
        done
        for ((e=0;e<((2*$i+1));e++)); do
            line+=$etoile
        done
        echo "$line"
        line=''
    done
    echo " "
}

function suite() {
    local suite=0
    for ((i=0;i<${1};i++)); do
        ((suite+=$i+1))
    done
    echo "La sommes des entiers de 1 à ${1} : $suite"
    echo " "
}

function factorielle() {
    local facto=1
    if [[ ${1} -gt 20 || ${1} -lt 1 ]]; then
        echo "Entrée un nombre entier entre 1 et 20"
    else
        for ((i=0;i<${1};i++)); do
            ((facto*=$i+1))
        done
        echo "${1}! : $facto"
    fi
    echo " "
}

function QuestionN () {
    local reset=0
    while [ ${reset} = 0 ]; do
        read -p "${1} [entier] : " reponse 
        if [[ "${reponse}" =~ ^[0-9]+$ ]]; then
            echo ${reponse}
            reset=1
        else
            reset=0
        fi   
    done
}

function pushenter(){
    local hello=0
    read -p "Appuyer sur entrée" hello
}

while [ true ]; do
    clear 
    PS3="Votre réponse : "
    echo "Que choisissez-vous ?"
    IFS=""
    tab=("Calculer la factorielle d'un nombre entier n!"
    "Calculer la somme des entiers de 1 à n"
    "Dessine une pyramide de n étoiles"
    "Quitter")
    select rep in ${tab[*]}
        do
            if [[ "$rep" == ${tab[0]} ]] ;then 
                clear
                factorielle $(QuestionN "Quel entier choissez vous ? [1-20] ")
                pushenter
                break
            elif [[ "$rep" == ${tab[1]} ]] ;then
                clear
                suite $(QuestionN "Quel entier choissez vous ?")
                pushenter
                break
            elif [[ "$rep" == ${tab[2]} ]] ;then
                clear
                pyramide $(QuestionN "Quel entier choissez vous ?")
                pushenter
                break
            elif [[ "$rep" == ${tab[3]} ]] ;then
                clear
                echo "Vous avez decider de quitter $0 "
                exit 0
            fi
        done
done