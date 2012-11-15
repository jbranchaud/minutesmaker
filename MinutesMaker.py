#!/usr/bin/python

"""
MinutesMaker.py

This is essentially the MinutesMaker.bash script ported to python.
"""

import os
import sys
import dateutil
import path

FIRSTYEAR = 2012
MONTHS = [1,2,3,4,5,6,7,8,9,10,11,12]
MINUTES='minutes'

CONTENT='content.tex'
FILENAME='minutes.tex'
PDFNAME='minutes.pdf'


"""
findYearDirectories: none -> string[]
this function will look through the directories in the current directory to
find those that are years greater than or equal to FIRSTYEAR (which is, by
default, 2012). Each directory that qualifies will be added to a list of
directory names which will be returned.
"""
def findYearDirectories():
    # get the current directory path
    curr_dir = path.path.getcwd()

    # build a list of directories that may be years
    years = []
    for directory in curr_dir.dirs():
        dir_basename = directory.basename()
        # if it is a digit, then it is a possible year
        if dir_basename.__str__().isdigit():
            curr_year = dir_basename.__str__()
            if int(curr_year) >= FIRSTYEAR:
                years.append(directory)

    # sort and return the resulting list, which could be empty
    years.sort()
    return years


"""
findMonthDirectories: path.path -> string[]
given the path.path of a year directory, this function will go through the
directories of that year to find the month directories which are integer
values ranging from 1 to 12. Each directory that qualifies will be added to
a list of directory names which will be returned.
"""
def findMonthDirectories(year):
    months = []

    # go through the directories in the year directory
    for directory in year.dirs():
        dir_basename = directory.basename()
        # if it is a digit, then it is a possible month
        if dir_basename.__str__().isdigit():
            curr_month = dir_basename.__str__()
            # FIXME: makes more sense to check 1-12 bounds
            if MONTHS.__contains__(int(curr_month)):
               months.append(directory)

    # sort and return the resulting list, which could be empty
    months.sort()
    return months


"""
getMinutesDirectory: path.path -> path.path
given the path.path of a month directory, this function will check the contents
of that directory for a directory that matches the global variable MINUTES. If
there is a match, this path.path object will be return, otherwise None will be
returned.
"""
def getMinutesDirectory(month):
    # go through the directories in the month directory
    for directory in month.dirs():
        if directory.basename().__str__() == MINUTES:
            return directory

    return None


"""
getMinutesFiles: path.path -> path.path[]
given a path.path for a minutes directory, this function will collect a list
of all of the .tex files in the given minutes directory and then return that
as a list of path.path objects.
"""
def getMinutesFiles(minutes_directory):
    minutes_files = minutes_directory.files('*.tex')
    minutes_files.sort()
    return minutes_files


"""
buildContentFile: none -> void
build a list in descending order of all of the tex files in the available
directory structure and then insert each of these tex files into the
CONTENT file.
"""
def buildContentFile():
    content_file = open(CONTENT, 'w')

    # find and go through all the years in descending order
    year_dirs = findYearDirectories()
    year_dirs.reverse()
    for year_dir in year_dirs:
        year = year_dir.name.__str__()
        # find and go through all the months in descending order
        month_dirs = findMonthDirectories(year_dir)
        month_dirs.reverse()
        for month_dir in month_dirs:
            month = month_dir.name.__str__()
            minutes_files = getMinutesFiles(getMinutesDirectory(month_dir))
            minutes_files.reverse()
            # write \section{getMonthName(int(month)) + " " + year}
            month_name = getMonthName(int(month))
            content_file.write("\\section{" + month_name + " " + year + "}\n\n")
            # adding year/month/minutes[x] to the content file
            for minutes_file in minutes_files:
                minutes = minutes_file.namebase.__str__()
                filepath = year + "/" + month + "/" + MINUTES + "/" + minutes
                inputline = "\\input{" + filepath + "}\n"
                content_file.write(inputline)
            content_file.write("\n")

    content_file.close()


"""
getMonthName: int -> string
given an integer (between 1 through 12), this function will determine the
month name associated with that integer and return that.
FIXME: Either fully enumerate this method or figure out a clever way to
do it with the dateutil import.
"""
def getMonthName(month):
    return 'January'


buildContentFile()
os.system('pdflatex ' + FILENAME)
os.system('open ' + PDFNAME)

