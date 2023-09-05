#!/bin/bash
eml=/home/verbal/Nextcloud/shittycinema/RAW/EpisodeMasterList.csv
sdir=/home/verbal/Nextcloud/shittycinema/Season6
oldpn=$(ls -t $sdir | grep PN | head -n1)
oldplot=$(ls -t $sdir | grep Plot | head -n1)


while IFS="," read -r episode film month badperson description releasedate recordeddate editr guest notes
do
	[[ $(date +%d%m%Y -d "+8 days") > $(date +%d%m%Y -d "$recordeddate") ]] && cp ${sdir}\$(ls -t $sdir | grep PN | head -n1) ${sdir}\${film}

done < <(tail -n +2 $eml)
