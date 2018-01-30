@echo off&setlocal
for %%i in ("%~dp0..") do set "folder=%%~fi" 
for %%i in ("%folder%\..") do set "folder=%%~fi"
echo %folder%\
echo %folder%\lovec.exe
SET project=%~dp0
start "" "%folder%\lovec.exe" "%project:~0,-1%" %* -server
start "" "%folder%\lovec.exe" "%project:~0,-1%" %* -client