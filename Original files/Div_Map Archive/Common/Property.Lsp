(if AppNam								; Code Version Indicator {3892 Lines of Code}
	(princ (strcat "\n" AppNam " Property Loading."))
	(princ "\nCadet 2.1 Property Loading.")
)

(defun C:DrwCkt ( / )						; Draw Primary Circuit
	(property 1)
	(princ)
)

(defun C:Query	( / )					; Query Circuit
	(if (and(/= Div "GA")(/= Div "AL"))
		(property 2)
		(QueryObject)
	)
	(princ)
)

(defun C:ChgProp ( / )						; Change Property
	(if (and (/= Div "GA") (/= Div "AL"))
		(property 3)
		(ChangeObjectLayer)
	)
	(princ)
)

(defun C:ChgMode ( / )						; Change Property and Modes
	(property 4)
	(princ)
)

(defun GetGrpNex ( /	ObjDict GrpDict GrpNum	; Get Group Next
					Cnt GrpAll GrpLst )
;****************************************************************************
;Function:		GetGrpNex
;Description:	This returns the next available group number
;Function(s):
;Arguments:
;Globals:
;Revised:
;****************************************************************************
	(setq ObjDict (namedobjdict)
		 GrpDict (dictsearch ObjDict "ACAD_GROUP")
		 Cnt	    0
		 GrpAll  nil
	)
	(while (< Cnt (length GrpDict))
		(if (= (car (nth Cnt GrpDict)) 3)
			(setq GrpLst (cdr (nth Cnt GrpDict)))
			(setq GrpLst nil)
		)
		(if (and GrpLst Bug)
			(princ (strcat	"\nGroup found named: "
						(cdr (nth Cnt GrpDict))
						" at number: "
						(itoa Cnt)
				  )
			)
		)
		(setq Cnt (1+ Cnt))
		(if GrpLst
			(if (= (strcase (substr GrpLst 1 5)) "CHPLN")
				(if GrpAll
					(setq GrpAll
							(append
								GrpAll
								(list (atoi (substr GrpLst 6))
								)
							)
					)
					(setq GrpAll (list (atoi (substr GrpLst 6))))
				)
			)
		)
	)
	(setq Cnt	1
		 GrpNum nil
	)
	(while (not GrpNum)
		(if (not (member Cnt GrpAll))
			(setq GrpNum Cnt)
			(setq Cnt (1+ Cnt))
		)
	)
	GrpNum
)

(defun GrpSSChgFilt ( ssE /	ObjDict GrpDict	; Group SS Change Filter
						EntLst EntAll GrpLst Cnt GrpAll EntSS FndLst GrpCnt GrpLen
						Bubba E1 EdsSS Found SSorig TmPe TmPl TmPs )
;****************************************************************************
;Function:		GrpSSChgFilt
;Description:	This functions filters a ss for grouped Plines
;Function(s):
;Arguments:
;Globals:
;Revised:
;****************************************************************************
	(setq ObjDict (namedobjdict)
		 GrpDict (dictsearch ObjDict "ACAD_GROUP")
		 Cnt	    0
		 GrpAll  nil
	)
	(while (< Cnt (length GrpDict))
		(if (= (car (nth Cnt GrpDict)) 3)
			(setq GrpLst (cons (cdr (nth Cnt GrpDict))
						    (cdr (nth (1+ Cnt) GrpDict))
					   )
			)
			(setq GrpLst nil)
		)
		(if (and GrpLst Bug)
			(princ (strcat	"\nGroup found named: "
						(cdr (nth Cnt GrpDict))
						" at number: "
						(itoa Cnt)
				  )
			)
		)
		(setq Cnt (1+ Cnt))
		(if GrpLst
			(if GrpAll
				(setq GrpAll (append GrpAll (list GrpLst)))
				(setq GrpAll (list GrpLst))
			)
		)
	)
	(foreach x
			 GrpAll
		(progn
			(setq GrpLst (entget (cdr x))
				 EntLst nil
				 Cnt	   0
			)
			(while (< Cnt (length GrpLst))
				(if (= (car (nth Cnt GrpLst)) 340)
					(if EntLst
						(setq EntLst
								(append EntLst
									   (list (cdr (nth Cnt
												    GrpLst
											    )
										    )
									   )
								)
						)
						(setq EntLst
								(list (cdr (nth Cnt GrpLst)))
						)
					)
				)
				(setq Cnt (1+ Cnt))
			)
			(if EntLst
				(if EntAll
					(setq EntAll (append EntAll (list EntLst)))
					(setq EntAll (list EntLst))
				)
			)
		)
	)
	(setq Cnt 0)
	(while (< Cnt (sslength ssE))
		(setq E1	(ssname ssE Cnt)
			 Cnt	(1+ Cnt)
		)
		(if EntSS
			(setq EntSS (append EntSS (list E1)))
			(setq EntSS (list E1))
		)
	)
	(if Bug
		(princ
			(strcat "\nEntSS has " (itoa (length EntSS)) " item(s)")
		)
	)
	(if Bug
		(setq EdsSS EntSS)
	)
	(setq ssOrig (ssadd)
		 ssOrig (ssadd (car EntSS) ssOrig)
	)
	(if (> (length EntSS) 1)
		(mapcar (quote (lambda (x) (setq ssOrig (ssadd x ssOrig))))
			   (cdr EntSS)
		)
	)
	(setq Cnt 0)
	(foreach x
			 EntAll
		(progn
			(setq GrpLen (length (nth Cnt EntAll))
				 GrpCnt 0
				 Found  nil
			)
			(while (< GrpCnt GrpLen)
				(if (not Found)
					(if (member (nth GrpCnt (nth Cnt EntAll))
							  EntSS
					    )
						(setq Found T
							 ssE	  (ssdel (nth GrpCnt
										    (nth Cnt EntAll)
									    )
									    ssE
								  )
						)
					)
					(setq
						ssE (ssdel (nth GrpCnt (nth Cnt EntAll))
								 ssE
						    )
					)
				)
				(setq GrpCnt (1+ GrpCnt))
			)
			(if Found
				(if FndLst
					(setq FndLst (append FndLst (list Cnt)))
					(setq FndLst (list Cnt))
				)
			)
			(setq Cnt (1+ Cnt))
		)
	)
	(setq TmpSS EntSS)
	(foreach x
			 TmpSS
		(progn
			(setq TmpE (entget x (list "*"))
				 TmpL (cdr (assoc 8 TmpE))
			)
			(if (< (strlen TmpL) 11)
				(setq EntSS (RemLstAll x EntSS)
					 ssE	  (if (ssmemb x ssE)
							  (ssdel x ssE)
							  ssE
						  )
					 Bubba (if Bug
							  (princ "\nssE lost one. -1")
						  )
				)
				(if (/= (substr TmpL 11 1) "C")
					(setq EntSS (RemLstAll x EntSS)
						 ssE	  (if (ssmemb x ssE)
								  (ssdel x ssE)
								  ssE
							  )
						 Bubba (if Bug
									(progn
										(princ "\nssE lost one. -2 \n\n")
										(prin1 TmpE)
									)
							  )
					)
					(setq ssOrig (if (ssmemb x ssOrig)
								   (ssdel x ssOrig)
								   ssOrig
							   )
						 Bubba  (if Bug
								   (princ "\nssOrig lost one.")
							   )
					)
				)
			)
		)
	)
	(list GrpAll EntAll EntSS FndLst ssE ssOrig)
)

(defun GrpEntChgFilt ( EntSS /	ObjDict		; Group Entity Change Filter
							GrpDict GrpLst Cnt GrpAll EntLst EntAll
							FndLst GrpCnt GrpLen Found )
;****************************************************************************
;Function:		Property  (main)
;Description:	This filters a list of entity names for membership in a group
;Function(s):
;Arguments:
;Globals:
;Revised:
;****************************************************************************
	(setq ObjDict (namedobjdict)
		 GrpDict (dictsearch ObjDict "ACAD_GROUP")
		 Cnt	    0
		 GrpAll  nil
	)
	(while (< Cnt (length GrpDict))
		(if (= (car (nth Cnt GrpDict)) 3)
			(setq GrpLst (cons (cdr (nth Cnt GrpDict))
						    (cdr (nth (1+ Cnt) GrpDict))
					   )
			)
			(setq GrpLst nil)
		)
		(if (and GrpLst Bug)
			(princ (strcat	"\nGroup found named: "
						(cdr (nth Cnt GrpDict))
						" at number: "
						(itoa Cnt)
				  )
			)
		)
		(setq Cnt (1+ Cnt))
		(if GrpLst
			(if GrpAll
				(setq GrpAll (append GrpAll (list GrpLst)))
				(setq GrpAll (list GrpLst))
			)
		)
	)
	(foreach x
			 GrpAll
		(progn
			(setq GrpLst (entget (cdr x))
				 EntLst nil
				 Cnt	   0
			)
			(while (< Cnt (length GrpLst))
				(if (= (car (nth Cnt GrpLst)) 340)
					(if EntLst
						(setq EntLst
								(append EntLst
									   (list (cdr (nth Cnt
												    GrpLst
											    )
										    )
									   )
								)
						)
						(setq EntLst
								(list (cdr (nth Cnt GrpLst)))
						)
					)
				)
				(setq Cnt (1+ Cnt))
			)
			(if EntLst
				(if EntAll
					(setq EntAll (append EntAll (list EntLst)))
					(setq EntAll (list EntLst))
				)
			)
		)
	)
	(setq Found nil
		 Cnt	0
	)
	(foreach x
			 EntAll
		(if (not Found)
			(if (member EntSS (nth Cnt EntAll))
				(setq Found Cnt
					 Cnt	  (1+ Cnt)
				)
				(setq Cnt (1+ Cnt))
			)
			(setq Cnt (1+ Cnt))
		)
	)
	(list GrpAll EntAll EntSS Found)
)

(defun RemLstAll ( Itm Lst / Was )			; calls CutLst to remove all Itm from Lst
;****************************************************************************
;Function:		RemLstAll
;Description:	This recursivley calls CutLst to remove all incidences of Itm from Lst
;Function(s):
;Arguments:
;Globals:
;Revised:
;****************************************************************************
	(setq Was (length Lst))
	(while (member Itm Lst)
		(setq Lst (CutLst Itm Lst))
	)
	Lst
)

(defun CutLst ( Itm Lst /	LstLen ALen ALst	; removes first Itm from Lst
						RLst RCnt Cnt )
;****************************************************************************
;Function:		CutLst
;Description:	This function removes the first occurence of Itm from Lst
;Function(s):
;Arguments:
;Globals:
;Revised:
;****************************************************************************
	(if (member Itm Lst)
		(progn
			(setq LstLen (length Lst)
				 ALen   (length (member Itm Lst))
			)
			(cond ((= ALen 1)
				  (setq Lst (reverse (cdr (reverse Lst))))
				 )
				 ((= ALen LstLen)
				  (setq Lst (cdr Lst))
				 )
				 (T
				  (setq RLst (cdr (member Itm Lst))
					   ALst (list (car Lst))
					   RCnt (- LstLen ALen)
					   Cnt  1
				  )
				  (while (< Cnt RCnt)
					  (setq ALst (append ALst (list (nth Cnt Lst)))
						   Cnt  (1+ Cnt)
					  )
				  )
				  (setq Lst (append ALst RLst))
				 )
			)
		)
	)
	Lst
)

(defun C:EffectChg ( /	ssE GetBak GrpAll EntAll	; Effects changes on selected Feeder Lines
					EntSS FndLst )
;****************************************************************************
;Function:		C:EffectChg
;Description:	This command-line function Effects proposed changes on selected Feeder Lines
;Function(s):
;Arguments:
;Globals:
;Revised:
;****************************************************************************
	(princ "\nSelect the objects to Effect Changes on: ")
	(setq ssE (ssget))
	(if ssE
		(setq GetBak (GrpSSChgFilt ssE))
	)
	(if GetBak
		(setq GrpAll (nth 0 GetBak)
			 EntAll (nth 1 GetBak)
			 EntSS  (nth 2 GetBak)
			 FndLst (nth 3 GetBak)
			 ssE	   (nth 4 GetBak)
		)
	)
	(if FndLst
		(foreach x
				 FndLst
			(EffChg (nth x GrpAll) (nth x EntAll))
		)
	)
	(if (and Bug (> (sslength ssE) 0))
		(princ (strcat	"\nRemaining SS has "
					(itoa (sslength ssE))
					" objects."
			  )
		)
	)
	(if (> (sslength ssE) 0)
		(ChSym "E" ssE)
	)
	;	Cleanup
	(if ssE	(setq	ssE	nil))
	(gc)
	
	(princ)
)

(defun C:EffectAllChg ( /	ssE GetBak GrpAll	; Effects changes on all feeder lines
						EntAll EntSS FndLst )
;****************************************************************************
;Function:		C:EffectAllChg
;Description:	This command-line function Effects proposed changes on all Feeder Lines
;Function(s):
;Arguments:
;Globals:
;Revised:
;****************************************************************************
	(setq ssE (ssget "X"))
	(if ssE
		(setq GetBak (GrpSSChgFilt ssE))
	)
	(if (and Bug (> (sslength ssE) 0))
		(princ (strcat	"\nOriginal SS has "
					(itoa (sslength ssE))
					" objects."
			  )
		)
	)
	(if GetBak
		(setq GrpAll (nth 0 GetBak)
			 EntAll (nth 1 GetBak)
			 EntSS  (nth 2 GetBak)
			 FndLst (nth 3 GetBak)
			 ssE	   (nth 4 GetBak)
		)
	)
	(if FndLst
		(foreach x
				 FndLst
			(EffChg (nth x GrpAll) (nth x EntAll))
		)
	)
	(if (and Bug (> (sslength ssE) 0))
		(princ (strcat	"\nRemaining SS has "
					(itoa (sslength ssE))
					" objects."
			  )
		)
	)
	(if (> (sslength ssE) 0)
		(ChSym "E" ssE)
	)
	
	;	Cleanup
	(if ssE	(setq	ssE	nil))
	(gc)
	
	(princ)
)

(defun EffChg ( GrpDat EntDat /	P1 P2 Ptmp	; Effects one change at a time
							PlObj1 PlObj2 PlTmp P2Lyr EED Bubba WDontE )
;****************************************************************************
;Function:		EffChg
;Description:	This function carries out the low-level changes
;Function(s):
;Arguments:
;Globals:
;Revised:
;****************************************************************************
	(command "-GROUP" "E" (car GrpDat))
	(setq P1	   (nth 0 EntDat)
		 P2	   (nth 1 EntDat)
		 PlObj1 (entget P1 (list "*"))
		 PlObj2 (entget P2 (list "*"))
	)
	(if Bug
		(princ (strcat	"\nBefore Swap, Dang EffChg says:"
					"\n\tOne: "
					(cdr (assoc 8 PlObj1))
					"\n\tTwo: "
					(cdr (assoc 8 PlObj2))
			  )
		)
	)
	(if (= (substr (cdr (assoc 8 PlObj1)) 11 1) "C")
		(setq Bubba  (if Bug
					   (princ "\nEffChg says C is 1.")
				   )
			 PTmp   P2
			 P2	   P1
			 P1	   PTmp
			 PlTmp  PlObj2
			 PlObj2 PlObj2
			 PlObj1 PlTmp
			 P2Lyr  (substr (cdr (assoc 8 PlObj2)) 1 10)
		)
		(setq P2Lyr (substr (cdr (assoc 8 PlObj2)) 1 10)
			 Bubba (if Bug
					  (princ "\nEffChg says C is 2.")
				  )
		)
	)
	(if Bug
		(princ (strcat	"\nAfter Swap, Dang EffChg says:"
					"\n\tOne: "
					(cdr (assoc 8 PlObj1))
					"\n\tTwo: "
					(cdr (assoc 8 PlObj2))
			  )
		)
	)
	(if Bug
		(princ (strcat "\nNew (Exist) Layer: " P2Lyr))
	)
	(setq	WDontE	DontE
			DontE	T
	)
	(setq	ColorBy	"FD")
	(MkLay P2Lyr)
	(if WDontE
		(setq	DontE	WDontE)
		(setq	DontE	nil)
	)
	(setq EED	   (cdr (assoc -3 PlObj2))
		 PlObj1 (subst	(cons -3 EED)
					(assoc -3 PlObj1)
					PlObj1
			   )
	)
	(entmod PlObj1)
	(if Bug
		(princ "\nEED entmod made!")
	)
	(setq PlObj1 (subst	(cons 8 P2Lyr)
					(assoc 8 PlObj1)
					PlObj1
			   )
	)
	(entmod PlObj1)
	(if Bug
		(princ "\nLyr entmod made!")
	)
	(command "_.ERASE" P2 "")
	P2Lyr
)

(defun FixAttLay ( et1 layr / e1 e2 )			; Fixes Attributes Layers
;****************************************************************************
;Function:		FixAttLay
;Description:	This provides an object list with the correct layer
;Function(s):
;Arguments:
;Globals:
;Revised:
;****************************************************************************
	(setq e1 (entnext et1))
	(if (null layr)
		(setq layr (cdr (assoc 8 (entget et1))))
	)
	(if (and (/= Div "AL") (/= Div "GA"))										;[Added Trans]
		(setq layr (MkLay (strcat (substr layr 1 6) "D" (substr layr 8))))
		(setq layr (MkLay (strcat layr "D")))
	)
	(while e1
		(if (/= (cdr (assoc 0 (setq e2 (entget e1 (list "*")))))
			   "SEQEND"
		    )
			(progn
				(setq e2 (subst (cons 8 layr) (assoc 8 e2) e2))
				(entmod e2)
				(setq e1 (entnext e1))
			)
			(setq e1 nil)
		)
	)
	(entupd et1)
	(princ)
)

(defun RngData	( Data MLst Tst / Retn MLen)	; Test data in valid range
;****************************************************************************
;Function:		RngData
;Description:	This function tests if supplied parameter is within set size
;Function(s):
;Arguments:
;Globals:
;Revised:
;****************************************************************************
	(setq Data (atoi Data)
		 MLen (length MLst)
		 Retn nil
	)
	(if Tst
		(setq Data (1- Data))
	)
	(if (and (>= Data 0) (< Data MLen))
		(setq Retn (nth Data MLst))
		(setq Retn nil)
	)
	Retn
)

(defun Cb_ME_radio ( / )					; Call Back - ME radio
	(setq Rad_Mode "E")
	(set_tile "ME_radio" "1")
	(set_tile "MI_radio" "0")
	(set_tile "MC_radio" "0")
	(set_tile "MR_radio" "0")
)

(defun Cb_MI_radio ( / )					; Call Back - MI radio
	(setq Rad_Mode "I")
	(set_tile "ME_radio" "0")
	(set_tile "MI_radio" "1")
	(set_tile "MC_radio" "0")
	(set_tile "MR_radio" "0")
)

(defun Cb_MC_radio ( / )					; Call Back - MC radio
	(setq Rad_Mode "C")
	(set_tile "ME_radio" "0")
	(set_tile "MI_radio" "0")
	(set_tile "MC_radio" "1")
	(set_tile "MR_radio" "0")
)

(defun Cb_MR_radio ( / )					; Call Back - MR radio
	(setq Rad_Mode "R")
	(set_tile "ME_radio" "0")
	(set_tile "MI_radio" "0")
	(set_tile "MC_radio" "0")
	(set_tile "MR_radio" "1")
)

(defun Cb_Test_Ok ( number / )				; Call Back - Test OK
	(if Bug (progn (princ "\nProperty.Lsp!Cb_Test_Ok parms: ")(prin1 number)))
	(if (= number 1)
		(progn
			(if (and (= Oh_Data "1") (= Ug_Data "0") (= Tm_Data "0"))
				(if (and (null kvs)
					    (null fds)
					    (null phs)
					    (null wssp)
					    (null wssn)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if (and (= Oh_Data "0") (= Ug_Data "1") (= Tm_Data "0"))
				(if (and (null kvs)
					    (null fds)
					    (null phs)
					    (null wssp)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if (and (= Oh_Data "0") (= Ug_Data "0") (= Tm_Data "1"))
				(if (and (null kvs)
					    (null fds)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
		)
	)
	(if (or (= number 3) (= number 4))
		(progn
			(if (and (= Oh_Data "1") (= Ug_Data "0") (= Tm_Data "0"))
				(if (and (null kvs)
					    (null fds)
					    (null phs)
					    (null wssp)
					    (null wssn)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if (and (= Oh_Data "0") (= Ug_Data "1") (= Tm_Data "0"))
				(if (and (null kvs)
					    (null fds)
					    (null phs)
					    (null wssp)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if (and (= Oh_Data "0") (= Ug_Data "0") (= Tm_Data "1"))
				(if (and (null kvs)
					    (null fds)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
		)
	)
	(if (= number 4) ; (or (= number 3) 
		(if (and (/= Div "AL") (/= Div "GA"))									;[Modified for Trans]
			(progn
				(if (null (car ModSS))
					(progn
						(mode_tile "Pri_S_popup" 1)
						(mode_tile "Pri_T_popup" 1)
						(mode_tile "Neu_S_popup" 1)
						(mode_tile "Neu_T_popup" 1)
						(if Bug (princ "\nDisabling all wire data!"))
					)
					(progn
						(mode_tile "Pri_S_popup" 0)
						(mode_tile "Pri_T_popup" 0)
						(mode_tile "Neu_S_popup" 0)
						(mode_tile "Neu_T_popup" 0)
						(if Bug (princ "\nEnabling all wire data!"))
					)
				)
				(progn
					(mode_tile "Pri_S_popup" 0)
					(mode_tile "Pri_T_popup" 0)
					(mode_tile "Neu_S_popup" 0)
					(mode_tile "Neu_T_popup" 0)
					(if Bug (princ "\nEnabling all wire data!"))
				)
			)
			(progn
				(mode_tile "Pri_S_popup" 1)
				(mode_tile "Pri_T_popup" 1)
				(mode_tile "Neu_S_popup" 1)
				(mode_tile "Neu_T_popup" 1)
				(if Bug (princ "\nDisabling all wire data!"))
			)
		)
	)
	(princ)
)

(defun Cb_vt_popup ( number / )				; Call Back - Voltage OK
;****************************************************************************
;Function:  cb_vt_popup
;Description:  This is the callback function for the voltage
;Function(s):  property()
;Arguments: number
;Globals:   None
;Revised:
;****************************************************************************
	(setq Vt_Data (get_tile "vt_popup"))
	(if (RngData Vt_Data Lst_Vt_S kvps)
		(setq kvs T)
		(setq kvs nil)
	)
	(if (= number 1)
		(progn
			(if (and (= Oh_Data "1") (= Ug_Data "0")(= Tm_Data "0"))
				(if (or (null kvs)
					   (null fds)
					   (null phs)
					   (null wssp)
					   (null wssn)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if (and (= Oh_Data "0") (= Ug_Data "1")(= Tm_Data "0"))
				(if (or (null kvs)
					   (null fds)
					   (null phs)
					   (null wssp)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if (and (= Oh_Data "0") (= Ug_Data "0")(= Tm_Data "1"))
				(if (or (null kvs)
					   (null fds)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if kvps
				(if (not (eq Vt_Data "0"))
					(setq Vt_Data (nth (- (atoi Vt_Data) 1)
								    Lst_Vt_S
							    )
					)
				)
				(setq Vt_Data (nth (atoi Vt_Data) Lst_Vt_S))
			)
		)
	)
	   ;
	(if (or (= number 3) (= number 4))
		(progn
			(if (and (= Oh_Data "1") (= Ug_Data "0")(= Tm_Data "0"))
				(if (and (null kvs)
					    (null fds)
					    (null phs)
					    (null wssp)
					    (null wssn)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if (and (= Oh_Data "0") (= Ug_Data "1")(= Tm_Data "0"))
				(if (and (null kvs)
					    (null fds)
					    (null phs)
					    (null wssp)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if (and (= Oh_Data "0") (= Ug_Data "0")(= Tm_Data "1"))
				(if (or (null kvs)
					   (null fds)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if kvps
				(if (not (eq Vt_Data "0"))
					(setq Vt_Data (nth (- (atoi Vt_Data) 1)
								    Lst_Vt_S
							    )
					)
				)
				(setq Vt_Data (nth (atoi Vt_Data) Lst_Vt_S))
			)
		)
	)
)

(defun Cb_Fd_popup ( number / )				; Call Back - Feeder OK
;****************************************************************************
;Function:  cb_Fd_popup
;Description:  This is the callback function for the feeder
;Function(s):  property()
;Arguments: number
;Globals:   None
;Revised:
;****************************************************************************
	(setq Fd_Data (get_tile "fd_popup"))
	(if (RngData Fd_Data Lst_Fd_V fdps)
		(setq fds T)
		(setq fds nil)
	)
	(if (= number 1)
		(progn
			(if (and (= Oh_Data "1") (= Ug_Data "0")(= Tm_Data "0"))
				(if (or (null kvs)
					   (null fds)
					   (null phs)
					   (null wssp)
					   (null wssn)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if (and (= Oh_Data "0") (= Ug_Data "1")(= Tm_Data "0"))
				(if (or (null kvs)
					   (null fds)
					   (null phs)
					   (null wssp)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if (and (= Oh_Data "0") (= Ug_Data "0")(= Tm_Data "1"))
				(if (or (null kvs)
					   (null fds)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if fdps
				(if (not (eq Fd_Data "0"))
					(setq Fd_Data (nth (- (atoi Fd_Data) 1)
								    Lst_Fd_V
							    )
					)
				)
				(setq Fd_Data (nth (atoi Fd_Data) Lst_Fd_V))
			)
		)
	)

	(if (or (= number 3) (= number 4))
		(progn
			(if (and (= Oh_Data "1") (= Ug_Data "0")(= Tm_Data "0"))
				(if (and (null kvs)
					    (null fds)
					    (null phs)
					    (null wssp)
					    (null wssn)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if (and (= Oh_Data "0") (= Ug_Data "1")(= Tm_Data "0"))
					(if (and (null kvs)
					    (null fds)
					    (null phs)
					    (null wssp)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if (and (= Oh_Data "0") (= Ug_Data "0")(= Tm_Data "1"))
				(if (or (null kvs)
					   (null fds)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if fdps
				(setq Fd_Data (nth (- (atoi Fd_Data) 1) Lst_Fd_V))
				(setq Fd_Data (nth (atoi Fd_Data) Lst_Fd_V))
			)
		)
	)
)

(defun Cb_Ph_popup ( number / )				; Call Back - Phase OK
;****************************************************************************
;Function:  cb_Ph_popup
;Description:  This is the callback function for the phasing
;Function(s):  property()
;Arguments: number
;Globals:   None
;Revised:
;****************************************************************************
	(setq Ph_Data (get_tile "ph_popup"))
	(if (RngData Ph_Data Lst_Ph_S phps)
		(setq phs T)
		(setq phs nil)
	)
	(if (= number 1)
		(progn
			(if (and (= Oh_Data "1") (= Ug_Data "0"))
				(if (or (null kvs)
					   (null fds)
					   (null phs)
					   (null wssp)
					   (null wssn)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if (and (= Oh_Data "0") (= Ug_Data "1"))
				(if (or (null kvs)
					   (null fds)
					   (null phs)
					   (null wssp)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if phps
				(if (not (eq Ph_Data "0"))
					(setq Ph_Data (nth (- (atoi Ph_Data) 1)
								    Lst_Ph_S
							    )
					)
				)
				(setq Ph_Data (nth (atoi Ph_Data) Lst_Ph_S))
			)
		)
	)
	(if (or (= number 3) (= number 4))
		(progn
			(if (and (= Oh_Data "1") (= Ug_Data "0"))
				(if (and (null kvs)
					    (null fds)
					    (null phs)
					    (null wssp)
					    (null wssn)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if (and (= Oh_Data "0") (= Ug_Data "1"))
				(if (and (null kvs)
					    (null fds)
					    (null phs)
					    (null wssp)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if phps
				(setq Ph_Data (nth (- (atoi Ph_Data) 1) Lst_Ph_S))
				(setq Ph_Data (nth (atoi Ph_Data) Lst_Ph_S))
			)
		)
	)
)

(defun Cb_Pri_S_popup ( number / Bubba lst )	; Call Back - Primary Wire Size OK
;****************************************************************************
;Function:  cb_Pri_S_popup
;Description:  This is the callback function for the Primary_Wire size
;Function(s):  property()
;Arguments: number
;Globals:   None
;Revised:
;****************************************************************************
	(setq Pri_S_datr (get_tile "Pri_S_popup"))
	(setq Pri_T_datr (get_tile "Pri_T_popup"))
	(if Bug
		(princ
			(strcat "\nRet Pri Raw Vals:" Pri_S_Datr "-" Pri_T_Datr)
		)
	)
	(if (and (RngData Pri_S_Datr Lst_Wr_S wspsp)
		    (RngData Pri_T_Datr Lst_Wr_T wspsp)
	    )
		(setq	wssp		T
				Bubba	(if Bug (princ "\nWssp(S) = T"))
		)
		(setq	wssp		nil
				Bubba	(if Bug (princ "\nWssp(S) = nil"))
		)
	)
	(if (= number 1)
		(progn
			(if (and (= Oh_Data "1") (= Ug_Data "0"))
				(if (or (null kvs)
					   (null fds)
					   (null phs)
					   (null wssp)
					   (null wssn)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if (and (= Oh_Data "0") (= Ug_Data "1"))
				(if (or (null kvs)
					   (null fds)
					   (null phs)
					   (null wssp)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
		)
		(if (or (= number 3) (= number 4))
			(progn
				(if (and (= Oh_Data "1") (= Ug_Data "0"))
					(if (and (null kvs)
						    (null fds)
						    (null phs)
						    (null wssp)
						    (null wssn)
					    )
						(mode_tile "ok_button" 1)
						(mode_tile "ok_button" 0)
					)
				)
				(if (and (= Oh_Data "0") (= Ug_Data "1"))
					(if (and (null kvs)
						    (null fds)
						    (null phs)
						    (null wssp)
					    )
						(mode_tile "ok_button" 1)
						(mode_tile "ok_button" 0)
					)
				)
			)
		)
	)
	(if wspsp
		(if (not (eq Pri_S_datr "0"))
			(setq Pri_S_data (nth (- (atoi Pri_S_datr) 1) Lst_Wr_S))
		)
		(setq Pri_S_data (nth (atoi Pri_S_datr) Lst_Wr_S))
	)
	(if Bug
		(princ (strcat "\nRet Pri Vals:" Pri_S_Data "-" Pri_T_Data))
	)
)

(defun Cb_Pri_T_popup ( number / lst )			; Call Back - Primary Wire Type OK
;****************************************************************************
;Function:  cb_Pri_T_popup
;Description:  This is the callback function for the Primary_Wire size
;Function(s):  property()
;Arguments: number
;Globals:   None
;Revised:
;****************************************************************************
	(setq Pri_S_datr (get_tile "Pri_S_popup"))
	(setq Pri_T_datr (get_tile "Pri_T_popup"))
	(if Bug
		(princ
			(strcat "\nRet Pri Raw Vals:" Pri_S_Datr "-" Pri_T_Datr)
		)
	)
	(if (and (RngData Pri_S_Datr Lst_Wr_S wspsp)
		    (RngData Pri_T_Datr Lst_Wr_T wspsp)
	    )
		(setq	wssp		T
				Bubba	(if Bug (princ "\nWssp(T) = T"))
		)
		(setq	wssp		nil
				Bubba	(if Bug (princ "\nWssp(T) = nil"))
		)
	)
	(if (= number 1)
		(progn
			(if (and (= Oh_Data "1") (= Ug_Data "0"))
				(if (or (null kvs)
					   (null fds)
					   (null phs)
					   (null wssp)
					   (null wssn)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if (and (= Oh_Data "0") (= Ug_Data "1"))
				(if (or (null kvs)
					   (null fds)
					   (null phs)
					   (null wssp)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
		)
		(if (or (= number 3) (= number 4))
			(progn
				(if (and (= Oh_Data "1") (= Ug_Data "0"))
					(if (and (null kvs)
						    (null fds)
						    (null phs)
						    (null wssp)
						    (null wssn)
					    )
						(mode_tile "ok_button" 1)
						(mode_tile "ok_button" 0)
					)
				)
				(if (and (= Oh_Data "0") (= Ug_Data "1"))
					(if (and (null kvs)
						    (null fds)
						    (null phs)
						    (null wssp)
					    )
						(mode_tile "ok_button" 1)
						(mode_tile "ok_button" 0)
					)
				)
			)
		)
	)
	(if wspsp
		(if (not (eq Pri_T_datr "0"))
			(setq Pri_T_data (nth (- (atoi Pri_T_datr) 1) Lst_Wr_T))
		)
		(setq Pri_T_data (nth (atoi Pri_T_datr) Lst_Wr_T))
	)
	(if Bug
		(princ (strcat "\nRet Pri Vals:" Pri_S_Data "-" Pri_T_Data))
	)
)

(defun Cb_Neu_S_popup ( number / lst )			; Call Back - Secondary Wire Size OK
;****************************************************************************
;Function:  cb_Neu_S_popup
;Description:  This is the callback function for the Primary_Wire size
;Function(s):  property()
;Arguments: number
;Globals:   None
;Revised:
;****************************************************************************
	(mode_tile "ok_button" 0)
	(setq Neu_S_datr (get_tile "Neu_S_popup"))
	(setq Neu_T_datr (get_tile "Neu_T_popup"))
	(if Bug
		(princ
			(strcat "\nRet Neu Raw Vals:" Neu_S_Datr "-" Neu_T_Datr)
		)
	)
	(if (and (RngData Neu_S_Datr Lst_Wr_S wspsn)
		    (RngData Neu_T_Datr Lst_Wr_T wspsn)
	    )
		(setq wssn T)
		(setq wssn nil)
	)
	(if (= number 1)
		(progn
			(if (and (= Oh_Data "1") (= Ug_Data "0"))
				(if (or (null kvs)
					   (null fds)
					   (null phs)
					   (null wssp)
					   (null wssn)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if (and (= Oh_Data "0") (= Ug_Data "1"))
				(if (or (null kvs)
					   (null fds)
					   (null phs)
					   (null wssp)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
		)
		(if (or (= number 3) (= number 4))
			(progn
				(if (and (= Oh_Data "1") (= Ug_Data "0"))
					(if (and (null kvs)
						    (null fds)
						    (null phs)
						    (null wssp)
						    (null wssn)
					    )
						(mode_tile "ok_button" 1)
						(mode_tile "ok_button" 0)
					)
				)
				(if (and (= Oh_Data "0") (= Ug_Data "1"))
					(if (and (null kvs)
						    (null fds)
						    (null phs)
						    (null wssp)
					    )
						(mode_tile "ok_button" 1)
						(mode_tile "ok_button" 0)
					)
				)
			)
		)
	)
	(if wspsn
		(if (not (eq Neu_S_datr "0"))
			(setq Neu_S_data (nth (- (atoi Neu_S_datr) 1) Lst_Wr_S))
		)
		(setq Neu_S_data (nth (atoi Neu_S_datr) Lst_Wr_S))
	)
	(if Bug
		(princ (strcat "\nRet Neu Vals:" Neu_S_Data "-" Neu_T_Data))
	)
)

(defun Cb_Neu_T_popup ( number / lst )			; Call Back - Secondary Wire Type OK
;****************************************************************************
;Function:  cb_Neu_T_popup
;Description:  This is the callback function for the Primary_Wire size
;Function(s):  property()
;Arguments: number
;Globals:   None
;Revised:
;****************************************************************************
	(setq Neu_S_datr (get_tile "Neu_S_popup"))
	(setq Neu_T_datr (get_tile "Neu_T_popup"))
	(if Bug
		(princ
			(strcat "\nRet Neu Raw Vals:" Neu_S_Datr "-" Neu_T_Datr)
		)
	)
	(if (and (RngData Neu_S_Datr Lst_Wr_S wspsn)
		    (RngData Neu_T_Datr Lst_Wr_T wspsn)
	    )
		(setq wssn T)
		(setq wssn nil)
	)
	(if (= number 1)
		(progn
			(if (and (= Oh_Data "1") (= Ug_Data "0"))
				(if (or (null kvs)
					   (null fds)
					   (null phs)
					   (null wssp)
					   (null wssn)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
			(if (and (= Oh_Data "0") (= Ug_Data "1"))
				(if (or (null kvs)
					   (null fds)
					   (null phs)
					   (null wssp)
				    )
					(mode_tile "ok_button" 1)
					(mode_tile "ok_button" 0)
				)
			)
		)
		(if (or (= number 3) (= number 4))
			(progn
				(if (and (= Oh_Data "1") (= Ug_Data "0"))
					(if (and (null kvs)
						    (null fds)
						    (null phs)
						    (null wssp)
						    (null wssn)
					    )
						(mode_tile "ok_button" 1)
						(mode_tile "ok_button" 0)
					)
				)
				(if (and (= Oh_Data "0") (= Ug_Data "1"))
					(if (and (null kvs)
						    (null fds)
						    (null phs)
						    (null wssp)
					    )
						(mode_tile "ok_button" 1)
						(mode_tile "ok_button" 0)
					)
				)
			)
		)
	)
	(if wspsn
		(if (not (eq Neu_T_datr "0"))
			(setq Neu_T_data (nth (- (atoi Neu_T_datr) 1) Lst_Wr_T))
		)
		(setq Neu_T_data (nth (atoi Neu_T_datr) Lst_Wr_T))
	)
	(if Bug
		(princ (strcat "\nRet Neu Vals:" Neu_S_Data "-" Neu_T_Data))
	)
)

(defun Cb_oh_radio ( / )					; Call Back - OH radio OK
;****************************************************************************
;Function: cb_oh_radio
;Description:  This is the callback function for the overhead function.
;Function(s):  property()
;Arguments: number
;Globals:   None
;Revised:
;****************************************************************************
	(set_tile "oh_radio" "1")
	(set_tile "ug_radio" "0")
	(set_tile "tm_radio" "0")
	(setq Oh_Data	(get_tile "oh_radio")
		 Ug_Data	(get_tile "ug_radio")
		 Tm_Data	(get_tile "tm_radio")
		 oh_value	Oh_Data
		 ug_value	Ug_Data
		 tm_value Tm_Data
	)
	(mode_tile "ph_popup" 0)
	(mode_tile "Pri_S_popup" 0)
	(mode_tile "Pri_T_popup" 0)
	(mode_tile "Neu_S_popup" 0)
	(mode_tile "Neu_T_popup" 0)
)

(defun Cb_ug_radio ( / )					; Call Back - UG radio OK
;****************************************************************************
;Function:  cb_ug_radio
;Description:  This is the callback function for the underground function.
;Function(s):  property()
;Arguments: number
;Globals:   None
;Revised:
;****************************************************************************
	(set_tile "ug_radio" "1")
	(set_tile "oh_radio" "0")
	(set_tile "tm_radio" "0")
	(setq Oh_Data	(get_tile "oh_radio")
		 Ug_Data	(get_tile "ug_radio")
		 Tm_Data	(get_tile "tm_radio")
		 oh_value	Oh_Data
		 ug_value	Ug_Data
		 tm_value Tm_Data
	)
	(mode_tile "ph_popup" 0)
	(mode_tile "Pri_S_popup" 0)
	(mode_tile "Pri_T_popup" 0)
	(mode_tile "Neu_S_popup" 1)
	(mode_tile "Neu_T_popup" 1)
)

(defun Cb_tm_radio ( / )
	(set_tile "oh_radio" "0")
	(set_tile "ug_radio" "0")
	(set_tile "tm_radio" "1")
	(setq Oh_Data	(get_tile "oh_radio")
		 Ug_Data	(get_tile "ug_radio")
		 Tm_Data	(get_tile "tm_radio")
		 oh_value	Oh_Data
		 ug_value	Ug_Data
		 tm_value Tm_Data
	)
	(mode_tile "ph_popup" 1)
	(mode_tile "Pri_S_popup" 1)
	(mode_tile "Pri_T_popup" 1)
	(mode_tile "Neu_S_popup" 1)
	(mode_tile "Neu_T_popup" 1)

)

(defun Cb_md_radio ( / )					; Call Back - MD radio OK
	(setq Smod (get_tile "mode_radio"))
)

(defun Cb_ok_button	( number / )			; Done Dialog return value (transform)
;****************************************************************************
;Function:  cb_ok_button
;Description:  This is the callback function for the ok button
;Function(s):  property()
;Arguments: number
;Globals:   None
;Revised:
;****************************************************************************
	(cond
		((= number 1) (done_dialog 1))
		((= number 2) (done_dialog 4))
		((= number 3) (done_dialog 2))
		((= number 4) (done_dialog 3))
	)
)

(defun CheckEntity ( entity / lyr ent answer)	; Checks entity on valid layer
;****************************************************************************
;Function:  CheckEntity
;Description:  This function checks the entity for proper layer and type
;Function(s):  ModifyGeometry()
;Arguments:
;Globals:   None
;Revised:
;****************************************************************************
	(setq	answer	T)
	(if (and (/= Div "AL") (/= Div "GA"))										;[Modified for Trans]
		(progn
			(if (< (strlen (cdr (assoc 8 entity))) 10)
				(setq	answer	nil)
			)
			(if answer
				(if (not (member (substr (cdr (assoc 8 entity)) 1 3) Lst_Fd_V))
					(setq	answer	nil)
				)
			)
		)
		(progn															;[Added for Trans]
			(if (< (strlen (cdr (assoc 8 entity))) 11)
				(setq	answer	nil)
			)
			(if answer
				(if (not (member (substr (cdr (assoc 8 entity)) 6 4) Lst_Fd_V))
					(setq	answer	nil)
				)
			)
		)
	)
	answer
)

(defun DrawPolyline ( Ap1 Ent_Lst /	EntNam	; Create new polyline entity
								Lyr Was Ss1 Pt1 Pt Pt2 NewEnt ClT CCl Tst1 EntGrp
								OrgEntH Bubba AltEnt AltEntH RLst OAltNam AltNam Alt_Sel )
;****************************************************************************
;Function:  DrawPolyline
;Description:  This function will create a new polyline entity
;Function(s):  property()
;Arguments: Ap1 Ent
;Globals:   Lst_Ph_W	SF
;Calls:  (breakit) which returns TRUE if break is needed & sets pt1 to ENDP if close.
;Revised:
;****************************************************************************
	(if Bug
		(progn
			(princ "\nProperty.Lsp!DrawPolyline - Entered.")
			(princ "\n   parameter Ap1 = ")(prin1 Ap1)
			(princ "\n   parameter Ent_Lst = ")(prin1 Ent_Lst)(princ "\n")
		)
	)
	(setq EntNam nil
		 ClT	   (getvar "CELTYPE")
		 CCl	   (getvar "CECOLOR")
		 Ss1	   (ssadd)
	)
	(if (/= (strcase ClT) "BYLAYER")
		(setvar "CELTYPE" "BYLAYER")
	)
	(if (/= (strcase CCl) "BYLAYER")
		(setvar "CECOLOR" "BYLAYER")
	)
	(command "_.layer" "t" "0" "u" "0" "on" "0" "s" "0" "")
	(if Ent_Lst
		(if (nth 8 Ent_Lst)
			(setq Tst1 (GrpEntChgFilt (nth 8 Ent_Lst)))
			(setq Tst1 nil)
		)
		(setq Tst1 nil)
	)
	(if Tst1
		(if (nth 3 Tst1)
			(setq EntGrp  (nth (nth 3 Tst1) (nth 1 Tst1))
				 OrgEntH (cdr (assoc 5 (entget (nth 8 Ent_Lst))))
				 Bubba   (if Bug
						    (princ "\nChg Grp Detected...")
					    )
			)
			(setq EntGrp nil)
		)
		(setq EntGrp nil)
	)
	(if EntGrp
		(command "-GROUP" "E" (car (nth (nth 3 Tst1) (nth 0 Tst1))))
	)
	(if EntGrp
		(if (= (length EntGrp) 2)
			(if (= (cdr (assoc 5 (entget (nth 0 EntGrp)))) OrgEntH)
				(setq AltEnt  (nth 1 EntGrp)
					 AltEntH (cdr (assoc 5 (entget (nth 1 EntGrp))))
					 Bubba   (if Bug
							    (princ (strcat "\nAltEnt = " AltEntH)
							    )
						    )
				)
				(setq AltEnt  (nth 0 EntGrp)
					 AltEntH (cdr (assoc 5 (entget (nth 0 EntGrp))))
					 Bubba   (if Bug
							    (princ (strcat "\nAltEnt = " AltEntH)
							    )
						    )
				)
			)
		)
		(setq AltEnt nil)
	)
	(if Ent_Lst
		(if (wcmatch (cdr (assoc 0 (entget (nth 8 Ent_Lst)))) "*POLYLINE")
			(setq RLst    (TstBreakIt
						    (cons (nth 8 Ent_Lst) (list (nth 7 Ent_Lst)))
					    )
				 OAltNam AltNam
				 Ent_Lst (cdr (cdr (reverse Ent_Lst)))
				 Ent_Lst (cons (cadr RLst) Ent_Lst)
				 Ent_Lst (reverse (cons (car RLst) Ent_Lst))
				 Pt1	    (nth 7 Ent_Lst)
			)
			(if (= (cdr (assoc 0 (entget (nth 8 Ent_Lst)))) "INSERT")
				(setq Pt1	    (osnap (nth 7 Ent_Lst) "ins"))
				(setq Pt1	    (nth 7 Ent_Lst))
			)
		)
		(setq Pt1 (getpoint "\nFrom Point: "))
	)
	(if AltEnt
		(setq Alt_Sel (TstBreakIt (cons AltEnt (list (nth 7 Ent_Lst))))
			 Bubba   (princ "\nMaking Groups...")
			 Bubba   (command "-group"
						   "C"
						   (strcat "ChPln" (itoa (GetGrpNex)))
						   "Change Mode Pline Pair"
						   (car Alt_Sel)
						   (nth 8 Ent_Lst)
						   ""
				    )
			 Bubba   (command "-group"
						   "C"
						   (strcat "ChPln" (itoa (GetGrpNex)))
						   "Change Mode Pline Pair"
						   OAltNam
						   AltNam
						   ""
				    )
			 Bubba   (princ "\nDone Making Groups!")
		)
	)
	(if (or (= (stpDot AppNam) "CADET20")(= (stpDot AppNam) "CADET"))
		(c:what_mode)						; Draws Service Lines on WE
	)
	(if (= ug_data "1")
		(progn
			(initget 0 "Arc")
				(while (setq pt2(getpoint pt1 "<A>rc/<Second point>:"))
				(princ "\n")
					(if (and (not (null pt2)) (not (equal (type pt2) (quote STR))))
						(progn
							(command "_.line" pt1 pt2 "")
							(setq pt1 pt2)
							(ssadd (entlast) ss1)
							(if Bug (princ (strcat "\nBug:" (itoa (sslength ss1)))))
						)
						(if (not (null pt2))
							(progn
								(setq pt2 (getpoint pt1 "Second point of arc:")
									 pt3 (getpoint pt2 "Endpoint of arc :")
								)
								(command "arc" pt1 pt2 pt3)
								(setq pt1 pt3)
								(ssadd (entlast) ss1)
								(if Bug (princ (strcat "\nBug:" (itoa (sslength ss1)))))
							)
						)
					)
					(initget 0 "Arc")
				)
				(if Bug (princ (strcat "\nBug:" (itoa (sslength ss1)))))
		)
		(progn
			(while (setq Pt2 (getpoint Pt1 "\nTo point: "))
					(command "_.line" Pt1 Pt2 "")
					(setq Pt1 pt2)
					(ssadd (entlast) Ss1)
			)
		)
	)
	(if (> (sslength Ss1) 0)
		(progn
			(command "_.pedit" (ssname Ss1 0) "y" "j" Ss1 "" "")
			(setq NewEnt (entlast))
			(AddEED Ap1 NewEnt)
			(if (not EntNam)
				(setq EntNam NewEnt)
			)
			(if (and (/= Div "AL") (/= Div "GA"))								;[Modified for Trans]
				(setq Lyr (MakeLayer NewEnt))
				(setq Lyr (MakeLayerTrans Ent_Lst))
			)
			(if (OR (= Div "AL") (= Div "GA"))
				(progn													; if Transmission
					(if (= Div "GA")
						(if (= (substr Lyr 6 4) "0000")
							(command "_.change" Newent "" "p" "la" Lyr "LT" "BYLAYER" "")
							(command "_.change" Newent "" "p" "la" Lyr "LT" "POWER_LINE" "")
						)
						(command "_.change" Newent "" "p" "la" Lyr "LT" "BYLAYER" "")
					)
				)
				(command "_.change" Newent "" "p" "la" Lyr "")
			)
			
			(command "_.change" Newent "" "p" "la" Lyr "")
			(if (= (strcase (substr Lyr 4 1)) "O")
				(command "_.PEDIT"
					    Newent
					    "W"
					    (* (nth (atoi (substr Lyr 8 1)) Lst_Ph_W) SF)
					    ""
				)
				(command "_.PEDIT"
					    Newent
					    "W"
					    (* (nth 5 Lst_Ph_W) SF)
					    ""
				)
			)
		)
	)
	(if Bug (princ "\nProperty.Lsp!DrawPolyline - Done."))
	(setvar "CELTYPE" ClT)
	(setvar "CECOLOR" CCl)
)
(defun PreGeometry ( ap1 /	cnt et1 et2 app	; Preselection testing
						Lngth e1 e2 lyr ss1 ss2 ss3 Tst1 )
	(if Bug
		(progn
			(princ "\nProperty.Lsp!PreGeometry - Entered")
			(princ "\n   Parameter ap1: ")(prin1 ap1)
		)
	)
	(princ "\nSelect geometry to modify: ")
	(setq	ss1		nil
			ss2		nil
			ss3		nil
	)
	(while (not ss1)
		(setq	ss1		(ssget))
		(if ss1
			(setq	Tst1		(GrpSSChgFilt ss1))	; filters for poly-lines only
		)
		(if (nth 3 Tst1)
			(progn
				(alert
					"ERROR: Selection Set contains Changed Group Pairs\nChanges being effected"
				)
				(foreach x (nth 3 Tst1)
					(EffChg (nth x (nth 0 Tst1))
						   (nth x (nth 1 Tst1))
					)
				)
				(setq ss1 (nth 5 Tst1))
			)
			(setq ss1 (nth 5 Tst1))
		)
		(if ss1
			(progn
				(setq app	(list ap1)
					 cnt	0
				)
				(repeat (sslength ss1)
					(setq e1	(ssname ss1 cnt)
						 e2	(entget e1 app)
						 cnt	(1+ cnt)
					)
					(if Bug
						(princ (strcat "\n" (itoa cnt)))
					)
					(if (CheckEntity e2)
						(if (assoc -3 e2)
							(if (boundp (quote ss2))
								(setq ss2 (ssadd e1 ss2))
								(setq ss2	(ssadd)
									 ss2	(ssadd e1 ss2)
								)
							)
							(if (boundp (quote ss3))
								(setq ss3 (ssadd e1 ss3))
								(setq ss3	(ssadd)
									 ss3	(ssadd e1 ss3)
								)
							)
						)
					)
				)
			)
			(progn
				(alert "ERROR: No geometry selected..!  Try again: "
				)
				(setq Lngth 0)
			)
		)
	)
	;	Cleanup
	(if ss1	(setq	ss1	nil))
	(gc)
	(if Bug
		(progn
			(princ "\nProperty.Lsp!PreGeometry - Finished")
			(princ "\n   Output ap1: ")(prin1 (list ss2 ss3))(princ "\n\n")
		)
	)
	(list ss2 ss3)
)

(defun ModifyGeometry ( ss1 ap1 /	cnt			; Modifies selected entities
							app Lngth lyr et1 et2 )
;****************************************************************************
;Function:  ModifyGeometry
;Description:  This function modifies the selected entities
;Function(s):  property()
;Arguments: ap1
;Globals:   None
;Revised:
;****************************************************************************
	(if Bug
		(progn
			(princ "\nProperty.Lsp!ModifyGeometry - Entered.")
			(princ "\n   parameter ss1 = ")(prin1 ss1)
			(princ "\n   parameter ap1 = ")(prin1 ap1)(princ "\n")
		)
	)
	(setq	Lngth	(sslength ss1)
			app		(list ap1)
			cnt		0
	)
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
	(repeat Lngth
		(setq	et1		(ssname ss1 cnt)
				et2		(entget et1 app)
		)
		(if (CheckEntity et2)
			(if (assoc -3 et2)
				(progn
					(AddEED ap1 et1)
					(setq lyr (MakeLayer et1))
					(command "_.change" et1 "" "p" "la" lyr "")
					(if (or (eq (cdr (assoc 0 et2)) "POLYLINE")
						   (eq (cdr (assoc 0 et2)) "LWPOLYLINE")
					    )
						(if (= (strcase (substr Lyr 4 1)) "O")
							(command "_.PEDIT"
								    et1		;;;Newent
								    "W"
								    (* (nth (atoi (substr Lyr 8 1)) Lst_Ph_W) SF)
								    ""
								    "_.ChProp"
								    et1
								    ""
								    "T"
								    SFF
								    ""
							)
							(command "_.PEDIT"
								    et1		;;;Newent
								    "W"
								    (* (nth 5 Lst_Ph_W) SF)
								    ""
								    "_.ChProp"
								    et1
								    ""
								    "T"
								    SFF
								    ""
							)
						)
					)
					(if (eq (cdr (assoc 0 et2)) "INSERT")
						(FixAttLay et1 lyr)
					)
				)
				(progn
					(if	(or	(and	(= Oh_Data "1")
								(/= Pri_S_Data "0")
								(/= Pri_T_Data "0")
								(/= Neu_S_Data "0")
								(/= Neu_T_Data "0")
							)
							(and	(= Ug_Data "1")
								(/= Pri_S_Data "0")
								(/= Pri_T_Data "0")
							)
						)
						(AddEED ap1 et1)
					)
					(if (and (/= Div "AL") (/= Div "GA"))						;[Modified for Trans]
						(setq lyr (MakeLayer et1))
						(setq lyr (MakeLayerTrans et1))
					)
					(command "_.change" et1 "" "p" "la" lyr "")
					(if (or (eq (cdr (assoc 0 et2)) "POLYLINE")
						   (eq (cdr (assoc 0 et2)) "LWPOLYLINE")
					    )
						(if (= (strcase (substr Lyr 4 1)) "O")
							(command "_.PEDIT"
								    et1		;;;Newent
								    "W"
								    (* (nth (atoi (substr Lyr 8 1)) Lst_Ph_W) SF)
								    ""
								    "_.ChProp"
								    et1
								    ""
								    "T"
								    SFF
								    ""
							)
							(command "_.PEDIT"
								    et1		;;;Newent
								    "W"
								    (* (nth 5 Lst_Ph_W) SF)
								    ""
								    "_.ChProp"
								    et1
								    ""
								    "T"
								    SFF
								    ""
							)
						)
					)
					(if (eq (cdr (assoc 0 et2)) "INSERT")
						(FixAttLay et1 lyr)
					)
				)
			)
			(if Bug (princ (strcat "\nModifyGeometry doesn't like " (cdr (assoc 0 et2)))))
		)
		(setq cnt (1+ cnt))
	)
	(princ)
)

(defun AddEED ( ap1 et1 /	st st1 st2		; Adds EED data to entities
						st3 st4 ed1 app et2 eed st st_3 ed1_1 Tst1 Tst2 Tst3 Tst4 Bubba )
;****************************************************************************
;Function:  AddEED
;Description:  This function will create or modify extended entity data
;Function(s):  ModifyGeometry()
;Arguments: ap1 app et1
;Globals:   None
;Revised:
;****************************************************************************
	(if (null (tblsearch "APPID" ap1))
		(setq ap1 (regapp ap1))
	)
	(setq st	nil
		 st1	nil
		 st2	nil
		 st3	nil
		 st4	nil
		 ed1	nil
		 et2	(entget et1)
		 app	(list ap1)
	)
	(if wssp
		(if wspsp
			(if (null Pri_S_datr)
				(setq Tst1  (nth (1- (atoi Pri_S_Data)) Lst_Wr_S)
					 Tst2  (nth (1- (atoi Pri_T_Data)) Lst_Wr_T)
					 Bubba (if Bug
							  (princ (strcat "\nPri_S_Data="
										  Pri_S_Data
								    )
							  )
						  )
					 Bubba (if Bug
							  (princ (strcat "\nPri_T_Data="
										  Pri_T_Data
								    )
							  )
						  )
				)
				(setq Tst1  (nth (1- (atoi Pri_S_Datr)) Lst_Wr_S)
					 Tst2  (nth (1- (atoi Pri_T_Datr)) Lst_Wr_T)
					 Bubba (if Bug
							  (princ (strcat "\nPri_S_Datr="
										  Pri_S_Datr
								    )
							  )
						  )
					 Bubba (if Bug
							  (princ (strcat "\nPri_T_Datr="
										  Pri_T_Datr
								    )
							  )
						  )
				)
			)
			(if (null Pri_S_datr)
				(setq Tst1  (nth (atoi Pri_S_Data) Lst_Wr_S)
					 Tst2  (nth (atoi Pri_T_Data) Lst_Wr_T)
					 Bubba (if Bug
							  (princ (strcat "\nPri_S_Data="
										  Pri_S_Data
								    )
							  )
						  )
					 Bubba (if Bug
							  (princ (strcat "\nPri_T_Data="
										  Pri_T_Data
								    )
							  )
						  )
				)
				(setq Tst1  (nth (atoi Pri_S_Datr) Lst_Wr_S)
					 Tst2  (nth (atoi Pri_T_Datr) Lst_Wr_T)
					 Bubba (if Bug
							  (princ (strcat "\nPri_S_Datr="
										  Pri_S_Datr
								    )
							  )
						  )
					 Bubba (if Bug
							  (princ (strcat "\nPri_T_Datr="
										  Pri_T_Datr
								    )
							  )
						  )
				)
			)
		)
	)
	(if wssn
		(if (eq Oh_Data "1")
			(if wspsn
				(if (null Neu_S_datr)
					(setq Tst3  (nth (1- (atoi Neu_S_Data)) Lst_Wr_S)
						 Tst4  (nth (1- (atoi Neu_T_Data)) Lst_Wr_T)
						 Bubba (if Bug
								  (princ (strcat "\nNeu_S_Data="
											  Neu_S_Data
									    )
								  )
							  )
						 Bubba (if Bug
								  (princ (strcat "\nNeu_T_Data="
											  Neu_T_Data
									    )
								  )
							  )
					)
					(setq Tst3  (nth (1- (atoi Neu_S_Datr)) Lst_Wr_S)
						 Tst4  (nth (1- (atoi Neu_T_Datr)) Lst_Wr_T)
						 Bubba (if Bug
								  (princ (strcat "\nNeu_S_Datr="
											  Neu_S_Datr
									    )
								  )
							  )
						 Bubba (if Bug
								  (princ (strcat "\nNeu_T_Datr="
											  Neu_T_Datr
									    )
								  )
							  )
					)
				)
				(if (null Neu_S_datr)
					(setq Tst3 (nth (atoi Neu_S_Data) Lst_Wr_S)
						 Tst4 (nth (atoi Neu_T_Data) Lst_Wr_T)
					)
					(setq Tst3 (nth (atoi Neu_S_Datr) Lst_Wr_S)
						 Tst4 (nth (atoi Neu_T_Datr) Lst_Wr_T)
					)
				)
			)
			(setq Tst3 nil
				 Tst4 nil
			)
		)
	)
	(if wssp
		(if (or (eq Oh_Data "1") (eq Tm_Data "1"))					;[Modified for Trans]
			(setq st (list	(cons 1000 Tst1)
						(cons 1000 Tst2)
						(cons 1000 Tst3)
						(cons 1000 Tst4)
				    )
			)
			(setq st (list (cons 1000 Tst1) (cons 1000 Tst2)))
		)
	)
	(if st
		(setq ed1	  (list (cons -3 (list (cons ap1 st))))
			 Bubba (if Bug
					  (if (eq Oh_Data "1")
						  (princ (strcat "\nAddEED got "
									  Tst1	  "-"
									  Tst2	  "&-"
									  Tst3	  "-"
									  Tst4
									 )
						  )
						  (princ (strcat "\nAddEED got "
									  Tst1
									  "-"
									  Tst2
							    )
						  )
					  )
				  )
		)
		(if Bug
			(princ "\nAddEED thinks it has no data.")
		)
	)
	(if ed1
		(if (or (eq (cdr (assoc 0 et2)) "POLYLINE")
			   (eq (cdr (assoc 0 et2)) "LWPOLYLINE")
		    )
			(progn
				(setq et2 (append et2 ed1))
				(entmod et2)
				(entupd et1)
				(if Bug
					(princ "\nAddEED thinks it did!")
				)
			)
		)
	)
)

(defun MakeLayerTrans (EntityLst /  Typ ColorNum LineType NewLayerName)  ;Name
	(if Bug
		(progn
			(princ "\nProperty.Lsp!MakeLayerTrans - Entered")
			(princ "\n   Parameter Entity: ")(prin1 EntityLst)
			(princ "\n   GVar fds: ") (prin1 fds)
			(princ "\n   GVar Fd_Data: ") (prin1 Fd_Data)
			(princ "\n   GVar kvs: ") (prin1 kvs)
			(princ "\n   GVar Vt_Data: ") (prin1 Vt_Data)
		)
	)				
	;	Get information from passed in entity list data.
	(setq	SeedLayer    	(cdr (assoc 8 (entget (nth 8 EntityLst))))
			PltLoc		(substr SeedLayer 1 5)
	)
	
	;	Start Building new layer name - Plant location / FacID
	(setq NewLayerName PltLoc)
	(if Bug
		(progn
			(princ "\n  variable 1  NewLayerName = ")(prin1 NewLayerName) (princ "\n")
		)
	)
	
	;	Add Line number
	(if fds												;Feeder Dialog box data entered
		(if (eq Fd_Data "0")
			(setq NewLayerName	(strcat NewLayerName	(substr SeedLayer 6 4))
			 	 Fd_Data		NewLayerName
			)
			(setq NewLayerName	(strcat NewLayerName Fd_Data)
			)
		)
		(setq NewLayerName	(strcat NewLayerName (substr SeedLayer 6 4))	;if not entered via Dialog use entity info for Feeder code
			 Fd_Data		NewLayerName
		)
	)
	(if Bug
		(progn
			(princ "\n  variable 2  NewLayerName = ")(prin1 NewLayerName) (princ "\n")
		)
	)
	
	;	Add voltage code
	(if kvs
		(if (eq Vt_Data "0")
			(setq NewLayerName	  (strcat NewLayerName (substr SeedLayer 10 2))
			)
			(setq NewLayerName	  (strcat NewLayerName Vt_Data)
			)
		)
		(setq NewLayerName	  (strcat NewLayerName (substr SeedLayer 10 2))
		)
	)
	(if Bug
		(progn
			(princ "\n  variable 3  NewLayerName = ")(prin1 NewLayerName) (princ "\n")
		)
	)
	
	(MakeLayer2 NewLayerName)	;	calls .NET dll to add the layer if needed
	NewLayerName
)

(defun MakeLayer ( Entity /	Nam Typ Clr Lty	; Creates and set the new layers - rule based
						Bubba EMode )
;****************************************************************************
;Function:  MakeLayer
;Description:  This function creates and set the new layer
;Function(s):  ModifyGeometry()
;Arguments: Entity
;Globals:   Fd_Data Oh_Data Ug_Data Ph_Data Vt_Data Lst_Ph_S
;Revised:
;****************************************************************************
	(if (null ColorBy)
		(setq ColorBy "FD")
	)
	(if Entity
		(setq Nam	(cdr (assoc 8 (entget Entity)))			;Layer name
			 Typ	(cdr (assoc 0 (entget Entity)))			;Text string indicating the entity type 
		)
		(setq Nam "0")
	)
	(if (> (strlen Nam) 10)
		(setq EMode (substr Nam 11 1))
		(setq EMode nil)
	)
	(setq	Clr	(cdr (assoc 62 (tblsearch "LAYER" Nam)))	;Color number (if negative, layer is off)	
			Lty	(cdr (assoc 6  (tblsearch "LAYER" Nam)))	;Linetype name
	)
	(if (= (substr Nam 5 2) "CP")
		(setq Clr 2)
	)
	(if Bug
		(princ (strcat "\nNam=" Nam))
	)
	(if fds
		(if (eq Fd_Data "0")
			(setq Lyr	    (substr Nam 1 3)
				 Bubba   (if Bug
						    (princ (strcat "\nFeed-" (substr Nam 1 3))
						    )
						    nil
					    )
				 Fd_Data Lyr
			)
			(setq Lyr	  Fd_Data
				 Bubba (if Bug
						  (princ (strcat "\nFeed-" Fd_Data))
						  nil
					  )
			)
		)
		(setq Lyr	    (substr Nam 1 3)
			 Bubba   (if Bug
					    (princ (strcat "\nFeed-" (substr Nam 1 3)))
					    nil
				    )
			 Fd_Data Lyr
		)
	)
	(if (and (eq Oh_Data "0") (eq Ug_Data "0"))
		(setq Lyr	  (strcat Lyr (substr Nam 4 1))
			 Bubba (if Bug
					  (princ (strcat "\nLine-" (substr Nam 4 1)))
					  nil
				  )
		)
		(if (eq Oh_Data "0")
			(setq Lyr	  (strcat Lyr "U")
				 Bubba (if Bug
						  (princ "\nLine-UnderGround")
						  nil
					  )
			)
			(setq Lyr	  (strcat Lyr "O")
				 Bubba (if Bug
						  (princ "\nLine-OverHead")
						  nil
					  )
			)
		)
	)
	(if Typ
		(cond	((or (= Typ "POLYLINE") (= Typ "LWPOLYLINE"))
					(if (eq Nam "0")
						(setq	Lyr		(strcat Lyr "CK-")
								Bubba	(if Bug
											(princ "\nNam=0, Lyr=CK-")
											nil
										)
						)
						(setq	Lyr		(strcat Lyr (substr Nam 5 3))
								Bubba	(if Bug
											(princ (strcat "\nNam-" (substr Nam 5 3)))
											nil
										)
						)
					)
				)
				((= Typ "INSERT")
					(if (eq Nam "0")
						(setq	Lyr		(strcat Lyr "CK-")
								Bubba	(if Bug
											(princ "\nNam=0, Lyr=CK-")
											nil
										)
						)
						(setq	Lyr		(strcat Lyr (substr Nam 5 3))
								Bubba	(if Bug
											(princ (strcat "\nNam-" (substr Nam 5 3)))
											nil
										)
						)
					)
				)
				((= Typ "ATTRIB")
					(if (eq Nam "0")
						(setq	Lyr		(strcat Lyr "CK-")
								Bubba	(if Bug
											(princ "\nNam=0, Lyr=CK-")
											nil
										)
						)
						(setq	Lyr		(strcat Lyr (substr Nam 5 2) "D")
								Bubba	(if Bug
											(princ (strcat "\nNam-" (substr Nam 5 2) "D"))
											nil
										)
						)
					)
				)
				(T
					(if (eq Nam "0")
						(setq	Lyr		(strcat Lyr "CK-")
								Bubba	(if Bug
											(princ "\nNam=0, Lyr=CK-")
											nil
										)
						)
						(setq	Lyr		(strcat Lyr (substr Nam 5 3))
								Bubba	(if Bug
											(princ (strcat "\nNam-" (substr Nam 5 3)))
											nil
										)
						)
					)
				)
		)
		(if Bug (princ "\nNo Typ found!"))
	)
	(if phs
		(if (eq Ph_Data "0")
			(setq Lyr	  (strcat Lyr (substr Nam 8 1))
				 Bubba (if Bug
						  (princ (strcat "\nPh=0, Lyr="
									  (substr Nam 8 1)
							    )
						  )
						  nil
					  )
				 Lty	  "CONTINUOUS"
			)
			(progn
				(setq Lyr	  (strcat	Lyr
								(itoa (- (length Lst_Ph_S)
									    (length (member	Ph_Data
													Lst_Ph_S
											  )
									    )
									 )
								)
						  )
					 Bubba (if Bug
							  (princ
								  (strcat
									  "\nPh="
									  Ph_Data
									  ", Lyr="
									  (itoa (- (length Lst_Ph_S
											 )
											 (length
												 (member
													 Ph_Data
													 Lst_Ph_S
												 )
											 )
										   )
									  )
								  )
							  )
							  nil
						  )
				)
				(if (eq (substr Lyr 4 1) "O")
					(setq Lty "CONTINUOUS")
					(cond
						((= (atoi Ph_Data) 0)
							(setq Lty "CONTINUOUS")
						)
						((or	(= (atoi Ph_Data) 1)
							(= (atoi Ph_Data) 2)
							(= (atoi Ph_Data) 3)
						 )
							(setq Lty "DASHED")
						)
						((or	(= (atoi Ph_Data) 4)
							(= (atoi Ph_Data) 5)
							(= (atoi Ph_Data) 6)
						 )
							(setq Lty "HIDDEN")
						)
						(T	(setq Lty "CONTINUOUS"))
					)
				)
				(if Bug
					(princ (strcat "\nLty=" Lty))
					nil
				)
			)
		)
		(setq Lyr	  (strcat Lyr (substr Nam 8 1))
			 Bubba (if Bug
					  (princ (strcat "\nPh=0, Lyr=" (substr Nam 8 1))
					  )
					  nil
				  )
			 Lty	  "CONTINUOUS"
		)
	)
	(if (or (= (stpDot AppNam) "CADET20")(= (stpDot AppNam) "CADET"))
		(if (= (substr Lyr 5 2) "CK")
			(if Emode
				(if (or (= EMode "I") (= EMode "C"))
					(setq Lty "HIDDEN2")
					(setq Lty "CONTINUOUS")
				)
				(cond 
					((or(= AppMode "I")(= AppMode "C"))
						(setq Lty "HIDDEN2")
					)
					((= AppMode "R")
						(setq Lty "REMOVED")
					)
					(T
						(setq Lty "CONTINUOUS")
					)
				)
			)
			(setq Lty "CONTINUOUS")
		)
		(if (eq (substr Lyr 4 1) "O")
			(setq Lty "CONTINUOUS")
			(cond
				((= (strlen Ph_Data) 3)
				 (setq Lty "CONTINUOUS")
				)
				((= (strlen Ph_Data) 2)
				 (setq Lty "DASHED")
				)
				((= (strlen Ph_Data) 1)
				 (setq Lty "HIDDEN")
				)
			)
		)
	)
	(if kvs
		(if (eq Vt_Data "0")
			(setq Lyr	  (strcat Lyr (substr Nam 9 2))
				 Bubba (if Bug
						  (princ "\nVt-0")
						  nil
					  )
			)
			(setq Lyr	  (strcat Lyr Vt_Data)
				 Bubba (if Bug
						  (princ (strcat "\nVt-" Vt_Data))
						  nil
					  )
			)
		)
		(setq Lyr	  (strcat Lyr (substr Nam 9 2))
			 Bubba (if Bug
					  (princ "\nVt-0")
					  nil
				  )
		)
	)
	(cond
		((eq ColorBy "FD")
			(setq	Clr		(nth	(- (length Lst_Fd_V)
									(length (member Fd_Data Lst_Fd_V))
								)
						   		Lst_Fd_C
							)
					Bubba	(if Bug
								(princ (strcat "\nColorby-" ColorBy))
								nil
							)
			)
		)
		((eq ColorBy "VT")
			(setq	Clr		(nth (- (length Lst_Vt_S)
									(length (member Vt_Data Lst_Vt_S))
					   			)
								Lst_Vt_C
							)
					Bubba	(if Bug
								(princ (strcat "\nColorby-" ColorBy))
								nil
							)
			)
		)
		((eq ColorBy "PH")
			(setq	Clr		(nth	(- (length Lst_Ph_S)
									(length (member Ph_Data Lst_Ph_S))
								)
								Lst_Ph_C
							)
					Bubba	(if Bug
								(princ (strcat "\nColorby-" ColorBy))
								nil
							)
			)
		)
		((eq ColorBy "OU")
			(if	(eq Oh_Data "1")
				(setq Clr 5)
			)
			(if	(eq Ug_Data "1")
				(setq Clr 1)
			)
			(if	Bug
				(princ (strcat "\nColorby-" ColorBy))
			)
		)
	)
	(if (> (strlen Nam) 5)					; Specific Overrides for Text or CP
		(if (member (substr Nam 7 1) (list "B" "T"))
			(setq	Clr		7)
			(if (= (substr Nam 5 2) "CP")
				(setq	Clr		2)
			)
		)
	)
	(if Bug
		(princ (strcat "\nClr=" (itoa Clr)))
	)
	(if Bug
		(princ (strcat "\n" Lyr))
	)
	(if Bug
		(setq Ed_Lyr Lyr
			 Ed_Clr Clr
			 Ed_Lty Lty
		)
	)
	(if (null DontE)
		(if (or (= (stpDot AppNam) "CADET20")(= (stpDot AppNam) "CADET"))
			(if (<= (strlen Lyr) 10)
				(cond ((= AppMode "I") (setq Lyr (strcat Lyr "I")))
					 ((= AppMode "C") (setq Lyr (strcat Lyr "C")))
					 ((= AppMode "R") (setq Lyr (strcat Lyr "R")))
				)
				(cond ((= AppMode "I")
					  (setq Lyr (strcat (substr Lyr 1 10) "I"))
					 )
					 ((= AppMode "C")
					  (setq Lyr (strcat (substr Lyr 1 10) "C"))
					 )
					 ((= AppMode "R")
					  (setq Lyr (strcat (substr Lyr 1 10) "R"))
					 )
				)
			)
		)
		(if (<= (strlen Lyr) 10)
			(if EMode
				(setq Lyr (strcat Lyr EMode))
			)
		)
	)
	(if (null (tblsearch "LAYER" Lyr))
		(command "_.layer" "m" Lyr "c" Clr Lyr "lt" Lty Lyr "")
	)
	(if (and Nam Lyr Bug)
		(princ (strcat "\n[Bug] Nam{" Nam "{ -> {" Lyr "}"))
	)
	Lyr
)

(defun GetEntity ( Ap1 Number /	Pnt Fd1 Oup 	; Selects entities - rule based
							Lyr Ph1 Kv1 Ph2 Ws1 Answer PrmptStr Pt Ent ApLst EntTmp
							ELay Bubba Edat0 Edat1 Edat2 Ent1 EntList Bub )
;****************************************************************************
;Function:  GetEntity
;Description:  This function will prompt the user to select an entity
;Function(s):  property()
;Arguments: ap1 number
;Globals:   None
;Revised:
;****************************************************************************
	(setq Answer  nil
		 Ent	    nil
		 Ent1    nil
		 Pt	    nil
		 ApLst   nil
		 Entlist (list nil nil nil nil nil nil nil nil)
	)
	(cond
		((= Number 1) (setq PrmptStr "\nSelect Primary Entity: "))
		((= Number 2) (setq PrmptStr "\nSelect Entity to Query: "))
		((= Number 5) (setq PrmptStr "\nSelect PolyLine: "))
		(T (setq PrmptStr "\nSelect Entity to Query: "))
	)
	(princ (strcat "\n" PrmptStr))
	(if (or (= (stpDot AppNam) "CADET20")(= (stpDot AppNam) "CADET"))
		(progn
			(setq Ent (entsel))
			(if Ent
				(if (= (substr	(setq ELay
									(cdr	(assoc
											8
											(cdr	(entget
													(car	Ent
													)
												)
											)
										)
									)
							)
							5
							2
					  )
					  "CK"
				    )
					(setq Ent1   (entget (car Ent) (list "*"))
						 Bubba  (if (and ELay Bug)
								   (princ	(strcat "\nEnt Lay-T-"
											   ELay
										)
								   )
							   )
						 Pt	   (cadr Ent)
						 EntTmp Ent
					)
					(setq Ent	  nil
						 Bubba (if (and ELay Bug)
								  (princ (strcat "\nEnt Lay-F-"
											  ELay
									    )
								  )
							  )
					)
				)
			)
		)
		(while (not (boundp (quote Ent)))
			(setq Ent (entsel))
			(if (boundp (quote Ent))
				(if (wcmatch (cdr (assoc 0 (cdr (entget (car Ent))))) "*POLYLINE")
					(if (and (/= Div "AL") (/= Div "GA"))												;[Revised for GCC]
						(if (member (substr (cdr (assoc 8 (cdr (entget (car Ent))))) 5 2) (list "FL" "CK"))
							(setq Ent1   (entget (car Ent) (list "*"))
								 Pt	   (cadr Ent)
								 EntTmp Ent
							)
							(setq Ent	  nil
								 Bubba (princ "\nIncorrect Layer for Circuit.")
							)
						)
						(setq Ent1   (entget (car Ent) (list "*"))
							 Pt	   (cadr Ent)
							 EntTmp Ent
						)
					)
					(if	(and	(= (cdr (assoc 0 (cdr (entget (car Ent))))) "INSERT")
							(or
								(= (substr (cdr (assoc 8 (cdr (entget (car Ent))))) 5 2) "CK")
								(= (substr (cdr (assoc 8 (cdr (entget (car Ent))))) 5 2) "FL")
							)
							(or
								(= (cdr (assoc 2 (cdr (entget (car Ent))))) "NODE-SUB")
								(= (cdr (assoc 2 (cdr (entget (car Ent))))) "GETAWAY")
								(= (cdr (assoc 2 (cdr (entget (car Ent))))) "165")
							)
						)
						(setq Ent1   (entget (car Ent) (list "*"))
							 Pt	   (cadr Ent)
							 EntTmp Ent
						)
						(setq Ent	  nil
							 Bubba (princ "\nIncorrect Object for Circuit.")
						)
					)
				)
				(setq Ent	  nil
					 Bubba (princ "\nNo Object Selected for Circuit.")
				)
			)
		)
	)
	(if (not (tblsearch "APPID" Ap1))
		(regapp Ap1)
	)
	(if Ent
		(if (not (assoc Ap1 (cdr (assoc -3 Ent1))))
			(if (= (substr (cdr (assoc 8 Ent1)) 4 1) "O")
				(setq Edat0 (cons Ap1
							   (list (cons 1000 "")
								    (cons 1000 "")
								    (cons 1000 "")
								    (cons 1000 "")
							   )
						  )
					 Edat1 (cdr (assoc -3 Ent1))
					 Edat2 (append Edat1 (list Edat0))
					 Ent1  (subst (cons -3 Edat2) (assoc -3 Ent1) Ent1)
					 Bubba (entmod Ent1)
				)
				(setq Edat0 (cons Ap1
							   (list (cons 1000 "")
								    (cons 1000 "")
							   )
						  )
					 Edat1 (cdr (assoc -3 Ent1))
					 Edat2 (append Edat1 (list Edat0))
					 Ent1  (subst (cons -3 Edat2) (assoc -3 Ent1) Ent1)
					 Bubba (entmod Ent1)
				)
			)
		)
	)
	(if Ent
		(setq Pnt	  (osnap Pt "nea")
			 Ent	  (car Ent)
			 ApLst (assoc Ap1
					    (cdr (assoc -3 (entget Ent (list "*"))))
				  )
		)
	)
	(if Bug
		(setq	Ed_Lst	ApLst
				Ed_Ent	Ent1
		)
	)
	(if Ent
		(if	(and	(= Number 1) (and (/= Div "AL") (/= Div "GA"))					;[Modified for Trans]
				(not
					(or
						(= (substr (cdr (assoc 8 Ent1)) 5 2) "CK")
						(= (substr (cdr (assoc 8 Ent1)) 5 2) "FL")
					)
				)
			)
			(progn
				(setq Ent	 nil
					 Ent1 nil
				)
				(if Bug (princ (strcat "\nNot Good Enough! " (itoa Number))))
				(GetEntity Ap1 Number)
			)
			(setq Answer T)
		)
	)
	(if Ent1
		(if (and (/= Div "AL") (/= Div "GA"))									;[Modified for Trans]
			(if (and (>= (strlen (cdr (assoc 8 Ent1))) 10)
				    Answer
			    )
				(progn
					(setq Fd1	(substr (cdr (assoc 8 Ent1)) 1 3)
						 Oup	(substr (cdr (assoc 8 Ent1)) 4 1)
						 Lyr	(substr (cdr (assoc 8 Ent1)) 5 2)
						 Ph1	(substr (cdr (assoc 8 Ent1)) 8 1)
						 Kv1	(substr (cdr (assoc 8 Ent1)) 9 2)
						 Ph2	(nth (atoi Ph1) Lst_Ph_S)
					)
					(if Bug
						(princ (strcat	"\nGetEntity says:"
									"\nFd = "	   Fd1
									"\nOu = "	   Oup
									"\nLy = "	   Lyr
									"\nPh = "	   Ph1
									"\nKv = "	   Kv1
									"\nPh2 = "   Ph2
							  )
						)
					)
					(if ApLst
						(if (> (length ApLst) 4)
							(setq Ws1	(strcat (itoa (strlen Ph2))
										   "-"
										   (cdr (nth 1 ApLst))
										   (cdr (nth 2 ApLst))
										   "&1-"
										   (cdr (nth 3 ApLst))
										   (cdr (nth 4 ApLst))
									)
							)
							(setq Ws1	(strcat (itoa (strlen Ph2))
										   "-"
										   (cdr (nth 1 ApLst))
										   (cdr (nth 2 ApLst))
									)
							)
						)
						(setq Ws1 "")
					)
					(setq Entlist (list	Kv1
									Fd1
									Ph2
									Ws1
									Oup
									Lyr
									Ph1
									Pnt
									(car EntTmp)
							    )
					)
				)
				(setq Entlist nil)
			)
			(progn 											;[Added Trans]
				(setq Fd1	(substr (cdr (assoc 8 Ent1)) 6 4)			;[Modified dur to layer schem change Trans]
					 Oup "T"	;nil
					 Lyr ""
					 Ph1 ""
					 Kv1	(substr (cdr (assoc 8 Ent1)) 10 2)
					 Ph2 ""
				)
				
				(setq Entlist (list	Kv1
									Fd1
									Ph2
									Ws1
									Oup
									Lyr
									Ph1
									Pnt
									(car EntTmp)
							)
				)
				
			)
		)
		(setq Entlist nil)
	)
	
	Entlist
)

(defun C:GETwireDN ( / ent)					; CL - returns wire data
	(setq ent (car (entsel "PICK CIRCUIT TO GET WIRE SIZE..")))
	(if ent
		(GETwireDN ent)
		(princ "\nNo objects selected..")
	)
)

(defun GetwireDN ( ent /	appvalues str_PRI	; returns wire data
						str_NEU phlen str_Pri_S str_Pri_T str_Neu_S str_Neu_T OutStr )
	(if (NOT Lst_Wr_S)
		(progn
			(if (NOT Bld_Lst_Wire)
				(load (strcat _Path-LISP "TABLES"))
			)
			(Bld_Lst_Wire)
			(Bld_T_Wire)
		)
	)
	(if (setq appvalues (GETeed "WIRE" ent))
		(progn
			(if (> (length appvalues) 2)
				(setq str_Pri_S (nth 0 appvalues)
					 str_Pri_T (nth 1 appvalues)
					 str_Neu_S (nth 2 appvalues)
					 str_Neu_T (nth 3 appvalues)
					 str_PRI	 (strcat str_Pri_S str_Pri_T)
					 str_NEU	 (strcat str_Neu_S str_Neu_T)
				)
				(setq str_Pri_S (nth 0 appvalues)
					 str_Pri_T (nth 1 appvalues)
					 str_PRI	 (strcat str_Pri_S str_Pri_T)
					 str_Neu_S nil
					 str_Neu_T nil
				)
			)
			(if (NOT Lst_Ph_S)
				(Bld_T_Ph)
			)
			(setq phlen
					(strlen
						(nth	(atoi
								(substr (cdr (assoc	8
												(entget ent)
										   )
									   )
									   8
									   1
								)
							)
							Lst_Ph_S
						)
					)
			)
			(if str_Neu_S
				(setq OutStr (strcat (itoa phlen)
								 "-"
								 str_PRI
								 "&1-"
								 str_NEU
						   )
				)
				(setq OutStr (strcat (itoa phlen) "-" str_PRI))
			)
		)
		(progn
			(setq str_Pri_S nil
				 str_Pri_T nil
				 str_Neu_S nil
				 str_Neu_T nil
				 OutStr	 "\nApplication WIRE  not found.."
			)
			(princ (strcat "\n" OutStr))
		)
	)
	OutStr
)

(defun GETeed ( appnam ent /	eedlst applst		; returns entity EED
						element output)
;****************************************************************************
;Function:  GetEED
;Description:  This function gets the extend entity data
;Function(s):  GetEntity()
;Arguments: app ent
;Globals:   None
;Revised:
;****************************************************************************
	(if ent
		(if (setq eedlst (assoc -3 (entget ent (list "*"))))
			(if (setq applst (assoc appnam (cdr eedlst)))
				(progn
					(setq output (list))
					(foreach element (cdr applst)
						(setq
							output (append	output
										(list (cdr element))
								  )
						)
					)
					output
				)
				nil
			)
		)
	)
)

(defun FindOut	( / Numb Dcl_Id )			; sets mode for the dialogue box
;****************************************************************************
;Function:  FindOut
;Description:  This function will set the mode for the dialogue box.
;Function(s):  property()
;Arguments: None
;Globals:   None
;Revised:
;****************************************************************************
	(setq Numb nil)
	(if (> (setq dcl_id	(load_dialog "property.dcl")) 0)
		(progn
			(new_dialog "property1" dcl_id)
			(action_tile "add_button" "(done_dialog 1)")
			(action_tile "query_button" "(done_dialog 2)")
			(action_tile "edit_button" "(done_dialog 3)")
			(setq Numb (start_dialog))
			(unload_dialog dcl_id)
		)
		(alert (strcat	"ERROR: Opening Dialogue Box Property.dcl"))
	)
	Numb
)

(defun Check_Member ( str lst /	Numb Bubba	; Checks Membership in list
							Pval )
;****************************************************************************
;Function:  Check_Member
;Description:  This function checks list
;Function(s):  Load_Data()
;Arguments: str lst
;Globals:   None
;Revised:
;****************************************************************************
	(setq Numb (length lst))
	(if (setq lst (member str lst))
		(setq Numb (itoa (- Numb (length lst)))
			 Pval   (nth (atoi Numb) lst)
			 Bubba  (if Bug
					   (if (= (type Pval) (quote STR))
						   (princ	(strcat "\nCheck_Member =>"
									   Numb
									   " - "
									   Pval
								)
						   )
						   (princ	(strcat "\nCheck_Member =>"
									   Numb
									   " - Xval"
								)
						   )
					   )
				   )
		)
		(setq Numb nil)
	)
	Numb
)

(defun GetVals ( ss1 /	wd1 wd2 wd3 wd4 kv fd	; Get Commonalities for multiple entities
					Md MdLst MstLst FdLst ph ws ou Bubba Cnt e1 e2 e3 LayNam KvLst
					OuLst PhLst PhW WsLst WrdLst Wd1Lst Wd2Lst Wd3Lst Wd4Lst )
;****************************************************************************
;Function:  GetVals
;Description:  This function checks for common values in multiple lists
;Function(s):  Load_Data()
;Arguments: ss
;Globals:   None
;Revised:
;****************************************************************************
	(setq	Cnt		0
			MstLst	nil
			WrdLst	nil
	)
	(if Bug
		(princ (strcat "\nSel-" (itoa (sslength ss1))))
	)
	(repeat (sslength ss1)
		(setq e1 (ssname ss1 Cnt)
			 e2 (entget e1 (list "WIRE"))
		)
		(if (and (/= Div "AL") (/= Div "GA"))									;[Modified for Trans]
			(progn
				(if (> (strlen (setq LayNam (cdr (assoc 8 e2)))) 9)
					(setq fd	(substr LayNam 1 3)
						 ou	(substr LayNam 4 1)
						 ph	(substr LayNam 8 1)
						 phw	(cond ((= ph "1") "3")
								 ((= ph "2") "2")
								 ((= ph "3") "2")
								 ((= ph "4") "2")
								 (T "1")
							)
						 kv	(substr LayNam 9 2)
					)
				)
				(if (> (strlen LayNam) 10)
					(setq md (substr LayNam 11 1))
					(setq md "E")
				)
			)
			(progn
				(if (>= (strlen (setq LayNam (cdr (assoc 8 e2)))) 11)
					(setq fd	(substr LayNam 6 4)
						 ou	"T"
						 ph	nil
						 phw	(cond ((= ph "1") "3")
								 ((= ph "2") "2")
								 ((= ph "3") "2")
								 ((= ph "4") "2")
								 (T "1")
							)
						 kv	(substr LayNam 10 2)
					)
				)
			)
		)	
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
									  (princ (strcat "\n"
												  ws
												  "$"
												  (itoa cnt)
										    )
									  )
								  )
						)
						(if (= (length e3) 2)
							(setq wd1		(cdr (nth 0 e3))
								 wd2		(cdr (nth 1 e3))
								 wd3		nil
								 wd4		nil
								 ws		(strcat phw "-" wd1 wd2)
								 Bubba 	(if Bug
											(princ	(strcat	"\n"
															ws
															"$"
															(itoa cnt)
													)
											)
										)
							)
							(setq wd1		nil
								 wd2		nil
								 wd3		nil
								 wd4		nil
								 ws		nil
								 Bubba 	(if Bug
											(princ	"\nNo ws defined -3 & e3, not 2 or 4")
										)
							)
						)
					)
					(setq wd1		nil
						 wd2		nil
						 wd3		nil
						 wd4		nil
						 ws		nil
						 Bubba 	(if Bug
									(princ	"\nNo ws defined, no e3")
								)
					)
				)
			)
			(setq wd1		nil
				 wd2		nil
				 wd3		nil
				 wd4		nil
				 ws		nil
				 Bubba 	(if Bug
							(princ	"\nNo ws defined, no -3")
						)
			)
		)
		(if MstLst
			(progn
				(if (not (member wd1 (nth 0 WrdLst)))
					(setq Wd1Lst (cons wd1 (nth 0 WrdLst)))
					(setq Wd1Lst (nth 0 WrdLst))
				)
				(if (not (member wd2 (nth 1 WrdLst)))
					(setq Wd2Lst (cons wd2 (nth 1 WrdLst)))
					(setq Wd2Lst (nth 1 WrdLst))
				)
				(if (not (member wd3 (nth 2 WrdLst)))
					(setq Wd3Lst (cons wd3 (nth 2 WrdLst)))
					(setq Wd3Lst (nth 2 WrdLst))
				)
				(if (not (member wd4 (nth 3 WrdLst)))
					(setq Wd4Lst (cons wd4 (nth 3 WrdLst)))
					(setq Wd4Lst (nth 3 WrdLst))
				)
				(if (not (member ws (nth 4 WrdLst)))
					(setq WsLst (cons ws (nth 4 WrdLst)))
					(setq WsLst (nth 4 WrdLst))
				)
				(if (not (member fd (nth 5 WrdLst)))
					(setq FdLst (cons fd (nth 5 WrdLst)))
					(setq FdLst (nth 5 WrdLst))
				)
				(if (not (member ou (nth 6 WrdLst)))
					(setq OuLst (cons ou (nth 6 WrdLst)))
					(setq OuLst (nth 6 WrdLst))
				)
				(if (not (member ph (nth 7 WrdLst)))
					(setq PhLst (cons ph (nth 7 WrdLst)))
					(setq PhLst (nth 7 WrdLst))
				)
				(if (not (member Kv (nth 8 WrdLst)))
					(setq KvLst (cons Kv (nth 8 WrdLst)))
					(setq KvLst (nth 8 WrdLst))
				)
				(if (not (member md (nth 9 WrdLst)))
					(setq MdLst (cons md (nth 9 WrdLst)))
					(setq MdLst (nth 9 WrdLst))
				)
				(setq WrdLst (list Wd1Lst   Wd2Lst	  Wd3Lst
							    Wd4Lst   WsLst	  FdLst
							    OuLst	   PhLst	  KvLst
							    MdLst
							   )
				)
				(if (nth 0 MstLst)
					(if (wcmatch (cdr (assoc 0 e2)) "*POLYLINE")
						(if (/= wd1 (nth 0 MstLst))
							(setq wd1 nil)
							(setq wd1 wd1)
						)
						(setq wd1 (nth 0 MstLst))
					)
					(setq wd1 nil)
				)
				(if (nth 1 MstLst)
					(if (wcmatch (cdr (assoc 0 e2)) "*POLYLINE")
						(if (/= wd2 (nth 1 MstLst))
							(setq wd2 nil)
							(setq wd2 wd2)
						)
						(setq wd2 (nth 1 MstLst))
					)
					(setq wd2 nil)
				)
				(if (nth 2 MstLst)
					(if (wcmatch (cdr (assoc 0 e2)) "*POLYLINE")
						(if (/= wd3 (nth 2 MstLst))
							(setq wd3 nil)
							(setq wd3 wd3)
						)
						(setq wd3 (nth 2 MstLst))
					)
					(setq wd3 nil)
				)
				(if (nth 3 MstLst)
					(if (wcmatch (cdr (assoc 0 e2)) "*POLYLINE")
						(if (/= wd4 (nth 3 MstLst))
							(setq wd4 nil)
							(setq wd4 wd4)
						)
						(setq wd4 (nth 3 MstLst))
					)
					(setq wd4 nil)
				)
				(if (nth 4 MstLst)
					(if (/= ws (nth 4 MstLst))
						(setq ws nil)
						(setq ws ws)
					)
					(setq ws nil)
				)
				(if (nth 5 MstLst)
					(if (/= fd (nth 5 MstLst))
						(setq fd nil)
						(setq fd fd)
					)
					(setq fd nil)
				)
				(if (nth 6 MstLst)
					(if (/= ou (nth 6 MstLst))
						(setq ou nil)
						(setq ou ou)
					)
					(setq ou nil)
				)
				(if (nth 7 MstLst)
					(if (/= ph (nth 7 MstLst))
						(setq ph nil)
						(setq ph ph)
					)
					(setq ph nil)
				)
				(if (nth 8 MstLst)
					(if (/= kv (nth 8 MstLst))
						(setq kv nil)
						(setq kv kv)
					)
					(setq kv nil)
				)
				(if (nth 9 MstLst)
					(if (/= md (nth 9 MstLst))
						(setq md nil)
						(setq md md)
					)
					(setq md nil)
				)
				(setq MstLst
						(list wd1 wd2 wd3 wd4 ws fd ou ph kv md)
				)
			)
			(setq MstLst (list wd1 wd2 wd3 wd4 ws fd ou ph kv md)
				 WrdLst (list (list wd1)
						    (list wd2)
						    (list wd3)
						    (list wd4)
						    (list ws)
						    (list fd)
						    (list ou)
						    (list ph)
						    (list kv)
						    (list md)
					   )
			)
		)
		(setq Cnt (1+ Cnt))
	)
	MstLst
)

(defun Pop_Lst ( LstNam NVal MVal MLst Number	; Populates DCL lists
				/	VSet Bk VpSet)
;****************************************************************************
;Function:  Pop_Lst
;Description:  This function populates DCL lists
;Function(s):  Load_Data()
;Arguments: DCL listname, Original Value, Member Value, Member Lst, Number
;Globals:   None
;Returns: List of NVal, MVal, VPSet
;	NVal	Actual current value of item (as appears in Master List)
;	MVal	List value of item (string integer)
;	VPset	T if value list unpadded, nil if padded with whitespace.
;	VSet	Value set to valid item
;****************************************************************************
	(setq bk (chr 32))
	(start_list LstNam 3)
	(cond
		((= Number 1)
		 (if	MVal
			 (progn
				 (mapcar (quote add_list) MLst)
				 (setq NVal  (atoi MVal)
					  VPSet nil
					  VSet  T
				 )
			 )
			 (progn
				 (add_list bk)
				 (mapcar (quote add_list) MLst)
				 (setq MVal "0"
					  NVal 1
					  VPSet T
					  VSet nil
				 )
			 )
		 )
		)
		((= Number 2)
		 (if	MVal
			 (progn
				 (setq NVal (nth (atoi MVal) MLst))
				 (add_list NVal)
				 (setq MVal "0"
					  NVal 0
					  VPSet nil
					  VSet T
				 )
			 )
			 (progn
				 (add_list bk)
				 (setq MVal "0"
					  NVal 1
					  VPSet T
					  VSet T
				 )
			 )
		 )
		)
		((= Number 3)
		 (if	MVal
			 (progn
				 (mapcar (quote add_list) MLst)
				 (setq NVal  (atoi MVal)
					  VPSet nil
					  VSet  T
				 )
			 )
			 (progn
				 (add_list bk)
				 (mapcar (quote add_list) MLst)
				 (setq NVal 1
					  MVal "0"
					  VPSet T
					  VSet nil
				 )
			 )
		 )
		)
		((= Number 4)
		 (if	MVal
			 (progn
				 (mapcar (quote add_list) MLst)
				 (setq NVal  (atoi MVal)
					  VPSet nil
					  VSet  T
				 )
			 )
			 (progn
				 (add_list bk)
				 (mapcar (quote add_list) MLst)
				 (setq NVal 1
					  MVal "0"
					  VPSet T
					  VSet nil
				 )
			 )
		 )
		)
	)
	(end_list)
	(list NVal MVal VPSet VSet)
)

(defun Load_Data ( lst number ModSS /	kvp fdp	; Loads Data in dialog box
								php bk Bubba DezVals ssCnt TempSS )
;****************************************************************************
;Function:  Load_Data
;Description:  This function reads the list information and displays
;              the content in the dialogue box.
;Function(s):  property()
;Arguments: lst number
;Globals:   None
;Revised:
;****************************************************************************
	(if Bug 
		(progn
			(princ "\nProperty.Lsp!Load_Data - Entered ")
			(princ "\n   Prameters Lst :") (prin1 lst)
			(princ "\n   Prameters number :") (prin1 number)
			(princ "\n   Prameters ModSS :") (prin1 ModSS)
		)
	)
	(setq kv		nil
		 fd		nil
		 ph		nil
		 ws		nil
		 ou		nil
		 bk		" "
		 ws_Pri_S	nil
		 ws_Pri_T	nil
		 ws_Neu_S	nil
		 ws_Neu_T	nil
	)
	(if (not Lst_Wr_S)
		(if (not Bld_Lst_Wire)
			(progn
				(load "TABLES")
				(Bld_Lst_Wire)
			)
			(Bld_Lst_Wire)
		)
	)
	(if Lst
		(if (= (type (last lst)) (quote ENAME))
			(setq	appvalues		(GETeed "WIRE" (last lst))
					Bubba		(if Bug (princ "\nLst - Ename"))
					kv			(nth 0 lst)
					fd			(nth 1 lst)
					ph			(nth 6 lst)
					ws			(nth 3 lst)
					ou			(nth 4 lst)
			)
			(setq	appvalues		(list	nil
										nil
										nil
										nil
						 		)
					Bubba		(if Bug (princ "\nLst - Not Ename"))
					kv			(nth 0 lst)
					fd			(nth 1 lst)
					ph			(nth 6 lst)
					ws			(nth 3 lst)
					ou			(nth 4 lst)
			)
		)
		(if ModSS
			(cond
				((and (car ModSS) (cadr ModSS))
					(setq	TempSS	(car ModSS)
							ssCnt	0
					)
					(repeat (sslength (cadr ModSS))
						(setq	eTmp		(ssname (cadr ModSS) ssCnt)
								TempSS	(ssadd eTmp TempSS)
								ssCnt	(1+ ssCnt)
						)
					)
					(setq	DezVals		(GetVals TempSS)
							appvalues		(list	(nth 0 DezVals)
												(nth 1 DezVals)
												(nth 2 DezVals)
												(nth 3 DezVals)
										)
							Bubba		(if Bug (princ "\nModSS - TempSS"))
							ws			(nth 4 DezVals)
							fd			(nth 5 DezVals)
							ou			(nth 6 DezVals)
							ph			(nth 7 DezVals)
							kv			(nth 8 DezVals)
							md			(nth 9 DezVals)
					)
				)
				((car ModSS)
					(setq	DezVals		(GetVals (car ModSS))
							appvalues		(list	(nth 0 DezVals)
												(nth 1 DezVals)
												(nth 2 DezVals)
												(nth 3 DezVals)
										)
							Bubba		(if Bug (princ "\nModSS - car ModSS"))
							ws			(nth 4 DezVals)
							fd			(nth 5 DezVals)
							ou			(nth 6 DezVals)
							ph			(nth 7 DezVals)
							kv			(nth 8 DezVals)
							md			(nth 9 DezVals)
					)
				)
				((cadr ModSS)
					(setq	DezVals		(GetVals (cadr ModSS))
							Bubba		(if Bug (princ "\nModSS - cadr ModSS"))
							appvalues		(list	(nth 0 DezVals)
												(nth 1 DezVals)
												(nth 2 DezVals)
												(nth 3 DezVals)
										)
							ws			(nth 4 DezVals)
							fd			(nth 5 DezVals)
							ou			(nth 6 DezVals)
							ph			(nth 7 DezVals)
							kv			(nth 8 DezVals)
							md			(nth 9 DezVals)
					)
				)
				(T
					(setq	appvalues		(list	nil
												nil
												nil
												nil
										)
							Bubba		(if Bug (princ "\nModSS - nil ModSS"))
							kv			nil
							fd			nil
							ph			nil
							ws			nil
							ou			(if (and (/= Div "AL") (/= Div "GA")) "O" "T")	;[Modified for Trans]
							md			nil
					)
				)
			)
		)
	)
	(if (= (length appvalues) 4)
		(setq	ws_Pri_S	(nth 0 appvalues)
				ws_Pri_T	(nth 1 appvalues)
				ws_Neu_S	(nth 2 appvalues)
				ws_Neu_T	(nth 3 appvalues)
		)
		(if appvalues
			(setq	ws_Pri_S	(nth 0 appvalues)
					ws_Pri_T	(nth 1 appvalues)
					ws_Neu_S	nil
					ws_Neu_T	nil
			)
			(setq	ws_Pri_S	nil
					ws_Pri_T	nil
					ws_Neu_S	nil
					ws_Neu_T	nil
			)
		)
	)
	
	(if (> (strlen (getvar "USERS5")) 0)
		(if (= (strlen (getvar "USERS5")) 1)
			(setq md	  (strcase (getvar "USERS5"))
				 Bubba (setvar "USERS5" ".")
				 Bubba (if Bug
						  (princ "\nGot UserS5 flag.")
					  )
			)
		)
	)
	(if Bug
		(if (car appvalues)
			(if (= (length appvalues) 2)
				(princ	(strcat	"\nWd1\t"
								(if (nth 0 appvalues)
									(nth 0 appvalues)
									"nil"
								)
								"\nWd2\t"
								(if (nth 1 appvalues)
									(nth 1 appvalues)
									"nil"
								)
								"\nOu\t"
								(if ou
									ou
									"nil"
								)
								"\nFd\t"
								(if fd
									fd
									"nil"
								)
								"\nPh\t"
								(if ph
									ph
									"nil"
								)
								"\nVt\t"
								(if kv
									kv
									"nil"
								)
					 	)
				)
				(princ	(strcat	"\nWd1\t"
								(if (nth 0 appvalues)
									(nth 0 appvalues)
									"nil"
								)
								"\nWd2\t"
								(if (nth 1 appvalues)
									(nth 1 appvalues)
									"nil"
								)
								"\nWd3\t"
								(if (nth 2 appvalues)
									(nth 2 appvalues)
									"nil"
								)
								"\nWd4\t"
								(if (nth 3 appvalues)
									(nth 3 appvalues)
									"nil"
								)
								"\nWs\t"
								(if ws
									ws
									"nil"
								)
								"\nOu\t"
								(if ou
									ou
									"nil"
								)
								"\nFd\t"
								(if fd
									fd
									"nil"
								)
								"\nPh\t"
								(if ph
									ph
									"nil"
								)
								"\nVt\t"
								(if kv
									kv
									"nil"
								)
						)
				)
			)
			(princ	(strcat	"\nOu\t"
							(if ou
								ou
								"nil"
							)
							"\nFd\t"
							(if fd
								fd
								"nil"
							)
							"\nPh\t"
							(if ph
								ph
								"nil"
							)
							"\nVt\t"
							(if kv
								kv
								"nil"
							)
					)
			)
		)
	)

	(cond
		((eq ou "O")
			(set_tile "oh_radio" "1")
			(set_tile "ug_radio" "0")
			(mode_tile "Neu_S_popup" 0)
			(mode_tile "Neu_T_popup" 0)
			(cb_oh_radio)
			(if	Bug
			 (princ "\nI Called cb_oh_radio!")
			)
		)
		((eq ou "U")
			(set_tile "oh_radio" "0")
			(set_tile "ug_radio" "1")
			(mode_tile "Neu_S_popup" 1)
			(mode_tile "Neu_T_popup" 1)
			(cb_ug_radio)
			(if	Bug
			 (princ "\nI Called cb_ug_radio!")
			)
		)
		((eq ou "T")
			(set_tile "oh_radio" "0")
			(set_tile "ug_radio" "0")
			(set_tile "tm_radio" "1")
			(mode_tile "ph_popup" 1)
			(mode_tile "Pri_S_popup" 1)
			(mode_tile "Pri_T_popup" 1)
			(mode_tile "Neu_S_popup" 1)
			(mode_tile "Neu_T_popup" 1)
		)
		((null ou)
			(set_tile "oh_radio" "0")
			(set_tile "ug_radio" "0")
			(mode_tile "Neu_S_popup" 0)
			(mode_tile "Neu_T_popup" 0)
		)
		(T
			(set_tile "oh_radio" "1")
			(set_tile "ug_radio" "0")
			(mode_tile "Neu_S_popup" 0)
			(mode_tile "Neu_T_popup" 0)
			(cb_oh_radio)
			(if	Bug
			 (princ "\nI Called cb_oh_radio!")
			)
		)
	)
	
	(setq	Oh_Data	(get_tile "oh_radio")
			Ug_Data	(get_tile "ug_radio")
			Tm_Data	(get_tile "tm_radio")		;[Added for Trans]
			oh_value	Oh_Data
			ug_value	Ug_Data
			tm_value  Tm_Data					;[Added for Trans]
	)
	(if Bug
		(princ "\nChecking Kv")
	)
	(setq	kvp		(Check_Member kv Lst_Vt_S))
	(setq	PopBak	(Pop_Lst "vt_popup" kv kvp Lst_Vt_S Number)
			kv		(nth 0 PopBak)
			kvp		(nth 1 PopBak)
			kvps		(nth 2 PopBak)
			kvs		(nth 3 PopBak)
	)
	(if Bug
		(princ "\nChecking Fd")
	)
	(setq	fdp		(Check_Member fd Lst_Fd_V))
	(setq	PopBak	(Pop_Lst "fd_popup" fd fdp Lst_Fd_S Number)
			fd		(nth 0 PopBak)
			fdp		(nth 1 PopBak)
			fdps		(nth 2 PopBak)
			fds		(nth 3 PopBak)
	)
	(if Bug
		(princ "\nChecking Ph")
	)
	
	(if ph
		(if (and (>= (atoi ph) 0) (< (atoi ph) (length Lst_Ph_S)))
			(setq php	  ph
				 Bubba (if Bug
						  (princ (strcat "\nCheck_Member =>"
									  ph
									  " - "
									  (nth (atoi ph) Lst_Ph_S)
							    )
						  )
					  )
			)
			(setq php nil)
		)
		(setq php nil)
	)
	(setq	PopBak	(Pop_Lst "ph_popup" ph php Lst_Ph_S Number)
			ph		(nth 0 PopBak)
			php		(nth 1 PopBak)
			phps		(nth 2 PopBak)
			phs		(nth 3 PopBak)
	)
	(if Bug
		(princ "\nChecking Ws_Pri")
	)
	
	(if ws_Pri_S
		(setq wsp_Pri_S (Check_Member ws_Pri_S Lst_Wr_S))
		(setq wsp_Pri_S nil)
	)
	
	(setq	PopBak	(Pop_Lst	"Pri_S_popup"
							ws_Pri_S
							wsp_Pri_S
							Lst_Wr_S
							Number
					)
			ws_Pri_S	(nth 0 PopBak)
			wsp_Pri_S	(nth 1 PopBak)
			wspsp	(nth 2 PopBak)
			wssp		(nth 3 PopBak)
	)
	(if Bug
		(if wsp_Pri_S
			(princ "\nFound wsp_Pri_S...")
			(princ "\nWsp_Pri_S not Found")
		)
	)
	(if Bug
		(if wsp_Pri_S
			(princ (strcat "\nFound wsp_Pri_S=" wsp_Pri_S))
		)
	)
	(if Bug
		(princ "\nChecking Wt_Pri")
	)
	(if ws_Pri_T
		(setq wsp_Pri_T (Check_Member ws_Pri_T Lst_Wr_T))
		(setq wsp_Pri_T nil)
	)
	(setq	PopBak	(Pop_Lst	"Pri_T_popup"
							ws_Pri_T
							wsp_Pri_T
							Lst_Wr_T
							Number
					)
			ws_Pri_T	(nth 0 PopBak)
			wsp_Pri_T	(nth 1 PopBak)
			wspsp	(nth 2 PopBak)
			wssp		(nth 3 PopBak)
	)
	(if Bug
		(if wsp_Pri_T
			(princ "\nFound wsp_Pri_T...")
			(princ "\nWsp_Pri_T not Found")
		)
	)
	(if Bug
		(if wsp_Pri_T
			(princ (strcat "\nFound wsp_Pri_T=" wsp_Pri_T))
		)
	)
	(if (= ou "U")
		(progn
			(mode_tile "Neu_S_popup" 0)
			(mode_tile "Neu_T_popup" 0)
		)
	)
	(if Bug
		(princ "\nChecking Ws_Neu")
	)
	(if ws_Neu_S
		(setq wsp_Neu_S (Check_Member ws_Neu_S Lst_Wr_S))
		(setq wsp_Neu_S nil)
	)
	(setq	PopBak	(Pop_Lst	"Neu_S_popup"
							ws_Neu_S
							wsp_Neu_S
							Lst_Wr_S
							Number
					)
			ws_Neu_S	(nth 0 PopBak)
			wsp_Neu_S	(nth 1 PopBak)
			wspsn	(nth 2 PopBak)
			wssn		(nth 3 PopBak)
	)
	(if Bug
		(princ "\nChecking Wt_Neu")
	)
	(if ws_Neu_T
		(setq wsp_Neu_T (Check_Member ws_Neu_T Lst_Wr_T))
		(setq wsp_Neu_T nil)
	)
	(setq	PopBak	(Pop_Lst	"Neu_T_popup"
							ws_Neu_T
							wsp_Neu_T
							Lst_Wr_T
							Number
					)
			ws_Neu_T	(nth 0 PopBak)
			wsp_Neu_T	(nth 1 PopBak)
			wspsn	(nth 2 PopBak)
			wssn		(nth 3 PopBak)
	)
	(if (= ou "U")
		(progn
			(mode_tile "Neu_S_popup" 1)
			(mode_tile "Neu_T_popup" 1)
		)
	)
	(cond
		((= number 1) (setq str "Add Properties"))
		((= number 2) (setq str "Query Properties"))
		((= number 3) (setq str "Edit Properties"))
		((= number 4) (setq str "Edit Mode Properties"))
	)
	(if (= number 4)
		(cond	((= md "E")
					(set_tile "ME_radio" "1")
					(set_tile "MI_radio" "0")
					(set_tile "MC_radio" "0")
					(set_tile "MR_radio" "0")
					(cb_md_radio)
				)
				((= md "I")
					(set_tile "ME_radio" "0")
					(set_tile "MI_radio" "1")
					(set_tile "MC_radio" "0")
					(set_tile "MR_radio" "0")
					(cb_md_radio)
				)
				((= md "C")
					(set_tile "ME_radio" "0")
					(set_tile "MI_radio" "0")
					(set_tile "MC_radio" "1")
					(set_tile "MR_radio" "0")
					(cb_md_radio)
				)
				((= md "R")
					(set_tile "ME_radio" "0")
					(set_tile "MI_radio" "0")
					(set_tile "MC_radio" "0")
					(set_tile "MR_radio" "1")
					(cb_md_radio)
				)
				(T
					(set_tile "ME_radio" "0")
					(set_tile "MI_radio" "0")
					(set_tile "MC_radio" "0")
					(set_tile "MR_radio" "0")
					(setq Smod "E")
				)
		)
	)
	(set_tile	"title_bar"	str)
	(set_tile	"vt_popup"	kvp)
	(if Bug
		(princ (strcat "\nKvP = " kvp))
	)
	(set_tile "fd_popup" fdp)
	(if Bug
		(princ (strcat "\nFdP = " fdp))
	)
	(set_tile "ph_popup" php)
	(if Bug
		(princ (strcat "\nPhP = " php))
	)
	(if wsp_Pri_S
		(set_tile	"Pri_S_popup"	wsp_Pri_S)
		(set_tile	"Pri_S_popup"	bk)
	)
	(if wsp_Pri_T
		(set_tile	"Pri_T_popup"	wsp_Pri_T)
		(set_tile	"Pri_T_popup"	bk)
	)
	(if wsp_Neu_S
		(set_tile	"Neu_S_popup"	wsp_Neu_S)
		(set_tile	"Neu_S_popup"	bk)
	)
	(if wsp_Neu_T
		(set_tile	"Neu_T_popup"	wsp_Neu_T)
		(set_tile	"Neu_T_popup"	bk)
	)
	(setq	Vt_Data		(get_tile "vt_popup")
			Fd_Data		(get_tile "fd_popup")
			Ph_Data		(get_tile "ph_popup")
			Pri_S_data	(get_tile "Pri_S_popup")
			Pri_T_data	(get_tile "Pri_T_popup")
			Neu_S_data	(get_tile "Neu_S_popup")
			Neu_T_data	(get_tile "Neu_T_popup")
			Pri_S_datr	(get_tile "Pri_S_popup")
			Pri_T_datr	(get_tile "Pri_T_popup")
			Neu_S_datr	(get_tile "Neu_S_popup")
			Neu_T_datr	(get_tile "Neu_T_popup")
	)
	(if kvs
		(setq	Vt_Data	(nth (atoi Vt_Data) Lst_Vt_S))
		(setq	Vt_Data	"0")
	)
	(if fds
		(setq	Fd_Data	(nth (atoi Fd_Data) Lst_Fd_V))
		(setq	Fd_Data	"0")
	)
	(if phs
		(setq	Ph_Data	(nth (atoi Ph_Data) Lst_Ph_S))
		(setq	Ph_Data	"0")
	)
	(if wssp
		(if (eq Oh_Data "1")
			(setq	Pri_S_data	(nth (atoi Pri_S_data) Lst_Wr_S)
					Pri_T_data	(nth (atoi Pri_T_data) Lst_Wr_T)
					Neu_S_data	(nth (atoi Neu_S_data) Lst_Wr_S)
					Neu_T_data	(nth (atoi Neu_T_data) Lst_Wr_T)
			)
			(setq	Pri_S_data	(nth (atoi Pri_S_data) Lst_Wr_S)
					Pri_T_data	(nth (atoi Pri_T_data) Lst_Wr_T)
			)
		)
		(if (eq Oh_Data "1")
			(setq	Pri_S_data	"0"
					Pri_T_data	"0"
					Neu_S_data	"0"
					Neu_T_data	"0"
			)
			(setq	Pri_S_data	"0"
					Pri_T_data	"0"
			)
		)
	)
)

(defun Property ( Number /	md1 md2 dlg ap1	; Property Main
						lyr ent_lst strlst dcl_id ModSS StrLst )
;****************************************************************************
;Function:		Property  (main)
;Description:	This is the controlling function for the program
;Function(s):
;Arguments:
;Globals:
;Revised:
;****************************************************************************
	(if Bug (progn (princ "\nProperty.Lsp!Property param: ")(prin1 Number)))
	(if (or (= (stpDot AppNam) "CADET20")(= (stpDot AppNam) "CADET"))
		(c:what_mode)						; Draws Service Lines on WE
	)
	(if (not (member number (list 1 2 3 4)))
		(exit)
	)
	(command "_.UNDO" "_Begin")
	(if (not SF)
		(SclFactor)
	)
	(if (null ApcDef)
		(progn
			(setq	ApcTst	(cdr (assoc 2 (tblnext "APPID" T))))
			(while (setq ApcTst (tblnext "APPID"))
				(if ApcTst
					(setq	ApcTst	(cdr (assoc 2 ApcTst)))
				)
				(if (and ApcTst (null ApcDef))
					(if (wcmatch (strcase ApcTst) "APCO*")
						(setq	ApcDef	1)
					)
				)
			)
			(if (null ApcDef)
				(setq	ApcDef	0)
			)
		)
	)
	(setq	md1		(getvar "cmdecho")
			md2		(getvar "clayer")
			dlg		5
			ap1		"WIRE"
			ent_lst	nil
	)
	
	(if (or (= (stpDot AppNam) "CADET20")(= (stpDot AppNam) "CADET"))
		(if (null (tblsearch "APPID" ap1))
			(if (= ApcDef 1)
				(progn
					(load (strcat _Path-LISP "APC2WIRE"))
					(Apc2Wire)
				)
				(regapp ap1)
			)
		)
		(if (null (tblsearch "APPID" ap1))
			(regapp ap1)
		)
	)
	
	(if (and (= AppMode "C") (= number 1))
		(progn
			(alert "ERROR: DrawCkt not allowed in mode Change")
			(exit)
		)
	)
	
	(if Lst_Fd_V
		(progn
			(if (or (= number 1) (= number 2))
				(setq ent_lst (GetEntity ap1 number)
					 strlst  (Geteed ap1 (last ent_lst))
					 ModSS   nil
					 DontE   nil
				)
				(if (= number 3)
					(setq DontE   T
						 ModSS   (PreGeometry ap1)
						 ent_lst nil
					)
					(setq DontE   nil
						 ModSS   (PreGeometry ap1)
						 ent_lst nil
					)
				)
			)
			(if (> (setq dcl_id	(load_dialog "property.dcl")) 0)
				(progn
					(while (> dlg 3)
						(if (/= number 4)
							(new_dialog "PropA" dcl_id)
							(new_dialog "Prop4" dcl_id)
						)
						(Load_Data ent_lst number ModSS)
						(Cb_Test_Ok number)
						(if (= number 4)
							(action_tile "mode_radio" "(cb_md_radio)(Cb_Test_Ok number)")
						)
						(action_tile "oh_radio" "(cb_oh_radio)")
						(action_tile "ug_radio" "(cb_ug_radio)")
						(action_tile "tm_radio" "(cb_tm_radio)")
						(if (= Ug_Data "1") (cb_ug_radio))
						(if (= Oh_Data "1") (cb_oh_radio))
						(if (= Tm_Data "1") (cb_tm_radio))
						(action_tile "vt_popup" "(cb_vt_popup  number)")
						(action_tile "fd_popup" "(cb_Fd_popup  number)")
						(action_tile "ph_popup" "(cb_Ph_popup  number)")
						(action_tile "ws_popup" "(cb_ws_popup  number)")
						(action_tile "Pri_S_popup" "(cb_Pri_S_popup  number)")
						(action_tile "Pri_T_popup" "(cb_Pri_T_popup  number)")
						(action_tile "Neu_S_popup" "(cb_Neu_S_popup  number)")
						(action_tile "Neu_T_popup" "(cb_Neu_T_popup  number)")
						(action_tile "ok_button" "(cb_ok_button number)")
						(action_tile "cancel_button" "(done_dialog 0)")
						(Cb_Test_Ok number)
						(setq dlg (start_dialog))
						(if (= dlg 4)
							(setq ent_lst (GetEntity ap1 number))
						)
					)
					(unload_dialog dcl_id)
					(if Bug
						(princ (strcat "\n ***** Dialog Box results  " (itoa dlg)))
					)
					(if (= dlg 1)
						(progn
							(if Bug (princ (strcat	"\nLayer: " (getvar "CLAYER"))))
							(if Bug (setq eds_lst ent_lst))
							(DrawPolyline ap1 ent_lst)
						)
					)
					(if (= dlg 2)
						(progn
							(if (nth 0 ModSS)
								(ModifyGeometry (nth 0 ModSS) ap1)
							)
							(if (nth 1 ModSS)
								(ModifyGeometry (nth 1 ModSS) ap1)
							)
							(setq DontE nil)
						)
					)
					(if (= dlg 3)
						(progn
							(cond	((= Smod "ME_radio")
										(if Bug (princ "\nSmodC = E"))
										(setq SmodC "E")
									)
									((= Smod "MI_radio")
										(if Bug (princ "\nSmodC = I"))
										(setq SmodC "I")
									)
									((= Smod "MC_radio")
										(if Bug (princ "\nSmodC = C"))
										(setq SmodC "C")
									)
									((= Smod "MR_radio")
										(if Bug (princ "\nSmodC = R"))
										(setq SmodC "R")
									)
									((null SmodC)
										(if Bug (princ "\nNull SmodC?"))
										(if (and Bug (= (type SmodC) STR))
											(princ (strcat "\nSmodC = " SmodC))
										)
										(setq SmodC "E")
									)
							)
							(ChgWork ModSS SmodC)
						)
					)
				)
				(alert (strcat	"ERROR: Opening Dialogue Box Property.dcl"))
			)
		)
		(alert (strcat "ERROR: Tables not built, call " AppNam " Support..."))
	)
	(if (member (strcase (substr (StpDot AppNam) 1 4)) (list "ADDS" "SUBT"))
		(if ModSS
			(progn
				(if (nth 0 ModSS)
					(ChngUm nil (nth 0 ModSS))
				)
				(if (nth 1 ModSS)
					(ChngUm nil (nth 1 ModSS))
				)
				(setq	ModSS	nil)
				(gc)
			)
		)
	)
	(setvar "clayer" md2)
	(setvar "cmdecho" md1)
	(command "_.UNDO" "_End")
	(princ)
)

(defun C:SvLn ( /	pt1 ss1 inshd pt2 pt3		;Service lines routine
				ang entnam newent )
	;(C:Chg_Oil)
	(if (null (tblsearch "LAYER" "SERVICEI"))
		(command "_.layer" "n" "servicei" "lt" "hidden2" "servicei" "")
	)
	(if (null (tblsearch "LAYER" "SERVICE"))
		(command "_.layer" "n" "service" "")
	)
	(setq pt1 (getpoint "Pick starting point :")
		  ss1 (ssadd)
	)
	(if (= appmode "E")
		(progn
			(setq Inshd "191")
			(setvar "CLAYER" "SERVICE")
		)
		(progn
			(setq inshd "391")
			(setvar "CLAYER" "SERVICEI")
		)
	)
	(if (= ug_data "1")
		(progn
			(initget 0 "Arc")
				(while (setq pt2(getpoint pt1 "<A>rc/<Second point>:"))
					(princ "\n")
					(if (and (not (null pt2)) (not (equal (type pt2) (quote STR))))
						(progn
							(command "_.line" pt1 pt2 "")
							(setq ang (angle pt1 pt2)
								 pt1 pt2
							)
							(ssadd (entlast) ss1)
						)
						(if (not (null pt2))
							(progn
								(setq pt2 (getpoint pt1 "Second point of arc:")
									 pt3 (getpoint pt2 "Endpoint of arc :")
								)
								(command "arc" pt1 pt2 pt3)
								(setq pt1 pt3)
								(ssadd (entlast) ss1)
							)
						)
					)
					(initget 0 "Arc")
				)
		)
		(progn
			(while (setq Pt2 (getpoint Pt1 "\nTo point: "))
					(command "_.line" Pt1 Pt2 "")
					(setq ang (angle pt1 pt2)
						 Pt1 pt2
					)
					(ssadd (entlast) Ss1)
			)
		)
	)
	(if (> (sslength Ss1) 0)
		(progn
			(command "_.pedit" (ssname Ss1 0) "y" "j" Ss1 "" "")	; the "y" converts lines & arcs to a polyline.
			(setq NewEnt (entlast))
			;(AddEED Ap1 NewEnt)
			(if (not EntNam)
				(setq EntNam NewEnt)
			)
			(setq Lyr (getvar "CLAYER"))
			;(command "_.change" Newent "" "p" "la" Lyr "")
			(if (= (strcase (substr Lyr 4 1)) "V")
				(command "_.PEDIT"
					    Newent
					    "W"
					    0.0
					    ""
				)
				(command "_.PEDIT"
					    Newent
					    "W"
					    0.0
					    ""
				)
			)
		)
	)
	(if (= appmode "I")
		(command "change" newent "" "p" "lt" "bylayer" "")
	)
	(if InsHd
		(command "INSERT"
			    (strcat _Path-Sym InsHd)
			    (getvar "LASTPOINT")
			    (* 0.1 sf);(* SF (nth PosOut Lst_Sp_Ss))
			    ""
			    (rtd Ang)
		)
	)
)

(setq	LodVer	"3.1.0a")
