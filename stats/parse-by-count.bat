@echo off
:: Assume number of times field names occur in each log is stable and
:: reliable. Search log for each occurrence of field name, redirect to
:: temp file, then combine all together into single csv at end.
::
:: A zero line output file means that field was not found in the log.
::

if [%1]==[] goto :Usage
if not exist "%1" goto :Usage

set logfile=%1
if not exist scratch mkdir scratch

for /f "delims=;" %%a in (field_names.txt) do call :Get_Field_Values "%%a"

goto :eof

:: ------------- Sub-routines ----------------

:Get_Field_Values
    findstr /C:%1 %logfile% > scratch\%1.txt
    goto :eof

:Usage
    echo.
    echo.	Usage:	%~n0 [logfile]
    echo.
    goto :eof
