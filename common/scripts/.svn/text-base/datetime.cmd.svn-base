@echo off
::
:: 2013-02-08 Global Service Tools - IT Infrastructure
:: 
:: Need this setlocal parameter to enable variables when you are referencing them inside a FOR loop
:: Also need !variable! to reference the intermediate values inside a FOR loop

SETLOCAL EnableDelayedExpansion
SET debug=TRUE
SET debug=FALSE

if [%debug%]==[TRUE] (echo Parameter1 passed="%1")
IF /I [%1]==[date] GOTO dateSubroutine 
IF /I [%1]==[time] GOTO timeSubroutine

:datetimeSubroutine
if [%debug%]==[TRUE] (echo datetimeSubroutine)
For /f "tokens=2-4 delims=/ " %%a in ("%DATE%") do (set mydate=%%c-%%a-%%b)
rem CANT USE because ':' can't be used in filename:::::: For /f "tokens=1-3 delims=/:. " %%a in ("%TIME%") do (set mytime=%%a:%%b:%%c)
For /f "tokens=1-3 delims=/:. " %%a in ("%TIME%") do (set mytime=%%a-%%b-%%c)
SET datetime=%mydate%_%mytime%
ENDLOCAL & SET _datetime=%mydate%_%mytime%
GOTO :eof

:dateSubroutine
if [%debug%]==[TRUE] (echo dateSubroutine)
For /f "tokens=2-4 delims=/ " %%a in ("%DATE%") do (set mydate=%%c-%%a-%%b)
ENDLOCAL & SET _date=%mydate%
GOTO :eof

:timeSubroutine
if [%debug%]==[TRUE] (echo timeSubroutine)
For /f "tokens=1-3 delims=/:. " %%a in ("%TIME%") do (
   set hour=%%a
   if !hour! LSS 10 (set hour=0!hour!)
   set mytime=!hour!-%%b-%%c
)
ENDLOCAL & SET _time=%mytime%
GOTO :eof
