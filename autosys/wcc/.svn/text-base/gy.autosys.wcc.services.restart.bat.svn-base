@echo on
rem 
rem 2017-09-08 Patrick Volz
rem This is a stub Windows Command Line file for launching CMD scripts, 
rem stdout and stderr logging, and putting appropriate name on log file
rem nothing should really change between different CMD scripts
rem
D:
set this_path=%~p0
cd "%this_path%"
call "..\..\common\common.cmd"  datetime
set file_stub=%~n0
echo file_stub=%file_stub%

echo on
call "%file_stub%.cmd" 1>"..\..\logs\%file_stub%_%local_datetime%.log" 2>&1
