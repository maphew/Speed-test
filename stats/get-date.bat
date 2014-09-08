@echo off
:: Parse date from xxcopy logfile. Assumes all lines beginning
:: "XXCOPY" (case sensitive) follow the format:
:: 
::    XXCOPY64 Pro Edition   ver 3.11.4   2013-01-16 17:04:03   Windows Ver 6.1.7601 Service Pack 1
:: 
::  beginnning to "ver" == xxcopy edition name 
::  "Windows" to end    == Windows version
::  middle is space delimited == xxcopy_version, date, time
::
setlocal EnableDelayedExpansion

set line=XXCOPY64 Pro Edition   ver 3.11.4   2013-01-16 17:04:03   Windows Ver 6.1.7601 Service Pack 1

if "%line:~0,6%" equ "XXCOPY" call :parse_date %line%

goto :eof

:: --------- Sub-routines -------------

:parse_date
   :: Adapted from http://ss64.com/nt/syntax-replace.html
   echo in: %*
   SET _test=%*

   :: To delete everything after the string 'Windows'  
   :: first delete 'Windows' and everything before it
   SET _endbit=%line:*Windows=%

   :: then we include 'Windows' again to remove it from final result
   set _endbit=Windows%_endbit%

   rem echo We dont want: [%_endbit%]

   ::Now remove this from the original string
   CALL SET _result=%%_test:%_endbit%=%%
   rem echo %_result%

   REM extract only date & time
   set _date=%_result:*ver=%
   set _date

    for /f "tokens=1-3 delims= " %%A in ("%_date%") do (
        echo %%A
        echo %%B
        echo %%C
        )
