(if AppNam								; Code Version Indicator {801 Lines of Code}
	(princ (strcat "\n" AppNam " Layers Loading."))
	(princ "\nAdds Layers Loading.")
)

(defun Mk_Lay ( /	subfd new clayer subkv )		; Builds layers from user entry
; Function: Lets user specify sub, feeder, phase, voltage info for a new
;           circuit, then builds associated layers
;       S.E.R.  9-6-88
; Global Out: sub - two digit alpha code assigned to substations {accessed from SUBLIST}
;             kv - kv of selected substation {accessed from SUBLIST}
;             fd - feeder number entered by the user
;       subfdlst - sub/feeder list indicating which layers have been built
	(if Bug (princ "mk_lay entered"))
	(if (/= (strcase Mouse) "YES")
		(command "REGENAUTO" "OFF" "TABLET" "OFF")
		(command "REGENAUTO" "OFF")
	)
	(setq	subkv	(getstring "\n\nSelect a substation:\n"))
	(setq	fd	nil)
	(while (null fd)
		(if (setq fd (getint "\n \nInput feeder number (1 - 26): "))
			(if (or (< fd 1) (> fd 26))
				(setq	fd	nil)
			)
		)
	)
	(setq	subfd	(strcat (substr subkv 1 2) (chr (+ fd 64))))
	(setq	kv		(substr subkv 3 2))
	(if (not (member subfd subfdlst))
		(progn
			(setq	subfdlst	(cons subfd subfdlst))
			(princ "\n\nOne moment please, layers are being created.\n")
			(setq	clayer	"?????????"
					new		"C"
			)
			(callcl T)
		)
	)
	(setq	sub		(substr subfd 1 2)
			fd		(substr subfd 3 1)
	)
	(if (/= (strcase Mouse) "YES")
		(command "TABLET" "OFF")
	)
	(if Bug (princ "mk_lay exited"))
)

(defun Get_Ex_Circuit ( /	circ cname clayer	; Sets variables based on circuit selection
						phase ug-oh new )
;  Function:  Sets sub, feeder, kv, and phase variables to match circuit
;             selected from screen by user
;  Date:      2/2/89
   (if Bug (princ "get_ex_circuit entered"))
   (setq circ (entsel "\n \nSelect an existing circuit: "))
   (setq cname (entget (car circ)))
   (setq clayer (cdr (assoc 8 cname)))
   (while (/= (substr clayer 5 2) "CK")
      (princ "\n***Invalid selection***  ")
      (setq circ (entsel "\nSelect an existing circuit: "))
      (setq cname (entget (car circ)))
      (setq clayer (cdr (assoc 8 cname)))
   )
   (setq sub (substr clayer 1 2)
   fd (substr clayer 3 1)
   outypetbph (substr clayer 4 5)
   kv (substr clayer 9 2)
   phase (substr clayer 8 1)
   ug-oh (substr clayer 4 1))
   (setq subfd (strcat sub fd))
   (if (not (member subfd subfdlst))
     (setq subfdlst (cons subfd subfdlst)
     new "C")
     ;else
     (setq new nil)
   )
   (callcl T)
   (setq width (getwid clayer))
   (setq circ nil
   cname nil
   clayer nil
   phase nil
   ug-oh nil)
   (princ (strcat "\n \nSelected circuit, " subfd outypetbph kv
        ", is now active with "
        (substr outypetbph 5) " phases"))
   (princ "\nChange phase or select DRAW CIRCUIT from tablet")
   (if Bug (princ "get_ex_circuit exited"))
   (princ)
)

(defun CallCl ( flag /	lname lna lnb lnc ln-1	; Calls the 'crelay' function to create layers
					ln-2 ln-3 ln-5 ln-6a ln-6b ln-7
					ln-8 ln-9 lnD1 lnD2 lnD3 lnTB1 lnTB2 lnTB3 lc col resp )
;  Function:  Calls the 'crelay' function to create layers
	(if Bug (princ "callcl entered"))
	(setq	lname	nil)
	(if (not (setq lc (lstclr subfd nil)))
		(if (and (/= clayer "?????????") (setq tbllst (tblsearch "LAYER" clayer)))
			;use existing circuit color
			(setq	lc	(abs (cdr (assoc 62 tbllst))))
			;else set up layer colors according to circuit voltage
			(cond
				((or (= kv "12") (= kv "13"))
					(setq lc 1)
				)
				((or (= kv "23") (= kv "35"))
					(setq lc 5)
				)
				((= kv "04")
					(setq lc 10)
				)
				(T
					(setq lc 7)
				)
			)
		)
	)
	(cond
		((= lc 1) (setq col "Red"))
		((= lc 2) (setq col "Yellow"))
		((= lc 3) (setq col "Green"))
		((= lc 4) (setq col "Cyan"))
		((= lc 5) (setq col "Blue"))
		((= lc 6) (setq col "Magenta"))
		((= lc 7) (setq col "White"))
		(T (setq col (itoa lc)))
	)
	(if flag
		(progn
			(initget	(strcat	"Red Yellow Green Cyan Blue Magenta White"
							" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15"))
			(setq	col	(getkword (strcat "\n\nSelect color <" col "> ")))
			(if col
				(cond
					((= col "Red") (setq lc 1))
					((= col "Yellow") (setq lc 2))
					((= col "Green") (setq lc 3))
					((= col "Cyan") (setq lc 4))
					((= col "Blue") (setq lc 5))
					((= col "Magenta") (setq lc 6))
					((= col "White") (setq lc 7))
					(T (setq lc (atoi col)))
				)
			)
			(if (and clr (/= clr lc))
				(progn
					(initget "Yes No")
					(princ	(strcat	"\n\nColor selected (" (itoa lc)
									") does not match color (" (itoa clr)
									") in COLORS.DAT file."
							)
					)
					(setq resp (getkword "\nDo you want to reset the color in COLOR.DAT? <N>"))
					(if (or (null resp) (= resp "No"))
						(setq lc clr)
					)
				)
			)
		)
	)
	(if (assoc subfd colors)
		(setq	colors	(subst (cons subfd lc) (assoc subfd colors) colors))
		(setq	colors	(append colors (list (cons subfd lc))))
	)
	(setq	lc	(itoa lc))
	(if new
		(progn
			(crelay "1")   ;--Create layers for phase 1
			(setq ln-1 lna
			lnD1 lnb
			lnTB1 lnc)
			(crelay "2")   ;--Create layers for phase 2
			(setq ln-2 lna
			lnD2 lnb
			lnTB2 lnc)
			(crelay "3")   ;--Create layers for phase 3
			(setq ln-3 lna
			lnD3 lnb
			lnTB3 lnc)
			(varlay)       ;--Build layers that are not tied to no. of phases
			(setlay)       ;--Set layers' colors and linetypes
		)
     ;else
     (command	"_.LAYER" "C" lc (strcat subfd "???-*")
           "C" "2"  "????CP*"  "C" "15" "????CE*"
           "C" "7"  "????NO*"  "C" "15" "???ULO*"
           "C" "15" "????PM*" "")
   )
   (if Bug (princ "callcl exited"))
)

(defun CRelay ( ph / )						; Create layers for phase passed as 'ph'
; Function:  Create layers for phase passed as 'ph'
   (if Bug (princ "crelay entered"))
   (setq lna (strcat  subfd "OCK-" ph kv
                  "," subfd "UCK-" ph kv
                  "," subfd "OSW-" ph kv
                  "," subfd "USW-" ph kv
                  "," subfd "OFL-" ph kv
                  "," subfd "UFL-" ph kv))
   (if new (command	"_.LAYER" "N" lna ""))
   (setq lnb (strcat subfd "OCKD" ph kv
                 "," subfd "UCKD" ph kv
                 "," subfd "OSWD" ph kv
                 "," subfd "USWD" ph kv
                 "," subfd "OCED" ph kv
                 "," subfd "UCED" ph kv
                 "," subfd "OCE-" ph kv
                 "," subfd "UCE-" ph kv))
   (if new (command	"_.LAYER" "N" lnb ""))
   (setq lnc (strcat subfd "OWST" ph kv
                 "," subfd "UWST" ph kv
                 "," subfd "OWSB" ph kv
                 "," subfd "UWSB" ph kv
                 "," subfd "OPM-" ph kv
                 "," subfd "UPM-" ph kv
                 "," subfd "OPMT" ph kv
                 "," subfd "UPMT" ph kv
                 "," subfd "OPMB" ph kv
                 "," subfd "UPMB" ph kv))
   (if new (command	"_.LAYER" "N" lnc ""))
   (if Bug (princ "crelay exited"))
)

(defun VarLay ( / )						; builds circuit-associated layers
; Function: builds circuit-associated layers that don't distinquish phase
   (if Bug (princ "varlay entered"))
   (setq ln-5 (strcat subfd "-CP--" kv)
         ln-6 (strcat subfd "-CE--" kv)
         ln-7 (strcat subfd "-STT-" kv)
         ln-8 (strcat subfd "-STB-" kv)
         ln-9 (strcat subfd "-NO--" kv)
        ln-10 (strcat subfd "ULO--" kv))
   (if new (command	"_.LAYER" "N" ln-5
                            "N" ln-6
                            "N" ln-7
                            "N" ln-8
                            "N" ln-9
                            "N" ln-10 "")
   )
   (if Bug (princ "varlay exited"))
)

(defun SetLay ( / )						; sets color and linetype for created layers
; Function: sets color and linetype for created layers
   (if Bug (princ "setlay entered"))
   (command	"_.LAYER" "C" "2" (strcat subfd "-CP*")
         "L" "DASHED" (strcat subfd "UCK-2*")
         "L" "DASHED" (strcat subfd "UFL-2*")
         "L" "HIDDEN" (strcat subfd "UCK-1*")
         "L" "HIDDEN" (strcat subfd "UFL-1*")
         "C" lc ln-1
         "C" lc ln-2
         "C" lc ln-3
         "C" "2" ln-5
         "C" "15" ln-6
         "C" "7" ln-7
         "C" "7" ln-8
         "C" "7" ln-9
         "C" "15" ln-10
         "C" "7" lnD1
         "C" "7" lnD2
         "C" "7" lnD3
         "C" "15" lnTB1
         "C" "15" lnTB2
         "C" "15" lnTB3 "")
   (if (= _default-div "MOBILE")
     (command	"_.LAYER" "L" "CONTINUOUS" (strcat subfd "UCK-2*")
           "L" "CONTINUOUS" (strcat subfd "UFL-2*")
           "L" "CONTINUOUS" (strcat subfd "UCK-1*")
           "L" "CONTINUOUS" (strcat subfd "UFL-1*") "")
   )
   (if Bug (princ "setlay exited"))
)

(defun Fd_Clr ( / )						; Set circuit colors by feeder number
; Function:  Set circuit colors by feeder number
   (if Bug (princ "fd_clr entered"))
   (command	"_.LAYER" "C" "1"  "??A???-*" "C" "2"  "??B???-*"
                    "C" "4"  "??C???-*" "C" "3"  "??D???-*"
                    "C" "5"  "??E???-*" "C" "6"  "??F???-*"
                    "C" "7"  "??G???-*" "C" "8"  "??H???-*"
                    "C" "9"  "??I???-*" "C" "10" "??J???-*"
                    "C" "11" "??K???-*" "C" "12" "??L???-*"
                    "C" "13" "??M???-*" "C" "14" "??N???-*"
                    "C" "15" "??O???-*" "C" "1"  "??P???-*"
                    "C" "2"  "??Q???-*" "C" "3"  "??R???-*"
                    "C" "4"  "??S???-*" "C" "5"  "??T???-*"
                    "C" "6"  "??U???-*" "C" "7"  "??V???-*"
                    "C" "8"  "??W???-*" "C" "9"  "??X???-*"
                    "C" "10" "??Y???-*" "C" "11" "??Z???-*"
                    "C" "2"  "????CP*"  "C" "15" "????CE*"
                    "C" "7"  "????NO*"  "C" "15" "???ULO*"
                    "C" "15" "????PM*" "")
   (if Bug (princ "fd_clr exited"))
)

(defun LstClr ( subfd prnt /	sbfdr linein filen	; Set colors based on sub/fd list
						count Lngth )
	(if Bug (princ "lstclr entered"))
	(if (not colors)
		(setq	colors	(mapcar (quote cons) Lst_Fd_V Lst_Fd_C)
				colors	(append colors (list (cons "NEW" 0)))
		)
	)
	(if (not subfd)
		(progn
			(command	"_.LAYER" "C" "10" "????CK-*" "")
			(setq	count	0
					Lngth		(length colors)
			)
			(while (< count Lngth)
				(setq	sbfdr	(car (nth count colors))
						clr		(cdr (nth count colors))
				)
				(if (/= sbfdr "NEW")
					(command	"_.LAYER" "C" (itoa clr) (strcat sbfdr "???-*")
							"C" "2"  "????CP*"  "C" "15" "????CE*"
							"C" "7"  "????NO*"  "C" "15" "???ULO*"
							"C" "15" "????PM*" ""
					)
				)
				(setq	count	(1+ count))
			)
			(princ)
		)
		(setq	clr	(cdr (assoc subfd colors)))
	)
)

(defun Pars ( linein prnt /	sbfdr volt clr		; Parse line from COLORS.DAT into subfd and lay color
						subnam )
	(if Bug (princ "pars entered"))
	(setq	sbfdr	nil)
	(setq	sbfdr	(substr linein 1 3)
			volt		(substr linein 4 2)
			clr		(atoi (substr linein 7 2))
			subnam	(substr linein 10)
	)
	(if prnt (princ (strcat "\nProcessing " subnam)))
	(list sbfdr volt clr subnam)
)

(defun LaySw ( / )							; display pull-down menu to allow toggle of switch
;  Function: display pull-down menu to allow toggle of switch and
;            fill-lines or circuits based on kv, sub, and phase setting
;  Author:   Jim Holton
;  Date:     December 1988
   (if Bug (princ "laysw entered"))
   (if (/= (strcase Mouse) "YES")
     (command "REGENAUTO" "OFF"
              "BLIPMODE" "ON"
              "TABLET" "OFF")
     ;else
     (command "REGENAUTO" "OFF"
              "BLIPMODE" "ON")
   )
   (menucmd "P1=LAYSW")
   (menucmd "P1=*")
   (getstring)               ;this keeps user in this routine for additional
                             ;  selections
   (if Bug (princ "laysw exited"))
)

(defun LayKv ( / )							; display menu to allow toggle of kv rating layers
;  Function: display pull-down menu to allow toggle of kv rating layers
;  Author:   Jim Holton
;  Date:     December 1988
   (if Bug (princ "laykv entered"))
   (if (/= (strcase Mouse) "YES")
     (command "REGENAUTO" "OFF"
              "BLIPMODE" "ON"
              "TABLET" "OFF")
     ;else
     (command "REGENAUTO" "OFF"
              "BLIPMODE" "ON")
   )
   (menucmd "P1=P1RATING")
   (menucmd "P1=*" )
   (setq sbkv (getstring "\n \nChoose a KV rating from the PULLDOWN list \n"))
   (menucmd "P1=LAYSW")
   (menucmd "P1=*" )
   (if Bug (princ "laykv exited"))
)

(defun LaySub ( / )						; display menu to allow toggle of sub/feeder layers
;  Function: display pull-down menu to allow toggle of substation/feeder layers
;  Author:   Jim Holton
;  Date:     December 1988
   (if Bug (princ "laysub entered"))
   (if (/= (strcase Mouse) "YES")
     (command "REGENAUTO" "OFF"
              "BLIPMODE" "ON"
              "TABLET" "OFF")
     ;else
     (command "REGENAUTO" "OFF"
              "BLIPMODE" "ON")
   )
   (menucmd "P1=SUBS")
   (menucmd "P1=*" )
   (setq sbkv (getstring "\n \nSelect a Substation\n"))
   (setq sbkv (strcat (substr sbkv 1 2) "??"))
   (initget 6)
   (setq feedr (getint "\nEnter feeder number or <CR> for all feeders : "))
   (setq feedr (if feedr (chr (+ 64 feedr)) "?"))
   (menucmd "P1=LAYSW")
   (menucmd "P1=*" )
   (if Bug (princ "laysub exited"))
)

(defun LayPh ( / )							; display menu to allow toggle of phase layers
;  Function: display pull-down menu to allow toggle of phase layers
;  Author:   Jim Holton
;  Date:     December 1988
   (if Bug (princ "layph entered"))
   (if (/= (strcase Mouse) "YES")
     (command "REGENAUTO" "OFF"
              "BLIPMODE" "ON"
              "TABLET" "OFF")
     ;else
     (command "REGENAUTO" "OFF"
              "BLIPMODE" "ON")
   )
   (menucmd "P2=P2A")
   (menucmd "P2=*" )
   (setq phsnam (getstring "\n \nChoose a Phase from the PULLDOWN list \n"))
   (menucmd "P2=POP2")
   (menucmd "P1=LAYSW")
   (menucmd "P1=*" )
   (if Bug (princ "layph exited"))
)

(defun LayDsp ( flag ltype /	LayNam )			; Freezes or thaws selected layers
;  Function: Freezes or thaws selected layers
;  Author:   grs & jvg
;  Date:     January 1989
	(if Bug (princ "laydsp entered"))
	(command "REGENAUTO" "ON")
	(if (null sbkv)
		(setq	sbkv		"????")
	)
	(if (null phsnam)
		(setq	phsnam	"?????")
	)
	(if (null feedr)
		(setq	feedr	"?")
	)
	(command	"_.LAYER" "S" "0" "")
	(cond
		((= ltype "CK?")
			(setq	LayNam		(strcat	(substr sbkv 1 2)
									feedr
									(substr phsnam 1 1)
									"SW?"
									(substr phsnam 5 1)
									(substr sbkv 3 2)
							)
			)
			(setq	LayNam		(strcat	LayNam
									","
									(substr LayNam 1 4)
									"FL?"
									(substr LayNam 8 3)
									","
									(substr LayNam 1 4)
									"CK?"
									(substr LayNam 8 3)
									","
									(substr LayNam 1 2)
									"?-CP??"
									(substr sbkv 3 2)
							)
			)
			(setq	LayNam		(strcat	LayNam
									","
									(substr LayNam 1 4)
									"WS?"
									(substr LayNam 8 3)
							)
			)
			(setq	LayNam		(strcat	LayNam
									","
									(substr sbkv 1 2)
									feedr
									"?CE??"
									(substr sbkv 3 2)
									","
									(substr sbkv 1 2)
									feedr
									"?NO??"
									(substr sbkv 3 2)
									","
									(substr sbkv 1 2)
									feedr
									"?ST??"
									(substr sbkv 3 2)
							)
			)
			(setq	LayNam		(strcat	LayNam
									","
									(substr sbkv 1 2)
									feedr
									"?PM??"
									(substr sbkv 3 2)
									","
									(substr sbkv 1 2)
									feedr
									"?SL??"
									(substr sbkv 3 2)
									","
									(substr sbkv 1 2)
									feedr
									"?LO??"
									(substr sbkv 3 2)
							)
			)
			(command	"_.LAYER" flag LayNam "")
		)
		((= ltype "SW?")
			(setq	LayNam		(strcat	(substr sbkv 1 2)
									feedr
									(substr phsnam 1 1)
									"SW?"
									(substr phsnam 5 1)
									(substr sbkv 3 2)
							)
			)
			(if (= flag "T")
				(setq	nflag	"F")
				(setq	nflag	"T")
			)
			(setq	LayNam2	(strcat	(substr LayNam 1 4)
									"FL?"
									(substr LayNam 8 3)
							)
			)
			(command	"_.LAYER" flag LayNam nflag LayNam2 "")
		)
		(	(or	(= ltype "FL?")
				(= ltype "SWD")
			)
			(setq	LayNam		(strcat	(substr sbkv 1 2)
									feedr
									(substr phsnam 1 1)
									ltype
									(substr phsnam 5 1)
									(substr sbkv 3 2)
							)
			)
			(command	"_.LAYER" flag LayNam "")
		)
		((= ltype "CP?")
			(setq	LayNam		(strcat	(substr sbkv 1 2)
									"?-CP??"
									(substr sbkv 3 2)
							)
			)
			(command	"_.LAYER" flag LayNam "")
		)
		((= ltype "GRD")
			(setq	LayNam		"----GRD---")
			(command	"_.LAYER" flag LayNam "")
		)
		((= ltype "NO?")
			(command	"_.LAYER" flag (strcat (substr sbkv 1 2) feedr "?NO??" (substr sbkv 3 2) "") "")
		)
	)
	(command "REGENAUTO" "OFF")
	(menucmd "P1=*")
	(if Bug (princ "laydsp exited"))
)

(defun LayAll ( / )						; sets layer variables for use by laydsp
;  Function:  sets layer variables to all wildcard chars for use by laydsp
   (if Bug (princ "layall entered"))
   (setq sbkv "????")
   (setq phsnam "?????")
   (setq feedr "?")
   (menucmd "P1=LAYSW")
   (menucmd "P1=*" )
   (if Bug (princ "layall exited"))
)

(defun ChgLay ( /	pl pllst lname sbkv fdr		; change layers
				ouTYPEtbPH width newkv )
; Function:  change layers
   (if Bug (princ "chglay entered"))
   (setq pl nil)
   (while (null pl)
      (if (setq pl (car (entsel "\nSelect circuit to be changed:")))
         (progn
            (setq pllst (entget pl))
            (if (/= (substr (setq lname (cdr (assoc 8 pllst))) 5 3) "CK-")
               (progn
                  (princ "\n \nEntity selected not a circuit ")
                  (setq pl nil)
            ))
         )
      ;else
         (princ "\n \nNo entity selected ")
      )
   );endwhile
   (command	"_.LAYER" "S" lname
                    "F" "*"
                    "T" (strcat (substr lname 1 3) "*,----SC*,0") "")
   (getchg)
   (princ "\n \nSelect the circuit, symbols, and text to be changed.")
   (princ "\nUse [C]rossing, [W]indow, [R]emove, and/or [A]dd...")
   (command "SELECT" pause)
   (initget "Yes No")
   (setq resp (getkword "\n \n \nOkay to proceed? <Y>: "))
   (if (or (null resp) (= resp "Yes"))
      (go_chg)
   ;else
      (if (= DlgFlag "T")
         (command	"_.LAYER" "T" "*" "")
      ;else
         (command	"_.LAYER" "T" "*" "F" "----DLG---" ""))
   )
   (setq typchg nil
         chglay nil)
   (if Bug (princ "chglay exited"))
)

(defun GetChg ( / )						; Let user select type of change to be made
; Function:  Let user select type of change to be made
   (menucmd "P1=CHGLAY")
   (menucmd "P1=*")
   (setq typchg (getstring "\n \nSelect the type of change...\n"))
   (cond
      ((= typchg "S")
         (progn
            (menucmd "P1=SUBS")
            (menucmd "P1=*")
            (setq sbkv (getstring "\n \n \nSelect a Substation\n"))
            (initget 6)
            (setq fdr (getint "\n \nEnter feeder number or <CR> to reuse existing number: "))
            (if fdr (setq fdr (chr (+ 64 fdr))) (setq fdr (substr lname 3 1)))
            (menucmd "P1=P1A")
          ))
      ((= typchg "P")
         (progn
            (menucmd "P2=P2A")
            (menucmd "P2=*")
            (setq ouTYPEtbPH (getstring "\n \n \nChoose a Phase\n"))
            (setq nwidth (getwid (strcat "---" ouTYPEtbPH "--")))
            (menucmd "P2=SETPH")
            (menucmd "P1=P1A")
          ))
      ((= typchg "V")
         (progn
            (initget  6 "4 12 13 23 35")
            (setq newkv (getkword "\n \n \nEnter Voltage in KV [4, 12, 13, 23, or 35]: "))
            (if (= newkv "4") (setq newkv "04"))
            (menucmd "P1=P1A")
         ))
   )
)

(defun Go_Chg ( /	chgset count laylst chgent	; Make the layer changes specified in chglay
				chglst sbfdkv newlay
				newlst subfd kv iset ZeroType )
; Function:  Make the layer changes specified in chglay
  (if Bug (princ "go_chg entered"))
  (if (= DlgFlag "T")
    (command	"_.LAYER" "T" "*" "")
  ;else
    (command	"_.LAYER" "T" "*" "F" "----DLG---" ""))
  (setq chgset (ssget "P")  ;--recapture the users selection set
        count 0
        laylst (list ) )
  (while (setq chgent (ssname chgset count)) ;--step thru entities in sel set
    (setq chglst (entget chgent))
    (resetl)
    (if newlay (progn
      (setq sbfdkv (strcat (substr newlay 1 3) (substr newlay 9 2)))
      (if (not (member sbfdkv newlst))         ;  create layers before moving
        (progn                                ;  entities to them
          (setq newlst (cons sbfdkv laylst)
                subfd (substr sbfdkv 1 3)
                kv (substr sbfdkv 4 2)
                new "C"
                clayer newlay)
          (callcl nil)
      ))
      (if (= ZeroType "INSERT")              ;---'ZeroType' is set in resetl
        (progn
          (setq iset (ssadd chgent)) ;---build sel. set containing the block
          (command "CHPROP" iset "" "LA" newlay "")
          (if (setq subent (entnext chgent)) ;---look at sub-entities of INSERT
            (progn
              (setq chglst (entget subent))
              (while (= (cdr (assoc 0 chglst)) "ATTRIB")
                (resetl)
                (if newlay (progn
                  (setq chglst (subst (cons 8 newlay) (assoc 8 chglst) chglst))
                  (entmod chglst)            ;---Update database from "chglst"
                  (entupd subent)            ;---Update screen image
                ))
                (setq subent (entnext subent))
                (setq chglst (entget subent))
              );endwhile
            )
          )
          ;---if changing phases and layer is a "T" or "B" type
          (if (and (= typchg "P")
                   (/= (substr newlay 7 1) "-"))
            (Adj_Tb (entget chgent)))
        )
      ;else, if entity is not a block
        (progn
          (setq chglst (subst (cons 8 newlay) (assoc 8 chglst) chglst))
          (entmod chglst)       ;---Update database from "chglst"
        )
      )
    ))
    (setq count (1+ count))
  );endwhile
  (setq resetl nil
        go_chg nil)
  (if Bug (princ "go_chg exited"))
);end of go_chg

(defun ResetL ( /	oldlay plw )				; build new layer name and set new width if needed
; Function: build new layer name and set new width if necessary
   (if Bug (princ "resetl entered"))
   (if (and (/= (setq oldlay (cdr (assoc 8 chglst))) "0");--Don't mess with
            (/= oldlay "----SC----")) ; SCALE Attr. or layer "0"
      (cond
         ((= typchg "S")
            (setq newlay (strcat (substr sbkv 1 2) fdr
                         (substr oldlay 4 5) (substr sbkv 3 2))
                  ZeroType (cdr (assoc 0 chglst))))
         (( = typchg "P")
            (setq newlay (strcat (substr oldlay 1 3) (substr ouTYPEtbPH 1 1)
                         (substr oldlay 5 3) (substr ouTYPEtbPH 5 1)
                         (substr oldlay 9 2))
                  owidth (getwid oldlay))
            (if (= (setq ZeroType (cdr (assoc 0 chglst))) "POLYLINE")
               (progn
                  (setq plw (cdr (assoc 40 chglst)))
                  (setq newplw (* (/ nwidth owidth) plw))
                  (setq chglst (subst (cons 40 newplw) (assoc 40 chglst) chglst))
                  (setq chglst (subst (cons 41 newplw) (assoc 41 chglst) chglst))
                  (entmod chglst)
                  (entupd chgent)
            )))
         (( = typchg "V")
            (setq newlay (strcat (substr oldlay 1 8) newkv)
                  ZeroType (cdr (assoc 0 chglst))))
      );endcond
   ;else
      (setq newlay nil)
   )
   (if Bug (princ "resetl exited"))
)

(defun Adj_Tb ( entlst / )					; adjust the location of an insert
; Function: adjust the location of an insert when line width changes
; Globals:  newlay - new layer for entity
;           oldlay - old layer for entity
   (cond
     ((= (substr newlay 7 1) "T")  ;---if layer is "Top"
        (setq angl (+ (cdr (assoc 50 entlst)) (/ PI 2.0))))
     ((= (substr newlay 7 1) "B")  ;---if layer is "Bottom"
        (setq angl (- (cdr (assoc 50 entlst)) (/ PI 2.0))))
     (T
        (setq angl nil))
   )
   (if angl (progn
     (setq displ (* (rem (cdr (assoc 39 entlst)) 100) 10000 0.3048 (/ (- nwidth owidth) 2.0)))
     (if (not (equal displ 0.0 0.001))
        (movent entlst displ angl))
   ))
)

(defun MovEnt ( lst s a /	ipt newipt )		; move an entity described by entity
; Function: move an entity described by entity list - lst,
;           distance - s, angle - a
  (setq ipt (cdr (assoc 10 lst))
        newipt (polar ipt a s))
  (setq lst (subst (cons 10 newipt) (assoc 10 lst) lst))
  (entmod lst)
)

(setq	LodVer	"2.5.2d")
