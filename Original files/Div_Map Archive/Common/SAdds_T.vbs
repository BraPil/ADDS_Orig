' Windows Scripting Host VB Script to Launch Adds 3.0 for AutoCad Map 2004
'
' -----------------------------------------------------------------------------------------
'
'               Copyright (C) 1999-2002 Alabama Power Company
'               
'               Author: Ed Williams
'               Script Created: June 17, 2004
'               Last Modified: June 17, 2004
'               Version 1.1
'
'
' -----------------------------------------------------------------------------------------
' ********************************************************************************
' Get computer name and user's NT id.
' ********************************************************************************
Public Const HELP_MSG = "Please call the IR Support Center at 8-999-9110 for assistance."
Public Const ERROR_TIMEOUT = 45          ' Seconds to display error messages
Public DebugLevel
Public WindowTitle
Dim WshNetwork, strComputer, strNTid, WshShell
Dim WshFS, MsgBox_Title_Text, MsgBox_Message_Text, fRunFile, strOutputFile, strCmdLine, ArgCnt
Dim strCRLF, strTAB, strDQUOTE, oDrives, Fnd_M, Fnd_N
Dim strVersionNum, strInputPath01, strInputPath02, strComment, bKey

Set WshShell = Wscript.CreateObject("Wscript.Shell")
Set WshUserEnv = WshShell.Environment("USER")
Set WshNetwork = WScript.CreateObject("WScript.Network")
Set WshFS = WScript.CreateObject("Scripting.FileSystemObject")

On Error Resume Next

SystemRootPath = WshShell.ExpandEnvironmentStrings("%SystemRoot%")
strComputer = Ucase(WshNetwork.ComputerName)
strNTid = Ucase(WshNetwork.UserName)
strCRLF = Chr(13) & Chr(10)
strTAB = Chr(9)
strDQUOTE = Chr(34)
strVersionNum = "Version 1.1"
strComment = strDQUOTE & "Adds Test Launcher" & strDQUOTE
StartTime = Time
DebugLevel = 0
WindowTitle = "Adds Test Launcher " & strVersionNum
' 	Fnd_M = False
'	Fnd_N = False

If Instr(UCase(Wscript.FullName),"CSCRIPT.EXE") > 0 then
	Wscript.Echo "*** " & WindowTitle & " ***" & vbCrLf
	CmdPrompt = True	
Else CmdPrompt = False
End If

'	**** Checks to see if AUTODESK Map 3D is installed if not it will install it. ***
bKey = WshShell.RegRead("HKLM\SOFTWARE\Autodesk\AutoCAD\R17.0\ACAD-5002:409\Service Packs\Autodesk Map 3D 2007\Release")
If (bKey = "10.0.100.0") then
	'WScript.Echo "bKey Value = {" & bKey & "}"
Else
	'WScript.Echo "bKey Value <> {" & bKey & "}"
	If (WshFS.FileExists("C:\Program Files\Southern Company\WebIcons\Launcher.exe")) Then
		intReturn = WshShell.Run (strDQUOTE & "C:\Program Files\Southern Company\WebIcons\Launcher.exe" & strDQUOTE & " 12577 False", 1,False)
	End If
	ShutDown 0
End If

Dim winTemp

'	*** Copies latest files from S to C drive ***
If (WshFS.FolderExists(WshFS.GetFolder("S:\Workgroups\APC Power Delivery\Division Mapping Test\Utils\"))) Then
	Set f = WshFS.GetFolder("S:\Workgroups\APC Power Delivery\Division Mapping Test\Utils\")
	strInputPath02 = f.Path & "\"
End If
If (WshFS.FileExists(strInputPath02 & "Upd_S_Map_Adds_Local.Cmd")) Then
	'WScript.Echo "Calling routine Upd_ADDS_Local.Cmd"
	winTemp = strDQUOTE & strInputPath02 & "Upd_S_Map_Adds_Local.Cmd" & strDQUOTE
	intReturn = WshShell.Run (winTemp, 1, True)
'	MsgBox winTemp & intReturn
Else
	'WScript.Echo "{Not} Calling routine Upd_ADDS_Local.Cmd"
End If

'	*** Gets path to AutoCAD sub-directory for firing off AutoDesk Map 3D ****
If (WshFS.FolderExists(WshFS.GetFolder("C:\Program Files\Autodesk\Autodesk Map 3D 2007\"))) Then
	Set f = WshFS.GetFolder("C:\Program Files\Autodesk\Autodesk Map 3D 2007\")
	strInputPath01 = f.Path & "\"
End If

'	*** Gets path common Adds sub-direcorty for obtaining profile information to load profile. ***
'If (WshFS.FolderExists(WshFS.GetFolder("S:\Workgroups\APC Power Delivery\Division Mapping Test\Common\"))) Then
'	Set f = WshFS.GetFolder("S:\Workgroups\APC Power Delivery Test\Division Mapping Test\Common\")
'	strInputPath02 = f.ShortPath & "\"
'End If

'	*** Checks to see if Cadet profile is installed on local box if not it will install it.  ***
pKey = WshShell.RegRead("HKCU\SOFTWARE\Autodesk\AutoCAD\R17.0\ACAD-5002:409\Profiles\Adds_T\UserName")
If (pKey = "Information Technology, Southern Company") then
	'WScript.Echo "pKey Value = {" & pKey & "}"
Else
	'WScript.Echo "pKey Value <> {" & pKey & "}"
	If (WshFS.FileExists(strInputPath01 & "Acad.exe")) Then
		'WScript.Echo "Calling Correct Version [Acad.exe]"
		intReturn = WshShell.Run (strDQUOTE & strInputPath01 & "Acad.exe" & strDQUOTE & " /nologo /b C:\Div_Map\Common\AddProfSAdds.Scr", 1,False)
	Else
		'WScript.Echo "{Not} Calling Correct Version [Acad.exe]"
	End If
	ShutDown 0
End If

If (WshFS.FileExists(strInputPath01 & "Acad.exe")) Then
	'WScript.Echo "Calling Correct Version [Acad.exe]"
	intReturn = WshShell.Run (strDQUOTE & strInputPath01 & "Acad.exe" & strDQUOTE & " /nologo /p Adds_T", 1,False)
Else
	'WScript.Echo "{Not} Calling Correct Version [Acad.exe]"
End If

ShutDown 0

'**************************************************************************************

Sub ShutDown(ErrorToReturn)
' Called to gracefully end the script
   Dim btn
   On Error Resume Next
   If DebugLevel >= 1 then Wscript.Echo Time & " - Script Ends."
   If DebugLevel >= 1 then Wscript.Echo Time & " - Total Logon Script Time is " & DateDiff("s", StartTime, Time) & " seconds."
   ' Delete any objects we may have connected to
   WScript.DisconnectObject WshNetwork
   WScript.DisconnectObject WshFS
   WScript.DisconnectObject WshUserEnv
   WScript.DisconnectObject WshShell
   ' End the Script
   WScript.Quit ErrorToReturn
End Sub  

'************************************************************************************