(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " Fixit Loading."))
	(princ "\nAdds Fixit Loading.")
)

(defun FixSc ( / )							; changes the 'scale' attribute for an panel
;==============================================================================
;                              FIXIT.LSP
;==============================================================================
; Routines in this file are special "fixit" routines
;------------------------------------------------------------------------------
; Name:     fixsc
; Function: changes the 'scale' attribute for an existing panel
;
   (if Bug (print "fixsc entered"))
   (command)
   (if (> (length PanLst) 1)
     (progn
       (initget 1)
       (setq pt (getpoint "\n\nSelect a panel\n"))
       (setq ptx (fix (/ (car pt) XPanel))
             pty (fix (/ (cadr pt) YPanel)))
       (setq ptx (* ptx XPanel)
             pty (* pty YPanel))
       (if (member (setq pan (BldFn ptx pty)) PanLst)
         (setq sff (dispsc pan))
       ;else
         (progn
           (princ "\n \n")
           (princ (strcat "***" AppNam " Error*** Selected point must be within panel boundaries\n"))
         )
       )
     )
   ;else
     (setq pan (nth 0 PanLst))
   )
   (setq scset (ssget "X" (list (cons 8 "----SC----")))
         aflg nil
         count 0)
   (if (null scset) (progn
     (setlim)
     (command "VIEW" "R" "ALL")
     (setq sclist '())
     (foreach pnam PanLst
        (AddSc pnam)
        (setq scset (ssget "X" (list (cons 8 "----SC----")))
              aflg T)
     )
   ))
   (if (not aflg) (progn
     (initget 6 "500 1000 2000")
     (setq sff (getkword
        (strcat "\n\nEnter new scale factor [500, 1000, or 2000] for panel "
                pan " <500>: "))
     )
     (if (not sff) (setq sff "500"))
     (setq sclist '())
     (while (setq ent (ssname scset count))
       (setq entlst (entget ent))
       (if (and (= (setq enttyp (cdr (assoc 3 entlst))) "Panel scale factor")
                (= (cdr (assoc 2 entlst)) pan))
         (progn
            (setq entlst (subst (cons 1 sff) (assoc 1 entlst) entlst))
            (entmod entlst)
            (entupd ent)
            (setq sclist (append (list pan sff) sclist))
         )
       ;else
         (setq sclist (append (list (cdr (assoc 2 entlst)) (cdr (assoc 1 entlst)))
                              sclist))
       )
       (setq count (1+ count))
     )
     (setq sff (atoi sff))
     (setq sf (* sff 0.3048))
     (if (or (not sclist) (not (member pan sclist))) (progn
       (command	"_.LAYER" "S" "0" "")
       (if (onscrn (list (atof (strcat (substr pan 1 3) "010"))
                         (atof (strcat (substr pan 4 4) "010")) 0.0))
         (progn
           (command "ATTDEF" "" pan "Panel scale factor" sff
                       (list (atof (strcat (substr pan 1 3) "010"))
                             (atof (strcat (substr pan 4 4) "010")) 0.0) "0.2" "0")
           (command "CHPROP" (list (atof (strcat (substr pan 1 3) "010"))
                             (atof (strcat (substr pan 4 4) "010")) 0.0) "" "LA"
                             "----SC----" "")
           (if (not sclist) (setq sclist '()))
           (setq sclist (append (list pan (itoa sff)) sclist))
         )
         ;else
		(princ	(strcat	"***"	AppNam
						" Error*** Lower left corner of panel "
						pan " must be on screen\n"
				)
		)
       )
     ))
   ))
   (if Bug (print "fixsc exited"))
)

(defun OnScrn ( pt / )						; Tests point for onscreen
;------------------------------------------------------------------------------
; Name:   onscrn
; Function: determine if point is on screen and therefore object can be selected
; parameters:  pt - point in question
; date:        12-07-90
;
  (if (and (> (car pt) (car (getvar "VSMIN")))
           (< (car pt) (car (getvar "VSMAX")))
           (> (cadr pt) (cadr (getvar "VSMIN")))
           (< (cadr pt) (cadr (getvar "VSMAX"))))
      (setq pt T)
  )
)

(defun FixDup ( /	box eset sset nument count	; Fix duplicates
				pcnt ent entlst enttyp subent1 sublst1 pt1x pt1y count2 tset ent2
				entlst2 subent2 sublst2 subent3 subent4 sublst3 sublst4 )
; Name:      fixdup
; Function:  Find and erase duplicated entities
;
;
  (if Bug (print "fixdup routine"))
  (command "REGENAUTO" "ON"
           "_.LAYER" "S" "0" "T" "*" "ON" "*" ""
           "REGENAUTO" "OFF")
  (command "VIEW" "R" "ALL")  ;to avoid problems with ssget "C"
  (setq box 1.0)
  (setq eset (ssadd))
  (if (setq sset (ssget "X")) (progn
    (princ (strcat "\n\n" (itoa (setq nument (sslength sset)))
                    " entities to be processed\n"))
    (princ "Processing entitity    1")
    (setq count 0
          pcnt 1)
    (while (setq ent (ssname sset count))
      (if (< pcnt 10)
         (princ (strcat "\010" (itoa pcnt)))
         ;else
         (if (< pcnt 100)
           (princ (strcat "\010\010" (itoa pcnt)))
           ;else
           (if (< pcnt 1000)
             (princ (strcat "\010\010\010" (itoa pcnt)))
             ;else
             (princ (strcat "\010\010\010\010" (itoa pcnt)))
           )
         )
      )
      (if (not (ssmemb ent eset)) (progn
         (setq entlst (entget ent)
               enttyp (cdr (assoc 0 entlst)))
         (cond
           ((= enttyp "POLYLINE")
             (setq subent1 (entnext ent))
             (setq sublst1 (entget subent1))
             (setq pt1x (car (cdr (assoc 10 sublst1)))
                   pt1y (cadr (cdr (assoc 10 sublst1))))
             (setq count2 0)
             (while (and (not (setq tset
                                 (ssget "C" (list (- pt1x box) (- pt1y box) 0.0)
                                            (list (+ pt1x box) (+ pt1y box)) 0.0)))
                         (< box 50.0)
                    )
               (setq box (+ box 1.0))
             )
             (setq box 1.0)
             (if (ssmemb ent tset) (ssdel ent tset))
             (if (> (sslength tset) 0)
               (progn
                 (while (setq ent2 (ssname tset count2))
                   (if (and (not (ssmemb ent2 eset)) (/= ent ent2)) (progn
                     (setq entlst2 (entget ent2))
                     (if (equal (cdr entlst) (cdr entlst2)) (progn
                       (setq subent2 (entnext ent2))
                       (setq sublst2 (entget subent2))
                       (if (equal (cdr sublst1) (cdr sublst2)) (progn
                         (setq subent3 (entnext subent1)
                               subent4 (entnext subent2))
                         (setq sublst3 (entget subent3)
                               sublst4 (entget subent4))
                         (if (equal (cdr sublst3) (cdr sublst4)) (progn
                           (ssadd ent2 eset)
                           (ssdel ent2 sset)  ;won't be checked for dups
                           (setq pcnt (1+ pcnt))
                         ))
                       ))
                     ))
                   ))
                   (setq count2 (1+ count2))
                 )
               )
             )
           )
           ((or (= enttyp "INSERT") (= enttyp "TEXT") (= enttyp "ATTDEF"))
             (setq pt1x (car (cdr (assoc 10 entlst)))
                   pt1y (cadr (cdr (assoc 10 entlst))))
             (setq count2 0)
             (while (not (setq tset
                             (ssget "C" (list (- pt1x box) (- pt1y box) 0.0)
                                        (list (+ pt1x box) (+ pt1y box)) 0.0)))
               (setq box (+ box 1.0))
             )
             (setq box 1.0)
             (if (ssmemb ent tset) (ssdel ent tset))
             (if (> (sslength tset) 0)
               (progn
                 (while (setq ent2 (ssname tset count2))
                   (if (and (not (ssmemb ent2 eset)) (/= ent2 ent)) (progn
                     (setq entlst2 (entget ent2))
                     (if (equal (cdr entlst) (cdr entlst2)) (progn
                       (ssadd ent2 eset)
                       (ssdel ent2 sset)   ;won't be checked for dups
                       (setq pcnt (1+ pcnt))
                     ))
                   ))
                   (setq count2 (1+ count2))
                 )
               )
             )
           )
           ;otherwise
           (T
             (princ (strcat enttyp "not processed"))
           )
         );endcond
      ))
      (setq count (1+ count)
            pcnt (1+ pcnt))
    );endwhile
  ))
  (setq count 0)
  (while (setq ent (ssname eset count))
    (entdel ent)
    (setq count (1+ count))
  )
  (if (< pcnt 10)
     (princ (strcat "\010" (itoa pcnt)))
     ;else
     (if (< pcnt 100)
       (princ (strcat "\010\010" (itoa pcnt)))
       ;else
       (if (< pcnt 1000)
         (princ (strcat "\010\010\010" (itoa pcnt)))
         ;else
         (princ (strcat "\010\010\010\010" (itoa pcnt)))
       )
     )
  )
  (princ (strcat "\n" (itoa (sslength eset)) " duplicate entities removed"))
  (command "REGEN")
  (princ)
);end fixdup

(defun FixLine ( /	inscal sset sf count ent		; Fix Lines
				entlst )
;!fixline - Fix widths of all polylines.
	(if Bug (print "fixline entered"))
	(if (not getwid)(load (strcat _PATH-LISP "fnct1")))
	(initget 6 "500 1000 2000")
	(setq inscal (getkword "\n \nEnter scale factor [500, 1000, or 2000] for plines: <500> "))
	(if (null inscal) (setq inscal "500"))
	(setq sset (ssget "X" (list (cons 0 "POLYLINE"))))
	(if sset
		(progn
			(setq sf (* (atof inscal) 0.3048)
			     count 0)
			(while (setq ent (ssname sset count))
				(setq 	entlst (entget ent)
						lname (cdr (assoc 8 entlst))
						ps (atof inscal)
				)
				(resetw sf)
				(setthick)
				(entmod entlst)
				(setq count (1+ count))
			);endwhile
		)
	)
	(if Bug (print "fixline exited"))
)

(defun SetThick ( / )						; Sets thickness
;------------------------------------------------------------------------
;! setthick - Sets thickness value for ADDS to control what is plotted at what detail.
;             Uses variables - entlst, lname, ps
;	(if Bug (progn (princ "\nFixit.Lsp!SetThick - Global Vars used:\n - entlst: ") (prin1 entlst) (princ "\n ps: ") (prin1 ps)(princ "\n lname: ") (prin1 lname)))
   (if (or (= (substr lname 7 1) "T") (= (substr lname 7 1) "B") (= (substr lname 5 2) "FL"))
     (if (assoc 39 entlst)
       (setq entlst (subst (cons 39 (+ ps (* ps 0.01))) (assoc 39 entlst) entlst)) ;then
       (setq entlst (cons (cons 39 (+ ps (* ps 0.01))) entlst))  ;else
     )
     ;else
     (if (assoc 39 entlst)
       (setq entlst (subst (cons 39 ps) (assoc 39 entlst) entlst)) ;then
       (setq entlst (cons (cons 39 ps) entlst)) ;else
     )
   )
)

(defun FixPnSc ( /	no_err newscal pnam scset	; fixes panel scale
				count ent entlst pt oldsca minx miny maxx maxy )
; Name:      fixpnsc
; Function:  Driver for the routines to fix the panel scale
;
	(if Bug (print "fixpnsc entered"))
	(if (= DlgFlag "T") (setq DlgFlag "F"))
	(setq no_err T
	    pnam nil)
	(if (and (not iflag) (> (length PanLst) 1)) 
		(progn
			(setq pt (getpoint "\n\nSelect a panel <Return for ALL>\n"))
			(if pt 
				(progn
					(setq minx (fix (/ (car pt) XPanel))
					    miny (fix (/ (cadr pt) YPanel))
					)
					(setq minx (* minx XPanel)
					    miny (* miny YPanel)
					)
					(setq maxx (+ minx XPanel)
					    maxy (+ miny YPanel)
					)
					(if (member (setq pnam (BldFn minx miny)) PanLst)
						(if (not (setq oldsca (cadr (member pnam sclist))))
							(if (not (dispsc pnam)) (setq no_err nil))
						)
						;else
						(progn
						  (setq no_err nil)
						  (princ "\n \n")
						  (princ (strcat "***" AppNam " Error*** Selected point must be within active panel\n"))
						)
					)
				)
			;else
			  (progn
			    (setq oldsca (cadr sclist))
			    (foreach pnam PanLst
			      (if (/= oldsca (cadr (member pnam sclist))) (progn
			        (princ "\n\nALL active panels must have the same original scale")
			        (setq no_err nil)
			      ))
			    )
			    (setq pnam nil)
			  )
			)
		)
		;else
		(setq oldsca (rtos sff))
	)
  (if no_err (progn
    (command "REGENAUTO" "ON"
             "_.LAYER" "S" "0" "T" "*"
             ""
;                    "F" "----DLG---,----GRD---" ""
             "REGENAUTO" "OFF")
    (if pt                                  ;single panel
      (progn
        (command "VIEW" "W" pnam (list (- minx 10) (- miny 10) 0.0)
                                 (list (+ maxx 10) (+ maxy 10) 0.0))
        (command "VIEW" "R" pnam)
        (setq pt1 (list minx miny 0.0)
              pt2 (list maxx maxy 0.0))
      )
      ;else                                 ;all panels
      (progn
        (command "VIEW" "R" "ALL")  ;to avoid problems with ssget "C" on
                                    ;  entities that are not on the screen
                                    ;  view ALL not available in plot routines
      )
    )
  ))
  (if no_err (getscl))
  (if no_err (progn
    (if pt                                  ;single panel
      (progn
        (princ "\n \n \nRescaling symbols, text and plines ...")
        (fixobj (atof newscal) (atof oldsca) pt1 pt2)
        (setq scset (ssget "X" (list (cons 8 "----SC----")))
              count 0)
        (setq sclist '())
        (while (setq ent (ssname scset count))
          (setq entlst (entget ent))
          (if (and (= (setq enttyp (cdr (assoc 3 entlst))) "Panel scale factor")
                   (= (cdr (assoc 2 entlst)) pnam))
            (progn
               (setq entlst (subst (cons 1 newscal) (assoc 1 entlst) entlst))
               (entmod entlst)
               (entupd ent)
               (setq sclist (append (list pnam newscal) sclist))
            )
          ;else
            (setq sclist (append (list (cdr (assoc 2 entlst)) (cdr (assoc 1 entlst)))
                                 sclist))
          )
          (setq count (1+ count))
        )
      )
    ;else                                   ;all panels
      (progn
        (princ "\n \n \nRescaling symbols, text and plines ...")
        (fixobj (atof newscal) (atof oldsca) nil nil)
        (setq scset (ssget "X" (list (cons 8 "----SC----")))
              count 0)
        (setq sclist '())                   ;rebuild sclist with new scale
        (while (setq ent (ssname scset count))
          (setq entlst (entget ent))
          (if (= (cdr (assoc 3 entlst)) "Panel scale factor")
            (progn
               (setq entlst (subst (cons 1 newscal) (assoc 1 entlst) entlst))
               (entmod entlst)
               (entupd ent)
               (setq sclist (append (list (cdr (assoc 2 entlst)) newscal) sclist))
            )
          )
          (setq count (1+ count))
        )
      )
    )
    (setq sff (atof newscal))
    (setq sf (* sff 0.3048))
;   (command "REGENAUTO" "ON"
;            "_.LAYER" "S" "0" "T" "----DLG---,----GRD---" ""
;            "REGENAUTO" "OFF"
;            "ZOOM" "P")
    (command "ZOOM" "P")
    (setvar "HIGHLIGHT" 1) ;This should't be needed--Rel. 10, C7 messes up
  ))
  ;--Clean all these functions out of memory
;;(setq fixpnsc nil  fix_fl nil   fixobj nil  fixplw  nil
;;      ty_pl   nil  resetw nil   getscl nil  fix_txt nil)
)

(defun GetScl ( / )						; Request scale for insert drawing
;------------------------------------------------------------------------------
; Name:      getscl
; Function:  Request a scale for the insert drawing
;            <newscal> is new scale in feet (local in calling routine)
;
  (if Bug (print "getscl entered"))
  (command)
  (initget 6 "500 1000 2000")
  (setq newscal (getkword
    "\n \nEnter new scale factor [500, 1000, or 2000] for panel: <500> "))
  (if (null newscal) (setq newscal "500"))
)

(defun FixObj ( newscl oldscl p1 p2 /	sset		; Rescale objects
								count symchg ent entlst lnam ipt gaplen ang pt1
								newpt1 pt2 newpt2 plset oldscm newscm ZeroType dist
								direct t_or_b err2 )
;-----------------------------------------------------------------------------
; Name:     fixobj
; Function: Rescale objects (blocks, text and plines) that are inside window
;           defined by corners <p1> and <p2>.  If <p1> and <p2> are
;           nil, modify all objects in drawing.
;           <newscl> is new scale in feet
;           <oldscl> is old scale in feet
;
;
	(if Bug (print "fixobj routine"))
	(if (and p1 p2)
		(setq sset (ssget "C" p1 p2))             ;single panel
		;else
		(setq sset (ssget "X"))                   ;all panels
	)
	(if sset 
		(progn
			(princ (strcat "\n\n" (itoa (sslength sset))
			                " entities to be processed\n"))
			(princ "Processing entitity    1")
			(setq count 0
			      oldscm (* oldscl 0.3048)            ;metric scales
			      newscm (* newscl 0.3048)            ;metric scales
			      symchg (/ newscl oldscl)            ;symbol and text multiplier
			      err2 nil)                           ;problem with ty_pl or fix_fl
			(while (setq ent (ssname sset count))
				(if err2 
					(progn
						(princ (strcat "\n" (itoa (sslength sset))
					        " entities to be processed.  Processing entity    "
					        (itoa count)))
						(setq err2 nil)
					)
				)
				(if (< count 10)
					(princ (strcat "\010" (itoa count)))
					;else
					(if (< count 100)
						(princ (strcat "\010\010" (itoa count)))
						;else
						(if (< count 1000)
					 		(princ (strcat "\010\010\010" (itoa count)))
					 		;else
					 		(princ (strcat "\010\010\010\010" (itoa count)))
						)
					)
				)
				(setq entlst (entget ent)
				    lnam (cdr (assoc 8 entlst))       ;layer name
				    ipt (cdr (assoc 10 entlst))       ;insertion point
				    gaplen (cdr (assoc 41 entlst))    ;gap length = scale
				    ZeroType (cdr (assoc 0 entlst))      ;entity type
				    ang (cdr (assoc 50 entlst)))      ;rotation
				(cond
					((= ZeroType "POLYLINE")
						(resetw newscm)
					)
					((= ZeroType "TEXT")
						(if (not (equal symchg 1.0 0.01))
							(fix_txt oldscm)
						)
					)
					((and (= ZeroType "INSERT") (/= lnam "----GRD---") (/= lnam "----DLG---"))
						(if (not (equal symchg 1.0 0.01)) 
							(progn
								(command "SCALE" ent "" ipt symchg)
								(setq gap "N")
								(setq	SymLst	(SymSizN (cdr (assoc 2 entlst))))
								(if SymLst
									(setq	gap		(nth 0 SymLst)
											Lngth	(nth 1 SymLst)
											symnam	(nth 2 SymLst)
									)
								)	
								(cond
									((= gap "M")
										(setq pt1 nil
										      newpt1 nil
										      pt2 (polar ipt ang gaplen)
										      newpt2 (polar ipt ang (* gaplen symchg))
										      plset (ssget "C" (list (- (car pt2) 1.0)
										                             (- (cadr pt2) 1.0) 0.0)
										                       (list (+ (car pt2) 1.0)
										                             (+ (cadr pt2) 1.0) 0.0))
										)
										(fix_fl symchg pt2)
										(ty_pl pt2 newpt2)
									)
									((= gap "C")
										(setq pt1 (polar ipt ang (- (/ gaplen 2)))
										      newpt1 (polar ipt ang (- (* (/ gaplen 2) symchg)))
										      pt2 (polar ipt ang (/ gaplen 2))
										      newpt2 (polar ipt ang (* (/ gaplen 2) symchg))
										      plset (ssget "C" (list (- (car pt1) 1.0)
										                             (- (cadr pt1) 1.0) 0.0)
										                       (list (+ (car pt1) 1.0)
										                             (+ (cadr pt1) 1.0) 0.0)))
										(ty_pl pt1 newpt1)
										(setq plset (ssget "C" (list (- (car pt2) 1.0)
										                             (- (cadr pt2) 1.0) 0.0)
										                       (list (+ (car pt2) 1.0)
										                             (+ (cadr pt2) 1.0) 0.0)))
										(ty_pl pt2 newpt2)
									)
									((not gap)
										(setq dist (* (- symchg 1.0) (* oldscm (+ 0.09 (* (getwid lnam) 0.5)))))
										(if (> (strlen lnam) 6)
										   (setq t_or_b (substr lnam 7 1))) ;--Top or Bottom?
										(setq direct (+ ang (/ PI 2)))
										(if (= t_or_b "B") (setq direct (- direct)))
										(if (or (= t_or_b "B") (= t_or_b "T")) 
											(progn
											    (setq entlst (subst (cons 10 (polar ipt direct dist))
											                        (assoc 10 entlst) entlst))
											    (entmod entlst)
											    (entupd ent)
											)
										)
									)
								);endcond
							)
						)
					)
				);endcond
				(setq count (1+ count))
			)
		);endwhile
  ;else
    (princ "\nNo entities selected !!!")
	)
  (if (equal symchg 1.0 0.01)
    (princ "\nNew scale matches old scale...only processed polylines!!")
  )
);end fixobj

(defun Fix_Txt ( oldscm /	align tx_ht justif	; relocate text after resizing
						t_or_b direct dist htf )
;------------------------------------------------------------------------------
; Name:     fix-txt
; Function: relocate text entities after resizing them
;           <align> is text "alignment" point
;           <ipt> is text insert point (from calling routine)
;           <tx_ht> is text height
;           <lnam> is text layer       (from calling routine)
;           <justif> is text justification flag
;           <t_or_b> is substring of text layer name, "T" for top, "B" for bottom
;           <direct> is direction for the (polar) fnct which follows
;           <dist> is distance for the (polar) fnct which follows
;           <oldscm> is old scale in meters
;           <entlst> is entity list (from calling routine)
;           <symchg> is symbol multiplier (from calling routine)
;           <ent> is entity name (from calling routine)
;           <ang> is angle (from calling routine)
;
  (if Bug (print "fix_txt routine"))
  (setvar "TEXTEVAL" 1)
  (setq align nil)
  (setq tx_ht (cdr (assoc 40 entlst))
        htf (/ tx_ht oldscm))
  (if (setq justif (cdr (assoc 72 entlst)))
    (if (/= justif 0)
      (setq align (cdr (assoc 11 entlst))))
  ;else
    (setq justif 0)
  )
  (if (> (strlen lnam) 6)
    (setq t_or_b (substr lnam 7 1))) ;--Is text on Top or Bottom?
  ;--Reset text height------------------------------------------
  (setq entlst (subst (cons 40 (* tx_ht symchg))
              (assoc 40 entlst) entlst))
  ;--Move text toward or away from new line---------------------
  ;  Adjust for change in text height and change in 3ph circuit
  ;  width.  0.04 is 3ph circ width in inches in final plot
  (cond
    ((= t_or_b "T")
      (setq direct (+ ang (/ PI 2)))
      (if (= justif 4) ;--"4" means Midpoint-aligned text
        (setq dist (* (- symchg 1.0) (* oldscm (+ 0.025 (/ (+ htf 0.04) 2)))))
      ;else
        (setq dist (* (- symchg 1.0) (* oldscm (+ 0.025 (/ 0.04 2)))))
      )
    )
    ((= t_or_b "B")
      (setq direct (- ang (/ PI 2)))
      (if (= justif 4)
        (setq dist (* (- symchg 1.0) (* oldscm (+ 0.025 (/ (+ htf 0.04) 2)))))
      ;else
        (setq dist (* (- symchg 1.0) (* oldscm (+ 0.025 htf (/ 0.04 2)))))
      )
    )
    (T
      (setq direct 1
            dist 0)
    )
  );endcond
  ;--Change text insert point---------------------------------------
  (setq entlst (subst (cons 10 (polar ipt direct dist))
                     (assoc 10 entlst) entlst))
  (if align  ;--If text had an Alignment Point, change it, too------
    (setq entlst (subst (cons 11 (polar align direct dist))
                       (assoc 11 entlst) entlst))
  )
  (entmod entlst)
  (entupd ent)
  (setvar "TEXTEVAL" 0)
)

(defun Fix_Fl ( symchg pt /	count contin flset	; find fill line and scale it
						plst p-ent ptx pty lay )
;------------------------------------------------------------------------------
; Name:     fix_fl
; Function: find the fill line at one end of a symbol insertion and scale it
; Local:    count  - integer counter
;           contin - flag to continue
;           flset  - selection set chosen to include the fill line
;           p-ent  - an entity from the flset selection set
;           plst   - an entget list for p-ent
;           ipt    - insertion point (from calling routine)
;
   (if Bug (print "fix_fl entered"))
   (command)
   (setq ptx (car pt) pty (cadr pt))
   (if (setq flset (ssget "C" (list (- ptx 1.0) (- pty 1.0) 0.0)
                              (list (+ ptx 1.0) (+ pty 1.0) 0.0)))
      (progn
         (setq count 0
               contin T)
         (while (and contin (setq p-ent (ssname flset count)))
            (setq plst (entget p-ent))
            (if (= (substr (setq lay (cdr (assoc 8 plst))) 5 3) "FL-")
               (progn
                  (setq p-ent (cons p-ent (list pt)))
                  (command "SCALE" p-ent "" ipt symchg)
                  (setq contin nil)
               )
            )
            (setq count (1+ count))
            (if (not p-ent) (progn
               (princ "\n \nUnable to rescale fill line for current symbol")
               (setq err2 T)
            ))
         )
         (setq count nil
               contin nil
               flset nil
               plst nil
               p-ent nil)
      )
   ;else
      (progn
        (setq err2 T)
        (princ "\n \nUnable to rescale fill line for current symbol")
      )
   )
   (if Bug (print "fix_fl exited"))
)

(defun Ty_Pl ( p1 p2 /	count contin contn plst	; Change pline end point
					p-ent lay subent slst pt ptx pty )
;-----------------------------------------------------------------------------
; Name:     ty_pl
; Function: Change a polyline's end-pt to given point
; Uses:     plset - a tiny "crossing" selection set created around p2
;                   in calling routine
;
  (if Bug (print "ty_pl entered"))
  (setq count 0
        contin T)
  (if plset (progn
    (while (and contin (setq p-ent (ssname plset count)))
      (setq plst (entget p-ent))
      (if (and (= (substr (setq lay (cdr (assoc 8 plst))) 5 3) "CK-")
               (setq subent (entnext p-ent)))
        (progn
          (setq contn T
                slst (entget subent))
          (while (and contn (/= (cdr (assoc 0 slst)) "SEQEND"))
            (setq pt (cdr (assoc 10 slst)))  ;--Get a vertex from pline
            (setq ptx (car pt)
                  pty (cadr pt))
            (if (and (equal ptx (car p1) 0.0001)   ;--Check if vertex equal
                     (equal pty (cadr p1) 0.0001)) ;  to <p1>
              (progn
                (setq slst (subst (cons 10 p2) (assoc 10 slst) slst))
                (entmod slst)
                (entupd p-ent)
                (setq contn nil     ;--set flags to exit both loops
                      contin nil)
              )
            ;else
              (if (setq subent (entnext subent))
                (setq slst (entget subent))
              ;else
                (progn
                   (setq contin nil
                         err2 T)
                   (princ (strcat "\n \nUnable to close this polyline"
                                   " back to current symbol"))
                )
              )
            )
          );endwhile
          (if contn (progn
            (setq err2 T)
            (princ (strcat "\n \nUnable to close this polyline"
                                      " back to current symbol")))
          )
        )
      )
      (setq count (1+ count))
    );endwhile
    (if contin (progn
       (setq err2 T)
       (princ "\n \nUnable to close this polyline back to current symbol")
    )))
  ;else
    (progn
      (setq err2 T)
      (princ "\n \nUnable to close this polyline back to current symbol")
    )
  )
  (setq count nil
        contin nil)
  (if Bug (print "ty_pl exited"))
)

(defun C:Hold_Load ( / )
	(if (not _path-lisp)
		(cond	((= (getenv "TEST") "YES")
					(if (findfile "J:\\DIV_MAP\\Adds25\\LISP\\Adds25.lsp")
						(setq	_Path-Lisp "J:\\DIV_MAP\\Adds25\\LISP\\")
						(if (findfile (strcat PrmRootPath "_Adds25\\LISP\\Adds25.lsp"))
							(setq	_Path-Lisp (strcat PrmRootPath "_Adds25\\LISP\\"))
							(if (findfile "C:\\DIV_MAP\\Adds25\\LISP\\Adds25.lsp")
								(setq	_Path-Lisp "C:\\DIV_MAP\\Adds25\\LISP\\")
								(alert "*Adds Warning!*\nLaunch code not found!\nCheck network paths!")
							)
						)
					)
				)
				(T
					(if (findfile (strcat PrmRootPath "_Adds25\\LISP\\Adds25.lsp"))
						(setq	_Path-Lisp (strcat PrmRootPath "_Adds25\\LISP\\"))
						(if (findfile "J:\\DIV_MAP\\Adds25\\LISP\\Adds25.lsp")
							(setq	_Path-Lisp "J:\\DIV_MAP\\Adds25\\LISP\\")
							(if (findfile "C:\\DIV_MAP\\Adds25\\LISP\\Adds25.lsp")
								(setq	_Path-Lisp "C:\\DIV_MAP\\Adds25\\LISP\\")
								(alert "*Adds Warning!*\nLaunch code not found!\nCheck network paths!")
							)
						)
					)
				)
		)
	)
	(if (findfile (strcat PrmRootPath "CADET20\\LISP\\CADET20.lsp"))
		(setq	_path-lisp	(strcat PrmRootPath "CADET20\\LISP\\"))
		(if (findfile "J:\\DIV_MAP\\CADET20\\LISP\\CADET20.lsp")
			(setq	_path-lisp	"J:\\DIV_MAP\\CADET20\\LISP\\")
			(if (findfile "C:\\DIV_MAP\\CADET20\\LISP\\CADET20.lsp")
				(setq	_path-lisp	"C:\\DIV_MAP\\CADET20\\LISP\\")
				(alert "*Adds Warning!*\nLaunch code not found!\nCheck network paths!")
			)
		)
	)
	(if (not _path-lisp)
		(cond	((= (getenv "TEST") "YES")
					(if (findfile "J:\\DIV_MAP\\Adds25\\LISP\\Adds25.lsp")
						(setq	_Path-Lisp "J:\\DIV_MAP\\Adds25\\LISP\\")
						(if (findfile (strcat PrmRootPath "_Adds25\\LISP\\Adds25.lsp"))
							(setq	_Path-Lisp (strcat PrmRootPath "_Adds25\\LISP\\"))
							(if (findfile "C:\\DIV_MAP\\Adds25\\LISP\\Adds25.lsp")
								(setq	_Path-Lisp "C:\\DIV_MAP\\Adds25\\LISP\\")
								(alert "*Adds Warning!*\nLaunch code not found!\nCheck network paths!")
							)
						)
					)
				)
				(T
					(if (findfile (strcat PrmRootPath "_Adds25\\LISP\\Adds25.lsp"))
						(setq	_Path-Lisp (strcat PrmRootPath "_Adds25\\LISP\\"))
						(if (findfile "J:\\DIV_MAP\\Adds25\\LISP\\Adds25.lsp")
							(setq	_Path-Lisp "J:\\DIV_MAP\\Adds25\\LISP\\")
							(if (findfile "C:\\DIV_MAP\\Adds25\\LISP\\Adds25.lsp")
								(setq	_Path-Lisp "C:\\DIV_MAP\\Adds25\\LISP\\")
								(alert "*Adds Warning!*\nLaunch code not found!\nCheck network paths!")
							)
						)
					)
				)
		)
	)
)

(setq	LodVer	"2.5.2c")
