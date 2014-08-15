@echo off
if [%1]==[] goto :Usage

for /L %%g in (1,1,10) do (
	echo.
	echo.	*** Running speed-test, count %%g of 10
	call speed-test %*
	)

goto :EOF

:Usage
  echo.
  call speed-test
  echo.
  goto :EOF