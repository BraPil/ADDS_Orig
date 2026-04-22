(defun Acad_SCS_Init ( / )					; Initialization ID Line
	(vlisp-import-symbol 'AppNam)
	(if AppNam
		(princ (strcat "\n" AppNam " Acad_SCS Loading."))
		(progn
			(setq	AppNam	"Adds 2.59a")
			(princ (strcat "\n" AppNam " Acad_SCS Loading."))
		)
	)
	(if (not (vl-registry-descendents "HKEY_CLASSES_ROOT\\Acad_SCS.SCS_About" nil))
		(LoadPrepSCS AppNam)
	)
	(setq	AppLst	(VGetPrefs)
			AppDir	(StpDot AppNam)
			LodVer	"2.5.9c"
	)
	(vlisp-export-symbol 'AppLst)
	(vlisp-import-symbol 'DevMark)
	(SetProfSCS AppNam AppLst DevMark)
	(vl-acad-defun 'C:DoAbout)
	(vl-acad-defun 'C:DoSplash)
	(vl-acad-defun 'C:TestProfs)
	(vl-acad-defun 'C:VerPrefs)
	(vl-acad-defun 'C:MakeItHappen)
	(vl-acad-defun 'GetProf)
	(vl-acad-defun 'C:AddsMapDrive)
	(vlisp-export-symbol 'LodVer)
;;;	(vl-acad-defun 'AddsUpAnalyze)
;;;	(vl-acad-defun 'AddsUpMerge)
;;;	(vl-acad-defun 'BldMstPLst)
;;;	(vl-acad-defun 'CalcArcLen)
;;;	(vl-acad-defun 'Date_S)
;;;	(vl-acad-defun 'GetPLen)
;;;	(vl-acad-defun 'PadChar)
;;;	(vl-acad-defun 'PadCharL)
;;;	(vl-acad-defun 'PadCharLX)
;;;	(vl-acad-defun 'PadCharR)
;;;	(vl-acad-defun 'PadCharRX)
;;;	(vl-acad-defun 'PExtent)
;;;	(vl-acad-defun 'ReadNPoly)
;;;	(vl-acad-defun 'ReadOPoly)
;;;	(vl-acad-defun 'RepChar)
;;;	(vl-acad-defun 'RevBlg)
;;;	(vl-acad-defun 'RevBlgLst)
;;;	(vl-acad-defun 'StpVrtLst)
;;;	(vl-acad-defun 'Time_S)
)

(defun GetProf ( NewApp /	acadObject		; Swaps current profile...
						acadDocument acadPrefer IsGood )
	(setq	acadObject	(vlax-get-acad-object)
			acadDocument	(vla-get-ActiveDocument acadObject)
			acadPrefer	(vla-get-Preferences acadObject)
			IsGood		(vla-set-ActiveProfile acadPrefer)
	)
	IsGood
)

(defun Delay ( / )							; Timer Function
	(setq	curtime	(* (getvar "DATE") 1e8)
			ritardo	2000
	)
	(while (< (* (getvar "DATE") 1e8) (+ curtime ritardo)))
)

(defun C:Uh_Oh ( /	acadObject acadPrefer WinBackGrnd i )
	(setq	acadObject	(vlax-get-acad-object)
			acadDocument	(vla-get-ActiveDocument acadObject)
			acadPrefer	(vla-get-Preferences acadObject)
			WinBackGrnd	(vla-get-GraphicsWinBackgrndColor acadPrefer)	;get bkgground
			i			0
	)
	(while (< i 10)
		(vla-put-GraphicsWinBackgrndColor acadPrefer i)   ;change bkground
		(setq i (1+ i))
		(delay)
	)
	(vla-put-GraphicsWinBackgrndColor acadPrefer WinBackGrnd)   ;change bkground back
)

(defun C:TBak ( /	acadObject acadPrefer WinBackGrnd i )
	(setq	NTextColr		(getint "\nWhat color for Text?: ")
			NTextColrB	(getint "\nWhat color for TextBack?: ")
			acadObject	(vlax-get-acad-object)
			acadDocument	(vla-get-ActiveDocument acadObject)
			acadPrefer	(vla-get-Preferences acadObject)
			OTextColr		(vla-get-GraphicsTextColor acadPrefer)
			OTextColrB	(vla-get-GraphicsTextBackgrndColor acadPrefer)
			;GraphicsTextBackgrndColor
			;GraphicsTextColor
	)
	(princ (strcat "\nText Color was [" (itoa OTextColr) "] is now [" (itoa NTextColr) "]\n"))
	(vla-put-GraphicsTextColor acadPrefer NTextColr)   ;change bkground back
	(princ (strcat "\nText Color Background was [" (itoa OTextColrB) "] is now [" (itoa NTextColrB) "]\n"))
	(vla-put-GraphicsTextBackgrndColor acadPrefer NTextColrB)   ;change bkground back
	(princ)
)

(defun C:MakeItHappen ( / )
	(Acad_SCS_Init)
	(princ)
)

(defun C:TestProfs ( / )					; Tests profile setting automation
	(vlisp-import-symbol 'AppNam)
	(setq	AppLst	(VGetPrefs))
	(SetProfSCS AppNam AppLst)
	(princ)
)

(defun LoadPrepSCS ( AppNam /	WinDir AppDir	; Copys and registers Acad_SCS.DLL to registry!
							DivDir TstCopy)
	(setq	WinDir	(getenv "WINDIR")
			AppDir	(StpDot AppNam)
			DivDir	(FindAppFile AppDir "MENU" AppDir "MNS")
	)
	(if WinDir
		(setq	WinDir	(strcase (strcat WinDir "\\system32")))
		(princ "\nAcad_SCS:WinDir not found!")
	)
	(if DivDir
		(progn
			(setq	DivDir	(strcase (vl-filename-directory DivDir)))
			(if (setq PosDiv (vl-string-search "DIV_MAP" DivDir))
				(setq	DivDir	(strcat (substr Divdir 1 (+ PosDiv 7)) "\\SUPPORT"))
				(if (setq PosDiv (vl-string-search "DIVMAP10" DivDir))
					(setq	DivDir	(strcat (substr Divdir 1 (+ PosDiv 8)) "\\COMMON"))
					(if (setq PosDiv (vl-string-search "DIVISION" DivDir))
						(setq	DivDir	(strcat (substr Divdir 1 (+ PosDiv 16)) "\\COMMON"))
						(princ (strcat "\nLoadPrepSCS error!\nDivDir:" DivDir "\nPosDiv:" (itoa PosDiv)))
					)
				)
			)
		)
		(princ "\nAcad_SCS:DivDir not found!")
	)
	(if (and (findfile (strcat DivDir "\\acad_scs.dll")) (findfile (strcat DivDir "\\msvbvm50.dll")))
	    	(progn
		     	(if (not (findfile (strcat WinDir "\\acad_scs.dll")))
			    	(vl-file-copy (strcat DivDir "\\acad_scs.dll") (strcat WinDir "\\acad_scs.dll"))
			)
		     	(if (not (findfile (strcat WinDir "\\msvbvm50.dll")))
			    	(vl-file-copy (strcat DivDir "\\msvbvm50.dll") (strcat WinDir "\\msvbvm50.dll"))
			)
		)
		(princ "\nAcad_SCS:DLL's not copied!")
	)
	(if (and (findfile (strcat WinDir "\\acad_scs.dll")) (findfile (strcat WinDir "\\msvbvm50.dll")))
		(progn
			(startapp (strcat DivDir "\\regsvr32 /s " WinDir "\\acad_scs.dll"))
			(princ "\nAcad_SCS.DLL Dynamic Link Library copied and registered!")
		)
		(princ "\nAcad_SCS:DLL's not registered!")
	)
)

(defun SetProfSCS ( AppNam AppLst DevMark /	WinDir	; Loads Profile Settings for session, if changed
									ProgDir AppDir DivDir AcadObj AppObj PosDiv ValProf PWD )
	(setq	WinDir	(getenv "WINDIR")
			ProgDir	(getvar "FONTMAP")
			AppDir	(StpDot AppNam)
			DivDir	(FindAppFile AppDir "MENU" AppDir "MNS")
	)
	(if WinDir
		(setq	WinDir	(strcase (strcat WinDir "\\system32\\")))
	)
	(if ProgDir
		(setq	ProgDir	(strcase (vl-filename-directory ProgDir))
				ProgDir	(if (vl-string-search "SUPPORT" ProgDir)
							(substr ProgDir 1 (vl-string-search "SUPPORT" ProgDir))
							ProgDir
						)
		)
	)
	(if DivDir
		(if DevMark
			(progn
				(setq	DivDir	(strcase (vl-filename-directory DivDir)))
				(if (setq PosDiv (vl-string-search "DIV_MAP" DivDir))
					(setq	DivDir	(substr Divdir 1 (+ PosDiv 7)))
					(if (setq PosDiv (vl-string-search "DIVMAP10" DivDir))
						(setq	DivDir	(substr Divdir 1 (+ PosDiv 8)))
						(if (setq PosDiv (vl-string-search "DIVISION MAPPING TEST" DivDir))
							(setq	DivDir	(substr Divdir 1 (+ PosDiv 21)))
							(if (setq PosDiv (vl-string-search "DIVISION MAPPING" DivDir))
								(setq	DivDir	(substr Divdir 1 (+ PosDiv 16)))
							)
						)
					)
				)
			)
			(progn
				(setq	DivDir	(strcase (vl-filename-directory DivDir)))
				(if (setq PosDiv (vl-string-search "DIV_MAP" DivDir))
					(setq	DivDir	(substr Divdir 1 (+ PosDiv 7)))
					(if (setq PosDiv (vl-string-search "DIVMAP10" DivDir))
						(setq	DivDir	(substr Divdir 1 (+ PosDiv 8)))
						(if (setq PosDiv (vl-string-search "DIVISION MAPPING" DivDir))
							(setq	DivDir	(substr Divdir 1 (+ PosDiv 16)))
						)
					)
				)
			)
		)
	)
	(setq	AcadObj	(vlax-get-acad-object))
	(if AcadObj
		(setq	AppObj	(vlax-get AcadObj "Preferences"))
		(setq	AppObj	nil)
	)
 	(if AppObj
		(if (/= (strcase AppDir) (strcase (nth 0 AppLst)))
			(if (= (strcat (strcase AppDir) "_T") (strcase (nth 0 AppLst)))
			    	(progn
					(princ "\nTest Profile In Use!")
		 	     	(setq	ValProf	T)
				)
			    	(progn
					(princ "\nNot Right Profile Name!")
		 	     	(setq	ValProf	nil)
				)
			)
		    	(progn
	 	     	(setq	ValProf	T)
	 		)
	 	)
	)
	(if (and AppObj ValProf ProgDir WinDir DivDir AppDir )
	    	(progn
	     	(if (vl-file-directory-p (strcat "C:\\" AppDir))
		     	(if (findfile (strcase (strcat "C:\\" AppDir "\\" AppDir ".log")))
				    	(if (not (= (findfile (strcase (strcat "C:\\" AppDir "\\" AppDir ".log"))) (strcase (nth 1 AppLst))))
					    	(progn
					    		(princ "\nCorrect Log File Exists, Not set in Profile")
						     (vlax-put AppObj "LogFileName" (strcase (strcat "C:\\" AppDir "\\" AppDir ".log")))
						)
					)
				)
			    	(progn
			     	(setq	PWD	(dos_pwdir))
			     	(dos_chdir "C:\\")
			     	(dos_mkdir (strcat "C:\\" AppDir))
			     	(dos_chdir PWD)
			    		(princ "\nLog File Created, Now set in Profile")
			     	(vlax-put AppObj "LogFileName" (strcase (strcat "C:\\" AppDir "\\" AppDir ".log")))
				)
			)
			(if (not DevMark)
		     	(if (FindAppFile AppDir "MENU" AppDir "MNS")
				    	(if (not (equal (strcase (FindAppFile AppDir "MENU" AppDir "MNS")) (strcase (strcat (nth 2 AppLst) ".MNS"))))
					    	(progn
					     	(princ "\nCorrect Menu Now Set in Profile")
					     	(vlax-put AppObj "MenuFile" (strcase (FindAppFile AppDir "MENU" AppDir "MNS")))
						)
					)
				)
			)
	     	(if	(not	(or	(vl-string-search "DIV_MAP" (strcase (nth 4 Applst)))
	     				(vl-string-search "DIVMAP" (strcase (nth 4 Applst)))
	     				(vl-string-search "DIVISION" (strcase (nth 4 Applst)))
	     			)
	     		)
			    	(princ "\nSupport Path Not Correctly Defined in Profile!")
			)
	     	(if (not (= (nth 6 AppLst) -1))
			    	(progn
			     	(princ "\nStart-Up Dialog Box Now Correctly Set in Profile!")
			     	(vlax-put AppObj "EnableStartupDialog" -1)
				)
			)
	     	(if (not (= (nth 7 AppLst) 0))
			    	(progn
			     	(princ "\nLisp Persistence Now Correctly Set in Profile!")
			     	(vlax-put AppObj "PersistentLISP" 0)
				)
			)
	     	(if (not (= (nth 8 AppLst) 0))
			    	(progn
			     	(princ "\nAutoSave Time Now Correctly Set in Profile!")
			     	(vlax-put AppObj "AutoSaveInterval" 0)
				)
			)
	     	ValProf
		)
	    	ValProf
	)
)

(defun VGetPrefs ( /	AcadObj AppObj )		; Gets Preference Objects for testing
	(setq	AcadObj	(vlax-get-acad-object))
	(if AcadObj
		(setq	AppObj	(vlax-get AcadObj "Preferences"))
		(setq	AppObj	nil)
	)
	(if AppObj
		(list	(vlax-get AppObj "ActiveProfile")
				(vlax-get AppObj "LogFileName")
				(vlax-get AppObj "MenuFile")
				(vlax-get AppObj "PrintSpoolerPath")
				(vlax-get AppObj "SupportPath")
				(vlax-get AppObj "TempFilePath")
				(vlax-get AppObj "EnableStartupDialog")
				(vlax-get AppObj "PersistentLISP")
				(vlax-get AppObj "AutoSaveInterval")
				(vlax-get AppObj "LogFileOn")
		)
	)
)

(defun TestPath ( AppNam AppMenu /	TstNam	; Tests validity of paths
								TstVal )
	(setq	TstVal	nil)
	(if (> (strlen AppNam) 4)
		(setq	TstNam	(substr AppNam 1 (- (strlen AppNam) 4)))
		(setq	TstNam	nil)
	)
	(if TstNam
		(progn
			(setq	Cnt	0)
			(while (< Cnt (- (strlen AppMenu) (strlen TstNam)))
				(if (equal (strcase TstNam) (strcase (substr AppMenu Cnt (strlen TstNam))))
					(setq	TstVal	T)
				)
				(setq	Cnt	(1+ Cnt))
			)
		)
	)
	TstVal
)

(defun FindAppFile ( AppPth AppDir FilNam FilExt / )	; Tests for known working areas
	(if (and AppPth AppDir FilNam FilExt)
		(if (= (getenv "TEST") "YES")
			(if (findfile (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\" AppPth "\\" AppDir "\\" FilNam "." FilExt))
				(setq	TstVal	(strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\" AppPth "\\" AppDir "\\" FilNam "." FilExt))
				(if (findfile (strcat "S:\\WorkGroups\\APC Power Delivery\\Division Mapping\\" AppPth "\\" AppDir "\\" FilNam "." FilExt))
					(setq	TstVal	(strcat "S:\\WorkGroups\\APC Power Delivery\\Division Mapping\\" AppPth "\\" AppDir "\\" FilNam "." FilExt))
					(if (findfile (strcat "V:\\DivMap10\\" AppPth "\\" AppDir "\\" FilNam "." FilExt))
						(setq	TstVal	(strcat "V:\\DivMap10\\" AppPth "\\" AppDir "\\" FilNam "." FilExt))
						(if (findfile (strcat "J:\\DIV_MAP\\" AppPth "\\" AppDir "\\" FilNam "." FilExt))
							(setq	TstVal	(strcat "J:\\DIV_MAP\\" AppPth "\\" AppDir "\\" FilNam "." FilExt))
							(if (findfile (strcat "C:\\DIV_MAP\\" AppPth "\\" AppDir "\\" FilNam "." FilExt))
								(setq	TstVal	(strcat "C:\\DIV_MAP\\" AppPth "\\" AppDir "\\" FilNam "." FilExt))
								(setq	TstVal	"*Warning!*\nSearch code not found!\nCheck network paths!")
							)
						)
					)
				)
			)
			(if (findfile (strcat "S:\\WorkGroups\\APC Power Delivery\\Division Mapping\\" AppPth "\\" AppDir "\\" FilNam "." FilExt))
				(setq	TstVal	(strcat "S:\\WorkGroups\\APC Power Delivery\\Division Mapping\\" AppPth "\\" AppDir "\\" FilNam "." FilExt))
				(if (findfile (strcat "V:\\DivMap10\\" AppPth "\\" AppDir "\\" FilNam "." FilExt))
					(setq	TstVal	(strcat "V:\\DivMap10\\" AppPth "\\" AppDir "\\" FilNam "." FilExt))
					(if (findfile (strcat "J:\\DIV_MAP\\" AppPth "\\" AppDir "\\" FilNam "." FilExt))
						(setq	TstVal	(strcat "J:\\DIV_MAP\\" AppPth "\\" AppDir "\\" FilNam "." FilExt))
						(if (findfile (strcat "C:\\DIV_MAP\\" AppPth "\\" AppDir "\\" FilNam "." FilExt))
							(setq	TstVal	(strcat "C:\\DIV_MAP\\" AppPth "\\" AppDir "\\" FilNam "." FilExt))
							(setq	TstVal	"*Warning!*\nSearch code not found!\nCheck network paths!")
						)
					)
				)
			)
		)
	)
	TstVal
)

(defun C:VerPrefs ( /	AppLst AppNam )		; Tests and sets Profile settings for SCS Apps
	(vlisp-import-symbol 'AppNam)
	(setq	AppLst	(VGetPrefs))
	(princ (strcat "\nPrefName:\t" (nth 0 AppLst)))
	(if (TestPath AppNam (nth 2 AppLst))
		(princ (strcat "\nMenuFile:\t" (nth 2 AppLst)))
		(princ (strcat "\nInvalid MenuFile:\t" (nth 2 AppLst)))
	)
	(princ (strcat "\nLogFile:\t" (nth 1 AppLst)))
	(princ (strcat "\nPlotPath:\t" (nth 3 AppLst)))
	(princ (strcat "\nAppSupp:\t" (nth 4 AppLst)))
	(princ (strcat "\nAppTemp:\t" (nth 5 AppLst)))
	(princ (strcat "\nAppSDlg:\t" (itoa (nth 6 AppLst))))
	(princ (strcat "\nAppPLsp:\t" (itoa (nth 7 AppLst))))
	(princ (strcat "\nAppSave:\t" (itoa (nth 8 AppLst))))
	(princ)
)

(defun StpDot ( Str / Cnt TmpStr )			; Strips periods and spaces from string
	(setq	Cnt		1
			TmpStr	"X"
	)
	(while (<= Cnt (strlen Str))
		(if	(not	(or	(= (ascii (substr Str Cnt 1)) 32)
					(= (ascii (substr Str Cnt 1)) 34)
					(= (ascii (substr Str Cnt 1)) 40)
					(= (ascii (substr Str Cnt 1)) 41)
					(= (ascii (substr Str Cnt 1)) 46)
				)
			)
			(setq	TmpStr	(strcat TmpStr (strcase (substr Str Cnt 1))))
		)
		(setq	Cnt		(1+ Cnt))
	)
	(if (> (strlen TmpStr) 1)
		(cond
			((wcmatch (substr TmpStr 2 6) "ADDS19")			;	[CET 2019 - Added for AutoCAD 2019]
				(substr TmpStr 2 4)
			)
			((wcmatch (substr TmpStr 2 6) "ADDS16")			;	[CET 2016 - Added for AutoCAD 2016]
				(substr TmpStr 2 4)
			)
			((wcmatch (substr TmpStr 2 6) "ADDS30")
				(substr TmpStr 2 4)
			)
			((wcmatch (substr TmpStr 2 5) "ADDS#")
				(substr TmpStr 2 6)
			)
			((= (substr TmpStr 2 5) "ADDSP")
				(substr TmpStr 2 8)
			)
			((wcmatch (substr TmpStr 2 5) "BEMS#")
				(substr TmpStr 2 4)
			)
			((wcmatch (substr TmpStr 2 7) "CADET[23]#")
				"CADET20"
			)
			((= (substr TmpStr 2 8) "SUBTOOLS")
				(substr TmpStr 2 8)
			)
			(T
				(substr TmpStr 2)
			)
		)
		nil
	)
)

(defun C:DoAbout ( /	AcadObj AboutObj AppNam	; Loads ActiveX About Screen
					Action )
	(setq	AcadObj	(vlax-get-acad-object)
			AboutObj	(vla-getinterfaceobject AcadObj "Acad_SCS.SCS_About")
	)
	(vlisp-import-symbol 'AppNam)
	(if AppNam
		(if (> (strlen AppNam) 5)
			(progn
				(cond	
						((wcmatch (stpdot AppNam) "ADDS##")
							(setq	Action	7)
						)
						((= (strcase (substr AppNam 1 5)) "SUBTO")
							(setq	Action	5)
						)
						((= (strcase (substr AppNam 1 5)) "ADDSP")
							(setq	Action	2)
						)
						((= (strcase (substr AppNam 1 5)) "CADET")
							(setq	Action	4)
						)
						((= (strcase (substr AppNam 1 4)) "BEMS")
							(setq	Action	3)
						)
						((= (strcase (substr AppNam 1 4)) "ADDS")
							(setq	Action	1)
						)
						(T	(setq	Action	0))
				)
				(vlax-invoke AboutObj "DisplayAbout" AppNam Action)
			)
		)
	)
	(princ)
)

(defun C:DoSplash ( /	AcadObj SplashObj		; Loads ActiveX Splash Screen
					AppNam Action )
	(setq	AcadObj	(vlax-get-acad-object)
			SplashObj	(vla-getinterfaceobject AcadObj "Acad_SCS.SCS_Splash")
	)
	(vlisp-import-symbol 'AppNam)
	(if AppNam
		(if (> (strlen AppNam) 5)
			(progn
				(cond	
						((wcmatch (stpdot AppNam) "ADDS##")
							(setq	Action	7)
						)
						((= (strcase (substr AppNam 1 5)) "SUBTO")
							(setq	Action	5)
						)
						((= (strcase (substr AppNam 1 5)) "ADDSP")
							(setq	Action	2)
						)
						((= (strcase (substr AppNam 1 5)) "CADET")
							(setq	Action	4)
						)
						((= (strcase (substr AppNam 1 4)) "BEMS")
							(setq	Action	3)
						)
						((= (strcase (substr AppNam 1 4)) "ADDS")
							(setq	Action	1)
						)
						(T	(setq	Action	0))
				)
				(vlax-invoke SplashObj "DisplaySplash" AppNam Action)
			)
		)
	)
	(princ)
)

(defun C:DrwColBlk ( / )
	(setq	Cntr		0)
	(repeat	256
			(cond
				((and (>= Cntr 0)(<= Cntr 29))
					(setq	Yb	0.0
							Offs	0
							Xb	(float (- Cntr Offs))
					)
				)
				((and (>= Cntr 30)(<= Cntr 59))
					(setq	Yb	2.0
							Offs	30
							Xb	(float (- Cntr Offs))
					)
				)
				((and (>= Cntr 60)(<= Cntr 89))
					(setq	Yb	4.0
							Offs	60
							Xb	(float (- Cntr Offs))
					)
				)
				((and (>= Cntr 90)(<= Cntr 119))
					(setq	Yb	6.0
							Offs	90
							Xb	(float (- Cntr Offs))
					)
				)
				((and (>= Cntr 120)(<= Cntr 149))
					(setq	Yb	8.0
							Offs	120
							Xb	(float (- Cntr Offs))
					)
				)
				((and (>= Cntr 150)(<= Cntr 179))
					(setq	Yb	10.0
							Offs	150
							Xb	(float (- Cntr Offs))
					)
				)
				((and (>= Cntr 180)(<= Cntr 209))
					(setq	Yb	12.0
							Offs	180
							Xb	(float (- Cntr Offs))
					)
				)
				((and (>= Cntr 210)(<= Cntr 239))
					(setq	Yb	14.0
							Offs	210
							Xb	(float (- Cntr Offs))
					)
				)
				((and (>= Cntr 240)(<= Cntr 255))
					(setq	Yb	16.0
							Offs	240
							Xb	(float (- Cntr Offs))
					)
				)
			)
			(command	"_.Solid"
					(list Xb Yb)
					(list (+ 0.5 Xb) Yb)
					(list Xb (+ Yb 0.5))
					(list (+ 0.5 Xb) (+ Yb 0.5))
					""
			)
			(if (and (> Cntr 0) (< Cntr 256))
				(progn
					(command	"_.Change"
							"L"
							""
							"P"
							"C"
							Cntr
							""
					)
					(command "_.Text" "M" (list (+ 0.25 Xb) (- Yb 0.375)) 0.25 0.0 (itoa Cntr))
				)
				(command "_.Text" "M" (list (+ 0.25 Xb) (- Yb 0.375)) 0.25 0.0 (itoa Cntr))
			)
			(setq	Cntr		(1+ Cntr))
	)
	(princ)
)

(defun MapDrivTst ( /	AcadObj FSO_Obj 		; Verifies FileSystemObject Mapped Drives
			Drive_Obj Drives_Obj Drive_Letter Drive_Type RootFolder Mapped_Prod Mapped_Targ ShareName VolumeName Prod_Targ Prod_Share
			Mapped_Prod_2 Mapped_Targ_2 Prod_Targ_2 Prod_Share_2 ShareName_2 VolumeName_2 )
	(setq	AcadObj		(vlax-get-acad-object)
			FSO_Obj		(vla-getinterfaceobject AcadObj "Scripting.FileSystemObject")
			Drives_Obj	(vlax-get FSO_Obj "Drives")
			Mapped_Prod	nil
			Mapped_Targ	nil
			Mapped_Prod_2	nil
			Mapped_Targ_2	nil
			ShareName		"None"
			VolumeName	"None"
			ShareName_2	"None"
			VolumeName_2	"None"
			Prod_Targ		"M"
			Prod_Share	"\\\\SouthernCo.com\\SHARED DATA\\Workgroups\\APC Power Delivery\\Division Mapping Test"
;;;			Prod_Share	"\\\\alxapsb12\\Adds"
			Prod_Targ_2	"N"
			Prod_Share_2	"\\\\SouthernCo.com\\SHARED DATA\\Temporary User Storage (Deleted each Sunday)\\APC Hq"	;Change by CET 5/3/2014
;;;			Prod_Share_2	"\\\\alsdcsb92\\Adds"
	)
  	(vlax-for	Drive_Obj
		  	Drives_Obj
	  		(setq	Drive_Letter	(vlax-get Drive_Obj "DriveLetter")
					Drive_Type	(vlax-get Drive_Obj "DriveType")
			)
	  		(if (= Drive_Letter Prod_Targ)
			  	(if (= (strcase Prod_Share) (strcase (vlax-get Drive_Obj "ShareName")))
					(setq	Mapped_Prod	T
							Mapped_Targ	T
							ShareName		(vlax-get Drive_Obj "ShareName")
							VolumeName	(vlax-get Drive_Obj "VolumeName")
					)
					(setq	Mapped_Prod	nil
							Mapped_Targ	T
							ShareName		(vlax-get Drive_Obj "ShareName")
							VolumeName	(vlax-get Drive_Obj "VolumeName")
					)
				)
			)
	  		(if (= Drive_Letter Prod_Targ_2)
			  	(if (= (strcase Prod_Share_2) (strcase (vlax-get Drive_Obj "ShareName")))
					(setq	Mapped_Prod_2	T
							Mapped_Targ_2	T
							ShareName_2	(vlax-get Drive_Obj "ShareName")
							VolumeName_2	(vlax-get Drive_Obj "VolumeName")
					)
					(setq	Mapped_Prod_2	nil
							Mapped_Targ_2	T
							ShareName_2	(vlax-get Drive_Obj "ShareName")
							VolumeName_2	(vlax-get Drive_Obj "VolumeName")
					)
				)
			)
	)
	(setq	Drives_Obj	nil
			Drive_Obj		nil
			FSO_Obj		nil
			AcadObj		nil
	)
	(list Mapped_Prod Mapped_Targ Prod_Targ Prod_Share ShareName VolumeName Mapped_Prod_2 Mapped_Targ_2 Prod_Targ_2 Prod_Share_2 ShareName_2 VolumeName_2)
)

(defun C:AddsMapDrive ( /	AcadObj Net_Obj 	; Verifies FileSystemObject Mapped Drives
						Ret_Val Mapped_Prod Mapped_Targ Prod_Targ
						Prod_Share ShareName VolumeName )
	(setq	Ret_Val		(MapDrivTst)
			Mapped_Prod	(nth 0 Ret_Val)
			Mapped_Targ	(nth 1 Ret_Val)
			Prod_Targ		(nth 2 Ret_Val)
			Prod_Share	(nth 3 Ret_Val)
			ShareName		(nth 4 Ret_Val)
			VolumeName	(nth 5 Ret_Val)
			Mapped_Prod_2	(nth 6 Ret_Val)
			Mapped_Targ_2	(nth 7 Ret_Val)
			Prod_Targ_2	(nth 8 Ret_Val)
			Prod_Share_2	(nth 9 Ret_Val)
			ShareName_2	(nth 10 Ret_Val)
			VolumeName_2	(nth 11 Ret_Val)
	)
	(if Mapped_Targ
		(if Mapped_Prod
			(princ (strcat "\nTarget Drive [" Prod_Targ ":] is *Correctly* mapped as [" (strcase ShareName) "]"))
			(progn
				(princ (strcat "\nTarget Drive [" Prod_Targ ":] is *InCorrectly* mapped as [" (strcase ShareName) "]"))
				(setq	AcadObj	(vlax-get-acad-object)
						Net_Obj	(vla-getinterfaceobject AcadObj "WScript.Network")
				)
				(if Net_Obj
					(progn
						(setq	Ret_Val	(vlax-invoke Net_Obj "RemoveNetworkDrive" (strcat Prod_Targ ":") "True" "False"))
						(setq	Ret_Val	(vlax-invoke Net_Obj "MapNetworkDrive" (strcat Prod_Targ ":") Prod_Share "False"))
					)
				)
				(if Net_Obj
					(setq	Net_Obj		nil
							AcadObj		nil
							Ret_Val		(MapDrivTst)
							Mapped_Prod	(nth 0 Ret_Val)
							Mapped_Targ	(nth 1 Ret_Val)
							Prod_Targ		(nth 2 Ret_Val)
							Prod_Share	(nth 3 Ret_Val)
							ShareName		(nth 4 Ret_Val)
							VolumeName	(nth 5 Ret_Val)
							Mapped_Prod_2	(nth 6 Ret_Val)
							Mapped_Targ_2	(nth 7 Ret_Val)
							Prod_Targ_2	(nth 8 Ret_Val)
							Prod_Share_2	(nth 9 Ret_Val)
							ShareName_2	(nth 10 Ret_Val)
							VolumeName_2	(nth 11 Ret_Val)
					)
				)
				(princ (strcat "\nTarget Drive [" Prod_Targ ":] is *ReMapped* as [" (strcase ShareName) "]"))
			)
		)
		(progn
			(princ (strcat "\nTarget Drive [" Prod_Targ ":] is *Not* mapped"))
			(setq	AcadObj	(vlax-get-acad-object)
					Net_Obj	(vla-getinterfaceobject AcadObj "WScript.Network")
			)
			(if Net_Obj
				(setq	Ret_Val	(vlax-invoke Net_Obj "MapNetworkDrive" (strcat Prod_Targ ":") Prod_Share "False"))
			)
			(if Net_Obj
				(setq	Net_Obj		nil
						AcadObj		nil
						Ret_Val		(MapDrivTst)
						Mapped_Prod	(nth 0 Ret_Val)
						Mapped_Targ	(nth 1 Ret_Val)
						Prod_Targ		(nth 2 Ret_Val)
						Prod_Share	(nth 3 Ret_Val)
						ShareName		(nth 4 Ret_Val)
						VolumeName	(nth 5 Ret_Val)
						Mapped_Prod_2	(nth 6 Ret_Val)
						Mapped_Targ_2	(nth 7 Ret_Val)
						Prod_Targ_2	(nth 8 Ret_Val)
						Prod_Share_2	(nth 9 Ret_Val)
						ShareName_2	(nth 10 Ret_Val)
						VolumeName_2	(nth 11 Ret_Val)
				)
			)
			(princ (strcat "\nTarget Drive [" Prod_Targ ":] is *Mapped* as [" (strcase ShareName) "]"))
		)
	)
	(if Mapped_Targ_2
		(if Mapped_Prod_2
			(princ (strcat "\nTarget Drive [" Prod_Targ_2 ":] is *Correctly* mapped as [" (strcase ShareName_2) "]"))
			(progn
				(princ (strcat "\nTarget Drive [" Prod_Targ_2 ":] is *InCorrectly* mapped as [" (strcase ShareName_2) "]"))
				(setq	AcadObj	(vlax-get-acad-object)
						Net_Obj	(vla-getinterfaceobject AcadObj "WScript.Network")
				)
				(if Net_Obj
					(progn
						(setq	Ret_Val	(vlax-invoke Net_Obj "RemoveNetworkDrive" (strcat Prod_Targ_2 ":") "True" "False"))
						(setq	Ret_Val	(vlax-invoke Net_Obj "MapNetworkDrive" (strcat Prod_Targ_2 ":") Prod_Share_2 "False"))
					)
				)
				(if Net_Obj
					(setq	Net_Obj		nil
							AcadObj		nil
							Ret_Val		(MapDrivTst)
							Mapped_Prod	(nth 0 Ret_Val)
							Mapped_Targ	(nth 1 Ret_Val)
							Prod_Targ		(nth 2 Ret_Val)
							Prod_Share	(nth 3 Ret_Val)
							ShareName		(nth 4 Ret_Val)
							VolumeName	(nth 5 Ret_Val)
							Mapped_Prod_2	(nth 6 Ret_Val)
							Mapped_Targ_2	(nth 7 Ret_Val)
							Prod_Targ_2	(nth 8 Ret_Val)
							Prod_Share_2	(nth 9 Ret_Val)
							ShareName_2	(nth 10 Ret_Val)
							VolumeName_2	(nth 11 Ret_Val)
					)
				)
				(princ (strcat "\nTarget Drive [" Prod_Targ_2 ":] is *ReMapped* as [" (strcase ShareName_2) "]"))
			)
		)
		(progn
			(princ (strcat "\nTarget Drive [" Prod_Targ_2 ":] is *Not* mapped"))
			(setq	AcadObj	(vlax-get-acad-object)
					Net_Obj	(vla-getinterfaceobject AcadObj "WScript.Network")
			)
			(if Net_Obj
				(setq	Ret_Val	(vlax-invoke Net_Obj "MapNetworkDrive" (strcat Prod_Targ_2 ":") Prod_Share_2 "False"))
			)
			(if Net_Obj
				(setq	Net_Obj		nil
						AcadObj		nil
						Ret_Val		(MapDrivTst)
						Mapped_Prod	(nth 0 Ret_Val)
						Mapped_Targ	(nth 1 Ret_Val)
						Prod_Targ		(nth 2 Ret_Val)
						Prod_Share	(nth 3 Ret_Val)
						ShareName		(nth 4 Ret_Val)
						VolumeName	(nth 5 Ret_Val)
						Mapped_Prod_2	(nth 6 Ret_Val)
						Mapped_Targ_2	(nth 7 Ret_Val)
						Prod_Targ_2	(nth 8 Ret_Val)
						Prod_Share_2	(nth 9 Ret_Val)
						ShareName_2	(nth 10 Ret_Val)
						VolumeName_2	(nth 11 Ret_Val)
				)
			)
			(princ (strcat "\nTarget Drive [" Prod_Targ_2 ":] is *Mapped* as [" (strcase ShareName_2) "]"))
		)
	)
	(princ)
)

(Acad_SCS_Init)
