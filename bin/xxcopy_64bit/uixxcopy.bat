@echo off
echo.
echo *******************************
echo *  XXCOPY64 UNINSTALL SCRIPT  *
echo *******************************
echo.
echo This batch script will delete the following files from this directory
echo.
echo     XXCOPY.EXE        // The XXCOPY64 executable file (for admin)
echo     XXCOPYSU.EXE      // For Vista/2003/2008 (for standard user)
echo     XXPBAR64.EXE      // The Progress Bar display module
echo     XXCONSOLE.EXE     // the super console generator
echo     XXCOPY.CHM        // html-style help filec
echo     UIXXCOPY.BAT      // this file
echo.
echo Are you ready to delete XXCOPY.EXE from the current directory
echo If not, press Ctrl-Break to terminate this batch script
echo To continue,  press any other key now.
pause >nul
echo.
echo del  XXCOPY.EXE
del  XXCOPY.EXE
echo Are you ready to delete XXCOPYSU.EXE from the current directory
echo If not, press Ctrl-Break to terminate this batch script
echo To continue,  press any other key now.
pause >nul
echo.
echo del  XXCOPYSU.EXE
del  XXCOPYSU.EXE
echo Are you ready to delete XXPBAR64.EXE from the current directory
echo If not, press Ctrl-Break to terminate this batch script
echo To continue,  press any other key now.
pause >nul
echo.
echo del  XXPBAR64.EXE
del  XXPBAR64.EXE
echo Are you ready to delete XXCONSOLE.EXE from the current directory
echo If not, press Ctrl-Break to terminate this batch script
echo To continue,  press any other key now.
pause >nul
echo.
echo del  XXCONSOLE.EXE
del  XXCONSOLE.EXE
echo Are you ready to delete XXCOPY.CHM from the current directory
echo If not, press Ctrl-Break to terminate this batch script
echo To continue,  press any other key now.
pause >nul
echo.
echo del  XXCOPY.CHM
del  XXCOPY.CHM
echo Are you ready to delete UIXXCOPY.BAT from the current directory
echo If not, press Ctrl-Break to terminate this batch script
echo To continue,  press any other key now.
pause >nul
echo.
echo del  UIXXCOPY.BAT
echo.
echo Uninstall XXCOPY complete.
echo.
del  UIXXCOPY.BAT
