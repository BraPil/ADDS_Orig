@echo off

IF NOT ("%CopyCmd%")==("") GOTO DONEXT
GOTO NOCMDVAL

:NOCMDVAL
set CopyCmd=/Y
GOTO DONEXT

:DONEXT
echo "******************** Transmission Test SDrive Adds Dir ********************"
date /t
time /t
echo "******************** Transmission Test SDrive Adds Dir ********************" >>C:\Adds\AddsUpd.Log
date /t >>C:\Adds\AddsUpd.Log
time /t >>C:\Adds\AddsUpd.Log
c:
cd \
if not exist "Adds." md "Adds."
if not exist "Div_Map." md "Div_Map."
cd "Adds."
if not exist "Dwg." md "Dwg."
if not exist "Logs." md "Logs."
if not exist "Plot." md "Plot."
cd \
cd "Div_Map."
if not exist "Adds." md "Adds."
if not exist "Common." md "Common."
if not exist "DosLib." md "DosLib."
if not exist "Icon_Collection." md "Icon_Collection."
if not exist "LookUpTable." md "LookUpTable."
if not exist "Oracle." md "Oracle."
if not exist "Utils." md "Utils."
rem - 6 lines below added 17 Feb 15 CET
cd \                         
cd "ProgramData."
if not exist "AddsTemp." md "AddsTemp."
icacls C:\ProgramData\AddsTemp. /grant Users:(oi)(ci)f
cd "AddsTemp."
if not exist "Dwg." md "Dwg."
REM
echo "Copying/Updating Files..."
echo "Copying/Updating Files..." >>C:\Adds\AddsUpd.Log
if not exist "C:\Div_Map\Div_map.ini" 	Xcopy "S:\Workgroups\APC Power Delivery\Division Mapping Test\TestTransmission\Setup\Div_map.ini" 		C:\Div_Map\Div_map.ini /F <"S:\Workgroups\APC Power Delivery\Division Mapping\Utils\F.Dat" >>C:\Adds\AddsUpd.Log
if not exist "AddsTestLogin.ini" 		Xcopy "S:\Workgroups\APC Power Delivery\Division Mapping Test\TestTransmission\Setup\AddsTestLogin.ini" C:\Div_Map\AddsTestLogin.ini /F <"S:\Workgroups\APC Power Delivery\Division Mapping\Utils\F.Dat" >>C:\Adds\AddsUpd.Log
REM
echo "Copying/Updating Adds Files..."
echo "Copying/Updating Adds Files..." >>C:\Adds\AddsUpd.Log
Xcopy "S:\Workgroups\APC Power Delivery\Division Mapping Test\TestTransmission\Adds\*.*" C:\Div_Map\Adds\*.* /D /F /S >>C:\Adds\AddsUpd.Log
REM
echo "Copying/Updating Common Files for All OS..."
echo "Copying/Updating Common Files..." >>C:\Adds\AddsUpd.Log
Xcopy "S:\Workgroups\APC Power Delivery\Division Mapping Test\TestTransmission\Common\*.*" C:\Div_Map\Common\*.* /D /F /S >>C:\Adds\AddsUpd.Log
REM
echo "Copying/Updating Common Files for Windows7..."
echo "Copying/Updating Common Files..." >>C:\Adds\AddsUpd.Log
Xcopy "S:\Workgroups\APC Power Delivery\Division Mapping Test\TestTransmission\CommonW10\*.*" C:\Div_Map\Common\*.* /D /F /S >>C:\Adds\AddsUpd.Log
REM
echo "Copying/Updating DosLib Files..."
echo "Copying/Updating DosLib Files..." >>C:\Adds\AddsUpd.Log
Xcopy "S:\Workgroups\APC Power Delivery\Division Mapping Test\TestTransmission\DosLib\*.*" C:\Div_Map\DosLib\*.* /D /F /S >>C:\Adds\AddsUpd.Log
REM
echo "Copying/Updating Icon_Collection Files..."
echo "Copying/Updating Icon_Collection Files..." >>C:\Adds\AddsUpd.Log
Xcopy "S:\Workgroups\APC Power Delivery\Division Mapping Test\TestTransmission\Icon_Collection\*.*" C:\Div_Map\Icon_Collection\*.* /D /F /S >>C:\Adds\AddsUpd.Log
REM
echo "Copying/Updating LookUpTable Files for Windows7..."
echo "Copying/Updating LookUpTable Files..." >>C:\Adds\AddsUpd.Log
Xcopy "S:\Workgroups\APC Power Delivery\Division Mapping Test\TestTransmission\LookUpTable\*.*" C:\Div_Map\LookUpTable\*.* /D /F /S >>C:\Adds\AddsUpd.Log
REM
echo "Copying/Updating Utils Files..."
echo "Copying/Updating Utils Files..." >>C:\Adds\AddsUpd.Log
Xcopy "S:\Workgroups\APC Power Delivery\Division Mapping Test\TestTransmission\Utils\*.*" C:\Div_Map\Utils\*.* /D /F /S >>C:\Adds\AddsUpd.Log

echo "******************** Sequence Complete {ALL} ********************" >>C:\Adds\AddsUpd.Log
date /t >>C:\Adds\AddsUpd.Log
time /t >>C:\Adds\AddsUpd.Log

GOTO EXIT

:EXIT
echo "Successfull Exit"
