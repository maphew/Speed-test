2008-Oct-08, 2010-Jan-07 Matt.wilkie@gov.yk.ca

Speed Test: copy 1gb of data from/to various locations and capture statistics in order measure performance.

Developed and tested on 64bit Windows XP SP2, with command extensions enabled.
Two additional programs are used: xxcopy (required) and grep (optional, used for reporting).

This test suite may be freely modified and shared. Please don't use the data (.\source\*) for anything other than benchmarking, there are much improved data for same available for free from htp://geobase.ca/.


----- Setup

1. Install xxcopy: open a command shell, run XXCOPY /INSTALL (in .\bin) and answer the prompts.
2. If the test suite is on a slow device you don't want to test, like a usb stick or disc, copy the tree somewhere else (xxcopy /clone %path-to-usb%\speed-test x:\speed-test).

----- Using speed-test.bat

1. Edit speed-test.bat and change "dest" and "dType" variables.
2. Open a command shell and run speed-test.bat
3. Repeat #2 at least two additional times to get an average

The 'stats' variable needs to point to a writeable location, default is \path\to\speed-test.bat\stats and are cumulative. 

There are existing statistics from my own machine, GEOMATT, for reference.

----- Results

In the stats folder there is a spreadsheet tallying the results of the tests in my local environment -- not favourable at all for the Drobo :( 
