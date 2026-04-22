(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " Custom50 Loading."))
	(princ "\nAddsPlot Custom50 Loading.")
)

(defun Do_Cus ( / )						;turns adjacent non-associated n.o.'s black for plotting
	(if Bug (princ "\n{ Do_Cus Entered"))
	(setq	pos	0)
	(setvar "CMDECHO" 0)
	(setq	vtxlst	nil
			ptlst	nil
			conn1	(ssadd)
			conn0	(ssadd)
			conn2	(ssadd)
	)
	(STARTtimer)
	(princ "Building endpoint list of visual circuits...")
	(setq	VtxLst	(GetVtx))
	(if VtxLst
		(progn
			(setq	VtxNum	(length VtxLst))
			(princ (strcat "Sorting list of " (itoa VtxNum) " endpoints....."))
			(if (< VtxNum 32767)
				(setvar "MAXSORT" VtxNum)
				(setvar "MAXSORT" 32767)
			)
			(setq	VtxLst	(acad_strlsort VtxLst))
			(STOPtimer)
			(STARTtimer)
			(princ "Finding switches with only 1 visual connection & changing layer for display.")
			(repeat (length cordkey)
				(setq	fdr_lay	(nth pos cordkey))
				(getsw)
				(setq	pos (1+ pos))
			)
			(princ (strcat "Number of swiches with only one connection: " (itoa (sslength conn1))))
			(STOPtimer)
		)
		(princ "Did not find any visible circuits, did nothing!")
	)
	(if Bug (princ "\n Do_Cus Exited}\n"))
	(princ)
)

(defun GetVtx ( / Eset n Ename Elist assoc10 )	; defines <VtxLst> ,string list made of X & Y endpoints and layer name.
	(setq	n	0)
	(if (setq Eset (ssget "C" (getvar "EXTMIN") (getvar "EXTMAX") (list (cons 0 "POLYLINE") (cons 8 "????CK*"))))
		(while (setq Ename (ssname Eset n))
			(setq	Elist	(entget (entnext Ename))
					VtxLst	(cons (strcat (itoa (fix (cadr (assoc 10 Elist)))) " "  (itoa (fix (caddr (assoc 10 Elist)))) " "  (setq Elay (cdr (assoc 8 Elist))) ) VtxLst)
					Elist	(entget (entnext (cdr (assoc -1 Elist))))
			)
			(while (/= (cdr (assoc 0 Elist)) "SEQEND")
				(setq	assoc10	(assoc 10 Elist)
						Elist	(entget (entnext (cdr (assoc -1 Elist))))
				)
			)
			(setq	VtxLst	(cons (strcat (itoa (fix (cadr assoc10))) " " (itoa (fix (caddr assoc10))) " " Elay ) VtxLst)
					n		(1+ n)
			)
		)
	)
	(setq	Eset	nil)
	(gc)
	VtxLst
)

(defun GetSw ( / pt0 )						;(defun getsw( / Eset n Ename Elist Elay Lay1 Lay2 pt1 pt2 fdr)
	(setq n 0)
	(command "_.mspace")
	(if (setq Eset (ssget "X" (list (cons 0 "INSERT") (cons 8 "????SW-*"))))
		(while (setq Ename (ssname Eset n))
			(setq Elist (entget Ename))
			(if (not (member (cdr (assoc 2 Elist)) '("RISER" "A140")))
				(progn
					(setq	pt0		(cdr (assoc 10 Elist))
							pt1		(polar pt0 (cdr (assoc 50 Elist)) (/ (cdr (assoc 41 Elist)) 2.0))
							pt2		(polar pt1 (+ pi (cdr (assoc 50 Elist))) (cdr (assoc 41 Elist)))
							Elay		(cdr (assoc 8 Elist))
							fudge	(* (abs (cdr (assoc 41 Elist))) 0.5)
							Lay1		(BS (strcat (itoa (fix (car pt1))) " " (itoa (fix (cadr pt1)))) VtxLst)
							Lay2		(BS (strcat (itoa (fix (car pt2))) " " (itoa (fix (cadr pt2)))) VtxLst)
					)
          			(if Lay1
            				(if Lay2
              				(progn
			  					(setq ptlst (cons pt2 ptlst)
									 ptlst (cons pt1 ptlst)
								)
                						(if (or (= fdr_lay (substr Lay1 1 2))
										   (= fdr_lay (substr Lay2 1 2))
										   (= fdr_lay (substr Lay1 1 3))
										   (= fdr_lay (substr Lay2 1 3))
										)
                  							(progn
                    							(setq Elist (subst (cons 8 "0") (assoc 8 Elist) Elist))
                    							(entmod Elist)
                    							(setq ALIST (entget (entnext(cdr (assoc -1 Elist)))))
                    								(if Alist
													(progn
                      										(while (/= (cdr (assoc 0 Alist)) "SEQEND")
                        										(progn
                          											(setq Alist (subst (cons 8 "0") (assoc 8 Alist) Alist)
																	 Alist (subst (cons 62 7) (assoc 62 Alist) Alist)
																	 Alist (subst (cons 6 "BYLAYER") (assoc 6 Alist) Alist)
																)
                          											(entmod Alist)
																(entmod elist)
																(setq ALIST (entget (entnext(cdr (assoc -1 Alist)))))
                       									 		)
                     								 		)
													)
									    			)
											(command "_.change" ename "" "p" "la" "0" "")
											(setq Alist NIL)
                    							(entupd Ename)
                 							 )
               						 )
             					 )
						)
					)
   				)
            
          	)
		 	(setq n (1+ n))
        	)
    )
	;	Cleanup
	(if Eset	(setq Eset nil))
	(gc)
	
	(command "_.PSpace")
)

(defun STARTtimer ( / )
	(setq	_STARTtimer	(getvar "DATE"))
	(princ)
)

(defun STOPtimer ( / secs )
	(if _STARTtimer
		(progn
			(setq	secs (*  (- (- (getvar "DATE") _STARTtimer) (fix (- (getvar "DATE") _STARTtimer)))   86400.0))
			(princ (strcat "Time elasped " (itoa (fix (/ secs 60.0))) " mins. and " (rtos (rem secs 60) 2 2) " secs."))
		)
		(princ "The function STARTtimer() must be run first.")
	)
)

(defun BS ( what lst / first llast mid SWpt )
	(setq	first	0
			llast	(length lst)
	)
	(while (< first llast)
		(setq	mid		(fix (/ (+ first llast) 2)))
		(if (< (SUBSTR (nth mid lst) 1 14) what)
			(setq	first	(1+ mid))
			(setq	llast	mid)
		)
	)
	(setq	SwX	(atoi (substr what 1 6))				;set to -1 on failure & set to 1 on sugsess.
			SwY	(atoi (substr what 8 7))
			i	FIRST
			lost	0
	)
	(if (and (> i -1) (< i VtxNum))
		(if (equal SwX (atoi (substr (nth i lst) 1 6)) fudge)
			(if (equal SwY (atoi (substr (nth i lst) 8 7)) fudge)
				(setq	lost	1)					;if X and Y match
				(setq	lost	-1)					;if X but not Y
			)
			(setq lost -1)							;not X, fell beneath range.
		)
		(setq lost -1)								;hit bottom of list
	)
	(if (= lost -1)
		(progn
			(setq	i	(1- FIRST)
					lost	0
			)
			(while (= lost 0)
				(if (> i -1)
					(if (equal SwX (atoi (substr (nth i lst) 1 6)) fudge)
						(if (equal SwY (atoi (substr (nth i lst) 8 7)) fudge)
							(setq	lost	1)		;if X and Y match
							(setq	i	(1- i))	;if X but not Y
						)
						(setq	lost	-1)			;not X, fell beneath range.
					)
					(setq	lost	-1)				;hit bottom of list
				)
			)
		)
	)
	(if (= lost -1)
		(progn
			(setq	i	(1+ FIRST)
					lost	0
			)
			(while (= lost 0)
				(if (< i VtxNum)
					(if (equal SwX (atoi (substr (nth i lst) 1 6)) fudge)
						(if (equal SwY (atoi (substr (nth i lst) 8 7)) fudge)
							(setq	lost	1)		;if X and Y match
							(setq	i	(1+ i))	;if X but not Y
						)
						(setq	lost	-1)			;not X, ran over range.
					)
					(setq	lost	-1)				;hit top of list
				)
			)
		)
	)
	(if (= lost 1)
		(SUBSTR (nth i lst) 16 10)
		(eval NIL)
	)
)

(DEFUN CIR (PT / )
	(SETQ	H	(* (GETVAR "VIEWSIZE") 0.06)
			C0	1.0
			S0	0.0
			A	(/ PI 8.0)
	)
	(WHILE (<= A (* 2 PI))
		(SETQ	C1	(COS A)
				S1	(SIN A)
				F	H
				LOOP	4
		)
		(WHILE (< LOOP 7)
			(SETQ	F	(* F 0.65)
					X1	(+ (CAR PT)  (* F C0))
					X2	(+ (CAR PT)  (* F C1))
					Y1	(+ (CADR PT) (* F S0))
					Y2	(+ (CADR PT) (* F S1))
			)
			(GRDRAW (LIST X1 Y1) (LIST X2 Y2) LOOP 0)
			(SETQ	LOOP	(+ LOOP 2))
		)
		(SETQ	C0	C1
				S0	S1
				A	(+ A (/ PI 8.0))
		)
	)
	(SETQ	F	H
			LOOP	4
	)
	(WHILE (< LOOP 7)
		(SETQ	F	(* F 0.65)
				X1	(+ (CAR PT) (* F C0))
				X2	(+ (CAR PT) F)
				Y1	(+ (CADR PT) (* F S0))
				Y2	(+ (CADR PT) 0.0)
		)
		(GRDRAW (LIST X1 Y1) (LIST X2 Y2) LOOP 0)
		(SETQ	LOOP	(+ LOOP 2))
	)
)

(defun C:FIND ( / )						; DRAW CIRCLES AROUND POINTS WERE PLINES MAY OVERLAP.
	(command "_.MSpace")
	(FOREACH	PT
			ptlst
			(CIR PT)
	)
	(command "_.PSpace")
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(do_cus)
	(setq	LodVer	"3.0.0a")
)
