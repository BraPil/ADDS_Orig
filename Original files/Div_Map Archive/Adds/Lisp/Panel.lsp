(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " Panel Loading."))
	(princ "\nAdds Panel Loading.")
)

(defun AddsQuit ( flag / pan ssA Ans )			; Quits from Adds/New Screen from Adds
	(if Bug 
		(progn
			(princ "\nPanel.lsp!AddsQuit - Parameter flag = ")
			(prin1 flag)
			(princ)
		)
	)
	(cond
		((= flag 1)	; 'Quit' command originated!
			(if (null PanLst)
				(if (Tst4Data)
					(alert "You have objects not saved in any panel...\n you shouldn't leave.(1)")
					(AddsExit_New)
				)
				(if (>= (setq Ans (SaveAns)) 3)
					(progn
						(SavClosEm)
						(if (Tst4Data)
							(alert "You have objects not saved in any panel...\n you shouldn't leave.(2)")
							(AddsExit_New)
						)
					)
					(if (>= Ans 2)
						(if QkSaved
							(progn
								(initget 1 "Yes No")
								(if (= (getkword "\n\nDo you wish to delete your quick save & release panel...") "No")
									(if (Tst4Data)
										(alert "You have objects not saved in any panel...\n you can't leave.(3)")
										(AddsExit_New)
									)
									(progn
										(DelAllLck)
										(command "DEL" (strcat ADDS_HD "ADDS_BAK.*"))
										(if (Tst4Data)
											(alert "You have objects not saved in any panel...\n you can't leave.(4)")
											(AddsExit_New)
										)
									)
								)
							)
							(progn
								(DelAllLck)
								(AddsExit_New)
							)
						)
						(alert "***ADDS MESSAGE***\nQuit terminated.")
					)
				)
			)
		)
		((= flag 2)	; 'New' command originated!
			(if (null PanLst)
				(if (setq ssA (ssget "X"))
					(progn
						(setq	ExPrt	(getvar "EXPERT"))
						(setvar "EXPERT" 5)
						(setq	LayNamLst	(GetLayoutNames))
						(foreach	LayName
								LayNamLst
								(if (and (/= (strcase LayName) "MODEL") (/= (strcase LayName) "LAYOUT1"))
									(DeleteLayout LayName)
								)
						)
						(SetCurrLayout "Model")
						(command	"_.LAYER" "T" "*" "ON" "*" "U" "*" "S" "0" "" "_.ERASE" ssA "" "PURGE" "A" "~---*" "N" "ZOOM" "E")
						(setvar "EXPERT" ExPrt)
					)
					(command	"_.LAYER" "T" "*" "ON" "*" "U" "*" "S" "0" "" "PURGE" "A" "~---*" "N" "ZOOM" "E")
				)
				(if (>= (setq Ans (SaveAns)) 3)
					(progn
						(SavClosEm)
						(if (Tst4Data)
							(alert "You have objects not saved in any panel...\n you shouldn't continue without saving.(5)")
						)
					)
					(if (>= Ans 2)
						(if QkSaved
							(progn
								(initget 1 "Yes No")
								(if (= (getkword "\n\nDo you wish to delete your quick save? ") "No")
									(progn
										(DelAllLck)
										(if (setq ssA (ssget "X"))
											(command	"_.LAYER" "T" "*" "ON" "*" "U" "*" "S" "0" "" "_.ERASE" ssA "" "PURGE" "A" "~---*" "N" "ZOOM" "E")
											(command	"_.LAYER" "T" "*" "ON" "*" "U" "*" "S" "0" "" "PURGE" "A" "~---*" "N" "ZOOM" "E")
										)
									)
									(progn
										(DelAllLck)
										(command "DEL" (strcat ADDS_HD "ADDS_BAK.*"))
										(if (setq ssA (ssget "X"))
											(command	"_.LAYER" "T" "*" "ON" "*" "U" "*" "S" "0" "" "_.ERASE" ssA "" "PURGE" "A" "~---*" "N" "ZOOM" "E")
											(command	"_.LAYER" "T" "*" "ON" "*" "U" "*" "S" "0" "" "PURGE" "A" "~---*" "N" "ZOOM" "E")
										)
									)
								)
							)
							(progn
								(DelAllLck)
								(setq	LayNamLst	(GetLayoutNames))
								(foreach	LayName
										LayNamLst
										(if (and (/= (strcase LayName) "MODEL") (/= (strcase LayName) "LAYOUT1"))
											(DeleteLayout LayName)
										)
								)
								(SetCurrLayout "Model")
								(if (setq ssA (ssget "X"))
									(command	"_.LAYER" "T" "*" "ON" "*" "U" "*" "S" "0" "" "_.ERASE" ssA "" "PURGE" "A" "~---*" "N" "ZOOM" "E")
									(command	"_.LAYER" "T" "*" "ON" "*" "U" "*" "S" "0" "" "PURGE" "A" "~---*" "N" "ZOOM" "E")
								)
							)
						)
						(alert "***ADDS MESSAGE***\nNew terminated.")
					)
				)
			)
			(if (= PanTyp 2)
				(SubMenuSet nil)
			)
			(SSNIL)
		)
		((= flag 3)
			(DelAllLck)
			(setq	LayNamLst	(GetLayoutNames))
			(foreach	LayName
					LayNamLst
					(if (and (/= (strcase LayName) "MODEL") (/= (strcase LayName) "LAYOUT1"))
						(DeleteLayout LayName)
					)
			)
			(SetCurrLayout "Model")
			(if (setq ssA (ssget "X"))
				(command	"_.LAYER" "T" "*" "ON" "*" "U" "*" "S" "0" "" "_.ERASE" ssA "" "PURGE" "A" "~---*" "N" "ZOOM" "E")
				(command	"_.LAYER" "T" "*" "ON" "*" "U" "*" "S" "0" "" "PURGE" "A" "~---*" "N" "ZOOM" "E")
			)
			(if (= PanTyp 2)
				(SubMenuSet nil)
			)
		)
	)
	Ans
)

(defun AddsExit_New (/)
	(command "_.Quit" "Y")
)


(defun BldShtVal ( / )						; Builds LstShtVal for BldSht (Style Sheet definitions)
	(setq	LstShtVal		(list	
;;; Mobile
								(list	"URD_EN2A"				;ShtNam
										"F"						;PageSize
										"-90"					;DView TWist
										(list 381412.82 3390793.78)	;ViewCtr
										1088.32					;ViewSize
										"Mview 0,0 33,28"			;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"WDR0191Z"				;ShtReference
								)
								(list	"URD_EN3A"				;ShtNam
										"E"						;PageSize
										"90"						;DView TWist
										(list 385569.31 3389371.34)	;ViewCtr
										1248.66					;ViewSize
										"Mview 0,0 43,33"			;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"WDR0032Z"				;ShtReference
								)
								(list	"URD_EN4A"				;ShtNam
										"D"						;PageSize
										"0"						;DView TWist
										(list 401204.19 3414764.62)	;ViewCtr
										1656.10					;ViewSize
										"Mview 0,0 33,23"			;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"NDR0005Z"				;ShtReference
								)
								(list	"URD_EN5A"				;ShtNam
										"F"						;PageSize
										"90"						;DView TWist
										(list 569157.25 3579021.80)	;ViewCtr
										902.19					;ViewSize
										"Mview 16,7.5 40,28"		;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"WDR0006Z"				;ShtReference
								)
								(list	"URD_EN6A"				;ShtNam
										"C"						;PageSize
										"0"						;DView TWist
										(list 385512.24 3400092.48)	;ViewCtr
										1217.40					;ViewSize
										"Mview  5.5,2.5 18,16.75"	;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"WDR0005Z"				;ShtReference
								)
;;; Southern
								(list	"URD_EM7A"				;ShtNam
										"F"						;PageSize
										"0"						;DView TWist
										(list 580791.00 3577701.94)	;ViewCtr
										0.0328083					;ViewScaleXP
										"MView P 0,0 @27,0 @0,3 @13,0 @0,25 @-40,0 c"
																;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"31UG196"					;ShtReference
								)
								(list	"URD_EM7B"				;ShtNam
										"F"						;PageSize
										"37"						;DView TWist
										(list 581133.93 3577502.47)	;ViewCtr
										398.63					;ViewSize
										"Mview 3,1.75 32,24"		;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"31UG196A"				;ShtReference
								)
								(list	"URD_EM7C"				;ShtNam
										"F"						;PageSize
										"32.5"					;DView TWist
										(list 581123.22 3577202.90)	;ViewCtr
										0.043743					;ViewScaleXP
										"MView P 2,5 @5<70 a @0,5 l @5<110 a @5<20 l @1<-70 a @5,0 @5,0 @5,0 l @1<70 a @5<-20 l @5<-110 a @0,-5 l @5<-70 c"
																;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"31UG196B"				;ShtReference
								)
								(list	"URD_EM7D"				;ShtNam
										"F"						;PageSize
										"-58"					;DView TWist
										(list 580761.89 3576451.48)	;ViewCtr
										546.53					;ViewSize
										"MView P 0,0 @27,0 @0,3 @13,0 @0,25 @-40,0 c"
																;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"31UG196C"				;ShtReference
								)
								(list	"URD_EM7E"				;ShtNam
										"F"						;PageSize
										"-90"					;DView TWist
										(list 581351.82 3577399.21)	;ViewCtr
										434.32					;ViewSize
										"MView P 0,0 @27,0 @0,3 @13,0 @0,25 @-40,0 c"
																;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"31UG196D"				;ShtReference
								)
								(list	"URD_EM7F"				;ShtNam
										"F"						;PageSize
										"0"					;DView TWist
										(list 581438.40 3577025.68)	;ViewCtr
										374.18					;ViewSize
										"MView P 0,0 @27,0 @0,3 @13,0 @0,25 @-40,0 c"
																;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"31UG196E"				;ShtReference
								)
								(list	"URD_EM7G"				;ShtNam
										"F"						;PageSize
										"0"						;DView TWist
										(list 581412.58 3576765.80)	;ViewCtr
										428.84					;ViewSize
										"MView P 0,0 @27,0 @0,3 @13,0 @0,25 @-40,0 c"
																;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"31UG196F"				;ShtReference
								)
								(list	"URD_EM7H"				;ShtNam
										"F"						;PageSize
										"0"						;DView TWist
										(list 581075.88 3576577.17)	;ViewCtr
										408.22					;ViewSize
										"MView P 0,0 @27,0 @0,3 @13,0 @0,25 @-40,0 c"
																;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"31UG196G"				;ShtReference
								)
								(list	"URD_EM7I"				;ShtNam
										"F"						;PageSize
										"260"					;DView TWist
										(list 581258.06 3576897.26)	;ViewCtr
										216.03					;ViewSize
										"MView P 0,0 @27,0 @0,3 @13,0 @0,25 @-40,0 c"
																;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"31UG196H"				;ShtReference
								)
								(list	"URD_EM7J"				;ShtNam
										"F"						;PageSize
										"-10"					;DView TWist
										(list 581109.35 3576731.44)	;ViewCtr
										234.95					;ViewSize
										"MView 3,7 40,28"			;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"31UG196I"				;ShtReference
								)
								(list	"URD_EM8A"				;ShtNam
										"F"						;PageSize
										"-90"					;DView TWist
										(list 569157.25 3579021.80)	;ViewCtr
										902.19					;ViewSize
										"MView P 0,0 @27,0 @0,3 @13,0 @0,25 @-40,0 c"
																;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"31UG001"					;ShtReference
								)
								(list	"URD_EM8B"				;ShtNam
										"F"						;PageSize
										"90"						;DView TWist
										(list 569198.87 3579411.62)	;ViewCtr
										127.67					;ViewSize
										"MView 0.75,3.50 32.75,27.25"	;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"31UG001A"				;ShtReference
								)
								(list	"URD_EM8C"				;ShtNam
										"F"						;PageSize
										"-90"					;DView TWist
										(list 568947.61 3579235.02)	;ViewCtr
										172.42					;ViewSize
										"MView P 2.125,10 @8,0 @4.25<250 @16,0 @4.25<70 @8,0 @8.5<70 @-8,0 @4.25<70 @-16,0 @4.25<250 @-8,0 c"
																;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"31UG062"					;ShtReference
								)
								(list	"URD_EM9A"				;ShtNam
										"F"						;PageSize
										"-90"					;DView TWist
										(list 569157.25 3579021.80)	;ViewCtr
										902.19					;ViewSize
										"Mview 0,0 40,28"			;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"31UG002"					;ShtReference
								)
								(list	"URD_EN0A"				;ShtNam
										"F"						;PageSize
										"-90"					;DView TWist
										(list 573975.92 3584166.12)	;ViewCtr
										490.14					;ViewSize
										"Mview 0,0 40,28"			;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"31UG010"					;ShtReference
								)
								(list	"URD_EN1A"				;ShtNam
										"F"						;PageSize
										"90"						;DView TWist
										(list 577569.52 3579806.89)	;ViewCtr
										1280.35					;ViewSize
										"Mview 0,0 40,28"			;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"31UG031"					;ShtReference
								)
								(list	"URD_EN1B"				;ShtNam
										"F"						;PageSize
										"-90"					;DView TWist
										(list 573975.92 3584166.12)	;ViewCtr
										490.14					;ViewSize
										"Mview 0,0 40,28"			;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"31UG031A"				;ShtReference
								)
;;; Western
								(list	"URD_W13A"				;ShtNam
										"D"						;PageSize
										"17"					;DView TWist
										(list 444002.94 3684362.09)	;ViewCtr
										855.93					;ViewSize
										"Mview 0,0 33,23"			;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"W13"					;ShtReference
								)
								(list	"URD_W41A"				;ShtNam
										"C"						;PageSize
										"0"						;DView TWist
										(list 442457.43 3679811.69)	;ViewCtr
										146.30					;ViewSize
										"Mview 6.39,6.93 16.50,14.44"	;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"651-10011Z"				;ShtReference
								)
								(list	"URD_W41B"				;ShtNam
										"D"						;PageSize
										"-90"					;DView TWist
										(list 442360.92 3679555.70)	;ViewCtr
										432.19					;ViewSize
										"Mview 0.50,2.25 32.75,22.50"	;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"651-10011Z"				;ShtReference
								)
								(list	"URD_W41C"				;ShtNam
										"D"						;PageSize
										"-90"					;DView TWist
										(list 442360.92 3679555.70)	;ViewCtr
										432.19					;ViewSize
										"Mview 0.50,2.25 32.75,22.50"	;ViewPort UR
										"N"						;Hide Boundary
										"-20UCK-401,-20UCK-402,-20UCK-403,-20UCK-405,-20UCK-406"	;Layers to Freeze
										"651-10011Z"				;ShtReference
								)
								(list	"URD_WBFA"				;ShtNam
										"D"						;PageSize
										"2"						;DView TWist
										(list 455309.01 3668293.29)	;ViewCtr
										518.90					;ViewSize
										"Mview 0,0 25,23"			;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"751-10095Z"				;ShtReference
								)
								(list	"URD_WESA"				;ShtNam
										"C"						;PageSize
										"0"						;DView TWist
										(list 476053.61 3746179.49)	;ViewCtr
										585.02					;ViewSize
										"Mview 0,0 14,17"			;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"430-08-0028-95"			;ShtReference
								)
								(list	"URD_WF6A"				;ShtNam
										"D"						;PageSize
										"-3"						;DView TWist
										(list 447457.99 3664199.65)	;ViewCtr
										605.86					;ViewSize
										"Mview 0,0 13,23"			;ViewPort UR
										"N"						;Hide Boundary
										"Mask,UrdPoly,????PL*,Road*"	;Layers to Freeze
										"410-08-0054-01"			;ShtReference
								)
						)
	)
)

(defun LodFileLst (	/	FilInp )			; Builds FLst from "files.lst"
	(if (findfile (strcat _Path-Panel "files.lst"))
		(progn
			(setq	FilG		(open (findfile (strcat _Path-Panel "files.lst")) "r")
					FilInp	(read-line FilG)
			)
			(while FilInp
				(if FilInp
					(if FLst
						(setq	FLst		(cons FilInp FLst))
						(setq	FLst		(list FilInp))
					)
				)
				(setq	FilInp	(read-line FilG))
			)
			(close FilG)
		)
	)
	FLst
)

(defun C:NexPan ( / )						; CL - Runs RevOrd and opens next file
	(if (not NexLst)
		(setq	NexLst	(LodFileLst))
	)
	(if NexLst
		(setq	Gon		(car NexLst)
				NexLst	(cdr NexLst)
		)
		(setq	Gon		nil)
	)
	(if PanLst
		(SavClosEm)
	)
	(if Gon
		(GetPan Gon)
	)
	(princ)
)

(defun GetFeed (_fd / )
	(if Bug (princ "\nPanel.lsp GetFeed - Start\n"))
	(if (not Div)
		(alert (strcat "***" AppNam " Error***\nDiv not set!"))
	)
	(setq	dlg		2)
	(if (and Div (not Lst_Fd_XY))
		(progn
			(cond 
				((= Div "BH") (princ "\nGetting Birmingham Feeder coordinates data"))
				((= Div "W_") (princ "\nGetting Western Feeder coordinates data"))
				((= Div "E_") (princ "\nGetting Easter Feeder coordinates data"))
				((= Div "M_") (princ "\nGetting Mobile Feeder coordinates data"))
				((= Div "S_") (princ "\nGetting Southern Feeder coordinates data"))
				((= Div "SE") (princ "\nGetting Southeastern Feeder coordinates data"))
				((= Div "GA") (princ "\nGetting GCC Line coordinates data"))
				((= Div "AL") (princ "\nGetting ACC Line coordinates data"))
			)
			(if (null GetFeederCor)
				(command "netload" "C:\\Div_Map\\Common\\Adds.dll")
			)
			;	Get all Feeder extents data for current division
			(setq lstFdrCors (GetFeederCor Div MyUsrInfo)
				Lst_Fd_XY  (list)
				Lst_Fd_Nam (list)
			)
			(setq index 0)
			(repeat (length lstFdrCors)
				(setq lstFdrCor (nth index lstFdrCors)
						index (+ index 1)
				)
				(setq	InList
					(list 
						(list (nth 0 lstFdrCor) (nth 1 lstFdrCor))
						(list (nth 2 lstFdrCor) (nth 3 lstFdrCor))
					)
					Lst_Fd_XY  (append Lst_Fd_XY (list	InList))
					Lst_Fd_Nam (append Lst_Fd_Nam (list(nth 4 lstFdrCor)))
				)
			)
		)
	)
	;	Loads and displays Feeder selection dialog box.
	(if Lst_Fd_Nam
		(if (setq Dcl_Pan (findfile (strcat _path-lisp "Adds.dcl")))
			(if (> (setq Dcl_Pan (load_dialog Dcl_Pan)) 0)
				(while (> dlg 1)
					(new_dialog "FdLstR" Dcl_Pan)
					(mode_tile "Lst1" 0)
					(start_list "Lst1" 3)
					(add_list " ")
					(mapcar (quote add_list) Lst_Fd_R)		; was Lst_Fd_S
					(end_list)
					(action_tile "Lst1" "(setq FdVal $value)")
					(setq dlg (start_dialog))
					(unload_dialog Dcl_Pan)
				)
				(alert "\nUnable to open DCL file")
			)
			(alert "\nUnable to find DCL file")
		)
	)
	;	Reacts to dialog box selection to load selected feeder.
	(if (= dlg 1)
		(progn
			(if Bug (princ (strcat "\nFdVal = " FdVal)))
			(if (and (not _fd) FdVal)
				(setq	_fd		(nth (1- (atoi FdVal)) Lst_Fd_V)
						PosFd	(- (length Lst_Fd_Nam) (length (member _fd Lst_Fd_Nam)))
				)
			)
			(if Bug (princ (strcat "\n_fd = " _fd)))
			(if PosFd
				(if (nth PosFd Lst_Fd_XY)
					(setq	Fd_Loc	(nth PosFd Lst_Fd_XY))
					(alert (strcat "***" AppNam " Error***\nPosition (" (itoa PosFd) ") unpopulated!"))
				)
				(progn
					(setq	Fd_Loc	nil)
					(alert (strcat "***" AppNam " Error***\nPosition Variable unpopulated!"))
				)
			)
			(if Fd_Loc
				(GetWin (nth 0 Fd_Loc) (nth 1 Fd_Loc))
			)
			(Bld_SL)
		)
		(princ "\nOpen by Feeder cancelled")
	)
	(if PanLst
		(if (not SF)
			(SclFactor)
		)
	)
	(princ)
)

(defun GetFeed_Old ( _fd /	Pos_Fd FCNam Fn InData	; Loads Feeder.COR for the current Division
					InList FdNam )
	(if (not Div)
		(alert (strcat "***" AppNam " Error***\nDiv not set!"))
	)
	(if Div
		(setq	FCNam	(findfile (strcat _Path-Panel "Feeder.COR"))) ;Div
		(setq	FCNam	nil)
	)
	(setq	dlg		2)
	(if (and Div (not Lst_Fd_XY))
		(if FCNam
			(progn
				(cond	((= Div "BH") (princ "\nLoading Birmingham Feeder.COR file"))
						((= Div "W_") (princ "\nLoading Western Feeder.COR file"))
						((= Div "E_") (princ "\nLoading Eastern Feeder.COR file"))
						((= Div "N_") (princ "\nLoading Northern Feeder.COR file"))
						((= Div "S_") (princ "\nLoading Southern Feeder.COR file"))
						((= Div "SE") (princ "\nLoading South-Eastern Feeder.COR file"))
				)
				(setq	Fn			(open FCNam "r")
						InData		(read-line Fn)
				)
				(if InData
					(setq	InList		(list
											(list	(atof (substr InData 1 10))
													(atof (substr InData 11 10))
											)
											(list	(atof (substr InData 21 10))
													(atof (substr InData 31 10))
											)
										)
							Lst_Fd_Nam	(list	(substr InData 41))
							Lst_Fd_XY	(list	InList)
					)
				)
				(while (setq InData (read-line Fn))
					(if InData
						(setq	InList	(list
											(list	(atof (substr InData 1 10))
													(atof (substr InData 11 10))
											)
											(list	(atof (substr InData 21 10))
													(atof (substr InData 31 10))
											)
										)
								FdNam	(substr InData 41)
						)
						(setq	InList	nil
								FdNam	nil
						)
					)
					(if (and InList FdNam)
						(setq	Lst_Fd_Nam	(append Lst_Fd_Nam (list FdNam))
								Lst_Fd_XY		(append Lst_Fd_XY (list InList))
						)
					)
				)
				(close Fn)
			)
			(alert (strcat "***" AppNam " Error***\nDiv (" Div ") .COR file not found!"))
		)
	)
	(if (and _fd Lst_Fd_Nam)
		(setq	PosFd	(- (length Lst_Fd_Nam) (length (member _fd Lst_Fd_Nam))))
		(if (setq Dcl_Pan (findfile (strcat _path-lisp "Adds.dcl")))
			(if (> (setq Dcl_Pan (load_dialog Dcl_Pan)) 0)
				(while (> dlg 1)
					(new_dialog "FdLstR" Dcl_Pan)
					(mode_tile "Lst1" 0)
					(start_list "Lst1" 3)
					(add_list " ")
					(mapcar (quote add_list) Lst_Fd_R)		; was Lst_Fd_S
					(end_list)
					(action_tile "Lst1" "(setq FdVal $value)")
					(setq dlg (start_dialog))
					(unload_dialog Dcl_Pan)
				)
				(alert "\nUnable to open DCL file")
			)
			(alert "\nUnable to find DCL file")
		)
	)
	(if (= dlg 1)
		(progn
			(if Bug (princ (strcat "\nFdVal = " FdVal)))
			(if (and (not _fd) FdVal)
				(setq	_fd		(nth (1- (atoi FdVal)) Lst_Fd_V)
						PosFd	(- (length Lst_Fd_Nam) (length (member _fd Lst_Fd_Nam)))
				)
			)
			(if Bug (princ (strcat "\n_fd = " _fd)))
			(if PosFd
				(if (nth PosFd Lst_Fd_XY)
					(setq	Fd_Loc	(nth PosFd Lst_Fd_XY))
					(alert (strcat "***" AppNam " Error***\nPosition (" (itoa PosFd) ") unpopulated!"))
				)
				(progn
					(setq	Fd_Loc	nil)
					(alert (strcat "***" AppNam " Error***\nPosition Variable unpopulated!"))
				)
			)
			(if Fd_Loc
				(GetWin (nth 0 Fd_Loc) (nth 1 Fd_Loc))
			)
			(Bld_SL)
		)
		(princ "\nOpen by Feeder cancelled")
	)
	(if PanLst
		(if (not SF)
			(SclFactor)
		)
	)
	(princ)
)

(defun C:QkSave ( /	ssAttD QsFn PanNam )	; Save a copy of the current drawing
; Function:  Save a copy of the current drawing, the base quad map name,
;            and the viewport coords into temp backup file ADDS_BAK.DWG
	(if Bug (princ "\nQkSave entered."))
	(setvar "EXPERT" 4)
	(if (null AttNamP)
		(setq AttNamP "")
	)
	(command	"_.LAYER" "T" "0" "U" "0" "On" "0" "S" "0" "")
	(command	"_.ATTDEF" "" "SAVING" "" AttNamP "M" (getvar "VIEWCTR") (/ (getvar "VIEWSIZE") 4) "0")
	(setq	ssAttD	(ssadd (entlast)))
	(if ssAttD
		(progn
			(command	"_.CHPROP" ssAttD "" "LA" "----SC----" "" ".SAVE" (strcat ADDS_HD "ADDS_BAK") "_.ERASE" ssAttD "")
			(setq	ssAttD	nil)
		)
	)
	(if (and PanLst Adds_HD)
		(progn
			(setq QsFn (open (strcat Adds_HD "ADDS_BAK.PAN") "w"))
			(foreach PanNam PanLst (write-line PanNam QsFn))
			(close QsFn)
		)
	)
	(setq QkSaved "T")
	(setvar "EXPERT" 1)
	(if Bug (princ "QkSave exited."))
	(princ)
)

(defun GetBak ( fn / pf pan )				; Loads Backup file and PanLst
	(if Bug (princ "\nGetBak entered"))
	(if (findfile (strcat fn ".PAN"))
		(progn
			(setq	pf		(open (strcat fn ".PAN") "r"))
			(while (setq pan (read-line pf))
				(if newlst
					(setq	newlst	(cons pan newlst))
					(setq	newlst	(list pan))
				)
			)
			(close pf)
			(SetLim (append newlst PanLst))
			(princ (strcat "\n\nOne moment please.  Loading " fn ".dwg"))
			(command "INSERT" (strcat "*" fn) "0,0" "" "")
			(foreach	pan
					newlst
					(LokPan pan)
			)
			(setq	newlst	nil)
;;;			(if (= (setq 1flag (length PanLst)) 1) ;--1flag=1 indicates that only one panel is loaded---
;;;				(setvar "LIMCHECK" 1)  ;turn limit-checking on
;;;				(progn
;;;					(setvar "LIMCHECK" 0)  ;turn limit-checking off
;;;					(setq 1flag nil)
;;;				)
;;;			)
			(Bld_SL)
		)
		(princ (strcat "\n***ADDS MESSAGE***  file containing panel list, " fn " was not found:  "))
	)
	(if PanLst
		(if (not SF)
			(SclFactor)
		)
	)
	(if Bug (princ "\nGetBak exited"))
	(princ)
)

(defun GetDev ( MyDev_ID /	Pan_ID PanNam Div_ID )					; Loads a panel from a Device_ID
	(if Bug (princ "\n GetDev entered"))
	(if (not MyDev_ID)
		(setq	MyDev_ID	(getstring "\nEnter Device_ID to search for: "))
	)
	(if MyDev_ID
		(setq	Pan_ID	
						(cond 
							((OR(= AcadVersion "18.2") (= AcadVersion "20.1") (= AcadVersion "23.0") (= AcadVersion "24.2"))
								(if (null MyChkDevPan_2012)			
									(command "netload" "C:\\Div_Map\\Common\\Adds.dll")
								)
								(MyChkDevPan_2012 MyDev_ID)
							)
							(T
								(MyChkDevPan MyDev_ID)
					 		)
						)
		)
	)
	(if Bug (progn (princ "\nPan_ID : ") (prin1 Pan_ID)))
	(if Pan_ID
		(setq	PanNam	(PanNam_from_ID Pan_ID))
	)
	(if Bug (progn (princ "\nPanNam : ") (prin1 PanNam)))
	(if PanNam
		(if (= (PanTypChk PanNam) 1)
			(princ (strcat "\nDevice_ID found in Panel {" PanNam "} a Geographic Panel"))
			(princ (strcat "\nDevice_ID found in Panel {" PanNam "} a Schematic Panel"))
		)
	)
	(if (AND PanNam (/= Div "GA") (/= Div "AL"))
		(setq	Div_ID	(MyChkPanObj (itoa Pan_ID)))
	)
	(if (null sf)
		(if (/= Div "GA")
			(setq	sff		1000
				sf		(* sff 0.3048)
				Bubba	(setvar "THICKNESS" (float sff))
			)
			(setq	sff		500
				sf		(* sff 0.3048)
				Bubba	(setvar "THICKNESS" (float sff))
			)
		)
	)
	(if Div_ID
		(cond	((= Div_ID 1)
					(if (/= Div "BH")
						(if (< (length PanLst) 1)
							(UpdDivINI "BH")
							(progn
								(alert (strcat "***" AppNam " Error***\nCan't change Division with Panels Open"))
								(setq	PanNam	nil)
								(exit)
							)
						)
					)
				)
				((= Div_ID 2)
					(if (/= Div "E_")
						(if (< (length PanLst) 1)
							(UpdDivINI "E_")
							(progn
								(alert (strcat "***" AppNam " Error***\nCan't change Division with Panels Open"))
								(setq	PanNam	nil)
								(exit)
							)
						)
					)
				)
				((= Div_ID 3)
					(if (/= Div "S_")
						(if (< (length PanLst) 1)
							(UpdDivINI "S_")
							(progn
								(alert (strcat "***" AppNam " Error***\nCan't change Division with Panels Open"))
								(setq	PanNam	nil)
								(exit)
							)
						)
					)
				)
				((= Div_ID 4)
					(if (/= Div "W_")
						(if (< (length PanLst) 1)
							(UpdDivINI "W_")
							(progn
								(alert (strcat "***" AppNam " Error***\nCan't change Division with Panels Open"))
								(setq	PanNam	nil)
								(exit)
							)
						)
					)
				)
				((= Div_ID 5)
					(if (/= Div "M_")
						(if (< (length PanLst) 1)
							(UpdDivINI "M_")
							(progn
								(alert (strcat "***" AppNam " Error***\nCan't change Division with Panels Open"))
								(setq	PanNam	nil)
								(exit)
							)
						)
					)
				)
				((= Div_ID 6)
					(if (/= Div "SE")
						(if (< (length PanLst) 1)
							(UpdDivINI "SE")
							(progn
								(alert (strcat "***" AppNam " Error***\nCan't change Division with Panels Open"))
								(setq	PanNam	nil)
								(exit)
							)
						)
					)
				)
		)
	)
	
	(if PanNam
		(GetPan PanNam)
	)
	(if PanNam
		(if (member PanNam PanLst)
			(progn
				(FndEEDev MyDev_ID)
				(if (/= Div "GA")
					(command "_.Zoom" "C" "" "1000")
					(command "_.Zoom" "C" "" "250")
				)
				(C:HdFl)
			)
		)
	)
	(if Bug (princ "\n GetDev exited"))
	(princ)
)

(defun GetPan ( pan / )						; Loads a single panel
	(if Bug (princ "\n GetPan entered"))
	(if (NOT pan)
		(progn
			(setq	pan	(getfiled "Panel Selection" _Path-Panel "DWG" 8))
			(if (not pan)
				(setq	pan	(getfiled "Shared Panel Selection" _Alt_Path-Panel "DWG" 8))
			)
			(if (not pan)
				(if MySubObj
					(setq	whap		(MySubObj)
							Bubba	(if (/= (nth 2 whap) Div)
										(UpdDivINI (nth 2 whap))
									)
							pan		(if (> (strlen (nth 4 whap)) 1) (strcat _AltSPath-Panel (nth 4 whap) ".Dwg") nil)
					)
					(setq	pan		(getfiled "Schematic Panel Selection" _AltSPath-Panel "DWG" 8))
				)
			)
			(if (not pan)
				(if MyURDObj
					(setq	whap		(MyURDObj)
							Bubba	(if (/= (nth 2 whap) Div)
										(UpdDivINI (nth 2 whap))
									)
							pan		(if (> (strlen (nth 4 whap)) 1) (strcat _AltSPath-Panel (nth 4 whap) ".Dwg") nil)
					)
					(setq	pan		(getfiled "URD Panel Selection" _AltSPath-Panel "DWG" 8))
				)
			)
			(if pan
				(setq	pan	(nth 2 (dos_splitpath pan)))
				(princ "\nOpen by Panel cancelled")
			)
		)
	)
	(if Bug 
		(progn
			(princ "\nPanel.Lsp!GetPan - pan = ") (prin1 pan) (princ "\n")
		)
	)
	(if (and pan (/= pan ""))
		(progn
			(setq	newlst	(list ))
			(setq	newlst	(cons pan newlst))
			(if newlst
				(LodPan)
			)
		)
	)
	(if PanLst
		(if (not SF)
			(SclFactor)
		)
	)
	(if Bug (princ "\n GetPan exited"))
	(princ)
)

(defun GetSubT ( pan /  )					; Loads a single panel for Substation Signal Line Diagram
	(if Bug (princ "\n GetSubT entered"))
	(if (NOT pan)
		(progn
			(if (not pan)
				(if MySubObj
					(progn
						(setq	whap		(OpenSubtest))			; Opens Sub Selection Dialog in ADDS.DLL
						(if (/= whap nil)
							(setq	Bubba	(if (/= (nth 2 whap) Div)
												(UpdDivINI (nth 2 whap))
											)
									pan		(if (> (strlen (nth 4 whap)) 1) (strcat _AltSPath-Panel (nth 4 whap) ".Dwg") nil)
							)
						)
					)
					(setq	pan		(getfiled "Schematic Panel Selection" _AltSPath-Panel "DWG" 8))
				)
			)
			(if pan
				(setq	pan	(nth 2 (dos_splitpath pan)))
				(princ "\nOpen by Panel cancelled")
			)
		)
	)
	(if (and pan (/= pan ""))
		(progn
			(setq	newlst	(list ))
			(setq	newlst	(cons pan newlst))
			(if newlst
				(progn
					(lodpan)
					(setq	fugdeFactor  	1.31234
							DwgType 		"SLD"
;							SMult		1.31234
							sff  250
							sf	(* sff 0.3048)
					
					)
				)
			)
		)
	)
	(if PanLst
		(if (not SF)
			(SclFactor)
		)
	)
	(if Bug (princ "\n GetSubT exited"))
	(princ)
)

(defun Get_URD ( pan / )					; Loads a single panel
	(if Bug (princ "\n Get_URD entered"))
	(if (NOT pan)
		(progn
			(if (not pan)
				(if MyURDObj
					(setq	whap		(MyURDObj)
							Bubba	(if (/= (nth 2 whap) Div)
										(UpdDivINI (nth 2 whap))
									)
							pan		(if (> (strlen (nth 4 whap)) 1) (strcat _AltSPath-Panel (nth 4 whap) ".Dwg") nil)
					)
					(setq	pan		(getfiled "URD Panel Selection" _AltSPath-Panel "DWG" 8))
				)
			)
			(if pan
				(setq	pan	(nth 2 (dos_splitpath pan)))
				(princ "\nOpen by Panel cancelled")
			)
		)
	)
	(if (and pan (/= pan ""))
		(progn
			(setq	newlst	(list ))
			(setq	newlst	(cons pan newlst))
			(if newlst
				(lodpan)
			)
		)
	)
	(if PanLst
		(if (not SF)
			(SclFactor)
		)
	)
	(if Bug (princ "\n Get_URD exited"))
	(princ)
)

(defun GetSw ( )
	(if Bug (princ "\nGetSw entered"))
	(setvar "LIMCHECK" 0)
	(setq	dlg	2)
	(if (setq Dcl_Pan (findfile (strcat _path-lisp "Adds.dcl")))
		(if (> (setq Dcl_Pan (load_dialog Dcl_Pan)) 0)
			(while (> dlg 1)
				(new_dialog "SrchName" Dcl_Pan)
				(set_tile "SrchInp" "")
				(action_tile "SrchInp" "(setq swnum $value)")
				(action_tile "ok_button" "(done_dialog 1)")
				(setq dlg (start_dialog))
				(unload_dialog Dcl_Pan)
			)
			(alert "\nUnable to open DCL file")
		)
		(alert "\nUnable to find DCL file")
	)
	(if (= dlg 1)
		(if (< (strlen swnum) 9)
			(setq	swnum	(strcase (PadChar swnum 9)))
			(if (> (strlen swnum) 9)
				(setq	swnum	(strcase (substr swnum 1 9)))
				(if (/= (strlen swnum) 9)
					(setq	swnum	nil)
					(setq	swnum	(strcase swnum))
				)
			)
		)
		(setq	swnum	nil
				Bubba	(princ "\nOpen by Switch cancelled")
		)
	)
	(if (and Bug swnum) (princ (strcat "\nSW Num: =>" swnum "<=")))
	(if swnum
		(progn 
			(if (null GetSwitchCorBySwID)
				(command "netload" "C:\\Div_Map\\Common\\Adds.dll")
			)
			; Get all Feeder extents data for current division
			(setq lstSwCors (GetSwitchCorBySwID MyUsrInfo Div swnum))
			(if lstSwCors
				(progn
					(setq	x 	(nth 1 lstSwCors)
							y	(nth 2 lstSwCors)
					)
					(getpan (BldFn (* (fix (/ x XPanel)) XPanel) (* (fix (/ y YPanel)) YPanel)))
					(if SFF
						(command "ZOOM" "C" (list x y) (* SFF 1.25))
						(progn
							(SetScale)
							(command "ZOOM" "C" (list x y) (* SFF 1.25))
						)
					)
				)
				(alert (strcat "***ADDS MESSAGE***\nSwitch " swnum " was not found. "))
			)
		)
	)
	(if Bug (princ "\ngetsw exited"))
	(princ)
)

(defun GetSW_Old ( /	swnum found ftable ln x y	; finds a switch and loads the panel
				Fn F1 InData SwNam SwEa SwNo SwFeed SwLst _Path-Get )
	(if Bug (princ "\nGetSw entered"))
	(setvar "LIMCHECK" 0)
	(setq	dlg	2)
	(if (setq Dcl_Pan (findfile (strcat _path-lisp "Adds.dcl")))
		(if (> (setq Dcl_Pan (load_dialog Dcl_Pan)) 0)
			(while (> dlg 1)
				(new_dialog "SrchName" Dcl_Pan)
				(set_tile "SrchInp" "")
				(action_tile "SrchInp" "(setq swnum $value)")
				(action_tile "ok_button" "(done_dialog 1)")
				(setq dlg (start_dialog))
				(unload_dialog Dcl_Pan)
			)
			(alert "\nUnable to open DCL file")
		)
		(alert "\nUnable to find DCL file")
	)
	(if (= dlg 1)
		(if (< (strlen swnum) 9)
			(setq	swnum	(strcase (PadChar swnum 9)))
			(if (> (strlen swnum) 9)
				(setq	swnum	(strcase (substr swnum 1 9)))
				(if (/= (strlen swnum) 9)
					(setq	swnum	nil)
					(setq	swnum	(strcase swnum))
				)
			)
		)
		(setq	swnum	nil
				Bubba	(princ "\nOpen by Switch cancelled")
		)
	)
	(if (and Bug swnum) (princ (strcat "\nSW Num: =>" swnum "<=")))
	(if swnum
		(if (setq found (bsearch swnum (strcat _PATH-Panel "ADDS_UP.SW") 1 9))
			(progn
				(setq	x	(atof (substr found 11 7))
						y	(atof (substr found 21 7))
				)
				(if (and Bug found) (princ (strcat "\nFound: " found)))
				(getpan (BldFn (* (fix (/ x XPanel)) XPanel) (* (fix (/ y YPanel)) YPanel)))
				(if SFF
					(command "ZOOM" "C" (list x y) (* SFF 1.25))
					(progn
						(SetScale)
						(command "ZOOM" "C" (list x y) (* SFF 1.25))
					)
				)
			)
			(alert (strcat "***ADDS MESSAGE***\nSwitch " swnum " was not found. "))
		)
	)
	(if Bug (princ "\ngetsw exited"))
	(princ)
)

(defun GetFil ( fn / pf pan )				; gets list of panels from a file and calls lodpan
	(if Bug (princ "\ngetfil entered"))
	(if (NOT fn)
		(setq	fn	(getstring "\n\nEnter filename containing panel set: {path\filename.ext} "))
	)
	(if (and fn (/= fn ""))
		(if (findfile fn)
			(progn
				(setq	newlst	(list)
						pf		(open fn "r")
				)
				(while (setq pan (read-line pf))
					(setq	newlst	(cons pan newlst))
				)
				(close pf)
				(if newlst
					(lodpan)
				)
			)
			(princ (strcat "\n***ADDS MESSAGE***  file containing panel list, " fn " was not found:  "))
		)
	)
	(if PanLst
		(if (not SF)
			(SclFactor)
		)
	)
	(if Bug (princ "\ngetfil exited"))
	(princ)
)

(defun GetWin ( winpt1 winpt2 /	llpt urpt		; builds PanLst & calls lodpan
							panx pany pt1x pt1y tmpt1y fn)
	(if Bug (princ "\ngetwin entered"))
	(setvar "LIMCHECK" 0)   ;--turn off limit-checking
	(if (NOT winpt1)
		(setq	winpt1	(getpoint "\n\nSelect the first point of active area:")
				winpt2	nil
		)
	)
	(if (NOT winpt2)
		(setq	winpt2	(getcorner winpt1 "\nSelect the second point of active area:"))
	)
	(if (and  winpt1  winpt2  (or (/= (car winpt1) (car winpt2)) (/= (cadr winpt1) (cadr winpt2))))
		(progn
			(setq	newlst	(list)
					llpt		(mapcar (quote min) winpt1 winpt2)
					urpt		(mapcar (quote max) winpt1 winpt2)
					pt1x		(fix (/ (car llpt) XPanel))
					pt1y		(fix (/ (cadr llpt) YPanel))
					pt2x		(fix (/ (car urpt) XPanel))
					pt2y		(fix (/ (cadr urpt) YPanel))
					panx		(+ 1 (- pt2x pt1x))
					pany		(+ 1 (- pt2y pt1y))
					pt1x		(* pt1x XPanel)
					pt1y		(* pt1y YPanel)
					pt2x		(* pt2x XPanel)
					pt2y		(* pt2y YPanel)
					tmpt1y	pt1y
			)
			(repeat	panx
					(repeat	pany
							(setq	fn		(BldFn pt1x pt1y)
									newlst	(cons fn newlst)
									pt1y		(+ pt1y YPanel)
							)
					)
					(setq	pt1x		(+ pt1x XPanel)
							pt1y		tmpt1y
					)
			)
			(if newlst
				(lodpan)
			)
		)
		(princ (strcat "\n***ADDS MESSAGE***  bad points for window. "))
	)
	(if PanLst
		(if (not SF)
			(SclFactor)
		)
	)
	(if Bug (princ "\ngetwin exited"))
	(princ)
)

(defun SetLim ( lst /	pan minx miny			; sets limits & create view "ALL" on panels
					maxx maxy )
	(if Bug (princ "\nPanel.Lsp!SetLim entered"))
	(setq	minx		999
			miny		9999
			maxx		0
			maxy		0
	)
	(foreach	pan
			lst
			(if (< (atoi (substr pan 1 3)) minx)
				(setq	minx	(atoi (substr pan 1 3)))
			)
			(if (< (atoi (substr pan 4)) miny)
				(setq	miny	(atoi (substr pan 4)))
			)
			(if (> (atoi (substr pan 1 3)) maxx)
				(setq	maxx	(atoi (substr pan 1 3)))
			)
			(if (> (atoi (substr pan 4)) maxy)
				(setq	maxy	(atoi (substr pan 4)))
			)
	)
	(setq	minx	(- (* minx 1000.0) 200.0)
			miny	(- (* miny 1000.0) 200.0)
			maxx	(+ (+ (* maxx 1000.0) XPanel) 200.0)
			maxy	(+ (+ (* maxy 1000.0) YPanel) 200.0)
	)
	(command "_.VIEW" "W" "ALL"
			 (list minx miny)
			 (list maxx maxy)
			 "_.ZOOM" "W" 
			 (list minx miny)
			 (list maxx maxy)
;			 "_.REGENALL"
	)
	(if Bug (princ "\nPanel.Lsp!SetLim exit"))
	(princ)
)

(defun Bld_SL ( /	ssAttD cntAttD EntNam EntLst	; Sets 'ScList', 'AttNamP', & 'DlgFlag'
				PanNam ssAttS TScale )
	(if Bug (princ "\nBld_SL entered"))
	(setq	ScList	(list))
	(if (setq ssAttD (ssget "X" (list (cons 0 "ATTDEF") (cons 8 "----SC----"))))
		(progn
			(setq	cntAttD	0)
			(while (setq EntNam (ssname ssAttD cntAttD))
				(setq	EntLst	(entget EntNam))
				(if (= (setq PanNam (cdr (assoc 2 EntLst))) "SAVING") ;--The "SAVING" attribute contains the name of the base quad
					(setq	AttNamP	(cdr (assoc 1 EntLst))
							ssAttS	(ssadd EntNam)
					)
					(if (setq TScale (cdr (assoc 1 EntLst)))
						(setq	ScList	(append (list PanNam TScale) ScList))
					)
				)
				(setq	cntAttD	(+ 1 cntAttD))
			)
			(setq	ssAttD	nil)
		)
	)
	(if ssAttS  ;--If we found a "SAVING" attribute, erase it now
		(progn
			(command "_.ERASE" ssAttS "")
			(if (= AttNamP "")
				(setq	AttNamP	nil)
				(setq	DlgFlag	"T")     ;else {Quad sheet exist.}
			)
			(setq	ssAttS	nil)
		)
	)
	(if Bug (princ "\nBld_SL exited"))
	(princ)
)

(defun SetSc ( /	NewSff CntLst )			; Set global scale SF in meters & SFF in feet
	(if Bug (princ "\nSetSc entered"))
	(princ "\nPanels and Scales in Drawing Database:")
	(setq	CntLst	0)
	(if ScList
		(while (nth CntLst ScList)
			(princ (strcat "\n" (nth CntLst ScList) "\t" (nth (1+ CntLst) ScList)))
			(setq	CntLst	(+ CntLst 2))
		)
		(setq	CntLst	1)
	)
	(if (= CntLst 1)
		(princ "\n*No* panels are active...[ScList is empty].")
	)
	(setq	NewSff	nil)
	(while (NOT NewSff)
		(setq	NewSff	(strcase (getstring "\nSelect the global scale for TEXT and SYMBOLs: ")))
		(if (= NewSff "BYPAN")
			(setq	NewSff	(getps nil))
		)
	)
	(setq	Sff	(atoi NewSff)
			Sf	(* Sff 0.3048)
	)
	(if Bug (princ "\nSetSc exited"))
	(princ)
)

(defun SetScale ( /	TstSF )				; calls SclFactor
	(setq	TstSF	(SclFactor))
	(if TstSF
		(progn
			(setvar "LTScale" SFF)
			(setvar "THICKNESS" SFF)
			SF
		)
	)
	(princ)
)

(defun GetPS ( pt /	prmpt ptx pty pan TScale); Reports the scale of a panel
	(if Bug (princ "GetPs entered"))
	(setq	TScale	nil)
	(if (not ScList)
		(Bld_SL)
	)
	(if (not XPanel)
		(if (/= Div  "AL")
			(setq	XPanel	6000.0)
			(setq	XPanel	60000.0)
		)
	)
	(if (not YPanel)
		(if (/=Div "AL")
			(setq	YPanel	4000.0)
			(setq	YPanel	40000.0)
		)
	)
	(if (not pt)
		(progn
			(initget 1)
			(setq	pt		(getpoint "\n\nSelect a panel you wish the scale of: \n")
					prmpt	T
			)
		)
		(setq	prmpt	nil)
	)
	(if (and pt ScList)
		(progn
			(setq	ptx		(* (fix (/ (car pt) XPanel)) XPanel)
					pty		(* (fix (/ (cadr pt) YPanel)) YPanel)
					pan		(BldFn ptx pty)
			)
			(if prmpt
				(if (member pan ScList)
					(if (setq TScale (cadr (member pan ScList)))
						(alert (strcat "The scale for panel " pan " is " TScale " feet/inch"))
						(alert (strcat "The scale for panel " pan " was not found in <ScList>."))
					)
					(if pan
						(alert (strcat "***" AppNam " Error***\nSelected point {" pan "} must be within panel boundaries"))
						(alert (strcat "***" AppNam " Error***\nSelected point must be within panel boundaries"))
					)
				)
				(if (member pan ScList)
					(setq	TScale	(cadr (member pan ScList)))
					(setq	TScale	"0")
				)
			)
		)
		(progn
			(alert "The scale for panel was not found.  Missing panel scaling information call the Ed's for help.")
			(setq	TScale	"1000")
		)
	)
	(if Bug (princ "GetPs exited"))
	TScale
)

(defun SclFactor ( /	md1 md2 dcl_id )		; Graphically requests scale to apply
	(setq	md1 (getvar "cmdecho")
			md2 (getvar "clayer" )
	)
	(if (> (setq dcl_id (load_dialog (strcat _PATH-LISP "Adds.dcl"))) 0)
		(progn
			(new_dialog "sclfactor" dcl_id)
			(if sf
				(cond
					((= sff 250) (set_tile "scl_250_radio" "1"))
					((= sff 500) (set_tile "scl_500_radio" "1"))
					((= sff 1000) (set_tile "scl_1000_radio" "1"))
					((= sff 2000) (set_tile "scl_2000_radio" "1"))
					(T (progn (set_tile "scl_1000_radio" "1") (setq sff 1000)))
				)
				(if (/= Div "GA")
					(progn
						(set_tile "scl_1000_radio" "1")
						(setq	sff	1000
								sf	(* sff 0.3048)
						)
					)
					(progn
						(set_tile "scl_500_radio" "1")
						(setq	sff	500
								sf	(* sff 0.3048)
						)
					)
				)
			)
			(if (not PanLst)
				(mode_tile "scl_BYPAN_radio" 1)
				(mode_tile "scl_BYPAN_radio" 0)
			)
			(action_tile "scale_radio" "(setq str $value)")
			(setq dlg (start_dialog))
			(unload_dialog dcl_id)
			(if (= dlg 1)
				(progn
					(cond
						((eq str "scl_250_radio") (setq sff 250))
						((eq str "scl_500_radio") (setq sff 500))
						((eq str "scl_1000_radio") (setq sff 1000))
						((eq str "scl_2000_radio") (setq sff 2000))
						((eq str "scl_BYPAN_radio") (setq sff (atoi (getps nil))))
					)
					(setq sf (* sff 0.3048))
				)
				(princ "\nSet Scale cancelled")
			)
		)
		(alert "ERROR: Opening Dialogue Box File..!")
	)
	(setvar "THICKNESS" (float sff))
	(setvar "clayer" md2)
	sf
)

(defun CaliBr ( /	calpt1 calpt2 )			; prompts user for screen points, then calibrates
   (if Bug (princ "\ncalibr entered"))
   (if (/= (strcase Mouse) "YES")
     (progn
       (command "BLIPMODE" "ON"
		"CMDECHO" 1)
       (command "TABLET" "CAL" pause pause pause pause "")
       (command "TABLET" "OFF")
       (command "BLIPMODE" "OFF"
		"CMDECHO" 0)
     )
   )
   (if Bug (princ "\ncalibr exited"))
)

(defun CalNam ( dir / )						; finds name of adjacent panel based on the dir
	(if Bug (princ "\ncalnam entered"))
	(cond
		((= dir 1)
			(setq	fn	(BldFn ptx (+ pty YPanel))
					pty	(+ pty YPanel)
			)
		)
		((= dir 2)
			(setq	fn	(BldFn (+ ptx XPanel) (+ pty YPanel))
					ptx	(+ ptx XPanel)
					pty	(+ pty YPanel)
			)
		)
		((= dir 3)
			(setq	fn	(BldFn (+ ptx XPanel) pty)
					ptx	(+ ptx XPanel)
			)
		)
		((= dir 4)
			(setq	fn	(BldFn (+ ptx XPanel) (- pty YPanel))
					ptx	(+ ptx XPanel)
					pty	(- pty YPanel)
			)
		)
		((= dir 5)
			(setq	fn	(BldFn ptx (- pty YPanel))
					pty	(- pty YPanel)
			)
		)
		((= dir 6)
			(setq	fn	(BldFn (- ptx XPanel) (- pty YPanel))
					ptx	(- ptx XPanel)
					pty	(- pty YPanel)
			)
		)
		((= dir 7)
			(setq	fn	(BldFn (- ptx XPanel) pty)
					ptx	(- ptx XPanel)
			)
		)
		((= dir 8)
			(setq	fn	(BldFn (- ptx XPanel) (+ pty YPanel))
					ptx	(- ptx XPanel)
					pty	(+ pty YPanel)
			)
		)
	)
	(if Bug (princ "\nCalNam exited"))
	fn	;--force function to return value of fn
)

(defun PopUp ( / )							; display icon menu to choose adjacent panel
	(if Bug (princ "\npopup entered"))
	(command "REGENAUTO" "OFF")
	(setq	dir	(getstring "\nSelect an adjacent sheet to add..."))
	(if (/= dir "0")
		(progn
			(setq	dir	(atoi dir)
					fn	(calnam dir)
			)
			(getpan fn)
		)
	)
	(if Bug (princ "\npopup exited"))
)

(defun SavBlk ( /	pancnt temp CurPan minx miny	; save each panel in the PanLst into a separate file
				maxx maxy sset Ocmd ssAddLst )
	(if Bug (princ "\nSavBlk entered"))
	(setq	sset		(ssget "X" (list (cons 6 "CONTINUOUS")))
			Ocmd		(getvar "CMDDIA")
	)
	(if sset
		(progn
			(command "CHANGE" sset "" "P" "LT" "BYLAYER" "")
			(setq	sset	nil
					pancnt	0
			)
		)
		(setq	sset	nil
				pancnt	0
		)
	)
	(setvar "CMDECHO" 0)
	(setvar "CMDDIA" 0)
	(if PanLst
		(foreach	CurPan
					PanLst
					(setq	ssAddLst	(ssadd))
					(command "VIEW" "R" CurPan)
					(setq	minx	(* (atof (substr CurPan 1 3)) 1000.0)   ;---Calculate lower left
							miny	(* (atof (substr CurPan 4)) 1000.0)
							maxx	(+ minx XPanel)                         ; and upper right coords. for panel
							maxy	(+ miny YPanel)
					)
					(savset (list minx miny 0.0) (list maxx maxy 0.0))
					(princ CurPan)
					(princ minx)
					(princ "\n ")
					(princ miny)
					(princ "\n ")
					(princ maxx)
					(princ "\n ")
					(princ maxy)
					(if panset
						(princ (strcat "\npanset: " (itoa (sslength panset))))
						(princ "\npanset is empty")
	      			)
					(if ssAddLst
						(princ (strcat "\nssAddLst" (itoa (sslength ssAddLst))))
						(princ "\nssAddLst is empty")
					)
					(princ "\n ")
					(if panset
						(command "WBLOCK" (strcat _PATH-PANEL CurPan) "" "0,0" panset ssAddLst "" "N")
						(command "WBLOCK" (strcat _PATH-PANEL CurPan) "" "0,0" ssAddLst "" "N")
					)
		)
	)
	(setvar "CMDDIA" Ocmd)
	(if Bug (princ "\nSavBlk exited"))
)

(defun SavSet ( ll ur /	Cross ul lr ill		; Builds crossing sets to capture symbols
					iur iul ilr )
;  Function: a) Build Crossing sets to capture symbols or text that Cross
;               the panel boundaries, then call chkent.
;            b) Build window set for resetw.
;	Author:   JVG-GRS
;	Date:     Feb. 1989
	(if Bug (princ "\nSavSet entered"))
	(if Bug
		(progn
			(princ (strcat "\nLL = " (rtos (nth 0 ll) 2 4) "," (rtos (nth 1 ll) 2 4)))
			(princ (strcat "\nUR = " (rtos (nth 0 ur) 2 4) "," (rtos (nth 1 ur) 2 4)))
		)
	)
	(setq pancnt (1+ pancnt))
	(princ (strcat "\nSAVSET - Panel # " (itoa pancnt)))
;	Windows a box 152 units inside panel, and stores entities in panset.
;	Gets a Crossing polygon from panel edge to 152 unit inside of panel.  This is
;	needed to capture objects Crossing panel that would not be grabbed by windowing.
;	152 units is the size of a switch at 2000' scale.
	(setq	ul	(list (car ll) (cadr ur) 0.0)
			lr	(list (car ur) (cadr ll) 0.0)
			ill	(list (+ (car ll) 152.0) (+ (cadr ll) 152.0) 0.0)
			iur	(list (- (car ur) 152.0) (- (cadr ur) 152.0) 0.0)
			iul	(list (+ (car ul) 152.0) (- (cadr ul) 152.0) 0.0)
			ilr	(list (- (car lr) 152.0) (+ (cadr lr) 152.0) 0.0)
	)
	(setq panset (ssget "W" ill iur))      ;RER get interior window
	(if arclst (ArcSav))  ;---if arcs were found in panel during BREAK, add them
	(if (setq Cross (ssget "C" ll ilr)) (chkent))
	(if (setq Cross (ssget "C" lr iur)) (chkent))
	(if (setq Cross (ssget "C" ur iul)) (chkent))
	(if (setq Cross (ssget "C" ul ill)) (chkent))
;	(if (or panset ssAddLst)
;		(procss)
;	)
	(if Bug (princ "\nSavSet exited"))
)

(defun ArcSav ( /	count )					; Checks the arclst for entities
; Function: This routine checks the arclst for entities in the current panel
;           and adds any found to the panset.
; Author:   GRS-JVG
; Date:     2/89
	(if Bug (princ "\nArcSav entered"))
	(foreach arcdat
			 arclst
			 (if (= curpan (car arcdat))
			 	(ssadd (cdr arcdat) panset)
			 )
	)
	(if Bug (princ "\nArcSav exited"))
)

(defun ChkEnt ( /	count ent ZeroType entlst	; Tests non-pline entities for addition to ss
				ipt width )
;  Function: check non-pline entities to determine if they should be added
;            to the selection set for the current panel
;            Reset width of plines that were set to zero earlier
;  Author:   David Cole
;  Date:     October 26, 1988
;  Rev.10/92 Calls GETWID(lname) to reset pline widths {was calling CIRWID}.
	(if Bug (princ "\nchkent entered"))
	(setq	llx	(- (car ll) 0.50)
			lly	(- (cadr ll) 0.50)
			urx	(+ (car ur) 0.50)
			ury	(+ (cadr ur) 0.50)
	)
	(setq	count	0)
	(while (setq ent (ssname Cross count))
		(setq	entlst	(entget ent)
				ZeroType	(cdr (assoc 0 entlst))
		)
		(if (= ZeroType "POLYLINE")
			(progn
				(setq	vtx1		(entnext ent)
						vtx1pt	(cdr (assoc 10 (entget vtx1)))
						vtx2		(entnext vtx1)
						vtx2pt	(cdr (assoc 10 (entget vtx2)))
				)
				(if (not (or	(> (car vtx1pt) urx)
							(> (car vtx2pt) urx)
							(< (car vtx1pt) llx)
							(< (car vtx2pt) llx)
							(> (cadr vtx1pt) ury)
							(> (cadr vtx2pt) ury)
							(< (cadr vtx1pt) lly)
							(< (cadr vtx2pt) lly)
						)
					)
					(progn
						(setq	width	(getwid (cdr (assoc 8 entlst))))
						(if (not (equal width 0.0 0.0001))
							(progn
								(if (not (assoc 39 entlst))
									(if SF
										(progn
											(setq	entlst	(append entlst (list (cons 39 SF))))
											(entmod entlst)
										)
										(progn
											(SclFactor)
											(setq	entlst	(append entlst (list (cons 39 SF))))
											(entmod entlst)
										)
									)
								)
								(if Bug	(princ	(strcat	"\nChkEnt Lay=" (cdr (assoc 8 entlst))
														"\nChkEnt 39="	(if (cdr (assoc 39 entlst))
																			(rtos (cdr (assoc 39 entlst)) 2 4)
																			"null"
																		)
														"\nChkEnt 40="	(if (cdr (assoc 40 entlst))
																			(rtos (cdr (assoc 40 entlst)) 2 4)
																			"null"
																		)
														"\nChkEnt 41="	(if (cdr (assoc 41 entlst))
																			(rtos (cdr (assoc 41 entlst)) 2 4)
																			"null"
																		)
												)
										)
								)
								(setq	entlst	(subst	(cons 40 (* width (cdr (assoc 39 entlst)) 0.3048))
														(assoc 40 entlst)
														entlst
												)
								)
								(setq	entlst	(subst	(cons 41 (* width (cdr (assoc 39 entlst)) 0.3048))
														(assoc 41 entlst)
														entlst
												)
								)
								(entmod entlst)
							)
						)
						(ssadd ent ssAddLst)                 ;   to 'ssAddLst'
					)
				)
			)	;else NOT polyline
			(progn
				(if	(and	(/= (cdr (assoc 72 entlst)) 0)
	            			(or	(= ZeroType "TEXT")
								(= ZeroType "ATTDEF")
							)
					)
					(setq	ipt	(cdr (assoc 11 entlst)))      ;   then use alignment pt
					(setq	ipt	(cdr (assoc 10 entlst)))      ;   else use insert pt
				)
				(if	(not	(or	(> (car ipt)  urx)    ;---if ipt is in current
								(> (cadr ipt) ury)    ;   panel,
								(< (car ipt)  llx)
								(< (cadr ipt) lly)
							)
					)
					(ssadd ent ssAddLst)                    ; then add entity to 'ssAddLst'
				)
			)
		)
		(setq	count	(1+ count))
	)
	(if Bug (princ "\nchkent exited"))
)

(defun ProcSS ( /	count sllist ent entlst		; This routine updates the panel.SUB files
				lname sublay fn )
; Comment:  This routine updates the panel.SUB files
; Author:   grs jvg
; Date:     3/89
   (if Bug (princ "\nprocss entered"))
   (setq count 0
         sllist nil)
   (if panset
     (while (setq ent (ssname panset count))
       ;---Add sublay (sub, feeder & kv) to sllist if not already there
       (setq entlst (entget ent))
       (if (= (cdr (assoc 0 entlst)) "POLYLINE")
         (progn
           (setq lname (cdr (assoc 8 entlst)))
           (if (and (/= (substr lname 1 2) "--") (/= (substr lname 1 1) "0"))
             (progn
               (setq sublay (strcat (substr lname 1 3) (substr lname 9 2)))
               (if (not (member sublay sllist))
                 (setq sllist (cons sublay sllist)))
             )
           )
         )
       )
       (setq count (+ 1 count))
     )
   )
   (setq count 0)
   (if ssAddLst
     (while (setq ent (ssname ssAddLst count))
       ;---Add sublay (sub, feeder & kv) to sllist if not already there
       (setq entlst (entget ent))
       (if (= (cdr (assoc 0 entlst)) "POLYLINE")
         (progn
           (setq lname (cdr (assoc 8 entlst)))
           (if (and (/= (substr lname 1 2) "--") (/= (substr lname 1 1) "0"))
             (progn
               (setq sublay (strcat (substr lname 1 3) (substr lname 9 2)))
               (if (not (member sublay sllist))
                 (setq sllist (cons sublay sllist)))
             )
           )
         )
       )
       (setq count (+ 1 count))
     )
   )
   ;---Build the panel.SUB file containing info. on each sub in the panel
   (if sllist
     (if (setq fn (open (strcat _PATH-SS curpan ".SUB") "w"))
        (progn
           (setq count 0)
           (while (< count (length sllist))
              (write-line (nth count sllist) fn)
              (setq count (1+ count))
           )
           (setq fn (close fn))
        )
     ;else
        (progn
           (princ (strcat "***" AppNam " Error*** Unable to open <panel>.SUB--Call Helpdesk! \n"))
           (read-line)
        )
     )
   )
   ;---Build the list of subs in the panel
   (setq subs nil)
   (foreach substa sllist
      (setq substa (substr substa 1 2))
      (if (not (member substa subs))
         (setq subs (cons substa subs)))
   )
   (if Bug (princ "\nprocss exited"))
)

(defun AddPan ( /	base baspck )				; Add adjacent panel to PanLst
;  Function: Allow user to add an adjacent panel to an existing panel in a
;              drawing session.  If multiple panels already loaded, request
;              user to select a base panel.
;  Author:   David Cole
;  Date:     November 1988
;  Modified: JVG, GRS
	(if Bug (print "AddPan entered"))
	(if (= (length PanLst) 1)
		(setq	base	(car PanLst)
				ptx	(* 1000.0 (atoi (substr base 1 3)))
				pty	(* 1000.0 (atoi (substr base 4)))
		)
		(progn
			(setq	baspck	(getpoint "Select the base panel: "))
			(if baspck
				(progn
					(setq	ptx		(fix (/ (car baspck) XPanel))
							pty		(fix (/ (cadr baspck) YPanel))
							ptx		(* ptx XPanel)
							pty		(* pty YPanel)
							base	(BldFn ptx pty)
					)
					(if (not (member base PanLst))
						(progn
							(setq	base	nil)
							(princ (strcat "***" AppNam " Error*** Choose a point within a panel \n"))
						)
					)
				)
				(princ (strcat "***" AppNam " Error*** No point chosen \n"))
			)
		)
	)
	(if base
		(popup) ;--display the icon "compass" menu
	)
	(if PanLst
		(if (not SF)
			(SclFactor)
		)
	)
	(if Bug (print "AddPan exited"))
)

(defun Brk ( /	kount curpan minx miny		; Breaks drawings into panels
				maxx maxy )
; Function: Main routine for breaking a drawing into panels and saving each
;     area into the proper panel file. Each panel file is named according
;     to the coordinates of the lower left corner of that panel in the
;     form XXXYYYY.DWG.
; Author:   David Cole
; Date:     January 1989
	(if Bug (princ "\nBrk entered"))
	(foreach curpan
			 PanLst
			 (setq	minx (* 1000 (atof (substr curpan 1 3)))
			 		miny (* 1000 (atof (substr curpan 4)))
			 		maxx (+ minx XPanel)
			 		maxy (+ miny YPanel)
			 )
			 (Brkset)
	)
	(if Bug (princ "\nBrk exited"))
)

(defun PSet ( /	panel Cross lx ly rx uy		; Builds crossing sets for PWidth
				count )
; Function:  Build Crossing sets for use by PWidth
;            "Crossing" window is 2 units inside panel boundary
	(if Bug (princ "\nPSet entered"))
	(foreach panel PanLst
		(setq	lx	(+ 2.0 (atof (strcat (substr panel 1 3) "000")))
				ly	(+ 2.0 (atof (strcat (substr panel 4 4) "000")))
				rx	(+ (- XPanel 4.0) lx)
				uy	(+ (- YPanel 4.0) ly)
		)
		(if (setq Cross (ssget "C" (list lx ly 0.0) (list rx ly 0.0))) (PWidth 0))
		(if (setq Cross (ssget "C" (list rx ly 0.0) (list rx uy 0.0))) (PWidth 0))
		(if (setq Cross (ssget "C" (list lx uy 0.0) (list rx uy 0.0))) (PWidth 0))
		(if (setq Cross (ssget "C" (list lx ly 0.0) (list lx uy 0.0))) (PWidth 0))
	)
	(princ "\nleaving PSet")
	(if Bug (princ "\nPSet exited"))
)

(defun PWidth ( width /	Cnt entnam entlst )		; Updates Polyline Width
; Function: This routine changes the width of all plines in set 'Cross'
;           to the width that is passed as an argument.
	(if Bug (princ "\nPWidth entered"))
	(setq	Cnt	0)
	(if Cross
		(progn
			(while (setq entnam (ssname Cross Cnt))
				(setq	entlst	(entget entnam))
				(if (= (cdr (assoc 0 entlst)) "POLYLINE")
					(progn
						(setq	entlst	(subst (cons 40 width) (assoc 40 entlst) entlst))
						(setq	entlst	(subst (cons 41 width) (assoc 41 entlst) entlst))
						(entmod entlst)
					)
				)
				(setq	Cnt	(1+ Cnt))
			)
			(command "CHANGE" Cross "" "P" "LT" "CONTINUOUS" "")	;---Required to eliminate problems with dashed lines.
		)
	)
	(if Bug (princ "\nPWidth exited"))
)

(defun Brkset ( / Cross ccount c-ent c-lst )	; Builds Crossings sets for breaking
; Function: This program builds the Crossing selection set for breaking.
; Author:   David Cole and Jim Holton
; Date:     11/07/88
; Rev Date: JVG-GRS (2/89)
	(if Bug (princ "\nBrkset entered"))
	(princ "\nentering BrkSET")
	;--- Build a view of each panel as it's processed.
	(command "VIEW" "W" curpan	(list (- minx 10) (- miny 10) 0.0)
							(list (+ maxx 10) (+ maxy 10) 0.0)
	)
	(command "VIEW" "R" curpan)
	;---To avoid problems with (ssget "P"). Makes sure it gets something
	;   (scale) from current panel if the SELECT window doesn't grab anything
	(command "SELECT" (list (+ minx 10) (+ miny 10) 0.0) "")
	;--- Calculate points 2 units inside the panel boundary to avoid including
	;     plines in other panels that touch the boundaries.
	(command "SELECT"	"C"	(list (+ minx 2) (+ miny 2) 0.0)
						(list (- maxx 2) (- maxy 2) 0.0)
						"R" "W"
						(list minx miny 0.0) (list maxx maxy 0.0)
						""
	)
	(setq	Cross	(ssget "P")
			ccount	0
	)
	(while (setq c-ent (ssname Cross ccount))
		(setq	c-lst	(entget c-ent))
		(if (= (cdr (assoc 0 c-lst)) "POLYLINE")
			(poly)
		)
		(setq	ccount	(1+ ccount))
	)
)

(defun Poly ( /	Brksel pt1x pt1y pt1typ		; Processes PLines for boundary crossing
				pt-cnt )
; Function: This program processes a polyline and checks each
;           sub entity for a boundary Crossing or an arc.
; Author:   David Cole and Jim Holton
; Date:     10/03/88
; Rev Date: GRS-JVG (2/89)
	(if Bug (princ "\npoly entered"))
	(setq	Brksel	c-ent) ;--save PLINE hdr for use in Brk-pt
	(setq	c-ent	(entnext c-ent))
	(set-pt)
	(setq	c-ent	(entnext c-ent))
	(setq	c-lst	(entget c-ent))
	(while (/= (cdr (assoc 0 c-lst)) "SEQEND")
		(setq	pt1x	pt2x
				pt1y	pt2y
				pt1typ	pt2typ
				pt2x	(cadr (assoc 10 c-lst))
				pt2y	(caddr (assoc 10 c-lst))
				pt2typ	(cdr (assoc 42 c-lst))   ;---non-nil indicates an ARC
				pt-cnt	(+ pt-cnt 1)
		)
		(if (= pt1typ 0)
			(x-find)                       ;---see if segment intersects panel bndry
			(ArcBrk)
		)
		(setq	c-ent	(entnext c-ent))
		(setq	c-lst	(entget c-ent))
	)
)

(defun Set-Pt ( / )						; sets variables for first vertex of pline
; Function: sets variables for first vertex of pline
; Author:   David Cole
; Date:     1/04/88
	(if Bug (princ "\nset-pt entered"))
	(setq	pt-cnt	0
			c-lst	(entget c-ent)
	)
	(setq	pt2x	(cadr (assoc 10 c-lst))
			pt2y	(caddr (assoc 10 c-lst))
			pt2typ	(cdr (assoc 42 c-lst))   ;---non-nil indicates an ARC
			pt-cnt	(+ pt-cnt 1)
	)
)

(defun X-Find ( /	int-pt intpt2 )			; Tests if pline segment intersects panel boundary
; Function: Determines if pline segment intersects panel boundary.
; Uses Global: minx, miny, maxx, maxy, pt1x, pt1y, pt2x, pt2y
; Author:   David Cole and Jim Holton
; Date:     11/03/88
; Revised:  7/13/89 (JVG-GRS) to look for ALL intersections in a pline segment
;           and sort them before calling Brk-pt
	(if Bug (princ "\nx-find entered"))
	(setq	int-pt	(inters	(list pt1x pt1y 0.0) (list pt2x pt2y 0.0)  ;---top boundary
							(list minx maxy 0.0) (list maxx maxy 0.0) 1)
	)
	(if int-pt
		(setq	intpt2	(inters	(list pt1x pt1y 0.0) (list pt2x pt2y 0.0)  ;---bottom boundary
								(list minx miny 0.0) (list maxx miny 0.0) 1)
		)
		(setq	int-pt	(inters	(list pt1x pt1y 0.0) (list pt2x pt2y 0.0)
								(list minx miny 0.0) (list maxx miny 0.0) 1)
		)
	)
	(if (null intpt2)
		(if int-pt
			(setq	intpt2	(inters	(list pt1x pt1y 0.0) (list pt2x pt2y 0.0)  ;---left boundary
									(list minx miny 0.0) (list minx maxy 0.0) 1)
			)
			(setq	int-pt	(inters	(list pt1x pt1y 0.0) (list pt2x pt2y 0.0)
									(list minx miny 0.0) (list minx maxy 0.0) 1)
			)
		)
	)
	(if (null intpt2)
		(if int-pt
			(setq	intpt2	(inters	(list pt1x pt1y 0.0) (list pt2x pt2y 0.0)  ;---right boundary
									(list maxx miny 0.0) (list maxx maxy 0.0) 1)
			)
			(setq	int-pt	(inters	(list pt1x pt1y 0.0) (list pt2x pt2y 0.0)
									(list maxx miny 0.0) (list maxx maxy 0.0) 1)
			)
		)
	)
	(if (and int-pt intpt2)
		(sortpt)
	)
	(if int-pt (Brk-pt))
)

(defun ArcBrk ( /	oldent )					; Tests which panel should contain arc segment
; Function: Determines which panel should contain arc segment
   (if Bug (princ "\nArcBrk entered"))
;---If point1 is in the panel
   (if (and (>= pt1x (- minx 0.0001)) (<= pt1x (+ maxx 0.0001))
            (>= pt1y (- miny 0.0001)) (<= pt1y (+ maxy 0.0001)))
;---  If point2 is in the panel
      (if (and (>= pt2x (- minx 0.0001)) (<= pt2x (+ maxx 0.0001))
                (>= pt2y (- miny 0.0001)) (<= pt2y (+ maxy 0.0001)))
         (setq arclst (cons (cons curpan Brksel) arclst))
      ;else   if point2 is not in the panel
         (if (cdr (assoc 10 (entget (entnext c-ent))))
            (progn
                (setq Brksel (cons Brksel (list (list pt2x pt2y 0.0))))
                (command "BREAK" Brksel (list pt2x pt2y 0.0))
                (command "SELECT" (list pt1x pt1y 0.0) "")
                (setq oldent (ssname (ssget "P") 0))
                (setq arclst (cons (cons curpan oldent) arclst))
                (setq oldent nil)
                (setq Brksel (entlast)) ;---Work with new pline created by BREAK
                (setq c-ent (entnext Brksel))
                (set-pt)
            )
         ;else
            (setq arclst (cons (cons curpan Brksel) arclst))
         )
      )
   )
   (setq oldent nil)
)

(defun Brk-pt ( / )						; Tests that vertex in not endpt then breaks
; Function: verifies that vertex is not an 'end point', then breaks
;           the pline at the intersection.  Resets entity variable to
;           point to the newly created pline.
; Author:   David Cole and Jim Holton
; Date:     10/03/88
; Rev Date: JVG-GRS (2/89)
   (if Bug (princ "\nBrk-pt entered"))
   (if (null (end-pt))
      (progn
         ;---build an 'entsel' type list (entity name and selection point)
         ;   to feed to BREAK (Brksel is the PLINE header saved in poly)
         (setq Brksel (cons Brksel (list int-pt)))
         (command "BREAK" Brksel int-pt)
         (setq Brksel (entlast))  ;---Work with new pline created by BREAK
         (setq c-ent (entnext (entlast)))
         (set-pt)
      )
   )
   (if Bug (princ "\nBrk-pt exited"))
)

(defun End-Pt ( / )						; Tests that vertex in not endpt
; Function: determine if the intersection point is an endpoint of pline
; Author:   David Cole
; Date:     December, 1988
; Rev Date:
   (if Bug (princ "\nend-pt entered/exited"))
   (if (and (or (= 2 pt-cnt) (= 1 pt-cnt))
          (or (nearnf (car int-pt) (cadr int-pt) pt1x pt1y)
              (nearnf (car int-pt) (cadr int-pt) pt2x pt2y)
          )
       )
       T
   ;else
      (if (null (cdr (assoc 10 (entget (entnext c-ent)))))
         (nearnf (car int-pt) (cadr int-pt) pt2x pt2y)
      )
   )
)

(defun NearNf ( pt1x pt1y pt2x pt2y / )		; Tests for 'Nearness' of points
; Function: determines if two sets of coordinates are near enough
;           to be considered equal
; Author:   David Cole
; Date:     December, 1988
;
;           NOTE: Used 0.01 rather than 0.001 originally used to correct
;                 problem with breaking polyline with vertex very close to
;                 panel boundary.  Accuracy of break limited by zoom level.
;
;  RER 9/9/93 Changed 0.01 to 0.1 after installing Acad12 because Mobile had
;             a problem with "At least one pt must be on the line for BREAK"
   (if Bug (princ "\nNearNf entered/exited"))
   (and (<= pt1x (+ pt2x 0.1)) (>= pt1x (- pt2x 0.1))
        (<= pt1y (+ pt2y 0.1)) (>= pt1y (- pt2y 0.1)))
)

(defun SortPt ( /	dis-pt dispt2 )			; Sorts points for 'Nearness'
; Function: sorts points of intersection when two occur for the same
;           line segment and sends the one closest to point 1 (beginning
;           of line segment) to Brk-pt.
	(if Bug (princ "\nSortPt entered"))
	(setq	dis-pt	(distance (list pt1x pt1y 0.0) int-pt)
			dispt2	(distance (list pt1x pt1y 0.0) intpt2)
	)
	(cond
		((< dis-pt 0.001)			;--if the 1st inters. pt. is ON boundary,
			(setq	int-pt	intpt2)	;  don't use it
		)
		((< dispt2 0.001))			;--if the 2nd inters. pt. is ON boundary,
									;  just be sure we don't get to next cond
		((> (abs dis-pt) (abs dispt2))
			(setq	int-pt	intpt2)
		)
	)
)

(defun StartEnd ( Act /	no_err scset ent		; Startup routine for the ADDS 'End' function
					entlst )
; Function:  Startup routine for the ADDS 'End' function
;            Determines which type of 'End' is needed based on number of panels.
	(setq	no_err	T)
	(cond
		((= Act 1)
			(if (= (length PanLst) 1)
				(SaveOne Act)
				(progn
					(panerr)    ;Sets no_err to nil if there is a problem.
					(if no_err
						(progn
							(setq	scset	nil)
							(DoBrk Act)
						)
					)
				)
			)
		)
		((= Act 2)
			(if (= (length PanLst) 1)
				(SaveOne Act)
				(progn
;					(panerr)    ;Sets no_err to nil if there is a problem.
					(if no_err
						(progn
							(setq	scset	nil)
							(DoBrk Act)
						)
					)
				)
			)
		)
	)
	(princ)
)

(defun PanErr ( / )						; routine to check entities
;     Function:  routine to check entities on scale layer vs. PanLst
	(if Bug (princ "\npanerr entered"))
	(if (setq scset (ssget "X" (list (cons 0 "ATTDEF") (cons 8 "----SC----"))))
		(progn
			(setq	count	0
					verify	(list)
			)
			;verify that every entry on the scale layer is contained in PanLst
			(while (setq ent (ssname scset count))
				(setq	entlst	(entget ent))
				(if (not (member (cdr (assoc 2 entlst)) PanLst))
					(progn
						(princ "\n Corrupted panel list. CALL HELP DESK IMMEDIATELY!!")
						(princ (strcat "\n" (cdr (assoc 2 entlst))))
						(setq no_err nil)
					)
				)
				(setq	count	(1+ count)
						verify	(cons (cdr (assoc 2 entlst)) verify)
				)
			)
			;verify that each member of PanLst has corresponding entry
			;on ----SC---- layer
			(foreach pan PanLst
				(if (not (member pan verify))
					(progn
						(setq	no_err	nil)
						(princ (strcat "\n Corrupted scale layer. (" pan ")  CALL HELP DESK IMMEDIATELY!! "))
					)
				)
			)
			(setq verify (list))
			;check for duplicates in the PanLst
			(foreach pan PanLst
				(if (not (member pan verify))
					(setq	verify	(cons pan verify))
					(progn
						(princ (strcat "\n " pan " duplicated in panel list.  CALL HELP DESK IMMEDIATELY!! \n"))
						(setq	no_err	nil)
					)
				)
			)
		)
		(progn
			(princ "\n\nCorrupted panel-no scale. CALL HELP DESK IMMEDIATELY!!")
			(princ (strcat "\n" (cdr (assoc 2 entlst))))
			(setq	no_err	nil)
		)
	)
	(if Bug (princ "\npanerr exited"))
)

(defun SavCol ( / )						; routine to save color definitions
;     Function:  routine to save color definitions
	(if Bug (princ "\nSavCol entered"))
	(if (and no_err colors)
		(progn
			(setq	oldcol	()
					filelen	0
			)
			(if (setq filen (open (strcat _PATH-SS "colors.dat") "r"))
				(progn
					(while (setq linein (read-line filen))
						(setq filelen (1+ filelen))
					)
					(close filen)
			    	)
			)
			(setq	count	0
					kount	0
					new		nil
					Lngth	(length colors)
					sbfdr	nil
					fileout	(open (strcat _PATH-SS "color2.dat") "w")
			)
			(while (< count Lngth)
				(setq	sbfdr	(car (nth count colors))
						clr		(cdr (nth count colors))
				)
				(setq	count	(1+ count)
						kv		"  "
						subnam	"Substation name not defined"
				)
				(if subnames
					(if (setq tmp (cdr (assoc (substr sbfdr 1 2) subnames)))
						(setq	kv		(substr tmp 1 2)
								subnam	(substr tmp 3)
						)
					)
					(progn
						(princ "\nError processing SUB NAMES. Call HELPDESK!!!")
						(setq	no_err	nil)
					)
				)
				(if clr
					(if (< clr 10)
						(setq	sclr	(strcat " " (itoa clr)))
						(setq	sclr	(itoa clr))
					)
					(progn
						(setq	sclr		"ERR")
						(princ "\nError processing COLORS.DAT. Call HELPDESK!!!")
						(setq	no_err	nil)
					)
				)
				(if (/= (substr sbfdr 1 3) "NEW")
					(write-line (strcat sbfdr kv " " sclr " " subnam) fileout)
					(setq	new	T)
				)
				(if (not new)
					(setq	kount	(1+ kount))
				)
			)
			(close fileout)
			(if (= kount filelen)  ;length of list matches file length
				(progn
					(if (setq filen (open (strcat _PATH-SS "color2.dat") "r"))
						(progn
							(setq	fileout	(open (strcat _PATH-SS "colors.dat") "w"))
							(while (setq linein (read-line filen))
								(write-line linein fileout)
							)
							(close fileout)
							(close filen)
						)
					)
					(princ "\nfinished updating COLOR.DAT")
				)
				(progn
					(princ "\nError processing COLORS.DAT. Call HELPDESK!!!")
					(setq	no_err	nil)
					(princ "\n       file length - ")
					(princ filelen)
					(princ "\n  list length - ")
					(princ kount)
				)
			)
		)
	)
	(if Bug (princ "\nSavCol exited"))
)

(defun StatLn ( msg1 / )					; update the status line with message
; Function:  update the status line with message and elapsed time
   (grtext -1 msg1)
   (grtext -2 (strcat (rtos (* 24 60 (getvar "TDUSRTIMER")) 2 2) " minutes"))
   (princ msg1)
   (princ (strcat "  " (rtos (* 24 60 (getvar "TDUSRTIMER")) 2 2) " minutes\n"))
)

(defun SavLayUp ( / )						; Preps drawing layers for closing
	(command "REGENAUTO" "ON")
	(command "_.LAYER"
			 "T" "0"     ;t=thaw
			 "ON" "0"    ;turn layer on
			 "U" "0"     ;u=unlock
			 "S" "0" ""  ;s=set current
	)
	(princ "\nFinished Layer")
	(setq	delst1	(ssget "X" (list (cons 8 "----DLG---")))
			delst2	(ssget "X" (list (cons 8 "----GRD---")))
	)
	(if delst2
		(progn
			(if delst1
				(command "_.ERASE" delst1 delst2 "")
				(command "_.ERASE" delst2 "")
			)
			(command "VIEW" "R" "ALL")
		)
	)
	(princ)
)

(defun GetPanNam ( /	PanPnt PanX PanY Panel )	; Tests which Panel is intended
	(setq	PanPnt	(getpoint "\nPick point in Panel to be acted upon: "))
	(if PanPnt
		(setq	PanX		(fix (/ (car PanPnt) XPanel))
				PanY		(fix (/ (cadr PanPnt) YPanel))
				Panel	(strcat	(itoa (fix (/ (* XPanel PanX) 1000.0)))
								(itoa (fix (/ (* YPanel PanY) 1000.0)))
						)
		)
		(setq	Panel	nil)
	)
	Panel
)

(defun BlkPanTst ( Panel /	MinX MinY MaxX MaxY	; Finds blocks on boundary in Drawing
		Fuzz Pt1 Pt2 Pt3 Pt4 Pt5 Pt6 Pt7 Pt8 BlkStf BlkS2 Cnt )
	(setq	MinX		(* 1000.0 (atof (substr Panel 1 3)))
			MinY		(* 1000.0 (atof (substr Panel 4 4)))
			MaxX		(+ MinX XPanel)
			MaxY		(+ MinY YPanel)
			Fuzz		120.0	;(/ (getvar "LTScale") 10.0)
			Bubba	(if Bug (princ (strcat "\nFuzz=" (rtos Fuzz 2 4))))
			BlkStf	nil
			Blks2	nil
			Cnt		0
			Filter	(list	(cons -4 "<AND")
								(cons 0 "INSERT")
								(cons -4 "<NOT")
									(cons -4 "<OR")
										(cons 2 "GRID")
										(cons 2 "LOCK")
									(cons -4 "OR>")
								(cons -4 "NOT>")
							(cons -4 "AND>")
					)
			BothBlks	(CollectStrips MinX MinY MaxX MaxY Filter Fuzz)
			BlkStf	(nth 0 BothBlks)
			Blks2	(nth 1 BothBlks)
	)
	(if (and Bug Blks2) (princ (strcat "\nBlks2 has " (itoa (sslength Blks2)))))
	(if (and Bug BlkStf) (princ (strcat "\nBlkStf has " (itoa (sslength BlkStf)))))
	(if Blks2
		(while (< Cnt (sslength Blks2))
			(if BlkStf
				(if (not (ssmemb (ssname Blks2 Cnt) BlkStf))
					(setq	BlkStf	(ssadd (ssname Blks2 Cnt) BlkStf))
				)
				(setq	BlkStf	(ssadd (ssname Blks2 Cnt)))
			)
			(setq	Cnt	(1+ Cnt))
		)
	)
	(if (and Bug BlkStf) (princ (strcat "\nBlkStf ends with " (itoa (sslength BlkStf)))))
	BlkStf
)

(defun TxtPanTst ( Panel /	MinX MinY MaxX MaxY	; ; Finds Text on boundary in Drawing
						Fuzz Bubba TxtStf TxtS2
						Cnt Filter BothTxts )
	(setq	MinX		(* 1000.0 (atof (substr Panel 1 3)))
			MinY		(* 1000.0 (atof (substr Panel 4 4)))
			MaxX		(+ MinX XPanel)
			MaxY		(+ MinY YPanel)
			Fuzz		120.0	;(/ (getvar "LTScale") 10.0)
			Bubba	(if Bug (princ (strcat "\nFuzz=" (rtos Fuzz 2 4))))
			TxtStf	nil
			Txts2	nil
			Cnt		0
			Filter	(list	(cons 0 "TEXT"))
			BothTxts	(CollectStrips MinX MinY MaxX MaxY Filter Fuzz)
			TxtStf	(nth 0 BothTxts)
			Txts2	(nth 1 BothTxts)
	)
	(if (and Bug Txts2) (princ (strcat "\nTxts2 has " (itoa (sslength Txts2)))))
	(if (and Bug TxtStf) (princ (strcat "\nTxtStf has " (itoa (sslength TxtStf)))))
	(if Txts2
		(while (< Cnt (sslength Txts2))
			(if TxtStf
				(if (not (ssmemb (ssname Txts2 Cnt) TxtStf))
					(setq	TxtStf	(ssadd (ssname Txts2 Cnt) TxtStf))
				)
				(setq	TxtStf	(ssadd (ssname Txts2 Cnt)))
			)
			(setq	Cnt	(1+ Cnt))
		)
	)
	(if (and Bug TxtStf) (princ (strcat "\nTxtStf ends with " (itoa (sslength TxtStf)))))
	TxtStf
)

(defun OtherPanTst ( Panel /	MinX MinY MaxX MaxY	; Finds anything but blocks or Text on boundary
						Fuzz Bubba OtherStf OtherS2 
						Cnt Filter BothOther )
	(setq	MinX		(* 1000.0 (atof (substr Panel 1 3)))
			MinY		(* 1000.0 (atof (substr Panel 4 4)))
			MaxX		(+ MinX XPanel)
			MaxY		(+ MinY YPanel)
			Fuzz		120.0	;(/ (getvar "LTScale") 10.0)
			Bubba	(if Bug (princ (strcat "\nFuzz=" (rtos Fuzz 2 4))))
			OtherStf	nil
			Others2	nil
			Cnt		0
			Filter	(list	(cons -4 "<NOT")
								(cons -4 "<OR")
									(cons 0 "INSERT")
									(cons 0 "TEXT")
									(cons 0 "LINE")
									(cons 8 "DLG*")
								(cons -4 "OR>")
							(cons -4 "NOT>")
					)
			BothOther	(CollectStrips MinX MinY MaxX MaxY Filter Fuzz)
			OtherStf	(nth 0 BothOther)
			Others2	(nth 1 BothOther)
	)
	(if (and Bug Others2) (princ (strcat "\nOtherS2 has " (itoa (sslength Others2)))))
	(if (and Bug OtherStf) (princ (strcat "\nOtherStf has " (itoa (sslength OtherStf)))))
	(if OtherS2
		(while (< Cnt (sslength Others2))
			(if OtherStf
				(if (not (ssmemb (ssname Others2 Cnt) OtherStf))
					(setq	OtherStf	(ssadd (ssname Others2 Cnt) OtherStf))
				)
				(setq	OtherStf	(ssadd (ssname Others2 Cnt)))
			)
			(setq	Cnt	(1+ Cnt))
		)
	)
	(if (and Bug OtherStf) (princ (strcat "\nOtherStf ends with " (itoa (sslength OtherStf)))))
	OtherStf
)

(defun EdgePanTst ( Panel /	MinX MinY MaxX MaxY	; Finds anything but blocks or Text on boundary
						Fuzz Bubba EdgeStf EdgeS2 
						Cnt Filter BothEdge )
	(setq	MinX		(* 1000.0 (atof (substr Panel 1 3)))
			MinY		(* 1000.0 (atof (substr Panel 4 4)))
			MaxX		(+ MinX XPanel)
			MaxY		(+ MinY YPanel)
			Fuzz		120.0	;(/ (getvar "LTScale") 10.0)
			Bubba	(if Bug (princ (strcat "\nFuzz=" (rtos Fuzz 2 4))))
			EdgeStf	nil
			Edges2	nil
			Cnt		0
			Filter	(list	(cons -4 "<NOT")
									(cons 0 "TRACE")
							(cons -4 "NOT>")
					)
			BothEdge	(CollectStrips MinX MinY MaxX MaxY Filter Fuzz)
			EdgeStf	(nth 0 BothEdge)
			Edges2	(nth 1 BothEdge)
	)
	(if (and Bug Edges2) (princ (strcat "\nEdgeS2 has " (itoa (sslength Edges2)))))
	(if (and Bug EdgeStf) (princ (strcat "\nEdgeStf has " (itoa (sslength EdgeStf)))))
	(if EdgeS2
		(while (< Cnt (sslength Edges2))
			(if EdgeStf
				(if (not (ssmemb (ssname Edges2 Cnt) EdgeStf))
					(setq	EdgeStf	(ssadd (ssname Edges2 Cnt) EdgeStf))
				)
				(setq	EdgeStf	(ssadd (ssname Edges2 Cnt)))
			)
			(setq	Cnt	(1+ Cnt))
		)
	)
	(if (and Bug EdgeStf) (princ (strcat "\nEdgeStf ends with " (itoa (sslength EdgeStf)))))
	EdgeStf
)

(defun TstThLay ( /	FFlg Tmp cLay )		; Test and maybe Thaw Layers
	(setq	FFlg		nil
			Tmp		(tblnext "LAYER" T)
			cLay		(strcase (getvar "CLAYER"))
	)
	(if (equal cLay "0")
		(while (setq Tmp (tblnext "LAYER"))
			(if (and	(not FFlg)
					(or
						(< (cdr (assoc 62 Tmp)) 0)
						(/= (cdr (assoc 70 Tmp)) 0)
					)
			    )
				(progn
					(setq	FFlg		T)
					(if Bug (princ (strcat "\nThawing because:" (cdr (assoc 2 Tmp)) "is bad!")))
				)
				(if Bug (princ "."))
			)
		)
		(setq	FFlg		T)
	)
	(if FFlg
		(progn
			(command	"_.LAYER" "T" "*" "ON" "*" "U" "*" "S" "0" "")
			(if Bug (princ "\nThawing layers to preserve integrity..."))
		)
	)
	cLay
)

(defun BrkPanClean ( Panel /	MinX MinY MaxX MaxY	; Breaks Panel Clean
		VCtr VHgt VSiz VWid WMnX VMnY VMxX VMxY
		GoodStf BlkStrip BlkStf TxtStf BrkStf OtherStf SclStuff Stuff
		Fuzz Cnt Bubba PrevZoom OtherSS )
	(if (not Panel)
		(while (not Panel)
			(setq	Panel	(GetPanNam))
			(princ (strcat "\nBreaking Panel: " Panel))
		)
		(princ (strcat "\nBreaking Panel: " Panel))
	)
	(TstThLay)
	(setq	MinX		(* 1000.0 (atof (substr Panel 1 3)))
			MinY		(* 1000.0 (atof (substr Panel 4 4)))
			MaxX		(+ MinX XPanel)
			MaxY		(+ MinY YPanel)
			VCtr		(getvar "VIEWCTR")
			VHgt		(getvar "VIEWSIZE")
			VSiz		(getvar "SCREENSIZE")
			VWid		(* (/ (car VSiz) (cadr VSiz)) VHgt)
			VMnX		(- (car VCtr) (/ VWid 2.0))
			VMnY		(- (cadr VCtr) (/ VHgt 2.0))
			VMxX		(+ (car VCtr) (/ VWid 2.0))
			VMxY		(+ (cadr VCtr) (/ VHgt 2.0))
			GoodStf	nil
			BlkStrip	nil
			BlkStf	nil
			TxtStf	nil
			BrkStf	nil
			OtherStf	nil
			SclStuff	nil
			Stuff	nil
	)
	(if	(not	(and	(>= MinX VMnX)
				(>= MinY VMnY)
				(<= MaxX VMxX)
				(<= MaxY VMxY)
			)
		)
		(progn
			(command "_.ZOOM"	(list (- MinX 100.0) (- MinY 100.0))
							(list (+ MaxX 100.0) (+ MaxY 100.0))
			)
			(setq	PrevZoom	T)
		)
		(setq	PrevZoom	nil)
	)
	(setq	BlkStrip	(ssget "W"	(list (- MinX 5.0) (- MinY 5.0))
								(list (+ MaxX 5.0) (+ MaxY 5.0))
								(list	(cons -4 "<OR")
											(cons -4 "<AND")
												(cons 0 "INSERT")
												(cons 2 "GRID")
											(cons -4 "AND>")
											(cons -4 "<AND")
												(cons 0 "INSERT")
												(cons 2 "LOCK")
											(cons -4 "AND>")
										(cons -4 "OR>")
								)
					)
	)
	(if BlkStrip							; Get rid of the Grid block
		(command "_.ERASE" BlkStrip "")
	)
	
	(setq	OtherSS	(OtherPanTst Panel)				; Collect everything around border
			BrkStf	(BreakPan Panel OtherSS)			; Break it up
			TxtStf	(EntNamGrp (TxtPanTst Panel))		; Collect Text
			BlkStf	(EntNamGrp (BlkPanTst Panel))		; Collect Blocks
			OtherStf	(EntNamGrp (OtherPanTst Panel))	; Collect Other
			SclStuff	(ssget "X"	(list	(cons 0 "ATTDEF")
										(cons 2 Panel)
								)				; Collect the Panel Scale object
					)
			Fuzz		100.0
			Stuff	(ssget "C"	(list (+ MinX Fuzz) (+ MinY Fuzz))
								(list (- MaxX Fuzz) (- MaxY Fuzz))
								(list	(cons -4 "<NOT")
											(cons -4 "<OR")
												(cons -4 "<AND")
													(cons 0 "INSERT")
													(cons 2 "GRID")
												(cons -4 "AND>")
												(cons 0 "LINE")
												(cons 8 "----DLG---")
												(cons 8 "DLG*")
											(cons -4 "OR>")
										(cons -4 "NOT>")
								)				; Collect the center of the Panel itself,
					)							; minus Grid blocks & Lines
	)
	(if (and Bug BrkStf)
		(setq	EdsBrkStf		BrkStf)
	)
	(if (and Bug BlkStf)
		(setq	EdsBlkStf		BlkStf)
	)
	(if (and Bug TxtStf)
		(setq	EdsTxtStf		TxtStf)
	)
	(if (and Bug OtherStf)
		(setq	EdsOtherStf	OtherStf)
	)
;;;	{Removal of objects that exist in Stuff}
	(if Stuff
		(if SclStuff
			(progn
				(setq	Cnt	0
						Ent	(ssname SclStuff Cnt)
				)
				(princ "\nRemoving Scale Stuff...")
				(if (ssmemb Ent Stuff)
					(setq	Stuff	(ssdel Ent Stuff))
				)
				(if (> (sslength SclStuff) 1)
					(repeat (1- (sslength SclStuff))
						(setq	Cnt		(1+ Cnt)
								Ent		(ssname SclStuff Cnt)
								SclStuff	(ssdel Ent SclStuff)
						)
					)
				)
			)
		)
	)
	(if Stuff
		(if OtherStf
			(progn
				(setq	Cnt	0)
				(princ "\nRemoving Other Stuff...")
				(foreach	Ent
						OtherStf
						(if (ssmemb Ent Stuff)
							(setq	Stuff	(ssdel Ent Stuff)
									Bubba	(if BugBug (princ (strcat "\nItem #" (itoa (1+ Cnt)) " is removed.")))
							)
						)
						(Twizzle Cnt)
						(setq	Cnt	(1+ Cnt))
				)
				(Twizzle (- 0 Cnt))
			)
		)
	)
	(if Stuff
		(if BlkStf
			(progn
				(setq	Cnt	0)
				(princ "\nRemoving Block Stuff...")
				(foreach	Ent
						BlkStf
						(if (ssmemb Ent Stuff)
							(setq	Stuff	(ssdel Ent Stuff)
									Bubba	(if BugBug (princ (strcat "\nItem #" (itoa (1+ Cnt)) " is removed.")))
							)
						)
						(Twizzle Cnt)
						(setq	Cnt	(1+ Cnt))
				)
				(Twizzle (- 0 Cnt))
			)
		)
	)
	(if Stuff
		(if TxtStf
			(progn
				(setq	Cnt	0)
				(princ "\nRemoving Text Stuff...")
				(foreach	Ent
						TxtStf
						(if (ssmemb Ent Stuff)
							(setq	Stuff	(ssdel Ent Stuff)
									Bubba	(if BugBug (princ (strcat "\nItem #" (itoa (1+ Cnt)) " is removed.")))
							)
						)
						(Twizzle Cnt)
						(setq	Cnt	(1+ Cnt))
				)
				(Twizzle (- 0 Cnt))
			)
		)
	)
;;;	{Addition of objects that tested Good to those in Stuff}
	(if OtherStf
		(progn
			(setq	Cnt	0)
			(princ "\nAdding Broken Stuff...")
			(foreach	Ent	OtherStf
					(if (EntTst Ent MinX MinY MaxX MaxY)
						(if GoodStf
							(setq	GoodStf	(append GoodStf (list Ent)))
							(setq	GoodStf	(list Ent))
						)
					)
					(Twizzle Cnt)
					(setq	Cnt	(1+ Cnt))
			)
			(Twizzle (- 0 Cnt))
			(princ "\nAdding Broken Stuff... Done")
		)
	)
	(if BlkStf
		(progn
			(setq	Cnt	0)
			(princ "\nAdding Block Stuff...")
			(foreach	Ent
					BlkStf
					(if (EntTst Ent MinX MinY MaxX MaxY)
						(if GoodStf
							(setq	GoodStf	(append GoodStf (list Ent)))
							(setq	GoodStf	(list Ent))
						)
					)
					(Twizzle Cnt)
					(setq	Cnt	(1+ Cnt))
			)
			(Twizzle (- 0 Cnt))
		)
	)
	(if TxtStf
		(progn
			(setq	Cnt	0)
			(princ "\nAdding Text Stuff...")
			(foreach	Ent
					TxtStf
					(if (EntTst Ent MinX MinY MaxX MaxY)
						(if GoodStf
							(setq	GoodStf	(append GoodStf (list Ent)))
							(setq	GoodStf	(list Ent))
						)
					)
					(Twizzle Cnt)
					(setq	Cnt	(1+ Cnt))
			)
			(Twizzle (- 0 Cnt))
		)
	)
	(if SclStuff
		(if GoodStf
			(setq	Ent		(ssname SclStuff 0)
					GoodStf	(cons Ent GoodStf)
			)
			(setq	Ent		(ssname SclStuff 0)
					GoodStf	(list Ent)
			)
		)
	)
	(setq	Cnt	0)
	(if GoodStf
		(princ "\nFinal Good Stuff...")
	)	
	(if (and GoodStf (not Stuff))
		(if (> (length GoodStf) 1)
			(setq	Stuff	(ssadd (car GoodStf))
					GoodStf	(cdr GoodStf)
			)
			(setq	Stuff	(ssadd (car GoodStf))
					GoodStf	nil
			)
		)
	)	
	(if GoodStf
		(foreach	Ent
				GoodStf
				(setq	Stuff	(ssadd Ent Stuff))
				(Twizzle (setq Cnt (1+ Cnt)))
		)
		(setq	Stuff	nil)
	)
	(if GoodStf
		(Twizzle (- 0 Cnt))
	)	
	(if PrevZoom
		(command "_.ZOOM" "_P")
	)
	Stuff
)

(defun BreakPan ( Panel ssBrk /	MinX MinY		; Breaks Panel edges
							MaxX MaxY Elast
							Enew EntDuz )
	(if Bug (princ "\nBreakPan entered"))
	(setq	MinX		(* 1000.0 (atof (substr Panel 1 3)))
			MinY		(* 1000.0 (atof (substr Panel 4 4)))
			MaxX		(+ MinX XPanel)
			MaxY		(+ MinY YPanel)
	)
	(command "_.PLINE"
			 (list MinX MinY)
			 "W"
			 "0.0"
			 "0.0"
			 (list MaxX MinY)
			 (list MaxX MaxY)
			 (list MinX MaxY)
			 "C"
	)
	(setq	Elast	(entlast))
	(Map_DwgBreakObj ssBrk Elast 1 0)	 ; SScut~selectionSet, Boundary~polyline for break, Skiptopo Flag 1~ skip objs ref Topology, keeppod 0 ~ Drop object data on any clipped obj.
	
	(setq	Enew		(entnext Elast))
	(if Enew
		(progn
			(setq	EntDuz	(list Enew))
			(while (setq Enew (entnext Enew))
				(if Enew
					(setq	EntDuz	(append EntDuz (list Enew)))
				)
			)
		)
		(setq	EntDuz	nil)
	)
	(command "_.ERASE" Elast "")
	EntDuz
)

(defun EntTst ( Enam MinX MinY MaxX MaxY /		; Test boundary crossing of entities
			Fuzz Accept EntLst ZeroType Bubba VtxNam VtxPt PWidth
			ModMe Ipt GrpByte NewLst )
	(setq	Fuzz		0.01
			Accept	T
			ModMe	nil
			EntLst	(entget Enam)
			ZeroType	(cdr (assoc 0 EntLst))
	)
	(if (not (and SF SFF))
		(SclFactor)
	)
	(if (and BugBug MinX) (princ (strcat "\nMinX: " (rtos MinX 2 4))))
	(if (and BugBug MinY) (princ (strcat "\nMinY: " (rtos MinY 2 4))))
	(if (and BugBug MaxX) (princ (strcat "\nMaxX: " (rtos MaxX 2 4))))
	(if (and BugBug MaxY) (princ (strcat "\nMaxY: " (rtos MaxY 2 4))))
	(cond
		((= ZeroType "POLYLINE")
			(setq	VtxNam	(entnext Enam)
					VtxPt	(cdr (assoc 10 (entget VtxNam)))
					Bubba	(if BugBug (princ "\nTesting PolyLine"))
					PWidth	(GetWid (cdr (assoc 8 EntLst)))
					Bubba	(if (and BugBug VtxPt)
								(princ (strcat "\nVtxPt: " (rtos (car VtxPt) 2 4) "," (rtos (cadr VtxPt) 2 4)))
							)
			)
			(while	(and	(/= (cdr (assoc 0 (entget VtxNam))) "SEQEND")
						Accept
					)
				(if VtxPt
					(progn
						(if BugBug (setq	EdsHold	(list VtxPt VtxNam)))
						(if (LimPtTst VtxPt MinX MinY MaxX MaxY Fuzz)
							(setq	Accept	nil)
						)
					)
				)
				(setq	VtxNam	(entnext VtxNam))
				(if (assoc 10 (entget VtxNam))
					(setq	VtxPt	(cdr (assoc 10 (entget VtxNam))))
					(setq	VtxPt	nil)
				)
			)
			(if (not (equal PWidth 0.0 0.0001))
				(progn
					(if (not (assoc 39 EntLst))
						(if SF
							(progn
								(setq	EntLst	(append EntLst (list (cons 39 SF))))
								(entmod EntLst)
							)
							(progn
								(SclFactor)
								(setq	EntLst	(append EntLst (list (cons 39 SF))))
								(entmod EntLst)
							)
						)
					)
					(setq	EntLst	(subst	(cons 40 (* PWidth (cdr (assoc 39 EntLst)) 0.3048))
											(assoc 40 EntLst)
											EntLst
									)
					)
					(setq	EntLst	(subst	(cons 41 (* PWidth (cdr (assoc 39 EntLst)) 0.3048))
											(assoc 41 EntLst)
											EntLst
									)
					)
					(setq	ModMe	T)
					(entmod EntLst)
				)
			)
			(if ModMe	(entupd Enam))
		)
		((= ZeroType "LWPOLYLINE")
			(setq	Bubba	(if BugBug (princ "\nTesting LWPolyLine")))
			(foreach	GrpByte
					EntLst
					(if (= (car GrpByte) 10)
						(setq	Ipt	(cdr GrpByte))
						(setq	Ipt	nil)
					)
					(if Ipt
						(if (LimPtTst Ipt MinX MinY MaxX MaxY Fuzz)
							(setq	Accept	nil)
						)
					)
			)
			(if Accept
				(foreach	GrpByte
						EntLst
						(cond
							((= (car GrpByte) 39)
								(setq	PWidth	(GetWid (cdr (assoc 8 EntLst))))
								(if (not (equal PWidth 0.0 0.001))
									(if SF
										(setq	GrpByte	(cons 39 SF))
										(progn
											(SclFactor)
											(setq	GrpByte	(cons 39 SF))
										)
									)
								)
								(if NewLst
									(setq	NewLst	(append NewLst (list GrpByte)))
									(setq	NewLst	(list GrpByte))
								)
							)
							((= (car GrpByte) 40)
								(setq	PWidth	(GetWid (cdr (assoc 8 EntLst))))
								(if (not (equal PWidth 0.0 0.001))
									(if SF
										(setq	GrpByte	(cons 40 (* PWidth SF 0.3048)))
										(progn
											(SclFactor)
											(setq	GrpByte	(cons 40 (* PWidth SF 0.3048)))
										)
									)
								)
								(if NewLst
									(setq	NewLst	(append NewLst (list GrpByte)))
									(setq	NewLst	(list GrpByte))
								)
							)
							((= (car GrpByte) 41)
								(setq	PWidth	(GetWid (cdr (assoc 8 EntLst))))
								(if (not (equal PWidth 0.0 0.001))
									(if SF
										(setq	GrpByte	(cons 41 (* PWidth SF 0.3048)))
										(progn
											(SclFactor)
											(setq	GrpByte	(cons 41 (* PWidth SF 0.3048)))
										)
									)
								)
								(if NewLst
									(setq	NewLst	(append NewLst (list GrpByte)))
									(setq	NewLst	(list GrpByte))
								)
							)
							(T
								(if NewLst
									(setq	NewLst	(append NewLst (list GrpByte)))
									(setq	NewLst	(list GrpByte))
								)
							)
						)
				)
			)
			(if (and Accept NewLst)
				(entmod NewLst)
			)
		)
		((= ZeroType "TEXT")
			(setq	Bubba	(if BugBug (princ "\nTesting Text")))
			(if (or (/= (cdr (assoc 72 EntLst)) 0) (/= (cdr (assoc 73 EntLst)) 0))
				(setq	Ipt	(cdr (assoc 11 EntLst)))
				(setq	Ipt	(cdr (assoc 10 EntLst)))
			)
			(if (LimPtTst Ipt MinX MinY MaxX MaxY Fuzz)
				(setq	Accept	nil)
			)
		)
		((= ZeroType "ATTDEF")
			(setq	Bubba	(if BugBug (princ "\nTesting AttDef")))
			(if (or (/= (cdr (assoc 72 EntLst)) 0) (/= (cdr (assoc 74 EntLst)) 0))
				(setq	Ipt	(cdr (assoc 11 EntLst)))
				(setq	Ipt	(cdr (assoc 10 EntLst)))
			)
			(if (LimPtTst Ipt MinX MinY MaxX MaxY Fuzz)
				(setq	Accept	nil)
			)
		)
		((= ZeroType "INSERT")
			(setq	Bubba	(if BugBug (princ "\nTesting Insert")))
			(setq	Ipt	(cdr (assoc 10 EntLst)))
			(if (LimPtTst Ipt MinX MinY MaxX MaxY Fuzz)
				(setq	Accept	nil)
			)
		)
		((= ZeroType "ARC")
			(setq	Bubba	(if BugBug (princ "\nTesting Arc")))
			(setq	Rad	(cdr (assoc 40 EntLst))
					Ang1	(cdr (assoc 50 EntLst))
					Ang2	(cdr (assoc 51 EntLst))
					Ang3	(+ (/ (- Ang2 Ang1) 2.0) Ang1)
					Ipt	(cdr (assoc 10 EntLst))
			)
			(if (LimPtTst (polar Ipt Ang1 Rad) MinX MinY MaxX MaxY Fuzz)
				(setq	Accept	nil)
			)
			(if (LimPtTst (polar Ipt Ang2 Rad) MinX MinY MaxX MaxY Fuzz)
				(setq	Accept	nil)
			)
			(if (LimPtTst (polar Ipt Ang3 Rad) MinX MinY MaxX MaxY Fuzz)
				(setq	Accept	nil)
			)
		)
		((= ZeroType "CIRCLE")
			(setq	Bubba	(if BugBug (princ "\nTesting Circle")))
			(setq	Rad	(cdr (assoc 40 EntLst))
					Ang1	(/ pi 2.0)
					Ang2	pi
					Ang3	(/ (* pi 3.0) 2.0)
					Ang4	(* pi 2.0)
					Ipt	(cdr (assoc 10 EntLst))
			)
			(if (LimPtTst (polar Ipt Ang1 Rad) MinX MinY MaxX MaxY Fuzz)
				(setq	Accept	nil)
			)
			(if (LimPtTst (polar Ipt Ang2 Rad) MinX MinY MaxX MaxY Fuzz)
				(setq	Accept	nil)
			)
			(if (LimPtTst (polar Ipt Ang3 Rad) MinX MinY MaxX MaxY Fuzz)
				(setq	Accept	nil)
			)
			(if (LimPtTst (polar Ipt Ang4 Rad) MinX MinY MaxX MaxY Fuzz)
				(setq	Accept	nil)
			)
		)
		(T
			(if (assoc 0 EntLst)
				(setq	Bubba	(if BugBug (princ (strcat "\nTesting {" (cdr (assoc 0 EntLst)) "}"))))
				(setq	Bubba	(if BugBug (princ "\nTesting Unknown")))
			)
			(if (assoc 10 EntLst)
				(setq	Ipt	(cdr (assoc 10 EntLst)))
			)
			(if Ipt
				(if (LimPtTst Ipt MinX MinY MaxX MaxY Fuzz)
					(setq	Accept	nil)
				)
				(setq	Accept	nil)
			)
		)
	)
	Accept
)

(defun LimPtTst ( IPnt MinX MinY MaxX MaxY Fuzz /; Exact Point comparator (within fuzzy)
				Result Bubba )
	(setq	Result	T)
	(if BugBug	(setq	EdsTst (list IPnt MinX MinY MaxX MaxY Fuzz)))
	(if (> (car IPnt) MaxX)
		(if (not (equal (car IPnt) MaxX Fuzz))
			(setq	Result	nil
					Bubba	(if BugBug	(princ	(strcat	"\nIPnt above MaxX: "
													(rtos (car IPnt) 2 4)
													" > "
													(rtos MaxX 2 4)
											)
									)
							)
			)
		)
	)
	(if Result
		(if (> (cadr IPnt) MaxY)
			(if (not (equal (cadr IPnt) MaxY Fuzz))
				(setq	Result	nil
						Bubba	(if BugBug	(princ	(strcat	"\nIPnt above MaxY: "
														(rtos (cadr IPnt) 2 4)
														" > "
														(rtos MaxY 2 4)
												)
										)
								)
				)
			)
		)
	)
	(if Result
		(if (< (car IPnt) MinX)
			(if (not (equal (car IPnt) MinX Fuzz))
				(setq	Result	nil
						Bubba	(if BugBug	(princ	(strcat	"\nIPnt below MinX: "
														(rtos (car IPnt) 2 4)
														" < "
														(rtos MinX 2 4)
												)
										)
								)
				)
			)
		)
	)
	(if Result
		(if (< (cadr IPnt) MinY)
			(if (not (equal (cadr IPnt) MinY Fuzz))
				(setq	Result	nil
						Bubba	(if BugBug	(princ	(strcat	"\nIPnt below MinY: "
														(rtos (cadr IPnt) 2 4)
														" < "
														(rtos MinY 2 4)
												)
										)
								)
				)
			)
		)
	)
	(not Result)
)

(defun EntNamGrp ( ssGrp /	EntGrp Cnt )		; Lists Entity Names from ss
	(setq	Cnt	0)
	(if (and Bug ssGrp) (princ (strcat "\nssGrp has " (itoa (sslength ssGrp)))))
	(if ssGrp
		(while (< Cnt (sslength ssGrp))
			(if EntGrp
				(setq	EntGrp	(append EntGrp (list (ssname ssGrp Cnt))))
				(setq	EntGrp	(list (ssname ssGrp Cnt)))
			)
			(setq	Cnt	(1+ Cnt))
		)
		(setq	EntGrp	nil)
	)
	(if (and Bug EntGrp) (princ (strcat "\nEntGrp has " (itoa (length EntGrp)))))
	EntGrp
)

(defun ClosEm ( /	delst1 delst2 Panel )		; Closes All Panels
	(if Bug (princ "\nCloseAllPan entered"))
	(setvar "HIGHLIGHT" 0)
	(SetLim PanLst)
	(if PanLst
		(foreach	Panel
				PanLst
				(SavPan Panel 2)
		)
	)
	(setvar "HIGHLIGHT" 1)
	(if Bug (princ "\nCloseAllPan exited"))
	(princ)
)

(defun SavClosEm ( /	delst1 delst2 Panel )	; Saves & Closes All Panels
	(if Bug (princ "\nCloseAllPan entered"))
;;;	(setvar "HIGHLIGHT" 0)
;;;	(SetLim PanLst)
	(if GrpOraDate
		(setq	GrpOraDate	nil)
	)
;;;	(if GetOraDate
;;;		(setq	GrpOraDate	(GetOraDate))
;;;	)
	(if PanLst
		(foreach	Panel
				PanLst
				(SavPan Panel 4)
		)
	)
	(if GrpOraDate
		(setq	GrpOraDate	nil)
	)
;;;	(setvar "HIGHLIGHT" 1)
	(if Bug (princ "\nCloseAllPan exited"))
	(princ)
)

(defun SavPan ( Panel Action /	Tdata ; Saves a Panel
							OldCmdDia OldExpert OldFileDia OldNoMutt LaySt ints isecs outs osecs elss ssLp Bubba )
	(if Bug (progn (princ "\nPanel.lsp!SavPan - Parameters Panel = ") (prin1 Panel)(princ " Action = ") (prin1 Action)(princ "\n")))
	(setq	Tdata	nil)
	(if (> (getvar "PLINETYPE") 0) (setvar "PLINETYPE" 0))
	(if (/= (getvar "SORTENTS") 20) (setvar "SORTENTS" 20))
	
	(if (= (length PanLst) 1)
		(setq 	Panel (car PanLst)) 
		(if (not Panel)
			(while (not Panel)
				(setq	Panel	(GetPanNam))
			)
		)
	)
	
	(if (not (member Panel PanLst))
		(progn
			(alert (strcat "***" AppNam " Error***\nNot an Open Panel"))
			(exit)
		)
	)
	(SubMakLay)
	(setq	ints			(getvar "date")
			isecs		(* 86400.0 (- ints (fix ints)))
	)
	
	;	Cleanup Polylines
	(setq	ssLp	(ssget "X" (list (cons 0 "LWPOLYLINE"))))
	(if ssLp
		(command "ConvertPoly" "H" ssLp "")
	)
	(if ssLp
		(setq	ssLp	nil)
	)

	(setq	ints			(getvar "date")
			isecs		(* 86400.0 (- ints (fix ints)))
	)
	
	(setq	LayNamLst	(GetLayoutNames))
	(foreach	LayName
			LayNamLst
			(if (= (substr (strcase LayName) 1 7) (strcase Panel))
				(setq	TstLst	(SetCurrLayout LayName)
						Bubba	(WBlkPanDwg LayName nil)
						Bubba	(DeleteLayout LayName)
				)
			)
	)
	(SetCurrLayout "Model")
	(if (= PanTyp 1)													;	Check to see if Geographic Panel ~ 1		(if (/= Div "GA")  (cons 8 "????CK-###*"))
		(setq	Tdata	(BrkPanClean Panel))
		(if (and (/= Div "GA")(/= Div "AL"))								;	If Mobile Sub
			(setq	Tdata	(ssget "X"	(list	(cons -4 "<OR")
													(cons -4 "<AND")
														(cons 0 "POLYLINE")
														(cons 8 "????CK-###*")
														(cons 67 0)
													(cons -4 "AND>")
													(cons -4 "<AND")
														(cons 0 "INSERT")
														(cons 2 "[Aa]###,[Aa]###[Ss]")
														(cons 67 0)
													(cons -4 "AND>")
													(cons -4 "<AND")
														(cons 0 "TEXT")
														(cons 8 "*")
														(cons 67 0)
													(cons -4 "AND>")
												(cons -4 "OR>")
												(cons 67 0)
										)
							)
			)
			(setq	Tdata	(ssget "X"	(list	(cons -4 "<OR")
													(cons -4 "<AND")
														(cons 0 "POLYLINE")
														(cons 67 0)
													(cons -4 "AND>")
													(cons -4 "<AND")
														(cons 0 "INSERT")
														(cons 2 "[Aa]###,[Aa]###[Ss]")
														(cons 67 0)
													(cons -4 "AND>")
													(cons -4 "<AND")
														(cons 0 "TEXT")
														(cons 8 "*")
														(cons 67 0)
													(cons -4 "AND>")
												(cons -4 "OR>")
												(cons 67 0)
										)
							)
			)
		)
	)
	(setq	outs		(getvar "date")
			osecs	(* 86400.0 (- outs (fix outs)))
			elss		(itoa (fix (- (* osecs 1000.0) (* isecs 1000.0))))
	)
	(if DevMark
		(princ (strcat "\nElapsed Milliseconds for BrkPanClean: " elss))
	)
	(if Tdata
		(if (not Action)
			(setq	Action	(SaveAns))
		)
	)
	(if (and Bug DevMark)
		(princ (strcat "\nAction: " (itoa Action)))
	)
	(if (and Bug Tdata)
		(setq	EdsTdata	Tdata
				Bubba	(princ (strcat "\nTdata: " (itoa (sslength Tdata))))
		)
	)
    ;below - actions within the conditional	
	;(= Action 2)  ; Close and Don't Save Choice
	;(= Action 3)  ; Save and Leave on Screen Choice
	;(= Action 4)  ; Save and Close Choice
	(if Tdata
		(cond
				((= Action 4)				; Save and Close Choice
					(princ (strcat "\nSaving " Panel))
					(CheckPolylineVertices) 	; 	[TODO] testing to cleanup vertices layer names to match base polyline name
				 	(CheckAttributes)		;	[TODO] Testings
					(if (= Div "AL")
						(progn
							(CheckObjectColor)	;	Checks first if colored bylayer if so corrects AutoCAD Pen based on voltage.
							(FixEED2 nil)
						)
					)
					(if (= Div "GA")	; Testing GCC Color Fix
						(progn
							(FixEED2 nil)
						)
					)
					
					(setq	OldCmdDia	(getvar "CMDDIA")
							OldExpert	(getvar "EXPERT")
							OldFileDia	(getvar "FILEDIA")
							OldNoMutt	(getvar "NOMUTT")
					)
					(command "_.UNDO" "_BE")
					(setvar "CMDDIA" 0)
					(setvar "EXPERT" 5)
					(setvar "FILEDIA" 0)
					(setvar "NOMUTT" 1)
					
					(if (and (/= Div "AL") (/= Div "GA"))
						(progn
							(setq	PLogDat	(AddsUpAnalyze Tdata Panel elss))
							(if PLogDat
								(if (setq PLogFil (open (strcat _Alt_Path-Panel "Data\\PanelChg.log") "a"))
									(setq	Bubba	(write-line (strcat "[" Div "] " PLogDat) PLogFil)
											Bubba	(close PLogFil)
											outs		(getvar "date")
											osecs	(* 86400.0 (- outs (fix outs)))
											elss		(itoa (fix (- (* osecs 1000.0) (* isecs 1000.0))))
									)
									(setq	outs		(getvar "date")
											osecs	(* 86400.0 (- outs (fix outs)))
											elss		(itoa (fix (- (* osecs 1000.0) (* isecs 1000.0))))
									)
								)
							)
						)
					)
					(if (not Vld_MPG)
						(if Lst_Vld_MPG
							(if (assoc (strcase (getvar "LOGINNAME")) Lst_Vld_MPG)
								(setq	Vld_MPG	(assoc (strcase (getvar "LOGINNAME")) Lst_Vld_MPG))
								(setq	Vld_MPG	nil)
							)
							(setq	Vld_MPG	nil)
						)
					)
					(if Vld_MPG
						(setq	Bubba	(princ (strcat "\n***Authorized MPG Poster: {" (cdr Vld_MPG) "} Posting in Div={" Div "}***"))
								OLogDat	(if (findfile (strcat _Alt_Path-Panel "Locked\\AddsDb.Lck"))
											(princ (strcat "\n*Error* Posting to AddsDb currently disabled!"))
											(EMB_Analyze Tdata Panel elss)  ; [Disable for Trans]
										)
								Bubba	(if (member Panel PanLst)
											(WBlkPanDwg Panel Tdata)
										)
								Bubba	(if (member Panel PanLst)
											(DelPanLck Panel)
										)
								Bubba	(setq	Tdata	nil)
								Bubba	(redraw)
						)
						(setq	Bubba	(princ (strcat "\n*Not* an Authorized MPG Poster: {" (strcase (getvar "LOGINNAME")) "}")))
					)
					(princ "\n - Action 4 DwgType: ") (prin1 DwgType) (princ "  Panel List: ") (prin1 PanLst)
					(if (or (= DwgType	"SLD") (null PanLst)) 	; SLD ~ Single Line Diagram
						(Addsquit 3)
						(if (= PanTyp 2)
							(SubMenuSet nil)
						)
					)
					(setvar "EXPERT" 	OldExpert)
					(setvar "CMDDIA" 	OldCmdDia)
					(setvar "FILEDIA"	OldFileDia)
					
				;	(setvar "NOMUTT" 	OldNoMutt)
					(setvar "NOMUTT" 0)
					(command "_.UNDO" "_EN")
				)
				((= Action 3)				; Save and Leave on Screen Choice
					(princ (strcat "\nSaving " Panel))
					(CheckPolylineVertices) 	; 	[TODO] testing to cleanup vertices layer names to match base polyline name
					(CheckAttributes)		;	[TODO] Testings
					(if (= Div "AL")
						(progn
							(CheckObjectColor)
							(FixEED2 nil)
						)
					)
					(setq	OldCmdDia	(getvar "CMDDIA")
							OldExpert	(getvar "EXPERT")
							OldFileDia	(getvar "FILEDIA")
							cLay		(getvar "CLAYER")
					)
					(command "_.UNDO" "_BE")
					(setvar "CMDDIA" 0)
					(setvar "EXPERT" 5)
					(setvar "FILEDIA" 0)
					(setq	PLogDat	(AddsUpAnalyze Tdata Panel elss))
					(if PLogDat
						(if (setq PLogFil (open (strcat _Alt_Path-Panel "Data\\PanelChg.log") "a"))
							(setq	Bubba	(write-line (strcat "[" Div "] " PLogDat) PLogFil)
									Bubba	(close PLogFil)
									outs		(getvar "date")
									osecs	(* 86400.0 (- outs (fix outs)))
									elss		(itoa (fix (- (* osecs 1000.0) (* isecs 1000.0))))
							)
							(setq	outs		(getvar "date")
									osecs	(* 86400.0 (- outs (fix outs)))
									elss		(itoa (fix (- (* osecs 1000.0) (* isecs 1000.0))))
							)
						)
					)
					(if (not Vld_MPG)
						(if Lst_Vld_MPG
							(if (assoc (strcase (getvar "LOGINNAME")) Lst_Vld_MPG)
								(setq	Vld_MPG	(assoc (strcase (getvar "LOGINNAME")) Lst_Vld_MPG))
								(setq	Vld_MPG	nil)
							)
							(setq	Vld_MPG	nil)
						)
					)
					(if (and Vld_MPG (member Div (list "BH" "E_" "M_" "S_" "SE" "W_")))
						(setq	Bubba	(princ (strcat "\n***Authorized MPG Poster: {" (cdr Vld_MPG) "} Posting in Div={" Div "}***"))
								OLogDat	(if (findfile (strcat _Alt_Path-Panel "Locked\\AddsDb.Lck"))
											(princ (strcat "\n*Error* Posting to AddsDb currently disabled!"))
											(EMB_Analyze Tdata Panel elss)
										)
						)
						(if Vld_MPG
							(if Div
								(if (= (strcase (getvar "LOGINNAME")) "ADDSLODR")
									(setq	Bubba	(princ (strcat "\n***Authorized MPG Poster: {" (cdr Vld_MPG) "} Posting in Div={" Div "}***"))
											OLogDat	(if (findfile (strcat _Alt_Path-Panel "Locked\\AddsDb.Lck"))
														(princ (strcat "\n*Error* Posting to AddsDb currently disabled!"))
														(EMB_Analyze Tdata Panel elss)
													)
									)
									(setq	Bubba	(princ (strcat "\n*Not* posting Division {" Div "} yet...")))
								)
								(setq	Bubba	(princ (strcat "\n*Not* posting Southern, SouthEast or Mobile Divisions yet...")))
							)
							(setq	Bubba	(princ (strcat "\n*Not* an Authorized MPG Poster: {" (strcase (getvar "LOGINNAME")) "}")))
						)
					)
					(if (findfile (strcat _PATH-PANEL Panel ".dwg"))
						(command "WBLOCK" (strcat _PATH-PANEL Panel) "" "0,0" Tdata "" "N")
						(command "WBLOCK" (strcat _Alt_PATH-PANEL Panel) "" "0,0" Tdata "" "N")
					)
					(redraw)
					(command "OOPS")
					(setvar "EXPERT" 	OldExpert)
					(setvar "CMDDIA" 	OldCmdDia)
					(setvar "FILEDIA"	OldFileDia)
					(command "_.UNDO" "_EN")
					(command "_.UNDO" "1")
					(setq	Tdata	nil)
					
					;	[Trans - Change]  due to ACC panel size
					(if (/= Div "AL")
						(command	"_.LAYER"
							"S"
							"----GRD---"
							""
							"INSERT"
							(strcat _Path-Sym "GRID") ;--Insert the panel box
							(strcat (substr Panel 1 3) "000," (substr Panel 4) "000")
							""
							""
							""
							"_.LAYER"
							"S"
							cLay
							""
						)
						(command	"_.LAYER"
							"S"
							"----GRD---"
							""
							"INSERT"
							(strcat _Path-Sym "GRID") ;--Insert the panel box
							(strcat (substr Panel 1 3) "000," (substr Panel 4) "000")
							"10.0"
							""
							""
							"_.LAYER"
							"S"
							cLay
							""
						)
					)
				)
				((= Action 2)				; Close and Don't Save Choice
					(princ (strcat "\nClosing " Panel))
					(command "_.UNDO" "_BE")
					(command "_.ERASE" Tdata "")
					(if (member Panel PanLst)
						(DelPanLck Panel)
					)
					(command "_.UNDO" "_EN")
					(princ "\n - Action 2 DwgType: ") (prin1 DwgType) (princ "  Panel List: ") (prin1 PanLst)
					(if (or (= DwgType	"SLD") (null PanLst)) 	; SLD ~ Single Line Diagram
						(Addsquit 3)
					)
				)
		)
	)
	Action
)

(defun CollectStrips (	MinX MinY MaxX MaxY		; Generic Panel Edge Stripper
					Filter Fuzz /	Pt1 Pt2 Pt3 Pt4
					Pt5 Pt6 Pt7 Pt8 SS1 SS2 )
	(setq	Pt1		(list (+ MinX Fuzz) (+ MinY Fuzz))
			Pt2		(list (- MinX Fuzz) (- MinY Fuzz))
			Pt3		(list (+ MaxX Fuzz) (- MinY Fuzz))
			Pt4		(list (+ MaxX Fuzz) (+ MaxY Fuzz))
			Pt5		(list (- MinX Fuzz) (+ MaxY Fuzz))
			Pt6		(list (+ MinX Fuzz) (- MaxY Fuzz))
			Pt7		(list (- MaxX Fuzz) (- MaxY Fuzz))
			Pt8		(list (- MaxX Fuzz) (+ MinY Fuzz))
			SS1		(ssget "CP"	(list Pt1 Pt2 Pt3 Pt4 Pt7 Pt8 Pt1)
								Filter
					)
			SS2		(ssget "CP"	(list Pt1 Pt2 Pt5 Pt4 Pt7 Pt6 Pt1)
								Filter
					)
	)
	(if Bug
		(progn
			(grdraw Pt1 Pt2 1 1)
			(grdraw Pt2 Pt3 1 1)
			(grdraw Pt3 Pt4 1 1)
			(grdraw Pt4 Pt7 1 1)
			(grdraw Pt7 Pt8 1 1)
			(grdraw Pt8 Pt1 1 1)
			(grdraw Pt1 Pt2 2 1)
			(grdraw Pt2 Pt5 2 1)
			(grdraw Pt5 Pt4 2 1)
			(grdraw Pt4 Pt7 2 1)
			(grdraw Pt7 Pt6 2 1)
			(grdraw Pt6 Pt1 2 1)
		)
	)
	(list SS1 SS2)
)

(defun LayPrep ( Action /	LayLst )			; Resets all layers prior to saving...
	(setq	LayLst	(list "0"))
;	(command	"_.LAYER" "T" "*" "ON" "*" "U" "*" "S" "0" "")
	LayLst
)

(defun BldAttDef (	PanelNam /	Ent1 PPt1 	; Builds AttDef Scales Ent1 
							PScl pt ptx pty )
	(if (not XPanel)
		(if (/= Div  "AL")
			(setq	XPanel	6000.0)
			(setq	XPanel	60000.0)
		)
	)
	(if (not YPanel)
		(if (/= Div  "AL")
			(setq	YPanel	4000.0)
			(setq	YPanel	40000.0)
		)
	)
	(if (not PanelNam)
		(progn
			(initget 1)
			(setq	pt		(getpoint "\n\nSelect a panel you wish the scale of: \n")
					ptx		(* (fix (/ (car pt) XPanel)) XPanel)
					pty		(* (fix (/ (cadr pt) YPanel)) YPanel)
					PanelNam	(BldFn ptx pty)
					Bubba	(princ (strcat "\nUser selected panel {" PanelNam "} to set scale in"))
			)
		)
	)
	(if (and PanelNam sff)
		(if (= (strlen PanelNam) 7)
			(setq	PPt1		(list	(+ 10.0 (* 1000.0 (atof (substr PanelNam 1 3))))
									(+ 10.0 (* 1000.0 (atof (substr PanelNam 4 4))))
									0.0
							)
					PScl		(itoa sff)
			)
		)
	)
	(if (and PPt1 PScl)
		(setq	Ent1		(list	(cons	0	"ATTDEF")
								(cons	8	"----SC----")
								(cons	100	"AcDbEntity")
								(cons	100	"AcDbText")
								(cons	10	PPt1)
								(cons	40	0.2)
								(cons	1	PScl)
								(cons	7	"STANDARD")
								(cons	210	(list 0.0 0.0 1.0))
								(cons	100	"AcDbAttributeDefinition")
								(cons	3	"Panel scale factor")
								(cons	2	PanelNam)
								(cons	70	0)
						)
		)
	)
	(if Ent1
		(entmake Ent1)
	)
)

(defun AddsUpGather ( /	DatLst DatLen Cntr		; Collects Data Files into Adds_Up files
					DatFil DatGet InData	; ChkLst CP_Lst BlkLst SW_Lst MstrFdrLst
					FdrTxt FdrNam MinX MinY MaxX MaxY Lent FdrNod OutStat
					ChkFil ChkItm SwFil SW_Itm FdrFil MstrFdrItm BlkFil BlkItm CP_Fil CP_Itm
					ints isecs outs osecs elss Bubba )
	(if (VerDwgDatMatch T)
		(setq	DatLst		nil)
		(setq	DatLst		(dos_dir (strcat _Path-Panel "Data\\*.dat"))
				ChkLst		nil
				CP_Lst		nil
				BlkLst		nil
				SW_Lst		nil
				MstrFdrLst	nil
				OutStat		nil
				ints			(getvar "date")
				isecs		(* 86400.0 (- ints (fix ints)))
				Bubba		(if (and Bug isecs) (princ (strcat "\nStart: " (rtos isecs 2 2))))
		)
	)
	(if Div
		(setq	SDatLst	(GetShrLst Div DevMark))
	)
	(if DatLst
		(setq	DatLst	(mapcar (quote (lambda (x) (substr x 1 (- (strlen x) 4)))) DatLst))
	)
	(if (and DatLst SDatLst)
		(foreach	Dat
				SDatLst
				(if (not (member Dat DatLst))
					(setq	DatLst	(cons Dat DatLst))
				)
		)
	)
	(if DatLst
		(setq	DatLst	(acad_strlsort DatLst)
				DatLen	(length DatLst)
				Cntr		0
		)
	)
	(if (and DatLst (not Bug))
		(princ "\nNow gathering Adds_Up data for reporting...")
		(if DatLen
			(princ (strcat "\nNow starting foreach on {" (itoa DatLen) "} DAT files..."))
		)
	)
	(if DatLst
		(foreach	DatFil
				DatLst
				(if (not Bug)
					(Twaddle Cntr DatLen)
					(princ ".")
				)
				(setq	DatGet	(if (findfile (strcat _Path-Panel "Data\\" DatFil ".dat"))
									(open (strcat _Path-Panel "Data\\" DatFil ".dat") "r")
									(if (findfile (strcat _Alt_Path-Panel "Data\\" DatFil ".dat"))
										(open (strcat _Alt_Path-Panel "Data\\" DatFil ".dat") "r")
										nil
									)
								)
						Cntr		(1+ Cntr)
				)
				(if DatGet
					(setq	InData	(read-line DatGet))
					(setq	InData	nil)
				)
				(while InData
					(if InData
						(cond
							((equal (substr InData 1 5) "[CHK]")
								(if ChkLst
									(setq	ChkLst	(cons (substr InData 11) ChkLst))
									(setq	ChkLst	(list (substr InData 11)))
								)
							)
							((equal (substr InData 1 5) "[CP] ")
								(if CP_Lst
									(setq	CP_Lst	(cons (substr InData 11) CP_Lst))
									(setq	CP_Lst	(list (substr InData 11)))
								)
							)
							((equal (substr InData 1 5) "[BLK]")
								(if BlkLst
									(setq	BlkLst	(cons (substr InData 11) BlkLst))
									(setq	BlkLst	(list (substr InData 11)))
								)
							)
							((equal (substr InData 1 5) "[SW] ")
								(if SW_Lst
									(setq	SW_Lst	(cons (substr InData 11) SW_Lst))
									(setq	SW_Lst	(list (substr InData 11)))
								)
							)
							((equal (substr InData 1 5) "[SUB]")
								(setq	FdrTxt	(substr InData 11)
										FdrNam	(substr FdrTxt 1 3)
										SubNam	(substr FdrTxt 1 2)
										MinX		(atof (substr FdrTxt 11 10))
										MinY		(atof (substr FdrTxt 21 10))
										MaxX		(atof (substr FdrTxt 31 10))
										MaxY		(atof (substr FdrTxt 41 10))
										LentOne	(atof (substr FdrTxt 51 12))
										LentTwo	(atof (substr FdrTxt 63 12))
										LentThr	(atof (substr FdrTxt 75 12))
										LentFor	(atof (substr FdrTxt 87 12))
										LentFiv	(atof (substr FdrTxt 99 12))
										LentSix	(atof (substr FdrTxt 111 12))
										LentSvn	(atof (substr FdrTxt 123 12))
										FdrNod	(list FdrNam MinX MinY MaxX MaxY LentOne LentTwo LentThr LentFor LentFiv LentSix LentSvn)
										SubNod	(list SubNam MinX MinY MaxX MaxY LentOne LentTwo LentThr LentFor LentFiv LentSix LentSvn)
								)
								(if MstrFdrLst
									(if (assoc FdrNam MstrFdrLst)
										(setq	MstrFdrLst	(subst	(AddsUpMerge FdrNod (assoc FdrNam MstrFdrLst))
																	(assoc FdrNam MstrFdrLst)
																	MstrFdrLst
															)
										)
										(setq	MstrFdrLst	(cons FdrNod MstrFdrLst))
									)
									(setq	MstrFdrLst	(list FdrNod))
								)
								(if MstrSubLst
									(if (assoc SubNam MstrSubLst)
										(setq	MstrSubLst	(subst	(AddsUpMerge SubNod (assoc SubNam MstrSubLst))
																	(assoc SubNam MstrSubLst)
																	MstrSubLst
															)
										)
										(setq	MstrSubLst	(cons SubNod MstrSubLst))
									)
									(setq	MstrSubLst	(list SubNod))
								)
							)
						)
					)
					(setq	InData	(read-line DatGet))
				)
				(if DatGet (close DatGet))
		)
	)
	(if (and DatLst (not Bug))
		(Twaddle (- 0 Cntr) DatLen)
		(if (and DatLst Bug)
			(princ ".\nDone with foreach\n")
		)
	)
	(if (or ChkLst SW_Lst MstrFdrLst MstrSubLst BlkLst CP_Lst)
		(setq	DatLen	(+	(if ChkLst	(length ChkLst) 0)
							(if SW_Lst	(length SW_Lst) 0)
							(if MstrFdrLst	(length MstrFdrLst) 0)
							(if MstrSubLst	(length MstrSubLst) 0)
							(if BlkLst	(length BlkLst) 0)
							(if CP_Lst	(length CP_Lst) 0)
						)
				Cntr		0
		)
	)
	(if (and DatLst (not Bug))
		(princ "\nNow outputting Adds_Up data: ...")
		(if DatLst
			(princ "\nCreating Adds_Up files: [CHK],[SW],[SUB],[BLK],[CP],[LEN]")
		)
	)
	(if (and DatLst ChkLst)
		(if OutStat
			(setq	OutStat	(strcat OutStat ",[CHK]")
					Bubba	(StatTxt OutStat)
			)
			(setq	OutStat	"AddsUp Processing: [CHK]"
					Bubba	(StatTxt OutStat)
			)
		)
	)
	(if (and DatLst ChkLst)
		(progn
			(setq	ChkFil	(open (strcat _Path-Panel "Adds_Up.CHK") "w")
					ChkLst	(reverse ChkLst)
			)
			(foreach	ChkItm
					ChkLst
					(setq	Cntr		(1+ Cntr))
					(if (not Bug)
						(Twaddle Cntr DatLen)
						(princ "+")
					)
					(write-line ChkItm ChkFil)
			)
			(close ChkFil)
		)
	)
	(if (and DatLst SW_Lst)
		(if OutStat
			(setq	OutStat	(strcat OutStat ",[SW]")
					Bubba	(StatTxt OutStat)
			)
			(setq	OutStat	"AddsUp Processing: [SW]"
					Bubba	(StatTxt OutStat)
			)
		)
	)
	(if (and DatLst SW_Lst)
		(progn
			(setq	SwFil	(open (strcat _Path-Panel "Adds_Up.SW") "w")
					CorSwFil	(open (strcat _Path-Panel "Switch.COR") "w")
					SW_Lst	(reverse SW_Lst)
			)
			(foreach	SW_Itm
					SW_Lst
					(setq	Cntr		(1+ Cntr))
					(if (not Bug)
						(Twaddle Cntr DatLen)
						(princ "*")
					)
					(write-line SW_Itm SwFil)
					(write-line	(strcat	(substr SW_Itm 11 20)
										(substr SW_Itm 11 20)
										(StpSpac (substr SW_Itm 1 10))
								)
								CorSwFil
					)
			)
			(close CorSwFil)
			(close SwFil)
		)
	)
	(if (and DatLst MstrFdrLst)
		(if OutStat
			(setq	OutStat	(strcat OutStat ",[COR]")
					Bubba	(StatTxt OutStat)
			)
			(setq	OutStat	"AddsUp Processing: [COR]"
					Bubba	(StatTxt OutStat)
			)
		)
	)
	(if (and DatLst MstrFdrLst)
		(progn
			(setq	FdrFil		(open (strcat _Path-Panel "Adds_Up.TMP") "w")
					LenFil		(open (strcat _Path-Panel "Adds_Up.LEN") "w")
					CorFdrFil		(open (strcat _Path-Panel "Feeder.COR") "w")
					CorSubFil		(open (strcat _Path-Panel "Sub.COR") "w")
					MstrFdrLst	(LstSort MstrFdrLst (quote (lambda (x y) (< (car x) (car y)))))
					MstrSubLst	(LstSort MstrSubLst (quote (lambda (x y) (< (car x) (car y)))))
			)
			(foreach	MstrFdrItm
					MstrFdrLst
					(setq	Cntr		(1+ Cntr))
					(if (not Bug)
						(Twaddle Cntr DatLen)
						(princ "&")
					)
					(write-line	(strcat	(PadCharR (rtos (nth 1 MstrFdrItm) 2 0) 10)	;;; MinX
										(PadCharR (rtos (nth 2 MstrFdrItm) 2 0) 10)	;;; MinY
										(PadCharR (rtos (nth 3 MstrFdrItm) 2 0) 10)	;;; MaxX
										(PadCharR (rtos (nth 4 MstrFdrItm) 2 0) 10)	;;; MaxY
										(nth 0 MstrFdrItm)						;;; Feeder Name
								)
								CorFdrFil
					)
					(write-line	(strcat	(nth 0 MstrFdrItm)						;;; Feeder Name
										(rtos (nth 1 MstrFdrItm) 2 0)				;;; MinX
										" "
										(rtos (nth 2 MstrFdrItm) 2 0)				;;; MinY
										" "
										(rtos (nth 3 MstrFdrItm) 2 0)				;;; MaxX
										" "
										(rtos (nth 4 MstrFdrItm) 2 0)				;;; MaxY
										" "
								)
								FdrFil
					)
					(write-line	(strcat	(nth 0 MstrFdrItm)						;;; Feeder Name
										(PadCharL (rtos (nth 5 MstrFdrItm) 2 2) 12)	;;; Feeder Length Overhead 3 Phase
										(PadCharL (rtos (nth 6 MstrFdrItm) 2 2) 12)	;;; Feeder Length Overhead 2 Phase
										(PadCharL (rtos (nth 7 MstrFdrItm) 2 2) 12)	;;; Feeder Length Overhead 1 Phase
										(PadCharL (rtos (nth 8 MstrFdrItm) 2 2) 12)	;;; Feeder Length Underground 3 Phase
										(PadCharL (rtos (nth 9 MstrFdrItm) 2 2) 12)	;;; Feeder Length Underground 2 Phase
										(PadCharL (rtos (nth 10 MstrFdrItm) 2 2) 12)	;;; Feeder Length Underground 1 Phase
										(PadCharL (rtos (nth 11 MstrFdrItm) 2 2) 12)	;;; Total Feeder Lenght
								)
								LenFil
					)
			)
			(foreach	MstrSubItm
					MstrSubLst
					(setq	Cntr		(1+ Cntr))
					(if (not Bug)
						(Twaddle Cntr DatLen)
						(princ "@")
					)
					(write-line	(strcat	(PadCharR (rtos (nth 1 MstrSubItm) 2 0) 10)
										(PadCharR (rtos (nth 2 MstrSubItm) 2 0) 10)
										(PadCharR (rtos (nth 3 MstrSubItm) 2 0) 10)
										(PadCharR (rtos (nth 4 MstrSubItm) 2 0) 10)
										(nth 0 MstrSubItm)
								)
								CorSubFil
					)
			)
			(close FdrFil)
			(close LenFil)
			(close CorFdrFil)
			(close CorSubFil)
		)
	)
	(if (and DatLst BlkLst)
		(if OutStat
			(setq	OutStat	(strcat OutStat ",[BLK]")
					Bubba	(StatTxt OutStat)
			)
			(setq	OutStat	"AddsUp Processing: [BLK]"
					Bubba	(StatTxt OutStat)
			)
		)
	)
	(if (and DatLst BlkLst)
		(progn
			(setq	BlkFil	(open (strcat _Path-Panel "Adds_Up.BLK") "w")
					BlkLst	(reverse BlkLst)
			)
			(foreach	BlkItm
					BlkLst
					(setq	Cntr		(1+ Cntr))
					(if (not Bug)
						(Twaddle Cntr DatLen)
						(princ "%")
					)
					(write-line BlkItm BlkFil)
			)
			(close BlkFil)
		)
	)
	(if (and DatLst CP_Lst)
		(if OutStat
			(setq	OutStat	(strcat OutStat ",[CP]")
					Bubba	(StatTxt OutStat)
			)
			(setq	OutStat	"AddsUp Processing: [CP]"
					Bubba	(StatTxt OutStat)
			)
		)
	)
	(if (and DatLst CP_Lst)
		(progn
			(setq	CP_Fil	(open (strcat _Path-Panel "Adds_Up.CP") "w")
					CP_Lst	(reverse CP_Lst)
			)
			(foreach	CP_Itm
					CP_Lst
					(setq	Cntr		(1+ Cntr))
					(if (not Bug)
						(Twaddle Cntr DatLen)
						(princ "#")
					)
					(write-line CP_Itm CP_Fil)
			)
			(close CP_Fil)
		)
	)
	(if (and DatLst (not Bug))
		(Twaddle (- 0 Cntr) DatLen)
		(if (and DatLst Bug)
			(princ "\nDone with file writing\n\n")
		)
	)
	(SetLin AppNam AppMode)
	(if (and DatLst DevMark)
		(setq	outs		(getvar "date")
				osecs	(* 86400.0 (- outs (fix outs)))
				elss		(itoa (fix (- (* osecs 1000.0) (* isecs 1000.0))))
				Bubba	(if (and Bug osecs) (princ (strcat "\nFinish: " (rtos osecs 2 2))))
				Bubba	(princ (strcat "\nElapsed Milliseconds for AddsUpGather: " elss))
		)
	)
	(princ)
)

(defun C:MakDatScr ( / )					; CL - Creates Script file to generate DAT files    
	(if (VerDwgDatMatch T)
		(princ "\nGot Positive Results!")
		(princ "\nGot Negative Results!")
	)
	(princ)
)

(defun C:DoIt ( / )						; CL - Runs the DoIt.Scr script file
	(if (findfile (strcat (getenv "TEMP") "\\DoIt.Scr"))
		(command "script" (findfile (strcat (getenv "TEMP") "\\DoIt.Scr")))
		(princ "\n*Error* - No DoIt Script File found...\n")
	)
	(princ)
)	

(defun VerDwgDatMatch ( MakFil /	DupLst DoLst	; Verifies Matchup of Data and Drawing files
							x Bubba Bubba1 Bubba2 Bubba3 Cntr
							) ; DwgLst SDwgLst DatLst SDatLst
	(setq	DwgLst	(dos_dir (strcat _Path-Panel "???????.dwg"))
			DatLst	(dos_dir (strcat _Path-Panel "Data\\???????.dat"))
			SDatLst	(dos_dir (strcat _Alt_Path-Panel "Data\\???????.dat"))
			DoLst	nil
			DupLst	nil
			MDwgLst	nil
			MDatLst	nil
	)
	(if DwgLst
		(setq	MDwgLst	(mapcar (quote (lambda (x) (substr x 1 (- (strlen x) 4)))) DwgLst))
	)
	(if DatLst
		(setq	MDatLst	(mapcar (quote (lambda (x) (substr x 1 (- (strlen x) 4)))) DatLst))
	)
	(if SDatLst
		(setq	SDatLst	(mapcar (quote (lambda (x) (substr x 1 (- (strlen x) 4)))) SDatLst))
	)
	(if Div
		(setq	SDwgLst	(GetShrLst Div DevMark))
	)
	(if DwgLst
		(princ (strcat "\nLocal Dwg Cnt:" (itoa (length DwgLst))))
	)
	(if SDwgLst
		(princ (strcat "\nShared Dwg Cnt:" (itoa (length SDwgLst))))
	)
	(if (and MDwgLst SDwgLst)
		(foreach	Dwg
				SDwgLst
				(if (not (member Dwg MDwgLst))
					(setq	MDwgLst	(cons Dwg MDwgLst))
				)
		)
	)
	(if (and MDatLst MDwgLst)
		(foreach	Dat
				MDatLst
				(if (not (member Dat MDwgLst))
					(princ (strcat "\nDat:{" Dat "} found without matching Dwg file!"))
				)
		)
	)
	(if (and MDatLst SDatLst)
		(foreach	Dat
				SDatLst
				(if (not (member Dat MDatLst))
					(setq	MDatLst	(cons Dat MDatLst))
				)
		)
	)
	(if MDwgLst
		(princ (strcat "\nTotal Dwg Cnt:" (itoa (length MDwgLst))))
	)
	(cond
		((and MDatLst MDwgLst)
			(foreach	Dwg
					MDwgLst
					(if (member Dwg MDatLst)
						(if DupLst
							(setq	DupLst	(cons Dwg DupLst))
							(setq	DupLst	(list Dwg))
						)
						(if DoLst
							(setq	DoLst	(cons Dwg DoLst)
									Bubba	(if Bug (princ (strcat "\n[Bug] No Dat for {" Dwg "} was found!")))
							)
							(setq	DoLst	(list Dwg)
									Bubba	(if Bug (princ (strcat "\n[Bug] No Dat for {" Dwg "} was found!")))
							)
						)
					)
			)
		)
		(MDwgLst
			(foreach	Dwg
					MDwgLst
					(if DoLst
						(setq	DoLst	(cons Dwg DoLst))
						(setq	DoLst	(list Dwg))
					)
			)
		)
	)
	(if DoLst
		(setq	Bubba	(princ (strcat "\nHave {" (itoa (length DoLst)) "} items for AddsUpAnalyze."))
				DoLst	(acad_strlsort DoLst)
		)
	)
	(if DupLst
		(if (= (length DwgLst) (length DupLst))
			(setq	Bubba	(princ (strcat "\nHave {" (itoa (length DupLst)) "} items in DAT format, all Drawings complete."))
					DupLst	(acad_strlsort DupLst)
			)
			(setq	Bubba	(princ (strcat "\nHave {" (itoa (length DupLst)) "} items in DAT format."))
					DupLst	(acad_strlsort DupLst)
			)
		)
	)
	(if (or (not sff) (not sf))
		(setq	sff		1000
				sf		(* sff 0.3048)
				Bubba	(setvar "LTScale" SFF)
				Bubba	(setvar "THICKNESS" SFF)
		)
	)
	(if (and MakFil DoLst)
		(if (< (length DoLst) 100)
			(setq	Bubba	(princ (strcat "\nMaking file:" (getenv "TEMP") "\\DoIt.Scr, works {" (itoa (length DoLst)) "} Panels.\nPlease run this script before continuing."))
					Bubba1	(open (strcat (getenv "TEMP") "\\DoIt.Scr") "w")
					Cntr		0
					Bubba2	(write-line (strcat "(StatLin 1 " (itoa (length DoLst)) ")") Bubba1)
					Bubba2	(mapcar	(quote (lambda (x)
										(write-line (strcat "(GetPan \"" x "\")") Bubba1)
										(if (and (> Cntr 0) (= (Mod Cntr 5) 0)) (write-line "(SavClosEm)" Bubba1))
	;;;									(write-line (strcat "(SavPan \"" (nth Cntr DoLst) "\" 4)") Bubba1)
										(write-line "(StatStep)" Bubba1)
										(setq	Cntr		(1+ Cntr))
									 ))
									 DoLst
							)
					Bubba2	(write-line "(SavClosEm)" Bubba1)
					Bubba2	(write-line "(setq Bubba (SetLin AppNam AppMode) Bubba1 nil)" Bubba1)
					Bubba2	(write-line "(RWav 10)" Bubba1)
					Bubba2	(write-line "(AddsExit)" Bubba1)
					Bubba3	(close Bubba1)
					Bubba	T
			)
			(setq	Bubba	(princ (strcat "\nMaking file:" (getenv "TEMP") "\\DoIt.Scr, works {" (itoa (length DoLst)) "} Panels.\nPlease run this script before continuing."))
					Bubba1	(open (strcat (getenv "TEMP") "\\DoIt.Scr") "w")
					Cntr		0
					Bubba2	(write-line (strcat "(StatLin 1 100)") Bubba1)
					Bubba2	(repeat	100
									(write-line (strcat "(GetPan \"" (nth Cntr DoLst) "\")") Bubba1)
									(if (and (> Cntr 0) (= (Mod Cntr 5) 0)) (write-line "(SavClosEm)" Bubba1))
;;;									(write-line (strcat "(SavPan \"" (nth Cntr DoLst) "\" 4)") Bubba1)
									(write-line "(StatStep)" Bubba1)
									(setq	Cntr		(1+ Cntr))
							)
					Bubba2	(write-line "(SavClosEm)" Bubba1)
					Bubba2	(write-line "(setq Bubba (SetLin AppNam AppMode) Bubba1 nil)" Bubba1)
					Bubba2	(write-line "(RWav 10)" Bubba1)
					Bubba2	(write-line "(AddsExit)" Bubba1)
					Bubba3	(close Bubba1)
					Bubba	T
			)
		)
	)
)

(defun GetSub ( / dlg lstSubCors index lstSubCor InList Dcl_Pan SbVal _sb Pos_Sb Sb_Loc)
	(if Bug (princ "\nPanel.lsp GetSub - Start\n"))
	(if (not Div)
		(alert (strcat "***" AppNam " Error***\nDiv not set!"))
	)
	(setq	dlg		2)
	(if (and Div (not Lst_Sb_XY))
		(progn
			(cond 
				((= Div "BH") (princ "\nGetting Birmingham Feeder coordinates data"))
				((= Div "W_") (princ "\nGetting Western Feeder coordinates data"))
				((= Div "E_") (princ "\nGetting Easter Feeder coordinates data"))
				((= Div "M_") (princ "\nGetting Mobile Feeder coordinates data"))
				((= Div "S_") (princ "\nGetting Southern Feeder coordinates data"))
				((= Div "SE") (princ "\nGetting Southeastern Feeder coordinates data"))
				((= Div "GA") (princ "\nGetting GCC Line coordinates data"))
				((= Div "AL") (princ "\nGetting ACC Line coordinates data"))
			)
			(if (null GetSubCor)
				(command "netload" "C:\\Div_Map\\Common\\Adds.dll")
			)
			;	Get all Feeder extents data for current division
			(setq lstSubCors (GetSubCor MyUsrInfo Div);"getsubcor" in adds.cs line 1006
				Lst_Sb_XY  (list)
				Lst_Sb_Nam (list)
			)
			(setq index 0)
			(repeat (length lstSubCors)
				(setq lstSubCor (nth index lstSubCors)
						index (+ index 1)
				)
				(setq	InList
					(list 
						(list (nth 0 lstSubCor) (nth 1 lstSubCor))
						(list (nth 2 lstSubCor) (nth 3 lstSubCor))
					)
					Lst_Sb_XY  (append Lst_Sb_XY (list	InList))
					Lst_Sb_Nam (append Lst_Sb_Nam (list(nth 4 lstSubCor)))
				)
			)

		)
	)
	;	Loads and displays Feeder selection dialog box.
	(if (and Lst_Sb_Nam)
		(if (setq Dcl_Pan (findfile (strcat _path-lisp "Adds.dcl")))
			(if (> (setq Dcl_Pan (load_dialog Dcl_Pan)) 0)
				(while (> dlg 1)
					(new_dialog "SbLstR" Dcl_Pan)
					(mode_tile "Lst1" 0)
					(start_list "Lst1" 3)
					(add_list " ")
					(mapcar (quote add_list) Lst_Sb_S)
					(end_list)
					(action_tile "Lst1" "(setq SbVal $value)")
					(setq dlg (start_dialog))
					(unload_dialog Dcl_Pan)
				)
				(alert "\nUnable to open DCL file")
			)
			(alert "\nUnable to find DCL file")
		)
	)
	;	Reacts to dialog box selection to load selected feeder.
	(if (= dlg 1)
		(progn
			(if Bug (princ (strcat "\nSbVal = " SbVal)))
			(if (and (not _sb) SbVal)
				(setq	_sb		(nth (1- (atoi SbVal)) Lst_Sb_V)
						Pos_Sb	(- (length Lst_Sb_Nam) (length (member _sb Lst_Sb_Nam)))
				)
			)
			(if Bug (princ (strcat "\n_sb = " _sb)))
			(if Pos_Sb
				(if (nth Pos_Sb Lst_Sb_XY)
					(setq	Sb_Loc	(nth Pos_Sb Lst_Sb_XY))
					(alert (strcat "***" AppNam " Error***\nPosition (" (itoa Pos_Sb) ") unpopulated!"))
				)
				(progn
					(setq	Sb_Loc	nil)
					(alert (strcat "***" AppNam " Error***\nPosition Variable unpopulated!"))
				)
			)
			(if Sb_Loc
				(GetWin (nth 0 Sb_Loc) (nth 1 Sb_Loc))
			)
			(Bld_SL)
		)
		(princ "\nOpen by Sub cancelled")
	)
	(if PanLst
		(if (not SF)
			(SclFactor)
		)
	)
	(princ)
)

(defun GetSub_Old ( _sb /	Pos_Sb SCNam Sn InData	; Loads Sub.COR for the current Division
					InList SbNam )
	(if (not Div)
		(alert (strcat "***" AppNam " Error***\nDiv not set!"))
	)
	(if Div
		(setq	SCNam	(findfile (strcat _Path-Panel "SUB.COR"))) ;Div
		(setq	SCNam	nil)
	)
	(setq	dlg		2)
	(if (and Div (not Lst_Sb_XY))
		(if SCNam
			(progn
				(cond	((= Div "BH") (princ "\nLoading Birmingham Sub.COR file"))
						((= Div "W_") (princ "\nLoading Western Sub.COR file"))
						((= Div "E_") (princ "\nLoading Eastern Sub.COR file"))
						((= Div "N_") (princ "\nLoading Northern Sub.COR file"))
						((= Div "S_") (princ "\nLoading Southern Sub.COR file"))
						((= Div "SE") (princ "\nLoading South-Eastern Sub.COR file"))
				)
				(setq	Sn			(open SCNam "r")
						InData		(read-line Sn)
				)
				(if InData
					(while InData
						(if InData
							(setq	InList	(list
												(list	(atof (substr InData 1 10))
														(atof (substr InData 11 10))
												)
												(list	(atof (substr InData 21 10))
														(atof (substr InData 31 10))
												)
											)
									SbNam	(substr InData 41)
							)
							(setq	InList	nil
									SbNam	nil
							)
						)
						(if (and InList SbNam)
							(setq	Lst_Sb_Nam	(append Lst_Sb_Nam (list SbNam))
									Lst_Sb_XY		(append Lst_Sb_XY (list InList))
							)
						)
						(setq InData (read-line Sn))
					)
				)
				(close Sn)
			)
			(alert (strcat "***" AppNam " Error***\nDiv (" Div ") .COR file not found!"))
		)
	)
	(if (and _sb Lst_Sb_Nam)
		(setq	Pos_Sb	(- (length Lst_Sb_Nam) (length (member _sb Lst_Sb_Nam))))
		(if (setq Dcl_Pan (findfile (strcat _path-lisp "Adds.dcl")))
			(if (> (setq Dcl_Pan (load_dialog Dcl_Pan)) 0)
				(while (> dlg 1)
					(new_dialog "SbLstR" Dcl_Pan)
					(mode_tile "Lst1" 0)
					(start_list "Lst1" 3)
					(add_list " ")
					(mapcar (quote add_list) Lst_Sb_S)
					(end_list)
					(action_tile "Lst1" "(setq SbVal $value)")
					(setq dlg (start_dialog))
					(unload_dialog Dcl_Pan)
				)
				(alert "\nUnable to open DCL file")
			)
			(alert "\nUnable to find DCL file")
		)
	)
	(if (= dlg 1)
		(progn
			(if Bug (princ (strcat "\nSbVal = " SbVal)))
			(if (and (not _sb) SbVal)
				(setq	_sb		(nth (1- (atoi SbVal)) Lst_Sb_V)
						Pos_Sb	(- (length Lst_Sb_Nam) (length (member _sb Lst_Sb_Nam)))
				)
			)
			(if Bug (princ (strcat "\n_sb = " _sb)))
			(if Pos_Sb
				(if (nth Pos_Sb Lst_Sb_XY)
					(setq	Sb_Loc	(nth Pos_Sb Lst_Sb_XY))
					(alert (strcat "***" AppNam " Error***\nPosition (" (itoa Pos_Sb) ") unpopulated!"))
				)
				(progn
					(setq	Sb_Loc	nil)
					(alert (strcat "***" AppNam " Error***\nPosition Variable unpopulated!"))
				)
			)
			(if Sb_Loc
				(GetWin (nth 0 Sb_Loc) (nth 1 Sb_Loc))
			)
			(Bld_SL)
		)
		(princ "\nOpen by Feeder cancelled")
	)
	(if PanLst
		(if (not SF)
			(SclFactor)
		)
	)
	(princ)
)

(defun LodPanelChg ( /	FNam2 FNamFil Cntr		; Loads Panel Change Log
					DivN PanN Scal Fdrs SvBy Date Time AdsU BrkP Inp_Lst Inp
					DivN_S PanN_S Scal_S Fdrs_S SvBy_S Date_S Time_S AdsU_S BrkP_S
					DivN_L PanN_L Scal_L Fdrs_L SvBy_L Date_L Time_L AdsU_L BrkP_L )
	(if DevMark
		(setq FNam2 (findfile "S:/Workgroups/APC Power Delivery/Division Mapping Test/Shared Panels/Data/PanelChg.Log"))
		(setq FNam2 (findfile "S:/Workgroups/APC Power Delivery/Division Mapping/Shared Panels/Data/PanelChg.Log"))
	)
	(if FNam2
		(progn
			(princ "\nLoading Data List...")
			(if FNam2
				(setq	FNamFil	(open FNam2 "r")
						Cntr	0
						DivN_S	2
						DivN_L	2
						PanN_S	13
						PanN_L	7
						Scal_S	30
						Scal_L	4
						Fdrs_S	43
						Fdrs_L	2
						SvBy_S	56
						SvBy_L	8
						Date_S	70
						Date_L	10
						Time_S	86
						Time_L	10
						AdsU_S	105
						AdsU_L	8
						BrkP_S	122
						BrkP_L	8
				)
				(setq	FNamFil	nil)
			)
			(if FNamFil
				(while	(setq	Inp		(read-line FNamFil))
					(if (not Bug)
						(Twizzle Cntr)
					)
					(if Inp
						(setq	DivN		(substr Inp DivN_S DivN_L)	;0
								PanN		(substr Inp PanN_S PanN_L)	;1
								Scal		(substr Inp Scal_S Scal_L)	;2
								Fdrs		(substr Inp Fdrs_S Fdrs_L)	;3
								SvBy		(substr Inp SvBy_S SvBy_L)	;4
								Date		(substr Inp Date_S Date_L)	;5
								Time		(substr Inp Time_S Time_L)	;6
								AdsU		(substr Inp AdsU_S AdsU_L)	;7
								BrkP		(substr Inp BrkP_S BrkP_L)	;8
								Inp_Lst	(list DivN PanN Scal Fdrs SvBy Date Time AdsU BrkP)
						)
						(setq	Inp_Lst		nil)
					)
					(if Inp_Lst
						(if PanelChgLst
							(setq	PanelChgLst	(cons Inp_Lst PanelChgLst))
							(setq	PanelChgLst	(list Inp_Lst))
						)
					)
					(setq	Cntr		(1+ Cntr))
				)
			)
			(if FNamFil
				(close FNamFil)
			)
			(if FNamFil
				(if (not Bug)
					(Twizzle (- 0 Cntr))
				)
			)
			(if FNamFil
				(if PanelChgLst
					(princ (strcat "\nLoaded {" (itoa (length PanelChgLst)) "} records into memory!\n"))
				)
			)
		)
	)
	PanelChgLst
)

(defun DspPanelChg ( DivIn / )				; Displays Panel Change Log
	(setq	Cntr		0
			NoCntr	0
			Bubba	(princ	(strcat	"\nDiv Panel   Scale Fdrs SaveBy   Date - Time"))
	)
	(if PanelChgLst
		(if DivIn
			(foreach	PanelChg
					PanelChgLst
					(if (= (car PanelChg) DivIn)
						(setq	Cntr		(1+ Cntr)
								Bubba	(princ	(strcat	"\n"
														(nth 0 PanelChg)
														"  "
														(nth 1 PanelChg)
														" "
														(nth 2 PanelChg)
														"  "
														(nth 3 PanelChg)
														"   "
														(nth 4 PanelChg)
														" "
														(nth 5 PanelChg)
														" - "
														(nth 6 PanelChg)
												)
										)
						)
						(setq	NoCntr		(1+ NoCntr))
					)
			)
			(foreach	PanelChg
					PanelChgLst
					(setq	Cntr		(1+ Cntr)
							Bubba	(princ	(strcat	"\n"
													(nth 0 PanelChg)
													"  "
													(nth 1 PanelChg)
													" "
													(nth 2 PanelChg)
													"  "
													(nth 3 PanelChg)
													"   "
													(nth 4 PanelChg)
													" "
													(nth 5 PanelChg)
													" - "
													(nth 6 PanelChg)
											)
									)
					)
			)
		)
	)
	(if DivIn
		(princ (strcat "\nDisplayed {" (itoa Cntr) "} records in Div [" DivIn "] with {" (itoa NoCntr) "} other panels not listed."))
		(princ (strcat "\nDisplayed {" (itoa Cntr) "} records."))
	)
	(princ)
)

(defun C:DspPanelChg ( / )					; CL - Displays Panel Change Log
	(LodPanelChg)
	(DspPanelChg Div)
	(princ)
)

(defun PanTypChk ( Pan / )					; Determines Panel Type for new Adds
	(princ "\n PanTypChk Pan: ") (prin1 Pan)
	(cond   ((member (strcase Pan) Lst_Sub_Fnm)	;	Checks to see if Substation Single Line diagram
		   		2
		   	)
		   	((= (substr Pan 1 3) "MS_" )
		   		2
		   	)
			((> (strlen Pan) 7)					;	Checks to see if other originally intended for URD's
				0
			)
			((wcmatch Pan "#######")				;	Checks to see if Geographical panel
				1
			)
		;	(( dos_filep (strcat _M_AltS-Panel Pan ".Dwg"))
		;		2
		;	)
			(T
				0
			)
	)
)

(defun LodPan ( /	Lck Cntr Bubba InsPt ssWas )	; loads panels into drawing
	(if Bug (princ "\n LodPan entered"))
	(setvar "LIMCHECK" 0)   ;--turn off limit-checking
	(princ "\n NewLst : ") (prin1 NewLst)
	(if (> (length NewLst) 0)
		(setq	Cntr		0
				PanNum	(length NewLst)
		)
	)
	(if (< (length PanLst) 1)
		(setq	PanTyp	nil)
	)
	(if (> (length NewLst) 0)
		(if (not PanTyp)
			(setq	PanTyp	(PanTypChk (Car NewLst)))
			(if (and (= PanTyp 1) (= (length PanLst) 0))
				(setq	PanTyp	(PanTypChk (Car NewLst)))
			)
		)
	)
	(if (= PanTyp 1)
		(SetLim (append NewLst PanLst))
		(setq	ObjMstDevLst	nil
				MstDevLst		nil
				ModMstDevLst	nil
				MyBigLst		nil
		)
	)
	(princ "\n PanTyp: ") (prin1 PanTyp)
	(while (< Cntr PanNum)
		(cond	((= PanTyp 1)				;if PanTyp = 1, then Geographic Panel
					(SubMenuSet nil)
					(setq	Pan		(nth Cntr NewLst)
							InsPt	(list	(* (atof (substr Pan 1 3)) 1000.0)
											(* (atof (substr Pan 4 4)) 1000.0)
											0.0
									)
							ssWas	(ssget "X"	(list	(cons 0 "INSERT")
														(cons 2 "LOCK")
														(cons 10 InsPt)
												)
									)
					)
					(if ssWas
						(progn
							(command "_.ERASE" ssWas "")
							(setq	ssWas	nil)
						)
					)
					(if (not (member Pan PanLst))
						(if (not (setq InUse (ChkLck Pan)))
							(if (or (dos_filep (strcat _Path-Panel      Pan ".Dwg"))
                                    				(dos_filep (strcat _M_Path-Panel    Pan ".Dwg"))
                                    				(dos_filep (strcat _N_AltP-Panel    Pan ".Dwg"))
								(dos_filep (strcat _ALT_PATH-PANEL  Pan ".Dwg"))
							)
								(progn
									(if (/= Div "AL")
										(command	"_.LAYER"
											"S"
											"----GRD---"
											""
											"INSERT"
											(strcat _Path-Sym "GRID") ;--Insert the panel box
											InsPt
											""
											""
											""
										)
										(command	"_.LAYER"
											"S"
											"----GRD---"
											""
											"INSERT"
											(strcat _Path-Sym "GRID") ;--Insert the panel box
											InsPt
											"10.0"
											""
											""
										)
									)
									(princ (strcat "\nAdding panel - " Pan))
									(cond 
										((dos_filep (strcat _Path-Panel Pan ".Dwg"))
											(setq	Bubba	(command "_.Insert" (strcat "*" _Path-Panel Pan) "0,0" "" "")
													Bubba	(LokPan Pan)
													LckFilNam	(strcat _Path-Panel "Locked\\" Pan ".Lck")
											)
										)
										((dos_filep (strcat _ALT_PATH-PANEL Pan ".Dwg"))
											(setq	Bubba	(command "_.Insert" (strcat "*" _ALT_PATH-PANEL Pan) "0,0" "" "")
													Bubba	(LokPan Pan)
													LckFilNam	(strcat _ALT_PATH-PANEL "Locked\\" Pan ".Lck")
											)
										)
										((dos_filep (strcat _M_Path-Panel Pan ".Dwg"))
											(setq	Bubba	(command "_.Insert" (strcat "*" _M_Path-Panel Pan) "0,0" "" "")
													Bubba	(LokPan Pan)
													LckFilNam	(strcat _M_Path-Panel "Locked\\" Pan ".Lck")
											)
										)
										((dos_filep (strcat _N_AltP-Panel Pan ".Dwg"))
											(setq	Bubba	(command "_.Insert" (strcat "*" _N_AltP-Panel Pan) "0,0" "" "")
													Bubba	(LokPan Pan)
													LckFilNam	(strcat _N_AltP-Panel "Locked\\" Pan ".Lck")
											)
										)
									)
									(if Bug
										(princ	(strcat	"\n[Bug]\tLckFilNam: {"	(if LckFilNam LckFilNam "NoName")
														"}\n\tFor Panel: {"		(if Pan Pan "NoName")
														"}\n\tAdds Username: {"	(if Adds_User Adds_User "NoName")
														"}\n\tLoginName: {"		(if (getvar "loginname") (strcase (getvar "loginname")) "NoName")
														"}\n\tOn Date: {"		(if (date_s) (date_s) "NoName")
														"}\n\tAt Time: {"		(if (time_s) (time_s) "NoName")
														"}\n"
												)
										)
									)
;;									(setq	PanLst	(cons Pan PanLst))
								)
								(princ (strcat "\n*** " AppNam " MESSAGE ***\n1-Panel drawing " _Path-Panel Pan ".Dwg was not found. "))
							)
							(progn
								(if (/= Div "AL")
										(command	"_.LAYER"
											"S"
											"----GRD---"
											""
											"INSERT"
											(strcat _Path-Sym "LOCK") ;--Insert the panel box
											(strcat (substr Pan 1 3) "000," (substr Pan 4) "000")
											""
											""
											""
											Pan
										)
										(command	"_.LAYER"
											"S"
											"----GRD---"
											""
											"INSERT"
											(strcat _Path-Sym "LOCK") ;--Insert the panel box
											(strcat (substr Pan 1 3) "000," (substr Pan 4) "000")
											"10.0"
											""
											""
											Pan
										)
									)
								(setq	Lck	(open InUse "r"))
								(princ (strcat "\n*** ADDS MESSAGE *** " (read-line Lck)))
								(close Lck)
							)
						) ;else, panel already active.
						(princ (strcat "\n*** ADDS MESSAGE *** Panel " Pan " is already active.  "))
					)
				)
				((= PanTyp 2)				;if PanTyp = 2, then Schematic Panel
					(if (> (length PanLst) 0)
						(progn
							(alert (strcat "*" AppNam " Warning*\nPanel Already Open - Please Close First"))
							(exit)
						)
						(SubMenuSet T)
					)
					(if (not (setq InUse (ChkLck Pan)))
						(if (dos_filep (strcat _M_AltS-Panel Pan ".Dwg"))
							(progn
								(command	"_.LAYER"
										"S"
										"----GRD---"
										""
								)
								(princ (strcat "\nAdding panel - " Pan))
								(cond 
									((dos_filep (strcat _M_AltS-Panel Pan ".Dwg"))
										(setq	Bubba	(command "_.Insert" (strcat "*" _M_AltS-Panel Pan) "0,0" "" "")
												Bubba	(LokPan Pan)
												LckFilNam	(strcat _M_AltS-Panel "Locked\\" Pan ".Lck")
										)
									)
								)
								(if Bug
									(princ	(strcat	"\n[Bug]\tLckFilNam: {"	(if LckFilNam LckFilNam "NoName")
													"}\n\tFor Panel: {"		(if Pan Pan "NoName")
													"}\n\tAdds Username: {"	(if Adds_User Adds_User "NoName")
													"}\n\tLoginName: {"		(if (getvar "loginname") (strcase (getvar "loginname")) "NoName")
													"}\n\tOn Date: {"		(if (date_s) (date_s) "NoName")
													"}\n\tAt Time: {"		(if (time_s) (time_s) "NoName")
													"}\n"
											)
									)
								)
;;								(setq	PanLst	(cons Pan PanLst))
							)
							(princ (strcat "\n*** " AppNam " MESSAGE ***\n2-Panel drawing " _M_AltS-Panel Pan ".Dwg was not found. "))
						)
						(progn
						;	(command	"_.LAYER"
						;			"S"
						;			"----GRD---"
						;			""
						;			"INSERT"
						;			(strcat _Path-Sym "LOCK") ;--Insert stamp showing area LOCKED
						;			"0,0"
						;			""
						;			""
						;			""
						;			Pan
						;	)
							(if (/= Div "AL")
										(command	"_.LAYER"
											"S"
											"----GRD---"
											""
											"INSERT"
											(strcat _Path-Sym "LOCK") ;--Insert the panel box
											"0,0"
											""
											""
											""
											Pan
										)
										(command	"_.LAYER"
											"S"
											"----GRD---"
											""
											"INSERT"
											(strcat _Path-Sym "LOCK") ;--Insert the panel box
											InsPt
											"10.0"
											""
											""
											Pan
										)
									)
							(setq	Lck	(open InUse "r"))
							(princ (strcat "\n*** ADDS MESSAGE *** " (read-line Lck)))
							(close Lck)
						)
					)
				)
				((= PanTyp 0)				;if PanTyp = 0, then other originally intended for URD's
					(if (> (length PanLst) 0)
						(progn
							(alert (strcat "*" AppNam " Warning*\nPanel Already Open - Please Close First"))
							(exit)
						)
					)
					(if (not (setq InUse (ChkLck Pan)))
						(progn
							(if (dos_filep (strcat _Path-Panel Pan ".Dwg"))	; was _M_AltS-Panel typ
								(progn
									(command	"_.LAYER"
											"S"
											"----GRD---"
											""
									)
									(princ (strcat "\nAdding panel - " Pan))
									(cond 
										((dos_filep (strcat _Path-Panel Pan ".Dwg"))
											(setq	Bubba	(command "_.Insert" (strcat "*" _Path-Panel Pan) "0,0" "" "")
													Bubba	(LokPan Pan)
													LckFilNam	(strcat _Path-Panel "Locked\\" Pan ".Lck")
											)
										)
									)
									(if Bug
										(princ	(strcat	"\n[Bug]\tLckFilNam: {"	(if LckFilNam LckFilNam "NoName")
														"}\n\tFor Panel: {"		(if Pan Pan "NoName")
														"}\n\tAdds Username: {"	(if Adds_User Adds_User "NoName")
														"}\n\tLoginName: {"		(if (getvar "loginname") (strcase (getvar "loginname")) "NoName")
														"}\n\tOn Date: {"		(if (date_s) (date_s) "NoName")
														"}\n\tAt Time: {"		(if (time_s) (time_s) "NoName")
														"}\n"
												)
										)
									)
	;;								(setq	PanLst	(cons Pan PanLst))
								)
								(progn
									(princ (strcat "\n*** " AppNam " MESSAGE ***\n3-Panel drawing " _Path-Panel Pan ".Dwg was not found. "))
									
								)
							)
						)
						(progn
						 ;	(command	"_.LAYER"
									"S"
						 ;			"----GRD---"
						 ;			""
						 ;			"INSERT"
						 ;			(strcat _Path-Sym "LOCK") ;--Insert stamp showing area LOCKED
						 ;			"0,0"
						 ;			""
						 ;			""
						 ;			""
						 ;			Pan
						 ;	)
							
							(if (/= Div "AL")
										(command	"_.LAYER"
											"S"
											"----GRD---"
											""
											"INSERT"
											(strcat _Path-Sym "LOCK") ;--Insert the panel box
											"0,0"
											""
											""
											""
											Pan
										)
										(command	"_.LAYER"
											"S"
											"----GRD---"
											""
											"INSERT"
											(strcat _Path-Sym "LOCK") ;--Insert the panel box
											InsPt
											"0,0"
											""
											""
											Pan
										)
									)
							
							(setq	Lck	(open InUse "r"))
							(princ (strcat "\n*** ADDS MESSAGE *** " (read-line Lck)))
							(close Lck)
						)
					)
				)
		)
		(setq	Cntr	(1+ Cntr))
	)
	(setq	NewLst	(list))
	(cond	((= PanTyp 1)
				(Bld_SL)
			)
			((= PanTyp 2)
				(setq	sff	500
						sf	(* sff 0.3048)
				)
				(setvar "LTScale" SFF)
				(setvar "THICKNESS" SFF)
				(command "_.Zoom" "E")
				(C:TS)
			)
			((= PanTyp 0)
				(setq	sff	100
						sf	(* sff 0.3048)
				)
				(setvar "LTScale" SFF)
				(setvar "THICKNESS" SFF)
				(command "_.Zoom" "E")
			)
	)
	(if (= mode "STARTUP")
		(calibr)
	)
	(command "_.UNDO" "C" "N" "_.UNDO" "ALL")
	(if Bug (princ "\n LodPan exited"))
	(princ)
)

(defun SubMenuSet ( Flag / Mstat )
	(if Flag
		(if (setq Mstat (menucmd "p1.5=?"))
			(if (= Mstat "")
				(progn
					(menucmd "p1.5=~")
					(menucmd "p1.6=~")
					(menucmd "p1.7=~")
					(menucmd "p1.8=~")
					(menucmd "p1.9=~")
					(menucmd "p1.12=~")
					(menucmd "p1.15=~")
				)
			)
		)
		(if (setq Mstat (menucmd "p1.5=?"))
			(if (/= Mstat "")
				(progn
					(menucmd "p1.5=")
					(menucmd "p1.6=")
					(menucmd "p1.7=")
					(menucmd "p1.8=")
					(menucmd "p1.9=")
					(menucmd "p1.12=")
					(menucmd "p1.15=")
				)
			)
		)
	)
)

(defun MakPan ( Pan / pt ptx pty Lck LogN )		; Builds Panel that didnt exist before
	(if (not Pan)
		(progn
			(initget 1)
			(setq	pt	(getpoint "\nPick a point in the panel you wish to create: \n"))
			(if pt
				(progn
					(setq	ptx		(* (fix (/ (car pt) XPanel)) XPanel)
							pty		(* (fix (/ (cadr pt) YPanel)) YPanel)
							Pan		(BldFn ptx pty)
					)
					(cond
						((member Pan PanLst)
							(princ (strcat "***" AppNam " Error***\nPanel {" Pan "} is already in use and cannot be created!"))
							(setq	Pan	nil)
						)
						((dos_filep (strcat _M_Path-Panel Pan ".Dwg"))
							(princ (strcat "***" AppNam " Error***\nPanel {" Pan "} already exists and cannot be created!"))
							(setq	Pan	nil)
						)
						((dos_filep (strcat _M_AltP-Panel Pan ".Dwg"))
							(princ (strcat "***" AppNam " Error***\nPanel {" Pan "} already exists as a Shared Panel and cannot be created!"))
							(setq	Pan	nil)
						)
						(T
							(princ (strcat "***" AppNam " Info***\nSelected Panel {" Pan "} will be created"))
						)
					)
				)
			)
		)
		(if (wcmatch Pan "#######")
			(cond
				((member Pan PanLst)
					(princ (strcat "***" AppNam " Error***\nPanel {" Pan "} is already in use and cannot be created!"))
					(setq	Pan	nil)
				)
				((dos_filep (strcat _M_Path-Panel Pan ".Dwg"))
					(princ (strcat "***" AppNam " Error***\nPanel {" Pan "} already exists and cannot be created!"))
					(setq	Pan	nil)
				)
				((dos_filep (strcat _M_AltP-Panel Pan ".Dwg"))
					(princ (strcat "***" AppNam " Error***\nPanel {" Pan "} already exists as a Shared Panel and cannot be created!"))
					(setq	Pan	nil)
				)
				(T
					(princ (strcat "***" AppNam " Info***\nSelected Panel {" Pan "} will be created"))
				)
			)
			(progn
				(princ (strcat "***" AppNam " Error***\nPanel value invalid - will not be created"))
				(setq	Pan	nil)
			)
		)
	)
	(if Pan
		(progn
			(if (/= Div "AL")
				(command	"_.LAYER"
					"S"
					"----GRD---"
					""
					"INSERT"
					(strcat _Path-Sym "GRID") ;--Insert the panel box
					(strcat
						(substr Pan 1 3)
						"000,"
						(substr Pan 4)
						"000"
					)
					""
					""
					""
				)
				(command	"_.LAYER"
					"S"
					"----GRD---"
					""
					"INSERT"
					(strcat _Path-Sym "GRID") ;--Insert the panel box
					(strcat
						(substr Pan 1 3)
						"000,"
						(substr Pan 4)
						"000"
					)
					"10.0"
					""
					""
				)
			)
			(setq	Bubba	(BldAttDef Pan))
			(if Bubba
				(progn
					(setq	ssLst	(ssadd (entlast)))
					(command "WBLOCK" (strcat _M_AltP-Panel Pan) "" "0,0" ssLst "" "N")
					(if (dos_filep (strcat _M_AltP-Panel Pan ".Dwg"))
						(progn
							(dos_copy (strcat _M_AltP-Panel Pan ".Dwg") (strcat _N_AltP-Panel Pan ".Dwg"))
							(dos_copy (strcat _M_AltP-Panel Pan ".Dwg") (strcat _Alt_Path-Panel Pan ".Dwg"))
						)
					)
					(setq	ssLst	nil)
					(LodPan Pan)
				)
			)
		)
	)
)

(defun ChkLck ( Panel /	InUse )				; Returns path to existing Lock file, if exists
	(if Bug (progn (princ "\nPanel.lsp!ChkLck - Entered Parameter: " )(prin1 Panel)))
	(cond
		((dos_filep (strcat _M_Path-Panel "Locked\\" Panel ".Lck"))		;Second location
			(setq	InUse	(strcat _M_Path-Panel "Locked\\" (car (dos_file (strcat _M_Path-Panel "Locked\\" Panel ".Lck")))))
		)
		((dos_filep (strcat _M_AltP-Panel "Locked\\" Panel ".Lck"))		;Shared Panels
			(setq	InUse	(strcat _M_AltP-Panel "Locked\\" (car (dos_file (strcat _M_AltP-Panel "Locked\\" Panel ".Lck")))))
		)
		((dos_filep (strcat _M_AltS-Panel "Locked\\" Panel ".Lck"))		;SubTools
			(setq	InUse	(strcat _M_AltS-Panel "Locked\\" (car (dos_file (strcat _M_AltS-Panel "Locked\\" Panel ".Lck")))))
		)
	)
	(if Bug (progn (princ "\nPanel.lsp!ChkLck - Done returned: " )(prin1 InUse)))
	InUse
)

(defun LokPan ( Pan / Lck LogN InUse )			; Creates Lock file for Panels in use
	(if Bug (progn (princ "\nPanel.lsp!LokPan - Entered Parameter: " )(prin1 Pan)))
	(if (not (member Pan PanLst))
		(if (not (setq InUse (ChkLck Pan)))
			(cond
				((dos_filep (strcat _M_AltP-Panel Pan ".Dwg"))	;Shared Panels
					(princ (strcat "\nLocking panel - " Pan))
					(setq	Lck	(open (strcat _M_AltP-Panel "Locked\\" Pan ".Lck") "w")
							LogN	(strcase (getvar "loginname"))
					)
					(princ (strcat "\nLogN:" LogN))
					(write-line (strcat "Panel " Pan " was LOCKED on " (date_s) " at " (time_s) " by " Adds_User " (" LogN ")") Lck)
					(close Lck)
					(if (dos_filep (strcat _M_AltP-Panel "Locked\\" Pan ".Lck"))
						(princ (strcat "\nLocked Shared {" Pan "} on Secondary Drive"))
						(princ (strcat "\nLock File creation *error* Shared {" Pan "} on Secondary Drive"))
					)
					(if (dos_filep (strcat _M_AltP-Panel "Locked\\" Pan ".Lck"))
						(dos_copy (strcat _M_AltP-Panel "Locked\\" Pan ".Lck") (strcat _N_AltP-Panel "Locked\\" Pan ".Lck"))
					)
					(if (dos_filep (strcat _N_AltP-Panel "Locked\\" Pan ".Lck"))
						(princ (strcat "\nLocked Shared {" Pan "} on Tertiary"))
						(princ (strcat "\nLock File creation *error* Shared {" Pan "} on Tertiary Drive"))
					)
					(if (dos_filep (strcat _M_AltP-Panel "Locked\\" Pan ".Lck"))
						(dos_copy (strcat _M_AltP-Panel "Locked\\" Pan ".Lck") (strcat _Alt_Path-Panel "Locked\\" Pan ".Lck"))
					)
					(if (dos_filep (strcat _Alt_Path-Panel "Locked\\" Pan ".Lck"))
						(princ (strcat "\nLocked Shared {" Pan "} on S Drive"))
					;	(princ (strcat "\nLock File creation *error* Shared {" Pan "} on S Drive"))
						(progn
							(setq msg (strcat "\nLock File creation *error* {" Pan "} on S Drive"))
							(princ msg)
							(alert (strcat msg "\nThis is a major problem!!! Contact Ed. \nDo you really want to proceed any further?"))
						)
					)
					(setq	PanLst	(cons Pan PanLst))
				)
				((dos_filep (strcat _M_AltS-Panel Pan ".Dwg"))
					(princ (strcat "\nLocking panel - " Pan))
					(setq	Lck	(open (strcat _M_AltS-Panel "Locked\\" Pan ".Lck") "w")
							LogN	(strcase (getvar "loginname"))
					)
					(princ (strcat "\nLogN:" LogN))
					(write-line (strcat "Panel " Pan " was LOCKED on " (date_s) " at " (time_s) " by " Adds_User " (" LogN ")") Lck)
					(close Lck)
					(if (dos_filep (strcat _M_AltS-Panel "Locked\\" Pan ".Lck"))
						(princ (strcat "\nLocked SubTool {" Pan "} on Secondary Drive"))
						(princ (strcat "\nLock File creation *error* SubTool {" Pan "} on Secondary Drive"))
					)
					(if (dos_filep (strcat _M_AltS-Panel "Locked\\" Pan ".Lck"))
						(dos_copy (strcat _M_AltS-Panel "Locked\\" Pan ".Lck") (strcat _N_AltS-Panel "Locked\\" Pan ".Lck"))
					)
					(if (dos_filep (strcat _N_AltS-Panel "Locked\\" Pan ".Lck"))
						(princ (strcat "\nLocked SubTool {" Pan "} on Tertiary Drive"))
						(princ (strcat "\nLock File creation *error* SubTool {" Pan "} on Tertiary Drive"))
					)
					(if (dos_filep (strcat _M_AltS-Panel "Locked\\" Pan ".Lck"))
						(dos_copy (strcat _M_AltS-Panel "Locked\\" Pan ".Lck") (strcat _AltSPath-Panel "Locked\\" Pan ".Lck"))
					)
					(if (dos_filep (strcat _AltSPath-Panel "Locked\\" Pan ".Lck"))
						(princ (strcat "\nLocked SubTool {" Pan "} on S Drive"))
					;	(princ (strcat "\nLock File creation *error* SubTool {" Pan "} on S Drive"))
						(progn
							(setq msg (strcat "\nLock File creation *error* SubTool {" Pan "} on S Drive"))
							(princ msg)
							(alert (strcat msg "\nThis is a major problem!!! Contact Ed. \nDo you really want to proceed any further?"))
						)
					)
					(setq	PanLst	(cons Pan PanLst))
				)
				((dos_filep (strcat _M_Path-Panel Pan ".Dwg"))
					(princ (strcat "\nLocking panel - " Pan))
					(setq	Lck	(open (strcat _M_Path-Panel "Locked\\" Pan ".Lck") "w")
							LogN	(strcase (getvar "loginname"))
					)
					(princ (strcat "\nLogN:" LogN))
					(write-line (strcat "Panel " Pan " was LOCKED on " (date_s) " at " (time_s) " by " Adds_User " (" LogN ")") Lck)
					(close Lck)
					(if (dos_filep (strcat _M_Path-Panel "Locked\\" Pan ".Lck"))
						(princ (strcat "\nLocked {" Pan "} on Secondary Drive"))
						(princ (strcat "\nLock File creation *error* {" Pan "} on Secondary Drive"))
					)
					
					(if (dos_filep (strcat _M_Path-Panel "Locked\\" Pan ".Lck"))
						(dos_copy (strcat _M_Path-Panel "Locked\\" Pan ".Lck") (strcat _N_Path-Panel "Locked\\" Pan ".Lck"))
					)
					(if (dos_filep (strcat _N_Path-Panel "Locked\\" Pan ".Lck"))
						(princ (strcat "\nLocked {" Pan "} on Tertiary Drive"))
						(princ (strcat "\nLock File creation *error* {" Pan "} on Tertiary Drive"))
					;	(progn
					;		(setq msg (strcat "\nLock File creation *error* {" Pan "} on Tertiary Drive"))
					;		(princ msg)
					;		(alert (strcat msg "\nThis is a major problem!!! Contact Ed. \nDo you really want to proceed any further?"))
					;	)
					)
					(if (dos_filep (strcat _M_Path-Panel "Locked\\" Pan ".Lck"))
						(dos_copy (strcat _M_Path-Panel "Locked\\" Pan ".Lck") (strcat _Path-Panel "Locked\\" Pan ".Lck"))
					)
					(if (dos_filep (strcat _Path-Panel "Locked\\" Pan ".Lck"))
						(princ (strcat "\nLocked {" Pan "} on S Drive"))
						(progn
							(setq msg (strcat "\nLock File creation *error* {" Pan "} on S Drive"))
							(princ msg)
							(alert (strcat msg "\nThis is a major problem!!! Contact Ed. \nDo you really want to proceed any further?"))
						)
					)
					(setq	PanLst	(cons Pan PanLst))
				)
				(T
					(alert "\n***ADDS Warning***\nPanel not found!")
				)
			)
			(alert "\n***ADDS Warning***\nPanel in Use!")
		)
		(alert "\n***ADDS Warning***\nPanel already loaded!")
	)
	(if Bug (progn (princ "\nPanel.lsp!LokPan - Done returned: " )(prin1 InUse)))
	InUse
)

(defun WBlkPanDwg ( Panel Tdata / AddsTempPath)			; Writes DWG files to Samba Share
	(setq	OldExpert  (getvar "EXPERT")
		OldNoMutt  (getvar "NOMUTT")
	)
    	(setq AddsTempPath "C:\\ProgramData\\AddsTemp\\Dwg\\")	;added 11feb15 karl (used in 9 places)
	(if Bug
		(progn
			(princ "\n[Bug] Panel.lsp!WBlkPanDwg - Enter Parameters:")
			(princ "\n  - Panel = ")(prin1 Panel)
			(princ "\n  - Tdata = ")(prin1 Tdata)(princ "\n")
		)
	)
	
	;	Cleanup log files remove ones older than 30 days [TODO] may want to move the block of code to an opening or closing function
	(setq 	logFiles	(dos_Filedate "C:\\Adds\\Logs\\*.log")
			baseDate	(getvar "CDate")
	)
	(foreach file  logFiles
		(if (< (cdr file) (- baseDate 31.0))
			(vl-file-delete (strcat "C:/Adds/Logs/" (car file)))
		)
	)
	
	(setq	MyLogFile		(open "C:\\Adds\\Logs\\AddsError.Log" "a"))
	
	(if (and _Path-Panel _M_Path-Panel)
		(cond
			((wcmatch (strcase (substr AppNam 1 4)) "ADDS")
				(cond
					((dos_filep (strcat _Path-Panel Panel ".Dwg"))				;	Standard Division Panel location if not a shared panel.
						(command)
						(command "_.WBLOCK" (strcat AddsTempPath  Panel) "" "0,0" Tdata "" "N")	;11feb15 karl
						(dos_pause 5);increased to five - 30dec14 - karl
						(setq 	LocalFile (strcat Panel ".Dwg")
							LocalPath  AddsTempPath 	;11feb15 karl
						)
						(setq flagSave1 (SavePanel LocalFile LocalPath _Path-Panel))
						(dos_pause 5)
						(if (and flagSave1 (dos_filep (strcat _Path-Panel LocalFile)))
							(progn
								(setq flagSave2 (SavePanel LocalFile LocalPath _M_Path-Panel))
								(dos_pause 5)
								(if (and flagSave2 (dos_filep (strcat _M_Path-Panel LocalFile)))
									(dos_delete (strcat AddsTempPath  Panel ".Dwg"));11feb15 karl
									(progn
										(setq msg (strcat (rtos (getvar "CDATE") 2 6)"\t -Adds was not able save to Secondary drive "  _M_Path-Panel Panel ".Dwg"))
										(write-line msg MyLogFile)
										(princ msg)
										(if flagSave2
											(alert msg)
										)
									)
								)
							;	(if (null (SavePanel LocalFile LocalPath _N_Path-Panel))		;	Save to thrid location
							;		(progn
							;			(setq msg (strcat (rtos (getvar "CDATE") 2 6)"\t -Adds was not able to save "  _N_Path-Panel Panel ".Dwg"))
							;			(write-line msg MyLogFile)
							;			(princ msg)
							;		)
							;	)
								
								(if Bug
									(setq	BugPan	(dos_file (strcat _Path-Panel Panel ".Dwg"))
											Bubba	(princ	(strcat	"\nWBBlkPanDwg Bug Pan:\t" Panel
																	"\nSize:\t" (rtos (nth 1 BugPan))
																	"\nDate:\t" (rtos (nth 2 BugPan) 2 4)
																	"\nPath:\t" (strcat _Path-Panel (nth 0 BugPan))
															)
													)
									)
								)
							)
							(progn
								(setq msg (strcat (rtos (getvar "CDATE") 2 6)"\t -Adds was not able save to Primary drive "  _Path-Panel Panel ".Dwg"))
								(write-line msg MyLogFile)
								(princ msg)
								(if flagSave1
									(alert msg)
								)
							)
						)
					)
					
					((dos_filep (strcat _Alt_Path-Panel Panel ".Dwg"))					;	Shared Panel Location
						(command)
						(command "_.WBLOCK" (strcat AddsTempPath  Panel) "" "0,0" Tdata "" "N")	;11feb15 karl
						(dos_pause 5);increased to five - 30dec14 - karl
						(setq 	LocalFile  (strcat Panel ".Dwg")
							LocalPath  AddsTempPath 									;11feb15 karl
						)
						(setq flagSave1 (SavePanel LocalFile LocalPath _Alt_Path-Panel))
						(dos_pause 5)
						(if (and flagSave1 (dos_filep (strcat _Alt_Path-Panel LocalFile)))
							(progn
								(setq flagSave2 (SavePanel LocalFile LocalPath _M_AltP-Panel))
								(dos_pause 5)
								(if (and flagSave2 (dos_filep (strcat _M_AltP-Panel LocalFile)))
									(dos_delete (strcat AddsTempPath  Panel ".Dwg"));11feb15 karl
									(progn
										(setq msg (strcat (rtos (getvar "CDATE") 2 6)"\t -Adds was not able save to Secondary drive "  _M_AltP-Panel Panel ".Dwg"))
										(write-line msg MyLogFile)
										(princ msg)
										(if flagSave2
											(alert msg)
										)
									)
								)
							
							;	(if (null (SavePanel LocalFile LocalPath _N_AltP-Panel))		;	Save to thrid location
							;		(progn
							;			(setq msg (strcat (rtos (getvar "CDATE") 2 6)"\t -Adds was not able to save "  _N_AltP-Panel Panel ".Dwg"))
							;			(write-line msg MyLogFile)
							;			(princ msg)
							;		)
							;	)
								
								(if Bug
									(setq	BugPan	(dos_file (strcat _Alt_Path-Panel Panel ".Dwg"))
											Bubba	(princ	(strcat	"\nWBBlkPanDwg Bug Pan:\t" Panel
																	"\nSize:\t" (rtos (nth 1 BugPan))
																	"\nDate:\t" (rtos (nth 2 BugPan) 2 4)
																	"\nPath:\t" (strcat _Alt_Path-Panel (nth 0 BugPan))
															)
													)
									)
								)
							)
							(progn
								(setq msg (strcat (rtos (getvar "CDATE") 2 6)"\t -Adds was not able save to Primary drive  "  _Alt_Path-Panel Panel ".Dwg"))
								(write-line msg MyLogFile)
								(princ msg)
								(if flagSave1
									(alert msg)
								)
							)
						)
					)
					
					((dos_filep (strcat _AltSPath-Panel Panel ".Dwg"))						;	Single Line Diagram / SubTools Location
						(command)
						(command "_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" "" ;t=thaw, U=unlock, S=set
								 "_.Zoom" "E" 
								 "_.Zoom" "0.8x"
						)
						(command)
						(command "_.WBLOCK" (strcat AddsTempPath  Panel) "" "0,0" Tdata "" "N")	;11feb15 karl
						(command)
						(dos_pause 5);increased to five - 30dec14 - karl
						(setq 	LocalFile  (strcat Panel ".Dwg")
							LocalPath  AddsTempPath 									;11feb15 karl
						)
						(setq flagSave1 (SavePanel LocalFile LocalPath _AltSPath-Panel))
						(dos_pause 5)
						(if (and flagSave1 (dos_filep (strcat _AltSPath-Panel LocalFile)))
							(progn
								(setq flagSave2 (SavePanel LocalFile LocalPath _M_AltS-Panel))
								(dos_pause 5)
								(if (and flagSave2 (dos_filep (strcat _M_AltS-Panel LocalFile)))
									(dos_delete (strcat AddsTempPath  Panel ".Dwg"));11feb15 karl
									(progn
										(setq msg (strcat (rtos (getvar "CDATE") 2 6)"\t -Adds was not able save to Secondary drive  "  _M_AltS-Panel Panel ".Dwg"))
										(write-line msg MyLogFile)
										(princ msg)
										(if flagSave2
											(alert msg)
										)
									)
								)
							
							;	(if (null (SavePanel LocalFile LocalPath _N_AltS-Panel))		;	Save to thrid location
							;		(progn
							;			(setq msg (strcat (rtos (getvar "CDATE") 2 6)"\t -Adds was not able to save "  _N_AltS-Panel Panel ".Dwg"))
							;			(write-line msg MyLogFile)
							;			(princ msg)
							;		)
							;	)
								
								(if Bug
									(setq	BugPan	(dos_file (strcat _AltSPath-Panel Panel ".Dwg"))
											Bubba	(princ	(strcat	"\nWBBlkPanDwg Bug Pan:\t" Panel
																	"\nSize:\t" (rtos (nth 1 BugPan))
																	"\nDate:\t" (rtos (nth 2 BugPan) 2 4)
																	"\nPath:\t" (strcat _AltSPath-Panel (nth 0 BugPan))
															)
													)
									)
								)
							)
							(progn
								(setq msg (strcat (rtos (getvar "CDATE") 2 6)"\t -Adds was not able save to Primary drive "  _AltSPath-Panel Panel ".Dwg"))
								(write-line msg MyLogFile)
								(princ msg)
								(if flagSave1
									(alert msg)
								)
							)
						)
					)
				)   
			)	; End of Adds condition test
			
			((wcmatch (strcase (substr AppNam 1 4)) "SUBT")
				(cond
					((dos_filep (strcat _M_Path-Panel Panel ".Dwg"))
						(command "WBLOCK" (strcat _M_Path-Panel Panel) "" "0,0" Tdata "" "N")
						(dos_copy (strcat _M_Path-Panel Panel ".Dwg") (strcat _N_Path-Panel Panel ".Dwg"))
						(dos_copy (strcat _M_Path-Panel Panel ".Dwg") (strcat _Path-Panel Panel ".Dwg"))
					)
				)
			)
		)
	)
	
	(if Bug
		(progn
			(princ "\n[Bug] Panel.lsp!WBlkPanDwg - Done")
		)
	)
	
	(if MyLogFile (close MyLogFile))
	(setvar "EXPERT" OldExpert)
	(setvar "NOMUTT" OldNoMutt)
	(princ)
)

(defun DelAllLck ( / CurPan )				; Deletes and Releases All Locks for Panels
	(if PanLst
		(foreach	CurPan
				PanLst
				(DelPanLck CurPan)
		)
		(princ "\nNo Panels to UnLock...")
	)
	(setq	PanLst	nil)
)

(defun DelPanLck ( Panel / ssLck )			; Deletes and Releases Locks for selected Panels
	(cond
		((wcmatch (strcase (substr AppNam 1 4)) "ADDS")
			(cond
				((dos_filep (strcat _M_Path-Panel "Locked\\" Panel ".Lck"))
					(if (dos_delete (strcat _M_Path-Panel "Locked\\" Panel ".Lck"))
						(princ (strcat "\nUnLocked {" Panel "} on Secondary Drive"))
						(princ (strcat "\nLock File removal *error* {" Panel "} on Secondary Drive"))
					)
					(if (dos_filep (strcat _N_Path-Panel "Locked\\" Panel ".Lck"))
						(if (dos_delete (strcat _N_Path-Panel "Locked\\" Panel ".Lck"))
							(princ (strcat "\nUnLocked {" Panel "} on Tertiary Drive"))
							(princ (strcat "\nLock File removal *error* {" Panel "} on Tertiary Drive"))
						)
					)
					(if (dos_filep (strcat _Path-Panel "Locked\\" Panel ".Lck"))
						(if (dos_delete (strcat _Path-Panel "Locked\\" Panel ".Lck"))
							(princ (strcat "\nUnLocked {" Panel "} on S Drive"))
							(princ (strcat "\nLock File removal *error* {" Panel "} on S Drive"))
						)
					)
					(setq	ssLck	(ssget "X" (list (cons 2 Panel))))
					(if ssLck
						(command "_.ERASE" ssLck "")
					)
					(setq	ssLck	nil)
					(setq	PanLst	(RemLst Panel PanLst))
				)
				((dos_filep (strcat _M_AltP-Panel "Locked\\" Panel ".Lck"))
					(if (dos_delete (strcat _M_AltP-Panel "Locked\\" Panel ".Lck"))
						(princ (strcat "\nUnLocked Shared {" Panel "} on Secondary Drive"))
						(princ (strcat "\nLock File removal *error* Shared {" Panel "} on Secondary Drive"))
					)
					(if (dos_filep (strcat _N_AltP-Panel "Locked\\" Panel ".Lck"))
						(if (dos_delete (strcat _N_AltP-Panel "Locked\\" Panel ".Lck"))
							(princ (strcat "\nUnLocked Shared {" Panel "} on Tertiary Drive"))
							(princ (strcat "\nLock File removal *error* Shared {" Panel "} on Tertiary Drive"))
						)
					)
					(if (dos_filep (strcat _Alt_Path-Panel "Locked\\" Panel ".Lck"))
						(if (dos_delete (strcat _Alt_Path-Panel "Locked\\" Panel ".Lck"))
							(princ (strcat "\nUnLocked Shared {" Panel "} on S Drive"))
							(princ (strcat "\nLock File removal *error* Shared {" Panel "} on S Drive"))
						)
					)
					(setq	ssLck	(ssget "X" (list (cons 2 Panel))))
					(if ssLck
						(command "_.ERASE" ssLck "")
					)
					(setq	ssLck	nil)
					(setq	PanLst	(RemLst Panel PanLst))
				)
				((dos_filep (strcat _M_AltS-Panel "Locked\\" Panel ".Lck"))
					(if (dos_delete (strcat _M_AltS-Panel "Locked\\" Panel ".Lck"))
						(princ (strcat "\nUnLocked SubTool {" Panel "} on Secondary Drive"))
						(princ (strcat "\nLock File removal *error* SubTool {" Panel "} on Secondary Drive"))
					)
					(if (dos_filep (strcat _N_AltS-Panel "Locked\\" Panel ".Lck"))
						(if (dos_delete (strcat _N_AltS-Panel "Locked\\" Panel ".Lck"))
							(princ (strcat "\nUnLocked SubTool {" Panel "} on Tertiary Drive"))
							(princ (strcat "\nLock File removal *error* SubTool {" Panel "} on Tertiary Drive"))
						)
					)
					(if (dos_filep (strcat _AltSPath-Panel "Locked\\" Panel ".Lck"))
						(if (dos_delete (strcat _AltSPath-Panel "Locked\\" Panel ".Lck"))
							(princ (strcat "\nUnLocked SubTool {" Panel "} on S Drive"))
							(princ (strcat "\nLock File removal *error* SubTool {" Panel "} on S Drive"))
						)
					)
					(setq	ssLck	(ssget "X" (list (cons 2 Panel))))
					(if ssLck
						(command "_.ERASE" ssLck "")
					)
					(setq	ssLck	nil)
					(setq	PanLst	(RemLst Panel PanLst))
				)
				(T
					(princ "\nLock File not found (Anywhere!)")
				)
			)
		)
		((wcmatch (strcase (substr AppNam 1 4)) "BEMS")
			(cond
				((dos_filep (strcat _M_Path-Panel "Locked\\" Panel ".Lck"))
					(if (dos_delete (strcat _M_Path-Panel "Locked\\" Panel ".Lck"))
						(princ (strcat "\nUnLocked BEMS {" Panel "} on Secondary Drive"))
						(princ (strcat "\nLock File removal *error* BEMS {" Panel "} on Secondary Drive"))
					)
					(if (dos_filep (strcat _N_Path-Panel "Locked\\" Panel ".Lck"))
						(if (dos_delete (strcat _N_Path-Panel "Locked\\" Panel ".Lck"))
							(princ (strcat "\nUnLocked BEMS {" Panel "} on Tertiary Drive"))
							(princ (strcat "\nLock File removal *error* BEMS {" Panel "} on Tertiary Drive"))
						)
					)
					(if (dos_filep (strcat _Path-Panel "Locked\\" Panel ".Lck"))
						(if (dos_delete (strcat _Path-Panel "Locked\\" Panel ".Lck"))
							(princ (strcat "\nUnLocked BEMS {" Panel "} on S Drive"))
							(princ (strcat "\nLock File removal *error* BEMS {" Panel "} on S Drive"))
						)
					)
				)
				(T
					(princ "\nLock File not found!")
				)
			)
		)
		((wcmatch (strcase (substr AppNam 1 4)) "SUBT")
			(cond
				((dos_filep (strcat _M_Path-Panel "Locked\\" Panel ".Lck"))
					(if (dos_delete (strcat _M_Path-Panel "Locked\\" Panel ".Lck"))
						(princ (strcat "\nUnLocked SubTool {" Panel "} on Secondary Drive"))
						(princ (strcat "\nLock File removal *error* SubTool {" Panel "} on Secondary Drive"))
					)
					(if (dos_filep (strcat _N_Path-Panel "Locked\\" Panel ".Lck"))
						(if (dos_delete (strcat _N_Path-Panel "Locked\\" Panel ".Lck"))
							(princ (strcat "\nUnLocked SubTool {" Panel "} on Tertiary Drive"))
							(princ (strcat "\nLock File removal *error* SubTool {" Panel "} on Tertiary Drive"))
						)
					)
					(if (dos_filep (strcat _Path-Panel "Locked\\" Panel ".Lck"))
						(if (dos_delete (strcat _Path-Panel "Locked\\" Panel ".Lck"))
							(princ (strcat "\nUnLocked SubTool {" Panel "} on S Drive"))
							(princ (strcat "\nLock File removal *error* SubTool {" Panel "} on S Drive"))
						)
					)
				)
				(T
					(princ "\nLock File not found!")
				)
			)
		)
	)
)

(defun C:LayBld ( / )						; Builds Style Sheets in Paperspace
	(if (not LstShtVal)
		(BldShtVal)
	)
	(setq	MstShtVal	(mapcar (quote (lambda (x) (list (substr (car x) 1 7) (substr (car x) 8 1)))) LstShtVal))
	(if (assoc (car PanLst) MstShtVal)
		(setq	PosNum	(- (length MstShtVal) (length (member (assoc (car PanLst) MstShtVal) MstShtVal)))
				PosCnt	(- (length (member (assoc (car PanLst) (reverse MstShtVal)) (reverse MstShtVal))) PosNum)
				CntR		0
		)
	)
	(if (and PosNum PosCnt)
		(if (> PosCnt 1)
			(while (< CntR PosCnt)
				(if (= CntR 0)
					(princ "\nSelect the LayOut to Build:\nNumber\tPanel\tSize\tReference ")
				)
				(princ (strcat "\n" (PadNum (itoa (1+ CntR)) 3) "\t=>\t" (nth 0 (nth (+ PosNum CntR) LstShtVal)) "\t" (nth 1 (nth (+ PosNum CntR) LstShtVal)) "\t" (nth 8 (nth (+ PosNum CntR) LstShtVal))))
				(setq	CntR	(1+ CntR))
			)
			(princ (strcat "\nSelected:" (PadNum (itoa (1+ CntR)) 3) "\t=>\t" (nth 0 (nth (+ PosNum CntR) LstShtVal)) "\t" (nth 1 (nth (+ PosNum CntR) LstShtVal)) "\t" (nth 8 (nth (+ PosNum CntR) LstShtVal))))
		)
	)
;	(initget 1 "")
	(if (> PosCnt 1)
		(progn
			(initget 1 "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z")
;;;			(setq	ShtSiz	(getkword "\nEnter the Sheet Size to match: "))
			(setq	ChzR	(getint "\nEnter number: "))
		)
		(setq	ChzR	1)
	)
	(if (= (type ChzR) (quote STR))
		(setq	ChzR		(- (ascii ChzR) 64))
	)
	(if (and (> ChzR 0) (<= ChzR PosCnt))
		(LodLayOut (cadr (nth (+ PosNum (1- ChzR)) MstShtVal)))
	)
)

(defun LodLayOut ( LayNum /	ShtNam Pan		; loads LayOuts into Paperspace of drawing
						ZSht ZTws ZPnt ZHgt ZRef ZHid ZLay ZCmd ViewD )
	(if Bug (princ "\n LodLayOut entered"))
	(if (not LstShtVal)
		(BldShtVal)
	)
	(setq	Pan		(car PanLst)
			ShtNam	(strcat Pan LayNum)
	)
	(if (assoc (strcase (strcat Pan LayNum)) LstShtVal)
		(setq	ZSht		(nth 1 (assoc (strcase (strcat Pan LayNum)) LstShtVal))
				ZTws		(nth 2 (assoc (strcase (strcat Pan LayNum)) LstShtVal))
				ZPnt		(nth 3 (assoc (strcase (strcat Pan LayNum)) LstShtVal))
				ZHgt		(nth 4 (assoc (strcase (strcat Pan LayNum)) LstShtVal))
				ZCmd		(Parse_Str2Lst (nth 5 (assoc (strcase (strcat Pan LayNum)) LstShtVal)))
				ZHid		(nth 6 (assoc (strcase (strcat Pan LayNum)) LstShtVal))
				ZLay		(nth 7 (assoc (strcase (strcat Pan LayNum)) LstShtVal))
				ZRef		(nth 8 (assoc (strcase (strcat Pan LayNum)) LstShtVal))
		)
	)
	(cond	((= ZSht "F")	(setq	FSht "ARCH_E1_(30.00_x_42.00_Inches)"))
			((= ZSht "E")	(setq	FSht "ARCH_E_(36.00_x_48.00_Inches)"))
			((= ZSht "D")	(setq	FSht "ARCH_D_(24.00_x_36.00_Inches)"))
			((= ZSht "C")	(setq	FSht "ARCH_C_(18.00_x_24.00_Inches)"))
			((= ZSht "B")	(setq	FSht "ANSI_B_(11.00_x_17.00_Inches)"))
			((= ZSht "A")	(setq	FSht "ANSI_A_(8.50_x_11.00_Inches)"))
			(T			(setq	FSht "ARCH_E_(36.00_x_48.00_Inches)"))
	)
	(setq	WellDid	(addMyLayout (list ShtNam "Acad_2.ctb" "XapVadrESheet.pc3" FSht nil nil nil nil nil)))
	(princ (strcat "\nAdding Panel Layout {" ShtNam "} to Panel {" Pan "}"))
	(cond 
		((dos_filep (strcat _M_AltS-Panel "LayOuts\\" Pan LayNum ".Dwg"))
			(command "_.Insert" (strcat "*" _M_AltS-Panel "LayOuts\\" Pan LayNum ".Dwg") "0,0" "1" "0")
		)
		(T
			(princ (strcat "\n*** " AppNam " MESSAGE ***\n4-Panel drawing " _M_AltS-Panel "LayOuts\\" Pan LayNum ".Dwg was not found. "))
		)
	)
	(if (not (LayChk "-20UCK-406"))
		(command	"_.Layer" "M" "-20UCK-406" "C" "6" "" "S" "-20UCK-406" "")     				;m=make, c=color, s=set current
		(command	"_.Layer" "T" "-20UCK-406" "ON" "-20UCK-406" "U" "-20UCK-406" "S" "-20UCK-406" "")	;t=thaw, u=unlock, s=set current
	)
	(if ViewPorter
		(setq	ViewD	(ViewPorter))
	)
	(if ViewD
		(progn
			(command "_.Erase" (handent (car ViewD)) "")
			(mapcar (quote command) ZCmd)
			(if (= ZTws "0")
				(command "_.MSpace" "UcsIcon" "On" "_.Zoom" "C" ZPnt ZHgt "_.PSpace")
				(command "_.MSpace" "UcsIcon" "On" "_.DView" "" "TW" ZTws "" "_.Zoom" "C" ZPnt ZHgt "_.PSpace")
			)
			(if (= ZHid "Y")
				(command	"_.Layer" "T" "0" "U" "0" "On" "0" "S" "0" "F" "-20UCK-406" "");t=thaw, u=unlock, s=set current, f=freeze
				(command	"_.Layer" "T" "0" "U" "0" "On" "0" "S" "0" "")
			)
			(if (> (strlen ZLay) 0)
				(command	"_.VPLayer" "F" ZLay "S" "L" "" "")
			)
		)
	)
	(if Bug (princ "\n LodLayOut exited"))
	(princ)
)

(setq	LodVer	"16.0.0")