@echo off
:: Matt.wilkie@gov.yk.ca, Initial version October 2008
:: this test suite may be freely modified and shared
:: 2010-Jan-07
::    + added basic sanity checks
::    * destination undefined by default
:: 2014-Aug-14
::    + Major overhaul. Type, dest, source, stats are now command line parameters
::
echo. ------------------------------------------------------------
echo.  Performance test by copying 500mb of small files (23,000+)
echo.  and a single 500mb large file.
echo. ------------------------------------------------------------
echo.
setlocal enabledelayedexpansion

:: required parameters
set dType=%2
set dest=%3

:: optional parameters
set source=%4
set stats=%5

if not defined dType call :NoType
if not defined dest call :NoDest
if not exist "%dest%" call :NoDest
if not [%1]==[go] goto :Usage

:: if source not specified, use folder next to the script
if not defined source set source=%~dp0source
if not exist "%source%" call :NoSource

:: if stats folder not specified, use folder next to the script
set stats=%~dp0stats\%computername%
if not exist "%stats%" mkdir "%stats%"

call :MakeScratch %dest%

:: Basic sanity checks
for %%g in (dest dType source stats) do if not defined %%g goto :Usage
if [%source%]==[%dest%] goto :ErrBadDest

:: make utilities available
set path=%path%;%~dp0\bin

:: make sure start in the same dir as the batch file
pushd %~dp0

CALL :Main

goto :EOF

:: ----------- SUBROUTINES ----------

:Main
  echo.   type        = %dType%
  echo.   destination = %dest%
  echo.   scratch     = %scratch%
  echo.   source      = %source%
  echo.   statistics  = %stats%
  echo.
  
  :: /yy    supress most prompts
  :: /oF0    don't list files copied to screen or logfile
  :: /clone  exact duplicate, inc. attributes, delete if not present in source
  :: /ff    fuzzy time stamps (+/- 2 secs)
  :: /pb    show progress bar (optional)
  :: /oa    append to logfile (used later, don't add to xparams)
  set xparams=/yy /of0 /clone /ff /pb

  set A=little_files
  echo.  --- Preparing for straight copy "!A!", %dType%...
  echo %date% %time% >> %stats%\%dType%_straight-!A!.log
  if exist %scratch%\!A! rd /s/q %scratch%\!A!
  xxcopy %xparams% %source%\!A! %scratch%\!A! /oa%stats%\%dType%_straight-!A!.log

  echo --- Preparing for differential copy "!A!", %dType%...
  echo %date% %time% >> %stats%\%dType%_diff-!A!.log
  :: Delete half the files in a blotch pattern 
    pushd %scratch%\little_files
    for /r %%h in (qctr) do (if exist "%%h" rd /s/q "%%h")
    popd
  xxcopy %xparams% %source%\!A! %scratch%\!A! /oa%stats%\%dType%_diff-!A!.log
  
  set A=big_files
  echo.  --- Preparing for straight copy "!A!", %dType%...
  echo %date% %time% >> %stats%\%dType%_straight-!A!.log
  if exist %scratch%\!A! rd /s/q %scratch%\!A!
  xxcopy %xparams% %source%\!A! %scratch%\!A! /oa%stats%\%dType%_straight-!A!.log

  call :ShowStats
  goto :EOF

:NoType
  echo. *** [type] parameter missing
  echo.
  echo. Type Examples:
  echo.
  echo.   source2destination-note           ... [source machine] 2 [target machine] - {extra note}
  echo.
  echo.   local2NASdual                     ...local machine to QNAP NAS, which is using 2 NICs
  echo.   local2NAS                         ...local machine to QNAP NAS, which is using 1 NIC
  echo.   server2NAS                        ...a server to QNAP NAS
  echo.   elite2raid-same-host              ...Drobo Elite to RAID (both are on same host, Killerbee)
  echo.   NAS2server                        ...from NAS to a server
  echo.   NAS2local                         ...from NAS to a workstation
  echo.   server2local                      ...from server to local workstation drive
  echo.   server2drobo                      ...from server to locally attached drobo
  echo.   server2dshare                     ...from server to droboshare
  echo.   server2server                     ...from server to another server
  echo.   server2loc-usb                    ...from server to local usb drive
  echo.   local2drobo                       ...from local drive to drobo
  echo.   local2dshare                      ...from local drive to droboshare  
  echo.   localssd2qnap_ts569-iscsi         ...from local SSD to QNAP iscsi on group switch
  echo.   localssd2qnap_ts569-iscsi-direct  ...to QNAP iscsi direct connect (no switch)
  echo.   localssd2qnap_ts569               ...to QNAP native mode (as regular server)
  echo.   localssd2envgeoserver_d           ...to \\envgeoserver's D: drive
  echo.   localssd2envgeo                   ...to \\envgeo
  echo.   localssd2downtown                 ...to a server downtown (\\storestatic)
  echo.   local2downtown                    ...local machine (reg disk) 
  echo.
  call :Usage
  call :HALT
  
:NoDest
  echo. *** Destination path missing or insufficient permissions
  echo.
  echo. Always use UNC paths for non-local destinations:
  echo.
  echo.   D:\temp
  echo.   \\envgeoserver\testing
  echo.
  call :Usage
  call :HALT

:NoSource
  echo.
  echo. *** Source "%source%" not found. 
  echo.
  echo.     {source} is an optional parameter. It defaults to "%~dp0source" and should contain:
  echo.
  echo.        big_files
  echo.        little_files
  echo.        big_files\NC_ETM_NIR.zip
  echo.        little_files\arcdata_old
  echo.        little_files\Beta
  echo.        little_files\dupes
  echo.        little_files\schema.ini
  echo.        little_files\arcdata_old\250k
  echo.        little_files\arcdata_old\250k\base
  echo.        little_files\arcdata_old\250k\boundary
  echo.        little_files\arcdata_old\250k\log
  echo.        little_files\arcdata_old\250k\theme
  echo.        little_files\arcdata_old\250k\base\094m
  echo.        little_files\arcdata_old\250k\base\094n
  echo.        ...etc
  echo.
  call :Usage
  call :HALT
  
:MakeScratch
  set scratch=%1\speed-test-scratch
  if not exist "%scratch%" (
    echo.
    echo. ...creating scratch folder "%scratch%"
    echo.
    mkdir "%scratch%"
    )
  if not exist "%scratch%" call :HALT
  goto :EOF

:ShowStats
  pushd %stats%
  echo.
  echo.  *** Summary results for %dType%:
  echo.
  grep "Action speed" %dType%*.log
  echo.
  :: pause for 10 secs
  ping -n 10 localhost >nul
  popd
  goto :EOF

:ErrBadDest
  echo.
  echo.  *** source and destination must not match *** 
  echo.  source:  %source%
  echo.  dest:  %dest%
  echo.
  call :Usage
  goto :EOF

:HALT
  :: terminate script immediately
  :: c.f. http://stackoverflow.com/questions/19258020/stop-a-batch-file-completely-when-in-a-call-loop
  call :__halt 2>nul
  :__halt
  ()

:Usage
  echo.
  echo.  Usage:  
  echo.
  echo.     %~n0 go [type] [destination path] {source path} {statistics folder}
  echo.
  goto :EOF
