(if AppNam								; Code Version Indicator 
	(princ (strcat "\n" AppNam " Util_One Loading."))
	(princ "\nCadet 2.1 Util_One Loading.")
)

(defun C:STL ( / LTe1 LTe2 )					; CL - Set Text Location
	(princ "\nSelect Loc Text: ")
	(setq	LTe1		(entsel)
			LTe2		(entget (car LTe1))
			LTins	(cdr (assoc 11 LTe2))
	)
	(princ)
)

(defun C:STD ( / LTe1 LTe2 )					; CL - Set Text Description
	(princ "\nSelect Desc Text: ")
	(setq	DTe1		(entsel)
			DTe2		(entget (car DTe1))
			DTins	(cdr (assoc 11 DTe2))
	)
	(princ)
)

(defun C:MTL ( / LTe1 LTe2 LTtmp )			; CL - Make Text Location
	(princ "\nSelect Loc Text: ")
	(setq	LTe1		(entsel)
			LTe2		(entget (car LTe1))
			LTtmp	(cdr (assoc 11 LTe2))
	)
	(if LTins
		(command "MOVE" (car LTe1) "" LTtmp LTins)
	)
	(princ)
)

(defun C:MTD ( / DTe1 DTe2 DTtmp )			; CL - Make Text Description
	(princ "\nSelect Desc Text: ")
	(setq	DTe1		(entsel)
			DTe2		(entget (car DTe1))
			DTtmp	(cdr (assoc 11 DTe2))
	)
	(if DTins
		(if (= (cdr (assoc 74 DTe2)) 2)
			(if (= (cdr (assoc 72 DTe2)) 2)
				(command	"MOVE"
						(car DTe1)
						""
						DTtmp
						(list (- (car DTins) 0.75) (cadr DTins))
				)
				(command	"MOVE"
						(car DTe1)
						""
						DTtmp
						(list (+ (car DTins) 0.75) (cadr DTins))
				)
			)
			(command "MOVE" (car DTe1) "" DTtmp DTins)
		)
	)
	(princ)
)

(defun C:LookSz ( / )						; CL - Look Up Text Size
	(if (not _Path-LUT)
		(setq	_Path-LUT	"J:\\DIV_MAP\\CADET20\\LUT\\")
	)
	(setq	Fn2		(open (strcat _Path-LUT "SYM_Prop.LUT") "r")
			In2		(read-line Fn2)
			In2It	(read (strcat "(" In2 ")"))
			In2Lst	(list In2It)
			ToLst	(cons (nth 1 In2It) (nth 5 In2It))
			SclLst	(list ToLst)
	)
	(while (setq In2 (read-line Fn2))
		(if In2
			(setq	In2It	(read (strcat "(" In2 ")"))
					ToLst	(cons (nth 1 In2It) (nth 5 In2It))
					SclLst	(cons ToLst SclLst)
			)
		)
	)
	(close Fn2)
	(setq	InSym	(strcat "1" (substr (getvar "DWGNAME") 2 2))
			SclIns	(atof (cdr (assoc InSym SclLst)))
			BigSz	(/ 0.1 SclIns)
			MidSz	(/ 0.08 SclIns)
			SmlSz	(/ 0.06 SclIns)
	)
	(princ (strcat "\nBig Text Size:   " (rtos BigSz 2 6) "\""))
	(princ (strcat "\nMid Text Size:   " (rtos MidSz 2 6) "\""))
	(princ (strcat "\nSmall Text Size: " (rtos SmlSz 2 6) "\""))
	(princ)
)

(defun C:MakBig ( / )						; CL - Apply Big Text Size
	(if (not BigSz)
		(C:LookSz)
	)
	(setq	Objs		(ssget))
	(if Objs
		(progn
			(setq	ObjLen	(sslength Objs)
					Cnt		0
			)
			(while (< Cnt ObjLen)
				(setq	e1	(ssname Objs Cnt)
						e2	(entget e1)
						pt0	(cdr (assoc 10 e2))
						pt1	(getpoint pt0 "\nSelect new insertion point: ")
						Cnt	(1+ Cnt)
				)
				(if	(and	(or	(= (cdr (assoc 0 e2)) "ATTDEF")
							(= (cdr (assoc 0 e2)) "TEXT")
						)
						(not	(equal (cdr (assoc 40 e2)) BigSz 0.01))
					)
					(progn
						(princ "\nChanging Height...")
						(setq	e2	(subst	(cons 40 BigSz)
											(assoc 40 e2)
											e2
									)
						)
						(entmod e2)
					)
				)
				(if	(and	(or	(= (cdr (assoc 0 e2)) "ATTDEF")
							(= (cdr (assoc 0 e2)) "TEXT")
						)
						(/= (cdr (assoc 72 e2)) 4)
					)
					(progn
						(princ "\nChanging Justification...")
						(setq	e2	(subst	(cons 72 4)
											(assoc 72 e2)
											e2
									)
						)
						(entmod e2)
					)
				)
				(progn
					(princ "\nChanging Placement...")
					(setq	e2	(subst	(cons 11 Pt1)
										(assoc 11 e2)
										e2
								)
					)
					(entmod e2)
				)
			)
		)
	)
	(princ)
)

(defun C:MakMid ( / )						; CL - Apply Mid Text Size
     (if (not MidSz)
	  (C:LookSz)
     )
     (setq Objs (ssget))
     (if Objs
	  (progn
	       (setq ObjLen (sslength Objs)
		     pt1    (getpoint "\nSelect new insertion point: ")
		     Cnt    0
	       )
	       (while (< Cnt ObjLen)
		    (setq e1  (ssname Objs Cnt)
			  e2  (entget e1)
			  pt0 (cdr (assoc 10 e2))
			  Cnt (1+ Cnt)
		    )
		    (if	(and (or (= (cdr (assoc 0 e2)) "ATTDEF")
				 (= (cdr (assoc 0 e2)) "TEXT")
			     )
			     (not (equal (cdr (assoc 40 e2))
					 MidSz
					 0.01
				  )
			     )
			)
			 (progn
			      (princ "\nChanging Height...")
			      (setq e2 (subst (cons 40 MidSz)
					      (assoc 40 e2)
					      e2
				       )
			      )
			      (entmod e2)
			 )
		    )
		    (if	(or (= (cdr (assoc 0 e2)) "ATTDEF")
			    (= (cdr (assoc 0 e2)) "TEXT")
			)
			 (progn
			      (princ "\nChanging Justification...")
			      (cond ((and (= (cdr (assoc 74 e2)) 2)
					  (= (cdr (assoc 72 e2)) 2)
				     )
				     (setq e2 (subst (cons 11
							   (polar Pt1
								  pi
								  0.75
							   )
						     )
						     (assoc 11 e2)
						     e2
					      )
				     )
				    )
				    ((and (= (cdr (assoc 74 e2)) 2)
					  (= (cdr (assoc 72 e2)) 0)
				     )
				     (setq e2 (subst (cons 11
							   (polar Pt1
								  0.0
								  0.75
							   )
						     )
						     (assoc 11 e2)
						     e2
					      )
				     )
				    )
				    ((and (= (cdr (assoc 74 e2)) 0)
					  (= (cdr (assoc 72 e2)) 4)
				     )
				     (setq e2 (subst (cons 11 Pt1)
						     (assoc 11 e2)
						     e2
					      )
				     )
				    )
				    (T
				     (setq e2 (subst (cons 72 4)
						     (assoc 72 e2)
						     e2
					      )
				     )
				     (setq e2 (subst (cons 74 0)
						     (assoc 74 e2)
						     e2
					      )
				     )
				     (setq e2 (subst (cons 11 Pt1)
						     (assoc 11 e2)
						     e2
					      )
				     )
				    )
			      )
			      (entmod e2)
			 )
		    )
	       )
	  )
     )
     (princ)
)

(defun C:MakSml ( / )						; CL - Apply Small Text Size
     (if (not SmlSz)
	  (C:LookSz)
     )
     (setq Objs (ssget))
     (if Objs
	  (progn
	       (setq ObjLen (sslength Objs)
		     Cnt    0
	       )
	       (while (< Cnt ObjLen)
		    (setq e1  (ssname Objs Cnt)
			  e2  (entget e1)
			  pt0 (cdr (assoc 10 e2))
			  pt1 (getpoint	pt0
					"\nSelect new insertion point: "
			      )
			  Cnt (1+ Cnt)
		    )
		    (if	(and (or (= (cdr (assoc 0 e2)) "ATTDEF")
				 (= (cdr (assoc 0 e2)) "TEXT")
			     )
			     (not (equal (cdr (assoc 40 e2))
					 SmlSz
					 0.01
				  )
			     )
			)
			 (progn
			      (princ "\nChanging Height...")
			      (setq e2 (subst (cons 40 SmlSz)
					      (assoc 40 e2)
					      e2
				       )
			      )
			      (entmod e2)
			 )
		    )
		    (if	(and (or (= (cdr (assoc 0 e2)) "ATTDEF")
				 (= (cdr (assoc 0 e2)) "TEXT")
			     )
			     (/= (cdr (assoc 72 e2)) 4)
			)
			 (progn
			      (princ "\nChanging Justification...")
			      (setq e2 (subst (cons 72 4)
					      (assoc 72 e2)
					      e2
				       )
			      )
			      (entmod e2)
			 )
		    )
		    (progn
			 (princ "\nChanging Placement...")
			 (setq e2 (subst (cons 11 Pt1)
					 (assoc 11 e2)
					 e2
				  )
			 )
			 (entmod e2)
		    )
	       )
	  )
     )
     (princ)
)

(defun C:MakTest ( /	Fn1 In1 InLst Fn2 In2	; Make Test Plot of Standard Symbols
					BoxLst FinLst BegLst EndLst PtLst NumAtt InX InY In2Lst )
	(if (not _Path-LUT)
		(setq	_Path-LUT	"J:\\CADET\\BASEMAP\\LUT\\")
	)
	(setq	Fn1		(open "C:\\TESTEM\\TESTEM.SCR" "r")
			Fn2		(open (strcat _Path-LUT "SYM_Name.LUT") "r")
			In1		(read-line Fn1)
			InLst	(list In1)
			In2		(read-line Fn2)
			In2It	(read (strcat "(" In2 ")"))
			In2Lst	(list In2It)
			DoLst	(cons (nth 1 In2It) (nth 4 In2It))
			ToLst	(cons (nth 1 In2It) (nth 5 In2It))
			UseLst	(list DoLst)
			SclLst	(list ToLst)
			CDia		(getvar "CMDECHO")
	)
	(setvar "CMDECHO" 0)
	(while (setq In1 (read-line Fn1))
		(if In1
			(setq	InLst	(cons In1 InLst))
		)
	)
     (while (setq In2 (read-line Fn2))
	  (if In2
	       (setq In2It  (read (strcat "(" In2 ")"))
		     DoLst  (cons (nth 1 In2It) (nth 4 In2It))
		     ToLst  (cons (nth 1 In2It) (nth 5 In2It))
		     UseLst (cons DoLst UseLst)
		     SclLst (cons ToLst SclLst)
		     In2Lst (cons In2It In2Lst)
	       )
	  )
     )
     (close Fn1)
     (close Fn2)
     (setq InLst  (reverse InLst)
	   BegLst (list "INSERT")
	   BoxLst (list "INSERT" "BOX")
	   EndLst (list "")
	   FinLst (list "" "" "")
	   PtLst  (list 0.0 0.0)
	   Scalar 5.0
	   OutLst (list "000")
     )
     (foreach x
		InLst
	  (setq	InDwg  (substr x 1 3)
		InSym  (strcat "1" (substr InDwg 2 2))
		UseStr (substr (cdr (assoc InSym UseLst)) 5 1)
		SclIns (* Scalar (atof (cdr (assoc InSym SclLst))))
		InX    (* 4.0 (atof (substr x 1 1)))
		InY    (if (or (= (substr InDwg 2 2) "05")
			       (= (substr InDwg 2 2) "69")
			   )
			    (* 4.0 (- 100.0 (- (atof (substr x 2 2)) 0.25)))
			    (* 4.0 (- 100.0 (atof (substr x 2 2))))
		       )
		InPt   (cond
			    ((= UseStr "C")
			     (list (strcat (rtos InX 2 4)
					   ","
					   (rtos InY 2 4)
				   )
			     )
			    )
			    ((= UseStr "L")
			     (list (strcat (rtos (- InX (* SclIns 0.5)) 2 4)
					   ","
					   (rtos InY 2 4)
				   )
			     )
			    )
			    ((= UseStr "B")
			     (list (strcat (rtos InX 2 4)
					   ","
					   (rtos (- InY (* SclIns 0.5)) 2 4)
				   )
			     )
			    )
			    (T
			     (list (strcat (rtos InX 2 4)
					   ","
					   (rtos InY 2 4)
				   )
			     )
			    )
		       )
		NumAtt (atoi (substr x 4 1))
		OutLst (cons
			    (append
				 BoxLst
				 (list (strcat (rtos InX 2 4)
					       ","
					       (rtos InY 2 4)
				       )
				 )
				 FinLst
				 BegLst
				 (list InDwg)
				 InPt
				 (list (rtos SclIns 2 4))
				 EndLst
				 (if (> NumAtt 0)
				      (cond ((= NumAtt 1)
					     (list "" "123")
					    )
					    ((= NumAtt 2)
					     (list "" "123" "123")
					    )
					    ((= NumAtt 3)
					     (list "" "123" "123" "123")
					    )
					    ((= NumAtt 4)
					     (list ""
						   "123"
						   "123"
						   "123"
						   "123"
					     )
					    )
					    ((= NumAtt 5)
					     (list ""
						   "123"
						   "123"
						   "123"
						   "123"
						   "123"
					     )
					    )
					    ((= NumAtt 6)
					     (list ""	   "123"
						   "123"   "123"
						   "123"   "123"
						   "123"
						  )
					    )
				      )
				      (list "")
				 )
			    )
			    OutLst
		       )
	  )
     )
     (if (> (length OutLst) 1)
	  (setq OutLst (cdr (reverse OutLst)))
	  (setq OutLst nil)
     )
     (if (and OutLst Ptit)
	  (setq	OutLst
		    (append
			 OutLst
			 (list
			      (list "PLOTID" "HP LaserJet 4-NR")
			      (list "PLOT" "W" "-2,402" "@38,-40" "0")
			      (list "PLOT" "W" "-2,362" "@38,-40" "0")
			      (list "PLOT" "W" "-2,322" "@38,-40" "0")
			      (list "PLOT" "W" "-2,282" "@38,-40" "0")
			      (list "PLOT" "W" "-2,242" "@38,-40" "0")
			      (list "PLOT" "W" "-2,202" "@38,-40" "0")
			      (list "PLOT" "W" "-2,162" "@38,-40" "0")
			      (list "PLOT" "W" "-2,122" "@38,-40" "0")
			      (list "PLOT" "W" "-2,082" "@38,-40" "0")
			      (list "PLOT" "W" "-2,042" "@38,-40" "0")
			 )
		    )
	  )
     )
     (if OutLst
	  (foreach x OutLst (mapcar (quote command) x))
     )
     (setvar "CMDECHO" CDia)
     (princ)
)

(defun C:CompLst ( /	UnqLst VarLst ExtLst	; Reads a file, compares and show diffs
					FunLst StrLst OutStr x MaxLen Cnt InDLst1 InDLst2
					InD1 Fn1 Fnam1 Fn3 Fnam3 Fn4 Fnam4 Fn5 Fnam5 )
	(setq	InDLst2	(atoms-family 1)
			Fnam1	"C:\\EDS\\ACAD.TXT"
			Fnam3	"C:\\EDS\\DIFF.TXT"
			Fn1		(open Fnam1 "r")
			Fn3		(open Fnam3 "w")
			InD1		(read-line Fn1)
			Cnt		0
			UnqLst 	(list "000")
	)
	(if InD1
		(setq	InDLst1	(list InD1)
				InD1		(read-line Fn1)
		)
     )
     (if InD1
	  (while InD1
	       (setq InDLst1 (cons InD1 InDLst1)
		     InD1    (read-line Fn1)
	       )
	  )
     )
     (close Fn1)
     (if (> (length InDLst1) (length InDLst2))
	  (repeat (length InDLst1)
	       (if (not (member (nth Cnt InDLst1) InDLst2))
		    (setq UnqLst (cons (nth Cnt InDLst1) UnqLst))
	       )
	       (setq Cnt (1+ Cnt))
	  )
	  (repeat (length InDLst2)
	       (if (not (member (nth Cnt InDLst2) InDLst1))
		    (setq UnqLst (cons (nth Cnt InDLst2) UnqLst))
	       )
	       (setq Cnt (1+ Cnt))
	  )
     )
     (if (> (length UnqLst) 1)
	  (setq	UnqLst (acad_strlsort (cdr (reverse UnqLst)))
		FunLst (FunVarStp UnqLst)
		VarLst (car FunLst)
		FunLst (cadr FunLst)
		MaxLen (strlen (car UnqLst))
	  )
	  (setq UnqLst nil)
     )
     (if UnqLst
	  (foreach x UnqLst
	       (if (> (strlen x) MaxLen)
		    (setq MaxLen (strlen x))
	       )
	  )
     )
     (if UnqLst
	  (setq MaxLen (+ MaxLen 5))
     )
     (if FunLst
	  (progn
	       (setq Fnam4 "C:\\Data\EdsFiles\\BaseFunc.TXT"
		     Fn4   (open Fnam4 "w")
	       )
	       (mapcar (list lambda
			     (x)
			     (write-line
				  (strcat x
					  (RepChar (chr 32)
						   (- MaxLen (strlen x))
					  )
					  "Function"
					  (RepChar (chr 32) 8)
				  )
				  Fn4
			     )
		       )
		       FunLst
	       )
	       (close Fn4)
	  )
     )
     (if VarLst
	  (progn
	       (setq Fnam5 "C:\\EDS\\BaseVars.TXT"
		     Fn5   (open Fnam5 "w")
	       )
	       (mapcar
		    (list lambda
			  (x)
			  (cond
			       ((= (type (eval (read x))) (quote ENAME))
				(setq
				     OutStr
					 (strcat x
						 (RepChar (chr 32)
							  (- MaxLen
							     (strlen x)
							  )
						 )
						 "Ename"
						 (RepChar (chr 32) 11)
					 )
				)
			       )
			       ((= (type (eval (read x))) (quote REAL))
				(setq
				     OutStr
					 (strcat x
						 (RepChar (chr 32)
							  (- MaxLen
							     (strlen x)
							  )
						 )
						 "Real"
						 (RepChar (chr 32) 12)
					 )
				)
			       )
			       ((= (type (eval (read x))) (quote INT))
				(setq
				     OutStr
					 (strcat x
						 (RepChar (chr 32)
							  (- MaxLen
							     (strlen x)
							  )
						 )
						 "Int"
						 (RepChar (chr 32) 13)
					 )
				)
			       )
			       ((= (type (eval (read x))) (quote STR))
				(setq
				     OutStr
					 (strcat x
						 (RepChar (chr 32)
							  (- MaxLen
							     (strlen x)
							  )
						 )
						 "String"
						 (RepChar (chr 32) 10)
					 )
				)
			       )
			       ((= (type (eval (read x))) (quote SYM))
				(setq
				     OutStr
					 (strcat x
						 (RepChar (chr 32)
							  (- MaxLen
							     (strlen x)
							  )
						 )
						 "Sym"
						 (RepChar (chr 32) 13)
					 )
				)
			       )
			       ((= (type (eval (read x))) (quote LIST))
				(if (= (type (car (eval (read x))))
				       (quote STR)
				    )
				     (setq OutStr
					       (strcat
						    x
						    (RepChar
							 (chr 32)
							 (- MaxLen (strlen x))
						    )
						    "List of Strings "
					       )
				     )
				)
				(if (= (type (car (eval (read x))))
				       (quote REAL)
				    )
				     (setq OutStr
					       (strcat
						    x
						    (RepChar
							 (chr 32)
							 (- MaxLen (strlen x))
						    )
						    "List of Reals"
						    (RepChar (chr 32) 3)
					       )
				     )
				)
				(if (= (type (car (eval (read x))))
				       (quote INT)
				    )
				     (setq OutStr
					       (strcat
						    x
						    (RepChar
							 (chr 32)
							 (- MaxLen (strlen x))
						    )
						    "List of Ints"
						    (RepChar (chr 32) 4)
					       )
				     )
				)
			       )
			       (T
				(setq
				     OutStr
					 (strcat x
						 (RepChar (chr 32)
							  (- MaxLen
							     (strlen x)
							  )
						 )
						 "Unknown"
					 )
				)
			       )
			  )
			  (write-line OutStr Fn5)
		    )
		    VarLst
	       )
	       (close Fn5)
	  )
     )
     (if UnqLst
	  (mapcar (list lambda (x) (write-line x Fn3)) UnqLst)
     )
     (close Fn3)
     (princ)
)

(defun DLG_Draw ( DoNam TxtH /	Fnam fWrk 	; Imports DLG listings, and paints a picture
							InData GoData Cnt ClrLst PtA PtB PtC PtD ClrDat )
	(if (setq Fnam (findfile DoNam))
		(progn
			(setq	fWrk		(open Fnam "r")
					InData	(read-line fWrk)
					GoData	(list (read (strcat "(" InData ")")))
			)
			(while (setq InData (read-line fWrk))
				(if InData
					(setq	GoData	(cons (read (strcat "(" InData ")")) GoData))
				)
			)
			(close fWrk)
		)
	)
	(if (not Mod)
		(load "Utils")
	)
	(setq	Cnt	0
			ClrLst	(list 51 61 71 81 91 101 111 121 131 141)
	)
	(if (> (length GoData) 1)
		(foreach	Rec
				GoData
				(setq	PtA		(list (nth 0 Rec) (nth 1 Rec))
						PtB		(list (nth 2 Rec) (nth 1 Rec))
						PtC		(list (nth 2 Rec) (nth 3 Rec))
						PtD		(list (nth 0 Rec) (nth 3 Rec))
						Ang		(angle PtA PtC)
						Dst		(distance PtA PtC)
						PtE		(polar PtA Ang (* 0.03 Dst))
						PtF		(polar PtA Ang (* 0.97 Dst))
						Cnt		(1+ Cnt)
						ClrDat	(nth (Mod Cnt 8) ClrLst)
				)
				(setvar "CECOLOR" (itoa ClrDat))
				(command "SOLID" PtA PtB PtD PtC "")
				(setvar "CECOLOR" "7")
				(command "TEXT" "J" "F" PtE PtF TxtH (nth 4 Rec))
		)
	)
	(princ)
)

(defun DLG_Rec ( / )						; One-of process of old DLG files
	(setvar "CMDECHO" 0)
	(setvar "FILEDIA" 0)
	(setvar "CMDDIA" 0)
	(setvar "GRIDMODE" 0)
	(setvar "SNAPMODE" 0)
	(setvar "ORTHOMODE" 0)
	(setvar "REGENMODE" 1)
	(setvar "OSMODE" 0)
	(setvar "EXPERT" 5)
	(command "UCSICON" "OFF")
	(if (not PadNum)
		(load "Utils")
	)
	(if (not Div)
		(setq	Div	"ALL")
	)
	(setq	LayNam	(tblnext "LAYER" T)
			LayLst	nil
	)
	(while (setq LayNam (tblnext "LAYER"))
		(if LayNam
			(setq	LayNam	(cdr (assoc 2 LayNam)))
		)
		(if LayNam
			(if LayLst
				(setq	LayLst	(cons LayNam LayLst))
				(setq	LayLst	(list LayNam))
			)
		)
	)
	(if (findfile (strcat "C:\\ADDS25\\" "DLG\\" Div "DLG_Lim.TXT"))
		(setq	fName	(findfile (strcat "C:\\ADDS25\\" "DLG\\" Div "DLG_Lim.TXT"))
				fOut		(open fName "a")
		)
		(setq	fName	(strcat "C:\\ADDS25\\" "DLG\\" Div "DLG_Lim.TXT")
				fOut		(open fName "w")
		)
	)
	(if fOut
		(progn
			(command	"_.LAYER" "T" "*" "ON" "*" "U" "*" "S" "0" "")
			(command "ZOOM" "E")
			(setq	ssTmp	(ssget "X" (list (cons 8 "0"))))
			(if ssTmp
				(command	"_.LAYER" "M" "DLG_TEMP" "" "CHPROP" ssTmp "" "LA" "DLG_TEMP" "")
			)
			(setq	DNam		(strcase (getvar "DWGNAME"))
					MinP		(getvar "EXTMIN")
					MaxP		(getvar "EXTMAX")
					MinX		(PadNum (rtos (car MinP) 2 2) 14)
					MinY		(PadNum (rtos (cadr MinP) 2 2) 14)
					MaxX		(PadNum (rtos (car MaxP) 2 2) 14)
					MaxY		(PadNum (rtos (cadr MaxP) 2 2) 14)
					DstA		(PadNum (rtos (distance MinP MaxP) 2 2) 14)
					OutP		(strcat	MinX
									MinY
									MaxX
									MaxY
									DstA
									"  "
									DNam
							)
			)
			(write-line OutP fOut)
			(close fOut)
		)
	)
	(foreach	LayNam
			LayLst
			(command "RENAME" "LA" LayNam (strcat "DLG_" LayNam))
	)
	(if (findfile (strcat "C:\\ADDS25\\" "DLG\\" Div "Lay_Lst.TXT"))
		(setq	fName	(findfile (strcat "C:\\ADDS25\\" "DLG\\" Div "Lay_Lst.TXT"))
				fLOut		(open fName "a")
		)
		(setq	fName	(strcat "C:\\ADDS25\\" "DLG\\" Div "Lay_Lst.TXT")
				fLOut		(open fName "w")
		)
	)
	(if fLOut
		(foreach	LayNam
				LayLst
				(if BigLaylst
					(if (not (assoc LayNam BigLayLst))
						(setq	OutP		(strcat (PadChar LayNam 25) "DLG_" LayNam)
								BigLayLst	(cons (cons LayNam (strcat "DLG_" LayNam)) BigLayLst)
						)
						(setq	OutP		nil)
					)
					(setq	OutP		(strcat (PadChar LayNam 25) "DLG_" LayNam)
							BigLayLst	(list (cons LayNam (strcat "DLG_" LayNam)))
					)
				)
				(if OutP
					(write-line OutP fLOut)
				)
		)
	)
	(if fLOut
		(close fLOut)
	)
	(setq Wnam (strcat "C:\\ADDS25\\" "DLG\\" Dnam))
	(princ (strcat "\nSaved as: " Wnam))
	(command "SAVEAS" "" (strcat "C:\\ADDS25\\" "DLG\\" Dnam))
	(setvar "FILEDIA" 1)
	(setvar "CMDDIA" 1)
	(if (= (getvar "USERI5") 0)
		(setvar "USERI5" 1)
		(setvar "USERI5" 0)
	)
	(princ)
)

(defun BlkTabTst ( nam / )					; Test function for dict work
	(setq	grp		(dictsearch (namedobjdict) "ACAD_GROUP"))
	(setq	g2		(dictsearch (cdr (assoc -1 grp)) "G2"))
	(tblobjname table-name symbol)
)

(defun C:TestFL ( /	AtLst Dnam SclFac SwLst	; Tests for unmatched FLs
					A1 S1 S2 S3 S4 S5 S6 S7 SaveIt )
	(if (not Jtod)
		(load "julian")
	)
	(if (= (getvar "USERI5") 99)
		(setq	SaveIt	T)
		(setq	SaveIt	nil)
	)
	(setq	AtLst	(ssget "X" (list (cons 0 "ATTDEF")(cons 8 "*SC*"))))
	(if AtLst
		(setq	A1		(entget (ssname AtLst 0))
				Dnam		(cdr (assoc 2 A1))
				SclFac	(atof (cdr (assoc 1 A1)))
				Fnam		"FL_Reprt.txt"
				FLst		(list "")
				GoodFL	T
		)
		(setq	Dnam		nil
				SclFac	nil
				Fnam		nil
		)
	)
	(if Fnam
		(if (findfile Fnam)
			(setq	FGo		(open (findfile Fnam) "a"))
			(setq	FGo		(open Fnam "w"))
		)
	)
	(if (and SclFac Dnam)
		(setq	HedDwg	(strcat "For Panel " Dnam " edited on " (rtos (jtod (getvar "tdupdate")) 2 4) " at scale 1\"=" (rtos SclFac 2 2) "meters"))
	)
	(setq	SwLst	(ssget "X" (list (cons 0 "INSERT")(cons 8 "*SW*"))))
	(if (and SwLst Dnam)
		(progn
			(setq	Cnt	0)
			(while (< Cnt (sslength SwLst))
				(setq	S1	(ssname SwLst Cnt))
				(if S1
					(setq	S2	(entget S1)
							S3	(cdr (assoc 10 S2))
							S4	(cdr (assoc 2 S2))
							S9	(cdr (assoc 41 S2))
							S8	(cdr (assoc 5 S2))
					)
					(setq	S2	nil)
				)
				(if S2
					(setq	S6	(ssget	"C"
										(list	(- (car S3) (* 0.1 S9))
												(- (cadr S3) (* 0.1 S9))
										)
										(list	(+ (car S3) (* 0.1 S9))
												(+ (cadr S3) (* 0.1 S9))
										)
										(list (cons 0 "*POLYLINE")(cons 8 "*FL*"))
								)
					)
					(setq	S6	nil)
				)
				(if S6
					(if (> (sslength S6) 1)
						(setq	S7		(entget (ssname S6 0))
								Bubba	(strcat "Found " (itoa (sslength S6)) " FLs for switch " S4 " (Handle " S8 ") at " (rtos (car S3) 2 2) "," (rtos (cadr S3) 2 2))
						)
						(setq	S7		(entget (ssname S6 0))
								Bubba	(strcat "Found FL for switch " S4 " (Handle " S8 ")")
						)
					)
					(if S4
						(setq	Bubba	(strcat "Found no FL for switch " S4 " (Handle " S8 ") at " (rtos (car S3) 2 2) "," (rtos (cadr S3) 2 2))
								GoodFL	nil
						)
						(setq	Bubba	(strcat "Found nothing at all"))
					)
				)
				(if Bubba (princ (strcat "\n" Bubba)))
				(if Bubba
					(setq	FLst		(append FLst (list Bubba)))
				)
				(setq	Cnt	(1+ Cnt))
			)
		)
	)
	(if (> (length FLst) 1)
		(setq	FLst		(cdr FLst))
		(setq	FLst		nil)
	)
	(if SaveIt
		(if GoodFL
			(progn
				(write-line HedDwg FGo)
				(princ "\nDrawing tested good...")
			)
			(if FLst
				(progn
					(write-line (strcat HedDwg " lacks FLs") FGo)
				)
				(write-line (strcat HedDwg " lacks FLs") FGo)
			)
		)
		(if GoodFL
			(princ (strcat "\nDrawing tested good..." HedDwg))
			(princ (strcat HedDwg " lacks FLs"))
		)
	)
	(if FGo
		(close FGo)
	)
	(princ)
)

(defun MakFL ( SS /	Cnt )				; Test FL maker
	(setq	Cnt	0)
	(while (< Cnt (sslength SS))
		(setq	e1	(ssname ss Cnt)
				e2	(entget e1)
				e3	(cdr (assoc 10 e2))
				e4	(cdr (assoc 41 e2))
				e5	(cdr (assoc 50 e2))
				e6	(cdr (assoc 8 e2))
		)
		(MkLay (strcat (substr e6 1 4) "FL-" (substr e6 8)))
		(command "PLINE" pt1 "W" (* 2 hlfwth) "" pt2 "")
		(setq	Cnt	(1+ Cnt))
	)
)

(defun C:FixFL ( /	AtFl Bubba AtLst Sym )		; Fixes unmatched FLs
										; SymLst PicLst AtSw 
	(command	"_.LAYER" "T" "*" "U" "*" "ON" "*" "S" "0" "" "ZOOM" "E")
	(setq	AtFl		(ssget "X" (list (cons 0 "*POLYLINE")(cons 8 "????FL*")))
			SymLst	nil
			AtLst	nil
	)
	(if AtFl
		(setq	Bubba	(princ (strcat "\nErasing " (itoa (sslength AtFl)) " fill lines..."))
				Bubba	(command "_.ERASE" AtFl "")
		)
	)
	(setq	AtLst	(mapcar (quote (lambda (x) (cons x (car (SymSizN x))))) Lst_Sp_Sn))
	(if AtLst
		(if (> (length AtLst) 1)
			(foreach	Sym
					AtLst
					(if (cdr Sym)
						(if (= (cdr Sym) "M")
							(if SymLst
								(if (not (member (car Sym) SymLst))
									(setq	SymLst	(cons (car Sym) SymLst))
								)
								(setq	SymLst	(list (car Sym)))
							)
						)
					)
			)
		)
	)
	(setq	PicLst	(mapcar (quote (lambda (x) (cons 2 x))) SymLst)
			PicLst	(cons (cons -4 "<OR") PicLst)
			PicLst	(append PicLst (list (cons -4 "OR>")))
	)
	(setq	AtSw		(ssget "X" PicLst))
	(if AtSw
		(if (> (sslength AtSw) 0)
			(MakFL AtSw)
		)
	)
	(princ)
)

(defun C:UpdKwLst ( /	FN1 FN2 FN3 FGet1 FGet2	; Loads, compares and writes User Keyword files
					FGet3 FGet4 InData Bubba StrOut StrStp StrGo )
	(setq	FN1		"H:\\CodeWright\\Projects\\Lsp1.kwd"
			FN2		"H:\\CodeWright\\Projects\\User1.kwd"
	)
	(if (not FLspData)
		(setq	FGet1	(open FN1 "r")
				InData	(read-line FGet1)
				FLspData	(list (strcase InData))
				Bubba	(princ "\n.")
				Bubba	(while InData
							(setq	InData	(read-line FGet1)
									Bubba2	(princ ".")
							)
							(if InData
								(setq	FLspData	(cons (strcase InData) FLspData))
							)
						)
				Bubba	(close FGet1)
				Bubba	(princ ".\nLoad Complete\n")
		)
	)
	(if (findfile FN2)
		(setq	FGet2	(open FN2 "r")
				InData	(read-line FGet2)
				ULspData	(list (strcase InData))
				Bubba	(princ "\n+")
				Bubba	(while InData
							(setq	InData	(read-line FGet2)
									Bubba2	(princ "+")
							)
							(if InData
								(setq	ULspData	(cons (strcase InData) ULspData))
							)
						)
				Bubba	(close FGet2)
				Bubba	(princ "+\nLoad Complete\n")
		)
	)
	(setq	FN3		(getfiled	"Name of Lisp File"
							"h:/div_map/common/"
							"lsp"
							10
					)
	)
	(if FN3
		(if (findfile FN3)
			(setq	FGet3	(open FN3 "r")
					InData	(read-line FGet3)
					NLspData	(list (strcase InData))
					Bubba	(princ "\n#")
					Bubba	(while InData
								(setq	InData	(read-line FGet3)
										Bubba2	(princ "#")
								)
								(if InData
									(setq	NLspData	(cons (strcase InData) NLspData))
								)
							)
					Bubba	(close FGet3)
					Bubba	(princ "#\nLoad Complete\n")
			)
		)
	)
	(foreach	StrOut
			NLspData
			(setq	StrStp	(StpKwdLin StrOut))
			(if (nth 0 StrStp)
				(if (>= (strlen (nth 0 StrStp)) 1)
					(TstULspData (StpDot (nth 0 StrStp)))
				)
			)
			(if (nth 1 StrStp)
				(if (>= (strlen (nth 1 StrStp)) 1)
					(TstULspData (StpDot (nth 1 StrStp)))
				)
			)
			(if (nth 2 StrStp)
				(if (>= (strlen (nth 2 StrStp)) 1)
					(TstULspData (StpDot (nth 2 StrStp)))
				)
			)
			(if (nth 3 StrStp)
				(if (>= (strlen (nth 3 StrStp)) 1)
					(TstULspData (StpDot (nth 3 StrStp)))
				)
			)
	)
	(if ULspData
		(setq	ULspData	(acad_strlsort ULspData))
	)
	(if ULspData
		(setq	FGet4	(open FN2 "w")
				Bubba	(princ "\n$")
				Bubba	(foreach	StrGo
								ULspData
								(write-line StrGo FGet4)
								(setq	Bubba2	(princ "$"))
						)
				Bubba	(close FGet4)
				Bubba	(princ "$\nWrite Complete\n")
		)
	)
	(princ)
)


(defun TstULspData ( StrInp /	)			;Tests strings for membership, then includes them
	(if (not (member StrInp FLspData))
		(if (and StrInp ULspData)
			(if (not (member StrInp ULspData))
				(setq	ULspData	(cons StrInp ULspData)
						Bubba	(if Bug (princ (strcat "\n{" StrInp "}")))
				)
			)
			(if StrInp
				(setq	ULspData	(list StrInp)
						Bubba	(if Bug (princ (strcat "\n{" StrInp "}")))
				)
			)
		)
		(if Bug (princ (strcat "\n[" StrInp "]")))
	)
)

(defun SeqColrNum ( Num /	ColrNum )			;Selects Sequential Color Numbers
	(if Bug (princ "\n{SeqColrNum entered\n"))
	(setq	ColrNum	(+ 11 Num))
	(cond
		((>= ColrNum 246)
			(setq	ColrNum	1)
		)
		((= (substr (itoa ColrNum) (strlen (itoa ColrNum))) "6")
			(setq	ColrNum	(+ ColrNum 4))
		)
		((= ColrNum 7)
			(setq	ColrNum	8)
		)
	)
	(if Bug (princ "\nSeqColrNum exited}\n"))
	ColrNum
)

(defun C:ShowLL ( / )						;Generates Lat-Long value for selected point
	(setq currProj (ade_projgetwscode))
	(if (or (not currProj) (= currProj ""))
		(progn
			(princ "\nNo coordinate system set.  Assuming Lat Long (LL).")
			(setq currProj "LL")
		)
	)
	(ade_projsetsrc currProj)
	(ade_projsetdest "LL")
	(initget 1)
	(setq	base_pt	(getpoint "\nEnter point to project: "))
	(setq	result	(proj_ptforward base_pt))
	(princ "\n")
	(princ (proj_formatcoord result))
	(princ)
)

(defun StpKwdLin ( StrOne /	StrL Cnt			;Strips function Names from file
						MkOne MkOneT MkOneS
						MkTwo MkTwoT MkTwoS
						MkThree MkThreeT MkThreeS
						MkFour MkFourT MkFourS )
	(setq	StrL		(strlen StrOne)
			Cnt		1
	)
	(repeat (- StrL Cnt)
		(if (and (not MkOne) (= (substr StrOne Cnt 1) "("))
			(setq	MkOne	Cnt)
		)
		(if (and (> Cnt MkOne) (not MkTwo) (= (substr StrOne Cnt 1) "("))
			(setq	MkTwo	Cnt)
		)
		(if (and MkTwo (> Cnt MkTwo) (not MkThree) (= (substr StrOne Cnt 1) "("))
			(setq	MkThree	Cnt)
		)
		(if (and MkThree (> Cnt MkThree) (not MkFour) (= (substr StrOne Cnt 1) "("))
			(setq	MkFour	Cnt)
		)
		(setq	Cnt	(1+ Cnt))
	)
	(if MkOne
		(setq	Cnt		(1+ MkOne)
				Bubba	(while (and (<= Cnt StrL) (not MkOneT))
							(if (or (= (substr StrOne Cnt 1) " ") (= (substr StrOne Cnt 1) "\t"))
								(setq	MkOneT	Cnt)
							)
							(setq	Cnt	(1+ Cnt))
						)
				Bubba	(if MkOneT
							(setq	MkOneT	(1- MkOneT))
							(setq	MkOneT	StrL)
						)
				MkOneS	(strcase (substr StrOne (1+ MkOne) (- MkOneT MkOne)))
		)
		(setq	MkOneS	"")
	)
	(if MkTwo
		(setq	Cnt		(1+ MkTwo)
				Bubba	(while (and (<= Cnt StrL) (not MkTwoT))
							(if (or (= (substr StrOne Cnt 1) " ") (= (substr StrOne Cnt 1) "\t"))
								(setq	MkTwoT	Cnt)
							)
							(setq	Cnt	(1+ Cnt))
						)
				Bubba	(if MkTwoT
							(setq	MkTwoT	(1- MkTwoT))
							(setq	MkTwoT	StrL)
						)
				MkTwoS	(strcase (substr StrOne (1+ MkTwo) (- MkTwoT MkTwo)))
		)
		(setq	MkTwoS	"")
	)
	(if MkThree
		(setq	Cnt		(1+ MkThree)
				Bubba	(while (and (<= Cnt StrL) (not MkThreeT))
							(if (or (= (substr StrOne Cnt 1) " ") (= (substr StrOne Cnt 1) "\t"))
								(setq	MkThreeT	Cnt)
							)
							(setq	Cnt	(1+ Cnt))
						)
				Bubba	(if MkThreeT
							(setq	MkThreeT	(1- MkThreeT))
							(setq	MkThreeT	StrL)
						)
				MkThreeS	(strcase (substr StrOne (1+ MkThree) (- MkThreeT MkThree)))
		)
		(setq	MkThreeS	"")
	)
	(if MkFour
		(setq	Cnt		(1+ MkFour)
				Bubba	(while (and (<= Cnt StrL) (not MkFourT))
							(if (or (= (substr StrOne Cnt 1) " ") (= (substr StrOne Cnt 1) "\t"))
								(setq	MkFourT	Cnt)
							)
							(setq	Cnt	(1+ Cnt))
						)
				Bubba	(if MkFourT
							(setq	MkFourT	(1- MkFourT))
							(setq	MkFourT	StrL)
						)
				MkFourS	(strcase (substr StrOne (1+ MkFour) (- MkFourT MkFour)))
		)
		(setq	MkFourS	"")
	)
	(list MkOneS MkTwoS MkThreeS MkFourS)
)

(defun C:CleanFdr ( / )						;Processes DWG for Feeder-Only purposes
	(if (not Div)
		(DivPretend "E_")
	)
	(if (not Lst_Fd_B)
		(progn
			(load "Tables")
			(tables)
		)
	)
	(setvar "CMDECHO" 0)
	(setvar "EXPERT" 5)
	(setvar "CMDDIA" 0)
	(setvar "FILEDIA" 0)
	(setq	FdrNum	nil
			Pntr		nil
			Cntr		0
			FdrCod	nil
			FdrNum	(substr (getvar "DWGNAME") 3)
			FdrNum	(substr FdrNum 1 (- (strlen FdrNum) 4))
	)
	(if (member FdrNum Lst_Fd_B)
		(setq	Pntr		(- (length Lst_Fd_B) (length (member FdrNum Lst_Fd_B)))
				FdrCod	(nth Pntr Lst_Fd_V)
		)
	)
	(if FdrCod
		(progn
			(princ (strcat "\nFound Breaker Num:{" FdrNum "} with Code:{" FdrCod "}\n"))
			(command "_.Zoom" "E")
			(setq	ssGood	(ssget "X"	(list	(cons -4 "<OR")
													(cons 8 (strcat FdrCod "[OU]CK-###"))
													(cons 8 (strcat FdrCod "[OU]FL-###"))
												(cons -4 "OR>")
												(cons 0 "*POLYLINE")
										)
							)
			)
			(if ssGood
				(princ (strcat "\nKeeping {" (itoa (sslength ssGood)) "} circuit items.\n"))
			)
			(if ssGood
				(command "_.Erase" "All" "R" ssGood "" "_.Purge" "A" "*" "N" "_.Zoom" "E")
			)
		)
	)
	(setq	ssFill	(ssget "X"	(list	(cons 8 "????FL?###")
										(cons 0 "*POLYLINE")
								)
					)
	)
	(if ssFill
		(repeat (sslength ssFill)
			(setq	e1	(ssname ssFill Cntr)
					e2	(entget e1 '("*"))
					e3	(cdr (assoc 8 e2))
					e4	(subst	(cons 8 (strcat (substr e3 1 4) "CK" (substr e3 7)))
								(assoc 8 e2)
								e2
						)
					bub	(princ (strcat "\nChanging item {" (itoa Cntr) "} from {" e3 "} to {" (substr e3 1 4) "CK" (substr e3 7) "}\n"))
					e5	(entmod e4)
					e5	(entupd e1)
					Cntr	(1+ Cntr)
			)
		)
	)
	(command "_.Purge" "A" "*" "N")
	(command "_.Purge" "A" "*" "N")
	(command "_.WBLOCK" (strcat "C:\\Data\\temp\\" FdrNum) "*" "N")
	(setvar "CMDECHO" 1)
	(setvar "CMDDIA" 1)
	(setvar "FILEDIA" 1)
	(setvar "EXPERT" 0)
	(princ)
)

(defun QueryAndTrans ( _Path_In _Path_Out Dwg_Lst Action Target / )			;ADE Queries multiple drawings, generates DXF files
	(setvar "CMDECHO" 0)
	(setvar "EXPERT" 5)
	(setvar "CMDDIA" 0)
	(setvar "FILEDIA" 0)
	(princ (strcat "\nGot {" (itoa (length Dwg_Lst)) "} dwgs to work!\n"))
	(mapcar (quote ade_dwgdeactivate) (ade_dslist))
	(ade_prefsetval "DontAddObjectsToSaveSet" T)
	(setq ade_2tmpprefval (ade_prefgetval "MkSelSetWithQryObj"))
	(ade_prefsetval "MkSelSetWithQryObj" T)
	(setq ade_tmpprefval (ade_prefgetval "ActivateDwgsOnAttach"))
	(ade_prefsetval "ActivateDwgsOnAttach" T)
	(if Target
		(ade_projsetwscode "UTM83-16F")
		(ade_projsetwscode "UTM27-16")
	)
	(foreach	DNam
			Dwg_Lst
			(princ (strcat "\nQuerying:{" _Path_In DNam ".DWG}"))
			(mapcar (quote ade_dwgdeactivate) (ade_dslist))
			(setq dwg_id (ade_dsattach (strcat _Path_In DNam ".DWG")))
			(ade_prefsetval "ActivateDwgsOnAttach" ade_tmpprefval)
			(ade_qryclear)
			(ade_qrysettype "draw")
			(ade_qrydefine '("" "" "" "Location" ("all" )""))
			(ade_qrysetaltprop T)
			(ade_altpclear)
			(ade_altpdefine "Color" "256")
			(ade_qryexecute)
			(command "_.Zoom" "E")
			(cond
				((= Action 1)
					(command "_.Dxfout" (strcat _Path_Out DNam ".dxf") "6")
				)
				((= Action 2)
					(command "_.Wblock" (strcat _Path_Out DNam) "" "0,0" "All" "" "N")
				)
			)
			(command "_.Erase" "All" "")
	)
	(setvar "CMDECHO" 1)
	(setvar "CMDDIA" 1)
	(setvar "FILEDIA" 1)
	(setvar "EXPERT" 0)
	(princ)
)

(defun C:CktMakQ ( /	ChewzR DTstDiv			; CL - Query Local Panels ;DTstLst
					DDivNam DTstNam DPthIn DPthOut MM_Was
					U1_Was U2_Was U3_Was U4_Was U5_Was )
	(if (not ChgPlWidths)
		(cond
			((and (= (getvar "ACADVER") "15.06") (findfile "C:\\Program Files\\Autodesk\\ACADMAP5\\Express\\MPedit.Lsp"))
				(princ "\n=>Loading MPedit for Map 5 {Acad 2002}...\n")
				(load "C:\\Program Files\\Autodesk\\ACADMAP4\\Express\\MPedit")
			)
			((and (= (getvar "ACADVER") "15.0") (findfile "C:\\Program Files\\Autodesk\\ACADMAP4\\Express\\MPedit.Lsp"))
				(princ "\n=>Loading MPedit for Map 4 {Acad 2000}...\n")
				(load "C:\\Program Files\\Autodesk\\ACADMAP4\\Express\\MPedit")
			)
			((and (= (getvar "ACADVER") "14.0") (findfile "C:\\Program Files\\Autodesk\\ACADMAP2\\BONUS\\CADTOOLS\\MPedit.Lsp"))
				(princ "\n=>Loading MPedit for Map 2 {Acad 14}...\n")
				(load "C:\\Program Files\\Autodesk\\ACADMAP2\\BONUS\\CADTOOLS\\MPedit")
			)
		)
	)
	(setq	Min_Div	0
			Max_Div	9
			Min_Act	1
			Max_Act	13
			ChewzR	(getint (strcat "\nWhat Division to Process? <" (itoa Min_Div) "-" (itoa Max_Div) ">: "))
			ChewzA	(getint (strcat "\nWhat Action to Take? <" (itoa Min_Act) "-" (itoa Max_Act) ">: "))
			MM_Was	(getvar "MODEMACRO")
			U1_Was	(getvar "USERS1")
			U2_Was	(getvar "USERS2")
			U3_Was	(getvar "USERS3")
			U4_Was	(getvar "USERS4")
			U5_Was	(getvar "USERS5")
	)
	(if (not ChewzR)
		(setq	ChewzR	1)
		(if (or (< ChewzR Min_Div) (> ChewzR Max_Div))
			(setq	ChewzR	1
					Bubba	(princ "\nDivision reset to 1...\n")
			)
		)
	)
	(if (not ChewzA)
		(setq	ChewzA	12
				Bubba	(princ "\nAction reset to 12...\n")
		)
		(if (or (< ChewzA Min_Act) (> ChewzA Max_Act))
			(setq	ChewzA	12
					Bubba	(princ "\nAction reset to 12...\n")
			)
		)
	)
	(if (= ChewzA 9)
		(setq	PanLNam	(getstring "\nWhat Panel Name?: "))
	)
	(if (= ChewzA 9)
		(if (not PanLNam)
			(setq	PanLNam	"Bham_99")
		)
	)
	(if (and Bug ChewzA ChewzR)
		(setq	ChewzA	(getint (strcat "\nChewzA value <" (itoa ChewzA) ">: ")))
	)
	(if ChewzR
		(cond
			((= ChewzR 0)	;StateWide
				(setq	DTstDiv	"Adds_BH"
						DDivNam	"StateWide"
						DTstNam	(strcat "Ckt_" DDivNam)
						DShrLst	(GetShrLst ChewzR nil)
						DTstLst	(dos_dir (strcat "C:\\MapQry\\" DTstDiv "\\" "*.dwg"))
				)
				(if DTstLst
					(setq	DTstLst	(mapcar (quote (lambda (x) (strcat "C:\\MapQry\\" DTstDiv "\\" x))) DTstLst))
				)
				(setq	DTst2Div	"Adds_E_"
						DTst2Lst	(dos_dir (strcat "C:\\MapQry\\" DTst2Div "\\" "*.dwg"))
				)
				(if DTst2Lst
					(setq	DTst2Lst	(mapcar (quote (lambda (x) (strcat "C:\\MapQry\\" DTst2Div "\\" x))) DTst2Lst))
				)
				(if (and DTst2Lst DTstLst)
					(setq	DTstLst	(append DTstLst DTst2Lst))
				)
				(setq	DTst3Div	"Adds_W_"
						DTst3Lst	(dos_dir (strcat "C:\\MapQry\\" DTst3Div "\\" "*.dwg"))
				)
				(if DTst3Lst
					(setq	DTst3Lst	(mapcar (quote (lambda (x) (strcat "C:\\MapQry\\" DTst3Div "\\" x))) DTst3Lst))
				)
				(if (and DTst3Lst DTstLst)
					(setq	DTstLst	(append DTstLst DTst3Lst))
				)
				(setq	DTst4Div	"Adds_S_"
						DTst4Lst	(dos_dir (strcat "C:\\MapQry\\" DTst4Div "\\" "*.dwg"))
				)
				(if DTst4Lst
					(setq	DTst4Lst	(mapcar (quote (lambda (x) (strcat "C:\\MapQry\\" DTst4Div "\\" x))) DTst4Lst))
				)
				(if (and DTst4Lst DTstLst)
					(setq	DTstLst	(append DTstLst DTst4Lst))
				)
				(setq	DTst5Div	"Adds_SE"
						DTst5Lst	(dos_dir (strcat "C:\\MapQry\\" DTst5Div "\\" "*.dwg"))
				)
				(if DTst5Lst
					(setq	DTst5Lst	(mapcar (quote (lambda (x) (strcat "C:\\MapQry\\" DTst5Div "\\" x))) DTst5Lst))
				)
				(if (and DTst5Lst DTstLst)
					(setq	DTstLst	(append DTstLst DTst5Lst))
				)
				(setq	DTst6Div	"Adds_M_"
						DTst6Lst	(dos_dir (strcat "C:\\MapQry\\" DTst6Div "\\" "*.dwg"))
				)
				(if DTst6Lst
					(setq	DTst6Lst	(mapcar (quote (lambda (x) (strcat "C:\\MapQry\\" DTst6Div "\\" x))) DTst6Lst))
				)
				(if (and DTst6Lst DTstLst)
					(setq	DTstLst	(append DTstLst DTst6Lst))
				)
				(setq	DTst0Div	"Adds_SH"
						DShrLst	(dos_dir (strcat "C:\\MapQry\\" DTst0Div "\\" "*.dwg"))
				)
				(if DShrLst
					(setq	DShrLst	(mapcar (quote (lambda (x) (strcat "C:\\MapQry\\" DTst0Div "\\" x))) DShrLst))
				)
				(if (and DShrLst DTstLst)
					(setq	DTstLst	(append DTstLst DShrLst))
				)
				(setq	DTstDiv	"Adds_StateWide")
				(if (findfile (strcat "C:\\MapQry\\AddsOut\\" DTstNam ".dwg"))
					(dos_delete (strcat "C:\\MapQry\\AddsOut\\" DTstNam ".dwg"))
				)
			)
			((= ChewzR 1)	;Bham
				(setq	DTstDiv	"Adds_BH"
						DDivNam	"Bham"
						DTstNam	(strcat "Ckt_" DDivNam)
						DShrLst	(GetShrLst ChewzR nil)
						DTstLst	(dos_dir (strcat "C:\\MapQry\\" DTstDiv "\\" "*.dwg"))
				)
				(if DTstLst
					(setq	DTstLst	(mapcar (quote (lambda (x) (strcat "C:\\MapQry\\" DTstDiv "\\" x))) DTstLst))
				)
				(if DShrLst
					(foreach	DoNam
							DShrLst
							(setq	DTstLst	(append DTstLst (list (strcat "C:\\MapQry\\Adds_SH\\" DoNam))))
					)
				)
				(if (findfile (strcat "C:\\MapQry\\AddsOut\\" DTstNam ".dwg"))
					(dos_delete (strcat "C:\\MapQry\\AddsOut\\" DTstNam ".dwg"))
				)
			)
			((= ChewzR 2)	;East
				(setq	DTstDiv	"Adds_E_"
						DDivNam	"East"
						DTstNam	(strcat "Ckt_" DDivNam)
						DShrLst	(GetShrLst ChewzR nil)
						DTstLst	(dos_dir (strcat "C:\\MapQry\\" DTstDiv "\\" "*.dwg"))
				)
				(if DTstLst
					(setq	DTstLst	(mapcar (quote (lambda (x) (strcat "C:\\MapQry\\" DTstDiv "\\" x))) DTstLst))
				)
				(if DShrLst
					(foreach	DoNam
							DShrLst
							(setq	DTstLst	(append DTstLst (list (strcat "C:\\MapQry\\Adds_SH\\" DoNam))))
					)
				)
				(if (findfile (strcat "C:\\MapQry\\AddsOut\\" DTstNam ".dwg"))
					(dos_delete (strcat "C:\\MapQry\\AddsOut\\" DTstNam ".dwg"))
				)
			)
			((= ChewzR 3)	;South
				(setq	DTstDiv	"Adds_S_"
						DDivNam	"South"
						DTstNam	(strcat "Ckt_" DDivNam)
						DShrLst	(GetShrLst ChewzR nil)
						DTstLst	(dos_dir (strcat "C:\\MapQry\\" DTstDiv "\\" "*.dwg"))
				)
				(if DTstLst
					(setq	DTstLst	(mapcar (quote (lambda (x) (strcat "C:\\MapQry\\" DTstDiv "\\" x))) DTstLst))
				)
				(if DShrLst
					(foreach	DoNam
							DShrLst
							(setq	DTstLst	(append DTstLst (list (strcat "C:\\MapQry\\Adds_SH\\" DoNam))))
					)
				)
				(if (findfile (strcat "C:\\MapQry\\AddsOut\\" DTstNam ".dwg"))
					(dos_delete (strcat "C:\\MapQry\\AddsOut\\" DTstNam ".dwg"))
				)
			)
			((= ChewzR 4)	;West
				(setq	DTstDiv	"Adds_W_"
						DDivNam	"West"
						DTstNam	(strcat "Ckt_" DDivNam)
						DShrLst	(GetShrLst ChewzR nil)
						DTstLst	(dos_dir (strcat "C:\\MapQry\\" DTstDiv "\\" "*.dwg"))
				)
				(if DTstLst
					(setq	DTstLst	(mapcar (quote (lambda (x) (strcat "C:\\MapQry\\" DTstDiv "\\" x))) DTstLst))
				)
				(if DShrLst
					(foreach	DoNam
							DShrLst
							(setq	DTstLst	(append DTstLst (list (strcat "C:\\MapQry\\Adds_SH\\" DoNam))))
					)
				)
				(if (findfile (strcat "C:\\MapQry\\AddsOut\\" DTstNam ".dwg"))
					(dos_delete (strcat "C:\\MapQry\\AddsOut\\" DTstNam ".dwg"))
				)
			)
			((= ChewzR 5)	;Mobile
				(setq	DTstDiv	"Adds_M_"
						DDivNam	"Mobile"
						DTstNam	(strcat "Ckt_" DDivNam)
						DShrLst	(GetShrLst ChewzR nil)
						DTstLst	(dos_dir (strcat "C:\\MapQry\\" DTstDiv "\\" "*.dwg"))
				)
				(if DTstLst
					(setq	DTstLst	(mapcar (quote (lambda (x) (strcat "C:\\MapQry\\" DTstDiv "\\" x))) DTstLst))
				)
				(if DShrLst
					(foreach	DoNam
							DShrLst
							(setq	DTstLst	(append DTstLst (list (strcat "C:\\MapQry\\Adds_SH\\" DoNam))))
					)
				)
				(if (findfile (strcat "C:\\MapQry\\AddsOut\\" DTstNam ".dwg"))
					(dos_delete (strcat "C:\\MapQry\\AddsOut\\" DTstNam ".dwg"))
				)
			)
			((= ChewzR 6)	;SoEast
				(setq	DTstDiv	"Adds_SE"
						DDivNam	"SoEast"
						DTstNam	(strcat "Ckt_" DDivNam)
						DShrLst	(GetShrLst ChewzR nil)
						DTstLst	(dos_dir (strcat "C:\\MapQry\\" DTstDiv "\\" "*.dwg"))
				)
				(if DTstLst
					(setq	DTstLst	(mapcar (quote (lambda (x) (strcat "C:\\MapQry\\" DTstDiv "\\" x))) DTstLst))
				)
				(if DShrLst
					(foreach	DoNam
							DShrLst
							(setq	DTstLst	(append DTstLst (list (strcat "C:\\MapQry\\Adds_SH\\" DoNam))))
					)
				)
				(if (findfile (strcat "C:\\MapQry\\AddsOut\\" DTstNam ".dwg"))
					(dos_delete (strcat "C:\\MapQry\\AddsOut\\" DTstNam ".dwg"))
				)
			)
			((= ChewzR 7)	;Share
				(setq	DTstDiv	"Adds_SH"
						DDivNam	"Share"
						DTstNam	(strcat "Ckt_" DDivNam)
						DTstLst	(dos_dir (strcat "C:\\MapQry\\" DTstDiv "\\" "*.dwg"))
				)
				(if (findfile (strcat "C:\\MapQry\\AddsOut\\" DTstNam ".dwg"))
					(dos_delete (strcat "C:\\MapQry\\AddsOut\\" DTstNam ".dwg"))
				)
			)
			((= ChewzR 8)	;North
				(setq	DTstDiv	"Adds_BH"
						DDivNam	"North"
						DTstNam	(strcat "Ckt_" DDivNam)
						DShrLst	(GetShrLst ChewzR nil)
						DTstLst	(dos_dir (strcat "C:\\MapQry\\" DTstDiv "\\" "*.dwg"))
				)
				(if DTstLst
					(setq	DTstLst	(mapcar (quote (lambda (x) (strcat "C:\\MapQry\\" DTstDiv "\\" x))) DTstLst))
				)
				(setq	DTst2Div	"Adds_E_"
						DTst2Lst	(dos_dir (strcat "C:\\MapQry\\" DTst2Div "\\" "*.dwg"))
				)
				(if DTst2Lst
					(setq	DTst2Lst	(mapcar (quote (lambda (x) (strcat "C:\\MapQry\\" DTst2Div "\\" x))) DTst2Lst))
				)
				(if (and DTst2Lst DTstLst)
					(setq	DTstLst	(append DTstLst DTst2Lst))
				)
				(setq	DTst3Div	"Adds_W_"
						DTst3Lst	(dos_dir (strcat "C:\\MapQry\\" DTst3Div "\\" "*.dwg"))
				)
				(if DTst3Lst
					(setq	DTst3Lst	(mapcar (quote (lambda (x) (strcat "C:\\MapQry\\" DTst3Div "\\" x))) DTst3Lst))
				)
				(if (and DTst3Lst DTstLst)
					(setq	DTstLst	(append DTstLst DTst3Lst))
				)
				(if DShrLst
					(foreach	DoNam
							DShrLst
							(setq	DTstLst	(append DTstLst (list (strcat "C:\\MapQry\\Adds_SH\\" DoNam ".dwg"))))
					)
				)
				(setq	DTstDiv	"Adds_N_")
				(if (findfile (strcat "C:\\MapQry\\AddsOut\\" DTstNam ".dwg"))
					(dos_delete (strcat "C:\\MapQry\\AddsOut\\" DTstNam ".dwg"))
				)
			)
			((= ChewzR 9)	;NorthEast
				(setq	DTstDiv	"Adds_BH"
						DDivNam	"NorthEast"
						DTstNam	(strcat "Ckt_" DDivNam)
						DShrLst	(GetShrLst ChewzR nil)
						DTstLst	(dos_dir (strcat "C:\\MapQry\\" DTstDiv "\\" "*.dwg"))
				)
				(if DTstLst
					(setq	DTstLst	(mapcar (quote (lambda (x) (strcat "C:\\MapQry\\" DTstDiv "\\" x))) DTstLst))
				)
				(setq	DTst2Div	"Adds_E_"
						DTst2Lst	(dos_dir (strcat "C:\\MapQry\\" DTst2Div "\\" "*.dwg"))
				)
				(if DTst2Lst
					(setq	DTst2Lst	(mapcar (quote (lambda (x) (strcat "C:\\MapQry\\" DTst2Div "\\" x))) DTst2Lst))
				)
				(if (and DTst2Lst DTstLst)
					(setq	DTstLst	(append DTstLst DTst2Lst))
				)
				(if DShrLst
					(foreach	DoNam
							DShrLst
							(setq	DTstLst	(append DTstLst (list (strcat "C:\\MapQry\\Adds_SH\\" DoNam ".dwg"))))
					)
				)
				(setq	DTstDiv	"Adds_NE")
				(if (findfile (strcat "C:\\MapQry\\AddsOut\\" DTstNam ".dwg"))
					(dos_delete (strcat "C:\\MapQry\\AddsOut\\" DTstNam ".dwg"))
				)
			)
			(T
				(setq	DTstLst	nil)
			)
		)
	)
	(if DTstLst
		(progn
			(setvar	"USERS1"		"CktMakQ")
			(setvar	"USERS3"		DDivNam)
			(setvar	"USERS5"		"Gathering Panels")
			(setvar	"MODEMACRO"
				(strcat
					"App: <$(getvar,USERS1)>"
					"$(substr,           ,1,$(-,11,$(strlen,$(getvar,USERS1))))"
					"Div: <$(getvar,USERS3)>"
					"$(substr,        ,1,$(-,8,$(strlen,$(getvar,USERS3))))"
					"Action: <$(getvar,USERS5)>"
					"$(substr,                        ,1,$(-,24,$(strlen,$(getvar,USERS5))))"
				)
			)
			(setq	DPthIn	nil
					DPthOut	"C:\\MapQry\\AddsOut\\"
			)
			(setvar	"USERS5"	(strcat "Panels=" (itoa (length DTstLst))))
		)
	)
	(if (and DPthOut DTstLst ChewzA DTstNam)
		(QueryCktTransAll DPthIn DPthOut DTstLst ChewzA nil DTstNam)
	)
	(setvar	"USERS1"		U1_Was)
	(setvar	"USERS2"		U2_Was)
	(setvar	"USERS3"		U3_Was)
	(setvar	"USERS4"		U4_Was)
	(setvar	"USERS5"		U5_Was)
	(setvar	"MODEMACRO"	MM_Was)
	(princ)
)

(defun QueryCktTransAll ( _Path_In _Path_Out Dwg_Lst Action Target DNamOut / )	;ADE Queries multiple drawings, generates DXF files
	(setvar "CMDECHO" 0)
	(setvar "EXPERT" 5)
	(setvar "CMDDIA" 0)
	(setvar "FILEDIA" 0)
	(princ (strcat "\nGot {" (itoa (length Dwg_Lst)) "} dwgs to work!\n"))
	(setvar	"USERS5"	(strcat "Building <" (itoa (length Dwg_Lst)) ">"))
	(mapcar (quote ade_dwgdeactivate) (ade_dslist))
	(ade_prefsetval "DontAddObjectsToSaveSet" T)
	(ade_prefsetval "MkSelSetWithQryObj" T)
	(ade_prefsetval "ActivateDwgsOnAttach" T)
	(if Target
		(ade_projsetwscode "UTM83-16F")
		(ade_projsetwscode "UTM27-16")
	)
	(mapcar (quote ade_dwgdeactivate) (ade_dslist))
	(if _Path_In
		(foreach	DNam
				Dwg_Lst
				(princ (strcat "\nAdding:{" _Path_In DNam ".DWG}"))
				(setq dwg_id (ade_dsattach (strcat _Path_In DNam ".DWG")))
		)
		(foreach	DNam
				Dwg_Lst
				(princ (strcat "\nAdding:{" DNam "}"))
				(setq dwg_id (ade_dsattach DNam))
		)
	)
	(ade_qryclear)
	(ade_qrysettype "draw")
	(cond
		((= Action 1)
			;Original - gets everything
			(ade_qrydefine '("" "" "" "Location" ("all" )""))
			(ade_qrysetaltprop T)
			(ade_altpclear)
			(ade_altpdefine "Color" "256")
			(setvar	"USERS5"	(strcat "{Executing Query}"))
		)
		((= Action 2)
			;Next - gets All Circuits Only
			(ade_qrydefine '("" "" "" "Property" ("objtype" "=" "2DPOLYLINE")""))
			(ade_qrydefine '("AND" "" "" "Property" ("layer" "=" "????CK-???")""))
			;(ade_qrydefine '("OR" "" "" "Property" ("objtype" "=" "2DPOLYLINE")""))
			;(ade_qrydefine '("AND" "" "" "Property" ("layer" "=" "????FL-???")""))
			(ade_qrysetaltprop T)
			(ade_altpclear)
			(ade_altpdefine "Color" "256")
			(setvar	"USERS5"	(strcat "{Executing Query}"))
		)
		((= Action 3)
			;Wayne's - gets District Lines?
			(ade_qrydefine '("" "" "" "Property" ("layer" "=" "????DT????")""))
			(ade_qrysetaltprop T)
			(ade_altpclear)
			(ade_altpdefine "Color" "256")
			(setvar	"USERS5"	(strcat "{Executing Query}"))
		)
		((= Action 4)
			;Wayne's 2nd - gets ---- Lines?
			(ade_qrydefine '("" "" "" "Property" ("objtype" "=" "2DPOLYLINE")""))
			(ade_qrydefine '("AND" "" "" "Property" ("layer" "=" "----???---")""))
			(ade_qrysetaltprop T)
			(ade_altpclear)
			(ade_altpdefine "Color" "256")
			(setvar	"USERS5"	(strcat "{Executing Query}"))
		)
		((= Action 5)
			;Ed's for TransMap nexta...
			(ade_qrydefine '("" "" "" "Property" ("objtype" "=" "INSERT")""))
			(ade_qrysetaltprop T)
			(ade_altpclear)
			(ade_altpdefine "Color" "256")
			(setvar	"USERS5"	(strcat "{Executing Query}"))
		)
		((= Action 6)
			;Cool for Bob - gets 35kV Circuits Only
			(ade_qrydefine '("" "" "" "Property" ("objtype" "=" "2DPOLYLINE")""))
			(ade_qrydefine '("AND" "" "" "Property" ("layer" "=" "????CK-?35")""))
			(ade_qrydefine '("OR" "" "" "Property" ("objtype" "=" "2DPOLYLINE")""))
			(ade_qrydefine '("AND" "" "" "Property" ("layer" "=" "????FL-?35")""))
			(ade_qrysetaltprop T)
			(ade_altpclear)
			(ade_altpdefine "Color" "256")
			(setvar	"USERS5"	(strcat "{Executing Query}"))
		)
		((= Action 7)
			;Cool for Bob - gets 12 & 13kV Circuits Only
			(ade_qrydefine '("" "" "" "Property" ("objtype" "=" "2DPOLYLINE")""))
			(ade_qrydefine '("AND" "" "" "Property" ("layer" "=" "????CK-?13")""))
			(ade_qrydefine '("OR" "" "" "Property" ("objtype" "=" "2DPOLYLINE")""))
			(ade_qrydefine '("AND" "" "" "Property" ("layer" "=" "????FL-?13")""))
			(ade_qrysetaltprop T)
			(ade_altpclear)
			(ade_altpdefine "Color" "256")
			(setvar	"USERS5"	(strcat "{Executing Query}"))
		)
		((= Action 8)
			;Cool for Bob - gets 12 & 13kV Circuits Only
			(ade_qrydefine '("" "" "" "Property" ("objtype" "=" "2DPOLYLINE")""))
			(ade_qrydefine '("AND" "" "" "Property" ("layer" "=" "????CK-?12")""))
			(ade_qrydefine '("OR" "" "" "Property" ("objtype" "=" "2DPOLYLINE")""))
			(ade_qrydefine '("AND" "" "" "Property" ("layer" "=" "????FL-?12")""))
			(ade_qrysetaltprop T)
			(ade_altpclear)
			(ade_altpdefine "Color" "256")
			(setvar	"USERS5"	(strcat "{Executing Query}"))
		)
		((= Action 9)
			;First Shot at Output to OpView
			(ade_qrydefine '("" "" "" "Property"    ("objtype" "=" "2DPOLYLINE")""))
			(ade_qrydefine '("AND" "" "" "Property" ("layer" "=" "????CK-*")""))
			(ade_qrydefine '("OR" "" "" "Property"  ("objtype" "=" "INSERT")""))		;Devices			>>Closed	>>Open
			(ade_qrydefine '("AND" "" "" "Property" ("blockname" "=" "MOGS")""))		;MO Gang Switch	->3118	->3117
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "NEWSS")""))		;Cutout Switch		->3112	->3111
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "_SS")""))		;Cutout Switch		->3112	->3111
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "_SSR")""))		;Cutout Switch		->3112	->3111
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "GR")""))		;Gang Switch		->3114	->3113
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "DR")""))		;Disconnect Switch	->3210	->3243
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "CR")""))		;Cutout Switch		->3112	->3111
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "GS2")""))		;Gang Switch		->3114	->3113
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "DS2")""))		;Disconnect Switch	->3210	->3243
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "CS2")""))		;Cutout Switch		->3112	->3111
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "GS")""))		;Gang Switch		->3114	->3113
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "DS")""))		;Disconnect Switch	->3210	->3243
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "CS")""))		;Cutout Switch		->3112	->3111
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "CAP")""))		;Capacitor		->3016
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "RISER")""))		;Riser			->3214
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "REG")""))		;Regulators		->3089
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "RECL*")""))		;Reclosers		->3702	->3701
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "_OCR*")""))		;Reclosers		->3702	->3701
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "_SECT")""))		;Sectionalizers	->3705	->3706
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "SECT")""))		;Sectionalizers	->3705	->3706
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "SMS")""))		;Scada Mate Switch	->3705	->3706
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "SUB")""))		;Substations		->3216
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "SUB2")""))		;Substations		->3216
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "SUBCUST")""))	;Substations		->3216
			(ade_qrysetaltprop T)
			(ade_altpclear)
			(ade_altpdefine "Color" "256")
			(setvar	"USERS5"	(strcat "{Executing Query}"))
		)
		((= Action 10)
			(ade_qrydefine '("" "" "" "Property"    ("objtype" "=" "2DPOLYLINE")""))
			(ade_qrydefine '("AND" "" "" "Property" ("layer" "=" "????CK-*")""))
			(ade_qrydefine '("OR" "" "" "Property"  ("objtype" "=" "INSERT")""))		;Devices			>>Closed	>>Open
			(ade_qrydefine '("AND" "" "" "Property"  ("blockname" "=" "SUB")""))		;Substations		->3216
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "SUB2")""))		;Substations		->3216
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "SUBCUST")""))	;Substations		->3216
			(ade_qrysetaltprop T)
			(ade_altpclear)
			(ade_altpdefine "Color" "256")
			(setvar	"USERS5"	(strcat "{Executing Query}"))
		)
		((= Action 11)
			;Gets All 3-phase Circuits Only
			(ade_qrydefine '("" "" "" "Property" ("objtype" "=" "2DPOLYLINE")""))
			(ade_qrydefine '("AND" "" "" "Property" ("layer" "=" "????CK-0??")""))
			(ade_qrydefine '("OR" "" "" "Property" ("objtype" "=" "2DPOLYLINE")""))
			(ade_qrydefine '("AND" "" "" "Property" ("layer" "=" "????FL-0??")""))
			(ade_qrydefine '("OR" "" "" "Property"  ("objtype" "=" "INSERT")""))
			(ade_qrydefine '("AND" "" "" "Property" ("blockname" "=" "NO")""))
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "SUB")""))
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "SUB2")""))
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "SUBCUST")""))
			(ade_qrysetaltprop T)
			(ade_altpclear)
			(ade_altpdefine "Color" "256")
			(setvar	"USERS5"	(strcat "{Executing Query}"))
		)
		((= Action 12)
			;Gets All 3-phase Circuits Only
			(ade_qrydefine '("" "" "" "Property" ("objtype" "=" "2DPOLYLINE")""))
			(ade_qrydefine '("AND" "" "" "Property" ("layer" "=" "????CK-0??")""))
			(ade_qrydefine '("OR" "" "" "Property" ("objtype" "=" "2DPOLYLINE")""))
			(ade_qrydefine '("AND" "" "" "Property" ("layer" "=" "????FL-0??")""))
			(ade_qrydefine '("OR" "" "" "Property"  ("objtype" "=" "INSERT")""))
			(ade_qrydefine '("AND" "" "" "Property" ("blockname" "=" "NO")""))
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "SUB")""))
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "SUB2")""))
			(ade_rtdefrange "SUB_SCALE" "Sub Scale" '(("<" 27. 19.)("<" 57. 38.)("<" 104. 76.)(">=" 104. 152.)("otherwise" "" 152.)))
			(ade_rtdefrange "ATT_SCALE" "Sub Attribute Scale" '(("<" 12. 8.)("<" 25. 17.)("<" 51. 34.)(">=" 51. 68.)("otherwise" "" 68.)))
			(ade_qrysetaltprop T)
			(ade_altpclear)
			(ade_altpdefine "Color" "256" "Rotation" 0. "scale" "(Range .scale SUB_SCALE)" "height" "(Range .height ATT_SCALE)")
			(setvar	"USERS5"	(strcat "{Executing Query}"))
		)
		((= Action 13)
			;Gets All 3-phase Circuits Only
			(ade_qrydefine '("" "" "" "Property"  ("objtype" "=" "INSERT")""))
			(ade_qrydefine '("AND" "" "" "Property"  ("blockname" "=" "SUB")""))
			(ade_qrydefine '("OR" "" "" "Property"  ("blockname" "=" "SUB2")""))
;;;			(ade_rtdefrange "SUB_SCALE" "Sub Scale" '(("<" 27. 19.)("<" 57. 38.)("<" 104. 76.)(">=" 104. 152.)("otherwise" "" 152.)))
;;;			(ade_rtdefrange "ATT_SCALE" "Sub Attribute Scale" '(("<" 12. 8.)("<" 25. 17.)("<" 51. 34.)(">=" 51. 68.)("otherwise" "" 68.)))
			(ade_qrysetaltprop T)
			(ade_altpclear)
			(ade_altpdefine "Color" "256")
			(ade_altpdefine "Rotation" "270")
			(ade_altpdefine "Scale" "38")
			(ade_altpdefine "Height" "17")
			(ade_altpdefine "Blockname" "SUB")
			(setvar	"USERS5"	(strcat "{Executing Query}"))
		)
	)
	(ade_qryexecute)
	(princ (strcat "\nGot {" (itoa (length Dwg_Lst)) "} dwgs to work!\n"))
	(setvar	"MODEMACRO"
		(strcat
			"App: <$(getvar,USERS1)>"
			"$(substr,           ,1,$(-,11,$(strlen,$(getvar,USERS1))))"
			"Div: <$(getvar,USERS3)>"
			"$(substr,        ,1,$(-,8,$(strlen,$(getvar,USERS3))))"
			"Action: <$(getvar,USERS5)>"
			"$(substr,                        ,1,$(-,24,$(strlen,$(getvar,USERS5))))"
		)
	)
	(setvar	"USERS5"	(strcat "Zooming..."))
	(command "_.Zoom" "E")
	(cond
		((= Action 1)
			(command "_.Dxfout" (strcat _Path_Out DNamOut ".dxf") "6")
			(setvar	"USERS5"	(strcat "Cleaning Up"))
			(command "_.Erase" "All" "")
			(mapcar (quote ade_dwgdeactivate) (ade_dslist))
			(ade_qryclear)
			(ade_altpclear)
		)
		((= Action 2)
			(setvar	"USERS5"	(strcat "Updating Circuits"))
			(command "ConvertPoly" "L" "All" "")
			(if ChgPlWidths
				(if (ssget "X" (list (cons 0 "*POLYLINE")))
					(ChgPlWidths (ssget "X" (list (cons 0 "*POLYLINE"))) 0.0)
				)
			)
			(setvar	"USERS5"	(strcat "Exporting Circuits"))
			(command "_.Wblock" (strcat _Path_Out DNamOut) "" "0,0" "All" "" "N")
			(setvar	"USERS5"	(strcat "Cleaning Up"))
			(command "_.Erase" "All" "")
			(mapcar (quote ade_dwgdeactivate) (ade_dslist))
			(ade_qryclear)
			(ade_altpclear)
		)
		((= Action 9)
			(command)
			(setvar	"USERS5"	(strcat "Updating Circuits"))
			(command)
			(princ "\nUpdating Circuits\n")
			(command "ConvertPoly" "L" "All" "")
			(setvar	"USERS5"	(strcat "Exporting Circuits"))
			(princ "\nExporting Circuits\n")
			(C:DelodG1)
			(C:FindUm)
			(C:GetPoints)
			;(command "_.Wblock" (strcat _Path_Out DNamOut) "" "0,0" "All" "" "N")
			(setvar	"USERS5"	(strcat "Cleaning Up"))
			;(command "_.Erase" "All" "")
			;(mapcar (quote ade_dwgdeactivate) (ade_dslist))
			;(ade_qryclear)
			;(ade_altpclear)
		)
		((= Action 10)
			(setvar	"USERS5"	(strcat "Updating Circuits"))
			(command "ConvertPoly" "L" "All" "")
			(if ChgPlWidths
				(if (ssget "X" (list (cons 0 "*POLYLINE")))
					(ChgPlWidths (ssget "X" (list (cons 0 "*POLYLINE"))) 0.0)
				)
			)
			(setvar	"USERS5"	(strcat "Exporting Circuits"))
			(command "_.Wblock" (strcat _Path_Out DNamOut) "" "0,0" "All" "" "N")
			(setvar	"USERS5"	(strcat "Cleaning Up"))
			(command "_.Erase" "All" "")
			(mapcar (quote ade_dwgdeactivate) (ade_dslist))
			(ade_qryclear)
			(ade_altpclear)
		)
		((= Action 11)
			(setvar	"USERS5"	(strcat "Updating Circuits"))
			(command "ConvertPoly" "L" "All" "")
			(if ChgPlWidths
				(if (ssget "X" (list (cons 0 "*POLYLINE")))
					(ChgPlWidths (ssget "X" (list (cons 0 "*POLYLINE"))) 10.0)
				)
			)
			(command "-Insert" "*C:\\MapQry\\ApCoSpecialProject\\Div_Map_Org_Poly.dwg" "0,0" "1" "0")
			(setvar	"USERS5"	(strcat "Exporting Circuits"))
;;;			(command "_.Wblock" (strcat _Path_Out DNamOut) "" "0,0" "All" "" "N")
;;;			(setvar	"USERS5"	(strcat "Cleaning Up"))
;;;			(command "_.Erase" "All" "")
			(mapcar (quote ade_dwgdeactivate) (ade_dslist))
			(ade_qryclear)
			(ade_altpclear)
		)
		((= Action 12)
			(setvar	"USERS5"	(strcat "Updating Circuits"))
			(mapcar (quote ade_dwgdeactivate) (ade_dslist))
			(ade_qryclear)
			(ade_altpclear)
		)
		((= Action 13)
			(setvar	"USERS5"	(strcat "Updating Circuits"))
			(mapcar (quote ade_dwgdeactivate) (ade_dslist))
			(ade_qryclear)
			(ade_altpclear)
		)
		(T
			(setvar	"USERS5"	(strcat "Updating Circuits"))
			(command "ConvertPoly" "L" "All" "")
			(if ChgPlWidths
				(if (ssget "X" (list (cons 0 "*POLYLINE")))
					(ChgPlWidths (ssget "X" (list (cons 0 "*POLYLINE"))) 0.0)
				)
			)
			(setvar	"USERS5"	(strcat "Exporting Circuits"))
			(command "_.Wblock" (strcat _Path_Out DNamOut) "" "0,0" "All" "" "N")
			(setvar	"USERS5"	(strcat "Cleaning Up"))
			(command "_.Erase" "All" "")
			(mapcar (quote ade_dwgdeactivate) (ade_dslist))
			(ade_qryclear)
			(ade_altpclear)
		)
	)
	(setvar "CMDECHO" 1)
	(setvar "CMDDIA" 1)
	(setvar "FILEDIA" 1)
	(setvar "EXPERT" 0)
	(princ)
)

(defun TestEm ( /	MinX MinY MaxX MaxY )		;Tester & translator for Etak dwgs
	(ConvertEtak)
	;(command "_.SaveAs" "R14" (strcat (getvar "DWGPREFIX") "Holder\\" (getvar "DWGNAME")))
	(command "_.Insert" (strcat "*S:\\Workgroups\\APC Power Delivery\\Division Mapping\\Quad\\" (getvar "DwgName")) "0,0" "" "")
	(command "_.Layer" "T" "*" "ON" "*" "U" "*" "C" "1" "dlg_*" "C" "3" "dlg_etak_cl" "C" "5" "dlg_etak_c?_name" "S" "0" "")
	(command "_.ChProp" "All" "" "C" "Bylayer" "LT" "Bylayer" "" "_.Zoom" "_E")
	;(setq Bubba (ssget "X" (list (cons 8 "dlg_etak*") (cons 0 "*PolyLine"))))
	;(if Bubba (ChgPlWidths Bubba 5.0))
	(setq Bubba (ssget "X" (list (cons 8 "dlg_etak*"))))
	(setq MinX (car (getvar "EXTMIN")) MinY (cadr (getvar "EXTMIN")) MaxX (car (getvar "EXTMAX")) MaxY (cadr (getvar "EXTMAX")))
	(command "_.PLINE" (list MinX MinY) "W" "0.0" "0.0" (list MaxX MinY) (list MaxX MaxY) (list MinX MaxY) "C")
	(command "_.Text" "J" "BR" (list (- MaxX 50.0) (+ MinY 50.0)) 250.0 0 (strcat (getvar "DWGNAME") " - Etak on Top"))
	(if Bubba (command "DrawOrder" Bubba "" "F"))
	(if (and Bubba (not Bug)) (command "_.Zoom" "E" "_.Plot" "E" "0") (command "_.Zoom" "E"))
	(command "_.Erase" "L" "" "_.Text" "J" "BR" (list (- MaxX 50.0) (+ MinY 50.0)) 250.0 0 (strcat (getvar "DWGNAME") " - DLG on Top"))
	(if Bubba (command "DrawOrder" Bubba "" "B"))
	(if (and Bubba (not Bug)) (command "_.Plot" "E" "0") (command "_.Zoom" "E"))
	(princ)
)

(defun ConvertEtak ( /	MinX MinY MaxX MaxY )	;Translator for Etak dwgs
	(if (not LayChk)
		(LodStage "UTILS")
	)
	(command "_.Layer" "T" "*" "ON" "*" "U" "*" "S" "0" "")
	(if (not ChgPlWidths)
		(cond
			((and (= (getvar "ACADVER") "15.06") (findfile "C:\\Program Files\\Autodesk\\ACADMAP5\\Express\\MPedit.Lsp"))
				(princ "\n=>Loading MPedit for Map 5 {Acad 2002}...\n")
				(load "C:\\Program Files\\Autodesk\\ACADMAP4\\Express\\MPedit")
			)
			((and (= (getvar "ACADVER") "15.0") (findfile "C:\\Program Files\\Autodesk\\ACADMAP4\\Express\\MPedit.Lsp"))
				(princ "\n=>Loading MPedit for Map 4 {Acad 2000}...\n")
				(load "C:\\Program Files\\Autodesk\\ACADMAP4\\Express\\MPedit")
			)
			((and (= (getvar "ACADVER") "14.0") (findfile "C:\\Program Files\\Autodesk\\ACADMAP2\\BONUS\\CADTOOLS\\MPedit.Lsp"))
				(princ "\n=>Loading MPedit for Map 2 {Acad 14}...\n")
				(load "C:\\Program Files\\Autodesk\\ACADMAP2\\BONUS\\CADTOOLS\\MPedit")
			)
		)
	)
	(if (LayChk "0roadcl") (command "rename" "la" "0roadcl" "Dlg_etak_cl"))
	(if (LayChk "10roadcl") (command "rename" "la" "10roadcl" "Dlg_etak_co_name"))
	(if (LayChk "1roadcl") (command "rename" "la" "1roadcl" "Dlg_etak_cl_name"))
	(if (LayChk "1") (command "rename" "la" "1" "Dlg_etak_cl_hwy_us"))
	(if (LayChk "2") (command "rename" "la" "2" "Dlg_etak_cl_hwy"))
	(if (LayChk "3") (command "rename" "la" "3" "Dlg_etak_cl_road_co"))
	(if (LayChk "4") (command "rename" "la" "4" "Dlg_etak_cl_road"))
	(if (LayChk "5") (command "rename" "la" "5" "Dlg_etak_cl_road_liteduty"))
	(if (LayChk "6") (command "rename" "la" "6" "Dlg_etak_cl_road_unpaved"))
	(if (LayChk "8") (command "rename" "la" "8" "Dlg_etak_cl_railroad"))
	(if (LayChk "P") (command "rename" "la" "P" "Dlg_etak_political"))
	(if (LayChk "S") (command "rename" "la" "S" "Dlg_etak_shoreline"))
	(if (LayChk "10") (command "rename" "la" "10" "Dlg_etak_cl_hwy_us_name"))
	(if (LayChk "20") (command "rename" "la" "20" "Dlg_etak_cl_hwy_name"))
	(if (LayChk "30") (command "rename" "la" "30" "Dlg_etak_cl_road_co_name"))
	(if (LayChk "40") (command "rename" "la" "40" "Dlg_etak_cl_road_name"))
	(if (LayChk "50") (command "rename" "la" "50" "Dlg_etak_cl_road_liteduty_name"))
	(if (LayChk "60") (command "rename" "la" "60" "Dlg_etak_cl_road_unpaved_name"))
	(if (LayChk "80") (command "rename" "la" "80" "Dlg_etak_cl_railroad_name"))
	(if (LayChk "P0") (command "rename" "la" "P0" "Dlg_etak_political_name"))
	(if (LayChk "S0") (command "rename" "la" "S0" "Dlg_etak_shoreline_name"))
	(command "_.ChProp" "all" "" "c" "Bylayer" "lt" "Bylayer" "")
	(command "_.Layer"	"c"	"3"	"dlg_etak_cl_hwy*"
					"c"	"1"	"dlg_etak_cl_road*"
					"c"	"4"	"dlg_etak*liteduty"
					"c"	"9"	"dlg_etak*unpaved"
					"c"	"8"	"dlg_etak*railroad"
					"c"	"6"	"dlg_etak*political"
					"c"	"5"	"dlg_etak*shoreline"
					"c"	"2"	"dlg_etak_*_name"
					""
	)
	(setq Bubba (ssget "X" (list (cons -4 "<AND") (cons 8 "~dlg_etak_cl_road_co") (cons 8 "~dlg_etak_cl_road") (cons 8 "~dlg_etak_cl_hwy*") (cons -4 "AND>") (cons 0 "*PolyLine"))))
	(if Bubba (princ (strcat "\nChanging width of [" (itoa (sslength Bubba)) "] non-main roads to zero...\n")))
	(if Bubba (ChgPlWidths Bubba 0.0))
	(setq Bubba (ssget "X" (list (cons -4 "<OR") (cons 8 "dlg_etak_cl_road_co") (cons 8 "dlg_etak_cl_road") (cons -4 "OR>") (cons 0 "*PolyLine"))))
	(if Bubba (princ (strcat "\nChanging width of [" (itoa (sslength Bubba)) "] main roads to two-and-a-half...\n")))
	(if Bubba (ChgPlWidths Bubba 2.5))
	(setq Bubba (ssget "X" (list (cons 8 "dlg_etak_cl_hwy*") (cons 0 "*PolyLine"))))
	(if Bubba (princ (strcat "\nChanging width of [" (itoa (sslength Bubba)) "] highways to five...\n")))
	(if Bubba (ChgPlWidths Bubba 5.0))
	(princ)
)

(defun C:BlkMarkUp ( / )					;Interactive tool for marking Insert usage & differences
	(if Bug (princ "\n{C:BlkMarkUp entered\n"))
	(command "_.UNDO" "G")
	(setq	EchoWas	(getvar "CMDECHO")
			LayWas	(getvar "CLAYER")
			OsMWas	(getvar "OSMODE")
	)
	(setvar "OSMODE" 0)
	(if (not Bug)
		(setvar "CMDECHO" 0)
	)
	(if (not StyChk)
		(load "Utils")
	)
	(setq	EntPick		(entsel "\nSelect the Block you wish to MarkUp: ")
			AttDatLst		nil
			AttDatHgt		nil
	)
	(if EntPick
		(setq	EntDat	(entget (car EntPick) '("*")))
		(setq	EntDat	nil)
	)
	(if (= (cdr (assoc 0 EntDat)) "INSERT")
		(while EntDat
			(cond
				((= (cdr (assoc 0 EntDat)) "INSERT")
					(setq	BlkDatNam		(strcat "INSERT:" (cdr (assoc 2 EntDat)))
							BlkDatXNY		(StrMeUp (assoc 10 EntDat))
							BlkDatLay		(strcat "<8:" (cdr (assoc 8 EntDat)) ">")
							BlkDatHand	(strcat "HANDLE:" (cdr (assoc 5 EntDat)))
							EntWalk		(entnext (cdr (assoc -1 EntDat)))
					)
					(setvar "CLAYER" (cdr (assoc 8 EntDat)))
					(if AttDatLst
						(setq	AttDatLst		(cons (list BlkDatNam BlkDatHand BlkDatLay BlkDatXNY) AttDatLst))
						(setq	AttDatLst		(list (list BlkDatNam BlkDatHand BlkDatLay BlkDatXNY)))
					)
				)
				((= (cdr (assoc 0 EntDat)) "ATTRIB")
					(setq	AttDatNam		(strcat "ATTRIB:" (cdr (assoc 2 EntDat)))
							AttDatVal		(strcat "VALUE:" (cdr (assoc 1 EntDat)))
							AttDatXNY		(if (assoc 11 EntDat)
											(if (not (equal (cdr (assoc 11 EntDat)) (list 0.0 0.0 0.0) 0.1))
												(StrMeUp (assoc 11 EntDat))
												(StrMeUp (assoc 10 EntDat))
											)
											(StrMeUp (assoc 10 EntDat))
										)
							AttDatLay		(strcat "<8:" (cdr (assoc 8 EntDat)) ">")
							AttDatSty		(strcat "<7:" (cdr (assoc 7 EntDat)) ">")
							EntWalk		(entnext (cdr (assoc -1 EntDat)))
					)
					(if (not AttDatHgt)
						(setq	AttDatHgt		(float (* 10 (fix (/ (cdr (assoc 40 EntDat)) 10.0)))))
					)
					(if (assoc 11 EntDat)
						(if (not (equal (cdr (assoc 11 EntDat)) (list 0.0 0.0 0.0) 0.1))
							(command "_.Insert" "OES" (cdr (assoc 11 EntDat)) AttDatHgt "" "")
							(command "_.Insert" "OES" (cdr (assoc 10 EntDat)) AttDatHgt "" "")
						)
					)
					(if AttDatValLst
						(setq	AttDatValLst	(cons AttDatVal AttDatValLst))
						(setq	AttDatValLst	(list AttDatVal))
					)
					(if AttDatLst
						(setq	AttDatLst		(cons (list AttDatNam AttDatVal AttDatLay AttDatXNY AttDatSty) AttDatLst))
						(setq	AttDatLst		(list (list AttDatNam AttDatVal AttDatLay AttDatXNY AttDatSty)))
					)
				)
				((= (cdr (assoc 0 EntDat)) "SEQEND")
					(setq	EntWalk	nil)
				)
			)
			(if EntWalk
				(setq	EntDat	(entget EntWalk '("*")))
				(setq	EntDat	nil)
			)
			(if EntDat
				(if (/= (cdr (assoc 0 EntDat)) "ATTRIB")
					(setq	EntDat	nil)
				)
			)
		)
	)
	(if AttDatLst
		(setq	AttDatLst		(reverse AttDatLst))
	)
	(if (not (StyChk "ATTDESC"))
		(command "-Style" "ATTDESC" "MONOS.TTF" "" "" "" "" "")
	)
	(if AttDatLst
		(setq	PickTop	(getpoint "\nSelect Top Left of Attribute Data Box: "))
		(setq	PickTop	nil)
	)
	(if PickTop
		(progn
			(setq	PickPt1	(list 	(+ (car PickTop) AttDatHgt) (- (cadr PickTop) AttDatHgt)))
			(command "_.Text" "S" "ATTDESC" "J" "ML" PickPt1 AttDatHgt "" (nth 0 (nth 0 AttDatLst)))
			(setq	DeltaX	(GetWidTxt (entget (entlast)) (mapcar (quote (lambda (x) (nth 0 x))) AttDatLst))
					PickPt2	(list	(+ (car PickPt1) AttDatHgt DeltaX) (cadr PickPt1))
					DeltaX	(GetWidTxt (entget (entlast)) (mapcar (quote (lambda (x) (nth 1 x))) AttDatLst))
					PickPt3	(list	(+ (car PickPt2) AttDatHgt DeltaX) (cadr PickPt2))
			)
			(command "_.Text" "S" "ATTDESC" "J" "ML" PickPt2 AttDatHgt "" (nth 1 (nth 0 AttDatLst)))
			(command "_.Text" "S" "ATTDESC" "J" "ML" PickPt3 AttDatHgt "" (nth 2 (nth 0 AttDatLst)))
			(setq	DeltaX	(GetWidTxt (entget (entlast)) (mapcar (quote (lambda (x) (nth 2 x))) (cdr AttDatLst)))
					PickPt4	(list	(+ (car PickPt3) AttDatHgt DeltaX) (cadr PickPt3))
			)
			(command "_.Text" "S" "ATTDESC" "J" "ML" PickPt4 AttDatHgt "" (nth 3 (nth 0 AttDatLst)))
			(setq	DeltaX	(GetWidTxt (entget (entlast)) (mapcar (quote (lambda (x) (nth 3 x))) (cdr AttDatLst)))
					PickPt5	(list	(+ (car PickPt4) AttDatHgt DeltaX) (cadr PickPt4))
					DeltaX	(GetWidTxt (entget (entlast)) (mapcar (quote (lambda (x) (nth 4 x))) (cdr AttDatLst)))
					PickPt6	(list	(+ (car PickPt5) AttDatHgt DeltaX) (cadr PickPt5))
			)
			(foreach	DatLst
					(cdr AttDatLst)
					(setq	PickPt1	(list	(car PickPt1) (- (cadr PickPt1) (* 1.5 AttDatHgt)))
							PickPt2	(list	(car PickPt2) (cadr PickPt1))
							PickPt3	(list	(car PickPt3) (cadr PickPt1))
							PickPt4	(list	(car PickPt4) (cadr PickPt1))
							PickPt5	(list	(car PickPt5) (cadr PickPt1))
					)
					(command "_.Text" "S" "ATTDESC" "J" "ML" PickPt1 AttDatHgt "" (nth 0 DatLst))
					(command "_.Text" "S" "ATTDESC" "J" "ML" PickPt2 AttDatHgt "" (nth 1 DatLst))
					(command "_.Text" "S" "ATTDESC" "J" "ML" PickPt3 AttDatHgt "" (nth 2 DatLst))
					(command "_.Text" "S" "ATTDESC" "J" "ML" PickPt4 AttDatHgt "" (nth 3 DatLst))
					(command "_.Text" "S" "ATTDESC" "J" "ML" PickPt5 AttDatHgt "" (nth 4 DatLst))
			)
			(setq	PickPt7	(list	(car PickPt6) (- (cadr PickPt1) AttDatHgt)))
			(command "_.PLINE"
					PickTop
					"W" "0.0" "0.0"
					(list (car PickTop) (cadr PickPt7))
					PickPt7
					(list (car PickPt7) (cadr PickTop))
					"C"
					"_.PLINE"
					(list (- (car PickPt2) (* 0.5 AttDatHgt)) (cadr PickTop))
					(list (- (car PickPt2) (* 0.5 AttDatHgt)) (cadr PickPt7))
					""
					"_.PLINE"
					(list (- (car PickPt3) (* 0.5 AttDatHgt)) (cadr PickTop))
					(list (- (car PickPt3) (* 0.5 AttDatHgt)) (cadr PickPt7))
					""
					"_.PLINE"
					(list (- (car PickPt4) (* 0.5 AttDatHgt)) (cadr PickTop))
					(list (- (car PickPt4) (* 0.5 AttDatHgt)) (cadr PickPt7))
					""
					"_.PLINE"
					(list (- (car PickPt5) (* 0.5 AttDatHgt)) (cadr PickTop))
					(list (- (car PickPt5) (* 0.5 AttDatHgt)) (cadr PickPt7))
					""
			)
		)
	)
	(setvar "CLAYER" LayWas)
	(setvar "OSMODE" OsMWas)
	(if (not Bug)
		(setvar "CMDECHO" EchoWas)
	)
	(command "_.UNDO" "E")
	(if Bug (princ "\nC:BlkMarkUp exited}\n"))
	(princ)
)

(defun GetWidTxt ( EntLst TxtLst /	WidBig	;Calculates Widest Value of Text at Proposed settings
								WidTmp TxtVal )
	(if Bug (princ "\n{GetWidTxt entered\n"))
	(cond
		((= (length TxtLst) 1)
			(setq	WidBox	(textbox	(subst	(cons 1 (car TxtLst))
											(assoc 1 EntLst)
											EntLst
									)
							)
					WidBig	(- (caadr WidBox) (caar WidBox))
			)
		)
		((> (length TxtLst) 1)
			(setq	WidBig	0.0)
			(foreach	TxtVal
					TxtLst
					(setq	WidBox	(textbox	(subst	(cons 1 TxtVal)
													(assoc 1 EntLst)
													EntLst
											)
									)
							WidTmp	(- (caadr WidBox) (caar WidBox))
					)
					(if (> WidTmp WidBig)
						(setq	WidBig	WidTmp)
					)
			)
		)
		(T
			(setq	WidBig	0.0)
		)
	)
	(if Bug (princ "\nGetWidTxt exited}\n"))
	WidBig
)

(defun MakBlkLst ( / )						;Incomplete - meant to generate XML files of Block Usage
	(if Bug (princ "\n{MakBlkLst entered\n"))
	(setq	BlkDef	(tblnext "BLOCK" T)
			Cntr		0
			BlkOut	(open "BlkDat.txt" "a")
			XmLOut	(open "XmLDat.txt" "a")
	)
	(while BlkDef
		(setq	BlkNam	(cdr (assoc 2 BlkDef))
				BlkHome	(strcase (getvar "DWGNAME"))
				BlkHasAtt	(if (assoc 70 BlkDef)
							(if (= (cdr (assoc 70 BlkDef)) 2)
								"Yes"
								"No"
							)
							"No"
						)
				BlkPnt	(cdr (assoc -2 BlkDef))
				BlkHome	(if (> (strlen BlkHome) 4) (substr BlkHome 1 (- (strlen BlkHome) 4)) BlkHome)
				Blk_Lst	(list BlkHome BlkNam BlkHasAtt)
		)
		(while BlkPnt
			(setq	BlkEntDat	(entget BlkPnt	(quote ("*")))
					BlkDat	nil
					BlkPnt	nil
					DscStr	nil
					DatStr	nil
					XmLStr	nil
			)
			(cond
				((= (cdr (assoc 0 BlkEntDat)) "ATTDEF")
					(setq	BlkDat	BlkEntDat
							Cntr		(1+ Cntr)
							DatScr	(strcat	(PadNum (itoa Cntr) 3) ","
											(PadNum BlkHome 7) ","
											(RepChar " " (- 8 (strlen BlkNam)))
											"\"" BlkNam "\","
											(if (assoc 2 BlkEntDat) (PadCharL (StrMeUp (cdr (assoc 2 BlkEntDat))) 48) (PadCharL "NoTag" 48)) ","
											(if (assoc 3 BlkEntDat) (PadCharL (StrMeUp (cdr (assoc 3 BlkEntDat))) 48) (PadCharL "NoPrompt" 48)) ","
											(if (assoc 1 BlkEntDat) (if (= (strlen (cdr (assoc 1 BlkEntDat))) 0) (PadCharL "\"NoDefault\"" 48) (PadCharL (StrMeUp (cdr (assoc 1 BlkEntDat))) 48)) (PadCharL "\"NoDefault\"" 48)) ","
											(if (assoc 7 BlkEntDat) (PadCharL (StrMeUp (cdr (assoc 7 BlkEntDat))) 15) (PadCharL "\"NoStyle\"" 15)) ",\""
											(if (assoc 70 BlkEntDat) (StrMeUp (cdr (assoc 70 BlkEntDat))) "0")
											(if (assoc 71 BlkEntDat) (StrMeUp (cdr (assoc 71 BlkEntDat))) "0")
											(if (assoc 72 BlkEntDat) (StrMeUp (cdr (assoc 72 BlkEntDat))) "0")
											(if (assoc 73 BlkEntDat) (StrMeUp (cdr (assoc 73 BlkEntDat))) "0")
											(if (assoc 74 BlkEntDat) (StrMeUp (cdr (assoc 74 BlkEntDat))) "0") "\","
											(PadNum BlkHome 7) (PadNum (itoa Cntr) 3)
									)
							DscStr	(strcat	"<UniqID=\"" (PadNum BlkHome 7) (PadNum (itoa Cntr) 3) "\""
											"\n\t;"
												"DrawingName=\"" (PadNum BlkHome 7) "\""
											"\n\t;"
												"BlockName=\"" BlkNam "\""
											"\n\t;"
												(cdr (assoc 0 BlkEntDat)) "=" (if (assoc 2 BlkEntDat) (StrMeUp (cdr (assoc 2 BlkEntDat))) "NoTag")
											"\n\t;"
												"Prompt=" (if (assoc 3 BlkEntDat) (StrMeUp (cdr (assoc 3 BlkEntDat))) "NoPrompt")
											"\n\t;"
												"Default=" (if (assoc 1 BlkEntDat) (if (= (strlen (cdr (assoc 1 BlkEntDat))) 0) "\"NoDefault\"" (StrMeUp (cdr (assoc 1 BlkEntDat)))) "\"NoDefault\"")
											"\n\t;"
												"Style=" (if (assoc 7 BlkEntDat) (StrMeUp (cdr (assoc 7 BlkEntDat))) "NoStyle")
											"\n\t;"
												"JFlag70=" (if (assoc 70 BlkEntDat) (StrMeUp (cdr (assoc 70 BlkEntDat))) "NoJFlag70")
											"\n\t;"
												"JFlag71=" (if (assoc 71 BlkEntDat) (StrMeUp (cdr (assoc 71 BlkEntDat))) "NoJFlag71")
											"\n\t;"
												"JFlag72=" (if (assoc 72 BlkEntDat) (StrMeUp (cdr (assoc 72 BlkEntDat))) "NoJFlag72")
											"\n\t;"
												"JFlag73=" (if (assoc 73 BlkEntDat) (StrMeUp (cdr (assoc 73 BlkEntDat))) "NoJFlag73")
											"\n\t;"
												"JFlag74=" (if (assoc 74 BlkEntDat) (StrMeUp (cdr (assoc 74 BlkEntDat))) "NoJFlag74")
											"\n\t;"
												"Height=" (if (assoc 40 BlkEntDat) (StrMeUp (cdr (assoc 40 BlkEntDat))) "NoHeight")
											"\n\t;"
												"InsPt=" (if (assoc 10 BlkEntDat) (StrMeUp (cdr (assoc 10 BlkEntDat))) "NoInsPt")
											"\n\t;"
												"JPt=" (if (assoc 11 BlkEntDat) (StrMeUp (cdr (assoc 11 BlkEntDat))) "NoJPt")
											"\n>"
									)
							XmLStr	(strcat	"<UniqID=\"" (PadNum BlkHome 7) (PadNum (itoa Cntr) 3) "\""
											";"
												"DrawingName=\"" (PadNum BlkHome 7) "\""
											";"
												"BlockName=\"" BlkNam "\""
											";"
												(cdr (assoc 0 BlkEntDat)) "=" (if (assoc 2 BlkEntDat) (StrMeUp (cdr (assoc 2 BlkEntDat))) "NoTag")
											";"
												"Prompt=" (if (assoc 3 BlkEntDat) (StrMeUp (cdr (assoc 3 BlkEntDat))) "NoPrompt")
											";"
												"Default=" (if (assoc 1 BlkEntDat) (if (= (strlen (cdr (assoc 1 BlkEntDat))) 0) "\"NoDefault\"" (StrMeUp (cdr (assoc 1 BlkEntDat)))) "\"NoDefault\"")
											";"
												"Style=" (if (assoc 7 BlkEntDat) (StrMeUp (cdr (assoc 7 BlkEntDat))) "NoStyle")
											";"
												"JFlag70=" (if (assoc 70 BlkEntDat) (StrMeUp (cdr (assoc 70 BlkEntDat))) "NoJFlag70")
											";"
												"JFlag71=" (if (assoc 71 BlkEntDat) (StrMeUp (cdr (assoc 71 BlkEntDat))) "NoJFlag71")
											";"
												"JFlag72=" (if (assoc 72 BlkEntDat) (StrMeUp (cdr (assoc 72 BlkEntDat))) "NoJFlag72")
											";"
												"JFlag73=" (if (assoc 73 BlkEntDat) (StrMeUp (cdr (assoc 73 BlkEntDat))) "NoJFlag73")
											";"
												"JFlag74=" (if (assoc 74 BlkEntDat) (StrMeUp (cdr (assoc 74 BlkEntDat))) "NoJFlag74")
											";"
												"Height=" (if (assoc 40 BlkEntDat) (StrMeUp (cdr (assoc 40 BlkEntDat))) "NoHeight")
											";"
												"InsPt=" (if (assoc 10 BlkEntDat) (StrMeUp (cdr (assoc 10 BlkEntDat))) "NoInsPt")
											";"
												"JPt=" (if (assoc 11 BlkEntDat) (StrMeUp (cdr (assoc 11 BlkEntDat))) "NoJPt")
											">"
									)
					)
					(if DscStr (princ (strcat "\n" DscStr)))
					(if DatScr (write-line DatScr BlkOut))
					(if XmLStr (write-line XmLStr XmLOut))
				)
				(T
					(setq	XmLStr	(strcat	"<UniqID=\"" (PadNum BlkHome 7) (PadNum (itoa Cntr) 3) "\""
											";"
												"DrawingName=\"" (PadNum BlkHome 7) "\""
											";"
												"Unexpected=\"" (StrMeUp (cdr (assoc 0 BlkEntDat))) "\""
											">"
									)
					)
					;(if XmLStr (princ (strcat "\n" XmLStr)))
				)
			)
			(if (and BlkDat Blk_Lst)
				(setq	Blk_Lst	(append Blk_Lst (list BlkDat)))
			)
			(setq	BlkPnt	(entnext (cdr (assoc -1 BlkEntDat))))
		)
		(if MstrBlkLst
			(setq	MstrBlkLst	(cons Blk_Lst MstrBlkLst))
			(setq	MstrBlkLst	(list Blk_Lst))
		)
		(setq	BlkDef	(tblnext "BLOCK"))
	)
	(close BlkOut)
	(close XmLOut)
	(if Bug (princ "\nMakBlkLst exited}\n"))
)

(defun C:MakBlkLst ( / )					;CL - calls MakBlkLst
	(MakBlkLst)
	(princ)
)

(defun StrMeUp ( InData /	OutStr )			;Strips & identifies Lisp Variables
	(if Bug (princ "\n{StrMeUp entered\n"))
	(cond
		((= (type InData) (quote SUBR))
			(if Bug (princ "\nBug:<SUBR>\n"))
			(setq	OutStr	"<SUBR>")
		)
		((= (type InData) (quote FILE))
			(if Bug (princ "\nBug:<FILE>\n"))
			(setq	OutStr	"<FILE>")
		)
		((= (type InData) (quote EXSUBR))
			(if Bug (princ "\nBug:<EXSUBR>\n"))
			(setq	OutStr	"<EXSUBR>")
		)
		((= (type InData) (quote PICKSET))
			(if Bug (princ "\nBug:<PICKSET>\n"))
			(setq	OutStr	"<PICKSET>")
		)
		((= (type InData) (quote PAGETB))
			(if Bug (princ "\nBug:<PAGETB>\n"))
			(setq	OutStr	"<PAGETB>")
		)
		((= (type InData) (quote ENAME))
			(if Bug (princ "\nBug:<ENAME>\n"))
			(setq	OutStr	"<ENAME>")
		)
		((= (type InData) (quote REAL))
			(if Bug (princ "\nBug:<REAL>\n"))
			(setq	OutStr	(rtos InData 2 2))
		)
		((= (type InData) (quote INT))
			(if Bug (princ "\nBug:<INT>\n"))
			(setq	OutStr	(itoa InData))
		)
		((= (type InData) (quote STR))
			(if Bug (princ "\nBug:<STR>\n"))
			(if (< (strlen InData) 1)
				(setq	OutStr	"\"Null String\"")
				(setq	OutStr	(strcat "\"" InData "\""))
			)
		)
		((= (type InData) (quote SYM))
			(if Bug (princ "\nBug:<SYM>\n"))
			(setq	OutStr	"<SYM>")
		)
		((and (= (type InData) (quote LIST)) (/= (type (cdr InData)) (quote LIST)))
			(if Bug (princ "\nBug:<Dotted Pair>\n"))
			(setq	OutStr	(strcat "<" (StrMeUp (car InData)) ":" (StrMeUp (cdr InData)) ">"))
		)
		((= (type InData) (quote LIST))
			(if Bug (princ "\nBug:<LIST>\n"))
			(cond
				((= (length InData) 2)
					(cond
						((and	(= (type (car InData)) (quote INT))
								(= (type (cadr InData)) (quote INT))
						 )
							(if Bug (princ "\nBug:<LIST:Length=2:Both INT>\n"))
						 	(setq	OutStr	(strcat "<" (itoa (car InData)) ":" (itoa (cadr InData)) ">"))
						)
						((and	(= (type (car InData)) (quote INT))
								(= (type (cadr InData)) (quote STR))
						 )
							(if Bug (princ "\nBug:<LIST:Length=2:INT&STR>\n"))
						 	(setq	OutStr	(strcat "<" (itoa (car InData)) ":" (cadr InData) ">"))
						)
						((and	(= (type (car InData)) (quote INT))
								(= (type (cadr InData)) (quote REAL))
						 )
							(if Bug (princ "\nBug:<LIST:Length=2:INT&REAL>\n"))
						 	(setq	OutStr	(strcat "<" (itoa (car InData)) ":" (rtos (cadr InData) 2 4) ">"))
						)
						(T
							(if Bug (princ "\nBug:<LIST:Length=2:Unknown>\n"))
						 	(setq	OutStr	(strcat "<" (StrMeUp (car InData)) ":" (StrMeUp (cadr InData)) ">"))
						)
					)
				)
				((= (length InData) 3)
					(if (and	(= (type (car InData)) (quote REAL)) (= (type (cadr InData)) (quote REAL)) (= (type (caddr InData)) (quote REAL)))
						(progn
							(if Bug (princ "\nBug:<LIST:Length=3:All REAL>\n"))
							(setq	OutStr	(strcat "<" (rtos (car InData) 2 4) "," (rtos (cadr InData) 2 4) "," (rtos (caddr InData) 2 4) ">"))
						)
						(progn
							(if Bug (princ "\nBug:<LIST:Length=3>\n"))
							(setq	OutStr	(strcat "<" (StrMeUp (car InData)) "," (StrMeUp (cadr InData)) "," (StrMeUp (caddr InData)) ">"))
						)
					)
				)
				((= (length InData) 4)
					(if (and	(= (type (car InData)) (quote INT)) (= (type (cadr InData)) (quote REAL)) (= (type (caddr InData)) (quote REAL)) (= (type (last InData)) (quote REAL)))
						(progn
							(if Bug (princ "\nBug:<Dotted Pair:List of REAL>\n"))
							(setq	OutStr	(strcat "<" (itoa (car InData)) ":" (rtos (cadr InData) 2 4) "," (rtos (caddr InData) 2 4) "," (rtos (last InData) 2 4) ">"))
						)
						(progn
							(if Bug (princ "\nBug:<LIST:Length=4>\n"))
							(setq	OutStr	(strcat "<" (StrMeUp (car InData)) "," (StrMeUp (cadr InData)) "," (StrMeUp (caddr InData)) "," (StrMeUp (last InData)) ">"))
						)
					)
				)
				(T
					(cond
						((= (type (car InData)) (quote STR))
							(if Bug (princ "\nBug:<LIST:Length=Unknown:First STR>\n"))
							(setq	OutStr	(strcat "<\"" (car InData) "\"" (apply (quote strcat) (mapcar (quote (lambda (y) (strcat ";" (StrMeUp y)))) (cdr InData))) ">"))
						)
						((= (type (car InData)) (quote REAL))
							(if Bug (princ "\nBug:<LIST:Length=Unknown:First REAL>\n"))
							(setq	OutStr	(strcat "<" (rtos (car InData) 2 4) (apply (quote strcat) (mapcar (quote (lambda (y) (strcat ";" (StrMeUp y)))) (cdr InData))) ">"))
						)
						((= (type (car InData)) (quote INT))
							(if Bug (princ "\nBug:<LIST:Length=Unknown:First INT>\n"))
							(setq	OutStr	(strcat "<" (itoa (car InData)) (apply (quote strcat) (mapcar (quote (lambda (y) (strcat ";" (StrMeUp y)))) (cdr InData))) ">"))
						)
					)
				)
			)
		)
		(T
			(if Bug (princ "\nBug:<UNKNOWN>\n"))
			(setq	OutStr	"<UNKNOWN>")
		)
	)
	(if Bug (princ "\nStrMeUp exited}\n"))
	OutStr
)

(defun ColrPickR ( LastNum Act /	ColrNum )		;Meant to generate non-sequential color lists (not perfect)
	(cond	((= Act "F")
				(setq	ColrNum	(+ 1 LastNum))
				(if (>= ColrNum 246)
					(setq	ColrNum	1)
					(if (= (substr (itoa ColrNum) (strlen (itoa ColrNum))) "6")
						(setq	ColrNum	(+ ColrNum 4))
					)
				)
			)
			((= Act "B")
				(setq	ColrNum	(+ 11 LastNum))
				(if (>= ColrNum 246)
					(setq	ColrNum	1)
					(if (= (substr (itoa ColrNum) (strlen (itoa ColrNum))) "6")
						(setq	ColrNum	(+ ColrNum 4))
						(if (= ColrNum 7)
							(setq	ColrNum	8)
						)
					)
				)
			)
			((= Act "S")
				(setq	ColrNum	(Mod LastNum 8))
				(if (= ColrNum 0)
					(setq	ColrNum	8)
				)
			)
			(T
				(setq	ColrNum	(+ 1 LastNum))
				(if (>= ColrNum 246)
					(setq	ColrNum	1)
					(if (= (substr (itoa ColrNum) (strlen (itoa ColrNum))) "6")
						(setq	ColrNum	(+ ColrNum 4))
					)
				)
			)
	)
	ColrNum
)

(defun C:Mak_New01 (  /	acadObject			;Swaps current profile...when run from Visual Lisp
			acadDocument )
	(setq	acadObject	(vlax-get-acad-object)
		acadDocument	(vla-get-ActiveDocument acadObject)
	)
	(vla-new "S:/Workgroups/APC Power Delivery/Division Mapping/Adds25/SYM/Adds25.dwt" "Y")
	(setq	acadDocument	(vla-get-ActiveDocument acadObject))
	(vla-new "S:/Workgroups/APC Power Delivery/Division Mapping/Adds25/SYM/Adds25.dwt" "Y")
	(setq	acadDocument	(vla-get-ActiveDocument acadObject))
	(vla-new "S:/Workgroups/APC Power Delivery/Division Mapping/Adds25/SYM/Adds25.dwt" "Y")
	(setq	acadDocument	(vla-get-ActiveDocument acadObject))
	(vla-new "S:/Workgroups/APC Power Delivery/Division Mapping/Adds25/SYM/Adds25.dwt" "Y")
  	(princ)
)

(defun ReadBigLst ( fNam /	MyfNam InLin InLst	;Reads in any text that can be Read to Lst format
						BigLst Cntr )
	(if Bug (princ "\n{ReadBigLst entered\n"))
	(if (findfile fNam) 
		(setq	MyfNam	(open fNam "r")
			Cntr	0
		)
		(setq	MyfNam	nil)
	)
	(if MyfNam
		(setq	InLin	(read-line MyfNam))
		(setq	InLin	nil)
	)
	(if InLin
		(setq	InLst	(read (strcat "(" InLin ")")))
		(setq	InLst	nil)
	)
	(if InLst
		(setq	BigLst	(list InLst)
			Cntr	(1+ Cntr)
		)
		(setq	BigLst	nil)
	)
	(if BigLst
		(while (setq InLin (read-line MyfNam))
			(if InLin
				(setq InLst	(read (strcat "(" InLin ")"))
					Cntr		(1+ Cntr)
					Bubba	(if Bug (princ (PadNum (itoa Cntr) 5)))
				)
			)
			(if InLst
				(setq BigLst (cons InLst BigLst))
			)
		)
	)
	(if fNam
		(close MyfNam)
	)
	(if Bug (princ "\nReadBigLst exited}\n"))
	BigLst
)

(defun GetOrg ( / )						;Reads & Writes files for translation LatLong to Adds coords for Org_ID locations
	(setq	FNam		"OpCenterOut.txt"
			OrgInLst	(GetFilAsLst fNam)
	)
	(if OrgInLst
		(foreach	OrgIn
				OrgInLst
				(setq	OrgOut	(UpdOrgLst OrgIn))
				(if (<= (car OrgOut) 82)
					(if OrgOutLst
						(setq	OrgOutLst	(cons OrgOut OrgOutLst))
						(setq	OrgOutLst	(list OrgOut))
					)
				)
		)
	)
	(if OrgOutLst
		(PutFilAsLst OrgOutLst "DevOrgGood.txt" RefOrgLst 1)
	)
)

(defun MakBigInserts ( DoOneLst AScl / )		;Updates Div_Map_Z inserts
	(if Bug (princ "\n{MakBigInserts entered\n"))
	(setq	ColorWas	(getvar "CECOLOR")
			PtX		(last DoOneLst)
			LocN		(nth 1 DoOneLst)
			BusN		(nth 6 DoOneLst)
			ColorIs	(nth 7 DoOneLst)
			OprN		(nth 8 DoOneLst)
			OprRepN	(nth 9 DoOneLst)
			JustFie	(nth 10 DoOneLst)
			BlkNam	"Office_Mstr"
	)
	(if Bug
		(setvar "CMDECHO" 1)
	)
	(if (= BusN "None")
		(setq	BusN		" ")
	)
	(if	(= OprRepN "None")
		(progn
			(setq	OprRepN		" ")
			(if (= OprN "None")
				(setq	OprN		" ")
			)
		)
	)
	(if (= BusN " ")
		(progn
			(cond
				((= JustFie 0)
					(setq	BlkNam	"Office_EngOne_LM2")
				)
				((= JustFie 1)
					(setq	BlkNam	"Office_EngOne_LM2")
				)
				((= JustFie 2)
					(setq	BlkNam	"Office_EngOne_LU2")
				)
				((= JustFie 3)
					(setq	BlkNam	"Office_EngOne_LD2")
				)
				((= JustFie 4)
					(setq	BlkNam	"Office_EngOne_LF2")
				)
				((= JustFie 5)
					(setq	BlkNam	"Office_EngOne_MU2")
				)
				((= JustFie -1)
					(setq	BlkNam	"Office_EngOne_RM2")
				)
				((= JustFie -2)
					(setq	BlkNam	"Office_EngOne_RU2")
				)
				((= JustFie -3)
					(setq	BlkNam	"Office_EngOne_RD2")
				)
				((= JustFie -4)
					(setq	BlkNam	"Office_EngOne_RF2")
				)
				((= JustFie -5)
					(setq	BlkNam	"Office_EngOne_MD2")
				)
			)
			(command "Insert" BlkNam PtX AScl AScl "0" LocN OprN OprRepN LocN)
		)
		(if (and (= OprN " ") (= OprRepN " "))
			(progn
				(cond
					((= JustFie 0)
						(setq	BlkNam	"Office_BusOne_LM2")
					)
					((= JustFie 1)
						(setq	BlkNam	"Office_BusOne_LM2")
					)
					((= JustFie 2)
						(setq	BlkNam	"Office_BusOne_LU2")
					)
					((= JustFie 3)
						(setq	BlkNam	"Office_BusOne_LD2")
					)
					((= JustFie 4)
						(setq	BlkNam	"Office_BusOne_LF2")
					)
					((= JustFie 5)
						(setq	BlkNam	"Office_BusOne_MU2")
					)
					((= JustFie -1)
						(setq	BlkNam	"Office_BusOne_RM2")
					)
					((= JustFie -2)
						(setq	BlkNam	"Office_BusOne_RU2")
					)
					((= JustFie -3)
						(setq	BlkNam	"Office_BusOne_RD2")
					)
					((= JustFie -4)
						(setq	BlkNam	"Office_BusOne_RF2")
					)
					((= JustFie -5)
						(setq	BlkNam	"Office_BusOne_MD2")
					)
				)
				(command "Insert" BlkNam PtX AScl AScl "0" LocN BusN LocN)
			)
			(progn
				(cond
					((= JustFie 0)
						(setq	BlkNam	"Office_BusShr_LM2")
					)
					((= JustFie 1)
						(setq	BlkNam	"Office_BusShr_LM2")
					)
					((= JustFie 2)
						(setq	BlkNam	"Office_BusShr_LU2")
					)
					((= JustFie 3)
						(setq	BlkNam	"Office_BusShr_LD2")
					)
					((= JustFie 4)
						(setq	BlkNam	"Office_BusShr_LF2")
					)
					((= JustFie 5)
						(setq	BlkNam	"Office_BusShr_MU2")
					)
					((= JustFie -1)
						(setq	BlkNam	"Office_BusShr_RM2")
					)
					((= JustFie -2)
						(setq	BlkNam	"Office_BusShr_RU2")
					)
					((= JustFie -3)
						(setq	BlkNam	"Office_BusShr_RD2")
					)
					((= JustFie -4)
						(setq	BlkNam	"Office_BusShr_RF2")
					)
					((= JustFie -5)
						(setq	BlkNam	"Office_BusShr_MD2")
					)
				)
				(command "Insert" BlkNam PtX AScl AScl "0" LocN BusN OprN OprRepN LocN)
			)
		)
	)
	(if Bug
		(setvar "CMDECHO" 0)
	)
	(if Bug (princ "\nMakBigInserts exited}\n"))
)

(defun MakCoLin (	DoLst /	ColWas OsmWas		;Updates ColorLst for Div_Map_Z
						LayWas LtWas )
	(setq	CoLst	nil
			CoLst01	nil
			CoLst02	nil
			CoLst03	nil
			CoLst04	nil
			CoLst05	nil
			CoLst06	nil
			PtLst01	nil
			PtLst02	nil
			PtLst03	nil
			PtLst04	nil
			PtLst05	nil
			PtLst06	nil
			ColWas	(getvar "CECOLOR")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsmWas	(getvar "OSMODE")
	)
	(command "Layer" "T" "REG_Office*" "ON" "REG_Office*" "U" "REG_Office*" "S" "REG_Office" "")
	(setvar "OSMODE" 0)
;	(setvar "CLAYER" "REG_Office")
	(setvar "CELTYPE" "HIDDEN")
	(setvar "CECOLOR" "3")
	(if DoLst
		(setq	CoLst	(mapcar (quote (lambda (x) (list (nth 5 x) (nth 7 x) (last x)))) dolst))
	)
	(if CoLst
		(foreach	CLst
				CoLst
				(cond
					((= (car CLst) 1)
						(if (> (cadr CLst) 0)
							(if CoLst01
								(if (not (member (cadr CLst) CoLst01))
									(setq	CoLst01	(cons (cadr CLst) CoLst01)
											PtLst01	(cons (nth 2 CLst) PtLst01)
									)
									(setq	PtLst01	(cons (nth 2 CLst) PtLst01))
								)
								(setq	CoLst01	(list (cadr CLst))
										PtLst01	(list (nth 2 CLst))
								)
							)
						)
					)
					((= (car CLst) 2)
						(if (> (cadr CLst) 0)
							(if CoLst02
								(if (not (member (cadr CLst) CoLst02))
									(setq	CoLst02	(cons (cadr CLst) CoLst02)
											PtLst02	(cons (nth 2 CLst) PtLst02)
									)
									(setq	PtLst02	(cons (nth 2 CLst) PtLst02))
								)
								(setq	CoLst02	(list (cadr CLst))
										PtLst02	(list (nth 2 CLst))
								)
							)
						)
					)
					((= (car CLst) 3)
						(if (> (cadr CLst) 0)
							(if CoLst03
								(if (not (member (cadr CLst) CoLst03))
									(setq	CoLst03	(cons (cadr CLst) CoLst03)
											PtLst03	(cons (nth 2 CLst) PtLst03)
									)
									(setq	PtLst03	(cons (nth 2 CLst) PtLst03))
								)
								(setq	CoLst03	(list (cadr CLst))
										PtLst03	(list (nth 2 CLst))
								)
							)
						)
					)
					((= (car CLst) 4)
						(if (> (cadr CLst) 0)
							(if CoLst04
								(if (not (member (cadr CLst) CoLst04))
									(setq	CoLst04	(cons (cadr CLst) CoLst04)
											PtLst04	(cons (nth 2 CLst) PtLst04)
									)
									(setq	PtLst04	(cons (nth 2 CLst) PtLst04))
								)
								(setq	CoLst04	(list (cadr CLst))
										PtLst04	(list (nth 2 CLst))
								)
							)
						)
					)
					((= (car CLst) 5)
						(if (> (cadr CLst) 0)
							(if CoLst05
								(if (not (member (cadr CLst) CoLst05))
									(setq	CoLst05	(cons (cadr CLst) CoLst05)
											PtLst05	(cons (nth 2 CLst) PtLst05)
									)
									(setq	PtLst05	(cons (nth 2 CLst) PtLst05))
								)
								(setq	CoLst05	(list (cadr CLst))
										PtLst05	(list (nth 2 CLst))
								)
							)
						)
					)
					((= (car CLst) 6)
						(if (> (cadr CLst) 0)
							(if CoLst06
								(if (not (member (cadr CLst) CoLst06))
									(setq	CoLst06	(cons (cadr CLst) CoLst06)
											PtLst06	(cons (nth 2 CLst) PtLst06)
									)
									(setq	PtLst06	(cons (nth 2 CLst) PtLst06))
								)
								(setq	CoLst06	(list (cadr CLst))
										PtLst06	(list (nth 2 CLst))
								)
							)
						)
					)
				)
		)
	)
	(if CoLst01
		(foreach	CItem
				CoLst01
				(setq	PtLst	nil
						DivNo	1
				)
				;(setvar "CECOLOR" (itoa CItem))
				(foreach	DLst
						CoLst
						(if (and (= (nth 0 DLst) DivNo) (= (nth 1 DLst) CItem))
							(if PtLst
								(setq PtLst (cons (last DLst) PtLst))
								(setq PtLst (list (last DLst)))
							)
						)
				)
				(if PtLst
					(command "Pline" (car PtLst) "W" "0.0" "0.0")
				)
				(if (> (length PtLst) 1)
					(mapcar (quote command) (cdr PtLst))
				)
				(if PtLst
					(command "")
				)
		)
	)
	(if CoLst02
		(foreach	CItem
				CoLst02
				(setq	PtLst	nil
						DivNo	2
				)
				;(setvar "CECOLOR" (itoa CItem))
				(foreach	DLst
						CoLst
						(if (and (= (nth 0 DLst) DivNo) (= (nth 1 DLst) CItem))
							(if PtLst
								(setq PtLst (cons (last DLst) PtLst))
								(setq PtLst (list (last DLst)))
							)
						)
				)
				(if PtLst
					(command "Pline" (car PtLst) "W" "0.0" "0.0")
				)
				(if (> (length PtLst) 1)
					(mapcar (quote command) (cdr PtLst))
				)
				(if PtLst
					(command "")
				)
		)
	)
	(if CoLst03
		(foreach	CItem
				CoLst03
				(setq	PtLst	nil
						DivNo	3
				)
				;(setvar "CECOLOR" (itoa CItem))
				(foreach	DLst
						CoLst
						(if (and (= (nth 0 DLst) DivNo) (= (nth 1 DLst) CItem))
							(if PtLst
								(setq PtLst (cons (last DLst) PtLst))
								(setq PtLst (list (last DLst)))
							)
						)
				)
				(if PtLst
					(command "Pline" (car PtLst) "W" "0.0" "0.0")
				)
				(if (> (length PtLst) 1)
					(mapcar (quote command) (cdr PtLst))
				)
				(if PtLst
					(command "")
				)
		)
	)
	(if CoLst04
		(foreach	CItem
				CoLst04
				(setq	PtLst	nil
						DivNo	4
				)
				;(setvar "CECOLOR" (itoa CItem))
				(foreach	DLst
						CoLst
						(if (and (= (nth 0 DLst) DivNo) (= (nth 1 DLst) CItem))
							(if PtLst
								(setq PtLst (cons (last DLst) PtLst))
								(setq PtLst (list (last DLst)))
							)
						)
				)
				(if PtLst
					(command "Pline" (car PtLst) "W" "0.0" "0.0")
				)
				(if (> (length PtLst) 1)
					(mapcar (quote command) (cdr PtLst))
				)
				(if PtLst
					(command "")
				)
		)
	)
	(if CoLst05
		(foreach	CItem
				CoLst05
				(setq	PtLst	nil
						DivNo	5
				)
				;(setvar "CECOLOR" (itoa CItem))
				(foreach	DLst
						CoLst
						(if (and (= (nth 0 DLst) DivNo) (= (nth 1 DLst) CItem))
							(if PtLst
								(setq PtLst (cons (last DLst) PtLst))
								(setq PtLst (list (last DLst)))
							)
						)
				)
				(if PtLst
					(command "Pline" (car PtLst) "W" "0.0" "0.0")
				)
				(if (> (length PtLst) 1)
					(mapcar (quote command) (cdr PtLst))
				)
				(if PtLst
					(command "")
				)
		)
	)
	(if CoLst06
		(foreach	CItem
				CoLst06
				(setq	PtLst	nil
						DivNo	6
				)
				;(setvar "CECOLOR" (itoa CItem))
				(foreach	DLst
						CoLst
						(if (and (= (nth 0 DLst) DivNo) (= (nth 1 DLst) CItem))
							(if PtLst
								(setq PtLst (cons (last DLst) PtLst))
								(setq PtLst (list (last DLst)))
							)
						)
				)
				(if PtLst
					(command "Pline" (car PtLst) "W" "0.0" "0.0")
				)
				(if (> (length PtLst) 1)
					(mapcar (quote command) (cdr PtLst))
				)
				(if PtLst
					(command "")
				)
		)
	)
	(setvar "CECOLOR" ColWas)
	(setvar "CLAYER" LayWas)
	(setvar "OSMODE" OsmWas)
	(setvar "CELTYPE" LtWas)
	(princ)
)

(defun MakOprInserts ( DoOneLst AScl / )		;Places Inserts in Div_Map_Z for Operations
	(if Bug (princ "\n{MakOprInserts entered\n"))
	(setq	ColorWas	(getvar "CECOLOR")
			PtX		(last DoOneLst)
			LocN		(nth 1 DoOneLst)
			BusN		(nth 6 DoOneLst)
			ColorIs	(nth 7 DoOneLst)
			OprN		(nth 8 DoOneLst)
			OprRepN	(nth 9 DoOneLst)
			JustFie	(nth 12 DoOneLst)	;<== was 10 before separate Opr Justifications
			OprShrN	(nth 11 DoOneLst)
			BlkNam	"Office_Mstr"
	)
	(command "Layer" "T" "REG_OperOffice*" "ON" "REG_OperOffice*" "U" "REG_OperOffice*" "S" "REG_OperOffice" "")
	(if Bug
		(setvar "CMDECHO" 1)
	)
	(if (= BusN "None")
		(setq	BusN		" ")
	)
	(if	(= OprRepN "None")
		(progn
			(setq	OprRepN		" ")
			(if (= OprN "None")
				(setq	OprN		" ")
			)
		)
	)
	(if (and (> OprShrN 0) (not (equal OprRepN " ")))
		(progn
			(cond
				((= JustFie 0)
					(setq	BlkNam	"Office_EngMgr_LM2")
				)
				((= JustFie 1)
					(setq	BlkNam	"Office_EngMgr_LM2")
				)
				((= JustFie 2)
					(setq	BlkNam	"Office_EngMgr_LU2")
				)
				((= JustFie 3)
					(setq	BlkNam	"Office_EngMgr_LD2")
				)
				((= JustFie 4)
					(setq	BlkNam	"Office_EngMgr_LF2")
				)
				((= JustFie 5)
					(setq	BlkNam	"Office_EngMgr_MU2")
				)
				((= JustFie -1)
					(setq	BlkNam	"Office_EngMgr_RM2")
				)
				((= JustFie -2)
					(setq	BlkNam	"Office_EngMgr_RU2")
				)
				((= JustFie -3)
					(setq	BlkNam	"Office_EngMgr_RD2")
				)
				((= JustFie -4)
					(setq	BlkNam	"Office_EngMgr_RF2")
				)
				((= JustFie -5)
					(setq	BlkNam	"Office_EngMgr_MD2")
				)
			)
			(command "Insert" BlkNam PtX AScl AScl "0" LocN OprN OprRepN LocN)
		)
		(if (> OprShrN 0)
			(progn
				(cond
					((= JustFie 0)
						(setq	BlkNam	"Office_EngOnL_LM2")
					)
					((= JustFie 1)
						(setq	BlkNam	"Office_EngOnL_LM2")
					)
					((= JustFie 2)
						(setq	BlkNam	"Office_EngOnL_LU2")
					)
					((= JustFie 3)
						(setq	BlkNam	"Office_EngOnL_LD2")
					)
					((= JustFie 4)
						(setq	BlkNam	"Office_EngOnL_LF2")
					)
					((= JustFie 5)
						(setq	BlkNam	"Office_EngOnL_MU2")
					)
					((= JustFie -1)
						(setq	BlkNam	"Office_EngOnL_RM2")
					)
					((= JustFie -2)
						(setq	BlkNam	"Office_EngOnL_RU2")
					)
					((= JustFie -3)
						(setq	BlkNam	"Office_EngOnL_RD2")
					)
					((= JustFie -4)
						(setq	BlkNam	"Office_EngOnL_RF2")
					)
					((= JustFie -5)
						(setq	BlkNam	"Office_EngOnL_MD2")
					)
				)
				(command "Insert" BlkNam PtX AScl AScl "0" LocN OprN LocN)
			)
		)
	)
	(if Bug
		(setvar "CMDECHO" 0)
	)
	(if Bug (princ "\nMakOprInserts exited}\n"))
)

(defun MakOrgLabels ( DoOneLst AScl / )		;Places Text per Org_ID in Div_Map_Z
	(if Bug (princ "\n{MakOrgLabels entered\n"))
	(setq	LocNum	(nth 0 DoOneLst)
			LocNam	(RepLChar (nth 1 DoOneLst) " " "_" 0)
			LocAbNam	(nth 2 DoOneLst)
			PLNam	(strcat "Org_ID_" LocAbNam)
			PLDat	(tblsearch "LAYER" PLNam)
			PLColr	(if PLDat
						(cdr (assoc 62 PLDat))
						7
					)
			ssPL		(ssget "X"	(list	(cons 0 "POLYLINE")
										(cons 8 PLNam)
								)
					)
			PtX		(nth 12 DoOneLst)
			OutStr	(if (<= LocNum 82)
						(strcat (strcase LocNam) "-{" (strcase LocAbNam) "}")
						nil
						;(strcat (strcase LocNam T) "-{" (strcase LocAbNam) "}")
					)
	)
	(if (not (tblsearch "STYLE" "ORGLST"))
		(command "_.Style" "ORGLST" "Romantic" "0" "1" "0" "N" "N")
	)
	(if (not (tblsearch "LAYER" (strcat "Org_ID_" LocAbNam "_Txt")))
		(command "_.Layer" "M" (strcat "Org_ID_" LocAbNam "_Txt") "C" "7" "" "")
		(setvar "CLAYER" (strcat "Org_ID_" LocAbNam "_Txt"))
	)
	(if OutStr
		(command "_.Text" "S" "OrgLst" "J" "M" PtX AScl "0" OutStr)
	)
	(if MovPly
		(progn
			(if ssPL
				(if (not (tblsearch "LAYER" LocNam))
					(command "_.Layer" "M" LocNam "C" PLColr "" "")
					(setvar "CLAYER" LocNam)
				)
			)
			(if ssPL
				(command "_.Move" ssPL "" "0,0" "448800,0" "_.Copy" ssPL "" "448800,0" "0,0" "_.Chprop" ssPL "" "LA" LocNam "")
			)
		)
	)
	(if Bug (princ "\nMakOrgLabels exited}\n"))
)

(defun UpdOrgLst ( OrgLst / )				;Translates LatLong to Adds coords for Org_ID locations
	(if OrgLst
		(setq	LocNum	(nth 0 OrgLst)
				LocNam	(RepLChar (nth 1 OrgLst) " " "_" 0)
				LocAbNam	(nth 2 OrgLst)
				PLNam	(strcat "Org_ID_" LocAbNam)
				PLDat	(tblsearch "LAYER" PLNam)
				PLColr	(if PLDat
							(cdr (assoc 62 PLDat))
							7
						)
				ssPL		(ssget "X"	(list	(cons 0 "POLYLINE")
											(cons 8 PLNam)
									)
						)
				PtX		(transcord "LL83" "UTM27-16" (list (atof (nth 3 OrgLst)) (atof (nth 4 OrgLst))))
				OutLst	(list	LocNum
								(nth 1 OrgLst)
								(nth 2 OrgLst)
								(nth 3 OrgLst)
								(nth 4 OrgLst)
								PLColr
								(rtos (car PtX) 2 6)
								(rtos (cadr PtX) 2 6)
						)
		)
		(setq	OutLst	nil)
	)
	OutLst
)

(defun C:BldDivMap ( /	DLst )				;Builds Div_Map_Z
	(initget "Default" 0)
	(setq	WhaScl	(getreal "\nEnter the scale for blocks: <Enter=2640.0> "))
	(if	(or	(not (numberp WhaScl))
			(<= WhaScl 0.1)
		)
		(setq	WhaScl	2640.0)
	)
	(setq	Fn1		nil
			Inp		nil
			InpLst	nil
			WrkLst	nil
			DoLst	nil
			ColWas	(getvar "CECOLOR")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			CmdWas	(getvar "CMDDIA")
			EchWas	(getvar "CMDECHO")
			FilWas	(getvar "FILEDIA")
			ssGone	(ssget "X" (list (cons -4 "<OR") (cons 2 "Office_EngOne*") (cons 2 "Office_Bus*") (cons -4 "OR>")))
	)
	(command "Layer" "T" "REG_Office*" "ON" "REG_Office*" "U" "REG_Office*" "S" "REG_Office" "")
	(if (not Bug)
		(progn
			(setvar "OSMODE" 0)
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "CELTYPE" "BYLAYER")
		)
	)
	(if ssGone
		(command "_.Erase" ssGone "" "_.Zoom" "E")
		(command "_.Zoom" "E")
	)
	(setq	ssGone	(ssget "X" (list (cons 8 "Reg_Office")(cons 0 "Polyline"))))
	(if ssGone
		(command "_.Erase" ssGone "")
	)
	(if (findfile "OpCenterOut.txt")
		(setq	Fn1		(open (findfile "OpCenterOut.txt") "r"))
		(if (findfile "c:/data/OpCenterOut.txt")
			(setq	Fn1		(open (findfile "c:/data/OpCenterOut.txt") "r"))
			(setq	Fn1		nil)
		)
	)
	(if Fn1
		(setq	Inp	(read-line Fn1))
		(setq	Inp	nil)
	)
	(if Inp
		(setq	InpLst	(read (strcat "(" Inp ")"))
				WrkLst	(list InpLst)
		)
	)
	(if Inp
		(while (setq	Inp	(read-line Fn1))
			(if Inp
				(setq	InpLst	(read (strcat "(" Inp ")"))
						WrkLst	(cons InpLst WrkLst)
				)
			)
		)
	)
	(if InpLst
		(close Fn1)
	)
	(if WrkLst
		(setq	DoLst	(mapcar	(quote	(lambda (x)
											(setq	PtX	(transcord "LL83" "UTM27-16" (list (atof (nth 3 x)) (atof (nth 4 x))))
													LstX	(cons PtX (reverse x))
													LstX	(reverse LstX)
											)
										)
								)
								WrkLst
						)
		)
	)
	(if DoLst
		(foreach DLst DoLst (MakBigInserts DLst WhaScl))
	)
	(if DoLst
		(MakCoLin DoLst)
	)
	(if DoLst
		(princ (strcat "\nCreated {" (itoa (length DoLst)) "} Office Location Blocks"))
	)
	(setvar "CECOLOR" ColWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CMDECHO" EchWas)
	(setvar "FILEDIA" FilWas)
	(princ)
)

(defun C:BldDivView ( /	DLst )				;Builds Division Views for Div_Map_Z
	(initget "Yes No" 1)
	(setq	OprP	(getkword "\nOperations Only: <Yes No> "))
	(if OprP
		(if (wcmatch OprP "No")
			(setq	OprP		nil)
		)
	)
	(if OprP
		(setq	SclDef	20000.0)
		(setq	SclDef	50000.0)
	)
	(initget "Default" 0)
	(setq	WhaScl	(getreal (strcat "\nEnter the scale for views: <Enter=" (rtos SclDef 2 1) "> ")))
	(if	(or	(not (numberp WhaScl))
			(<= WhaScl 0.1)
		)
		(setq	WhaScl	SclDef)
	)
	(setq	Fn1		nil
			Inp		nil
			InpLst	nil
			WrkLst	nil
			DoLst	nil
			ColWas	(getvar "CECOLOR")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			CmdWas	(getvar "CMDDIA")
			EchWas	(getvar "CMDECHO")
			FilWas	(getvar "FILEDIA")
			TmdWas	(getvar "TILEMODE")
	)
	(if (/= TmdWas 1)
		(setvar "TILEMODE" 1)
	)
	(command "_.Zoom" "E")
	(command "_.View" "D" "*")
	(command "_.View" "S" "StateWide")
	(if (not Bug)
		(progn
			(setvar "OSMODE" 0)
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "CELTYPE" "BYLAYER")
		)
	)
	(if (findfile "OpCenterOut.txt")
		(setq	Fn1		(open (findfile "OpCenterOut.txt") "r"))
		(if (findfile "c:/data/OpCenterOut.txt")
			(setq	Fn1		(open (findfile "c:/data/OpCenterOut.txt") "r"))
			(setq	Fn1		nil)
		)
	)
	(if Fn1
		(setq	Inp	(read-line Fn1))
		(setq	Inp	nil)
	)
	(if Inp
		(setq	InpLst	(read (strcat "(" Inp ")"))
				WrkLst	(list InpLst)
		)
	)
	(if Inp
		(while (setq	Inp	(read-line Fn1))
			(if Inp
				(setq	InpLst	(read (strcat "(" Inp ")"))
						WrkLst	(cons InpLst WrkLst)
				)
			)
		)
	)
	(if InpLst
		(close Fn1)
	)
	(if WrkLst
		(setq	DoLst	(mapcar	(quote	(lambda (x)
											(setq	PtX	(transcord "LL83" "UTM27-16" (list (atof (nth 3 x)) (atof (nth 4 x))))
													LstX	(cons PtX (reverse x))
													LstX	(reverse LstX)
											)
										)
								)
								WrkLst
						)
		)
	)
	(if DoLst
		(setq	DoLst	(LstSort DoLst (quote (lambda (x y) (< (nth 1 x) (nth 1 y))))))
	)
	(if DoLst
		(foreach DLst DoLst (MakViews DLst WhaScl OprP))
	)
	(if DoLst
		(princ (strcat "\nCreated {" (itoa (length DoLst)) "} Office Location Views"))
	)
	(setvar "CECOLOR" ColWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CMDECHO" EchWas)
	(setvar "FILEDIA" FilWas)
	(princ)
)

(defun C:BldOprMap ( /	DLst )				;Builds Operations view in Div_Map_Z
	(initget "Default" 0)
	(setq	WhaScl	(getreal "\nEnter the scale for blocks: <Enter=2640.0> "))
	(if	(or	(not (numberp WhaScl))
			(<= WhaScl 0.1)
		)
		(setq	WhaScl	2640.0)
	)
	(setq	Fn1		nil
			Inp		nil
			InpLst	nil
			WrkLst	nil
			DoLst	nil
			ColWas	(getvar "CECOLOR")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			CmdWas	(getvar "CMDDIA")
			EchWas	(getvar "CMDECHO")
			FilWas	(getvar "FILEDIA")
			ssGone	(ssget "X" (list (cons -4 "<OR") (cons 2 "Office_EngMgr*") (cons 2 "Office_EngOnL*") (cons -4 "OR>")))
	)
	(command "Layer" "T" "REG_OperOffice*" "ON" "REG_OperOffice*" "U" "REG_OperOffice*" "S" "REG_OperOffice" "")
	(if (not Bug)
		(progn
			(setvar "OSMODE" 0)
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "CELTYPE" "BYLAYER")
		)
	)
	(if ssGone
		(command "_.Erase" ssGone "" "_.Zoom" "E")
		(command "_.Zoom" "E")
	)
	(setq	ssGone	(ssget "X" (list (cons 8 "REG_OperOffice")(cons 0 "Polyline"))))
	(if ssGone
		(command "_.Erase" ssGone "")
	)
	(if (findfile "OpCenterOut.txt")
		(setq	Fn1		(open (findfile "OpCenterOut.txt") "r"))
		(if (findfile "c:/data/OpCenterOut.txt")
			(setq	Fn1		(open (findfile "c:/data/OpCenterOut.txt") "r"))
			(setq	Fn1		nil)
		)
	)
	(if Fn1
		(setq	Inp	(read-line Fn1))
		(setq	Inp	nil)
	)
	(if Inp
		(setq	InpLst	(read (strcat "(" Inp ")"))
				WrkLst	(list InpLst)
		)
	)
	(if Inp
		(while (setq	Inp	(read-line Fn1))
			(if Inp
				(setq	InpLst	(read (strcat "(" Inp ")"))
						WrkLst	(cons InpLst WrkLst)
				)
			)
		)
	)
	(if InpLst
		(close Fn1)
	)
	(if WrkLst
		(setq	DoLst	(mapcar	(quote	(lambda (x)
											(setq	PtX	(transcord "LL83" "UTM27-16" (list (atof (nth 3 x)) (atof (nth 4 x))))
													LstX	(cons PtX (reverse x))
													LstX	(reverse LstX)
											)
										)
								)
								WrkLst
						)
		)
	)
	(if DoLst
		(foreach DLst DoLst (MakOprInserts DLst WhaScl))
	)
;;;	(if DoLst
;;;		(MakOprCoLin DoLst)
;;;	)
	(if DoLst
		(princ (strcat "\nCreated {" (itoa (length DoLst)) "} Operations Location Blocks"))
	)
	(setvar "CECOLOR" ColWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CMDECHO" EchWas)
	(setvar "FILEDIA" FilWas)
	(princ)
)

(defun C:BldOrgTxt ( /	DLst )				;ReBuilds Org_ID text in Div_Map_Z
	(initget "Default" 0)
	(setq	WhaScl	(getreal "\nEnter the height for text: <Enter=2640.0> "))
	(if	(or	(not (numberp WhaScl))
			(<= WhaScl 0.1)
		)
		(setq	WhaScl	2640.0)
	)
	(setq	Fn1		nil
			Inp		nil
			InpLst	nil
			WrkLst	nil
			DoLst	nil
			ColWas	(getvar "CECOLOR")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			CmdWas	(getvar "CMDDIA")
			EchWas	(getvar "CMDECHO")
			FilWas	(getvar "FILEDIA")
	)
	(if (not Bug)
		(progn
			(setvar "OSMODE" 0)
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "CELTYPE" "BYLAYER")
		)
	)
	(command "_.UNDO" "_BE")
	(command "Layer" "T" "Org_Id_???_Name" "ON" "Org_Id_???_Name" "U" "Org_Id_???_Name" "S" "0" "" "_.Zoom" "E")
	(setq	ssGone	(ssget "X" (list (cons -4 "<AND") (cons 0 "TEXT") (cons 8 "Org_Id_???_Name") (cons -4 "AND>"))))
	(if ssGone
		(command "_.Erase" ssGone "")
	)
	(if MovPly
		(command "_.Pan" "224400,0" "0,0")
	)
	(if (findfile "OpCenterOut.txt")
		(setq	Fn1		(open (findfile "OpCenterOut.txt") "r"))
		(if (findfile "c:/data/OpCenterOut.txt")
			(setq	Fn1		(open (findfile "c:/data/OpCenterOut.txt") "r"))
			(setq	Fn1		nil)
		)
	)
	(if Fn1
		(setq	Inp	(read-line Fn1))
		(setq	Inp	nil)
	)
	(if Inp
		(setq	InpLst	(read (strcat "(" Inp ")"))
				WrkLst	(list InpLst)
		)
	)
	(if Inp
		(while (setq	Inp	(read-line Fn1))
			(if Inp
				(setq	InpLst	(read (strcat "(" Inp ")"))
						WrkLst	(cons InpLst WrkLst)
				)
			)
		)
	)
	(if InpLst
		(close Fn1)
	)
	(if WrkLst
		(setq	DoLst	(mapcar	(quote	(lambda (x)
											(setq	PtX	(transcord "LL83" "UTM27-16" (list (atof (nth 3 x)) (atof (nth 4 x))))
													LstX	(cons PtX (reverse x))
													LstX	(reverse LstX)
											)
										)
								)
								WrkLst
						)
		)
	)
	(if DoLst
		(foreach	DLst
				DoLst
				(MakOrgLabels DLst WhaScl)
		)
	)
	(if DoLst
		(princ (strcat "\nCreated {" (itoa (length DoLst)) "} Org_ID Location Labels"))
	)
	(command "_.UNDO" "_EN")
	(setvar "CECOLOR" ColWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CMDECHO" EchWas)
	(setvar "FILEDIA" FilWas)
	(princ)
)

(setq	LodVer	"2.5.3k")
