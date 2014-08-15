@echo off
echo.
echo ***************************
echo *  XXCOPY INSTALL SCRIPT  *
echo ***************************
echo.
::--------------------------------------------------------------------------
:: Make the directory where this batch file resides the current directory
::
if "%OS%"=="Windows_NT" ((cd /d %~dp0)&(goto next))
echo %0 | find.exe ":" >nul
if not errorlevel 1 %0\
cd %0\..
:next
echo The current directory is:
cd
echo.
::--------------------------------------------------------------------------
if not exist .\readme.txt    goto error1
if not exist .\xxcopy.exe    goto error1
if not exist .\xxcopysu.exe  goto error1
if not exist .\xxpbar.exe    goto error1
if not exist .\xxconsole.exe goto error1
if not exist .\xxcopy.chm    goto error1
if not exist .\install.bat   goto error1
if not exist .\uixxcopy.bat  goto error1
goto start
::--------------------------------------------------------------------------
:error1
echo.
echo The following files are expected to be present in the current directory.
echo.
echo        README.TXT      // Please read this file first
echo        XXCOPY.EXE      // the workhorse of this package
echo        XXCOPYSU.EXE    // (for Vista/Win7 standard user)
echo        XXPBAR.EXE      // used when /PB (progress bar) is used
echo        XXCONSOLE.EXE   // the super console generator
echo        XXCOPY.CHM      // html-style help filec
echo        UIXXCOPY.BAT    // uninstall XXCOPY-related entries from registry
echo.
goto end
::--------------------------------------------------------------------------
:start
xxcopy.exe  /install
echo.
echo --------- [ install.bat ] --------------------------------------------
if errorlevel 1 goto error2
echo.
echo  Congratulations!!!  XXCOPY has been successfully installed.
echo.
echo  If you ever need to uninstall the XXCOPY software package,
echo  run the following sequence (moved into the XXCOPY home directory).
echo.
echo    XXCOPY     /uninstall
echo    UIXXCOPY
echo.
echo  If you followed the recommendation for XXCOPY's home directory,
echo  the XXCOPY files have been copied to its permanent directory. 
echo  The XXCOPY-related files in this temporary directory where
echo  the install batch file was launched are no longer needed.
echo.
echo         README.TXT
echo         XXCOPY.EXE
echo         XXCOPYSU.EXE
echo         XXPBAR.EXE
echo         XXCONSOLE.EXE
echo         XXCOPY.CHM
echo         INSTALL.BAT
echo         UIXXCOPY.BAT
echo.
goto end
:error2
echo.
echo To install XXCOPY, run the following command from this directory.
echo.
echo   XXCOPY /INSTALL
echo.
:end
