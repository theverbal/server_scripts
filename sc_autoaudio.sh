#!/bin/bash

curdate=`date +%m/%d/%Y`
logfile=/var/log/sc_autoaudio.log
errorlog=/var/log/sc_autoaudio_errors.log
progname=$0
acct=$(/usr/bin/logname)
eml=/home/verbal/Nextcloud/shittycinema/EpisodeMasterList.xlsx

#directories
rawdir=/home/verbal/Nextcloud/shittycinema/RAW
dldir=/home/verbal/Downloads

#clean function to remove spaces and special characters
clean() {
    local a="${1//[^[:alnum:]]/}"
    echo "${a,,}"
}

#verify script is run as sudo
if [[ $EUID -ne 0 ]]
	then /usr/bin/echo "You must be a root user to run this script, please run sudo sc_autoaudio.sh"
	exit 1
fi

#log script starting
echo "$acct started $progname at $(date)" | tee -a $logfile

#check if episode master list exists
if [[ ! -f $eml ]]
	then echo "Episode Master List not found at $eml" 
	exit 1
fi

#convert episode master list to csv for parsing
libreoffice --headless --convert-to csv $eml --outdir $rawdir 1>>$logfile 2>>$errorlog 

#get craig filename
zipfile=$(ls $dldir | grep craig) 1>>$logfile 2>>$errorlog

# read eml and process craig*.zip
while IFS="," read -r episode film month badperson description releasedate recordeddate editor guest notes
do
        if [[ $recordeddate == $curdate ]] 
	then 	filmc=$(clean "$film")
		monthc=$(clean "$month")
		editorc=$(echo $editor | tr '[:lower:]' '[:upper:]')
		filmdir=$rawdir/e$episode-$filmc-$monthc-$editorc
		[[ ! -d $filmdir ]] && mkdir $filmdir 1>>$logfile 2>>$errorlog
		unzip $dldir/$zipfile -d $filmdir 1>>$logfile 2>>$errorlog
	        mv $dldir/$zipfile $filmdir/e$episode-$filmc.zip 1>>$logfile 2>>$errorlog
	        validation=$(cat $filmdir/info.txt | grep $film) 1>>$logfile 2>>$errorlog
		[[ ! $validation == *$film* ]] && validationfail=1 1>>$logfile 2>>$errorlog
	fi
done < <(tail -n +2 $rawdir/EpisodeMasterList.csv) 1>>$logfile 2>>$errorlog

#set permissions to verbal
chown verbal:verbal $rawdir/EpisodeMasterList.csv
chown -R verbal:verbal $filmdir 

[[ $validationfail == 1 ]] && echo "Warning! Recording name and Episode Master List are inconsistent." 
