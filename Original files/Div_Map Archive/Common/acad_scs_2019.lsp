(defun Acad_SCS_Init ( / )					; Initialization ID Line
	(vlisp-import-symbol 'AppNam)
	(vlisp-import-symbol 'DevMark)
	(vlisp-import-symbol 'PrmRootPath)
	(vlisp-import-symbol 'SecRootPath)
	(vlisp-import-symbol 'TestPrmRootPath)
	(if AppNam
		(princ (strcat "\n" AppNam " Acad_SCS_2019 Loading.\n"))
		(progn
			(setq	AppNam	"Adds 3.0.0a")
			(princ (strcat "\n" AppNam " Acad_SCS_2019 Loading.\n"))
		)
	)
	(if (not (vl-registry-descendents "HKEY_CLASSES_ROOT\\Acad_SCS.SCS_About" nil))
		(LoadPrepSCS AppNam DevMark)
	)
	(setq	AppLst	(VGetPrefs)
			NewLst	(NGetPrefs)
			AppDir	(StpDot AppNam)
			LodVer	"3.0.1a"
	)
;	(vlisp-import-symbol 'map_wspacevisible)
;	(if (map_wspacevisible)
;		(command "MAPWSPACE" "oFf")
;	)
	(vlisp-export-symbol 'AppLst)
	(vlisp-export-symbol 'NewLst)
	(SetProfSCS AppNam AppLst DevMark)
	(vl-acad-defun 'GetAcadInfo)
	(vl-acad-defun 'Plinc)
	(vl-acad-defun 'SayWhat)
	(vl-acad-defun 'C:DoAbout)
	(vl-acad-defun 'C:DoSplash)
	(vl-acad-defun 'C:TestProfs)
	(vl-acad-defun 'C:VerPrefs)
	(vl-acad-defun 'C:MakeItHappen)
	(vl-acad-defun 'GetProf)
	(vl-acad-defun 'C:AddsMapDrive)
	(if AppNam
		(if	(and	(= (substr (StpDot AppNam) 1 4) "ADDS")
				(/= (StpDot AppNam) "ADDSPLOT")
			)
			(C:AddsMapDrive)
		)
	)
	(princ)
	(vlisp-export-symbol 'LodVer)
)

(defun Str2Lst ( StrIn DLim CasChz / OutLst Pos StPos )
	(setq	StPos	1)
	(if (not (setq Pos (vl-string-position (ascii DLim) StrIn)))
		(setq	OutLst	(list StrIn))
		(while Pos
			(if OutLst
				(setq	OutLst	(cons (substr StrIn (1+ StPos) (- Pos StPos)) OutLst))
				(setq	OutLst	(list (substr StrIn StPos Pos)))
			)
			(setq	StPos	(1+ Pos)
					Pos		(vl-string-position (ascii DLim) StrIn StPos)
			)
		)
	)
	(if (and (> (strlen StrIn) StPos) (/= StPos 1))
		(setq	OutLst	(cons (substr StrIn (1+ StPos)) OutLst))
	)
	(if CasChz
		(if (and (eq (strcase CasChz) "U") OutLst)
			(setq	OutLst	(mapcar (quote strcase) OutLst))
			(setq	OutLst	(mapcar (quote (lambda (x) (strcase x T))) OutLst))
		)
	)
	OutLst
)

(defun GetProf ( NewApp /	acadObject		; Swaps current profile...
						acadDocument acadPrefer acadProfiles IsGood )
	(setq	acadObject	(vlax-get-acad-object)
			acadDocument	(vla-get-ActiveDocument acadObject)
			acadPrefer	(vla-get-Preferences acadObject)
			acadProfiles	(vla-get-Profiles acadPrefer)
			IsGood		(vla-get-ActiveProfile acadProfiles)
	)
	IsGood
)

(defun Delay ( / )
	(setq	curtime	(* (getvar "DATE") 1e8)
			ritardo	2000
	)
	(while (< (* (getvar "DATE") 1e8) (+ curtime ritardo)))
)

(defun C:MakeItHappen ( / )
	(vlisp-import-symbol 'AppNam)
	(if AppNam
		(princ (strcat "\n" AppNam " Acad_SCS Loading."))
		(progn
			(setq	AppNam	"Adds 3.0.0a")
			(princ (strcat "\n" AppNam " Acad_SCS Loading."))
		)
	)
	(if (not (vl-registry-descendents "HKEY_CLASSES_ROOT\\Acad_SCS.SCS_About" nil))
		(LoadPrepSCS AppNam)
	)
	(setq	AppLst	(VGetPrefs)
			NewLst	(NGetPrefs)
			AppDir	(StpDot AppNam)
			LodVer	"3.0.0"
	)
;	(if (map_wspacevisible)
		(command "_MAPWSPACE" "off")
;	)
	(vlisp-export-symbol 'AppLst)
	(vlisp-export-symbol 'NewLst)
	(vlisp-import-symbol 'DevMark)
	(SetProfSCS AppNam AppLst DevMark)
	(princ)
)

(defun C:TestProfs ( / )					; Tests profile setting automation
	(vlisp-import-symbol 'AppNam)
	(vlisp-import-symbol 'DevMark)
	(setq	AppLst	(VGetPrefs))
	(SetProfSCS AppNam AppLst DevMark)
	(princ)
)

(defun LoadPrepSCS ( AppNam DevMark /	TstCopy	; Copys and registers Acad_SCS.DLL to registry!
								AppDir DivDir AcadObj AppObj PosDiv ValProf PWD LstAcadInfo
								Acad17Reg Acad17RegPth Acad17RegPrd Acad17RegREL Acad17RegS_N
								UserName UserProf AllUsrPrf WinDir TmpDir ProgDir )
	(setq	LstAcadInfo	(GetAcadInfo)
			Acad17Reg		(nth 0 LstAcadInfo)
			Acad17RegPth	(nth 1 LstAcadInfo)
			Acad17RegPrd	(nth 2 LstAcadInfo)
			Acad17RegREL	(nth 3 LstAcadInfo)
			Acad17RegS_N	(nth 4 LstAcadInfo)
			UserName		(nth 5 LstAcadInfo)
			UserProf		(nth 6 LstAcadInfo)
			AllUsrPrf		(nth 7 LstAcadInfo)
			WinDir		(nth 8 LstAcadInfo)
			TmpDir		(nth 9 LstAcadInfo)
			ProgDir		(nth 10 LstAcadInfo)
	)
	(if AppNam
		(setq	AppDir		(StpDot AppNam))
		(setq	AppDir		nil)
	)
	(if WinDir
		(if (vl-filename-directory (strcat WinDir "\\system32\\"))
			(setq	WinDir	(strcase (vl-filename-directory (strcat WinDir "\\system32\\"))))
			(setq	WinDir	nil
					Bubba	(princ "\nAcad_SCS:WinDir not found!")
			)
		)
	)
	(cond
		((= AppDir "ADDS")
			(if DevMark
				(if (findfile (strcat TestPrmRootPath "Common" "\\acad_scs.dll"))
					(setq	DivDir	(strcat TestPrmRootPath "Common"))
				)
				(if (findfile (strcat PrmRootPath "Common" "\\acad_scs.dll"))
					(setq	DivDir	(strcat PrmRootPath "Common"))
				)
			)
		)
	)
	(if (and	(findfile (strcat DivDir "\\acad_scs.dll"))
			(findfile (strcat DivDir "\\msvbvm50.dll"))
		)
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
	(if (and	(findfile (strcat WinDir "\\acad_scs.dll"))
			(findfile (strcat WinDir "\\msvbvm50.dll"))
		)
		(progn
			(start (strcat DivDir "\\regsvr32 /s " WinDir "\\acad_scs.dll"))
			(princ "\nAcad_SCS.DLL Dynamic Link Library copied and registered!")
		)
		(princ "\nAcad_SCS:DLL's not registered!")
	)
)

(defun SetProfSCS ( AppNam AppLst DevMark /	WinDir	; Loads Profile Settings for session, if changed
									AppDir DivDir AcadObj AppObj PosDiv ValProf PWD LstAcadInfo
									Acad17Reg Acad17RegPth Acad17RegPrd Acad17RegREL Acad17RegS_N
									UserName UserProf AllUsrPrf WinDir TmpDir ProgDir ValProf LclDivMap TstVal 
									appLogFilePath logFlag)
	(setq	LstAcadInfo	(GetAcadInfo)
			Acad17Reg		(nth 0 LstAcadInfo)
			Acad17RegPth	(nth 1 LstAcadInfo)
			Acad17RegPrd	(nth 2 LstAcadInfo)
			Acad17RegREL	(nth 3 LstAcadInfo)
			Acad17RegS_N	(nth 4 LstAcadInfo)
			UserName		(nth 5 LstAcadInfo)
			UserProf		(nth 6 LstAcadInfo)
			AllUsrPrf		(nth 7 LstAcadInfo)
			WinDir		(nth 8 LstAcadInfo)
			TmpDir		(nth 9 LstAcadInfo)
			ProgDir		(nth 10 LstAcadInfo)
			LclDivMap		"C:\\Div_Map\\"
	)
	(if AppNam
		(setq	AppDir		(StpDot AppNam))
		(setq	AppDir		nil)
	)
	(if WinDir
		(if (vl-filename-directory (strcat WinDir "\\system32\\"))
			(setq	WinDir	(strcase (vl-filename-directory (strcat WinDir "\\system32\\"))))
			(setq	WinDir	nil)
		)
	)
	
	(cond
		(AppDir
			(if DevMark
				(setq	DivDir	(strcat "C:\\Div_Map\\" AppDir "\\"))
				(setq	DivDir	(strcat SecRootPath AppDir "\\"))
			)
		)
	)
	(setq	AcadObj	(vlax-get-acad-object))
	(if AcadObj
		(setq	AppObj	(vlax-get AcadObj "Preferences")
				PrProfObj	(vlax-get AppObj "Profiles")
				PrFileObj	(vlax-get AppObj "Files")
				PrSysObj	(vlax-get AppObj "System")
				PrOpSvObj	(vlax-get AppObj "OpenSave")
				PrDspObj	(vlax-get AppObj "Display")
				PrDrftObj	(vlax-get AppObj "Drafting")
				PrUsrObj	(vlax-get AppObj "User")
		)
		(setq	AppObj	nil)
	)
	(if AppObj
		(if (/= (strcase AppDir) (strcase (nth 0 AppLst)))
			(if (= (strcat (strcase AppDir) "_T") (strcase (nth 0 AppLst)))
			    	(progn
					(princ "\nTest Profile In Use!")
		 	     	(setq	ValProf	(nth 0 AppLst))
				)
			    	(progn
					(princ "\nNot Right Profile Name!")
		 	     	(setq	ValProf	nil)
				)
			)
		    	(progn
	 	     	(setq	ValProf	(nth 0 AppLst))
	 		)
	 	)
	)
	(if ValProf
		(cond
			((or (= (strcase ValProf) (strcase "Adds")) (= (strcase ValProf) (strcase "Adds_T"))
				(= (strcase ValProf) (strcase "AddsPlot")) (= (strcase ValProf) (strcase "AddsPlot_T"))
				(= (strcase ValProf) (strcase "Cadet")) (= (strcase ValProf) (strcase "Cadet_T")))
				(if (< (vlax-get PrDspObj	"CursorSize") 5)				;"Display"
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"CursorSize"
										"}"
								)
						)
						(vlax-put PrDspObj	"CursorSize" 5)
					)
				)
				(if (/= (vlax-get PrDspObj	"DisplayLayoutTabs") -1)			;"Display"
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"DisplayLayoutTabs"
										"}"
								)
						)
						(vlax-put PrDspObj	"DisplayLayoutTabs" -1)
					)
				)

				(if (< (vlax-get PrDspObj	"HistoryLines") 1024)			;"Display"
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"HistoryLines"
										"}"
								)
						)
						(vlax-put PrDspObj	"HistoryLines" 1024)
					)
				)
				(if (/= (vlax-get PrDspObj	"MaxAutoCADWindow") 0)			;"Display"
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"MaxAutoCADWindow"
										"}"
								)
						)
						(vlax-put PrDspObj	"MaxAutoCADWindow" 0)
					)
				)
				(if (/= (vlax-get PrDrftObj	"AutoSnapAperture") 0)			;"Drafting"
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"AutoSnapAperture"
										"}"
								)
						)
						(vlax-put PrDrftObj	"AutoSnapAperture" 0)
					)
				)
				(if (< (vlax-get PrDrftObj	"AutoSnapApertureSize") 10)		;"Drafting"
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"AutoSnapApertureSize"
										"}"
								)
						)
						(vlax-put PrDrftObj	"AutoSnapApertureSize" 10)
					)
				)


				(if (/= (strcase(vlax-get PrFileObj	"AutoSavePath"))				;"Files"
										(strcat TmpDir "\\"))
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"AutoSavePath"
										"}"
								)
						)
						(vlax-put PrFileObj	"AutoSavePath" (strcat TmpDir "\\"))
					)
				)
				(if	(/=	(vlax-get PrFileObj "CustomIconPath")				;"Files"
										(strcat LclDivMap "Icon_Collection")
					)
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"CustomIconPath"
										"}"
								)
						)
						(vlax-put PrFileObj	"CustomIconPath" (strcat LclDivMap "Icon_Collection"))
					)
				)
				(if (/= (vlax-get PrFileObj	"DefaultInternetURL") 			;"Files"
										"file://S:/Workgroups/APC Power Delivery/Division Mapping/Public/Web_Sdr/AlaState.html")
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"DefaultInternetURL"
										"}"
								)
						)
						(vlax-put PrFileObj	"DefaultInternetURL" "file://S:/Workgroups/APC Power Delivery/Division Mapping/Public/Web_Sdr/AlaState.html")
					)
				)
				;	Check to make sure Adds Series application and setup log file path if needed
				(if (or	(= (strcase ValProf) (strcase "AddsPlot"))	(= (strcase ValProf) (strcase "AddsPlot_T"))
						(= (strcase ValProf) (strcase "Adds")) 		(= (strcase ValProf) (strcase "Adds_T"))
						(= (strcase ValProf) (strcase "Cadet")) 	(= (strcase ValProf) (strcase "Cadet_T"))
					)
						(progn
							(setq	appLogFilePath	(strcat "C:\\" AppDir "\\Logs\\")
									TstVal		(vl-directory-files (strcat "C:\\" AppDir "\\") "Logs" -1)
									logFlag		nil
							)
							;	Check to make sure Logs subdirectory exists if Adds Series application
							(if (< (length TstVal) 1)
								(progn
									(vl-mkdir appLogFilePath)
									(princ (strcat "\nMaking Directory {" appLogFilePath "} for LogFilePath"))
									(setq logFlag T)
								)
							)
							;	Check to make sure LogFilePath is correct in AutoCAD options/registry/system var
							(if (/= (vlax-get PrFileObj	"LogFilePath")	appLogFilePath)
								(progn
									(vlax-put PrFileObj	"LogFilePath" appLogFilePath)
									(setq logFlag T)
								)
							)
							(if setq logFlag
								;	Communicate to user that a change occurred.
								(princ	(strcat	"\n*SetProfSCS* fixes {"
												"LogFilePath =" appLogFilePath
												" }"
										)
								)
							)
						)
				)

				(if (/= (vlax-get PrFileObj	"PageSetupOverridesTemplateFile") 	;"Files"
										(strcat LclDivMap "LookUpTable\\Template\\SheetSets\\Architectural Imperial.dwt"))
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"PageSetupOverridesTemplateFile"
										"}"
								)
						)
						(vlax-put PrFileObj	"PageSetupOverridesTemplateFile" (strcat LclDivMap "LookUpTable\\Template\\SheetSets\\Architectural Imperial.dwt"))
					)
				)
				(if (/= (strcase(vlax-get PrFileObj	"PlotLogFilePath")) 				;"Files"
										(strcat TmpDir "\\"))
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"PlotLogFilePath"
										"}"
								)
						)
						(vlax-put PrFileObj	"PlotLogFilePath" (strcat TmpDir "\\"))
					)
				)
				(if (/= (vlax-get PrFileObj	"PrinterConfigPath") 			;"Files"
										(strcat LclDivMap "LookUpTable\\Plotters"))
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"PrinterConfigPath"
										"}"
								)
						)
						(vlax-put PrFileObj	"PrinterConfigPath" (strcat LclDivMap "LookUpTable\\Plotters"))
					)
				)
				(if (/= (vlax-get PrFileObj	"PrinterDescPath") 				;"Files"
										(strcat LclDivMap "LookUpTable\\Plotters\\PMP Files"))
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"PrinterDescPath"
										"}"
								)
						)
						(vlax-put PrFileObj	"PrinterDescPath" (strcat LclDivMap "LookUpTable\\Plotters\\PMP Files"))
					)
				)
				(if (/= (vlax-get PrFileObj	"PrinterStyleSheetPath") 		;"Files"
										(strcat LclDivMap "LookUpTable\\Plot Styles"))
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"PrinterStyleSheetPath"
										"}"
								)
						)
						(vlax-put PrFileObj	"PrinterStyleSheetPath" (strcat LclDivMap "LookUpTable\\Plot Styles"))
					)
				)
				(if (/= (strcase(vlax-get PrFileObj	"PrintSpoolerPath")) 			;"Files"
										(strcat TmpDir "\\"))
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"PrintSpoolerPath"
										"}"
								)
						)
						(vlax-put PrFileObj	"PrintSpoolerPath" (strcat TmpDir "\\"))
					)
				)
				(if (/= (vlax-get PrFileObj	"QNewTemplateFile") 			;"Files"
										(strcat LclDivMap "LookUpTable\\Template\\" ValProf ".dwt"))
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"QNewTemplateFile"
										"}"
								)
						)
						(vlax-put PrFileObj	"QNewTemplateFile" (strcat LclDivMap "LookUpTable\\Template\\" ValProf ".dwt"))
					)
				)
				(if (/= (strcase(vlax-get PrFileObj	"TempFilePath"))				;"Files"
										(strcat TmpDir "\\"))
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"TempFilePath"
										"}"
								)
						)
						(vlax-put PrFileObj	"TempFilePath" (strcat TmpDir "\\"))
					)
				)
				(if (/= (vlax-get PrFileObj	"TemplateDwgPath") 				;"Files"
										(strcat LclDivMap "LookUpTable\\Template"))
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"TemplateDwgPath" 
										"}"
								)
						)
						(vlax-put PrFileObj	"TemplateDwgPath" (strcat LclDivMap "LookUpTable\\Template"))
					)
				)
				(if (/= (strcase(vlax-get PrFileObj	"TempXrefPath"))				;"Files"
										(strcat TmpDir "\\"))
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"TempXrefPath"
										"}"
								)
						)
						(vlax-put PrFileObj	"TempXrefPath" (strcat TmpDir "\\"))
					)
				)
				(if	(/=	(vlax-get PrFileObj "ToolPalettePath")				;"Files"
						(strcat LclDivMap "LookUpTable\\ToolPalette\\" (StpDot AppNam))
					)
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"ToolPalettePath " (StpDot AppNam)
										"}"
								)
						)
						(vlax-put PrFileObj	"ToolPalettePath" (strcat LclDivMap "LookUpTable\\ToolPalette\\" (StpDot AppNam)))
					)
				)
				(if	(/=	(vlax-get PrFileObj "WorkspacePath")				;"Files"
										(strcat LclDivMap "LookUpTable\\Data Links")
					)
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"WorkspacePath"
										"}"
								)
						)
						(vlax-put PrFileObj	"WorkspacePath" (strcat LclDivMap "LookUpTable\\Data Links"))
					)
				)
				(if (/= (vlax-get PrOpSvObj "AutoSaveInterval") 0)			;"OpenSave"
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"AutoSaveInterval"
										"}"
								)
						)
						(vlax-put PrOpSvObj "AutoSaveInterval" 0)
					)
				)
				(if (/= (vlax-get PrOpSvObj "CreateBackUp") -1)				;"OpenSave"
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"CreateBackUp"
										"}"
								)
						)
						(vlax-put PrOpSvObj "CreateBackUp" -1)
					)
				)
				(if (/= (vlax-get PrOpSvObj "DemandLoadARXApp") 3)			;"OpenSave"
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"DemandLoadARXApp"
										"}"
								)
						)
						(vlax-put PrOpSvObj "DemandLoadARXApp" 3)
					)
				)
				(if (/= (vlax-get PrOpSvObj "IncrementalSavePercent") 0)		;"OpenSave"
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"IncrementalSavePercent"
										"}"
								)
						)
						(vlax-put PrOpSvObj "IncrementalSavePercent" 0)
					)
				)
				(if (/= (vlax-get PrOpSvObj "LogFileOn") -1)					;"OpenSave"
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"LogFileOn"
										"}"
								)
						)
						(vlax-put PrOpSvObj "LogFileOn" -1)
					)
				)
				(if (/= (vlax-get PrOpSvObj "SaveAsType") 36)				;"OpenSave"
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"SaveAsType"
										"}"
								)
						)
						(vlax-put PrOpSvObj "SaveAsType" 36)
					)
				)
				(if (/= (vlax-get PrOpSvObj	"SavePreviewThumbnail") -1)		;"OpenSave"
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"SavePreviewThumbnail"
										"}"
								)
						)
						(vlax-put PrOpSvObj	"SavePreviewThumbnail" -1)
					)
				)
				(if (/= (vlax-get PrSysObj	"EnableStartupDialog") 0)		;"System"
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"EnableStartupDialog"
										"}"
								)
						)
						(vlax-put PrSysObj	"EnableStartupDialog" 0)
					)
				)
				(if (/= (vlax-get PrSysObj	"LoadAcadLspInAllDocuments") -1)	;"System"
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"LoadAcadLspInAllDocuments"
										"}"
								)
						)
						(vlax-put PrSysObj	"LoadAcadLspInAllDocuments" -1)
					)
				)
								
				(if (or	(= (strcase ValProf) (strcase "AddsPlot")) (= (strcase ValProf) (strcase "AddsPlot_T"))
							(= (strcase ValProf) (strcase "Adds")) (= (strcase ValProf) (strcase "Adds_T"))
						)
						(progn
							(if (/= (vlax-get PrSysObj	"SingleDocumentMode") -1)
								(progn
									(princ	(strcat	"\n*SetProfSCS* fixes {"
													"SingleDocumentMode"
													"}\n"
											)
									)
									(vlax-put PrSysObj	"SingleDocumentMode" -1)
								)
							)
							(if (/= (vlax-get PrDspObj 	"DisplayScrollBars")	0)
								(progn
									(princ 	(strcat "\n*SetProfSCS* fixes {" "DisplayScrollBars" "} - Turns Off\n"))
									(vlax-put PrDspObj	"DisplayScrollBars" 0)
								)
							)
						)
						(if (or 	(= (strcase ValProf) (strcase "Cadet")) (= (strcase ValProf) (strcase "Cadet_T")))
							(progn
								(if (/= (vlax-get PrSysObj	"SingleDocumentMode") 0)
									(progn
										(princ 	(strcat "\n*SetProfSCS* fixes {" "Multiple Document Mode" "}\n"))
										(vlax-put PrSysObj	"SingleDocumentMode" 0)
									)
								)
								(if (/= (vlax-get PrDspObj 	"DisplayScrollBars")	-1)
									(progn
										(princ 	(strcat "\n*SetProfSCS* fixes {" "DisplayScrollBars" "} - Turns On\n"))
										(vlax-put PrDspObj	"DisplayScrollBars" -1)
									)
								)
							)
						)
				)
				
				
				(if (/= (vlax-get PrUsrObj	"ADCInsertUnitsDefaultSource") 0)	;"User"
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"ADCInsertUnitsDefaultSource"
										"}"
								)
						)
						(vlax-put PrUsrObj	"ADCInsertUnitsDefaultSource" 0)
					)
				)
				(if (/= (vlax-get PrUsrObj	"ADCInsertUnitsDefaultTarget") 0)	;"User"
					(progn
						(princ	(strcat	"\n*SetProfSCS* fixes {"
										"ADCInsertUnitsDefaultTarget"
										"}"
								)
						)
						(vlax-put PrUsrObj	"ADCInsertUnitsDefaultTarget" 0)
					)
				)
			)
		)
	)
	(setq	PrProfObj	nil
			PrFileObj	nil
			PrSysObj	nil
			PrOpSvObj	nil
			PrDspObj	nil
			PrDrftObj	nil
			PrUsrObj	nil
			AppObj	nil
			AcadObj	nil
	)
	(princ)
)

(defun VGetPrefs ( /	AcadObj AppObj PrProfObj	; Gets Preference Objects for testing
					PrFileObj PrSysObj PrOpSvObj )
	(setq	AcadObj	(vlax-get-acad-object))
	(if AcadObj
		(setq	AppObj	(vlax-get AcadObj "Preferences")
				PrProfObj	(vlax-get AppObj "Profiles")
				PrFileObj	(vlax-get AppObj "Files")
				PrSysObj	(vlax-get AppObj "System")
				PrOpSvObj	(vlax-get AppObj "OpenSave")
		)
		(setq	AppObj	nil)
	)
	(if PrProfObj
		(list	(vlax-get PrProfObj	"ActiveProfile")
				(vlax-get PrFileObj	"LogFilePath")
				(vlax-get PrFileObj	"MenuFile")
				(vlax-get PrFileObj	"PrintSpoolerPath")
				(vlax-get PrFileObj	"SupportPath")
				(vlax-get PrFileObj	"TempFilePath")
				(vlax-get PrSysObj	"EnableStartupDialog")
				0	;(vlax-get AppObj "PersistentLISP")
				(vlax-get PrOpSvObj	"AutoSaveInterval")
				(vlax-get PrOpSvObj	"LogFileOn")
		)
	)
)

(defun NGetPrefs ( /	AcadObj AppObj PrProfObj	; Gets Preference Objects for testing
					PrFileObj PrSysObj PrOpSvObj PrDspObj PrDrftObj PrUsrObj LstPrefs )
	(setq	AcadObj	(vlax-get-acad-object))
	(if AcadObj
		(setq	AppObj	(vlax-get AcadObj "Preferences")
				PrProfObj	(vlax-get AppObj "Profiles")
				PrFileObj	(vlax-get AppObj "Files")
				PrSysObj	(vlax-get AppObj "System")
				PrOpSvObj	(vlax-get AppObj "OpenSave")
				PrDspObj	(vlax-get AppObj "Display")
				PrDrftObj	(vlax-get AppObj "Drafting")
				PrUsrObj	(vlax-get AppObj "User")
		)
		(setq	AppObj	nil)
	)
	(if AppObj
	(setq	LstPVals	(list	(vlax-get PrProfObj	"ActiveProfile")				;00	"ADDS30"
							(vlax-get PrOpSvObj	"AutoSaveInterval")				;01	0
							(vlax-get PrOpSvObj	"CreateBackUp")				;02	-1
							(vlax-get PrOpSvObj	"IncrementalSavePercent")		;03	0
							(vlax-get PrOpSvObj	"LogFileOn")					;04	-1
							(vlax-get PrOpSvObj	"SaveAsType")					;05	24
							(vlax-get PrOpSvObj	"SavePreviewThumbnail")			;06	
							(vlax-get PrSysObj	"EnableStartupDialog")			;07
							(vlax-get PrSysObj	"LoadAcadLspInAllDocuments")		;08
							(vlax-get PrSysObj	"SingleDocumentMode")			;09
							(vlax-get PrFileObj	"DefaultInternetURL")			;10
							(vlax-get PrFileObj	"LogFilePath")					;11
							(vlax-get PrFileObj	"MenuFile")					;12
							(vlax-get PrFileObj	"PrintSpoolerPath")				;13
							(vlax-get PrFileObj	"SupportPath")					;14
							(vlax-get PrFileObj	"TempFilePath")				;15
							(vlax-get PrFileObj	"TempXrefPath")				;16
							(vlax-get PrFileObj	"ToolPalettePath")				;17
							(vlax-get PrFileObj	"WorkspacePath")				;18
							(vlax-get PrDspObj	"CursorSize")					;19
							(vlax-get PrDspObj	"MaxAutoCADWindow")				;20
							(vlax-get PrDrftObj	"AutoSnapAperture")				;21
							(vlax-get PrDrftObj	"AutoSnapApertureSize")			;22
							(vlax-get PrUsrObj	"ADCInsertUnitsDefaultSource")	;23
							(vlax-get PrUsrObj	"ADCInsertUnitsDefaultTarget")	;24
					)
			LstPrefs	(list	"ActiveProfile"
							"AutoSaveInterval"
							"CreateBackUp"
							"IncrementalSavePercent"
							"LogFileOn"
							"SaveAsType"
							"SavePreviewThumbnail"
							"EnableStartupDialog"
							"LoadAcadLspInAllDocuments"
							"SingleDocumentMode"
							"DefaultInternetURL"
							"LogFilePath"
							"MenuFile"
							"PrintSpoolerPath"
							"SupportPath"
							"TempFilePath"
							"TempXrefPath"
							"ToolPalettePath"
							"WorkspacePath"
							"CursorSize"
							"MaxAutoCADWindow"
							"AutoSnapAperture"
							"AutoSnapApertureSize"
							"ADCInsertUnitsDefaultSource"
							"ADCInsertUnitsDefaultTarget"
					)
		)
	)
	(setq	PrProfObj	nil
			PrFileObj	nil
			PrSysObj	nil
			PrOpSvObj	nil
			PrDspObj	nil
			PrDrftObj	nil
			PrUsrObj	nil
			AppObj	nil
			AcadObj	nil
	)
	(list LstPrefs LstPVals)
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
				(if (findfile (strcat PrmRootPath AppPth "\\" AppDir "\\" FilNam "." FilExt))
					(setq	TstVal	(strcat PrmRootPath AppPth "\\" AppDir "\\" FilNam "." FilExt))
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
			(if (findfile (strcat PrmRootPath AppPth "\\" AppDir "\\" FilNam "." FilExt))
				(setq	TstVal	(strcat PrmRootPath AppPth "\\" AppDir "\\" FilNam "." FilExt))
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
			((wcmatch (substr TmpStr 2 5) "CADET")
				"CADET"
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

(defun C:DoAbout ( /	AcadObj AboutObj 	; Loads ActiveX About Screen {AppNam}
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

(defun C:DoSplash ( /	AcadObj SplashObj		; Loads ActiveX Splash Screen {AppNam}
					 Action )
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

(defun MapDrivTst ( /	AcadObj FSO_Obj 	; Verifies FileSystemObject Mapped Drives
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
			Prod_Share	"\\\\SouthernCo.com\\Shared Data\\Workgroups\\APC Power Delivery\\Division Mapping Test"
			Prod_Targ_2	"N"
			Prod_Share_2	"\\\\SouthernCo.com\\Shared Data\\Temporary User Storage (Deleted each Sunday)\\APC Hq" ;Change by CET 5/3/2014
;			Prod_Targ		"M"
;			Prod_Share	"\\\\alxapsb12\\Adds"
;			Prod_Targ_2	"N"
;			Prod_Share_2	"\\\\alsdcsb92\\Adds"
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

(defun Plinc ( arg1 arg2 / )
	(if (= (type arg2) 'INT)
	  (princ (strcat "\n" arg1 "\t" (itoa arg2)))
	  (princ (strcat "\n" arg1 "\t" arg2))
	)
  (princ)
)

(defun SayWhat ( NewLst /	Cntr )				;Lists Preference Settings
	(setq	Cntr	0)
	(princ "\nFeatureName\tFeatureValue")
	(princ "\n***********\t************")
	(while (< Cntr (length (car NewLst)))
		(Plinc (nth Cntr (nth 0 NewLst)) (nth Cntr (nth 1 NewLst)))
		(setq	Cntr	(1+ Cntr))
	)
	(princ)
)

(defun GetAcadInfo ( /	AcadObj WSH_Obj		; Verifies Program System Variables
					AcadReg AcadRegPth AcadRegPrd AcadRegREL AcadRegS_N
					UserName UserProf AllUsrPrf WinDir TmpDir ProgDir )
	(setq	AcadObj		(vlax-get-acad-object)
			WSH_Obj		(vla-getinterfaceobject AcadObj "WScript.Shell")
			UserName		(strcase (vlax-invoke WSH_Obj "ExpandEnvironmentStrings" "%USERNAME%"))
			UserProf		(strcase (vlax-invoke WSH_Obj "ExpandEnvironmentStrings" "%USERPROFILE%"))
			AllUsrPrf		(strcase (vlax-invoke WSH_Obj "ExpandEnvironmentStrings" "%ALLUSERSPROFILE%"))
			WinDir		(strcase (vlax-invoke WSH_Obj "ExpandEnvironmentStrings" "%WinDir%"))
			TmpDir		(strcase (vlax-invoke WSH_Obj "ExpandEnvironmentStrings" "%Temp%"))
			ProgDir		(strcase (vlax-invoke WSH_Obj "ExpandEnvironmentStrings" "%ProgramFiles%"))
	)
	(cond 
		((= (substr (getvar "ACADVER") 1 4) "23.1")		;	AutoCAD 2019
			(setq	AcadReg 		"ACAD-3002:409"
					AcadRegPth	(vlax-invoke WSH_Obj "RegRead" (strcat "HKLM\\SOFTWARE\\Autodesk\\AutoCAD\\R23.1\\" AcadReg "\\AcadLocation"))
					AcadRegPrd	(vlax-invoke WSH_Obj "RegRead" (strcat "HKLM\\SOFTWARE\\Autodesk\\AutoCAD\\R23.1\\" AcadReg "\\ProductName"))
					AcadRegREL	(vlax-invoke WSH_Obj "RegRead" (strcat "HKLM\\SOFTWARE\\Autodesk\\AutoCAD\\R23.1\\" AcadReg "\\Release"))
					AcadRegS_N	(vlax-invoke WSH_Obj "RegRead" (strcat "HKLM\\SOFTWARE\\Autodesk\\AutoCAD\\R23.1\\" AcadReg "\\SerialNumber"))
			)
		)
		((= (substr (getvar "ACADVER") 1 4) "20.1")		;	AutoCAD 2016
			(setq	AcadReg 		"ACAD-F002:409"
					AcadRegPth	(vlax-invoke WSH_Obj "RegRead" (strcat "HKLM\\SOFTWARE\\Autodesk\\AutoCAD\\R20.1\\" AcadReg "\\AcadLocation"))
					AcadRegPrd	(vlax-invoke WSH_Obj "RegRead" (strcat "HKLM\\SOFTWARE\\Autodesk\\AutoCAD\\R20.1\\" AcadReg "\\ProductName"))
					AcadRegREL	(vlax-invoke WSH_Obj "RegRead" (strcat "HKLM\\SOFTWARE\\Autodesk\\AutoCAD\\R20.1\\" AcadReg "\\Release"))
					AcadRegS_N	(vlax-invoke WSH_Obj "RegRead" (strcat "HKLM\\SOFTWARE\\Autodesk\\AutoCAD\\R20.1\\" AcadReg "\\SerialNumber"))
			)
		)
		((= (substr (getvar "ACADVER") 1 4) "18.2")		;	AutoCAD 2012
			(setq	AcadReg 		"ACAD-A002:409"
					AcadRegPth	(vlax-invoke WSH_Obj "RegRead" (strcat "HKLM\\SOFTWARE\\Autodesk\\AutoCAD\\R18.2\\" AcadReg "\\AcadLocation"))
					AcadRegPrd	(vlax-invoke WSH_Obj "RegRead" (strcat "HKLM\\SOFTWARE\\Autodesk\\AutoCAD\\R18.2\\" AcadReg "\\ProductName"))
					AcadRegREL	(vlax-invoke WSH_Obj "RegRead" (strcat "HKLM\\SOFTWARE\\Autodesk\\AutoCAD\\R18.2\\" AcadReg "\\Release"))
					AcadRegS_N	(vlax-invoke WSH_Obj "RegRead" (strcat "HKLM\\SOFTWARE\\Autodesk\\AutoCAD\\R18.2\\" AcadReg "\\SerialNumber"))
			)
		)
		((= (substr (getvar "ACADVER") 1 4) "17.0")		;	AutoCAD 2007
			(setq	AcadReg 		"ACAD-5002:409"		   
					AcadRegPth	(vlax-invoke WSH_Obj "RegRead" (strcat "HKLM\\SOFTWARE\\Autodesk\\AutoCAD\\R17.0\\" AcadReg "\\AcadLocation"))
					AcadRegPrd	(vlax-invoke WSH_Obj "RegRead" (strcat "HKLM\\SOFTWARE\\Autodesk\\AutoCAD\\R17.0\\" AcadReg "\\ProductName"))
					AcadRegREL	(vlax-invoke WSH_Obj "RegRead" (strcat "HKLM\\SOFTWARE\\Autodesk\\AutoCAD\\R17.0\\" AcadReg "\\Release"))
					AcadRegS_N	(vlax-invoke WSH_Obj "RegRead" (strcat "HKLM\\SOFTWARE\\Autodesk\\AutoCAD\\R17.0\\" AcadReg "\\SerialNumber"))
			)
		)
	)
	(setq	WSH_Obj		nil
			AcadObj		nil
	)
	(list AcadReg AcadRegPth AcadRegPrd AcadRegREL AcadRegS_N UserName UserProf AllUsrPrf WinDir TmpDir ProgDir)
)

(Acad_SCS_Init)
