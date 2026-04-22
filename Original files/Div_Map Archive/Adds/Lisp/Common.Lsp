(if AppNam								; Code Version Indicator {362 Lines of Code}
	(princ (strcat "\n" AppNam " Common Loading."))
	(princ "\nAdds Common Loading.")
)

(defun C:Bug ( / )							; Toggles DeBugging Mode
; Function: Toggle deBugging by changing status of 'Bug' variable
	(if (setq Bug (not Bug))   ;--toggle <Bug> global var
		(progn
			(princ "\nDeBug Mode is now ENABLED.")
			(setq	*error*		olderr)
		)
		(progn
			(princ "\nDeBug Mode is now DISABLED.")
			(setq	*error*		S:err)
		)
	)
)

(defun S:err ( msg / )						; Error Handler
;****************************************************************************
;Function:  S:err
;Description:  Displays an error message and resets the system variables
;              back to the orignal setting, if the user cancels the program
;Arguments:  msg
;Globals:    md1, md2
;Revised:
;****************************************************************************
	(SSNIL)
	(setq	ErrEds	(getvar "ERRNO"))
	(cond	((= ErrEds 3)						;Exceeded maximum number of selection sets
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
				(if RWav
					(if SndPick02
						(RWav SndPick02)
						(RWav 28)
					)
				)
				(if (and AppNam AppMode)
					(SetLin AppNam AppMode)
				)
				(princ	(strcat	"\n>> DivMap - "
								AppNam
								" Error:\n"
								"====>> "
								msg
								" <<====\n"
								Blammo
								"\nAll Panel Saves Disabled - Exit the application"
						)
				)
				(if PanLst
					(setq	Bubba	(DelAllLck)
							Bubba	(alert	(strcat	">> DivMap - "
													AppNam
													" Error:\n"
													"====>> "
													msg
													" <<====\n"
													Blammo
													"\nAll Panel Saves Disabled - Exit the application"
											)
									)
					)
				)
			)
			((= lastcmd "BREAK")
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
			((= lastcmd "RUNPLD")
				(RUNPLD)
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
		((= (substr (getvar "ACADVER") 1 2) "15")	;	AutoCAD 2000
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
		((= (substr (getvar "ACADVER") 1 2) "14")	;	AutoCAD r14 February 1997
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
	;(command "_.Layer" "T" "*" "ON" "*" "U" "*" "S" "0" "" "_.Zoom" "E" "_.Zoom" "0.8x")
	(princ)
)

(defun Blks2Top ( /	allblks )				; Copies all blocks to top - DrawOrder issue
	(if (setq allblks (ssget "X" (list (cons 0 "INSERT"))))
		(command	"_.COPY"
				allblks
				""
				(list 0 0)
				(list 0 0)
				"_.ERASE"
				allblks
				""
		)
	)
)

(defun Cp_Au2 ( /	cpnum lname fdr ipt			; Auto-Inserts Computer Points
				pfent spt cpt m slope pos omod mp slopep plname hlfwth plthk ipt )
;  Function:  Automates the insertion of computer points
;             Requires user to enter each point number
	(if Bug (princ "\nCp_Au2 entered"))
	(if (or (not SF) (not SFF))
		(SetScale)
	)
	(princ "\n\n\n            <<<<<< Press <Ctrl>C to cancel... >>>>>>")
	(setq	SymLst	(SymSizN "CP")
			Gap		(nth 0 SymLst)
			Lngth	(nth 1 SymLst)
			SymNam	(nth 2 SymLst)
	)
	(initget 1 "F O")
	(if (= "O" (getkword "\n \nMake computer points Freestanding or On-line [F or O]? "))
		(while T
			(setq	PFLst	(PFindN nil))
			(if PFLst
				(setq	pfent	(nth 0 PFLst)
						spt		(nth 1 PFLst)
						cpt		(nth 2 PFLst)
						m		(nth 3 PFLst)
						slope	(nth 4 PFLst)
						mp		(nth 5 PFLst)
						slopep	(nth 6 PFLst)
						plname	(nth 7 PFLst)
						hlfwth	(nth 8 PFLst)
						plthk	(nth 9 PFLst)
						ipt		(nth 10 PFLst)
				)
				(progn
					(alert (strcat "**" AppNam " Error**\nNo Polydata passed"))
					(exit)
				)
			)
			(setq	lname	(strcat (substr plname 1 3) "-CP--" (substr plname 9 2)))
			(command	"_.LAYER"
					"T"
					lname
					"S"
					lname
					""
			)
			(setq	cpnum	(getstring "\n\nEnter the computer point number: "))
			(command	"INSERT"
					(strcat _PATH-SYM "CP")
					ipt
					(* Lngth sf)
					""
					slope
                        cpnum
			)
			(setthk (entget (entlast)))
			(Att-MR)
			(Drw_Arr nil)
		)
		(progn
			(setq	lname	(getlay "CK"))
			(setq	lname	(strcat (substr lname 1 3) "-CP--" (substr lname 9 2)))
			(command	"_.LAYER"
					"T"
					lname
					"S"
					lname
					""
			)
			(setq	fdr	(itoa (- (ascii (substr lname 3 1)) 64)))
			(setq	cptype	nil
					lname	nil
			)
			(while T
				(setq	ipt	(getpoint (strcat "\nPick insertion point...Feeder # " fdr)))
				(if ipt
					(progn
						(setq	cpnum	(getstring "\n\nEnter the computer point number: "))
						(command	"INSERT"
								(strcat _PATH-SYM "CP")
								ipt
								(* Lngth sf)
								""
								""
								cpnum
						)
						(setthk (entget (entlast)))
						(Att-MR)
						(Drw_Arr nil)
					)
				)
			)
		)
	)
)

(defun Diag ( /	scset ent now count )		; Generate diagnostics display and printout
	(princ "\n\n\n\n\n\n\n\n\n\n\n\n\n")
;	(textscr)  ;--switch screen display to text mode
	(princ "\nMake sure printer is ready, then press <Ctrl>Q ...")
	(princ "\nPress any key to continue ...\n")
	(read-char)
	(setq	now	(rtos (getvar "CDATE") 2 4))
	(princ 	(strcat	"\n\n"
					(substr now 5 2)
					"/"
					(substr now 7 2)
					"/"
					(substr now 3 2)
					"   "
					(substr now 10 2)
					":"
					(substr now 12 2)
					"\n"
			)
	)
	(princ "\n\nBASE QUAD:  ") (princ AttNamP)
	(princ "\n \nPanLst:\n") (princ PanLst)
  (princ "\n \nSCLIST:\n") (princ sclist)
  (princ "\n \nPanels and Scales in Drawing Database:")
  (if (setq scset (ssget "X" (list (cons 0 "ATTDEF") (cons 8 "----SC----"))))
    (progn
      (setq count 0)
      (while (setq ent (ssname scset count))
        (if (= 0 (rem count 2))
          (princ (strcat "\n" (cdr (assoc 2 (entget ent))) "...."
                               (cdr (assoc 1 (entget ent)))))
        ;else
          (princ (strcat (chr 9) (chr 9) (cdr (assoc 2 (entget ent))) "...."
                                          (cdr (assoc 1 (entget ent)))))
        )
        (setq count (1+ count))
      )
    )
  ;else
    (princ "\nnone found")
  )
  (princ "\n \n \nPress <Ctrl>Q again to turn printer off ...")
  (princ "\n  Press any key to continue ...\n \n \n") (read-char)
  (graphscr)   ;--switch screen display back to graphics mode
  (princ)
)

(defun C:DC ( /	BLK SYMLST SYMPT SYMSC ANG1	; Draws Lines under blocks
				ANG2 SYMLEN OLDPT1 OLDPT2 )
  (if (setq BLK (entsel "Select block to draw line under: "))
    (progn
      (setq SYMLST (entget (car BLK)))
      (if (= (cdr (assoc 0 SYMLST)) "INSERT")
        (progn
          (setq SYMPT (cdr (assoc 10 SYMLST))
                SYMSC (cdr (assoc 41 SYMLST))
                ANG1 (- (cdr (assoc 50 SYMLST)) pi)
                ANG2 (cdr (assoc 50 SYMLST))
                SYMLEN (* SYMSC 0.5)
                OLDPT1 (polar SYMPT ANG1 SYMLEN)
                OLDPT2 (polar SYMPT ANG2 SYMLEN))
          (command ".LINE" OLDPT1 OLDPT2 "")
        )
        (princ "Please select a block. ")
      )
    )
    (princ "No object selected...")
  )
)

(defun C:DE ( /	BLK SYMLST SYMPT SYMSC ANG	; Draws Lines under blocks
				ENDPT1 ENDPT2 )
  (if (setq BLK (entsel "Select block to draw line under: "))
    (progn
      (setq SYMLST (entget (car BLK)))
      (if (= (cdr (assoc 0 SYMLST)) "INSERT")
        (progn
          (setq SYMPT (cdr (assoc 10 SYMLST))
                SYMSC (cdr (assoc 41 SYMLST))
                ANG (cdr (assoc 50 SYMLST))
                ENDPT1 SYMPT
                ENDPT2 (polar SYMPT ANG SYMSC))
          (command ".LINE" ENDPT1 ENDPT2 "")
        )
        (princ "Please select a block. ")
      )
    )
    (princ "No object selected...")
  )
)

(setq	LodVer	"2.5.2g")


(defun SSNIL ( / x a)
  (mapcar
   '(lambda (x)(set x nil))
    (vl-remove-if-not
     '(lambda (a)(equal (type (eval a)) 'PICKSET))
      (atoms-family 0)
    )
  )
)
