#!/bin/bash

# This script will go through the year and month directories to gather
# the contents of all the meeting minutes. These will be built together
# into a minutes.tex file which will then be compiled with pdflatex.
# Optionally, the script will open the file using the system's default
# PDF viewer.

FIRSTYEAR=2012
MONTHS=( 1 2 3 4 5 6 7 8 9 10 11 12 )
MINUTES='minutes'

CONTENT="content.tex"
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


# getMonthName: int -> string
# given an integer that corresponds to a month in the year, this function
# will return the corresponding month name. For instance, if the argument
# given is 1, then 'January' is returned.
currMonthName='January'
function getMonthName {
    if [ $1 -eq 1 ]
    then
        currMonthName='January'

    elif [ $1 -eq 2 ]
    then
        currMonthName='February'

    elif [ $1 -eq 3 ]
    then
        currMonthName='March'

    elif [ $1 -eq 4 ]
    then
        currMonthName='April'

    elif [ $1 -eq 5 ]
    then
        currMonthName='May'

    elif [ $1 -eq 6 ]
    then
        currMonthName='June'

    elif [ $1 -eq 7 ]
    then
        currMonthName='July'

    elif [ $1 -eq 8 ]
    then
        currMonthName='August'

    elif [ $1 -eq 9 ]
    then
        currMonthName='September'

    elif [ $1 -eq 10 ]
    then
        currMonthName='October'

    elif [ $1 -eq 11 ]
    then
        currMonthName='November'

    elif [ $1 -eq 12 ]
    then
        currMonthName='December'

    else
        currMonthName='January'

    fi
}

years=()
texfiles=()


# addMonth: int
# given an int that represents the number value of the month of interest,
# this function will insert the appropriate content into the content tex file
# and then reset the texfiles array to nothing.
function addMonth {

    getMonthName $1

    echo "\\section{$currMonthName 2012}" >> $CONTENT

    for item in ${texfiles[@]}
    do

        echo "\\input{$item}" >> $CONTENT

    done

    echo "" >> $CONTENT

    texfiles=()
}

# createTempFile: none
# this function will create a tmp file for the existing minutes.tex, so that
# a backup is stored somewhere.
function createTempFile {
    if [ -f "$FNAME" ]
    then
    
        cp $FNAME .minutesmaker/$FNAME.tmp
    
    fi
}

# createTempContext: none
# this function will create a tmp file for the existing content.tex so that
# a backup is stored somewhere.
function createTempContent {
    if [ -f "$CONTENT" ]
    then
        cp $CONTENT .minutesmaker/$CONTENT.tmp
        rm $CONTENT
    fi
}

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

# create the beginning of the minutes.tex file
#cp .minutesmaker/top.tex $FNAME

# create a temp content file and then delete the existing one to prepare
# for the new one to be created.
createTempContent

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

                    # this is where we will add a month to tex file
                    addMonth $month

                fi

            fi

        done

    done

done

#echo "\\end{document}" >> $FNAME

pdflatex $FNAME
open $PDFNAME

exit 0

