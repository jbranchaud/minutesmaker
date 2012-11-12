MinutesMaker
============

This is a quick and dirty script for generating meeting minutes PDF documents
from a distributed set of LaTeX files in a specific directory structure. The
idea is that each of the tex files contain agenda/minutes content for
particular meetings.

The minutes will be organized in directories first by year and then by month.
The minutes will, by default, be organized with most recent minutes first.

To Dos
------
- Need to organize the order in which months are injected into the tex file
- Support for multiple months has been added, but what about multiple years
- Be able to specify year and/or month to generate minutes for
- Be able to specify a custom directory structure
- More robustness to the process

