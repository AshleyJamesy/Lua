@echo off&setlocal
for %%i in ("%~dp0..") do set "folder=%%~fi"
echo %folder%\
echo %~dp0%
for %%i in ("%folder%\..") do set "folder=%%~fi"
echo %folder%\
start "" "%folder%\lovec.exe" .