@echo OFF
:: Generate statistics from an XXCCOPY logfile
:: Thank you dbenham: http://stackoverflow.com/a/25657306/14420
::
:: Debugging: uncomment lower case "rem" lines
::
:: TODO: figure out how to extract date stamp from "XXCOPY ver ..." line
::
setlocal enableDelayedExpansion

if "%1"=="" goto :Usage

set "input=%1"
set "output=%~n1_stats.csv"

call :Main
goto :eof

:: ---------- Sub-routines ----------
:Main
  set "row="
  set "header="
  set "begin="
  set "first="
  (
    for /f "usebackq tokens=1* delims==" %%A in ("%input%") do (
      REM At this point %%A is {before =} and %%B is {after =}
      REM or Field & Value 
      rem echo --FIELD: %%A
      rem echo --VALUE: %%B
      call :Get_date %%A

      for /f "tokens=*" %%C in ("%%B") do (
          REM %%C is B%% with any leading whitespace stripped 
          REM (an effect of "tokens=*")
          rem echo --VAL-2: %%C
           
          if "!begin!" equ "%%A" (
            REM Emit header row if this is the first time through outer loop
            if not defined first (
              set first=1
              echo !header:~1!
            )
            echo !row:~1!
            set "row="
          )
          
          REM This adds leading comma on 1st loop run 
          set "row=!row!,"%%C""

          REM On first loop...
          if not defined first for /f "delims=" %%H in ("%%A") do (
            REM %%H is header row column name
            rem echo --COLUMN: %%H
            
            if not defined begin set "begin=%%A"
            
            REM "%%~nH" is to strip trailing whitespace
            rem echo --COLUMN    : "%%H"
            rem echo --COLUMN~nH : "%%~nH"

            rem echo --HEADER-OLD: !header!
            rem echo --HEADER-NEW: !header!,"%%~nH""
            set "header=!header!,"%%~nH""
          )
        )
    )
    REM Emit data row. "~1" strips the leading comma left by
    REM something in previous loop.
    rem echo --DATA-RAW  : !row!
    rem echo --DATA-STRIP: !row:~1!
    echo !row:~1!
  )>"%output%"

  REM to debug: uncomment next (prints to console)
  type "%output%"
  
  echo. --- "%input%" stats saved to "%output%"
  goto :eof

:Get_date
  :: Parse date from xxcopy logfile. Assumes all lines beginning
  :: "XXCOPY" (case sensitive) follow the format:
  :: 
  ::    XXCOPY64 Pro Edition   ver 3.11.4   2013-01-16 17:04:03   Windows Ver 6.1.7601 Service Pack 1
  :: 
  ::  beginnning to "ver" == xxcopy edition name 
  ::  "Windows" to end    == Windows version
  ::  middle is space delimited == xxcopy_version, date, time
  ::
  rem echo. Get_date subroutine stub
  set line=%*
  if not "%line:~0,6%" equ "XXCOPY" goto :eof

  rem echo "%line%"
  rem echo "%line:*Windows=%"
  set ".winver=Windows%line:*Windows=%"
  call set .tmp=%%line:%.winver%=%%
  set ".xxver_date=%.tmp:*ver=%"
  set .

  for /f "tokens=1-3 delims= " %%A in ("%.xxver_date%") do (
      echo -- xxcopy version: %%A
      echo -- date of run   : %%B
      echo -- time of run   : %%C
      )

  set line=
  goto :eof
   
:Usage
  echo.
  echo.  Usage:  
  echo.
  echo.     %~n0 [path\to\input_logfile]
  echo.
  goto :eof
