@echo off
setlocal enabledelayedexpansion
for /f "delims=" %%a in ('dir /b lsdpack*exe') do set lsdpack=%%a%
echo Found lsdpack: !lsdpack!
for /f "delims=" %%b in ('dir /b makegbs*exe') do set makegbs=%%b%
echo Found makegbs: !makegbs!
if not exist !lsdpack! (echo Please place lsdpack.exe in this folder && goto end)
if not exist !makegbs! (echo Please place makegbs.exe in this folder && goto end)
if not exist rgbasm.exe (echo Please place rgbasm.exe in this folder && goto end)
if not exist rgblink.exe (echo Please place rgblink.exe in this folder && goto end)
if [%1]==[] (
 echo Usage: makegbs.bat lsdj.gb
 echo Please specify an LSDJ ROM
 goto end
) else (
 set lsdj=%1%
 echo Compiling song from !lsdj!
 if exist !lsdj!*s rm !lsdj!*s
)
set sav=!lsdj:.gb=.sav!
set rom=!lsdj:.gb=!
if not exist !sav! (echo Please place %1 and !sav! in this folder && goto end)
if not exist player.o (rgbasm.exe -o player.o player.s)
!lsdpack! -g %1
for /f "delims=" %%c in ('dir /b !rom!*.s') do (
 set in=%%c%
 set out=!in:.s=.o!
 rgbasm -o !out! !in!
)
for /f "delims=" %%d in ('dir /b !rom!*.o') do (
 set in=%%d%
 set out=!in:.o=!
 rgblink -o !out!-player.gb player.o !in!
)
for /f "delims=" %%e in ('dir /b *-player.gb') do !makegbs! %%e
:end
