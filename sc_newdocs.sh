#!/bin/bash

# this script copies the episode master list to csv
# then if a recording date is four days away or less
# create copies of the plot and production notes
# for each film within the time span

path=/home/verbal/Nextcloud/shittycinema
eml=${path}/EpisodeMasterList.xlsx
emlc=${path}/EpisodeMasterList.csv
sdir=${path}/Season6
pn=${path}/zPN.docx
plot=${path}/zPlot.docx
curdate=$(date +%m/%d/%Y)

#convert eml to tab delimited file 9(ASCII tab),0(no quotes around strings; 34 double or 39 single)
unoconv -f csv -e FilterOptions="9,0,9,2" $eml 

while IFS=$'\t' read -r episode film month badperson description releasedate recordeddate editr guest notes
do
	#[[ $(date +%m/%d/%Y -d "+4 days") > $(date +%m/%d/%Y -d "$recordeddate") ]] && cp $pn ${sdir}/${film}" PN.docx" ; cp $plot ${sdir}/${film}" Plot.docx" ; list+=("$film")
	#[[ $(date +%m/%d/%Y -d "+4 days") > $(date +%m/%d/%Y -d "$recordeddate") && $recordeddate > $curdate ]] && [[ ! -f ${sdir}/${film}" PN.docx" ]] && cp $pn ${sdir}/${film}" PN.docx" && [[ ! -f ${sdir}/${film}" Plot.docx" ]] && cp $plot ${sdir}/${film}" Plot.docx" && list+=("$film")
	[[ $(date +"%s" -d +"4 days") ge $(date --date='$recordeddate' +"%s") ]] && echo "$film"
done < <(tail -n +2 $emlc)

rm $emlc

[[ ${#list[@]} -ne 0 ]] && for i in ${list[@]}
do
	echo "Created production notes and plot documents for $i"
done
