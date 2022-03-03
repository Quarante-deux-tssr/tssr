#!/usr/bin/env bash

# Exercice 3 :
# Vous allez écrire un script prenant un paramètre qui sera un nom de répertoire. 
# Dans ce répertoire, ce script créera un fichier index.html qui affichera les images jpg du 
# répertoire.

head_html='<HTML><HEAD><TITLE>IMAGES JPG</TITLE></HEAD><BODY>'
footer_html='</BODY></HTML>'

if [[ -d ${1} ]];
then
    t=($(ls ${1}/*.jpg))
    img_html=""
    for a in ${t[@]}; do
        img_html+="<IMG SRC='$a'><BR>"
    done
    echo $head_html$img_html$footer_html > ${1}/index.html
fi