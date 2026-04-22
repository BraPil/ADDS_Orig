(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " Custom Loading."))
	(princ "\nAddsPlot Custom Loading.")
)

(defun Sym_Color ( /	VPStuff PtLL PtUR PtCen	; Layer Phase Change
					GetBlk BlkObj Cntr Bubba Obj Eblk ELay NLay
					LayLst WrkLst LayTmp GetSSl WrkObj LayTst LayN LayTmp x LayOop )
;;;	Uses these funtions internally:
;;;		Tables		(Tables)
;;;		GetSelVals	(Utils)
;;;		Twizzle		(Utils)
;;;		ForceLay		(Utils)
;;;		LayUpdObj		(Utils)
;;;		MKLay		(Symbols)
	(if Bug (princ "\n{Sym_Color entered\n"))
	(if EdCode
		(if (= (strcase (getvar "loginname")) "GEWILYMS")
			(setq	Bug		T
					*error*	nil
			)
		)
	)
	(if (not (and Lst_Fd_C Lst_Fd_V))
		(if (not Tables)
			(progn
				(load "Tables")
				(Tables)
			)
			(Tables)
		)
	)
	(if (not GetSelVals)
		(load "Utils")
	)
	(if (not MKLay)
		(load "Symbols")
	)
	(if (not EntNamGrp)
		(if (findfile "Panel.Lsp")
			(load (findfile "Panel.Lsp"))
			(load "C:\\Div_Map\\Adds\\Lisp\\Panel.Lsp")
		)
	)
	(if Bug
		(princ	(strcat	"\nSomething wrong?:\n"
						(if DivPretend	"\t1.) Acad loaded... \n"	"\t1.) Acad not loaded!\n")
						(if MKLay		"\t2.) Symbols loaded... \n"	"\t2.) Symbols not loaded!\n")
						(if Tables	"\t3.) Tables loaded... \n"	"\t3.) Tables not loaded!\n")
						(if GetSelVals	"\t4.) Utils loaded... \n"	"\t4.) Utils not loaded!\n")
						(if EntNamGrp	"\t5.) Panel loaded... \n"	"\t5.) Panel not loaded!\n")
				)
		)
	)
	(setq	VPStuff	(ViewPorter)
			PtLL		(nth 8 VPStuff)
			PtUR		(nth 9 VPStuff)
			PtCen	(nth 7 VPStuff)
	)
	(if (/= 0 (getvar "tilemode"))
		(command "_.tilemode" 0)
	)
	(if (= 1 (getvar "cvport"))
		(command "_.MSpace")
	)
	(setvar "REGENMODE" 1)
	(setvar "OSMODE" 0)
	(setvar "EXPERT" 5)
	(princ "\nGathering Layer List...")
	(command "_.LAYER" "_T" "*" "_ON" "*" "_U" "*" "_S" "0" "") ;  "_.ZOOM" "_E" "_.ZOOM" "0.7x"
	(setq	DelBlk	(ssget "C"	PtLL PtUR
								(list	(cons 0 "INSERT")
										(cons 67 0)
										(cons -4 "<OR")
											(cons 2 "_CC_?")
											(cons 2 "LFSP")
											(cons 2 "FLAG")
											(cons 2 "A148")
										(cons -4 "OR>")
								)
					)
	)
	(if DelBlk
		(command "_.Erase" DelBlk "")
	)
	(setq	GetBlk	(ssget "C"	PtLL PtUR
								(list	(cons -4 "<OR")
											(cons 2 "_CC_?")
											(cons 2 "_FI_?")
											(cons 2 "_KEY")
											(cons 2 "_SGEN")
											(cons 2 "_OCR*")
											(cons 2 "_CATV")
											(cons 2 "SENSOR")
											(cons 2 "LFSP")
											(cons 2 "A148")	;_CC_?
											(cons 2 "A106")	;_FI_?
											(cons 2 "A183")	;_Key
											(cons 2 "A104")	;_SGEN
											(cons 2 "A105")	;_OCR*
											(cons 2 "A169")	;_OCR*
											(cons 2 "A193")	;_OCR*
											(cons 2 "A194")	;_OCR*
											(cons 2 "A100")	;_CATV
											(cons 2 "A155")	;SENSOR
										(cons -4 "OR>")
								)
					)
	)
	(if GetBlk
		(setq	BlkObj	(EntNamGrp GetBlk)
				Cntr		0
				Bubba	(princ (strcat "\nWorking " (itoa (length BlkObj)) " Mobile Blocks."))
		)
	)
	(if BlkObj
		(foreach	Obj
				BlkObj
				(Twizzle Cntr)
				(setq	Cntr		(1+ Cntr)
						Eblk		(entget Obj)
						ELay		(cdr (assoc 8 Eblk))
				)
				(if (> (strlen ELay) 9)
					(progn
						(setq	NLay		(strcat	(substr ELay 1 4)
												"CE"
												(substr ELay 7)
										)
						)
						(if Bug (princ (strcat "\nFrom {" ELay "} to {" NLay "} ")))
						(if (not (tblsearch "LAYER" NLay))
							(MKLay NLay)
						)
						(setq	Eblk		(subst	(cons 8 NLay)
												(assoc 8 Eblk)
												Eblk
										)
						)
						(entmod Eblk)
						(entupd Obj)
					)
				)
		)
	)
	(if Cntr
		(Twizzle (- 0 Cntr))
	)
	(setq	Cntr		0
			LayLst	nil
			WrkLst	nil
			LayTmp	nil
			GetSSl	nil
			WrkObj	nil
			LayTst	(nth 1 (GetSelVals))
			LayN		(tblnext "LAYER" T)
			LayTmp	(list (cdr (assoc 2 LayN)))
	)
	(while (setq LayN (tblnext "LAYER"))
		(if LayN
			(setq	LayTmp	(cons (cdr (assoc 2 LayN)) LayTmp))
		)
	)
	(if (and LayTmp Bug) (princ (strcat "\nFound " (itoa (length LayTmp)) " layers!")))
	(if LayTst
		(foreach		x
					LayTmp
					(Twizzle Cntr)
					(setq	Cntr	(1+ Cntr))
					(if (= (strlen x) 10)
						(if (member (substr x 1 3) LayTst)
							(if LayLst
								(setq	LayLst	(append LayLst (list x)))
								(setq	LayLst	(list x))
							)
							(if Bug (princ "."))
						)
					)
		)
		(setq	LayLst	nil)
	)
	(Twizzle (- 0 Cntr))
	(setq	Cntr		0
			LayOop	0
	)
	(if (and LayLst Bug) (princ (strcat "\nFound " (itoa (length LayLst)) " working layers!")))
	(if LayLst
		(foreach		x
					LayLst
					(Twizzle Cntr)
					(setq	Cntr	(1+ Cntr)
							LayW	(ForceLay x)
					)
					(if LayW
						(if WrkLst
							(setq	WrkLst	(append WrkLst LayW)
									LayOop	(1+ LayOop)
							)
							(setq	WrkLst	LayW
									LayOop	(1+ LayOop)
							)
						)
					)
		)
		(if Bug (princ "\nBug:No LayLst"))
	)
	(if LayLst
		(Twizzle (- 0 Cntr))
	)
	(setq	Cntr		0)
	(if WrkLst
		(progn
			(princ (strcat "\nExecuting " (itoa LayOop) " Layer Changes..."))
			(setq	WrkLst	(cons "C" (reverse WrkLst))
					WrkLst	(cons "6" WrkLst)
					WrkLst	(cons "????CE*" WrkLst)
					WrkLst	(cons "C" WrkLst)
					WrkLst	(cons "7" WrkLst)
					WrkLst	(cons "????CED*" WrkLst)
					WrkLst	(cons "" WrkLst)
					WrkLst	(cons "_.LAYER" (reverse WrkLst))
			)
			(mapcar (quote command) WrkLst)
		)
		(progn
			(if Bug (princ "\nBug:No WrkLst"))
			(princ (strcat "\nExecuting 2 Layer Changes..."))
			(setq	WrkLst	(list "C")
					WrkLst	(cons "6" WrkLst)
					WrkLst	(cons "????CE*" WrkLst)
					WrkLst	(cons "C" WrkLst)
					WrkLst	(cons "7" WrkLst)
					WrkLst	(cons "????CED*" WrkLst)
					WrkLst	(cons "" WrkLst)
					WrkLst	(cons "_.LAYER" (reverse WrkLst))
			)
			(mapcar (quote command) WrkLst)
		)
		
	)
	(princ "\nGathering Objects to update...")
	(setq	LayFltStr	(list (cons 8 "[~-]?????[BTD-]???")))
	(setq	FltrStr	(list	(cons 0 "INSERT"))
			TstStr	(cons	(cons -4 "OR>") (reverse LayFltStr))
			TstStr	(cons	(cons -4 "<OR") (reverse TstStr))
			TstStr	(append TstStr FltrStr)
			TstStr	(cons	(cons -4 "AND>") (reverse TstStr))
			TstStr	(cons	(cons -4 "<AND") (reverse TstStr))
			GetSSl	(ssget "C" PtLL PtUR TstStr)
	)
	(if GetSSl
		(setq	WrkObj	(EntNamGrp GetSSl)
				Cntr		0
				Bubba	(princ (strcat "\nWorking " (itoa (length WrkObj)) " objects."))
		)
		(setq	WrkObj	nil
				Cntr		0
				Bubba	(if Bug (princ "\nBug:No GetSSL"))
		)
	)
	(if TstRpt
		(setq	TstRpt	nil)		; Force LayUpdObj to _not_ collect PLine Length data
	)
	(if WrkObj
		(foreach	Obj
				WrkObj
				(Twizzle Cntr)
				(setq	Cntr	(1+ Cntr))
				(LayUpdObj Obj nil)
		)
	)
	(Twizzle (- 0 Cntr))
	(setq	Cntr		0)
	(if kv_strlst
		(command "_.LAYER" "_F" kv_strlst "_S" "0" "")
		(command "_.LAYER" "_F" "????CP*" "_S" "0" "")
	)
	(if (tblsearch "BLOCK" "NO")
		(command "_.INSERT" (strcat "NO=" _Path-Sym "NO") PtCen "" "" "" "_.Erase" "L" "")
	)
	(command "_.Pspace")
	
	;	Cleanup
	(setvar "FILEDIA" 1)
	(setvar "CMDDIA" 1)
	(if DelBlk	(setq DelBlk	nil))
	(if GetBlk	(setq GetBlk	nil))
	(if GetSSl	(setq GetSSl	nil))
	(gc)
	
	(if Bug (princ "\nSym_Color exited}\n"))
	(princ)
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(Sym_Color)
	(setq	LodVer	"3.0.1")
)
