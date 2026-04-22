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
strComment = strDQUOTE & "Adds 3.0 Launcher" & strDQUOTE
StartTime = Time
DebugLevel = 0
WindowTitle = "Adds 3.0 Launcher " & strVersionNum
Fnd_M = False
Fnd_N = False

If Instr(UCase(Wscript.FullName),"CSCRIPT.EXE") > 0 then
	Wscript.Echo "*** " & WindowTitle & " ***" & vbCrLf
	CmdPrompt = True	
Else CmdPrompt = False
End If

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

Set oDrives = WshNetwork.EnumNetworkDrives
For i = 0 to oDrives.Count - 1 Step 2
	If Ucase(oDrives.Item(i)) = "M:" then
		Fnd_M = True
	End If
	If Ucase(oDrives.Item(i)) = "N:" then
		Fnd_N = True
	End If
	'WScript.Echo "Drive " & oDrives.Item(i) & " = " & oDrives.Item(i+1)
Next

If Fnd_M = False then
	MapDrive "M:", "alxapsb12", "Adds", False
End If

If Fnd_N = False then
	MapDrive "N:", "alsdcsb92", "Adds", False
End If

If (WshFS.FolderExists(WshFS.GetFolder("M:\DivData\MapSource\Utils\"))) Then
	Set f = WshFS.GetFolder("M:\DivData\MapSource\Utils\")
	strInputPath02 = f.Path & "\"
End If

If (WshFS.FileExists(strInputPath02 & "Upd_ADDS_Local.Cmd")) Then
	'WScript.Echo "Calling routine Upd_ADDS_Local.Cmd"
	intReturn = WshShell.Run (strInputPath02 & "Upd_ADDS_Local.Cmd", 1, True)
Else
	'WScript.Echo "{Not} Calling routine Upd_ADDS_Local.Cmd"
End If

If (WshFS.FolderExists(WshFS.GetFolder("C:\Program Files\Autodesk\Autodesk Map 3D 2007\"))) Then
	Set f = WshFS.GetFolder("C:\Program Files\Autodesk\Autodesk Map 3D 2007\")
	strInputPath01 = f.Path & "\"
End If

If (WshFS.FolderExists(WshFS.GetFolder("M:\DivData\MapSource\Adds\Sym\"))) Then
	Set f = WshFS.GetFolder("M:\DivData\MapSource\Adds\Sym\")
	strInputPath02 = f.Path & "\"
End If

pKey = WshShell.RegRead("HKCU\SOFTWARE\Autodesk\AutoCAD\R17.0\ACAD-5002:409\Profiles\Adds_T\UserName")

If (pKey = "Information Technology, Southern Company") then
	'WScript.Echo "pKey Value = {" & pKey & "}"
Else
	'WScript.Echo "pKey Value <> {" & pKey & "}"
	If (WshFS.FileExists(strInputPath01 & "Acad.exe")) Then
		'WScript.Echo "Calling Correct Version [Acad.exe]"
		intReturn = WshShell.Run (strDQUOTE & strInputPath01 & "Acad.exe" & strDQUOTE & " /nologo /b M:\DivData\MapSource\Common\AddProfAdds_T.Scr", 1,False)
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

'*************************************************************************************

Function MapDrive (Drive, Server, Share, EnableErrMsg)
' Delete and map drives without killing the script if there is a problem.
   On Error Resume Next
   If DebugLevel >= 1 then WScript.Echo Time & " - Attempting to map " & Drive & " to \\" & Server & "\" & Share
   WshNetwork.RemoveNetworkDrive Drive, TRUE, FALSE
   Err.Clear
   WshNetwork.MapNetworkDrive Drive, "\\" & Server & "\" & Share, FALSE
   If (Err.Number <> 0) then
      If DebugLevel >= 1 then Wscript.Echo Time & " - Connection Failed."
      If (EnableErrMsg) then WshShell.Popup "Can not connect the " & Drive & " drive to \\" & _ 
         Server & "\" & Share & vbCrLf & "If the problem persists, " & HELP_MSG, _
         ERROR_TIMEOUT, WindowTitle, vbExclamation
   Else
      If CmdPrompt then Wscript.Echo "Drive " & Drive & " = \\" & Server & "\" & Share
   End If
   MapDrive = Err.Number
   Err.Clear
End Function

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
