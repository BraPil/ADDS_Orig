(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " 4 Loading."))
	(princ "\nAddsPlot 4 Loading.")
)

(defun Cus4 ( / )							;Rotates all text and text attributes to be readable
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
	(if EdCode
		(if (= (strcase (getvar "loginname")) "GEWILYMS")
			(setq	Bug		T
					*error*	nil
			)
		)
	)
	(if Bug (princ "\n{Custom4 Entered}\n"))
;-----------------------------------------------------------------------------
; Name: CUSTOM4.lsp
; Function: Rotates all text and text attributes so that they are readable
;           from the bottom side of drawing with the north arrow to the LEFT.
;           Also includes a sample to show how to turn off all formats but the
;           one that is needed.
;
;
;*****************************************************************************
;    The following line turns all the format layers off and then turns the   *
;        format layer specified back on.  You should SUBSTITUTE the correct  *
;        TWO CHARACTER SUBSTATION DESIGNATION where the "EQ" is AND the      *
;        correct VOLTAGE where the "12" is.  DO NOT change anything else on  *
;        the line.                                                           *
;*****************************************************************************
;
;
	(command "LAYER" "OFF" "????FMT???" "ON" "LO--FMT-12" "")
;
;
;*****************************************************************************
;    The program below rotates the text.  DO NOT MODIFY ANYTHING BELOW THIS  *
;        LINE!!!!!!                                                          *
;*****************************************************************************
;
	(setq	sset	(ssget "X"	(list	(cons 0 "INSERT") (cons 67 0))))
;;;									(cons -4 "<NOT")
;;;										(cons -4 "<OR")
;;;											(cons 2 "_OC*")
;;;											(cons 2 "RECL*")
;;;											(cons 2 "A105")
;;;											(cons 2 "A169")
;;;											(cons 2 "A193")
;;;											(cons 2 "A194")
;;;										(cons -4 "OR>")
;;;									(cons -4 "NOT>")
;;;							)
;;;				)
;;;	)
	(if sset
		(progn
			(setq	CntR		0
					sLen		(sslength sset)
			)
			(princ (strcat "\n\n{" (itoa sLen) "} attributes to be processed\n"))
			(princ "\nProcessing attributes...")
			(while (setq entm (ssname sset CntR))
				(if (not Bug)
					(Twaddle CntR sLen)
				)
				(setq	blkn		(cdr (assoc 2 (entget entm)))
						entm		(entnext entm)
						elist	(entget entm)
				)
				(if (wcmatch (strcase blkn) "A###,A###S,_*")
					(while (equal (cdr (assoc 0 elist)) "ATTRIB")
						(setq	attang	(cdr (assoc 50 elist))			;---Get attribute angle------------
								attpts	(AttRotBox nil nil pi elist)		;---Get attribute pts...------------
						)
						(while (or (< attang 0) (> attang (* pi 2)))
							(if (< attang 0)
								(setq attang (+ attang (* pi 2)))    ;---Make angle positive------------
							)
							(if (> attang (* pi 2))
								(setq attang (- attang (* pi 2)))    ;---Make angle less than 360 degrees------------
							)
						)
						(if (or (>= attang 5.93412) (<= attang 2.7925))
							(setq	attang	(+ attang pi)
									elist	(AttValAdj attpts elist)
							)
						)
						(entmod elist)									;---Update database from "elist"
						(entupd entm)									;---Update screen image
						(setq entm (entnext entm))						;---Set up for loop
						(setq elist (entget entm))
					)
				)
				(setq CntR (1+ CntR))
			)
			(if (not Bug)
				(Twaddle sLen sLen)
			)
		)
	)
	(setq sset (ssget "X" (list (cons 0 "TEXT") (cons 67 0))))
	(if sset
		(progn
			(setq	CntR		0
					sLen		(sslength sset)
			)
			(princ (strcat "\n\n{" (itoa sLen) "} text strings to be processed\n"))
			(princ "\nProcessing text string...")
			(setq CntR 0)
			(while (setq entm (ssname sset CntR))
				(if (not Bug)
					(Twaddle CntR sLen)
				)
				(setq elist (entget entm))
				(setq	attang	(cdr (assoc 50 elist))   		;---Get text angle-----------------
						attpts	(AttRotBox nil nil pi elist)		;---Get attribute pts...------------
				)
				(while (or (< attang 0) (> attang (* pi 2)))
					(if (< attang 0)
						(setq attang (+ attang (* pi 2)))    ;---Make angle positive------------
					)
					(if (> attang (* pi 2))
						(setq attang (- attang (* pi 2)))    ;---Make angle less than 360 degrees------------
					)
				)
		;---Correct text angle to be readable from bottom of dwg-------------------
		;---  with the north arrow pointing to the right.       -------------------
				(if (or (>= attang 5.93412) (<= attang 2.7925))
					(setq	attang	(+ attang pi)
							elist	(TxtValAdj attpts elist)
					)
				)
				(entmod elist)                          ;---Update database from "elist"
				(entupd entm)                      ;---Update screen image
				(setq CntR (1+ CntR))
			)
		)
	)
	; Inserted by Ralston to give Louis PINK stuff
	(if Desc_1
		(progn
			(load (strcat _PATH-USER "SymColor"))
			(setq	Desc_1	nil)
		)
	)
	(if Bug (princ "\n{Custom4 Exited}\n"))
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(Cus4)
	(setq	LodVer	"1.50d")
)
