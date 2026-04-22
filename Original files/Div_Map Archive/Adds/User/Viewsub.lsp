(defun c:Viewsub	( /	Eset ctr n Ename									       ; Collects all text, Checks for proper height (.7)
					sname vname											  ; get xy coord, steps thru selection set
					vXcord vYcord vdist										  ; building a view around each xy coord.
					cmdE maxS len char_chk )
	(if Bug (princ "\n{Viewsub entered\n"))
	(if (= (getvar "UNDOCTL") 0)
		(command "_.UNDO" "N")												  ;initialize undo
		(if (= (getvar "UNDOCTL") 3)
			(command "_.UNDO" "C" "N")
		)
	)
	(setq	cmdE		(getvar "CMDECHO")										  ;Store existing variables
			maxS		(getvar "MAXSORT")										  ;to restore later
			n 0
			suffix 1															  ;Item index
	)
	(setvar "CMDECHO" 0)													  ;Turn echo off
	(if	(setq	Eset	(ssget "X"	(list	(cons 0 "TEXT")))					  ;Get all text, if exists
		)																  ;go to work
		(progn
			(while (setq Ename (ssname Eset n))								  ;get item
				(setq ent (entget ename))									  ;get entity data
				(if (and (> (strlen (cdr (assoc 1 ent))) 3)(>= (cdr (assoc 40 ent)) 0.10));Include only sub names greater than 
					(progn												  ;3 chararcters long and with a height of .7
						(setq sname (cdr (assoc 1 ent))						  ;Get sub name
							 xycord (cdr (assoc 10 ent))						  ;Get xy							 						  
							 vxcord (car xycord)							  ;Get x
							 vycord (cadr xycord)							  ;Get y
							 vdist 400.0									  ;Set half view width
					    		 len (strlen sname)								  ;Get string length
							 ctr 1										  ;Character index
							 vname ""										  ;Declare view name as empty string
						)
						(repeat len
							(setq char_chk (substr sname ctr 1))				  ;Step thru each letter of each piece of text
							(if (or   (= char_chk " ")     		 			  ;replace characters not allowed for naming views
									(= char_chk "#")   		 				  ;with underscore
									(= char_chk ".")
									(= char_chk "'")
									(= char_chk "(")
									(= char_chk ")")
									(= char_chk "/")
									(= char_chk "&")
									(= char_chk ":")
									(= char_chk ",")
									(= char_chk ";")
									(= char_chk "%")
									(= char_chk "\"")
								)
								(setq char_chk "_")
							)
							(setq vname (strcat vname char_chk)				  ;Put text back together for view name
							 	 ctr (+ ctr 1)
							)
						)
						(setq vname (substr vname 1 30))
						(if (tblsearch "VIEW" vname)
							(progn
								(setq vname (strcat vname (itoa suffix)))
								(setq suffix (1+ suffix))
							)
						)
						(command "_.VIEW" "W" vname (list (- vXcord vdist) 	       ;Make the view
												    (- vYcord vdist)) 
											   (list (+ vXcord vdist) 
											   	    (+ vYcord vdist))
						)																	
					)
				)
				(setq	n	(1+ n))										  ;Go to next item
			)
		)
	)
	(c:shvw)
	(setvar "CMDECHO" cmdE)
	(setvar "MAXSORT" maxS)
	(princ "\nViewsub exited}\n")
	(princ)
)
(defun c:shvw ( / vw clr vwctr vw_ctr
				vw_xctr vw_yctr vw_ht
				vw_wdth llxy ulxy urxy
				lrxy )							    						  ;Show where views are on dwg
	(setq vw (tblnext "VIEW" t)
		 clr 1
		 vwctr 0
	)
		(while vw
			(setq
				 vw_ctr(cdr (assoc 10 vw))
				 vw_xctr (car vw_ctr)
				 vw_yctr (cadr vw_ctr)
				 vw_ht (/ (cdr (assoc 40 vw)) 2.0)
				 vw_wdth (* vw_ht 1.65) 
				 llxy (list (- vw_xctr vw_wdth) (- vw_yctr vw_ht))
				 ulxy (list (- vw_xctr vw_wdth) (+ vw_yctr vw_ht))
				 urxy (list (+ vw_xctr vw_wdth) (+ vw_yctr vw_ht))
				 lrxy (list (+ vw_xctr vw_wdth) (- vw_yctr vw_ht))
			)
			(setq vwctr (+ vwctr 1))
			(if (= clr 255)
				(setq clr 1)
				(setq clr (+ clr 1))
			)
 		 	(grdraw llxy ulxy clr)
			(grdraw ulxy urxy clr)
			(grdraw urxy lrxy clr)
			(grdraw lrxy llxy clr)
			(setq vw (tblnext "VIEW"))
		)
		(princ vwctr) 
		(princ "\nViews saved\n")
		(princ)
)

