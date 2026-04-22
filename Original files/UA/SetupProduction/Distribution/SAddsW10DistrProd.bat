@ECHO OFF
PowerShell.exe -Command "& {Start-Process PowerShell.exe -ArgumentList '-ExecutionPolicy Bypass -File ""U:\SCS Transmission Portfolio\ADDS\UA\SetupProduction\Distribution\sADDSW10DirSetup.ps1""' -Verb RunAs}"
PowerShell.exe -Command "& 'U:\SCS Transmission Portfolio\ADDS\UA\SetupProduction\Distribution\SAddsW10DistrProd.ps1'"
