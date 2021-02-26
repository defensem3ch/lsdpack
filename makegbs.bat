@echo off
setlocal enabledelayedexpansion
for /f "delims=" %%a in ('dir /b lsdpack*exe') do set lsdpack=!a!
echo !a!
for /f "delims=" %%b in ('dir /b makegbs*exe') do set makegbs=!b!
echo !b!
if not exist !lsdpack! (echo Please place lsdpack.exe in this folder && exit)
if not exist !makegbs! (echo Please place makegbs.exe in this folder && exit)
if not exist rgbasm.exe (echo Please place rgbasm.exe in this folder && exit)
if not exist rgblink.exe (echo Please place rgblink.exe in this folder && exit)
if [%1]==[] (
 echo Usage: makegbs.bat lsdj.gb
 echo Please specify an LSDJ ROM
)
set sav=%1:.gb=.sav%
set rom=%1:.gb=%
if not exist !sav! (echo Please place %1 and !sav! in this folder && exit)
if not exist player.o (rgbasm.exe -o player.o player.s)
lsdpack.exe -g %1
rgbasm.exe -o !rom!.o !rom!.s
rgblink.exe -o !rom!-player.gb player.o !rom!.o
makegbs.exe !rom!-player.gb
