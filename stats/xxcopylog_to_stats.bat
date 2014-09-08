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
  (
    for /f "usebackq tokens=1* delims==" %%A in ("%input%") do (
      REM At this point %%A is {before =} and %%B is {after =}
      REM or Field & Value 
      rem echo --FIELD: %%A
      rem echo --VALUE: %%B
      
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
  
  REM to debug: uncomment 1st line and comment 2nd
  REM (prints to console instead of file)
  )
  rem )>"%output%"
  
  echo. --- "%input%" stats saved to "%output%"
  goto :eof

:Usage
  echo.
  echo.  Usage:  
  echo.
  echo.     %~n0 [path\to\input_logfile]
  echo.
  goto :eof
