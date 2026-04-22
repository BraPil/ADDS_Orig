@ECHO OFF
PowerShell.exe -Command "& {Start-Process PowerShell.exe -ArgumentList '-ExecutionPolicy Bypass -File ""U:\SCS Transmission Portfolio\ADDS\UA\Setup\Transmission\ADDS19DirSetup.ps1""' -Verb RunAs}"

PowerShell.exe -Command "& 'U:\SCS Transmission Portfolio\ADDS\UA\Setup\ADDS19\ADDS19TransTestSetup.ps1'"

