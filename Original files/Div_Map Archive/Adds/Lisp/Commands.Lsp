(if AppNam								; Code Version Indicator {738 Lines of Code}
	(princ (strcat "\n" AppNam " Commands Loading."))
	(princ "\nAdds Commands Loading.")
)

(defun C:CP ( / )							; Loads & runs original point routine
	(cpins)
	(princ)
)

(defun C:CP2 ( / )							; Loads & runs alternate point routine
   (cp_au2)
   (princ)
)

(defun C:HI ( / )							; Resets AutoCAD variable "HIGHLIGHT" to 1
	(setvar "HIGHLIGHT" 1)
)

(defun C:REVSYM ( / )						; Loads & runs 'do_rev' function of EditSym
	(if (null do_rev) (load (strcat _PATH-LISP "EDITSYM")))
	(do_rev)
	(princ)
)

(defun C:DWS ( / )							; Calls Dtext command with angle to align WS
	(initget "T B")
	(if (not (setq tbx (getkword "\n\nPlace text on Top or Bottom (T or B) side of circuit? <T/B>: ")))
		(setq	tbx	"T")
	)
	(while T
		(dtxtln (* 0.075 tmult) "WS" tbx)
	)
)

(defun C:CHG_SC ( / )						; Loads & runs Scale attribute modifier
	(if (null fixsc)
		(LodStage "FIXIT")
	)
	(fixsc)
	(princ)
)

(defun C:FixLine ( / )						; Loads & runs the routine to correct pline widths
	(if (null fixline)
		(LodStage "FIXIT")
	)
	(fixline)
	(princ)
)

(defun C:FIXPN_SC ( / )						; Loads & runs Panel Rescaler function
	(if (not fixpnsc)
		(LodStage "FIXIT")
	)
	(fixpnsc)
	(princ)
)

(defun C:FIX_DUP ( / )						; Loads & runs Dup entity eliminator 
	(if (not fixdup)
		(LodStage "FIXIT")
	)
	(fixdup)
	(princ)
)

(defun C:OFFSW ( / )						; Sets Global vars for automatic switch offsetting
	(setq	off_sw	(not off_sw))
	(if off_sw
		(progn
			(princ "\n\n<<<   Automatic Switch Offset Mode is now ENABLED   >>>")
			(princ "\nSwitches will be offset 0.2 (1/5) of the symbol length.")
			(initget 6)
			(setq	off_sw	(getreal "\nEnter a decimal value [0.01 to 0.99] to change this offset <0.2>: "))
			(if (not off_sw)
				(setq off_sw 0.20)
			)
			(if (> off_sw 1.0)
				(progn
					(princ "\n \nNumber entered must be less than 1.0\n Please retry!")
					(setq off_sw nil)
				)
			)
		)
		(princ "\n \n    <<<   Automatic Switch Offset Mode is now DISABLED   >>>")
	)
	(princ)
)

(defun RepTx ( mnu / )						; Toggle repeat for text entry
	(if (setq reptxt (not reptxt))
		(progn
			(princ "\n \nRepeat Text Mode is now ENABLED.")
			(menucmd (strcat mnu "=*"))
		)
		(progn
			(princ "\n \nRepeat Text Mode is now DISABLED.")
			(menucmd (strcat mnu "=*"))
		)
	)
)

(defun C:Z ( / )	(command "zoom"))			; for Zoom
(defun C:ZW ( / )	(command "zoom" "W"))		; for Zoom Window
(defun C:ZP ( / )	(command "zoom" "P"))		; for Zoom Previous
;(defun C:ZD ( / )	(command "zoom" "D"))		; for Zoom Dynamic
(defun C:ZO ( / )							; for Zoom Out - zooms out maximum w/out regen
	(command "ZOOM" "W" (getvar "VSMIN") (getvar "VSMAX"))
)
(defun C:ZA ( / )	(command "zoom" "A"))		; for Zoom All
(defun C:PE ( / )	(command "PEDIT"))			; for PolyLine Edit
(defun C:ALL ( / )	(command "VIEW" "R" "ALL"))	; for View Restore All

(defun C:SwIcon1 ( / )						; Loads the first symbol icon menu [SWITCHES]
;  Function: Create AutoCAD 'commands' to load icon menus when invoked from
;            pull-down or tablet -- to allow default repeating of symbol
;            insertion commands
	(if Bug (princ "SwIcon1 entered"))
	(if (/= (strcase Mouse) "YES") (command "TABLET" "OFF"))
	(menucmd "I=SYMICON1")
	(menucmd "I=*")
	(if Bug (princ "SwIcon1 exited"))
)

(defun C:SwIcon1A ( / )						; Loads the second symbol icon menu [SWITCHES #2]
;  Function: Create AutoCAD 'commands' to load icon menus when invoked from
;            pull-down or tablet -- to allow default repeating of symbol
;            insertion commands
	(if Bug (princ "SwIcon1a entered"))
	(if (/= (strcase Mouse) "YES") (command "TABLET" "OFF"))
	(menucmd "I=SYMICON1A")
	(menucmd "I=*")
	(if Bug (princ "SwIcon1a exited"))
)

(defun C:SwIcon2 ( / )						; Loads the third symbol icon menu [RISERS]
;  Function: Create AutoCAD 'commands' to load icon menus when invoked from
;            pull-down or tablet -- to allow default repeating of symbol
;            insertion commands
	(if Bug (princ "SwIcon2 entered"))
	(if (/= (strcase Mouse) "YES") (command "TABLET" "OFF"))
	(menucmd "I=SYMICON2")
	(menucmd "I=*")
	(if Bug (princ "SwIcon2 exited"))
)

(defun C:SwIcon3 ( / )						; Loads the fourth symbol icon menu [OTHER EQUIP.]
;  Function: Create AutoCAD 'commands' to load icon menus when invoked from
;            pull-down or tablet -- to allow default repeating of symbol
;            insertion commands
	(if Bug (princ "SwIcon3 entered"))
	(if (/= (strcase Mouse) "YES") (command "TABLET" "OFF"))
	(menucmd "I=SYMICON3")
	(menucmd "I=*")
	(if Bug (princ "SwIcon3 exited"))
)

(defun C:SwIcon4 ( / )						; Loads the fifth symbol icon menu [RECLOSERS]
;  Function: Create AutoCAD 'commands' to load icon menus when invoked from
;            pull-down or tablet -- to allow default repeating of symbol
;            insertion commands
	(if Bug (princ "SwIcon4 entered"))
	(if (/= (strcase Mouse) "YES") (command "TABLET" "OFF"))
	(menucmd "I=SYMICON4")
	(menucmd "I=*")
	(if Bug (princ "SwIcon4 exited"))
)

(defun C:SwIcon5 ( / )						; Loads the sixth symbol icon menu [SCADA]
;  Function: Create AutoCAD 'commands' to load icon menus when invoked from
;            pull-down or tablet -- to allow default repeating of symbol
;            insertion commands
	(if Bug (princ "SwIcon5 entered"))
	(if (/= (strcase Mouse) "YES") (command "TABLET" "OFF"))
	(menucmd "I=SYMICON5")
	(menucmd "I=*")
	(if Bug (princ "SwIcon5 exited"))
)

(defun C:SwIcon6 ( / )						; Loads the sixth symbol icon menu [NEW 08-08-94]
;  Function: Create AutoCAD 'commands' to load icon menus when invoked from
;            pull-down or tablet -- to allow default repeating of symbol
;            insertion commands
	(if Bug (princ "SwIcon6 entered"))
	(if (/= (strcase Mouse) "YES") (command "TABLET" "OFF"))
	(menucmd "I=SYMICON6")
	(menucmd "I=*")
	(if Bug (princ "SwIcon6 exited"))
)

(defun C:TXTICON ( / )						; Loads the text icon menu
;  Function: Create AutoCAD 'commands' to load icon menus when invoked from
;            pull-down or tablet -- to allow default repeating of symbol
;            insertion commands
	(if Bug (princ "txticon entered"))
	(if (/= (strcase Mouse) "YES") (command "TABLET" "OFF"))
	(menucmd "I=TEXTICON1")
	(menucmd "I=*")
	(if Bug (princ "txticon exited"))
)

(defun C:SwIcon9 ( / )						; Loads the first symbol icon menu [SWITCHES]
;  Function: Create AutoCAD 'commands' to load icon menus when invoked from
;            pull-down or tablet -- to allow default repeating of symbol
;            insertion commands
	(if Bug (princ "SwIcon9 entered"))
	(if (/= (strcase Mouse) "YES") (command "TABLET" "OFF"))
	(menucmd "I=SYMICON9")
	(menucmd "I=*")
	(if Bug (princ "SwIcon9 exited"))
)

(defun SaveAns ( /	dcl_fl dcl_id Ans )			; Returns a Dialog answer: yes, no, cancel
	(if (setq dcl_fl (findfile (strcat _Path-LISP "Adds.dcl")))
		(if (> (setq dcl_id (load_dialog dcl_fl)) 0)
			(progn
				(if (new_dialog "Save" dcl_id)
					(progn
						(action_tile "Yes_Key" "(done_dialog 3)")
						(action_tile "No_Key" "(done_dialog 2)")
						(action_tile "Can_Key" "(done_dialog 1)")
						(setq ans (start_dialog))
					)
				)
				(unload_dialog dcl_id)
			)
			(alert "ERROR:  Opening Dialogue Box File..!")
		)
		(alert "ERROR:  Locating Dialogue Box File..!")
	)
	ans
)

(defun Tst4Data ( /	ssi ssAll )			; Tests for any objects in drawing space
										; that aren't Locked Graphics or Quads (DLG's)
	(setq	ssi	(ssget "X"	(list	(cons -4 "<AND")
										(cons -4 "<OR")
											(cons -4 "<AND")
												(cons 0 "INSERT")
												(cons 2 "LOCK")
											(cons -4 "AND>")
											(cons 8 "DLG*")
										(cons -4 "OR>")
										(cons 67 0)
									(cons -4 "AND>")
							)
				)
	)
	(if ssi
		(command "_.ERASE" ssi "")
	)
	(setq	ssAll	(ssget "X" (list (cons 67 0))))
	ssAll
)

(defun C:LINE ( / )						; Redefined command to eliminate Lines
;  Function: to define the AutoCAD "LINE" command for use within ADDS
	(princ "\n \nAutoCAD LINE's should not be used in ADDS.")
	(princ "\nUse PLINE's instead.    ")
)

(defun C:Quit ( / )						; Redefined command to use correct command
	(AddsQuit 1)
	(princ)
)

(defun C:New ( / )							; Redefined command to use correct command
	(AddsQuit 2)
	(princ)
)

(defun C:Open ( / )						; Redefined command to use correct command
	(GetPan nil)
	(princ)
)

(defun C:Save ( /	dcl_fl dcl_id				; Redefined command to use correct command
				Ans LaySt Bubba )
	(if (setq dcl_fl (findfile (strcat _Path-LISP "Adds.dcl")))
		(if (> (setq dcl_id (load_dialog dcl_fl)) 0)
			(progn
				(if (new_dialog "SaveAll" dcl_id)
					(progn
						(action_tile "Yes_Key" "(done_dialog 3)")
						(action_tile "No_Key" "(done_dialog 2)")
						(action_tile "Can_Key" "(done_dialog 1)")
						(setq ans (start_dialog))
					)
				)
				(unload_dialog dcl_id)
			)
			(alert "ERROR:  Opening Dialogue Box File..!")
		)
		(alert "ERROR:  Locating Dialogue Box File..!")
	)
	(if Ans
		(if (= Ans 3)
			(if PanLst
				(setq	LaySt	(LayPrep nil)
						Bubba	(SetLim PanLst)
						Bubba	(foreach	Panel
										PanLst
										(SavPan Panel 3)
								)
				)
			)
			(if (= Ans 2)
				(C:SaveOne)
				(princ "\nSave cancelled")
			)
		)
		(princ "\nSave error")
	)
	(princ)
)

(defun C:SaveOne ( /	Ans LaySt Bubba )		; Redefined command to use correct command
	(setq	LaySt	(LayPrep nil)
			Bubba	(SetLim PanLst)
			Bubba	(SavPan nil 3)
	)
	(princ)
)

(defun C:Close1 ( /		dcl_fl dcl_id			; Redefined command to use correct command
					Ans LaySt Bubba )
	(if Bug (if Bug (princ "\nCommands.lsp!C:Close1")))
	(if (setq dcl_fl (findfile (strcat _Path-LISP "Adds.dcl")))
		(if (> (setq dcl_id (load_dialog dcl_fl)) 0)
			(progn
				(if (new_dialog "CloseAll" dcl_id)
					(progn
						(action_tile "Yes_Key" "(done_dialog 3)")
						(action_tile "No_Key" "(done_dialog 2)")
						(action_tile "Can_Key" "(done_dialog 1)")
						(setq ans (start_dialog))
					)
				)
				(unload_dialog dcl_id)
			)
			(alert "ERROR:  Opening Dialogue Box File..!")
		)
		(alert "ERROR:  Locating Dialogue Box File..!")
	)
	(if Ans
		(if (= Ans 3)
			(AddsQuit 3)
;			(ClosEm)			
		(if (= Ans 2)
				(C:CloseOne)
				(princ "\nSave cancelled")
			)
		)
		(princ "\nSave error")
	)
	(setq DwgType	nil)
	(princ)
)

(defun C:CloseOne ( /	LaySt Bubba )			; Redefined command to use correct command
	(if Bug (if Bug (princ "\nCommands.lsp!C:CloseOne")))
	(setq	DwgType	nil
			LaySt	(LayPrep nil)
			Bubba	(SetLim PanLst)
			Bubba	(SavPan nil 2)
	)
	(princ)
)

(defun C:SavClose ( /	dcl_id dcl_fl			; Redefined command to use correct command
					Ans LaySt Bubba )
	(if (setq dcl_fl (findfile (strcat _Path-LISP "Adds.dcl")))
		(if (> (setq dcl_id (load_dialog dcl_fl)) 0)
			(progn
				(if (new_dialog "SavCloseAll" dcl_id)
					(progn
						(action_tile "Yes_Key" "(done_dialog 3)")
						(action_tile "No_Key" "(done_dialog 2)")
						(action_tile "Can_Key" "(done_dialog 1)")
						(setq ans (start_dialog))
					)
				)
				(unload_dialog dcl_id)
			)
			(alert "ERROR:  Opening Dialogue Box File..!")
		)
		(alert "ERROR:  Locating Dialogue Box File..!")
	)
	(if Ans
		(if (= Ans 3)
			(setq	LaySt	(LayPrep nil)
					Bubba	(SavClosEm)
			)
			(if (= Ans 2)
				(C:SavCloseOne)
				(princ "\nSave cancelled")
			)
		)
		(princ "\nSave error")
	)
	(setq 	DwgType	nil)
	(princ)
)

(defun C:SavCloseOne ( /	Ans LaySt Bubba )	; Redefined command to use correct command
	(setq	DwgType	nil
			Bubba	(SetLim PanLst)
			Bubba	(SavPan nil 4)
	)
	(princ)
)

(defun C:PanScl ( / )						; Gets Panel Scale
	(getps nil)
	(princ)
)

(defun C:MakPan ( / )						; Makes Panel that didnt exist
	(MakPan nil)
	(princ)
)

(defun C:OpenBak ( / )						; Opens Quick Backup (obsolete)
	(GetBak "ADDS_BAK")
	(princ)
)

(defun C:OpenDev ( / )						; Opens by Device_ID
	(GetDev nil)
	(princ)
)

(defun C:OpenFeed ( / )						; Opens by Feeder
	(GetFeed nil)
	(princ)
)

(defun C:OpenSub ( / )						; Opens by Substation
	(GetSub)
	(princ)
)

(defun C:OpenSubT ( / )						; Opens by Substation
	(GetSubT nil)
	(princ)
)

(defun C:OpenURD ( / )						; Opens by Substation
	(Get_URD nil)
	(princ)
)

(defun C:OpenFile ( / )						; Opens by File (drawing/panel list)
	(GetFil nil)
	(princ)
)

(defun C:OpenPan ( / )						; Opens by Panel
	(GetPan nil)
	(princ)
)

(defun C:OpenSW ( / )						; Opens by Switch
	(GetSW)
	(princ)
)

(defun C:OpenWin ( / )						; Opens by Window (2 points)
	(GetWin nil nil)
	(princ)
)

(defun C:Update_INI ( / )					; Dialog to Update Settings
	(Upd_INI)
	(princ)
)

(defun C:Update_Div_INI ( / )				; Change Current Division
	(if Div
		(UpdDivINI Div)
		(UpdDivINI nil)
	)
	(princ)
)

(defun C:Update_Mult ( / )					; Update Multiplier (Mobile Mostly)
	(MultDlg TMult SMult)
	(princ)
)

(defun C:Del_Sym ( / )						; Delete Symbol (and fix circuit beneath)
	(DelSym nil)
	(princ)
)

(defun C:DelSym ( / )						; Delete Symbol (and fix circuit beneath)
	(DelSym nil)
	(princ)
)

(defun C:Drw_Arr ( / )						; Draw Arrow
	(Drw_Arr T)
	(princ)
)

(defun C:MisLin_LM ( / )					; Draw Landmark Line
	(mislin "LM" 0.0099)
	(princ)
)

(defun C:MisLin_DT ( / )					; Draws District Boundary
	(mislin "DT" 0.0099)
	(princ)
)

(defun C:MisLin_DV ( / )					; Draws Division Boundary
	(mislin "DV" 0.0099)
	(princ)
)

(defun C:MisLin_TA ( / )					; Draws 44 kV TL
	(mislin "TA" 0.0099)
	(princ)
)

(defun C:MisLin_TB ( / )					; Draws 115 kV TL
	(mislin "TB" 0.0099)
	(princ)
)

(defun C:MisLin_TC ( / )					; Draws 161 kV TL
	(mislin "TC" 0.0099)
	(princ)
)

(defun C:MisLin_TD ( / )					; Draws 230 kV TL
	(mislin "TD" 0.0099)
	(princ)
)

(defun C:MisLin_TE ( / )					; Draws 500 kV TL
	(mislin "TE" 0.0099)
	(princ)
)

(defun C:MisLin_AA ( / )					; Draws Small Dashes
	(mislin "AA" 0.0099)
	(princ)
)

(defun C:MisLin_AB ( / )					; Draws Large Dashes
	(mislin "AB" 0.0099)
	(princ)
)

(defun C:MisLin_AC ( / )					; Draws Centerline Dashes
	(mislin "AC" 0.0099)
	(princ)
)

(defun C:MisLin_AD ( / )					; Draws Dots
	(mislin "AD" 0.0099)
	(princ)
)

(defun C:BDTxt_ST_T ( / )					; Text - Street T
	(DtxtLn 0.075 "ST" "T")
	(princ)
)

(defun C:BDTxt_ST_B ( / )					; Text - Street B
	(DtxtLn 0.075 "ST" "B")
	(princ)
)

(defun C:BDTxt_TR_T ( / )					; Text - Transmission T
	(BDtxt 0.075 "----TAT---" "T")
	(princ)
)

(defun C:BDTxt_TR_B ( / )					; Text - Transmission B
	(BDtxt 0.075 "----TAT---" "B")
	(princ)
)

(defun C:BDTxt_LM_T ( / )					; Text - LandMark T
	(BDtxt 0.075 "----LM----" "T")
	(princ)
)

(defun C:BDTxt_LM_B ( / )					; Text - LandMark B
	(BDtxt 0.075 "----LM----" "B")
	(princ)
)

(defun C:BDTxt_DtDv ( / )					; Text - District/Division
	(MakLstTxt 1)
	(princ)
)

(defun C:WireSz1 ( / )						; Text - WireSize Pri
	(WireSize 1)
	(princ)
)

(defun C:WireSz2 ( / )						; Text - WireSize Pri/Neu
	(WireSize nil)
	(princ)
)

(setq	LodVer	"2.5.2h")
