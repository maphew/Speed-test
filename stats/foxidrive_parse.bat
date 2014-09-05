REM foxidrive: http://stackoverflow.com/a/25657687/14420
@echo off
(
 echo Source,Destination,Total bytes,MB per min
 for /f "usebackq tokens=1,* delims==" %%a in ("input_data.txt") do (
   for /f "tokens=*" %%c in ("%%b") do (
    if "%%a"=="MB per min " (set/p=""%%c""<nul&echo() else (set/p=""%%c","<nul)
 )
)>"%~n0_result.csv"
