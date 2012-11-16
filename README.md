MinutesMaker
============

This is a quick and dirty script for generating meeting minutes PDF documents
from a distributed set of LaTeX files in a specific directory structure. The
idea is that each of the tex files contain agenda/minutes content for
particular meetings.

The minutes will be organized in directories first by year and then by month.
The minutes will, by default, be organized with most recent minutes first.

Usage
-----

    ./MinutesMaker.bash

or

    python MinutesMaker.py

To Dos
------
- Try rewriting MinutesMaker.bash in python (MinutesMaker.py)
- Add another approach that extracts dates from the header of the document to
    determine the documents date and then inject them into the minutes.tex file
    based on that ordering. All tex documents can simply go into one directory
    and then there is no need for the user to maintain the directory structure
    and organization of these documents. A special table of documents and the
    dates they are associated with can be maintained and updated as files are
    modified and added. This table will then be referenced when generating the
    minutes.tex document.
- Build minutes.tex to be a full tex document with an \input{content} and then
    have an additional content.tex file that is injected with all of the
    \input commands for the specific minutes that should be included.
- Need to organize the order in which months are injected into the tex file
- Support for multiple months has been added, but what about multiple years
- Be able to specify year and/or month to generate minutes for
- Be able to specify a custom directory structure
- More robustness to the process

