#!/bin/bash

#automatically record a video using Guvcview
#Params: the device we are using, resolution, file format, FPS,
#filename, video duration, exiting guvcview after recording
guvcview -d /dev/video0 -x 640x480 -f MJPG -F 5/1 -j recording -y 60 -e

#counts the number of recordings in the shared folder
filesInSharedFolder=0
for filename in /media/sf_SecurityCamera/recording-*.mkv
do
     #checking if FILE exist
     FILE=/media/sf_SecurityCamera/recording-1.mkv
     if test -f "$FILE"; then
          filesInSharedFolder=$((filesInSharedFolder + 1))
     else
          break
     fi
done

#counts the number of recordings in the home folder
filesInHomeFolder=0
for filename in /home/victor/recording-*.mkv
do
     #checking if FILE1 exist
     FILE1=/home/victor/recording-1.mkv
     if test -f "$FILE1"; then
          filesInHomeFolder=$((filesInHomeFolder + 1))
     else
          break
     fi
done

#the value for the new recording
sharedFolderNextIndex=$((filesInSharedFolder + 1))





#when there are more recordings in home folder:
#we move from home to shared folder, then update the name.
if [ $filesInHomeFolder -gt $sharedFolderNextIndex ]
then
     sudo mv /home/victor/recording-${filesInHomeFolder}.mkv /media/sf_SecurityCamera
sudo mv /media/sf_SecurityCamera/recording-${filesInHomeFolder}.mkv /media/sf_SecurityCamera/recording-${sharedFolderNextIndex}.mkv

#when the recordings between home and shared folder are equivalent:
#we move from home to shared folder
elif [ $filesInHomeFolder -eq $sharedFolderNextIndex ]
then
     sudo mv /home/victor/recording-${filesInHomeFolder}.mkv /media/sf_SecurityCamera

#when there are more recordings in shared folder:
#we update the name, then move from home to shared folder
else
     sudo mv /home/victor/recording-${filesInHomeFolder}.mkv /home/victor/recording-${sharedFolderNextIndex}.mkv
     sudo mv /home/victor/recording-${sharedFolderNextIndex}.mkv /media/sf_SecurtiyCamera
fi
