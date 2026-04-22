(if AppNam								; Code Version Indicator {1069 Lines of Code}
	(princ (strcat "\n" AppNam " Lines & Text Loading."))
	(princ "\nCadet 2.1 Lines & Text Loading.")
)

(defun C:Lines ( / )						; Pline by layer
; Name : LINES
; Function : sets layer and pline parameters then draws a PLINE
; Global   : SF - scale factor, LNdes - lines description,
;            LNtype- linetype,  LNwid - linewidth, and lname - layer name
	(if Bug
		(princ "\n{Lines entered\n")
	)
	(if (= (strcase LNtyp T) "PROP")
		(progn
			(if (not (tblsearch "LTYPE" "PROPERTY")) (command "-LINETYPE" "L" "PROPERTY" (findfile "Custom.Lin")))
			(command)
		)
	)
	(command "LINETYPE"	"S" LNtyp	"" "LAYER" "T"	lname "S"	lname "")
	(princ (strcat "\n\nPick starting point for " LNdes "...\n")
	)
	(command "_.PLINE" pause "W" (* SF LNwid) (* SF LNwid))
	(if Bug
		(princ "\nLines exited}\n")
	)
)

(defun BLines ( Lnam Ltyp Lcol Lwid Ldes ArrHd	; Pline on correct layer
				/	Otyp Ocol GoLst GoT StrtPt NexPt OPt NeWid NewPt Ang
					InsHd PosOut Bubba )
	(if Bug
		(princ "\n{BLines entered\n")
	)
	(setq Otyp  (getvar "CELTYPE")
		 Ocol  (getvar "CECOLOR")
		 GoLst nil
		 GoT	  T
	)
	(if ArrHd
		(if (= ArrHd "E")
			(setq ArrHd nil
				 InsHd "191"
			)
			(if (= ArrHd "I")
				(setq ArrHd nil
					 InsHd "391"
				)
				(setq ArrHd T
					 InsHd nil
				)
			)
		)
	)
	(if InsHd
		(setq PosOut (- (length Lst_Sp_Sn)
					 (length (member InsHd Lst_Sp_Sn))
				   )
		)
	)
	(if Ltyp
		(setvar "CELTYPE" Ltyp)
	)
	(if (LayChk Lnam)
		(command	"_.LAYER" "T" Lnam "S" Lnam "")
		(if Lcol
			(command	"_.LAYER" "M" Lnam "C" (itoa Lcol) "" "")
			(command	"_.LAYER" "M" Lnam "")
		)
	)
	(if Lcol
		(cond ((= (type Lcol) 'INT)
			  (setvar "CECOLOR" (itoa Lcol))
			 )
			 ((= (type Ocol) 'STR)
			  (setq Lcol -1)
			 )
			 (T
			  (setq Lcol (cdr (assoc 62 (tblsearch "LAYER" Lnam))))
			  (setvar "CECOLOR" (itoa Lcol))
			 )
		)
		(cond ((= (type Ocol) 'STR)
			  (setq Lcol -1)
			 )
			 (T
			  (setq Lcol -1)
			 )
		)
	)
	(if (and Bug Lcol)
		(princ (strcat "\nLcol = " (itoa Lcol)))
	)
	(if (setq	StrtPt
			    (getpoint
				    (strcat "\n\nPick starting point for " Ldes ": ")
			    )
	    )
		(while GoT
			(if NexPt
				(setq OPt NexPt)
				(setq OPt StrtPt)
			)
			(if Bug
				(princ (strcat	"\nOPt = "
							(rtos (car OPt) 2 4)
							","
							(rtos (cadr OPt) 2 4)
					  )
				)
			)
			(if NexPt
				(setq NexPt
						(getpoint	NexPt
								(strcat "\nPick next point for "
									   Ldes
									   ": "
								)
						)
				)
				(setq NexPt
						(getpoint	StrtPt
								(strcat "\nPick next point for "
									   Ldes
									   ": "
								)
						)
				)
			)
			(if (and Bug NexPt)
				(princ (strcat	"\nNexPt = "
							(rtos (car NexPt) 2 4)
							","
							(rtos (cadr NexPt) 2 4)
					  )
				)
			)
			(if NexPt
				(if (= (type NexPt) 'LIST)
					(if GoLst
						(setq GoLst (append GoLst (list NexPt))
							 Bubba (grdraw OPt NexPt Lcol)
							 Ang	  (angle OPt NexPt)
							 OPt	  NexPt
						)
						(setq GoLst (list NexPt)
							 Bubba (grdraw OPt NexPt Lcol)
							 Ang	  (angle OPt NexPt)
							 OPt	  NexPt
						)
					)
					(setq GoT nil)
				)
				(setq GoT nil)
			)
		)
	)
	(setq NeWid (* SF 0.06)
		 NewPt (polar OPt (+ Ang pi) (* SF 0.18))
	)
	(if (and StrtPt GoLst)
		(progn
			(command "PLINE" StrtPt "W" (* SF Lwid) (* SF Lwid))
			(mapcar (quote command) GoLst)
			(if ArrHd
				(command "W" "" NeWid NewPt)
			)
			(command "")
			(if InsHd
				(command "INSERT"
					    (strcat _Path-Sym InsHd)
					    (last GoLst)
					    (* SF (nth PosOut Lst_Sp_Ss))
					    ""
					    (rtd Ang)
				)
			)
		)
	)
	(command "REDRAW")
	(if Ltyp
		(setvar "CELTYPE" Otyp)
	)
	(if Lcol
		(setvar "CECOLOR" Ocol)
	)
	(if Bug
		(princ "\nBLines exited}\n")
	)
	(setvar "PLINEWID" 0.0)
	(princ)
)

(defun C:OffSets ( / OfS Ln2OfS TopT )			; Offsets pline a selected distance
; Function : offsets a selected pline the changes the parameters of the new pline
; Global   : SF - scale factor, LNdes - lines description, LNwid - linewidth
;            Lnam - layer name, offset - holds the variable name for some offset
	(if Bug
		(princ "\n{OffSets entered\n")
	)
	(setq OfS	(getreal (strcat "\nEnter offset distance: ["
						  (RTOS offset 2 2)
						  "]  "
				    )
			)
	)
	(if OfS
		(set offset OfS)
		(setq OfS offset)
	)
	(setq Ln2OfS (entsel (strcat "\nPick the "
						    LNdes
						    " is to be offset from: "
					 )
			   )
		 TopT   (getpoint "\nSide to offset to? ")
	)
	(command "_.OFFSET" OfS Ln2OfS TopT "")
	(command "_.CHANGE" "L" "" "P" "LTYPE" LNtyp "LAYER" lname "")
	(command "_.PEDIT" "L" "W" (* SF LNwid) "X")
	(if Bug
		(princ "\nOffSets exited}\n")
	)
	(princ)
)

(defun BOffSets ( Ldes Ltyp Lcol Lwid Lnam Odis	; Offsets pline a selected distance on right layer
				/	OfS Ln2OfS TopT )
	(if Bug
		(princ "\n{BOffSets entered\n")
	)
	(if (null Odis)
		(setq Odis 0.0001)
	)
	(setq OfS	(getreal (strcat "\nEnter offset distance: ["
						  (RTOS Odis 2 2)
						  "]  "
				    )
			)
	)
	(if OfS
		(setq	Odis		OfS)
		(setq	OfS		Odis)
	)
	(setq Ln2OfS (entsel
				   (strcat "\nPick the "
						 Ldes
						 " is to be offset from: "
				   )
			   )
		 TopT   (getpoint "\nSide to offset to? ")
	)
	(command "_.OFFSET" OfS Ln2OfS TopT "")
	(if Lcol
		(command "_.CHANGE" "L" "" "P" "COLOR" Lcol "")
	)
	(if Lnam
		(command "_.CHANGE" "L" "" "P" "LAYER" Lnam "")
	)
	(if Ltyp
		(command "_.CHANGE" "L" "" "P" "LTYPE" Ltyp "")
		(command "_.CHANGE" "L" "" "P" "LTYPE" "BYLAYER" "")
	)
	(command "_.PEDIT" "L" "W" (* SF Lwid) "X")
	(if Bug
		(princ "\nBOffSets exited}\n")
	)
	(princ)
)

(defun C:RR ( /	exprt RRSet EntLst			; Applys RailRoad look to landmark plines
				EntTyp EntLay )
; Name:     rr
; Function: sets layer and pline parameters then issues the command PLINE
	(if Bug (princ "\n{RR entered\n"))
	(setq exprt (getvar "EXPERT"))
	(setvar "EXPERT" 4)
	(if (not (LayChk "MISC"))
		(command	"_.LAYER" "M" "MISC" "C" "1" "MISC" "")
		(command	"_.LAYER" "T" "MISC" "S" "MISC" "")
	)
	(princ "\nSelect a misc. polyline to be marked as railroad: ")
	(if (not (tblsearch "BLOCK" "RRTICK"))
		(command "INSERT" (strcat _Path-Sym "RRTICK") (getvar "VIEWCTR") "" "" "" "_.ERASE" "L" "")
	)
	(while (setq RRSet (entsel))
		(setq	EntLst	(entget (car rrset)))
		(if EntLst
			(setq	EntTyp	(cdr (assoc 0 EntLst))
					EntLay	(cdr (assoc 8 EntLst))
			)
		)
		(if	(or	(= "POLYLINE" EntTyp)
				(= "LWPOLYLINE" EntTyp)
			)
			(if (or (= "MISC" EntLay) (= "BUDMISC" EntLay) (= "---LM---" EntLay))
				(command "MEASURE" RRSet "B" "RRTICK" "" "30")
				(princ "\n*** Polyline must be on Landmark layer ***")
			)
			(princ "\n*** Not a Polyline! ***")
		)
		(princ "\nSelect another polyline: ")
	)
	(setvar "EXPERT" exprt)
	(if Bug (princ "\nRR exited}\n"))
	(princ)
)

(defun C:DrwArr ( /	OLayer OMod )			; Draws Arrows
; Function: DRAW ARROW  calls PL() then puts symbol at the end
; Variables: Global Required: LNwid, lname, SymTyp
	(if Bug
		(princ "\n{DrwArr entered\n")
	)
	(setq	OLayer	(getvar "CLAYER")
			OMod	(getvar "OSMODE")
	)
	(setvar "OSMODE" 0)
	(command "LINETYPE"	"S" LNtyp	"" "LAYER" "T"	lname "S"	lname "")
	(setq	SymLst	(SymSizN "ARRHD")
			Gap		(nth 0 SymLst)
			Lngth	(nth 1 SymLst)
			SymNam	(nth 2 SymLst)
	)
	(PLx (* SF LNwid))
	(command "INSERT"
		    SymNam
		    (getvar "LASTPOINT")
		    (* sf Lngth)
		    ""
		    (rd2deg (getvar "LASTANGLE"))
	)
	(setvar "CLAYER" OLayer)
	(setvar "OSMODE" OMod)
	(if Bug
		(princ "\nDrwArr exited}\n")
	)
)

(defun PLx ( PW / )							; Pline replacement
	(if Bug
		(princ "\n{PL entered\n")
	)
	(setq PLset (ssadd)
		 spt	  (getpoint "\n\nFrom Point:\n")
		 ept	  (getpoint spt "\n\n<End of line>:\n")
	)
	(while ept
		(command "_.PLINE" spt "W" PW "" ept "")
		(setq PLset (ssadd (entlast) PLset)
			 spt	  ept
			 ept	  (getpoint spt "\n\n<End of line>:\n")
		)
	)
	(command "_.PEDIT" (ssname PLset 0) "J" PLset "" "X")
	(if Bug
		(princ "\nPL exited}\n")
	)
)

(defun C:Dtxt ( /	pfent spt cpt m slope ipt	; uses Dtext to input data
				pos omod mp slopep plname hlfwth plthk )
; Function:  Inserts text, if tbx (T/B) puts it along a selected line else puts horizonal
; Globals: height - size of text in inches
;          lname - layer name
;          tbx - sets Top or Bottom of line, or if tbx=nil then makes freestanding
	(if Bug
		(princ "\n{Dtxt entered\n")
	)
	(command	"_.LAYER" "T" lname "S" lname "")
	(if tbx
		(progn
			(setq	PFLst	(PFindN T))
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
		)
	)
	(cond
		((and tbx (or (= lname "STREET") (= lname "BUDSTREET")))
			(setq pt2	(getpoint
						ipt
						"\nPick other side of street perpendicular to previous pick....."
					)
				 ipt	(polar ipt
						  (angle ipt pt2)
						  (/ (distance ipt pt2) 2)
					)
			)
			(command "TEXT"
				    "S"
				    "STANDARD"
				    "M"
				    ipt
				    (* sf height)
				    (RD2DEG m)
			)
		)
		((and tbx (or (= lname "CONST_NOTES") (= lname "BUDCONST_NOTES")))
			(if (= tbx "B")
				(setq ipt
						(polar
							ipt
							mp
							(- (+ (* height sf 1.5)
								 hlfwth
							   )
							)
						)
				)
				(setq ipt
						(polar
							ipt
							mp
							(+ (* height sf 0.5) hlfwth)
						)
				)
			)
			(command "DTEXT"
				    "S"
				    "STANDARD"
				    ipt
				    (* sf height)
				    (RD2DEG m)
			)
		)
		(tbx
			(if (= tbx "B")
				(setq ipt
						(polar
							ipt
							mp
							(- (+ (* height sf) hlfwth))
						)
				)
				(setq ipt	(polar ipt
							  mp
							  (+	(* height sf)
								hlfwth
							  )
						)
				)
			)
			(command "TEXT"
				    "S"
				    "STANDARD"
				    "M"
				    ipt
				    (* sf height)
				    (RD2DEG m)
			)
		)
		(T
			(setvar "TEXTSTYLE" "STANDARD")
			(setvar "TEXTSIZE" (* sf height))
			(princ
				"\nPick the start point for the first text line...\n"
			)
			(command "MTEXT" pause pause)
		)
	)
	(if Bug
		(princ "\nDtxt exited}\n")
	)
)

(defun BDtxt ( Hgt Lnam Tbx /	Pt2 Ipt Ma	; inserts text on predefined correct layers
							OLay OSty OSiz OTxt BHgt PntMe TipT Tma )
	(if Bug
		(princ "\n{BDtxt entered\n")
	)
	(if (not Tmult)						 ; 11/9/98 for Cadet 2.*
		(setq Tmult 1.0)
	)
	(if (not SF)
		(SetScale)
	)
	(setq	OLay	(getvar "CLAYER")
			OSty	(getvar "TEXTSTYLE")
			OSiz	(getvar "TEXTSIZE")
			OTxt	(getvar "TEXTEVAL")
			BHgt	(* SF TMult Hgt)
	)
	(if (LayChk Lnam)
		(command	"_.LAYER" "T" Lnam "S" Lnam "")
		(command	"_.LAYER" "M" Lnam "")
	)
	(setvar "TEXTSTYLE" "STANDARD")
	(setvar "TEXTEVAL" 1)
	(if Tbx
		(progn
			(princ "\nSelect Polyline to Annotate: ")
			(setq PntMe (GetPLDat (entsel)))
		)
		(setq	Ipt		(getpoint "\nSelect text Placement: ")
				PntMe	nil
		)
	)
	(if (and Ipt (null PntMe))
		(setq	TMa		0.0
				TIpt	Ipt
				Bubba	(setvar "TEXTSIZE" BHgt)
		)
		(if (nth 0 PntMe)
			(setq	Ipt	(nth 1 PntMe)
					Ma	(nth 4 PntMe)
			)
			(setq	Ipt	nil
					Ma	nil
			)
		)
	)
	(if Ipt
		(if Tbx
			(if (= Tbx "B")
				(if (and (> Ma (/ pi 2.0))
					    (< Ma (/ (* 3.0 pi) 2.0))
				    )
					(setq	TIpt	(polar	Ipt
								   			(+ Ma (/ pi 2.0))
								   			(* BHgt 0.75)
									)
							TMa		(- Ma pi)
					)
					(setq	TIpt	(polar	Ipt
											(- Ma (/ pi 2.0))
											(* BHgt 0.75)
							 		)
							TMa		(if (>= Ma (/ (* 3.0 pi) 2.0))
										(- Ma (* 2.0 pi))
										Ma
									)
					)
				)
				(if (and (> Ma (/ pi 2.0))
					    (< Ma (/ (* 3.0 pi) 2.0))
				    )
					(setq	TIpt	(polar	Ipt
								   			(- Ma (/ pi 2.0))
								   			(* BHgt 0.75)
							 		)
						 	TMa		(- Ma pi)
					)
					(setq	TIpt	(polar	Ipt
								   			(+ Ma (/ pi 2.0))
								   			(* BHgt 0.75)
							 		)
							TMa		(if (>= Ma (/ (* 3.0 pi) 2.0))
										(- Ma (* 2.0 pi))
										Ma
									)
					)
				)
			)
		)
	)
	(if (< (getvar "cmdactive") 1)
		(if (null PntMe)
			(command "_.MTEXT" TIpt)
			(if (and TIpt TMa)
				(progn
					(princ "\nEnter text: ")
					(cond	((= Tbx "B")
								(command "DTEXT" "TL" TIpt BHgt (RD2DEG TMa))
							)
							((= Tbx "T")
								(command "DTEXT" TIpt BHgt (RD2DEG TMa))
							)
							(T
								(command "DTEXT" "M" TIpt BHgt (RD2DEG TMa))
							)
					)
				)
			)
		)
	)
	(setvar "TEXTEVAL" OTxt)
	(setvar "TEXTSTYLE" OSty)
	(if (> OSiz 0.0001)
		(setvar "TEXTSIZE" OSiz)
	)
;	(setvar "CLAYER" OLay)
	(if Bug
		(princ "\nBDtxt exited}\n")
	)
)

(defun C:Services ( / )
	(if (or (= (stpDot AppNam) "CADET20")(= (stpDot AppNam) "CADET"))
		(c:what_mode)						; Draws Service Lines on WE
	)
	(if Bug
		(princ "\n{Services entered\n")
	)
	(cond	((= AppMode "E")
				(BLines "SERVICE" nil 7 0.001 "Existing Service Line" "E")
			)
			((= AppMode "I")
				(BLines "SERVICE" "HIDDEN2" 7 0.001 "Install Service Line" "I")
			)
			(T
				(alert "\nServices only active in\nExisting or Install Modes.")
			)
	)
	(command "REDRAW")
	(if Bug
		(princ "\nServices exited}\n")
	)
	(princ)
)

(defun C:CIRCUIT ( / )						; Sets Layer & Pline params, then calls Pline
; Function : sets layer and pline parameters then issues the command PLINE
; Global Var. : sub, outypetbPH, fd, kv, width
	(if Bug (princ "\n{Circuit entered\n"))
	(cond
		((and (not sff) sf)
			(setq	sff	(/ sf 0.3408))
		)
		((and (not sf) sff)
			(setq	sf	(* sff 0.3408))
		)
		((and (not sff) (not sf))
			(SetScale)
		)
	)
	(if (and sub fd outypetbph kv)
		(if (tblsearch "LAYER" (strcat sub fd outypetbph kv))
			(progn
				(if (/= (strcase Mouse) "YES")
					(command	"LINETYPE" "S" "BYLAYER" ""
							"_.LAYER" "T" (STRCAT sub FD ouTYPEtbPH kv)
							"S" (STRCAT sub FD ouTYPEtbPH kv) ""
							"TABLET" "ON"
					)
					(command	"LINETYPE" "S" "BYLAYER" ""
							"_.LAYER" "T" (STRCAT sub FD ouTYPEtbPH kv)
							"S" (STRCAT sub FD ouTYPEtbPH kv) ""
					)
				)
				(setvar "THICKNESS" sff)
				(princ "\n\nPick starting point for circuit...\n")
				(command "PLINE" pause "W" (* sf width) (* sf width))
				(setvar "THICKNESS" 0.0)
			)
			(progn
				(setq subfdlst (remove subfdlst (strcat sub fd)))
				(princ (strcat "***" AppNam " Error*** Layer not found...please try 'Existing Feeder'"))
				(princ "\n                 or 'New Feeder', then 'Draw Circuit' again.  ")
			)
		)
		(princ "\nSubstation, feeder, phase, or KV not set.  \n")
	)
	(if Bug (princ "\nCircuit exited}\n"))
	(princ)
)

(defun Remove ( lst x /	nlst )				; Removes X from List
; Function:  to remove the specified element 'x' from list 'lst'
	(if Bug (princ "\n{Remove entered\n"))
	(if (listp lst)  ;--Make sure 'lst' is a list
		(foreach	elem
				lst
				(if (/= elem x) (setq nlst (cons elem nlst)))
		)
	)
	(if Bug (princ "\nRemove exited}\n"))
	(if nlst (reverse nlst))
)

(defun MisLin ( ltype width / )				; Meant to be a Pline prep function
; Function: sets layer and pline parameters then issues the command PLINE
	(if Bug (princ "\n{MisLin entered\n"))
	(cond
		((and (not sff) sf)
			(setq	sff	(/ sf 0.3408))
		)
		((and (not sf) sff)
			(setq	sf	(* sff 0.3408))
		)
		((and (not sff) (not sf))
			(SetScale)
		)
	)
	(command	"LINETYPE" "S" "BYLAYER" ""
			"_.LAYER" "T" (STRCAT "----" ltype "----")
			"S" (STRCAT "----" ltype "----") ""
	)
	(setvar "THICKNESS" sff)
	(princ "\n \nPick starting point:\n")
	(command "PLINE" pause "W" (* sf width) (* sf width))
	(setvar "THICKNESS" 0.0)
	(if Bug (princ "\nMisLin exited}\n"))
)

(defun C:WATER ( / )						; Meant to be a Pline prep function
; Function: sets layer and pline parameters then issues the command PLINE
	(if Bug (princ "\n{Water entered\n"))
	(cond
		((and (not sff) sf)
			(setq	sff	(/ sf 0.3408))
		)
		((and (not sf) sff)
			(setq	sf	(* sff 0.3408))
		)
		((and (not sff) (not sf))
			(SetScale)
		)
	)
	(command	"_.LAYER" "T" "----WA----" "S" "----WA----" "")
	(setvar "THICKNESS" sff)
	(setq pt (getpoint "\n\nEnter water-line starting point: "))
	(command "PLINE" pt "W" "0" "")
	(setvar "THICKNESS" 0.0)
	(if Bug (princ "\nWater exited}\n"))
	(princ)
)

(defun TxtLn ( txt height ltype tbx /	ipt		; determines the placement of the text
								pfent spt cpt m slope pos omod mp slopep plname hlfwth plthk )
; Function: Used in wire size, street, dist\div, and transmission text.
;           It determines the placement of the text depending on whether
;           the text will be on the top or bottom of the circuit.
;           The proper layer is also set.      S.E.R.  9-6-88
; Modified: JVG  3/89
	(if Bug (princ "\n{TxtLn entered\n"))
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
   ;--Offset all text the same dist from circuit c/l (as if 3 phase circ).
   ;  'plthk' = polyline thickness, is set in pfind().
   ;  'height' is text height in inches for final plot.
   ;  0.025 is clearance in inches between text and 3ph circuit.
   ;  0.04 is 3ph circuit width in inches for final plot.
   ;--This works for Midpoint aligned text.
   (setq ipt (polar ipt mp (if (= tbx "B")
                 (- (+ (* 0.025 plthk 0.3048) (/ (+ (* height sf) (* 0.04 plthk 0.3048)) 2)))
                 ;else
                    (+ (* 0.025 plthk 0.3048) (/ (+ (* height sf) (* 0.04 plthk 0.3048)) 2)))))
   (cond
      ((= ltype nil)
         (setq lname (strcat (substr plname 1 6) tbx (substr plname 8 3))))
      ((= ltype "ST")
         (setq lname (strcat (substr plname 1 3) "-ST"
                             tbx "-" (substr plname 9 2))))
      ((and (= ltype "WS")
            (= (substr plname 5 2) "CK"))
         (setq lname (strcat (substr plname 1 4)
                             ltype tbx (substr plname 8 3))))
      (T
         (setq lname nil))     ;---don't allow wire text anywhere else
   )
   (if lname
      (progn
         (command	"_.LAYER" "T" lname "S" lname "")
         (if (NOT txt)
           (setq txt (getstring T "\n \nEnter street name: "))
         )
         (command "TEXT" "S" "STANDARD" "M" ipt (* sf height) slope txt)
         (setthk (entget (entlast)))  ;sets thickness
      )
   )
   (if (and reptxt (= ltype "WS")) (progn
     (menucmd "P1=WIRE")
     (menucmd "P1=*"))
   ;else
     (menucmd "P1=P1A")
   )
   (if Bug (princ "\nTxtLn exited}\n"))
)

(defun DtxtLn ( height ltype tbx /	orig new	; Inserts text along a selected line
								pfent spt cpt m slope pos omod mp slopep plname
								hlfwth plthk ipt txt LastEnt )
; Function:  Inserts text along a selected line with the DTEXT command
	(if Bug (princ "\n{DTxtLn entered\n"))
	(setq test T)
	(setq LastEnt (entlast))
	(while test
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
     ;--Offset all text the same dist from circuit c/l (as if 3 phase circ).
     ;  'plthk' = polyline thickness, is set in pfind().
     ;  'height' is text height in inches for final plot.
     ;  0.025 is clearance in inches between text and 3ph circuit.
     ;  0.04 is 3ph circuit width in inches for final plot.
     (setq ipt (polar ipt mp (if (= tbx "B")
                  (- (+ (* 0.025 plthk 0.3048) (/ (+ (* height sf) (* 0.04 plthk 0.3048)) 2)))
                  ;else
                  (+ (* 0.025 plthk 0.3048) (/ (+ (* height sf) (* 0.04 plthk 0.3048)) 2)))))
     ;--Adjust insert pt for Standard-aligned text.--------------------------
     (setq ipt (polar ipt mp (- (/ (* height sf) 2))))
     (cond
        ((= ltype nil)
           (setq lname (strcat (substr plname 1 6) tbx (substr plname 8 3))))
        ((= ltype "ST")
           (setq lname (strcat
             (substr plname 1 3) "-ST" tbx "-" (substr plname 9 2))))
        ((= ltype "WS")
           (cond
             ((= (substr plname 5 2) "CK")
               (setq lname (strcat (substr plname 1 4) ltype
                                   tbx (substr plname 8 3))))
             ((= (substr plname 5 1) "T")
               (setq lname (strcat (substr plname 1 6) tbx
                                   (substr plname 8 3))))
           ));endcond
        (T
           (setq lname nil))
     );endcond
     (command	"_.LAYER" "T" lname "S" lname "")
     (princ "\nText (Type exit to Exit): ")
     (command "DTEXT" "S" "STANDARD" ipt (* sf height) slope)
     (setq orig (ssname (ssget "L") 0)
           txt (cdr (assoc 1 (entget orig))))
     (entdel orig)
     (if (not (or (= txt "exit") (= txt "EXIT")))
       (progn
         (command "TEXT" "S" "STANDARD" "M" ipt (* sf height) slope txt)
         (setq new (ssname (ssget "L") 0))
         (setq entlst (entget new))
         (setq entlst (subst (cons 11 (list (- (* 2 (cadr (assoc 11 entlst)))
                                                    (cadr (assoc 10 entlst)))
                                            (- (* 2 (caddr (assoc 11 entlst)))
                                                    (caddr (assoc 10 entlst)))))
                             (assoc 11 entlst) entlst))
         (entmod entlst)
         (entupd new)
         (if (not reptxt)
           (progn
             (menucmd "P1=P1A")
             (setq test nil)
           )
         )
       )
       ;else
        (progn
          (menucmd "P1=P1A")
          (setq test nil)
        )
      )
   )
   (while (setq LastEnt (entnext LastEnt))
      (setthk (entget LastEnt))  ;sets thickness
   )
   (if Bug (princ "\nDTxtLn exited}\n"))
)

(defun LM_TXT ( height /	LastEnt )			; Used to insert landmark text
; Function: Used to insert landmark text.  The user selects the point
;           of insertion and the angle for the text.  S.E.R.   9-6-88
;
   (if Bug (princ "\n{Lm_Txt entered\n"))
   (setq pt (getpoint "\nPick the midpoint for the first text line..."))
   (setq LNAME "----LM----")
   (command	"_.LAYER" "T" lname
                    "S" lname
                    "C" "15" lname "")
   (setq LastEnt (entlast))
   (setvar "CMDECHO" 1)
   (command "DTEXT" "S" "STANDARD" "M" pt (* height sf) pause)
   (setvar "CMDECHO" 0)
   (while (setq LastEnt (entnext LastEnt))
      (setthk (entget LastEnt))  ;sets thickness
   )
   (if Bug (princ "\nLm_Txt exited}\n"))
)

(defun FdrLstChk ( / LastEnt )					; Set correct layer and text size for feeder table
	; Function:  Set correct layer and text size for substation feeder table
	(if Bug (princ "\n{FdrLstChk entered\n"))
	(initget 1)
	(setq pt (getpoint "\n \n \nPick starting point for Sub Feeder list..."))
	(command	"_.LAYER" "T" "----SB----" "S" "----SB----" "")
	(setq LastEnt (entlast))
	(princ "\n \nEnter text for each line of Feeder List (e.g., 1 - 34540)...\nText: ")
	(command "DTEXT" pt (* 0.1 sf) "0")
	(while (setq LastEnt (entnext LastEnt))
		(setthk (entget LastEnt))  ;sets thickness
	)
	(if Bug (princ "\nFdrLstChk exited}\n"))
)

(defun ChgWth ( w /	cross )				; Build crossing sets along each side of window
; Function:  Build crossing sets along each side of window and change
;            polyline widths in each crossing set to width <w>
;            <minx, miny> and <maxx, maxy> are lower left and upper right
;              corners of window--set in calling routine
;
   (if Bug (princ "\n{ChgWth entered\n"))
	(if (setq cross (ssget "C" (list minx miny) (list maxx miny))) (pwidth w))
	(if (setq cross (ssget "C" (list maxx miny) (list maxx maxy))) (pwidth w))
	(if (setq cross (ssget "C" (list minx maxy) (list maxx maxy))) (pwidth w))
	(if (setq cross (ssget "C" (list minx miny) (list minx maxy))) (pwidth w))
   (if Bug (princ "\nChgWth exited}\n"))
)

(defun TrimSet ( / )						; trims entities outside of points
; Function: trims entities outside of specified coordinates (llx,lly,urx,ury)
; Author:   Glen Summerall
;
   (if Bug (princ "\n{TrimSet entered\n"))
	(command	"_.ERASE"
				"C"
				(list (- mnxhld 100) (- mnyhld 100))
				(list (+ mxxhld 100) (+ mxyhld 100))
				"R"
				"W"
				(list (- llx 2) (- lly 2))
				(list (+ urx 2) (+ ury 2))
				""
	)
   (if Bug (princ "\nTrimSet exited}\n"))
)

(defun ResetW ( newscm /	lname width )		; Reset width of pline
;------------------------------------------------------------------------------
;  Name:      resetw
;  Function:  Reset pline widths according to scale of their panel
;             <entlst> is entity list (from calling routine)
;             <newscm> is new scale in meters (from calling routine)
;
   (setq lname (cdr (assoc 8 entlst)))
   (if Bug(progn (princ "\n{ResetW entered - parameters: ")(prin1 newscm) 
   	(princ "\n entlst :")(prin1 entlst)) )
   (if (= (substr lname 5 3) "CK-") (progn
; Commented out 4/8/91 - appeared to reset width of fill lines twice.
;    Once here and once in fix_fl
;   (if (or (= (substr lname 5 3) "CK-")
;           (= (substr lname 5 3) "FL-")) (progn
;   ))
     (setq width (getwid lname)
           entlst (subst (cons 40 width)		; [TODO] check(* newscm width)
                         (assoc 40 entlst) entlst))
     (setq entlst (subst (cons 41 width)
                         (assoc 41 entlst) entlst))
     (entmod entlst)
	
	;	[TODO] check with EdW about code change to handle vertex updates
	(setq en2 entlst)
	(while (/= (cdr (assoc 0 en2)) "SEQEND")
		(if (= (cdr (assoc 0 en2)) "VERTEX")
			(progn
				(setq en2 (Subst (cons 40 width) (assoc 40 en2) en2)
					 en2 (Subst (cons 41 width) (assoc 41 en2) en2)
				)
				(entmod en2)
			)
		)
		(setq en2 (entget (entnext (cdr (assoc -1 en2))) (list "*")))
	)
   ))
   (if Bug (progn (princ "\nResetW exited - return: ") (prin1 entlst) ))
)

(defun FixPlW ( /	thkm cross ent icount )		; fix polyline widths
; Function: fix polyline widths that were set to zero for break routine
; Author:   Glen Summerall
;
   (if Bug (princ "\n{FixPlW entered\n"))
	(setq	icount	0)
	(if (setq cross (ssget "C" (list minx miny) (list maxx (+ miny 6))))   ;RER
		(progn
			(while	(setq ent (ssname cross icount))
				(setq	entlst	(entget ent)
						ZeroType	(cdr (assoc 0 entlst));entity type
				)
				(if (= ZeroType "POLYLINE")
					(progn
						(setq	thkm	(* 0.3048 (cdr (assoc 39 entlst)))   ;thickness in meters
								lnam	(cdr (assoc 8 entlst)))       ;layer name req'd by resetw
						(resetw thkm)
					)
				)
				(setq	icount	(1+ icount))
			)
		)
	)
	(setq	icount	0)
	(if (setq cross (ssget "C" (list maxx miny) (list (- maxx 6) maxy)))    ;RER
		(progn
			(while (setq ent (ssname cross icount))
				(setq	entlst	(entget ent)
						ZeroType	(cdr (assoc 0 entlst));entity type
				)
				(if (= ZeroType "POLYLINE")
					(progn
						(setq	thkm	(* 0.3048 (cdr (assoc 39 entlst)))   ;thickness in meters
								lnam	(cdr (assoc 8 entlst))       ;layer name req'd by resetw
						)
						(resetw thkm)
					)
				)
				(setq	icount	(1+ icount))
			)
		)
	)
	(setq	icount	0)
	(if (setq cross (ssget "C" (list minx maxy) (list maxx (- maxy 6))))    ;RER
		(progn
			(while (setq ent (ssname cross icount))
				(setq	entlst	(entget ent)
						ZeroType	(cdr (assoc 0 entlst))      ;entity type
				)
				(if (= ZeroType "POLYLINE")
					(progn
						(setq	thkm	(* 0.3048 (cdr (assoc 39 entlst)))   ;thickness in meters
								lnam	(cdr (assoc 8 entlst))       ;layer name req'd by resetw
						)
						(resetw thkm)
					)
				)
				(setq	icount	(1+ icount))
			)
		)
	)
	(setq	icount	0)
	(if (setq cross (ssget "C" (list minx miny) (list (+ minx 6) maxy)))     ;RER
		(progn
			(while (setq ent (ssname cross icount))
				(setq	entlst	(entget ent)
						ZeroType	(cdr (assoc 0 entlst))      ;entity type
				)
				(if (= ZeroType "POLYLINE")
					(progn
						(setq	thkm	(* 0.3048 (cdr (assoc 39 entlst)))   ;thickness in meters
								lnam	(cdr (assoc 8 entlst))       ;layer name req'd by resetw
						)
						(resetw thkm)
					)
				)
				(setq	icount	(1+ icount))
			)
		)
	)
   (if Bug (princ "\nFixPlW exited}\n"))
)

(setq	LodVer	"2.5.3i")
