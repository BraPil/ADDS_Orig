(if AppNam								; Code Version Indicator {2776 Lines of Code} [19 functions]
	(princ (strcat "\n" AppNam " RER_Chk Loading."))
	(princ "\nAdds RER_Chk Loading.")
)

(defun StyMChk ( /	ssMTx CntR CntM entM		;Makes all MText use Arial Bold ttf
				strM strM3 )
	(setq	ssMTx	(ssget "X" (list (cons 0 "MTEXT")))
			CntR		0
			CntM		0
	)
	(if ssMTx (princ (strcat "\nFound [" (itoa (sslength ssMTx)) "] MText entities")))
	(if ssMTx
		(while (< CntR (sslength ssMTx))
			(if (not Bug) (Twizzle CntR))
			(setq	entM	(entget (ssname ssMTx CntR) (list "*"))
					strM	(cdr (assoc 1 entM))
			)
			(if (assoc 3 entM)
				(setq	strM3	(cdr (assoc 3 entM)))
				(setq	strM3	nil)
			)
			(if (wcmatch (strcase strM t) "\\f*;*")
				(setq	strM		(strcat "\\fArial|b1|i0|c0|p34;" (substr strM (1+ (InStr strM 59))))
						entM		(subst (cons 1 strM) (assoc 1 entM) entM)
						entM		(if (assoc 7 entM)
									(subst (cons 7 "STANDARD") (assoc 7 entM) entM)
								)
						bubba	(entmod entM)
						CntM		(1+ CntM)
				)
			)
			(if strM3
				(if (wcmatch (strcase strM3 t) "\\f*;*")
					(setq	strM3		(strcat "\\fArial|b1|i0|c0|p34;" (substr strM3 (1+ (InStr strM3 59))))
							entM		(subst (cons 3 strM3) (assoc 3 entM) entM)
							entM		(if (assoc 7 entM)
										(subst (cons 7 "STANDARD") (assoc 7 entM) entM)
									)
							bubba	(entmod entM)
							CntM		(1+ CntM)
					)
				)
			)
			(setq	CntR	(1+ CntR))
		)
	)
	(Twizzle (- 0 CntR))
	(if (> CntM 0) (princ (strcat "\nFixed [" (itoa CntM) "] MText entities!")))
	CntM
)

(defun C:StyMChk ( / )						; CL for StyMChk
	(if (/= (getvar "TILEMODE") 1)
		(progn
			(setq	TileWas	(getvar "TILEMODE"))
			(setvar "TILEMODE" 1)
		)
	)
	(setq	LayLst	(LayWhat)
			LayStr	nil
			LayWrk	nil
	)
	(if (nth 1 LayLst)
		(setq	LayWrk	(mapcar (quote car) (nth 1 LayLst))
				LayStr	(car LayWrk)
				LayWrk	(cdr LayWrk)
				Bubba	(mapcar (quote (lambda (x) (setq LayStr (strcat LayStr "," x)))) LayWrk)
		)
	)
	(if LayStr
		(progn
			(if (assoc "MASK" (nth 0 LayLst))
				(setq	LayStr	(strcat LayStr ",MASK"))
			)
			(if (= Div "W_")
				(progn
					(if (assoc "SCAN" (nth 0 LayLst))
						(setq	LayStr	(strcat LayStr ",SCAN"))
					)
					(if (assoc "VPORT" (nth 0 LayLst))
						(setq	LayStr	(strcat LayStr ",VPORT"))
					)
				)
			)
		)
	)
	(command	"_.LAYER" "T" "*" "U" "*" "On" "*" "S" "0" "" "_.Zoom" "E" "_.Zoom" "0.8x")
	(setq	MstCntLst	(StyMChk))
	(if (> MstCntLst 0)
		(progn
			(command "_.Purge" "A" "*" "N")
			(command "_.Purge" "A" "*" "N")
			(command "_.Purge" "A" "*" "N")
			(command "_.Purge" "A" "*" "N")
			(if (assoc "0" (nth 0 LayLst))
				(setq	LayT	"0")
				(progn
					(setq	CntR	0
							LayT	(caaar LayLst)
					)
					(while (not (LayChk LayT))
						(setq	CntR	(1+ CntR)
								LayT	(car (nth CntR (car LayLst)))
						)
					)
				)
			)
			(command	"_.LAYER" "S" LayT "F" LayStr "" "_.Zoom" "E" "_.Zoom" "0.8x")
			(setvar "ORTHOMODE" 0)
			(setvar "OSMODE" 0)
			(if TileWas
				(if (/= TileWas 1)
					(setvar "TILEMODE" TileWas)
				)
			)
			(command "_.Qsave")
		)
	)
	(princ)
)

(defun DwfPathR ( Dnam / )
	(cond
		((member (strcase (substr Dnam 1 3))	(list	"WBW" "WCE" "WE5" "WE6" "WE7" "WE8" "WE9" "WEA" "WEB" "WEC" 
												"WED" "WEE" 
										)
		 )
			(setq	_Path-Dwf		"S:/Workgroups/APC Power Delivery/Division Mapping/Public/Tuscaloosa/Underground/Centreville/")
		)
		((member (strcase (substr Dnam 1 3))	(list	"WCW" "WD8" "WGM" "WGW" "WH0" "WHC" "WHU" "WHV" "WHW" "WHX" 
												"WHY" "WHZ" "WI0" "WI1" "WI2" "WI3" "WI4" "WI5" "WI6" "WI7" 
												"WI8" "WI9" "WIA" "WIB" "WIC" "WID" "WIE" "WIF" "WIG" "WIH" 
												"WII" "WIJ" 
										)
		 )
			(setq	_Path-Dwf		"S:/Workgroups/APC Power Delivery/Division Mapping/Public/Tuscaloosa/Underground/Demopolis/")
		)
		((member (strcase (substr Dnam 1 3))	(list	"WDO" "WF2" "WFB" "WFL" "WHJ" "WHK" "WHL" "WHM" "WHN" "WHO" 
												"WHP" "WHQ" "WHR" "WHS" "WHT" 
										)
		 )
			(setq	_Path-Dwf		"S:/Workgroups/APC Power Delivery/Division Mapping/Public/Tuscaloosa/Underground/Haleyville/")
		)
		((member (strcase (substr Dnam 1 3))	(list	"WA0" "WAS" "WB3" "WB8" "WEN" "WEO" "WEP" "WEQ" "WER" "WES" 
												"WET" "WEU" "WEV" "WEX" "WEY" "WEZ" "WF0" "WF1" "WF3" "WF4" 
												"WFA" "WFE" "WGL" "WH2" "WHG" "WIL" "WIM" "WIN" "WIO" "WIP" 
												"WIQ" "WIR" "WIY" "WJL" 
										)
		 )
			(setq	_Path-Dwf		"S:/Workgroups/APC Power Delivery/Division Mapping/Public/Tuscaloosa/Underground/Jasper/")
		)
		((member (strcase (substr Dnam 1 3))	(list	"WEH" "WEI" "WG2" "WGJ" "WGS" "WH8"))
			(setq	_Path-Dwf		"S:/Workgroups/APC Power Delivery/Division Mapping/Public/Tuscaloosa/Underground/Reform/")
		)
		((member (strcase (substr Dnam 1 3))	(list	"W00" "W01" "W02" "W03" "W04" "W05" "W07" "W09" "W10" "W11" 
												"W12" "W13" "W14" "W15" "W16" "W17" "W18" "W19" "W21" "W22" 
												"W23" "W24" "W25" "W26" "W27" "W28" "W29" "W31" "W32" "W33" 
												"W34" "W35" "W36" "W37" "W38" "W39" "W40" "W41" "W42" "W43" 
												"W44" "W45" "W46" "W47" "W48" "W49" "W50" "W51" "W52" "W53" 
												"W54" "W55" "W56" "W57" "W58" "W59" "W61" "W62" "W63" "W64" 
												"W65" "W67" "W68" "W69" "W70" "W71" "W72" "W73" "W74" "W75" 
												"W76" "W77" "W79" "W80" "W81" "W82" "W83" "W84" "W85" "W86" 
												"W87" "W88" "W90" "W91" "W92" "W93" "W94" "W95" "W96" "W97" 
												"W99" "WAT" "WC0" "WCG" "WDD" "WE3" "WE4" "WEF" "WF5" "WF9" 
												"WFC" "WFK" "WFO" "WFR" "WFX" "WFY" "WGB" "WGR" "WGX" "WH1" 
												"WH6" "WH9" "WHD" "WHE" "WHH" "WHI" "WIK" "WIS" "WIT" "WIX" 
												"WJD" "WJE" "WJG" "WJH" "WJI" "WJJ"
										)
		 )
			(setq	_Path-Dwf		"S:/Workgroups/APC Power Delivery/Division Mapping/Public/Tuscaloosa/Underground/Tuscaloosa-North/")
		)
		((member (strcase (substr Dnam 1 3))	(list	"W06" "W08" "W20" "W60" "W66" "W78" "W89" "W98" "WA1" "WA2" 
												"WA3" "WA4" "WA5" "WA6" "WA7" "WA8" "WA9" "WAA" "WAB" "WAC" 
												"WAD" "WAE" "WAF" "WAG" "WAH" "WAI" "WAJ" "WAK" "WAL" "WAM" 
												"WAN" "WAO" "WAP" "WAQ" "WAR" "WAU" "WAV" "WAW" "WAX" "WAY" 
												"WAZ" "WB0" "WB1" "WB2" "WB4" "WB5" "WB6" "WB7" "WB9" "WBA" 
												"WBB" "WBC" "WBD" "WBE" "WBF" "WBG" "WBH" "WBI" "WBJ" "WBK" 
												"WBL" "WBM" "WBN" "WBO" "WBP" "WBQ" "WBR" "WBS" "WBT" "WBU" 
												"WBV" "WBX" "WBY" "WBZ" "WC1" "WC2" "WC3" "WC4" "WC5" "WC6" 
												"WC7" "WC8" "WC9" "WCA" "WCB" "WCC" "WCD" "WCF" "WCH" "WCI" 
												"WCJ" "WCK" "WCL" "WCM" "WCN" "WCO" "WCP" "WCQ" "WCR" "WCS" 
												"WCT" "WCU" "WCV" "WCX" "WCY" "WCZ" "WD0" "WD1" "WD2" "WD3" 
												"WD4" "WD5" "WD6" "WD7" "WD9" "WDA" "WDB" "WDC" "WDE" "WDF" 
												"WDG" "WDH" "WDI" "WDJ" "WDK" "WDL" "WDM" "WDN" "WDP" "WDQ" 
												"WDR" "WDS" "WDT" "WDU" "WDV" "WDW" "WDX" "WDY" "WDZ" "WE0" 
												"WE1" "WE2" "WEG" "WF6" "WF7" "WF8" "WFD" "WFG" "WFH" "WFI" 
												"WFJ" "WFM" "WFN" "WFP" "WFQ" "WFS" "WFU" "WFV" "WFW" "WG0" 
												"WG1" "WG3" "WG4" "WG5" "WG6" "WG7" "WG8" "WG9" "WGA" "WGC" 
												"WGD" "WGE" "WGF" "WGH" "WGK" "WGN" "WGP" "WGU" "WGV" "WGY" 
												"WGZ" "WH5" "WH9" "WHA" "WIS" "WIU" "WIV" "WIW" "WIZ" "WJA" 
												"WJB" "WJC" "WJF" "WJK" 
										)
		 )
			(setq	_Path-Dwf		"S:/Workgroups/APC Power Delivery/Division Mapping/Public/Tuscaloosa/Underground/Tuscaloosa-South/")
		)
		((member (strcase (substr Dnam 1 3))	(list	"WEJ" "WEK" "WEL" "WEM" "WGG" "WGO" "WGQ" "WGT" "WH3" "WH7" "WHF" "WHJ"))
			(setq	_Path-Dwf		"S:/Workgroups/APC Power Delivery/Division Mapping/Public/Tuscaloosa/Underground/Winfield/")
		)
		(T
			(setq	_Path-Dwf		"S:/Workgroups/APC Power Delivery/Division Mapping/Public/Tuscaloosa/Underground/")
		)
	)
	_Path-Dwf
)

(defun C:StyCL ( / )						; CL for StyChkLog
	(if (/= (getvar "TILEMODE") 1)
		(setvar "TILEMODE" 1)
	)
	(setq	LayLst	(LayWhat)
			LayStr	nil
			LayWrk	nil
	)
	(if (nth 1 LayLst)
		(setq	LayWrk	(mapcar (quote car) (nth 1 LayLst))
				LayStr	(car LayWrk)
				LayWrk	(cdr LayWrk)
				Bubba	(mapcar (quote (lambda (x) (setq LayStr (strcat LayStr "," x)))) LayWrk)
		)
	)
	(if LayStr
		(if (assoc "MASK" (nth 0 LayLst))
			(setq	LayStr	(strcat LayStr ",MASK"))
		)
	)
	(command	"_.LAYER" "T" "*" "U" "*" "On" "*" "S" "0" "" "_.Zoom" "E" "_.Zoom" "0.8x")
	(setq	MstCntLst	nil
			MstCntLst	(StyChkLog 1)
	)
	(command "_.Purge" "A" "*" "N")
	(command "_.Purge" "A" "*" "N")
	(command "_.Purge" "A" "*" "N")
	(command "_.Purge" "A" "*" "N")
	(if (assoc "0" (nth 0 LayLst))
		(setq	LayT	"0")
		(progn
			(setq	CntR	0
					LayT	(caaar LayLst)
			)
			(while (not (LayChk LayT))
				(setq	CntR	(1+ CntR)
						LayT	(car (nth CntR (car LayLst)))
				)
			)
		)
	)
	(command	"_.LAYER" "S" LayT "F" LayStr "" "_.Zoom" "E" "_.Zoom" "0.8x")
	(setvar "ORTHOMODE" 0)
	(setvar "OSMODE" 0)
	(if MstCntLst
		(PutFilAsLst MstCntLst "C:\\MapQry\\MapQ_Logs\\MstCntLst.txt" nil 0)
	)
	(command "_.Qsave")
	(princ)
)

(defun StyChkLog ( Action /	StyStf LstCnt		; Logs and/or Repairs Styles to contain only fonts on the accepted list
						LstSty LstNam StyN ssSty ssLen Obj1 Obj2
						CntR CntN CntT MstCntLst Bubba )
	(setq	StyStf	(StyChkFnt)
			LstSty	(car StyStf)
			LstNam	(cadr StyStf)
			DwgN		(getvar "DWGNAME")
	)
	(if LstNam
		(if (and (= (length LstNam) 1) (not (null (car LstNam))))
			(setq	LstCnt	(length LstNam)
					CntN		0
			)
			(if (> (length LstNam) 1)
				(setq	LstCnt	(length LstNam)
						CntN		0
				)
				(setq	LstCnt	nil
						CntN		nil
				)
			)
		)
		(setq	LstCnt	nil
				CntN		nil
		)
	)
	(if LstCnt
		(setq	MstCntLst	(mapcar (quote (lambda (x y) (strcat "Dwg {" DwgN "} Style {" x "} uses font {" y "}"))) LstNam LstSty))
	)
	(if LstCnt
		(if (not (StyChk "STANDARD"))
			(command "STYLE" "STANDARD" "ROMANS" 0.0 1.0 0.0 "N" "N" "N")
			(if (/= (strcase (cdr (assoc 3 (tblsearch "STYLE" "STANDARD")))) "ROMANS.SHX")
				(command "STYLE" "STANDARD" "ROMANS" 0.0 1.0 0.0 "N" "N" "N")
			)
		)
	)
	(if LstCnt
		(foreach	StyN
				LstNam
				(setq	PosN		(- (length LstNam) (length (member StyN LstNam)))
						ssSty	(ssget "X"	(list	(cons 0 "TEXT")
													(cons 7 StyN)
													(cons 67 0)
											)
								)
				)
				(if ssSty
					(setq	CntR		0
							ssLen	(sslength ssSty)
					)
					(setq	CntR		nil)
				)
				(if ssLen
					(if (> ssLen 0)
						(if MstCntLst
							(setq	MstCntLst	(cons (strcat "Dwg {" DwgN "}\tQty {" (itoa ssLen)"}\tFnt {" (nth PosN LstSty) "}\tSty {" (nth PosN LstNam) "}\tText Items") MstCntLst))
							(setq	MstCntLst	(list (strcat "Dwg {" DwgN "}\tQty {" (itoa ssLen)"}\tFnt {" (nth PosN LstSty) "}\tSty {" (nth PosN LstNam) "}\tText Items")))
						)
					)
				)
				(if (= Action 1)
					(progn
						(if CntR
							(while (< CntR ssLen)
								(setq	Obj1		(ssname ssSty CntR)
										Obj2		(entget Obj1 (list "*"))
										Obj2		(subst	(cons 7 "STANDARD")
														(assoc 7 Obj2)
														Obj2
												)
										Bubba	(entmod Obj2)
										Bubba	(entupd Obj1)
										CntR		(1+ CntR)
								)
							)
						)
						(if ssSty
							(setq	ssSty	nil)
						)
						(if ssLen
							(setq	ssLen	nil)
						)
						(gc)
					)
				)
				(setq	ssSty	(ssget "X"	(list	(cons 0 "INSERT")
													(cons 66 1)
													(cons 67 0)
											)
								)
				)
				(if (= Action 1)
					(progn
						(if ssSty
							(setq	CntR		0
									CntT		0
									ssLen	(sslength ssSty)
							)
							(setq	CntR		nil
									CntT		nil
							)
						)
						(if CntR
							(while (< CntR ssLen)
								(setq	Obj1		(ssname ssSty CntR)
										Obj2		(entget (entnext Obj1) (list "*"))
								)
								(if (member (cdr (assoc 7 Obj2)) LstNam)
									(setq	Obj2		(subst	(cons 7 "STANDARD")
															(assoc 7 Obj2)
															Obj2
													)
											CntT		(1+ CntT)
											Bubba	(entmod Obj2)
									)
								)
								(while (/= (cdr (assoc 0 (setq Obj2 (entget (entnext (cdr (assoc -1 Obj2))) (list "*"))))) "SEQEND")
									(if (member (cdr (assoc 7 Obj2)) LstNam)
										(setq	Obj2		(subst	(cons 7 "STANDARD")
																(assoc 7 Obj2)
																Obj2
														)
												Bubba	(entmod Obj2)
										)
									)
								)
								(entupd Obj1)
								(setq	CntR		(1+ CntR))
							)
						)
						(if ssLen
							(if (> ssLen 0)
								(if MstCntLst
									(setq	MstCntLst	(cons (strcat "Dwg {" DwgN "}\tQty {" (itoa ssLen)"}\tFnt {" (nth PosN LstSty) "}\tSty {" (nth PosN LstNam) "}\tAttribute Items") MstCntLst))
									(setq	MstCntLst	(list (strcat "Dwg {" DwgN "}\tQty {" (itoa ssLen)"}\tFnt {" (nth PosN LstSty) "}\tSty {" (nth PosN LstNam) "}\tAttribute Items")))
								)
							)
						)
						(if ssSty
							(setq	ssSty	nil)
						)
						(gc)
					)
				)
		)
	)
	(if MstCntLst
		(setq	MstCntLst	(reverse MstCntLst))
	)
	(if MstCntLst
		(mapcar (quote (lambda (x) (princ (strcat "\n" x)))) MstCntLst)
	)
	(princ)
	MstCntLst
)

(defun StyChkFnt ( / LstSty StyNxt VldLstSty )	; Tests for valid style
	(setq	LstSty	(list (strcase (cdr (assoc 3 (tblnext "STYLE" T)))))
			VldLstSty	(list	"BIGFONT.SHX" "COMPLEX.SHX" "GOTHICE.SHX" "GOTHICG.SHX" "GOTHICI.SHX"
							"GREEKC.SHX" "GREEKS.SHX" "ISOCP.SHX" "ISOCP2.SHX" "ISOCP3.SHX" 
							"ISOCT.SHX" "ISOCT2.SHX" "ISOCT3.SHX" "ITALIC.SHX" "ITALICC.SHX"
							"ITALICT.SHX" "MONOTXT.SHX" "ROMANC.SHX" "ROMAND.SHX" "ROMANS.SHX"
							"ROMANT.SHX" "SCRIPTC.SHX" "SCRIPTS.SHX" "SIMPLEX.SHX" "SYASTRO.SHX"
							"SYMAP.SHX" "SYMATH.SHX" "SYMETEO.SHX" "SYMUSIC.SHX" "TXT.SHX" "TIMES.TTF" "LTYPESHP.SHX"
					)
			NamLst	(list "NaDa")
	)
	(while (setq StyNxt (tblnext "STYLE"))
		(if StyNxt
			(setq	NamSty	(strcase (cdr (assoc 2 StyNxt)))
					StyNxt	(strcase (cdr (assoc 3 StyNxt)))
			)
		)
		(if StyNxt
			(if (> (strlen StyNxt) 0)
				(if (not (HasDot StyNxt))
					(setq	StyNxt	(strcat StyNxt ".SHX"))
				)
				(setq	StyNxt	nil)
			)
			(setq	StyNxt	nil)
		)
		(if StyNxt
			(if (not (member StyNxt VldLstSty))
				(setq	LstSty	(cons StyNxt LstSty)
						NamLst	(cons NamSty NamLst)
				)
			)
		)
	)
	(if (and (member (last LstSty) VldLstSty) (> (length LstSty) 1))
		(setq	LstSty	(reverse (cdr (reverse LstSty)))
				NamLst	(reverse (cdr (reverse NamLst)))
		)
		(if (and (member (last LstSty) VldLstSty) (= (length LstSty) 1))
			(setq	LstSty	nil
					NamLst	nil
			)
		)
	)
	(list LstSty NamLst)
)


(defun C:QkS ( /	ssPan QsFn UNam MNam		; Save edits of currently open panels
				STim FNam WNam cDia xPrt fDia )
	(if Bug (princ "\n C:QkS entered."))
	(setq	cDia		(getvar "CMDDIA")
			xPrt		(getvar "EXPERT")
			fDia		(getvar "FILEDIA")
	)
	(command "_.UNDO" "_BE")
	(setvar "CMDDIA" 0)
	(setvar "EXPERT" 5)
	(setvar "FILEDIA" 0)
	(command	"_.LAYER" "T" "*" "U" "*" "On" "*" "S" "0" "" "_.Zoom" "E" "_.Zoom" "0.8x")
	(setq	ssPan	(ssget "X"	(list	(cons -4 "<NOT")
											(cons 2 "GRID")
										(cons -4 "NOT>")
								)
					)
			UNam		(strcase (getvar "LOGINNAME"))
			MNam		(strcase (getenv "COMPUTERNAME"))
			STim		(substr (GetStorDate) 1 8)
			FNam		(strcat "C:\\Adds25\\" STim "_" MNam "_" UNam ".scr")
			WNam		(strcat "C:\\Adds25\\" STim "_" MNam "_" UNam ".dwg")
			WWnm		(strcat "C:\\\\Adds25\\\\" STim "_" MNam "_" UNam ".dwg")
	)
	(if (findfile FNam)
		(dos_delete FNam)
	)
	(if (findfile WNam)
		(dos_delete WNam)
	)
	(command "_.WBlock" WNam "" "0,0" ssPan "" "N")
	(command "_.Insert" (strcat "*" WNam) "0,0" "1" "0")
	(if (and PanLst ssPan Div)
		(progn
			(setq QsFn (open FNam "w"))
			(write-line (strcat "(UpdDivINI \"" Div "\")") QsFn)
			(write-line (strcat "(setq sff " (itoa sff) " sf (* sff 0.3048))") QsFn)
			(write-line "(setvar \"LTSCALE\" SFF)" QsFn)
			(write-line "(setvar \"THICKNESS\" SFF)" QsFn)
			(mapcar (quote (lambda (x) (write-line (strcat "(GetPan \"" x "\")") QsFn))) PanLst)
			(write-line "(command \"_.LAYER\" \"T\" \"*\" \"U\" \"*\" \"On\" \"*\" \"S\" \"0\" \"\" \"_.Zoom\" \"E\" \"_.Zoom\" \"0.8x\")" QsFn)
			(write-line "(setq ssPan (ssget \"X\" (list (cons -4 \"<NOT\") (cons 2 \"GRID\") (cons -4 \"NOT>\"))))" QsFn)
			(write-line "(if ssPan (command \"_.Erase\" ssPan \"\"))" QsFn)
			(write-line (strcat "(command \"_.Insert\" \"*" WWnm "\" \"0,0\" \"1\" \"0\")") QsFn)
			(close QsFn)
		)
	)
	(setvar "EXPERT" xPrt)
	(setvar "CMDDIA" cDia)
	(setvar "FILEDIA" fDia)
	(command "_.UNDO" "_EN")
	(AddsQuit 1)
	(if Bug (princ "\n C:QkS exited."))
	(princ)
)

(defun FixPLs ( /	sso 	;Fixes PLines that should be Circuits!
				)
				;PlNLay Cntr PlAdd ENam
				;EDat PLInf PlTst Cset PNam PScl FN x y PLInfOut NDat )
	(command "_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" "" "_.Zoom" "E")
	(princ "\nGathering Device Selection Set & Building Lists...")
	(setq	sso		(ssget "X"	(list	(cons -4 "<AND")
											(cons 0 "POLYLINE")
											(cons -4 "<NOT")
												(cons 8 "????CK-*,????FL-*")
											(cons -4 "NOT>")
										(cons -4 "AND>")
								)
					)
			PLInfLst	nil
			Cntr		0
	)
	(if sso
		(princ (strcat "\nFixPLs found {" (itoa (sslength sso)) "} PLines to test..."))
	)
	(if sso
		(while (setq ENam (ssname sso Cntr))
			(setq	EDat	(entget (entnext ENam) (list "*")))
			(if (> (cdr (assoc 40 EDat)) 0.01)
				(setq	PLInf	(cons ENam (cdr (reverse (GetPLEnd ENam))))
						PlTst	nil
						PlAdd	nil
						PlNLay	nil
				)
				(setq	PLInf	nil
						PlTst	nil
						PlAdd	nil
						PlNLay	nil
				)
			)
			(if PLInf
				(setq	PlTst	(ChkCktMtchPnt (cadr PLInf) (car PLInf)))
				(setq	PlTst	nil)
			)
			(if PlTst
				(if (and (= (car PlTst) "Y") (= (last PlTst) "Y"))
					(setq	PlAdd	T
							PlNLay	(nth 3 PlTst)
							PlTst	nil
					)
					(setq	PlTst	(ChkCktMtchPnt (caddr PLInf) (car PLInf)))
				)
			)
			(if PlTst
				(if (and (= (car PlTst) "Y") (= (last PlTst) "Y"))
					(setq	PlAdd	T
							PlNLay	(nth 3 PlTst)
							PlTst	nil
					)
					(setq	PlAdd	nil)
				)
			)
			(if (and PlNLay PlAdd)
				(setq	NDat		(entget ENam (list "*"))
						Bubba	(princ (strcat "\nFixPLs updates from {" (cdr (assoc 8 NDat)) "} to {" PlNLay "}."))
						NDat		(subst (cons 8 PlNLay) (assoc 8 NDat) NDat)
						Bubba	(entmod NDat)
						Bubba	(entupd ENam)
				)
			)
			(setq	Cntr	(1+ Cntr))
		)
	)
	(if sso
		(setq	sso		nil
				Bubba	(gc)
		)
	)
	(ShwPls)
	(princ)
)

(defun C:ChkPLs ( /	sso Cntr PlAdd ENam		;Test for PLines that should be Circuits!
					EDat PLInf PlTst Cset PNam PScl FN x y PLInfOut )
	(command "_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" "" "_.Zoom" "E")
	(princ "\nGathering Device Selection Set & Building Lists...")
	(setq	sso		(ssget "X"	(list	(cons -4 "<AND")
											(cons 0 "POLYLINE")
											(cons -4 "<NOT")
												(cons 8 "????CK-*,????FL-*")
											(cons -4 "NOT>")
										(cons -4 "AND>")
								)
					)
			PLInfLst	nil
			Cntr		0
	)
	(if sso
		(princ (strcat "\nChkPLs found {" (itoa (sslength sso)) "} PLines to test..."))
	)
	(if sso
		(while (setq ENam (ssname sso Cntr))
			(setq	EDat	(entget (entnext ENam)))
			(if (> (cdr (assoc 40 EDat)) 0.01)
				(setq	PLInf	(cons ENam (cdr (reverse (GetPLEnd ENam))))
						PlTst	nil
						PlAdd	nil
				)
				(setq	PLInf	nil
						PlTst	nil
						PlAdd	nil
				)
			)
			(if PLInf
				(setq	PlTst	(ChkCktMtchPnt (cadr PLInf) (car PLInf)))
				(setq	PlTst	nil)
			)
			(if PlTst
				(if (and (= (car PlTst) "Y") (= (last PlTst) "Y"))
					(setq	PlAdd	T
							PlTst	nil
					)
					(setq	PlTst	(ChkCktMtchPnt (caddr PLInf) (car PLInf)))
				)
			)
			(if PlTst
				(if (and (= (car PlTst) "Y") (= (last PlTst) "Y"))
					(setq	PlAdd	T
							PlTst	nil
					)
					(setq	PlAdd	nil)
				)
			)
			(if PlAdd
				(if PLInfLst
					(setq	PLInfLst	(cons PLInf PLInfLst))
					(setq	PLInfLst	(list PLInf))
				)
			)
			(setq	Cntr	(1+ Cntr))
		)
	)
	(if sso
		(setq	sso		nil
				Bubba	(gc)
		)
	)
	(ShwPls)
	(if (= (getvar "DWGTITLED") 1)
		(if (setq Cset (ssget "X" (list (cons 0 "ATTDEF") (cons 8 "*-SC-*"))))
			(setq	PScl	(atof (cdr (assoc 1 (entget (ssname Cset 0)))))
					PNam	(getvar "DWGNAME")
			)
		)
		(if PanLst
			(if (= (length PanLst) 1)
				(setq	PNam	(car PanLst)
						PScl	(if ScList (last ScList))
				)
			)
		)
	)
	(if Cset
		(setq	Cset			nil
				Bubba		(gc)
		)
	)
	(if PNam
		(if (> (strlen PNam) 4)
			(if (= (substr (strcase PNam) (- (strlen PNam) 3) 4) ".DWG")
				(setq	PNam	(substr (strcase PNam) 1 (- (strlen PNam) 4)))
			)
		)
	)
	(if (and PNam PLInfLst)
		(setq	PLInfOut	(mapcar (quote (lambda (y) (list (cdr (assoc 5 (entget (car y)))) (rtos (car (nth 1 y)) 2 2) (rtos (cadr (nth 1 y)) 2 2) (rtos (car (nth 2 y)) 2 2) (rtos (cadr (nth 2 y)) 2 2)))) PLInfLst)
				PLInfOut	(mapcar (quote (lambda (x) (cons PNam x))) PLInfOut)
		)
	)
	(if PLInfOut
		(progn
			(if (= (getvar "DWGTITLED") 1)
				(setq FN (open (strcat (getenv "MapQry") "\\MapQry\\PLInfOut.TXT") "a"))
				(setq FN (open "PLInfOut.TXT" "a"))
			)
			(setq	PLInfOut	(mapcar (quote (lambda (x) (mapcar (quote (lambda (y) (strcat "," y))) x))) PLInfOut))
			(setq	PLInfOut	(mapcar (quote (lambda (x) (apply (quote strcat) x))) PLInfOut))
			(if (and PLInfOut FN)
				(mapcar (quote (lambda (x) (write-line (substr x 2) FN))) PLInfOut)
			)
			(if FN (close FN))
		)
	)
	(if FN
		(setq	FN	nil)
	)
	(gc)
	(princ)
)

(defun C:ShwPls ( /	AttWas				;Comment Here
					BlpWas CmdWas ColWas EchWas ExWas FilWas LayWas LtWas OsWas TmdWas )
	(if Bug (princ "\n{ C:ShwPls entered}\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			CmdWas	(getvar "CMDDIA")
			ColWas	(getvar "CECOLOR")
			EchWas	(getvar "CMDECHO")
			ExWas	(getvar "EXPERT")
			FilWas	(getvar "FILEDIA")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			TmdWas	(getvar "TILEMODE")
	)
	
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
		)
	)
	(command "_.UNDO" "_BE")
	
	(ShwPls)
	
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CMDECHO" EchWas)
	(setvar "EXPERT" ExWas)
	(setvar "FILEDIA" FilWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "TILEMODE" TmdWas)
	(if Bug (princ "\n{ C:ShwPls exited}\n"))
	(princ)
)

(defun ShwPls ( / )
	(if PLInfLst
		(progn
			(Show (mapcar (Quote cadr) PLInfLst) 1)
			(Show (mapcar (Quote caddr) PLInfLst) 2)
			(princ (strcat "\nChkPLs found {" (itoa (length PLInfLst)) "} PLines with Width!"))
		)
	)
	(princ)
)

(defun C:FndFL ( /	AttWas					;Comment Here
					BlpWas CmdWas ColWas EchWas ExWas FilWas LayWas LtWas OsWas TmdWas )
	(if Bug (princ "\n{ C:FndFL entered}\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			CmdWas	(getvar "CMDDIA")
			ColWas	(getvar "CECOLOR")
			EchWas	(getvar "CMDECHO")
			ExWas	(getvar "EXPERT")
			FilWas	(getvar "FILEDIA")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			TmdWas	(getvar "TILEMODE")
	)
	
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
		)
	)
	(command "_.UNDO" "_BE")
	
	(if DevInfLst
		(if (not DevCntr)
			(setq	DevCntr	0)
			(setq	DevCntr	(1+ DevCntr))
		)
		(setq	DevCntr	nil)
	)
	(if DevCntr
		(if (< DevCntr (1- (length DevInfLst)))
			(if (= (nth 1 (nth DevCntr DevInfLst)) "FL")
				(TstFL (nth DevCntr DevInfLst) DevCntr)
				(princ "\nOut of Fill Lines to Look At!")
			)
		)
	)
	
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CMDECHO" EchWas)
	(setvar "EXPERT" ExWas)
	(setvar "FILEDIA" FilWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "TILEMODE" TmdWas)
	(if Bug (princ "\n{ C:FndFL exited}\n"))
	(princ)
)

(defun TstFL ( DevInf DevCntr /	Pt1 Pt2 LayN )
	(setq	Pt1	(list	(atof (nth 14 DevInf))
						(atof (nth 15 DevInf))
				)
			Pt2	(list	(atof (nth 16 DevInf))
						(atof (nth 17 DevInf))
				)
			LayN	(strcat (substr (nth 4 DevInf) 1 4) "CK" (substr (nth 4 DevInf) 7))
	)

	(command "_.Zoom" "C"	(list	(+ (car Pt1) (/ (- (car Pt2) (car Pt1)) 2.0))
								(+ (cadr Pt1) (/ (- (cadr Pt2) (cadr Pt1)) 2.0))
						)
						(* (distance Pt1 Pt2) 2.0)
	)
	(redraw (handent (car DevInf)) 3)
	(if (and (LayChk (nth 4 DevInf)) (LayChk LayN))
		(progn
			(initget 1 "Layer Delete Ignore")
			(setq	DoIt	(getkword (strcat "\nFill Line {" (itoa (1+ DevCntr)) "} Layer=[" (nth 4 DevInf) "] Actions=<D>elete, <I>gnore or <L>ayer change to [" LayN "]: ")))
			(cond
				((= DoIt "Layer")
					(setq	EDat		(entget (handent (nth 0 DevInf)) (list "*"))
							EDat		(subst (cons 8 LayN) (assoc 8 EDat) EDat)
							Bubba	(entmod EDat)
							Bubba	(entupd (handent (nth 0 DevInf)))
					)
				)
				((= DoIt "Delete")
					(command "_.Erase" (handent (nth 0 DevInf)) "")
				)
				((= DoIt "Ignore")
					(redraw (handent (car DevInf)) 4)
				)
			)
		)
	)
	(princ)
)

(defun SwChk ( /	CSET Cntr D_Lst DevInfLen	;Generates DevInfLst & reports
				EELst EFdr EHnd ESLst E_Lst EkVL FCnt
				FDat FEpt FHnd FLENamLst FLay FLen FMat FSpt
				F_Lst GCnt G_Lst H_Lst INam NCnt NNam N_Lst PNam PScl
				PanEdgeX1 PanEdgeX2 PanEdgeY1 PanEdgeY2
				PosOut SNam SSET T_Lst ssCnt ssFL DevInfOut )
	(setq	SwFltLst	(GetSwFltR)
			NCnt		0
			DevInfLst	nil
			GCnt		0
			EdsLocal	T
			FLENamLst	nil
			NFL_Lst	(list)
			G_Lst	nil
			DevInfOut	nil
	)
	(command "_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" "" "_.Zoom" "E")
	(if (= (getvar "DWGTITLED") 1)
		(if (setq Cset (ssget "X" (list (cons 0 "ATTDEF") (cons 8 "*-SC-*"))))
			(setq	PScl	(atof (cdr (assoc 1 (entget (ssname Cset 0)))))
					PNam	(getvar "DWGNAME")
			)
			(setq	PScl	500.0
					PNam	(getvar "DWGNAME")
			)
		)
		(if PanLst
			(if (= (length PanLst) 1)
				(setq	PNam	(car PanLst)
						PScl	(if ScList (last ScList))
				)
			)
		)
	)
	(if Cset
		(setq	Cset			nil
				Bubba		(gc)
		)
	)
	(if PNam
		(if (> (strlen PNam) 4)
			(if (= (substr (strcase PNam) (- (strlen PNam) 3) 4) ".DWG")
				(setq	PNam	(substr (strcase PNam) 1 (- (strlen PNam) 4)))
			)
		)
	)
	(princ (strcat "\nGathering Device Selection Set & Building Lists for [" PNam "]..."))
	(if SwFltLst
		(if	(setq	SSET	(ssget "X" SwFltLst))
			(progn
				(while (setq NNam (ssname SSET NCnt))
					(if NNam
						(if G_Lst
							(setq	G_Lst	(cons NNam G_Lst))
							(setq	G_Lst	(list NNam))
						)
					)
					(setq	NCnt	(1+ NCnt))
				)
				(setq	SSET	nil
						CSET	nil
						NNam	nil
						NCnt	0
				)
				(gc)
			)
			(setq	G_Lst	nil)
		)
	)
	(princ (strcat "\nStarting EndPoint Checks for {" (itoa (length G_Lst)) "} Devices..."))
	(if PNam
		(setq	PanEdgeX1	(* (atof (substr PNam 1 3)) 1000.0)
				PanEdgeX2	(+ PanEdgeX1 6000.0)
				PanEdgeY1	(* (atof (substr PNam 4 4)) 1000.0)
				PanEdgeY2	(+ PanEdgeY1 4000.0)
		)
	)
	(if (> (length G_Lst) 0)
		(while (> (length G_Lst) 0)
			(if (> (length G_Lst) 0)
				(setq	NNam		(car G_Lst)
						G_Lst	(if (> (length G_Lst) 1) (cdr G_Lst) nil)
						H_Lst	(list (cdr (assoc 5 (entget NNam))))
				)
			)
			(if NNam
				(setq	Cntr		0
						Bubba	(princ (strcat "\nHere goes Group {" (itoa (1+ GCnt)) "} Run {" (itoa (1+ Cntr)) "} with {" (itoa (length G_Lst)) "} Devices Left"))
						E_Lst	(ChkInsOther NNam nil nil)
						N_Lst	(if (> (length (car E_Lst)) 1) (RemLst NNam (car E_Lst)) nil)
						D_Lst	(list NNam)
						ssCnt	0
						DevInfLen	(length DevInfLst)
				)
				(setq	E_Lst	nil
						N_Lst	nil
						D_Lst	nil
						Cntr		nil
				)
			)
			(if (and N_Lst E_Lst D_Lst)
				(while (and N_Lst E_Lst)
					(setq	Cntr		(1+ Cntr))
					(if (> (length N_Lst) 0)
						(setq	NNam		(car N_Lst)
								D_Lst	(cons NNam D_Lst)
								N_Lst	(if (> (length N_Lst) 1) (cdr N_Lst) nil)
								E_Lst	(ChkInsOther NNam (nth 1 E_Lst) (nth 2 E_Lst))
								Bubba	(princ (strcat "\nHere goes Group {" (itoa (1+ GCnt)) "} Run {" (itoa (1+ Cntr)) "}..."))
						)
						(setq	NNam		nil)
					)
					(if NNam
						(foreach	INam
								(car E_Lst)
								(if (not (member (cdr (assoc 5 (entget INam))) H_Lst))
									(setq	H_Lst	(cons (cdr (assoc 5 (entget INam))) H_Lst))
								)
								(if (and N_Lst D_Lst)
									(if (and (not (member INam D_Lst)) (not (member INam N_Lst)))
										(setq	N_Lst	(reverse (cons INam (reverse N_Lst))))
									)
									(if D_Lst
										(if (not (member INam D_Lst))
											(setq	N_Lst	(list INam))
										)
									)
								)
								(if (member INam G_Lst)
									(setq	G_Lst	(RemLst INam G_Lst))
								)
						)
					)
				)
			)
			(princ	(strcat	"\nNth1X:{" (rtos (car (nth 1 E_Lst)) 2 4) "},Nth1Y:{" (rtos (cadr (nth 1 E_Lst)) 2 4) "}"))
			(princ	(strcat	"\nNth2X:{" (rtos (car (nth 2 E_Lst)) 2 4) "},Nth2Y:{" (rtos (cadr (nth 2 E_Lst)) 2 4) "}"))
			(princ	(strcat	"\nResX:{"	(rtos (+ (car (nth 1 E_Lst)) (/ (- (car (nth 2 E_Lst)) (car (nth 1 E_Lst))) 2.0)) 2 4)
							"},ResY:{"	(rtos (+ (cadr (nth 1 E_Lst)) (/ (- (cadr (nth 2 E_Lst)) (cadr (nth 1 E_Lst))) 2.0)) 2 4)
							"},Dist:{"	(rtos (* (distance (nth 1 E_Lst) (nth 2 E_Lst)) 2.0) 2 4)
							"}"
					)
			)
			(command "_.Zoom" "C"	(list	(+ (car (nth 1 E_Lst)) (/ (- (car (nth 2 E_Lst)) (car (nth 1 E_Lst))) 2.0))
										(+ (cadr (nth 1 E_Lst)) (/ (- (cadr (nth 2 E_Lst)) (cadr (nth 1 E_Lst))) 2.0))
								)
								(if (> (distance (nth 1 E_Lst) (nth 2 E_Lst)) 0.0)
									(* (distance (nth 1 E_Lst) (nth 2 E_Lst)) 2.0)
									250.0
								)
			)
			(setq	NNam		(handent (last H_Lst))
					T_Lst	(assoc (last H_Lst) DevInfLst)
					EkVL		(if (> (strlen (nth 4 T_Lst)) 9) (substr (nth 4 T_Lst) 9 2) "??")
					EFdr		(if (> (strlen (nth 4 T_Lst)) 2) (substr (nth 4 T_Lst) 1 3) (PadCharR (nth 4 T_Lst) 3))
					EELst	(ChkCktAtPnt (nth 1 E_Lst) EkVL EFdr)
					ESLst	(ChkCktAtPnt (nth 2 E_Lst) EkVL EFdr)
			)
			(if E_Lst
				(if (= (length (car E_Lst)) 1)
					(if (= (cdr (assoc 2 (entget (caar E_Lst)))) "A122")
						(setq	ssFL	(ssget "CP" (last E_Lst) (list (cons 0 "POLYLINE") (cons 8 "????FL*"))))
						(setq	ssFL	(ssget "WP" (last E_Lst) (list (cons 0 "POLYLINE") (cons 8 "????FL*"))))
					)
					(setq	ssFL	(ssget "WP" (last E_Lst) (list (cons 0 "POLYLINE") (cons 8 "????FL*"))))
				)
				(setq	ssFL	nil)
			)
			(if ssFL
				(if (> (sslength ssFL) 1)
					(progn
						(princ (strcat "\nFound {" (itoa (sslength ssFL)) "} Fill Line Fragments under {" (itoa (length (car E_Lst))) "} Inserts."))
						(setq	FLay	(cdr (assoc 8 (entget (ssname ssFL 0))))
								FHnd	(cdr (assoc 5 (entget (ssname ssFL 0))))
								FLen	(GetPLen (entget (ssname ssFL 0)))
								FMat	(sslength ssFL)
						)
					)
					(progn
						(princ (strcat "\nFound {" (itoa (sslength ssFL)) "} Fill Line under {" (itoa (length (car E_Lst))) "} Inserts."))
						(setq	FLay	(cdr (assoc 8 (entget (ssname ssFL 0))))
								FHnd	(cdr (assoc 5 (entget (ssname ssFL 0))))
								FLen	(GetPLen (entget (ssname ssFL 0)))
								FMat	0
						)
					)
				)
				(progn
					(princ (strcat "\nFound {No} Fill Lines under {" (itoa (length (car E_Lst))) "} Inserts."))
					(if H_Lst
						(foreach	HNam
								H_Lst
								(setq	NFL_Lst	(cons HNam NFL_Lst))
						)
					)
					(setq	FLay	nil
							FHnd	nil
							FLen	nil
							FMat	nil
					)
				)
			)
			(if ssFL
				(progn
					(while (< ssCnt (sslength ssFL))
						(if (setq SNam (ssname ssFL ssCnt))
							(if FLENamLst
								(setq	FLENamLst	(cons SNam FLENamLst))
								(setq	FLENamLst	(list SNam))
							)
						)
						(setq	ssCnt	(1+ ssCnt))
					)
				)
			)
			(setq	GCnt	(1+ GCnt)
					ssFL	nil
			)
			(gc)
			(if (and DevInfLst H_Lst)
				(foreach	EHnd
						H_Lst
						(if (assoc EHnd DevInfLst)
							(setq	PosOut	(- (length DevInfLst) (length (member (assoc EHnd DevInfLst) DevInfLst)))
									DevInf	(append	(assoc EHnd DevInfLst)
													(list	(itoa GCnt)					;Dev_Position		13
															(rtos (car (nth 1 E_Lst)) 2 2)	;FSPT_X			14
															(rtos (cadr (nth 1 E_Lst)) 2 2)	;FSPT_Y			15
															(rtos (car (nth 2 E_Lst)) 2 2)	;FEPT_X			16
															(rtos (cadr (nth 2 E_Lst)) 2 2)	;FEPT_Y			17
															(if (> (length H_Lst) 1) "Y" "N")	;GroupP			18
															(nth 0 ESLst)					;Switch_In_Match	19
															(nth 0 EELst)					;Switch_Out_Match	20
															(nth 1 ESLst)					;Switch_In_Ckt		21
															(nth 1 EELst)					;Switch_Out_Ckt	22
															(nth 2 ESLst)					;Switch_In_Lay		23
															(nth 2 EELst)					;Switch_Out_Lay	24
															(nth 3 ESLst)					;Switch_In_Handle	25
															(nth 3 EELst)					;Switch_Out_Handle	26
															(if FMat (itoa FMat) "-1")		;Fill_Line_Match	27
															(if (equal (distance (nth 1 E_Lst) (nth 2 E_Lst)) FLen 1.0)
																"Y" "N")					;Fill_Len_Scl_Match	28
															(if FLay FLay "")				;Fill_Line_Lay		29
															(if FHnd FHnd "")				;Fill_Line_Handle	30
															(if FLen (rtos FLen 2 2) "")		;Fill_Line_Length	31

													)
											)
									DevInfLst	(RepLst DevInfLst DevInf PosOut)
							)
							(setq	DevInfLst	(cons DevInf DevInfLst))
						)
				)
			)
		)
	)
	(command "_.Zoom" "E")
	(setq	ssFL		(ssget "X" (list (cons 0 "POLYLINE") (cons 8 "????FL*")))
			FCnt		0
			F_Lst	nil
	)
	(if (and ssFL FLENamLst)
		(foreach	INam
				FLENamLst
				(if (ssmemb INam ssFL)
					(setq	ssFL	(ssdel INam ssFL))
				)
		)
	)
	(if ssFL
		(princ (strcat "\nFound {" (itoa (sslength ssFL)) "} Stranded Fill Lines!"))
	)
	(if ssFL
		(while (setq FNam (ssname ssFL FCnt))
			(if FNam
				(if F_Lst
					(setq	F_Lst	(cons FNam F_Lst))
					(setq	F_Lst	(list FNam))
				)
			)
			(setq	FCnt	(1+ FCnt))
		)
	)
	(setq	ssFL	nil
			FNam	nil
			FCnt	nil
	)
	(gc)
	(if F_Lst
		(foreach	FNam
				F_Lst
				(setq	FLay	(cdr (assoc 8 (entget FNam)))
						FHnd	(cdr (assoc 5 (entget FNam)))
						FLen	(GetPLen (entget FNam))
						FDat	(GetPLEnd FNam)
						FSpt	(nth 0 FDat)
						FEpt	(nth 1 FDat)
						FStf	(EntDatLstR FNam)
						FuID	(if EStf
								(if (= (car (last FStf)) "XData")
									(if (assoc "ID" (cdr (last FStf)))
										(cdr (assoc "ID" (cdr (last FStf))))
										""
									)
									""
								)
								""
							)
				)
				(setq	DevInf	(list	FHnd					;00
										"FL"					;01
										"NA"					;02
										""					;03
										FLay					;04
										"0.0"				;05
										"0.0"				;06
										"0.0"				;07
										FuID					;08
										"0.0"				;09
										"0.0"				;10
										"0.0"				;11
										"0.0"				;12
										"-1"					;13
										(rtos (car FSpt) 2 2)	;14
										(rtos (cadr FSpt) 2 2)	;15
										(rtos (car FEpt) 2 2)	;16
										(rtos (cadr FEpt) 2 2)	;17
										"N"					;18
										"N"					;19
										"N"					;20
										"N"					;21
										"N"					;22
										""					;23
										""					;24
										""					;25
										""					;26
										"-1"					;27
										"N"					;28
										FLay					;29
										FHnd					;30
										(rtos FLen 2 2)		;31
								)
				)
				(if DevInf
					(if DevInfLst
						(setq	DevInfLst	(cons DevInf DevInfLst))
						(setq	DevInfLst	(list DevInf))
					)
				)
		)
	)
	(if (and PNam DevInfLst)
		(setq	DevInfOut	(reverse DevInfLst)
				DevInfOut	(mapcar (quote (lambda (x) (cons PNam x))) DevInfOut)
		)
	)
	(if DevInfOut
		(progn
			(if (= (getvar "DWGTITLED") 1)
				(setq FN (open (strcat (getenv "MapQry") "\\MapQry\\SwInfoOut.TXT") "a"))
				(setq FN (open "SwInfoOut.TXT" "a"))
			)
			(setq	DevInfOut	(mapcar (quote (lambda (x) (mapcar (quote (lambda (y) (strcat "," y))) x))) DevInfOut))
			(setq	DevInfOut	(mapcar (quote (lambda (x) (apply (quote strcat) x))) DevInfOut))
			(if (and DevInfOut FN)
				(mapcar (quote (lambda (x) (write-line (substr x 2) FN))) DevInfOut)
			)
			(if FN (close FN))
		)
	)
	(if FN
		(setq	FN	nil)
	)
	(gc)
	DevInfLst
)

(defun GetSwFltR ( /	SwFltLst )			;Builds the Switch Filter List, eh?
	(if (not Bld_No_Dev)
		(progn
			(load "S:/Workgroups/APC Power Delivery/Division Mapping/Common/Tables.Lsp")
			(Bld_No_Dev)
		)
		(if (not Lst_No_Dev)
			(Bld_No_Dev)
		)
	)
	(setq	SwFltLst	(mapcar (quote (lambda (x) (cons 2 (car x)))) Lst_No_Dev))
	(if SwFltLst
		(setq	SwFltLst	(cons (cons -4 "OR>") (reverse SwFltLst)))
	)
	(if SwFltLst
		(setq	SwFltLst	(cons (cons -4 "<OR") (reverse SwFltLst)))
	)
	(if SwFltLst
		(setq	SwFltLst	(cons (cons 0 "INSERT") SwFltLst))
	)
	(if SwFltLst
		(setq	SwFltLst	(cons (cons 67 0) SwFltLst))
	)
	(if SwFltLst
		(setq	SwFltLst	(cons (cons -4 "AND>") (reverse SwFltLst)))
	)
	(if SwFltLst
		(setq	SwFltLst	(cons (cons -4 "<AND") (reverse SwFltLst)))
	)
	SwFltLst
)

(defun C:RstFL ( /	)						;Comment Here
	(setq	DevCntr	nil)
	(princ)
)

(defun C:TstFL ( /	AttWas					;Comment Here
					BlpWas CmdWas ColWas EchWas ExWas FilWas LayWas LtWas OsWas TmdWas )
	(if Bug (princ "\n{ C:TstFL entered}\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			CmdWas	(getvar "CMDDIA")
			ColWas	(getvar "CECOLOR")
			EchWas	(getvar "CMDECHO")
			ExWas	(getvar "EXPERT")
			FilWas	(getvar "FILEDIA")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			TmdWas	(getvar "TILEMODE")
	)
	
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
		)
	)
	(command "_.UNDO" "_BE")
	(setq	DevInfLst	nil
			NNam		(car (entsel "\nSelect Block to Test: "))
			EdsLocal	T
	)
	(if NNam
		(setq	Cntr		0
				Bubba	(princ (strcat "\nHere goes Run {" (itoa (1+ Cntr)) "}..."))
				E_Lst	(ChkInsOther NNam nil nil)
				N_Lst	(if (> (length (car E_Lst)) 1) (RemLst NNam (car E_Lst)) nil)
				D_Lst	(list NNam)
		)
		(setq	E_Lst	nil
				N_Lst	nil
				D_Lst	nil
				Cntr		nil
		)
	)
	(if (and N_Lst E_Lst D_Lst)
		(while (and N_Lst E_Lst)
			(setq	Cntr		(1+ Cntr))
			(if (> (length N_Lst) 0)
				(setq	NNam		(car N_Lst)
						D_Lst	(cons NNam D_Lst)
						N_Lst	(if (> (length N_Lst) 1) (cdr N_Lst) nil)
						E_Lst	(ChkInsOther NNam (nth 1 E_Lst) (nth 2 E_Lst))
						Bubba	(princ (strcat "\nHere goes Run {" (itoa (1+ Cntr)) "}..."))
				)
				(setq	NNam		nil)
			)
			(if NNam
				(foreach	INam
						(car E_Lst)
						(if (and N_Lst D_Lst)
							(if (and (not (member INam D_Lst)) (not (member INam N_Lst)))
								(setq	N_Lst	(reverse (cons INam (reverse N_Lst))))
							)
							(if D_Lst
								(if (not (member INam D_Lst))
									(setq	N_Lst	(list INam))
								)
							)
						)
				)
			)
		)
	)
	(if E_Lst
		(if (= (length (car E_Lst)) 1)
			(if (= (cdr (assoc 2 (entget (caar E_Lst)))) "A122")
				(setq	ssFL	(ssget "CP" (last E_Lst) (list (cons 0 "POLYLINE") (cons 8 "????FL*"))))
				(setq	ssFL	(ssget "WP" (last E_Lst) (list (cons 0 "POLYLINE") (cons 8 "????FL*"))))
			)
			(setq	ssFL	(ssget "WP" (last E_Lst) (list (cons 0 "POLYLINE") (cons 8 "????FL*"))))
		)
		(setq	ssFL	nil)
	)
	(if ssFL
		(if (> (sslength ssFL) 1)
			(princ (strcat "\nFound {" (itoa (sslength ssFL)) "} Fill Line Fragments under {" (itoa (length (car E_Lst))) "} Inserts."))
			(princ (strcat "\nFound {" (itoa (sslength ssFL)) "} Fill Line under {" (itoa (length (car E_Lst))) "} Inserts."))
		)
		(princ (strcat "\nFound {No} Fill Lines under {" (itoa (length (car E_Lst))) "} Inserts."))
	)
	
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CMDECHO" EchWas)
	(setvar "EXPERT" ExWas)
	(setvar "FILEDIA" FilWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "TILEMODE" TmdWas)
	(if Bug (princ "\n{ C:TstFL exited}\n"))
	(princ)
)

(defun C:TstADev ( /	AttWas					;Comment Here
					BlpWas CmdWas ColWas EchWas ExWas FilWas LayWas LtWas OsWas TmdWas )
	(if Bug (princ "\n{ C:TstADev entered}\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			CmdWas	(getvar "CMDDIA")
			ColWas	(getvar "CECOLOR")
			EchWas	(getvar "CMDECHO")
			ExWas	(getvar "EXPERT")
			FilWas	(getvar "FILEDIA")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			TmdWas	(getvar "TILEMODE")
	)
	
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
		)
	)
	(command "_.UNDO" "_BE")
	(setq	DevInfLst	(SwChk))
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CMDECHO" EchWas)
	(setvar "EXPERT" ExWas)
	(setvar "FILEDIA" FilWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "TILEMODE" TmdWas)
	(if Bug (princ "\n{ C:TstADev exited}\n"))
	(princ)
)

(defun C:SwChk ( /	AttWas					;Comment Here
				BlpWas CmdWas ColWas EchWas ExWas
				FilWas LayWas LtWas OsWas TmdWas ); DevInfLst
	(if Bug (princ "\n{ C:SwChk entered}\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			CmdWas	(getvar "CMDDIA")
			ColWas	(getvar "CECOLOR")
			EchWas	(getvar "CMDECHO")
			ExWas	(getvar "EXPERT")
			FilWas	(getvar "FILEDIA")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			TmdWas	(getvar "TILEMODE")
			LgNWas	(getvar "LOGFILENAME")
			LogWas	(getvar "LOGFILEMODE")
	)
	(setvar "LOGFILENAME" "C:\\MapQry\\RER_Chk_Log.Log")
	(setvar "LOGFILEMODE" 1)
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
		)
	)
	(command "_.UNDO" "_BE")
	(setq	DevCntr	nil)
	(setq	DevInfLst	(SwChk))
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CMDECHO" EchWas)
	(setvar "EXPERT" ExWas)
	(setvar "FILEDIA" FilWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "TILEMODE" TmdWas)
	(setvar "LOGFILENAME" LgNWas)
	(setvar "LOGFILEMODE" LogWas)
	(if Bug (princ "\n{ C:SwChk exited}\n"))
	(princ)
)

;-------------------------------------------------------------------------------
(DEFUN Cir ( PT clr /	H C0 S0 A C1 S1 F LOOP	; Draws Circles
					X1 X2 Y1 Y2 )
	; 2pi = 6.283185307  and  pi/8 = 0.392699081 summed = 6.675885117
	(SETQ	H	(* (GETVAR "VIEWSIZE") 0.06)
			C0	1.0
			S0	0.0
			A	0.392699081
	)
	(WHILE (<= A 6.675885117)
		(SETQ	C1	(COS A)
				S1	(SIN A)
				F	H
				LOOP	1
		)
		(WHILE (< LOOP 4)
			(SETQ	F	(* F 0.65)
					X1	(+ (CAR PT)  (* F C0))
					X2	(+ (CAR PT)  (* F C1))
					Y1	(+ (CADR PT) (* F S0))
					Y2	(+ (CADR PT) (* F S1))
			)
			(GRDRAW (LIST X1 Y1) (LIST X2 Y2) clr 0)
			(SETQ	LOOP	(1+ LOOP))
		)
		(SETQ	C0	C1
				S0	S1
				A	(+ A 0.392699081)
		)
	)
	(princ)
)
;-------------------------------------------------------------------------------

(defun Show ( points clr /	PT )				; function DRAW CIRCLES AROUND POINTS in given list by given color.
	(FOREACH PT points
		(CIR PT clr)
	)
	(princ)
)
;-------------------------------------------------------------------------------

(defun Look ( pl / vtx X Y Eset nextpl n )
	(setq	worked	(ssadd pl worked))
	(if (ssmemb pl waiting) 
		(setq	waiting	(ssdel pl waiting))
	)
	(setq vtx pl)
	(command "CHPROP" pl "" "C" 1 "")
	(while (/= (cdr (assoc 0 (entget (setq vtx (entnext vtx))))) "SEQEND")
		(setq	X	(car (cdr (assoc 10 (entget vtx))))
				Y	(cadr (cdr (assoc 10 (entget vtx))))
				Eset	(ssget "C" (list (- X 1.0) (- Y 1.0)) (list (+ X 1.0) (+ Y 1.0)) (list (cons 0 "POLYLINE")))
		)
		(setq	n	0)
	    (while (setq nextpl (ssname Eset n))
			(if (ssmemb nextpl worked) 
				(ssdel nextpl Eset)
				(if (ssmemb nextpl waiting)
					(ssdel nextpl Eset)
					(progn
						(ssadd nextpl waiting)
						(setq	n	(1+ n))
					)
				)
			)
	    )
	    (if (> (sslength Eset) 0)
			(progn
				(setq	n	0)
				(while (setq nextpl (ssname Eset n))
					(look nextpl)
					(setq	n	(1+ n))
				)
			)
	    )
		(COMMAND "TEXT" "J" "MC" (cdr (assoc 10 (entget vtx))) 30.0 0.0 "X")
	)
)
;------------------------------------------------------------------------------

(defun Test ( / )
	(setvar "CMDECHO" 0)
	(setq	worked	(ssadd)
			waiting	(ssadd)
	)
	(look (car (entsel "PICK ONE")))
)
;-------------------------------------------------------------------------------

(defun C:ShwFLNo ( /	AttWas BlpWas ColWas	;
					LtWas LayWas CmdWas EchWas FilWas OsWas ExWas Bubba NoLst GoLst )
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			ColWas	(getvar "CECOLOR")
			LtWas	(getvar "CELTYPE")
			LayWas	(getvar "CLAYER")
			CmdWas	(getvar "CMDDIA")
			EchWas	(getvar "CMDECHO")
			FilWas	(getvar "FILEDIA")
			OsWas	(getvar "OSMODE")
			ExWas	(getvar "EXPERT")
	)
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
			(setvar "EXPERT" 5)
		)
	)
	(command "_.UNDO" "_BE")
	(if LstNptCkt
		(if ChzInt
			(setq	Bubba	(if (and (>= ChzInt 1) (<= ChzInt (length LstNptCkt)))
								(setq	Bubba	(Show (list (nth 0 (nth (1- ChzInt) LstFptCkt))) 4)
										Bubba	(Show (list (nth 1 (nth (1- ChzInt) LstFptCkt))) 4)
										Bubba	(redraw (nth 2 (nth (1- ChzInt) LstFptCkt)) 3)
								)
							)
					WazInt	(1+ ChzInt)
					ChzInt	(getint (strcat "\nTheir are {" (itoa (length LstNptCkt)) "} Un-Matched Fill Line(s) to inspect.  <" (itoa WazInt) ">: "))
			)
			(setq	ChzInt	(getint (strcat "\nTheir are {" (itoa (length LstNptCkt)) "} Un-Matched Fill Line(s) to inspect.  Which one: ")))
		)
		(progn
			(alert "*** C:ShwFLNo Error ***\nCould not initialize FL list")
			(exit)
		)
	)
	(if (and (null ChzInt) WazInt)
		(if (and (>= WazInt 2) (<= WazInt (1+ (length LstNptCkt))))
			(setq	ChzInt	WazInt)
		)
	)
	(if (and (>= ChzInt 1) (<= ChzInt (length LstNptCkt)))
		(progn
			(setq	NoLst	(nth (1- ChzInt) LstNptCkt))
			(command "_.Zoom" "C" NoLst 500.0)	;(* 0.75 PnScl))
			(Show (list (nth 0 (nth (1- ChzInt) LstFptCkt))) 4)
			(Show (list (nth 1 (nth (1- ChzInt) LstFptCkt))) 4)
			(redraw (nth 2 (nth (1- ChzInt) LstFptCkt)) 3)
			;(redraw (handent (nth 0 NoLst)) 3)
		)
		(princ "\nNot a valid value for viewing! Try again\n")
	)
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CELTYPE" LtWas)
	(setvar "CLAYER" LayWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CMDECHO" EchWas)
	(setvar "FILEDIA" FilWas)
	(setvar "OSMODE" OsWas)
	(setvar "EXPERT" ExWas)
	(princ)
)
;-------------------------------------------------------------------------------

(defun C:ShwIPNo ( /	AttWas BlpWas ColWas	;
					LtWas LayWas CmdWas EchWas FilWas OsWas ExWas Bubba NoLst GoLst )
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			ColWas	(getvar "CECOLOR")
			LtWas	(getvar "CELTYPE")
			LayWas	(getvar "CLAYER")
			CmdWas	(getvar "CMDDIA")
			EchWas	(getvar "CMDECHO")
			FilWas	(getvar "FILEDIA")
			OsWas	(getvar "OSMODE")
			ExWas	(getvar "EXPERT")
	)
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
			(setvar "EXPERT" 5)
		)
	)
	(command "_.UNDO" "_BE")
	(if LstIptCkt
		(if ChzInt
			(setq	Bubba	(if (and (>= ChzInt 1) (<= ChzInt (length LstIptCkt)))
								(setq	Bubba	(Show (list (nth 3 (nth (1- ChzInt) LstIptCkt))) 5)
										;Bubba	(Show (list (nth 4 (nth (1- ChzInt) LstIptCkt))) 5)
										;Bubba	(Show (list (nth 5 (nth (1- ChzInt) LstIptCkt))) 5)
										Bubba	(redraw (handent (nth 2 (nth (1- ChzInt) LstIptCkt))) 3)
								)
							)
					WazInt	(1+ ChzInt)
					ChzInt	(getint (strcat "\nTheir are {" (itoa (length LstIptCkt)) "} Device(s) to inspect.  <" (itoa WazInt) ">: "))
			)
			(setq	ChzInt	(getint (strcat "\nTheir are {" (itoa (length LstIptCkt)) "} Device(s) to inspect.  Which one: ")))
		)
		(progn
			(alert "*** C:ShwIPNo Error ***\nCould not initialize FL list")
			(exit)
		)
	)
	(if (and (null ChzInt) WazInt)
		(if (and (>= WazInt 2) (<= WazInt (1+ (length LstIptCkt))))
			(setq	ChzInt	WazInt)
		)
	)
	(if (and (>= ChzInt 1) (<= ChzInt (length LstIptCkt)))
		(progn
			(setq	NoLst	(nth 3 (nth (1- ChzInt) LstIptCkt)))
			(command "_.Zoom" "C" NoLst 500.0)	;(* 0.75 PnScl))
			(Show (list (nth 3 (nth (1- ChzInt) LstIptCkt))) 5)
			;(Show (list (nth 4 (nth (1- ChzInt) LstIptCkt))) 5)
			;(Show (list (nth 5 (nth (1- ChzInt) LstIptCkt))) 5)
			(redraw (handent (nth 2 (nth (1- ChzInt) LstIptCkt))) 3)
			(princ (strcat "\nItem:" (itoa (1+ (nth 0 (nth (1- ChzInt) LstIptCkt)))) " Block:{" (nth 1 (nth (1- ChzInt) LstIptCkt)) "} Handle:[" (nth 2 (nth (1- ChzInt) LstIptCkt)) "]"))
			;(redraw (handent (nth 0 NoLst)) 3)
		)
		(princ "\nNot a valid value for viewing! Try again\n")
	)
	(C:ShwSw)
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CELTYPE" LtWas)
	(setvar "CLAYER" LayWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CMDECHO" EchWas)
	(setvar "FILEDIA" FilWas)
	(setvar "OSMODE" OsWas)
	(setvar "EXPERT" ExWas)
	(princ)
)
;-------------------------------------------------------------------------------

(defun C:ShwSw ( /	AttWas					;Comment Here
					BlpWas CmdWas ColWas EchWas ExWas FilWas LayWas LtWas OsWas TmdWas )
	(if Bug (princ "\n{ C:ShwSw entered}\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			CmdWas	(getvar "CMDDIA")
			ColWas	(getvar "CECOLOR")
			EchWas	(getvar "CMDECHO")
			ExWas	(getvar "EXPERT")
			FilWas	(getvar "FILEDIA")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			TmdWas	(getvar "TILEMODE")
	)
	
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
		)
	)
	(command "_.UNDO" "_BE")
	(if LstSptCkt
		(show LstSptCkt 1)
	)
	(if LstEptCkt
		(show LstEptCkt 2)
	)
	(if LstCptCkt
		(show LstCptCkt 3)
	)
	(if LstNptCkt
		(show LstNptCkt 4)
	)
	(if LstFLnCkt
		(show (mapcar (quote car) LstFLnCkt) 6)
	)
	(if LstSptCkt
		(princ (strcat "\nFound {" (itoa (length LstSptCkt)) "} Start Point Mis-Matches"))
	)
	(if LstEptCkt
		(princ (strcat "\nFound {" (itoa (length LstEptCkt)) "} End Point Mis-Matches"))
	)
	(if LstCptCkt
		(princ (strcat "\nFound {" (itoa (length LstCptCkt)) "} Fill Line Mis-Matches"))
	)
	(if LstNptCkt
		(princ (strcat "\nFound {" (itoa (length LstNptCkt)) "} Un-Matched Fill Line(s)"))
	)
	(if LstFLnCkt
		(princ (strcat "\nFound {" (itoa (length LstFLnCkt)) "} Mis-Scaled Fill Line(s)"))
	)
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CMDECHO" EchWas)
	(setvar "EXPERT" ExWas)
	(setvar "FILEDIA" FilWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "TILEMODE" TmdWas)
	(if Bug (princ "\n{ C:ShwSw exited}\n"))
	(princ)
)
;-------------------------------------------------------------------------------

(defun GetDevInfo ( Enam /	EStf ELst EBlk ELay EFdr EkVL ELen ERot ERtc EIns EHnd EuID EOpt ESpt EEpt ECpt DevInf ELtp )
	(setq	EStf			(EntDatLstR Enam)
			ELst			(entget Enam)
			EBlk			(cdr (assoc 2 ELst))
			ELay			(cdr (assoc 8 ELst))
			EFdr			(if (> (strlen ELay) 2) (substr ELay 1 3) "   ")
			EkVL			(if (> (strlen ELay) 9) (substr ELay 9 2) "  ")
			ELen			(cdr (assoc 41 ELst))
			ERot			(cdr (assoc 50 ELst))
			ERtc			ERot
			EIns			(cdr (assoc 10 ELst))
			EHnd			(cdr (assoc 5 ELst))
			EuID			(if EStf
							(if (= (car (last EStf)) "XData")
								(if (assoc "ID" (cdr (last EStf)))
									(cdr (assoc "ID" (cdr (last EStf))))
									nil
								)
								nil
							)
							nil
						)
			EOpt			(if EStf
							(if (= (nth 9 EStf) 1)
								(if (nth 10 EStf)
									(if (cdr (nth 10 EStf))
										(if (assoc "LOC_NUM" (cdr (nth 10 EStf)))
											(StpBadChar (nth 1 (assoc "LOC_NUM" (cdr (nth 10 EStf)))) 2)
											nil
										)
										nil
									)
									nil
								)
								nil
							)
							nil
						)
	)
	(cond	((= EBlk "A140")
				(setq	ESpt		EIns
						EEpt		(polar ESpt ERot (* 1.0 ELen))
						ECpt		(polar ESpt ERot (* 0.5 ELen))
				)
			)
			((= EBlk "A122")
				(setq	ELtp		(* ELen 0.70)
						ECpt		EIns
						ESpt		(polar ECpt (+ (/ pi 2.0) ERot) (* 0.5 ELtp))
						EEpt		(polar ECpt (+ (/ (* pi 3.0) 2.0) ERot) (* 0.5 ELtp))
				)
			)
			(T
				(setq	ECpt		EIns
						ESpt		(polar ECpt (+ pi ERot) (* 0.5 ELen))
						EEpt		(polar ECpt ERot (* 0.5 ELen))
				)
			)
	)
	(if ERtc
		(cond
			((<= ERtc -0.0001)
				(while (<= ERtc -0.0001)
					(setq	ERtc	(+ ERtc pi))
				)
			)
			((>= ERtc (+ pi 0.0001))
				(while (>= ERtc (+ pi 0.0001))
					(setq	ERtc	(- ERtc pi))
				)
			)
		)
	)
	(setq	DevInf	(list	(nth 1 EStf)								;Dev_Handle	00
							(nth 0 EStf)								;Block_Name	01
							(if (member (nth 0 EStf) Lst_No_Ver) "OPN" "CLO")	;Normal_State	02
							(if EOpt EOpt "")							;Switch_Name	03
							(nth 2 EStf)								;Switch_Layer	04
							(rtos (car (nth 3 EStf)) 2 2)					;Easting		05
							(rtos (cadr (nth 3 EStf)) 2 2)				;Northing		06
							(if ELen (rtos ELen 2 2) "0.0")				;Switch_Scale	07
							(if EuID EuID "")							;Device_ID	08
							(rtos (car ESpt) 2 2)						;SPT_X		09
							(rtos (cadr ESpt) 2 2)						;SPT_Y		10
							(rtos (car EEpt) 2 2)						;EPT_X		11
							(rtos (cadr EEpt) 2 2)						;EPT_Y		12
					)
	)
	(if DevInfLst
		(if (assoc EHnd DevInfLst)
			(setq	PosOut	(- (length DevInfLst) (length (member (assoc EHnd DevInfLst) DevInfLst)))
					DevInfLst	(RepLst DevInfLst DevInf PosOut)
			)
			(setq	DevInfLst	(cons DevInf DevInfLst))
		)
		(setq	DevInfLst	(list DevInf))
	)
	(list	EHnd		;00
			EStf		;01
			ELst		;02
			EBlk		;03
			ELay		;04
			EFdr		;05
			EkVL		;06
			ELen		;07
			ERot		;08
			ERtc		;09
			EIns		;10
			EuID		;11
			EOpt		;12
			ESpt		;13
			EEpt		;14
			ECpt		;15
			DevInf	;16
	)
)

(defun ChkInsOther ( Enam ISpt IEpt	/	ISdv	;Checks for ultimate in-line endpoints...
									ICnt USpt UEpt EDat PBox JumpOut CCnt NoMatch NoStart
									UIEnamLst IAng Cset PScl Bubba PMlt UAng XMlt
									Upt1 Upt2 Upt3 Upt4 MaxY MaxX MinY MinX DevInf NSpt NEpt )
	(setq	ISdv			T
			ICnt			0
			EDat			(GetDevInfo Enam)
			USpt			(nth 13 EDat)
			UEpt			(nth 14 EDat)
			UAng			(angle USpt UEpt)
			PBox	    		8.0
			JumpOut  		2.0
			CCnt			0
			NoMatch		T
			NoStart		T
			UIEnamLst		(list Enam)
	)
	(if (not SwFltLst)
		(setq	SwFltLst	(GetSwFltR))
	)
	(if (and ISpt IEpt)
		(setq	IAng	(angle ISpt IEpt))
		(setq	IAng	nil)
	)
	(if Bug
		(princ	(strcat	"\n[A]USptX:{" (rtos (car USpt) 2 4)
						"},USptY:{" (rtos (cadr USpt) 2 4)
						"}"
				)
		)
	)
	(if Bug
		(princ	(strcat	"\n[A]UEptX:{" (rtos (car UEpt) 2 4)
						"},UEptY:{" (rtos (cadr UEpt) 2 4)
						"}"
				)
		)
	)
	(if IAng
		(cond
			((<= IAng -0.0001)
				(while (<= IAng -0.0001)
					(setq	IAng	(+ IAng pi))
				)
			)
			((>= IAng (+ pi 0.0001))
				(while (>= IAng (+ pi 0.0001))
					(setq	IAng	(- IAng pi))
				)
			)
		)
	)
	(command "_.Zoom" "C" (nth 15 EDat) (* 5.0 (abs (nth 7 EDat))))
	(princ (strcat "\nEChk Blk {" (nth 3 EDat) "} Angle {" (angtos (nth 8 EDat) 0 2) "} "))
	(if (= (getvar "DWGTITLED") 1)
		(if (setq Cset (ssget "X" (list (cons 0 "ATTDEF") (cons 8 "*-SC-*"))))
			(setq	PScl	(atof (cdr (assoc 1 (entget (ssname Cset 0))))))
			(setq	PScl	500.0)
		)
		(setq	PScl	(atof (GetPS (nth 15 EDat))))
	)
	(if Cset
		(setq	Cset			nil
				Bubba		(gc)
		)
	)
	;Check EEpt for other inserts...
	(if IAng
	 	(if (equal IAng (nth 9 EDat) 0.05)				;If IAng = ERtc Corrected Rotations are equal...
			(while	(and	(not	(setq	Cset	(ssget	"C"
												(list	(- (car UEpt) PBox)
														(- (cadr UEpt) PBox)
												)
												(list	(+ (car UEpt) PBox)
														(+ (cadr UEpt) PBox)
												)
												SwFltLst
										)
							)
						)
						(not NoStart)
						(< PBox 25.0)
					)
				(setq	PBox	(+ PBox JumpOut)
						ICnt	(1+ ICnt)
				)
				(if Bug
					(progn
						(grdraw (list (- (car UEpt) PBox) (- (cadr UEpt) PBox)) (list (+ (car UEpt) PBox) (- (cadr UEpt) PBox)) 1 1)
						(grdraw (list (+ (car UEpt) PBox) (- (cadr UEpt) PBox)) (list (+ (car UEpt) PBox) (+ (cadr UEpt) PBox)) 1 1)
						(grdraw (list (+ (car UEpt) PBox) (+ (cadr UEpt) PBox)) (list (- (car UEpt) PBox) (+ (cadr UEpt) PBox)) 1 1)
						(grdraw (list (- (car UEpt) PBox) (+ (cadr UEpt) PBox)) (list (- (car UEpt) PBox) (- (cadr UEpt) PBox)) 1 1)
					)
				)
			)
			(setq	Cset	nil)
		)
		(while	(and	(not	(setq	Cset	(ssget	"C"	;Or If Not IAng at all...
											(list	(- (car UEpt) PBox)
													(- (cadr UEpt) PBox)
											)
											(list	(+ (car UEpt) PBox)
													(+ (cadr UEpt) PBox)
											)
											SwFltLst
									)
						)
					)
					(not NoStart)
					(< PBox 25.0)
				)
			(setq	PBox	(+ PBox JumpOut)
					ICnt	(1+ ICnt)
			)
			(if Bug
				(progn
					(grdraw (list (- (car UEpt) PBox) (- (cadr UEpt) PBox)) (list (+ (car UEpt) PBox) (- (cadr UEpt) PBox)) 1 1)
					(grdraw (list (+ (car UEpt) PBox) (- (cadr UEpt) PBox)) (list (+ (car UEpt) PBox) (+ (cadr UEpt) PBox)) 1 1)
					(grdraw (list (+ (car UEpt) PBox) (+ (cadr UEpt) PBox)) (list (- (car UEpt) PBox) (+ (cadr UEpt) PBox)) 1 1)
					(grdraw (list (- (car UEpt) PBox) (+ (cadr UEpt) PBox)) (list (- (car UEpt) PBox) (- (cadr UEpt) PBox)) 1 1)
				)
			)
		)
	)
	(if Cset
		(if	(and	(= (sslength Cset) 1)
				(ssmemb Enam Cset)
			)
			(setq	Bubba	(if Bug (princ (strcat "\nICnt [" (itoa (1+ ICnt)) "] had only ENam!")))
					Cset		nil
					Bubba	(gc)
			)
			(if	(and	(> (sslength Cset) 1)
					(ssmemb Enam Cset)
				)
				(setq	Bubba	(if Bug (princ (strcat "\nICnt [" (itoa (1+ ICnt)) "] had {" (itoa (sslength Cset)) "} members, and ENam is one!")))
						Cset		(ssdel Enam Cset)
						NoStart	nil
				)
			)
		)
	)
	(if (and Bug Cset)
		(if Cset
			(princ (strcat "\nICnt [" (itoa ICnt) "] at EEpt has {" (itoa (sslength Cset)) "} members to test!"))
			(princ (strcat "\nICnt [" (itoa ICnt) "] at EEpt is empty!"))
		)
	)
	(if Cset
		(progn
			(while	(and	(setq	CNam	(ssname Cset CCnt))
						NoMatch
					)
				(setq	CDat1		(GetDevInfo CNam))
				;;;===================================================
			 	(if (equal (nth 9 CDat1) (nth 9 EDat) 0.05)				;If CRtc = ERtc Corrected Rotations are equal...
					(if (equal (nth 13 CDat1) UEpt 3.0)				;And If CSpt = UEpt
						(setq	ISdv			T
								NoMatch		nil
								Bubba		(if Bug (princ (strcat "\nChk [" (itoa (1+ CCnt)) "] is Blk {" (nth 3 CDat1) "} at angle {" (angtos (nth 9 CDat1) 0 2) "} - Match, extending Ultimate Endpoint!")))
								UIEnamLst		(cons CNam UIEnamLst)
								UEpt			(nth 14 CDat1)
						)
						(if (equal (nth 14 CDat1) UEpt 1.5)			;Or If CEpt = UEpt
							(setq	ISdv			T
									NoMatch		nil
									Bubba		(if Bug (princ (strcat "\nChk [" (itoa (1+ CCnt)) "] is Blk {" (nth 3 CDat1) "} at angle {" (angtos (nth 9 CDat1) 0 2) "} - Match, extending Ultimate Endpoint!")))
									UIEnamLst		(cons CNam UIEnamLst)
									UEpt			(nth 13 CDat1)
							)
							(setq	ISdv			nil
									Bubba		(if Bug (princ (strcat "\nChk [" (itoa (1+ CCnt)) "] is Blk {" (nth 3 CDat1) "} at angle {" (angtos (nth 9 CDat1) 0 2) "} - No Match.")))
							)
						)
					)
					(setq	ISdv		nil
							Bubba		(if Bug (princ (strcat "\nChk [" (itoa (1+ CCnt)) "] is Blk {" (nth 3 CDat1) "} at angle {" (angtos (nth 9 CDat1) 0 2) "} - No Match.")))
					)
				)
				;;;===================================================
				(setq	CCnt	(1+ CCnt))
			)
		)
		(setq	ISdv		nil)
	)
	(if Cset
		(setq	Cset			nil
				Bubba		(gc)
		)
	)
	;Check ESpt for other inserts...
	(if IAng
	 	(if (equal IAng (nth 9 EDat) 0.05)				;If IAng = ERtc Corrected Rotations are equal...
			(while	(and	(not	(setq	Cset	(ssget	"C"
												(list	(- (car USpt) PBox)
														(- (cadr USpt) PBox)
												)
												(list	(+ (car USpt) PBox)
														(+ (cadr USpt) PBox)
												)
												SwFltLst
										)
							)
						)
						(not NoStart)
						(< PBox 25.0)
					)
				(setq	PBox	(+ PBox JumpOut)
						ICnt	(1+ ICnt)
				)
				(if Bug
					(progn
						(grdraw (list (- (car USpt) PBox) (- (cadr USpt) PBox)) (list (+ (car USpt) PBox) (- (cadr USpt) PBox)) 2 1)
						(grdraw (list (+ (car USpt) PBox) (- (cadr USpt) PBox)) (list (+ (car USpt) PBox) (+ (cadr USpt) PBox)) 2 1)
						(grdraw (list (+ (car USpt) PBox) (+ (cadr USpt) PBox)) (list (- (car USpt) PBox) (+ (cadr USpt) PBox)) 2 1)
						(grdraw (list (- (car USpt) PBox) (+ (cadr USpt) PBox)) (list (- (car USpt) PBox) (- (cadr USpt) PBox)) 2 1)
					)
				)
			)
			(setq	Cset	nil)
		)
		(while	(and	(not	(setq	Cset	(ssget	"C"
											(list	(- (car USpt) PBox)
													(- (cadr USpt) PBox)
											)
											(list	(+ (car USpt) PBox)
													(+ (cadr USpt) PBox)
											)
											SwFltLst
									)
						)
					)
					(not NoStart)
					(< PBox 25.0)
				)
			
			(setq	PBox	(+ PBox JumpOut)
					ICnt	(1+ ICnt)
			)
			(if Bug
				(progn
					(grdraw (list (- (car USpt) PBox) (- (cadr USpt) PBox)) (list (+ (car USpt) PBox) (- (cadr USpt) PBox)) 2 1)
					(grdraw (list (+ (car USpt) PBox) (- (cadr USpt) PBox)) (list (+ (car USpt) PBox) (+ (cadr USpt) PBox)) 2 1)
					(grdraw (list (+ (car USpt) PBox) (+ (cadr USpt) PBox)) (list (- (car USpt) PBox) (+ (cadr USpt) PBox)) 2 1)
					(grdraw (list (- (car USpt) PBox) (+ (cadr USpt) PBox)) (list (- (car USpt) PBox) (- (cadr USpt) PBox)) 2 1)
				)
			)
		)
	)
	(if Cset
		(if	(and	(= (sslength Cset) 1)
				(ssmemb Enam Cset)
			)
			(setq	Bubba	(if Bug (princ (strcat "\nICnt [" (itoa (1+ ICnt)) "] had only ENam!")))
					Cset		nil
					Bubba	(gc)
			)
			(if	(and	(> (sslength Cset) 1)
					(ssmemb Enam Cset)
				)
				(setq	Bubba	(if Bug (princ (strcat "\nICnt [" (itoa (1+ ICnt)) "] had {" (itoa (sslength Cset)) "} members, and ENam is one!")))
						Cset		(ssdel Enam Cset)
						NoStart	nil
				)
			)
		)
	)
	(if (and Bug Cset)
		(if Cset
			(princ (strcat "\nICnt [" (itoa ICnt) "] at ESpt has {" (itoa (sslength Cset)) "} members to test!"))
			(princ (strcat "\nICnt [" (itoa ICnt) "] at ESpt is empty!"))
		)
	)
  	(setq	NoMatch	T
			CCnt		0
	)
	(if Cset
		(progn
			(while	(and	(setq	CNam	(ssname Cset CCnt))
						NoMatch
					)
				(setq	CDat2		(GetDevInfo CNam))
			 	(if (equal (nth 9 CDat2) (nth 9 EDat) 0.05)
					(if (equal (nth 13 CDat2) USpt 1.0)
						(setq	ISdv			T
								NoMatch		nil
								Bubba		(if Bug (princ (strcat "\nChk [" (itoa (1+ CCnt)) "] is Blk {" (nth 3 CDat2) "} at angle {" (angtos (nth 9 CDat2) 0 2) "} - Match, extending Ultimate Start Point!")))
								UIEnamLst		(cons CNam UIEnamLst)
								USpt			(nth 14 CDat2)
						)
						(if (equal (nth 14 CDat2) USpt 1.0)
							(setq	ISdv			T
									NoMatch		nil
									Bubba		(if Bug (princ (strcat "\nChk [" (itoa (1+ CCnt)) "] is Blk {" (nth 3 CDat2) "} at angle {" (angtos (nth 9 CDat2) 0 2) "} - Match, extending Ultimate Start Point!")))
									UIEnamLst		(cons CNam UIEnamLst)
									USpt			(nth 13 CDat2)
							)
							(setq	ISdv			nil
									Bubba		(if Bug (princ (strcat "\nChk [" (itoa (1+ CCnt)) "] is Blk {" (nth 3 CDat2) "} at angle {" (angtos (nth 9 CDat2) 0 2) "} - No Match.")))
							)
						)
					)
					(setq	ISdv		nil
							Bubba		(if Bug (princ (strcat "\nChk [" (itoa (1+ CCnt)) "] is Blk {" (nth 3 CDat2) "} at angle {" (angtos (nth 9 CDat2) 0 2) "} - No Match.")))
					)
				)
				(setq	CCnt	(1+ CCnt))
			)
		)
		(setq	ISdv		nil)
	)
	(if Cset
		(setq	Cset			nil
				Bubba		(gc)
		)
	)
	(if (and ISpt IEpt USpt UEpt)
		(cond
			((equal (angle (nth 15 EDat) ISpt) (angle (nth 15 EDat) USpt) 0.5)
				(if	(>	(distance (nth 15 EDat) ISpt)
						(distance (nth 15 EDat) USpt)
					)
					(setq	NSpt		ISpt)
					(setq	NSpt		USpt)
				)
			)
			((equal (angle (nth 15 EDat) ISpt) (angle (nth 15 EDat) UEpt) 0.5)
				(if	(>	(distance (nth 15 EDat) ISpt)
						(distance (nth 15 EDat) UEpt)
					)
					(setq	NSpt		ISpt)
					(setq	NSpt		UEpt)
				)
			)
		)
	)
	(if (and ISpt IEpt USpt UEpt)
		(cond
			((equal (angle (nth 15 EDat) IEpt) (angle (nth 15 EDat) USpt) 0.5)
				(if	(>	(distance (nth 15 EDat) IEpt)
						(distance (nth 15 EDat) USpt)
					)
					(setq	NEpt		IEpt)
					(setq	NEpt		USpt)
				)
			)
			((equal (angle (nth 15 EDat) IEpt) (angle (nth 15 EDat) UEpt) 0.5)
				(if	(>	(distance (nth 15 EDat) IEpt)
						(distance (nth 15 EDat) UEpt)
					)
					(setq	NEpt		IEpt)
					(setq	NEpt		UEpt)
				)
			)
		)
	)
	(if NSpt
		(setq	USpt		NSpt)
	)
	(if NEpt
		(setq	UEpt		NEpt)
	)
	(if (and USpt UEpt)
		(setq	UAng	(angle USpt UEpt))
	)
	(if UAng
		(cond
			((<= UAng -0.0001)
				(while (<= UAng -0.0001)
					(setq	UAng	(+ UAng pi))
				)
			)
			((>= UAng (+ pi 0.0001))
				(while (>= UAng (+ pi 0.0001))
					(setq	UAng	(- UAng pi))
				)
			)
		)
	)
	(if (and USpt UEpt)
		(setq	PMlt		0.015625		;0.009
				UAng		(angle USpt UEpt)
				XMlt		(* 0.025 (distance USpt UEpt))
				Upt1		(polar USpt (+ UAng (/ pi 2.0)) (* PMlt PScl))
				Upt1		(polar Upt1 (+ UAng pi) XMlt)
				Upt2		(polar UEpt (+ UAng (/ pi 2.0)) (* PMlt PScl))
				Upt2		(polar Upt2 UAng XMlt)
				Upt3		(polar USpt (+ UAng (/ (* pi 3.0) 2.0)) (* PMlt PScl))
				Upt3		(polar Upt3 (+ UAng pi) XMlt)
				Upt4		(polar UEpt (+ UAng (/ (* pi 3.0) 2.0)) (* PMlt PScl))
				Upt4		(polar Upt4 UAng XMlt)
				MinX		(car UEpt)
				MinY		(cadr UEpt)
				MaxX		(car UEpt)
				MaxY		(cadr UEpt)
		)
	)
	(command "_.Zoom" "P")
	(if EdsLocal
		(progn
			(if MinX (mapcar (quote (lambda (x) (if (< (car x) MinX) (setq MinX (car x))))) (list Upt1 Upt2 Upt4 Upt3)))
			(if MinY (mapcar (quote (lambda (x) (if (< (cadr x) MinY) (setq MinY (cadr x))))) (list Upt1 Upt2 Upt4 Upt3)))
			(if MaxX (mapcar (quote (lambda (x) (if (> (car x) MaxX) (setq MaxX (car x))))) (list Upt1 Upt2 Upt4 Upt3)))
			(if MaxY (mapcar (quote (lambda (x) (if (> (cadr x) MaxY) (setq MaxY (cadr x))))) (list Upt1 Upt2 Upt4 Upt3)))
			(if (and Upt1 Upt2 Upt3 Upt4)
				(setq	Bubba	(grdraw Upt1 Upt2 -1 1)
						Bubba	(grdraw Upt2 Upt4 -1 1)
						Bubba	(grdraw Upt3 Upt4 -1 1)
						Bubba	(grdraw Upt3 Upt1 -1 1)
				)
			)
		)
	)
	(list UIEnamLst USpt UEpt (list Upt1 Upt2 Upt4 Upt3))
)

(defun ChkCktAtPnt ( EEpt EkVL EFdr /	PBox		;Look to see if circuit has the same layer as the switch.............................
								JumpOut ISckt Cset CCnt NoMatch
								CNam ISNckt HndEptCkt LayEptOne )
	(setq	PBox		1.0
			JumpOut	2.0
			ISckt	T
	)
	(while	(and	(not	(setq	Cset	(ssget	"C"
										(list	(- (car EEpt) PBox)
												(- (cadr EEpt) PBox)
										)
										(list	(+ (car EEpt) PBox)
												(+ (cadr EEpt) PBox)
										)
										(list	(cons 0 "POLYLINE")
												(cons 8 (strcat "????CK-#" EkVL "*"))
										)
								)
					)
				)
				(< PBox 25.0)
			)
		(setq	PBox	(+ PBox JumpOut))
	)
	(if Cset
		(progn
			(setq	CCnt		0
					NoMatch	T
			)
			(while (and (setq CNam (ssname Cset CCnt)) NoMatch)
			 	(if (= (substr (cdr (assoc 8 (entget CNam))) 1 3) EFdr)
					(setq	ISckt	T
							HndEptCkt	(cdr (assoc 5 (entget CNam)))
							LayEptOne	(cdr (assoc 8 (entget CNam)))
							NoMatch	nil
					)
					(setq	ISckt	nil)
				)
				(setq	CCnt	(1+ CCnt))
			)
		)
		(setq	ISckt	nil)
	)
	(setq	Cset		nil
			Bubba	(gc)
	)
	(if (not ISckt)
		(progn
			(setq	PBox		1.0
					JumpOut	2.0
					ISNckt	T
			)
			(while	(and	(not	(setq	Cset	(ssget	"C"
												(list	(- (car EEpt) PBox)
														(- (cadr EEpt) PBox)
												)
												(list	(+ (car EEpt) PBox)
														(+ (cadr EEpt) PBox)
												)
												(list	(cons 0 "POLYLINE")
														(cons 8 (strcat "????CK-*"))
												)
										)
							)
						)
						(< PBox 25.0)
					)
				(setq	PBox	(+ PBox JumpOut))
			)
			(if Cset
				(progn
					(setq	CCnt		0
							NoMatch	T
					)
					(while (and (setq CNam (ssname Cset CCnt)) NoMatch)
						(setq	ISNckt	T
								HndEptCkt	(cdr (assoc 5 (entget CNam)))
								LayEptOne	(cdr (assoc 8 (entget CNam)))
								NoMatch	nil
						)
						(setq	CCnt	(1+ CCnt))
					)
				)
				(setq	ISNckt	nil)
			)
			(setq	Cset		nil
					Bubba	(gc)
			)
		)
	)
	(list	(if ISckt "Y" "N")
			(if ISNckt "Y" "N")
			(if HndEptCkt HndEptCkt "")
			(if LayEptOne LayEptOne "")
	)
)

(defun ChkCktMtchPnt ( EEpt Enam /	PBox		;Look to see if circuit has the same layer as the switch.............................
								JumpOut ISckt Cset CCnt NoMatch
								CNam ISNckt HndEptCkt LayEptOne )
	(setq	PBox		1.0
			JumpOut	2.0
			ISckt	T
	)
	(if Enam
		(setq	EFdr		(cdr (assoc 8 (entget Enam)))
				EFdr		(if (> (strlen EFdr) 3)
							(substr EFdr 1 3)
						)
				EPt1		(GetPLEnd Enam)
				EPt2		(nth 1 EPt1)
				EPt1		(nth 0 EPt1)
		)
		(setq	EFdr		nil)
	)
	(if EFdr
		(if (< (strlen EFdr) 3)
			(while (< (strlen EFdr) 3)
				(setq	EFdr	(strcat EFdr "-"))
			)
		)
	)
	(while	(and	(not	(setq	Cset	(ssget	"C"
										(list	(- (car EEpt) PBox)
												(- (cadr EEpt) PBox)
										)
										(list	(+ (car EEpt) PBox)
												(+ (cadr EEpt) PBox)
										)
										(list	(cons 0 "POLYLINE")
												(cons 8 "????CK-###*")
										)
								)
					)
				)
				(< PBox 5.0)
			)
		(setq	PBox	(+ PBox JumpOut))
	)
	(if (and Enam Cset)
		(if	(and	(= (sslength Cset) 1)
				(ssmemb Enam Cset)
			)
			(setq	Cset		nil
					Bubba	(gc)
			)
			(if	(and	(> (sslength Cset) 1)
					(ssmemb Enam Cset)
				)
				(setq	Cset		(ssdel Enam Cset))
			)
		)
	)
	(if Cset
		(progn
			(setq	CCnt		0
					NoMatch	T
			)
			(while (and (setq CNam (ssname Cset CCnt)) NoMatch)
			 	(if (= (substr (cdr (assoc 8 (entget CNam))) 1 3) EFdr)
					(setq	ISckt	T
							HndEptCkt	(cdr (assoc 5 (entget CNam)))
							LayEptOne	(cdr (assoc 8 (entget CNam)))
							NoMatch	nil
							CPt1		(GetPLEnd Cnam)
							CPt2		(nth 1 CPt1)
							CPt1		(nth 0 CPt1)
					)
					(setq	ISckt	nil)
				)
				(setq	CCnt	(1+ CCnt))
			)
		)
		(setq	ISckt	nil)
	)
	(setq	Cset		nil
			Bubba	(gc)
	)
	(if (not ISckt)
		(progn
			(setq	PBox		1.0
					JumpOut	2.0
					ISNckt	T
			)
			(while	(and	(not	(setq	Cset	(ssget	"C"
												(list	(- (car EEpt) PBox)
														(- (cadr EEpt) PBox)
												)
												(list	(+ (car EEpt) PBox)
														(+ (cadr EEpt) PBox)
												)
												(list	(cons 0 "POLYLINE"))
										)
							)
						)
						(< PBox 5.0)
					)
				(setq	PBox	(+ PBox JumpOut))
			)
			(if (and Enam Cset)
				(if	(and	(= (sslength Cset) 1)
						(ssmemb Enam Cset)
					)
					(setq	Cset		nil
							Bubba	(gc)
					)
					(if	(and	(> (sslength Cset) 1)
							(ssmemb Enam Cset)
						)
						(setq	Cset		(ssdel Enam Cset))
					)
				)
			)
			(if Cset
				(progn
					(setq	CCnt		0
							NoMatch	T
					)
					(while (and (setq CNam (ssname Cset CCnt)) NoMatch)
						(setq	ISNckt	T
								HndEptCkt	(cdr (assoc 5 (entget CNam)))
								LayEptOne	(cdr (assoc 8 (entget CNam)))
								NoMatch	nil
								SPt1		(GetPLEnd Cnam)
								SPt2		(nth 1 SPt1)
								SPt1		(nth 0 SPt1)
						)
						(setq	CCnt	(1+ CCnt))
					)
				)
				(setq	ISNckt	nil)
			)
			(setq	Cset		nil
					Bubba	(gc)
			)
		)
	)
	(if ISckt
		(if (and EPt1 EPt2 CPt1 CPt2)
			(if	(or	(< (distance EPt1 CPt1) 1.0)
					(< (distance EPt1 CPt2) 1.0)
					(< (distance EPt2 CPt1) 1.0)
					(< (distance EPt2 CPt2) 1.0)
				)
				(setq	IsTouch	T)
				(setq	IsTouch	nil)
			)
			(setq	IsTouch	nil)
		)
		(if ISNckt
			(if (and EPt1 EPt2 SPt1 SPt2)
				(if	(or	(< (distance EPt1 SPt1) 1.0)
						(< (distance EPt1 SPt2) 1.0)
						(< (distance EPt2 SPt1) 1.0)
						(< (distance EPt2 SPt2) 1.0)
					)
					(setq	IsTouch	T)
					(setq	IsTouch	nil)
				)
				(setq	IsTouch	nil)
			)
			(setq	IsTouch	nil)
		)
	)
	(list	(if ISckt "Y" "N")
			(if ISNckt "Y" "N")
			(if HndEptCkt HndEptCkt "")
			(if LayEptOne LayEptOne "")
			(if IsTouch "Y" "N")
	)
)
(defun C:Bug ( / )							; Toggles DeBugging Mode
; Function: Toggle deBugging by changing status of 'Bug' variable
	(if (setq Bug (not Bug))   ;--toggle <Bug> global var
		(progn
			(princ "\nDeBug Mode is now ENABLED.")
			(setq	*error*		nil)
		)
		(progn
			(princ "\nDeBug Mode is now DISABLED.")
			(setq	*error*		R:err)
		)
	)
)

(defun R:err ( msg / )						; Error Handler
;****************************************************************************
;Function:  S:err
;Description:  Displays an error message and resets the system variables
;              back to the orignal setting, if the user cancels the program
;Arguments:  msg
;Globals:    md1, md2
;Revised:
;****************************************************************************
	(setq	ErrEds	(getvar "ERRNO"))
	(cond	((= lastcmd "BREAK")
				(grtext)
				(DELLOCKS UNLCK)
				(setq	UNLCK	nil)
				(setlim PanLst)
				(command "_.LAYER" "LT" "DASHED" "????CK-1*,????CK-2*,????CK-3*" "LT" "HIDDEN" "????CK-4*,????CK-5*,????CK-6*" "")
				(command "_.REGENALL")
				(princ "Error: ")
				(princ msg)
				(command "_.ZOOM" "C" IPT SF)
				(cir IPT 6)
				(princ "Break problem...")
				(princ)
			)
			(T
				(if (and ErrEds Err_Lst)
					(if (assoc ErrEds Err_Lst)
						(setq	Blammo	(strcat	"\nError Code:"
												(itoa ErrEds)
												" Value:"
												(cdr (assoc ErrEds Err_Lst))
												"\n"
										)
						)
						(setq	Blammo	"\n")
					)
					(setq	Blammo	"\n")
				)
				(if (= ErrEds 0)
					(if RWav
						(if SndPick02
							(RWav SndPick02)
							(RWav 28)
						)
					)
					(if RWav
						(if SndPick02
							(RWav SndPick02)
							(RWav 28)
						)
					)
				)
				(if (and AppNam AppMode)
					(SetLin AppNam AppMode)
				)
				(princ	(strcat	"\n>> DivMap - "
								AppNam
								" Error: "
								msg
								" <<===="
								Blammo
						)
				)
			)
	)
	(cond
		((= (substr (getvar "ACADVER") 1 2) "15")
			(princ "\nEdsUp fixes settings for Acad 2000 Products...\n")
			(setvar "ATTMODE" 1)
			(setvar "BLIPMODE" 1)
			(setvar "CHAMMODE" 0)
			(setvar "DRAGMODE" 2)
			(setvar "EDGEMODE" 0)
			(setvar "EXPLMODE" 1)
			(setvar "FILLMODE" 1)
			(if (> (getvar "GRIDMODE") 0) (setvar "GRIDMODE" 0))
			(setvar "LOGFILEMODE" 0)
			(setvar "ISAVEPERCENT" 0)
			(setvar "MAXSORT" 3500)
			(setvar "MBUTTONPAN" 0)
			(if (> (getvar "ORTHOMODE") 0) (setvar "ORTHOMODE" 0))
			(if (> (getvar "OSMODE") 0) (setvar "OSMODE" 0))
			(if (/= (getvar "OSNAPCOORD") 1) (setvar "OSNAPCOORD" 1))
			(setvar "PDMODE" 0)
			(setvar "PLOTROTMODE" 2)
			(setvar "POLARMODE" 8)
			(setvar "PROJMODE" 1)
			(setvar "QTEXTMODE" 0)
			(if (/= (getvar "REGENMODE") 1) (setvar "REGENMODE" 1))
			(if (> (getvar "SNAPMODE") 0) (setvar "SNAPMODE" 0))
			(setvar "TABMODE" 0)
			(setvar "TILEMODE" 1)
			(setvar "TRIMMODE" 1)
			(setvar "UNITMODE" 0)
		)
		((= (substr (getvar "ACADVER") 1 2) "14")
			(princ "\nEdsUp fixes settings for Acad 14 Products...\n")
			(if (/= (getvar "ATTREQ") 1)		(setvar "ATTREQ" 1))
			(if (/= (getvar "APERTURE") 10)	(setvar "APERTURE" 10))
			(if (/= (getvar "BLIPMODE") 0)	(setvar "BLIPMODE" 0))
			(if (/= (getvar "CMDECHO") 0)		(setvar "CMDECHO" 0))
			(if (/= (getvar "CMDDIA") 1)		(setvar "CMDDIA" 1))
			(if (/= (getvar "EXPERT") 1)		(setvar "EXPERT" 1))
			(if (/= (getvar "FILEDIA") 1)		(setvar "FILEDIA" 1))
			(if (>  (getvar "GRIDMODE") 0)	(setvar "GRIDMODE" 0))
			(if (/= (getvar "GRIPS") 1)		(setvar "GRIPS" 1))
			(if (/= (getvar "HIGHLIGHT") 1)	(setvar "HIGHLIGHT" 1))
			(if (/= (getvar "ISAVEPERCENT") 0)	(setvar "ISAVEPERCENT" 0))
			(if	(not	(or	(equal (getvar "LTSCALE")  250.0 1.0)
						(equal (getvar "LTSCALE")  500.0 1.0)
						(equal (getvar "LTSCALE") 1000.0 1.0)
						(equal (getvar "LTSCALE") 2000.0 1.0)
					)
				)
				(setq	Bubba	(setvar "LTSCALE" 1000.0)
						sf		304.8
						sff		1000
				)
			)
			(if (/= (getvar "MENUECHO") 1)	(setvar "MENUECHO" 1))
			(if (>  (getvar "ORTHOMODE") 0)	(setvar "ORTHOMODE" 0))
			(if (>  (getvar "OSMODE") 0)		(setvar "OSMODE" 0))
			(if (/= (getvar "PLINETYPE") 0)	(setvar "PLINETYPE" 0))
			(if (/= (getvar "REGENMODE") 1)	(setvar "REGENMODE" 1))
			(if (/= (getvar "SAVETIME") 0)	(setvar "SAVETIME" 0))
			(if (>  (getvar "SNAPMODE") 0)	(setvar "SNAPMODE" 0))
			(if (/= (getvar "UCSICON") 0)		(setvar "UCSICON" 0))
			(command "Viewres" "y" "8000")
		)
	)
	(if MyPick
		(setvar "PICKBOX" MyPick)
		(setvar "PICKBOX" 5)
	)
	(princ)
)

(setq	olderr	*error*
		*error*	R:err
)

(setq	LodVer	"2.5.3y")
