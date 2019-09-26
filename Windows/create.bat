@echo off

call CONFIG.bat

IF "%1"=="" (set CONTAINER=%CONTAINERN%) ELSE (set CONTAINER=%1)

rem Deterimine configured user for the docker image
FOR /F "tokens=* USEBACKQ" %%F IN (`docker image inspect --format '{{.Config.User}}' %IMAGEN%`) DO (
SET docker_user=%%F
)
set docker_user=%docker_user:~1,-1%
IF "%docker_user%"=="" (set dHOME_FOLDER="/root") ELSE (set dHOME_FOLDER="/home/%docker_user%")

FOR /F "tokens=1,* delims= " %%a in ("%*") do set ALL_BUT_FIRST=%%b

docker create ^
    --name=%CONTAINER% ^
    --net=host ^
    --ipc=host ^
    --privileged ^
    -e DISPLAY="host.docker.internal:0.0" ^
    -v %SRCPATH%:%dHOME_FOLDER%/catkin_ws/src ^
    -it %IMAGEN% "%ALL_BUT_FIRST%"
