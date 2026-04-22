(if AppNam								; Code Version Indicator {851 Lines of Code}
	(princ (strcat "\n" AppNam " Att_Chg Loading."))
	(princ "\nCadet 2.1 Att_Chg Loading.")
)
;;;below - made consistent across six "Att_Chg.lsp" files. (10june14 - karl)
;;;        S:\Workgroups\APC Power Delivery\Division Mapping Test\Common\att_chg.lsp
;;;        S:\Workgroups\APC Power Delivery\Division Mapping Test\TestTransmission\Common\att_chg.lsp
;;;        S:\Workgroups\APC Power Delivery\Division Mapping\Common\att_chg.lsp
;;;        S:\Workgroups\APC Power Delivery-ACC\Transmap\ADDS_TMap\Common\att_chg.lsp
;;;        S:\Workgroups\GPC Real-Time Systems\STAFF\Transmap\ADDS_TMap\Common\att_chg.lsp
;;;        S:\Workgroups\GPC Real-Time Systems\STAFF\Transmap\Division Mapping\Common\att_chg.lsp
;
;subroutines  (listed in order) as of 03june14 - karl
;                  trapAttr (errmsg)
;                  C:Att-M
;                  C:Att-R
;                  C:Att-RM
;                  C:Att-MR
;                  C:LevAtt
;                  C:MLvAtt
;                  C:LvMAtt
;                  Att-NR
;                  Att-MR
;                  Att-NM
;                  FixVertex
;                  AttAct
;                  Att-Up
;                  Att-Chg-Lay
;                  GetAttOrt (AttRPos  MstPos  EList  TList  EListM)
;                  DelCons (INum  Elst)
;                  AttCnv (EntM)                               ;not used in this file "att_chg.lsp" - karl
;
;
(defun trapAttr (errmsg)
	 	(if (not (wcmatch errmsg "Function,cancelled,quit / exit abort,console break"))
			(princ (strcat "\nError: " errmsg " Calling function: " curFunNam "\n"
					" Your last action has been roll back to the previous state.\n"))
 	 	)
		(command "_.UNDO" "_EN")
		(command "_.UNDO" "1")
		(setq *error* temperr)
		(princ)
);end-of-defun
;
;
(defun C:Att-M ( / EntM AttCom )				; CL - Moves attributes
; Name:     Att-M
; Function: calls AttAct to MOVE the attributes as a group
	(if Bug
		(princ "\n{Att-M entered\n")
	)
	(setq curFunNam "C:Att-M")
	(setq temperr *error*)
	(setq *error* trapAttr)
	
	(command "_.UNDO" "_BE")
	(setq	AttCom	"M"
			EntM		(car (Entsel "\n Select symbol: "))
	)
	(AttAct)
	(if Bug
		(princ "\nAtt-M exited}\n")
	)
	(command "_.UNDO" "_EN")
	(setq *error* temperr)
    (print)
);end-of-defun
;
;
(defun C:Att-R ( / EntM AttCom )				; CL - Rotates Attributes
; Name:     Att-R
; Function: calls AttAct to ROTATE the attributes as a group
	(if Bug
		(princ "\n{Att-R entered\n")
	)
	(setq curFunNam "C:Att-R")
	(setq temperr *error*)
	(setq *error* trapAttr)
	
	(command "_.UNDO" "_BE")
	(setq	AttCom	"R"
			EntM		(car (Entsel "\n Select symbol: "))
	)
	(AttAct)
	(if Bug
		(princ "\nAtt-R exited}\n")
	)
	(command "_.UNDO" "_EN")
	(setq *error* temperr)
    (print)
);end-of-defun
;
;
(defun C:Att-RM ( / EntM AttCom)				; calls AttAct to ROTATE and MOVE the attributes as a group
; Function: calls AttAct to ROTATE and MOVE the attributes as a group
	(if Bug
		(princ "\n{Att-RM entered\n")
	)
	(setq curFunNam "C:Att-RM")
	(setq temperr *error*)
	(setq *error* trapAttr)
	
	(command "_.UNDO" "_BE")
	(setq	AttCom	"RM"
			EntM		(car (Entsel "\n Select symbol: "))
	)
	(AttAct)
	(if Bug (princ "Att-RM exited}\n"))
	(command "_.UNDO" "_EN")
	(setq *error* temperr)
    (print)
);end-of-defun
;
;
(defun C:Att-MR ( / EntM AttCom )				; CL - Moves and Rotates Attributes
; Name: Att-MR
; Function: calls AttAct to MOVE and ROTATE the attributes as a group
	(if Bug
		(princ "\n{Att-MR entered\n")
	)
	(setq curFunNam "C:Att-MR")
	(setq temperr *error*)
	(setq *error* trapAttr)
	
	(command "_.UNDO" "_BE")
	(setq	AttCom	"MR"
			EntM		(car (Entsel "\n Select symbol: "))
	)
	(AttAct)
	(if Bug
		(princ "\nAtt-MR exited}\n")
	)
	(command "_.UNDO" "_EN")
	(setq *error* temperr)
    (print)
);end-of-defun
;
;
(defun C:LevAtt ( / EntM AttCom )				; CL - Levels Attributes
; Function: Set angle of a user-selected attribute to ZERO
	(if Bug
		(princ "\n{LevAtt entered\n")
	)
	(setq curFunNam "C:LevAtt")
	(setq temperr *error*)
	(setq *error* trapAttr)
	
	(command "_.UNDO" "_BE")
	(setq	EntM		(car (entsel "\n\nSelect an attribute:"))
			AttCom	"NR"
	)
	(AttAct)
	(if Bug
		(princ "\nLevAtt exited}\n")
	)
	(command "_.UNDO" "_EN")
	(setq *error* temperr)
    (print)
);end-of-defun
;
;
(defun C:MLvAtt ( / EntM AttCom )				; CL - Move and Level Attributes
; Function: Set angle of a user-selected attribute to ZERO and allow it
;           to be MOVED
	(if Bug
		(princ "\n{MLvAtt entered\n")
	)
	(setq curFunNam "C:MLvAtt")
	(setq temperr *error*)
	(setq *error* trapAttr)
	
	(command "_.UNDO" "_BE")
	(setq	EntM		(car (entsel "\n\nSelect an attribute:"))
			AttCom	"NRM"
	)
	(AttAct)
	(if Bug
		(princ "\nMLvAtt exited}\n")
	)
	(command "_.UNDO" "_EN")
	(setq *error* temperr)
    (print)
);end-of-defun
;
;
(defun C:LvMAtt ( / EntM AttCom)				; Set angle of a user-selected attribute to ZERO and allow it
; Function: Set angle of a user-selected attribute to ZERO and allow it
;           to be MOVED
	(if Bug
		(princ "\n{LvMAtt entered\n")
	)
	(setq curFunNam "C:LvMAtt")
	(setq temperr *error*)
	(setq *error* trapAttr)
	
	(command "_.UNDO" "_BE")
	(setq	EntM		(car (entsel "\n\nSelect an attribute:"))
			AttCom	"NRM"
	)
	(AttAct)
	(if Bug (princ "LvMAtt exited}\n"))
	(command "_.UNDO" "_EN")
	(setq *error* temperr)
    (print)
);end-of-defun
;
;
(defun Att-NR ( / EntM AttCom )				; Non-Rotate Attributes
; Function: calls AttAct to ROTATE the ATTRIBUTES horizontally as a group
;           Works with the last entity in the database
	(if Bug
		(princ "\n{Att-NR entered\n")
	)
	(setq	EntM		(entlast)
			AttCom	"NR"
	)
	(AttAct)
	(if Bug
		(princ "\nAtt-NR exited}\n")
	)
    (print)
);end-of-defun
;
;
(defun Att-MR ( / EntM AttCom )				; Moves and Rotates Attributes
; Function: calls AttAct to MOVE and ROTATE the attributes as a group
;           Works with the last entity in the database
	(if Bug
		(princ "\n{Att-MR entered\n")
	)
	(setq	EntM		(entlast)
			AttCom	"MR"
	)
	(AttAct)
	(if Bug
		(princ "\nAtt-MR exited}\n")
	)
    (print)
);end-of-defun
;
;
(defun Att-NM ( / EntM AttCom )				; Moves and Non-Rotates Attributes
; Function: calls AttAct to ROTATE HORZ. and then MOVE the attributes as a group
;           Works with the last entity in the database
	(if Bug
		(princ "\n{Att-NM entered\n")
	)
	(setq	EntM		(entlast)
			AttCom	"NRM"
	)
	(AttAct)
	(if Bug
		(princ "\nAtt-NM exited}\n")
	)
    (print)
);end-of-defun
;
;
(defun FixVertex ( / )
	(setq	EntM		(car (entsel "\n\nSelect an polyline:")))
	(setq	EListM	(entget EntM)
			LayR		(assoc 8 EListM)
			ssV		(ssadd)
			EList	(entget (entnext EntM))
	)
	(while (equal (cdr (assoc 0 EList)) "VERTEX")
		(ssadd (cdr (assoc -1 EList)) ssV)
		(setq	EList	(entget (entnext (cdr (assoc -1 EList)))))
	)
	(setq	ssVLen	(sslength ssV))
	(if (> ssVLen )
		(progn
			(setq	Count	0					
					ssV2		(ssadd)
					NumChr	0
			)
			(while (< Count ssVLen)
				(setq	EList	(entget (ssname ssV Count)))
				(setq Elist (subst LayR (assoc 8 EList) EList))
				(entmod Elist)
				(ssadd (entlast) ssV2)				;   as attributes
				(setq	Count	(1+ Count))
			)
		)
	)
);end-of-defun
;
;
(defun AttAct ( /	NumChr EListM ssA			; Attribute Actions Engine
				ssALen ssT EList LayR AttStyle AttAngDeg AttHgt AttVal AttPt Count
				s_72 s_73 d_72 d_73 AttAlign TmpLst BasePt BlkNam Tmp RotPt
				AngRad AngDeg TblAtt AttBNam AttRPos AttALst AttMst MstPos
				ALayR TList )	; Ed_Lst

				; EList	->	EListM
				; ssA	->	ssALen

; Def. : Rotates (and/or) Moves attributes as a group <by block> according
;          to the global values set in calling routine
; Date : (modified 1-18-89) by GRS and JVG
; Global In : EntM - entity name of selected, or last, entity
;             AttCom - is used to determine what action to take,
;                      can be either "R", "M", "NR", "NRM"       ;also "RM" & "MR" karl
; this code does not handle "align" or "fit" justification              ;karl (to do for future)
	(if Bug
		(princ "\n{AttAct entered\n")
	)
	(if (not EntM)
		(setq	EntM		(car (entsel "\n\nSelect an attribute:")))
	)
	(setq	EListM	(entget EntM)					;---works with EntM set by caller function
			LayR		(assoc 8 EListM)				;---gets layer block defined on
			ssA		(ssadd)						;---build a selection set of the attrs in EntM
			EList	(entget (entnext EntM))			;---starts getting attributes
	)
	(if (not CheckEntity)
		(LodStage2 "Property")
	)
	(if (CheckEntity EListM)
		(if (and (/= Div "AL") (/= Div "GA"))
			(setq	ALayR	(strcat	(substr (cdr LayR) 1 6)
									"D"
									(substr (cdr LayR) 8)
							)
			)
		)
	)
	(while (equal (cdr (assoc 0 EList)) "ATTRIB")
		(ssadd (cdr (assoc -1 EList)) ssA)
		(setq	EList	(entget (entnext (cdr (assoc -1 EList)))))
	)
	(setq	ssALen	(sslength ssA))				;---get no. of items in selection set
	(if (> ssALen 0)
		(progn									;---Build selection set "ssT" containing 
			(setq	Count	0					;---a 'text' copy of the attrs--
					ssT		(ssadd)
					NumChr	0
			)
			(while (< Count ssALen)
				(setq	EList     (entget (ssname ssA Count))
						AttStyle  (cdr (assoc 7 EList))
						AttHgt    (cdr (assoc 40 EList))
						AttAngDeg (/ (* (cdr (assoc 50 EList)) 180.0) pi)
						AttVal    (cdr (assoc 1 EList))
						AttPt     (cdr (assoc 10 EList))
				)
				(if (or (not AttVal) (= AttVal "") (= AttVal " ") (= AttVal "  ") (= AttVal "   "))
					(setq	AttVal	"._.")
				)
				(if (> (strlen AttVal) NumChr)
					(setq	NumChr	(strlen AttVal))
				)
				(setq	d_73		(cdr (assoc 74 EList))	; Note: Attrib code 74=Text code 73
						d_72		(cdr (assoc 72 EList))
						s_73		(cond	((= d_73 1) "B")
										((= d_73 2) "M")
										((= d_73 3) "M")
										(T "")
								)
						s_72		(cond	((= d_72 0) "L")
										((= d_72 1) "C")
										((= d_72 2) "R")
										((= d_72 3) "A")
										((= d_72 4) "M")
										((= d_72 5) "F")
										(T "")
								)
				)
				(if AttJVal
					(setq	AttAlign	AttJVal)
					(setq	AttAlign	(strcat s_73 s_72))
				)
				(if Bug
					(princ (strcat "\nAttAlign = " AttAlign))
				)
				(command "COLOR" "7")
				(if (or (= AttAlign "") (= AttAlign "L"))
					(if (= (cdr (assoc 40 (tblsearch "STYLE" AttStyle))) 0.0)
						(command "TEXT" "S" AttStyle AttPt AttHgt AttAngDeg AttVal)
						(command "TEXT" "S" AttStyle AttPt AttAngDeg AttVal)
					)
					(if (= (cdr (assoc 40 (tblsearch "STYLE" AttStyle))) 0.0)
						(command "TEXT" "S" AttStyle "J" AttAlign (cdr (assoc 11 EList)) AttHgt AttAngDeg AttVal)
						(command "TEXT" "S" AttStyle "J" AttAlign (cdr (assoc 11 EList)) AttAngDeg AttVal)
					)
				)
				(command "COLOR" "BYLAYER")
				(ssadd (entlast) ssT)				;   as attributes
				(setq	Count	(1+ Count))
			);end-of-while
			(setq	d_73		nil
					d_72		nil
					s_73		nil
					s_72		nil
					AttAlign	nil
			)
			(setq	BlkNam	(cdr (assoc 2 EListM)))
			(if (member BlkNam (list "_OCR" "_OCR_BP"))
				(setq	Tmp		1)
				(if (= BlkNam "_OCR_EL")
					(setq	Tmp		3)
					(setq	Tmp		(fix (/ ssALen 2)))
				)
			)
			(if Bug
				(setq	Ed_Lst	TmpLst)
			)
			(setq	TmpLst	(entget (ssname ssA Tmp)))
			(if (/= (cadr (assoc 11 TmpLst)) 0.0)
				(setq	BasePt	(cdr (assoc 11 TmpLst)))
				(setq	BasePt	(polar	(list	(cadr (assoc 10 TmpLst))
												(caddr (assoc 10 TmpLst))
										)
										(cdr (assoc 50 TmpLst))
										(* AttHgt NumChr 0.5)
								)
				)
			)
			(setq	BlkNam		nil
					Tmp			nil
					TmpLst		nil
			)	
			(if (or (= AttCom "M") (= AttCom "MR") (= AttCom "RM"))		;---Move and/or rotate set "ssT"----
				(progn
					(if (= AttCom "RM")
						(progn
							(princ "\nSelect rotation for attribute(s)...")
							(command "_.ROTATE" ssT "" BasePt pause)
;							(setq BasePt (getvar "LASTPOINT"))
						)
					)
					(princ "\nPick location for text:\n")
					(command "_.MOVE" ssT "" BasePt pause)
					(if (= AttCom "MR")
						(progn
							(setq RotPt (getvar "LASTPOINT"))
							(princ "\nSelect rotation for attribute(s)...")
							(command "_.ROTATE" ssT "" RotPt pause)
						)
					)
				)
				(if (equal AttCom "R")
					(command "_.ROTATE" ssT "" BasePt pause)
					(progn
                        (setq ItemCounter 0)                                                       ;added 04june14 karl
                        (while (< ItemCounter (sslength ssT))                                      ;
                            (setq Item (ssname ssT ItemCounter))                                   ;
                            (setq AngRad (cdr (assoc 50 (entget Item))))                           ;
                            (setq AngDeg (cvunit AngRad "radians"  "degrees"))                     ;
                            (command "rotate" Item "" BasePt "r" AngDeg "0.0");r=reference angle   ;
                            (setq ItemCounter (1+ ItemCounter))                                    ;
                        )                                                                          ;
						(if (equal AttCom "NRM")
							(if AttNPnt
								(command "MOVE" ssT "" BasePt AttNPnt)
								(progn
									(princ "\nPick location for text:\n")
									(command "MOVE" ssT "" BasePt pause)
								)
							)
						)
					);end-of-progn
				);end-of-if
			);end-of-if
;---Build Relative positioning list from changed text-------
			(setq	TblAtt	(tblsearch "BLOCK" (cdr (assoc 2 EListM)))
					AttBNam	(entnext (cdr (assoc -2 TblAtt)))
					AttRPos	nil
			)
			(if AttBNam
				(while AttBNam
					(setq	AttALst	(entget AttBNam)
							AttBNam	(entnext AttBNam)
					)
					(if AttALst
						(if (= (cdr (assoc 0 AttALst)) "ATTDEF")
							(if AttRPos
								(setq	AttRPos	(append	AttRPos
														(list
															(list	(cdr (assoc  2 AttALst))
																	(cdr (assoc 11 AttALst))
																	(cdr (assoc 50 AttALst))
															)
														)
												)
								)
								(setq	AttRPos (list
													(list
														(cdr (assoc  2 AttALst))
														(cdr (assoc 11 AttALst))
														(cdr (assoc 50 AttALst))
													)
												)
								)
							)
						)
					)
				)
			)
;---Rebuild set "ssA" with new coords and Angle from set "ssT"-------
			(setq	Count	0
					;AttMst	(caar AttRPos)      ;commented out 03june14 karl
					MstPos	nil
			)
			(while (< Count ssALen)
				(setq	EList	(entget (ssname ssA Count))
						TList	(entget (ssname ssT Count))
                        AttMst  (car (nth Count AttRPos))         ;added 03june14 karl
				)
;--Following line added to cure problem of attributes coming
;  in on layer "0", contrary to what AutoCAD says should happen
				(if ALayR
					(setq EList (subst (cons 8 ALayR)
								    (assoc 8 EList)
								    EList
							  )
					)
					(if (= "0" (cdr (assoc 8 EList)))
						(setq EList (subst LayR
									    (assoc 8 EList)
									    EList
								  )
						)
					)
				)
				(if (= (cdr (assoc 2 EList)) AttMst)
					(progn
						(setq MstPos (cdr (assoc 11 TList)))
						(if Bug
							(princ (strcat "\nMstPos = " (rtos (car MstPos) 2 4) "," (rtos (cadr MstPos) 2 4)))
						)
					)
					(if MstPos
						(setq Mlist	(GetAttOrt	AttRPos
										   		MstPos
										   		EList
										   		TList
										   		EListM
									)
						)
						(setq Mlist nil)
					)
				)
				(if Bug
					(setq	Ed_TLst	TList
							Ed_ELst	EList
					)
				)
				(if (and Mlist (= AttCom "NR"))
					(if (= (cdr (assoc 2 EList)) AttMst)
						(setq	EList	(subst	(assoc 11 TList)
												(assoc 11 EList)
												EList
										)
								EList	(subst	(assoc 10 TList)
												(assoc 10 EList)
												EList
										)
								EList	(subst	(assoc 50 TList)
												(assoc 50 EList)
												EList
										)
								EList	(if (assoc 72 EList)
											(if (assoc 72 TList)
												(subst	(assoc 72 TList)
														(assoc 72 EList)
														EList
												)
												(subst	(cons 72 0)
														(assoc 72 EList)
														EList
												)
											)
											(if (assoc 72 TList)
												(append EList (list (assoc 72 TList)))
												(append EList (list (cons 72 0)))
											)
										)
								EList	(if (assoc 74 EList)
											(if (assoc 73 TList)
												(subst	(cons 74 (cdr (assoc 73 TList)))
														(assoc 74 EList)
														EList
												)
												(subst	(cons 74 0)
														(assoc 74 EList)
														EList
												)
											)
											(if (assoc 73 TList)
												(append EList (list (cons 74 (cdr (assoc 73 TList)))))
												(append EList (list (cons 74 0)))
											)
										)
								Count	(1+ Count)
						)
						(setq	EList	(subst	(cons 11 (nth 1 Mlist))
												(assoc 11 EList)
												EList
										)
								EList	(subst	(cons 50 (nth 2 Mlist))
												(assoc 50 EList)
												EList
										)
								EList	(if (assoc 72 EList)
											(if (assoc 72 TList)
												(subst	(assoc 72 TList)
														(assoc 72 EList)
														EList
												)
												(subst	(cons 72 0)
														(assoc 72 EList)
														EList
												)
											)
											(if (assoc 72 TList)
												(append EList (list (assoc 72 TList)))
												(append EList (list (cons 72 0)))
											)
										)
								EList	(if (assoc 74 EList)
											(if (assoc 73 TList)
												(subst	(cons 74 (cdr (assoc 73 TList)))
														(assoc 74 EList)
														EList
												)
												(subst	(cons 74 0)
														(assoc 74 EList)
														EList
												)
											)
											(if (assoc 73 TList)
												(append EList (list (cons 74 (cdr (assoc 73 TList)))))
												(append EList (list (cons 74 0)))
											)
										)
								EList	(DelCons 10 EList)
								Count	(1+ Count)
						)
					)
					(setq	EList	(subst	(assoc 10 TList)
											(assoc 10 EList)
											EList
									)
							EList	(subst	(assoc 11 TList)
											(assoc 11 EList)
											EList
									)
							EList	(subst	(assoc 50 TList)
											(assoc 50 EList)
											EList
									)
							EList	(if (assoc 72 EList)
										(if (assoc 72 TList)
											(subst	(assoc 72 TList)
													(assoc 72 EList)
													EList
											)
											(subst	(cons 72 0)
													(assoc 72 EList)
													EList
											)
										)
										(if (assoc 72 TList)
											(append EList (list (assoc 72 TList)))
											(append EList (list (cons 72 0)))
										)
									)
							EList	(if (assoc 74 EList)
										(if (assoc 73 TList)
											(subst	(cons 74 (cdr (assoc 73 TList)))
													(assoc 74 EList)
													EList
											)
											(subst	(cons 74 0)
													(assoc 74 EList)
													EList
											)
										)
										(if (assoc 73 TList)
											(append EList (list (cons 74 (cdr (assoc 73 TList)))))
											(append EList (list (cons 74 0)))
										)
									)
						 Count (1+ Count)
					)
				)
				(EntMod EList) ;---Update database from "EList"
			)
			(command "ERASE" ssT "")
			(entupd EntM) ;---Update the screen image
		)
		(princ
			"\n\n***ADDS WARNING***  No Attributes were selected\n"
		)
	)
	(if Bug
		(princ "\nAttAct exited}\n")
	)
	(princ)
);end-of-defun
;
;
(defun Att-Up ( /	Pt1 Pt2					; Corrects rotation of attribute
				EntM EList EListM AttAngRad )
; Function: Corrects mirrored text attributes and rotates them to be readable
;           from the bottom side of drawing.
	(if Bug
		(princ "\nAtt-up entered")
	)
	(setq EntM (entlast)) ;---Operates on the last entity drawn---
	(setq EListM (entget EntM))
;---Construct correct layer name for attributes-----------------------------
	(setq EntM (entnext EntM)) ;---Get the 1st attrib data
	(setq EList (entget EntM))
	(while (equal (cdr (assoc 0 EList)) "ATTRIB")
		(setq AttAngRad (cdr (assoc 50 EList)))
;---Get attribute Angle------------
		(if (< AttAngRad 0)
			(setq AttAngRad (+ AttAngRad (* pi 2)))
;---Make Angle positive------------
		)
		(if	(or	(= INV "Y")						;---If symbol is 'inverted'--------
				(< (cadr (assoc 10 EList)) 0.0)		; Updated - GEW
				(< (caddr (assoc 10 EList)) 0.0)
				(< (cadddr (assoc 210 EList)) -0.1)
			)
			(progn ;   convert text back to normal
				(setq Pt1 (assoc 10 EList))
;   -works for Rel 10 only
;---Make X-coord positive----------------------------------------------
				(setq EList (subst (cons	10
									(list (abs (cadr Pt1))
										 (cadr (cdr Pt1))
										 (caddr (cdr Pt1))
									)
							    )
							    Pt1
							    EList
						  )
				)
				(setq Pt2 (assoc 11 EList))
;---Make X-coord positive----------------------------------------------
				(setq EList (subst (cons	11
									(list (abs (cadr Pt2))
										 (cadr (cdr Pt2))
										 (caddr (cdr Pt2))
									)
							    )
							    Pt2
							    EList
						  )
				)
				(setq EList (subst (cons 210 (list 0.0 0.0 1.0))
							    (assoc 210 EList)
							    EList
						  )
				)
				(setq AttAngRad (- 0 AttAngRad))
;---Change sign of attr Angle-------------
				(setq EList (subst (cons 50 AttAngRad)
							    (assoc 50 EList)
							    EList
						  )
				)
			)
		)
		(if (< AttAngRad 0)
			(setq AttAngRad (+ AttAngRad (* pi 2)))
;---Convert neg Angle to equiv
		) ;   positive Angle
;---Correct text Angle to be readable from bottom of dwg-------------------
		(if (and (> AttAngRad (/ pi 2)) (< AttAngRad (* pi 1.505)))     ;1.505rad = 86.23deg
			(progn
				(setq AttAngRad (- AttAngRad pi))
				(setq EList (subst (cons 50 AttAngRad)
							    (assoc 50 EList)
							    EList
						  )
				)
			)
		)
		(EntMod EList)				;---Update database from "EList"
		(entupd EntM)				;---Update screen image
		(setq EntM (entnext EntM))	;---Set up for loop
		(setq EList (entget EntM))
	)
	(if Bug
		(princ "\nAtt-up exited}\n")
	)
);end-of-defun
;
;
(defun Att-Chg-Lay ( /	EntM EList EListM		; Attribute Change Layer
					AttLay )
; Function: Set attribute's layer
; Date: (modified 1-27-89) by RER and SAB
	(if Bug
		(princ "\nAtt-Chg-Lay entered")
	)
	(setq	EntM		(entlast)						;---Operates on the last entity drawn---
			EListM	(entget EntM)
	;---Construct correct layer name for attributes-------------------------
			AttLay	(cdr (assoc 8 EListM))
			AttLay	(strcat (substr AttLay 1 6) "D" (substr AttLay 8 3))
			EntM		(entnext EntM)					;---Get the 1st attrib data
			EList	(entget EntM)
	)
 ;---This "while loop" assumes that attributes will be listed consecutive in database
	(while (equal (cdr (assoc 0 EList)) "ATTRIB")
 ;---Insert new layer name in list-------------------------------------
		(setq	EList	(subst	(cons 8 AttLay)
								(assoc 8 EList)
								EList
						)
		)
		(EntMod EList)								;---Update database from "EList"
		(entupd EntM)								;---Update screen image
		(setq	EntM		(entnext EntM)
				EList	(entget EntM)
		)
	)
	(if Bug
		(princ "\nAtt-Chg-Lay exited}\n")
	)
	(princ)
);end-of-defun
;
;
(defun GetAttOrt ( AttRPos MstPos EList TList EListM /	; Get Attribute Orientation
					RLen Cnt AttNam AttNum ADst AAng AJDst AJAng ASFct
					Att11 Att10 Att50
				)
	(setq	RLen		(length AttRPos)
			Cnt		0
			AttNam	(cdr (assoc 2 EList))
			AttNum	nil
	)
	(while (< Cnt RLen)
		(if (= (car (nth Cnt AttRPos)) AttNam)
			(setq	AttNum	Cnt)
		)
		(setq	Cnt	(1+ Cnt))
	)
	(if AttNum
		(setq	ADst		(distance	(nth 1 (nth 0 AttRPos))
								(nth 1 (nth AttNum AttRPos))
						)
				AAng		(angle	(nth 1 (nth 0 AttRPos))
								(nth 1 (nth AttNum AttRPos))
						)
				AJDst	(distance	(cdr (assoc 11 TList))
								(cdr (assoc 10 TList))
						)
				AJAng	(angle	(cdr (assoc 11 TList))
								(cdr (assoc 10 TList))
						)
				ASFct	(cdr (assoc 41 EListM))
				Att11	(polar MstPos AAng (* ASFct ADst))
				Att10	(polar Att11 AJAng AJDst)
				Att50	(if (equal 0.0 (nth 2 (nth AttNum AttRPos)) 0.01)
							0.0
							(nth 2 (nth AttNum AttRPos))
						)
		)
		(setq	Att10	nil
				Att11	nil
				Att50	nil
		)
	)
	(if (and Bug AttNum)
		(princ (strcat "\nWorked Att-" (itoa AttNum)))
	)
	(if (and Bug ADst)
		(princ (strcat "\nWorked ADst-" (rtos ADst)))
	)
	(if (and Bug AAng)
		(princ (strcat "\nWorked AAng-" (rtos AAng)))
	)
	(if (and Bug ASFct)
		(princ (strcat "\nWorked ASFct-" (rtos ASFct)))
	)
	(if (and Bug Att11)
		(princ	(strcat	"\nWorked Att11-"
						(rtos (car Att11) 2 4)
						","
						(rtos (cadr Att11) 2 4)
				)
		)
	)
	(list Att10 Att11 Att50)
);end-of-defun
;
;
(defun DelCons ( INum Elst / x NLst )			; Return list without matching items
	(setq	NLst	nil)
	(foreach	x
			Elst
			(if (/= (car x) INum)
			(if NLst
				(setq NLst (append NLst (list x)))
				(setq NLst (list x))
			)
		)
	)
	NLst
);end-of-defun
;
;
(defun AttCnv ( EntM /	NumChr EListM ssA		; Attribute Conversion Engine
					ssALen ssT EList LayR AttStyle AttAngDeg AttHgt AttVal Count
					s_72 s_73 d_72 d_73 AttAlign TmpLst BasePt BlkNam Tmp RotPt
					TblAtt AttBNam AttRPos AttALst AttMst MstPos ALayR TList )
	(if Bug
		(princ "\n{AttCnv entered\n")
	)
	(if (not EntM)
		(setq	EntM		(car (entsel "\n\nSelect an attribute:")))
	)
	(setq	EListM	(entget EntM)					;---works with EntM set by caller function
			LayR		(assoc 8 EListM)				;---gets layer block defined on
			ssA		(ssadd)						;---build a selection set of the attrs in EntM
			EList	(entget (entnext EntM))			;---starts getting attributes
	)
	(if (CheckEntity EListM)
		(setq	ALayR	(strcat	(substr (cdr LayR) 1 6)
								"D"
								(substr (cdr LayR) 8)
						)
		)
	)
	(while (equal (cdr (assoc 0 EList)) "ATTRIB")
		(ssadd (cdr (assoc -1 EList)) ssA)
		(setq	EList	(entget (entnext (cdr (assoc -1 EList)))))
	)
	(setq	ssALen	(sslength ssA))				;---get no. of items in selection set
	(if (> ssALen 0)
		(progn
			(setq	Count	0
					NumChr	0
			)
			(while (< Count ssALen)
				(setq	EList     (entget (ssname ssA Count))
						AttStyle  (cdr (assoc 7 EList))
						AttHgt	  (cdr (assoc 40 EList))
						AttAngDeg (/ (* (cdr (assoc 50 EList)) 180.0) pi)
						AttVal    (cdr (assoc 1 EList))
						AttPt     (cdr (assoc 10 EList))
				)
				(if (or (not AttVal) (= AttVal ""))
					(setq	AttVal	".")
				)
				(if (> (strlen AttVal) NumChr)
					(setq	NumChr	(strlen AttVal))
				)
				(setq	d_73		(cdr (assoc 74 EList))	; Note: Attrib code 74=Text code 73
						d_72		(cdr (assoc 72 EList))
						s_73		(cond	((= d_73 1) "B")
										((= d_73 2) "M")
										((= d_73 3) "M")
										(T "")
								)
						s_72		(cond	((= d_72 0) "L")
										((= d_72 1) "C")
										((= d_72 2) "R")
										((= d_72 3) "A")
										((= d_72 4) "M")
										((= d_72 5) "F")
										(T "")
								)
				)
				(setq	AttAlign	(strcat s_73 s_72))
				(if Bug
					(princ (strcat "\nAttAlign = " AttAlign))
				)
				(command "COLOR" "7")
				(if (or (= AttAlign "") (= AttAlign "L"))
					(if (= (cdr (assoc 40 (tblsearch "STYLE" AttStyle))) 0.0)
						(command "TEXT" "S" AttStyle AttPt AttHgt AttAngDeg AttVal)
						(command "TEXT" "S" AttStyle AttPt AttAngDeg AttVal)
					)
					(if (= (cdr (assoc 40 (tblsearch "STYLE" AttStyle))) 0.0)
						(command "TEXT" "S" AttStyle "J" AttAlign (cdr (assoc 11 EList)) AttHgt AttAngDeg AttVal)
						(command "TEXT" "S" AttStyle "J" AttAlign (cdr (assoc 11 EList)) AttAngDeg AttVal)
					)
				)
				(command "COLOR" "BYLAYER")
				(setq	Count	(1+ Count))
			)
		)
		(princ
			"\n\n***ADDS WARNING***  No Attributes were selected\n"
		)
	)
	(if Bug
		(princ "\nAttCnv exited}\n")
	)
	(princ)
);end-of-defun
;
;
(setq	LodVer	"3.0.0")
