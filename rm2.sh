#!/usr/bin/env bash

## VARIABLE 

## Chemin de la corbeille
TrashName=~/.fake

## Nom de l'alias
AliasRM='rm2'

##################################################################
##################################################################


## Fonction initrm2 - Fonction d'initialisation du script :
##  - Creation du dossier corbeille, si ce dernier n'existe pas.
##  - Ajout d'un alias au script.
##
function initrm2(){

    ## Si le dossier corbeille n'existe pas, nous le créons.
    if [ ! -d ${2} ];
    then
        mkdir ${2}
    fi

    ## Si ~/.bash_aliases n'existe pas, création puis ajout de l'alias ${1} vers le script
    if ! [ -e ~/.bash_aliases ];
    then
        echo "alias ${1}='$0'" >> ~/.bash_aliases
        echo "Reconnectez vous au terminal pour la prise en compte de l'alias ${1}"
    fi

    ## Si ${1} n'existe pas dans ~/.bash_aliases, ajout de l'alias ${1} vers le script
    testalias=$(cat ~/.bash_aliases | grep ${1})
    if [[ -z $testalias ]];
    then
        echo "alias ${1}='$0'" >> ~/.bash_aliases
        echo "Reconnectez vous au terminal pour la prise en compte de l'alias ${1}"
    fi

}

## Fonction Question avec réponse Oui/Non 
## Utilisation : QuestionYN "Question à poser ? "
## Retour : 0 si la réponse est oui
##          1 si la réponse est non
function QuestionYN () {
    local reset=0
    while [ ${reset} = 0 ]; do
        read -p "${1} [Oui/Non] : " reponse 
        if [[ "${reponse}" =~ ^[oO]$ || "${reponse}" =~ ^[oO][uU][iI]$ ]]; then
            echo 0
            reset=1
        elif [[ ${reponse} =~ ^[nN]$ || "${reponse}" =~ ^[nN][oN][nN]$ ]]; then 
            echo 1
            reset=1
        else
            reset=0
        fi   
    done
}


## Fonction cleantrash - Vider la corbeille
## Utilisation cleantrash <Dossier corbeille>
function cleantrash(){
    rm -rf ${1}/*
    echo "La corbeille ${1} est vide"
}

## Function inter - Fonctionnalité interractive : demande une confirmation de suppression et fais une backup du fichier dans la corbeille.
## Utilisation : inter <dossier corbeille> <fichier a supprimer>
function inter(){

    ## définition des variables local
    local trash=${1}
    local rep=
    local i=
    shift

    ## Pour chaque arguments
    for i in ${@}; 
    do
        ## Verifions que le fichier existe.
        if [ -e $i ];
        then
            
            ## Demande confirmation à l'utilisateur de mettre le fichier à la corbeille.
            rep=$(QuestionYN "Voulez vous mettre à la corbeille le fichier $i ?")
            IFS2=$IFS
            IFS='/'
            tabfil=($i)
            IFS=$IFS2

            ## Récupérons uniquement le nom du fichier.
            ## Exemple : si l'argument est /home/$USER/test.dat nous récupérons uniquement test.dat
            if [[ ${#tabfil[@]} -gt 1 ]];
            then
                filetab=${tabfil[((${#tabfil[@]} - 1))]}
            else
                filetab=$i
            fi

            ## Si nous avons répondu oui à la confirmation.
            if [[ $rep = 0 ]];
            then
                ## Verifions si le fichier existe dans la corbeille. 
                if [ -e $trash/$filetab ];
                then
                    ## Verifion si une sauvegarde (*.bak) existe dans la corbeille.
                    if [ -e $trash/$filetab.bak ];
                    then
                        ## Si le fichier sauvegarde (*.bak) existe dans la corbeille, nous le supprimons
                        rm -f $trash/$filetab.bak
                        echo "Fichier $trash/$filetab.bak supprimer"
                    fi
                    ## Si le fichier existe dans la corbeille, création d'un fichier de sauvegarde(*.bak) 
                    mv $trash/$filetab $trash/$filetab.bak
                    echo "$trash/$filetab.bak créer"
                fi
                ## Déplaçons le fichier vers la corbeille.
                mv $i $trash/$filetab
                echo "$filetab mis dans la corbeille"
            fi
        ## Si le fichier n'existe pas, nous informons l'utilisateur.
        else
            echo "Le fichier $i n'existe pas"
        fi
    done
}

## Fonction likerm - Même fonction que rm
function likerm(){

    local i=
    for i in ${@};
    do
        if [ -e $i ]; then
            rm -rf $i
            echo "$i supprimer"
        else
            echo "$i n'existe pas"
        fi
    done
}

## Message d'erreur avec les arguments.
function helpuser(){
    echo "Veuillez bien ecrire la commande"
    echo "-v : vide la corbeille ${2}"
    echo "-i : Demande confirmation avant de mettre un fichier dans la corbeille ${2}"
    echo "-r : identique à rm"
    echo "${1} -v"
    echo "${1} -i <NOM DU FICHIER>"
    echo "${1} -r <NOM DU FICHIER>"
}

# Arguments
while getopts ":i:r:" option; do
    case "${option}" in
        ## Le mode interactive
        i)
            initrm2 $AliasRM $TrashName
            i=${OPTARG}
            inter $TrashName $i
            exit 0
            ;;
        ## Le mode rm
        r)
            initrm2 $AliasRM $TrashName
            r=${OPTARG}
            likerm $r
            exit 0
            ;;
        *)
            ## Le mode vider la corbeille
            if [[ ${1} = "-v" ]]; then
                initrm2 $AliasRM $TrashName
                cleantrash $TrashName
                exit 0
            fi
            ## Si nous n'avons pas compris la demande de l'utilisateur
            initrm2 $AliasRM $TrashName
            helpuser $AliasRM $TrashName
            exit 0
            ;;
    esac
done