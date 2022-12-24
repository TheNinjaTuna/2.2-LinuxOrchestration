#!/bin/bash

if [ $# -lt 2 ]; then
  echo "ERROR: not enough parameters, the script should be called in the following way: "
  echo "   './sortscript.sh [week/month] [directory to sort]' "
  exit 1
fi  

if [ $1 = "week" ] || [ $1 = "Week" ] || [ $1 = "month" ] || [ $1 = "Month" ]; then
  echo ""
else
  echo "ERROR: Invalid first parameter, make sure to specify week or month like this:" 
  echo "   './sortscript.sh [week/month] [directory to sort]'"
  exit 1
fi

if [ ! -d "$2" ]; then
  echo "ERROR: The provided directory is invalid, please make sure to provide a valid directory"
  echo "          as your second parameter."
  exit 1
fi

if ls $2/*.{jpg,png} > /dev/null ; then
  echo " "
else
  echo "ERROR: No photo files found in target directory!"
  exit 1
fi

if [ $1 = "week" ] || [ $1 = "Week" ]; then
 dirtocreate=$(date +"%d-%b-%y_%T")
 echo "-- STARTING SCRIPT - MODE: $1 - DIR: $2 --"
 echo " "
 if mkdir -p sortedpics/"$dirtocreate"; then
   for f in $2/*.{png,jpg}
    do
     name="$(basename "$f")"
     md5original=($(md5sum "$f"))
     echo "PROCEEDING WITH FILE: $name"
     date=$(date -r "$f" +"Week%U_%Y")
     dirtocreate2="sortedpics/"$dirtocreate"/"$date
     mkdir -p $dirtocreate2
     cp "$f" "$dirtocreate2"
     md5new=($(md5sum "$dirtocreate2"/"$name"))
     if [[ ! $md5original = $md5new ]]; then
       echo "WARNING: MD5SUM DOES NOT MATCH! THE ORIGINAL FILE WILL NOT BE DELETED."
     else
       echo "SUCCESS! THE FILE HAS BEEN MOVED TO IT'S NEW DIRECTORY"
       rm "$f"
     fi
     echo " "
    done
 else 
   echo "FAILED TO CREATE DIRECTORY, EXITING SCRIPT! (make sure you have write access here!)"
   exit 1
 fi
fi

if [ $1 = "month" ] || [ $1 = "Month" ]; then
 dirtocreate=$(date +"%d-%b-%y_%T")
 echo "-- STARTING SCRIPT - YOU WILL FIND YOUR SORTED PICTURES IN THE '/sortedpics/[date_time]' FOLDER --"
 echo " "
 if mkdir -p sortedpics/"$dirtocreate"; then
   for f in $2/*.{png,jpg}
    do
     name="$(basename "$f")"
     md5original=($(md5sum "$f"))
     echo "PROCEEDING WITH FILE: $name"
     date=$(date -r "$f" +"%B_%Y")
     dirtocreate2="sortedpics/"$dirtocreate"/"$date
     mkdir -p $dirtocreate2
     cp "$f" "$dirtocreate2"
     md5new=($(md5sum "$dirtocreate2"/"$name"))
     if [[ ! $md5original = $md5new ]]; then
       echo "WARNING: MD5SUM DOES NOT MATCH! THE ORIGINAL FILE WILL NOT BE DELETED."
     else
       echo "SUCCESS! THE FILE HAS BEEN MOVED TO IT'S NEW DIRECTORY"
       rm "$f"
     fi
     echo " "
    done
 else 
   echo "FAILED TO CREATE DIRECTORY, EXITING SCRIPT! (make sure you have write access here!)"
   exit 1
 fi
fi

echo "-- SCRIPT FINISHED :) - YOU WILL FIND YOUR SORTED PUCTURES IN '/sortedpics/[date_time]' --"
echo " "
