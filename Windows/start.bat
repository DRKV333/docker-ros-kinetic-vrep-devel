@echo off

call CONFIG.bat
IF "%1"=="" (set CONTAINER=%CONTAINERN%) ELSE (set CONTAINER=%1)
docker start -ai %CONTAINER%