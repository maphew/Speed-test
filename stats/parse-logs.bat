@echo off
:: Original by Garry Deane, xxcopy mailing list, 2014-Aug-15

setlocal enabledelayedexpansion

:: change the following to suit your own log file name
set log=d:\xxcopy.log

set field_titles=log file date/time

for %%a in (%log%) do set field_values=%%~ta

set no=0

set cmd=grep -A100 "Source base directory" %log%

for /f "tokens=1-2 delims==" %%a in ('%cmd%') do (
  set title=%%a
  set value=%%b
  call :save
)

echo intermediate results
echo --------------------
set field_titles
set title
set field_values
set value
echo --------------------

for /f "tokens=2 delims==" %%a in ('set title') do (
  set field_titles=!field_titles!,%%a)

for /f "tokens=2 delims==" %%a in ('set value') do (
  set field_values=!field_values!,%%a)

echo final results
echo --------------------
echo %field_titles%
echo %field_values%
echo %field_titles%>test.csv
echo %field_values%>>test.csv

goto :eof

 

:save
  if not defined value goto :eof
  if %no% LSS 10 (set no_str=0%no%) else set no_str=%no%
  set title%no_str%=%title:~1%
  set value%no_str%=%value:,=%
  set value%no_str%=!value%no_str%:~1!
  set /a no = no+1
  set title=
  set value=
  goto :eof

  