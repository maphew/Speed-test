@echo off
if "%1"=="" goto :Usage
echo.
echo.   Generate statistics for all xxcopy logfiles in folder "%1"
echo.

if not exist "%1" goto :NotExist

call :Main %*
goto :eof

:: ---------- Sub-routines ----------
:Main
  pushd "%1"
  for %%A in (*.log) do call %~dp0\xxcopylog_to_stats.bat %%A
  popd
  goto :eof

:NotExist
  echo. *** Error: "%1" doesn't exist.
  call :Usage
  goto :eof

:Usage
  echo.
  echo.  Usage:  
  echo.
  echo.     %~n0 [path\to\top\folder]
  echo.
  goto :eof
