(if AppNam								; Code Version Indicator {989 Lines of Code}
	(princ (strcat "\n" AppNam " EditSym Loading."))
	(princ "\nAdds EditSym Loading.")
)

(defun Do_Rev ( /	ent elist sym at_cnt scl ipt	; Routines to update a symbol in an existing drawing
				err )
; Function:  force AutoCAD to reread a block definition from disk
	(if Bug (princ "do_rev routine"))
;--User selects a symbol of the type to be updated--------------------------
	(setq	ent		(car (entsel "\n \nSelect a symbol type to update: "))
			elist	(entget ent)
	)
	(while (/= (cdr (assoc 0 elist)) "INSERT")
		(princ "\n!! Must select a symbol...Please retry")
		(setq	ent		(car (entsel "\n\nSelect a symbol type to update: "))
				elist	(entget ent)
		)
	)
;--Get the symbol name--------------------
	(setq	sym	(cdr (assoc 2 elist)))
;--Make sure symbol dwg is available-
	(if (setq sym (qualif sym _PATH-SYM))
		(progn
			(alert	(strcat	"\n\nCaution!\nThis will alter all existing occurences of symbol "
							sym
					)
			)
			(initget 1 "Yes No")
			(if (= (getkword "\nDo you wish to proceed? [Y/N] ") "Yes")
				(progn
					(command	"_.LAYER" "T" "0" "S" "0" "")
;--If "attributes follow" flag is set------
					(if (assoc 66 elist)
						(if (/= 0 (cdr (assoc 66 elist)))
							(progn
;--Count how many attributes
								(setq	at_cnt	(count_attr ent)
;--Get insert scale multiplier
										scl		(cdr (assoc 41 elist))
;--Get insertion point
										ipt		(cdr (assoc 10 elist))
								)
;--The following section builds a different "INSERT" command
;  for each possible number of attributes.  If number of
;  attributes in new symbol differs from number in old symbol,
;  program will probably CRASH!
;--This insert forces AutoCAD to reread the symbol .DWG file.
;  The routine also reads the attribute height of the new symbol
								(cond
									((= at_cnt 1)
										(command	"INSERT"	(strcat sym "=" _PATH-SYM sym)
						                					ipt
						                					scl
														""
														""
														"X"
										)
									)
									((= at_cnt 2)
										(command	"INSERT"	(strcat sym "=" _PATH-SYM sym)
						                					ipt
						                					scl
														""
														""
														"X"
														"X"
										)
									)
									((= at_cnt 3)
										(command	"INSERT"	(strcat sym "=" _PATH-SYM sym)
						                					ipt
						                					scl
														""
														""
														"X"
														"X"
														"X"
										)
									)
									((= at_cnt 4)
										(command	"INSERT"	(strcat sym "=" _PATH-SYM sym)
						                					ipt
						                					scl
														""
														""
														"X"
														"X"
														"X"
														"X"
										)
									)
									((= at_cnt 5)
										(command	"INSERT"	(strcat sym "=" _PATH-SYM sym)
						                					ipt
						                					scl
														""
														""
														"X"
														"X"
														"X"
														"X"
														"X"
										)
									)
									((= at_cnt 6)
										(command	"INSERT"	(strcat sym "=" _PATH-SYM sym)
						                					ipt
						                					scl
														""
														""
														"X"
														"X"
														"X"
														"X"
														"X"
														"X"
										)
									)
									((= at_cnt 7)
										(command	"INSERT"	(strcat sym "=" _PATH-SYM sym)
						                					ipt
						                					scl
														""
														""
														"X"
														"X"
														"X"
														"X"
														"X"
														"X"
														"X"
										)
									)
									((= at_cnt 8)
										(command	"INSERT"	(strcat sym "=" _PATH-SYM sym)
						                					ipt
						                					scl
														""
														""
														"X"
														"X"
														"X"
														"X"
														"X"
														"X"
														"X"
														"X"
										)
									)
									((= at_cnt 9)
										(command	"INSERT"	(strcat sym "=" _PATH-SYM sym)
						                					ipt
						                					scl
														""
														""
														"X"
														"X"
														"X"
														"X"
														"X"
														"X"
														"X"
														"X"
														"X"
										)
									)
									(T
										(setq err T)
										(alert (strcat "***" AppNam " Error***\nREVSYM cannot convert this symbol!"))
										(princ (strcat "\n(number of attributes = " at_cnt ")"))
									)
								)
;--Fix the existing attributes' heights
								(if (not err)
									(fixatt)
								)
							)
						)
;--If no attributes, symbol update is much simpler--------------
						(command "INSERT" (strcat sym "=" _PATH-SYM sym) ^C)
					)
				)
			)
		)
		(alert (strcat "***" AppNam " Error***\nUnable to find symbol " sym "!"))
	)
)

(defun Qualif ( fn path /	fname slen strpos )	; Qualify a drawing filename and find if it exists
; Function:  Qualify a drawing filename and determine if it exists in 'path'
;            Returns the filename if it finds the file, nil otherwise
	(if Bug (princ "Qualif routine"))
	(setq	fname	""
			slen		(strlen fn)
			strpos	1
	)
;--Strip off file extension if one was entered-----------
	(while	(and	(<= strpos slen)
				(/= "." (setq char (substr fn strpos 1)))
			)
		(setq	fname	(strcat fname char)
				strpos	(1+ strpos)
		)
	)
	(setq	fname	(strcase fname))
	(if (findfile (strcat path fname ".DWG"))
		fname
	)
)

(defun FixAtt ( /	newblk subent loop att_ht	; Globally Fix the attributes of all block instances
				count blkset blk b_scl subblk sublst new_ht )
; Function:  Fix the attribute parameters of all instances of the block
;            just redefined  (Text Height, Style, and Oblique Angle)
	(if Bug (princ "\nFixatt routine"))
;--Grab the new Insert just created
	(setq	newblk	(ssname (ssget "L") 0)
			subent	(entnext newblk)
	)
;--Find an attribute in new Insert
	(while (and loop subent)
		(if (= "ATTRIB" (cdr (assoc 0 (entget subent))))
			(setq	loop		nil)
			(setq	subent	(entnext subent))
		)
	)
	(if subent
		(setq	sublst	(entget subent)
				att_ht	(cdr (assoc 40 sublst))
				att_st	(cdr (assoc  7 sublst))
				att_ob	(cdr (assoc 51 sublst))
		)
	)
;--Erase new Insert now that parameters are stored
	(entdel newblk)
;--Build a selection set of chosen type Inserts---------------------------
	(if (setq blkset (ssget "X" (list (cons 2 sym))))
		(progn
			(setq	count	0)
;--Step thru each symbol in set
			(while (setq blk (ssname blkset count))
;--Get its insert scale
				(setq	b_scl	(cdr (assoc 41 (entget blk))))
				(setq	subblk	(entnext blk)
						sublst	(entget subblk)
				)
;--Step thru sub-entities
				(while (/= (cdr (assoc 0 sublst)) "SEQEND")
;--If find attribute, change its height------------------------------
					(if (= (cdr (assoc 0 sublst)) "ATTRIB")
						(progn
							(setq	new_ht	(* att_ht (/ b_scl scl))
									sublst	(subst	(cons 40 new_ht)
													(assoc 40 sublst)
													sublst
											)
									sublst	(subst	(cons 7 att_st)
													(assoc 7 sublst)
													sublst
											)
									sublst	(subst	(cons 51 att_ob)
													(assoc 51 sublst)
													sublst
											)
							)
							(entmod sublst)
						)
					)
					(setq	subblk	(entnext subblk)
							sublst	(entget subblk)
					)
				)
				(entupd blk)
				(setq	count	(1+ count))
			)
		)
	)
)

(defun Count_Attr ( blk /	subsym ZeroType	; Count the number of attributes in a block
						count )
	(if Bug (princ "\nCount_Attr routine"))
	(setq	subsym	(entnext blk))
	(setq	ZeroType	(cdr (assoc 0 (entget subsym)))
			count	0
	)
	(while (/= ZeroType "SEQEND")
		(if (= ZeroType "ATTRIB")
			(setq	count	(1+ count))
		)
		(setq	subsym	(entnext subsym)
				ZeroType	(cdr (assoc 0 (entget subsym)))
		)
	)
	count
)

(defun DelSym (	Ept	/					; Deletes Symbols/Plines
				Enam ELst Etyp Eipt Erot ELNam EBlkNam EGapLen
				Gap Lngth SymNam Pt1X Pt1Y Pt2X Pt2Y Bubba )
; Function:  To erase an inserted symbol, rejoining the circuit pline
;            at the old location if necessary
	(if Bug (princ "\n{DelSym entered"))
	(if (not EPt)
		(setq	EPt		(entsel "\nSelect the Symbol/Circuit to be erased: "))
	)
	(cond	((and	EPt
					(= (cdr (assoc 0 (entget (car EPt)))) "INSERT")
					(/= (substr (cdr (assoc 8 (entget (car EPt)))) 5 3) "DLG")
					(/= (substr (cdr (assoc 8 (entget (car EPt)))) 1 3) "DLG")
			 )
				(setq	Enam 	(car EPt)
						ELst		(entget Enam)
						Etyp		(cdr (assoc 0 ELst))
						Eipt		(cdr (assoc 10 ELst))
						Erot		(cdr (assoc 50 ELst))
						ELNam	(cdr (assoc 8 ELst))
						EBlkNam	(cdr (assoc 2 ELst))
						EGapLen	(cdr (assoc 41 ELst))
				)
				(command "_.undo" "BE")
				(setq	Bubba	(SymSizN EBlkNam))
				(if Bubba
					(setq	Gap		(nth 0 Bubba)
							Lngth	(nth 1 Bubba)
							SymNam	(nth 2 Bubba)
					)
				)
				(if (member EBlkNam (list "REG" "REGA"))
					(progn
						(if Bug (princ "\nLooking for Arrow to remove..."))
						(setq	PstSet	(ssget "CP" (CP_Lst6 Eipt (* 1.5 EGapLen)) (list (cons 0 "INSERT") (cons 2 "REGARR"))))
						(if PstSet
							(command "_.ERASE" PstSet "")
							(if Bug (princ "\nDidn't find one!"))
						)
					)
				)
				(cond
					((member EBlkNam (list "_FI_T" "_FI_B" "_CC_T" "_CC_B" "CAP"))
						(setq	Pt1X		(car Eipt)
								Pt1Y		(cadr Eipt)
								Pt2X		nil
								Pt2Y		nil
						)
					)
					((= Gap "M")
						(setq	Pt1X		(car Eipt)
								Pt1Y		(cadr Eipt)
								Pt2X		(+ Pt1X (* EGapLen (cos Erot)))
								Pt2Y		(+ Pt1Y (* EGapLen (sin Erot)))
						)
					)
					((= Gap "C")
						(setq	Eipt		(polar Eipt (+ Erot pi) (/ EGapLen 2.0))
								Pt1X		(car Eipt)
								Pt1Y		(cadr Eipt)
								Pt2X		(+ Pt1X (* EGapLen (cos Erot)))
								Pt2Y		(+ Pt1Y (* EGapLen (sin Erot)))
						)
					)
					(T
						(setq	Pt1X		nil)
					)
				)
				(if Gap
					(if (member Gap (list "C" "M"))
						(princ "\nDelSym is Erasing a Switch...")
					)
					(princ "\nDelSym is Erasing a Block...")
				)
				(command "_.ERASE" EPt "")
				(if Pt1X
					(progn
						(if (and Bug Pt1X Pt1Y) (princ (strcat "\nPt1X=" (rtos Pt1X 2 4) ", Pt1Y=" (rtos Pt1Y 2 4))))
						(if (and Bug Pt2X Pt2Y) (princ (strcat "\nPt2X=" (rtos Pt2X 2 4) ", Pt2Y=" (rtos Pt2Y 2 4))))
						(if (or (= Gap "M") (= Gap "C") (member EBlkNam (list "_FI_T" "_FI_B" "_CC_T" "_CC_B" "CAP")))
							(FixPlinN (list Pt1X Pt1Y Pt2X Pt2Y) ELNam Gap)
						)
					)
				)
				(command "_.undo" "END")
			)
			((and	(wcmatch (cdr (assoc 0 (entget (car EPt)))) "*POLYLINE")
					(= (substr (cdr (assoc 8 (entget (car EPt)))) 6 2) "K-")
			 )
				(princ "\nDelSym is Erasing a Circuit...")
				(command "_.ERASE" EPt "")
			)
			((and	(wcmatch (cdr (assoc 0 (entget (car EPt)))) "*POLYLINE")
					(= (substr (cdr (assoc 8 (entget (car EPt)))) 5 2) "FL")
			 )
				(princ "\nDelSym is Erasing a Fill Line...")
				(command "_.ERASE" EPt "")
			)
			(T
				(princ "\n\nObject selected is not a Symbol or Circuit, please retry...")
			)
	)
	(if Bug (princ "\nDelSymN exited}\n"))
)

(defun FixPlinN ( PLst LName Gap /	A1 A2 A3	; Delete the old fill line and join plines back
								A4 L1 L2 P1 P2 P3 P4 EndsA EndsB EWid NLin NEnt AE BE VCen VSiz
								Pt1X Pt1Y Pt2X Pt2Y PCen FLay PLay FlSet PlSet PlSetA PlSetB Fuzz )
								; Pta Ptb OLVrt NewPout NewP2Vrt TckA TckB
; Function: Delete the old fill line and join polylines back together
;           where a symbol has been removed if both lines match
	(if Bug (princ "\n{FixPlinN entered"))
	(setq	Pt1X		(nth 0 PLst)
			Pt1Y		(nth 1 PLst)
			Pt2X		(nth 2 PLst)
			Pt2Y		(nth 3 PLst)
			TckA		nil
			TckB		nil
			FLay		(strcat	(substr LName 1 4)
							"FL-"
							(substr LName 8)
					)
			PLay		(strcat	(substr LName 1 4)
							"CK-"
							(substr LName 8)
					)
			VCen		(getvar "VIEWCTR")
			VSiz		(getvar "VIEWSIZE")
;			Fuzz		1.0
	)
	(if Pt2X
		(setq	PCen		(list	(+ Pt1X (/ (- Pt2X Pt1X) 2.0))	; Center of Box
								(+ Pt1Y (/ (- Pt2Y Pt1Y) 2.0))
						)
				PtA		(list Pt1X Pt1Y)
				PtB		(list Pt2X Pt2Y)
				L1		(distance PtA PtB)						; Length of Symbol
				L2		(* (nth 0 Lst_Ph_W) SF)					; (Greatest) Width of FL
				Fuzz		L2
		)
		(setq	PCen		(list	Pt1X Pt1Y)					; Center of Insert
				PtA		(list Pt1X Pt1Y)
				L2		(* (nth 0 Lst_Ph_W) SF)					; (Greatest) Width of FL
				Fuzz		L2
		)
	)
	(if (and Bug PLay) (princ (strcat "\nFixPlinN PLay=" PLay)))
	(if Pt2X
		(command "_.Zoom" "C" PCen (* L1 2.0))
		(command "_.Zoom" "C" PCen (* L2 2.0))
	)
	(if (LayChk FLay)
		(command "_.Layer" "T" FLay "On" FLay "U" FLay "T" PLay "On" PLay "U" PLay "S" PLay "")
		(command "_.Layer" "T" PLay "On" PLay "U" PLay "S" PLay "")
	)
;----Delete Fill Line
	(if Pt2X
		(setq	FlSet	(ssget "WP" (CP_Lst2 PtA PtB L2) (list (cons 8 "????FL*"))))
	)
	(if FlSet
		(progn
			(command "_.Erase" FlSet "")
			(if Bug (princ "\nFixPlinN erased a Fill Line"))
		)
		(if Pt2X
			(alert (strcat AppNam " **Caution**\nFill Line not erased/found!"))
		)
	)
;----Find Circuit Plines
	(if Pt2X
		(setq	PlSet	(ssget "CP" (CP_Lst2 PtA PtB L2) (list (cons 0 "POLYLINE") (cons 8 PLay) (cons -4 ">") (cons 39 0.5))))
		(setq	PlSet	(ssget "CP" (CP_Lst6 PtA L2) (list (cons 0 "POLYLINE") (cons 8 PLay) (cons -4 ">") (cons 39 0.5))))
	)
;----If Two, Join Them
	(if PlSet
		(cond
			((= (sslength PlSet) 2)
				(setq	EndsA	(GetPLEnd (ssname PlSet 0))
						EndsB	(GetPLEnd (ssname PlSet 1))
						TckA		(cdr (assoc 39 (entget (ssname PlSet 0))))
						TckB		(cdr (assoc 39 (entget (ssname PlSet 1))))
						EWid		(cdr (assoc 40 (entget (entnext (ssname PlSet 0)))))
				)
				(if Bug (princ (strcat "\nFixPlinN found 2 Plines")))
			)
			((= (sslength PlSet) 1)
				(setq	EndsA	(GetPLEnd (ssname PlSet 0))
						TckA		(cdr (assoc 39 (entget (ssname PlSet 0))))
						EWid		(cdr (assoc 40 (entget (entnext (ssname PlSet 0)))))
				)
				(if Bug (princ (strcat "\nFixPlinN found 1 Plines")))
			)
			((> (sslength PlSet) 2)
				(if Bug (princ (strcat "\nFixPlinN found X=" (itoa (sslength PlSet)) " Plines")))
				(if PtA
					(setq	PlSetA	(ssget "CP" (CP_Lst6 PtA L2) (list (cons 0 "POLYLINE") (cons 8 PLay) (cons -4 ">") (cons 39 0.5))))
				)
				(if PtB
					(setq	PlSetB	(ssget "CP" (CP_Lst6 PtB L2) (list (cons 0 "POLYLINE") (cons 8 PLay) (cons -4 ">") (cons 39 0.5))))
				)
				(if (and PlSetA (= (sslength PlSetA) 1))
					(setq	EndsA	(GetPLEnd (ssname PlSetA 0))
							TckA		(cdr (assoc 39 (entget (ssname PlSetA 0))))
							EWid		(cdr (assoc 40 (entget (entnext (ssname PlSetA 0)))))
							PlSet	PlSetA
					)
				)
				(if (and PlSetB (= (sslength PlSetB) 1))
					(if EndsA
						(setq	EndsB	(GetPLEnd (ssname PlSetB 0))
								TckB		(cdr (assoc 39 (entget (ssname PlSetB 0))))
								PlSet	nil
								PlSet	(ssadd)
								PlSet	(ssadd (ssname PlSetA 0) PlSet)
								PlSet	(ssadd (ssname PlSetB 0) PlSet)
						)
						(setq	EndsA	(GetPLEnd (ssname PlSetB 0))
								TckA		(cdr (assoc 39 (entget (ssname PlSetB 0))))
								EWid		(cdr (assoc 40 (entget (entnext (ssname PlSetB 0)))))
								PlSet	PlSetB
						)
					)
				)
			)
		)
		(if Bug (princ "\nNo Plines found"))
	)
	(if (and EndsA EndsB)
		(if (and (nth 2 EndsA) (nth 2 EndsB))
			(if (equal TckA TckB 0.1)
				(setq	EED_OK	(EED_LstCmp (nth 2 EndsA) (nth 2 EndsB)))
				(setq	EED_OK	nil
						Bubba	(if Bug (princ "\nNot TckA = TckB!\n"))
				)
			)
			(setq	EED_OK	T
					Bubba	(if Bug (princ "\nNo EED groups to compare!"))
			)
		)
		(if TckA
			(setq	EED_OK	T
					Bubba	(if Bug (princ "\nNot both ends found to compare!"))
			)
			(setq	EED_OK	nil
					Bubba	(if Bug (princ "\nNo TckA!\nNot both ends found to compare!"))
			)
		)
	)
	(if Pt2X
		(if EndsA
			(cond
				((equal (nth 0 EndsA) (list Pt1X Pt1Y 0.0) Fuzz)
					(setq	EndsA	(nth 0 EndsA)
							AE		0
							Bubba	(if Bug (princ (strcat "\nAE=0,Fuzz=" (rtos Fuzz 2 4))))
					)
				)
				((equal (nth 1 EndsA) (list Pt1X Pt1Y 0.0) Fuzz)
					(setq	EndsA	(nth 0 EndsA)
							AE		1
							Bubba	(if Bug (princ (strcat "\nAE=1,Fuzz=" (rtos Fuzz 2 4))))
					)
				)
				((equal (nth 0 EndsA) (list Pt2X Pt2Y 0.0) Fuzz)
					(setq	EndsA	(nth 0 EndsA)
							AE		0
							Bubba	(if Bug (princ (strcat "\nAE=0,Fuzz=" (rtos Fuzz 2 4))))
					)
				)
				((equal (nth 1 EndsA) (list Pt2X Pt2Y 0.0) Fuzz)
					(setq	EndsA	(nth 0 EndsA)
							AE		1
							Bubba	(if Bug (princ (strcat "\nAE=1,Fuzz=" (rtos Fuzz 2 4))))
					)
				)
				(T
					(if Bug (princ (strcat "\nEndsA_1=" (rtos (distance (nth 0 EndsA) (list Pt1X Pt1Y 0.0)) 2 4))))
					(if Bug (princ (strcat "\nEndsA_2=" (rtos (distance (nth 1 EndsA) (list Pt1X Pt1Y 0.0)) 2 4))))
					(if Bug (princ (strcat "\nEndsA_3=" (rtos (distance (nth 0 EndsA) (list Pt2X Pt2Y 0.0)) 2 4))))
					(if Bug (princ (strcat "\nEndsA_4=" (rtos (distance (nth 1 EndsA) (list Pt2X Pt2Y 0.0)) 2 4))))
					(setq	EndsA	nil)
				)
			)
			(if Bug (princ "\nNo EndsA"))
		)
		(if EndsA
			(cond
				((equal (nth 0 EndsA) (list Pt1X Pt1Y 0.0) Fuzz)
					(setq	EndsA	(nth 0 EndsA)
							AE		0
							Bubba	(if Bug (princ (strcat "\nAE=0,Fuzz=" (rtos Fuzz 2 4))))
					)
				)
				((equal (nth 1 EndsA) (list Pt1X Pt1Y 0.0) Fuzz)
					(setq	EndsA	(nth 0 EndsA)
							AE		1
							Bubba	(if Bug (princ (strcat "\nAE=1,Fuzz=" (rtos Fuzz 2 4))))
					)
				)
				(T
					(if Bug (princ (strcat "\nEndsA_1=" (rtos (distance (nth 0 EndsA) (list Pt1X Pt1Y 0.0)) 2 4))))
					(if Bug (princ (strcat "\nEndsA_2=" (rtos (distance (nth 1 EndsA) (list Pt1X Pt1Y 0.0)) 2 4))))
					(setq	EndsA	nil)
				)
			)
			(if Bug (princ "\nNo EndsA, No Pt2X"))
		)
	)
	(if Pt2X
		(if EndsB
			(cond
				((equal (nth 0 EndsB) (list Pt1X Pt1Y 0.0) Fuzz)
					(setq	EndsB	(nth 0 EndsB)
							BE		0
							Bubba	(if Bug (princ (strcat "\nBE=0,Fuzz=" (rtos Fuzz 2 4))))
					)
				)
				((equal (nth 1 EndsB) (list Pt1X Pt1Y 0.0) Fuzz)
					(setq	EndsB	(nth 0 EndsB)
							BE		1
							Bubba	(if Bug (princ (strcat "\nBE=1,Fuzz=" (rtos Fuzz 2 4))))
					)
				)
				((equal (nth 0 EndsB) (list Pt2X Pt2Y 0.0) Fuzz)
					(setq	EndsB	(nth 0 EndsB)
							BE		0
							Bubba	(if Bug (princ (strcat "\nBE=0,Fuzz=" (rtos Fuzz 2 4))))
					)
				)
				((equal (nth 1 EndsB) (list Pt2X Pt2Y 0.0) Fuzz)
					(setq	EndsB	(nth 0 EndsB)
							BE		1
							Bubba	(if Bug (princ (strcat "\nBE=1,Fuzz=" (rtos Fuzz 2 4))))
					)
				)
				(T
					(if Bug (princ (strcat "\nEndsB_1=" (rtos (distance (nth 0 EndsB) (list Pt1X Pt1Y 0.0)) 2 4))))
					(if Bug (princ (strcat "\nEndsB_2=" (rtos (distance (nth 1 EndsB) (list Pt1X Pt1Y 0.0)) 2 4))))
					(if Bug (princ (strcat "\nEndsB_3=" (rtos (distance (nth 0 EndsB) (list Pt2X Pt2Y 0.0)) 2 4))))
					(if Bug (princ (strcat "\nEndsB_4=" (rtos (distance (nth 1 EndsB) (list Pt2X Pt2Y 0.0)) 2 4))))
					(setq	EndsB	nil)
				)
			)
			(if Bug (princ "\nNo EndsB"))
		)
		(if EndsB
			(cond
				((equal (nth 0 EndsB) (list Pt1X Pt1Y 0.0) Fuzz)
					(setq	EndsB	(nth 0 EndsB)
							BE		0
							Bubba	(if Bug (princ (strcat "\nBE=0,Fuzz=" (rtos Fuzz 2 4))))
					)
				)
				((equal (nth 1 EndsB) (list Pt1X Pt1Y 0.0) Fuzz)
					(setq	EndsB	(nth 0 EndsB)
							BE		1
							Bubba	(if Bug (princ (strcat "\nBE=1,Fuzz=" (rtos Fuzz 2 4))))
					)
				)
				(T
					(if Bug (princ (strcat "\nEndsB_1=" (rtos (distance (nth 0 EndsB) (list Pt1X Pt1Y 0.0)) 2 4))))
					(if Bug (princ (strcat "\nEndsB_2=" (rtos (distance (nth 1 EndsB) (list Pt1X Pt1Y 0.0)) 2 4))))
					(setq	EndsB	nil)
				)
			)
			(if Bug (princ "\nNo EndsB, No Pt2X"))
		)
	)
	(if (= (strcase (substr PLay 4 1)) "O")
		(if (or TckA TckB)
			(if TckA
				(setq	NWid		(* (* TckA 0.3048) (nth (atoi (substr PLay 8 1)) Lst_Ph_W)))
				(setq	NWid		(* (* TckB 0.3048) (nth (atoi (substr PLay 8 1)) Lst_Ph_W)))
			)
			(setq	NWid		(* (* (float SFF) 0.3048) (nth (atoi (substr PLay 8 1)) Lst_Ph_W)))
		)
		(if (or TckA TckB)
			(if TckA
				(setq	NWid		(* (* TckA 0.3048) (nth 5 Lst_Ph_W)))
				(setq	NWid		(* (* TckB 0.3048) (nth 5 Lst_Ph_W)))
			)
			(setq	NWid		(* (* (float SFF) 0.3048) (nth 5 Lst_Ph_W)))
		)
	)
	(if (and EndsA EndsB EWid)
		(progn
			(cond
				((and (= AE 1) (= BE 0) Pt2X EED_OK)		; --> --> -->
					(if Bug (princ "\nA=1 B=0 EED_OK Pt2X"))
					(setq	NewP1	(ReadOPoly (entget (ssname PlSet 0) (list "*")))
							NewP2	(ReadOPoly (entget (ssname PlSet 1) (list "*")))
							NewPout	(append	(StpVrtLst NewP1 nil)
											(StpVrtLst NewP2 nil)
									)
					)
				)
				((and (= AE 1) (= BE 1) Pt2X EED_OK)		; --> --> <--
					(if Bug (princ "\nA=1 B=1 EED_OK Pt2X"))
					(setq	NewP1	(ReadOPoly (entget (ssname PlSet 0) (list "*")))
							NewP2	(ReadOPoly (entget (ssname PlSet 1) (list "*")))
							NewPout	(append	(StpVrtLst NewP1 nil)
											(StpVrtLst NewP2 T)
									)
					)
				)
				((and (= AE 0) (= BE 1) Pt2X EED_OK)		; <-- --> <--
					(if Bug (princ "\nA=0 B=1 EED_OK Pt2X"))
					(setq	NewP1	(ReadOPoly (entget (ssname PlSet 0) (list "*")))
							NewP2	(ReadOPoly (entget (ssname PlSet 1) (list "*")))
							NewPout	(append	(StpVrtLst NewP1 T)
											(StpVrtLst NewP2 T)
									)
					)
				)
				((and (= AE 0) (= BE 0) Pt2X EED_OK)		; <-- --> -->
					(if Bug (princ "\nA=0 B=0 EED_OK Pt2X"))
					(setq	NewP1	(ReadOPoly (entget (ssname PlSet 0) (list "*")))
							NewP2	(ReadOPoly (entget (ssname PlSet 1) (list "*")))
							NewPout	(append	(StpVrtLst NewP1 T)
											(StpVrtLst NewP2 nil)
									)
					)
				)
				((and (= AE 1) (= BE 0) EED_OK)			; --> --> For Zero-Gap Items
					(if Bug (princ "\nA=1 B=0 EED_OK"))
					(setq	NewP1	(ReadOPoly (entget (ssname PlSet 0) (list "*")))
							NewP2	(ReadOPoly (entget (ssname PlSet 1) (list "*")))
							NewPout	(append	(StpVrtLst NewP1 nil)
											(cdr (StpVrtLst NewP2 nil))
									)
					)
				)
				((and (= AE 0) (= BE 1) EED_OK)			; <-- <-- For Zero-Gap Items
					(if Bug (princ "\nA=0 B=1 EED_OK"))
					(setq	NewP1	(ReadOPoly (entget (ssname PlSet 0) (list "*")))
							NewP2	(ReadOPoly (entget (ssname PlSet 1) (list "*")))
							NewPout	(append	(StpVrtLst NewP1 T)
											(cdr (StpVrtLst NewP2 T))
									)
					)
				)
				((and (= AE 0) (= BE 0) EED_OK)			; <-- --> For Zero-Gap Items
					(if Bug (princ "\nA=0 B=0 EED_OK"))
					(setq	NewP1	(ReadOPoly (entget (ssname PlSet 0) (list "*")))
							NewP2	(ReadOPoly (entget (ssname PlSet 1) (list "*")))
							NewPout	(append	(StpVrtLst NewP1 T)
											(cdr (StpVrtLst NewP2 nil))
									)
					)
				)
				((and (= AE 1) (= BE 1) EED_OK)			; --> <-- For Zero-Gap Items
					(if Bug (princ "\nA=1 B=1 EED_OK"))
					(setq	NewP1	(ReadOPoly (entget (ssname PlSet 0) (list "*")))
							NewP2	(ReadOPoly (entget (ssname PlSet 1) (list "*")))
							NewPout	(append	(StpVrtLst NewP1 nil)
											(cdr (StpVrtLst NewP2 T))
									)
					)
				)
				((and (= AE 1) Pt2X (not EED_Ok))
					(if Bug (princ "\nA=1 Pt2X EED_NotOK"))
					(setq	NewP1	(ReadOPoly (entget (ssname PlSet 0) (list "*")))
							OLVrt	(nth (- (length NewP1) 2) NewP1)
							NewP2Vrt	(if (equal (cdr (assoc 10 OLVrt)) (list Pt2X Pt2Y 0.0) Fuzz)
										(subst	(cons 10 (list Pt1X Pt1Y 0.0))
												(assoc 10 OLVrt)
												OLVrt
										)
										(subst	(cons 10 (list Pt2X Pt2Y 0.0))
												(assoc 10 OLVrt)
												OLVrt
										)
									)
							NewPout	(append	(StpVrtLst NewP1 nil)
											(list NewP2Vrt)
									)
							PlSet	(ssdel (ssname PlSet 1) PlSet)
					)
				)
				((and (= AE 0) Pt2X (not EED_Ok))
					(if Bug (princ "\nA=0 Pt2X EED_NotOK"))
					(setq	NewP1	(ReadOPoly (entget (ssname PlSet 0) (list "*")))
							OLVrt	(nth 1 NewP1)
							NewP2Vrt	(if (equal (cdr (assoc 10 OLVrt)) (list Pt2X Pt2Y 0.0) Fuzz)
										(subst	(cons 10 (list Pt1X Pt1Y 0.0))
												(assoc 10 OLVrt)
												OLVrt
										)
										(subst	(cons 10 (list Pt2X Pt2Y 0.0))
												(assoc 10 OLVrt)
												OLVrt
										)
									)
							NewPout	(append	(list NewP2Vrt)
											(StpVrtLst NewP1 nil)
									)
							PlSet	(ssdel (ssname PlSet 1) PlSet)
					)
				)
				(T
					(if Bug (princ "\nEndsA EndsB EWid, but not handled!"))
					(alert (strcat "***" AppNam " Error**\nFixPlinN Error 1: Re-Join not done!"))
					(exit)
				)
			)
			(if Bug (BugRepOPoly NewPout))
			(setq	NewPout	(VPout NewPout NWid)
					NewPHed	(if (assoc 39 (nth 0 NewP1))
								(subst	(cons 39 TckA)
										(assoc 39 (nth 0 NewP1))
										(nth 0 NewP1)
								)
								(nth 0 NewP1)
							)
					NewLst	(PExtent NewPout)
			)
			(command "_.Zoom" "W" (list (nth 0 NewLst) (nth 1 NewLst)) (list (nth 2 NewLst) (nth 3 NewLst)))
			(command "_.Erase" PlSet "")
			(setq	NewPout	(cons (last NewP1) (reverse NewPout))
					NewPout	(cons NewPHed (reverse NewPout))
			)
			(setq	NewPout	(Weeder NewPout))
			(mapcar (quote entmake) NewPout)
		)
		(cond
			((and (= AE 1) Pt2X)
				(if Bug (princ "\nA=1 Pt2X"))
				(setq	NewP1	(ReadOPoly (entget (ssname PlSet 0) (list "*")))
						OLVrt	(nth (- (length NewP1) 2) NewP1)
						NewP2Vrt	(if (equal (cdr (assoc 10 OLVrt)) (list Pt2X Pt2Y 0.0) Fuzz)
									(subst	(cons 10 (list Pt1X Pt1Y 0.0))
											(assoc 10 OLVrt)
											OLVrt
									)
									(subst	(cons 10 (list Pt2X Pt2Y 0.0))
											(assoc 10 OLVrt)
											OLVrt
									)
								)
						NewPout	(append	(StpVrtLst NewP1 nil)
										(list NewP2Vrt)
								)
						NewPout	(VPout NewPout NWid)
						NewPHed	(if (assoc 39 (nth 0 NewP1))
									(subst	(cons 39 TckA)
											(assoc 39 (nth 0 NewP1))
											(nth 0 NewP1)
									)
									(nth 0 NewP1)
								)
						NewLst	(PExtent NewPout)
				)
				(command "_.Zoom" "W" (list (nth 0 NewLst) (nth 1 NewLst)) (list (nth 2 NewLst) (nth 3 NewLst)))
				(command "_.Erase" PlSet "")
				(setq	NewPout	(cons (last NewP1) (reverse NewPout))
						NewPout	(cons NewPHed (reverse NewPout))
				)
				(setq	NewPout	(Weeder NewPout))
				(mapcar (quote entmake) NewPout)
			)
			((and (= AE 0) Pt2X)
				(if Bug (princ "\nA=0 Pt2X"))
				(setq	NewP1	(ReadOPoly (entget (ssname PlSet 0) (list "*")))
						OLVrt	(nth 1 NewP1)
						NewP2Vrt	(if (equal (cdr (assoc 10 OLVrt)) (list Pt2X Pt2Y 0.0) Fuzz)
									(subst	(cons 10 (list Pt1X Pt1Y 0.0))
											(assoc 10 OLVrt)
											OLVrt
									)
									(subst	(cons 10 (list Pt2X Pt2Y 0.0))
											(assoc 10 OLVrt)
											OLVrt
									)
								)
						NewPout	(append	(list NewP2Vrt)
										(StpVrtLst NewP1 nil)
								)
						NewPout	(VPout NewPout NWid)
						NewPHed	(if (assoc 39 (nth 0 NewP1))
									(subst	(cons 39 TckA)
											(assoc 39 (nth 0 NewP1))
											(nth 0 NewP1)
									)
									(nth 0 NewP1)
								)
						NewLst	(PExtent NewPout)
				)
				(command "_.Zoom" "W" (list (nth 0 NewLst) (nth 1 NewLst)) (list (nth 2 NewLst) (nth 3 NewLst)))
				(command "_.Erase" PlSet "")
				(setq	NewPout	(cons (last NewP1) (reverse NewPout))
						NewPout	(cons NewPHed (reverse NewPout))
				)
				(setq	NewPout	(Weeder NewPout))
				(mapcar (quote entmake) NewPout)
			)
			(Pt2X
				(setq	NWid		(* (* (float SFF) 0.3048) (nth (atoi (substr PLay 8 1)) Lst_Ph_W))
						NewPout	(list	(list	(cons 0 "POLYLINE")
												(cons 8 Play)
												(cons 39 (float SFF))
												(cons 6 "BYLAYER")
												(cons 62 256)
												(cons 66 1)
												(cons 70 0)
										)
										(list	(cons 0 "VERTEX")
												(cons 8 Play)
												(cons 10 PtA)
												(cons 40 NWid)
												(cons 41 NWid)
												(cons 42 0.0)
												(cons 70 0)
												(cons 50 0.0)
										)
										(list	(cons 0 "VERTEX")
												(cons 8 Play)
												(cons 10 PtB)
												(cons 40 NWid)
												(cons 41 NWid)
												(cons 42 0.0)
												(cons 70 0)
												(cons 50 0.0)
										)
										(list	(cons 0 "SEQEND"))
								)
				)
				(mapcar (quote entmake) NewPout)
				(if Bug (princ "\n{Not} EndsA EndsB EWid, handled!"))
				(alert "**Adds Caution**\nCircuit Drawn: Re-Join not done")
			)
			(T
				(if Bug (princ "\n{Not} EndsA EndsB EWid, but not handled!"))
				(alert (strcat "***" AppNam " Error**\nFixPlinN Error 2: Re-Join not done!"))
			)
		)
	)
	(command "_.Zoom" "C" VCen VSiz)
	(if Bug (princ "\nFixPlinN exited}\n"))
)

(defun VPout ( Lst1 NWid /	Lst2 )			; Updates Vertex width in Vertex List
	(foreach	VLst
			Lst1
			(setq	VLst		(subst	(cons 40 NWid)
									(assoc 40 VLst)
									VLst
							)
			)
			(setq	VLst		(subst	(cons 41 NWid)
									(assoc 41 VLst)
									VLst
							)
			)
			(if Lst2
				(setq	Lst2		(cons VLst Lst2))
				(setq	Lst2		(list VLst))
			)
	)
	(reverse Lst2)
)

(defun EED_LstCmp ( Lst1 Lst2 /	Good Cntr )	; Compares EED Lists of Strings for equality
	(setq	Good		T
			Cntr		0
	)
	(if (= (length Lst1) (length Lst2))
		(while (< Cntr (length Lst1))
			(if (/= (nth Cntr Lst1) (nth Cntr Lst2))
				(setq	Good		nil
						Bubba	(if Bug (princ (strcat "\nEED Lists not equal at " (itoa Cntr) " position!")))
				)
			)
			(setq	Cntr		(1+ Cntr))
		)
		(setq	Good		nil
				Bubba	(if Bug (princ "\nEED Lists not equal length!"))
		)
	)
	Good
)

(defun ChgNorm ( TypChg / ssG RetN )			; SS collector that checks Changed
	(setq ssG (ssget))
	(if ssG
		(setq Retn (ChSym TypChg ssG))
	)
	(princ)
)

(setq	LodVer	"2.5.2a")
