(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " BemsCut Loading."))
	(princ "\nAddsPlot BemsCut Loading.")
)

(defun BemsCut ( /	 )	; Cuts out viewing area for and posts to Bems
				; ViewD BemsDir PutFile MinX MinY MaxX MaxY Fuzz cmD ssBrk ELast ssGood
	(if Bug (princ "\n{BemsCut Entered"))
	(if (= (getvar "ACADVER") "15.0")
		(if (not (member (strcase "DosLib2k.arx" T) (arx)))
			(if (findfile "doslib2k.arx")
				(arxload "doslib2k")
				(princ "\n*Buttons Error*: DosLIB Arx file not found on this system!")
			)
		)
		(if (not (member (strcase "DosLib14.arx" T) (arx)))
			(if (findfile "doslib14.arx")
				(arxload "doslib14")
				(princ "\n*Buttons Error*: DosLIB Arx file not found on this system!")
			)
		)
	)
	(if ViewPorter
		(setq	ViewD	(ViewPorter))
		(progn
			(load "S:\\Workgroups\\APC Power Delivery\\Division Mapping\\Common\\Acad.lsp")
			(load "S:\\Workgroups\\APC Power Delivery\\Division Mapping\\Common\\Utils.lsp")
			(if ViewPorter
				(setq	ViewD	(ViewPorter))
			)
		)
	)
	(if ViewD
		(if (/= (strcase (getvar "loginname")) "JALSMITH")
			(if (dos_getini "BEMS" "DWG" "H:\\Div_Map\\Div_Map.ini")
				(if (not (equal (dos_getini "BEMS" "DWG" "H:\\Div_Map\\Div_Map.ini") "default"))
					(setq	BemsDir	(dos_getini "BEMS" "DWG" "H:\\Div_Map\\Div_Map.ini"))
					(progn
						(alert (strcat "**" AppNam "** Error!\nNo BEMS DwgPath info loaded!"))
						(exit)
					)
				)
				(progn
					(alert (strcat "**" AppNam "** Error!\nNo BEMS DwgPath info loaded!"))
					(exit)
				)
			)
			(setq	BemsDir	"S:/Workgroups/APC Western Division/Division Mapping/Work in progress/")
		)
		(progn
			(alert (strcat "**" AppNam "** Error!\nNo ViewPort info loaded!"))
			(exit)
		)
	)
	(if BemsDir
		(setq	PutFile	(getfiled	"Name of Bems File" BemsDir "dwg" 1))
		(if _Path-Dwg
			(progn
				(setq	BemsDir	_Path-Dwg)
				(setq	PutFile	(getfiled	"Name of Bems File" BemsDir "dwg" 1))
			)
			(progn
				(alert (strcat "**" AppNam "** Error!\nNo Bems Paths found!"))
				(exit)
			)
		)
	)
	(if BemsDir
		(progn
			(command "_.Undo" "C" "ALL" "_.Undo" "BE")
			(if (/= 0 (getvar "tilemode"))
				(command "_.tilemode" 0)
			)
			(if (= 1 (getvar "cvport"))
				(command "_.MSpace")
			)
			(if (not PldName)
				(setq	PldName	"No PldName")
			)
			(if (not Vlt)
				(setq	Vlt		"No Vlt")
			)
			(if (not Job_Nam)
				(setq	Job_Nam	"No Job_Nam")
			)
			(if (not Det1)
				(setq	Det1		"No Det1")
			)
			(if (not Dwg_Num)
				(setq	Dwg_Num	"No Dwg_Num")
			)
			(if (not Desc_1)
				(setq	Desc_1	"No Desc_1")
			)
			(if (not Sc)
				(setq	Sc		1.0)
			)
			(if (not Sc_Asci)
				(setq	Sc_Asci	"No Sc_Asci")
			)
			(if (not Sht)
				(setq	Sht		"No Sht")
			)
			(princ	(strcat	"\nDetails attached to Bems Job:"
							"\nPldName:\t" PldName
							"\nVlt:\t\t" Vlt
							"\nJob_Nam:\t" Job_Nam
							"\nDet1:\t\t" Det1
							"\nDwg_Num:\t" Dwg_Num
							"\nDesc_1:\t" Desc_1
							"\nSc:\t\t1\"=" (if Sc (rtos Sc 2 2) "1") "\'"
							"\nSc_Asci:\t" Sc_Asci
							"\nSht:\t\t" Sht
							"\nSaved To File:\t" PutFile "\n"
					)
			)
			(command "_.Insert" (strcat _Path-Sym "Pld_Data") (getvar "VIEWCTR") "" "" "" PldName Vlt Job_Nam Det1 Dwg_Num Desc_1 (if Sc (rtos Sc 2 2) "1") Sc_Asci Sht)
			(command "_.Zoom" "0.8x" "_.-Layer" "T" "*" "ON" "*" "U" "*" "S" "0" "")
			(setq	MinX		(car (nth 8 ViewD))
					MaxX		(car (nth 9 ViewD))
					MinY		(cadr (nth 8 ViewD))
					MaxY		(cadr (nth 9 ViewD))
					Fuzz		10.0
					cmD		(getvar "CMDDIA")
					ssBrk	(ssget "C" (list (- MinX Fuzz) (- MinY Fuzz)) (list (+ MaxX Fuzz) (+ MaxY Fuzz)))
			)
			(setvar "CMDDIA" 0)
			(command	"_.PLINE"
					(list (- MinX Fuzz) (- MinY Fuzz))
					"W"
					"0.0"
					"0.0"
					(list (+ MaxX Fuzz) (- MinY Fuzz))
					(list (+ MaxX Fuzz) (+ MaxY Fuzz))
					(list (- MinX Fuzz) (+ MaxY Fuzz))
					"C"
			)
			(setq	Elast	(entlast))
			(Map_DwgBreakObj ssBrk Elast 0 1)
			(command "_.ERASE" Elast "")
			(setq	ssBrk	nil
					Fuzz		(/ Fuzz 2.0)
					ssGood	(ssget "C" (list (- MinX Fuzz) (- MinY Fuzz)) (list (+ MaxX Fuzz) (+ MaxY Fuzz)))
			)
			(if (and PutFile ssGood)
				(command "_.Wblock" PutFile "" "0,0" ssGood "" "N")
			)
			(command "_.Undo" "Back")
		)
	)
	(setvar "CMDDIA" cmD)
	(if Bug (princ "\nBemsCut Exited}\n"))
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(BemsCut)
	(setq	LodVer	"2.0.2")
)
