#!/bin/bash

curdate=`date +%m/%d/%Y`
logfile=/var/log/sc_autoaudio.log
errorlog=/var/log/sc_autoaudio_errors.log
progname=$0
acct=$(/usr/bin/logname)
eml=/home/verbal/Nextcloud/shittycinema/EpisodeMasterList.xlsx
rawdir=/home/verbal/Nextcloud/shittycinema/RAW
dldir=/home/verbal/Downloads

#clean function to remove spaces and special characters
clean() {
    local a="${1//[^[:alnum:]]/}"
    echo "${a,,}"
}

#verify script is run as sudo
[[ $EUID -ne 0 ]] &&  /usr/bin/echo "You must be a root user to run this script, please run sudo sc_autoaudio.sh" && exit 1

#log script starting
echo "$acct started $progname at $(date)" | tee -a $logfile

#check if episode master list exists
[[ ! -f $eml ]] && { echo "Episode Master List not found at $eml"; exit 1; }

#convert episode master list to csv for parsing
libreoffice --headless --convert-to csv $eml --outdir $rawdir 1>>$logfile 2>>$errorlog 

#get craig filename
zipfile=$(ls $dldir | grep craig) 1>>$logfile 2>>$errorlog

#read eml
while IFS="," read -r episode film month badperson description releasedate recordeddate editr guest notes
do
        [[ $recordeddate == $curdate ]] && filmdir=${rawdir}/e${episode}-$(clean "$film")-$(clean "$month")-$(echo $editr |tr '[:lower:]' '[:upper:]') && zipsave=${filmdir}/e${episode}-$(clean "$film").zip && cont=1
done < <(tail -n +2 ${rawdir}/EpisodeMasterList.csv) 1>>$logfile 2>>$errorlog
i
#quit if there are no scheduled recordings on this date
[[ $cont != 1 ]] && { echo "There is no recording scheduled for $curdate"; exit 1; }

#create folder, unzip, archive.zip, and validate film
[[ ! -d $filmdir ]] && mkdir $filmdir && dircreate=1 || [[ "$(ls -A $filmdir)" ]] && { echo "$filmdir exists with data"; exit 1; }
unzip ${dldir}/${zipfile} -d $filmdir && mv ${dldir}/${zipfile} $zipsave

#set permissions to verbal
chown verbal:verbal ${rawdir}/EpisodeMasterList.csv & chown -R verbal:verbal $filmdir 

[[ $dircreate == 1 ]] && echo "$filmdir created."
[[ ! $(cat ${filmdir}/info.txt | grep $film) == *$film* ]] && echo "Warning! Recording name and Episode Master List are inconsistent." || echo "Recording $film matches Episode Master List."
