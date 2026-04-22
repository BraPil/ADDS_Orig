(if AppNam								; Code Version Indicator {495 Lines of Code}
	(princ (strcat "\n" AppNam " RemDups Loading."))
	(princ "\nCadet 2.1 RemDups Loading.")
)

(defun C:NewChkTst ( /	)					; Check for Old Phasing duped with New Phasing with Bug turned on
	(setq	LayChkOld		T
			LayChkNot		nil
			DrawPnt		T
	)
	(if (not Bug)
		(c:Bug)
	)
	(Chk_Inserts)
	(Chk_Text)
	(Ck_Plines)
	(princ)
)

(defun C:NewChkDupNoLay ( /	)				; Checks for duplication by Name, Position & Rotation only
	(setq	LayChkNot		T
			LayChkOld		nil
	)
	(if (not Bug)
		(c:Bug)
	)
	(Chk_Inserts)
	(Chk_Text)
	(Ck_Plines)
	(princ)
)

(defun C:NewChkDupLay ( /	)				; Checks for duplication by Name, Layer, Position & Rotation
	(setq	LayChkNot		nil
			LayChkOld		nil
	)
	(if (not Bug)
		(c:Bug)
	)
	(Chk_Inserts)
	(Chk_Text)
	(Ck_Plines)
	(princ)
)

(defun C:NewChkDup ( /	)					; Check for Old Phasing duped with New Phasing
	(setq	LayChkOld		T
			LayChkNot		nil
	)
	(if Bug
		(c:Bug)
	)
	(Chk_Inserts)
	(Chk_Text)
	(Ck_Plines)
	(princ)
)

(defun Chk_Inserts ( /	MemDoI Cnt ICnt DoI		; Kills Duplicate Blocks
					ILst DLst Did DiDoI SSi Ent1 Ent2
					XtraLst XtraPnt EntN EntP HiC )
	(setq	SSi	(ssget "X" (list (cons 0 "INSERT")))
			ssO	nil
	)
	(if Bug (princ "\nVirtualizing Selection..."))
	(if SSi
		(progn
			(setq	Cnt	0
					HiC	(sslength SSi)
			)
			(repeat HiC
				(setq	Ent1		(ssname SSi Cnt)
						Ent2		(entget Ent1)
						Cnt		(1+ Cnt)
						ILst		(list	(cdr (assoc 2 Ent2))	; 0th Block Name
										(cdr (assoc 8 Ent2))	; 1st Layer Name
										(cdr (assoc 10 Ent2))	; 2nd Position X,Y
										(cdr (assoc 50 Ent2))	; 3rd Rotation
										Ent1					; 4th EntName
								)
				)
				(if DoI
					(setq	DoI	(cons ILst DoI))
					(setq	DoI	(list ILst))
				)
			)
			(princ (strcat "\nFound " (itoa HiC) " Blocks Inserted..."))
			(setq	SSi	nil)
		)
		(setq	HiC	nil
				DoI	nil
		)
	)
	(if DoI
		(if (> (length DoI) 1)
			(setq	Cnt		0
					HiC		(length DoI)
					DiDoI	DoI
			)
			(setq	Cnt		nil
					HiC		nil
			)
		)
		(setq	Cnt		nil
				HiC		nil
		)
	)
	(if Bug (princ "\nStarting Run"))
	(if HiC
		(while (< Cnt HiC)
			(setq	ILst		(car DoI)
					DoI		(cdr DoI)
					Did		nil
					ICnt		0
			)
			(if (and Cnt Bug) (grtext -1 (strcat "Insert #" (itoa Cnt) "   ")))
			(if (not Bug)
				(if (and Twaddle Cnt HiC)
					(Twaddle Cnt HiC)
				)
			)
			(foreach	DLst
					DoI
					(cond
						((and	(= (nth 0 DLst) (nth 0 ILst))			;Block Name
								(not Did)							;Loop condition
								LayChkOld							;Switch disables layer check
								(equal (nth 2 DLst) (nth 2 ILst) 0.1)	;Insertion Point
								(equal (nth 3 DLst) (nth 3 ILst) 0.02)	;Rotation
						 )
							(if	(or	(and	(= (substr (nth 1 ILst) 8 1) "1")
										(= (substr (nth 1 DLst) 8 1) "4")
									)
									(and	(= (substr (nth 1 ILst) 8 1) "2")
										(= (substr (nth 1 DLst) 8 1) "1")
									)
									(and	(= (substr (nth 1 ILst) 8 1) "3")
										(= (substr (nth 1 DLst) 8 1) "0")
									)
								)
								(if MemDoI
									(if (not (member Cnt MemDoI))
										(setq	MemDoI	(cons Cnt MemDoI)
												Did		T
										)
										(setq	Did		T)
									)
									(setq	MemDoI	(list Cnt)
											Did		T
									)
								)
								(if	(or	(and	(= (substr (nth 1 DLst) 8 1) "1")
											(= (substr (nth 1 ILst) 8 1) "4")
										)
										(and	(= (substr (nth 1 DLst) 8 1) "2")
											(= (substr (nth 1 ILst) 8 1) "1")
										)
										(and	(= (substr (nth 1 DLst) 8 1) "3")
											(= (substr (nth 1 ILst) 8 1) "0")
										)
									)
									(if XtraLst
										(setq	XtraLst	(cons (last DLst) XtraLst)
												XtraPnt	(cons (nth 2 DLst) XtraPnt)
										)
										(setq	XtraLst	(list (last DLst))
												XtraPnt	(list (nth 2 DLst))
										)
									)
								)
							)
						)
						((and	(= (nth 0 DLst) (nth 0 ILst))			;Block Name
								(not Did)							;Loop condition
								LayChkNot							;Switch disables layer check
								(equal (nth 2 DLst) (nth 2 ILst) 0.1)	;Insertion Point
								(equal (nth 3 DLst) (nth 3 ILst) 0.02)	;Rotation
						 )
							(if MemDoI
								(if (not (member Cnt MemDoI))
									(setq	MemDoI	(cons Cnt MemDoI)
											Did		T
									)
									(setq	Did		T)
								)
								(setq	MemDoI	(list Cnt)
										Did		T
								)
							)
						)
						((and	(= (nth 0 DLst) (nth 0 ILst))			;Block Name
								(not Did)							;Loop condition
								(= (nth 1 DLst) (nth 1 ILst))			;Layer Name
								(equal (nth 2 DLst) (nth 2 ILst) 0.1)	;Insertion Point
								(equal (nth 3 DLst) (nth 3 ILst) 0.02)	;Rotation
						 )
							(if MemDoI
								(if (not (member Cnt MemDoI))
									(setq	MemDoI	(cons Cnt MemDoI)
											Did		T
									)
									(setq	Did		T)
								)
								(setq	MemDoI	(list Cnt)
										Did		T
								)
							)
						)
					)
					(setq	ICnt		(1+ ICnt))
			)
			(setq	Cnt		(1+ Cnt))
		)
	)
	(if (not Bug)
		(if (and Twaddle Cnt HiC)
			(Twaddle (- 0 Cnt) HiC)
		)
	)
	(if MemDoI
		(progn
			(setq	ssO		(ssadd))
			(foreach	EntN
					MemDoI
					(setq	ssO		(ssadd (last (nth EntN DiDoI)) ssO))
			)
		)
	)
	(if (not ssO)
		(setq	ssO		(ssadd))
	)
	(if XtraLst
		(progn
			(setq	ssO		(ssadd (car XtraLst) ssO)
					XtraLst	(cdr XtraLst)
			)
			(foreach	EntN
					XtraLst
					(setq	ssO		(ssadd EntN ssO))
			)
		)
	)
	(cond
		((and	XtraPnt
				MemDoI
		 )
			(foreach	EntP
					MemDoI
					(setq	XtraPnt	(cons (nth 2 (nth EntP DiDoI)) XtraPnt))
			)
		)
		(MemDoI
			(foreach	EntP
					MemDoI
					(if	XtraPnt
						(setq	XtraPnt	(cons (nth 2 (nth EntP DiDoI)) XtraPnt))
						(setq	XtraPnt	(list (nth 2 (nth EntP DiDoI))))
					)
			)
		)
	)
	(if (and DrawPnt XtraPnt)
		(progn
			(command "_.LAYER" "T" "0" "ON" "0" "U" "0" "S" "0" "" "_.PLINE" (car XtraPnt) "W" "0.0" "0.0")
			(foreach	EntP
					(cdr XtraPnt)
					(command EntP)
			)
			(command "")
		)
	)
	(if (< (sslength ssO) 1)
		(setq	ssO		nil)
	)
	(if ssO
		(if Bug
			(princ (strcat "\nFound " (setq ICnt (itoa (sslength ssO))) " duplicate Insert Items"))
			(progn
				(princ (strcat "\nDeleting " (setq ICnt (itoa (sslength ssO))) " duplicate Insert Items"))
				(command "_.ERASE" ssO "")
			)
		)
		(if Bug
			(princ "\nNo Duplicates found to delete...")
		)
	)
	ICnt
)

(defun Chk_Text ( /	MemDoI Cnt ICnt DoI		; Kills Duplicate Text
					ILst DLst Did DiDoI SSi Ent1 Ent2 EntN HiC )
	(setq	SSi	(ssget "X" (list (cons 0 "TEXT")))
			ssO	nil
	)
	(if Bug (princ "\nVirtualizing Selection..."))
	(if SSi
		(progn
			(setq	Cnt	0
					HiC	(sslength SSi)
			)
			(repeat HiC
				(setq	Ent1		(ssname SSi Cnt)
						Ent2		(entget Ent1)
						Cnt		(1+ Cnt)
						ILst		(list	(cdr (assoc 1 Ent2))
										(cdr (assoc 8 Ent2))
										(cdr (assoc 10 Ent2))
										(cdr (assoc 50 Ent2))
										Ent1
								)
				)
				(if DoI
					(setq	DoI	(cons ILst DoI))
					(setq	DoI	(list ILst))
				)
			)
			(princ (strcat "\nFound " (itoa HiC) " Text Pieces..."))
			(setq	SSi	nil)
		)
		(setq	HiC	nil
				DoI	nil
		)
	)
	(if DoI
		(if (> (length DoI) 1)
			(setq	Cnt		0
					HiC		(length DoI)
					DiDoI	DoI
			)
			(setq	Cnt		nil
					HiC		nil
			)
		)
		(setq	Cnt		nil
				HiC		nil
		)
	)
	(if Bug (princ "\nStarting Run"))
	(if HiC
		(while (< Cnt HiC)
			(setq	ILst		(car DoI)
					DoI		(cdr DoI)
					Did		nil
					ICnt		0
			)
			(if (and Cnt Bug) (grtext -1 (strcat "Text #" (itoa Cnt) "   ")))
			(if (not Bug)
				(if (and Twaddle Cnt HiC)
					(Twaddle Cnt HiC)
				)
			)
			(foreach	DLst
					DoI
					(if (not Did)
						(if	(and	(= (nth 0 DLst) (nth 0 ILst))			;Text
								(= (nth 1 DLst) (nth 1 ILst))		;Layer Name
								(equal (nth 2 DLst) (nth 2 ILst) 0.1)	;Insertion Point
								(equal (nth 3 DLst) (nth 3 ILst) 0.02)	;Rotation
							)
							(if MemDoI
								(if (not (member Cnt MemDoI))
									(setq	MemDoI	(cons Cnt MemDoI)
											Did		T
									)
									(setq	Did		T)
								)
								(setq	MemDoI	(list Cnt)
										Did		T
								)
							)
						)
					)
					(setq	ICnt		(1+ ICnt))
			)
			(setq	Cnt		(1+ Cnt))
		)
	)
	(if (not Bug)
		(if (and Twaddle Cnt HiC)
			(Twaddle (- 0 Cnt) HiC)
		)
	)
	(if MemDoI
		(progn
			(setq	ssO		(ssadd))
			(foreach	EntN
					MemDoI
					(setq	ssO		(ssadd (last (nth EntN DiDoI)) ssO))
			)
		)
	)
	(if ssO
		(if Bug
			(princ (strcat "\nFound " (setq ICnt (itoa (sslength ssO))) " duplicate Text Pieces"))
			(progn
				(princ (strcat "\nDeleting " (setq ICnt (itoa (sslength ssO))) " duplicate Text Pieces"))
				(command "_.ERASE" ssO "")
			)
		)
	)
	ICnt
)

(defun Ck_Plines ( /	Sset )				; Delete duplicate plines
;------------------------------------------------------------------------------
; 1) DOES CROSSING SET ON START POINTS OF EVERY PLINE ON SAME LAYER.
; 2) COMPARES VERTEX TO VERTEX FOR THE PLINES UNTIL POINTS DIFFER OR
;    END OF ONE OF THE PLINES IS REACHED.
; 3) IF ALL VERTEXES MATCH THEN DELETE DUPLICATE, ELSE
;        IF THE ANGLE OF THE LAST SEGMENTS MATCH THEN STORE START POINT OF
;        PLINE IN LIST CALLED OVERLAY.
	(IF (SETQ Sset (SSGET "X" (list (cons 0 "POLYLINE"))))
		(PROGN
			(SETQ	DELSET	(SSADD)
					OVERLAY	NIL
					ECNT		0
					HiCnt	(SSLENGTH SSET)
			)
			(princ (STRCAT "\nPlines: " (ITOA (SSLENGTH SSET)) "\tKeeping:    "))
			(WHILE (SETQ ENAM (SSNAME SSET ECNT))
				;(princ (itoa (1+ ECNT)))
				(if (not Bug)
					(if (and Twaddle ECNT HiCnt)
						(Twaddle ECNT HiCnt)
					)
				)
				(SETQ	ELST		(ENTGET ENAM)
						ELAY		(CDR (ASSOC 8 ELST))
						PBOX		(/ (CDR (ASSOC 40 ELST)) 2)    ;Size for crossing box.  1/2 width
						EPT		(CDR (ASSOC 10 (ENTGET (ENTNEXT ENAM))))
				)
				(WHILE (NOT (SETQ CSET (SSGET "C"	(LIST (- (CAR EPT) PBOX) (- (CADR EPT) PBOX))
					      					(LIST (+ (CAR EPT) PBOX) (+ (CADR EPT) PBOX))
											(LIST (CONS 0 "POLYLINE") (CONS 8 ELAY)))))
					(SETQ PBOX (+ PBOX 3))
				)
				(IF (> (SSLENGTH CSET) 1)
					(PROGN
						(SETQ	CCNT		0)
						(WHILE (SETQ CNAM (SSNAME CSET CCNT))
							(IF (NOT (EQ CNAM ENAM))
								(PROGN
									(SETQ	PT1NAM	(ENTNEXT ENAM)   ;vertex of main entitiy
											PT1TYP	(CDR (ASSOC 0 (ENTGET PT1NAM)))
											PT1		NIL
											PT2NAM	(ENTNEXT CNAM)   ;vertex of crossing entity
											PT2TYP	(CDR (ASSOC 0 (ENTGET PT2NAM)))
											PT2		NIL
											DIFF		NIL
									)
									(WHILE (AND (/= PT1TYP "SEQEND") (/= PT2TYP "SEQEND") (NOT DIFF))
										(SETQ	OLD1		PT1
												PT1		(CDR (ASSOC 10 (ENTGET PT1NAM)))
												OLD2		PT2
												PT2		(CDR (ASSOC 10 (ENTGET PT2NAM)))
										)
										(IF (EQUAL PT1 PT2 0.1)
											(SETQ	PT1NAM	(ENTNEXT PT1NAM)   ;vertex of main entitiy
													PT1TYP	(CDR (ASSOC 0 (ENTGET PT1NAM)))
													PT2NAM	(ENTNEXT PT2NAM)   ;vertex of crossing entity
													PT2TYP	(CDR (ASSOC 0 (ENTGET PT2NAM)))
											)
											(SETQ	DIFF		T)   ;ELSE vetex points do not match
										)
									)
									(IF (AND (= PT1TYP "SEQEND") (= PT2TYP "SEQEND"))
										(PROGN
											(SSADD CNAM DELSET)
											(SSDEL CNAM SSET)
										)
										(IF (AND OLD1 (EQUAL (ANGLE OLD1 PT1) (ANGLE OLD2 PT2) 0.03))
											(SETQ	OVERLAY	(CONS EPT OVERLAY))
										)
									)
								)
							)
							(SETQ	CCNT	(1+ CCNT))
						)
					)
				)
				(SETQ ECNT (1+ ECNT))
			)
			(if (not Bug)
				(if (and Twaddle ECNT HiCnt)
					(Twaddle (- 0 ECNT) HiCnt)
				)
			)
			(princ "\tDuplicates:    ") (princ (itoa (SSLENGTH DELSET))) (princ "\t\t")
			(COMMAND "_.ERASE" DELSET "")
		)
	)
)

(setq	LodVer	"2.5.2d")
