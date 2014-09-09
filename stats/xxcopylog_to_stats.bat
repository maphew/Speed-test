@echo OFF
:: Generate statistics from an XXCCOPY logfile
:: Thank you dbenham: http://stackoverflow.com/a/25657306/14420
::
:: Debugging: uncomment lower case "rem" lines
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
  set /a "count=0"
  (
    for /f "usebackq tokens=1* delims==" %%A in ("%input%") do (
      REM These line numbers should match logfile. If not, something is
      REM wrong.
      set /a "count+=1"
      rem echo Loop# !count!: "%%A" >> debug-loop-count.txt
      rem echo Loop# !count!: "%%A"

      REM At this point %%A is {before =} and %%B is {after =}
      REM or Field & Value 
      rem echo --FIELD: %%A
      rem echo --VALUE: %%B
      
      call :Get_date %%A
      rem echo ~~~ "!xxcopy_ver!","!run_date!","!run_time!"

      for /f "tokens=*" %%C in ("%%B") do (
          REM %%C is VALUE with any leading whitespace stripped 
          REM (an effect of "tokens=*")
          rem echo --VAL-2: %%C
           
          if "!begin!" equ "%%A" (
            REM Emit header row if this is the first time through outer loop
            if not defined first (
              set first=1
              echo !header:~1!,"xxcopy version","date","time"
            )
            REM BUG: with xxcopy_ver etc. these 3 values are out by one,
            REM the first one gets swallowed ...cont'd:
            rem echo !row:~1!,"!xxcopy_ver!","!run_date!","!run_time!"
            echo !row:~1!
            set "row="
          )
          
          REM BUG: ...while here the 3 values are in the right row, but
          REM they interperse with other columns, duplicated many times
          REM
          REM This adds leading comma on 1st loop run 
          rem set "row=!row!,"%%C","!xxcopy_ver!","!run_date!","!run_time!""
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
  :::: Adapted from http://ss64.com/nt/syntax-replace.html
  ::
  rem echo. Get_date subroutine stub
  set line=%*
  if not "%line:~0,6%" equ "XXCOPY" goto :eof
  set xxcopy_ver=
  set run_date=
  set run_time=

  REM Get substring from "Windows" to end of line 
  set ".winver=Windows%line:*Windows=%"
  
  REM remove Windows substring from input line
  call set .tmp=%%line:%.winver%=%%
  
  REM Get substring beginning of line to first "ver" from temp string
  set ".xxver_date=%.tmp:*ver=%"
  rem set .

  REM Parse the remaining middle bit
  for /f "tokens=1-3 delims= " %%A in ("%.xxver_date%") do (
      set xxcopy_ver=%%A
      set run_date=%%B
      set run_time=%%C
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
