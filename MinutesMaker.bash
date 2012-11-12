#!/bin/bash

# This script will go through the year and month directories to gather
# the contents of all the meeting minutes. These will be built together
# into a minutes.tex file which will then be compiled with pdflatex.
# Optionally, the script will open the file using the system's default
# PDF viewer.

FIRSTYEAR=2012
MONTHS=( 1 2 3 4 5 6 7 8 9 10 11 12 )
MINUTES='minutes'

FNAME="minutes.tex"
PDFNAME="minutes.pdf"

# go through the current directory finding the directories with a name that
# is equal to and then greater than FIRSTYEAR. Within each of those
# directories, we can look for the existence of directories with names
# that match with the contents of the MONTHS array. Each of these
# directories then may contain a minutes directories which should contain
# all of the minutes tex files. These will be collected in a queue fashion
# so that when they are written to the minutes.tex file, they will appear
# in reverse chronological order so that the most relevant/recent minutes
# appear towards the top of the document.

years=()

for f in *
do

    if [[ -d "$f" && $f -ge $FIRSTYEAR ]]
    then
        #echo $f
        # add this directory
        years=("${years[@]}" "$f")
    fi

done

if [[ ${#years[@]} -le 0 ]]
then

    echo "There are no years here."
    exit 0

fi

texfiles=()

# Now I need to go through the list of months in each year
for year in $years
do

    for f in $year/*
    do

        # if the file isn't a directory, then continue to next
        if [ ! -d "$f" ]
        then
            continue
        fi

        # check against the set of months to verify that dir is a month
        for month in ${MONTHS[@]}
        do

            basedir=${f##*/}
            #echo $basedir

            #echo "Checking $month against $basedir."

            if [ "$month" -eq "$basedir" ]
            then

                #echo $f

                # verify that the minutes directory exists
                if [ -d "$f/$MINUTES" ]
                then

                    for texfile in $f/$MINUTES/*
                    do
            
                        #echo "- $texfile"
                        filename="${texfile%.*}"
                        #echo "- $filename"
                        texfiles=($filename ${texfiles[@]})

                    done

                fi

            fi

        done

    done

done

if [ -f "$FNAME" ]
then

    cp $FNAME .minutesmaker/$FNAME.tmp

fi

cp .minutesmaker/top.tex $FNAME

echo "\\section{November 2012}" >> $FNAME

for item in ${texfiles[@]}
do

    echo "\\input{$item}" >> $FNAME

done

echo "" >> $FNAME
echo "\\end{document}" >> $FNAME

pdflatex $FNAME
open $PDFNAME

exit 0

