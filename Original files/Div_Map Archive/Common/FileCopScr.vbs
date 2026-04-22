' Windows Scripting Host VB Script to Copy Files to the S: Drive for use by Alabama Power.
'
' -----------------------------------------------------------------------------------------
'
'               Copyright (C) 1999-2002 Alabama Power Company
'               
'               Author: Ed Williams
'               Script Created: June 11, 2009
'               Version 1.0
'
'
' -----------------------------------------------------------------------------------------
' ********************************************************************************
' Get computer name and user's NT id.
' ********************************************************************************

Dim objNet, strComputer, strNTid
Set objNet = WScript.CreateObject("WScript.Network")
strComputer = Ucase(objNet.ComputerName)
strNTid = Ucase(objNet.UserName)
Dim fso, MsgBox_Title_Text, MsgBox_Message_Text, fRunFile, strOutputFile, strCmdLine, ArgCnt
Set fso = CreateObject("Scripting.FileSystemObject")
Dim strCRLF, strTAB, strDQUOTE
Dim strVersionNum, strInputPath01, strInputPath02, strInputPath03, strInputPath04, strInputPath05, strInputPath06
Dim strInputPath07, strInputPath08, strInputPath09, strInputPath10, strInputPath11, strInputPath12, strInputPath13
Dim strOutputPath, strInputFile, strUName, strUPass, strSID, strLodMstDvExFile, strLodObBlkExFile
Dim strLodObAttExFile, strLod4PtPLExFile, strLodObTxtExFile, strLodObjPLExFile, strLodObVrtExFile, strLodRgAppExFile
Dim strSFile, strSPath, strDPath
strCRLF = Chr(13) & Chr(10)
strTAB = Chr(9)
strDQUOTE = Chr(34)
strVersionNum = "Version 1.0"

On Error Resume Next

DebugLevel = 0

Set objArgs = WScript.Arguments

For ArgCnt = 0 To (objArgs.Count - 1)
	'Wscript.Echo "Got [" & objArgs(ArgCnt) & "] as [" & trim(cstr(ArgCnt)) & "]"
	if ArgCnt = 0 then
		If DebugLevel >= 1 then Wscript.Echo "Got [" & objArgs(ArgCnt) & "] as [Source File]"
		strSFile = objArgs(ArgCnt)
	end if
	if ArgCnt = 1 then
		If DebugLevel >= 1 then Wscript.Echo "Got [" & objArgs(ArgCnt) & "] as [Source Path]"
		strSPath = objArgs(ArgCnt)
	end if
	if ArgCnt = 2 then
		If DebugLevel >= 1 then Wscript.Echo "Got [" & objArgs(ArgCnt) & "] as [Destination Path]"
		strDPath = objArgs(ArgCnt)
	end if
Next
If DebugLevel >= 1 then Wscript.Echo "Trying [" & strSPath & strSFile & "] to [" & strDPath & strSFile & "]"
RetVal = fso.CopyFile(strSPath & strSFile , strDPath & strSFile , true)
If DebugLevel >= 1 then Wscript.Echo "Got RetVal of [" & trim(cstr(RetVal)) & "]"

ShutDown 0

'**************************************************************************************

Sub ShutDown(ErrorToReturn)
' Called to gracefully end the script
   Dim btn
   On Error Resume Next
   'Wscript.Echo Time & " - Script Ends."
   'Wscript.Echo Time & " - Total Logon Script Time is " & DateDiff("s", StartTime, Time) & " seconds."
   ' Delete any objects we may have connected to
   WScript.DisconnectObject WshSh
   WScript.DisconnectObject objNet
   WScript.DisconnectObject fso
   WScript.DisconnectObject objArgs
   ' End the Script
   WScript.Quit ErrorToReturn
End Sub  

'************************************************************************************
