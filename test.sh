#!/bin/bash

clean() {
    local a="${1//[^[:alnum:]]/}"
    echo "${a,,}"
}

episode="999"
film="Abduction (2019)"
month="Don't Get Probed"
editr="Casey"
dldir=/home/verbal/Downloads
rawdir=/home/verbal/Nextcloud/shittycinema/RAW

filmdir=${rawdir}/e${episode}-$(clean "$film")-$(clean "$month")-$(echo $editr |tr '[:lower:]' '[:upper:]')

#echo $filmdir

zipfile=( $(ls $dldir | grep craig) )

echo $zipfile
echo ${zipfile[1]}
echo ${zipfile[2]}

echo ${#zipfile[@]}


[[ ${#zipfile[@]} > 0 ]] && [[ ${zipfile[@]} == 1]]  
