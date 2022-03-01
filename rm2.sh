#!/usr/bin/env bash

##################################################################
##################################################################
##
##             EXERCICE
##
## Vous allez écrire une commande rm2 qui remplacera la commande rm. 
## 1 - rm2 déplace les fichiers passés en paramètre dans une poubelle située à la racine du compte de l'utilisateur. 
## Il faut créer cette poubelle si elle n'existe pas. 
## Si un fichier n'existe pas, le signaler à l'utilisateur. 
## Si un fichier existe déjà dans la corbeille, le renommer avec l'extension .bak. 
## 2 – Il faut implémenter les options suivantes : 
## -v = vide la corbeille. 
## -i = mode interactif : demande confirmation avant déplacement. 
## -r = rm2 fonctionne comme rm.
## Vous devrez créer un répertoire dans votre espace personnel nommé scripts et il faut que vous puissiez éxécuter se script depuis n'importe quel endroit de cette manière : rm2.sh ou rm2
##
##################################################################
##################################################################

## VARIABLE 

## Chemin de la corbeille
TrashName=~/.fake

## Extension Backup
ExtBackup="bak"

## Fonction initrm2 - Fonction d'initialisation du script :
##  - Creation du dossier corbeille, si ce dernier n'existe pas.
##  - Ajout d'un alias au script.
##
function initrm2(){

    ## Si le dossier corbeille n'existe pas, nous le créons.
    if [ ! -d ${1} ];
    then
        mkdir ${1}
    fi
    
    ## Si le dossier utilisateur n'est pas dans la variable $PATH
    testpath=$(echo $PATH | grep "$(pwd):")
    if [[ -z $testpath ]];
    then
        echo "PATH=\"$(pwd):PATH\"" >> ~/.profile
        sed -r 's/:PATH/:$PATH/g' ~/.profile > ~/.profile2
        rm ~/.profile
        mv ~/.profile2 ~/.profile
        exec bash
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
## Utilisation : inter <dossier corbeille> <extension backup> <fichier a supprimer>
function inter(){

    ## définition des variables local
    local trash=${1}
    local bakcup=${2}
    local rep=
    local i=
    local tabfil=()
    shift; shift

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
                    ## Verifion si une sauvegarde existe dans la corbeille.
                    if [ -e $trash/$filetab.$bakcup ];
                    then
                        ## Si le fichier sauvegarde existe dans la corbeille, nous le supprimons
                        rm -f $trash/$filetab.$bakcup
                        echo "Fichier $trash/$filetab.$bakcup supprimer"
                    fi
                    ## Si le fichier existe dans la corbeille, création d'un fichier de sauvegarde
                    mv $trash/$filetab $trash/$filetab.$bakcup
                    echo "$trash/$filetab.$bakcup créer"
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
    echo "-v : vide la corbeille ${1}"
    echo "-i : Demande confirmation avant de mettre un fichier dans la corbeille ${1}"
    echo "-r : identique à rm"
    echo "${0} -v"
    echo "${0} -i <NOM DU FICHIER>"
    echo "${0} -r <NOM DU FICHIER>"
}

# Arguments
while getopts ":i:r:" option; do
    case "${option}" in
        ## Le mode interactive
        i)
            initrm2 $TrashName
            shift
            i=${@}
            inter $TrashName $ExtBackup $i
            exit 0
            ;;
        ## Le mode rm
        r)
            initrm2 $TrashName
            shift
            r=${@}
            likerm $r
            exit 0
            ;;
        *)
            ## Le mode vider la corbeille
            if [[ ${1} = "-v" ]]; then
                initrm2 $TrashName
                cleantrash $TrashName
                exit 0
            fi
            ## Si nous n'avons pas compris la demande de l'utilisateur
            initrm2 $TrashName
            helpuser $TrashName
            exit 0
            ;;
    esac
done
