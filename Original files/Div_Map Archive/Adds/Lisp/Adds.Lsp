(princ "\nLoading Adds.")					; Code Version Indicator {579 Lines of Code}

(setq	LodVer	"16.0.0")

(defun-q C:Do_Adds_Up ( /	Dcl_FL Dcl_ID ans )	; Dialog version of Adds_Up entry!
	(if (= panlst nil)
		(if (setq Dcl_FL (findfile (strcat _Path-LISP "Adds.dcl")))
			(if (> (setq Dcl_ID (load_dialog Dcl_FL)) 0)
				(progn
					(if (new_dialog "AddsUp" Dcl_ID)
						(progn
							(action_tile "Yes_Key" "(done_dialog 3)")
							(action_tile "No_Key" "(done_dialog 2)")
							(action_tile "Can_Key" "(done_dialog 1)")
							(setq ans (start_dialog))
						)
					)
					(unload_dialog Dcl_ID)
				)
				(alert "ERROR:  Opening Dialogue Box File..!")
			)
			(alert "ERROR:  Locating Dialogue Box File..!")
		)
		(setq	ans	nil)
	)
	(if Ans
		(if (= Ans 3)
			(AddsUpGather)
			(if (= Ans 2)
				(princ "\nAddsUp Stopped")
				(alert "\nAddsUp error")
			)
		)
	)
	(princ)
)

(defun-q Cb_MouseKey ( Number / Bubba MousData )	; Call Back function for ResetDig (Digitizer)
	(setq	MousData	(get_tile "MouseKey"))
	(if (= MousData "1")
		(progn
			(setq	URx		nil
					URy		nil
					IsMouse	"1"
					Mouse	"Yes"
					Bubba	(if Bug (princ "\nIsMouse set-1"))
			)
			(set_tile "DigiKey" "0")
			(mode_tile "1117Key" 1)
			(mode_tile "2030Key" 1)
			(mode_tile "3040Key" 1)
		)
	)
)

(defun-q Cb_DigiKey ( Number / Bubba DigiData )	; Call Back function for ResetDig (Digitizer)
	(setq	DigiData	(get_tile "DigiKey"))
	(if (= DigiData "1")
		(progn
			(setq	URx		17.0
					URy		11.0
					IsMouse	"0"
					Mouse	nil
					Bubba	(if Bug (princ "\nIsMouse set-0"))
			)
			(set_tile "MouseKey" "0")
			(mode_tile "1117Key" 0)
			(mode_tile "2030Key" 0)
			(mode_tile "3040Key" 0)
		)
	)
)

(defun-q Cb_1117Key ( Number / )				; Call Back function for ResetDig (Digitizer)
	(setq	URx	17.0
			URy	11.0
	)
	(set_tile "2030Key" "0")
	(set_tile "3040Key" "0")
)

(defun-q Cb_2030Key ( Number / )				; Call Back function for ResetDig (Digitizer)
	(setq	URx	30.0
			URy	20.0
	)
	(set_tile "1117Key" "0")
	(set_tile "3040Key" "0")
)

(defun-q Cb_3040Key ( Number / )				; Call Back function for ResetDig (Digitizer)
	(setq	URx	40.0
			URy	30.0
	)
	(set_tile "1117Key" "0")
	(set_tile "2030Key" "0")
)

(defun-q ResetDig ( / Bubba Dcl_ID dlg )		; Re-creates Pointing device keys in Acad14.cfg
	(setq	dlg		5)
	(if (> (setq Dcl_ID (load_dialog (strcat _PATH-LISP "Adds.dcl"))) 0)
		(while (> dlg 2)
			(new_dialog "DigSet" Dcl_ID)
			(if (= (get_tile "MouseKey") "1")
				(progn
					(mode_tile "1117Key" 1)
					(mode_tile "2030Key" 1)
					(mode_tile "3040Key" 1)
				)
			)
			(Cb_MouseKey Number)
			(action_tile "MouseKey"			"(Cb_MouseKey Number)")
			(action_tile "DigiKey"			"(Cb_DigiKey Number)")
			(action_tile "1117Key"			"(Cb_1117Key Number)")
			(action_tile "2030Key"			"(Cb_2030Key Number)")
			(action_tile "3040Key"			"(Cb_3040Key Number)")
			(action_tile "cancel_button"	"(done_dialog 0)")
			(action_tile "ok_button"		"(done_dialog 1)")
			(setq dlg (start_dialog))
		)
	)
	(if (null IsMouse)
		(if (= (get_tile "MouseKey") "1")
			(setq	IsMouse	"1"
					Bubba	(if Bug (princ "\nIsMouse reset-1"))
			)
			(setq	IsMouse	"0"
					Bubba	(if Bug (princ "\nIsMouse reset-0"))
			)
		)
	)
	(unload_dialog Dcl_ID)
	(if (= dlg 1)
		(progn
			(if (not (= (getcfg "AppData/Adds/MouseTest") "1"))
				(setcfg "AppData/Adds/MouseTest" "1")
			)
			(if (= IsMouse "1")
				(setcfg "AppData/Adds/MouseLoad" "1")
				(progn
					(setcfg "AppData/Adds/MouseLoad" "0")
					(setcfg "AppData/Adds/DigiURx" (rtos URx 2 2))
					(setcfg "AppData/Adds/DigiURy" (rtos URy 2 2))
				)
			)
			(if (and Bug (= IsMouse "1"))
				(princ "\nIt's a mouse, dang it!")
				(if (and Bug (= IsMouse "0"))
					(princ (strcat "\nIt's a digitizer with size of " (rtos URx 2 2) "," (rtos URy 2 2)))
				)
			)
		)
		(princ "\nPointer choice cancelled")
	)
	IsMouse
)

(defun-q SetLin	( AppNam AppMode / )		; Defines status line for Application
	(if Bug (princ "\n{SetLin entered\n"))
	(setvar	"USERS1" AppNam)
	(setvar	"USERS2" AppMode)
	(if Div
		(setvar "USERS3" Div)
		(setvar "USERS3" "Unk")
	)
	(setvar	"MODEMACRO"
		(strcat
			"Lay: $(substr,$(getvar,CLAYER),1,11)"
			"$(substr,             ,1,$(-,12,$(strlen,$(getvar,clayer))))"
			"App: <$(getvar,USERS1)>"
			"$(substr,           ,1,$(-,11,$(strlen,$(getvar,USERS1))))"
;;;			"Mode: <$(getvar,USERS2)>"
;;;			"$(substr,    ,1,$(-,4,$(strlen,$(getvar,USERS2))))"
			"Div: <$(getvar,USERS3)>"
			"$(substr,    ,1,$(-,4,$(strlen,$(getvar,USERS3))))"
			"Scale: <$(rtos,$(getvar,THICKNESS),2,0)>"
			"$(substr,     ,1,$(-,5,$(strlen,$(rtos,$(getvar,THICKNESS),2,0))))"
			"$(getvar,USERS5)"
		)
	)
	(if Bug (princ "\nSetLin exited}\n"))
)

(princ ".")

(defun-q FreshDwg ( / EMax EMin )				; Sets up environment in each new dwg
	(setvar "APERTURE" 10)
	(setvar "CMDECHO" 0)
	(setvar "EXPERT" 1)
	(setvar "GRIDMODE" 0)
	(setvar "LTSCALE" 304.8)
	(setvar "MENUECHO" 1)
	(if MyPick
		(setvar "PICKBOX" MyPick)
		(setvar "PICKBOX" 5)
	)
	(setvar "PLINETYPE" 0)
	(setvar "SAVETIME" 0)
	(setvar "SORTENTS" 20)
	(setvar "UCSICON" 0)
	(setvar "GRIPS" 1)
	(setvar "BLIPMODE" 0)
	(command "_.Undefine" "NEW")
	(command "_.Undefine" "END")
	(command "_.Undefine" "QUIT")
	(command "_.Undefine" "OPEN")
	(command "_.Undefine" "SAVE")
	(command "_.Undefine" "SAVEAS")
	(command "_.Undefine" "LINE")
	(command "_.Undefine" "SCALE")
	(command "_.Undefine" "REPEAT")
	(command "_.Style" "STANDARD" "ROMANS" 0.0 1.0 0.0 "N" "N" "N")
	(command)
	(command "_.Viewres" "y" "8000")
	(command)
	
	(princ	(strcat	"\nStarting " AppNam " Now..."))
	(setq AcadVersion (substr (getvar "ACADVER") 1 4))
	
	;	Calls Splash Screen base on version
	(cond 
		((OR(= AcadVersion "18.2") (= AcadVersion "23.0") (= AcadVersion "24.2"))
			(if (null DisplaySplash2)			
				(command "netload" "C:\\Div_Map\\Common\\Adds.dll")
			)
			(DisplaySplash_2012 AppNam)
		)
		(T
			(c:DoSplash)
 		)
	)
	;	Sets user variable for dragging attributes?
	(cond
		((= (strcase (substr AppNam 1 5)) "ADDS ")
			(if (null DRAGATT)
				(toggle "DRAGATT")
			)
		)
	)
	(setq	Amode	"STARTUP")
	
	;	Checks to see it the user is a valid ADDs poster
	(if (/= Div "GA")
		(progn
			(Bld_Vld_MPG)
			(if Lst_Vld_MPG
				(if (assoc (strcase (getvar "LOGINNAME")) Lst_Vld_MPG)
					(setq	Vld_MPG	(assoc (strcase (getvar "LOGINNAME")) Lst_Vld_MPG))
					(setq	Vld_MPG	nil)
				)
				(setq	Vld_MPG	nil)
			)
			(if (not Vld_MPG)
				(progn
					(alert (strcat "*** " AppNam " Operator Error ***\n*Not* an Authorized MPG Poster: {" (strcase (getvar "LOGINNAME")) "}"))
		;			(command "_.Quit" "Y")
				)
			)
		)
	)
	;	Checks if scale information layer exists.
	(if (LayChk "----SC----")
		(command "-LAYER" "S" "0" "F" "----SC----" "") ; Sets current layer to 0 and freezes the scale information layer 
		(command "-LAYER" "S" "0" "")
	)
	(command)
	(setq	olderr	*error*
			*error*	S:err
	)
	
	(if (and (or MyLoginObj MyLoginObj_2012)(not MyUsrInfo))
		(AppndLognDat)		;	Appends Login.INI info to the end of Div_Map.INI if needed
	)
	;	Calls database login dialog box based on AutoCad Version & stores login information.
	(setq	MyUsrInfo		(MyLoginObj AppDbNam))
	
	(if MyUsrInfo
		(if (= (car MyUsrInfo) 1)
			(princ (strcat "\nLogged into {" (nth 1 MyUsrInfo) "} as {" (nth 2 MyUsrInfo) "} with role {" (nth 4 MyUsrInfo) "}"))
			(progn
				(alert (strcat "*** " AppNam " Login Error ***\n*Not* an Authorized Oracle Login: {" (strcase (getvar "LOGINNAME")) "} to instance [" (cadr MyUsrInfo) "]"))
				(command "_.Quit" "Y")
			)
		)
	)
	(if (= AppNam "Adds 19.00")
		(MonitorWorkspaceChange)
	)
	(tables)	;	Runs all List Building Routines
	(subload)	; 	Builds a list of substation names
	(princ)
)

(defun-q C:ModeE ( / )						; Sets Existing Mode
	(setq	AppMode	"E")
	(setvar "USERS2" "E")
	(princ "\nMode is Existing.")
	(princ)
)

(defun-q C:ModeI ( / )						; Sets Install Mode
	(setq	AppMode	"I")
	(setvar "USERS2" "I")
	(princ "\nMode is Install.")
	(princ)
)

(defun-q C:ModeC ( / )						; Sets Change Mode
	(setq	AppMode	"C")
	(setvar "USERS2" "C")
	(princ "\nMode is Change.")
	(princ)
)

(defun-q C:ModeR ( / )						; Sets Replace Mode
	(setq	AppMode	"R")
	(setvar "USERS2" "R")
	(princ "\nMode is Remove.")
	(princ)
)

(princ ".")

(defun-q C:MenuSet ( / )					; CL - Rebuilds Menu Settings
	(princ (strcat "\nNow testing & loading the menus of " AppNam))
	(MenuSet)
	(princ)
)

(defun-q MenuSet ( / )						; Rebuilds Menu Settings
	(cond
		((= (substr (getvar "ACADVER") 1 4) "16.1")			;	AutoCAD 2005
			(setq	LogNam	(getvar "LOGINNAME"))
		 	(setq	ButtRelod	nil)
			(if (vl-file-systime "C:\\Div_Map\\Buttons.MnL")
				(setq	LocMnL	"C:\\Div_Map\\Buttons.MnL"
						LocMnS	"C:\\Div_Map\\Buttons.MnS"
				)
				(if (vl-file-systime "H:\\Div_Map\\Buttons.MnL")
					(setq	LocMnL	"H:\\Div_Map\\Buttons.MnL"
							LocMnS	"H:\\Div_Map\\Buttons.MnS"
					)
					(if (vl-file-systime (strcat PrmRootPath "Buttons.MnL"))
						(setq	LocMnL	(strcat PrmRootPath "Buttons.MnL")
								LocMnS	(strcat PrmRootPath "Buttons.MnS")
						)
						(setq	LocMnL	nil
								LocMnS	nil
						)
					)
				)
			)
			(if (vl-file-systime "C:\\Program Files\\Autodesk\\Autodesk Map 3D 2005\\UserDataCache\\Support\\Buttons.MnS")
				(setq	TLocMnL	"C:\\Program Files\\Autodesk\\Autodesk Map 3D 2005\\UserDataCache\\Support\\Buttons.MnL"
						TLocMnS	"C:\\Program Files\\Autodesk\\Autodesk Map 3D 2005\\UserDataCache\\Support\\Buttons.MnS"
				)
				(setq	TLocMnL	nil
						TLocMnS	nil
				)
			)
			(if LocMnS
				(if TLocMnS
					(if (and (not ButtRelod) LocMnL TLocMnL)
						(if	(not	(equal	(vl-file-systime LocMnL)
										(vl-file-systime TLocMnL)
								)
							)
							(progn
								(princ "\nUpdating Buttons.MnL...")
								(setq	ButtRelod	T)
								(if (menugroup "Buttons")
									(command "_.MenuUnLoad" "Buttons")
								)
								(vl-file-delete TLocMnS)
								(vl-file-copy LocMnS TLocMnS)
								(vl-file-delete TLocMnL)
								(vl-file-copy LocMnL TLocMnL)
								(command "_.MenuLoad" (findfile TLocMnS))
							)
						)
					)
					(progn
						(princ "\nCopying Buttons.MnL...")
						(setq	ButtRelod	T)
						(if (menugroup "Buttons")
							(command "_.MenuUnLoad" "Buttons")
						)
						(vl-file-copy LocMnS TLocMnS)
						(vl-file-copy LocMnL TLocMnL)
						(command "_.MenuLoad" (findfile TLocMnS))
					)
				)
			)
			(if (not (menugroup "Buttons"))
				(if (findfile (strcat "C:\\Documents and Settings\\" LogNam "\\Application Data\\Autodesk\\Autodesk Map 3D 2005\\R16.1\\enu\\Support\\Buttons.MnS"))
					(command "_.MenuLoad" (findfile (strcat "C:\\Documents and Settings\\" LogNam "\\Application Data\\Autodesk\\Autodesk Map 3D 2005\\R16.1\\enu\\Support\\Buttons.MnS")))
				)
			)
			(setq	LogNam	nil
					LocMnL	nil
					LocMnS	nil
			)
			(if (not (menugroup "Express"))
				(if (findfile "C:\\Program Files\\Autodesk\\Autodesk Map 3D 2005\\UserDataCache\\Support\\acetmain.mns")
					(command "_.MenuLoad" "C:\\Program Files\\Autodesk\\Autodesk Map 3D 2005\\UserDataCache\\Support\\acetmain.mns")
				)
			)
			(if (not (menugroup "Acad"))
				(if (findfile "C:\\Program Files\\Autodesk\\Autodesk Map 3D 2005\\UserDataCache\\Support\\acad.mns")
					(command "_.MenuLoad" "C:\\Program Files\\Autodesk\\Autodesk Map 3D 2005\\UserDataCache\\Support\\acad.mns")
				)
			)
			(if (not (menugroup "AcMap"))
				(if (findfile "C:\\Program Files\\Autodesk\\Autodesk Map 3D 2005\\UserDataCache\\Support\\AcMap.mns")
					(command "_.MenuLoad" "C:\\Program Files\\Autodesk\\Autodesk Map 3D 2005\\UserDataCache\\Support\\AcMap.mns")
				)
			)
		)
	)
	(if (not (menugroup "Buttons"))
		(if (findfile (strcat _Path-Person "Buttons.mns"))
			(progn
				(command "menuload" (strcat _Path-Person "Buttons.mns"))
				(menucmd "b1=+Buttons.buttons1")
				(menucmd "b2=+Buttons.buttons2")
				(menucmd "b3=+Buttons.buttons3")
				(menucmd "b4=+Buttons.buttons4")
				(menucmd "a1=+Buttons.aux1")
				(menucmd "a2=+Buttons.aux2")
				(menucmd "a3=+Buttons.aux3")
				(menucmd "a4=+Buttons.aux4")
				(menucmd "P16=-")
				(menucmd "P15=-")
				(menucmd "P14=-")
				(menucmd "P13=-")
				(menucmd "P12=-")
				(menucmd "P11=-")
				(menucmd "P10=-")
				(menucmd "P9=-")
				(menucmd "P8=-")
				(menucmd "P7=-")
				(menucmd "p0=Adds30.pop0")
				(menucmd "p1=Adds30.pop1")
				(menucmd "p2=Adds30.pop2")
				(menucmd "p3=Adds30.pop3")
				(menucmd "p4=Adds30.pop4")
				(menucmd "p5=Adds30.pop5")
				(menucmd "p6=Adds30.pop6")
			)
			(progn
				(menucmd "b1=Adds30.buttons1")
				(menucmd "b2=Adds30.buttons2")
				(menucmd "b3=Adds30.buttons3")
				(menucmd "b4=Adds30.buttons4")
				(menucmd "a1=Adds30.aux1")
				(menucmd "a2=Adds30.aux2")
				(menucmd "a3=Adds30.aux3")
				(menucmd "a4=Adds30.aux4")
				(menucmd "P16=-")
				(menucmd "P15=-")
				(menucmd "P14=-")
				(menucmd "P13=-")
				(menucmd "P12=-")
				(menucmd "P11=-")
				(menucmd "P10=-")
				(menucmd "P9=-")
				(menucmd "P8=-")
				(menucmd "P7=-")
				(menucmd "p0=Adds30.pop0")
				(menucmd "p1=Adds30.pop1")
				(menucmd "p2=Adds30.pop2")
				(menucmd "p3=Adds30.pop3")
				(menucmd "p4=Adds30.pop4")
				(menucmd "p5=Adds30.pop5")
				(menucmd "p6=Adds30.pop6")
			)
		)
		(progn
			(menucmd "b1=Buttons.buttons1")
			(menucmd "b2=Buttons.buttons2")
			(menucmd "b3=Buttons.buttons3")
			(menucmd "b4=Buttons.buttons4")
			(menucmd "a1=Buttons.aux1")
			(menucmd "a2=Buttons.aux2")
			(menucmd "a3=Buttons.aux3")
			(menucmd "a4=Buttons.aux4")
			(menucmd "P16=-")
			(menucmd "P15=-")
			(menucmd "P14=-")
			(menucmd "P13=-")
			(menucmd "P12=-")
			(menucmd "P11=-")
			(menucmd "P10=-")
			(menucmd "P9=-")
			(menucmd "P8=-")
			(menucmd "P7=-")
			(menucmd "p0=Adds30.pop0")
			(menucmd "p1=Adds30.pop1")
			(menucmd "p2=Adds30.pop2")
			(menucmd "p3=Adds30.pop3")
			(menucmd "p4=Adds30.pop4")
			(menucmd "p5=Adds30.pop5")
			(menucmd "p6=Adds30.pop6")
		)
	)
)

(defun-q Tst_For_Common ( /	AcadObj			; Tests for the existence of the Common Path...
				PrfDisplayObj PrfFilesObj PrfOpnSavObj PrfProfObj PrfSystemObj SuppPth Bubba )
	(if (not (wcmatch (strcase (getvar "ACADPREFIX")) "*S:\\WORKGR*"))
		(cond
			((= (substr (getvar "ACADVER") 1 4) "16.0")			;	AutoCAD 2004
				(setq	AcadObj	(vlax-get-acad-object))
				(if AcadObj
					(setq	AppObj		(vlax-get AcadObj "Preferences")
							PrfFilesObj	(vlax-get AppObj "Files")
							PrfDisplayObj	(vlax-get AppObj "Display")
							PrfOpnSavObj	(vlax-get AppObj "OpenSave")
							PrfProfObj	(vlax-get AppObj "Profiles")
							PrfSystemObj	(vlax-get AppObj "System")
					)
					(setq	AppObj	nil
							SuppPth	nil
					)
				)
				(if	(and	AppObj
						(vl-file-directory-p	"C:\\Program Files\\AutoDesk Map 5\\Support")
						(vl-file-directory-p	"C:\\Program Files\\AutoDesk Map 5\\Fonts")
						(vl-file-directory-p	"C:\\Program Files\\AutoDesk Map 5\\Help")
						(vl-file-directory-p	"C:\\Program Files\\Common Files\\Autodesk Shared\\GIS\\ImportExport\\1.0")
						(vl-file-directory-p	"C:\\Program Files\\Autodesk Map 5\\drv")
					)
					(setq	SuppPth	(strcat	"C:\\Program Files\\AutoDesk Map 5\\Support;"
											"C:\\Program Files\\AutoDesk Map 5\\Fonts;"
											"C:\\Program Files\\AutoDesk Map 5\\Help;"
											"C:\\Program Files\\Common Files\\Autodesk Shared\\GIS\\ImportExport\\1.0;"
											"C:\\Program Files\\Autodesk Map 5\\drv"
									)
					)
					(setq	SuppPth	nil)
				)
				(if	(and	SuppPth
						(vl-file-directory-p	"C:\\Program Files\\AutoDesk Map 5\\Express")
					)
					(setq	SuppPth	(strcat	"C:\\Program Files\\AutoDesk Map 5\\Express;"
											SuppPth
									)
					)
				)
				(if	(and	SuppPth
						(vl-file-directory-p	"C:\\Program Files\\CADOverlay 2002\\Help")
					)
					(setq	SuppPth	(strcat	"C:\\Program Files\\CADOverlay 2002\\Help;"
											SuppPth
									)
					)
				)
				(if DevMark
					(if	(and	SuppPth
							(vl-file-directory-p	(strcat TestPrmRootPath "Common"))
						)
						(setq	SuppPth	(strcat	TestPrmRootPath "Common;"
												SuppPth
										)
						)
					)
					(if	(and	SuppPth
							(vl-file-directory-p	(strcat PrmRootPath "Common"))
						)
						(setq	SuppPth	(strcat	PrmRootPath "Common;"
												SuppPth
										)
						)
					)
				)
				(if	(and	SuppPth
						(vl-file-directory-p	"H:\\Div_Map\\Common")
					)
					(setq	SuppPth	(strcat	"H:\\Div_Map\\Common;"
											SuppPth
									)
					)
				)
				(if	(and	SuppPth
						(vl-file-directory-p	"C:\\Div_Map\\Common")
					)
					(setq	SuppPth	(strcat	"C:\\Div_Map\\Common;"
											SuppPth
									)
					)
				)
				(if	(and	SuppPth
						PrfFilesObj
					)
					(setq	Bubba	(vlax-put PrfFilesObj "SupportPath" SuppPth)
							Bubba	(princ (strcat "\nUpdated SupportPath!{" SuppPth "}\n"))
					)
				)
			)
			((wcmatch (strcase (getvar "ACADVER")) "15.06")		;	AutoCAD 2002
				(setq	AcadObj	(vlax-get-acad-object))
				(if AcadObj
					(setq	AppObj		(vlax-get AcadObj "Preferences")
							PrfFilesObj	(vlax-get AppObj "Files")
							PrfDisplayObj	(vlax-get AppObj "Display")
							PrfOpnSavObj	(vlax-get AppObj "OpenSave")
							PrfProfObj	(vlax-get AppObj "Profiles")
							PrfSystemObj	(vlax-get AppObj "System")
					)
					(setq	AppObj	nil
							SuppPth	nil
					)
				)
				(if	(and	AppObj
						(vl-file-directory-p	"C:\\Program Files\\AutoDesk Map 5\\Support")
						(vl-file-directory-p	"C:\\Program Files\\AutoDesk Map 5\\Fonts")
						(vl-file-directory-p	"C:\\Program Files\\AutoDesk Map 5\\Help")
						(vl-file-directory-p	"C:\\Program Files\\Common Files\\Autodesk Shared\\GIS\\ImportExport\\1.0")
						(vl-file-directory-p	"C:\\Program Files\\Autodesk Map 5\\drv")
					)
					(setq	SuppPth	(strcat	"C:\\Program Files\\AutoDesk Map 5\\Support;"
											"C:\\Program Files\\AutoDesk Map 5\\Fonts;"
											"C:\\Program Files\\AutoDesk Map 5\\Help;"
											"C:\\Program Files\\Common Files\\Autodesk Shared\\GIS\\ImportExport\\1.0;"
											"C:\\Program Files\\Autodesk Map 5\\drv"
									)
					)
					(setq	SuppPth	nil)
				)
				(if	(and	SuppPth
						(vl-file-directory-p	"C:\\Program Files\\AutoDesk Map 5\\Express")
					)
					(setq	SuppPth	(strcat	"C:\\Program Files\\AutoDesk Map 5\\Express;"
											SuppPth
									)
					)
				)
				(if	(and	SuppPth
						(vl-file-directory-p	"C:\\Program Files\\CADOverlay 2002\\Help")
					)
					(setq	SuppPth	(strcat	"C:\\Program Files\\CADOverlay 2002\\Help;"
											SuppPth
									)
					)
				)
				(if DevMark
					(if	(and	SuppPth
							(vl-file-directory-p	(strcat	TestPrmRootPath "Common"))
						)
						(setq	SuppPth	(strcat	TestPrmRootPath "Common;"
												SuppPth
										)
						)
					)
					(if	(and	SuppPth
							(vl-file-directory-p	(strcat PrmRootPath "Common"))
						)
						(setq	SuppPth	(strcat	PrmRootPath "Common;"
												SuppPth
										)
						)
					)
				)
				(if	(and	SuppPth
						(vl-file-directory-p	"H:\\Div_Map\\Common")
					)
					(setq	SuppPth	(strcat	"H:\\Div_Map\\Common;"
											SuppPth
									)
					)
				)
				(if	(and	SuppPth
						(vl-file-directory-p	"C:\\Div_Map\\Common")
					)
					(setq	SuppPth	(strcat	"C:\\Div_Map\\Common;"
											SuppPth
									)
					)
				)
				(if	(and	SuppPth
						PrfFilesObj
					)
					(setq	Bubba	(vlax-put PrfFilesObj "SupportPath" SuppPth)
							Bubba	(princ (strcat "\nUpdated SupportPath!{" SuppPth "}\n"))
					)
				)
			)
			((and (wcmatch (strcase (getvar "ACADVER")) "14.0") (not DevMark))	;	AutoCAD r14 February 1997
				(alert (strcat "***" AppNam " Error!***\nCommon Path not loading correctly!\nAttempting to fix..."))
				(if (findfile (strcat PrmRootPath "Common\\SCS_COMM.ARX"))
					(arxload (strcat PrmRootPath "Common\\SCS_COMM.ARX"))
				)
				(C:SCSetCommon)
				(if (wcmatch (strcase (getvar "ACADPREFIX")) "*S:\\WORKGR*")
					(progn
						(alert (strcat "***" AppNam " Fix Successfull!***\nCommon Path now loaded correctly!\nExiting..."))
						(if (> (getvar "DBMOD") 0)
							(command "_.Quit" "Y")
							(command "_.Quit")
						)
					)
					(alert (strcat "***" AppNam " UnSuccessfull!***\nCommon Path not found!\nExiting..."))
				)
				(exit)
			)
		)
	)
	(princ)
)

(defun-q AddsGo ( /	LodNam LodGet )		; Adds Initialization Function, starts environment
	(setvar "CMDECHO" 0)
	(Command "LOGFILEON")
	(foreach	LodNam
			(list "Acad_ADO" "Att_Chg" "DLGLod" "Get_Init" "GetPoints" "Julian" "OracleFun" "Lin_Txt" "Property" "Switch" "Symbols" "Tables" "Utils")
			(setq	LodGet	(LodStage2 LodNam))
			(if (and LodGet LodLst)
				(setq	LodLst	(cons LodGet LodLst))
			)
	)
	(AppndAddsDat)
	(Init_INI)
	(foreach	LodNam
			(list "ChgFdr" "Commands" "Common" "EditSym" "Fnct1" "Layers" "Panel")
			(setq	LodGet	(LodStage2 LodNam))
			(if (and LodGet LodLst)
				(setq	LodLst	(cons LodGet LodLst))
			)
	)
;	(setq sym-oh (list "CS" "GS" "RECL" "CAP" "REG" "REGA"))
;	(setq sym-ug (list "CR" "DR" "GR" "UGOPEN" "RISER" "U"))
	(DivGet)
	
	(if (= Div "AL")
		(progn
			(setq  XPanel 60000
				  YPanel 40000
			)
		)
		(progn
			(setq  XPanel 6000
				  YPanel 4000
			)
		)
	)
	(SetLin AppNam AppMode)
	(if (= (getcfg "AppData/Adds/MouseTest") "1")
		(if (= (getcfg "AppData/Adds/MouseLoad") "1")
			(setq	Mouse	"Yes")
			(if (= (getcfg "AppData/Adds/MouseLoad") "0")
				(setq	Mouse	"No"
						URx		(atof (getcfg "AppData/Adds/DigiURx"))
						URy		(atof (getcfg "AppData/Adds/DigiURy"))
				)
				(if (= (ResetDig) "1")
					(setq	Mouse	"Yes")
					(setq	Mouse	"No"
							URx		(atof (getcfg "AppData/Adds/DigiURx"))
							URy		(atof (getcfg "AppData/Adds/DigiURy"))
					)
				)
			)
		)
		(if (= (ResetDig) "1")
			(setq	Mouse	"Yes")
			(setq	Mouse	"No"
					URx		(atof (getcfg "AppData/Adds/DigiURx"))
					URy		(atof (getcfg "AppData/Adds/DigiURy"))
			)
		)
	)
	(if (dos_getini "Common" "PickTest" (strcat _Path-Person "DIV_MAP.INI"))
		(if (not (equal (dos_getini "Common" "PickTest" (strcat _Path-Person "DIV_MAP.INI")) "default"))
			(setq	MyPick	(atoi (dos_getini "Common" "PickVal" (strcat _Path-Person "DIV_MAP.INI"))))
			(setq	MyPick	(ResetPick))
		)
		(setq	MyPick	(ResetPick))
	)
;	(MenuSet)
;	(TABLES)  test
	(if Div
		(if (AND (/= Div "AL") (/= Div "GA"))
			(progn
				(quadload)
			)
		)
	)
;	(subload)  test
	(if (not DevMark)
		(DivGetUnix Div)
	)
	(FreshDwg)
	(princ)
)

(defun-q ShwTB ( / )						; Toggles Toolbar visibility
	(setq	TB_St	(getvar "CMDDIA"))
	(if (< (getvar "CMDDIA") 1) (setvar "CMDDIA" 1))
	(command "TOOLBAR")
	(setvar "CMDDIA" TB_St)
	(princ)
)

(princ ".")
