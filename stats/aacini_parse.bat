REM Aacini: http://stackoverflow.com/a/25654584/14420
@echo off
setlocal EnableDelayedExpansion

set "header=1"
set "row="
(for /F "tokens=1* delims==" %%a in (Input_data.txt) do (
   if defined header set "header=!header!,"%%~Na""
   for /F "tokens=*" %%c in ("%%b") do set "row=!row!,"%%c""
   if "%%a" equ "MB per min " (
      if defined header echo !header:~2!& set "header="
      echo !row:~1!
      set "row="
   )
)) > "%~n0_result.csv"
