(if AppNam								; Code Version Indicator {633 Lines of Code}
	(princ (strcat "\n" AppNam " Fnct1 Loading."))
	(princ "\nAdds Fnct1 Loading.")
)

(defun MMsg ( msg_num msg_arg / )				; display messages when called from a menu
; Function: display messages when called from a menu (overcomes problems
;           printing directly from a menu)
; parameters:  msg_num - indicates which message to display
;              msg_arg - a string argument to be included in the message
   (if Bug (princ "mmsg entered/exited"))
   (cond
      ((= msg_num 1)
        (princ (strcat "\n\nMenu Selection #" msg_arg " is not defined "))
      )
      ((= msg_num 2)
        (princ (strcat "\n\n" msg_arg " is not available until a panel is loaded "))
      )
   ;otherwise
      (T (princ (strcat "\n\nNo message defined for #" (itoa msg_num))))
   );endcond
   (setq msg_num nil
         msg_arg nil)
   (princ)
)

(defun AddSc ( pnam /	newsff )				; creates a 'scale' attribute for a new panel
; Function: creates a 'scale' attribute for a new panel
   (if Bug (princ "AddSc entered"))
   (initget 6 "500 1000 2000")
   (setq newsff (getkword
      (strcat "\n\nEnter scale factor [500, 1000, or 2000] for panel "
              pnam " <500>: "))
   )
   (if (not newsff) (setq newsff "500"))
   (command	"_.LAYER" "S" "0" "")
   (command "ATTDEF" "" pnam "Panel scale factor" newsff
               (list (atof (strcat (substr pnam 1 3) "010"))
                     (atof (strcat (substr pnam 4 4) "010")) 0.0) "0.2" "0")
   (command "CHPROP" (entlast) "" "LA" "----SC----" "")
   (if Bug (princ "AddSc exited"))
   (princ)
)

(defun PFIND ( /	aper chkou chkph )			; Retrieves pline info and determines insertion point
; Function:   Retrieves polyline information and determines insertion point
; Global Out: m, slope - is the slope in radians/degrees respectfully
;           : mp, slopep - is the perpendicular in rad./deg. respectfully
;           : ipt - is the insertion point using object snap (ctr pline)
;           : plname - is name of polyline
;           : hlfwth - is distance from center to edge of polyline
;           : plthk  - is the thickness of the polyline.
;           : pfent - is NAME OF ENTITY & SEL> PT.; then used for ENTITY LIST
;           : spt - is point on edge of polyline selected
;           : cpt - is OSNAP of spt
	(if Bug (princ "pfind entered"))
	(setq	aper		(getvar "APERTURE") ;--Save current setting
			pfent	nil
	)
;--Had problem when these two were different sizes - force to same
	(setvar "APERTURE" (getvar "PICKBOX"))
	(if (/= (strcase Mouse) "YES") (command "TABLET" "OFF"))
	(while (null pfent)
		(if (setq pfent (entsel "\n Select polyline (Use button 0): "))
			(progn
				(setq	spt		(cadr pfent)) ; sets <spt> to point on edge of poly.
				(setq	cpt		(osnap spt "NEA")) ; sets <cpt> to nearest point of <spt>
				(while (equal spt cpt 0.0001)
					(princ "\n\n")
					(princ "\n*** Cancel this operation - Press <Ctrl>C...*** ")
					(princ "\nStart symbol insertion again and DON'T USE OBJECT SNAP for 1st pick!")
					(read-line)
				)
				(setq	pfent	(entget (car pfent))) ;sets <pfent> to entity list of <pfent>
				(if (/= (cdr (assoc 0 pfent)) "POLYLINE")
					(progn
						(princ "\n\nSelected entity was not a POLYLINE...Please retry!")
						(setq	pfent	nil)
					)
				)
			)
		)
	)
	(if (= (car spt) (car cpt))  ;---to avoid a divide-by-zero problem for
		(setq	m	0                  ;   horizontal lines
				mp	(/ pi 2)
		)
		(progn
			(setq	mp	(atan (/ (- (cadr spt) (cadr cpt)) (- (car spt) (car cpt)))))
			(if (> mp 0)
				(setq	m	(- mp (/ pi 2)))
				(progn
					(setq	m	(+ mp (/ pi 2)))
					(setq	mp	(+ mp pi))
				)
			)
		)
	)
	(setq	slope	(/ (* m 180.0) pi)
			perpm	(+ m (/ pi 2))
			slopep	(/ (* perpm 180.0) pi)
			plname	(cdr (assoc 8 pfent))
;;;			hlfwth	(* (cdr (assoc 40 pfent)) 0.5)	; old method for pline width set
			hlfwth	(if (and Lst_Ph_W SF)
						(* 0.5 (nth (atoi (substr (cdr (assoc 8 pfent)) 8 1)) Lst_Ph_W) SF)
						(if (not Lst_Ph_W)
							(alert "Tables not loaded!")
							(if (not SF)
								(progn
									(SetScale)
									(* 0.5 (nth (atoi (substr (cdr (assoc 8 pfent)) 8 1)) Lst_Ph_W) SF)
								)
							)
						)
					)
	)
	(if (assoc 39 pfent)
		(setq	plthk	(cdr (assoc 39 pfent)))
		(setq	plthk	0.0)
	)
; --------------------------------------------------------------------------
; | The following inactive lines were added in an attempt to make the      |
; | "redefine" message optional.  The problem with this is that it affects |
; | the number of user responses required, thus fouling up the number of   |
; | pauses in the menu items which initiate symbol insertions.             |
; --------------------------------------------------------------------------
; (setq ipt nil)
; (if (not aflag) (progn
	(princ "\n\nPress <Enter> to use existing insertion point or")
    (setq	ipt	(Getpoint "\n  use OSNAP to redefine point: "))
; ))
	(if (null ipt)
		(setq	ipt	cpt)
		(setq	ipt	(osnap ipt "NEA"))
	)
;	(chklay plname)	; Trying to Isolate ChkLay and remove it! GEW
	(if plname
		(setvar "CLAYER" plname)
	)
	(setvar "APERTURE" aper)
	(if Bug (princ "pfind exited"))
)

(defun GetLay ( flag /	ent elist elayer )		; Returns the layer name of the selected entity
; Function: Returns the layer name of the selected entity--
;           Non-nil 'flag' forces layer to be type specified by 'flag'
	(if Bug (princ "\n{GetLay entered"))
	(cond
		((null flag)
			(while (null elayer)
				(princ "\n \nSelect an entity.  This will set the layer")
				(setq	ent	(car (entsel "\n  for the next symbol insertion...")))
				(if ent (setq elist (entget ent)))
				(if elist (setq elayer (cdr (assoc 8 elist))))
			)
		)
		(T
			(setq	elayer	"----------")
			(while (/= (substr elayer 5 2) flag)
				(princ	(strcat	"\nSelect an entity of type " flag
								".\nThis will set the layer"
						)
				)
				(setq	ent	(car (entsel "\n  for the next symbol insertion...")))
				(if ent (setq elist (entget ent)))
				(if elist (setq elayer (cdr (assoc 8 elist))))
			)
		)
	)
	(if elayer
		(setvar "CLAYER" elayer)
	)
	(if Bug (princ "\nGetLay exited}\n"))
	elayer
)

(defun ChkLay ( laynm /	subfd )				; Check 'subfdlst', update it and build new layers
; Function:  Check 'subfdlst', update it and build new layers if needed
; Global:    subfdlst - list of substation-feeder combos for which layers
;                       have already been created
;            kv - global that is set here
	(if Bug (princ "chklay entered"))
	(setq	subfd	(substr laynm 1 3))
	(if (not (member subfd subfdlst))
		(progn
			(setq	subfdlst	(cons subfd subfdlst)
					kv		(substr laynm 9 2)
					new		"C"
					clayer	laynm
			)
			(callcl nil)
		)
	)
	(if Bug (princ "chklay exited"))
	(princ)
)

(defun C:GETQUAD ( /	id-pt idX idY qname		; Gets Quads
					fname ln lastln no )
  (command	"_.LAYER" "T" "----DLG---" "S" "----DLG---" ""
           "LIMITS" "OFF")
  (setq id-pt (getpoint "Please pick a point in the desired quad: ")
        idX (car id-pt)
        idY (cadr id-pt)
        qname NIL
        fname (open (strcat _PATH-DLG "quadindx") "r"))
  (setq ln (read-line fname))
  (while (AND ln (NOT qname))
    (if (< idX (atof (substr ln 1 6)))
          (setq ln (read-line fname))
          (setq qname (substr ln 16 8))
        )
  )
  (if qname
     (progn
       (setq qname NIL)
       (while (AND ln (NOT qname))
         (if (< idY (atof (substr ln 8 7)))
           (setq qname (substr ln 16 8))
           (setq lastln ln
                 ln (read-line fname))
         )

       )
     )
   )
  (close fname)
  (if (= ln NIL)
    (princ "NO QUAD FOUND")
    (progn
         (setq no 8)
          (setq qname (substr lastln 16 8))
          (while (= (substr qname no 1) " ") (setq no (1- no)))
          (setq qname (substr lastln 16 no))
          (command "INSERT" (strcat _PATH-DLG qname) "0,0" "" "" "")
    )
  )
)

(defun 0Thk ( clr /	C Eset )				; Creates a list of points
;  0Thk(clr) - Creates a list of points, PtLst, where entities are with THICKNESS < 1.0
;            - Excludes entities on layers: "----SC----", "----FMT---"
	(setq	Eset		(ssget "X"	(list	(cons -4 "<NOT")
											(cons -4 "<OR")
												(cons 8 "----SC----")
												(cons 8 "----GRD---")
												(cons 8 "----FMT---")
											(cons -4 "OR>")
										(cons -4 "NOT>")
										(cons 0 "POLYLINE")
										(cons -4 "<")
										(cons 39 1.0)
								
								)
					)
			C		0
			PtLst	nil
	)
	(if Eset
		(repeat (sslength Eset)
			(setq	PtLst	(cons (cdr (assoc 10 (entget (entnext (ssname Eset C))))) PtLst))
			(setq	C		(1+ C))
		)
	)
	(if PtLst
		(show clr)
	)
	(if PtLst
		(princ (strcat "\nNumber of entities found: " (itoa (length PtLst))))
	)
	(princ)
)

(defun 0Len ( clr /	C PLSET Vtx1 Vtx2 )		; Creates a list of points
;  0Len(clr) - Creates a list of points, PtLst, where polylines length is Zero.
  (setq PtLst nil
        C 0)
  (if (setq PLSET (ssget "X" (list (cons 0 "POLYLINE"))))
    (while (setq PLNAME (ssname PLSET C))
      (setq Vtx1 (entnext PLNAME)
            Vtx2 (entnext Vtx1))
      (if (and (= (cdr (assoc 0 (entget (entnext Vtx2)))) "SEQEND")
               (equal (cdr (assoc 10 (entget Vtx1))) (cdr (assoc 10 (entget Vtx2))) 0.001))
        (setq PtLst (cons (cdr (assoc 10 (entget Vtx1))) PtLst))
      )
      (setq C (1+ C))
    )
  )
  (if PtLst
    (progn
      (show clr)
      (strcat "Number of entities found: " (itoa (length PtLst)))
    )
  )
)

(defun SHOW ( clr /	ctr shift llx lly urx	; DRAW CIRCLES AROUND POINTS
					ury PT )
; DRAW CIRCLES AROUND POINTS, PtLst.
   (setq ctr (getvar "VIEWCTR")
         shift (getvar "VIEWSIZE")
         llx (- (car ctr) shift)
         lly (- (cadr ctr) shift)
         urx (+ (car ctr) shift)
         ury (+ (cadr ctr) shift))
   (FOREACH PT PtLst
     (if (not (or (> (car PT) urx) (< (car PT) llx) (> (cadr PT) ury) (< (cadr PT) lly)))
        (CIR PT clr)
     )
   )
   (strcat "Number of entities found: " (itoa (length PtLst)))
)

(defun C:SL ( /	ENT LAYNAM )				; sets layer to that of object
        ; This command set the AutoCAD LAYER to the layer of the object you pick.
        (setvar "CMDECHO" 0)
        (if (setq ENT (entsel "Select object that is in the LAYER you wish to set: "))
          (progn
            (setq LAYNAM (cdr (assoc 8 (entget (car ENT)))))
            (command	"_.LAYER" "S" LAYNAM "")
            (princ (strcat "The current layer is: " LAYNAM))
          )
          (princ "You did not select an object.")
        )
        (princ)
)

(defun C:UtmLL ( / )						; convert utm to lat/lon
;  convert utm to lat/lon
;  uses fortran program UTM_LL
;  11/10/88
;  Lum M. Loo
;
	(setvar "COORDS" 1)
	(setq	w	(GRAPHSCR))
	(setq	utm	(getpoint "\nEnter point to convert to LAT LON "))
	(setq	y	(cadr utm))
	(setq	x	(car utm))
	(setq	y1	(rtos y 2 3))
	(setq	x1	(rtos x 2 3))
	(setq	xy	(strcat x1 " " y1))
	(setq	f	(open "utm.dat" "w"))
	(write-line xy f)
	(setq	eof	(close f))
	(setq	z	(command "shell" (strcat _path-lisp "utm_ll")))
	(setq	w	(GRAPHSCR))
	(setq	o	(open "ll.dat" "r"))
	(setq	ll	(read-line o))
	(setq	eof	(close o))
	(list ll)
)

(defun C:CPSEL ( /	scmde sf pt1 pt2 temp ss1	; Function to scale computer points
				ss2 ss3 msize cnt2 ename ent1 tp scpt count temp nwide chk )
;Function to scale computer points
;
;C:CPSEL command
   (setq scmde (getvar "cmdecho"))
   (setvar "cmdecho" 0)
   (setq chk "A")
   (princ "\nScale ALL or SELECT (A/S) <")
   (princ chk)
   (setq temp (getstring ">: "))
   (if temp (setq chk temp))
   (if (equal "S" (strcase chk))
       (progn
           (setq sf (getreal "\nScale Factor: "))                     ;get scale factor
           (setq pt1 (getpoint "\nFirst Corner: "))
           (setq pt2 (getcorner pt1 "\nSecond Corner: "))
           (princ "\nThinking...")
           (setq ss1 (ssget "w" pt1 pt2))                                   ;store all entities to
           (setq ss2 (ssget "x" (list (cons 2 "cp"))))
           (setq ss3 (ssadd))
           (setq msize (sslength ss2))
           (setq cnt2 0)
           (while (< cnt2 msize)
               (if (setq ename (ssmemb (ssname ss2 cnt2) ss1))
                 (progn
                   (ssadd ename ss3)
                   (redraw ename 3)
                 )
               ); end if
               (setq cnt2 (1+ cnt2))
           ); end while
           (setq count 0)                                                   ;selection set (ss1)
           (princ "\nDrawing..." )
           (while (setq entmp (ssname ss3 count))                           ;while entity name not nil
               (setq enm (entnext entmp))
               (setq ent1 (entget enm))                                   ;get list of properties of entity
               (setq scpt (cdr (assoc 10 ent1)))                            ;get insert point
               (setq sz (cdr (assoc 40 ent1)))
               (setq sz (* sz sf))
               (setq ent1 (subst (cons 40 sz) (assoc 40 ent1) ent1))
               (entmod ent1)
               (entupd enm)
               (setq count (1+ count))                                      ;increment counter
           ); end while                                                     ;end of loop
           (setvar "cmdecho" scmde)
       ); end progn
   ;else
       (progn
           (setq sf (getreal "\nInput Scale Factor: "))       ;get scale factor
           (setq ss1 (ssget "x" (list (cons 2 "cp"))))        ;store all point numbers to
           (setq count 0)                                     ;selection set (ss1)
           (while (setq entmp (ssname ss1 count))             ;while entity name not nil
               (setq enm (entnext entmp))
               (setq ent1 (entget enm))                                   ;get list of properties of entity
               (setq scpt (cdr (assoc 10 ent1)))                            ;get insert point
               (setq sz (cdr (assoc 40 ent1)))
               (setq sz (* sz sf))
               (setq ent1 (subst (cons 40 sz) (assoc 40 ent1) ent1))   ;
               (entmod ent1)
               (entupd enm)
               (setq count (1+ count))                                      ;increment counter
           ); end while                                       ;end of loop
           (setvar "cmdecho" scmde)
       ); end progn
   ); end if
   (princ)
)

(defun Cp_Au ( /	cpnum incr lname fdr ipt		; insertion of computer points and numbers
				pfent spt cpt m slope pos omod mp slopep plname hlfwth plthk ipt )
;  Function:  Automates the insertion of computer points and numbers
;
  (if Bug (print "cp_au entered"))
	(if (or (not SF) (not SFF))
		(SetScale)
	)
  (initget 7)
  (setq cpnum (getreal "\n \nEnter the starting Computer Point Number: "))
  (initget 6)
  (setq incr (getint "\n \nEnter the number to increment each time <default 10>: "))
  (princ "\n \n \n            <<<<<< Press <Ctrl>C to cancel... >>>>>>")
  (if (not incr) (setq incr 10))
	(setq	SymLst	(SymSizN "CP")
			Gap		(nth 0 SymLst)
			Lngth	(nth 1 SymLst)
			SymNam	(nth 2 SymLst)
	)
  (initget  1 "F O")
  (if (= "O" (getkword "\n \nMake computer points Freestanding or On-line [F or O]? "))
    ;--This part of routine handles CP's which are to be "online"
    (while T   ;--set up endless loop (user must Cancel out of it)
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
      (setq lname (strcat (substr plname 1 3) "-CP--" (substr plname 9 2)))
      (command	"_.LAYER" "T" lname
                       "S" lname ""
               "INSERT" (strcat _PATH-SYM "CP") ipt (* Lngth sf) "" slope
                        (rtos cpnum 2 0))
      (setthk (entget (entlast)))  ;sets thickness
      (Att-MR)
      (Drw_Arr nil)
      (setq cpnum (+ cpnum incr))  ;--increment the CP number
    );endwhile
  ;else
    ;--This part of routine handles CP's which are to be "freestanding"
    (progn
      (setq lname (getlay "CK"))
      (setq lname (strcat (substr lname 1 3) "-CP--" (substr lname 9 2)))
      (command	"_.LAYER" "T" lname
                       "S" lname "")
      (setq fdr (itoa (- (ascii (substr lname 3 1)) 64)))
      (setq cptype nil
            lname nil)
      (while T  ;--endless loop
        ;--Remind user that he should stay on selected feeder--
        (setq ipt (getpoint
               (strcat "\nPick insertion point...Feeder # " fdr)))
        (if ipt (progn
          (command "INSERT" (strcat _PATH-SYM "CP") ipt (* Lngth sf) "" ""
                            (rtos cpnum 2 0))
          (setthk (entget (entlast)))  ;sets thickness
          (Att-MR)
          (Drw_Arr nil)
          (setq cpnum (+ cpnum incr)) ;--increment the CP number
        ))
      );endwhile
    )
  )
)

(defun P_Find ( /	aper pfent spt cpt m mp		; Retrieves pline info and determines insertion point
				slope perpm slopep plname hlfwth plthk ipt plname )
; Function:   Retrieves polyline information and determines insertion point
; Global Out: m, slope - is the slope in radians/degrees respectfully
;           : mp, slopep - is the perpendicular in rad./deg. respectfully
;           : ipt - is the insertion point using object snap (ctr pline)
;           : plname - is name of polyline
;           : hlfwth - is distance from center to edge of polyline
;           : plthk  - is the thickness of the polyline.
;           : pfent - is NAME OF ENTITY & SEL> PT.; then used for ENTITY LIST
;           : spt - is point on edge of polyline selected
;           : cpt - is OSNAP of spt
	(if Bug (princ "P_Find entered"))
	(setq	aper		(getvar "APERTURE") ;--Save current setting
			pfent	nil
	)
	(setvar "APERTURE" (getvar "PICKBOX"))
	(if (/= (strcase Mouse) "YES") (command "TABLET" "OFF"))
	(while (null pfent)
		(if (setq pfent (entsel "\n Select polyline (Use button 0): "))
			(progn
				(setq	spt		(cadr pfent)) ; sets <spt> to point on edge of poly.
				(setq	cpt		(osnap spt "NEA")) ; sets <cpt> to nearest point of <spt>
				(while (equal spt cpt 0.0001)
					(princ "\n\n")
					(princ "\n*** Cancel this operation - Press <Ctrl>C...*** ")
					(princ "\nStart symbol insertion again and DON'T USE OBJECT SNAP for 1st pick!")
					(read-line)
				)
				(setq	pfent	(entget (car pfent))) ;sets <pfent> to entity list of <pfent>
				(if (/= (cdr (assoc 0 pfent)) "POLYLINE")
					(progn
						(princ "\n\nSelected entity was not a POLYLINE...Please retry!")
						(setq	pfent	nil)
					)
				)
			)
		)
	)
	(if (= (car spt) (car cpt))  ;---to avoid a divide-by-zero problem for
		(setq	m	0                  ;   horizontal lines
				mp	(/ pi 2)
		)
		(progn
			(setq	mp	(atan (/ (- (cadr spt) (cadr cpt)) (- (car spt) (car cpt)))))
			(if (> mp 0)
				(setq	m	(- mp (/ pi 2)))
				(setq	m	(+ mp (/ pi 2))
						mp	(+ mp pi)
				)
			)
		)
	)
	(setq	slope	(/ (* m 180.0) pi)
			perpm	(+ m (/ pi 2))
			slopep	(/ (* perpm 180.0) pi)
			plname	(cdr (assoc 8 pfent))
			hlfwth	(if (and Lst_Ph_W SF)
						(* 0.5 (nth (atoi (substr (cdr (assoc 8 pfent)) 8 1)) Lst_Ph_W) SF)
						(if (not Lst_Ph_W)
							(alert "Tables not loaded!")
							(if (not SF)
								(progn
									(SetScale)
									(* 0.5 (nth (atoi (substr (cdr (assoc 8 pfent)) 8 1)) Lst_Ph_W) SF)
								)
							)
						)
					)
	)
	(if (assoc 39 pfent)
		(setq	plthk	(cdr (assoc 39 pfent)))
		(setq	plthk	0.0)
	)
	(princ "\n\nPress <Enter> to use existing insertion point or")
    (setq	ipt	(Getpoint "\n  use OSNAP to redefine point: "))
	(if (null ipt)
		(setq	ipt	cpt)
		(setq	ipt	(osnap ipt "NEA"))
	)
	(if plname
		(setvar "CLAYER" plname)
	)
	(setvar "APERTURE" aper)
	(if Bug (princ "pfind exited"))
	(list ipt plname plthk)
)

(defun C:CP_au3 ( /	LayDat ipt plname pfthk ); insertion of computer points and numbers
;  Function:  Automates the insertion of computer points and numbers
;	cpnum incr 
	(if Bug (print "CP_au3 entered"))
	(if (or (not SF) (not SFF))
		(SetScale)
	)
	(initget 7)
	(setq	cpnum	(getreal "\n \nEnter the starting Computer Point Number: "))
	(initget 6)
	(setq	incr		(getint "\n \nEnter the number to increment each time <default 10>: "))
	(princ "\n \n \n            <<<<<< Press <Esc> to cancel... >>>>>>")
	(if (not incr)
		(setq incr 10)
	)
	(setq	SymLst	(SymSizN "CP"))
	(if SymLst
		(setq	gap		(nth 0 SymLst)
				Lngth	(nth 1 SymLst)
				symnam	(nth 2 SymLst)
		)
	)
	(setq	LayDat	(P_Find)
			ipt		(nth 0 LayDat)
			plname	(nth 1 LayDat)
			pfthk	(nth 2 LayDat)
	)
	(initget  1 "F O")
	(if (= "O" (getkword "\n \nMake computer points Freestanding or On-line [F or O]? "))
		(while T   ;--set up endless loop (user must Cancel out of it)
			(CP_Ins "O" cpnum plname Lngth)
;			(CP_Ins "O" (rtos cpnum 2 0) plname Lngth)
			(setq cpnum (+ cpnum incr))  ;--increment the CP number
		)
		(while T   ;--set up endless loop (user must Cancel out of it)
			(CP_Ins "F" cpnum plname Lngth)
;			(CP_Ins "F" (rtos cpnum 2 0) plname Lngth)
			(setq cpnum (+ cpnum incr))  ;--increment the CP number
		)
	)
	(if Bug (print "CP_au3 exited"))
)

(setq	LodVer	"2.5.1b")
