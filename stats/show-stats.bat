@echo off
if [%1]==[] goto :Usage
rem %~dp0\..\bin\grep --recursive "Action speed" %*
%~dp0\..\bin\grep --recursive --with-filename "Action speed" %*
goto :eof

  
:Findstr
finstr /s/i "Action speed"
  
:Usage
echo.
echo.	Usage:	%~n0 {grep options} [logfile match pattern]
echo.
echo.	%~n0 *2server*.log
echo.	%~n0 --ignore-case *2server*.log
echo.
