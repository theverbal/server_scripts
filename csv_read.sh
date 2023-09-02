#!/bin/bash

episode="999"
film="abduction2019"
month="dontgetprobed"
editor="CASEY"
rawdir=/home/verbal/Nextcloud/shittycinema/RAW
filmdir=$rawdir/e$episode-$film-$month-$editor



dldir=/home/verbal/Downloads
curdate=`date +%m/%d/%Y`

echo $curdate

while IFS="," read -r episode film month badperson description releasedate recordeddate editor guest notes
do
        
	if [[ $recordeddate == $curdate ]]
        then    
              
                editorc=$(echo $editor | tr '[:lower:]' '[:upper:]')
                filmdir=$rawdir/e$episode-$film-$month-$editor
		echo "$filmdir"
        fi
done < <(tail -n +2 /home/verbal/Nextcloud/shittycinema/RAW/EpisodeMasterList.csv)

