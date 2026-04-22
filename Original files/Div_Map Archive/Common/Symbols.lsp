(if AppNam								; Code Version Indicator {4749 Lines of Code}
	(princ (strcat "\n" AppNam " Symbols Loading."))
	(princ "\nCadet 2.1 Symbols Loading.\n")
)

(defun Cb_PolDrw ( / )						; Call Back - Pole Draw
	(setq npos1 (get_tile "lst1"))
;	(if (= npos1 "1")				Modify code per CADET User Group Requests from 11/25/08
;		(mode_tile "lst3" 0)
;		(mode_tile "lst3" 1)
;	)
	(mode_tile "lst3" 0)
)

(defun Cb_ConstDrw ( / )					; Call Back - Construction Draw
	(setq npos1 (get_tile "lst1"))
	(if (member (nth (atoi npos1) Ls_Const_Name) (list "North Arrow" "Wire Size Change"))
		(mode_tile "val1" 1)
		(mode_tile "val1" 0)
	)
)

(defun C:CAP ( / )							; Capacitor Draw
;****************************************************************************
;Function: C:CAP
;Purpose: inserts a capacitor.
;Local: lst1 npos1 nval1 lst2 npos2
;Global: If Ls_CAPACTR_DFLT does not exist it gets created.
;Functions called: PICCKT
;****************************************************************************
	(CapDrw nil)
	(princ)
)

(defun CapDrw ( Itm /	dcl_sym LayNam _Fdr		; Capacitor Dialog Data
					_Ph _level _ou dlg npos1
					nval1 npos2 Ls_CAPACTR_DFLT )
	(setq Mnum (cond ((= AppMode "E") 1)
				  ((= AppMode "I") 2)
				  ((= AppMode "C") 3)
				  ((= AppMode "R") 4)
				  (T 1)
			 )
	)
	(if Itm
		(if (not (and (> Itm 0)
				    (<= Itm (1- (length Ls_CAPACTR_Name)))
			    )
		    )
			(setq Itm nil)
			(if (= (substr	(nth	(setq PosOut
									(LookLst Itm
										    Ls_CAPACTR_Name
										    Lst_Sp_Dn
									)
							)
							Lst_Sp_Ma
						)
						Mnum
						1
				  )
				  "0"
			    )
				(progn
					(DevModA PosOut)
					(exit)
				)
			)
		)
	)
	(setq DatLst (PicCkt))
	(setq dcl_sym (load_dialog "symbols.dcl"))
	(if (and Ls_CAPACTR_Name Ls_CAPACTR_Desc DatLst)
		(progn
			(setq LayNam (nth 2 DatLst))
			(if (member (substr LayNam 1 3) Lst_Fd_V)
				(setq
					_Fdr	(nth	(- (length Lst_Fd_V)
							   (length
								   (member (substr LayNam 1 3)
										 Lst_Fd_V
								   )
							   )
							)
							Lst_Fd_S
						)
				)
				(setq _Fdr "")
			)
			(setq _Ph (nth (atoi (substr LayNam 8 1)) Lst_Ph_S))
			(if (= (substr LayNam 4 1) "O")
				(setq _ou "OVERHEAD")
				(setq _ou "UNDERGROUND")
			)
			(if (= (substr LayNam 5 2) "CK")
				(setq _level (strcat (substr LayNam 9 2)
								 " kV PRIMARY"
						   )
				)
				(setq _level "SECONDARY")
			)
			(if Itm
				(setq Ls_CAPACTR_DFLT (list Itm "" 0))
				(setq Ls_CAPACTR_DFLT (list 1 "" 0))
			)
			(new_dialog "CAPACTR" dcl_sym)
			(set_tile "_Fdr" _Fdr)
			(set_tile "_Ph" _Ph)
			(set_tile "_ou" _ou)
			(set_tile "_level" _level)
			(start_list "lst1" 3)
			(mapcar (quote add_list) Ls_CAPACTR_Name)
			(end_list)
			(set_tile "lst1" (itoa (nth 0 Ls_CAPACTR_DFLT)))
			(set_tile "val1" (nth 1 Ls_CAPACTR_DFLT))
			(start_list "lst2" 3)
			(mapcar (quote add_list) Ls_CAPACTR_Desc)
			(end_list)
			(set_tile "lst2" (itoa (nth 2 Ls_CAPACTR_DFLT)))
			(action_tile "_Fdr" "(setq _Fdr $value)")
			(action_tile "_Ph" "(setq _Ph $value)")
			(action_tile "_ou" "(setq _ou $value)")
			(action_tile "_level" "(setq _level $value)")
			(action_tile "lst1" "(setq npos1 $value)")
			(action_tile "val1" "(setq nval1 $value)")
			(action_tile "lst2" "(setq npos2 $value)")
			(setq dlg (start_dialog))
			(if (= dlg 1)
				(progn
					(if npos1
						(setq npos1 (atoi npos1))
						(setq npos1 (nth 0 Ls_CAPACTR_DFLT))
					)
					(if nval1
						(setq nval1 (strcase nval1))
						(setq nval1 (nth 1 Ls_CAPACTR_DFLT))
					)
					(if npos2
						(setq npos2 (atoi npos2))
						(setq npos2 (nth 2 Ls_CAPACTR_DFLT))
					)
					(if (> npos1 0)
						(progn
							(setq Ls_CAPACTR_DFLT
									(list npos1
										 nval1
										 npos2
									)
							)
							(if (= cb 1)
								(chgDev
									(list (nth npos1 Ls_CAPACTR_Name)
										 nval1
									 	(nth npos2 Ls_CAPACTR_Desc)
									)
								)
 								(DrwDev
									(list (nth npos1 Ls_CAPACTR_Name)
										 nval1
										 (nth npos2 Ls_CAPACTR_Desc)
									)
								)
							)
						)
						(alert
							"Warning: Function canceled because DEVICE cannot be left blank."
						)
					)
				)
			)
		)
		(alert
			"ERROR: Ls_CAPACTR_Name or Ls_CAPACTR_Desc not defined!"
		)
	)
	(unload_dialog dcl_sym)
	(princ)
)

(defun C:CONST ( / )						; Construction Draw
	(ConstDrw nil)
	(princ)
)

(defun ConstDrw ( Itm /	dcl_sym LayNam _Fdr _Ph	; Construction Dialog Data
					_level _ou dlg npos1 nval1 npos2
					Ls_Const_DFLT Onam DrgAt )
	(setq Mnum (cond ((= AppMode "E") 1)
				  ((= AppMode "I") 2)
				  ((= AppMode "C") 3)
				  ((= AppMode "R") 4)
				  (T 1)
			 )
	)
	(if Itm
		(if (not (and (> Itm 0) (<= Itm (1- (length Ls_Const_Name))))
		    )
			(setq Itm nil)
			(if (= (substr	(nth	(setq PosOut (LookLst Itm
											  Ls_Const_Name
											  Lst_Sp_Dn
									   )
							)
							Lst_Sp_Ma
						)
						Mnum
						1
				  )
				  "0"
			    )
				(progn
					(DevModA PosOut)
					(exit)
				)
			)
		)
	)
	(if DragAtt
		(progn
			(toggle "DragAtt")
			(setq	DrgAt	T)
		)
		(setq DrgAt nil)
	)
	(setq DatLst nil
		 Onam   (getvar "CLAYER")
	)
	(if (or (/= itm 5) (/= itm 4))
		(command "_.layer" "t" "const_notes" "s" "const_notes" "")
	)
	(if (= itm 4)
		(command	"_.LAYER" "T" "work_loc" "S" "work_loc" "")
	)
	(if (= itm 5)
		(command "_.layer" "t" "angle" "s" "angle" "")
	)
	(setq dcl_sym (load_dialog "symbols.dcl"))
	(if (and Ls_Const_Name Ls_Const_Desc)
		(progn
			(if DatLst
				(setq LayNam (nth 2 DatLst))
				(setq LayNam (getvar "CLAYER"))
			)
			(if (member (substr LayNam 1 3) Lst_Fd_V)
				(setq
					_Fdr	(nth	(- (length Lst_Fd_V)
							   (length
								   (member (substr LayNam 1 3)
										 Lst_Fd_V
								   )
							   )
							)
							Lst_Fd_S
						)
				)
				(setq _Fdr "")
			)
			(setq _Ph (nth (atoi (substr LayNam 8 1)) Lst_Ph_S))
			(if (= (substr LayNam 4 1) "O")
				(setq _ou "OVERHEAD")
				(setq _ou "UNDERGROUND")
			)
			(if (= (substr LayNam 5 2) "CK")
				(setq _level (strcat (substr LayNam 9 2)
								 " kV PRIMARY"
						   )
				)
				(setq _level "SECONDARY")
			)
			(if Itm
				(setq Ls_Const_DFLT (list Itm ""))
				(setq Ls_Const_DFLT (list 1 ""))
			)
			(new_dialog "CONSTRU" dcl_sym)
			(set_tile "_Fdr" _Fdr)
			(set_tile "_Ph" _Ph)
			(set_tile "_ou" _ou)
			(set_tile "_level" _level)
			(start_list "lst1" 3)
			(mapcar (quote add_list) Ls_Const_Name)
			(end_list)
			(set_tile "lst1" (itoa (nth 0 Ls_Const_DFLT)))
			(set_tile "val1" (nth 1 Ls_Const_DFLT))
			(cb_ConstDrw)
			(action_tile "_Fdr" "(setq _Fdr $value)")
			(action_tile "_Ph" "(setq _Ph $value)")
			(action_tile "_ou" "(setq _ou $value)")
			(action_tile "_level" "(setq _level $value)")
			(action_tile "lst1" "(cb_ConstDrw)")
			(action_tile "val1" "(setq nval1 $value)")
			(setq dlg (start_dialog))
			(if (= dlg 1)
				(progn
					(if npos1
						(setq npos1 (atoi npos1))
						(setq npos1 (nth 0 Ls_Const_DFLT))
					)
					(if nval1
						(setq nval1 (strcase nval1))
						(setq nval1 (nth 1 Ls_Const_DFLT))
					)
					(if (> npos1 0)
						(progn
							(setq Ls_Const_DFLT
									(list npos1 nval1)
							)
							(DrwDev
								(list (nth npos1 Ls_Const_Name)
									 nval1
									 0
								)
							)
						)
						(alert
							"Warning: Function canceled because DEVICE cannot be left blank."
						)
					)
				)
			)
		)
		(alert "ERROR: Ls_Const_Name or Ls_Const_Desc not defined!")
	)
	(unload_dialog dcl_sym)
	(if DrgAt
		(progn
			(toggle "DragAtt")
			(setq	DrgAt	nil)
		)
	)
	(setvar "CLAYER" Onam)
	(princ)
)

(defun C:Guy ( / )							; Guy Draw
;****************************************************************************
;Function: C:GUY
;Purpose: inserts DOWN GUY or SPAN GUY.
;Local: lst1 npos1 lst2 npos2
;Global: If Ls_GUY_DFLT does not exist it gets created.
;****************************************************************************
	(GuyDrw nil)
	(princ)
)

(defun GuyDrw ( Itm /	dcl_sym _Fdr _Ph _ou	; Guy Dialog Data
					_level lst1 npos1 LayNam dlg )
	(setq Mnum (cond ((= AppMode "E") 1)
				  ((= AppMode "I") 2)
				  ((= AppMode "C") 3)
				  ((= AppMode "R") 4)
				  (T 1)
			 )
	)
	(if Itm
		(if (not (and (> Itm 0) (<= Itm (1- (length Ls_GUY_Name)))))
			(setq Itm nil)
			(if (= (substr	(nth	(setq PosOut (LookLst Itm
											  Ls_GUY_Name
											  Lst_Sp_Dn
									   )
							)
							Lst_Sp_Ma
						)
						Mnum
						1
				  )
				  "0"
			    )
				(progn
					(DevModA PosOut)
					(exit)
				)
			)
		)
	)
	;(if (/= toolpic 1)
		(setq dcl_sym (load_dialog "symbols.dcl"))
	;)
	(setq DatLst (PicPole))
	(if Ls_GUY_Name
		(progn
			(setq LayNam (nth 2 DatLst))
			(if (member (substr LayNam 1 3) Lst_Fd_V)
				(setq
					_Fdr	(nth	(- (length Lst_Fd_V)
							   (length
								   (member (substr LayNam 1 3)
										 Lst_Fd_V
								   )
							   )
							)
							Lst_Fd_S
						)
				)
				(setq _Fdr "")
			)
			(setq _Ph (nth (atoi (substr LayNam 8 1)) Lst_Ph_S))
			(if (= (substr LayNam 4 1) "O")
				(setq _ou "OVERHEAD")
				(setq _ou "UNDERGROUND")
			)
			(if (= (substr LayNam 5 2) "CK")
				(setq _level (strcat (substr LayNam 9 2)
								 " kV PRIMARY"
						   )
				)
				(setq _level "SECONDARY")
			)
			(if Itm
				(setq Ls_GUY_DFLT (list Itm))
				(setq Ls_GUY_DFLT (list 0))
			)
			(new_dialog "GUY" dcl_sym)
			(set_tile "_Fdr" _Fdr)
			(set_tile "_Ph" _Ph)
			(set_tile "_ou" _ou)
			(set_tile "_level" _level)
			(start_list "lst1" 3)
			(mapcar (quote add_list) Ls_GUY_Name)
			(end_list)
			(set_tile "lst1" (itoa (nth 0 Ls_GUY_DFLT)))
			(action_tile "_Fdr" "(setq _Fdr $value)")
			(action_tile "_Ph" "(setq _Ph $value)")
			(action_tile "_ou" "(setq _ou $value)")
			(action_tile "_level" "(setq _level $value)")
			(action_tile "lst1" "(setq npos1 $value)")
			(setq dlg (start_dialog))
			(if (= dlg 1) ;then OK was pressed
				(progn
					(if npos1
						(setq npos1 (atoi npos1))
						(setq npos1 (nth 0 Ls_GUY_DFLT))
					)
					(if (> npos1 0)
						(progn
							(setq Ls_GUY_DFLT (list npos1))
							(if (= cb 1)
								(chgDEV (list (nth npos1 Ls_GUY_Name))
								)
								(DRWDEV (list (nth npos1 Ls_GUY_Name))
								)
							)
						)
						(alert
							"Warning: Function canceled because TYPE cannot be left blank."
						)
					)
				)
			)
		)
		(alert "ERROR: Ls_GUY_Name not defined!")
	)
	(unload_dialog dcl_sym)
	(princ)
)

(defun C:Land ( / )						; Land Draw
;****************************************************************************
;Function: C:LAND
;Purpose: inserts a miscellanous landbase symbol.
;Local: lst1 npos1 nval1 nval2
;Global: If Ls_LAND_DFLT does not exist it gets created.
;****************************************************************************
	(LandDrw nil)
	(princ)
)

(defun LandDrw ( Itm /	lst1 npos1 nval1 nval2	; Land Dialog Data
					dlg dcl_sym )
	(setq Mnum (cond ((= AppMode "E") 1)
				  ((= AppMode "I") 2)
				  ((= AppMode "C") 3)
				  ((= AppMode "R") 4)
				  (T 1)
			 )
	)
	(if Itm
		(if (not (and (> Itm 0) (<= Itm (1- (length Ls_LAND_Name)))))
			(setq Itm nil)
			(if (= (substr	(nth	(setq PosOut (LookLst Itm
											  Ls_LAND_Name
											  Lst_Sp_Dn
									   )
							)
							Lst_Sp_Ma
						)
						Mnum
						1
				  )
				  "0"
			    )
				(progn
					(DevModA PosOut)
					(exit)
				)
			)
		)
	)
	(setq dcl_sym (load_dialog "symbols.dcl"))
	(if Ls_LAND_Name
		(progn
			(if Itm
				(setq Ls_LAND_DFLT (list Itm "" ""))
				(setq Ls_LAND_DFLT (list 0 "" ""))
			)
			(new_dialog "LAND" dcl_sym)
			(start_list "lst1" 3)
			(mapcar (quote add_list) Ls_LAND_Name)
			(end_list)
			(set_tile "lst1" (itoa (nth 0 Ls_LAND_DFLT)))
			(set_tile "val1" (nth 1 Ls_LAND_DFLT))
			(set_tile "val2" (nth 2 Ls_LAND_DFLT))
			(action_tile "lst1" "(setq npos1 $value)")
			(action_tile "val1" "(setq nval1 $value)")
			(action_tile "val2" "(setq nval2 $value)")
			(setq dlg (start_dialog))
			(if (= dlg 1) ;then OK was pressed
				(progn
					(if npos1
						(setq npos1 (atoi npos1))
						(setq npos1 (nth 0 Ls_LAND_DFLT))
					)
					(if nval1
						(setq nval1 (strcase nval1))
						(setq nval1 (nth 1 Ls_LAND_DFLT))
					)
					(if nval2
						(setq nval2 (strcase nval2))
						(setq nval2 (nth 2 Ls_LAND_DFLT))
					)
					(if (> npos1 0)
						(progn
							(setq Ls_LAND_DFLT
									(list npos1
										 nval1
										 nval2
									)
							)
							(if (= cb 1)
								(chgDEV (list (nth npos1 Ls_LAND_Name)
									   	 nval1
									   	 nval2
								   		)
								)
								(DRWDEV (list (nth npos1 Ls_LAND_Name)
									    	nval1
									    	nval2
								   		)
								)
							)
						)
						(alert
							"Warning: Function canceled because DEVICE cannot be left blank."
						)
					)
				)
			)
		)
		(alert "ERROR: Ls_LAND_Name not defined!")
	)
	(unload_dialog dcl_sym)
	(princ)
)

(defun C:Light ( / )						; Light Draw
;****************************************************************************
;Function: C:LIGHT
;Purpose: inserts a light.
;Local: lst1 npos1 nval1 lst2 npos2
;Global: If Ls_LIGHT_DFLT does not exist it gets created.
;****************************************************************************
	(LightDrw nil)
	(princ)
)

(defun LightDrw ( Itm /	lst1 npos1 nval1 lst2	; Light Dialog Data
					npos2 LayNam _Fdr _Ph _ou _level dlg dcl_sym )
	(setq Mnum (cond ((= AppMode "E") 1)
				  ((= AppMode "I") 2)
				  ((= AppMode "C") 3)
				  ((= AppMode "R") 4)
				  (T 1)
			 )
	)
	(if Itm
		(if (not (and (> Itm 0) (<= Itm (1- (length Ls_LIGHT_Name))))
		    )
			(setq Itm nil)
			(if (= (substr	(nth	(setq PosOut (LookLst Itm
											  Ls_LIGHT_Name
											  Lst_Sp_Dn
									   )
							)
							Lst_Sp_Ma
						)
						Mnum
						1
				  )
				  "0"
			    )
				(progn
					(DevModA PosOut)
					(exit)
				)
			)
		)
	)
	(setq dcl_sym (load_dialog "symbols.dcl"))
	(setq DatLst (PicCkt))
	(if (and Ls_LIGHT_Name Ls_LIGHT_Desc)
		(progn
			(setq LayNam (nth 2 DatLst))
			(if (member (substr LayNam 1 3) Lst_Fd_V)
				(setq
					_Fdr	(nth	(- (length Lst_Fd_V)
							   (length
								   (member (substr LayNam 1 3)
										 Lst_Fd_V
								   )
							   )
							)
							Lst_Fd_S
						)
				)
				(setq _Fdr "")
			)
			(setq _Ph (nth (atoi (substr LayNam 8 1)) Lst_Ph_S))
			(if (= (substr LayNam 4 1) "O")
				(setq _ou "OVERHEAD")
				(setq _ou "UNDERGROUND")
			)
			(if (= (substr LayNam 5 2) "CK")
				(setq _level (strcat (substr LayNam 9 2)
								 " kV PRIMARY"
						   )
				)
				(setq _level "SECONDARY")
			)
			(if Itm
				(setq Ls_LIGHT_DFLT (list Itm "" 0))
				(setq Ls_LIGHT_DFLT (list 1 "" 0))
			)
			(new_dialog "LIGHT" dcl_sym)
			(set_tile "_Fdr" _Fdr)
			(set_tile "_Ph" _Ph)
			(set_tile "_ou" _ou)
			(set_tile "_level" _level)
			(start_list "lst1" 3)
			(mapcar (quote add_list) Ls_LIGHT_Name)
			(end_list)
			(set_tile "lst1" (itoa (nth 0 Ls_LIGHT_DFLT)))
			(set_tile "val1" (nth 1 Ls_LIGHT_DFLT))
			(start_list "lst2" 3)
			(mapcar (quote add_list) Ls_LIGHT_Desc)
			(end_list)
			(set_tile "lst2" (itoa (nth 2 Ls_LIGHT_DFLT)))
			(action_tile "_Fdr" "(setq _Fdr $value)")
			(action_tile "_Ph" "(setq _Ph $value)")
			(action_tile "_ou" "(setq _ou $value)")
			(action_tile "_level" "(setq _level $value)")
			(action_tile "lst1" "(setq npos1 $value)")
			(action_tile "val1" "(setq nval1 $value)")
			(action_tile "lst2" "(setq npos2 $value)")
			(setq dlg (start_dialog))
			(if (= dlg 1) ;then OK was pressed
				(progn
					(if npos1
						(setq npos1 (atoi npos1))
						(setq npos1 (nth 0 Ls_LIGHT_DFLT))
					)
					(if nval1
						(setq nval1 (strcase nval1))
						(setq nval1 (nth 1 Ls_LIGHT_DFLT))
					)
					(if npos2
						(setq npos2 (atoi npos2))
						(setq npos2 (nth 2 Ls_LIGHT_DFLT))
					)
					(if (> npos1 0)
						(progn
							(setq Ls_LIGHT_DFLT
									(list npos1
										 nval1
										 npos2
									)
							)
							(DRWDEV
								(list (nth npos1 Ls_LIGHT_Name)
									 nval1
									 (nth npos2 Ls_LIGHT_Desc)
								)
							)
						)
						(alert
							"Warning: Function canceled because DEVICE cannot be left blank."
						)
					)
				)
			)
		)
		(alert "ERROR: Ls_LIGHT_Name or Ls_LIGHT_Desc not defined!")
	)
	(unload_dialog dcl_sym)
	(princ)
)

(defun C:MkS ( / )
	(if Bug (princ "\n{C:MkS entered\n"))
	(setq	EntLayR	nil
			PosOne	nil
			TxtOne	nil
			TxtTwo	nil
			TblAtt	nil
			AttBNam	nil
			AttRPos	nil
			AttStyle	nil
			AttHgt	nil
			AttAng	nil
			AttVal	nil
			AttPt	nil
			Ient1	nil
			Ient2	nil
			Ient3	nil
			Ient4	nil
			ObjTwo	nil
	)
	(princ "\nSelect a block on the intended layer: ")
	(setq	EntLayR	(cdr (assoc 8 (entget (car (entsel)) (list "*")))))
	(if EntLayR
		(setq	Bubba	(princ (strcat "\nLayer [" EntLayR "] selected"))
				PosOne	(getpoint "\nPick your placement: ")
		)
	)
	(if PosOne
		(setq	Bubba	(princ "\nPick First Text item to be Loc_Num Attribute: ")
				TxtOne	(entget (car (entsel)) (list "*"))
		)
	)
	
	(if (= Div "AL")				;	CET 10/21/19 - Added Scale setting for GPC picking up SENT sysmbol
		(setq symScale  76.0)
		(setq symScale  20.0)
	)
		
	(if PosOne
		(setq	Ient1	(list	(cons 0 "INSERT")
								(cons 5 "6C67") 
								(cons 100 "AcDbEntity") 
								(cons 67 0)
								(cons 410 "Model") 
								(cons 8 EntLayR)
								(cons 62 2) 
								(cons 100 "AcDbBlockReference")
								(cons 66 1)
								(cons 2 "A899")
								(cons 10 PosOne)
								(cons 41 symScale)
								(cons 42 symScale)
								(cons 43 symScale)
								(cons 50 0.0)
								(cons 70 0)
								(cons 71 0)
								(cons 44 0.0)
								(cons 45 0.0)
								(cons 210 (list 0.0 0.0 1.0))
						)
		)
	)
	(if TxtOne
		(setq	Bubba	(princ "\nPick Second Text item to be Descript Attribute: ")
				Ient2	(list	(cons 0 "ATTRIB")
								(cons 5 "6C68") 
								(cons 100 "AcDbEntity")
								(cons 67 0)
								(cons 410 "Model") 
								(cons 8 EntLayR)
								(cons 100 "AcDbText")
								(assoc 10 TxtOne)
								(assoc 40 TxtOne)
								(assoc 1 TxtOne)
								(assoc 7 TxtOne)
								(assoc 11 TxtOne)
								(assoc 41 TxtOne)
								(assoc 50 TxtOne)
								(assoc 51 TxtOne)
								(assoc 210 TxtOne)
								(cons 100 "AcDbAttribute")
								(cons 280 0) 
								(cons 2 "LOC_NUM")
								(cons 70 0)
								(cons 71 0)
								(cons 72 4)
								(cons 73 0)
								(cons 74 0)
								(cons 280 0) 
						)
		)
	)
	(if TxtOne
		(setq	ObjTwo	(entsel))
	)
	(if ObjTwo
		(setq	TxtTwo	(entget (car ObjTwo) (list "*")))
	)
	(if TxtTwo
		(setq	Ient3	(list	(cons 0 "ATTRIB")
								(cons 5 "6C69")
								(cons 100 "AcDbEntity")
								(cons 67 0)
								(cons 410 "Model") 
								(cons 8 EntLayR)
								(cons 100 "AcDbText")
								(assoc 1 TxtTwo)
								(assoc 10 TxtTwo)
								(assoc 40 TxtTwo)
								(assoc 7 TxtTwo)
								(assoc 11 TxtTwo)
								(assoc 41 TxtTwo)
								(assoc 50 TxtTwo)
								(assoc 51 TxtTwo)
								(assoc 210 TxtTwo)
								(cons 100 "AcDbAttribute")
								(cons 280 0) 
								(cons 2 "DESCRIPT")
								(cons 70 0)
								(cons 71 0)
								(cons 72 4)
								(cons 73 0)
								(cons 74 0)
								(cons 280 0) 
						)
		)
		(setq	Ient3	(list	(cons 0 "ATTRIB")
								(cons 5 "6C69")
								(cons 100 "AcDbEntity")
								(cons 67 0)
								(cons 410 "Model") 
								(cons 8 EntLayR)
								(cons 100 "AcDbText")
								(cons 1 "")
								(assoc 10 TxtOne)
								(assoc 40 TxtOne)
								(assoc 7 TxtOne)
								(assoc 11 TxtOne)
								(assoc 41 TxtOne)
								(assoc 50 TxtOne)
								(assoc 51 TxtOne)
								(assoc 210 TxtOne)
								(cons 100 "AcDbAttribute")
								(cons 280 0) 
								(cons 2 "DESCRIPT")
								(cons 70 0)
								(cons 71 0)
								(cons 72 4)
								(cons 73 0)
								(cons 74 0)
								(cons 280 0) 
						)
		)
	)
	(setq	Ient4	(list	(cons 0 "SEQEND")
							(cons 5 "6C6A") 
							(cons 100 "AcDbEntity") 
							(cons 67 0)
							(cons 410 "Model") 
							(cons 8 EntLayR)
					)
	)
	(if (and Ient1 Ient2 Ient3 Ient4)
		(progn
			(entmake Ient1)
			(entmake Ient2)
			(entmake Ient3)
			(entmake Ient4)
		)
	)
	
	(setq	ssT		(ssadd))
	(if TxtOne
		(ssadd (cdr (assoc -1 TxtOne)) ssT)
	)
	(if TxtTwo
		(ssadd (cdr (assoc -1 TxtTwo)) ssT)
	)
	(command "_.Erase" ssT "")
	(princ)
	(if Bug (princ "\n{C:MkS exited}\n"))
)

(defun C:Misc ( / )						; Misc Draw
;****************************************************************************
;Function: C:MISC
;Purpose: inserts a miscellanous electrical symbol.
;Local: lst1 npos1 nval1 nval2
;Global: If Ls_MISC_DFLT does not exist it gets created.
;****************************************************************************
	(MiscDrw nil)
	(princ)
)

(defun MiscDrw ( Itm /	Mnum PosOut lst1 npos1	; Misc Dialog Data
					nval1 nval2 _Fdr LayNam _Ph _ou _level dcl_sym dlg )
	(setq Mnum (cond ((= AppMode "E") 1)
				  ((= AppMode "I") 2)
				  ((= AppMode "C") 3)
				  ((= AppMode "R") 4)
				  (T 1)
			 )
	)
	(if Itm
		(if (not (and (> Itm 0) (<= Itm (1- (length Ls_Misc_Name)))))
			(setq Itm nil)
			(if (= (substr	(nth	(setq PosOut (LookLst Itm
											  Ls_Misc_Name
											  Lst_Sp_Dn
									   )
							)
							Lst_Sp_Ma
						)
						Mnum
						1
				  )
				  "0"
			    )
				(progn
					(DevModA PosOut)
					(exit)
				)
			)
		)
	)
	(setq dcl_sym (load_dialog "symbols.dcl"))
	(setq DatLst (PicCkt))
	(if Ls_MISC_Name
		(progn
			(setq LayNam (nth 2 DatLst))
			(if (member (substr LayNam 1 3) Lst_Fd_V)
				(setq
					_Fdr	(nth	(- (length Lst_Fd_V)
							   (length
								   (member (substr LayNam 1 3)
										 Lst_Fd_V
								   )
							   )
							)
							Lst_Fd_S
						)
				)
				(setq _Fdr "")
			)
			(setq _Ph (nth (atoi (substr LayNam 8 1)) Lst_Ph_S))
			(if (= (substr LayNam 4 1) "O")
				(setq _ou "OVERHEAD")
				(setq _ou "UNDERGROUND")
			)
			(if (= (substr LayNam 5 2) "CK")
				(setq _level (strcat (substr LayNam 9 2)
								 " kV PRIMARY"
						   )
				)
				(setq _level "SECONDARY")
			)
			(if Itm
				(setq Ls_MISC_DFLT (list Itm "" ""))
				(setq Ls_MISC_DFLT (list 0 "" ""))
			)
			(if (or 	(= itm 3)
					(= itm 5)
					(= itm 6)
					(= itm 11)
					(= itm 17)
					(= itm 19)
					(= itm 23)
					(= itm 25)
					(= itm 27)
				)
				(setq attoff 1)
			)
			(new_dialog "MISC" dcl_sym)
			(set_tile "_Fdr" _Fdr)
			(set_tile "_Ph" _Ph)
			(set_tile "_ou" _ou)
			(set_tile "_level" _level)
			(start_list "lst1" 3)
			(mapcar (quote add_list) Ls_MISC_Name)
			(end_list)
			(set_tile "lst1" (itoa (nth 0 Ls_MISC_DFLT)))
			(if (= attoff 1)
				(progn
					(mode_tile "val1" 1)
					(mode_tile "val2" 1)
					(setq attoff 0)
		    		)
		   		(progn			
		  			(set_tile "val1" (nth 1 Ls_MISC_DFLT))
		 			(set_tile "val2" (nth 2 Ls_MISC_DFLT))
		 		)
		 	)
			(action_tile "_Fdr" "(setq _Fdr $value)")
			(action_tile "_Ph" "(setq _Ph $value)")
			(action_tile "_ou" "(setq _ou $value)")
			(action_tile "_level" "(setq _level $value)")
			(action_tile "lst1" "(setq npos1 $value)")
			(action_tile "val1" "(setq nval1 $value)")
			(action_tile "val2" "(setq nval2 $value)")
			(setq dlg (start_dialog))
			(if (= dlg 1) ;then OK was pressed
				(progn
					(if npos1
						(setq npos1 (atoi npos1))
						(setq npos1 (nth 0 Ls_MISC_DFLT))
					)
					(if nval1
						(setq nval1 (strcase nval1))
						(setq nval1 (nth 1 Ls_MISC_DFLT))
					)
					(if nval2
						(setq nval2 (strcase nval2))
						(setq nval2 (nth 2 Ls_MISC_DFLT))
					)
					(if (> npos1 0)
						(progn
							(setq Ls_MISC_DFLT
									(list npos1
										 nval1
										 nval2
									)
							)
							(if (= cb 1)
								(chgDEV (list (nth npos1 Ls_MISC_Name)
									   	 nval1
									    	 nval2
								   	)
								)
								(DRWDEV (list (nth npos1 Ls_MISC_Name)
									    	nval1
									    	nval2
								   		)
								)
							 )
						)
						(alert
							"Warning: Function canceled because DEVICE cannot be left blank."
						)
					)
				)
			)
		)
		(alert "ERROR: Ls_MISC_Name not defined!")
	)
	(unload_dialog dcl_sym)
	(princ)
)

(defun C:POLE ( / )						; Pole Draw
;****************************************************************************
;Function: C:POLE
;Purpose: inserts a pole.
;Local: lst1 npos1 lst2 npos2
;Global: If Ls_POLE_DFLT does not exist it gets created.
;****************************************************************************
	(PoleDrw nil)
	(princ)
)

(defun PoleDrw ( Itm /	lst1 npos1 lst2 npos2	; Pole Dialog Data
					LayNam _Fdr _Ph _ou _level dlg dcl_sym )
	(setq Mnum (cond ((= AppMode "E") 1)
				  ((= AppMode "I") 2)
				  ((= AppMode "C") 3)
				  ((= AppMode "R") 4)
				  (T 1)
			 )
	)
	(if Itm
		(if (not (and (> Itm 0) (<= Itm (1- (length Ls_POLE_Name)))))
			(setq Itm nil)
			(if (= (substr	(nth	(setq PosOut (LookLst Itm
											  Ls_POLE_Name
											  Lst_Sp_Dn
									   )
							)
							Lst_Sp_Ma
						)
						Mnum
						1
				  )
				  "0"
			    )
				(progn
					(DevModA PosOut)
					(exit)
				)
			)
		)
	)
	(setq dcl_sym (load_dialog "symbols.dcl"))
	(setq DatLst (PicCkt))
	(if (and Ls_POLE_Name Ls_POLE_Desc Ls_POLE_CLASS)
		(progn
			(setq LayNam (nth 2 DatLst))
			(if (member (substr LayNam 1 3) Lst_Fd_V)
				(setq
					_Fdr	(nth	(- (length Lst_Fd_V)
							   (length
								   (member (substr LayNam 1 3)
										 Lst_Fd_V
								   )
							   )
							)
							Lst_Fd_S
						)
				)
				(setq _Fdr "")
			)
			(setq _Ph (nth (atoi (substr LayNam 8 1)) Lst_Ph_S))
			(if (= (substr LayNam 4 1) "O")
				(setq _ou "OVERHEAD")
				(setq _ou "UNDERGROUND")
			)
			(if (= (substr LayNam 5 2) "CK")
				(setq _level (strcat (substr LayNam 9 2)
								 " kV PRIMARY"
						   )
				)
				(setq _level "SECONDARY")
			)
			(if Itm
				(setq Ls_POLE_DFLT (list Itm 0 0))
				(setq Ls_POLE_DFLT (list 0 0 0))
			)
			(new_dialog "POLE" dcl_sym)
			(set_tile "_Fdr" _Fdr)
			(set_tile "_Ph" _Ph)
			(set_tile "_ou" _ou)
			(set_tile "_level" _level)
			(start_list "lst1" 3)							;lst1 ~ Type of Pole
			(mapcar (quote add_list) Ls_POLE_Name)
			(end_list)
			(set_tile "lst1" (itoa (nth 0 Ls_POLE_DFLT)))
			(start_list "lst2" 3)							;lst2 ~ Height
			(mapcar (quote add_list) Ls_POLE_Desc)
			(end_list)
			(set_tile "lst2" (itoa (nth 1 Ls_POLE_DFLT)))
			(start_list "lst3" 3)							;lst3 ~ Class
			(mapcar (quote add_list) Ls_POLE_CLASS)
			(end_list)
			(set_tile "lst3" (itoa (nth 2 Ls_POLE_DFLT)))
			(cb_PolDrw)
			(action_tile "_Fdr" "(setq _Fdr $value)")
			(action_tile "_Ph" "(setq _Ph $value)")
			(action_tile "_ou" "(setq _ou $value)")
			(action_tile "_level" "(setq _level $value)")
			(action_tile "lst1" "(cb_PolDrw)")
			(action_tile "lst2" "(setq npos2 $value)")
			(action_tile "lst3" "(setq npos3 $value)")
			(setq dlg (start_dialog))
			(if (= dlg 1) ;then OK was pressed
				(progn
					(if npos1
						(setq npos1 (atoi npos1))
						(setq npos1 (nth 0 Ls_POLE_DFLT))
					)
					(if npos2
						(setq npos2 (atoi npos2))
						(setq npos2 (nth 1 Ls_POLE_DFLT))
					)
					(if npos3
						(setq npos3 (atoi npos3))
						(setq npos3 (nth 2 Ls_POLE_DFLT))
					)
					(if (> npos1 0)
						(progn
							(setq Ls_POLE_DFLT
									(list npos1
										 npos2
										 npos3
									)
							)
							(if (= cb 1)
								(chgDEV (list (nth npos1
										   		Ls_POLE_Name
									   		 )
									    		(nth npos2
										   		 Ls_POLE_Desc
									    		)
									   		 "/"
									    		(nth npos3
										    		Ls_POLE_CLASS
									    		)
								  		 )
								)
								(DRWDEV (list (nth npos1
										    		Ls_POLE_Name
									    		)
									    		(nth npos2
										   		 Ls_POLE_Desc
									    		)
									    		"/"
									    		(nth npos3
										    		Ls_POLE_CLASS
									    		)
								  		 )
								)
							)
				  		)
						(alert
							"Warning: Function canceled because TYPE cannot be left blank."
						)
					)
				)
			)
		)
		(alert "ERROR: Ls_POLE_Name or Ls_POLE_Desc not defined!")
	)
	(setq npos3 nil)
	(unload_dialog dcl_sym)
	(princ)
)

(defun C:RECL ( / )						; Recloser Draw
;****************************************************************************
;Function: C:RECL
;Purpose: inserts a reclosers.
;Local: lst1 npos1 nval1 lst2 npos2 nval2 nval3 nval4
;Global: If Ls_RECLOSER_DFLT does not exist it gets created.
;****************************************************************************
	(ReclDrw nil)
	(princ)
)

(defun ReclDrw ( Itm /	lst1 npos1 nval1 lst2	; Recloser Dialog Data
					npos2 nval2 nval3 nval4 ival2 nval3 ival4 LayNam _Fdr _ou _Ph _level dcl_sym dlg )
	(setq Mnum (cond ((= AppMode "E") 1)
				  ((= AppMode "I") 2)
				  ((= AppMode "C") 3)
				  ((= AppMode "R") 4)
				  (T 1)
			 )
	)
	(if Itm
		(if (not (and (> Itm 0)
				    (<= Itm (1- (length Ls_RECLOSER_Name)))
			    )
		    )
			(setq Itm nil)
			(if (= (substr	(nth	(setq PosOut
									(LookLst Itm
										    Ls_RECLOSER_Name
										    Lst_Sp_Dn
									)
							)
							Lst_Sp_Ma
						)
						Mnum
						1
				  )
				  "0"
			    )
				(progn
					(DevModA PosOut)
					(exit)
				)
			)
		)
	)
	(setq dcl_sym (load_dialog "symbols.dcl"))
	(setq DatLst (PicCkt))
	(if (and Ls_RECLOSER_Name Ls_RECLOSER_Desc)
		(progn
			(setq LayNam (nth 2 DatLst))
			(if (member (substr LayNam 1 3) Lst_Fd_V)
				(setq	_Fdr		(nth	(- (length Lst_Fd_V) (length (member (substr LayNam 1 3) Lst_Fd_V)))	Lst_Fd_S))
				(setq	_Fdr		"")
			)
			(setq _Ph (nth (atoi (substr LayNam 8 1)) Lst_Ph_S))
			(if (= (substr LayNam 4 1) "O")
				(setq _ou "OVERHEAD")
				(setq _ou "UNDERGROUND")
			)
			(if (= (substr LayNam 5 2) "CK")
				(setq	_level	(strcat (substr LayNam 9 2) " kV PRIMARY"))
				(setq	_level	"SECONDARY")
			)
			(if Itm
				(setq	Ls_RECLOSER_DFLT	(list Itm "" 0 "" "S" "" "B" "" "L"))
				(setq	Ls_RECLOSER_DFLT	(list 0 "" 0 "" "S" "" "B" "" "L"))
			)
			(new_dialog "RECLOSER" dcl_sym)
			(set_tile "_Fdr" _Fdr)
			(set_tile "_Ph" _Ph)
			(set_tile "_ou" _ou)
			(set_tile "_level" _level)
			(start_list "lst1" 3)
				(mapcar (quote add_list) Ls_RECLOSER_Name)
			(end_list)
			(set_tile "lst1" (itoa (nth 0 Ls_RECLOSER_DFLT)))
			(set_tile "val1" (nth 1 Ls_RECLOSER_DFLT))
			(start_list "lst2" 3)
				(mapcar (quote add_list) Ls_RECLOSER_Desc)
			(end_list)
			(set_tile "lst2" (itoa (nth 2 Ls_RECLOSER_DFLT)))
			(set_tile "val2" (nth 3 Ls_RECLOSER_DFLT))
			(set_tile "val3" (nth 5 Ls_RECLOSER_DFLT))
			(set_tile "val4" (nth 7 Ls_RECLOSER_DFLT))
			(action_tile "_Fdr" "(setq _Fdr $value)")
			(action_tile "_Ph" "(setq _Ph $value)")
			(action_tile "_ou" "(setq _ou $value)")
			(action_tile "_level" "(setq _level $value)")
			(action_tile "lst1" "(setq npos1 $value)")
			(action_tile "val1" "(setq nval1 $value)")
			(action_tile "lst2" "(setq npos2 $value)")
			(action_tile "val2" "(setq nval2 $value)")
	   		(action_tile "val3" "(setq nval3 $value)")
			(action_tile "val4" "(setq nval4 $value)")
			(setq dlg (start_dialog))
			(if (= dlg 1) ;then OK was pressed
				(progn
					(if npos1	;;;	Bank Type:
						(setq	npos1	(atoi npos1))
						(setq	npos1	(nth 0 Ls_RECLOSER_DFLT))
					)
					(if nval1	;;;	Location #:
						(setq	nval1	(strcase nval1))
						(setq	nval1	(nth 1 Ls_RECLOSER_DFLT))
					)
					(if npos2	;;;	Recloser Size
						(setq	npos2	(atoi npos2))
						(setq	npos2	(nth 2 Ls_RECLOSER_DFLT))
					)
					(if nval2	;;;	Source:
						(setq	nval2	(strcase nval2)
								ival2	"S"
						)
						(setq	nval2	(nth 3 Ls_RECLOSER_DFLT)
								ival2	""
						)
					)
					(if nval3	;;; 	Bypass:
						(setq	nval3	(strcase nval3)
								ival3	"B"
						)
						(setq	nval3	(nth 5 Ls_RECLOSER_DFLT)
								ival3	""
						)
					)
					(if nval4	;;;	Load:
						(setq	nval4	(strcase nval4)
								ival4	"L"
						)
						(setq	nval4	(nth 7 Ls_RECLOSER_DFLT)
								ival4	""
						)
					)
					(if (> npos1 0)
						(progn
							(setq	Ls_RECLOSER_DFLT
									(list	npos1	nval1	npos2
											nval2	ival2
											nval3	ival3
											nval4	ival4
									)
							)
							(DRWDEV	(list	(nth npos1 Ls_RECLOSER_Name) 		;;; Bank Type:
											nval1 (nth npos2 Ls_RECLOSER_Desc)	;;; Location #:, Recloser Size
											nval2 ival2					;;; Source:, 
											nval3 ival3					;;; Bypass:
											nval4 ival4					;;; Load:
									)
							)
						)
						(alert
							"Warning: Function canceled because RECLOSER TYPE cannot be left blank."
						)
					)
				)
			)
		)
		(alert
			"ERROR: Ls_RECLOSER_Name or Ls_RECLOSER_Desc not defined!"
		)
	)
	(unload_dialog dcl_sym)
	(princ)
)

(defun C:REG ( / )							; Regulator Draw
;****************************************************************************
;Function: C:REG
;Purpose: inserts a regulator or autobooster.
;Local: lst1 npos1 nval1 lst2 npos2
;Global: If Ls_REGLATOR_DFLT does not exist it gets created.
;****************************************************************************
	(RegDrw nil)
	(princ)
)

(defun RegDrw ( Itm /	lst1 npos1 nval1 lst2	; Regulator Dialog Data
					npos2 LayNam dcl_sym dlg _Fdr _Ph _ou _level )
	(setq Mnum (cond ((= AppMode "E") 1)
				  ((= AppMode "I") 2)
				  ((= AppMode "C") 3)
				  ((= AppMode "R") 4)
				  (T 1)
			 )
	)
	(if Itm
		(if (not (and (> Itm 0)
				    (<= Itm (1- (length Ls_REGLATOR_Name)))
			    )
		    )
			(setq Itm nil)
			(if (= (substr	(nth	(setq PosOut
									(LookLst Itm
										    Ls_REGLATOR_Name
										    Lst_Sp_Dn
									)
							)
							Lst_Sp_Ma
						)
						Mnum
						1
				  )
				  "0"
			    )
				(progn
					(DevModA PosOut)
					(exit)
				)
			)
		)
	)
	(setq dcl_sym (load_dialog "symbols.dcl"))
	(setq DatLst (PicCkt))
	(if (and Ls_REGLATOR_Name Ls_REGLATOR_Desc)
		(progn
			(setq LayNam (nth 2 DatLst))
			(if (member (substr LayNam 1 3) Lst_Fd_V)
				(setq
					_Fdr	(nth	(- (length Lst_Fd_V)
							   (length
								   (member (substr LayNam 1 3)
										 Lst_Fd_V
								   )
							   )
							)
							Lst_Fd_S
						)
				)
				(setq _Fdr "")
			)
			(setq _Ph (nth (atoi (substr LayNam 8 1)) Lst_Ph_S))
			(if (= (substr LayNam 4 1) "O")
				(setq _ou "OVERHEAD")
				(setq _ou "UNDERGROUND")
			)
			(if (= (substr LayNam 5 2) "CK")
				(setq _level (strcat (substr LayNam 9 2)
								 " kV PRIMARY"
						   )
				)
				(setq _level "SECONDARY")
			)
			(if Itm
				(setq Ls_REGLATOR_DFLT (list Itm "" 0))
				(setq Ls_REGLATOR_DFLT (list 0 "" 0))
			)
			(new_dialog "REGLATOR" dcl_sym)
			(set_tile "_Fdr" _Fdr)
			(set_tile "_Ph" _Ph)
			(set_tile "_ou" _ou)
			(set_tile "_level" _level)
			(start_list "lst1" 3)
			(mapcar (quote add_list) Ls_REGLATOR_Name)
			(end_list)
			(set_tile "lst1" (itoa (nth 0 Ls_REGLATOR_DFLT)))
			(set_tile "val1" (nth 1 Ls_REGLATOR_DFLT))
			(start_list "lst2" 3)
			(mapcar (quote add_list) Ls_REGLATOR_Desc)
			(end_list)
			(set_tile "lst2" (itoa (nth 2 Ls_REGLATOR_DFLT)))
			(action_tile "_Fdr" "(setq _Fdr $value)")
			(action_tile "_Ph" "(setq _Ph $value)")
			(action_tile "_ou" "(setq _ou $value)")
			(action_tile "_level" "(setq _level $value)")
			(action_tile "lst1" "(setq npos1 $value)")
			(action_tile "val1" "(setq nval1 $value)")
			(action_tile "lst2" "(setq npos2 $value)")
			(setq dlg (start_dialog))
			(if (= dlg 1) ;then OK was pressed
				(progn
					(if npos1
						(setq npos1 (atoi npos1))
						(setq npos1 (nth 0 Ls_REGLATOR_DFLT))
					)
					(if nval1
						(setq nval1 (strcase nval1))
						(setq nval1 (nth 1 Ls_REGLATOR_DFLT))
					)
					(if npos2
						(setq npos2 (atoi npos2))
						(setq npos2 (nth 2 Ls_REGLATOR_DFLT))
					)
					(if (> npos1 0)
						(progn
							(setq Ls_REGLATOR_DFLT
									(list npos1
										 nval1
										 npos2
									)
							)
							(DRWDEV (list (nth npos1
										    Ls_REGLATOR_Name
									    )
									    nval1
									    (nth npos2
										    Ls_REGLATOR_Desc
									    )
								   )
							)
						)
						(alert
							"Warning: Function canceled because DEVICE cannot be left blank."
						)
					)
				)
			)
		)
		(alert
			"ERROR: Ls_REGLATOR_Name or Ls_REGLATOR_Desc not defined!"
		)
	)
	(unload_dialog dcl_sym)
	(princ)
)

(defun C:SW ( / )							; Switch Draw
;****************************************************************************
;Function: C:SW
;Purpose: inserts a switch.
;Local: lst1 npos1 nval1 lst2 npos2
;Global: If Ls_SWITCH_DFLT does not exist it gets created.
;****************************************************************************
	(SwDrw nil)
	(princ)
)

(defun SwDrw ( Itm /	lst1 npos1 nval1 lst2	; Switch Dialog Data
					npos2 LayNam dcl_sym dlg _Fdr _Ph _ou _level )
	(setq Mnum (cond ((= AppMode "E") 1)
				  ((= AppMode "I") 2)
				  ((= AppMode "C") 3)
				  ((= AppMode "R") 4)
				  (T 1)
			 )
	)
	(if Itm
		(if (not (and (> Itm 0)
				    (<= Itm (1- (length Ls_SWITCH_Name)))
			    )
		    )
			(setq Itm nil)
			(if (= (substr	(nth	(setq
								PosOut (LookLst Itm
											 Ls_SWITCH_Name
											 Lst_Sp_Dn
									  )
							)
							Lst_Sp_Ma
						)
						Mnum
						1
				  )
				  "0"
			    )
				(progn
					(DevModA PosOut)
					(exit)
				)
			)
		)
	)
	(setq dcl_sym (load_dialog "symbols.dcl"))
	(setq DatLst (PicCkt))
	(if (and Ls_SWITCH_Name Ls_SWITCH_Desc)			;Both list created by Tables.Lsp!Tables run at Cadet startup
		(progn
			(setq LayNam (nth 2 DatLst))
			(if (member (substr LayNam 1 3) Lst_Fd_V)
				(setq
					_Fdr	(nth	(- (length Lst_Fd_V)
							   (length
								   (member (substr LayNam 1 3)
										 Lst_Fd_V
								   )
							   )
							)
							Lst_Fd_S
						)
				)
				(setq _Fdr "")
			)
			(setq _Ph (nth (atoi (substr LayNam 8 1)) Lst_Ph_S))
			(if (= (substr LayNam 4 1) "O")
				(setq _ou "OVERHEAD")
				(setq _ou "UNDERGROUND")
			)
			(if (= (substr LayNam 5 2) "CK")
				(setq _level (strcat (substr LayNam 9 2)
								 " kV PRIMARY"
						   )
				)
				(setq _level "SECONDARY")
			)
			(if Itm
				(setq Ls_SWITCH_DFLT (list Itm "" 0))
				(setq Ls_SWITCH_DFLT (list 0 "" 0))
			)
			;(if (= cb 1)
				;(new_dialog "CHSWITCH" dcl_sym)
				(new_dialog "SWITCH" dcl_sym)
			;)
			(set_tile "_Fdr" _Fdr)
			(set_tile "_Ph" _Ph)
			(set_tile "_ou" _ou)
			(set_tile "_level" _level)
			(start_list "lst1" 3)
			(mapcar (quote add_list) Ls_SWITCH_Name)
			(end_list)
			(set_tile "lst1" (itoa (nth 0 Ls_SWITCH_DFLT)))
			(set_tile "val1" (nth 1 Ls_SWITCH_DFLT))
			(start_list "lst2" 3)
			(mapcar (quote add_list) Ls_SWITCH_Desc)
			(end_list)
			(set_tile "lst2" (itoa (nth 2 Ls_SWITCH_DFLT)))
			(action_tile "_Fdr" "(setq _Fdr $value)")
			(action_tile "_Ph" "(setq _Ph $value)")
			(action_tile "_ou" "(setq _ou $value)")
			(action_tile "_level" "(setq _level $value)")
			(action_tile "lst1" "(setq npos1 $value)")
			(action_tile "val1" "(setq nval1 $value)")
			(action_tile "lst2" "(setq npos2 $value)")
			(setq dlg (start_dialog))
			(if (= dlg 1) ;then OK was pressed
				(progn
					(if npos1
						(setq npos1 (atoi npos1))
						(setq npos1 (nth 0 Ls_SWITCH_DFLT))
					)
					(if nval1
						(setq nval1 (strcase nval1))
						(setq nval1 (nth 1 Ls_SWITCH_DFLT))
					)
					(if npos2
						(setq npos2 (atoi npos2))
						(setq npos2 (nth 2 Ls_SWITCH_DFLT))
					)
					(if (> npos1 0)
						(progn
							(setq Ls_SWITCH_DFLT
									(list npos1 nval1 npos2)
							)
							(if (= cb 1)
								(chgDEV
									(list (nth npos1 Ls_SWITCH_Name) nval1 (nth npos2 Ls_SWITCH_Desc))
								)
								(DRWDEV
									(list (nth npos1 Ls_SWITCH_Name) nval1 (nth npos2 Ls_SWITCH_Desc))
								)
							)
						)
						(alert "Warning: Function canceled because DEVICE cannot be left blank.")
					)
				)
			)
		)
		(alert
			"ERROR: Ls_SWITCH_Name or Ls_SWITCH_Desc not defined!"
		)
	)
	(unload_dialog dcl_sym)
	(princ)
)

(defun cb_TranBankType ( pos / )
	(setq npos1 pos)
	(if (member (nth (atoi pos) Ls_TRANSFRM_Name) 
			(list "Step Up/Down Pad Xfmr" "3 Phase Wye  UG" "Single Phase UG" "3 Phase Closed Delta UG" "3 Phase Open Delta UG")
		)
		(progn
			(mode_tile "lst2" 1)
			(mode_tile "lst4" 1)
		)
		(progn
			(mode_tile "lst2" 0)
			(mode_tile "lst4" 0)
		)
	)
)

(defun C:TRAN ( / )						; Transformer
;****************************************************************************
;Function: C:TRAN
;Purpose: inserts a transformers.
;Local: lst1 npos1 nval1 lst2 npos2 lst3 npos3 lst4 npos4
;Global: If Ls_TRANSFRM_DFLT does not exist it gets created.
;****************************************************************************
	(TranDrw nil)
	(princ)
)

(defun TranDrw ( Itm /	lst1 npos1 nval1 lst2	; Trans Dialog Data
					npos2 lst3 npos3 lst4 npos4 LayNam dcl_sym dlg _Fdr _Ph _ou _level )
	(setq Mnum (cond ((= AppMode "E") 1)
				  ((= AppMode "I") 2)
				  ((= AppMode "C") 3)
				  ((= AppMode "R") 4)
				  (T 1)
			 )
	)
	(if Itm
		(if (not (and (> Itm 0)
				    (<= Itm (1- (length Ls_TRANSFRM_Name)))
			    )
		    )
			(setq Itm nil)
			(if (= (substr	(nth	(setq PosOut
									(LookLst Itm
										    Ls_TRANSFRM_Name
										    Lst_Sp_Dn
									)
							)
							Lst_Sp_Ma
						)
						Mnum
						1
				  )
				  "0"
			    )
				(progn
					(DevModA PosOut)
					(exit)
				)
			)
		)
	)
	(setq dcl_sym (load_dialog "symbols.dcl"))
	(setq DatLst (PicCkt))
	(if (and Ls_TRANSFRM_Name Ls_TRANSFRM_Desc)
		(progn
			(setq LayNam (nth 2 DatLst))
			(if (member (substr LayNam 1 3) Lst_Fd_V)
				(setq
					_Fdr	(nth	(- (length Lst_Fd_V)
							   (length
								   (member (substr LayNam 1 3)
										 Lst_Fd_V
								   )
							   )
							)
							Lst_Fd_S
						)
				)
				(setq _Fdr "")
			)
			(setq _Ph (nth (atoi (substr LayNam 8 1)) Lst_Ph_S))
			(if (= (substr LayNam 4 1) "O")
				(setq _ou "OVERHEAD")
				(setq _ou "UNDERGROUND")
			)
			(if (= (substr LayNam 5 2) "CK")
				(setq _level (strcat (substr LayNam 9 2)
								 " kV PRIMARY"
						   )
				)
				(setq _level "SECONDARY")
			)
			(if Itm
				(setq Ls_TRANSFRM_DFLT (list Itm "" 0 0 0))
				(setq Ls_TRANSFRM_DFLT (list 0 "" 0 0 0))
			)
			(new_dialog "TRANSFRM" dcl_sym)
			(set_tile "_Fdr" _Fdr)
			(set_tile "_Ph" _Ph)
			(set_tile "_ou" _ou)
			(set_tile "_level" _level)
			(start_list "lst1" 3)
			(mapcar (quote add_list) Ls_TRANSFRM_Name)
			(end_list)
			(set_tile "lst1" (itoa (nth 0 Ls_TRANSFRM_DFLT)))
			(set_tile "val1" (nth 1 Ls_TRANSFRM_DFLT))
			(start_list "lst2" 3)
			(mapcar (quote add_list) Ls_TRANSFRM_Desc)
			(end_list)
			(set_tile "lst2" (itoa (nth 2 Ls_TRANSFRM_DFLT)))
			(start_list "lst3" 3)
			(mapcar (quote add_list) Ls_TRANSFRM_Desc)
			(end_list)
			(set_tile "lst3" (itoa (nth 3 Ls_TRANSFRM_DFLT)))
			(start_list "lst4" 3)
			(mapcar (quote add_list) Ls_TRANSFRM_Desc)
			(end_list)
			(set_tile "lst4" (itoa (nth 4 Ls_TRANSFRM_DFLT)))
			
			(action_tile "_Fdr" "(setq _Fdr $value)")
			(action_tile "_Ph" "(setq _Ph $value)")
			(action_tile "_ou" "(setq _ou $value)")
			(action_tile "_level" "(setq _level $value)")
			(action_tile "lst1" "(cb_TranBankType $value)")
			(action_tile "val1" "(setq nval1 $value)")
			(action_tile "lst2" "(setq npos2 $value)")
			(action_tile "lst3" "(setq npos3 $value)")
			(action_tile "lst4" "(setq npos4 $value)")
							
			(setq dlg (start_dialog))
			(if (= dlg 1) ;then OK was pressed
				(progn
					(if npos1
						(setq npos1 (atoi npos1))
						(setq npos1 (nth 0 Ls_TRANSFRM_DFLT))
					)
					(if nval1
						(setq nval1 (strcase nval1))
						(setq nval1 (nth 1 Ls_TRANSFRM_DFLT))
					)
					(if npos2
						(setq npos2 (atoi npos2))
						(setq npos2 (nth 2 Ls_TRANSFRM_DFLT))
					)
					(if npos3
						(setq npos3 (atoi npos3))
						(setq npos3 (nth 3 Ls_TRANSFRM_DFLT))
					)
					(if npos4
						(setq npos4 (atoi npos4))
						(setq npos4 (nth 4 Ls_TRANSFRM_DFLT))
					)
					(if (> npos1 0)
						(progn
							(setq Ls_TRANSFRM_DFLT
									(list npos1
										 nval1
										 npos2
										 npos3
										 npos4
									)
							)
							(if (= cb 1)
								(chgDEV (list (nth npos1
										   		 Ls_TRANSFRM_Name
									   		 )
									   		 nval1
									    		(nth npos2
										    		 Ls_TRANSFRM_Desc
									    		)
									    		(nth npos3
										   		 Ls_TRANSFRM_Desc
									    		)
									    		(nth npos4
										    		 Ls_TRANSFRM_Desc
									    		)
								   		)
								)
								(DRWDEV (list (nth npos1
										    		Ls_TRANSFRM_Name
									    		)
									    		nval1
									    		(nth npos2
										    		Ls_TRANSFRM_Desc
									    		)
									    		(nth npos3
										    		Ls_TRANSFRM_Desc
									    		)
									    		(nth npos4
										    		Ls_TRANSFRM_Desc
									    		)
								   		)
								)
							)
						)
						(alert
							"Warning: Function canceled because BANK TYPE cannot be left blank."
						)
					)
				)
			)
			
		)
		(alert
			"ERROR: Ls_TRANSFRM_Name or Ls_TRANSFRM_Desc not defined!"
		)
	)
	(unload_dialog dcl_sym)
	(princ)
)

(defun PicCkt ( /	TMP Ent Ppt1 LayNam WirSiz	; Pick Circuit returns various data
				Vpt1 Vpt2 Ept1 Ept2 Ang )
	(if Bug (princ "\nSymbols.Lsp!PicCkt - Entered No parameters\n"))
	(setq	ENT	nil
			vpt1	nil
			vpt2	nil
	)
	(while (not ENT)
		(if (setq ENT (entsel "\nPick circuit for association:"))
			(if (and (or (= (cdr (assoc 0 (entget (car ENT)))) "LWPOLYLINE")
					   (= (cdr (assoc 0 (entget (car ENT)))) "POLYLINE")
				    )
				    (member
					    (strcase(substr (cdr (assoc 8 (entget (car ENT)))) 5 2))
					    (list "CK" "SC" "ME" "XF" "IC")		; SC was PA
				    )
			    )
				(setq Ppt1   (osnap (cadr ENT) "nea")
					 LayNam (cdr (assoc 8 (entget (car ENT))))
					 EDat   (GetDat (car ent))
					 WirSiz (nth 4 EDat)
				)
				(setq ENT nil)
			)
		)
	)
	(setq	Hobart	(GetPLDat Ent))
	(if Hobart
		(setq	Vpt1	(nth 2 Hobart)
				Vpt2	(nth 3 Hobart)
				Ept1	Vpt1
				Ept2	Vpt2
				Ang	(rtd (angle Vpt1 Vpt2))
		)
	)
	(if (and (> Ang 90) (< Ang 270))
		(setq Ang (- Ang 180))
	)
	(if Bug 
		(progn
			(princ "\nSymbols.Lsp!PicCkt - Done returns: \n")
			(prin1 (list Ent Ppt1 LayNam WirSiz Vpt1 Vpt2 Ept1 Ept2 Ang EDat))
		)
	)
	(list Ent Ppt1 LayNam WirSiz Vpt1 Vpt2 Ept1 Ept2 Ang EDat)
)

(defun GetDat ( e1 /	e2 LayNam fd ou ph		; Passed entsel, returns formatted data
					phw kv e3 wd1 wd2 wd3 wd4 ws Bubba )
	(setq e2 (entget e1 (list "*")))
	(if e2
		(if (> (strlen (setq LayNam (cdr (assoc 8 e2)))) 9)
			(setq fd	(substr LayNam 1 3)
				 ou	(substr LayNam 4 1)
				 ph	(substr LayNam 8 1)
				 phw	(cond ((= ph "0") "3")
						 ((= ph "1") "2")
						 ((= ph "2") "2")
						 ((= ph "3") "2")
						 (T "1")
					)
				 kv	(substr LayNam 9 2)
			)
		)
	)
	(if e2
		(if (assoc -3 e2)
			(progn
				(setq e3 (cdadr (assoc -3 e2)))
				(if e3
					(if (= (length e3) 4)
						(setq wd1	  (cdr (nth 0 e3))
							 wd2	  (cdr (nth 1 e3))
							 wd3	  (cdr (nth 2 e3))
							 wd4	  (cdr (nth 3 e3))
							 ws	  (strcat	phw	 "-"	  wd1
										wd2	 "&1-" wd3
										wd4
									    )
							 Bubba (if Bug
									  (princ (strcat "\n" ws "$")
									  )
								  )
						)
						(if (= (length e3) 2)
							(setq wd1	(cdr (nth 0 e3))
								 wd2	(cdr (nth 1 e3))
								 wd3	nil
								 wd4	nil
								 ws	(strcat phw "-" wd1 wd2)
							)
							(setq wd1	nil
								 wd2	nil
								 wd3	nil
								 wd4	nil
								 ws	nil
							)
						)
					)
					(setq wd1	nil
						 wd2	nil
						 wd3	nil
						 wd4	nil
						 ws	nil
					)
				)
			)
		)
	)
	(if e2
		(list fd ou ph kv ws wd1 wd2 wd3 wd4)
		(list nil nil nil nil nil nil nil nil nil)
	)
)

(defun GetLWVert ( Ent Npt1 /	Cnt e2 Ept1	; LWPolyline vertice with intercept returned
							Ept2 Vpt1 Vpt2 Ppt1 A1 D1 Xpt1 Tpt1 )
	(setq	e2	(entget (car Ent) (list "*"))
			Ppt1	(cadr Ent)
			A1	(angle Ppt1 Npt1)
			D1	(distance Ppt1 Npt1)
			Xpt1	(polar Ppt1 A1 (* D1 2.0))
			Cnt	0
			Tpt1	nil
	)
	(repeat (length e2)
		(if (= (car (nth Cnt e2)) 10)
			(progn
				(if (null Ept1)
					(setq	Ept1	(cdr (nth Cnt e2)))
					(setq	Tpt1	Ept2)
				)
				(setq Ept2 (cdr (nth Cnt e2)))
				(if Tpt1
					(if (inters Ppt1 Xpt1 Tpt1 Ept2)
						(setq	Vpt1	Tpt1
								Vpt2	Ept2
						)
					)
				)
			)
		)
		(setq Cnt (1+ Cnt))
	)
	(list Vpt1 Vpt2 Ept1 Ept2)
)

(defun PicPole ( / Ent Ppt1 LayNam )			; Pick Pole returns various data
	(setq ENT nil)
	(while (not ENT)
		(if (setq ENT (entsel "\n Pick a pole:"))
			(if (member (cdr (assoc 2 (entget (car ENT))))
					  (list "138"	  "139"	 "338"	"339"
						   "538"	  "539"	 "738"	"739"
						   "157" "168" "357" "368")
			    )
				(setq Ppt1   (cdr (assoc 10 (entget (car ENT))))
					 LayNam (cdr (assoc 8 (entget (car ENT))))
				)
				(setq ENT nil)
			)
		)
	)
	(list Ent Ppt1 LayNam)
)

(defun DevModA ( PosOut / GMode GCnt GMods )	; Device Mode Availability tester
	(setq GMode ""
		 GCnt 0
	)
	(if (= (substr (nth PosOut Lst_Sp_Ma) 1 1) "1")
		(setq GMode (strcat GMode "E")
			 GCnt  (1+ GCnt)
		)
	)
	(if (= (substr (nth PosOut Lst_Sp_Ma) 2 1) "1")
		(if (> GCnt 0)
			(setq GMode (strcat GMode ",I")
				 GCnt  (1+ GCnt)
			)
			(setq GMode (strcat GMode "I")
				 GCnt  (1+ GCnt)
			)
		)
	)
	(if (= (substr (nth PosOut Lst_Sp_Ma) 3 1) "1")
		(if (> GCnt 0)
			(setq GMode (strcat GMode ",C")
				 GCnt  (1+ GCnt)
			)
			(setq GMode (strcat GMode "C")
				 GCnt  (1+ GCnt)
			)
		)
	)
	(if (= (substr (nth PosOut Lst_Sp_Ma) 4 1) "1")
		(if (> GCnt 0)
			(setq GMode (strcat GMode ",R")
				 GCnt  (1+ GCnt)
			)
			(setq GMode (strcat GMode "R")
				 GCnt  (1+ GCnt)
			)
		)
	)
	(if (> GCnt 1)
		(setq GMods "modes: ")
		(setq GMods "mode ")
	)
	(alert (strcat	"\nError: That symbol\n{"
				(nth PosOut Lst_Sp_Dn)
				"}\nis available in\n"
				GMods
				GMode
				" only."
		  )
	)
)

(defun DrwDev ( Out /	PosOut Blk AttNam		; Draws Devices
					Ang AttLst AttVal OfffSet Ent Ppt1 LayNam Vpt1 Vpt2 Omod Ocol pnt1)
	(if Bug 
		(progn
			(princ "\nSymbols.Lsp!DrwDev - Enter parameter Out(list): ")
			(prin1 Out)
			(princ "\n")
		)
	)
	(if (or (= (stpDot AppNam) "CADET20")(= (stpDot AppNam) "CADET"))
		(c:what_mode)						; Draws Service Lines on WE
	)
	;	Gets position index from searching passed in symbol description, 
	;	PosOut is the key to all lookups in this function.
	(setq	PosOut	(-	(length Lst_Sp_Dn)
						(length (member (nth 0 OUT) Lst_Sp_Dn))
					)
	)
	;	Checks to see information from PicCkt ealier call exists is populates variables.
	(if DatLst
		(setq	Ent		(car (nth 0 DatLst))
				Ppt1		(nth 1 DatLst)
				LayNam	(nth 2 DatLst)
				Vpt1		(nth 4 DatLst)
				Vpt2		(nth 5 DatLst)
				Vpt1a	vpt1
				Vpt2a	vpt2
				Ang		(nth 8 DatLst)
		)
		(setq	LayNam	(getvar "CLAYER"))
	)
	;	Gets various system setting as to restore them at end of function
	(setq	AttRq	(getvar "ATTREQ")
			Ocol	(getvar "CECOLOR")
			Omod	(getvar "ORTHOMODE")
	)
	(setvar "ATTREQ" 0)
	(setvar "ORTHOMODE" 0)
	(if (= (nth PosOut Lst_Sp_Oc) "CONST")		;; Lst_Sp_Oc  ---> Object Class.
		(if (= (nth PosOut Lst_Sp_Sn) "093")
			(setvar "CECOLOR" "3")
			(if (= (nth PosOut Lst_Sp_Sn) "095")
				(progn
					(setvar "CECOLOR" "4")
					(setq	Out	(list	(nth 0 Out)
										(strcat (nth 1 Out) "%%D")
										(nth 2 Out)
								)
					)
				)
				(setvar "CECOLOR" "4")
			)
		)
		(setvar "CECOLOR" "7")
	)
	(if Bug
		(if (= (type Ang) (quote REAL))
			(princ (strcat "\nAng1 = " (rtos Ang 2 4)))
		)
	)
	(if Bug
		(setq	EdsOut	Out
				EdpOut	PosOut
				EdNam	LayNam
		)
	)
	(if Ent
		(setq	Tst1		(GrpEntChgFilt Ent))
		(setq	Tst1		nil)
	)
	(if Tst1
		;	Checks to see if block to be inserted is an in-line device.
		(if (and (nth 3 Tst1) (= (nth PosOut Lst_Sp_Er) "IL"))
			(setq	EntGrp	(nth (nth 3 Tst1) (nth 1 Tst1))
					OrgEntH	(cdr (assoc 5 (entget Ent)))
					Bubba	(if Bug
								(princ "\nChg Grp Detected...")
							)
					Bubba	(if Bug
								(princ (strcat "\nOrgEnt = " OrgEntH))
							)
			)
			(setq EntGrp nil)
		)
		(setq	EntGrp	nil)
	)
	(if EntGrp
		(command "-GROUP" "E" (car (nth (nth 3 Tst1) (nth 0 Tst1))))
	)
	(if EntGrp
		(if (= (length EntGrp) 2)
			(if (= (cdr (assoc 5 (entget (nth 0 EntGrp)))) OrgEntH)
				(setq	AltEnt	(nth 1 EntGrp)
						AltEntH	(cdr (assoc 5 (entget (nth 1 EntGrp))))
						Bubba	(if Bug
									(princ (strcat "\nAltEnt = " AltEntH))
								)
				)
				(setq	AltEnt	(nth 0 EntGrp)
						AltEntH	(cdr (assoc 5 (entget (nth 0 EntGrp))))
						Bubba	(if Bug
									(princ (strcat "\nAltEnt = " AltEntH))
								)
				)
			)
		)
		(setq	AltEnt	nil)
	)
	(if (/= PosOut (length Lst_Sp_Dn))
		(if (or (= (stpDot AppNam) "CADET20")(= (stpDot AppNam) "CADET"))
			(cond	((< (atoi (nth PosOut Lst_Sp_Sn)) 100)
						(setq	INam	(strcat _Path-SYM (nth PosOut Lst_Sp_Sn))
								Bubba	(if Bug
											(princ "\nDrwDev thinks sw name less than 100.")
										)
						)
					)
					((= AppMode "E")
						(setq	INam	(strcat _Path-SYM (nth PosOut Lst_Sp_Sn))
								Bubba	(if Bug
											(princ "\nDrwDev thinks Mode is Existing.")
										)
						)
					)
					((= AppMode "I")
						(setq	INam	(strcat _Path-SYM (itoa (+ 200 (atoi (nth PosOut Lst_Sp_Sn)))))
								Bubba	(if Bug
											(princ "\nDrwDev thinks Mode is Install.")
										)
						)
					)
					((= AppMode "R")
						(setq	INam	(strcat _Path-SYM (itoa (+ 400 (atoi (nth PosOut Lst_Sp_Sn)))))
								Bubba	(if Bug
											(princ "\nDrwDev thinks Mode is Remove.")
										)
						)
					)
					((= AppMode "C")
						(setq	INam	(strcat _Path-SYM (itoa (+ 600 (atoi (nth PosOut Lst_Sp_Sn)))))
								Bubba	(if Bug
											(princ "\nDrwDev thinks Mode is Changed.")
										)
						)
					)
					(T
						(setq	INam	(strcat _Path-SYM (nth PosOut Lst_Sp_Sn))
								Bubba	(if Bug
											(princ "\nDrwDev takes the default.")
										)
						)
					)
			)
			(setq	INam	(strcat _Path-SYM (nth PosOut Lst_Sp_Sn))
					Bubba	(if Bug
								(princ "\nDrwDev thinks this isnt Cadet.")
							)
			)
		)
	)
	(if (= (substr (nth posout lst_sp_sn) 1 1) "9")
		(setq	INam	(strcat _Path-SYM (nth PosOut Lst_Sp_Sn)))
	)
	(if (and Bug INam)
		(princ (strcat "\nDevice=" INam "\n"))
	)
	(if (/= PosOut (length Lst_Sp_Dn))
		(cond
			((= (nth PosOut Lst_Sp_Er) "IL")	;--------- If symbol goes IN the line.  ----------
				(if	(and (or (= (stpDot AppNam) "CADET20")(= (stpDot AppNam) "CADET")) (/= AppMode "E")) ; Sets layer to LookUpTable value
					(progn
						(if	Bug
							(princ	(strcat	"\nIL DrwDev Lay= "
											(substr LayNam 1 4)
											(nth PosOut Lst_Sp_Ln)
											(substr LayNam 7 4)
											AppMode
									)
							)
						)
						(MkLay	(strcat	(substr LayNam 1 4)
										(nth PosOut Lst_Sp_Ln)
										(substr LayNam 7 4)
										AppMode
								)
						)
					)
					(progn
						(if	Bug
							(princ	(strcat	"\nIL DrwDev Lay= "
											(substr LayNam 1 4)
											(nth PosOut Lst_Sp_Ln)
											(substr LayNam 7 4)
									)
							)
						)
						(MkLay	(strcat	(substr LayNam 1 4)
										(nth PosOut Lst_Sp_Ln)
										(substr LayNam 7 4)
								)
						)
					)
				)
				; Inserts primary block at 0,0,0
				(command	"INSERT"	
						INam
						(list 0.0 0.0)
						(* SF (nth PosOut Lst_Sp_Ss))
						""
						Ang
				)
				(setq	Blk	(PopAtt Out)) ; Populates attributes with dialog values
				(if	Bug
					(if	(= (type Ang) (quote REAL))
						(princ (strcat "\nAng2 = " (rtos Ang 2 4)))
					)
				)
				(if	Bug
					(if	(= (type Ang) (quote REAL))
						(princ (strcat "\nAng3 = " (rtos Ang 2 4)))
					)
				)
				(if	(and Bug (= (type Blk) (quote ENAME)))
					(princ "\nBlk returned Ename.")
				)
				(princ "\n\n\nPick location for insertion.")
				(command "MOVE" Blk "" (list 0.0 0.0) pause) ; Moves primary block to insertion point
				(setq	Ppt2		(getvar "LASTPOINT")	; Stores insertion point
						Tpt1		Ppt2					; Stores copy of insertion point
				)
				(if	(or	(equal Ppt2 (append Vpt1 (list 0.0)) (* 0.5 SF (nth PosOut Lst_Sp_Ss))) ; if either insertion point is 
						(equal Ppt2 (append Vpt2 (list 0.0)) (* 0.5 SF (nth PosOut Lst_Sp_Ss))) ; half device width from segment endpoint
					)
						(if (equal Ppt2 (append Vpt1 (list 0.0)) (* 0.5 SF (nth PosOut Lst_Sp_Ss)))
							(setq	Ppt2		(osnap	(polar	Vpt1
															(angle Vpt1 Vpt2)
															(* 0.75 SF (nth PosOut Lst_Sp_Ss))
													)
													"near"
											)
									Bubba	(if Bug
												(princ "\nTook first choice!")
											)
							)
							(setq	Ppt2		(osnap	(polar	Vpt2
															(angle Vpt2 Vpt1)
															(* 0.75 SF (nth PosOut Lst_Sp_Ss))
													)
													"near"
											)
									Bubba	(if Bug
												(princ "\nTook first choice!")
											)
							)
						)
						(setq	Ppt2		(inters	(polar	Ppt2
														(+ (angle Vpt1 Vpt2) (/ pi 2.0))
														100.0
												)
												(polar	Ppt2
														(- (angle Vpt1 Vpt2) (/ pi 2.0))
														100.0
												)
												Vpt1
												Vpt2
												nil
										)
								Bubba	(if Bug
											(princ "\nTook second choice!")
										)
						)
				)
				(if	Bug
					(if	(= (type Ang) (quote REAL))
						(princ (strcat "\nAng4 = " (rtos Ang 2 4)))
					)
				)
				(if	(and Bug PPt2)
					(if	(= (type PPt2) (quote LIST))
						(princ "\ndadgum PPt2 is a list!")
						(if	(null PPt2)
							(princ "\ndadgum PPt2 is nil!")
							(princ "\ndadgum PPt2 is not nil!")
						)
					)
					(if	Bug
						(princ "\ndadgum PPt2 is nil!!")
					)
				)
				(if	(= (nth PosOut Lst_Sp_Rt) "Y")
					(if	(equal Ppt2 Tpt1 0.001) ; if it hasnt moved
						(if	(and (>= Ang 90.0) (< Ang 270.0))
							(command	"ROTATE"
										Blk
										""
										Tpt1
										"R"
										Ang
										(+ Ang (setq Dang -90.0))
							)
							(command	"ROTATE"
										Blk
										""
										Tpt1
										"R"
										Ang
										(+ Ang (setq Dang 90.0))
							)
						)
						(command	"ROTATE"
									Blk
									""
									Tpt1
									"R"
									Ang
									(setq Nang (rtd (angle Ppt2 Tpt1)))
						)
					)
				)
				(command "MOVE" Blk "" Tpt1 (list 0.0 0.0))
				(setq	Tpt2		Ppt2
						Bubba	(if (and Bug (= (type Ent) (quote ENAME)))
									(princ "\nYa, Ent is an ename!")
								)
						Ent_Sel	(TstBreakIt (cons Ent (list Ppt2)))
						OAltNam	AltNam
						Ent		(car Ent_Sel)
						Ppt2		(cadr Ent_Sel)
				)
				(if Bug
					(PROGN
						(setq	EdOAlt	AltNam)
						(PRINC BLK)
					)
				)
				(if	AltEnt
					(setq	Alt_Sel	(TstBreakIt (cons AltEnt (list Ppt2)))
							EdNAlt	AltNam
							Bubba	(command
									"-group"
									"C"
									(strcat "ChPln" (itoa (GetGrpNex)))
									"Change Mode Pline Pair"
									(car Alt_Sel)
									(car Ent_Sel)
									""
									)
							Bubba	(command
									"-group"
									"C"
									(strcat "ChPln" (itoa (GetGrpNex)))
									"Change Mode Pline Pair"
									OAltNam
									AltNam
									""
									)
					)
				)
				(if	(not (equal Ppt2 Tpt1 0.001))
					(command "MOVE" Blk "" (list 0.0 0.0) Ppt2)
					(command "MOVE" Blk "" (list 0.0 0.0) Tpt1)
				)
				(setq	RPang	(cdr (assoc 50 (entget Blk)))
						RPdst	(* SF (nth PosOut Lst_Sp_Ss) 0.5)
				)
				(if	(member (nth PosOut Lst_Sp_Sn)
						(list "137" "337" "537" "737")
					)
					(if Bug (princ "\nGonna Move this one over!"))
				)
				(if	(member (nth PosOut Lst_Sp_Sn)
						(list "137" "337" "537" "737")
					)
					(command	"MOVE"
								Blk
								""
								Ppt1
								(polar Ppt1 RPang RPdst)
					)
				)
				(if	(and (assoc 66 (entget Blk)) DragATT)
					(progn
						(command	"_.COPY"
									Blk
									""
									"0,0"
									"0,0"
									"_.ERASE"
									Blk
									""
						)
						(att-nm)
					)
					(if	(assoc 66 (entget Blk))
						(progn
							(command	"_.COPY"
										Blk
										""
										"0,0"
										"0,0"
										"_.ERASE"
										Blk
										""
							)
							(att-nr)
						)
					)
				)
				(if	(and Bug (= (type Ent) (quote ENAME)))
					(princ "\nEnt found as Ename.")
				)
				(command	"_.COPY"
						Blk
						""
						Ppt2
						Ppt2
						"_.ERASE"
						Blk
						""
				)
				(entupd (entlast)) ; update complex entity
			)
			;--------- If symbol goes ON or OFF the line. -------
			((numberp (setq OfffSet (read (nth PosOut Lst_Sp_Er))))
			 (if	(and (or (= (stpDot AppNam) "CADET20")(= (stpDot AppNam) "CADET")) (/= AppMode "E"))
				 (progn
					 (if	Bug
						 (princ (strcat "\nOffset DrwDev Lay= "
									 (substr LayNam 1 4)
									 (nth PosOut Lst_Sp_Ln)
									 (substr LayNam 7 4)
									 AppMode
							   )
						 )
					 )
					 (MkLay (strcat (substr LayNam 1 4)
								 (nth PosOut Lst_Sp_Ln)
								 (substr LayNam 7 4)
								 AppMode
						   )
					 )
				 )
				 (progn
					 (if	Bug
						 (princ (strcat "\nOffset DrwDev Lay= "
									 (substr LayNam 1 4)
									 (nth PosOut Lst_Sp_Ln)
									 (substr LayNam 7 4)
							   )
						 )
					 )
					 (MkLay (strcat (substr LayNam 1 4)
								 (nth PosOut Lst_Sp_Ln)
								 (substr LayNam 7 4)
						   )
					 )
				 )
			 )
			 (command	"INSERT"
					INam
					(list 0.0 0.0)
					(* SF (nth PosOut Lst_Sp_Ss))
					""
					Ang
			 )
			 (setq Blk (PopAtt Out))
 				 	(princ "\n\n\nPick location for insertion.")
						(if (= (substr INAM (- (strlen INAM) 1) 2) "40")
		  						(progn
						 			(command "MOVE" Blk "" (list 0.0 0.0) "nea"pause)
									(setq pnt1(getvar "lastpoint"))
									(command "ROTATE" "L" "" pnt1 "r" ang "nea"pause)
								 )
						)
						(if (= (substr INAM (- (strlen INAM) 1) 2) "77")
							(progn
								(command "MOVE" Blk "" (list 0.0 0.0) "end"pause)
					   			(setq pnt1(getvar "lastpoint"))
				 				(setq item(entlast))
			 					(setq pnt1(list (car pnt1) (cadr pnt1)))
			 						(if bug
			 							(princ (rtos ang))
									)
								(if (and (equal pnt1 vpt2a)(/= (rtd(angle vpt1a vpt2a)) ang))
									(command "rotate" item "" pnt1 "180")
								)
								(if (and (equal pnt1 vpt1a)(/= (rtd(angle vpt2a vpt1a)) ang))
									(command "rotate" item "" pnt1 "180")
								)
							)
						 	(if (and 	(/= (substr INAM (- (strlen INAM) 1) 2) "40")
									(/= (substr INAM (- (strlen INAM) 1) 2) "77")
									(/= (substr INAM (- (strlen INAM) 1) 2) "38")
									(/= (substr INAM (- (strlen INAM) 1) 2) "39")
									(/= (substr INAM (- (strlen INAM) 1) 2) "57")
									(/= (substr INAM (- (strlen INAM) 1) 2) "68")
	   							)
								;(progn
							    		(command "MOVE" Blk "" (list 0.0 0.0) ppt1)
										;(if (= attnum nil)
											;(att-nm)
									    ; )
								;)
						    	)
						)
			 (if	(= (nth PosOut Lst_Sp_Oc) "POLE")
				(progn
					 (command "MOVE" Blk "" (list 0.0 0.0) pause)
					 (setq Ppt2 (getvar "LASTPOINT"))
				 	 (setq ent1(entget ent))
					 (if
					 	(= (substr (cdr (assoc 8 ENT1)) 5 2) "PA")
						(setq offfset 0.0)
					 	(setq OfffSet 0.12)
					 )
				)
				(setq ppt2 (getvar "LASTPOINT"))
			 )
			 (setq Ppt2 (inters	Ppt2
							(polar Ppt2 (dtr (- Ang 90)) 100)
						    	Vpt1
						    	Vpt2
						    	nil
					 )
			 )
			 (if	(equal Ppt2 (getvar "LASTPOINT") 0.001)
				 (setq Ppt2 (polar Ppt2
							    (dtr (+ Ang 90))
							    (* SF OfffSet)
						  )
				 )
				 (setq Ppt2
						 (polar Ppt2
							   (angle Ppt2 (getvar "LASTPOINT"))
							   (* SF OfffSet)
						 )
				 )
			 )
			 (if	(= (nth PosOut Lst_Sp_Oc) "POLE")
			 		(command "MOVE" Blk "" (getvar "LASTPOINT") Ppt2)
			 )
			(if (and (assoc 66 (entget Blk)) DragATT)
				(progn
					(command	"_.COPY"
					 			Blk
								""
								"0,0"
								"0,0"
								"_.ERASE"
								Blk
								""
					)
					(att-nm)
					(setq attnum T)
				)
				(if	(assoc 66 (entget Blk))
					(progn
						(command	"_.COPY"
									Blk
									""
									"0,0"
									"0,0"
									"_.ERASE"
									Blk
									""
						)
						(att-nr)
					)
				)
			)
		)
		((= (nth PosOut Lst_Sp_Er) "GY")	;--------- If symbol is DOWN GUY or SPAN GUY.
			(if (null (tblsearch "LAYER" "GUY_WIRE"))
				(command "layer" "n" "GUY_WIRE" "")
			)
			(if	(and (or (= (stpDot AppNam) "CADET20")(= (stpDot AppNam) "CADET")) (/= AppMode "E"))
				 (progn
					 (if	Bug
						 (princ (strcat "\nGuy DrwDev Lay= "
									 (substr LayNam 1 4)
									 (nth PosOut Lst_Sp_Ln)
									 (substr LayNam 7 4)
									 AppMode
							   )
						 )
					 )
					 (MkLay (strcat (substr LayNam 1 4)
								 (nth PosOut Lst_Sp_Ln)
								 (substr LayNam 7 4)
								 AppMode
						   )
					 )
				 )
				 (progn
					 (if	Bug
						 (princ (strcat "\nGuy DrwDev Lay= "
									 (substr LayNam 1 4)
									 (nth PosOut Lst_Sp_Ln)
									 (substr LayNam 7 4)
							   )
						 )
					 )
					 (MkLay (strcat (substr LayNam 1 4)
								 (nth PosOut Lst_Sp_Ln)
								 (substr LayNam 7 4)
						   )
					 )
				 )
			 )
			(if	(member (nth PosOut Lst_Sp_Sn)
					(list "135" "335" "535" "735" "136" "336" "536" "736")
				)
				(progn
					(command	"INSERT"
								INam
								Ppt1
								(* SF (nth PosOut Lst_Sp_Ss))
								""
								0.0
								"ROTATE"
								(entlast)
								""
								Ppt1
								pause
					)
					(setq	RPang	(cdr (assoc 50 (entget (entlast))))
							RPdst	(+ (* SF (nth PosOut Lst_Sp_Ss) 0.5) (* SF 0.06))
					)
					(if (member (nth PosOut Lst_Sp_Sn)
						(list "136" "336" "536" "736"))
						(progn
							(if Bug (princ "\nGonna Move this one over!"))
							(command	"MOVE"
										(entlast)
										""
										Ppt1
										(polar Ppt1 RPang RPdst)
							)	
							(command	"COPY"
										ENT
										""
										Ppt1
										Ppt1
										"_.ERASE"
										ENT
										""
							)
						)
					)
					(entupd (entlast))
				 )
				 (if	(member (nth PosOut Lst_Sp_Sn)
						   (list "114" "314" "514" "714")
					)
					 (progn
						 (setq Ppt2 Ppt1)
						 (princ "\n Now select the second pole.")
						 (setq Ppt1 (nth 1 (picpole)))
						 (setq Ang (angle Ppt1 Ppt2))
						 (Setq ang2 ang)
						 (setq ppt3 ppt1)
						 (setq Ppt1
								 (polar
									 Ppt1
									 Ang
									 (/ (distance Ppt1 Ppt2) 2)
								 )
						 )
						 (setq Ang (rtd Ang))
						 (if	(and (>= Ang 90.0) (< Ang 270.0))
							 (setq Ang (- Ang 180.0))
						 )
						 (setq blkscl(* SF (nth PosOut Lst_Sp_Ss)))
						 (command	"INSERT"
								INam
								Ppt1
								(* SF (nth PosOut Lst_Sp_Ss))
								""
								Ang
						 )
					(setq old_la(getvar "CLAYER"))
					(setvar "CLAYER" "GUY_WIRE")
					(setvar "PLINEWID" 0)
					(setq ppt4 (polar ppt1 ang2 (* -0.5 blkscl)))
					(setq ppt5 (polar ppt1 ang2 (* 0.5 blkscl)))
					(command "_.pline" ppt3 ppt4 ppt5 PPt2 "")
					(if (= AppMode "I")
						(command "_.change" "l" "" "P" "lt" "hidden2" "")
					)
					(setvar "CLAYER" old_la)
					 )
				 )
			 )
			)
			;--------- If symbol is Electical and Freestanding. ----------
			((= (nth PosOut Lst_Sp_Er) "EF")	
				(if	(/= (nth PosOut Lst_Sp_Oc) "CONST")
					(progn	;	This section of code change due to users group request for CADET to have all URD lights
							;	on a layer named "Lights".  Please think twice before changing code!!! CET 5/27/2008
							
						;	First if statement use do determine base layer name for any application.
						(if (and 	(or 	(= (nth PosOut Lst_Sp_Sn) "149") (= (nth PosOut Lst_Sp_Sn) "153")
									(= (nth PosOut Lst_Sp_Sn) "349") (= (nth PosOut Lst_Sp_Sn) "353")
									(= (nth PosOut Lst_Sp_Sn) "549") (= (nth PosOut Lst_Sp_Sn) "553")
									(= (nth PosOut Lst_Sp_Sn) "749") (= (nth PosOut Lst_Sp_Sn) "753")
								)
								(= (strcase(substr LayNam 4 1)) "U")
								(= (stpDot AppNam) "CADET"))
							(progn
								(setq baseLayer "LIGHTS")
								(setq ug_data "1")
							)
							(setq baseLayer (strcat (substr LayNam 1 4) (nth PosOut Lst_Sp_Ln)(substr LayNam 7 5)))
						)
						(if	(and (or (= (stpDot AppNam) "CADET20")(= (stpDot AppNam) "CADET")) (/= AppMode "E"))
							(progn	;	Any mode in CADET besides existing
								(setq newLayer (strcat baseLayer AppMode))
								(if	Bug (princ (strcat "\nEF DrwDev Lay= " newLayer)))
							)
							(progn	; 	Not CADET or Existing mode
								(setq newLayer baseLayer)
								(if	Bug (princ (strcat "\nEF DrwDev Lay= " newLayer)))
							)
						)
						(if newLayer
							(MkLay newLayer)
						)
					)
				)
				(if (= (substr inam (- (strlen inam) 2) 3) "094")
					(command "layer" "s" "WORK_LOC" "")
				)
				(if (= (substr inam (- (strlen inam) 2) 3) "095")
					(command "layer" "s" "angle" "")
				)
				(command	"INSERT"
					INam
					(list 0.0 0.0)
					(* SF (nth PosOut Lst_Sp_Ss))
					""
					0.0
				)
				(setq Blk (PopAtt Out))
				(princ "\n\n\nPick location for insertion.")
				(command "MOVE" Blk "" (list 0.0 0.0) pause)
				(setq lt_pt(getvar "LASTPOINT"))
				(if	(and (assoc 66 (entget Blk)) DragATT)
					(progn		   
						(command	"_.COPY" Blk	 ""	    "0,0"
								"0,0"   "_.ERASE"	    Blk
								""
						)
						(att-nm)
					)
					(if	(assoc 66 (entget Blk))
						 (progn
							 (command	"_.COPY" Blk	 ""	    "0,0"
									"0,0"   "_.ERASE"	    Blk
									""
								    )
							 (att-nr)
						)
					)
				)
				(setq Ppt2 (getvar "LASTPOINT"))
				(setq chklt(substr (cdr (assoc 2 (entget (entlast)))) 2 2))
				(if (or (= chklt "49")
				 	    (= chklt "53")
					 )
					(progn
						(setq baseLayer (strcat (substr LayNam 1 4) "SC" (substr LayNam 7 5)))
						(MkLay baseLayer)
						(command "_.pline" lt_pt "w" "0.0" "0.0")
					)
				)
				(if	(= (nth PosOut Lst_Sp_Sn) "093")
					 (command "_.ROTATE" "L" "" Ppt2 pause)
				)
			)
			;--------- If symbol is Freestanding Landbase. ----------
			((= (nth PosOut Lst_Sp_Er) "LF")	
			 (if	(not (tblsearch "LAYER" "LM_LANDMARK"))
				 (MkLay "LM_LANDMARK")
			 )
			 (command	"_.LAYER"
					"S"
					"LM_LANDMARK"
					""
					"INSERT"
					INam
					(list 0.0 0.0)
					(* SF (nth PosOut Lst_Sp_Ss))
					""
					0.0
			 )
			 (setq Blk (PopAtt Out))
			 (princ "\n\n\nPick location for insertion.")
			 (command "MOVE" Blk "" (list 0.0 0.0) pause)
			 (setq Ppt2 (getvar "LASTPOINT"))
			 (if	(= (nth PosOut Lst_Sp_Sn) "SP")
				 (command "ROTATE" Blk "" Ppt2 pause)
			 )
			 (if	(and (assoc 66 (entget Blk)) DragATT)
				 (progn
					 (command	"_.COPY" Blk	 ""	    "0,0"
							"0,0"   "_.ERASE"	    Blk
							""
						    )
					 (att-nm)
				 )
				 (if	(assoc 66 (entget Blk))
					 (progn
						 (command	"_.COPY" Blk	 ""	    "0,0"
								"0,0"   "_.ERASE"	    Blk
								""
							    )
						 (att-nr)
					 )
				 )
			 )
			)
			(T							;------------------------------------------
			 (alert "ERROR: Edit Rule not found")
			)
		)
	)
	(setvar "ATTREQ" AttRq)
	(setvar "ORTHOMODE" Omod)
	(setvar "CECOLOR" Ocol)
	(princ)
)

(defun MkLay ( _LAY / _POS _CLR _LT )			; Makes a Layer based upon passed entity & rules
	(if Bug 
		(progn
			(princ "\nSymbols.Lsp!MkLay - Enter parameter _LAY(string): ")
			(prin1 _LAY) ;(princ " DontE : ")
			;(prin1 DontE)
			(princ "\n")
		)
	)
	(if (/= _LAY (getvar "CLAYER"))
		(if (null (tblsearch "LAYER" _LAY))
			(progn
				(setq	_LT	"CONTINUOUS")
				(if (null ColorBy)
					(setq ColorBy "FD")
				)
				;	This block of code sets new layer color.
				(cond
					((= (substr _LAY 5 2) "CP")
						(setq _CLR 2)
					)
					((or	(= (substr _LAY 7 1) "D")
						(= (substr _LAY 7 1) "T")
						(= (substr _LAY 7 1) "B")
					 )
						(setq _CLR 7)
					)
					((= (substr _LAY 5 2) "SC")
						(setq _CLR 106)
					)
					((eq ColorBy "FD")
						(setq	_POS	(- (length Lst_Fd_V)
									   (length (member (substr _LAY 1 3) Lst_Fd_V))
									)
						)
						(if	(< _POS (length Lst_Fd_V))
							(setq _CLR (nth _POS Lst_Fd_C))
						)
					)
					((eq ColorBy "VT")
						(setq	_POS	(-	(length Lst_Vt_S)
										(length (member (substr _LAY 9 2) Lst_Vt_S))
									)
						)
						(if	(< _POS (length Lst_Vt_S))
							(setq _CLR (nth _POS Lst_Vt_C))
						)
					)
					((eq ColorBy "PH")
						(setq	_CLR	(nth (atoi (substr _LAY 7 1)) Lst_Ph_C))
					)
					((eq ColorBy "OU")
						(if	(= (substr _LAY 4 1) "O")
							(setq _CLR 5) ;OVERHEAD
							(setq _CLR 1) ;UNDERGROUND
						)
					)
					(T
						(setq _CLR 7)
						(princ "\nCouldnt find a ColorBy match!")
					)
				)
				(if (null DontE)
					(if (and (or (= (stpDot AppNam) "CADET20")(= (stpDot AppNam) "CADET"))
						    (<= (strlen _LAY) 10) (/=(substr _LAY 1 6) "LIGHTS") 
					    )
					    ;	This block of code sets new layer linetype
						(cond ((and (= AppMode "I")
								  (or (=(substr _LAY 5 2) "CK")
								  	 (=(substr _LAY 5 2) "SC")
								  )
							  )
								  (setq _LAY (strcat _LAY "I")
									   _LT  "HIDDEN2"
								  )
							 )
							 ((= AppMode "I")
							  (setq _LAY (strcat _LAY "I")
								   _LT  "CONTINUOUS"
							  )
							 )
							 ((and (= AppMode "C")
							 	(or (=(substr _LAY 5 2) "CK")
								    (=(substr _LAY 5 2) "SC")
								  )
								)
							  	(setq _LAY (strcat _LAY "C")
								   	_LT  "HIDDEN2"
							  )
							 )
							 ((= AppMode "C")
							  (setq _LAY (strcat _LAY "C")
								   _LT  "CONTINUOUS"
							  )
							 )
							 ((and (= AppMode "R")
							 	(or (=(substr _LAY 5 2) "CK")
								  	 (=(substr _LAY 5 2) "SC")
								  )
								)
							  (setq _LAY (strcat _LAY "R")
								   _LT  "REMOVED"
							  )
							 )
							 (T (setq _LT "CONTINUOUS"))
						)
						(progn
							(if (or (= (substr _LAY 11 1) "I")
								   (= (substr _LAY 11 1) "C")
							    )
								(setq _LT "HIDDEN2")
							)
							(if (and (= (substr _LAY 11 1) "R")
								(or (=(substr _LAY 5 2) "CK")
								  	 (=(substr _LAY 5 2) "SC")
								  )
								)
								(setq _LT "REMOVED")							
							)
							(if (or (= _LAY "LIGHTSI")
								    (= _LAY "LIGHTSC")
							    )
								(setq _LT "CONTINUOUS")
							)
						)
					)
					(if	(= (substr _LAY 4 1) "O")
						(setq	_LT	"CONTINUOUS")
						(cond	((and	(= (substr _LAY 4 1) "O")
										(member (substr _LAY 7 1) (list "1" "2" "3"))
								 )
									(setq	_LT	"DASHED")
								)
								((and	(= (substr _LAY 4 1) "U")
										(member (substr _LAY 7 1) (list "4" "5" "6"))
								 )
									(setq	_LT	"HIDDEN")
								)
								(T (setq	_LT	"CONTINUOUS"))
						)
					)
				)
				(if Bug
					(if _CLR
						(if (= (type _CLR) (quote INT))
							(princ (strcat	"\nMkLay = " _LAY ", Lt = " _LT ", _CLR =" (itoa _CLR)))
						)
					)
				)
				(if (not _LT)
					(setq	_LT	"CONTINUOUS")
				)
				(if (not _CLR)
					(setq	_CLR		7)
				)
				(command "_.LAYER" "m" _LAY "c" _CLR _LAY "lt" _LT _LAY "")
			)
			(progn
				(ForceLay _LAY)
				(command "_.LAYER" "s" _LAY "")
			)
		)
	)
	(if Bug (princ (strcat	"\nMkLay = " _LAY  "\n" )))
	(if Bug
		(if _CLR
			(if (= (type _CLR) (quote INT))
				(princ (strcat	"\nMkLay = " _LAY ", Lt = " _LT ", _CLR =" (itoa _CLR)))
			)
		)
	)
	_lay
)

(defun PopAtt ( Out / Blk Cnt AttLst AttVal )	; Pops Attribute values to Block
; POPATT - stuffs new block with atrributes used in function DRWDEV().
; Out = value list received by DrwDev
; Calls Att-nr function from file att_chg.lsp for Non-Rotated placement
	(if Bug 
		(progn
			(princ "\nSymbols.Lsp!PopAtt - Enter parameter Out(list): ")
			(prin1 Out)
			(princ "\n")
		)
	)
	(setq Blk (entlast))
	(if (assoc 66 (entget Blk))
		(progn
			(setq CNT	   1
				 ATTNAM (entnext Blk)
			)
			(while (/= (cdr (assoc 0 (entget ATTNAM))) "SEQEND")
				(if (setq ATTVAL (nth CNT OUT))
					(progn
						(setq ATTLST (entget ATTNAM)
							 ATTLST (subst	(cons 1 ATTVAL)
										(assoc 1 ATTLST)
										ATTLST
								   )
						)
						(if Bug
							(princ (strcat	"\nPopAtt does "
										(cdr (assoc 1 AttLst))
										" as number "
										(itoa Cnt)
								  )
							)
						)
						(entmod ATTLST)
					)
				)
				(setq CNT	   (1+ CNT)
					 ATTNAM (entnext ATTNAM)
				)
			)
			(Att-Nr)
		)
	)
	Blk
)

(defun WireSize ( PriOnly /	TempLst LayNam		; WireSize annotates Wire with Wire Size
						WirSiz dcl_sym dlg apos1 LimGot )
;Layers '??????T???' and '??????B???' are created - The Wire-description either Top or
;Bottom of Circuits to be in one of the above layers.
;Pass a nil to get both Primary and Neutral
	(setvar "LIMCHECK" 0)
	(setvar "ORTHOMODE" 0)
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
	(setq	TempLst	(PicSec))
	(setq	LayNam	(nth 2 TempLst)
			Wirsiz	(nth 4 (last TempLst))
	)
	(if (and bug WirSiz LayNam)
		(progn
			(princ (strcat "\nWirsiz: " WirSiz))
			(princ (strcat "\nLaynam: " LayNam))
		)
	    (if (and bug LayNam)
			(princ (strcat "\nLaynam (only): " LayNam))
	    )
	)
	(if (not (nth 3 TempLst))
		(cond
			((= (type PriOnly) (quote LIST))
				(TxtDo PriOnly LayNam nil TempLst)
			)
			(T
				(setq dcl_sym (load_dialog "symbols.dcl"))
				(new_dialog "TXTDO" dcl_sym)
				(action_tile "val1" "(setq apos1 $value)")
				(setq dlg (start_dialog))
				(if (= dlg 1)
					(if (not (null apos1))
					   (TxtDo PriOnly LayNam apos1 TempLst)
					)
					(princ "\nWireSize cancelled")
				)
				(unload_dialog dcl_sym)
			)
		)
	    (WirDo PriOnly LayNam WirSiz TempLst)
	)
	(princ)
)

(defun WirDo ( PriOnly LayNam WirSiz TempLst	; called from WireSize, places text on drawing
			/	chr_pos OFFSET Ppt2 Ppt1 ENT WirSiz_PRI Ept1 Ept2 VpTemp
				TextLayer Ang Vpt1 Vpt2 )
	(setq	Ang		(nth 8 TempLst)
			Vpt1		(nth 4 TempLst)
			Vpt2		(nth 5 TempLst)
	)
	(if (not Tmult)						 ; 11/9/98 for Cadet 2.*
		(setq Tmult 1.0)
	)
	(if PriOnly ;Nil if you want both Primary and Neutral
			(progn
				(setq last_chr(substr laynam (strlen laynam) 1))
 				(setq chr_pos 1)
					(if (= (substr laynam 4 1) "O")
						(progn
							(repeat (strlen WirSiz)
								(if (= (substr WirSiz chr_pos 1) "&")
									(setq WirSiz_pri(substr WirSiz 1 (- chr_pos 1)))
								)
								(setq chr_pos (1+ chr_pos))
							)
						)
						(setq wirsiz_pri wirsiz)
					)
				(if (or (= last_chr "I") (= last_chr "R")(= last_chr "C"))
					;(progn
						(setq wirsiz_pri (strcat last_chr ": " wirsiz_pri))
							;(if (= kv 1)
								;(progn
									;(setq kvnum(substr laynam 9 2))
									;(setq wirsiz_pri (strcat wirsiz_pri " " kvnum "KV"))
								;)
							;)
					;)
					;(if (= kv 1)
								;(progn
									;(setq kvnum(substr laynam 9 2))
									;(setq wirsiz_pri (strcat wirsiz_pri " " kvnum "KV"))
								;)
					 ;)
				)
				(command "TEXT"
				    		"J"
				    		"M"
			    			(list 0.0 0.0)
				  		(* SF TMult 0.075)
				   		 ANG
					    	WirSiz_PRI
				)
			)
			(progn
				(setq last_chr(substr laynam (strlen laynam) 1))
					(if (or (= last_chr "I") (= last_chr "R"))
						;(progn
							(setq wirsiz (strcat last_chr ": " wirsiz))
								;(if (= kv 1)
									;(progn
										;(setq kvnum(substr laynam 9 2))
										;(setq wirsiz (strcat wirsiz " " kvnum "KV"))
									;)
							    ;	)
						;)
						;(if (= kv 1)
							;(progn
								;(setq kvnum(substr laynam 9 2))
								;(setq wirsiz (strcat wirsiz " " kvnum "KV"))
							;)
					 	;)
					)
			(command "TEXT"
				    "J"
				    "M"
				    (list 0.0 0.0)
				    (* SF TMult 0.075)
				    ANG
				    WirSiz
			)
		)
	)
	(setq kv 0)
	(princ "\n\n\nPick locration for insertion.")
	(command "MOVE" (entlast) "" (list 0.0 0.0) pause)
	(setq Ppt2 (getvar "LASTPOINT"))
	(setq OFFFSET 0.10)
	(setq Ppt2 (inters Ppt2
				    (polar Ppt2 (dtr (- ANG 90)) 100)
				    Vpt1
				    Vpt2
				    nil
			 )
	)
	(if (equal Ppt2 (getvar "LASTPOINT") 0.001)
		(setq Ppt2 (polar Ppt2 (dtr (+ ANG 90)) (* SF TMult OFFFSET)))
		(setq Ppt2 (polar Ppt2
					   (angle Ppt2 (getvar "LASTPOINT"))
					   (* SF TMult OFFFSET)
				 )
		)
	)
	(command "MOVE" (entlast) "" (getvar "LASTPOINT") Ppt2)
	(if (> (car Vpt1) (car Vpt2))
		(setq VpTemp Vpt1
			 Vpt1 Vpt2
			 Vpt2 VpTemp
		)
		(if (= (car Vpt1) (car Vpt2))
			(if (> (cadr Vpt1) (cadr Vpt2))
				(setq VpTemp Vpt1
					 Vpt1 Vpt2
					 Vpt2 VpTemp
				)
			)
		)
	)
	(if (< (RTD (angle Ppt2 Vpt2)) (RTD (angle Vpt1 Vpt2)))
		(setq textlayer (MKLAY (strcat (substr LayNam 1 6)
								 "T"
								 (substr LayNam 8 4)
						   )
					 )
		)
		(setq textlayer (MKLAY (strcat (substr LayNam 1 6)
								 "B"
								 (substr LayNam 8 4)
						   )
					 )
		)
	)
	(command "CHPROP" (entlast) "" "LA" textlayer "")
	(princ)
)

(defun TxtDo ( PriOnly LayNam WirSiz TempLst	; called from WireSize, places text on drawing
			/	chr_pos OFFSET Ppt2 Ppt1 ENT WirSiz_PRI Ept1 Ept2 VpTemp
				TextLayer Ang Vpt1 Vpt2 WirSizer dcl_sym dlg )
	(setq	Ang		(nth 8 TempLst)
			Vpt1		(nth 4 TempLst)
			Vpt2		(nth 5 TempLst)
	)
	(if (not Tmult)						 ; 11/9/98 for Cadet 2.*
		(setq Tmult 1.0)
	)
	(if PriOnly ;Nil if you want both Primary and Neutral
		(if (= (type PriOnly) (quote LIST))
			(progn
				(if Bug (princ "\nGone the list route"))
				(setq	dcl_sym	(load_dialog "symbols.dcl")
						dlg		3
				)
				(if dcl_sym
					(while (> dlg 1)
						(new_dialog "LISTXT" dcl_sym)
						(start_list "lst1" 3)
						(mapcar (quote add_list) PriOnly)
						(end_list)
						(action_tile "lst1" "(setq WirSizer $value)")
						(setq	dlg	(start_dialog))
					)
				)
				(if (= dlg 1)
					(if (/= WirSizer "0")
						(setq	WirSiz_PRI	(nth (atoi WirSizer) PriOnly))
					)
					(princ "\nText choice cancelled")
				)
				(if (= dlg 1)
					(command "TEXT"
						    "J"
						    "M"
						    (list 0.0 0.0)
						    (* SF TMult 0.075)
						    ANG
						    WirSiz_PRI
					)
				)
			)
			(progn
				(if Bug (princ "\nGone the non-list route"))
				(command "TEXT"
					    "J"
					    "M"
					    (list 0.0 0.0)
					    (* SF TMult 0.075)
					    ANG
					    WirSiz
				)
				(setq	dlg	1)
			)
		)
		(progn
			(if Bug (princ "\nGone the other route"))
			(command "TEXT"
				    "J"
				    "M"
				    (list 0.0 0.0)
				    (* SF 0.075)
				    ANG
				    WirSiz
			)
			(setq	dlg	1)
		)
	)
	(if (= dlg 1)
		(progn
			(princ "\n\n\nPick location for insertion.")
			(command "MOVE" (entlast) "" (list 0.0 0.0) pause)
			(setq Ppt2 (getvar "LASTPOINT"))
			(setq OFFFSET 0.10)
			(setq Ppt2 (inters Ppt2
						    (polar Ppt2 (dtr (- ANG 90)) 100)
						    Vpt1
						    Vpt2
						    nil
					 )
			)
			(if (equal Ppt2 (getvar "LASTPOINT") 0.001)
				(setq Ppt2 (polar Ppt2 (dtr (+ ANG 90)) (* SF TMult OFFFSET)))
				(setq Ppt2 (polar Ppt2
							   (angle Ppt2 (getvar "LASTPOINT"))
							   (* SF TMult OFFFSET)
						 )
				)
			)
			(command "MOVE" (entlast) "" (getvar "LASTPOINT") Ppt2)
			(if (> (car Vpt1) (car Vpt2))
				(setq VpTemp Vpt1
					 Vpt1 Vpt2
					 Vpt2 VpTemp
				)
				(if (= (car Vpt1) (car Vpt2))
					(if (> (cadr Vpt1) (cadr Vpt2))
						(setq VpTemp Vpt1
							 Vpt1 Vpt2
							 Vpt2 VpTemp
						)
					)
				)
			)
			(if (< (RTD (angle Ppt2 Vpt2)) (RTD (angle Vpt1 Vpt2)))
				(setq textlayer (MKLAY (strcat (substr LayNam 1 6)
										 "T"
										 (substr LayNam 8 4)
								   )
							 )
				)
				(setq textlayer (MKLAY (strcat (substr LayNam 1 6)
										 "B"
										 (substr LayNam 8 4)
								   )
							 )
				)
			)
			(command "CHPROP" (entlast) "" "LA" textlayer "")
		)
	)
	(princ)
)

(defun SymSizN ( Sym /	Lngth Gap SymNam )		; determine proper size and Gap type for a Symbol
; Function: determine the proper size and Gap type for a Symbol
; Comments: sets globals 'Lngth' and 'Gap'
;           Gap = "N"   do not create Gap
;           Gap = "M"   make a Gap to one side of ins pt and a fill line
;           Gap = "C"   make a Gap centered on the ins pt, but no fill line
	(if Bug (princ "\n{SymSizN entered"))
	(cond
		;------------  Symbol Collisions! ----------------------------------------
		((and (member Sym (list "BRKR_SUB")) (wcmatch (substr (StpDot AppNam) 1 4) "ADDS"))
			(setq	Lngth	0.15	Gap	"C")
		)
		((and (member Sym (list "BRKR_SUB")) (wcmatch (StpDot AppNam) "SUBTOOLS"))
			(setq	Lngth	0.25	Gap	"C")
		)
		((member Sym (list "BRKR_SUB"))
			(setq	Lngth	0.25	Gap	"C")
		)
		((and (member Sym (list "SUB")) (wcmatch (substr (StpDot AppNam) 1 4) "ADDS"))
			(setq	Lngth	0.25	Gap	nil)
		)
		((and (member Sym (list "SUB")) (wcmatch (StpDot AppNam) "SUBTOOLS"))
			(setq	Lngth	0.60	Gap	"C")
		)
		((member Sym (list "SUB"))
			(setq	Lngth	0.60	Gap	"C")
		)
		((and (member Sym (list "REG")) (wcmatch (substr (StpDot AppNam) 1 4) "ADDS"))
			(setq	Lngth	0.25	Gap	"C")
		)
		((and (member Sym (list "REG")) (wcmatch (StpDot AppNam) "SUBTOOLS"))
			(setq	Lngth	0.32808	Gap	"C")
		)
		((and (member Sym (list "LTC")) (wcmatch (StpDot AppNam) "SUBTOOLS"))
			(setq	Lngth	0.15791	Gap	"M")
		)
		((member Sym (list "REG"))
			(setq	Lngth	0.25	Gap	"C")
		)
		;-------------------------------------------------------------------------
		((member Sym (list"RISER"))
			(setq	Lngth	0.09	Gap	"M")
		)
		((member Sym (list "CS" "DS" "GS" "CS2" "DS2" "GS2" "SECT" "MOGS"))
			(setq	Lngth	0.25	Gap	"M")
		)
		((member Sym (list "CR" "DR" "GR" "RECL" "RECLBP" "SMS"))
			(setq	Lngth	0.34	Gap	"M")
		)
		((= Sym "RECLEL")
			(setq	Lngth	0.6	Gap	"M")
		)
		((member Sym (list "_SS" "NEWSS" "C_SS" "E_SS" "I_SS" "R_SS" "CNEWSS" "ENEWSS" "INEWSS" "RNEWSS"))
			(setq	Lngth	0.0625 Gap "M")
		)
		((member Sym (list "_SSR" "C_SSR" "E_SSR" "I_SSR" "R_SSR" "UGOPEN" "UNO" ))
			(setq	Lngth	0.125 Gap	"M")
		)
		((member Sym (list "A140"))
			(setq	Lngth	0.09	Gap	"M")
		)
		;-------------------------------------------------------------------------
		((member Sym (list "SWC" "SWO" "TL" "BKRC" "BKRO" "BRKR_SUB" "FSC" "FSO" "FUSE" "MODC" "GSC" "GSO" "KNIFESW" "MODO" "RACK_NC" "RACK_NO" "RACK_RO"))
			(setq	Lngth	0.25	Gap	"C")
		)
		((member Sym (list "ARR_FDR"))
			(setq	Lngth	0.175	Gap	"C")
		)
		((member Sym (list "A167" "A175" "A177" "A180"))
			(setq	Lngth	0.1875	Gap	"C")
		)
		((member Sym (list "A125" "A170" "A124" "A172" "A126" "A173" "A160" "A161" "A121" "A176" "A196" "A197" "A135" "A131" "A065"))
			(setq	Lngth	0.25	Gap	"C")
		)
		((member Sym (list "A123" "A171" "A085" "A084"))
			(setq	Lngth	0.34	Gap	"C")
		)
		((member Sym (list "A125S" "A170S"))
			(setq	Lngth	0.0625 Gap "C")
		)
		((member Sym (list "A109" "A071"))
			(setq	Lngth	0.125 Gap	"C")
		)
		((member Sym (list "U" "T" "G" "FD_NUM2" "A080"))
			(setq	Lngth	0.15	Gap	"C")
		)
		((member Sym (list "PAD" "A079" "PADMT" "A078" "TRANSCL" "A077"))
			(setq	Lngth	0.20	Gap	"C")
		)
		((member Sym (list "A133" "A188" "A189" "A192" "A195" "REGA" "A120" "STEP" "STEPTRAN" "A122"))
			(setq	Lngth	0.25	Gap	"C")
		)
		((member Sym (list "LOC_IN"))
			(setq	Lngth	0.34	Gap	"C")
		)
		((member Sym (list "_FI_T" "A106" "_FI_B" "_CC_T" "_CC_B" "A148"))
			(setq	Lngth	0.144 Gap	"C")
		)
		((member Sym (list "_AUTOCON" "A123" "A138" "A142" "A171" "A164" "A181"))
			(setq	Lngth	0.15	Gap	"C")
		)
		((member Sym (list "_OCR" "A105" "A154" "A157" "A169" "A190" "A191" "A193" "A194" "A213" "A214" "_OCR_BP" "_OCR_EL" "_SECT" "C_OCR" "E_OCR" "I_OCR" "R_OCR"))
			(setq	Lngth	0.15	Gap	"C")
		)
		;-------------------------------------------------------------------------
		((member Sym (list "QUANTUM" "POT"))
			(setq	Lngth	0.125 Gap	nil)
		)
		((member Sym (list "ARROW"))
			(setq	Lngth	0.06965 Gap	nil)
		)
		((member Sym (list "GROUND"))
			(setq	Lngth	0.08333 Gap	nil)
		)
		((member Sym (list "DPOLE" "FPOLE" "TPOLE"))
			(setq	Lngth	0.125 Gap	nil)
		)
		((member Sym (list "PM" "A150" "A198" "A199"))
			(setq	Lngth	0.18	Gap	nil)
		)
		((member Sym (list "ARRHD" "1ANC" "GND" "SERV" "STUB"))
			(setq	Lngth	0.20	Gap	nil)
		)
		((member Sym (list "SENSOR" "A155" "2ANC" "CAP" "A101" "LA" "A074" "SUB2" "A075" "A132" "A134"))
			(setq	Lngth	0.25	Gap	nil)
		)
		((member Sym (list "1TX" "2TX" "3TX"))
			(setq	Lngth	0.28	Gap	nil)
		)
		((member Sym (list "3ANC" "LITE"))
			(setq	Lngth	0.30	Gap	nil)
		)
		((member Sym (list "CE" "A082" "LOC" "A086"))
			(setq	Lngth	0.34	Gap	nil)
		)
		((member Sym (list "ANG" "TREE"))
			(setq	Lngth	0.40	Gap	nil)
		)
		((member Sym (list "LFSP"))
			(setq	Lngth	0.50	Gap	nil)
		)
		((member Sym (list "STN"))
			(setq	Lngth	0.6	Gap	nil)
		)
		((member Sym (list "LTNO"))
			(setq	Lngth	0.70	Gap	nil)
		)
		((member Sym (list "SWNO" "SENSNO"))
			(setq	Lngth	0.95	Gap	nil)
		)
		;-------------------------------------------------------------------------
		((= Sym "CP")
			(setq	Lngth	0.0775 Gap "N")
		)
		((member Sym (list "GETAWAY" "A165"))
			(setq	Lngth	0.06 Gap "N")
		)
		((= Sym "NO")
			(setq	Lngth	0.12	Gap	"N")
		)
		((= Sym "PM_END")
			(setq	Lngth	0.18	Gap	"N")
		)
		((member Sym (list "URD_LOC" "A081" "_DA" "A156"))
			(setq	Lngth	0.25	Gap	"N")
		)
;;;		((member Sym (list "CE" "A100"))
;;;			(setq	Lngth	0.5	Gap	"N")
;;;		)
;;;		((= Sym "LFSP")							;--For Mobile, makes Life Support
;;;			(setq	Lngth	(/ 0.50 smult)				;  stay original size.
;;;					Gap	"N"
;;;			)
;;;		)
		((member Sym (list "SUBCUST" "A076"))
			(setq	Lngth	0.1833 Gap "N")
		)
		((member Sym (list "_SGEN" "A104" "_CATV" "A100" "_KEY" "A183"))
			(setq	Lngth	0.275 Gap	"N")
		)
		((member Sym (list "_CHURCH" "_SCHOOL" "_BLDG" "CEMETERY"))
			(setq	Lngth	0.09	Gap	"N")
		)
		;-------------------------------------------------------------------------
		(T
			(setq	Lngth	nil	Gap	nil)
		)
	)
	(if AppNam
		(if	(and	(=		(strcase (substr AppNam 1 4))
						"BEMS"
				)
				(not (member	(strcase Sym)
							(list "ANG" "ARRHD" "CE" "FD_NUM2" "G" "LOC" "LOC_IN" "LFSP" "NA" "NO" "TREE" "U" "UNO")
					)
				)
				AppMode
			)
			(if (and Sym _Path-Sym)
				(setq	SymNam	(strcat _Path-Sym AppMode Sym))
			)
			(if (and Sym _Path-Sym)
				(setq	SymNam	(strcat _Path-Sym Sym))
			)
		)
		(if (and Sym _Path-Sym)
			(setq	SymNam	(strcat _Path-Sym Sym))
		)
	)
	(if (and Lngth smult)
		(setq	Lngth	(* Lngth smult))
	)
	(if (and Bug Gap)
		(princ	(strcat	"\nGap=" Gap))
	)
	(if (and Bug Lngth)
		(princ	(strcat	"\nLngth=" (rtos Lngth 2 4)))
	)
	(if (and Bug SymNam)
		(princ	(strcat	"\nSymNam=" SymNam))
	)
	(if Bug (princ "\nSymSizN exited}\n"))
	(list Gap Lngth SymNam)
)

(defun LookLst ( Numb Lst1 Lst2 / Inam Onum )	; List Lookup shortcut
	(setq Inam (nth Numb Lst1))
	(if Inam
		(if (member Inam Lst2)
			(setq Onum (- (length Lst2) (length (member Inam Lst2))))
		)
	)
)

(defun PicSec ( /	TMP Ent Ppt1 LayNam WirSiz	; Pick Second
				Vpt1 Vpt2 Ept1 Ept2 Ang Hobart )
	(setq ENT	 nil
		 vpt1 nil
		 vpt2 nil
	)
	(while (not ENT)
		(if (setq ENT (entsel "\n Pick circuit for association:"))
			(if (and (or (= (cdr (assoc 0 (entget (car ENT))))
						 "LWPOLYLINE"
					   )
					   (= (cdr (assoc 0 (entget (car ENT))))
						 "POLYLINE"
					   )
				    )
			    )
				(setq Ppt1   (osnap (cadr ENT) "nea")
					 LayNam (cdr (assoc 8 (entget (car ENT))))
					 EDat   (GetDat (car ent))
					 WirSiz (nth 4 EDat)
				)
				(setq ENT nil)
			)
		)
	)
	(setq	Hobart	(GetPLDat Ent))
	(if Hobart
		(setq	Vpt1	(nth 2 Hobart)
				Vpt2	(nth 3 Hobart)
				Ept1	Vpt1
				Ept2	Vpt2
				Ang	(rtd (angle Vpt1 Vpt2))
		)
	)
	(if (and (> Ang 90) (< Ang 270))
		(setq Ang (- Ang 180))
	)
	(list Ent Ppt1 LayNam WirSiz Vpt1 Vpt2 Ept1 Ept2 Ang EDat)
)

(defun PopRAtt ( Out / Blk Cnt AttLst AttVal )	; Pops Attribute values to Block
	(setq Blk (entlast))
	(if (assoc 66 (entget Blk))
		(progn
			(setq CNT	   1
				 ATTNAM (entnext Blk)
			)
			(while (/= (cdr (assoc 0 (entget ATTNAM))) "SEQEND")
				(if (setq ATTVAL (nth CNT OUT))
					(progn
						(setq ATTLST (entget ATTNAM)
							 ATTLST (subst	(cons 1 ATTVAL)
										(assoc 1 ATTLST)
										ATTLST
								   )
						)
						(if Bug
							(princ (strcat	"\nPopAtt does "
										(cdr (assoc 1 AttLst))
										" as number "
										(itoa Cnt)
								  )
							)
						)
						(entmod ATTLST)
					)
				)
				(setq CNT	   (1+ CNT)
					 ATTNAM (entnext ATTNAM)
				)
			)
		)
	)
	Blk
)

(defun Cb_Tst_OK ( Act / )					; Call Back - Phase Test OK
	(cond	((= Act 1)
				(if (/= (get_tile "TL_popup") "0")
					(mode_tile "ok_button" 0)
					(mode_tile "ok_button" 1)
				)
			)
			((= Act 2)
				(if (or	(and	(/= (get_tile "TL_popup") "0")
								(/= (get_tile "TM_popup") "0")
						)
						(and	(/= (get_tile "TL_popup") "0")
								(/= (get_tile "ML_popup") "0")
						)
					)
						(mode_tile "ok_button" 0)
						(mode_tile "ok_button" 1)
				)
			)
			((= Act 3)
				(setq	TstVal	(+	(if (/= 0 (atoi (get_tile "TL_popup"))) 1 0)
									(if (/= 0 (atoi (get_tile "TM_popup"))) 1 0)
									(if (/= 0 (atoi (get_tile "TR_popup"))) 1 0)
									(if (/= 0 (atoi (get_tile "ML_popup"))) 1 0)
									(if (/= 0 (atoi (get_tile "MM_popup"))) 1 0)
									(if (/= 0 (atoi (get_tile "MR_popup"))) 1 0)
									(if (/= 0 (atoi (get_tile "BL_popup"))) 1 0)
									(if (/= 0 (atoi (get_tile "BM_popup"))) 1 0)
									(if (/= 0 (atoi (get_tile "BR_popup"))) 1 0)
								)
				)
				(if (= TstVal 3)
					(mode_tile "ok_button" 0)
					(mode_tile "ok_button" 1)
				)
			)
	)
)

(defun Cb_TL_popup ( Act Alst / )				; Call Back - Phase TL
	(setq	Alst	(RepLst ALst (get_tile "TL_popup") 0))
	(cb_Tst_OK Act)
	Alst
)

(defun Cb_TM_popup ( Act Alst / )				; Call Back - Phase TM
	(setq	Alst	(RepLst ALst (get_tile "TM_popup") 1))
	(cb_Tst_OK Act)
	Alst
)

(defun Cb_TR_popup ( Act Alst / )				; Call Back - Phase TR
	(setq	Alst	(RepLst ALst (get_tile "TR_popup") 2))
	(cb_Tst_OK Act)
	Alst
)

(defun Cb_ML_popup ( Act Alst / )				; Call Back - Phase ML
	(setq	Alst	(RepLst ALst (get_tile "ML_popup") 3))
	(cb_Tst_OK Act)
	Alst
)

(defun Cb_MM_popup ( Act Alst / )				; Call Back - Phase MM
	(setq	Alst	(RepLst ALst (get_tile "MM_popup") 4))
	(cb_Tst_OK Act)
	Alst
)

(defun Cb_MR_popup ( Act Alst / )				; Call Back - Phase MR
	(setq	Alst	(RepLst ALst (get_tile "MR_popup") 5))
	(cb_Tst_OK Act)
	Alst
)

(defun Cb_BL_popup ( Act Alst / )				; Call Back - Phase BL
	(setq	Alst	(RepLst ALst (get_tile "BL_popup") 6))
	(cb_Tst_OK Act)
	Alst
)

(defun Cb_BM_popup ( Act Alst / )				; Call Back - Phase BM
	(setq	Alst	(RepLst ALst (get_tile "BM_popup") 7))
	(cb_Tst_OK Act)
	Alst
)

(defun Cb_BR_popup ( Act Alst / )				; Call Back - Phase BR
	(setq	Alst	(RepLst ALst (get_tile "BR_popup") 8))
	(cb_Tst_OK Act)
	Alst
)

(defun Load_TPH ( Act /	dlg TLst ALst dcl_Sym	; Phase Symbols Tester
					Cnt )
	(setvar "ATTREQ" 1)
	(setq	dlg		2
			Tlst		(list " " "A" "B" "C")
			Alst		(list	(chr 48)
							(chr 48)
							(chr 48)
							(chr 48)
							(chr 48)
							(chr 48)
							(chr 48)
							(chr 48)
							(chr 48)
					)
	)
	(if (member Act (list 1 2 3))
		(if (setq dcl_sym (findfile "symbols.dcl"))
			(if (> (setq dcl_sym (load_dialog dcl_sym)) 0)
				(while (> dlg 1)
					(new_dialog "TPH" dcl_sym)
					(cond	((= Act 1)
								(mode_tile "TL_popup" 0)
								(mode_tile "TM_popup" 0)
								(mode_tile "TR_popup" 0)
								(mode_tile "ML_popup" 0)
								(mode_tile "MM_popup" 0)
								(mode_tile "MR_popup" 0)
								(mode_tile "BL_popup" 0)
								(mode_tile "BM_popup" 0)
								(mode_tile "BR_popup" 0)
								(start_list "TL_popup" 3)
								(mapcar (quote add_list) Tlst)
								(end_list)
								(mode_tile "TM_popup" 1)
								(mode_tile "TR_popup" 1)
								(mode_tile "ML_popup" 1)
								(mode_tile "MM_popup" 1)
								(mode_tile "MR_popup" 1)
								(mode_tile "BL_popup" 1)
								(mode_tile "BM_popup" 1)
								(mode_tile "BR_popup" 1)
							)
							((= Act 2)
								(mode_tile "TL_popup" 0)
								(mode_tile "TM_popup" 0)
								(mode_tile "TR_popup" 0)
								(mode_tile "ML_popup" 0)
								(mode_tile "MM_popup" 0)
								(mode_tile "MR_popup" 0)
								(mode_tile "BL_popup" 0)
								(mode_tile "BM_popup" 0)
								(mode_tile "BR_popup" 0)
								(start_list "TL_popup" 3)
								(mapcar (quote add_list) Tlst)
								(end_list)
								(start_list "TM_popup" 3)
								(mapcar (quote add_list) Tlst)
								(end_list)
								(start_list "ML_popup" 3)
								(mapcar (quote add_list) Tlst)
								(end_list)
								(start_list "MM_popup" 3)
								(mapcar (quote add_list) Tlst)
								(end_list)
								(mode_tile "TR_popup" 1)
								(mode_tile "MR_popup" 1)
								(mode_tile "BL_popup" 1)
								(mode_tile "BM_popup" 1)
								(mode_tile "BR_popup" 1)
							)
							((= Act 3)
								(mode_tile "TL_popup" 0)
								(mode_tile "TM_popup" 0)
								(mode_tile "TR_popup" 0)
								(mode_tile "ML_popup" 0)
								(mode_tile "MM_popup" 0)
								(mode_tile "MR_popup" 0)
								(mode_tile "BL_popup" 0)
								(mode_tile "BM_popup" 0)
								(mode_tile "BR_popup" 0)
								(start_list "TL_popup" 3)
								(mapcar (quote add_list) Tlst)
								(end_list)
								(start_list "TM_popup" 3)
								(mapcar (quote add_list) Tlst)
								(end_list)
								(start_list "TR_popup" 3)
								(mapcar (quote add_list) Tlst)
								(end_list)
								(start_list "ML_popup" 3)
								(mapcar (quote add_list) Tlst)
								(end_list)
								(start_list "MM_popup" 3)
								(mapcar (quote add_list) Tlst)
								(end_list)
								(start_list "MR_popup" 3)
								(mapcar (quote add_list) Tlst)
								(end_list)
								(start_list "BL_popup" 3)
								(mapcar (quote add_list) Tlst)
								(end_list)
								(start_list "BM_popup" 3)
								(mapcar (quote add_list) Tlst)
								(end_list)
								(start_list "BR_popup" 3)
								(mapcar (quote add_list) Tlst)
								(end_list)
							)
					)
					(cb_Tst_OK Act)
					(action_tile "TL_popup" "(setq ALst (cb_TL_popup Act ALst))")
					(action_tile "TM_popup" "(setq ALst (cb_TM_popup Act ALst))")
					(action_tile "TR_popup" "(setq ALst (cb_TR_popup Act ALst))")
					(action_tile "ML_popup" "(setq ALst (cb_ML_popup Act ALst))")
					(action_tile "MM_popup" "(setq ALst (cb_MM_popup Act ALst))")
					(action_tile "MR_popup" "(setq ALst (cb_MR_popup Act ALst))")
					(action_tile "BL_popup" "(setq ALst (cb_BL_popup Act ALst))")
					(action_tile "BM_popup" "(setq ALst (cb_BM_popup Act ALst))")
					(action_tile "BR_popup" "(setq ALst (cb_BR_popup Act ALst))")
					(action_tile "ok_button" "(done_dialog 1)")
					(action_tile "cancel_button" "(done_dialog 0)")
					(setq dlg (start_dialog))
					(unload_dialog dcl_sym)
					)
				(alert "\nUnable to open DCL file")
			)
			(alert "\nUnable to find DCL file")
		)
		(alert "\nAction must be 1,2 or 3!")
	)
	(setq	Cnt		0)
	(repeat (length Alst)
		(setq	Alst	(RepLst Alst (nth (atoi (nth Cnt Alst)) Tlst) Cnt)
				Cnt		(1+ Cnt)
		)
	)
	(if (= dlg 1)
		ALst
		nil
	)
)

(defun C:PhSym ( /	AttRq CLay TempLst			; Phase Symbols
				LayNam Ph_Siz Irot Ph_Lst INam Blk TxtLay Well )
	(if Bug (princ "\n{PhSym entered!"))
	(setvar "GRIPS" 0)
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
	(setq	AttRq	(getvar "ATTREQ")
			CLay		(getvar "CLAYER")
			TempLst	(PicCkt)
	)
	(if TempLst
		(setq	TxtLay	(MKLAY (strcat (substr (nth 2 TempLst) 1 4) "CPD" (substr (nth 2 TempLst) 8)))
				LayNam	(MKLay (strcat (substr (nth 2 TempLst) 1 4) "CP-" (substr (nth 2 TempLst) 8)))
				Bubba	(command "_.Layer" "C" "2" TxtLay "")
				Ph_siz	(nth 2 (last TempLst))
				Irot		(angle (nth 4 TempLst) (nth 5 TempLst))
		)
		(progn
			(alert (strcat "\n**" AppNam " Error\nObject not selected!"))
			(exit)
		)
	)
	(while (> Irot (* 2.0 pi))
		(setq	Irot		(- Irot (* 2.0 pi)))
	)
	(while (< Irot 0.0)
		(setq	Irot		(+ Irot (* 2.0 pi)))
	)
	(if (and (>= Irot (/ pi 2.0)) (<= Irot (/ (* pi 3.0) 2.0))) 		; 90-270
		(setq	Irot		(- Irot pi))
	)
	(setq	Irot		(+ Irot (/ pi 2.0)))
	(if (and bug Ph_Siz LayNam)
		(progn
			(princ (strcat "\nPh_siz: " Ph_Siz))
			(princ (strcat "\nLaynam: " LayNam))
			(princ (strcat "\nIrot: " (rtos (rtd Irot) 2 4)))
		)
	    (if (and bug LayNam)
			(princ (strcat "\nLaynam (only): " LayNam))
	    )
	)
	(cond	((member (atoi Ph_Siz) (list 0))
				(setq	Ph_Lst	(Load_TPH 3)
						INam		(Ph_Tst Ph_Lst)
				)
				(if Ph_Lst
					(setq	Ph_Lst	(append (list INam) Ph_Lst))
					(princ "\nPhase Description cancelled")
				)
			)
			((member (atoi Ph_Siz) (list 1 2 3))
				(setq	Ph_Lst	(Load_TPH 2)
						INam		(Ph_Tst Ph_Lst)
				)
				(if Ph_Lst
					(setq	Ph_Lst	(append (list INam) (list (nth 4 Ph_Lst)(nth 1 Ph_Lst)(nth 3 Ph_Lst)(nth 0 Ph_Lst))))
					(princ "\nPhase Description cancelled")
				)
			)
			((member (atoi Ph_Siz) (list 4 5 6))
				(setq	Ph_Lst	(Load_TPH 1)
						INam		(Ph_Tst Ph_Lst)
				)
				(if Ph_Lst
					(setq	Ph_Lst	(append (list INam) (list (car Ph_Lst))))
					(princ "\nPhase Description cancelled")
				)
			)
	)
	(if Ph_Lst
		(progn
			(setvar "ATTREQ" 0)
			(command	"INSERT"
					INam
					(list 0.0 0.0)
					(* SF 0.1)
					""
					(rtd Irot)
			)
			(if Bug (princ "\nGot it inserted!"))
			(setq	Blk		(PopRAtt Ph_Lst))
			(princ "\nPick location for insertion.")
			(command "_.MOVE" Blk "" (list 0.0 0.0) pause)
			(Att-Chg-Lay)
			(initget "Yes No")
			(setq	Well		(getkword "\nFlip Phase Descriptor? <No> Yes: "))
			(if Well
				(if (= (strcase Well) "YES")
					(command "_.Rotate" Blk "" "@0,0" "180")
				)
			)
			(setvar "ATTREQ" AttRq)
		)
	)
	(setvar "CLAYER" CLay)
	(setvar "GRIPS" 1)
	(if Bug (princ "\nPhSym exited!}\n"))
	(princ)
)

(defun Ph_Tst ( Ph_Lst / )					; Decides which symbol represents the Phases selected on the Dialogue box
	(cond
		((or
			(and
				(/= (nth 0 Ph_Lst) (chr 32))
				(/= (nth 3 Ph_Lst) (chr 32))
				(/= (nth 6 Ph_Lst) (chr 32))
			)
			(and
				(/= (nth 1 Ph_Lst) (chr 32))
				(/= (nth 4 Ph_Lst) (chr 32))
				(/= (nth 7 Ph_Lst) (chr 32))
			)
			(and
				(/= (nth 2 Ph_Lst) (chr 32))
				(/= (nth 5 Ph_Lst) (chr 32))
				(/= (nth 8 Ph_Lst) (chr 32))
			)
		 )
			(strcat _Path-Sym "083V")
		)
		((or
			(and
				(/= (nth 0 Ph_Lst) (chr 32))
				(/= (nth 1 Ph_Lst) (chr 32))
				(/= (nth 2 Ph_Lst) (chr 32))
			)
			(and
				(/= (nth 3 Ph_Lst) (chr 32))
				(/= (nth 4 Ph_Lst) (chr 32))
				(/= (nth 5 Ph_Lst) (chr 32))
			)
			(and
				(/= (nth 6 Ph_Lst) (chr 32))
				(/= (nth 7 Ph_Lst) (chr 32))
				(/= (nth 8 Ph_Lst) (chr 32))
			)
		 )
			(strcat _Path-Sym "083H")
		)
		((or
				(/= (nth 2 Ph_Lst) (chr 32))
				(/= (nth 5 Ph_Lst) (chr 32))
				(/= (nth 6 Ph_Lst) (chr 32))
				(/= (nth 7 Ph_Lst) (chr 32))
				(/= (nth 8 Ph_Lst) (chr 32))
		 )
			(strcat _Path-Sym "083")
		)
		((or
			(and
				(/= (nth 0 Ph_Lst) (chr 32))
				(/= (nth 3 Ph_Lst) (chr 32))
			)
			(and
				(/= (nth 1 Ph_Lst) (chr 32))
				(/= (nth 4 Ph_Lst) (chr 32))
			)
			(and
				(/= (nth 2 Ph_Lst) (chr 32))
				(/= (nth 5 Ph_Lst) (chr 32))
			)
		 )
			(strcat _Path-Sym "082V")
		)
		((or
			(and
				(/= (nth 0 Ph_Lst) (chr 32))
				(/= (nth 1 Ph_Lst) (chr 32))
			)
			(and
				(/= (nth 3 Ph_Lst) (chr 32))
				(/= (nth 4 Ph_Lst) (chr 32))
			)
			(and
				(/= (nth 6 Ph_Lst) (chr 32))
				(/= (nth 7 Ph_Lst) (chr 32))
			)
		 )
			(strcat _Path-Sym "082H")
		)
		((or
				(/= (nth 1 Ph_Lst) (chr 32))
				(/= (nth 3 Ph_Lst) (chr 32))
				(/= (nth 4 Ph_Lst) (chr 32))
		 )
			(strcat _Path-Sym "082")
		)
		((/= (nth 0 Ph_Lst) (chr 32))
			(strcat _Path-Sym "081")
		)
		(T
			nil
		)
	)
)

(defun BlockLst ( /	InData TstSS Blklst		; Smart Block Tester
					Cntlst BlkNam OutLst Cnt Blk OrgLst ModLst ModNam devlst)
	(setq	BlkLst	(list "000")
			CntLst	(list 0)
			InData	(tblnext "BLOCK" T)
			devlst	(list "")
	)
	(if (= (strlen (setq BlkNam (cdr (assoc 2 InData)))) 3)
		(if (and (>= (ascii BlkNam) 48) (<= (ascii BlkNam) 57))
			(if (setq	TstSS (ssget "X" (list (cons 0 "INSERT")(cons 2 BlkNam))))
				(setq	BlkLst	(append BlkLst (list BlkNam))
						CntLst	(append CntLst (list (sslength TstSS)))
				)
			)
		)
	)
	(while (setq InData (tblnext "BLOCK"))
		(if (= (strlen (setq BlkNam (cdr (assoc 2 InData)))) 3)
			(if (and (>= (ascii BlkNam) 48) (<= (ascii BlkNam) 57))
				(if (setq	TstSS (ssget "X" (list (cons 0 "INSERT")(cons 2 BlkNam))))
					(setq	BlkLst	(append BlkLst (list BlkNam))
							CntLst	(append CntLst (list (sslength TstSS)))
					)
				)
			)
		)
	)
	(if (> (length BlkLst) 1)
		(progn
			(setq	Cnt		0
					ModNam	(list	"D"  ; "Draw  "
									"E"	; "Exist "
									"I"	; "Insert"
									"C"	; "Change"
									"R"	; "Remove"
							)
					ModLst	(mapcar	(quote	(lambda (x)
												(cond	((= (substr x 1 1) "0")
															1
														)
														((= (substr x 1 1) "9")
															1
														)
														((= (substr x 1 1) "1")
															1
														)
														((= (substr x 1 1) "3")
															2
														)
														((= (substr x 1 1) "7")
															3
														)
														((= (substr x 1 1) "5")
															4
														)
												)
											 )
									)
									 BlkLst
							)
					OrgLst	(cdr BlkLst)
					BlkLst	(mapcar	(quote	(lambda (x)
												(if (or (= (substr x 1 1) "0") (= (substr x 1 1) "1"))
													x
													(strcat "1" (substr x 2 2))
												)
											 )
									)
									 BlkLst
							)
					BlkLst	(cdr BlkLst)
					ModLst	(cdr ModLst)
					CntLst	(cdr CntLst)
			)
			(foreach	Blk
					BlkLst
					(if Bug
						(if (nth Cnt CntLst)
							(princ (strcat "\nFound Block:" Blk " Qty:" (itoa (nth Cnt CntLst))))
							(princ (strcat "\nFound Block:" Blk))
						)
					)
					(if (member Blk Lst_Sp_Sn)
						(if (nth Cnt CntLst)
							(if (setq Pos (- (length Lst_Sp_Sn) (length (member Blk Lst_Sp_Sn))))
								(princ	(strcat	"\nDevice Name: "
												(nth Cnt OrgLst)
												" Type: "
												(PadChar (nth Pos Lst_Sp_Oc) 8)
;												" Qty:"
;												(PadCharL (itoa (nth Cnt CntLst)) 3)
												" Mode: "
												(nth (nth Cnt ModLst) ModNam)
												" Desc:"
												(nth Pos Lst_Sp_Dn)
										)
								)
							)
						)
					)
					(setq	Cnt	(1+ Cnt))
			)
			(progn
				(setq	OutLst	(list OrgLst BlkLst ModLst CntLst))
 			)
		)
		(setq	OutLst	nil)
	)
	(princ "\n")
	OutLst
)

(defun C:BlkLegend ( /	GetLst Cnt OrgLst		; Smart Legend Block Creation
					BlkLst ModLst CntLst Mod ExtLst InsStr InsLst ExtStr
					LayGo VisLayLst NoVisLayLst ViewGo
					ChgStr ChgLst RemStr RemLst MinP MaxP WorkP extlst devlst ss new_blk_name)
	(setq	LayGo		(LayWhat)
			VisLayLst		(nth 0 LayGo)
			NoVisLayLst	(nth 1 LayGo)
			LayGo		(getvar "CLAYER")
			ViewGo		(GetStorDate)
			Bubba		(command "_.View" "S" ViewGo)
	)																		;Writes device no., dwg path, dwg no, dwf path, dwf no, title block info,
	(command "_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" "" "_.Zoom" "E")					;date/time, login name to database
	(updte)
	(command)
	(setq oldlay (getvar "CLAYER"))
	(if (and (not (null (tblsearch "BLOCK" "092"))) (null (tblsearch "BLOCK" "391")))
			(command "_.rename" "b" "092" "391")
			(progn
				(setq ss (ssget "X" (list (cons 2 "092")))
					 new_blk_name "391"
				)
				(if ss
					(progn
						(Cbx ss new_blk_name)
						(command "_.purge" "b" "092" "n")
					)
				)
			)
			
	)
	(if ss
		(setq ss nil
			 Bubba (gc)
		)
	)
	(command)
	(if (and (not (null (tblsearch "BLOCK" "091"))) (null (tblsearch "BLOCK" "191")))
			(command "_.rename" "b" "091" "191")
			(progn
				(setq ss (ssget "X" (list (cons 2 "091")))
				      new_blk_name "191"
				)
				(if ss
					(progn
						(Cbx ss new_blk_name)
						(command "_.purge" "b" "091" "n")
					)
				)
			)
			
	)
	(if ss
		(setq ss nil
			 Bubba (gc)
		)
	)
	(command)
	(command "_.osnap" "none")
	(if (LayChk "BOM")
		(progn
			(command "_.LAYER" "S" "BOM" "LT" "CONTINUOUS" "BOM" "" "ZOOM" "E" "LINETYPE" "S" "BYLAYER" "")
			(if (setq	SSI (ssget "X" (list (cons 8 "BOM"))))
				(progn
					(command "_.ERASE" SSI "" "_.ZOOM" "E")
					(setq SSI nil
						 Bubba (gc)
					)
				)
			)
		)
		(command "_.LAYER" "M" "BOM" "LT" "CONTINUOUS" "BOM" "" "ZOOM" "E" "LINETYPE" "S" "BYLAYER" "")
	)
	(command)
	(setq	GetLst	(BlockLst)
			MinP		(getvar "EXTMIN")
			MaxP		(getvar "EXTMAX")
			WorkP	(list	(+ (car MaxP) (* SF 0.50))
							(cadr MinP)
							0.0
					)
			ExtOut	nil
			InsOut	nil
			ChgOut	nil
			RemOut	nil
	)
	(if GetLst
		(setq	OrgLst	(nth 0 GetLSt)
				BlkLst	(nth 1 GetLSt)
				ModLst	(nth 2 GetLSt)
				CntLst	(nth 3 GetLSt)
				Cnt		0
		)
	)
	(foreach	Mod
			ModLst
			(setq	Pos	(- (length Lst_Sp_Sn) (length (member (nth Cnt BlkLst) Lst_Sp_Sn))))
			(cond
				((= Mod 1)
					(if ExtLst
						(setq	ExtStr	(append ExtStr (list (nth Pos Lst_Sp_Dn)))
								ExtLst	(append ExtLst (list	(cons	(nth Pos Lst_Sp_Dn)
																	(list	Pos
																			(nth Cnt OrgLst)
																	(nth pos lst_sp_oc))
															)
													)
										)
						)
						(setq	ExtStr	(list (nth Pos Lst_Sp_Dn))
								ExtLst	(list	(cons	(nth Pos Lst_Sp_Dn)
														(list	Pos
																(nth Cnt OrgLst)
														(nth pos lst_Sp_Oc))
												)
										)
						)
					)
				)
				((= Mod 2)
					(if InsLst
						(setq	InsStr	(append InsStr (list (nth Pos Lst_Sp_Dn)))
								InsLst	(append InsLst (list	(cons	(nth Pos Lst_Sp_Dn)
																	(list	Pos
																			(nth Cnt OrgLst)
																	(nth pos lst_Sp_Oc))
															)
													)
										)
						)
						(setq	InsStr	(list (nth Pos Lst_Sp_Dn))
								InsLst	(list	(cons	(nth Pos Lst_Sp_Dn)
														(list	Pos
																(nth Cnt OrgLst)
														(nth pos Lst_Sp_Oc))
												)
										)
						)
					)
				)
				((= Mod 3)
					(if ChgLst
						(setq	ChgStr	(append ChgStr (list (nth Pos Lst_Sp_Dn)))
								ChgLst	(append ChgLst (list	(cons	(nth Pos Lst_Sp_Dn)
																	(list	Pos
																			(nth Cnt OrgLst)
																	(nth pos Lst_Sp_Oc))
															)
													)
										)
						)
						(setq	ChgStr	(list (nth Pos Lst_Sp_Dn))
								ChgLst	(list	(cons	(nth Pos Lst_Sp_Dn)
														(list	Pos
																(nth Cnt OrgLst)
														(nth pos Lst_Sp_Oc))
												)
										)
						)
					)
				)
				((= Mod 4)
					(if RemLst
						(setq	RemStr	(append RemStr (list (nth Pos Lst_Sp_Dn)))
								RemLst	(append RemLst (list	(cons	(nth Pos Lst_Sp_Dn)
																	(list	Pos
																			(nth Cnt OrgLst)
																	(nth pos Lst_Sp_Oc))
															)
													)
										)
						)
						(setq	RemStr	(list (nth Pos Lst_Sp_Dn))
								RemLst	(list	(cons	(nth Pos Lst_Sp_Dn)
														(list	Pos
																(nth Cnt OrgLst)
														(nth pos Lst_Sp_Oc))
												)
										)
						)
					)
				)
			)
			(setq	Cnt	(1+ Cnt))
	)
	(if ExtStr
		(setq	EdsStr	ExtStr
				ExtStr	(reverse (acad_strlsort ExtStr))
		)
	)
	(if ExtStr
		(foreach	Str
				ExtStr
				(if ExtOut
					(setq	ExtOut	(append ExtOut (list (assoc Str ExtLst))))
					(setq	ExtOut	(list (assoc Str ExtLst)))
				)
		)
	)
	(if InsStr
		(setq	InsStr	(reverse (acad_strlsort InsStr))
				Bubba	(command "PAN" (list (- 0.0 (* SF 1.5)) 0.0) "")
		)
	)
	(if InsStr
		(foreach	Str
				InsStr
				(if InsOut
					(setq	InsOut	(append InsOut (list (assoc Str InsLst))))
					(setq	InsOut	(list (assoc Str InsLst)))
				)
		)
	)
	(if ChgStr
		(setq	ChgStr	(reverse (acad_strlsort ChgStr))
				Bubba	(command "PAN" (list (- 0.0 (* SF 1.5)) 0.0) "")
		)
	)
	(if ChgStr
		(foreach	Str
				ChgStr
				(if ChgOut
					(setq	ChgOut	(append ChgOut (list (assoc Str ChgLst))))
					(setq	ChgOut	(list (assoc Str ChgLst)))
				)
		)
	)
	(if RemStr
		(setq	RemStr	(reverse (acad_strlsort RemStr))
				Bubba	(command "PAN" (list (- 0.0 (* SF 1.5)) 0.0) "")
		)
	)
	(if RemStr
		(foreach	Str
				RemStr
				(if RemOut
					(setq	RemOut	(append RemOut (list (assoc Str RemLst))))
					(setq	RemOut	(list (assoc Str RemLst)))
				)
		)
	)
	(setq	BCnt		0
			AttR		(getvar "ATTREQ")
	)
	(if Bug (princ (strcat "\nCount: " (itoa BCnt))))
	(setvar "ATTREQ" 0)
	(setvar "PLINEWID" (* sf 0.015))
	(if ExtOut
		(foreach	ExtBlk
				ExtOut
				(setq	BCnt		(- (length ExtStr) (length (member (nth 0 ExtBlk) ExtStr))))
				(command	"_.PLINE"
						(list	(car WorkP)
								(+ (cadr WorkP) (* BCnt (* SF 0.5)))
						)
						(list	(+ (car WorkP) (* SF 1.5))
								(+ (cadr WorkP) (* BCnt (* SF 0.5)))
						)
						(list	(+ (car WorkP) (* SF 1.5))
								(+ (cadr WorkP) (* (1+ BCnt) (* SF 0.5)))
						)
						(list	(car WorkP)
								(+ (cadr WorkP) (* (1+ BCnt) (* SF 0.5)))
						)
						"C"
				)
				(setq	BlkStuff	(BlkDefExt (nth 2 ExtBlk))
						BlkX		(* (- (nth 2 BlkStuff) (nth 0 BlkStuff)) SF (nth (nth 1 ExtBlk) Lst_Sp_SS))
						BlkY		(* (- (nth 3 BlkStuff) (nth 1 BlkStuff)) SF (nth (nth 1 ExtBlk) Lst_Sp_SS))
						BlkC		(list	(+ (/ (- (nth 2 BlkStuff) (nth 0 BlkStuff)) 2.0) (nth 0 BlkStuff))
										(+ (/ (- (nth 3 BlkStuff) (nth 1 BlkStuff)) 2.0) (nth 1 BlkStuff))
										0.0
								)
				)
				(cond	((= (nth 5 BlkStuff) 0)
							(setq	AttLst	nil)
						)
						((= (nth 5 BlkStuff) 1)
							(setq	AttLst	(list "" ""))
						)
						((= (nth 5 BlkStuff) 2)
							(setq	AttLst	(list "" "" ""))
						)
						((= (nth 5 BlkStuff) 3)
							(setq	AttLst	(list "" "" "" ""))
						)
						((= (nth 5 BlkStuff) 4)
							(setq	AttLst	(list "" "" "" "" ""))
						)
						((= (nth 5 BlkStuff) 5)
							(setq	AttLst	(list "" "" "" "" "" ""))
						)
						((= (nth 5 BlkStuff) 6)
							(setq	AttLst	(list "" "" "" "" "" "" ""))
						)
						((= (nth 5 BlkStuff) 7)
							(setq	AttLst	(list "" "" "" "" "" "" "" ""))
						)
						((= (nth 5 BlkStuff) 8)
							(setq	AttLst	(list "" "" "" "" "" "" "" "" ""))
						)
				)
				(if (equal BlkC (nth 4 BlkStuff) 0.001)
					(setq	BlkCX	0.0
							BlkCY	0.0
							Bubba	(if Bug (princ (strcat "\nBlock " (nth 2 ExtBlk) " BlkX: " (rtos BlkX 2 4) " BlkY: " (rtos BlkY 2 4))))
					)
					(setq	BlkCX	(- (car (nth 4 BlkStuff)) (car BlkC))
							BlkCY	(- (cadr (nth 4 BlkStuff)) (cadr BlkC))
							Bubba	(if Bug (princ (strcat "\nBlock " (nth 2 ExtBlk) " BlkX: " (rtos BlkX 2 4) " BlkY: " (rtos BlkY 2 4) " Offx: " (rtos BlkCX 2 4) " Offy: " (rtos BlkCY 2 4))))
					)
				)
				(if	(and	(< BlkX (* SF 0.45))
						(< BlkY (* SF 0.45))
					)
					(setq	BlkIns	(* SF (nth (nth 1 ExtBlk) Lst_Sp_SS))
							BlkPer	nil
					)
					(if (< (/ BlkX (* SF 0.45)) (/ BlkY (* SF 0.45)))
						(if (<= (/ (* SF 0.45) BlkX) 1.0)
							(setq	BlkPer	(/ (* SF 0.45) BlkX)
									BlkIns	(* BlkPer SF (nth (nth 1 ExtBlk) Lst_Sp_SS))
							)
							(setq	BlkPer	(/ BlkX (* SF 0.45))
									BlkIns	(* BlkPer SF (nth (nth 1 ExtBlk) Lst_Sp_SS))
							)
						)
						(if (<= (/ (* SF 0.45) BlkY) 1.0)
							(setq	BlkPer	(/ (* SF 0.45) BlkY)
									BlkIns	(* BlkPer SF (nth (nth 1 ExtBlk) Lst_Sp_SS))
							)
							(setq	BlkPer	(/ BlkY (* SF 0.45))
									BlkIns	(* BlkPer SF (nth (nth 1 ExtBlk) Lst_Sp_SS))
							)
						)
					)
				)
				(if Bug (princ (strcat "\nBlkIns: " (rtos BlkIns 2 4))))
				(command	"_.INSERT"
						(nth 2 ExtBlk)
						(list	(+ (car WorkP) (* SF 0.25) (* BlkIns BlkCX))
								(+ (cadr WorkP) (* BCnt (* SF 0.5)) (* SF 0.25) (* BlkIns BlkCY))
						)
						BlkIns
						BlkIns
						0.0
				)
				(if (and AttLst Bug) (princ (strcat "\nBlock " (nth 2 ExtBlk) " has " (itoa (length AttLst)) " attributes.")))
				(if AttLst
					(PopAtt AttLst)
				)
				(command	"_.TEXT"
						"S"
						"STANDARD"
						"J"
						"ML"
						(list	(+ (car WorkP) (* SF 0.50))
								(+ (cadr WorkP) (* BCnt (* SF 0.5)) (* SF 0.40))
						)
						(* SF 0.08)
						0.0
						"Mode:Existing"
				)
				(command	"_.TEXT"
						"S"
						"STANDARD"
						"J"
						"ML"
						(list	(+ (car WorkP) (* SF 0.50))
								(+ (cadr WorkP) (* BCnt (* SF 0.5)) (* SF 0.25))
						)
						(* SF 0.08)
						0.0
						(nth 3 Extblk)
				)
				(command	"_.TEXT"
						"S"
						"STANDARD"
						"J"
						"f"
						(list	(+ (car WorkP) (* SF 0.50))
								(+ (cadr WorkP) (* BCnt (* SF 0.5)) (* SF 0.10) (* SF -0.04))
						)
						(list	(+ (car WorkP) (* SF 1.45))
								(+ (cadr WorkP) (* BCnt (* SF 0.5)) (* SF 0.10) (* SF -0.04))
						)
						(* SF 0.08)
						(nth 0 ExtBlk)
				)
				(setq	BCnt		(+ 1 BCnt))
				(if Bug (princ (strcat "\nCount: " (itoa BCnt))))
		)
	)
	(if InsOut
		(foreach	InsBlk
				InsOut
				(setq	BCnt		(- (length InsStr) (length (member (nth 0 InsBlk) InsStr))))
				(cond	((null ExtOut)
							(setq	WorkPI	WorkP)
						)
						(T
							(setq	WorkPI	(list	(+ (car WorkP) (* SF 1.5))
													(cadr WorkP)
											)
							)
						)
				)
				(command	"_.PLINE"
						(list	(car WorkPI)
								(+ (cadr WorkPI) (* BCnt (* SF 0.5)))
						)
						(list	(+ (car WorkPI) (* SF 1.5))
								(+ (cadr WorkPI) (* BCnt (* SF 0.5)))
						)
						(list	(+ (car WorkPI) (* SF 1.5))
								(+ (cadr WorkPI) (* (1+ BCnt) (* SF 0.5)))
						)
						(list	(car WorkPI)
								(+ (cadr WorkPI) (* (1+ BCnt) (* SF 0.5)))
						)
						"C"
				)
				(setq	BlkStuff	(BlkDefExt (nth 2 InsBlk))
						BlkX		(* (- (nth 2 BlkStuff) (nth 0 BlkStuff)) SF (nth (nth 1 InsBlk) Lst_Sp_SS))
						BlkY		(* (- (nth 3 BlkStuff) (nth 1 BlkStuff)) SF (nth (nth 1 InsBlk) Lst_Sp_SS))
						BlkC		(list	(+ (/ (- (nth 2 BlkStuff) (nth 0 BlkStuff)) 2.0) (nth 0 BlkStuff))
										(+ (/ (- (nth 3 BlkStuff) (nth 1 BlkStuff)) 2.0) (nth 1 BlkStuff))
										0.0
								)
				)
				(cond	((= (nth 5 BlkStuff) 0)
							(setq	AttLst	nil)
						)
						((= (nth 5 BlkStuff) 1)
							(setq	AttLst	(list "" ""))
						)
						((= (nth 5 BlkStuff) 2)
							(setq	AttLst	(list "" "" ""))
						)
						((= (nth 5 BlkStuff) 3)
							(setq	AttLst	(list "" "" "" ""))
						)
						((= (nth 5 BlkStuff) 4)
							(setq	AttLst	(list "" "" "" "" ""))
						)
						((= (nth 5 BlkStuff) 5)
							(setq	AttLst	(list "" "" "" "" "" ""))
						)
						((= (nth 5 BlkStuff) 6)
							(setq	AttLst	(list "" "" "" "" "" "" ""))
						)
						((= (nth 5 BlkStuff) 7)
							(setq	AttLst	(list "" "" "" "" "" "" "" ""))
						)
						((= (nth 5 BlkStuff) 8)
							(setq	AttLst	(list "" "" "" "" "" "" "" "" ""))
						)
				)
				(if (equal BlkC (nth 4 BlkStuff) 0.001)
					(setq	BlkCX	0.0
							BlkCY	0.0
							Bubba	(if Bug (princ (strcat "\nBlock " (nth 2 InsBlk) " BlkX: " (rtos BlkX 2 4) " BlkY: " (rtos BlkY 2 4))))
					)
					(setq	BlkCX	(- (car (nth 4 BlkStuff)) (car BlkC))
							BlkCY	(- (cadr (nth 4 BlkStuff)) (cadr BlkC))
							Bubba	(if Bug (princ (strcat "\nBlock " (nth 2 InsBlk) " BlkX: " (rtos BlkX 2 4) " BlkY: " (rtos BlkY 2 4) " Offx: " (rtos BlkCX 2 4) " Offy: " (rtos BlkCY 2 4))))
					)
				)
				(if	(and	(< BlkX (* SF 0.45))
						(< BlkY (* SF 0.45))
					)
					(setq	BlkIns	(* SF (nth (nth 1 InsBlk) Lst_Sp_SS))
							BlkPer	nil
					)
					(if (< (/ BlkX (* SF 0.45)) (/ BlkY (* SF 0.45)))
						(if (<= (/ (* SF 0.45) BlkX) 1.0)
							(setq	BlkPer	(/ (* SF 0.45) BlkX)
									BlkIns	(* BlkPer SF (nth (nth 1 InsBlk) Lst_Sp_SS))
							)
							(setq	BlkPer	(/ BlkX (* SF 0.45))
									BlkIns	(* BlkPer SF (nth (nth 1 InsBlk) Lst_Sp_SS))
							)
						)
						(if (<= (/ (* SF 0.45) BlkY) 1.0)
							(setq	BlkPer	(/ (* SF 0.45) BlkY)
									BlkIns	(* BlkPer SF (nth (nth 1 InsBlk) Lst_Sp_SS))
							)
							(setq	BlkPer	(/ BlkY (* SF 0.45))
									BlkIns	(* BlkPer SF (nth (nth 1 InsBlk) Lst_Sp_SS))
							)
						)
					)
				)
				(if Bug (princ (strcat "\nBlkIns: " (rtos BlkIns 2 4))))
				(command	"_.INSERT"
						(nth 2 InsBlk)
						(list	(+ (car WorkPI) (* SF 0.25) (* BlkIns BlkCX))
								(+ (cadr WorkPI) (* BCnt (* SF 0.5)) (* SF 0.25) (* BlkIns BlkCY))
						)
						BlkIns
						BlkIns
						0.0
				)
				(if (and AttLst Bug) (princ (strcat "\nBlock " (nth 2 InsBlk) " has " (itoa (length AttLst)) " attributes.")))
				(if AttLst
					(PopAtt AttLst)
				)
				(command	"_.TEXT"
						"S"
						"STANDARD"
						"J"
						"ML"
						(list	(+ (car WorkPI) (* SF 0.50))
								(+ (cadr WorkPI) (* BCnt (* SF 0.5)) (* SF 0.40))
						)
						(* SF 0.08)
						0.0
						"Mode:Install"
				)
				(command	"_.TEXT"
						"S"
						"STANDARD"
						"J"
						"ML"
						(list	(+ (car WorkPI) (* SF 0.50))
								(+ (cadr WorkPI) (* BCnt (* SF 0.5)) (* SF 0.25))
						)
						(* SF 0.08)
						0.0
						(nth 3 InsBlk)
				)
				(command	"_.TEXT"
						"S"
						"STANDARD"
						"J"
						"F"
						(list	(+ (car WorkPI) (* SF 0.50))
								(+ (cadr WorkPI) (* BCnt (* SF 0.5)) (* SF 0.1) (* SF -0.04))
						)
						(list	(+ (car WorkPI) (* SF 1.45))
								(+ (cadr WorkPI) (* BCnt (* SF 0.5)) (* SF 0.1) (* SF -0.04))
						)
						(* SF 0.08)
						(nth 0 insblk)
				)
				(setq	BCnt		(+ 1 BCnt))
				(if Bug (princ (strcat "\nCount: " (itoa BCnt))))
		)
	)
	(if ChgOut
		(foreach	ChgBlk
				ChgOut
				(setq	BCnt		(- (length ChgStr) (length (member (nth 0 ChgBlk) ChgStr))))
				(cond	((and ExtOut InsOut)
							(setq	WorkPC	(list	(+ (car WorkP) (* SF 3.0))
													(cadr WorkP)
											)
							)
						)
						((or ExtOut InsOut)
							(setq	WorkPC	(list	(+ (car WorkP) (* SF 1.5))
													(cadr WorkP)
											)
							)
						)
						((and (null ExtOut) (null InsOut))
							(setq	WorkPC	WorkP)
						)
				)
				(command	"_.PLINE"
						(list	(car WorkPC)
								(+ (cadr WorkPC) (* BCnt (* SF 0.5)))
						)
						(list	(+ (car WorkPC) (* SF 1.5))
								(+ (cadr WorkPC) (* BCnt (* SF 0.5)))
						)
						(list	(+ (car WorkPC) (* SF 1.5))
								(+ (cadr WorkPC) (* (1+ BCnt) (* SF 0.5)))
						)
						(list	(car WorkPC)
								(+ (cadr WorkPC) (* (1+ BCnt) (* SF 0.5)))
						)
						"C"
				)
				(setq	BlkStuff	(BlkDefExt (nth 2 ChgBlk))
						BlkX		(* (- (nth 2 BlkStuff) (nth 0 BlkStuff)) SF (nth (nth 1 ChgBlk) Lst_Sp_SS))
						BlkY		(* (- (nth 3 BlkStuff) (nth 1 BlkStuff)) SF (nth (nth 1 ChgBlk) Lst_Sp_SS))
						BlkC		(list	(+ (/ (- (nth 2 BlkStuff) (nth 0 BlkStuff)) 2.0) (nth 0 BlkStuff))
										(+ (/ (- (nth 3 BlkStuff) (nth 1 BlkStuff)) 2.0) (nth 1 BlkStuff))
										0.0
								)
				)
				(cond	((= (nth 5 BlkStuff) 0)
							(setq	AttLst	nil)
						)
						((= (nth 5 BlkStuff) 1)
							(setq	AttLst	(list "" ""))
						)
						((= (nth 5 BlkStuff) 2)
							(setq	AttLst	(list "" "" ""))
						)
						((= (nth 5 BlkStuff) 3)
							(setq	AttLst	(list "" "" "" ""))
						)
						((= (nth 5 BlkStuff) 4)
							(setq	AttLst	(list "" "" "" "" ""))
						)
						((= (nth 5 BlkStuff) 5)
							(setq	AttLst	(list "" "" "" "" "" ""))
						)
						((= (nth 5 BlkStuff) 6)
							(setq	AttLst	(list "" "" "" "" "" "" ""))
						)
						((= (nth 5 BlkStuff) 7)
							(setq	AttLst	(list "" "" "" "" "" "" "" ""))
						)
						((= (nth 5 BlkStuff) 8)
							(setq	AttLst	(list "" "" "" "" "" "" "" "" ""))
						)
				)
				(if (equal BlkC (nth 4 BlkStuff) 0.001)
					(setq	BlkCX	0.0
							BlkCY	0.0
							Bubba	(if Bug (princ (strcat "\nBlock " (nth 2 ChgBlk) " BlkX: " (rtos BlkX 2 4) " BlkY: " (rtos BlkY 2 4))))
					)
					(setq	BlkCX	(- (car (nth 4 BlkStuff)) (car BlkC))
							BlkCY	(- (cadr (nth 4 BlkStuff)) (cadr BlkC))
							Bubba	(if Bug (princ (strcat "\nBlock " (nth 2 ChgBlk) " BlkX: " (rtos BlkX 2 4) " BlkY: " (rtos BlkY 2 4) " Offx: " (rtos BlkCX 2 4) " Offy: " (rtos BlkCY 2 4))))
					)
				)
				(if	(and	(< BlkX (* SF 0.45))
						(< BlkY (* SF 0.45))
					)
					(setq	BlkIns	(* SF (nth (nth 1 ChgBlk) Lst_Sp_SS))
							BlkPer	nil
					)
					(if (< (/ BlkX (* SF 0.45)) (/ BlkY (* SF 0.45)))
						(if (<= (/ (* SF 0.45) BlkX) 1.0)
							(setq	BlkPer	(/ (* SF 0.45) BlkX)
									BlkIns	(* BlkPer SF (nth (nth 1 ChgBlk) Lst_Sp_SS))
							)
							(setq	BlkPer	(/ BlkX (* SF 0.45))
									BlkIns	(* BlkPer SF (nth (nth 1 ChgBlk) Lst_Sp_SS))
							)
						)
						(if (<= (/ (* SF 0.45) BlkY) 1.0)
							(setq	BlkPer	(/ (* SF 0.45) BlkY)
									BlkIns	(* BlkPer SF (nth (nth 1 ChgBlk) Lst_Sp_SS))
							)
							(setq	BlkPer	(/ BlkY (* SF 0.45))
									BlkIns	(* BlkPer SF (nth (nth 1 ChgBlk) Lst_Sp_SS))
							)
						)
					)
				)
				(if Bug (princ (strcat "\nBlkIns: " (rtos BlkIns 2 4))))
				(command	"_.INSERT"
						(nth 2 ChgBlk)
						(list	(+ (car WorkPC) (* SF 0.25) (* BlkIns BlkCX))
								(+ (cadr WorkPC) (* BCnt (* SF 0.5)) (* SF 0.25) (* BlkIns BlkCY))
						)
						BlkIns
						BlkIns
						0.0
				)
				(if (and AttLst Bug) (princ (strcat "\nBlock " (nth 2 ChgBlk) " has " (itoa (length AttLst)) " attributes.")))
				(if AttLst
					(PopAtt AttLst)
				)
				(command	"_.TEXT"
						"S"
						"STANDARD"
						"J"
						"ML"
						(list	(+ (car WorkPC) (* SF 0.50))
								(+ (cadr WorkPC) (* BCnt (* SF 0.5)) (* SF 0.40))
						)
						(* SF 0.08)
						0.0
						"Mode:Change"
				)
				(command	"_.TEXT"
						"S"
						"STANDARD"
						"J"
						"ML"
						(list	(+ (car WorkPC) (* SF 0.50))
								(+ (cadr WorkPC) (* BCnt (* SF 0.5)) (* SF 0.25))
						)
						(* SF 0.08)
						0.0
						(nth 3 ChgBlk)
				)
				(command	"_.TEXT"
						"S"
						"STANDARD"
						"J"
						"F"
						(list	(+ (car WorkPC) (* SF 0.50))
								(+ (cadr WorkPC) (* BCnt (* SF 0.5)) (* SF 0.1) (* SF -0.04))
						)
						(list	(+ (car WorkPC) (* SF 1.45))
								(+ (cadr WorkPC) (* BCnt (* SF 0.5)) (* SF 0.1) (* SF -0.04))
						)
						(* SF 0.08)
						(nth 0 chgblk)
				)
				(setq	BCnt		(+ 1 BCnt))
				(if Bug (princ (strcat "\nCount: " (itoa BCnt))))
		)
	)
	(if RemOut
		(foreach	RemBlk
				RemOut
				(setq	BCnt		(- (length RemStr) (length (member (nth 0 RemBlk) RemStr))))
				(cond	((and ExtOut InsOut ChgOut)
							(setq	WorkPR	(list	(+ (car WorkP) (* SF 4.5))
													(cadr WorkP)
											)
							)
						)
						((or	(and ExtOut InsOut)
							(and ExtOut ChgOut)
							(and InsOut ChgOut)
						 )
							(setq	WorkPR	(list	(+ (car WorkP) (* SF 3.0))
													(cadr WorkP)
											)
							)
						)
						((or ExtOut InsOut ChgOut)
							(setq	WorkPR	(list	(+ (car WorkP) (* SF 1.5))
													(cadr WorkP)
											)
							)
						)
						((and (null ExtOut) (null InsOut) (null ChgOut))
							(setq	WorkPR	WorkP)
						)
						(T
							(setq	WorkPR	(list	(+ (car WorkP) (* SF 4.5))
													(cadr WorkP)
											)
							)
						)
				)
				(command	"_.PLINE"
						(list	(car WorkPR)
								(+ (cadr WorkPR) (* BCnt (* SF 0.5)))
						)
						(list	(+ (car WorkPR) (* SF 1.5))
								(+ (cadr WorkPR) (* BCnt (* SF 0.5)))
						)
						(list	(+ (car WorkPR) (* SF 1.5))
								(+ (cadr WorkPR) (* (1+ BCnt) (* SF 0.5)))
						)
						(list	(car WorkPR)
								(+ (cadr WorkPR) (* (1+ BCnt) (* SF 0.5)))
						)
						"C"
				)
				(setq	BlkStuff	(BlkDefExt (nth 2 RemBlk))
						BlkX		(* (- (nth 2 BlkStuff) (nth 0 BlkStuff)) SF (nth (nth 1 RemBlk) Lst_Sp_SS))
						BlkY		(* (- (nth 3 BlkStuff) (nth 1 BlkStuff)) SF (nth (nth 1 RemBlk) Lst_Sp_SS))
						BlkC		(list	(+ (/ (- (nth 2 BlkStuff) (nth 0 BlkStuff)) 2.0) (nth 0 BlkStuff))
										(+ (/ (- (nth 3 BlkStuff) (nth 1 BlkStuff)) 2.0) (nth 1 BlkStuff))
										0.0
								)
				)
				(cond	((= (nth 5 BlkStuff) 0)
							(setq	AttLst	nil)
						)
						((= (nth 5 BlkStuff) 1)
							(setq	AttLst	(list "" ""))
						)
						((= (nth 5 BlkStuff) 2)
							(setq	AttLst	(list "" "" ""))
						)
						((= (nth 5 BlkStuff) 3)
							(setq	AttLst	(list "" "" "" ""))
						)
						((= (nth 5 BlkStuff) 4)
							(setq	AttLst	(list "" "" "" "" ""))
						)
						((= (nth 5 BlkStuff) 5)
							(setq	AttLst	(list "" "" "" "" "" ""))
						)
						((= (nth 5 BlkStuff) 6)
							(setq	AttLst	(list "" "" "" "" "" "" ""))
						)
						((= (nth 5 BlkStuff) 7)
							(setq	AttLst	(list "" "" "" "" "" "" "" ""))
						)
						((= (nth 5 BlkStuff) 8)
							(setq	AttLst	(list "" "" "" "" "" "" "" "" ""))
						)
				)
				(if (equal BlkC (nth 4 BlkStuff) 0.001)
					(setq	BlkCX	0.0
							BlkCY	0.0
							Bubba	(if Bug (princ (strcat "\nBlock " (nth 2 RemBlk) " BlkX: " (rtos BlkX 2 4) " BlkY: " (rtos BlkY 2 4))))
					)
					(setq	BlkCX	(- (car (nth 4 BlkStuff)) (car BlkC))
							BlkCY	(- (cadr (nth 4 BlkStuff)) (cadr BlkC))
							Bubba	(if Bug (princ (strcat "\nBlock " (nth 2 RemBlk) " BlkX: " (rtos BlkX 2 4) " BlkY: " (rtos BlkY 2 4) " Offx: " (rtos BlkCX 2 4) " Offy: " (rtos BlkCY 2 4))))
					)
				)
				(if	(and	(< BlkX (* SF 0.45))
						(< BlkY (* SF 0.45))
					)
					(setq	BlkIns	(* SF (nth (nth 1 RemBlk) Lst_Sp_SS))
							BlkPer	nil
					)
					(if (< (/ BlkX (* SF 0.45)) (/ BlkY (* SF 0.45)))
						(if (<= (/ (* SF 0.45) BlkX) 1.0)
							(setq	BlkPer	(/ (* SF 0.45) BlkX)
									BlkIns	(* BlkPer SF (nth (nth 1 RemBlk) Lst_Sp_SS))
							)
							(setq	BlkPer	(/ BlkX (* SF 0.45))
									BlkIns	(* BlkPer SF (nth (nth 1 RemBlk) Lst_Sp_SS))
							)
						)
						(if (<= (/ (* SF 0.45) BlkY) 1.0)
							(setq	BlkPer	(/ (* SF 0.45) BlkY)
									BlkIns	(* BlkPer SF (nth (nth 1 RemBlk) Lst_Sp_SS))
							)
							(setq	BlkPer	(/ BlkY (* SF 0.45))
									BlkIns	(* BlkPer SF (nth (nth 1 RemBlk) Lst_Sp_SS))
							)
						)
					)
				)
				(if Bug (princ (strcat "\nBlkIns: " (rtos BlkIns 2 4))))
				(command	"_.INSERT"
						(nth 2 RemBlk)
						(list	(+ (car WorkPR) (* SF 0.25) (* BlkIns BlkCX))
								(+ (cadr WorkPR) (* BCnt (* SF 0.5)) (* SF 0.25) (* BlkIns BlkCY))
						)
						BlkIns
						BlkIns
						0.0
				)
				(if (and AttLst Bug) (princ (strcat "\nBlock " (nth 2 RemBlk) " has " (itoa (length AttLst)) " attributes.")))
				(if AttLst
					(PopAtt AttLst)
				)
				(command	"_.TEXT"
						"S"
						"STANDARD"
						"J"
						"ML"
						(list	(+ (car WorkPR) (* SF 0.50))
								(+ (cadr WorkPR) (* BCnt (* SF 0.5)) (* SF 0.40))
						)
						(* SF 0.08)
						0.0
						"Mode:Remove"
				)
				(command	"_.TEXT"
						"S"
						"STANDARD"
						"J"
						"ML"
						(list	(+ (car WorkPR) (* SF 0.50))
								(+ (cadr WorkPR) (* BCnt (* SF 0.5)) (* SF 0.25))
						)
						(* SF 0.08)
						0.0
						(nth 3 RemBlk)
				)
				(command	"_.TEXT"
						"S"
						"STANDARD"
						"J"
						"F"
						(list	(+ (car WorkPR) (* SF 0.50))
								(+ (cadr WorkPR) (* BCnt (* SF 0.5)) (* SF 0.1) (* SF -0.04))
						)
						(list	(+ (car WorkPR) (* SF 1.45))
								(+ (cadr WorkPR) (* BCnt (* SF 0.5)) (* SF 0.1) (* SF -0.04))
						)
						(* SF 0.08)
						(nth 0 remblk)
				)
				(setq	BCnt		(+ 1 BCnt))
				(if Bug (princ (strcat "\nCount: " (itoa BCnt))))
		)
	)
	(command "_.View" "R" ViewGo)
	(command "_.View" "D" ViewGo)
	(if NoVisLayLst
		(setq	Bubba	(mapcar (quote (lambda (x) (if (>= (cdr x) 0) (if FLay (setq FLay (strcat FLay "," (car x))) (setq FLay (car x))) (if OLay (setq OLay (strcat OLay "," (car x))) (setq OLay (car x)))))) NoVisLayLst)
				Bubba	(if (and FLay OLay)
							(command "_.Layer" "S" LayGo "F" FLay "Off" OLay "")
							(if FLay
								(command "_.Layer" "S" LayGo "F" FLay "")
								(if OLay
									(command "_.Layer" "S" LayGo "Off" OLay "")
									(command "_.Layer" "S" LayGo "")
								)
							)
						)
		)
		(command "_.Layer" "S" LayGo "")
	)
	(setvar "PLINEWID" 0)
	(setvar "CLAYER" oldlay)
	(setvar "ATTREQ" AttR)
	(princ)
)

(defun C:BlkFirst ( / ssI )					; Pushs Inserts (Blocks) to top of DrawOrder
	(command "ZOOM" "E")
	(setq	ssI	(ssget "X" (list (cons 0 "INSERT"))))
	(if ssI
		(progn
			(command "DRAWORDER" ssI "" "F")
			(command "REGENALL")
		)
	)
	(princ)
)

(defun C:BlkLastFirst ( / ssI)
	(setq	ssI	(ssget "X" (list (cons 0 "INSERT"))))
	(if ssI
		(progn
			(command "DRAWORDER" ssI "" "F")
			(command "REGENALL")
		)
	)
)

(defun C:ChBlk ( / )						;CHanges block def
	(setq cb 1)
	(setq chblk_ss(ssget))
	(setq cb_len(sslength chblk_ss))
	(setq item(ssname chblk_ss 0))
	(setq ent(entget item))
	(setq sym_mode(substr (cdr (assoc 2 ent)) 1 1))
	(setq sym_typ(substr (cdr (assoc 8 ent)) 5 2))
		(if (= sym_typ "SW")
			(c:sw)
		)
		(if (= sym_typ "XF")
			(c:tran)
		)
		(if (= sym_typ "PA")
			(c:guy)
		)
		(if (= sym_typ "PS")
			(c:pole)
		)
		(if (= sym_typ "ME")
			(c:misc)
		)
		(if (= sym_typ "AN")
			(c:land)
		)
		(if (= sym_typ "VC")
			(c:cap)
		)

)

(defun ChgBlock ( / )						;CHanges block def
	(setq ctr 0)
		(repeat cb_len
			(setq item (ssname chblk_ss ctr))
			(setq ent (entget item))
			(setq ent (subst (cons 2 new_block) (assoc 2 ent) ent))
			(entmod ent)
			(setq ctr (+ ctr 1))
		)
	(setq cb 0)
)

(defun ChgDev ( Out /	PosOut Blk AttNam		; Changes Devices
					Ang AttLst AttVal OfffSet Ent Ppt1 LayNam Vpt1 Vpt2 Omod Ocol pnt1)
	(if (or (= (stpDot AppNam) "CADET20")(= (stpDot AppNam) "CADET"))
		(c:what_mode)						; Draws Service Lines on WE
	)
	(setq	PosOut	(-	(length Lst_Sp_Dn)
						(length (member (nth 0 OUT) Lst_Sp_Dn))
					)
	)
	(if DatLst
		(setq	Ent		(car (nth 0 DatLst))
				Ppt1		(nth 1 DatLst)
				LayNam	(nth 2 DatLst)
				Vpt1		(nth 4 DatLst)
				Vpt2		(nth 5 DatLst)
				Vpt1a	vpt1
				Vpt2a	vpt2
				Ang		(nth 8 DatLst)
		)
		(setq	LayNam	(getvar "CLAYER"))
	)
	(setq	AttRq	(getvar "ATTREQ")
			Ocol	(getvar "CECOLOR")
			Omod	(getvar "ORTHOMODE")
	)
	(setvar "ATTREQ" 0)
	(setvar "ORTHOMODE" 0)
	(setq new_block (nth PosOut Lst_Sp_Sn))
	(setq new_block (strcat sym_mode (substr new_block 2 2)))
	(if (not (tblsearch "BLOCK" new_block))
		(progn
			(setq get_block (strcat _path-sym new_block))
			(command "insert" get_block "0.0" "" "" "" "erase" "l" "")
		)
	)
	(chgblock)
)

(defun C:Sc2Back ( / ss item )				;Sends scanned image to back of draworder
	(if (setq ss (ssget "X" (list (cons 8 "SCAN"))))
		(progn
			(setq item (ssname ss 0))
			(command "draworder" item "" "BACK")
		)
	)
	(if ss
		(setq	ss		nil
				Bubba	(gc)
		)
	)
	(princ)
)

(setq	LodVer	"2.5.3y")
