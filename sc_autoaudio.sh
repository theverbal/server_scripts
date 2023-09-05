#!/bin/bash

logfile=/var/log/sc_automation.log
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
[[ $EUID -ne 0 ]] && { echo "You must be a root user to run this script, please run sudo sc_autoaudio.sh" ; exit 1}

#log script starting
echo "$(date) $acct started $progname" >> $logfile

#check if episode master list exists
[[ ! -f $eml ]] && { echo "Episode Master List not found at $eml"; echo "$(date) Episode Master List not found at $eml" >> $logfile; exit 1 }

#convert episode master list to csv for parsing
libreoffice --headless --convert-to csv $eml --outdir $rawdir &>> $logfile 

#get craig filename
zipfile=$(ls $dldir | grep craig) &>> $logfile

#read eml
while IFS="," read -r episode film month badperson description releasedate recordeddate editr guest notes
do
	[[ $recordeddate == $(date +%d/%m/%Y) ]] && filmdir=${rawdir}/e${episode}-$(clean "$film")-$(clean "$month")-$(echo $editr |tr '[:lower:]' '[:upper:]') && zipsave=${filmdir}/e${episode}-$(clean "$film").zip && cont=1
done < <(tail -n +2 ${rawdir}/EpisodeMasterList.csv) &>> $logfile

#quit if there are no scheduled recordings on this date
[[ $cont != 1 ]] && { echo "There is no recording scheduled for $(date +%d/%m/%Y)";  echo "$(date) There is no recording scheduled for $(date +%d/%m/%Y)" >> $logfile; exit 1 }

#create folder, unzip, archive.zip, and validate film
[[ ! -d $filmdir ]] && mkdir $filmdir || [[ "$(ls -A $filmdir)" ]] && { echo "$filmdir exists with data"; echo "$(date) $filmdir exists with data" >> $logfile; exit 1 }
unzip ${dldir}/${zipfile} -d $filmdir &>> $logfile && mv ${dldir}/${zipfile} $zipsave &>> $logfile 

#set permissions to verbal
chown verbal:verbal ${rawdir}/EpisodeMasterList.csv ; chown -R verbal:verbal $filmdir 

[[ ! $(cat ${filmdir}/info.txt | grep $film) == *$film* ]] && echo "Warning! Recording name and Episode Master List are inconsistent." ; echo "$(date) Warning! Recording name and Episode Master List are inconsistent." >> $logfile || echo "Recording $film matches Episode Master List."
