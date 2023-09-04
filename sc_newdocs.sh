#!/bin/bash

sdir=/home/verbal/Nextcloud/shittycinema/Season6
oldpn=$(ls -t $sdir | grep PN | head -n1)
oldplot=$(ls -t $sdir | grep Plot | head -n1)

cp ${sdir}\$(ls -t $sdir | grep PN | head -n1) ${sdir}\${film}
