(if AppNam								; Code Version Indicator {Universal}
	(princ (strcat "\n" AppNam " ChgFdr Loading."))
	(princ "\nAddsPlot ChgFdr Loading.")
)

(defun ChgFdr ( / pl LName LN_kV FdrCode tmpss FdrClr ss resp)
	(command "_.UNDO" "_BE")
	(setq pl nil)
	(while (null pl)
		(if (setq pl (car (entsel "\nSelect a piece of circuit to be changed:")))
			(if (and (/= Div "AL") (/= Div "GA"))										; [Added for Trans]
				(if (not (wcmatch (setq LName (cdr (assoc 8 (entget pl)))) "????????##*"))
					(progn
                        ;below:  \7 is a bell (control character)(displays as a dot on the command line)
						(princ "\n \nEntity selected not a circuit\7")
						(setq pl nil)
					)
				)
				(if (not (wcmatch (setq LName (cdr (assoc 8 (entget pl)))) "???????????"))	; [Added for Trans]
					(progn
                        			(princ "\n\nEntity selected not a circuit\7");  \7 is a bell (control character)
						(setq pl nil)
					)
				)
			)
			(princ "\n \nNo entity selected\7")
		)
	)
	(if (and (/= Div "AL") (/= Div "GA")(> (strlen LName) 9))								; [Modified for Trans]
		(setq	LN_kV	(substr LName 9 2))
	)
	(if (and (or (= Div "AL")(= Div "GA"))(>= (strlen LName) 12))							; [Added for Trans]
		(setq	LN_kV	(substr LName 10 2))
	)
	(setq FdrCode "")
	(setq FdrClr nil)
	(while (and (/= Div "AL") (/= Div "GA")(/= (strlen FdrCode) 3))							;[Modified for Trans]
		(setq FdrCode (strcase (getstring "\n\n\nEnter 3 character Feeder Code: ")))
	)
	(while (and (or (= Div "AL")(= Div "GA"))(/= (strlen FdrCode) 5))						;[Added for Trans]
		(setq FdrCode (strcase (getstring "\n\n\nEnter 5 character Feeder Code: ")))
	)
	
	(if (and (/= Div "AL") (/= Div "GA"))
		(if (setq tmpss (ssget "X" (list (cons 8 (strcat FdrCode "?CK-*")))))
			(setq FdrClr (cdr (assoc 62 (tblsearch "Layer" (cdr (assoc 8 (entget (ssname tmpss 0))))))))
			(while (not FdrClr)
				(initget 6)
				(setq	FdrClr	(getint "\n\nEnter Feeder Color number: "))
			)
		)
		(if (setq tmpss (ssget "X" (list (cons 8 (strcat FdrCode "*")))))
			(setq FdrClr (cdr (assoc 62 (tblsearch "Layer" (cdr (assoc 8 (entget (ssname tmpss 0))))))))
			(while (not FdrClr)
				(initget 6)
				(setq	FdrClr	(getint "\n\nEnter Feeder Color number: "))
			)
		)
	)
	(if LN_kV
		(setq	kV_Code (strcase (getstring "\n\n\nEnter 2 character Voltage Code (or <return> for no change:) ")))
	)
	(if  kV_Code
		(if (> (strlen kV_Code) 0)
			(if (assoc kV_Code Lst_kV_Clr)
				(if (equal kV_Code LN_kV)
					(setq	kV_Code	nil
							Bubba	(princ "\nExisting Voltage matches New Voltage - Ignored")
					)
					(princ (strcat "\nNew Voltage {" kV_Code "} - Accepted"))
				)
				(setq	kV_Code	nil
						Bubba	(princ "\nNew Voltage not valid - Ignored")
				)
			)
			(setq	kV_Code	nil
					Bubba	(princ "\nNew Voltage not entered - Ignored")
			)
		)
		(setq	kV_Code	nil
				Bubba	(princ "\nNew Voltage not entered - Ignored")
		)
	)
	
	(if (and LN_kV kV_Code)
		(princ (strcat "\n \nSelect the circuit, symbols, and text to be changed...\nFrom [" (substr LName 1 3) "..." LN_kV "] to [" FdrCode "..." kV_Code "]"))
		(princ "\n \nSelect the circuit, symbols, and text to be changed.")
	)
	
	
	(princ "\nUse [C]rossing, [W]indow, [R]emove, and/or [A]dd...")
	(if (and (/= Div "AL") (/= Div "GA"))
		(if (and LN_kV kV_Code)												;[Added/Modified for Trans]
			(setq	ss	(ssget (list (cons 8 (strcat (substr LName 1 3) "?????" LN_kV "*")))))
			(setq	ss	(ssget (list (cons 8 (strcat (substr LName 1 3) "*")))))
		)
		(if (and LN_kV kV_Code)
			(setq	ss	(ssget (list (cons 8 (strcat (substr LName 1 9) LN_kV "*")))))		    
			(setq	ss	(ssget (list (cons 8 (strcat (substr LName 1 9) "*")))))
		)
	)
	(initget "Yes No")
	(setq	resp	(getkword "\n \n \nOkay to proceed? <Y>: "))
	(princ "\n FdrClr = ") (prin1 FdrClr)
	(if (and ss (or (null resp) (= resp "Yes")))
		(Go_ChgFdr2 ss FdrCode FdrClr kV_Code)
	)
	(if (and ss (or (null resp) (= resp "Yes")))
		(ChngUm nil ss)
	)
	(command "_.UNDO" "_EN")
	
	; Releases Selection sets from memory
	(setq	ss		nil					
			tmpss	nil
	)
	(gc)
)
;------------------------------------------------------------------------------
(defun Go_ChgFdr ( ss FdrCode FdrClr kV_Code / c e el ObjType NewLay subent sublst)
    (setq c 0)
    (while (setq e (ssname ss c))
        (setq el     (entget e (list "*"))
              ObjType  (cdr (assoc 0 el))
              NewLay (CreateLay (cdr (assoc 8 el)) FdrCode FdrClr kV_Code)
              el     (subst (cons 8 NewLay) (assoc 8 el) el)
        )
        (entmod el)
        (if (and (= ObjType "INSERT") (= (cdr (assoc 66 el)) 1))
            (progn
                (setq subent (entnext e)
                      sublst (entget subent (list "*"))
                )
                (while (= (cdr (assoc 0 sublst)) "ATTRIB")
                    (setq NewLay (CreateLay (cdr (assoc 8 sublst)) FdrCode FdrClr kV_Code)
                          sublst (subst (cons 8 NewLay) (assoc 8 sublst) sublst)
                    )
                    (entmod sublst)
                    (entupd subent)
                    (setq subent (entnext subent)
                          sublst (entget subent (list "*"))
                    )
                )
                (setq sublst (subst (cons 8 NewLay) (assoc 8 sublst) sublst))
                (entmod sublst)
                (entupd subent)
            )
        );end-of-if
	    (if (and (= ObjType "POLYLINE") (= (cdr (assoc 66 el)) 1))
            (progn
                (setq subent (entnext e)
                      sublst (entget subent (list "*"))
                )					   
			  (while (= (cdr (assoc 0 sublst)) "VERTEX")
                    (setq sublst (subst (cons 8 NewLay) (assoc 8 sublst) sublst)
                    )
                    (entmod sublst)
                    (entupd subent)
                    (setq subent (entnext subent)
                          sublst (entget subent (list "*"))
                    )
                )
			  (setq sublst (subst (cons 8 NewLay) (assoc 8 sublst) sublst))
			  (entmod sublst)
                (entupd subent)
            )
		)
		(entupd e)
		(setq c (1+ c))
    );end-of-while
)

;------------------------------------------------------------------------------
(defun CreateLay ( OldLay FdrCode FdrClr kV_Code / NewLay clr )
	(if (and (/= Div "AL") (/= Div "GA"))										; Modified for Trans]
		(if kV_Code
			(setq	NewLay	(strcat FdrCode (substr OldLay 4 5) kV_Code))
			(setq	NewLay	(strcat FdrCode (substr OldLay 4 7)))
		)
		(if kV_Code														; [Added for Trans]
			(setq	NewLay	(strcat "0000" FdrCode kV_Code))
			(setq	NewLay	(strcat "0000" FdrCode (substr OldLay 10 2)))
		)
	)
	(if Bug
		(princ (strcat "\nFrom {" OldLay "} To {" NewLay "}"))
	)
	(if (not (LayChk NewLay))
		(progn
			(if (= (substr NewLay 5 2) "CP")
				(setq	clr	2)
				(if (member (substr NewLay 7 1) (list "D" "T" "B"))
					(setq	clr	7)
					(setq	clr	FdrClr)
				)
			)
			(command "_.LAYER" "N" NewLay "C" clr NewLay "") 
		)
	)
	NewLay
)

;------------------------------------------------------------------------------
(defun C:Chg ( / )
    (ChgFdr)
    (princ)
);end-of-defun

(defun C:DeepDive ( / ent cn)
	(setq ent (entget (car (entsel)) (list "*")))
	(princ "\n")(prin1 ent) (princ "\n")
	;	Checks to see if there are sub-entities in the selected object
	(if (= (cdr (assoc 66 ent)) 1) 
		(progn
			(setq cn 1)
			(while cn
				 (setq ent (entget (entnext (cdr (car ent))) (list "*")))
				 (princ "\n") (prin1 ent) (princ "\n")
				 (if (= (cdr (assoc 0 ent)) "SEQEND")
				 	(setq cn nil)
				)
			)
		)
	)
	;	Opens text screen or commandline screen	
	(textscr)	
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(ChgFdr)
	(setq	LodVer	"3.0.1")
)
