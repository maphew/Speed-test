REM dbenham: http://stackoverflow.com/a/25657306/14420 
@echo OFF
setlocal enableDelayedExpansion

set "input=input_data.txt"
set "output=%~n0_result.csv"

set "row="
set "header="
set "begin="
set "first="
(
  for /f "usebackq tokens=1* delims==" %%A in ("%input%") do for /f "tokens=*" %%C in ("%%B") do (
    if "!begin!" equ "%%A" (
      if not defined first (
        set first=1
        echo !header:~1!
      )
      echo !row:~1!
      set "row="
    )
    set "row=!row!,"%%C""
    if not defined first for /f "delims=" %%H in ("%%A") do (
      if not defined begin set "begin=%%A"
      set "header=!header!,"%%~nH""
    )
  )
  echo !row:~1!
)>"%output%"
