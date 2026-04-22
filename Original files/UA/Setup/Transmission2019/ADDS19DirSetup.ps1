

#	***	Creates C:\ADDS directory if it does not exists and sets permission	***"
if(!(Test-Path -path C:\ADDS)) 		{New-Item C:\ADDS 		-type directory }
icacls.exe C:\ADDS /grant 'Users:(oi)(ci)(f)'
if(!(Test-Path -path C:\ADDS\Dwg)) 	{New-Item C:\ADDS\Dwg 	-type directory }
if(!(Test-Path -path C:\ADDS\Logs)) {New-Item C:\ADDS\Logs 	-type directory }
if(!(Test-Path -path C:\ADDS\Plot)) {New-Item C:\ADDS\Plot 	-type directory }


#	*** Creates C:\ProgramData\AddsTemp and sets permissions	***
$target="C:\ProgramData\AddsTemp"
if(!(Test-Path -path $target)) {New-Item $target -type directory }
$target2="C:\ProgramData\AddsTemp\Dwg"
if(!(Test-Path -path $target2)) {New-Item $target2 -type directory }
icacls.exe $target /grant 'Users:(oi)(ci)(f)'


if(!(Test-Path -path C:\Div_Map\))                {New-Item C:\Div_Map\ 	-type directory }
if(!(Test-Path -path C:\Div_Map\Adds))            {New-Item C:\Div_Map\Adds 	-type directory }
if(!(Test-Path -path C:\Div_Map\Common))          {New-Item C:\Div_Map\Common 	-type directory }
if(!(Test-Path -path C:\Div_Map\DosLib))          {New-Item C:\Div_Map\DosLib 	-type directory }
if(!(Test-Path -path C:\Div_Map\Icon_Collection)) {New-Item C:\Div_Map\Icon_Collection 	-type directory }
if(!(Test-Path -path C:\Div_Map\LookUpTable))     {New-Item C:\Div_Map\LookUpTable 	-type directory }
if(!(Test-Path -path C:\Div_Map\Utils))           {New-Item C:\Div_Map\Utils 	-type directory }
icacls.exe C:\Div_Map /grant 'Users:(oi)(ci)(f)'




