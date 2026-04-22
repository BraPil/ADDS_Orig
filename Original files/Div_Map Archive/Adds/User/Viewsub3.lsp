(defun c:Viewsub3	( /	Eset ctr n Ename									       ; Collects all text, Checks for proper height (.7)
					sname vname vname1										  ; get xy coord, steps thru selection set
					vXcord vYcord vdist										  ; building a view around each xy coord.
					cmdE maxS len char_chk 
					sublist sub vnamelen)
	(if Bug (princ "\n{View4Sw entered\n"))
	(if (= (getvar "UNDOCTL") 0)
		(command "_.UNDO" "N")												  ;initialize undo
		(if (= (getvar "UNDOCTL") 3)
			(command "_.UNDO" "C" "N")
		)
	)
	(setq	cmdE		(getvar "CMDECHO")										  ;Store existing variables
			maxS		(getvar "MAXSORT")										  ;to restore later
			n 0
			vname_ctr 1													  ;Item index
	)
	(setvar "CMDECHO" 0)													  ;Turn echo off
	(if	(setq	Eset	(ssget "X"	(list	(cons 0 "TEXT")))					  ;Get all text, if exists
		)																  ;go to work
		(progn
			(setq sublist (list ))
			(while (setq Ename (ssname Eset n))								  ;get item
				(setq ent (entget ename))									  ;get entity data
				(if (and (> (strlen (cdr (assoc 1 ent))) 3)
							  (= (cdr (assoc 40 ent)) 0.7)					  ;Include only sub names greater than 
					)													  ;3 chararcters long and with a height of .7
					(progn												  
						(setq sname (cdr (assoc 1 ent))						  ;Get sub name
							 xycord (cdr (assoc 10 ent))						  ;Get xy							 						  
							 vxcord (car xycord)							  ;Get x
							 vycord (cadr xycord)							  ;Get y
							 vdist 25.0									  ;Set half view width
					    		 len (strlen sname)								  ;Get string length
							 ctr 1										  ;Character index
							 vname_ctr 1									  ;Duplicate view suffix counter
							 vname ""
							 lastvname ""									  ;Declare view name as empty string
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
								)
								(setq char_chk "_")
							)
							(setq vname (strcat vname char_chk)				  ;Put text back together for view name
							 	 ctr (+ ctr 1)
							)
						)
						(repeat 2
							(if (= (substr vname 1 1) "_")					  ;if view name starts with underscore
								(setq vname (substr vname 2 (- (strlen vname) 1)))  ;take out underscore
							)
						)
						(setq sublist (cons (strcat vname					  	  ;Make a list of all views
										" "
									   (rtos vxcord)
									     " "
									   (rtos vycord)
									     " "
									   (itoa (strlen vname))
									     " "
										)
									sublist
									)
						)
					)
				)
				(setq	n	(1+ n))									  	  ;Go to next item
			)
			(setq sublist (acad_strlsort sublist)								  ;Sort view list
			)													  		  
			(foreach sub
				    sublist												  ;Step thru list for view data
				    (setq vnamelen (atoi (substr sub (- (strlen sub) 2) 2))
				    		vname    (substr sub 1 vnamelen)
						vxcord   (atof (substr sub (+ vnamelen 2) 8))
						vycord   (atof (substr sub (+ vnamelen 10) 8))
						vname1 vname
					)
					(if (= vname lastvname)									  ;if view already exists
							(progn										  ;add numerical suffix
								(setq vname (strcat vname (itoa vname_ctr)))
								(setq vname_ctr (+ vname_ctr 1))
							)
					)
					(setq lastvname vname1)
				(command "_.VIEW" "W" vname (list (- vXcord vdist) 	       		  ;Make the view
										    (- vYcord vdist)) 
									   (list (+ vXcord vdist) 
										    (+ vYcord vdist))
				)
			)									  
		)
	 )
	(c:shvw)
	(setvar "CMDECHO" cmdE)													  ;Restore sys variables
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

