(if AppNam								; Code Version Indicator {989 Lines of Code}
	(princ (strcat "\n" AppNam " DlgLod Loading."))
	(princ "\nAdds DlgLod Loading.")
)

(defun GetDlg ( /	quad fn )					; allows choice of Quad (DLG) sheet
	(if Bug (princ "\nGetDlg entered"))
	(if (not Lst_DLG_xyn)
		(Bld_DLG_Lst)
	)
	(setq	fn	nil)
	(while (not fn)
		(menucmd "p1=*" )
		(setq	name		(strcase (getstring "\n\nSelect the quad sheet you wish to update: "))
				quad		(strcat _PATH-DLG name)
				fn		(findfile (strcat quad ".dwg"))
		)
		(if (not fn) (princ (strcat "\n**" AppNam "ERROR*** Invalid quad selected")))
	)
	(command	"_.LAYER" "S" "----DLG---" ""
			"INSERT" quad "0,0" "" "" ""
			"ZOOM" "E"
	)
;	(command "LIMITS" (getvar "extmin") (getvar "extmax"))
	(setq DlgFlag "T")
	(menucmd "p1=p1A")
	(menucmd "p1=*" )
	(if Bug (princ "\nGetDlg exited"))
	(princ)
)

(defun NewSht ( /	a b )					; Loads or replaces the original Quad (DLG) drawing
	(if Bug (princ "\nNewSht entered"))
	(setq	sseras	(ssget "W" (list 0.0 0.0 0.0) (list 999999.0 9999999.0 0.0)))
	(if sseras
		(command "_.ERASE" sseras "")
		(princ (strcat "\n**" AppNam "WARNING*** No elements exist to be erased\n"))
	)
	(StrtUp)
	;	Cleanup
	(if sseras	(setq sseras	nil))
	(gc)
	
	(if Bug (princ "newsht exited"))
	(princ)
)

(defun GetNam ( /	filen dir quad )			; Loads Panel by Name
	(if Bug (princ "\nGetNam entered"))
	(if (= name "")
		(setq name nil)
	)
	(if name
		(progn
;--This part of routine handles when Quad(s) already in drawing
			(setq	flag		nil
					filen	(open (strcat _PATH-DLG (strcat _DEFAULT-DIV ".dlg")) "r")
			)
			(if filen
				(progn
					(while	(and	(null flag)
								(setq inline (read-line filen))
							)
						(if (= name (strip (substr inline 1 8)))
							(progn
								(setq	flag	1)
								(command "REGENAUTO" "OFF")
								(menucmd "I=dlgicon")
								(menucmd "I=*")
								(setq dir	(getstring "\nSelect an adjacent sheet to add: "))
								(if (/= dir "0")
									(progn
										(setq	dir	(atoi dir))
										(setq	quad	(substr inline (+ (* 9 dir) 1) 8))
										(setq	quad	(strip quad))
										(if (/= quad "")
											(progn
												(princ (strcat "\nAdding sheet - " quad))
												(command	"_.LAYER"
														"T"
														"----DLG---"
														"S"
														"----DLG---"
														""
														"LIMITS"
														"OFF"
												)
												(setq	DlgFlag	"T"
														quad		(strcat _PATH-DLG quad)
												)
												(command "INSERT" quad "0,0" "" "" "")
;--if one of these flags is set, turn limit-checking back on
;;;												(if 1flag
;;;													(setvar "LIMCHECK" 1)
;;;												)
												(if (null PanLst)
													(command "ZOOM" "E")
												)
											)
											(alert (strcat "\n**" AppNam "ERROR***\nQuad sheet cannot be added in that direction."))
										)
									)
								)
							)
						)
					)
					(setq	filen	(close filen))
				)
				(alert (strcat "\n**" AppNam "ERROR***\nCannot open DLG reference file"))
			)
			(if (null flag)
				(alert (strcat "\n**" AppNam "ERROR***\nCannot find " name " in DLG ref. file"))
			)
		)
;--This part of routine handles when no Quad yet in drawing
		(progn
			(command "MENU" (strcat _PATH-MENU "DLG"))
			(menucmd "P1=QUAD1")
			(menucmd "P1=*")
			(if (setq name (strcase (getstring "\nSelect a quad sheet: ")))
				(progn
					(setq	quad	(strcat _PATH-DLG name))
					(if (findfile (strcat quad ".DWG"))
						(progn
							(command	"_.LAYER"
									"T"
									"----DLG---"
									"S"
									"----DLG---"
									""
									"LIMITS"
									"OFF"
									"INSERT"
									quad
									"0,0"
									""
									""
									""
							)
;;;							(if 1flag     ;--if one of these flags is set,
;;;								(setvar "LIMCHECK" 1)
;;;							) ;  turn limit-checking back on
							(setq	DlgFlag	"T")
						)
						(progn
							(alert (strcat "\n**" AppNam "ERROR***\nCannot find quad " name ".DWG!"))
							(setq	name	nil)
						)
					)
				)
			)
			(if (= mode "EDIT")
				(command "MENU" (strcat _PATH-MENU "ADDS"))
			)
		)
	)
	(if Bug (princ "\nGetNam exited"))
	(setq bogus nil)
)

(defun Strip	( str /	cnt )				; strip trailing blanks from quad name string
; Author:   David Cole (JG)
; Date:     September 1988 (1-12-89)
	(if Bug (princ "\nStrip routine"))
	(setq	cnt	(strlen str))
	(while	(and	(/= cnt 0)
				(= (substr str cnt 1) " ")
			)
			(setq	cnt	(1- cnt))
	)
	(if (= cnt 0)
		(setq	str	"")
		(setq	str	(substr str 1 cnt))
	)
)

(defun Map_DLG ( Doit / )					; Performs an ADE query that draws a map
	(setq	ade_cmddia_before_qry	(getvar "cmddia"))
	(setvar "cmddia" 0)
	(mapcar (quote ade_dwgdeactivate) (ade_dslist))
	(setq	ade_tmpprefval		(ade_prefgetval "ActivateDwgsOnAttach"))
	(ade_prefsetval "ActivateDwgsOnAttach" T)

	(setq	dwg_id	(ade_dsattach (strcat "D:\\" Doit ".DWG")))

	(ade_prefsetval "ActivateDwgsOnAttach" ade_tmpprefval)
	(ade_qryclear)
	(ade_qrysettype "draw")
	(ade_qrydefine (quote ("" "" "" "Location" ("window" "crossing" (323134.674622 3332384.493718 0.000000)(716854.729906 3880687.678407 0.000000))"")))
	(ade_qrysetaltprop nil)
	(ade_qryexecute)
	(setvar "cmddia" ade_cmddia_before_qry)
	(princ)
)

(defun C:GetAllADE ( /	fNam InLin InLst y x	; Calls Map_DLG for each dwg in dir InLst
					cmdVal )
	(setq	InLst	nil)
	(if (not Lst_DLG_xyn)
		(Bld_DLG_Lst)
	)
	(setq	InLst	(mapcar (quote (lambda (y) (nth 4 y))) Lst_DLG_xyn))
	(if InLst
		(progn
			(setq	cmdVal	(getvar "cmddia"))
			(setvar "cmddia" 0)
			(mapcar (quote ade_dwgdeactivate) (ade_dslist))
			(setq	ade_tmpprefval		(ade_prefgetval "ActivateDwgsOnAttach"))
			(ade_prefsetval "ActivateDwgsOnAttach" T)

			(foreach	x
					InLst
					(princ (strcat "\nTesting: " x))
					(setq	dwg_id	(ade_dsattach (strcat "D:\\" x ".DWG")))
			)

			(ade_prefsetval "ActivateDwgsOnAttach" ade_tmpprefval)
			(ade_qryclear)
			(ade_qrysettype "preview")
			(ade_qrydefine (quote ("" "" "" "Location" ("all") "")))
			(ade_qrysetaltprop nil)
			(ade_qryexecute)
			(mapcar (quote ade_dwgdeactivate) (ade_dslist))
			(setvar "cmddia" cmdVal)

		)
	)
	(princ)
)

(defun GetWinDLG ( Act /	FndL FndR GetR fNam	; Prompts for area, performs ADE 'draw' query
						InLin InLst y x cmdVal GetR InLst AliLst AliTst AliWas )
	(if (not Lst_DLG_xyn)
		(Bld_DLG_Lst)
	)
	(if (not _Path-DLG)
		(progn
			(alert (strcat "**" AppNam " Error**\nPath-DLG not defined!"))
			(exit)
		)
	)
	(setq	GetR		(Fnd_Win_DLG)
			AliLst	(ade_aliasgetlist)
			AliNam	nil
	)
	(if AliLst
		(foreach	y
				AliLst
				(setq	AliTst	(strcat (strcase (cadr y)) "\\"))
				(if AliWas
					(setq	AliWas	(cons (car y) AliWas))
					(setq	AliWas	(list (car y)))
				)
				(if (= AliTst _Path-DLG)
					(setq	AliNam	(car y))
				)
				(if Bug (princ (strcat "\nAlias: " AliTst)))
		)
	)
	(if (not AliNam)
		(if AliWas
			(progn
				(setq	AliNam	"A")
				(if (member AliNam AliWas)
					(while (member AliNam AliWas)
						(setq	AliNam	(chr (1+ (ascii AliNam))))
					)
				)
				(ade_aliasadd AliNam _Path-DLG)
			)
			(progn
				(setq	AliNam	"A")
				(ade_aliasadd AliNam _Path-DLG)
			)
		)
	)
	(if Bug (princ (strcat "\nAlias Name: " AliNam)))
	(if	GetR
		(setq	InLst	(mapcar (quote car) GetR))
		(setq	InLst	nil)
	)
	(if (and AliNam InLst)
		(progn
			(initget 1 "Yes No")
			(setq	YesNo	(getkword "\nShow all of DLG? (Yes No): "))
			(setq	cmdVal	(getvar "cmddia"))
			(setvar "cmddia" 0)
			(mapcar (quote ade_dwgdeactivate) (ade_dslist))
			(ade_prefsetval "DontAddObjectsToSaveSet" T)
			(setq	ade_1tmpprefval		(ade_prefgetval "ActivateDwgsOnAttach"))
			(ade_prefsetval "ActivateDwgsOnAttach" T)
			(setq	ade_2tmpprefval		(ade_prefgetval "MkSelSetWithQryObj"))
			(ade_prefsetval "MkSelSetWithQryObj" T)
			(foreach	x
					InLst
					(princ (strcat "\nAttaching: " x))
					(setq	dwg_id	(ade_dsattach (strcat AliNam ":\\" x ".DWG")))
			)

			(ade_prefsetval "ActivateDwgsOnAttach" ade_1tmpprefval)
			(ade_qryclear)
			(cond	((= Act 1)
						(ade_qrysettype "preview")
					)
					((= Act 2)
						(ade_qrysettype "draw")
					)
					(T
						(ade_qrysettype "preview")
					)
			)
			(if (= YesNo "Yes")
				(ade_qrydefine (quote ("" "" "" "Location" ("all") "")))
				(ade_qrydefine (quote ("" "" "" "Location" ("window" "crossing" "?") "")))
			)
			(ade_qrysetaltprop nil)
			(ade_qryexecute)
			(setq	GotItems	(ssget "P"))
			(ade_prefsetval "MkSelSetWithQryObj" ade_2tmpprefval)
			(if GotItems
				(ade_EditUnLockObjs GotItems)
			)
			(mapcar (quote ade_dwgdeactivate) (ade_dslist))
			(setvar "cmddia" cmdVal)

		)
	)
	
	;	Cleanup
	(if GotItems	(setq GotItems	nil))
	(gc)

	(princ)
)

(defun GetADLG ( Act /	FndL FndR fNam			; Prompts for point, performs ADE 'draw' query
					InLin InLst y x cmdVal GetR InLst 
					elss osecs outs ints isecs AliLst AliTst AliWas )
	(if (not Lst_DLG_xyn)
		(Bld_DLG_Lst)
	)
	(if (not _Path-DLG)
		(progn
			(alert (strcat "\n**" AppNam "Error**\nPath-DLG not defined!"))
			(exit)
		)
	)
	(setq	ints		(getvar "date")
			isecs	(* 86400.0 (- ints (fix ints)))
			GetR		(Fnd_DLG)
			AliLst	(ade_aliasgetlist)
	)
	(if AliLst
		(foreach	y
				AliLst
				(setq	AliTst	(strcat (strcase (cadr y)) "\\"))
				(if AliWas
					(setq	AliWas	(cons (car y) AliWas))
					(setq	AliWas	(list (car y)))
				)
				(if (= AliTst _Path-DLG)
					(setq	AliNam	(car y))
				)
				(if Bug (princ (strcat "\nAlias: " AliTst)))
		)
	)
	(if (not AliNam)
		(if AliWas
			(progn
				(setq	AliNam	"A")
				(if (member AliNam AliWas)
					(while (member AliNam AliWas)
						(setq	AliNam	(chr (1+ (ascii AliNam))))
					)
				)
				(ade_aliasadd AliNam _Path-DLG)
			)
			(progn
				(setq	AliNam	"A")
				(ade_aliasadd AliNam _Path-DLG)
			)
		)
	)
	(if Bug (princ (strcat "\nAlias Name: " AliNam)))
	(if	GetR
		(setq	InLst	(list (car GetR)))
		(setq	InLst	nil)
	)
	(if (and InLst AliNam)
		(progn
			(if (not DefYes)
				(initget 1 "Yes No")
			)
			(if (not DefYes)
				(setq	YesNo	(getkword "\nShow all of DLG? (Yes No): "))
				(setq	YesNo	"Yes")
			)
			(setq	cmdVal	(getvar "cmddia"))
			(setvar "cmddia" 0)
			(mapcar 'ade_dwgdeactivate (ade_dslist))
			(setq	ade_tmpprefval		(ade_prefgetval "ActivateDwgsOnAttach"))
			(ade_prefsetval "ActivateDwgsOnAttach" T)

			(foreach	x
					InLst
					(princ (strcat "\nAttaching: " x))
					(setq	dwg_id	(ade_dsattach (strcat AliNam ":\\" x ".DWG")))
			)

			(ade_prefsetval "ActivateDwgsOnAttach" ade_tmpprefval)
			(ade_qryclear)
			(cond	((= Act 1)
						(ade_qrysettype "preview")
					)
					((= Act 2)
						(ade_qrysettype "draw")
					)
					(T
						(ade_qrysettype "preview")
					)
			)
			(if (= YesNo "Yes")
				(ade_qrydefine '("" "" "" "Location" ("all") ""))
				(ade_qrydefine '("" "" "" "Location" ("window" "crossing" "?") ""))
			)
			(ade_qrysetaltprop nil)
			(ade_qryexecute)
			(mapcar 'ade_dwgdeactivate (ade_dslist))
			(setvar "cmddia" cmdVal)

		)
	)
	(setq outs (getvar "date"))
	(setq osecs (* 86400.0 (- outs (fix outs))))
	(setq elss (itoa (fix (- (* osecs 1000.0) (* isecs 1000.0)))))
	(princ (strcat "\nElapsed Milliseconds = " elss))
	(princ)
)

(defun C:ClrAde ( / )						; Clears ADE Locks
	(mapcar 'ade_dwgdeactivate (ade_dslist))
	(princ)
)

(defun Bld_DLG_Lst ( /	fNam fGet InLin )		; Function to build list of Quad Data
	(if (not _Path-LUT)
		(progn
			(alert (strcat "\n**" AppNam "Error**\nPath-LUT not defined!"))
			(exit)
		)
	)
	(if (findfile (strcat _Path-LUT "DLG_Lim.LUT"))
		(progn
			(setq	fNam		(findfile (strcat _Path-LUT "DLG_Lim.LUT"))
					fGet		(open fNam "r")
					InLin	(read-line fGet)
			)
			(while InLin
				(if InLin
					(if Lst_DLG_xyn
						(setq	Lst_DLG_xyn	(cons (read (strcat "(" InLin ")")) Lst_DLG_xyn))
						(setq	Lst_DLG_xyn	(list (read (strcat "(" InLin ")"))))
					)
				)
				(setq	InLin	(read-line fGet))
			)
			(if Lst_DLG_xyn
				(setq	Lst_DLG_xyn	(reverse Lst_DLG_xyn))
			)
			(if fGet
				(close fGet)
			)
		)
	)
	(princ)
)

(defun C:Lod_DLG ( / )						; Command line load of Quad Data
	(if (not Lst_DLG_xyn)
		(Bld_DLG_Lst)
	)
	(if Lst_DLG_xyn
		(princ (strcat "\nLoaded " (itoa (length Lst_DLG_xyn)) " listings."))
	)
	(princ)
)

(defun Fnd_DLG ( /	FndR GetR R )				; Returns Quad from point
	(if (not Lst_DLG_xyn)
		(Bld_DLG_Lst)
	)
	(setq	FndR		(getpoint "\nSelect point to test for quads: "))
	(setq	GetR		(TstDLGPnt FndR nil))
	(if (and Bug GetR)
		(if (= (type (car GetR)) 'LIST)
			(foreach	R
					GetR
					(princ (strcat "\nFound: " (nth 1 R)))
			)
			(princ (strcat "\nFound: " (nth 1 GetR)))
		)
	)
	GetR
)

(defun Fnd_Win_DLG ( /	FndL FndR GetR R )		; Returns Quad List from window
	(if (not Lst_DLG_xyn)
		(Bld_DLG_Lst)
	)
	(setq	GetR		nil
			R		nil
			FndL		(getpoint "\nSelect first corner to test for quads: ")
	)
	(if FndL
		(setq	FndR	(getcorner FndL "\nSelect second corner to test for quads: "))
	)
	(setq	GetR		(TstDLGPnt FndL FndR))
	(if (and Bug GetR)
		(if (= (type (car GetR)) 'LIST)
			(foreach	R
					GetR
					(princ (strcat "\nFound: " (nth 1 R)))
			)
			(princ (strcat "\nFound: " (nth 1 R)))
		)
	)
	GetR
)

(defun TstDLGPnt ( FndL FndR /	OutLst WrkX	; Tests DLG's against 1 or 2 points to find members
							WrkY Bubba WrkXA WrkXB WrkYA WrkYB )
	(setq	OutLst	nil
			Etak_Lst	nil
	)
	(if (not Lst_DLG_xyn)
		(Bld_DLG_Lst)
	)
	(if Etak_Me
		(setq	Etak_Lst	(list "(setq ade_cmddia_before_qry (getvar \"cmddia\"))")
				Etak_Lst	(cons "(setvar \"cmddia\" 0)" Etak_Lst)
				Etak_Lst	(cons "(if (not BrkRect) (load \"DlgLod\"))" Etak_Lst)
				Etak_Lst	(cons "(if (not Ft2Mt) (load \"Utils\"))" Etak_Lst)
				Etak_Lst	(cons "(command \"_.-Layer\" \"M\" \"Dlg_Etak\" \"C\" \"6\" \"\" \"M\" \"Dlg_Etak_cl\" \"C\" \"1\" \"\" \"M\" \"Dlg_Etak_cl_name\" \"C\" \"2\" \"\" \"M\" \"Dlg_Etak_co_name\" \"C\" \"3\" \"\" \"\")" Etak_Lst)
				Etak_Lst	(cons "(mapcar \'ade_dwgdeactivate (ade_dslist))" Etak_Lst)
				Etak_Lst	(cons "(ade_prefsetval \"DontAddObjectsToSaveSet\" T)" Etak_Lst)
				Etak_Lst	(cons "(setq ade_2tmpprefval (ade_prefgetval \"MkSelSetWithQryObj\"))" Etak_Lst)
				Etak_Lst	(cons "(ade_prefsetval \"MkSelSetWithQryObj\" T)" Etak_Lst)
				Etak_Lst	(cons "(setq ade_tmpprefval (ade_prefgetval \"ActivateDwgsOnAttach\"))" Etak_Lst)
				Etak_Lst	(cons "(ade_prefsetval \"ActivateDwgsOnAttach\" T)" Etak_Lst)
				Etak_Lst	(cons "(setq dwg_id (ade_dsattach \"W:\\Etak_Map.dwg\"))" Etak_Lst)
				Etak_Lst	(cons "(ade_prefsetval \"ActivateDwgsOnAttach\" ade_tmpprefval)" Etak_Lst)
				Etak_Lst	(cons "(ade_rtdefrange \"ETAK_LAYER\" \"Etak Layer\" \'((\"=\" \"0ROADCL\" \"Dlg_etak_cl\")(\"=\" \"10ROADCL\" \"Dlg_etak_co_name\")(\"=\" \"1ROADCL\" \"Dlg_etak_cl_name\")(\"otherwise\" \"\" \"Dlg_etak\")))" Etak_Lst)
				Etak_Lst	(cons "(ade_rtdefrange \"ETAK_COLOR\" \"Etak Color\" \'((\"<\" 15 256)(\"otherwise\" \"\" 256)))" Etak_Lst)
				Bubba	(princ "\nRunning TstDLGPnt - Etak Me!")
		)
		(if Bug (princ "\nNOT Running TstDLGPnt - Etak Me!"))
	)
	(cond	((and FndR (not FndL))
				(if Bug (princ "\nOption 1"))
				(setq	WrkX		(car FndR)
						WrkY		(cadr FndR)
				)
				(foreach	x
						Lst_DLG_xyn
						(if	(and	(>= WrkX (nth 0 x))
								(>= WrkY (nth 1 x))
								(<= WrkX (nth 2 x))
								(<= WrkY (nth 3 x))
							)
							(if OutLst
								(setq	OutLst	(append OutLst (list (nth 4 x) (nth 5 x)))
										Bubba	(if Bug (princ (strcat "\nFound: " (nth 5 x))))
								)
								(setq	OutLst	(list (nth 4 x) (nth 5 x))
										Bubba	(if Bug (princ (strcat "\nFound: " (nth 5 x))))
								)
							)
						)
				)
			)
			((and (not FndR) FndL)
				(if Bug (princ "\nOption 2"))
				(setq	WrkX		(car FndL)
						WrkY		(cadr FndL)
				)
				(foreach	x
						Lst_DLG_xyn
						(if	(and	(>= WrkX (nth 0 x))
								(>= WrkY (nth 1 x))
								(<= WrkX (nth 2 x))
								(<= WrkY (nth 3 x))
							)
							(if OutLst
								(setq	OutLst	(append OutLst (list (nth 4 x) (nth 5 x)))
										Bubba	(if Bug (princ (strcat "\nFound: " (nth 5 x))))
								)
								(setq	OutLst	(list (nth 4 x) (nth 5 x))
										Bubba	(if Bug (princ (strcat "\nFound: " (nth 5 x))))
								)
							)
						)
				)
			)
			((and FndR FndL)
				(if Bug (princ "\nOption 3"))
				(if	(< (car FndL) (car FndR))
					(setq	WrkXA	(car FndL)
							WrkXB	(car FndR)
					)
					(setq	WrkXA	(car FndR)
							WrkXB	(car FndL)
					)
				)
				(if	(< (cadr FndL) (cadr FndR))
					(setq	WrkYA	(cadr FndL)
							WrkYB	(cadr FndR)
					)
					(setq	WrkYA	(cadr FndR)
							WrkYB	(cadr FndL)
					)
				)
				(foreach	x
						Lst_DLG_xyn
						(setq	Trigger	nil)
						(if	(or	(and	(and	(<= WrkXA (nth 0 x)) (>= WrkXB (nth 0 x)))
									(and	(<= WrkYA (nth 1 x)) (>= WrkYB (nth 1 x)))
								)	; If Lower Left is within range...
								(and	(and	(<= WrkXA (nth 2 x)) (>= WrkXB (nth 2 x)))
									(and	(<= WrkYA (nth 3 x)) (>= WrkYB (nth 3 x)))
								)	; If Upper Right is within range...
								(and	(and	(<= WrkXA (nth 0 x)) (>= WrkXB (nth 0 x)))
									(and	(<= WrkYA (nth 3 x)) (>= WrkYB (nth 3 x)))
								)	; If Lower Right is within range...
								(and	(and	(<= WrkXA (nth 2 x)) (>= WrkXB (nth 2 x)))
									(and	(<= WrkYA (nth 1 x)) (>= WrkYB (nth 1 x)))
								)	; If Upper Left is within range...
								(and	(>= WrkXA (nth 0 x))
									(>= WrkYA (nth 1 x))
									(<= WrkXA (nth 2 x))
									(<= WrkYA (nth 3 x))
								)	; If Point A is totally enclosed
								(and	(>= WrkXB (nth 0 x))
									(>= WrkYB (nth 1 x))
									(<= WrkXB (nth 2 x))
									(<= WrkYB (nth 3 x))
								)	; If Point B is totally enclosed
								(and	(and	(>= WrkXA (nth 0 x)) (<= WrkXB (nth 2 x)))
									(and	(<= WrkYA (nth 1 x)) (>= WrkYB (nth 3 x)))
								)	; If Vertically Striped in range...
								(and	(and	(<= WrkXA (nth 0 x)) (>= WrkXB (nth 2 x)))
									(and	(>= WrkYA (nth 1 x)) (<= WrkYB (nth 3 x)))
								)	; If Horizontally Striped in range...
							)
							(if OutLst
								(setq	OutLst	(append OutLst (list (list (nth 4 x) (nth 5 x))))
										Trigger	T
										Bubba	(if Bug (princ (strcat "\nFound: " (nth 5 x))))
								)
								(setq	OutLst	(list (list (nth 4 x) (nth 5 x)))
										Trigger	T
										Bubba	(if Bug (princ (strcat "\nFound: " (nth 5 x))))
								)
							)
						)
						(if (and Trigger Etak_Me)
							(progn
								(setq	Etak_Lst	(cons "(ade_qryclear)" Etak_Lst)
										Etak_Lst	(cons "(ade_qrysettype \"draw\")" Etak_Lst)
										Etak_Lst	(cons	(strcat	"(ade_qrydefine \'(\"\" \"\" \"\" \"Location\" (\"polygon\" \"crossing\" ("
																(rtos (nth 0 x) 2 4)
																" "
																(rtos (nth 1 x) 2 4)
																" 0.0000)("
																(rtos (nth 2 x) 2 4)
																" "
																(rtos (nth 1 x) 2 4)
																" 0.0000)("
																(rtos (nth 2 x) 2 4)
																" "
																(rtos (nth 3 x) 2 4)
																" 0.0000)("
																(rtos (nth 0 x) 2 4)
																" "
																(rtos (nth 3 x) 2 4)
																" 0.0000"
																"))\"\"))"
														)
														Etak_Lst
												)
										Etak_Lst	(cons "(ade_qrysetaltprop T)" Etak_Lst)
										Etak_Lst	(cons "(ade_altpclear)" Etak_Lst)
										Etak_Lst	(cons "(ade_altpdefine \"layer\" \"(Range .layer ETAK_LAYER)\")" Etak_Lst)
										Etak_Lst	(cons "(ade_altpdefine \"color\" \"(Range .layer ETAK_COLOR)\")" Etak_Lst)
										Etak_Lst	(cons "(ade_qryexecute)" Etak_Lst)
										Etak_Lst	(cons	(strcat	"(BrkRect (list "
																(rtos (nth 0 x) 2 4)
																" "
																(rtos (nth 1 x) 2 4)
																") (list "
																(rtos (nth 2 x) 2 4)
																" "
																(rtos (nth 3 x) 2 4)
																"))"
														)
														Etak_Lst
												)
										Etak_Lst	(cons	(strcat	"(command \"Wblock\" \""
																(if (equal (getvar "ACADVER") "14.0")	;	AutoCAD r14 February 1997
																	"H:\\\\Project Files\\\\Drawings\\\\Misc\\\\Etak\\\\Quads\\\\"
																	"H:\\\\Project Files\\\\Drawings\\\\Misc\\\\Etak\\\\Quad2000\\\\"
																)
																(nth 4 x)
																"\" \"\" \"0,0\" \"All\" \"\" \"N\")"
														)
														Etak_Lst
												)
										Etak_Lst	(cons	(strcat	"(princ \"\\nWe finished outputting "
																(nth 5 x)
																"!\")"
														)
														Etak_Lst
												)
								)
							)
						)
				)
			)
	)
	(if (> (length Etak_Lst) 12)
		(progn
			(setq	Etak_Lst	(cons "(setvar \"cmddia\" ade_cmddia_before_qry)" Etak_Lst)
					Etak_Lst	(cons "(command \"_.Quit\" \"Y\")" Etak_Lst)
					Etak_Lst	(reverse Etak_Lst)
			)
			(princ (strcat "\nWriting Etak Query with length of {" (itoa (length Etak_Lst)) "} lines\n"))
			(setq	Etak_Fil	(open "Etak_Qry.Qry" "w"))
			(mapcar '(lambda (x) (write-line x Etak_Fil)) Etak_Lst)
			(close Etak_Fil)
		)
	)
	OutLst
)

(defun BrkRect ( Pt1 Pt2 ssQuad /	MinX MinY			; Breaks Rectangle edges
						MaxX MaxY Elast
						ssBrk Enew EntDuz adeSS status )
	(if Bug (princ "\n{BrkRect entered}\n"))
	(command "_.Layer" "T" "*" "ON" "*" "U" "*" "S" "0" "" "_.Zoom" "E")
	(setq	MinX		(car Pt1)
			MinY		(cadr Pt1)
			MaxX		(car Pt2)
			MaxY		(cadr Pt2)
			ssBrk	(if ssQuad ssQuad (ssget "X") )
	)
	(command	"_.PLINE"
			(list MinX MinY)
			"W"
			"0.0"
			"0.0"
			(list MaxX MinY)
			(list MaxX MaxY)
			(list MinX MaxY)
			"C"
	)
	(setq	Elast	(entlast))
	(setq adeSS (Map_DwgBreakObj ssBrk Elast 1 0))
	(setq	Enew		(entnext Elast))
	(if Enew
		(progn
			(setq	EntDuz	(list Enew))
			(while (setq Enew (entnext Enew))
				(if Enew
					(setq	EntDuz	(append EntDuz (list Enew)))
				)
			)
		)
		(setq	EntDuz	nil)
	)
;	(command "_.ERASE" "All" "R" "W" (list (- MinX 10.0) (- MinY 10.0)) (list (+ MaxX 10.0) (+ MaxY 10.0)) "A" Elast "")
;	(command "_.ERASE" ssQuad "R" "W" (list (- MinX 10.0) (- MinY 10.0)) (list (+ MaxX 10.0) (+ MaxY 10.0)) "A" Elast "")
	(command "_.ERASE" Elast "")
	(setq ssWant (ssget "C" Pt2 Pt1 (list(cons 8 "DLG*"))))
	(setq ssMost (ssget "X" (list(cons 8 "DLG*"))))
	(if (and ssWant ssMost)
		(command "_.Erase" ssMost "R" ssWant "")
	)
	;	Cleanup
	(if adeSS
		(setq status (ade_ssfree adeSS))
	)
	(if ssBrk	(setq ssBrk	nil))
	(gc)

	 (command ".zoom" "p")
	(if Bug (princ "\n{BrkRect exited}\n"))
	(princ)
)

(defun DoBackDLG ( M_LL M_UR Act /			; Performs 'Insert' command for Quads - much faster!
								GetR InLst x OutSS )
	(if Bug 
		(progn
			(princ "\nDlgLoad.lsp!DoBackDLG - Enter")
			(princ "\n   Paramters M_LL : ")(prin1 M_LL)
			(princ "\n             M_UR : ")(prin1 M_UR)
			(princ "\n               Act: ")(prin1 Act)
		)
	)
	(if (not Lst_DLG_xyn)
		(Bld_DLG_Lst)
	)
	(if (not _Path-DLG)
		(progn
			(alert (strcat "**" AppNam " Error**\nPath-DLG not defined!"))
			(exit)
		)
	)
	(if (= 0 (getvar "tilemode"))				;Move to Model Space and leave breadcrumbs to return if needed
		(if (= 1 (getvar "cvport"))
			(progn
				(command "_.MSpace")
				(setq	BackToPS	T)
			)
			(setq	BackToPS	nil)
		)
		(setq	BackToPS	nil)
	)
	(setq	GetR		(TstDLGPnt M_LL M_UR))	;Find all DLG's in window
	(if	GetR
		(setq	InLst	(mapcar (quote car) GetR)
				Bubba	(if Bug (princ (strcat "\nBug:GetR:InLst of {" (itoa (length InLst)) "} items Found")))
		)
		(setq	InLst	nil
				Bubba	(if Bug (princ (strcat "\nBug:GetR:InLst Not Found")))
		)
	)
	(if InLst
		(foreach	x
				InLst
				
				(if (findfile (strcat _Path-DLG x ".dwg"))
					(progn
						(command "_.Insert" (strcat "*" _Path-DLG x) "0,0" "1" "0")
						(princ (strcat "\nInserted: " x))
					)
					(princ (strcat "\nCannot Insert: " x))
				)
		)
	)
	(if (and WlX WlY WuX WuY (wcmatch (StpDot AppNam) "ADDSPLOT"))
		(setq	OutSS	(ssget "c" (list WlX WlY) (list WuX WuY) (list (cons 0 "POLYLINE") (cons 8 "DLG*"))))
		(setq	OutSS	nil)
	)
	(BrkRect (list WlX WlY) (list WuX WuY) OutSS)	; ET mod
	(if (and OutSS WlX WlY WuX WuY (wcmatch (StpDot AppNam) "ADDSPLOT"))
		(if (or (= Div "S_") (= Div "SE"))
			(if (findfile "C:\\Program Files\\Autodesk\\AutoCAD 2019\\Express\\MPedit.Lsp")
				(progn
					(load "C:\\Program Files\\Autodesk\\AutoCAD 2019\\Express\\MPedit")
					(if OutSS
						(ChgPLWidths OutSS 1.0)
					)
				)
			)
			(if (findfile "C:\\Program Files\\Autodesk\\AutoCAD 2019\\Express\\MPedit.Lsp")
				(progn
					(load "C:\\Program Files\\Autodesk\\AutoCAD 2019\\Express\\MPedit")
					(if OutSS
						(ChgPLWidths OutSS 10.0)
					)
				)
			)
		)
	)
	(if (and LayChk (wcmatch (StpDot AppNam) "ADDSPLOT"))
		(if (LayChk "DLG*")
			(command "_.-Layer" "C" "254" "DLG*" "")
		)
	)
	(setq	OutSS	nil)
	(if (and prtdesc (wcmatch (StpDot AppNam) "ADDSPLOT"))
		(cond
			((= (strcase prtdesc) "DWG")
				(princ (strcat "\nNo DrawOrder attempt for output type: {" desc "}\n"))
			)
			((= (strcase prtdesc) "DXF")
				(princ (strcat "\nNo DrawOrder attempt for output type: {" desc "}\n"))
			)
			((= (strcase prtdesc) "DWF")
				(princ (strcat "\nNo DrawOrder attempt for output type: {" desc "}\n"))
			)
			(T
				(setq	OutSS	(ssget "c" (list WlX WlY) (list WuX WuY) (list (cons 8 "DLG*"))))
				(if OutSS
					(princ (strcat "\nNow attempting to DrawOrder the Quads to the background {" (itoa (sslength OutSS)) " items}..."))
				)
				(if OutSS
					(command "_DrawOrder" OutSS "" "B")
					(princ "\nNo OutSS found!")
				)
			)
		)
	)
	(if BackToPS
		(progn
			(command "_.tilemode" 1)
			(command "_.PSpace")
		)
	)
	;	Cleanup
	(if OutSS	(setq OutSS	nil))
	(gc)

	(if Bug (princ "\nDlgLoad.lsp!DoBackDLG - Done"))
	(princ)
)

(defun DoBackDLG_Old ( M_LL M_UR Act /	FndL FndR	; Prompts for area, performs ADE 'draw' query
								GetR fNam InLin InLst y x cmdVal
								InLst AliLst AliTst AliWas )
	(if (not Lst_DLG_xyn)
		(Bld_DLG_Lst)
	)
	(if (not _Path-DLG)
		(progn
			(alert (strcat "**" AppNam " Error**\nPath-DLG not defined!"))
			(exit)
		)
	)
	(setq	GetR		(TstDLGPnt M_LL M_UR)
			AliLst	(ade_aliasgetlist)
			AliNam	nil
	)
	(if AliLst
		(foreach	y
				AliLst
				(setq	AliTst	(strcat (strcase (cadr y)) "\\"))
				(if AliWas
					(setq	AliWas	(cons (car y) AliWas))
					(setq	AliWas	(list (car y)))
				)
				(if (= AliTst _Path-DLG)
					(setq	AliNam	(car y))
				)
				(if Bug (princ (strcat "\nAlias: " AliTst)))
		)
	)
	(if (not AliNam)
		(if AliWas
			(progn
				(setq	AliNam	"A")
				(if (member AliNam AliWas)
					(while (member AliNam AliWas)
						(setq	AliNam	(chr (1+ (ascii AliNam))))
					)
				)
				(ade_aliasadd AliNam _Path-DLG)
			)
			(progn
				(setq	AliNam	"A")
				(ade_aliasadd AliNam _Path-DLG)
			)
		)
	)
	(if Bug (princ (strcat "\nAlias Name: " AliNam)))
	(if	GetR
		(setq	InLst	(mapcar (quote car) GetR))
		(setq	InLst	nil)
	)
	(if (and AliNam InLst)
		(progn
			(initget 1 "Yes No")
			(setq	YesNo	"Yes"
					cmdVal	(getvar "cmddia")
			)
			(setvar "cmddia" 0)
			(mapcar (quote ade_dwgdeactivate) (ade_dslist))
			(ade_prefsetval "DontAddObjectsToSaveSet" T)
			(setq	ade_1tmpprefval		(ade_prefgetval "ActivateDwgsOnAttach"))
			(ade_prefsetval "ActivateDwgsOnAttach" T)
			(setq	ade_2tmpprefval		(ade_prefgetval "MkSelSetWithQryObj"))
			(ade_prefsetval "MkSelSetWithQryObj" T)
			(foreach	x
					InLst
					(princ (strcat "\nAttaching: " x))
					(setq	dwg_id	(ade_dsattach (strcat AliNam ":\\" x ".DWG")))
			)

			(ade_prefsetval "ActivateDwgsOnAttach" ade_1tmpprefval)
			(ade_qryclear)
			(cond	((= Act 1)
						(ade_qrysettype "preview")
					)
					((= Act 2)
						(ade_qrysettype "draw")
					)
					(T
						(ade_qrysettype "preview")
					)
			)
			(if (= YesNo "Yes")
				(ade_qrydefine (quote ("" "" "" "Location" ("all") "")))
				(ade_qrydefine (quote ("" "" "" "Location" ("window" "crossing" "?") "")))
			)
			(ade_qrysetaltprop nil)
			(ade_qryexecute)
			(setq	GotItems	(ssget "P"))
			(ade_prefsetval "MkSelSetWithQryObj" ade_2tmpprefval)
			(if GotItems
				(ade_EditUnLockObjs GotItems)
			)
			(mapcar (quote ade_dwgdeactivate) (ade_dslist))
			(setvar "cmddia" cmdVal)
			(command "_.-Layer" "C" "254" "DLG*" "")
					;InSS		(ssget "w" (list WlX WlY) (list WuX WuY) (list (cons 0 "Insert")))
			(setq	OutSS	(ssget "c" (list WlX WlY) (list WuX WuY) (list (cons 8 "DLG*"))))
			(if OutSS
				(princ "\nNow attempting to DrawOrder the Quads to the background 2...")
			)
			(if OutSS
				(command "_DrawOrder" OutSS "" "B")
				(princ "\nNo OutSS found!")
			)
		)
	)
	;	Cleanup
	(if GotItems	(setq GotItems	nil))
	(gc)

	(princ)
)

(setq	LodVer	"3.0.0a")
