(if AppNam								; Code Version Indicator {9540 Lines of Code}
	(princ (strcat "\n" AppNam " GetPoints Loading."))
	(princ "\nCadet 2.1 GetPoints Loading.")
)

(defun C:GetPoints ( / )					; Calls the GetPoints function
	(if Bug (princ "\n{C:GetPoints entered\n"))
	(if (not PLDname)
		(setq	PLDname	(getstring "\nEnter PldName for use: "))
	)
	(if (or (not PLDname) (< (strlen PLDname) 2))
		(setq	PLDname	(strcase (getvar "DWGNAME")))
	)
	(if (= (substr PLDname (- (strlen PLDname) 3)) ".DWG")
		(setq	PLDname		(substr PLDname 1 (- (strlen PLDname) 4)))
	)
	(GetPoints "VerKlmpt" PLDname)
	(if Bog (princ "\nC:GetPoints exited}\n"))
	(princ)
)

(defun GetPoints ( Dnam PanLNam / id place tfile	; PanLNam
							sid nl )
	(if Bug (princ "\n{GetPoints entered\n"))
	(setq	APID		"ID"
;			tfile	(open "S:/Workgroups/APC Power Delivery/Division Mapping/Shared Panels/Data/id_file.txt" "r")
;			tfile	(open "M:/DivData/Shared Panels/Data/id_file.txt" "r")
			tfile 	(open (strcat RootPathLst "Shared Panels\\Data\\id_file.txt") "r")
			sid		(atoi (read-line tfile))
			id		(itoa sid)
			UnkLst	(list "99999999")
			Bubba	(close tfile)
	)
	(if (not Dnam)
		(setq	Dnam	(strcase (getvar "DWGNAME")))
	)
	(if (= (substr Dnam (- (strlen Dnam) 3)) ".DWG")
		(setq	Dnam		(substr Dnam 1 (- (strlen Dnam) 4)))
	)
	(if (not DontKill)
		(if (findfile (strcat "c:/tmap40/" DNam ".txt"))
			(dos_delete (strcat "c:/tmap40/" DNam ".txt"))
		)
	)
	(if (null (tblsearch "APPID" APID))
		(regapp APID)
	)
	(setq	ssAllObjects		(ssget "X"	(list	(cons -4 "<AND")
													(cons 67 0)
													(cons -4 "<OR")
														(cons -4 "<AND")
															(cons 0 "*POLYLINE")
															(cons -4 "<OR")
																(cons 8 "????CK-???")
																(cons 8 "????FL-???")
																(cons 8 "DLG*")
															(cons -4 "OR>")
														(cons -4 "AND>")
														(cons -4 "<AND")
															(cons 0 "*TEXT")
															(cons 8 "*-LM-*")
														(cons -4 "AND>")
														(cons -4 "<AND")
															(cons 0 "INSERT")
															(cons -4 "<OR")
																(cons 2 "CAP")
																(cons 2 "REG")
																(cons 2 "FSO")
																(cons 2 "FSC")
																(cons 2 "GSO")
																(cons 2 "GSC")
																(cons 2 "KSO")
																(cons 2 "KSC")
																(cons 2 "ARROW")
																(cons 2 "FDR")
																(cons 2 "NSECTO")
																(cons 2 "NSECTC")
																(cons 2 "CS")
																(cons 2 "CS2")
																(cons 2 "CR")
																(cons 2 "_SS")
																(cons 2 "_SSR")
																(cons 2 "NEWSS")
																(cons 2 "DS")
																(cons 2 "DS2")
																(cons 2 "DR")
																(cons 2 "GS")
																(cons 2 "GS2")
																(cons 2 "GR")
																(cons 2 "RISER")
																(cons 2 "SMS")
																(cons 2 "SECT")
																(cons 2 "_SECT")
																(cons 2 "_OCR*")
																(cons 2 "RECL*")
																(cons 2 "NO")
																(cons 2 "MOGS")
																(cons 2 "SUB")
																(cons 2 "SUB2")
															(cons -4 "OR>")
														(cons -4 "AND>")
													(cons -4 "OR>")
												(cons -4 "AND>")
										)
							)
	)
	(setq	date2	(rtos (getvar "CDATE") 2 4)
			year2	(substr date2 3 2)
			month2	(substr date2 5 2)
			day2		(substr date2 7 2)
			hrs2		(substr date2 10 2)
			min2		(substr date2 12 2)
			date3	(strcat month2 "/" day2 "/20" year2)
			time2	(strcat hrs2 ":" min2)
			dtm		(strcat date3 " " time2)
			i		0
			MaxCnt	(sslength ssAllObjects)
			co		"0"
			f		(open (strcat "c:/tmap40/" DNam ".txt") "a")
	)
	(if ssAllObjects
		(princ (strcat "\nGetPoints is processing {" (itoa MaxCnt) "} items...\n"))
	)
	(if Bog
		(princ (strcat "\n\nStarting ID:" id "-" (itoa i)))
	)
	(while (< i (sslength ssAllObjects))										; LOOP THROUGH SELECTION SET A
		(setq	url		""
				ln_id	""
				pid		""
				num		""
				b		(entget (ssname ssAllObjects i) (list "ID"))
				lay		(cdr (assoc 8 b))
				hd		(cdr (assoc 5 b))
		)
		(if (/= nil (cdr (assoc -3 b)))
			(setq	id	(cdr (car (cdadr (assoc -3 b)))))
			(setq	id	"o")
		)
		(if (= "o" id)
			(setq	b		(entget (ssname ssAllObjects i))
					APID		"ID"
					xd		(list APID (cons 1000 (strcat "DG_" (itoa sid))))
					xd		(list -3 xd)
					Bubba	(entmod (append b (list xd)))
					Bubba	(entupd (cdr (assoc -1 b)))
					sid		(1+ sid)
					id		(strcat "DG_" (itoa sid))
					Bubba	(if Bog
								(princ (strcat ":" id "-" (itoa i)))
								(Twaddle i MaxCnt)
							)
			)
		)
		(if (not id)
			(setq	b		(entget (ssname ssAllObjects i))
					APID		"ID"
					xd		(list APID (cons 1000 (strcat "DG_" (itoa sid))))
					xd		(list -3 xd)
					Bubba	(entmod (append b (list xd)))
					Bubba	(entupd (cdr (assoc -1 b)))
					sid		(1+ sid)
					id		(strcat "DG_" (itoa sid))
					Bubba	(if Bog
								(princ (strcat ";" id "-" (itoa i)))
								(Twaddle i MaxCnt)
							)
			)
			(if (member id UnkLst)
				(setq	b		(entget (ssname ssAllObjects i))
						APID		"ID"
						Bubba	(princ (strcat "\nDuplicate on:" id "\n"))
						xd		(list APID (cons 1000 (strcat "DG_" (itoa sid))))
						xd		(list -3 xd)
						Bubba	(entmod (append b (list xd)))
						Bubba	(entupd (cdr (assoc -1 b)))
						sid		(1+ sid)
						id		(strcat "DG_" (itoa sid))
						Bubba	(if Bog
									(princ (strcat ";" id "-" (itoa i)))
									(Twaddle i MaxCnt)
								)
				)
				(setq	UnkLst	(cons id UnkLst))
			)
		)
		(setq	b	(entget (ssname ssAllObjects i) (list "PE_URL")))
		(if (/= nil (cdr (assoc -3 b)))
			(setq	url		(cdr (car (cdadr (assoc -3 b)))))
			(setq	url		(FormURL (ssname ssAllObjects i)))
		)
		(if (not url)
			(setq	url	"http://powerdelivery.southernco.com/apc/pds/methsys/")
		)
		(setq	b	(entget (ssname ssAllObjects i) (list "PLANT_ID")))
		(if (/= nil (cdr (assoc -3 b)))
			(setq	pid		(cdr (car (cdadr (assoc -3 b)))))
			(setq	pid		(substr lay 1 2))
		)
		(setq	b	(entget (ssname ssAllObjects i) (list "LINE_ID")))
		(if (/= nil (cdr (assoc -3 b)))
			(setq	ln_id	(cdr (car (cdadr (assoc -3 b)))))
			(if (> (strlen lay) 9)
				(setq	ln_id	(substr lay 4 7))
			)
		)
		(cond													; Set layers, colors and data layer
			((= lay "0")			(setq	lay	"0"	co	"215"))
			((= lay "12KV")		(setq	lay	"2"	co	"172"	dlay	"1"))
			((= lay "12KVD")		(setq	lay	"1"	co	"215"	dlay	"1"))
			((= lay "44KV")		(setq	lay	"4"	co	"185"	dlay	"3"))
			((= lay "44KVD")		(setq	lay	"3"	co	"215"	dlay	"3"))
			((= lay "46KV")		(setq	lay	"4"	co	"185"	dlay	"3"))
			((= lay "46KVD")		(setq	lay	"3"	co	"215"	dlay	"3"))
			((= lay "115KV")		(setq	lay	"6"	co	"204"	dlay	"5"))
			((= lay "115KVD")		(setq	lay	"5"	co	"215"	dlay	"5"))
			((= lay "161KV")		(setq	lay	"8"	co	"198"	dlay	"7"))
			((= lay "161KVD")		(setq	lay	"7"	co	"215"	dlay	"7"))
			((= lay "230KV")		(setq	lay	"10"	co	"5"		dlay	"9"))
			((= lay "230KVD")		(setq	lay	"9"	co	"215"	dlay	"9"))
			((= lay "500KV")		(setq	lay	"12"	co	"30"		dlay	"11"))
			((= lay "500KVD")		(setq	lay	"11"	co	"215"	dlay	"11"))
			((= lay "DIVLINE")		(setq	lay	"0"	co	"186"	dlay	"0"))
			((= lay "PAGE")		(setq	lay	"0"	co	"215"	dlay	"0"))
			((= lay "115_AEC")		(setq	lay	"6"	co	"172"	dlay	"5"))
			((= lay "115_AECD")		(setq	lay	"5"	co	"215"	dlay	"5"))
			((= lay "CAUTION")		(setq	lay	"0"	co	"186"	dlay	"0"))
			((= lay "KEY")			(setq	lay	"0"	co	"30"		dlay	"0"))
			((= lay "SCADA")		(setq	lay	"0"	co	"29"		dlay	"0"))
			((= lay "AEC115L")		(setq	lay	"5"	co	"172"	dlay	"6"))
			((= lay "AEC230L")		(setq	lay	"10"	co	"5"		dlay	"10"))
			((= lay "AECSUB3")		(setq	lay	"0"	co	"215"	dlay	"0"))
			((= lay "AECSUB6")		(setq	lay	"0"	co	"215"	dlay	"0"))
			((= lay "AECTEXT")		(setq	lay	"0"	co	"215"	dlay	"0"))
			((= lay "CITIES")		(setq	lay	"0"	co	"215"	dlay	"0"))
			((= lay "CROSSHAIR")	(setq	lay	"0"	co	"215"	dlay	"0"))
			((= lay "INSBORDR")		(setq	lay	"0"	co	"215"	dlay	"0"))
			((= lay "OPC115L")		(setq	lay	"5"	co	"172"	dlay	"6"))
			((= lay "OPC230L")		(setq	lay	"10"	co	"5"		dlay	"10"))
			((= lay "OPC500L")		(setq	lay	"12"	co	"30"		dlay	"12"))
			((= lay "PIPELINES")	(setq	lay	"5"	co	"172"	dlay	"00"))
			((= lay "SEPA")		(setq	lay	"0"	co	"212"	dlay	"0"))
			((= lay "SERCBORDR")	(setq	lay	"0"	co	"215"	dlay	"0"))
			((= lay "SERCFUTURE")	(setq	lay	"0"	co	"215"	dlay	"0"))
			((= lay "SERCLGND")		(setq	lay	"0"	co	"215"	dlay	"0"))
			((= lay "SERCTEXT")		(setq	lay	"0"	co	"215"	dlay	"0"))
			((= lay "SESBORDR")		(setq	lay	"0"	co	"215"	dlay	"0"))
			((= lay "SMEPA115")		(setq	lay	"5"	co	"172"	dlay	"0"))
			((= lay "SMEPA230")		(setq	lay	"10"	co	"5"		dlay	"0"))
			((= lay "SMEPASUB3")	(setq	lay	"0"	co	"215"	dlay	"0"))
			((= lay "SMEPASUB6")	(setq	lay	"0"	co	"215"	dlay	"0"))
			((= lay "SMEPATXT")		(setq	lay	"0"	co	"215"	dlay	"0"))
			((= lay "SMEPASUB6")	(setq	lay	"0"	co	"215"	dlay	"0"))
			((= lay "SOU115L")		(setq	lay	"5"	co	"204"	dlay	"0"))
			((= lay "SOU230L")		(setq	lay	"10"	co	"5"		dlay	"10"))
			((= lay "SOU500L")		(setq	lay	"12"	co	"30"		dlay	"0"))
			((= lay "SOUSUB3")		(setq	lay	"0"	co	"215"	dlay	"0"))
			((= lay "SOUSUB6")		(setq	lay	"0"	co	"215"	dlay	"0"))
			((= lay "SOUTEXT")		(setq	lay	"1"	co	"215"	dlay	"2"))
			((= lay "STATE")		(setq	lay	"5"	co	"172"	dlay	"0"))
			((= lay "WATER")		(setq	lay	"0"	co	"5"		dlay	"0"))
			((= lay "WATTEXT")		(setq	lay	"0"	co	"215"	dlay	"0"))
			((= lay "ZONES")		(setq	lay	"0"	co	"215"	dlay	"0"))
;;;			((= lay "--AOCK-020")		(setq	lay	"0"	co	"215"	dlay	"0"))
			((wcmatch lay "????CK-?04")		(setq	lay	"1"	co	"172"	dlay	"51"))
			((wcmatch lay "????CK-?12")		(setq	lay	"2"	co	"172"	dlay	"52"))
			((wcmatch lay "????CK-?13")		(setq	lay	"3"	co	"172"	dlay	"53"))
			((wcmatch lay "????CK-?23")		(setq	lay	"4"	co	"172"	dlay	"54"))
			((wcmatch lay "????CK-?25")		(setq	lay	"5"	co	"172"	dlay	"55"))
			((wcmatch lay "????CK-?35")		(setq	lay	"6"	co	"172"	dlay	"56"))
			((wcmatch lay "????CK-?44")		(setq	lay	"7"	co	"172"	dlay	"57"))
			((wcmatch lay "????CK-?15")		(setq	lay	"8"	co	"172"	dlay	"58"))
			((wcmatch lay "????CK-?61")		(setq	lay	"9"	co	"172"	dlay	"59"))
			((wcmatch lay "????CK-?30")		(setq	lay	"10"	co	"172"	dlay	"60"))
			((wcmatch lay "????CK-?00")		(setq	lay	"11"	co	"172"	dlay	"61"))
			((wcmatch lay "????????04")		(setq	lay	"21"	co	"172"	dlay	"81"))
			((wcmatch lay "????????12")		(setq	lay	"22"	co	"172"	dlay	"82"))
			((wcmatch lay "????????13")		(setq	lay	"23"	co	"172"	dlay	"83"))
			((wcmatch lay "????????23")		(setq	lay	"24"	co	"172"	dlay	"84"))
			((wcmatch lay "????????25")		(setq	lay	"25"	co	"172"	dlay	"85"))
			((wcmatch lay "????????35")		(setq	lay	"26"	co	"172"	dlay	"86"))
			((wcmatch lay "????????44")		(setq	lay	"27"	co	"172"	dlay	"87"))
			((wcmatch lay "????????15")		(setq	lay	"28"	co	"172"	dlay	"88"))
			((wcmatch lay "????????61")		(setq	lay	"29"	co	"172"	dlay	"89"))
			((wcmatch lay "????????30")		(setq	lay	"30"	co	"172"	dlay	"90"))
			((wcmatch lay "????????00")		(setq	lay	"31"	co	"172"	dlay	"91"))
			((wcmatch lay "????LM????")		(setq	lay	"41"	co	"172"	dlay	"46"))
			(T					(setq	lay	"0"	co	"215"	dlay	"0"))
		)
;;;Adds_Oracle_Update_Query
;;;IIf(Len([ADDS_LAYER_NAM])>9,IIf(((Mid$([ADDS_LAYER_NAM],5,2)='CK') Or (Mid$([ADDS_LAYER_NAM],5,2)='SW') Or (Mid$([ADDS_LAYER_NAM],5,2)='FL')),Switch(Mid$([ADDS_LAYER_NAM],9,2)='04',1,Mid$([ADDS_LAYER_NAM],9,2)='12',2,Mid$([ADDS_LAYER_NAM],9,2)='13',3,Mid$([ADDS_LAYER_NAM],9,2)='23',4,Mid$([ADDS_LAYER_NAM],9,2)='25',5,Mid$([ADDS_LAYER_NAM],9,2)='35',6,Mid$([ADDS_LAYER_NAM],9,2)='44',7,Mid$([ADDS_LAYER_NAM],9,2)='15',8),215),215)

		(setq	co	(itoa (cdr (assoc 62 (tblsearch "LAYER" (cdr (assoc 8 b)))))))
		(cond 
			((= co "1")	(setq	co	"186"))
			((= co "2")	(setq	co	"210"))
			((= co "3")	(setq	co	"24"))
			((= co "4")	(setq	co	"29"))
			((= co "5")	(setq	co	"10"))
			((= co "6")	(setq	co	"185"))
			((= co "7")	(setq	co	"215"))
			((= co "8")	(setq	co	"86"))
			((= co "9")	(setq	co	"216"))
			((= co "10")	(setq	co	"192"))
			((= co "14")	(setq	co	"72"))
			((= co "15")	(setq	co	"114"))
			((= co "20")	(setq	co	"198"))
			((= co "253")	(setq	co	"172"))
		)
		(cond 
			((= (cdr (assoc 62 b)) 1)	(setq	co	"186"))			; IF COLORS OTHER THAN BYLAYER
			((= (cdr (assoc 62 b)) 2)	(setq	co	"210"))
			((= (cdr (assoc 62 b)) 3)	(setq	co	"24"))
			((= (cdr (assoc 62 b)) 4)	(setq	co	"29"))
			((= (cdr (assoc 62 b)) 5)	(setq	co	"10"))
			((= (cdr (assoc 62 b)) 6)	(setq	co	"185"))
			((= (cdr (assoc 62 b)) 7)	(setq	co	"215"))
			((= (cdr (assoc 62 b)) 8)	(setq	co	"86"))
			((= (cdr (assoc 62 b)) 9)	(setq	co	"172"))
			((= (cdr (assoc 62 b)) 140)	(setq	co	"53"))
		)
		(cond
			;;;;;;;;;;;;;;;;;;;; PolyLine ;;;;;;;;;;;;;;;;;;;;
			((and	(= (cdr (assoc 0 b)) "LWPOLYLINE")					; IF ENTITY IS LWPOLYLINE and not on layer ZZZZ
					(/=  (cdr (assoc 8 b)) "ZZZZ")
			 )
				(setq	j		0
						ptlist	nil
				)
				(if (not url)
					(if (< (strlen url) 1)
						(setq	url		"file:s:\\WORKGR~1\\APCPOW~2\\ACCGEN~1\\personal\\hafling\\wire\\wire_r~1.xls")
					)
				)
				(while (< j (length b))								; LOOP ENTITY DATA
					(if (= (car (nth j b)) 10)						; LOOKING FOR XY
						(setq	xpt		(rtos (cadr (nth j b)))
								ypt		(rtos (caddr (nth j b)))
								pt		(strcat xpt ";" ypt)
								ptlist	(append (list pt) ptlist)	; ADD POINTS TO POINT LISP
						)
					)
					(setq	j	(1+ j))
				)
				(setq	count	(- (length ptlist) 1))				; SET COUNT TO INDEX INTO POINT LIST
				(while (> count 3)
					(setq	str	(strcat (nth count ptlist) ";" (nth (- count 1) ptlist) ";" (nth (- count 2) ptlist) ";" (nth (- count 3) ptlist)))
					(write-line	(strcat	id
										";"
										PanLNam
										";2;4;"
										lay
										";0;0;"
										co
										";0;0;"
										str
										";"
										ln_id
										";;0;"
										dtm
										";"
										url
										";;"
										num
										";"
										pid
										";"
										ln_id
										";"
								)
								f
					)
					(setq	count	(- count 3)
;;;							id		(itoa sid)
;;;							sid		(1+ sid)
					)
				)
				(cond											; < 4 POINTS IN THE POINT LIST
					((= count 3)	(setq	str	(strcat (nth 3 ptlist) ";" (nth 2 ptlist) ";" (nth 1 ptlist) ";" (nth 0 ptlist))))
					((= count 2)	(setq	str	(strcat (nth 2 ptlist) ";" (nth 1 ptlist) ";" (nth 0 ptlist) ";0;0")))
					((= count 1)	(setq	str	(strcat (nth 1 ptlist) ";" (nth 0 ptlist) ";0;0;0;0")))
				)
				(if (and (> count 0) (< count 4))
					(write-line	(strcat	id
										";"
										PanLNam;DNam
										";2;"
										(itoa (+ count 1))
										";"
										lay
										";0;0;"
										co
										";0;0;"
										str
										";"
										ln_id
										";;0;"
										dtm
										";"
										url
										";;"
										num
										";"
										pid
										";"
										ln_id
										";"
								)
								f
					)
				)
			)
			;;;;;;;;;;;;;;;;;;;; Line ;;;;;;;;;;;;;;;;;;;;
			((= (cdr (assoc 0 b)) "LINE")
				(setq	sptx		(rtos (cadr (assoc 10 b)))
						spty		(rtos (caddr (assoc 10 b)))
						eptx		(rtos (cadr (assoc 11 b)))
						epty		(rtos (caddr (assoc 11 b)))
						str		(strcat sptx ";" spty ";" eptx ";" epty ";0;0;0;0")
						Bubba	(write-line (strcat id ";" PanLNam ";2;2;" lay ";0;0;" co ";0;0;" str ";" ln_id ";;0;" dtm ";" url ";;" num ";" pid ";" ln_id ";") f)
				)
			)
			;;;;;;;;;;;;;;;;;;;; Insert ;;;;;;;;;;;;;;;;;;;;
			((and	(= (cdr (assoc 0 b)) "INSERT")
					(/= (cdr (assoc 8 b)) "ASHADE")
			 )
				(setq	sidstr	""
						num		""
						typ		""
						fnam		""
						ang		(itoa (fix (rtd (cdr (assoc 50 b)))))	; GET ANGLE  ang
						sc		(rtos (cdr (assoc 41 b)))			; SCALE  sc
						sym		(cdr (assoc 2 b))					; SYMBLE sym
						xpt		(rtos (cadr (assoc 10 b)))			; X
						ypt		(rtos (caddr (assoc 10 b)))
				)
				(cond  
;;;					((= sym "BKRO")	(setq sym "3010"))				; MAP SYMBOL TO SYM NUMBER
;;;					((= sym "BKRC")	(setq sym "3011"))
;;;					((= sym "SWO")		(setq sym "3113"))
;;;					((= sym "SWC")		(setq sym "3114"))
;;;					((= sym "MODO")	(setq sym "3117"))
;;;					((= sym "MODC")	(setq sym "3118"))
;;;					((= sym "TL")		(setq sym "3129"))
;;;					((= sym "SUB")		(setq sym "3133"))
;;;					((= sym "LA")		(setq sym "3207"))
;;;					((= sym "GROUND")	(setq sym "3208"))
;;;					((= sym "KNIFESW")	(setq sym "3210"))
;;;					((= sym "FUSE")	(setq sym "3064"))
;;;					((= sym "POT")		(setq sym "3212"))
;;;					((= sym "DS")		(setq sym "3216"))
;;;					((= sym "CONNECT")	(setq sym "3240"))
;;;					((= sym "GEN")		(setq sym "3250"))
;;;					((= sym "RN")		(setq sym "3903"))
;;;					((= sym "TRAP")	(setq sym "3906"))
;;;					((= sym "BUS")		(setq sym "3302"))
;;;					((= sym "LINE_ID")	(setq sym "3303"))
;;;					((= sym "BORDER")	(setq sym "3304"))
					((= sym "CAP")		(setq sym "3016"))
					((= sym "REG")		(setq sym "3089"))
					((= sym "FSO")		(setq sym "3111"))
					((= sym "FSC")		(setq sym "3112"))
					((= sym "GSO")		(setq sym "3113"))
					((= sym "GSC")		(setq sym "3114"))
					((= sym "KSO")		(setq sym "3243"))
					((= sym "KSC")		(setq sym "3210"))
					((= sym "ARROW")	(setq sym "3211"))
					((= sym "FDR")		(setq sym "3214"))
					((= sym "NSECTO")	(setq sym "3706"))
					((= sym "NSECTC")	(setq sym "3705"))
					((= sym "SUB")		(setq sym "3216"))
					((= sym "SUB2")	(setq sym "3216"))
					((wcmatch sym "_OCR*")		(setq sym "3702"))
					((wcmatch sym "RECL*")		(setq sym "3702"))
					((wcmatch sym "SECT,_SECT")	(setq sym "3705"))
					((wcmatch sym "MOGS")		(setq sym "3118"))
					;((wcmatch sym "SMS")		(setq sym "3210")) ;??
				)
				(if (= (cdr (assoc 66 b)) 1)
					(progn
						(setq	g	(entget (entnext (cdr (assoc -1 b))) (list "ID")))
						(while (= (cdr (assoc 0 g)) "ATTRIB")
							(setq	place	"")
							(cond
								((or (= (cdr (assoc 2 G)) "NUMBER")
									(= (cdr (assoc 2 G)) "OCR")
									(= (cdr (assoc 2 G)) "SECT#")
									(= (cdr (assoc 2 G)) "SUBSTATION")
								 )
															(setq	num		(cdr (assoc 1 g))
																	nhand	(cdr (assoc 5 g))
																	place	".1"
															)
								)
;;;								((or	(= (cdr (assoc 2 G)) "TYPE")
;;;									(= (cdr (assoc 2 G)) "KVCODE")
;;;								 )
;;;															(setq	typ		(cdr (assoc 1 g))
;;;																	place	".2"
;;;															)
;;;								)
;;;								((or	(= (cdr (assoc 2 G)) "UNIT_NO")
;;;									(= (cdr (assoc 2 G)) "SUBCODE")
;;;								 )
;;;															(setq	place	".3")
;;;								)
;;;								((= (cdr (assoc 2 G)) "SIZE")		(setq	place	".4"))	;ATTRIB'S HAVE ID OF SYMBOL WITH PLACE APPENDED
;;;								((or	(= (cdr (assoc 2 G)) "KVAR")
;;;									(= (cdr (assoc 2 G)) "RATING")
;;;								 )
;;;															(setq	place	".5")
;;;								)
;;;								((= (cdr (assoc 2 G)) "MVA")		(setq	place	".5"))
;;;								((= (cdr (assoc 2 G)) "FDR")		(setq	place	".6"))
;;;								((= (cdr (assoc 2 G)) "FAC_NAM")	(setq	place	".7"))
;;;								((= (cdr (assoc 2 G)) "SOURCE")	(setq	place	".8"))
;;;								((= (cdr (assoc 2 G)) "LOAD")		(setq	place	".9"))
;;;								((= (cdr (assoc 2 G)) "BYPASS")	(setq	place	".10"))
								(T							(setq	place	""))
							)
  							(if	(and	(/= (cdr (assoc 70 g)) 1)							;IF ATTRIBUTE IS VISIBLE
									(/= (cdr (assoc 2 g)) "LINE_ID")
									(> (strlen place) 1)
								)
								(progn
									(setq	handle	(cdr (assoc 5 g))
											height	(rtos (cdr (assoc 40 g)))			;GET ITS DATA
											tangle	(itoa (fix (rtd (cdr (assoc 50 g)))))
											x		(rtos (cadr (assoc 10 g)))
											y		(rtos (caddr (assoc 10 g)))
											str		(cdr (assoc 1 g))
											tangle	(itoa (* -1 (atoi tangle)))			;FIX ANGLE
											height	(rtos (* 1.75 (cdr (assoc 40 g))))		;SCALE TEXT BY 1.75
									)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PUT ID IN EXTENDED DATA FOR ATTRIBUTE
									(if (/= nil (cdr (assoc -3 g)))
										(setq	aid	(cdr (car (cdadr (assoc -3 g)))))
										(setq	aid	"o")								;PROBIBLY DON'T NEED THIS
									)												;COULD ALWAYS SET TO ID+PLACE
									(if (=  aid "o")									;BUT SAFER TO STORE ?????????
										(setq	g		(entget (cdr (assoc -1 g)))
												aid		(strcat id place)
												xd		(list APID (cons 1000 aid))
												xd		(list -3 xd)
												Bubba	(entmod (append g (list xd)))
										)
									)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;IF ATTRIBUTE STRING NOT NIL WRITE OUT AS TEXT
									(if (> (strlen str) 0)								
										(write-line	(strcat	aid
															";"
															PanLNam;DNam
															";0;1;"
															dlay
															";"
															tangle
															";"
															height
															";215;0;0;"
															x
															";"
															y
															";0;0;0;0;0;0;"
															str
															";;0;"
															dtm
															";"
															url
															";;"
															num
															";"
															pid
															";"
															ln_id
															";"
													)
													f
										)
									)
								)
							)
							(setq	g	(entget (entnext (cdr (assoc -1 g)))))		;GET NEXT ATTRIBUTE
						)													;end while attrib
					)
				)															;endif symbol has atts 
				(setq	cat	(strcat num "|" pid "|" ln_id)						;STRINGCAT number | plant_id | line_id FOR DATA DESC FOR SYMBOL
						ang	(itoa (* (atoi ang) -1))
				)															;FIX ANGLE
				(if (= sym "3906")												;SCALE TRAPS BY 0.5
					(setq	sc	(rtos (/ (atoi sc) 2)))							;TRAPS WERE BIG, GREEN and UGLY ???????
				)
;;;				(if (or (= sym "3216") (= sym "3133"))								;SET URL TO PLANT_LOCATION FOR VAULT SEARCH
;;;					(setq	url	(strcat "http://pdtweb.southernco.com/cgi-bin/get_dwg?locnum=" pid))
;;;				)
				(if (/= sym "3304")												;BORDER SYMBOL
					(write-line (strcat id ";" PanLNam ";1;1;" lay ";" ang ";" sc ";-1;" sym ";"sym ";" xpt ";" ypt ";0;0;0;0;0;0;" cat ";;0;" dtm ";" url ";;" num ";" pid ";" ln_id ";") f)
				)
			)
			;;;;;;;;;;;;;;;;;;;; Text ;;;;;;;;;;;;;;;;;;;;
			((and (= (cdr (assoc 0 b)) "TEXT") (/= (cdr (assoc 8 b)) "BORDER"))
				(setq	height	(rtos (cdr (assoc 40 b)))									;GET ITS DATA
						tangle	(itoa (fix (rtd (* -1 (cdr (assoc 50 b))))))
						x		(rtos (cadr (assoc 10 b)))
						y		(rtos (caddr (assoc 10 b)))
						str		(cdr (assoc 1 b))
						height	(rtos (* 1.75 (cdr (assoc 40 b))))								;SCALE TEXT BY 1.75
						Bubba	(write-line (strcat id ";" PanLNam ";0;1;" lay ";" tangle ";" height ";" co ";0;0;" x ";" y ";0;0;0;0;0;0;" str ";;0;" dtm ";" url ";;" num ";" pid ";" ln_id ";") f)
				)
			)
		)
		(setq	i	(1+ i))
	)
	(if (not Bog)
		(Twaddle (- 0 i) MaxCnt)
	)
	(close f)
;	(setq	tfile	(open "S:/Workgroups/APC Power Delivery/Division Mapping/Shared Panels/Data/id_file.txt" "w"))
;	(setq	tfile	(open "M:/DivData/Shared Panels/Data/id_file.txt" "w"))
	(setq 	tfile	(open (strcat RootPathLst "Shared Panels\\Data\\id_file.txt") "w"))

	(write-line (itoa sid) tfile)
	(close tfile)

	;	Cleanup
	(if ssAllObjects	(setq ssAllObjects	nil))
	(gc)
	
	(if Bog (princ "\nGetPoints exited}\n"))
	(princ)
)

(defun FormURL ( EntNam /	url fdrcode		; Builds URL to link to object
						SubDwg )
	(if (setq fdrcode (GetCode (entget EntNam)))						; get fdrcode of substation
		(progn
			(if Bug (princ (strcat "\nFdrCode: {" fdrcode "}\n")))
			(if (setq SubDwg (GetSubDwg fdrcode))					; lookup dwg name of fdrcode
				(setq	url	(strcat _Path-Sub SubDwg ".dwf"))
			)
		)
	)
)

(defun GetCode ( el /	Cnt blk xpt ypt lay ang	; Returns SubCode of object
					fud ss2 ent ent1 code )
	(if Bug (princ "\n{GetCode entered\n"))
	(setq	lay	(cdr (assoc 8 el))								; layer of block
;;;			blk	(cdr (assoc 2 el))
;;;			xpt	(rtos (cadr (assoc 10 el)) 2 0)					; insert of block
;;;			ypt	(rtos (caddr (assoc 10 el)) 2 0)
;;;			angr	(+ (cdr (assoc 50 el)) pi)						; rotation angle in radians + 180
;;;			fud	(* (/ (cdr (assoc 42 el)) 38.1)  1.1)				; a fudge factor based on scale of symbol
;;;			Cnt	0
;;;			flag	nil
	)
	(if (wcmatch (substr lay 1 2) "??")
		(setq	code		(substr lay 1 2))
;;;		(if (setq ss2 (ssget "f" (SubFence (atoi xpt) (atoi ypt) angr fud)))	; select based on a fence around sub block
;;;			(while (and (setq ent (ssname ss2 Cnt)) (not flag))			; loop till it runs out of entities
;;;				(setq	entl		(entget ent))
;;;				(if (= (substr (cdr (assoc 8 entl)) 5 2) "ck")			; must get a circuit
;;;					(setq	code	(substr (cdr (assoc 8 entl)) 1 2)		; get the sub code from the circuit
;;;							flag	T
;;;					)
;;;				)
;;;				(setq	Cnt	(1+ Cnt))
;;;			)
;;;		)
	)
	(if (and code Bug)
		(princ (strcat "\nGetCode got:{" code "}\n"))
		(if Bug (princ (strcat "\nGot No Code!{" lay "}\n")))
	)
	(if Bug (princ "\nGetCode exited}\n"))
	code
)

(defun GetSubDwg ( acode /	fp1 _STR _LST		; Returns SubTools drawing associated with object
						index dwgname )
	(if Bug (princ "\n{GetSubDwg entered\n"))
	(if (or (not Lst_Sub_Codes) (not Lst_Sub_Dwgs))
		(if (setq fp1 (open (strcat _Path-User "SubsDwg.txt") "r"))
			(progn
				(setq	Lst_Sub_Codes	nil
						Lst_Sub_Dwgs	nil
				)
				(while (setq _STR (read-line fp1))
					(setq	_LST		(read (strcat "(" _STR ")")))
					(if (>= (length _LST) 2)
						(setq	Lst_Sub_Codes	(append Lst_Sub_Codes (list (nth 0 _LST)))
								Lst_Sub_Dwgs	(append Lst_Sub_Dwgs (list (nth 1 _LST)))
						)
					)
				)
				(close fp1)
			)
			(alert (strcat "ERROR Opening: " _Path-User "SubsDwg.txt"))
		)
	)
	(if (member acode Lst_Sub_Codes)
		(setq	index	(- (length Lst_Sub_Codes) (length (member acode Lst_Sub_Codes)))
				dwgname	(nth index Lst_Sub_Dwgs)	;sub code has to be in the list 
		)
		(setq	dwgname	nil)	;was "default"
	)
	(if (and dwgname Bug)
		(princ (strcat "\nGetSubDwg got:{" dwgname "}\n"))
		(if Bug (princ "\nGot No SubDwg!\n"))
	)
	(if Bug (princ "\nGetSubDwg exited}\n"))
	dwgname
)

(defun C:FixNo ( / )						; CL - Fixes NO block inserts (conversion)
	(setq	nob	(ssget "X"	(list	(cons -4 "<OR")
										(cons 2 "NO")
										(cons 2 "NO_ISO")
										(cons 2 "NO_TRF")
									(cons -4 "OR>")
									(cons 0 "INSERT")
							)
				)
			ncnt	0
	)
	(if nob
		(while (setq e1 (ssname nob ncnt))
			(if e1
				(setq e2 (entget e1))
				(setq e2 nil)
			)
			(if e2
				(if No_Lst
					(setq No_Lst (cons (cdr (assoc 10 e2)) No_Lst))
					(setq No_Lst (list (cdr (assoc 10 e2))))
				)
			)
			(if e2
				(setq	ssAllObjects	(ssget "X"	(list	(cons -4 "<OR")
													(cons 2 "CS")
													(cons 2 "CS2")
													(cons 2 "DS")
													(cons 2 "DS2")
													(cons 2 "GS")
													(cons 2 "GS2")
													(cons 2 "CR")
													(cons 2 "DR")
													(cons 2 "GR")
													(cons 2 "_SSR")
													(cons 2 "_SS")
													(cons 2 "NEWSS")
												(cons -4 "OR>")
										)
							)
				)
			)
			(setq	ncnt		(1+ ncnt))
		)
	)
	;	Cleanup
	(if nob			(setq nob	nil))
	(if ssAllObjects	(setq ssAllObjects	nil))
	(gc)
	
)

(defun C:FixLay ( /	ssNObjects ncnt Bub		; Fixes Inserts with 13-character layers
					e1 e2 )
	(setq	ssNObjects		(ssget "X"	(list	(cons -4 "<AND")
													(cons 0 "INSERT")
													(cons 2 "[Aa]###,[Aa]###[Ss]")
													(cons 8 "????????????[ABCDEFGHIJKLMNO]")
													(cons 67 0)
												(cons -4 "AND>")
										)
							)
			ncnt	0
	)
	(if ssNObjects
		(princ (strcat "\nFixing {" (itoa (sslength ssNObjects)) "} Inserts."))
	)
	(if ssNObjects
		(while (setq e1 (ssname ssNObjects ncnt))
			(if e1
				(setq	e2	(entget e1))
				(setq	e2	nil)
			)
			(if e2
				(setq	e2	(subst (cons 8 (substr (cdr (assoc 8 e2)) 1 10)) (assoc 8 e2) e2)
						Bub	(entmod e2)
						Bub	(princ ".")
				)
			)
			(setq	ncnt		(1+ ncnt))
		)
	)
	(if ssNObjects
		(princ "Complete!")
	)
	(if ssNObjects
		(ChngUm nil ssNObjects)
	)
	;	Cleanup
	(if ssNObjects		(setq ssNObjects	nil))
	(gc)
	
	(princ)
)

(defun C:FindUm ( / )						; Selects objects for output
	(if Bog (princ "\n{C:FindUm entered\n"))
	(setvar "ATTREQ" 0)
	;(command "Convert" "P" ""); MAKE PLINES LWPLINES
	(setq	ssAllObjects	(ssget "X"	(list	(cons -4 "<OR")
												(cons 2 "CS")
												(cons 2 "CS2")
												(cons 2 "DS")
												(cons 2 "DS2")
												(cons 2 "GS")
												(cons 2 "GS2")
												(cons 2 "CR")
												(cons 2 "DR")
												(cons 2 "GR")
												;(cons 2 "CAP")
												(cons 2 "_SSR")
												(cons 2 "_SS")
												(cons 2 "NEWSS")
												(cons 2 "RISER")
												(cons 2 "SMS")
												;(cons 2 "MOGS")
												(cons 2 "SECT")
												(cons 2 "_SECT")
												(cons 2 "RECL*")
											(cons -4 "OR>")
									)
						)
	)
	(setq	i	0
			co	"0"
	)
	(if ssAllObjects
		(princ (strcat "\nFindUm is converting {" (itoa (sslength ssAllObjects)) "} blocks...\n"))
	)
	(while (< i (sslength ssAllObjects))												;LOOP THROUGH SELECTION SET A
		(setq	b	(entget (ssname ssAllObjects i) (list "ID"))
				lay	(cdr (assoc 8 b))										;LAYER
				pt	(cdr (assoc 10 b))										;POINT
				sc	(cdr (assoc 41 b))										;SCALE
				ang	(rtd (cdr (assoc 50 b)))									;ANGLE
				oc	nil
		)
		(if (/= nil (cdr (assoc -3 b)))
			(setq	id	(cdr (car (cdadr (assoc -3 b)))))
		)
		(setq	b	(entget (ssname ssAllObjects i) (list "PE_URL")))
		(if (/= nil (cdr (assoc -3 b)))
			(setq	url		(cdr (car (cdadr (assoc -3 b)))))
		)
		(setq	b	(entget (ssname ssAllObjects i) (list "PLANT_ID")))
		(if (/= nil (cdr (assoc -3 b)))
			(setq	pid		(cdr (car (cdadr (assoc -3 b)))))
		)
		(setq	b	(entget (ssname ssAllObjects i) (list "LINE_ID")))
		(if (/= nil (cdr (assoc -3 b)))
			(setq	ln_id	(cdr (car (cdadr (assoc -3 b)))))
		)
    	(if (= (cdr (assoc 66 b)) 1)											;IF SYMBOL HAS ATTRIBS
			(progn                      
				(setq	c	(entget (entnext (cdr (assoc -1 b)))))
				(while (= (cdr (assoc 0 c)) "ATTRIB")
					(if	(or	(= (cdr (assoc 2 c)) "SWITCH")					;BOTH SWITCH AND RISER CONTAIN NUMBER
							(= (cdr (assoc 2 c)) "RISER")
							(= (cdr (assoc 2 c)) "SECT#")
							(= (cdr (assoc 2 c)) "NUMBER")
							(= (cdr (assoc 2 c)) "OCR")
						)
						(setq	num	(cdr (assoc 1 c))
								Apt	(cdr (assoc 11 c))
								Apt2	(cdr (assoc 10 c))
								Aang	(cdr (assoc 50 c))
								Aht	(* (cdr (assoc 40 c)) 0.75)
								Alay	(cdr (assoc 8 c))
						)
					)
					(if (= (cdr (assoc 2 c)) "DRESSING")
						(setq	oc	(cdr (assoc 1 c)))
					)
					(if (= (cdr (assoc 2 c)) "CAPACITOR")
						(setq	nam	(cdr (assoc 1 c))
								Apt	(cdr (assoc 11 c))
								Apt2	(cdr (assoc 10 c))
								Aang	(cdr (assoc 50 c))
								Aht	(* (cdr (assoc 40 c)) 0.75)
								Alay	(cdr (assoc 8 c))
						)
					)
					(if	(or	(= (cdr (assoc 2 c)) "KVAR")
							(= (cdr (assoc 2 c)) "SIZE")
							(= (cdr (assoc 2 c)) "FUSE")
							(= (cdr (assoc 2 c)) "AMP")
							(= (cdr (assoc 2 c)) "AMPS")
							(= (cdr (assoc 2 c)) "AMP_OCR")
						)
						(setq	siz	(cdr (assoc 1 c))
								Apt	(cdr (assoc 11 c))
								Apt2	(cdr (assoc 10 c))
								Aang	(cdr (assoc 50 c))
								Aht	(* (cdr (assoc 40 c)) 0.75)
								Alay	(cdr (assoc 8 c))
						)
					)
					(if	(or	(= (cdr (assoc 2 c)) "SOURCE")
							(= (cdr (assoc 2 c)) "SW1")
						)
						(setq	src	(cdr (assoc 1 c))
								Apt	(cdr (assoc 11 c))
								Apt2	(cdr (assoc 10 c))
								Aang	(cdr (assoc 50 c))
								Aht	(* (cdr (assoc 40 c)) 0.75)
								Alay	(cdr (assoc 8 c))
						)
					)
					(if	(or	(= (cdr (assoc 2 c)) "TYPE")
							(= (cdr (assoc 2 c)) "TYPE_OCR")
							(= (cdr (assoc 2 c)) "RTU")
						)
						(setq	typ	(cdr (assoc 1 c))
								Apt	(cdr (assoc 11 c))
								Apt2	(cdr (assoc 10 c))
								Aang	(cdr (assoc 50 c))
								Aht	(* (cdr (assoc 40 c)) 0.75)
								Alay	(cdr (assoc 8 c))
						)
					)
					(if	(= (cdr (assoc 2 c)) "BYPASS")
						(setq	byp	(cdr (assoc 1 c))
								Apt	(cdr (assoc 11 c))
								Apt2	(cdr (assoc 10 c))
								Aang	(cdr (assoc 50 c))
								Aht	(* (cdr (assoc 40 c)) 0.75)
								Alay	(cdr (assoc 8 c))
						)
					)
					(if	(or	(= (cdr (assoc 2 c)) "LOAD")
							(= (cdr (assoc 2 c)) "SW2")
						)
						(setq	lod	(cdr (assoc 1 c))
								Apt	(cdr (assoc 11 c))
								Apt2	(cdr (assoc 10 c))
								Aang	(cdr (assoc 50 c))
								Aht	(* (cdr (assoc 40 c)) 0.75)
								Alay	(cdr (assoc 8 c))
						)
					)
					(setq	c	(entget (entnext (cdr (assoc -1 c)))))
				)
				(if oc
					(cond
						((= (strcase oc) "N.O.")
							(setq	oc	"NO")
						)
						((= (strcase oc) "NO")
							(setq	oc	"NO")
						)
						((wcmatch (strcase oc) "NORMAL O*")
							(setq	oc	"NO")
						)
						((wcmatch (strcase oc) "NORMAL C*")
							(setq	oc	"NC")
						)
						((= (strcase oc) "N.C.")
							(setq	oc	"NC")
						)
						((= (strcase oc) "NC")
							(setq	oc	"NC")
						)
						(T
							(setq	oc	"NC")
						)
					)
					(if (member (cdr (assoc 2 b)) (list "NEWSS" "_SS" "GS" "GS2" "CS" "CS2" "DS2" "DS" "SMS" "_SECT" "SECT"))
						(setq	oc	"NC")	;;; Todo: Process No_Lst for proximity to switch
						(setq	oc	"NC")
					)
				)
			)
		)
		(cond  
			((and (= oc "NC") (= (cdr (assoc 2 b)) "CS"))		(setq	dev	(strcat _Path-Sym "FSC")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "CS"))		(setq	dev	(strcat _Path-Sym "FSO")))
			((and (= oc "NC") (= (cdr (assoc 2 b)) "CS2"))		(setq	dev	(strcat _Path-Sym "FSC")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "CS2"))		(setq	dev	(strcat _Path-Sym "FSO")))
			((and (= oc "NC") (= (cdr (assoc 2 b)) "_SSR"))		(setq	dev	(strcat _Path-Sym "FSC")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "_SSR"))		(setq	dev	(strcat _Path-Sym "FSO")))
			((and (= oc "NC") (= (cdr (assoc 2 b)) "_SS"))		(setq	dev	(strcat _Path-Sym "FSC")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "_SS"))		(setq	dev	(strcat _Path-Sym "FSO")))
			((and (= oc "NC") (= (cdr (assoc 2 b)) "NEWSS"))		(setq	dev	(strcat _Path-Sym "FSC")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "NEWSS"))		(setq	dev	(strcat _Path-Sym "FSO")))
			((and (= oc "NC") (= (cdr (assoc 2 b)) "DS"))		(setq	dev	(strcat _Path-Sym "KSC")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "DS"))		(setq	dev	(strcat _Path-Sym "KSO")))
			((and (= oc "NC") (= (cdr (assoc 2 b)) "DS2"))		(setq	dev	(strcat _Path-Sym "KSC")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "DS2"))		(setq	dev	(strcat _Path-Sym "KSO")))
			((and (= oc "NC") (= (cdr (assoc 2 b)) "GS"))		(setq	dev	(strcat _Path-Sym "GSC")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "GS"))		(setq	dev	(strcat _Path-Sym "GSO")))
			((and (= oc "NC") (= (cdr (assoc 2 b)) "GS2"))		(setq	dev	(strcat _Path-Sym "GSC")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "GS2"))		(setq	dev	(strcat _Path-Sym "GSO")))
			((and (= oc "NC") (= (cdr (assoc 2 b)) "CR"))		(setq	dev	(strcat _Path-Sym "FSC")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "CR"))		(setq	dev	(strcat _Path-Sym "FSO")))
			((and (= oc "NC") (= (cdr (assoc 2 b)) "GR"))		(setq	dev	(strcat _Path-Sym "GSC")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "GR"))		(setq	dev	(strcat _Path-Sym "GSO")))

			((and (= oc "NC") (= (cdr (assoc 2 b)) "MOGS"))		(setq	dev	(strcat _Path-Sym "GSC")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "MOGS"))		(setq	dev	(strcat _Path-Sym "GSO")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "SMS"))		(setq	dev	(strcat _Path-Sym "NSECTO")))
			((and (= oc "NC") (= (cdr (assoc 2 b)) "SMS"))		(setq	dev	(strcat _Path-Sym "NSECTC")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "SECT"))		(setq	dev	(strcat _Path-Sym "NSECTO")))
			((and (= oc "NC") (= (cdr (assoc 2 b)) "SECT"))		(setq	dev	(strcat _Path-Sym "NSECTC")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "_SECT"))		(setq	dev	(strcat _Path-Sym "NSECTO")))
			((and (= oc "NC") (= (cdr (assoc 2 b)) "_SECT"))		(setq	dev	(strcat _Path-Sym "NSECTC")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "RECL"))		(setq	dev	(strcat _Path-Sym "_OCR")))
			((and (= oc "NC") (= (cdr (assoc 2 b)) "RECL"))		(setq	dev	(strcat _Path-Sym "_OCR")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "RECLBP"))		(setq	dev	(strcat _Path-Sym "_OCR_BP")))
			((and (= oc "NC") (= (cdr (assoc 2 b)) "RECLBP"))		(setq	dev	(strcat _Path-Sym "_OCR_BP")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "RECLBP_2"))	(setq	dev	(strcat _Path-Sym "_OCR_BP")))
			((and (= oc "NC") (= (cdr (assoc 2 b)) "RECLBP_2"))	(setq	dev	(strcat _Path-Sym "_OCR_BP")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "RECLEL"))		(setq	dev	(strcat _Path-Sym "_OCR_EL")))
			((and (= oc "NC") (= (cdr (assoc 2 b)) "RECLEL"))		(setq	dev	(strcat _Path-Sym "_OCR_EL")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "RECLEL_2"))	(setq	dev	(strcat _Path-Sym "_OCR_EL")))
			((and (= oc "NC") (= (cdr (assoc 2 b)) "RECLEL_2"))	(setq	dev	(strcat _Path-Sym "_OCR_EL")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "RECLEL_3"))	(setq	dev	(strcat _Path-Sym "_OCR_EL")))
			((and (= oc "NC") (= (cdr (assoc 2 b)) "RECLEL_3"))	(setq	dev	(strcat _Path-Sym "_OCR_EL")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "RECLEL_4"))	(setq	dev	(strcat _Path-Sym "_OCR_EL")))
			((and (= oc "NC") (= (cdr (assoc 2 b)) "RECLEL_4"))	(setq	dev	(strcat _Path-Sym "_OCR_EL")))
			((and (= oc "NO") (= (cdr (assoc 2 b)) "RECLEL_5"))	(setq	dev	(strcat _Path-Sym "_OCR_EL")))
			((and (= oc "NC") (= (cdr (assoc 2 b)) "RECLEL_5"))	(setq	dev	(strcat _Path-Sym "_OCR_EL")))

			((= (cdr (assoc 2 b)) "DR")						(setq	dev	(strcat _Path-Sym "KSC")))
			((= (cdr (assoc 2 b)) "CAP")						(setq	dev	(strcat _Path-Sym "CAP")
																ang	(+ ang 90)))
			((= (cdr (assoc 2 b)) "RISER")					(setq	dev	(strcat _Path-Sym "FDR")))
		)
		(entdel (cdr (assoc -1 b)))
		(setq	cmdEch	(getvar "CMDECHO"))
		(setvar "CMDECHO" 0)
		(if (< sc 0)
			(setq	pt	(polar pt (dtr (- ang 0)) (/ sc 2)))
			(setq	pt	(polar pt (dtr ang)(/ sc 2)))
		)
		(if (or (= (cdr (assoc 2 b)) "CR") (= (cdr (assoc 2 b)) "DR") (= (cdr (assoc 2 b)) "GR"))
			(setq	Bubba	(command "insert" (strcat _Path-Sym "arrow") pt sc sc ang)
					sc		(/ sc 2)
					pt		(polar pt (dtr (- ang 180)) (/ sc 2))
			)
			(setq	skip		nil)
		)
		(command "_.Insert" dev pt sc sc ang)
		(setvar "CMDECHO" cmdEch)
		(setq	c	(entget (entlast)))
		(setq	c	(subst (cons 8 lay) (assoc 8 c) c))
		(entmod c)
		(setq	APID		"ID"
				xd		(list APID (cons 1000 id))
				xd		(list -3 xd)
				Bubba	(entmod (append c (list xd)))
				Bubba	(entmod (append c (list xd)))
				APID		"PLANT_ID"
				xd		(list APID (cons 1000 pid))
				xd		(list -3 xd)
				Bubba	(entmod (append c (list xd)))
				APID		"LINE_ID"
				xd		(list APID (cons 1000 ln_id))
				xd		(list -3 xd)
				Bubba	(entmod (append c (list xd)))
				Bubba	(entupd (cdr (assoc -1 c)))
		)
		(if url
			(setq	APID		"PE_URL"
					xd		(list APID (cons 1000 url))
					xd		(list -3 xd)
			)
		)
;;;		(if (not nam)
;;;			(setq	nam	"UNK")
;;;			(if (< (strlen nam) 1)
;;;				(setq	nam	"UNK")
;;;			)
;;;		)
;;;		(if (not siz)
;;;			(setq	siz	"UNK")
;;;			(if (< (strlen siz) 1)
;;;				(setq	siz	"UNK")
;;;			)
;;;		)
;;;		(if (not num)
;;;			(setq	num	"UNK")
;;;			(if (< (strlen num) 1)
;;;				(setq	num	"UNK")
;;;			)
;;;		)
;;;		(if (not src)
;;;			(setq	src	"UNK")
;;;			(if (< (strlen src) 1)
;;;				(setq	src	"UNK")
;;;			)
;;;		)
;;;		(if (not typ)
;;;			(setq	typ	"UNK")
;;;			(if (< (strlen typ) 1)
;;;				(setq	typ	"UNK")
;;;			)
;;;		)
;;;		(if (not byp)
;;;			(setq	byp	"UNK")
;;;			(if (< (strlen byp) 1)
;;;				(setq	byp	"UNK")
;;;			)
;;;		)
;;;		(if (not lod)
;;;			(setq	lod	"UNK")
;;;			(if (< (strlen lod) 1)
;;;				(setq	lod	"UNK")
;;;			)
;;;		)
		(if nam
			(if (< (strlen nam) 1)
				(setq	nam	nil)
			)
		)
		(if siz
			(if (< (strlen siz) 1)
				(setq	siz	nil)
			)
		)
		(if num
			(if (< (strlen num) 1)
				(setq	num	nil)
			)
		)
		(if src
			(if (< (strlen src) 1)
				(setq	src	nil)
			)
		)
		(if typ
			(if (< (strlen typ) 1)
				(setq	typ	nil)
			)
		)
		(if byp
			(if (< (strlen byp) 1)
				(setq	byp	nil)
			)
		)
		(if lod
			(if (< (strlen lod) 1)
				(setq	lod	nil)
			)
		)
		(if (= (cdr (assoc 66 c)) 1)
			(progn                                    
				(setq	d	(entget (entnext (cdr (assoc -1 c)))))
				(while (= (cdr (assoc 0 d)) "ATTRIB")
					(if	(and	(or	(= (cdr (assoc 2 d)) "NUMBER")
								(= (cdr (assoc 2 d)) "SECT#")
							)
							num
						)
						(setq	d	(subst (cons 1 num) (assoc 1 d) d)
								d	(subst (cons 8 alay) (assoc 8 d) d)
								d	(subst (cons 11 Apt) (assoc 11 d) d)
								d	(subst (cons 10 Apt2) (assoc 10 d) d)
								d	(subst (cons 40 Aht) (assoc 40 d) d)
								d	(subst (cons 50 Aang) (assoc 50 d) d)
						)
					)
					(if (and (= (cdr (assoc 2 d)) "SIZE") siz)
						(if (or (wcmatch dev (strcat _Path-Sym "_OCR*")) (wcmatch dev (strcat _Path-Sym "NSECT*")))
							(setq	apt	(polar pt (dtr ang) 75)
									d	(subst (cons 1 siz) (assoc 1 d) d)
									d	(subst (cons 8 alay) (assoc 8 d) d)
									d	(subst (cons 11 Apt) (assoc 11 d) d)
									d	(subst (cons 10 Apt2) (assoc 10 d) d)
									d	(subst (cons 40 Aht) (assoc 40 d) d)
									d	(subst (cons 50 0) (assoc 50 d) d)
							)
						)
					)
					(if (and (= (cdr (assoc 2 d)) "SIZE") nam)
						(if (and (not (wcmatch dev (strcat _Path-Sym "_OCR*"))) (not (wcmatch dev (strcat _Path-Sym "NSECT*"))))
							(setq	apt	(polar pt (dtr ang) 75)
									d	(subst (cons 1 nam) (assoc 1 d) d)
									d	(subst (cons 8 alay) (assoc 8 d) d)
									d	(subst (cons 11 Apt) (assoc 11 d) d)
									d	(subst (cons 10 Apt2) (assoc 10 d) d)
									d	(subst (cons 40 Aht) (assoc 40 d) d)
									d	(subst (cons 50 0) (assoc 50 d) d)
							)
						)
					)
					(if	(and	(or	(= (cdr (assoc 2 d)) "KVAR")
								(= (cdr (assoc 2 d)) "AMPS")
							)
							siz
						)
						(setq	d	(subst (cons 1 siz) (assoc 1 d) d)
								d	(subst (cons 8 alay) (assoc 8 d) d)
								d	(subst (cons 11 (polar Apt (dtr 270) 20)) (assoc 11 d) d)
								d	(subst (cons 10 (polar Apt2 (dtr 270) 20)) (assoc 10 d) d)
								d	(subst (cons 40 Aht) (assoc 40 d) d)
								d	(subst (cons 50 0) (assoc 50 d) d)
						)
					)
					(if (and (= (cdr (assoc 2 d)) "SOURCE") src)
						(setq	d	(subst (cons 1 src) (assoc 1 d) d)
								d	(subst (cons 8 alay) (assoc 8 d) d)
								d	(subst (cons 11 Apt) (assoc 11 d) d)
								d	(subst (cons 10 Apt2) (assoc 10 d) d)
								d	(subst (cons 40 Aht) (assoc 40 d) d)
								d	(subst (cons 50 Aang) (assoc 50 d) d)
						)
					)
					(if (and (= (cdr (assoc 2 d)) "TYPE") typ)
						(setq	d	(subst (cons 1 typ) (assoc 1 d) d)
								d	(subst (cons 8 alay) (assoc 8 d) d)
								d	(subst (cons 11 Apt) (assoc 11 d) d)
								d	(subst (cons 10 Apt2) (assoc 10 d) d)
								d	(subst (cons 40 Aht) (assoc 40 d) d)
								d	(subst (cons 50 Aang) (assoc 50 d) d)
						)
					)
					(if (and (= (cdr (assoc 2 d)) "BYPASS") byp)
						(setq	d	(subst (cons 1 byp) (assoc 1 d) d)
								d	(subst (cons 8 alay) (assoc 8 d) d)
								d	(subst (cons 11 Apt) (assoc 11 d) d)
								d	(subst (cons 10 Apt2) (assoc 10 d) d)
								d	(subst (cons 40 Aht) (assoc 40 d) d)
								d	(subst (cons 50 Aang) (assoc 50 d) d)
						)
					)
					(if (and (= (cdr (assoc 2 d)) "LOAD") lod)
						(setq	d	(subst (cons 1 lod) (assoc 1 d) d)
								d	(subst (cons 8 alay) (assoc 8 d) d)
								d	(subst (cons 11 Apt) (assoc 11 d) d)
								d	(subst (cons 10 Apt2) (assoc 10 d) d)
								d	(subst (cons 40 Aht) (assoc 40 d) d)
								d	(subst (cons 50 Aang) (assoc 50 d) d)
						)
					)
					(entmod d)
					(entupd (cdr (assoc -1 d)))
					(setq	d	(entget (entnext (cdr (assoc -1 d)))))
				)
			)
		)
		(entupd (cdr (assoc -1 b)))
		(setq	i	(1+ i))
	)																	;end ss LOOP BACK FOR NEXT ENTITY IN SELECTION SET
	
	;	Cleanup
	(if ssAllObjects	(setq ssAllObjects	nil))
	(gc)
	
	(if Bog (princ "\nC:FindUm exited}\n"))
	(princ)
)

(defun c:IDDUMP (/ apid i s id b xd g)			; Dumps Unique_IDs
	(if Bog (princ "\n{c:IDDUMP entered\n"))
	(setq	APID	"ID")
	(setq	s	(ssget))													; GET A SELECTION SET
	(setq	i	0)
	(while (< i (sslength s))												; LOOP THROUGH SELECTION SET
		(setq	id	"o")
		(setq	b	(entget (ssname s i)))
		(setq	xd	(list APID (cons 1000 id)))
		(setq	xd	(list -3 xd))
		(entmod (append b (list xd)))
		(if (= (cdr (assoc 66 b)) 1)
			(progn
				(setq	g	(entget (entnext (cdr (assoc -1 b)))))				; NEED TO DUMP XDATA FOR ATTS
				(while (= (cdr (assoc 0 g)) "ATTRIB")
					(entmod (append g (list xd)))
					(setq	g	(entget (entnext (cdr (assoc -1 g)))))
				)														; endwhile attrib
			)
		)																; endif attributes
		(entupd (cdr (assoc -1 b)))
		(setq i (+ 1 i))
	)																	; endss
	
	;	Cleanup
	(if s	(setq s	nil))
	(gc)
	
	(if Bog (princ "\nc:IDDUMP exited}\n"))
	(princ)
)

(defun C:ChngUm ( / )						; CL - Changes/Updates EED info for EMB
	(if Bug (princ "\n{C:ChngUm entered\n"))
	(ChngUm T nil)
	(if Bug (princ "\nC:ChngUm exited}\n"))
	(princ)
)

(defun C:ChngSum ( / ssi Ent1 Cntr )			; CL - Changes/Updates EED info for Selection Set
	(if Bug (princ "\n{ C:ChngSum entered\n"))
	(setq	Bubba	(princ "\nSelect Object to Force Update on:")
			ssi		(ssget)
	)
	(if ssi
		(progn
			(setq	Cntr		0
					Ent1		(ssname ssi Cntr)
			)
			(while Ent1
				(ChngUm T Ent1)
				(if (< Cntr (sslength ssi))
					(setq	Cntr		(1+ Cntr)
							Ent1		(ssname ssi Cntr)
					)
				)
			)
		)
	)
	(if Cntr
		(princ (strcat "\n C:ChngSum Forced Update on {" (itoa Cntr) "} items...complete."))
	)
	;	Cleanup
	(if ssi	(setq ssi	nil))
	(gc)
	
	(if Bug (princ "\n C:ChngSum exited}\n"))
	(princ)
)

(defun C:FixEED2 ( /)
	(setq	EntMe	(car (entsel "\nSelect the entity to fix Xdata: ")))
	(if EntMe
		(FixEED2 EntMe)
	)
)

(defun FixEED2 (Enam / ssAllObjects APID i MaxCnt  MyDat xd lay b bxd)
	(if Enam
		(cond
			((eq (quote ENAME) (type Enam))			;	case Entity Names
				(setq	ssAllObjects	(ssadd)
						ssAllObjects	(ssadd Enam ssAllObjects)
				)
			)
			((eq (quote PICKSET) (type Enam))			;	case Selection Set
				(setq	ssAllObjects	Enam)
			)
		)
		(setq	ssAllObjects		
			(if (and (/= Div "AL") (/= Div "GA"))							; [Modified for Trans]
				(ssget "X"	(list	(cons -4 "<OR")
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
							)
				)
				(ssget "X"	(list	(cons -4 "<OR")
										(cons -4 "<AND")
											(cons 0 "POLYLINE")
											(cons 8 "*")
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
							)
				)
			)
		)
	)
		
	;	Register standard Adds application names with the current AutoCAD drawing in preparation for using extended object data
	(setq	APID		"CLR_NUM")
	(if (null (tblsearch "APPID" APID))
		(regapp APID)
	)
	(setq	APID		"PLANT_ID")
	(if (null (tblsearch "APPID" APID))
		(regapp APID)
	)
	(setq	APID		"LINE_ID")
	(if (null (tblsearch "APPID" APID))
		(regapp APID)
	)
	(setq	APID		"LINE_TYP")
	(if (null (tblsearch "APPID" APID))
		(regapp APID)
	)
	(setq	APID		"EDIT_DTM")
	(if (null (tblsearch "APPID" APID))
		(regapp APID)
	)
	(setq	APID		"PE_URL")
	(if (null (tblsearch "APPID" APID))
		(regapp APID)
	)
	
	;	Setup for loop
	(setq 	i 		0
			MaxCnt	(sslength ssAllObjects)
	)
	(if ssAllObjects
		(if (> (sslength ssAllObjects) 1)
			(princ (strcat "\nFixEED2 is processing {" (itoa MaxCnt) "} items...\n"))
		)
	)
	;	Loop through all selection set
	(while (< i (sslength ssAllObjects))
		
		;	*** Check Edit Date Xdata ***
		(setq	b	(entget (ssname ssAllObjects i) (list "EDIT_DTM"))
				bxd	(assoc -3 b)
		)
		(setq 	MyDat	(GetStorDate)
				APID		"EDIT_DTM"
				xd		(list APID (cons 1000 MyDat))
				xd		(list -3 xd)
		)
		(if bxd
			(progn	;	Xdata EDIT_DTM exists
				(setq 	b 	(subst	xd	(assoc -3 b) b))
				(entmod b)
			)
			(progn	;	Xdata EDIT_DTM does not exists
				(entmod (append b (list xd)))
			)
		)
		(entupd (cdr (assoc -1 b)))
		
		
		;	*** Check Plant ID Xdata ***
		(setq	b	(entget (ssname ssAllObjects i) (list "PLANT_ID"))
				bxd	(assoc -3 b)
				lay	(cdr(assoc 8 b))
		)
		(setq 	pid		(if (and (/= Div "AL") (/= Div "GA"))				; [Modified for Trans]
							(substr lay 1 2)
							(if (= (substr lay 1 5) "00000")
								"0"
								(vl-string-left-trim "0" (substr lay 1 5))
							)
						)
				APID		"PLANT_ID"
				xd		(list APID (cons 1000 pid))
				xd		(list -3 xd)
		)
		(if bxd
			(progn	;	Xdata PLANT_ID exists
				(setq 	b 	(subst	xd	(assoc -3 b) b))
				(entmod b)
			)
			(progn	;	Xdata PLANT_ID does not exists
				(entmod (append b (list xd)))
			)
		)
		(entupd (cdr (assoc -1 b)))
		
		
		;	*** Check Line ID Xdata ***
		(setq	b	(entget (ssname ssAllObjects i) (list "LINE_ID"))
				bxd	(assoc -3 b)
				lay	(cdr(assoc 8 b))
		)
		(setq 	ln_id	(if (and (/= Div "AL") (/= Div "GA"))					; [Modified for Trans]
							(substr lay 1 10)
							(if (= (substr lay 6 4) "0000")
									"0"
									(vl-string-left-trim "0" (substr lay 6 4))
							)
						)
				APID		"LINE_ID"
				xd		(list APID (cons 1000 ln_id))
				xd		(list -3 xd)
		)
		(if bxd
			(progn	;	Xdata LINE_ID exists
				(setq 	b 	(subst	xd	(assoc -3 b) b))
				(entmod b)
			)
			(progn	;	Xdata LINE_ID does not exists
				(entmod (append b (list xd)))
			)
		)
		(entupd (cdr (assoc -1 b)))
		
		
		;	*** Check Color Number XData ***
		(setq	b	(entget (ssname ssAllObjects i) (list "CLR_NUM"))
				bxd	(assoc -3 b)
		)
		;	Check to see if Color dxf 62 is overriden if so updates or adds XData
		(if (assoc 62 b)														
			(progn
				(setq	MyDat	(cdr (assoc 62 b)))		;	returns color number 0 ~ ByLayer
				
				(if (/= MyDat 0)	; Checks to see if not color bylayer
					(progn
						(setq 	APID		"CLR_NUM"
								xd		(list APID (cons 1000 (itoa MyDat)))
								xd		(list -3 xd)
						)
						(if bxd
							(progn	;	Xdata CLR_NUM exists
								(setq 	b 	(subst	xd	(assoc -3 b) b))
								(entmod b)
							)
							(progn	;	Xdata CLR_NUM does not exists
								(entmod (append b (list xd)))
							)
						)
						(entupd (cdr (assoc -1 b)))
					)
					(progn	; 	deletes CLR_NUM xdata
						(entmod (list (cons -1 (ssname ssAllObjects i)) (list -3 (list "CLR_NUM"))))
						(entupd (cdr (assoc -1 b)))
					)
				)
			)
			;	if color is not overriden and XData exist for CLR_NUM then delete the CLR_NUM Xdata entry
			(if bxd 												
				(progn
					(entmod (list (cons -1 (ssname ssAllObjects i)) (list -3 (list "CLR_NUM"))))
					(entupd (cdr (assoc -1 b)))
				)
			)
		)
		
		
		;	*** Check Line Type XData is hidden ***
		(setq	b	(entget (ssname ssAllObjects i) (list "LINE_TYP"))
				bxd	(assoc -3 b)
		)
		(if (assoc 6 b)
			(if (= (cdr (assoc 6 b)) "HIDDEN")
				(progn
					(setq	MyDat	"1"
							APID 	"LINE_TYP"
							xd		(list APID (cons 1000 MyDat))
							xd		(list -3 xd)
					)
					(if bxd
						(progn	;	Xdata LINE_TYP exists
							(setq 	b 	(subst	xd	(assoc -3 b) b))
							(entmod b)
						)
						(progn	;	Xdata LINE_TYP does not exists
							(entmod (append b (list xd)))
						)
					)
					(entupd (cdr (assoc -1 b)))
				)
				;	if line type is not overriden to hidden and XData exist for LINE_TYP then delete the LINE_TYP Xdata entry
				(if bxd 												
					(progn
						(entmod (list (cons -1 (ssname ssAllObjects i)) (list -3 (list "LINE_TYP"))))
						(entupd (cdr (assoc -1 b)))
					)
				)
			)
			(if bxd 												
				(progn
					(entmod (list (cons -1 (ssname ssAllObjects i)) (list -3 (list "LINE_TYP"))))
					(entupd (cdr (assoc -1 b)))
				)
			)
		)
		
		;	*** Check Color Number XData ***
		(setq	b	(entget (ssname ssAllObjects i) (list "PE_URL"))
				b1	b
				bxd	(assoc -3 b)
		)
		(if bxd
			(progn
				(setq	oldURL	(cdr (cadr (cadr bxd)))
						newURL	(car(CheckURL oldURL))
						APID		"PE_URL"
						xd		(list APID (cons 1000 newURL))
						xd		(list -3 xd)
				)
				(setq 	b 	(subst	xd	(assoc -3 b) b))
				(entmod b)
				(entupd (cdr (assoc -1 b)))
			)
		)
		
		;	index counter		
		(setq	i	(1+ i))
	)
)


(defun C:UmChg ( / )						; CL - Changes/Updates EED info for EMB (forces new Unique_ID)
	(if Bug (princ "\n{C:UmChg entered\n"))
	(setq	EntMe	(car (entsel "\nSelect the entity to update: ")))
	(if EntMe
		(ChngUm T EntMe)
	)
	(if Bug (princ "\nC:UmChg exited}\n"))
	(princ)
)

(defun ChngUm ( ForceUpd Enam /	divp id_pre	; Updates the Device_ID for objects
							sid id Dnam APID ssAllObjects date2 year2 month2 day2 hrs2 min2 date3 time2
							dtm i MaxCnt co url ln_id pid num b lay hd xd b1 oid ) ;GtAdded )
							;LnIdLst PidLst
	(if Bug
		(progn 
			(princ "\n{ChngUm entered}\n")
			(princ " - ForceUp: ") (prin1 ForceUpd)
			(princ " - Enam: ") (prin1 Enam)
		)	
	)
	(if (not Div)
		(if (> (strlen (getvar "DWGPREFIX")) 20)
			(setq	divp		(strcase (substr (getvar "DWGPREFIX") 19 10)))
			(setq	divp		(strcase (substr (getvar "DWGPREFIX") 3 10)))
		)
		(setq	divp		Div)
	)
	(setq	id_pre	(cond
						((= Div "BH")	"BHM")
						((= Div "E_")	"EAS")
						((= Div "M_")	"MOB")
						((= Div "S_")	"SOU")
						((= Div "SE")	"SOE")
						((= Div "W_")	"WES")
						((wcmatch divp "POWER DELI")	"SHR")
						((wcmatch divp "BIRMINGHAM")	"BHM")
						((wcmatch divp "EASTERN DI")	"EAS")
						((wcmatch divp "MOBILE DIV")	"MOB")
						((wcmatch divp "SOUTHEAST ")	"SOE")
						((wcmatch divp "SOUTHERN D")	"SOU")
						((wcmatch divp "WESTERN DI")	"WES")
						(T	"BHM")
					)
			Dnam		(strcase (getvar "DWGNAME"))
	)
	(if (not Enam)
		(progn
			(if (= (substr Dnam (- (strlen Dnam) 3)) ".DWG")
				(setq	Dnam		(substr Dnam 1 (- (strlen Dnam) 4)))
			)
			(command)
			(command "_.Layer" "T" "*" "ON" "*" "U" "*" "S" "0" "" "_.Zoom" "E")
		)
		(if (= (substr Dnam (- (strlen Dnam) 3)) ".DWG")
			(setq	Dnam		(substr Dnam 1 (- (strlen Dnam) 4)))
		)
	)
	(if (or (not _Path-Sub) (not _Path-User))
		(cond
			((and (= (substr (StpDot AppNam) 1 4) "ADDS") (= Div "BH"))
				(if (not _Path-Sub)
					(setq	_Path-Sub		"http:\\\\powerdelivery.southernco.com\\apc\\div\\BD\\sub_single_line\\")
				)
				(if (not _Path-User)
					(setq	_Path-User	"S:\\Workgroups\\APC Birmingham Division\\Division Mapping\\Adds\\USER\\")
				)
			)
			((and (= (substr (StpDot AppNam) 1 4) "ADDS") (= Div "E_"))
				(if (not _Path-Sub)
					(setq	_Path-Sub		"http:\\\\powerdelivery.southernco.com\\apc\\div\\BD\\sub_single_line\\")
				)
				(if (not _Path-User)
					(setq	_Path-User	"S:\\Workgroups\\APC Eastern Division\\Division Mapping\\Adds\\USER\\")
				)
			)
			((and (= (substr (StpDot AppNam) 1 4) "ADDS") (= Div "M_"))
				(if (not _Path-Sub)
					(setq	_Path-Sub		"http:\\\\powerdelivery.southernco.com\\apc\\div\\BD\\sub_single_line\\")
				)
				(if (not _Path-User)
					(setq	_Path-User	"S:\\Workgroups\\APC Birmingham Division\\Division Mapping\\Adds\\USER\\")
				)
			)
			((and (= (substr (StpDot AppNam) 1 4) "ADDS") (= Div "S_"))
				(if (not _Path-Sub)
					(setq	_Path-Sub		"http:\\\\powerdelivery.southernco.com\\apc\\div\\BD\\sub_single_line\\")
				)
				(if (not _Path-User)
					(setq	_Path-User	"S:\\Workgroups\\APC Birmingham Division\\Division Mapping\\Adds\\USER\\")
				)
			)
			((and (= (substr (StpDot AppNam) 1 4) "ADDS") (= Div "SE"))
				(if (not _Path-Sub)
					(setq	_Path-Sub		"http:\\\\powerdelivery.southernco.com\\apc\\div\\BD\\sub_single_line\\")
				)
				(if (not _Path-User)
					(setq	_Path-User	"S:\\Workgroups\\APC Birmingham Division\\Division Mapping\\Adds\\USER\\")
				)
			)
			((and (= (substr (StpDot AppNam) 1 4) "ADDS") (= Div "W_"))
				(if (not _Path-Sub)
					(setq	_Path-Sub		"http:\\\\powerdelivery.southernco.com\\apc\\div\\WD\\maps\\SUB\\")
				)
				(if (not _Path-User)
					(setq	_Path-User	"S:\\Workgroups\\APC Western Division\\Division Mapping\\Adds\\USER\\")
				)
			)
			((and (= (stpdot AppNam) "SUBTOOLS") (= Div "BH"))
				(if (not _Path-Sub)
					(setq	_Path-Sub		"http:\\\\powerdelivery.southernco.com\\apc\\div\\BD\\sub_single_line\\")
				)
				(if (not _Path-User)
					(setq	_Path-User	"S:\\Workgroups\\APC Birmingham Division\\Division Mapping\\Adds\\USER\\")
				)
			)
			((and (= (stpdot AppNam) "SUBTOOLS") (= Div "E_"))
				(if (not _Path-Sub)
					(setq	_Path-Sub		"http:\\\\powerdelivery.southernco.com\\apc\\div\\BD\\sub_single_line\\")
				)
				(if (not _Path-User)
					(setq	_Path-User	"S:\\Workgroups\\APC Birmingham Division\\Division Mapping\\Adds\\USER\\")
				)
			)
			((and (= (stpdot AppNam) "SUBTOOLS") (= Div "M_"))
				(if (not _Path-Sub)
					(setq	_Path-Sub		"http:\\\\powerdelivery.southernco.com\\apc\\div\\BD\\sub_single_line\\")
				)
				(if (not _Path-User)
					(setq	_Path-User	"S:\\Workgroups\\APC Birmingham Division\\Division Mapping\\Adds\\USER\\")
				)
			)
			((and (= (stpdot AppNam) "SUBTOOLS") (= Div "S_"))
				(if (not _Path-Sub)
					(setq	_Path-Sub		"http:\\\\powerdelivery.southernco.com\\apc\\div\\BD\\sub_single_line\\")
				)
				(if (not _Path-User)
					(setq	_Path-User	"S:\\Workgroups\\APC Birmingham Division\\Division Mapping\\Adds\\USER\\")
				)
			)
			((and (= (stpdot AppNam) "SUBTOOLS") (= Div "SE"))
				(if (not _Path-Sub)
					(setq	_Path-Sub		"http:\\\\powerdelivery.southernco.com\\apc\\div\\BD\\sub_single_line\\")
				)
				(if (not _Path-User)
					(setq	_Path-User	"S:\\Workgroups\\APC Birmingham Division\\Division Mapping\\Adds\\USER\\")
				)
			)
			((and (= (stpdot AppNam) "SUBTOOLS") (= Div "W_"))
				(if (not _Path-Sub)
					(setq	_Path-Sub		"http:\\\\powerdelivery.southernco.com\\apc\\div\\BD\\sub_single_line\\")
				)
				(if (not _Path-User)
					(setq	_Path-User	"S:\\Workgroups\\APC Birmingham Division\\Division Mapping\\Adds\\USER\\")
				)
			)
			(T
				(if (not _Path-Sub)
					(setq	_Path-Sub		"http:\\\\powerdelivery.southernco.com\\apc\\div\\BD\\sub_single_line\\")
				)
				(if (not _Path-User)
					(setq	_Path-User	"S:\\Workgroups\\APC Birmingham Division\\Division Mapping\\Adds\\USER\\")
				)
			)
		)
	)
	(if Bug (princ "\nChngUm Im here pt1\n"))
	;	Register standard Adds application names with the current AutoCAD drawing in preparation for using extended object data
	(setq	APID		"ID")
	(if (null (tblsearch "APPID" APID))
		(regapp APID)
	)
	(setq	APID		"PE_URL")
	(if (null (tblsearch "APPID" APID))
		(regapp APID)
	)
	(setq	APID		"PLANT_ID")
	(if (null (tblsearch "APPID" APID))
		(regapp APID)
	)
	(setq	APID		"LINE_ID")
	(if (null (tblsearch "APPID" APID))
		(regapp APID)
	)
	(setq	APID		"LINE_TYP")
	(if (null (tblsearch "APPID" APID))
		(regapp APID)
	)
	(setq	APID		"LINE_WDT")
	(if (null (tblsearch "APPID" APID))
		(regapp APID)
	)
	(setq	APID		"OPERPTNUM")
	(if (null (tblsearch "APPID" APID))
		(regapp APID)
	)
	(setq	APID		"EDIT_DTM")
	(if (null (tblsearch "APPID" APID))
		(regapp APID)
	)
	(setq	APID		"CLR_NUM")
	(if (null (tblsearch "APPID" APID))
		(regapp APID)
	)
	(if Bug (princ "\nChngUm Im here pt2\n"))
	(if (not Enam)
		(progn
		(if Bug (princ "\nChngUm Im here pt2.a\n"))
		(setq	ssAllObjects		(if (and (/= Div "AL") (/= Div "GA"))							; [Modified for Trans]
									(ssget "X"	(list	(cons -4 "<OR")
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
												)
									)
									(ssget "X"	(list	(cons -4 "<OR")
															(cons -4 "<AND")
																(cons 0 "POLYLINE")
																(cons 8 "*")
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
												)
									)
							)
							)
		)
		(cond
			((eq (quote ENAME) (type Enam))
				(if Bug (princ "\nChngUm Im here pt2b.a\n"))
				(setq	ssAllObjects	(ssadd)
						ssAllObjects	(ssadd Enam ssAllObjects)
				)
			)
			((eq (quote PICKSET) (type Enam))
				(if Bug (princ "\nChngUm Im here pt2b.b\n"))
				(setq	ssAllObjects	Enam)
			)
			((eq (quote LIST) (type Enam))
				(if Bug (princ "\nChngUm Im here pt2b.c\n"))
				(setq	ssAllObjects	(ssadd)
						ssAllObjects	(ssadd Enam ssAllObjects)
				)
			)
		)
	)
	(if Bug (princ "\nChngUm Im here pt3\n"))
	(setq	date2	(rtos (getvar "CDATE") 2 4)
			year2	(substr date2 3 2)
			month2	(substr date2 5 2)
			day2		(substr date2 7 2)
			hrs2		(substr date2 10 2)
			min2		(substr date2 12 2)
			date3	(strcat month2 "/" day2 "/20" year2)
			time2	(strcat hrs2 ":" min2)
			dtm		(strcat date3 " " time2)
			i		0
			MaxCnt	(sslength ssAllObjects)
			co		"0"
	)
	(if Bug (princ "\nChngUm Im here pt4\n"))
	(if ssAllObjects
		(if (> (sslength ssAllObjects) 1)
			(princ (strcat "\nChngUm is processing {" (itoa MaxCnt) "} items...\n"))
		)
	)
	(if Bug (princ "\nChngUm Im here pt5\n"))	
	(while (< i (sslength ssAllObjects))										; LOOP THROUGH SELECTION SET A
		(setq	url		""
				ln_id	""
				pid		""
				num		""
				b		(entget (ssname ssAllObjects i) (list "ID"))
				lay		(cdr (assoc 8 b))
				hd		(cdr (assoc 5 b))
		)
		(if (not Bug)
			(if (not Enam)
				(Twaddle i MaxCnt)
			)
		)
		(if (not (assoc -3 b))
			(progn											    ; [Modified for Trans] case no Xdata
				(setq 	b		(entget (ssname ssAllObjects i))
						APID		"ID"
						sid		(GetNextID)
				)
				(if (and (/= Div "AL") (/= Div "GA"))
					(setq	objp	(cond
									((wcmatch (cdr (assoc 0 b)) "*POLYLINE") "DP_")
									((wcmatch (cdr (assoc 0 b)) "INSERT") "DS_")
									((wcmatch (cdr (assoc 0 b)) "*TEXT") "DT_")
									(T "DS_")
								)
							id		(strcat objp id_pre "_" (itoa sid))
					)
					(setq	objp	(cond
									((wcmatch (cdr (assoc 0 b)) "*POLYLINE") "P_")
									((wcmatch (cdr (assoc 0 b)) "INSERT") "D_")
									((wcmatch (cdr (assoc 0 b)) "*TEXT") "T_")
									(T "D_")
								)
							id		(strcat objp (itoa sid))
							
					)
				)
				(setq	xd		(list APID (cons 1000 id))
						xd		(list -3 xd)
						Bubba	(entmod (append b (list xd)))
						Bubba	(entupd (cdr (assoc -1 b)))
						Bubba	(if GtAdded
									(setq	GtAdded	(cons (cons id i) GtAdded))
									(setq	GtAdded	(list (cons id i)))
								)
				)
			)
			(if ForceUpd
				(if (eq (quote STR) (type ForceUpd))
					(setq	b		(entget (ssname ssAllObjects i) (list "*"))
							b1		(cdr (assoc -3 b))
							b2		(cdadr (assoc "ID" b1))
							b2		(if (= (substr b2 (strlen b2) 1) "]")
										(substr b2 1 (- (strlen b2) 3))
										b2
									)
							b3		(list "ID" (cons 1000 (strcat b2 ForceUpd)))
							xd		(subst b3 (assoc "ID" b1) b1)
							xd		(cons -3 xd)
							b		(subst xd (assoc -3 b) b)
							Bubba	(entmod b)
							Bubba	(if GtAdded
										(setq	GtAdded	(cons (cons id i) GtAdded))
										(setq	GtAdded	(list (cons id i)))
									)
					)
					(progn											    ; [Modified for Trans]  if ForceUpd type not STR ~ T SYM
						(setq 	b		(entget (ssname ssAllObjects i) (list "*"))
								b1		(cdr (assoc -3 b))
								APID		"ID"
								sid		(GetNextID)
						)
						(if (and (/= Div "AL") (/= Div "GA"))
							(setq	objp	(cond
											((wcmatch (cdr (assoc 0 b)) "*POLYLINE") "DP_")
											((wcmatch (cdr (assoc 0 b)) "INSERT") "DS_")
											((wcmatch (cdr (assoc 0 b)) "*TEXT") "DT_")
											(T "DS_")
										)
									id		(strcat objp id_pre "_" (itoa sid))
									
							)
							(setq	objp	(cond
											((wcmatch (cdr (assoc 0 b)) "*POLYLINE") "P_")
											((wcmatch (cdr (assoc 0 b)) "INSERT") "D_")
											((wcmatch (cdr (assoc 0 b)) "*TEXT") "T_")
											(T "S_")
										)
									id		(strcat objp (itoa sid))
							)
						)
						(setq	xd		(list APID (cons 1000 id))
								xd		(subst xd (assoc "ID" b1) b1)
								xd		(cons -3 xd)
								b		(subst xd (assoc -3 b) b)
								Bubba	(entmod b)
								Bubba	(if GtAdded
											(setq	GtAdded	(cons (cons id i) GtAdded))
											(setq	GtAdded	(list (cons id i)))
										)
						)
					)
				)
				(setq	oid		(cdadr (assoc "ID" (cdr (assoc -3 b))))
						b		(entget (ssname ssAllObjects i) (list "*"))
						b1		(cdr (assoc -3 b))
						APID		"ID"
						objp		(cond
									((wcmatch (cdr (assoc 0 b)) "*POLYLINE") "DP_")
									((wcmatch (cdr (assoc 0 b)) "INSERT") "DS_")
									((wcmatch (cdr (assoc 0 b)) "*TEXT") "DT_")
									(T "DS_")
								)
						id		(strcat objp id_pre "_" (substr oid 8))
						xd		(list "ID" (cons 1000 id))
						xd		(subst xd (assoc "ID" b1) b1)
						xd		(cons -3 xd)
						b		(subst xd (assoc -3 b) b)
						Bubba	(entmod b)
				)
			)
		)
		(setq	b	(entget (ssname ssAllObjects i) (list "PE_URL")))
		(if (not (assoc -3 b))
			(if (and (= (cdr (assoc 0 b)) "INSERT") (member (cdr (assoc 2 b)) (list "SUB" "SUB2" "SUBCUST" "A074" "A075" "A076")))
				(setq	b		(entget (ssname ssAllObjects i))
						url		(FormURL (ssname ssAllObjects i))
						APID		"PE_URL"
						Bubba	(if (not url)
									(setq	url	"http://powerdelivery.southernco.com/apc/pds/methsys/")
								)
						xd		(list APID (cons 1000 url))
						xd		(list -3 xd)
						Bubba	(entmod (append b (list xd)))
						Bubba	(entupd (cdr (assoc -1 b)))
				)
				(if (and (= (cdr (assoc 0 b)) "INSERT") (member (cdr (assoc 2 b)) (list "A156")))
					(setq	b		(entget (ssname ssAllObjects i))
							tmp		(EntDatLstR (ssname ssAllObjects i))
							id		(cdr (assoc "ID" (cdr (last tmp))))
							tmp2		(if (= (nth 9 tmp) 1)
										(if (assoc "LOC_NUM" (cdr (nth 10 tmp)))
											(cadr (assoc "LOC_NUM" (cdr (nth 10 tmp))))
											nil
										)
										nil
									)
							url		(cond
										((and tmp2 (= (substr id 4 3) "BHM"))
											(setq	url	(strcat "http://www.scada.apc.southernco.com/webfg/adn/displays/scada/" (strcase tmp2 T) ".fgdisplay"))
										)
										((and tmp2 (= (substr id 4 3) "EAS"))
											(setq	url	(strcat "http://www.scada.apc.southernco.com/webfg/adn/displays/scada/" (strcase tmp2 T) ".fgdisplay"))
										)
										((and tmp2 (= (substr id 4 3) "WES"))
											(setq	url	(strcat "http://www.scada.apc.southernco.com/webfg/adn/displays/scada/" (strcase tmp2 T) ".fgdisplay"))
										)
										((and tmp2 (= (substr id 4 3) "SHR"))
											(setq	url	(strcat "http://www.scada.apc.southernco.com/webfg/adn/displays/scada/" (strcase tmp2 T) ".fgdisplay"))
										)
										((and tmp2 (= (substr id 4 3) "SOU"))
											(setq	url	(strcat "http://www.scada.apc.southernco.com/webfg/adn/displays/scada/" (strcase tmp2 T) ".fgdisplay"))
										)
										((and tmp2 (= (substr id 4 3) "SOE"))
											(setq	url	(strcat "http://www.scada.apc.southernco.com/webfg/adn/displays/scada/" (strcase tmp2 T) ".fgdisplay"))
										)
										((and tmp2 (= (substr id 4 3) "MOB"))
											(setq	url	(strcat "http://www.scada.apc.southernco.com/webfg/adn/displays/scada/" (strcase tmp2 T) ".fgdisplay"))
										)
										(T
											nil
										)
									)
							APID		"PE_URL"
							Bubba	(if (not url)
										(if id
											(setq	url	"http://www.scada.apc.southernco.com/webfg/adn/displays/menus/menus.fgdisplay")
											(setq	url	"http://www.scada.apc.southernco.com/webfg/adn/displays/menus/menus.fgdisplay")
										)
									)
							xd		(list APID (cons 1000 url))
							xd		(list -3 xd)
							Bubba	(entmod (append b (list xd)))
							Bubba	(entupd (cdr (assoc -1 b)))
					)
				)
			)
		)
		
		(setq	b	(entget (ssname ssAllObjects i) (list "EDIT_DTM")))
		(setq	b		(entget (ssname ssAllObjects i))
				MyDat	(GetStorDate)
				APID		"EDIT_DTM"
				xd		(list APID (cons 1000 MyDat))
				xd		(list -3 xd)
				Bubba	(entmod (append b (list xd)))
				Bubba	(entupd (cdr (assoc -1 b)))
		)
		(setq	b	(entget (ssname ssAllObjects i) (list "CLR_NUM"))
				bxd	(assoc -3 b)
		)
		(if bxd 
			(entmod (list (cons -1 (ssname ssAllObjects i)) (list -3 (list "CLR_NUM"))))
			(entupd (cdr (assoc -1 b)))
		)
		(if (assoc 62 b)
			(setq	b		(entget (ssname ssAllObjects i))
					MyDat	(cdr (assoc 62 b))
					APID		"CLR_NUM"
					xd		(list APID (cons 1000 (itoa MyDat)))
					xd		(list -3 xd)
					Bubba	(entmod (append b (list xd)))
					Bubba	(entupd (cdr (assoc -1 b)))
			)
		)
		(setq	b	(entget (ssname ssAllObjects i) (list "LINE_TYP")))		;	Added for [GCC Trans]
		(if (assoc 6 b)
			(if (= (cdr (assoc 6 b)) "HIDDEN")
				(setq	b		(entget (ssname ssAllObjects i))
						MyDat	"1"
						APID 	"LINE_TYP"
						xd		(list APID (cons 1000 MyDat))
						xd		(list -3 xd)
						Bubba	(entmod (append b (list xd)))
						Bubba	(entupd (cdr (assoc -1 b)))
				)	
			)
		)
		(if ForceUpd
			(if (eq (quote STR) (type ForceUpd))
			    	(if Bug (princ "\nBug:Skipped due to (Not Distribution)\n"))
				(progn
					(setq	b	(entget (ssname ssAllObjects i) (list "PLANT_ID")))
					(setq	b		(entget (ssname ssAllObjects i))
							pid		(if (and (/= Div "AL") (/= Div "GA"))				; [Modified for Trans]
										(substr lay 1 2)
										(if (= (substr lay 1 5) "00000")
											"0"
											(vl-string-left-trim "0" (substr lay 1 5))
										)
									)
							APID		"PLANT_ID"
							xd		(list APID (cons 1000 pid))
							xd		(list -3 xd)
							Bubba	(entmod (append b (list xd)))
							Bubba	(entupd (cdr (assoc -1 b)))
					)
					(setq	b	(entget (ssname ssAllObjects i) (list "LINE_ID")))
					(setq	b		(entget (ssname ssAllObjects i))
							ln_id	(if (and (/= Div "AL") (/= Div "GA"))				; [Modified for Trans]
										(substr lay 1 10)
										(if (= (substr lay 6 4) "0000")
											"0"
											(vl-string-left-trim "0" (substr lay 6 4))
										)
									)
							APID		"LINE_ID"
							xd		(list APID (cons 1000 ln_id))
							xd		(list -3 xd)
							Bubba	(entmod (append b (list xd)))
							Bubba	(entupd (cdr (assoc -1 b)))
					)
				)
			)
			(progn
				(setq	b	(entget (ssname ssAllObjects i) (list "PLANT_ID")))
				(setq	b		(entget (ssname ssAllObjects i))
						pid		(if (and (/= Div "AL") (/= Div "GA"))					; [Modified for Trans]
									(substr lay 1 2)
									(if (= (substr lay 1 5) "00000")
											"0"
											(vl-string-left-trim "0" (substr lay 1 5))
									)
								)
						APID		"PLANT_ID"
						xd		(list APID (cons 1000 pid))
						xd		(list -3 xd)
						Bubba	(entmod (append b (list xd)))
						Bubba	(entupd (cdr (assoc -1 b)))
				)
				(setq	b	(entget (ssname ssAllObjects i) (list "LINE_ID")))
				(setq	b		(entget (ssname ssAllObjects i))
						ln_id	(if (and (/= Div "AL") (/= Div "GA"))					; [Modified for Trans]
									(substr lay 1 10)
									(if (= (substr lay 6 4) "0000")
											"0"
											(vl-string-left-trim "0" (substr lay 6 4))
									)
								)
						APID		"LINE_ID"
						xd		(list APID (cons 1000 ln_id))
						xd		(list -3 xd)
						Bubba	(entmod (append b (list xd)))
						Bubba	(entupd (cdr (assoc -1 b)))
				)
			)
		)
		
		(if (and (= (or(substr (StpDot AppNam) 1 4) "SUBT") (= dwgType "SLD")) (wcmatch lay "????CK?###*"))
			(progn
				(setq	b	(entget (ssname ssAllObjects i) (list "LINE_WDT")))
				(setq	b		(entget (ssname ssAllObjects i))
						ln_wd	(cond
									((= (substr lay 1 2) "--")
										"1"
									)
									((= (substr lay 8 1) "0")
										"7"
									)
									((member (substr lay 8 1) (list "1" "2" "3"))
										"3"
									)
									((member (substr lay 8 1) (list "4" "5" "6"))
										"0"
									)
								)
						APID		"LINE_WDT"
						xd		(list APID (cons 1000 ln_wd))
						xd		(list -3 xd)
						Bubba	(entmod (append b (list xd)))
						Bubba	(entupd (cdr (assoc -1 b)))
				)
			)
		)
		(if ln_id
			(if LnIdLst
				(if (not (member ln_id LnIdLst))
					(setq	LnIdLst	(cons ln_id LnIdLst))
				)
				(setq	LnIdLst	(list ln_id))
			)
		)
		(if pid
			(if PidLst
				(if (not (member pid PidLst))
					(setq	PidLst	(cons pid PidLst))
				)
				(setq	PidLst	(list pid))
			)
		)
		(if (= Div "AL")
			(progn
				(setq 	etb		(entget (ssname ssAllObjects i)))
				(FixEED2 (cdr (assoc -1 etb)))
			)
		)
		(setq	i	(1+ i))
		
	)
	(if Bug (princ "\nChngUm Im here pt6\n"))
	(if (not Bug)
		(if (not Enam)
			(Twaddle (- 0 i) MaxCnt)
		)
	)
	(if ssAllObjects
		(if (> (sslength ssAllObjects) 1)
			(if (and GtAdded id i)
				(princ	(strcat "\nChngUm added this many id's:" (itoa (length GtAdded)) "\n\nEnding ID:" id "-" (itoa i)))
				(if (and i id)
					(princ	(strcat "\n\nEnding ID:" id "-" (itoa i)))
					(princ	(strcat "\n\nNo ID's added"))
				)
			)
		)
	)
	;	Cleanup
	(if ssAllObjects	(setq ssAllObjects	nil))
	(gc)
	
	(if Bug (princ "\n{ ChngUm exited}\n"))
	GtAdded
)

(defun GetStat ( Pt1 Pt2 SrchTrm /	p1 p2	; Finds devices with supplied device_id status
								p3 p4 ssI ssO x Mx e1 e2 e3 e4 )
	(if (and Pt1 Pt2)
		(setq	p1	(list (car Pt1) (cadr Pt1))
				p2	(list (car Pt2) (cadr Pt1))
				p3	(list (car Pt2) (cadr Pt2))
				p4	(list (car Pt1) (cadr Pt2))
				ssI	(ssget "CP" (list p1 p2 p3 p4) (list (list -3 (list "ID"))))
				ssO	(ssadd)
		)
		(setq	ssI	nil)
	)
	(if ssI
		(progn
			(setq	x		0
					Mx		(1- (sslength ssI))
			)
			(while (<= x Mx)
				(setq	e1	(ssname ssI x)
						e2	(entget e1 (list "*"))
						e3	(cdr (assoc -3 e2))
						e4	(cdadr (assoc "ID" e3))
				)
				(if e4
					(if (> (strlen e4) 3)
						(if (eq (substr e4 (- (strlen e4) 2)) SrchTrm)
							(setq	ssO	(ssadd e1 ssO))
						)
					)
				)
				(setq	x	(1+ x))
			)
			(if (>= (sslength ssO) 0)
				(princ (strcat "\nSearched [" (itoa (1+ Mx)) "] selected items, found [" (itoa (sslength ssO)) "] with " SrchTrm " status."))
				(princ (strcat "\nSearched [" (itoa (1+ Mx)) "] selected items, found [None] with " SrchTrm " status."))
			)
		)
	)
	(setq	ssI		nil
			bubba	(gc)
	)
	ssO
)

(defun C:FeA ( / Pt1 Pt2 )					; Finds devices with [a] device_id status
	(if Bug (princ "\n{ C:FeA entered\n"))
	(setq	ssO		nil
			SrchTrm	"[a]"
			Pt1		(getpoint "\nSelect Lower-Left Point: ")
			Pt2		(getcorner Pt1 "\nSelect Upper-Right Point: ")
			ssO		(GetStat Pt1 Pt2 SrchTrm)
	)
	;	Cleanup
	(if ssO	(setq ssO	nil))
	(gc)

	(if Bug (princ "\n{ C:FeA exited}\n"))
	(princ)
)

(defun C:FeE ( / Pt1 Pt2 )					; Finds devices with [e] device_id status
	(if Bug (princ "\n{ C:FeE entered\n"))
	(setq	ssO		nil
			SrchTrm	"[e]"
			Pt1		(getpoint "\nSelect Lower-Left Point: ")
			Pt2		(getcorner Pt1 "\nSelect Upper-Right Point: ")
			ssO		(GetStat Pt1 Pt2 SrchTrm)
	)
	;	Cleanup
	(if ssO	(setq ssO	nil))
	(gc)

	(if Bug (princ "\n{ C:FeE exited}\n"))
	(princ)
)

(defun C:FeF ( / Pt1 Pt2 )					; Finds devices with [f] device_id status
	(if Bug (princ "\n{ C:FeF entered\n"))
	(setq	ssO		nil
			SrchTrm	"[f]"
			Pt1		(getpoint "\nSelect Lower-Left Point: ")
			Pt2		(getcorner Pt1 "\nSelect Upper-Right Point: ")
			ssO		(GetStat Pt1 Pt2 SrchTrm)
	)
	;	Cleanup
	(if ssO	(setq ssO	nil))
	(gc)

	(if Bug (princ "\n{ C:FeF exited}\n"))
	(princ)
)

(defun C:FeG ( / Pt1 Pt2 )					; Finds devices with [g] device_id status
	(if Bug (princ "\n{ C:FeG entered\n"))
	(setq	ssO		nil
			SrchTrm	"[g]"
			Pt1		(getpoint "\nSelect Lower-Left Point: ")
			Pt2		(getcorner Pt1 "\nSelect Upper-Right Point: ")
			ssO		(GetStat Pt1 Pt2 SrchTrm)
	)
	(if Bug (princ "\n{ C:FeG exited}\n"))
	(princ)
)

(defun C:FeM ( / Pt1 Pt2 )					; Finds devices with [m] device_id status
	(if Bug (princ "\n{ C:FeM entered\n"))
	(setq	ssO		nil
			SrchTrm	"[m]"
			Pt1		(getpoint "\nSelect Lower-Left Point: ")
			Pt2		(getcorner Pt1 "\nSelect Upper-Right Point: ")
			ssO		(GetStat Pt1 Pt2 SrchTrm)
	)
	(if Bug (princ "\n{ C:FeM exited}\n"))
	(princ)
)

(defun C:FeS ( / Pt1 Pt2 )					; Finds devices with [s] device_id status
	(if Bug (princ "\n{ C:FeS entered\n"))
	(setq	ssO		nil
			SrchTrm	"[s]"
			Pt1		(getpoint "\nSelect Lower-Left Point: ")
			Pt2		(getcorner Pt1 "\nSelect Upper-Right Point: ")
			ssO		(GetStat Pt1 Pt2 SrchTrm)
	)
	(if Bug (princ "\n{ C:FeS exited}\n"))
	(princ)
)

(defun C:FeW ( / Pt1 Pt2 )					; Finds devices with [w] device_id status
	(if Bug (princ "\n{ C:FeW entered\n"))
	(setq	ssO		nil
			SrchTrm	"[w]"
			Pt1		(getpoint "\nSelect Lower-Left Point: ")
			Pt2		(getcorner Pt1 "\nSelect Upper-Right Point: ")
			ssO		(GetStat Pt1 Pt2 SrchTrm)
	)
	(if Bug (princ "\n{ C:FeW exited}\n"))
	(princ)
)

(defun C:CeA ( / ssi )						; Applies [a] device_id status
	(if Bug (princ "\n{ C:CeA entered\n"))
	(setq	ssi	(ssget))
	(if ssi
		(setq	bubba	(ChngUm "[a]" ssi)
				ssi		nil
				bubba	(gc)
		)
	)
	(if Bug (princ "\n{ C:CeA exited}\n"))
	(princ)
)

(defun C:CeE ( / ssi )						; Applies [e] device_id status
	(if Bug (princ "\n{ C:CeE entered\n"))
	(setq	ssi	(ssget))
	(if ssi
		(setq	bubba	(ChngUm "[e]" ssi)
				ssi		nil
				bubba	(gc)
		)
	)
	(if Bug (princ "\n{ C:CeE exited}\n"))
	(princ)
)

(defun C:CeF ( / ssi )						; Applies [f] device_id status
	(if Bug (princ "\n{ C:CeF entered\n"))
	(setq	ssi	(ssget))
	(if ssi
		(setq	bubba	(ChngUm "[f]" ssi)
				ssi		nil
				bubba	(gc)
		)
	)
	(if Bug (princ "\n{ C:CeF exited}\n"))
	(princ)
)

(defun C:CeG ( / ssi )						; Applies [g] device_id status
	(if Bug (princ "\n{ C:CeG entered\n"))
	(setq	ssi	(ssget))
	(if ssi
		(setq	bubba	(ChngUm "[g]" ssi)
				ssi		nil
				bubba	(gc)
		)
	)
	(if Bug (princ "\n{ C:CeG exited}\n"))
	(princ)
)

(defun C:CeM ( / ssi )						; Applies [m] device_id status
	(if Bug (princ "\n{ C:CeM entered\n"))
	(setq	ssi	(ssget))
	(if ssi
		(setq	bubba	(ChngUm "[m]" ssi)
				ssi		nil
				bubba	(gc)
		)
	)
	(if Bug (princ "\n{ C:CeM exited}\n"))
	(princ)
)

(defun C:CeS ( / ssi )						; Applies [s] device_id status
	(if Bug (princ "\n{ C:CeS entered\n"))
	(setq	ssi	(ssget))
	(if ssi
		(setq	bubba	(ChngUm "[s]" ssi)
				ssi		nil
				bubba	(gc)
		)
	)
	(if Bug (princ "\n{ C:CeS exited}\n"))
	(princ)
)

(defun C:CeW ( / ssi )						; Applies [w] device_id status
	(if Bug (princ "\n{ C:CeW entered\n"))
	(setq	ssi	(ssget))
	(if ssi
		(setq	bubba	(ChngUm "[w]" ssi)
				ssi		nil
				bubba	(gc)
		)
	)
	(if Bug (princ "\n{ C:CeW exited}\n"))
	(princ)
)

(defun FrmObLstOut ( ILst / OStr Cntr )		; Returns Object List
	(if (and ILst (> (length ILst) 0))
		(setq	OStr		(strcat	"\"" (nth 0 ILst))
				Cntr		1
		)
	)
	(if (and ILst (> (length ILst) 1))
		(repeat (1- (length (cdr ILst)))
			(setq	OStr		(strcat	OStr "\" \"" (nth Cntr ILst))
					Cntr		(1+ Cntr)
			)
		)
	)
	(setq	OStr		(strcat	OStr "\""))
	OStr
)

(defun CoolUm ( ForceUpd Enam / )				; Older symbology conversion routine
	(if Bug (princ "\n{CoolUm entered\n"))
	(setq	divp		(strcase (substr (getvar "DWGPREFIX") 19 10))
			UnkLst	(list "99999999")
			MstLst	nil
			GtAdded	nil
			Div		(cond
						((wcmatch divp "POWER DELI")	"SHR")
						((wcmatch divp "BIRMINGHAM")	"BHM")
						((wcmatch divp "EASTERN DI")	"EAS")
						((wcmatch divp "MOBILE DIV")	"MOB")
						((wcmatch divp "SOUTHEAST ")	"SOE")
						((wcmatch divp "SOUTHERN D")	"SOU")
						((wcmatch divp "WESTERN DI")	"WES")
						(T	"BHM")
					)
			id_pre	(cond
						((and (= (substr (StpDot AppNam) 1 4) "ADDS") (= Div "BH"))	"BHM")
						((and (= (substr (StpDot AppNam) 1 4) "ADDS") (= Div "E_"))	"EAS")
						((and (= (substr (StpDot AppNam) 1 4) "ADDS") (= Div "M_"))	"MOB")
						((and (= (substr (StpDot AppNam) 1 4) "ADDS") (= Div "S_"))	"SOU")
						((and (= (substr (StpDot AppNam) 1 4) "ADDS") (= Div "SE"))	"SOE")
						((and (= (substr (StpDot AppNam) 1 4) "ADDS") (= Div "W_"))	"WES")
						((wcmatch divp "POWER DELI")	"SHR")
						((wcmatch divp "BIRMINGHAM")	"BHM")
						((wcmatch divp "EASTERN DI")	"EAS")
						((wcmatch divp "MOBILE DIV")	"MOB")
						((wcmatch divp "SOUTHEAST ")	"SOE")
						((wcmatch divp "SOUTHERN D")	"SOU")
						((wcmatch divp "WESTERN DI")	"WES")
						(T	"BHM")
					)
			Div		(cond
						((wcmatch id_pre "SHR") "BH")
						((wcmatch id_pre "BHM") "BH")
						((wcmatch id_pre "EAS") "E_")
						((wcmatch id_pre "MOB") "M_")
						((wcmatch id_pre "SOE") "SE")
						((wcmatch id_pre "SOU") "S_")
						((wcmatch id_pre "WES") "W_")
						(T	"BH")
					)
			id		(strcat "DS_" id_pre "_000001")
			Dnam		(strcase (getvar "DWGNAME"))
			AttLst	(list	"##"
							"AMP"
							"AMP_BP"
							"AMP_OCR"
							"AMP_SW1"
							"AMP_SW2"
							"AMPS"
							"ATS"
							"B_INDICATOR"
							"BREAKER"
							"BYP"
							"BYPASS"
							"CAPACITOR"
							"COMPUTER-PT"
							"CUST-NAME"
							"DESCRIP"
							"EQUIP"
							"FUSE"
							"KVAR"
							"L_INDICATOR"
							"LOAD"
							"NAME"
							"NUMBER"
							"PARCEL#"
							"RATING"
							"RISER"
							"RTU"
							"S_INDICATOR"
							"SIZE"
							"SM"
							"SOURCE"
							"SUBSTATION"
							"SW1"
							"SW2"
							"SWITCH"
							"TRAN_ID"
							"TYPE"
							"TYPE_OCR"
					)
			HdrLst	(cons "Feeder_Name" AttLst)
			HdrLst	(cons "PanelName" HdrLst)
			HdrLst	(cons "LayName" HdrLst)
			HdrLst	(cons "Northing" HdrLst)
			HdrLst	(cons "Easting" HdrLst)
			HdrLst	(cons "BlockName" HdrLst)
			HdrLst	(cons "Uniq_ID" HdrLst)
	)
	(if (not _Path-Sub)
		(setq	_Path-Sub		"http:\\\\powerdelivery.southernco.com\\apc\\div\\BD\\sub_single_line\\")
	)
	(if (not _Path-User)
		(setq	_Path-User	"S:\\Workgroups\\APC Birmingham Division\\Division Mapping\\Adds\\USER\\")
	)
	(if (not Enam)
		(progn
			(if (= (substr Dnam (- (strlen Dnam) 3)) ".DWG")
				(setq	Dnam		(substr Dnam 1 (- (strlen Dnam) 4)))
			)
			(setvar "CMDECHO" 0)
			(command)
			(command "_.Layer" "T" "*" "ON" "*" "U" "*" "S" "0" "" "_.Zoom" "E")
		)
	)
	(setq	APID		"ID")
	(if (null (tblsearch "APPID" APID))
		(regapp APID)
	)
	(setq	APID		"PE_URL")
	(if (null (tblsearch "APPID" APID))
		(regapp APID)
	)
	(setq	APID		"PLANT_ID")
	(if (null (tblsearch "APPID" APID))
		(regapp APID)
	)
	(setq	APID		"LINE_ID")
	(if (null (tblsearch "APPID" APID))
		(regapp APID)
	)
	(if (not Enam)
		(setq	ssAllObjects		(ssget "X"	(list	(cons -4 "<OR")
														(cons -4 "<AND")
															(cons 0 "*POLYLINE")
															(cons -4 "<OR")
																(cons 8 "????CK-???")
																(cons 8 "????FL-???")
															(cons -4 "OR>")
														(cons -4 "AND>")
														(cons -4 "<AND")
															(cons 0 "INSERT")
															(cons -4 "<OR")
																(cons 2 "CS")
																(cons 2 "CS2")
																(cons 2 "CR")
																(cons 2 "_SS")
																(cons 2 "_SSR")
																(cons 2 "NEWSS")
																(cons 2 "DS")
																(cons 2 "DS2")
																(cons 2 "DR")
																(cons 2 "GS")
																(cons 2 "GS2")
																(cons 2 "GR")
																(cons 2 "RISER")
																(cons 2 "SMS")
																(cons 2 "SECT")
																(cons 2 "_SECT")
																(cons 2 "_OCR*")
																(cons 2 "RECL*")
																(cons 2 "NO")
																(cons 2 "MOGS")
																(cons 2 "SUB")
																(cons 2 "SUB2")
															(cons -4 "OR>")
														(cons -4 "AND>")
													(cons -4 "OR>")
											)
								)
		)
		(setq	ssAllObjects		(ssadd)
				ssAllObjects		(ssadd Enam ssAllObjects)
		)
	)
	(setq	date2	(rtos (getvar "CDATE") 2 4)
			year2	(substr date2 3 2)
			month2	(substr date2 5 2)
			day2		(substr date2 7 2)
			hrs2		(substr date2 10 2)
			min2		(substr date2 12 2)
			date3	(strcat month2 "/" day2 "/20" year2)
			time2	(strcat hrs2 ":" min2)
			dtm		(strcat date3 " " time2)
			i		0
			MaxCnt	(if ssAllObjects
						(sslength ssAllObjects)
						0
					)
			co		"0"
	)
	(princ (strcat "\n\nStarting ID:" id "-" (itoa i)))
	(if ssAllObjects
		(princ (strcat "\nCoolUm is processing {" (itoa MaxCnt) "} items...\n"))
	)
	(if ssAllObjects
		(while (< i MaxCnt)
			(setq	url		""
					ln_id	""
					pid		""
					num		""
					b		(entget (ssname ssAllObjects i) (list "ID"))
					lay		(cdr (assoc 8 b))
					hd		(cdr (assoc 5 b))
					ObLst	(MakLst "" (length AttLst))
			)
			(if (not Bug)
				(if (not Enam)
					(Twaddle i MaxCnt)
				)
			)
			(if (not (assoc -3 b))
				(setq	b		(entget (ssname ssAllObjects i))
						APID		"ID"
						objp		(cond
									((wcmatch (cdr (assoc 0 b)) "*POLYLINE") "DP_")
									((wcmatch (cdr (assoc 0 b)) "INSERT") "DS_")
									((wcmatch (cdr (assoc 0 b)) "*TEXT") "DT_")
									(T "DG_")
								)
						id		(strcat objp id_pre "_" (itoa (GetNextID)))
						UnkLst	(cons id UnkLst)
						xd		(list APID (cons 1000 id))
						xd		(list -3 xd)
						Bubba	(entmod (append b (list xd)))
						Bubba	(entupd (cdr (assoc -1 b)))
						Bubba	(if GtAdded
									(setq	GtAdded	(strcat GtAdded "+" "\n{" id "-" (itoa i) "}"))
									(setq	GtAdded	(strcat "\n{" id "-" (itoa i) "}"))
								)
						Bubba	(if Bug
									(princ (strcat "::" id "-" (itoa i) ";"))
								)
				)
				(if (or ForceUpd (member (cdadr (assoc "ID" (cdr (assoc -3 b)))) UnkLst))
					(setq	b		(entget (ssname ssAllObjects i) (list "*"))
							b1		(cdr (assoc -3 b))
							APID		"ID"
							objp		(cond
										((wcmatch (cdr (assoc 0 b)) "*POLYLINE") "DP_")
										((wcmatch (cdr (assoc 0 b)) "INSERT") "DS_")
										((wcmatch (cdr (assoc 0 b)) "*TEXT") "DT_")
										(T "DG_")
									)
							id		(strcat objp id_pre "_" (itoa (GetNextID)))
							UnkLst	(cons id UnkLst)
							xd		(list "ID" (cons 1000 id))
							xd		(subst xd (assoc "ID" b1) b1)
							xd		(cons -3 xd)
							b		(subst xd (assoc -3 b) b)
							Bubba	(entmod b)
							Bubba	(if GtAdded
										(setq	GtAdded	(strcat GtAdded "#" "\n{" id "-" (itoa i) "}"))
										(setq	GtAdded	(strcat "\n{" id "-" (itoa i) "}"))
									)
							Bubba	(if Bug
										(if ForceUpd
											(princ (strcat "||" id "-" (itoa i) "|"))
											(princ (strcat "**" id "-" (itoa i) "*"))
										)
									)
					)
					(setq	oid		(cdadr (assoc "ID" (cdr (assoc -3 b))))
							b		(entget (ssname ssAllObjects i) (list "*"))
							b1		(cdr (assoc -3 b))
							APID		"ID"
							objp		(cond
										((wcmatch (cdr (assoc 0 b)) "*POLYLINE") "DP_")
										((wcmatch (cdr (assoc 0 b)) "INSERT") "DS_")
										((wcmatch (cdr (assoc 0 b)) "*TEXT") "DT_")
										(T "DG_")
									)
							id		(strcat objp id_pre "_" (substr oid 8))
							UnkLst	(cons id UnkLst)
							xd		(list "ID" (cons 1000 id))
							xd		(subst xd (assoc "ID" b1) b1)
							xd		(cons -3 xd)
							b		(subst xd (assoc -3 b) b)
							Bubba	(entmod b)
							Bubba	(if Bug
										(princ (strcat "@@" id "-" (itoa i) "@"))
									)
					)
				)
			)
			(if (or (and (= (cdr (assoc 0 b)) "INSERT") (= (cdr (assoc 66 b)) 1)) (= (cdr (assoc 0 b)) "POLYLINE"))
				(setq	bnex		b)
			)
			(if (and (= (cdr (assoc 0 b)) "INSERT") (= (cdr (assoc 66 b)) 1))
				(while (/= (cdr (assoc 0 (setq bnex (entget (entnext (cdr (assoc -1 bnex))))))) "SEQEND")
					(if (member (cdr (assoc 2 bnex)) AttLst)
						(setq	AttPos	(- (length AttLst) (length (member (cdr (assoc 2 bnex)) AttLst))))
						(setq	AttPos	nil)
					)
					(if AttPos
						(setq	ObLst	(RepLst ObLst (StpBadChar (cdr (assoc 1 bnex)) 2) AttPos))
					)
				)
			)
			(if (= (cdr (assoc 0 b)) "POLYLINE")
				(setq	Eas	(cadr (assoc 10 (setq bnex (entget (entnext (cdr (assoc -1 bnex)))))))
						Nor	(caddr (assoc 10 bnex))
				)
				(setq	Eas	(cadr (assoc 10 b))
						Nor	(caddr (assoc 10 b))
				)
			)
			(setq	ObLst	(cons (substr lay 1 3) ObLst)
					ObLst	(cons Dnam ObLst)
					ObLst	(cons lay ObLst)
					ObLst	(cons (rtos Nor 2 4) ObLst)
					ObLst	(cons (rtos Eas 2 4) ObLst)
					ObLst	(if (= (cdr (assoc 0 b)) "INSERT")
								(cons (strcase (cdr (assoc 2 b))) ObLst)
								(cons (strcase (cdr (assoc 0 b))) ObLst)
							)
					ObLst	(cons id ObLst)
			)
			(if (= (cdr (assoc 0 b)) "INSERT")
				(if MstLst
					(setq	MstLst	(cons ObLst MstLst))
					(setq	MstLst	(list ObLst))
				)
			)
			(if	(or	(/= (cdr (assoc 0 b)) "INSERT")
					(and
						(and
							(= (cdr (assoc 0 b)) "INSERT")
							(/= (cdr (assoc 2 b)) "SUB")
						)
						(and
							(= (cdr (assoc 0 b)) "INSERT")
							(/= (cdr (assoc 2 b)) "SUB2")
						)
					)
				)
				(StmpUrl (cdr (assoc -1 b)))
			)
			(setq	i	(1+ i))
		)
	)
	(if ssAllObjects
		(if Bug
			(princ "\n**")
		)
	)
	(if ssAllObjects
		(if (not Bug)
			(if (not Enam)
				(Twaddle (- 0 i) MaxCnt)
			)
		)
	)
	(if ssAllObjects
		(progn
			(setq	f		(open (strcat "h:/data/access/Adds_Master.txt") "a"))
			(foreach	NObLst
					MstLst
					(write-line (FrmObLstOut NObLst) f)
			)
			(close f)
		)
	)
	(if GtAdded
		(princ	(strcat "\nCoolUm added these id's:" GtAdded))
	)
	(princ (strcat "\n\nEnding ID:" id "-" (itoa i)))
	(if ssAllObjects
		(if (not (= (substr (StpDot AppNam) 1 4) "ADDS"))
			(command "_.Qsave")
		)
	)
	(if Bug (princ "\nCoolUm exited}\n"))
	(princ)
)

(defun StmpLineID ( En /	ItmStr Booga )		; Assigns Stomp Line_ID
	(if (not En)
		(setq	En	(car (entsel)))
	)
	(setq	ItmStr	"LINE_ID"
			Booga	(XCutLstR ItmStr En)
	)
	(command "_.Erase" En "")
	(if (/= (car Booga) "CUD")
		(entmake Booga)
		(progn
			(entmake (nth 1 Booga))
			(foreach	Thngy
					(nth 2 Booga)
					(entmake Thngy)
			)
		)
	)
	(princ)
)

(defun StmpPlantID ( En /	ItmStr Booga )		; Assigns Stomp Plant_ID
	(if (not En)
		(setq	En	(car (entsel)))
	)
	(setq	ItmStr	"PLANT_ID"
			Booga	(XCutLstR ItmStr En)
	)
	(command "_.Erase" En "")
	(if (/= (car Booga) "CUD")
		(entmake Booga)
		(progn
			(entmake (nth 1 Booga))
			(foreach	Thngy
					(nth 2 Booga)
					(entmake Thngy)
			)
		)
	)
	(princ)
)

(defun StdSym ( / SS C ENTnam ENTlst )			; Modifies ADDS symbols to southern standards
	(if (= (substr (getvar "ACADVER") 1 2) "14")
		(setvar "PLINETYPE" 0)
	)
	(if (setq SS (ssget "X" (list (cons 0 "INSERT"))))
		(progn
			(setq	test1ang	(* pi 0.50)
					test2ang	(* pi 1.50)
					angtol	(* pi (/ 1.0 180.0))
			)
			(setq	UNtouched	(list)
					C		0
			)
		   	(command "insert" "*stdsym" (list 0 0) "" "")
			(repeat (sslength SS)
				(setq	ENTnam	(ssname SS C)
						ENTlst	(entget ENTnam)
						oldblk	(cdr (assoc 2 ENTlst))
				)
				(cond
  	    				((= oldblk "REGARR")
						(command "erase" ENTnam "")
					)
  	    				((or (= oldblk "CS") (= oldblk "CS2"))
						(setq	newblk	"125A")
						(setCSvar)  ;SETS sc, ang, oldpt1, newpt1, midpt, newpt2, oldpt2.
        	      			(setq	ENTlst	(subst (cons 2 newblk) (assoc 2 ENTlst) ENTlst)
           	   					ENTlst	(subst (cons 10 midpt) (assoc 10 ENTlst) ENTlst)
						)
						(if (< (cdr (assoc 42 ENTlst)) 0)
							(setq	ENTlst	(subst (cons 42 (abs (cdr (assoc 42 ENTlst)))) (assoc 42 ENTlst) ENTlst))
						)
						(entmod ENTlst)
						(ShiftAtt 0.125)  ;Moves attribute so it doesn't overlap new blade position.
						(command "copy" ENTnam "" (list 0 0) (list 0 0) "erase" ENTnam "")
					)
		  	    		((or (= oldblk "NEWSS") (= oldblk "_SS"))
						(setq	newblk	"125B")
						(setCSvar)  ;SETS sc, ang, oldpt1, newpt1, midpt, newpt2, oldpt2.
        	      			(setq	ENTlst	(subst (cons 2 newblk) (assoc 2 ENTlst) ENTlst)
           	   					ENTlst	(subst (cons 10 midpt) (assoc 10 ENTlst) ENTlst)
						)
						(if (< (cdr (assoc 42 ENTlst)) 0)
							(setq	ENTlst	(subst (cons 42 (abs (cdr (assoc 42 ENTlst)))) (assoc 42 ENTlst) ENTlst))
						)
						(entmod ENTlst)
						(command "copy" ENTnam "" (list 0 0) (list 0 0) "erase" ENTnam "")
					)
  	    				((or (= oldblk "DS") (= oldblk "DS2"))
						(setq	newblk	"124A")
						(setCSvar)  ;SETS sc, ang, oldpt1, newpt1, midpt, newpt2, oldpt2.
						(setq	ENTlst	(subst (cons 2 newblk) (assoc 2 ENTlst) ENTlst)
								ENTlst	(subst (cons 10 midpt) (assoc 10 ENTlst) ENTlst)
						)
						(if (< (cdr (assoc 42 ENTlst)) 0)
							(setq	ENTlst	(subst (cons 42 (abs (cdr (assoc 42 ENTlst)))) (assoc 42 ENTlst) ENTlst))
						)
						(entmod ENTlst)
						(ShiftAtt 0.125)  ;Moves attribute so it doesn't overlap new blade position.
						(command "copy" ENTnam "" (list 0 0) (list 0 0) "erase" ENTnam "")
					)
  	    				((or (= oldblk "GS") (= oldblk "GS2"))
						(setq	newblk	"126A")
			        	     (setCSvar)  ;SETS sc, ang, oldpt1, newpt1, midpt, newpt2, oldpt2.
			        	     (setq	ENTlst	(subst (cons 2 newblk) (assoc 2 ENTlst) ENTlst)
           	   					ENTlst	(subst (cons 10 midpt) (assoc 10 ENTlst) ENTlst)
						)
						(if (< (cdr (assoc 42 ENTlst)) 0)
							(setq	ENTlst	(subst (cons 42 (abs (cdr (assoc 42 ENTlst)))) (assoc 42 ENTlst) ENTlst))
						)
						(entmod ENTlst)
						(ShiftAtt 0.125)  ;Moves attribute so it doesn't overlap new blade position.
						(command "copy" ENTnam "" (list 0 0) (list 0 0) "erase" ENTnam "")
					)
  	    				((= oldblk "CR")
						(setq	newblk	"125A")
						(setCRvar)  ;SETS sc, ang, oldpt1, newpt1, midpt, newpt2, oldpt2, rsc, rpt.
						(setq	ENTlst	(subst (cons 2 newblk) (assoc 2 ENTlst) ENTlst)
								ENTlst	(subst (cons 10 midpt) (assoc 10 ENTlst) ENTlst)
								ENTlst	(subst (cons 41 sc) (assoc 41 ENTlst) ENTlst)
								ENTlst	(subst (cons 42 sc) (assoc 42 ENTlst) ENTlst)
						)
						(entmod ENTlst)
						(ShiftAtt 0.125)  ;Moves attribute so it doesn't overlap new blade position.
  	    					(command "insert" "140" rpt rsc rsc (rtd ang) "chprop" (entlast) "" "LA" (cdr (assoc 8 ENTlst)) "" "copy" ENTnam "" (list 0 0) (list 0 0) "erase" ENTnam "")
					)
     				(T
     					(if (not (member oldblk UNtouched))
     						(setq	UNtouched	(cons oldblk UNtouched))
						)
					)
				)
				(setq	C	(1+ C))
			)
		)
	)
	(princ)
)

(defun setCSvar ( / )						; SETS sc, ang, oldpt1, newpt1, midpt, newpt2, oldpt2.
	(setq	sc		(cdr (assoc 41 ENTlst))
		  	ang		(cdr (assoc 50 ENTlst))
		  	oldpt1	(cdr (assoc 10 ENTlst))
		  	newpt1	(polar oldpt1 ang (1- (/ sc 2.0)))
		  	midpt	(polar oldpt1 ang (/ sc 2.0))
		  	newpt2	(polar oldpt1 ang (1+ (/ sc 2.0)))
		  	oldpt2	(polar oldpt1 ang sc)
	)
)

(defun setCRvar ( / )						; SETS sc, ang, oldpt1, newpt1, midpt, newpt2, oldpt2, rsc, rpt.
	(setq	sc		(* (cdr (assoc 41 ENTlst)) (/ 0.25 0.34))
		  	ang		(cdr (assoc 50 ENTlst))
		  	oldpt1	(cdr (assoc 10 ENTlst))
		  	newpt1	(polar oldpt1 ang (1- (/ sc 2.0)))
		  	midpt	(polar oldpt1 ang (/ sc 2.0))
		  	newpt2	(polar oldpt1 ang (1+ (/ sc 2.0)))
			rsc		(* (cdr (assoc 41 ENTlst)) (/ 0.09 0.34))
		  	rpt		(polar oldpt1 ang (+ sc (/ rsc 2.0)))
		  	oldpt2	(polar oldpt1 ang (+ sc rsc))
	)
)

(defun ShiftAtt ( pcentOFsc / )				; pass % of scale to move away from blade. i.e 0.1166 for CS.
	;Everything is global!!! Moves attribute so it doesn't overlap new blade position.
	(setq	SUBent	(entnext ENTnam)
			SUBlst	(entget SUBent)
			SUBang	(cdr (assoc 50 SUBlst))
	)
 	(if	(or	(equal (abs (- ang SUBang)) test1ang angtol)
 			(equal (abs (- ang SUBang)) test2ang angtol)
		)
 		(progn
	   		(if (> (car (assoc 72 SUBlst)) 0)
	    	   		(setq	SUBlst	(subst (cons 11 (polar (cdr(assoc 11 SUBlst)) (- ang pi) (* sc pcentOFsc))) (assoc 11 SUBlst) SUBlst))
			   	(setq	SUBlst	(subst (cons 10 (polar (cdr(assoc 10 SUBlst)) (- ang pi) (* sc pcentOFsc))) (assoc 10 SUBlst) SUBlst))
			)
			(entmod SUBlst)
			(setq	SUBent	(entnext SUBent)
					SUBlst	(entget SUBent)
					SUBang	(cdr (assoc 50 SUBlst))
			)
			(if (> (car (assoc 72 SUBlst)) 0)
	        		(setq	SUBlst	(subst (cons 11 (polar (cdr(assoc 11 SUBlst)) (- ang pi) (* sc pcentOFsc))) (assoc 11 SUBlst) SUBlst))
	   		  	(setq	SUBlst	(subst (cons 10 (polar (cdr(assoc 10 SUBlst)) (- ang pi) (* sc pcentOFsc))) (assoc 10 SUBlst) SUBlst))
	 		)
	 		(entmod SUBlst)
 		)
 	)
)

(defun BlkNoFnd ( ExcpLst /	NoCntr ssP NoDat	; Determine valid N.O. Device state
						Cntr InCntr NoLen NoPnt NoHnd NoHgt NoLst NoAtt NoNam
						NoFndHnd NoMatchLst MultMatchLst FineMatchLst EnDat EnLst EnPnt
						ssHand NoShwLst FuzzHnd NoSel NoStaSel NoStaVal ssO FstPic
						NoFuzzLen NoFuzzHnd NoFuzzStr NoDevLst NoIgnore BlkFltLst BigDat
						IssNum ifile ptx pty PanelNam IssData
						NoDevHndLst NoDevEnt NoDevBlk NoDevHnd NoDevLay NoDevAtt NoFlag )
	(setq	NoCntr		0
			ssP			nil
			ssO			nil
			NoShwLst		nil
			NoFndHnd		(nth 0 ExcpLst)
			NoMatchLst	(nth 1 ExcpLst)
			MultMatchLst	(nth 2 ExcpLst)
			FineMatchLst	(nth 3 ExcpLst)
	)
	(foreach	NoDat
			BlkDatNoLst
			(setq	Cntr		0
					NoLen	600000.0
					NoPnt	(nth 3 NoDat)
					NoHnd	(nth 1 NoDat)
					NoHgt	(abs (nth 4 NoDat))
					NoLst	nil
					NoSel	nil
					NoStaSel	nil
					NoFuzzLen	(* 0.16 PnScl)	;was 0.3125
					NoFuzzHnd	nil
					NoFuzzStr	nil
					ssHand	nil
					NoDevLst	nil
					NoIgnore	nil
					NoStaSel	nil
					NoStaVal	nil
					ssO		nil
					FstPic	nil
					EnDat	nil
					EnLst	nil
					EnPnt	nil
					BlkFltLst	(reverse (mapcar (quote (lambda (x) (cons 2 x))) BlkNoDev))
					BlkFltLst	(cons (cons -4 "OR>") BlkFltLst)
					BlkFltLst	(cons (cons 0 "INSERT") BlkFltLst)
					BlkFltLst	(cons (cons -4 "<OR") (reverse BlkFltLst))
					Bubba	(command "_.Zoom" "C" NoPnt (* 0.75 PnScl))
					ssP		(ssget "C"	(list	(- (car NoPnt) (* 0.45 NoHgt))
												(- (cadr NoPnt) (* 0.45 NoHgt))
										)
										(list	(+ (car NoPnt) (* 0.45 NoHgt))
												(+ (cadr NoPnt) (* 0.45 NoHgt))
										)
										BlkFltLst
							)
			)
			(if (> (length NoFndHnd) 0)	;If there are Inserts with N.O. in an Attribute...
				(foreach	BigDat
						NoFndHnd
						(if	(equal (nth 2 (assoc BigDat BlkDatHndLst)) NoPnt NoFuzzLen)	;and if it is close enough...
							(if NoFuzzHnd
								(setq	NoFuzzHnd	(cons BigDat NoFuzzHnd)
										NoAtt	(if (= (nth 8 (assoc BigDat BlkDatHndLst)) 1)
													(nth 1 (nth 1 (nth 9 (assoc BigDat BlkDatHndLst))))
													"None"
												)
										NoNam	(cdr (assoc 2 (entget (handent BigDat))))
										NoLay	(cdr (assoc 8 (entget (handent BigDat))))
										NoFuzzStr	(cons (strcat "\n\tItem:[" (itoa (1+ Cntr)) "] Block:[" NoNam "] Layer:[" NoLay "] Att:[" NoAtt "]\n\t\t{Has N.O. in Attribute Data!}") NoFuzzStr)
										Cntr		(1+ Cntr)
								)
								(setq	NoFuzzHnd	(list BigDat)
										NoAtt	(if (= (nth 8 (assoc BigDat BlkDatHndLst)) 1)
													(nth 1 (nth 1 (nth 9 (assoc BigDat BlkDatHndLst))))
													"None"
												)
										NoNam	(cdr (assoc 2 (entget (handent BigDat))))
										NoLay	(cdr (assoc 8 (entget (handent BigDat))))
										NoFuzzStr	(list (strcat "\n BlkNoFnd Multiple Choice={" (itoa (1+ NoCntr)) "} (" (nth 2 NoDat) ")") "\n********** BlkNoFnd **********")
										NoFuzzStr	(cons (strcat "\n\tItem:[" (itoa (1+ Cntr)) "] Block:[" NoNam "] Layer:[" NoLay "] Att:[" NoAtt "]\n\t\t{Has N.O. in Attribute Data!}") NoFuzzStr)
										Cntr		(1+ Cntr)
								)
							)
						)
				)
			)
			(if (> (length NoMatchLst) 0)	;If there are Inserts with Different Circuit on either end...
				(foreach	BigDat
						NoMatchLst
						(if	(or (equal (nth 1 BigDat) NoPnt NoFuzzLen) (equal (nth 2 BigDat) NoPnt NoFuzzLen))		;and if either end is close enough...
							(if NoFuzzHnd
								(if (not (member (nth 0 BigDat) NoFuzzHnd))									;and it is not already in this list...
									(setq	NoFuzzHnd	(cons (nth 0 BigDat) NoFuzzHnd)
											NoAtt	(if (= (nth 8 (assoc (nth 0 BigDat) BlkDatHndLst)) 1)
														(nth 1 (nth 1 (nth 9 (assoc (nth 0 BigDat) BlkDatHndLst))))
														"None"
													)
											NoNam	(cdr (assoc 2 (entget (handent (nth 0 BigDat)))))
											NoLay	(cdr (assoc 8 (entget (handent (nth 0 BigDat)))))
											NoFuzzStr	(cons (strcat "\n\tItem:[" (itoa (1+ Cntr)) "] Block:[" NoNam "] Layer:[" NoLay "] Att:[" NoAtt "]\n\t\t{Not Same Circuit both sides!}") NoFuzzStr)
											Cntr		(1+ Cntr)
									)
								)
								(setq	NoFuzzHnd	(list (nth 0 BigDat))
										NoAtt	(if (= (nth 8 (assoc (nth 0 BigDat) BlkDatHndLst)) 1)
													(nth 1 (nth 1 (nth 9 (assoc (nth 0 BigDat) BlkDatHndLst))))
													"None"
												)
										NoNam	(cdr (assoc 2 (entget (handent (nth 0 BigDat)))))
										NoLay	(cdr (assoc 8 (entget (handent (nth 0 BigDat)))))
										NoFuzzStr	(list (strcat "\n BlkNoFnd Multiple Choice={" (itoa (1+ NoCntr)) "} (" (nth 2 NoDat) ")") "\n********** BlkNoFnd **********")
										NoFuzzStr	(cons (strcat "\n\tItem:[" (itoa (1+ Cntr)) "] Block:[" NoNam "] Layer:[" NoLay "] Att:[" NoAtt "]\n\t\t{Not Same Circuit both sides!}") NoFuzzStr)
										Cntr		(1+ Cntr)
								)
							)
						)
				)
			)
			(if (> (length MultMatchLst) 0)	;If there are Inserts with Multiple Circuits on either end...
				(foreach	BigDat
						MultMatchLst
						(if	(or (equal (nth 1 BigDat) NoPnt NoFuzzLen) (equal (nth 2 BigDat) NoPnt NoFuzzLen))		;and if either end is close enough...
							(if NoFuzzHnd
								(if (not (member (nth 0 BigDat) NoFuzzHnd))									;and it is not already in this list...
									(setq	NoFuzzHnd	(cons (nth 0 BigDat) NoFuzzHnd)
											NoAtt	(if (= (nth 8 (assoc (nth 0 BigDat) BlkDatHndLst)) 1)
														(nth 1 (nth 1 (nth 9 (assoc (nth 0 BigDat) BlkDatHndLst))))
														"None"
													)
											NoNam	(cdr (assoc 2 (entget (handent (nth 0 BigDat)))))
											NoLay	(cdr (assoc 8 (entget (handent (nth 0 BigDat)))))
											NoFuzzStr	(cons (strcat "\n\tItem:[" (itoa (1+ Cntr)) "] Block:[" NoNam "] Layer:[" NoLay "] Att:[" NoAtt "]\n\t\t{Multiple Circuits on at least one side!}") NoFuzzStr)
											Cntr		(1+ Cntr)
									)
								)
								(setq	NoFuzzHnd	(list (nth 0 BigDat))
										NoAtt	(if (= (nth 8 (assoc (nth 0 BigDat) BlkDatHndLst)) 1)
													(nth 1 (nth 1 (nth 9 (assoc (nth 0 BigDat) BlkDatHndLst))))
													"None"
												)
										NoNam	(cdr (assoc 2 (entget (handent (nth 0 BigDat)))))
										NoLay	(cdr (assoc 8 (entget (handent (nth 0 BigDat)))))
										NoFuzzStr	(list (strcat "\n BlkNoFnd Multiple Choice={" (itoa (1+ NoCntr)) "} (" (nth 2 NoDat) ")") "\n********** BlkNoFnd **********")
										NoFuzzStr	(cons (strcat "\n\tItem:[" (itoa (1+ Cntr)) "] Block:[" NoNam "] Layer:[" NoLay "] Att:[" NoAtt "]\n\t\t{Multiple Circuits on at least one side!}") NoFuzzStr)
										Cntr		(1+ Cntr)
								)
							)
						)
				)
			)
			(if (> (length FineMatchLst) 0)	;If there are Inserts with the Exactly Right Circuit on both ends...
				(foreach	BigDat
						FineMatchLst
						(if	(or (equal (nth 1 BigDat) NoPnt NoFuzzLen) (equal (nth 2 BigDat) NoPnt NoFuzzLen))		;and if either end is close enough...
							(if NoFuzzHnd
								(if (not (member (nth 0 BigDat) NoFuzzHnd))									;and it is not already in this list...
									(setq	NoFuzzHnd	(cons (nth 0 BigDat) NoFuzzHnd)
											NoAtt	(if (= (nth 8 (assoc (nth 0 BigDat) BlkDatHndLst)) 1)
														(nth 1 (nth 1 (nth 9 (assoc (nth 0 BigDat) BlkDatHndLst))))
														"None"
													)
											NoNam	(cdr (assoc 2 (entget (handent (nth 0 BigDat)))))
											NoLay	(cdr (assoc 8 (entget (handent (nth 0 BigDat)))))
											NoFuzzStr	(cons (strcat "\n\tItem:[" (itoa (1+ Cntr)) "] Block:[" NoNam "] Layer:[" NoLay "] Att:[" NoAtt "]\n\t\t{Matches Circuit on both sides!}") NoFuzzStr)
											Cntr		(1+ Cntr)
									)
								)
								(setq	NoFuzzHnd	(list (nth 0 BigDat))
										NoAtt	(if (= (nth 8 (assoc (nth 0 BigDat) BlkDatHndLst)) 1)
													(nth 1 (nth 1 (nth 9 (assoc (nth 0 BigDat) BlkDatHndLst))))
													"None"
												)
										NoNam	(cdr (assoc 2 (entget (handent (nth 0 BigDat)))))
										NoLay	(cdr (assoc 8 (entget (handent (nth 0 BigDat)))))
										NoFuzzStr	(list (strcat "\n BlkNoFnd Multiple Choice={" (itoa (1+ NoCntr)) "} (" (nth 2 NoDat) ")") "\n********** BlkNoFnd **********")
										NoFuzzStr	(cons (strcat "\n\tItem:[" (itoa (1+ Cntr)) "] Block:[" NoNam "] Layer:[" NoLay "] Att:[" NoAtt "]\n\t\t{Matches Circuit on both sides!}") NoFuzzStr)
										Cntr		(1+ Cntr)
								)
							)
						)
				)
			)
			(if ssP
				(cond
					((> (sslength ssP) 1)
						(princ "\n********** BlkNoFnd **********")
						(princ (strcat "\n BlkNoFnd Multiple Choice={" (itoa (1+ NoCntr)) "} (" (nth 2 NoDat) ") [" (itoa (sslength ssP)) "]"))
						(setq	InCntr		0
								Bubba		(NoCir NoPnt NoFuzzLen)
								NoDevHndLst	(list "0")
						)
						(if NoTrbLst
							(setq	NoTrbLst	(cons NoCntr NoTrbLst))
							(setq	NoTrbLst	(list NoCntr))
						)
						(while (< InCntr (sslength ssP))
							(setq	NoDevEnt		(entget (ssname ssP InCntr))
									NoDevBlk		(cdr (assoc 2 NoDevEnt))
									NoDevHnd		(cdr (assoc 5 NoDevEnt))
									NoDevLay		(cdr (assoc 8 NoDevEnt))
									NoDevHndLst	(cons NoDevHnd NoDevHndLst)
									NoDevAtt		(if (= (nth 8 (assoc NoDevHnd BlkDatHndLst)) 1)
													(nth 1 (nth 1 (nth 9 (assoc NoDevHnd BlkDatHndLst))))
													"None"
												)
							)
							(cond
								((and (assoc NoDevHnd NoMatchLst) (member NoDevHnd NoFndHnd))
									(setq	NoFlag	"\n\t\t{Not Same Circuit both sides,\n\t\tand N.O. in Attribute Data!}")
								)
								((and (assoc NoDevHnd MultMatchLst) (member NoDevHnd NoFndHnd))
									(setq	NoFlag	"\n\t\t{Multiple Circuits on at least one side,\n\t\tand N.O. in Attribute Data!}")
								)
								((and (assoc NoDevHnd FineMatchLst) (member NoDevHnd NoFndHnd))
									(setq	NoFlag	"\n\t\t{Same Circuit on both sides,\n\t\tand N.O. in Attribute Data!}")
								)
								((assoc NoDevHnd NoMatchLst)
									(setq	NoFlag	"\n\t\t{Not Same Circuit both sides!}")
								)
								((assoc NoDevHnd MultMatchLst)
									(setq	NoFlag	"\n\t\t{Multiple Circuits on at least one side!}")
								)
								((assoc NoDevHnd FineMatchLst)
									(setq	NoFlag	"\n\t\t{Same Circuit on both sides!}")
								)
								((member NoDevHnd NoFndHnd)
									(setq	NoFlag	"\n\t\t{N.O. in Attribute Data!}")
								)
								(T
									(setq	NoFlag	"\n\t\t{No Layer Data}")
								)
							)
							(princ (strcat "\n\tItem:" (itoa (1+ InCntr)) " Block:[" NoDevBlk "] Layer:[" NoDevLay "] Att:[" NoDevAtt "]" NoFlag))
							(setq	InCntr	(1+ InCntr))
						)
						(setq	NoDevHndLst	(cdr (reverse NoDevHndLst)))
						(redraw (handent NoHnd) 3)
						(foreach	FuzzHnd
								NoDevHndLst
								(redraw (handent FuzzHnd) 3)
						)
						(setq	NoSel	-3)
						(while (or (< NoSel 1) (> NoSel (length NoDevHndLst)))
							(initget 1 "Destroy")
							(RWav 2)
							(setq	NoSel	(getint (strcat "\nChoice (1-" (itoa (length (cdr NoDevHndLst))) " or <D>estroy): ")))
							(if (= NoSel "Destroy")
								(setq	NoSel	1
										NoIgnore	T
								)
								(if (and (>= NoSel 1) (<= NoSel (length NoFuzzHnd)))
									(setq	NoDevLst	(assoc (nth (1- NoSel) NoDevHndLst) BlkDatHndLst))
								)
							)
						)
						(foreach	FuzzHnd
								NoDevHndLst
								(redraw (handent FuzzHnd) 4)
						)
						(redraw (handent NoHnd) 4)
					)
					((= (sslength ssP) 1)
						(if Bug
							(princ (strcat "\n {BlkNoFnd} Single ssP choice handled at {" (itoa NoCntr) "}\n"))
						)
						(if	(or	(wcmatch (strcase (cdr (assoc 2 (entget (ssname ssP 0))))) "RECL*")
								(wcmatch (strcase (cdr (assoc 2 (entget (ssname ssP 0))))) "_OCR*")
							)
							(setq	NoSel	1
									NoIgnore	T
									Bubba	(if Bug (princ (strcat "\n {BlkNoFnd} Single ssP choice of {" (strcase (cdr (assoc 2 (entget (ssname ssP 0))))) "} Destroyed at {" (itoa NoCntr) "}\n")))
							)
							(setq	ssHand	(cdr (assoc 5 (entget (ssname ssP 0))))
									NoDevLst	(assoc ssHand BlkDatHndLst)
									Bubba	(if Bug (princ (strcat "\n {BlkNoFnd} Single ssP choice of {" (strcase (cdr (assoc 2 (entget (ssname ssP 0))))) "} handled at {" (itoa NoCntr) "}\n")))
							)
						)
					)
					(T
						(princ (strcat "\n {BlkNoFnd} ssP not counted correctly at {" (itoa NoCntr) "}\n"))
						(setq	ssHand	(cdr (assoc 5 (entget (ssname ssP 0))))
								NoDevLst	(assoc ssHand BlkDatHndLst)
						)
					)
				)
				(if NoFuzzHnd
					(cond
						((> (length NoFuzzHnd) 1)
							(NoCir NoPnt NoFuzzLen)
							(if NoTrbLst
								(setq	NoTrbLst	(cons NoCntr NoTrbLst))
								(setq	NoTrbLst	(list NoCntr))
							)
							(redraw (handent NoHnd) 3)
							(foreach	FuzzHnd
									NoFuzzHnd
									(redraw (handent FuzzHnd) 3)
							)
							(setq	NoSel	-3)
							(while (or (< NoSel 1) (> NoSel (length NoFuzzHnd)))
								(initget 1 "Destroy Flag Open")
								(RWav 2)
								(princ (last NoFuzzStr))
								(princ (strcat (cadr (reverse NoFuzzStr)) " [" (itoa (length NoFuzzHnd)) "]"))
								(mapcar (quote princ) (cddr (reverse NoFuzzStr)))
								(setq	NoSel	(getint	(strcat	"\nChoice (1-"
																(itoa (length NoFuzzHnd))
																" <F>lag for cleanup, <O>pen circuit or <D>estroy): "
														)
												)
								)
								(if (= NoSel "Destroy")
									(setq	NoSel	1
											NoIgnore	T
									)
									(if (= NoSel "Open")
										(progn
											(initget 1 "Yes No")
											(setq	NoSel	1
													NoStaSel	(getkword "Input Station Number? <Yes No>: ")
											)
											(if (= NoStaSel "Yes")
												(setq	NoStaVal	(getstring T "\nStation Number: "))
												(setq	NoStaVal	nil)
											)
											(setq	ssO		(ssget "C"	(list	(- (car NoPnt) (* 0.45 NoHgt))
																				(- (cadr NoPnt) (* 0.45 NoHgt))
																		)
																		(list	(+ (car NoPnt) (* 0.45 NoHgt))
																				(+ (cadr NoPnt) (* 0.45 NoHgt))
																		)
																		(list	(cons 0 "*POLYLINE")
																				(cons 8 "????CK-*")
																		)
															)
											)
											(if ssO
												(cond
													((= (sslength ssO) 1)
														(setq	FstPic		(cons (ssname ssO 0) (list NoPnt))
																EnLst		(GetPLDat FstPic)
																Bubba		(setvar "ATTREQ" 1)
																EnPnt		(polar (nth 1 EnLst) (+ pi (nth 4 EnLst)) (* 0.5 (* 1.041667 (nth 4 NoDat))))
																Bubba		(setvar "CLAYER" (cdr (assoc 8 (entget (ssname ssO 0)))))
																EnWas		(entlast)
																Bubba		(if (> (distance NoPnt EnPnt) (nth 4 NoDat))
																				(if NoStaVal
																					(setq	Bubba	(setvar "OSMODE" 41)
																							EnPnt	(getpoint "\nPlease select the point & rotation to flag the Open Circuit: ")
																							Bubba	(setvar "OSMODE" 0)
																							Bubba	(command "_.Insert" (strcat _Path-Sym "UGOPEN") EnPnt (* 1.041667 (nth 4 NoDat)) (* 1.041667 (nth 4 NoDat)) pause NoStaVal ".")
																					)
																					(setq	Bubba	(setvar "OSMODE" 41)
																							EnPnt	(getpoint "\nPlease select the point & rotation to flag the Open Circuit: ")
																							Bubba	(setvar "OSMODE" 0)
																							Bubba	(command "_.Insert" (strcat _Path-Sym "UGOPEN") EnPnt (* 1.041667 (nth 4 NoDat)) (* 1.041667 (nth 4 NoDat)) pause "." ".")
																					)
																				)
																				(if NoStaVal
																					(command "_.Insert" (strcat _Path-Sym "UGOPEN") EnPnt (* 1.041667 (nth 4 NoDat)) (* 1.041667 (nth 4 NoDat)) (angtos (nth 4 EnLst)) NoStaVal ".")
																					(command "_.Insert" (strcat _Path-Sym "UGOPEN") EnPnt (* 1.041667 (nth 4 NoDat)) (* 1.041667 (nth 4 NoDat)) (angtos (nth 4 EnLst)) "." ".")
																				)
																			)
																EnDat		(EntDatLstR (entlast))
																BlkDatBigLst	(append BlkDatBigLst (list EnDat))
																BlkDatHndLst	(append BlkDatHndLst (list (cdr EnDat)))
																NoDevLst		(cdr EnDat)
																Bubba		(setvar "ATTREQ" 0)
														)
													)
													((> (sslength ssO) 1)
														(setq	FstPic		(cons (ssname ssO 0) (list NoPnt))
																EnLst		(GetPLDat FstPic)
																Bubba		(setvar "ATTREQ" 1)
																EnPnt		(polar (nth 1 EnLst) (+ pi (nth 4 EnLst)) (* 0.5 (* 1.041667 (nth 4 NoDat))))
																Bubba		(setvar "CLAYER" (cdr (assoc 8 (entget (ssname ssO 0)))))
																EnWas		(entlast)
																Bubba		(if (> (distance NoPnt EnPnt) (nth 4 NoDat))
																				(if NoStaVal
																					(setq	Bubba	(setvar "OSMODE" 41)
																							EnPnt	(getpoint "\nPlease select the point & rotation to flag the Open Circuit: ")
																							Bubba	(setvar "OSMODE" 0)
																							Bubba	(command "_.Insert" (strcat _Path-Sym "UGOPEN") EnPnt (* 1.041667 (nth 4 NoDat)) (* 1.041667 (nth 4 NoDat)) pause NoStaVal ".")
																					)
																					(setq	Bubba	(setvar "OSMODE" 41)
																							EnPnt	(getpoint "\nPlease select the point & rotation to flag the Open Circuit: ")
																							Bubba	(setvar "OSMODE" 0)
																							Bubba	(command "_.Insert" (strcat _Path-Sym "UGOPEN") EnPnt (* 1.041667 (nth 4 NoDat)) (* 1.041667 (nth 4 NoDat)) pause "." ".")
																					)
																				)
																				(if NoStaVal
																					(command "_.Insert" (strcat _Path-Sym "UGOPEN") EnPnt (* 1.041667 (nth 4 NoDat)) (* 1.041667 (nth 4 NoDat)) (angtos (nth 4 EnLst)) NoStaVal ".")
																					(command "_.Insert" (strcat _Path-Sym "UGOPEN") EnPnt (* 1.041667 (nth 4 NoDat)) (* 1.041667 (nth 4 NoDat)) (angtos (nth 4 EnLst)) "." ".")
																				)
																			)
																EnDat		(EntDatLstR (entlast))
																BlkDatBigLst	(append BlkDatBigLst (list EnDat))
																BlkDatHndLst	(append BlkDatHndLst (list (cdr EnDat)))
																NoDevLst		(cdr EnDat)
																Bubba		(setvar "ATTREQ" 0)
														)
													)
												)
											)
										)
										(if (= NoSel "Flag")
											(setq	NoSel	1
													NoIgnore	T
													Bubba	(setvar "ATTREQ" 1)
													IssNum	(GetNextISS)
													Bubba	(command "_.Insert" (strcat _Path-Sym "FLAG") NoPnt NoHgt NoHgt 0.0 (itoa IssNum))
													ifile	(open "S:/Workgroups/APC Power Delivery/Division Mapping/Shared Panels/Data/FlgIssue.txt" "a")
													ptx		(* (fix (/ (car NoPnt) XPanel)) XPanel)
													pty		(* (fix (/ (cadr NoPnt) YPanel)) YPanel)
													PanelNam	(BldFn ptx pty)
													IssData	(strcat "Issue {" (PadNum (itoa IssNum) 6) "} in Panel {" PanelNam "} by operator {" (getvar "LOGINNAME") "}")
													Bubba	(if (= (strcase (substr AppNam 1 4)) "ADDS") (write-line IssData ifile))
													Bubba	(close ifile)
											)
											(if (and (>= NoSel 1) (<= NoSel (length NoFuzzHnd)))
												(setq	NoDevLst	(assoc (nth (1- NoSel) (reverse NoFuzzHnd)) BlkDatHndLst))
											)
										)
									)
								)
							)
							(redraw (handent NoHnd) 4)
							(foreach	FuzzHnd
									NoFuzzHnd
									(redraw (handent FuzzHnd) 4)
							)
						)
						((= (length NoFuzzHnd) 1)
							(if Bug
								(princ (strcat "\n {BlkNoFnd} Single Fuzzy choice handled at {" (itoa NoCntr) "}\n"))
							)
							(if	(or	(wcmatch (strcase (cdr (assoc 2 (entget (handent (nth 0 NoFuzzHnd)))))) "RECL*")
									(wcmatch (strcase (cdr (assoc 2 (entget (handent (nth 0 NoFuzzHnd)))))) "_OCR*")
								)
								(setq	NoSel	1
										NoIgnore	T
										Bubba	(if Bug (princ (strcat "\n {BlkNoFnd} Single Fuzzy choice of {" (strcase (cdr (assoc 2 (entget (handent (nth 0 NoFuzzHnd)))))) "} Destroyed at {" (itoa NoCntr) "}\n")))
								)
								(setq	ssHand	(nth 0 NoFuzzHnd)
										NoDevLst	(assoc ssHand BlkDatHndLst)
										Bubba	(if Bug (princ (strcat "\n {BlkNoFnd} Single Fuzzy choice of {" (strcase (cdr (assoc 2 (entget (handent ssHand))))) "} handled at {" (itoa NoCntr) "}\n")))
								)
							)
						)
						(T
;;;							(if Bug
								(princ (strcat "\n {BlkNoFnd} ssP not counted correctly at {" (itoa NoCntr) "}\n"))
;;;							)
							(princ (strcat "\n {BlkNoFnd} NoFuzzHnd not counted correctly!\n"))
							(setq	ssHand	(nth 0 NoFuzzHnd)
									NoDevLst	(assoc ssHand BlkDatHndLst)
							)
						)
					)
;;;					(if Bug
						(princ (strcat "\n {BlkNoFnd} Not all cases handled correctly at {" (itoa NoCntr) "}\n"))
;;;					)
				)
			)
			(setq	NoCntr		(1+ NoCntr))
			(if (and NoHnd NoPnt NoDevLst)
				(setq	NoDevLst	(list	NoHnd
										(nth 0 NoDevLst)
										NoPnt
										(nth 2 NoDevLst)
								)
				)
				(if NoIgnore
					(setq	NoDevLst	(list NoHnd nil NoPnt nil))
				)
			)
			(if NoDevLst
				(if NoShwLst
					(setq	NoShwLst	(append NoShwLst (list NoDevLst)))
					(setq	NoShwLst	(list NoDevLst))
				)
			)
	)
	NoShwLst
)

(defun BlkEndsTst ( NoLst /	Gap Just BlkEnd	; Returns both ends of Symbol, Handle, Scale & Layer
						Bubba BlkHnd BlkLay BlkStrt BlkXFct BlkRot BlkScl )
	(if (not SymSizN)
		(setq	LodBub	(LodStage "Symbols")
				LodLst	(UpdLodLst LodBub LodLst)
		)
	)
	(cond
		((= (type (nth 2 NoLst)) 'LIST)
			(setq	Bubba	(SymSizN (cdr (assoc 2 (entget (handent (nth 0 NoLst))))))
					Just		(nth 0 Bubba)
					Gap		(nth 1 Bubba)
					BlkHnd	(nth 0 NoLst)
					BlkLay	(nth 1 NoLst)
					BlkStrt	(nth 2 NoLst)
					BlkXFct	(abs (nth 3 NoLst))
					BlkRot	(if (< (nth 3 NoLst) 0.0)
								(+ (nth 6 NoLst) pi)
								(nth 6 NoLst)
							)
					BlkScl	(if Gap
								(if (> Gap 0.01)
									(/ BlkXFct (* Gap 0.3048))
									(if (= (nth 8 NoLst) 1)
										(abs (nth 6 (nth 1 (nth 9 NoLst))))
										1000.0
									)
								)
								(if (= (nth 8 NoLst) 1)
									(abs (nth 6 (nth 1 (nth 9 NoLst))))
									1000.0
								)
							)
					Gap		(if Gap Gap 1.0)
			)
		)
		((= (type (nth 2 NoLst)) 'STR)
			(setq	Bubba	(SymSizN (car NoLst))
					Just		(nth 0 Bubba)
					Gap		(nth 1 Bubba)
					BlkHnd	(nth 1 NoLst)
					BlkLay	(nth 2 NoLst)
					BlkStrt	(nth 3 NoLst)
					BlkXFct	(abs (nth 4 NoLst))
					BlkRot	(if (< (nth 4 NoLst) 0.0)
								(+ (nth 7 NoLst) pi)
								(nth 7 NoLst)
							)
					BlkScl	(if Gap
								(if (> Gap 0.01)
									(/ BlkXFct (* Gap 0.3048))
									(if (= (nth 9 NoLst) 1)
										(abs (nth 6 (nth 1 (nth 10 NoLst))))
										1000.0
									)
								)
								(if (= (nth 9 NoLst) 1)
									(abs (nth 6 (nth 1 (nth 10 NoLst))))
									1000.0
								)
							)
					Gap		(if Gap Gap 1.0)
			)
		)
	)
	(if (< BlkScl 0.0)
		(princ (strcat "\n {BlkEndsTst} Invalid Block Scale on Handle [" BlkHnd "]"))
	)
	(if (= Just "C")
		(setq	BlkStrt	(polar BlkStrt (+ BlkRot pi) (* 0.5 (* BlkScl Gap 0.3048))))
	)
	(setq	BlkEnd	(polar BlkStrt BlkRot (* BlkScl Gap 0.3048)))
	(list BlkHnd BlkStrt BlkEnd BlkScl BlkLay (nth 1 Bubba))
)

(defun BlkFndAtt ( WhatDa MyDatLst /	FoundLst	; Returns list of handles where attributes match
								FndIt DatLst AttLst )
	(if MyDatLst
		(foreach	DatLst
				MyDatLst
				(setq	FndIt	nil)
				(if (= (nth 9 DatLst) 1)
					(foreach	AttLst
							(cdr (nth 10 DatLst))
							(if (not FndIt)
								(if (wcmatch (nth 1 AttLst) WhatDa)
									(setq	FndIt	(nth 1 DatLst))
								)
							)
					)
				)
				(if FndIt
					(if FoundLst
						(setq	FoundLst	(cons FndIt FoundLst))
						(setq	FoundLst	(list FndIt))
					)
				)
		)
	)
	FoundLst
)

(defun BlkDigDisp ( BigLst /	BlkInfo BlkDigLst	; Block Digest Display
						BlkSpcLst Cntr BlkDig )
	(if (not LstSort)
		(Lod "Utils")
	)
	(foreach	BlkInfo
			BigLst
			(if BlkDigLst	;Block Counter List (Digest)
				(if (assoc (car BlkInfo) BlkDigLst)
					(setq	BlkDigLst	(subst	(cons (car BlkInfo) (1+ (cdr (assoc (car BlkInfo) BlkDigLst))))
											(assoc (car BlkInfo) BlkDigLst)
											BlkDigLst
									)
					)
					(setq	BlkDigLst	(cons (cons (car BlkInfo) 1) BlkDigLst))
				)
				(setq	BlkDigLst	(list (cons (car BlkInfo) 1)))
			)
			(if BlkSpcLst	;Block Space List (0=Model, 1=Paper, 2=Mixed)
				(if (assoc (car BlkInfo) BlkSpcLst)
					(if (/= (nth 8 BlkInfo) (cdr (assoc (car BlkInfo) BlkSpcLst)))
						(setq	BlkSpcLst	(subst	(cons (car BlkInfo) 2)
												(assoc (car BlkInfo) BlkSpcLst)
												BlkSpcLst
										)
						)
					)
					(setq	BlkSpcLst	(cons (cons (car BlkInfo) (nth 8 BlkInfo)) BlkSpcLst))
				)
				(setq	BlkSpcLst	(list (cons (car BlkInfo) (nth 8 BlkInfo))))
			)
	)
	(if BlkDigLst
		(setq	BlkDigLst	(LstSort BlkDigLst (quote (lambda (a b) (< (car a) (car b))))))
	)
	(if BlkDigLst
		(textscr)
	)
	(if BlkDigLst
		(princ "\nNum Space BlockName           Count")
	)
	(setq	Cntr		0)
	(if BlkDigLst
		(foreach	BlkDig
				BlkDigLst
				(princ	(strcat	"\n"
								(PadCharR (itoa (setq Cntr (1+ Cntr))) 4)
								(cond
									((= (cdr (assoc (car BlkDig) BlkSpcLst)) 0)
										(PadCharR "Model" 6)
									)
									((= (cdr (assoc (car BlkDig) BlkSpcLst)) 1)
										(PadCharR "Paper" 6)
									)
									((= (cdr (assoc (car BlkDig) BlkSpcLst)) 2)
										(PadCharR "Mixed" 6)
									)
									(T
										(PadCharR "Unkwn" 6)
									)
								)
								(PadCharR (car BlkDig) 20)
								(PadCharL (itoa (cdr BlkDig)) 5)
						)
				)
		)
	)
	BlkDigLst
)

(defun GetBlkDefLst ( /	LayDat LayNam LaySta	; Gathers Layer & Block Def Data
					LayCol LayLtp LayLst
					BlkLst BlkDat BlkNam
					BlkAttP BlkEnt BlkEnt2 BlkLst1 )
	(setq	LayDat	(tblnext "LAYER" T)
			LayLst	nil
	)
	(while (setq LayDat (tblnext "LAYER"))
		(if LayDat
			(setq	LayNam	(cdr (assoc 2 LayDat))
					LayCol	(cdr (assoc 62 LayDat))
					LaySta	(cdr (assoc 70 LayDat))
					LayLtp	(cdr (assoc 6 LayDat))
			)
			(setq	LayNam	nil)
		)
		(if LayNam
			(if LayLst
				(setq	LayLst	(cons (list LayNam LayCol LaySta LayLtp) LayLst))
				(setq	LayLst	(list (list LayNam LayCol LaySta LayLtp)))
			)
		)
	)
	(if LayLst
		(if (> (length LayLst) 1)
			(princ (strcat "\n GetBlkDefLst gathered data on {" (itoa (length LayLst)) "} Layer Definitions."))
		)
	)
	(setq	BlkDat	(tblnext "Block" T)
			BlkLst	nil
	)
	(if BlkDat
		(setq	BlkNam	(cdr (assoc 2 BlkDat))
				BlkAttP	(cdr (assoc 70 BlkDat))
				BlkEnt	(cdr (assoc -2 BlkDat))
				BlkEnt2	(entget BlkEnt (list "*"))
				BlkLst1	nil
		)
		(setq	BlkNam	nil
				BlkLst1	nil
				BlkEnt2	nil
				BlkAttP	nil
		)
	)
	(if (= BlkAttP 2)
		(if (= (cdr (assoc 0 BlkEnt2)) "ATTDEF")
			(setq	BlkLst1	(list BlkNam (cdr (assoc 2 BlkEnt2))))
		)
	)
	(if (= BlkAttP 2)
		(while BlkEnt2
			(if (entnext (cdr (assoc -1 BlkEnt2)))
				(if (setq BlkEnt2 (entget (entnext (cdr (assoc -1 BlkEnt2))) (list "*")))
					(if (= (cdr (assoc 0 BlkEnt2)) "ATTDEF")
						(if BlkLst1
							(setq	BlkLst1	(append BlkLst1 (list (cdr (assoc 2 BlkEnt2)))))
							(setq	BlkLst1	(list BlkNam (cdr (assoc 2 BlkEnt2))))
						)
					)
				)
				(setq	BlkEnt2	nil)
			)
		)
		(setq	BlkLst1	(list BlkNam "None"))
	)
	(if BlkLst1
		(if BlkLst
			(setq	BlkLst	(cons BlkLst1 BlkLst))
			(setq	BlkLst	(list BlkLst1))
		)
	)
	(while (setq BlkDat (tblnext "Block"))
		(if BlkDat
			(setq	BlkNam	(cdr (assoc 2 BlkDat))
					BlkAttP	(cdr (assoc 70 BlkDat))
					BlkEnt	(cdr (assoc -2 BlkDat))
					BlkEnt2	(entget BlkEnt (list "*"))
					BlkLst1	nil
			)
			(setq	BlkNam	nil
					BlkLst1	nil
					BlkEnt2	nil
					BlkAttP	nil
			)
		)
		(if (= BlkAttP 2)
			(if (= (cdr (assoc 0 BlkEnt2)) "ATTDEF")
				(setq	BlkLst1	(list BlkNam (cdr (assoc 2 BlkEnt2))))
			)
		)
		(if (= BlkAttP 2)
			(while BlkEnt2
				(if (entnext (cdr (assoc -1 BlkEnt2)))
					(if (setq BlkEnt2 (entget (entnext (cdr (assoc -1 BlkEnt2))) (list "*")))
						(if (= (cdr (assoc 0 BlkEnt2)) "ATTDEF")
							(if BlkLst1
								(setq	BlkLst1	(append BlkLst1 (list (cdr (assoc 2 BlkEnt2)))))
								(setq	BlkLst1	(list BlkNam (cdr (assoc 2 BlkEnt2))))
							)
						)
					)
					(setq	BlkEnt2	nil)
				)
			)
			(setq	BlkLst1	(list BlkNam "None"))
		)
		(if BlkLst1
			(if BlkLst
				(setq	BlkLst	(cons BlkLst1 BlkLst))
				(setq	BlkLst	(list BlkLst1))
			)
		)
	)
	(if BlkLst
		(if (> (length BlkLst) 1)
			(princ (strcat "\n GetBlkDefLst gathered data on {" (itoa (length BlkLst)) "} Block Definitions."))
		)
	)
	(list LayLst BlkLst)
)

(defun GetBlkDatLst ( InpLst /	BlkDat BlkLst	; Builds Blk Lists
							At1 At2 x Cntr MLen en1 en2 EntDatOut
							ExDat ExDatLst ExDatOut ExDat0 ss1
							BlkNoIns BlkNoDev BlkLand
							BlkDatBigLst BlkDatNoLst BlkDatLandLst BlkDatMiscLst )
	(setq	BlkLst	(nth 0 InpLst)
			BlkNoIns	(nth 1 InpLst)
			BlkNoDev	(nth 2 InpLst)
			BlkLand	(nth 3 InpLst)
	)
	(if BlkLst
		(if (not Bug)
			(princ (strcat "\nProcessing {" (itoa (length BlkLst)) "} Block Definitions.\n"))
		)
		(if (not Bug)
			(princ "\n* GetBlkDatLst Error* - No BlkLst to Process\n")
		)
	)
	(if BlkLst
		(foreach	BlkDat
				BlkLst
				(if (not Bug)
					(princ ".")
				)
				(setq	ss1	(ssget "X"	(list	(cons 0 "INSERT")
												(cons 2 (car BlkDat))
										)
							)
				)
				(if (not (wcmatch (nth 1 BlkDat) "None"))
					(setq	At1	(cdr BlkDat)
							At2	(mapcar (quote (lambda (x) (cons x "None"))) At1)
					)
					(setq	At1	nil
							At2	nil
					)
				)
				(if ss1
					(setq	Cntr		0
							MLen		(1- (sslength ss1))
					)
				)
				(if ss1
					(while (<= Cntr MLen)
						(setq	EntDatOut	(EntDatLstR (ssname ss1 Cntr)))
						(cond
							((member (strcase (car EntDatOut))	BlkNoIns)
								(if BlkDatNoLst
									(setq	BlkDatNoLst	(cons EntDatOut BlkDatNoLst))
									(setq	BlkDatNoLst	(list EntDatOut))
								)
							)
							((member (strcase (car EntDatOut))	BlkNoDev)
								(if BlkDatBigLst
									(setq	BlkDatBigLst	(cons EntDatOut BlkDatBigLst))
									(setq	BlkDatBigLst	(list EntDatOut))
								)
							)
							((member (strcase (car EntDatOut))	BlkLand)
								(if BlkDatLandLst
									(setq	BlkDatLandLst	(cons EntDatOut BlkDatLandLst))
									(setq	BlkDatLandLst	(list EntDatOut))
								)
							)
							(T
								(if BlkDatMiscLst
									(setq	BlkDatMiscLst	(cons EntDatOut BlkDatMiscLst))
									(setq	BlkDatMiscLst	(list EntDatOut))
								)
							)
						)
						(setq	Cntr		(1+ Cntr))
					)
				)
		)
	)
	(list BlkDatBigLst BlkDatNoLst BlkDatLandLst BlkDatMiscLst)
)

(defun C:BlkReset ( / )						; CL - Resets Block Lists
	(BlkReset)
	(princ)
)

(defun BlkReset ( / )						; Resets Block Lists
	(setq
			BlkDatBigLst	nil	;Big List of Inserts that are from BlkNoDev
			BlkDatHndLst 	nil	;Big List of Inserts with Handle first (Block name truncated)
			BlkDatLandLst	nil	;Big List of Inserts that are from BlkLand
			BlkDatMiscLst	nil	;Big List of Inserts that are Miscellaneous
			BlkDatNoLst  	nil	;Big List of Inserts that are from BlkNoIns
			BlkLand		nil	;Inserts that indicate Landmarks
			BlkLst		nil	;Block List
			BlkNoDev		nil	;Inserts that are devices that can be Normal Open
			BlkNoIns		nil	;Inserts that indicate Normal Open status
			FineMatchLst 	nil	;Inserts that have Just One circuit at each end, and they match layer
			LayLst		nil	;Layer List
			MultMatchLst 	nil	;Inserts that have Multiple circuits at one (or both) ends
			NoFndHnd		nil	;Handles Only => Possible N.O. Inserts due to Attributes like "N.O." Filtered to not dup NoShwHnd
			NoFndLst		nil	;Device List from NoFndHnd
			NoLayHnd		nil	;Handles Only => from NoMatchLst => Filtered to not dup NoShwHnd
			NoLayLst		nil	;Device List from NoLayHnd
			NoMatchLst   	nil	;Possible N.O. Inserts due to No Matching Circuit layer
			NoShwHnd		nil	;Handles Only => from NoShwLst
			NoShwLst		nil	;N.O. matches from BlkNoFnd
			PnScl		nil	;Scale of Panel or Drawing
			ValidLst		nil	;List of Devices it is Valid to Replace/Update/Remove
	)
)

(defun C:BugOut ( / )						; Toggles Debug Settings
	(if Bug
		(setq	Bug		nil)
		(setq	Bug		T
				*error*	nil
		)
	)
	(princ)
)

(defun C:BlkDataFnd ( /	AttWas BlpWas ColWas	; CL - Main Builder Function
					LtWas LayWas CmdWas EchWas FilWas OsWas ExWas MdWas )
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			ColWas	(getvar "CECOLOR")
			LtWas	(getvar "CELTYPE")
			LayWas	(getvar "CLAYER")
			CmdWas	(getvar "CMDDIA")
			EchWas	(getvar "CMDECHO")
			FilWas	(getvar "FILEDIA")
			OsWas	(getvar "OSMODE")
			ExWas	(getvar "EXPERT")
			MdWas	(getvar "MODEMACRO")
	)
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
			(setvar "EXPERT" 5)
		)
	)
	(command "_.UNDO" "_BE")
	(if (= (substr (StpDot AppNam) 1 4) "ADDS")
		(progn
			(if (not Chk_Inserts)
				(LodStage "RemDups")
			)
			(if (not GetPS)
				(LodStage "Panel")
			)
		)
		(progn
			(if (not Chk_Inserts)
				(Load (strcat TestPrmRootPath "Adds\\LISP\\RemDups"))
			)
			(if (not GetPS)
				(Load (strcat TestPrmRootPath "Adds\\LISP\\Panel"))
			)
		)
	)
	(setq	LayChkNot		T)
	(if (= Div "M_")
		(Chk_Inserts)
	)
	(cond
		((and (= (substr (StpDot AppNam) 1 4) "ADDS") DevMark)
			(setq	LogWas	(getvar "LOGFILENAME")
					LogOnWas	(getvar "LOGFILEMODE")
					Bubba	(setvar "LOGFILENAME" (strcat TestPrmRootPath "Shared Panels\\Data\\ConvReport_" (strcase (getvar "LOGINNAME")) ".Log"))
					Bubba	(setvar "LOGFILEMODE" 1)
					Bubba	(if PanLst
								(if (> (length PanLst) 1)
									(princ "\nWorking Panels:")
									(princ "\nWorking Panel:")
								)
								(princ "\nNo Panels Open!")
							)
					Bubba	(if PanLst
								(mapcar (quote (lambda (x) (princ (strcat "\n" x)))) PanLst)
							)
			)
			(if (not _Path-Sym)
				(setq	_Path-Sym		(strcat	TestPrmRootPath "Adds\\Sym\\"))
			)
		)
		((= (substr (StpDot AppNam) 1 4) "ADDS")
			(setq	LogWas	(getvar "LOGFILENAME")
					LogOnWas	(getvar "LOGFILEMODE")
					Bubba	(setvar "LOGFILENAME" (strcat PrmRootPath "Shared Panels\\Data\\ConvReport_") (strcase (getvar "LOGINNAME")) ".Log"))
					Bubba	(setvar "LOGFILEMODE" 1)
					Bubba	(if PanLst
								(if (> (length PanLst) 1)
									(princ "\nWorking Panels:")
									(princ "\nWorking Panel:")
								)
								(princ "\nNo Panels Open!")
							)
					Bubba	(if PanLst
								(mapcar (quote (lambda (x) (princ (strcat "\n" x)))) PanLst)
							)
			)
			(if (not _Path-Sym)
				(setq	_Path-Sym		(strcat PrmRootPath "Adds\\Sym\\")		;	If c_Path-Sym path not set then set it based on s drive location
			)
		)
		(DevMark
			(setq	LogWas	(getvar "LOGFILENAME")
					LogOnWas	(getvar "LOGFILEMODE")
					Bubba	(setvar "LOGFILENAME" (strcat "C:\\Data\\Zip\\ConvReport_" (strcase (getvar "LOGINNAME")) ".Log"))
					Bubba	(setvar "LOGFILEMODE" 1)
			)
			(if (not _Path-Sym)
				(setq	_Path-Sym			"C:\\Div_Map\\Adds\\SYM\\")
			)
		)
		(T
			(setq	LogWas	(getvar "LOGFILENAME")
					LogOnWas	(getvar "LOGFILEMODE")
					Bubba	(setvar "LOGFILENAME" (strcat "C:\\Data\\Public\\ConvReport_" (strcase (getvar "LOGINNAME")) ".Log"))
					Bubba	(setvar "LOGFILEMODE" 1)
			)
			(if (not _Path-Sym)
				(setq	_Path-Sym			"C:\\Div_Map\\Adds\\SYM\\")
			)
		)
	)
	(if (> (strlen LogWas) 1)
		(setq	LogWas	(RepLChar LogWas "\\" "/" 0))
	)
	(BlkDataFnd)
	(if (> (strlen LogWas) 1)
		(setvar "LOGFILENAME" LogWas)
	)
	(if (/= LogOnWas (getvar "LOGFILEMODE"))
		(setvar "LOGFILEMODE" LogOnWas)
	)
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CELTYPE" LtWas)
	(setvar "CLAYER" LayWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CMDECHO" EchWas)
	(setvar "FILEDIA" FilWas)
	(setvar "OSMODE" OsWas)
	(setvar "EXPERT" ExWas)
	(setvar "MODEMACRO" MdWas)
	(princ)
)

(defun BlkDataFnd ( /	Bubba BoNoLayLst		; Main Builder Function
					ints isecs outs osecs esecs otim elss LogWas LogOnWas )
	;***Global Variables***
	;;;BlkDatBigLst	nil	;Big List of Inserts that are from BlkNoDev
	;;;BlkDatHndLst 	nil	;Big List of Inserts with Handle first (Block name truncated)
	;;;BlkDatLandLst	nil	;Big List of Inserts that are from BlkLand
	;;;BlkDatMiscLst	nil	;Big List of Inserts that are Miscellaneous
	;;;BlkDatNoLst  	nil	;Big List of Inserts that are from BlkNoIns
	;;;BlkLand		nil	;Inserts that indicate Landmarks
	;;;BlkLst			nil	;Block List
	;;;BlkNoDev		nil	;Inserts that are devices that can be Normal Open
	;;;BlkNoIns		nil	;Inserts that indicate Normal Open status
	;;;FineMatchLst 	nil	;Inserts that have Just One circuit at each end, and they match layer
	;;;LayLst			nil	;Layer List
	;;;MultMatchLst 	nil	;Inserts that have Multiple circuits at one (or both) ends
	;;;NoFndHnd		nil	;Handles Only => Possible N.O. Inserts due to Attributes like "N.O." Filtered to not dup NoShwHnd
	;;;NoFndLst		nil	;Device List from NoFndHnd
	;;;NoLayHnd		nil	;Handles Only => from NoMatchLst => Filtered to not dup NoShwHnd
	;;;NoLayLst		nil	;Device List from NoLayHnd
	;;;NoMatchLst   	nil	;Possible N.O. Inserts due to No Matching Circuit layer
	;;;NoShwHnd		nil	;Handles Only => from NoShwLst
	;;;NoShwLst		nil	;N.O. matches from BlkNoFnd
	;;;PnScl			nil	;Scale of Panel or Drawing
	;;;ValidLst		nil	;List of Devices it is Valid to Replace/Update/Remove
	(if (not ValidLst)
		(setq	ValidLst	(list
								"A$C*"
								"ACC"			;SubTools	(Explode)
								"ARR_FDR"			;SubTools A130 <-> 3830
								"ARROW"			;SubTools A137 <-> 3837
								"ATS"
								"BKRC"			;SubTools A164 <-> 3864
								"BKRO"			;SubTools A181 <-> 3881
								"BRKR_SUB"		;SubTools A181 <-> 3881
								"CAP"
								"CE"
								"CR"
								"CS"
								"CS2"
								"DA"
								"DR"
								"DS"
								"DS2"
								"FDR"			;SubTools A130 <-> 3830
								"FSC"			;SubTools A125 <-> 3825
								"FSO"			;SubTools A170 <-> 3870
								"FD_NUM2"
								"FUSE"			;SubTools A131 <-> 3831
								"GETAWAY"
								"GR"
								"GROUND"			;SubTools A132 <-> 3832
								"GS"
								"GS2"
								"GSC"			;SubTools A126 <-> 3826
								"GSO"			;SubTools A173 <-> 3873
								"KNIFESW"			;SubTools A124 <-> 3824
								"LA"				;SubTools A134 <-> 3834
								"LOC"
								"LTC"
								"MODC"			;SubTools A196 <-> 3896
								"MODO"			;SubTools A197 <-> 3897
								"MOGS"
								"NEWSS"
								"NO_ISO"
								"NO_TRF"
								"PAD"
								"PADMT"
								"PAD_END"
								"PM"
								"PM_END"
								"POT"			;SubTools A135 <-> 3835
								"QUANTUM"			;SubTools A073 <-> 3773
								"RACK_NC"			;SubTools A070 <-> 3770
								"RACK_NO"			;SubTools A068 <-> 3768
								"RACK_RO"			;SubTools A069 <-> 3769
								"RECL"
								"RECLBP"
								"RECLBP_2"
								"RECLEL"
								"RECLEL_2"
								"RECLEL_3"
								"RECLEL_4"
								"RECLEL_5"
								"REG"
								"REGA"
								"RISER"
								"SCADA"
								"SECT"
								"SENSOR"
								"SGEN"
								"SMS"
								"STEPTRAN"
								"SUB"
								"SUB2"
								"SUBCUST"
								"SWC"			;SubTools A124 <-> 3824
								"SWO"			;SubTools A172 <-> 3872
								"T"
								"TL"				;SubTools A071 <-> 3771
								"TRANSCL"
								"U"
								"UGOPEN"
								"UGOPEN"
								"UNO"
								"UNO_PAD"
								"URD_LOC"
								"_AUTOCON"
								"_DA"
								"_KEY"
								"_OCR"
								"_OCR_BP"
								"_OCR_EL"
								"_SECT"
								"_SGEN"
								"_SS"
								"_SSR"
								"SS"				;Not in Ins_Rep List
								"A$C1C696"		;Not in Ins_Rep List
								"A$C429E3"		;Not in Ins_Rep List
						)
		)
	)
	(command "-Layer" "T" "*" "U" "*" "ON" "*" "S" "0" "" "_.Zoom" "E" "_.View" "S" "StartNo")
	(setq	ints		(getvar "date")
			isecs	(* 86400.0 (- ints (fix ints)))
			PnScl	(getvar "THICKNESS")
			BlkNoIns	(list	"NO")
			BlkNoDev	(list	"ATS"
							"CR"
							"CS"
							"CS2"
							"DR"
							"DS"
							"DS2"
							"GR"
							"GS"
							"GS2"
							"MOGS"
							"NEWSS"
							"NO_ISO"
							"NO_TRF"
							"RECL"
							"RECLBP"
							"RECLBP_2"
							"RECLEL"
							"RECLEL_2"
							"RECLEL_3"
							"RECLEL_5"
							"SECT"
							"SMS"
							"UGOPEN"
							"UNO_PAD"
							"_AUTOCON"
							"_OCR"
							"_OCR_BP"
							"_OCR_EL"
							"_SECT"
							"_SS"
							"_SSR"
							"ACC"			;SubTools	(Explode)
							"ARR_FDR"			;SubTools A130 <-> 3830
							"ARROW"			;SubTools A137 <-> 3837
							"BKRC"			;SubTools A164 <-> 3864
							"BKRO"			;SubTools A181 <-> 3881
							"BRKR_SUB"		;SubTools A181 <-> 3881
							"FDR"			;SubTools A130 <-> 3830
							"FSC"			;SubTools A125 <-> 3825
							"FSO"			;SubTools A170 <-> 3870
							"FUSE"			;SubTools A131 <-> 3831
							"GROUND"			;SubTools A132 <-> 3832
							"GSC"			;SubTools A126 <-> 3826
							"GSO"			;SubTools A173 <-> 3873
							"KNIFESW"			;SubTools A124 <-> 3824
							"LA"				;SubTools A134 <-> 3834
							"LTC"			;SubTools A133 <-> 3833
							"MODC"			;SubTools A196 <-> 3896
							"MODO"			;SubTools A197 <-> 3897
							"POT"			;SubTools A135 <-> 3835
							"QUANTUM"			;SubTools A073 <-> 3773
							"RACK_NC"			;SubTools A070 <-> 3770
							"RACK_NO"			;SubTools A068 <-> 3768
							"RACK_RO"			;SubTools A069 <-> 3769
							"SWC"			;SubTools A124 <-> 3824
							"SWO"			;SubTools A172 <-> 3872
							"TL"				;SubTools A071 <-> 3771
					)
			BlkLand	(list	"2CHURCH"
							"2SCHOOL"
							"5CHURCH"
							"5STORE"
							"5TOWER"
							"CEMETERY"
							"CH"
							"CHU-500"
							"CHURCH"
							"CROSS"
							"FEN"
							"FENC"
							"LFSP"
							"PARCEL"
							"RR"
							"SCH"
							"SCH-500"
							"SCHOOL"
							"STO-500"
							"STORE"
							"TOWER"
							"_BLDG"
							"_CATV"
							"_CC_T"
							"_CC_B"
							"_CHURCH"
							"_KEY"
							"_SCHOOL"
					)
	)
	(if (< PnScl 1.0)
		(progn
			(initget 1 "No")
			(setq	PnScl	(getreal "\nEnter Panel Scale for selections: "))
		)
	)
	(if (not BlkDatBigLst)
		(if (not BlkLst)
			(setq	Bubba		(setvar "MODEMACRO" "<GetBlkDefLst>")
					Bubba		(GetBlkDefLst)
					LayLst		(nth 0 Bubba)
					BlkLst		(nth 1 Bubba)
					Bubba		(setvar "MODEMACRO" "<GetBlkDatLst>")
					Bubba		(GetBlkDatLst (list BlkLst BlkNoIns BlkNoDev BlkLand))
					BlkDatBigLst	(nth 0 Bubba)
					BlkDatNoLst	(nth 1 Bubba)
					BlkDatLandLst	(nth 2 Bubba)
					BlkDatMiscLst	(nth 3 Bubba)
			)
			(setq	Bubba		(setvar "MODEMACRO" "<GetBlkDatLst>")
					Bubba		(GetBlkDatLst (list BlkLst BlkNoIns BlkNoDev BlkLand))
					BlkDatBigLst	(nth 0 Bubba)
					BlkDatNoLst	(nth 1 Bubba)
					BlkDatLandLst	(nth 2 Bubba)
					BlkDatMiscLst	(nth 3 Bubba)
			)
		)
	)
	(setq	Bubba		nil
			BlkDatHndLst	(mapcar (quote cdr) BlkDatBigLst)
			Bubba		(setvar "MODEMACRO" "<BlkFndAtt>")
			NoFndHnd		(BlkFndAtt "*N.O.*" BlkDatBigLst)	;No Zoom - Attribute Data Search Only
			Bubba		(setvar "MODEMACRO" "<BlkLayTst>")
			BoNoLayLst	(BlkLayTst BlkDatBigLst)			;Zooms to each BlkNoDev for Layer test
			NoMatchLst	(nth 0 BoNoLayLst)
			MultMatchLst	(nth 1 BoNoLayLst)
			FineMatchLst	(nth 2 BoNoLayLst)
			BoNoLayLst	(list NoFndHnd NoMatchLst MultMatchLst FineMatchLst)
			NoLayHnd		(mapcar (quote car) NoMatchLst)
			Bubba		(command "-Layer" "F" "????CP*,????FL*" "")
			Bubba		(setvar "MODEMACRO" "<BlkNoFnd>")
			NoShwLst		(BlkNoFnd BoNoLayLst)			;Decides what BlkNoDev devices are what state
			NoShwHnd		(mapcar (quote cadr) NoShwLst)
			NoNoShwHnd	(mapcar (quote car) NoShwLst)
	)
	(if BlkDatBigLst
		(setq	BlkDatHndLst	(mapcar (quote cdr) BlkDatBigLst))
	)
	(if BlkDatNoLst
		(setq	BlkDatHndLst	(append BlkDatHndLst (mapcar (quote cdr) BlkDatNoLst)))
	)
	(if BlkDatLandLst
		(setq	BlkDatHndLst	(append BlkDatHndLst (mapcar (quote cdr) BlkDatLandLst)))
	)
	(if BlkDatMiscLst
		(setq	BlkDatHndLst	(append BlkDatHndLst (mapcar (quote cdr) BlkDatMiscLst)))
	)
	(cond
		((and NoShwHnd NoFndHnd NoLayHnd)
			(mapcar (quote (lambda (x) (if (not (member x NoShwHnd)) (if NoFndLst (setq NoFndLst (cons x NoFndLst)) (setq NoFndLst (list x)))))) NoFndHnd)
			(mapcar (quote (lambda (x) (if (not (member x NoShwHnd)) (if NoLayLst (setq NoLayLst (cons x NoLayLst)) (setq NoLayLst (list x)))))) NoLayHnd)
		)
		((and NoShwHnd NoFndHnd)
			(mapcar (quote (lambda (x) (if (not (member x NoShwHnd)) (if NoFndLst (setq NoFndLst (cons x NoFndLst)) (setq NoFndLst (list x)))))) NoFndHnd)
		)
		((and NoShwHnd NoLayHnd)
			(mapcar (quote (lambda (x) (if (not (member x NoShwHnd)) (if NoLayLst (setq NoLayLst (cons x NoLayLst)) (setq NoLayLst (list x)))))) NoLayHnd)
		)
		((and NoLayHnd NoFndHnd)
			(mapcar (quote (lambda (x) (if (not (member x NoLayHnd)) (if NoFndLst (setq NoFndLst (cons x NoFndLst)) (setq NoFndLst (list x)))))) NoFndHnd)
			(mapcar (quote (lambda (x) (if (not (member x NoFndHnd)) (if NoLayLst (setq NoLayLst (cons x NoLayLst)) (setq NoLayLst (list x)))))) NoLayHnd)
		)
	)
	(if BlkDatBigLst
		(if (> (length BlkDatBigLst) 0)
			(progn
				(princ "\n\nListing of Device Inserts:")
				(BlkDigDisp BlkDatBigLst)
				(princ (strcat "\nTotal of all Device Inserts: " (itoa (length BlkDatBigLst)) "\n"))
			)
			(princ "\nNo Inserts found!")
		)
	)
	(if BlkDatNoLst
		(if (> (length BlkDatNoLst) 0)
			(progn
				(princ "\n\nListing of N.O. Indicator Inserts:")
				(BlkDigDisp BlkDatNoLst)
				(princ (strcat "\nTotal of all N.O. Indicator Inserts: " (itoa (length BlkDatNoLst)) "\n"))
			)
			(princ "\nNo N.O. Inserts found!")
		)
	)
	(if BlkDatLandLst
		(if (> (length BlkDatLandLst) 0)
			(progn
				(princ "\n\nListing of LandMark Blocks:")
				(BlkDigDisp BlkDatLandLst)
				(princ (strcat "\nTotal of all LandMark Blocks: " (itoa (length BlkDatLandLst)) "\n"))
			)
			(princ "\nNo LandMark Blocks found!")
		)
	)
	(if BlkDatMiscLst
		(if (> (length BlkDatMiscLst) 0)
			(progn
				(princ "\n\nListing of Miscellaneous Blocks:")
				(BlkDigDisp BlkDatMiscLst)
				(princ (strcat "\nTotal of all Miscellaneous Blocks: " (itoa (length BlkDatMiscLst)) "\n"))
			)
			(princ "\nNo Miscellaneous Blocks found!")
		)
	)
	(if NoFndLst
		(if (> (length NoFndLst) 0)
			(setq	NoFndLst	(mapcar (quote (lambda (x) (assoc x BlkDatHndLst))) NoFndLst)
					Bubba	(princ (strcat "\nAssigning status to [" (itoa (length NoFndLst)) "] Devices with N.O. in the Attribute Data..."))
					Bubba	(DoNoAtt)
			)
		)
	)
	(if NoLayLst
		(if (> (length NoLayLst) 0)
			(setq	NoLayLst	(mapcar (quote (lambda (x) (assoc x BlkDatHndLst))) NoLayLst)
					Bubba	(princ (strcat "\nThere are [" (itoa (length NoLayLst)) "] Devices with UnMatched Circuits."))
			)
		)
	)
	(if NoTrbLst
		(if (> (length NoTrbLst) 0)
			(princ (strcat "\nN.O. decisions required [" (itoa (length NoTrbLst)) "] interactions.\n"))
		)
	)
	(command "_.View" "R" "StartNo")
	(setq	outs		(getvar "date")
			osecs	(* 86400.0 (- outs (fix outs)))
			esecs	(- (* osecs 1000.0) (* isecs 1000.0))
			otim		(eMillFmt esecs)
			elss		(itoa (fix esecs))
			Bubba	(princ	(strcat	"\nElapsed Time = "
									(PadNum (itoa (fix (nth 1 otim))) 2)
									":"
									(PadNum (itoa (fix (nth 2 otim))) 2)
									(if (< (nth 3 otim) 10000.0)
										":0"
										":"
									)
									(rtos (/ (nth 3 otim) 1000.0) 2 3)
							)
					)
	)
;	(if ErrorUpd
;		(ErrorUpd)
;	)
)

(defun C:BlkNoSho ( /	AttWas BlpWas ColWas	; Main N.O. Display Function
					LtWas LayWas CmdWas EchWas FilWas OsWas ExWas Bubba NoLst GoLst )
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			ColWas	(getvar "CECOLOR")
			LtWas	(getvar "CELTYPE")
			LayWas	(getvar "CLAYER")
			CmdWas	(getvar "CMDDIA")
			EchWas	(getvar "CMDECHO")
			FilWas	(getvar "FILEDIA")
			OsWas	(getvar "OSMODE")
			ExWas	(getvar "EXPERT")
	)
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
			(setvar "EXPERT" 5)
		)
	)
	(command "_.UNDO" "_BE")
	(command "-Layer" "F" "????FL*" "")
	(if BlkDatBigLst
		(setq	BlkDatHndLst	(mapcar (quote cdr) BlkDatBigLst))
	)
	(if BlkDatNoLst
		(setq	BlkDatHndLst	(append BlkDatHndLst (mapcar (quote cdr) BlkDatNoLst)))
	)
	(if BlkDatLandLst
		(setq	BlkDatHndLst	(append BlkDatHndLst (mapcar (quote cdr) BlkDatLandLst)))
	)
	(if BlkDatMiscLst
		(setq	BlkDatHndLst	(append BlkDatHndLst (mapcar (quote cdr) BlkDatMiscLst)))
	)
	(if NoShwLst
		(setq	NoShwHnd		(mapcar (quote cadr) NoShwLst)
				NoNoShwHnd	(mapcar (quote car) NoShwLst)
		)
	)
	(if NoShwLst
		(if ChzInt
			(setq	Bubba	(if (and (>= ChzInt 1) (<= ChzInt (length NoShwLst)))
								(progn
									(redraw (handent (nth 0 (nth (1- ChzInt) NoShwLst))) 4)
									(if (nth 1 (nth (1- ChzInt) NoShwLst))
										(redraw (handent (nth 1 (nth (1- ChzInt) NoShwLst))) 4)
									)
								)
							)
					WazInt	(1+ ChzInt)
					ChzInt	(getint (strcat "\nTheir are {" (itoa (length NoShwLst)) "} N.O.'s to inspect.  <" (itoa WazInt) ">: "))
			)
			(setq	ChzInt	(getint (strcat "\nTheir are {" (itoa (length NoShwLst)) "} N.O.'s to inspect.  Which one: ")))
		)
		(progn
			(alert "*** BlkNoSho Error ***\nCould not initialize NO list")
			(exit)
		)
	)
	(if (and (null ChzInt) WazInt)
		(if (and (>= WazInt 2) (<= WazInt (1+ (length NoShwLst))))
			(setq	ChzInt	WazInt)
		)
	)
	(if (and (>= ChzInt 1) (<= ChzInt (length NoShwLst)))
		(progn
			(setq	NoLst	(nth (1- ChzInt) NoShwLst)
					NoHgt	(abs (* 12.0 (nth 4 (assoc (nth 0 NoLst) BlkDatHndLst))))
			)
			(command "_.Zoom" "C" (nth 2 NoLst) (* 0.75 PnScl))
			(redraw (handent (nth 0 NoLst)) 3)
			(if (nth 1 NoLst)
				(redraw (handent (nth 1 NoLst)) 3)
			)
			(if (nth 1 NoLst)
				(princ (ID_Me (nth 1 NoLst)))
				(princ "\nNo Device Associated!")
			)
			(NoCir (nth 2 NoLst) (* 0.3125 PnScl))
			(if (nth 1 NoLst)
				(progn
					(initget 1 "Yes No")
					(setq	Chz	(getkword "\nReplace Insert? (Yes No): "))
					(if (= Chz "Yes")
						(progn
							(redraw (handent (nth 0 NoLst)) 4)
							(redraw (handent (nth 1 NoLst)) 4)
							(setq	GoLst	(assoc (nth 1 NoLst) BlkDatHndLst)
									GoLst	(cons (cdr (assoc 2 (entget (handent (nth 1 NoLst))))) GoLst)
							)
							(if NoShwLst
								(setq	NoNoShwHnd	(mapcar (quote cadr) NoShwLst))
							)
							(InsRep GoLst)
						)
						(if (nth 1 NoLst)
							(setq	Bubba	(redraw (handent (nth 0 NoLst)) 4)
									Bubba	(redraw (handent (nth 1 NoLst)) 4)
							)
							(redraw (handent (nth 0 NoLst)) 4)
						)
					)
				)
			)
		)
		(princ "\nNot a valid value for viewing! Try again\n")
	)
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CELTYPE" LtWas)
	(setvar "CLAYER" LayWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CMDECHO" EchWas)
	(setvar "FILEDIA" FilWas)
	(setvar "OSMODE" OsWas)
	(setvar "EXPERT" ExWas)
	(princ)
)

(defun ID_Me ( NoHnd /	ANoLst AttLst Bubba )	; Just tell me what this is!
	(setq	ANoLst	(assoc NoHnd BlkDatHndLst))
	(if ANoLst
		(if (= (nth 8 ANoLst) 1)
			(setq	AttLst	","
					Bubba	(mapcar (quote (lambda (x) (setq AttLst (strcat AttLst "," (nth 0 x) "='" (nth 1 x) "'")))) (cdr (nth 9 ANoLst)))
					AttLst	(substr AttLst 3)
					Bubba	(strcat "\nBlock [" (cdr (assoc 2 (entget (handent NoHnd)))) "] has Attribs [" AttLst "]")
			)
			(setq	Bubba	(strcat "\nBlock [" (cdr (assoc 2 (entget (handent NoHnd)))) "] has no Attribs"))
		)
		(setq	Bubba	(strcat "\nBlock [" (cdr (assoc 2 (entget (handent NoHnd)))) "] not in BlkDatHndLst"))
	)
	Bubba
)

(defun C:ID_Me ( /	Ent1 EntD Blob )			; CL - Just tell me what this is!
	(setq	Ent1		(car (entsel "\nSelect the entity you wish to know about: "))
			EntD		(entget Ent1 (list "*"))
			Blob		(if (= (cdr (assoc 0 EntD)) "INSERT")
						(ID_Me (cdr (assoc 5 EntD)))
						(strcat "\nEntType:[" (cdr (assoc 0 EntD)) "] Layer:[" (cdr (assoc 8 EntD)) "]")
					)
	)
	(princ Blob)
	(princ)
)

(defun C:BlkDetShw ( /	AttWas BlpWas ColWas	; Main N.O. Display Function
					LtWas LayWas CmdWas EchWas FilWas OsWas ExWas Bubba NoLst )
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			ColWas	(getvar "CECOLOR")
			LtWas	(getvar "CELTYPE")
			LayWas	(getvar "CLAYER")
			CmdWas	(getvar "CMDDIA")
			EchWas	(getvar "CMDECHO")
			FilWas	(getvar "FILEDIA")
			OsWas	(getvar "OSMODE")
			ExWas	(getvar "EXPERT")
	)
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
			(setvar "EXPERT" 5)
		)
	)
	(command "_.UNDO" "_BE")
	(command "-Layer" "F" "????FL*" "")
	(if NoShwLst
		(setq	NoShwHnd		(mapcar (quote cadr) NoShwLst)
				NoNoShwHnd	(mapcar (quote car) NoShwLst)
		)
	)
	(if BlkDetLst
		(if ChzInt
			(setq	Bubba	(if (and (>= ChzInt 1) (<= ChzInt (length BlkDetLst)))
								(progn
									(if (nth 1 (nth (1- ChzInt) BlkDetLst))
										(redraw (handent (nth 1 (nth (1- ChzInt) BlkDetLst))) 4)
									)
								)
							)
					WazInt	(1+ ChzInt)
					ChzInt	(getint (strcat "\nTheir are {" (itoa (length BlkDetLst)) "} Details to inspect.  <" (itoa WazInt) ">: "))
			)
			(setq	ChzInt	(getint (strcat "\nTheir are {" (itoa (length BlkDetLst)) "} Details to inspect.  Which one: ")))
		)
		(progn
			(alert "*** C:BlkDetShw Error ***\nCould not initialize BlkDetLst list")
			(exit)
		)
	)
	(if BlkDetLst
		(if (and (null ChzInt) WazInt)
			(if (and (>= WazInt 2) (<= WazInt (1+ (length BlkDetLst))))
				(setq	ChzInt	WazInt)
			)
		)
	)
	(if BlkDetLst
		(if (and (>= ChzInt 1) (<= ChzInt (length BlkDetLst)))
			(progn
				(setq	NoLst	(nth (1- ChzInt) BlkDetLst)
						NoHgt	(abs (* 12.0 (nth 4 (assoc (nth 1 NoLst) BlkDatHndLst))))
				)
				(command "_.Zoom" "C" (nth 3 NoLst) (* 0.75 PnScl))
				(if (nth 1 NoLst)
					(redraw (handent (nth 1 NoLst)) 3)
				)
				(if NoShwLst
					(if (member (nth 1 NoLst) NoShwHnd)
						(redraw (handent (nth (- (length NoShwHnd) (length (member (nth 1 NoLst) NoShwHnd))) NoNoShwHnd)) 3)
					)
				)
				;(NoCir (nth 3 NoLst) (* 0.5625 PnScl))
			)
			(princ "\nNot a valid value for viewing! Try again\n")
		)
	)
	(if (and BlkDetLst ChzInt)
		(if (and (>= ChzInt 1) (<= ChzInt (length BlkDetLst)))
			(progn
				(initget 1 "Yes No")
				(setq	Chz	(getkword "\nReplace Insert? (Yes No): "))
				(if (= Chz "Yes")
					(InsRep NoLst)
					(progn
						(if (nth 1 NoLst)
							(redraw (handent (nth 1 NoLst)) 4)
						)
						(if NoShwLst
							(if (member (nth 1 NoLst) NoShwHnd)
								(redraw (handent (nth (- (length NoShwHnd) (length (member (nth 1 NoLst) NoShwHnd))) NoNoShwHnd)) 4)
							)
						)
					)
				)
			)
		)
	)
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CELTYPE" LtWas)
	(setvar "CLAYER" LayWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CMDECHO" EchWas)
	(setvar "FILEDIA" FilWas)
	(setvar "OSMODE" OsWas)
	(setvar "EXPERT" ExWas)
	(princ)
)

(defun NoCir ( NoPnt NoDst / )				; Steps Inc Cntr Ang
	(setq	Steps	48.0
			Inc		(/ (* 2.0 pi) Steps)
			Cntr		0
			Ang		0.0
	)
	(while (< Cntr Steps)
		(grdraw (polar NoPnt Ang NoDst) (polar NoPnt (+ Ang Inc) NoDst) -1 1)
		(setq	Ang	(+ Ang Inc)
				Cntr	(1+ Cntr)
		)
	)
)

(defun C:DoInsRep ( /	AttWas BlpWas ColWas	; Main Insert Replace Function
					LtWas LayWas CmdWas EchWas FilWas OsWas ExWas Bubba NoLst )
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			ColWas	(getvar "CECOLOR")
			LtWas	(getvar "CELTYPE")
			LayWas	(getvar "CLAYER")
			CmdWas	(getvar "CMDDIA")
			EchWas	(getvar "CMDECHO")
			FilWas	(getvar "FILEDIA")
			OsWas	(getvar "OSMODE")
			ExWas	(getvar "EXPERT")
	)
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
			(setvar "EXPERT" 5)
		)
	)
	(command "_.UNDO" "_BE")
	(command "-Layer" "T" "*" "U" "*" "ON" "*" "")
	(setq	UnqLst	(BlkDigDisp BlkDatBigLst)
			UnqLst	(mapcar (quote car) UnqLst)
			BlkDetLst	nil
	)
	(initget 1 "")
	(setq	YrChz	(strcat "\nYour Choice (1-" (itoa (length UnqLst)) "): ")
			ChzName	(getint YrChz)
			ChzName	(nth (1- ChzName) UnqLst)
	)
	(if ChzName
		(foreach	BlkInfo
				BlkDatBigLst
				(if (wcmatch (strcase (car BlkInfo)) (strcase ChzName))
					(if BlkDetLst
						(setq	BlkDetLst	(cons BlkInfo BlkDetLst))
						(setq	BlkDetLst	(list BlkInfo))
					)
				)
		)
	)
	(if NoShwLst
		(setq	NoNoShwHnd	(mapcar (quote cadr) NoShwLst))
	)
	(foreach	NoLst
			BlkDetLst
			(command "_.Zoom" "C" (nth 3 NoLst) (* 0.75 PnScl))
			(InsRep NoLst)
	)
	(if (and BlkDetLst NoShwLst)
		(princ (strcat "\nUpdated [" (itoa (length BlkDetLst)) "] symbols, with [" (itoa (length NoShwLst)) "] marked N.O.!"))
		(if BlkDetLst
			(princ (strcat "\nUpdated [" (itoa (length BlkDetLst)) "] symbols!"))
			(princ "\nCould not initialize BlkDetLst [List of Valid Devices to convert]\n")
		)
	)
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CELTYPE" LtWas)
	(setvar "CLAYER" LayWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CMDECHO" EchWas)
	(setvar "FILEDIA" FilWas)
	(setvar "OSMODE" OsWas)
	(setvar "EXPERT" ExWas)
	(princ)
)

(defun C:DoAllSub ( /	AttWas BlpWas ColWas	; Main Insert Replace Function
					LtWas LayWas CmdWas EchWas FilWas OsWas ExWas
					LogWas LogOnWas Bubba NoLst BlkDeleteLst
					ints isecs outs osecs esecs otim elss
					BlkDetLst ChzName Cntr BlkInfo NoLst ssF )
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			ColWas	(getvar "CECOLOR")
			LtWas	(getvar "CELTYPE")
			LayWas	(getvar "CLAYER")
			CmdWas	(getvar "CMDDIA")
			EchWas	(getvar "CMDECHO")
			FilWas	(getvar "FILEDIA")
			OsWas	(getvar "OSMODE")
			ExWas	(getvar "EXPERT")
			MdWas	(getvar "MODEMACRO")
	)
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
			(setvar "EXPERT" 5)
		)
	)
	(command "_.UNDO" "_BE")
	(setq	Cntr		0)
	(if (= (substr (StpDot AppNam) 1 4) "ADDS")
		(progn
			(if (not Chk_Inserts)
				(LodStage "RemDups")
			)
			(if (not GetPS)
				(LodStage "Panel")
			)
		)
		(progn
			(if (not Chk_Inserts)
				(Load (strcat	TestPrmRootPath "Adds\\LISP\\RemDups"))
			)
			(if (not GetPS)
				(Load (strcat	TestPrmRootPath "Adds\\LISP\\Panel"))
			)
		)
	)
	(command "-Layer" "T" "*" "U" "*" "ON" "*" "S" "0" "" "_.Zoom" "E")
	(setq	ssF	(ssget "X" (list (cons 0 "INSERT") (cons 2 "CADET"))))
	(if ssF
		(if (>= (sslength ssF) 1)
			(princ (strcat "\nDeleting [" (itoa (sslength ssF)) "] {CADET} that no longer belong."))
		)
	)
	(if ssF
		(if (>= (sslength ssF) 1)
			(command "_.Erase" ssF "")
		)
	)
	(setq	ssF	(ssget "X" (list (cons 0 "INSERT") (cons 2 "CADET15"))))
	(if ssF
		(if (>= (sslength ssF) 1)
			(princ (strcat "\nDeleting [" (itoa (sslength ssF)) "] {CADET15} that no longer belong."))
		)
	)
	(if ssF
		(if (>= (sslength ssF) 1)
			(command "_.Erase" ssF "")
		)
	)
	(setq	ssF	(ssget "X" (list (cons 0 "INSERT") (cons 2 "AME_SOL"))))
	(if ssF
		(if (>= (sslength ssF) 1)
			(princ (strcat "\nDeleting [" (itoa (sslength ssF)) "] {AME_SOL} that no longer belong."))
		)
	)
	(if ssF
		(if (>= (sslength ssF) 1)
			(command "_.Erase" ssF "")
		)
	)
	(setq	ssF	(ssget "X" (list (cons 0 "INSERT") (cons 2 "AME_NIL"))))
	(if ssF
		(if (>= (sslength ssF) 1)
			(princ (strcat "\nDeleting [" (itoa (sslength ssF)) "] {AME_NIL} that no longer belong."))
		)
	)
	(if ssF
		(if (>= (sslength ssF) 1)
			(command "_.Erase" ssF "")
		)
	)
	(setq	ssF	(ssget "X" (list (cons 0 "INSERT") (cons 2 "NO"))))
	(if ssF
		(if (>= (sslength ssF) 1)
			(princ (strcat "\nDeleting [" (itoa (sslength ssF)) "] {NO} that no longer belong."))
		)
	)
	(if ssF
		(if (>= (sslength ssF) 1)
			(command "_.Erase" ssF "")
		)
	)
	(setq	ssF	(ssget "X" (list (cons 0 "INSERT") (cons 2 "REGARR"))))
	(if ssF
		(if (>= (sslength ssF) 1)
			(princ (strcat "\nDeleting [" (itoa (sslength ssF)) "] {REGARR} that no longer belong."))
		)
	)
	(if ssF
		(if (>= (sslength ssF) 1)
			(command "_.Erase" ssF "")
		)
	)
	(setq	ssF	(ssget "X" (list (cons 0 "INSERT") (cons 2 "CONNECT"))))
	(if ssF
		(if (>= (sslength ssF) 1)
			(princ (strcat "\nDeleting [" (itoa (sslength ssF)) "] {CONNECT} that no longer belong."))
		)
	)
	(if ssF
		(if (>= (sslength ssF) 1)
			(command "_.Erase" ssF "")
		)
	)
	(setq	ssF	(ssget "X" (list (cons 0 "INSERT") (cons 2 "FBD_NODE"))))
	(if ssF
		(if (>= (sslength ssF) 1)
			(princ (strcat "\nDeleting [" (itoa (sslength ssF)) "] {FBD_NODE} that no longer belong."))
		)
	)
	(if ssF
		(if (>= (sslength ssF) 1)
			(command "_.Erase" ssF "")
		)
	)
	(setq	ssF	(ssget "X" (list (cons 0 "INSERT") (cons 2 "FID_NODE"))))
	(if ssF
		(if (>= (sslength ssF) 1)
			(princ (strcat "\nDeleting [" (itoa (sslength ssF)) "] {FID_NODE} that no longer belong."))
		)
	)
	(if ssF
		(if (>= (sslength ssF) 1)
			(command "_.Erase" ssF "")
		)
	)
	(setq	ssF	(ssget "X" (list (cons 0 "INSERT") (cons 2 "HIGH-SUB"))))
	(if ssF
		(if (>= (sslength ssF) 1)
			(princ (strcat "\nDeleting [" (itoa (sslength ssF)) "] {HIGH-SUB} that no longer belong."))
		)
	)
	(if ssF
		(if (>= (sslength ssF) 1)
			(command "_.Erase" ssF "")
		)
	)
	(setq	ssF	(ssget "X" (list (cons 0 "INSERT") (cons 2 "MID_NODE"))))
	(if ssF
		(if (>= (sslength ssF) 1)
			(princ (strcat "\nDeleting [" (itoa (sslength ssF)) "] {MID_NODE} that no longer belong."))
		)
	)
	(if ssF
		(if (>= (sslength ssF) 1)
			(command "_.Erase" ssF "")
		)
	)
	(setq	ssF	(ssget "X" (list (cons 0 "INSERT") (cons 2 "NODE-SUB"))))
	(if ssF
		(if (>= (sslength ssF) 1)
			(princ (strcat "\nDeleting [" (itoa (sslength ssF)) "] {NODE-SUB} that no longer belong."))
		)
	)
	(if ssF
		(if (>= (sslength ssF) 1)
			(command "_.Erase" ssF "")
		)
	)
	(setq	ssF	(ssget "X" (list (cons 0 "INSERT") (cons 2 "SND_NODE"))))
	(if ssF
		(if (>= (sslength ssF) 1)
			(princ (strcat "\nDeleting [" (itoa (sslength ssF)) "] {SND_NODE} that no longer belong."))
		)
	)
	(if ssF
		(if (>= (sslength ssF) 1)
			(command "_.Erase" ssF "")
		)
	)
	(setq	ssF	(ssget "X" (list (cons 0 "INSERT") (cons 2 "SRC_NODE"))))
	(if ssF
		(if (>= (sslength ssF) 1)
			(princ (strcat "\nDeleting [" (itoa (sslength ssF)) "] {SRC_NODE} that no longer belong."))
		)
	)
	(if ssF
		(if (>= (sslength ssF) 1)
			(command "_.Erase" ssF "")
		)
	)
	(BlkReset)
	(setq	sff		500
			sf		(* sff 0.3048)
			Bubba	(setvar "THICKNESS" (float sff))
			Bubba	(setvar "LTSCALE" (float sff))
			PnScl	(float sff)
			Panel	(strcase (substr (getvar "DWGNAME") 1 7))
			Bubba	(setvar "USERS4" Panel)
	)
	(SetLin AppNam AppMode)
	(if (not BlkDatBigLst)
		(BlkDataFnd)
	)
	(if (not BlkDatNoLst)
		(setq	BlkDatNoLst	(list "Bogus" "Bogus"))
	)
	(if (not BlkDatLandLst)
		(setq	BlkDatLandLst	(list "Bogus" "Bogus"))
	)
	(SetLin AppNam AppMode)
	(if (and ValidLst BlkDatBigLst)
		(foreach	ChzName
				ValidLst
				(foreach	BlkInfo
						BlkDatBigLst
						(if (wcmatch (strcase (car BlkInfo)) (strcase ChzName))
							(if BlkDetLst
								(setq	BlkDetLst	(cons BlkInfo BlkDetLst))
								(setq	BlkDetLst	(list BlkInfo))
							)
						)
				)
		)
	)
	(SetLin AppNam AppMode)
	(if (and ValidLst BlkDatMiscLst)
		(foreach	ChzName
				ValidLst
				(foreach	BlkInfo
						BlkDatMiscLst
						(if (wcmatch (strcase (car BlkInfo)) (strcase ChzName))
							(if BlkDetLst
								(setq	BlkDetLst	(cons BlkInfo BlkDetLst))
								(setq	BlkDetLst	(list BlkInfo))
							)
						)
				)
		)
	)
	(SetLin AppNam AppMode)
	(if BlkDetLst
		(foreach	NoLst
				BlkDetLst
				(setq	Cntr		(1+ Cntr))
				(command "_.Zoom" "C" (nth 3 NoLst) (* 0.75 PnScl))
				(InsRep NoLst)
		)
	)
	(SetLin AppNam AppMode)
;;;	(setq	outs		(getvar "date")
;;;			osecs	(* 86400.0 (- outs (fix outs)))
;;;			esecs	(- (* osecs 1000.0) (* isecs 1000.0))
;;;			otim		(eMillFmt esecs)
;;;			elss		(itoa (fix esecs))
;;;			Bubba	(princ	(strcat	"\nElapsed Time = "
;;;									(PadNum (itoa (fix (nth 1 otim))) 2)
;;;									":"
;;;									(PadNum (itoa (fix (nth 2 otim))) 2)
;;;									(if (< (nth 3 otim) 10000.0)
;;;										":0"
;;;										":"
;;;									)
;;;									(rtos (/ (nth 3 otim) 1000.0) 2 3)
;;;							)
;;;					)
;;;	)
	(command "-Layer" "T" "*" "U" "*" "ON" "*" "S" "0" "F" "MASK,????FL*" "" "_.Zoom" "E")
	(if BlkDetLst
		(princ "\nCongratulations!  You have completed conversion sucessfully!\n")
	)
	(if BlkDetLst
		(RWav 22)
	)
	(SetLin AppNam AppMode)

	(setq	ssLPL	(ssget "X" (list (cons 0 "LWPOLYLINE"))))
	(if ssLPL (command "ConvertPoly" "H" ssLPL ""))

	(command "_.PURGE" "_A" "*" "_N")
	(command "_.PURGE" "_A" "*" "_N")
	(command "_.PURGE" "_A" "*" "_N")
	(command "_.BLOCK" "?" "*")
	(command "_.LAYER" "?" "??#?ck-*" "")

	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CELTYPE" LtWas)
	(setvar "CLAYER" LayWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CMDECHO" EchWas)
	(setvar "FILEDIA" FilWas)
	(setvar "OSMODE" OsWas)
	(setvar "EXPERT" ExWas)
	(setvar "MODEMACRO" MdWas)
	(princ)
)

(defun C:DoAllRep ( /	AttWas BlpWas ColWas	; Main Insert Replace Function
					LtWas LayWas CmdWas EchWas FilWas OsWas ExWas
					LogWas LogOnWas Bubba NoLst BlkDeleteLst
					ints isecs outs osecs esecs otim elss
					BlkDetLst ChzName Cntr BlkInfo NoLst ssF )
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			ColWas	(getvar "CECOLOR")
			LtWas	(getvar "CELTYPE")
			LayWas	(getvar "CLAYER")
			CmdWas	(getvar "CMDDIA")
			EchWas	(getvar "CMDECHO")
			FilWas	(getvar "FILEDIA")
			OsWas	(getvar "OSMODE")
			ExWas	(getvar "EXPERT")
			MdWas	(getvar "MODEMACRO")
	)
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
			(setvar "EXPERT" 5)
		)
	)
	(command "_.UNDO" "_BE")
	(BlkReset)
	(if (= (substr (StpDot AppNam) 1 4) "ADDS")
		(progn
			(if (not Chk_Inserts)
				(LodStage "RemDups")
			)
			(if (not GetPS)
				(LodStage "Panel")
			)
		)
		(progn
			(if (not Chk_Inserts)
				(Load (strcat	TestPrmRootPath "Adds\\LISP\\RemDups"))
			)
			(if (not GetPS)
				(Load (strcat	TestPrmRootPath "Adds\\LISP\\Panel"))
			)
		)
	)
	(setq	LayChkNot		T)
	(if (= Div "M_")
		(Chk_Inserts)
	)
	(cond
		((and (= (substr (StpDot AppNam) 1 4) "ADDS") DevMark)
			(setq	LogWas	(getvar "LOGFILENAME")
					LogOnWas	(getvar "LOGFILEMODE")
					Bubba	(setvar "LOGFILENAME" (strcat TestPrmRootPath "Shared Panels\\Data\\ConvReport_" (strcase (getvar "LOGINNAME")) ".Log"))
					Bubba	(setvar "LOGFILEMODE" 1)
					Bubba	(if PanLst
								(if (> (length PanLst) 1)
									(princ "\nWorking Panels:")
									(princ "\nWorking Panel:")
								)
								(princ "\nNo Panels Open!")
							)
					Bubba	(if PanLst
								(mapcar (quote (lambda (x) (princ (strcat "\n" x)))) PanLst)
							)
			)
			(if (not _Path-Sym)
				(setq	_Path-Sym		(strcat TestPrmRootPath "Adds\\Sym\\"))
			)
		)
		((= (substr (StpDot AppNam) 1 4) "ADDS")
			(setq	LogWas	(getvar "LOGFILENAME")
					LogOnWas	(getvar "LOGFILEMODE")
					Bubba	(setvar "LOGFILENAME" (strcat PrmRootPath "Shared Panels\\Data\\ConvReport_") (strcase (getvar "LOGINNAME")) ".Log"))
					Bubba	(setvar "LOGFILEMODE" 1)
					Bubba	(if PanLst
								(if (> (length PanLst) 1)
									(princ "\nWorking Panels:")
									(princ "\nWorking Panel:")
								)
								(princ "\nNo Panels Open!")
							)
					Bubba	(if PanLst
								(mapcar (quote (lambda (x) (princ (strcat "\n" x)))) PanLst)
							)
			)
			(if (not _Path-Sym)
				(setq	_Path-Sym		(strcat 	PrmRootPath "Adds\\Sym\\")	;	If c_Path-Sym path not set then set it based on s drive location
			)
		)
		(DevMark
			(setq	LogWas	(getvar "LOGFILENAME")
					LogOnWas	(getvar "LOGFILEMODE")
					Bubba	(setvar "LOGFILENAME" (strcat "C:\\Data\\Zip\\ConvReport_" (strcase (getvar "LOGINNAME")) ".Log"))
					Bubba	(setvar "LOGFILEMODE" 1)
			)
			(if (not _Path-Sym)
				(setq	_Path-Sym			"C:\\Div_Map\\Adds\\SYM\\")
			)
		)
		(T
			(setq	LogWas	(getvar "LOGFILENAME")
					LogOnWas	(getvar "LOGFILEMODE")
					Bubba	(setvar "LOGFILENAME" (strcat "C:\\Data\\Public\\ConvReport_" (strcase (getvar "LOGINNAME")) ".Log"))
					Bubba	(setvar "LOGFILEMODE" 1)
			)
			(if (not _Path-Sym)
				(setq	_Path-Sym			"C:\\Div_Map\\Adds\\SYM\\")
			)
		)
	)
	(if (> (strlen LogWas) 1)
		(setq	LogWas	(RepLChar LogWas "\\" "/" 0))
	)
	(if (not BlkDatBigLst)
		(BlkDataFnd)
	)
	(command "-Layer" "T" "*" "U" "*" "ON" "*" "")
	(setq	ints		(getvar "date")
			isecs	(* 86400.0 (- ints (fix ints)))
			BlkDetLst	nil
			ChzName	nil
			Cntr		0
	)
	(if (and ValidLst BlkDatBigLst)
		(foreach	ChzName
				ValidLst
				(foreach	BlkInfo
						BlkDatBigLst
						(if (wcmatch (strcase (car BlkInfo)) (strcase ChzName))
							(if BlkDetLst
								(setq	BlkDetLst	(cons BlkInfo BlkDetLst))
								(setq	BlkDetLst	(list BlkInfo))
							)
						)
				)
		)
	)
	(if (and ValidLst BlkDatLandLst)
		(foreach	ChzName
				ValidLst
				(foreach	BlkInfo
						BlkDatLandLst
						(if (wcmatch (strcase (car BlkInfo)) (strcase ChzName))
							(if BlkDetLst
								(setq	BlkDetLst	(cons BlkInfo BlkDetLst))
								(setq	BlkDetLst	(list BlkInfo))
							)
						)
				)
		)
	)
	(if (and ValidLst BlkDatMiscLst)
		(foreach	ChzName
				ValidLst
				(foreach	BlkInfo
						BlkDatMiscLst
						(if (wcmatch (strcase (car BlkInfo)) (strcase ChzName))
							(if BlkDetLst
								(setq	BlkDetLst	(cons BlkInfo BlkDetLst))
								(setq	BlkDetLst	(list BlkInfo))
							)
						)
				)
		)
	)
	(if NoShwLst
		(setq	NoShwHnd		(mapcar (quote cadr) NoShwLst)
				NoNoShwHnd	(mapcar (quote car) NoShwLst)
		)
	)
	(if BlkDetLst
		(foreach	NoLst
				BlkDetLst
				(setq	Cntr		(1+ Cntr))
				(command "_.Zoom" "C" (nth 3 NoLst) (* 0.75 PnScl))
				(InsRep NoLst)
		)
	)
	(if (and BlkDetLst NoShwLst)
		(princ (strcat "\nUpdated [" (itoa (length BlkDetLst)) "] symbols, with [" (itoa (length NoShwLst)) "] marked N.O.!"))
		(if BlkDetLst
			(princ (strcat "\nUpdated [" (itoa (length BlkDetLst)) "] symbols!"))
			(princ "\nCould not initialize BlkDetLst [List of Valid Devices to convert]\n")
		)
	)
	(setq	outs		(getvar "date")
			osecs	(* 86400.0 (- outs (fix outs)))
			esecs	(- (* osecs 1000.0) (* isecs 1000.0))
			otim		(eMillFmt esecs)
			elss		(itoa (fix esecs))
			Bubba	(princ	(strcat	"\nElapsed Time = "
									(PadNum (itoa (fix (nth 1 otim))) 2)
									":"
									(PadNum (itoa (fix (nth 2 otim))) 2)
									(if (< (nth 3 otim) 10000.0)
										":0"
										":"
									)
									(rtos (/ (nth 3 otim) 1000.0) 2 3)
							)
					)
	)
	(command "-Layer" "T" "*" "U" "*" "ON" "*" "")
	(setq	ssF	(ssget "X" (list (cons 0 "INSERT") (cons 2 "NO"))))
	(if ssF
		(if (>= (sslength ssF) 1)
			(princ (strcat "\nDeleting [" (itoa (sslength ssF)) "] {NO} that no longer belong."))
		)
	)
	(if ssF
		(if (>= (sslength ssF) 1)
			(command "_.Erase" ssF "")
		)
	)
	(setq	ssF	(ssget "X" (list (cons 0 "INSERT") (cons 2 "NODE-SUB"))))
	(if ssF
		(if (>= (sslength ssF) 1)
			(princ (strcat "\nDeleting [" (itoa (sslength ssF)) "] {NODE-SUB} that no longer belong."))
		)
	)
	(if ssF
		(if (>= (sslength ssF) 1)
			(command "_.Erase" ssF "")
		)
	)
	(setq	ssF	(ssget "X" (list (cons 0 "INSERT") (cons 2 "HIGH-SUB"))))
	(if ssF
		(if (>= (sslength ssF) 1)
			(princ (strcat "\nDeleting [" (itoa (sslength ssF)) "] {HIGH-SUB} that no longer belong."))
		)
	)
	(if ssF
		(if (>= (sslength ssF) 1)
			(command "_.Erase" ssF "")
		)
	)
	(setq	ssF	(ssget "X" (list (cons 0 "INSERT") (cons 2 "REGARR"))))
	(if ssF
		(if (>= (sslength ssF) 1)
			(princ (strcat "\nDeleting [" (itoa (sslength ssF)) "] {REGARR} that no longer belong."))
		)
	)
	(if ssF
		(if (>= (sslength ssF) 1)
			(command "_.Erase" ssF "")
		)
	)
	(if BlkDetLst
		(command "_.Layer" "T" "*" "U" "*" "ON" "*" "S" "0" "F" "????CP*" "" "_.Zoom" "E")	;????CE*,????FL*,MASK
	)
	(if (wcmatch (strcase (getvar "LOGINNAME")) "GEWILYMS")
		(progn
			(setq	ssF	(ssget "X" (list (cons 0 "INSERT"))))
			(if ssF
				(command "DRAWORDER" ssF "" "F")
			)
		)
	)
	(if BlkDetLst
		(princ "\nCongratulations!  You have completed conversion sucessfully!\n")
	)
	(if BlkDetLst
		(RWav 22)
	)
	(if (> (strlen LogWas) 1)
		(setvar "LOGFILENAME" LogWas)
	)
	(if (/= LogOnWas (getvar "LOGFILEMODE"))
		(setvar "LOGFILEMODE" LogOnWas)
	)
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CELTYPE" LtWas)
	(setvar "CLAYER" LayWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CMDECHO" EchWas)
	(setvar "FILEDIA" FilWas)
	(setvar "OSMODE" OsWas)
	(setvar "EXPERT" ExWas)
	(setvar "MODEMACRO" MdWas)
	(princ)
)

(defun BlkLayEnd ( NoHnd /	BlkLay )			; LookUp of Circuit Endpoints
	(if (setq BlkLay (assoc NoHnd NoMatchLst))
		(if Bug (princ "\nEndPnt data from NoMatchLst"))
		(if (setq BlkLay (assoc NoHnd MultMatchLst))
			(if Bug (princ "\nEndPnt data from MultMatchLst"))
			(if (setq BlkLay (assoc NoHnd FineMatchLst))
				(if Bug (princ "\nEndPnt data from FineMatchLst"))
				(progn
					(if Bug (princ "\nNo EndPnt data"))
					(setq BlkLay nil)
				)
			)
		)
	)
	BlkLay
)

(defun C:BlkNoAtt ( /	AttWas BlpWas ColWas	; Main N.O. Display Function
					LtWas LayWas CmdWas EchWas FilWas OsWas ExWas Bubba NoLst )
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			ColWas	(getvar "CECOLOR")
			LtWas	(getvar "CELTYPE")
			LayWas	(getvar "CLAYER")
			CmdWas	(getvar "CMDDIA")
			EchWas	(getvar "CMDECHO")
			FilWas	(getvar "FILEDIA")
			OsWas	(getvar "OSMODE")
			ExWas	(getvar "EXPERT")
	)
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
			(setvar "EXPERT" 5)
		)
	)
	(command "_.UNDO" "_BE")
	(command "-Layer" "F" "????FL*" "")
	(if NoFndLst
		(if ChxInt
			(setq	WuzInt	(length NoFndLst)
					ChxInt	(getint (strcat "\nTheir are {" (itoa (length NoFndLst)) "} N.O.'s to inspect.  <" (itoa WuzInt) ">: "))
			)
			(setq	ChxInt	(getint (strcat "\nTheir are {" (itoa (length NoFndLst)) "} N.O.'s to inspect.  Which one: ")))
		)
	)
	(if (and (null ChxInt) WuzInt)
		(if (and (>= WuzInt 2) (<= WuzInt (1+ (length NoFndLst))))
			(setq	NoLst	(nth (- WuzInt 2) NoFndLst)
					ChxInt	WuzInt
					Bubba	(redraw (handent (nth 0 NoLst)) 4)
			)
		)
	)
	(if (and (>= ChxInt 1) (<= ChxInt (length NoFndLst)))
		(progn
			(setq	NoLst	(nth (1- ChxInt) NoFndLst)
					NoHgt	(abs (* 10.0 (nth 3 NoLst)))
			)
			(command "_.Zoom" "C" (nth 2 NoLst) (* 0.75 PnScl))
			(redraw (handent (nth 0 NoLst)) 3)
		)
	)
	(if (and NoFndLst ChxInt)
		(progn
			(initget 1 "Yes No")
			(setq	Chz	(getkword "\nAdd to N.O. List? (Yes No): "))
			(if (= Chz "Yes")
				(progn
					(redraw (handent (nth 0 NoLst)) 4)
					(command "_.Insert" (strcat _Path-Sym "NO") (nth 2 NoLst) (* PnScl (nth 1 (SymSizN "NO")) 0.3048) "" "")
					(setq	NoEnt	(entget (entlast))
							EntDatOut	(list	(cdr (assoc 2 NoEnt)) 	;00 BlockName
											(cdr (assoc 5 NoEnt)) 	;01 Block Handle
											(cdr (assoc 8 NoEnt)) 	;02 Block Layer
											(cdr (assoc 10 NoEnt))	;03 Block Insertion Point
											(cdr (assoc 41 NoEnt))	;04 Block X-Scale
											(cdr (assoc 42 NoEnt))	;05 Block Y-Scale
											(cdr (assoc 43 NoEnt))	;06 Block Z-Scale
											(cdr (assoc 50 NoEnt))	;07 Block Rotation
											(cdr (assoc 67 NoEnt))	;08 Block Space Mode (0=Model, 1=Paper)
											(cdr (assoc 66 NoEnt))	;09 Block Attributes Follow (1=Yes, 0=No)
									)
							NoHnd	(cdr (assoc 5 NoEnt))
							NoLst	(list	NoHnd
											(nth 0 NoLst)
											(nth 2 NoLst)
											(nth 2 NoLst)
									)
					)
					(if NoShwLst
						(setq	NoShwLst	(append NoShwLst (list NoLst)))
						(setq	NoShwLst	(list NoLst))
					)
					(if BlkDatNoLst
						(setq	BlkDatNoLst	(append BlkDatNoLst (list EntDatOut)))
						(setq	BlkDatNoLst	(list EntDatOut))
					)
					(if BlkDatHndLst
						(setq	BlkDatHndLst	(append BlkDatHndLst (list (cdr EntDatOut))))
						(setq	BlkDatHndLst	(list (cdr EntDatOut)))
					)
					(setq	NoFndLst	(RemNumLst (1- ChxInt) NoFndLst)
							ChxInt	(1- ChxInt)
							WuzInt	(1- ChxInt)
					)
				)
				(redraw (handent (nth 0 NoLst)) 4)
			)
		)
	)
	(if NoShwLst
		(setq	NoShwHnd		(mapcar (quote cadr) NoShwLst)
				NoNoShwHnd	(mapcar (quote car) NoShwLst)
		)
	)
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CELTYPE" LtWas)
	(setvar "CLAYER" LayWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CMDECHO" EchWas)
	(setvar "FILEDIA" FilWas)
	(setvar "OSMODE" OsWas)
	(setvar "EXPERT" ExWas)
	(princ)
)

(defun C:DoNoAtt ( /	AttWas BlpWas ColWas	; Main N.O. Display Function
					LtWas LayWas CmdWas EchWas FilWas OsWas ExWas Bubba )
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			ColWas	(getvar "CECOLOR")
			LtWas	(getvar "CELTYPE")
			LayWas	(getvar "CLAYER")
			CmdWas	(getvar "CMDDIA")
			EchWas	(getvar "CMDECHO")
			FilWas	(getvar "FILEDIA")
			OsWas	(getvar "OSMODE")
			ExWas	(getvar "EXPERT")
	)
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
			(setvar "EXPERT" 5)
		)
	)
	(command "_.UNDO" "_BE")
	(command "-Layer" "F" "????FL*" "")
	(DoNoAtt)
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CELTYPE" LtWas)
	(setvar "CLAYER" LayWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CMDECHO" EchWas)
	(setvar "FILEDIA" FilWas)
	(setvar "OSMODE" OsWas)
	(setvar "EXPERT" ExWas)
	(princ)
)

(defun DoNoAtt ( /	NoLst Cntr NoHgt NoEnt		; Builds NoShwLst for N.O. objects
				EntDatOut NoHnd )
	(setq	Cntr		0)
	(if NoFndLst
		(foreach	NoLst
				NoFndLst
				(setq	NoHgt	(abs (* 10.0 (nth 3 NoLst))))
				(command "_.Zoom" "C" (nth 2 NoLst) (* 0.75 PnScl))
				(command "_.Insert" (strcat _Path-Sym "NO") (nth 2 NoLst) (* PnScl (nth 1 (SymSizN "NO")) 0.3048) "" "")
				(setq	NoEnt	(entget (entlast))
						EntDatOut	(list	(cdr (assoc 2 NoEnt)) 	;00 BlockName
										(cdr (assoc 5 NoEnt)) 	;01 Block Handle
										(cdr (assoc 8 NoEnt)) 	;02 Block Layer
										(cdr (assoc 10 NoEnt))	;03 Block Insertion Point
										(cdr (assoc 41 NoEnt))	;04 Block X-Scale
										(cdr (assoc 42 NoEnt))	;05 Block Y-Scale
										(cdr (assoc 43 NoEnt))	;06 Block Z-Scale
										(cdr (assoc 50 NoEnt))	;07 Block Rotation
										(cdr (assoc 67 NoEnt))	;08 Block Space Mode (0=Model, 1=Paper)
										(cdr (assoc 66 NoEnt))	;09 Block Attributes Follow (1=Yes, 0=No)
								)
						NoHnd	(cdr (assoc 5 NoEnt))
						NoLst	(list	NoHnd
										(nth 0 NoLst)
										(nth 2 NoLst)
										(nth 2 NoLst)
								)
				)
				(if NoShwLst
					(setq	NoShwLst	(append NoShwLst (list NoLst)))
					(setq	NoShwLst	(list NoLst))
				)
				(if BlkDatNoLst
					(setq	BlkDatNoLst	(append BlkDatNoLst (list EntDatOut)))
					(setq	BlkDatNoLst	(list EntDatOut))
				)
				(if BlkDatHndLst
					(setq	BlkDatHndLst	(append BlkDatHndLst (list (cdr EntDatOut))))
					(setq	BlkDatHndLst	(list (cdr EntDatOut)))
				)
				(setq	NoFndLst	(RemNumLst Cntr NoFndLst)
						Cntr		(1+ Cntr)
				)
		)
	)
	(if NoShwLst
		(setq	NoShwHnd		(mapcar (quote cadr) NoShwLst)
				NoNoShwHnd	(mapcar (quote car) NoShwLst)
		)
	)
)

(defun C:BlkNoLay ( /	AttWas BlpWas ColWas	; CL - Main N.O. Display Function
					LtWas LayWas CmdWas EchWas FilWas OsWas ExWas Bubba NoLst )
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			ColWas	(getvar "CECOLOR")
			LtWas	(getvar "CELTYPE")
			LayWas	(getvar "CLAYER")
			CmdWas	(getvar "CMDDIA")
			EchWas	(getvar "CMDECHO")
			FilWas	(getvar "FILEDIA")
			OsWas	(getvar "OSMODE")
			ExWas	(getvar "EXPERT")
	)
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
			(setvar "EXPERT" 5)
		)
	)
	(command "_.UNDO" "_BE")
	(command "-Layer" "F" "????FL*" "")
	(if NoLayLst
		(if ChyInt
			(setq	WizInt	(1+ ChyInt)
					ChyInt	(getint (strcat "\nTheir are {" (itoa (length NoLayLst)) "} N.O.'s to inspect.  <" (itoa WizInt) ">: "))
			)
			(setq	ChyInt	(getint (strcat "\nTheir are {" (itoa (length NoLayLst)) "} N.O.'s to inspect.  Which one: ")))
		)
	)
	(if (and (null ChyInt) WizInt)
		(if (and (>= WizInt 2) (<= WizInt (1+ (length NoLayLst))))
			(setq	NoLst	(nth (- WizInt 2) NoLayLst)
					ChyInt	WizInt
					Bubba	(redraw (handent (nth 0 NoLst)) 4)
			)
		)
	)
	(if (and (>= ChyInt 1) (<= ChyInt (length NoLayLst)))
		(progn
			(setq	NoLst	(nth (1- ChyInt) NoLayLst)
					NoHgt	(abs (* 10.0 (nth 3 NoLst)))
			)
			(command "_.Zoom" "C" (nth 2 NoLst) (* 0.75 PnScl))
			(redraw (handent (nth 0 NoLst)) 3)
		)
	)
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CELTYPE" LtWas)
	(setvar "CLAYER" LayWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CMDECHO" EchWas)
	(setvar "FILEDIA" FilWas)
	(setvar "OSMODE" OsWas)
	(setvar "EXPERT" ExWas)
	(princ)
)

(defun C:BlkDetF ( / )						; CL - Main Block Detail Display Function
	(initget 1 "View")
	(setq	ChzInt	-3
			ChzMax	0
			BlkDetLst	nil
	)
	(cond
		((and BlkDatBigLst BlkDatNoLst BlkDatLandLst BlkDatMiscLst)
			(setq	IntroStr	(strcat	"\nSelect List Source:"
									"\n BlkDatBigLst  = 1"
									"\n BlkDatNoLst   = 2"
									"\n BlkDatLandLst = 3"
									"\n BlkDatMiscLst = 4"
									"\nYour Choice: "
							)
			)
			(initget 1 "")
			(setq	ChzMax	(getint IntroStr))
			(cond
				((= ChzMax 1)
					(setq	UnqLst	(BlkDigDisp BlkDatBigLst)
							UnqLst	(mapcar (quote car) UnqLst)
					)
					(initget 1 "")
					(setq	YrChz	(strcat "\nYour Choice (1-" (itoa (length UnqLst)) "): ")
							ChzName	(getint YrChz)
							ChzName	(nth (1- ChzName) UnqLst)
					)
					(if ChzName
						(foreach	BlkInfo
								BlkDatBigLst
								(if (wcmatch (strcase (car BlkInfo)) (strcase ChzName))
									(if BlkDetLst
										(setq	BlkDetLst	(cons BlkInfo BlkDetLst))
										(setq	BlkDetLst	(list BlkInfo))
									)
								)
						)
					)
				)
				((= ChzMax 2)
					(setq	UnqLst	(BlkDigDisp BlkDatNoLst)
							UnqLst	(mapcar (quote car) UnqLst)
					)
					(initget 1 "")
					(setq	YrChz	(strcat "\nYour Choice (1-" (itoa (length UnqLst)) "): ")
							ChzName	(getint YrChz)
							ChzName	(nth (1- ChzName) UnqLst)
					)
					(if ChzName
						(foreach	BlkInfo
								BlkDatNoLst
								(if (wcmatch (strcase (car BlkInfo)) (strcase ChzName))
									(if BlkDetLst
										(setq	BlkDetLst	(cons BlkInfo BlkDetLst))
										(setq	BlkDetLst	(list BlkInfo))
									)
								)
						)
					)
				)
				((= ChzMax 3)
					(setq	UnqLst	(BlkDigDisp BlkDatLandLst)
							UnqLst	(mapcar (quote car) UnqLst)
					)
					(initget 1 "")
					(setq	YrChz	(strcat "\nYour Choice (1-" (itoa (length UnqLst)) "): ")
							ChzName	(getint YrChz)
							ChzName	(nth (1- ChzName) UnqLst)
					)
					(if ChzName
						(foreach	BlkInfo
								BlkDatLandLst
								(if (wcmatch (strcase (car BlkInfo)) (strcase ChzName))
									(if BlkDetLst
										(setq	BlkDetLst	(cons BlkInfo BlkDetLst))
										(setq	BlkDetLst	(list BlkInfo))
									)
								)
						)
					)
				)
				((= ChzMax 4)
					(setq	UnqLst	(BlkDigDisp BlkDatMiscLst)
							UnqLst	(mapcar (quote car) UnqLst)
					)
					(initget 1 "")
					(setq	YrChz	(strcat "\nYour Choice (1-" (itoa (length UnqLst)) "): ")
							ChzName	(getint YrChz)
							ChzName	(nth (1- ChzName) UnqLst)
					)
					(if ChzName
						(foreach	BlkInfo
								BlkDatMiscLst
								(if (wcmatch (strcase (car BlkInfo)) (strcase ChzName))
									(if BlkDetLst
										(setq	BlkDetLst	(cons BlkInfo BlkDetLst))
										(setq	BlkDetLst	(list BlkInfo))
									)
								)
						)
					)
				)
			)
		)
	)
	(if (and BlkDetLst ChzName)
		(princ (strcat "\nYour selection {" ChzName "} found [" (itoa (length BlkDetLst)) "] matches.\n"))
	)
	(princ)
)

(defun BlkLayTst ( BlkLst /	NoLayLst			; Returns list of unmatched circuits
						Cntr Bubba NoLst ssT1 TLay1 TLay2 MyLst
						BlkHnd BlkStrt BlkEnd BlkScl BlkLay
						NoMatchLst MultMatchLst FineMatchLst )
	(command "-Layer" "T" "????CK-*" "")
	(setq	NoLayLst	(mapcar (quote BlkEndsTst) BlkLst)
			Cntr		0
	)
	(foreach	NoLst
			NoLayLst
			(setq	BlkHnd	(nth 0 NoLst)
					BlkStrt	(nth 1 NoLst)
					BlkEnd	(nth 2 NoLst)
					BlkScl	(nth 3 NoLst)
					BlkLay	(nth 4 NoLst)
					Cntr		(1+ Cntr)
			)
			(if (> BlkScl 1.0)
				(command	"_.Zoom"
						"C"
						(list	(+ (car BlkStrt) (/ (- (car BlkEnd) (car BlkStrt)) 2.0))
								(+ (cadr BlkStrt) (/ (- (cadr BlkEnd) (cadr BlkStrt)) 2.0))
						)
						(/ BlkScl 2.0)
				)
				(setq	Bubba	(if Bug (princ (strcat "\n {BlkLayTst} InValid Scale Working Handle [" BlkHnd "] Number [" (itoa Cntr) "]\n")))
						Bubba	(command	"_.Zoom"
										"C"
										(list	(+ (car BlkStrt) (/ (- (car BlkEnd) (car BlkStrt)) 2.0))
												(+ (cadr BlkStrt) (/ (- (cadr BlkEnd) (cadr BlkStrt)) 2.0))
										)
										250.0
								)
				)
			)
			(if (not (nth 5 NoLst))
				(if (not (member (cdr (assoc 2 (entget (handent BlkHnd)))) (list "ATS" "UNO_PAD")))
					(progn
						(setvar "OSMODE" 41)
						(RWav 2)
						(redraw (handent BlkHnd) 3)
						(setq	BlkEnd	(getpoint BlkStrt (strcat "\nInsert Width for [" (cdr (assoc 2 (entget (handent BlkHnd)))) "] not standard - select end point: ")))
						(setvar "OSMODE" 0)
						(redraw (handent BlkHnd) 4)
					)
					(cond
						((member (cdr (assoc 2 (entget (handent BlkHnd)))) (list "UNO_PAD"))
							(RWav 2)
							(redraw (handent BlkHnd) 3)
							(setq	BlkEnd	(polar BlkStrt (cdr (assoc 50 (entget (handent BlkHnd)))) (abs (cdr (assoc 41 (entget (handent BlkHnd))))))
									BlkScl	(/ (abs (cdr (assoc 41 (entget (handent BlkHnd))))) 0.10363200)
							)
							(setvar "OSMODE" 0)
						)
						((member (cdr (assoc 2 (entget (handent BlkHnd)))) (list "ATS"))
							(RWav 2)
							(redraw (handent BlkHnd) 3)
							(setq	BlkEnd	(polar BlkStrt (cdr (assoc 50 (entget (handent BlkHnd)))) (abs (cdr (assoc 41 (entget (handent BlkHnd))))))
									BlkScl	(/ (abs (cdr (assoc 41 (entget (handent BlkHnd))))) 0.10363200)
							)
							(setvar "OSMODE" 0)
						)
					)
				)
			)
			(setq	ssT1		(ssget "C"	(list (- (car BlkStrt) (* 0.0125 BlkScl)) (- (cadr BlkStrt) (* 0.0125 BlkScl)))
										(list (+ (car BlkStrt) (* 0.0125 BlkScl)) (+ (cadr BlkStrt) (* 0.0125 BlkScl)))
										(list (cons 0 "*POLYLINE") (cons 8 (strcat (substr BlkLay 1 3) "?CK-*")))
							)
			)
			(if ssT1
				(if (= (sslength ssT1) 1)
					(setq	TLay1	(cdr (assoc 8 (entget (ssname ssT1 0)))))
					(setq	TLay1	(strcat "Found{" (itoa (sslength ssT1)) "}"))
				)
				(setq	TLay1	"NotFound{0}")
			)
			(setq	ssT1		(ssget "C"	(list (- (car BlkEnd) (* 0.0125 BlkScl)) (- (cadr BlkEnd) (* 0.0125 BlkScl)))
										(list (+ (car BlkEnd) (* 0.0125 BlkScl)) (+ (cadr BlkEnd) (* 0.0125 BlkScl)))
										(list (cons 0 "*POLYLINE") (cons 8 (strcat (substr BlkLay 1 3) "?CK-*")))
							)
			)
			(if ssT1
				(if (= (sslength ssT1) 1)
					(setq	TLay2	(cdr (assoc 8 (entget (ssname ssT1 0)))))
					(setq	TLay2	(strcat "Found{" (itoa (sslength ssT1)) "}"))
				)
				(setq	TLay2	"NotFound{0}")
			)
			(setq	MyLst	(list BlkHnd BlkStrt BlkEnd BlkScl BlkLay TLay1 TLay2))
			(if (or (wcmatch TLay1 "NotFound*") (wcmatch TLay2 "NotFound*"))
				(if NoMatchLst
					(setq	NoMatchLst	(cons MyLst NoMatchLst))
					(setq	NoMatchLst	(list MyLst))
				)
				(if (not (wcmatch (strcase TLay1) (strcase TLay2)))
					(if MultMatchLst
						(setq	MultMatchLst	(cons MyLst MultMatchLst))
						(setq	MultMatchLst	(list MyLst))
					)
					(if FineMatchLst
						(setq	FineMatchLst	(cons MyLst FineMatchLst))
						(setq	FineMatchLst	(list MyLst))
					)
				)
			)
	)
	(list NoMatchLst MultMatchLst FineMatchLst)
)

(defun isCType ( InStr /	StrTst OutVal )	; Tests if is Capacitor Type
	(if InStr
		(if (> (strlen InStr) 0)
			(setq	StrTst	(strcase (StpSpac InStr)))
		)
	)
	(if StrTst
		(cond
			((= StrTst "S")
				(setq	OutVal "S")
			)
			((= StrTst "F")
				(setq	OutVal "F")
			)
			((= StrTst "SW")
				(setq	OutVal "S")
			)
			((= StrTst "SWITCHED")
				(setq	OutVal "S")
			)
			((= StrTst "SCADA")
				(setq	OutVal "S")
			)
			((= StrTst "FIXED")
				(setq	OutVal "F")
			)
			(T
				(setq	OutVal nil)
			)
		)
		(if InStr
			(if (= (strlen InStr) 0)
				(setq	OutVal "")
				(setq	OutVal nil)
			)
			(setq	OutVal nil)
		)
	)
	(if OutVal
		(if Bug (princ (strcat "\n {isCType} says [" OutVal "]")))
		(if Bug (princ (strcat "\n {isCType} says [not S type]")))
	)
	OutVal
)

(defun isCKvar ( InStr /	StrTst OutVal )	; Tests if is Capacitor Size
	(if InStr
		(if (> (strlen InStr) 0)
			(setq	StrTst	(strcase (StpSpac InStr)))
		)
	)
	(if StrTst
		(if (>= (strlen StrTst) 4)
			(if (wcmatch (strcase (substr StrTst (- (strlen StrTst) 3))) "KVAR")
				(setq	OutVal	StrTst)
				(setq	OutVal	nil)
			)
			(if (or (wcmatch StrTst "####") (wcmatch StrTst "###") (wcmatch StrTst "##"))
				(setq	OutVal	(strcat StrTst "KVAR"))
				(setq	OutVal	nil)
			)
		)
		(setq	OutVal	nil)
	)
	(if OutVal
		(if Bug (princ (strcat "\n {isCKvar} says [KVAR]")))
		(if Bug (princ (strcat "\n {isCKvar} says [not KVAR]")))
	)
	OutVal
)

(defun RemDevLst ( NoLst /	BlkHndLst BlkCntr )	; Removes Objects that have been converted from the Device Lists
	(cond
		((member (nth 0 NoLst) BlkNoIns)
			(setq	BlkHndLst		(mapcar (quote cadr) BlkDatNoLst)
					BlkCntr		(member (nth 1 NoLst) BlkHndLst)
			)
			(if BlkCntr
				(setq	BlkCntr		(- (length BlkHndLst) (length BlkCntr))
						BlkDatNoLst	(RemNumLst BlkCntr BlkDatNoLst)
				)
			)
		)
		((member (nth 0 NoLst) BlkNoDev)
			(setq	BlkHndLst		(mapcar (quote cadr) BlkDatBigLst)
					BlkCntr		(member (nth 1 NoLst) BlkHndLst)
			)
			(if BlkCntr
				(setq	BlkCntr		(- (length BlkHndLst) (length BlkCntr))
						BlkDatBigLst	(RemNumLst BlkCntr BlkDatBigLst)
				)
			)
		)
		((member (nth 0 NoLst) BlkLand)
			(setq	BlkHndLst		(mapcar (quote cadr) BlkDatLandLst)
					BlkCntr		(member (nth 1 NoLst) BlkHndLst)
			)
			(if BlkCntr
				(setq	BlkCntr		(- (length BlkHndLst) (length BlkCntr))
						BlkDatLandLst	(RemNumLst BlkCntr BlkDatLandLst)
				)
			)
		)
		(T
			(setq	BlkHndLst		(mapcar (quote cadr) BlkDatMiscLst)
					BlkCntr		(member (nth 1 NoLst) BlkHndLst)
			)
			(if BlkCntr
				(setq	BlkCntr		(- (length BlkHndLst) (length BlkCntr))
						BlkDatMiscLst	(RemNumLst BlkCntr BlkDatMiscLst)
				)
			)
		)
	)
)

(defun BlkAttUpd ( NoLst Pnt1 Gap Ang0 Dst0 /	; Ent1 	;Updates Attributes in Replaced Blocks
										)
										;XLst XNam EDat )
										;Att1 Att2 Att3 Att4 Att5 Att6 Att7 Att8 Att9 Att10 Att11 )
	(setq	ValLst	nil	Val01	nil	Val02	nil	Val03	nil	Val04	nil	Val05	nil
			Val06	nil	Val07	nil	Val08	nil	Val09	nil	Val10	nil	Val11	nil
			Ent1		nil	Att1		nil	Att2		nil	Att3		nil	Att4		nil	Att5		nil
			Att6		nil	Att7		nil	Att8		nil	Att9		nil	Att10	nil	Att11	nil
			Val01Box	nil	Val02Box	nil	Val03Box	nil	Val04Box	nil	Val05Box	nil	Val06Box	nil
			Val07Box	nil	Val08Box	nil	Val09Box	nil	Val10Box	nil	Val11Box	nil	AttSty	nil
			Ent1		(entget (entlast))
			Ent1		(cdr (assoc -1 Ent1))
	)
	(if (entnext Ent1)
		(setq	Att1		(entget (entnext Ent1))
				AttLay	(nth 3 (nth 1 (nth 10 NoLst)))
				AttSty	(nth 9 (nth 1 (nth 10 NoLst)))
				Att1		(subst (cons 8 AttLay) (assoc 8 Att1) Att1)
		)
		(setq	Att1		nil)
	)
	(if Att1
		(if (entnext (cdr (assoc -1 Att1)))
			(setq	Att2		(entget (entnext (cdr (assoc -1 Att1))))
					Att2		(subst (cons 8 AttLay) (assoc 8 Att2) Att2)
			)
			(setq	Att2		nil)
		)
		(setq	Att2		nil)
	)
	(cond
		((wcmatch (strcase (nth 0 NoLst)) "RECL*")
			(if Bug (princ "\n [BlkAttUpd] Case 1 - {RECL*}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "OCR" ValLst) (cdr (assoc "OCR" ValLst)) " ")
					Val02	(if (and (assoc "TYPE_OCR" ValLst) (assoc "AMP_OCR" ValLst))
								(strcat (cdr (assoc "AMP_OCR" ValLst)) " " (cdr (assoc "TYPE_OCR" ValLst)))
								(if (assoc "TYPE_OCR" ValLst)
									(cdr (assoc "TYPE_OCR" ValLst))
									(if (assoc "AMP_OCR" ValLst)
										(cdr (assoc "AMP_OCR" ValLst))
										" "
									)
								)
							)
					Val03	(if (assoc "SW1" ValLst) (cdr (assoc "SW1" ValLst)) " ")
					Val04	(if (and (> (strlen Val03) 0) (/= Val03 " ")) "S" " ")
			)
			(if (not (wcmatch (strcase (nth 0 NoLst)) "RECL"))
				(if	(or	(wcmatch (strcase (nth 0 NoLst)) "RECLBP")
						(wcmatch (strcase (nth 0 NoLst)) "RECLBP_2")
					)
					(setq	Val05	" "
							Val06	" "
							Val07	(if (assoc "BYPASS" ValLst) (cdr (assoc "BYPASS" ValLst)) " ")
							Val08	(if (and (> (strlen Val07) 0) (/= Val07 " ")) "B" " ")
					)
					(if	(or	(wcmatch (strcase (nth 0 NoLst)) "RECLEL")
							(wcmatch (strcase (nth 0 NoLst)) "RECLEL_2")
							(wcmatch (strcase (nth 0 NoLst)) "RECLEL_3")
							(wcmatch (strcase (nth 0 NoLst)) "RECLEL_5")
						)
						(setq	Val05	(if (assoc "SW2" ValLst) (cdr (assoc "SW2" ValLst)) " ")
								Val06	(if (and (> (strlen Val05) 0) (/= Val05 " ")) "L" " ")
								Val07	(if (assoc "BYPASS" ValLst) (cdr (assoc "BYPASS" ValLst)) " ")
								Val08	(if (and (> (strlen Val07) 0) (/= Val07 " ")) "B" " ")
						)
						(if (wcmatch (strcase (nth 0 NoLst)) "RECLEL_4")
							(setq	Val05	(if (assoc "SW2" ValLst) (cdr (assoc "SW2" ValLst)) " ")
									Val06	(if (and (> (strlen Val05) 0) (/= Val05 " ")) "L" " ")
									Val07	(if (assoc "BYP" ValLst) (cdr (assoc "BYP" ValLst)) " ")
									Val08	(if (and (> (strlen Val07) 0) (/= Val07 " ")) "B" " ")
							)
							(princ "\n {BlkAttUpd} not handling all RECL cases correctly...\n")
						)
					)
				)
				(setq	Val05	" "
						Val06	" "
						Val07	" "
						Val08	" "
				)
			)
		)
		((or (wcmatch (strcase (nth 0 NoLst)) "_OCR") (wcmatch (strcase (nth 0 NoLst)) "_OCR_BP") (wcmatch (strcase (nth 0 NoLst)) "_OCR_EL"))
			(if Bug (princ "\n [BlkAttUpd] Case 2 - {_OCR*}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "NUMBER" ValLst) (cdr (assoc "NUMBER" ValLst)) " ")
					Val02	(if (and (assoc "TYPE" ValLst) (assoc "SIZE" ValLst))
								(strcat (cdr (assoc "SIZE" ValLst)) " " (cdr (assoc "TYPE" ValLst)))
								(if (assoc "TYPE" ValLst)
									(cdr (assoc "TYPE" ValLst))
									(if (assoc "SIZE" ValLst)
										(cdr (assoc "SIZE" ValLst))
										" "
									)
								)
							)
					Val03	(if (assoc "SOURCE" ValLst) (cdr (assoc "SOURCE" ValLst)) " ")
					Val04	(if (and (> (strlen Val03) 0) (/= Val03 " ")) "S" " ")
					Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "NUMBER" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
					Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "SIZE" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
					Val03Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "SOURCE" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
					Val04Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "S_INDICATOR" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
			)
			(if (or (wcmatch (strcase (nth 0 NoLst)) "_OCR_BP") (wcmatch (strcase (nth 0 NoLst)) "_OCR_EL"))
				(if (wcmatch (strcase (nth 0 NoLst)) "_OCR_BP")
					(setq	Bubba	(if Bug (princ "\n [BlkAttUpd] detected symbol {_OCR_BP}\n"))
							Val05	" "
							Val06	(if (and (> (strlen Val05) 0) (/= Val05 " ")) "L" " ")
							Val07	(if (assoc "BYPASS" ValLst) (cdr (assoc "BYPASS" ValLst)) " ")
							Val08	(if (and (> (strlen Val07) 0) (/= Val07 " ")) "B" " ")
							Val07Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "BYPASS" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
							Val08Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "B_INDICATOR" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
					)
					(if (wcmatch (strcase (nth 0 NoLst)) "_OCR_EL")
						(setq	Bubba	(if Bug (princ "\n [BlkAttUpd] detected symbol {_OCR_EL}\n"))
								Val05	(if (assoc "LOAD" ValLst) (cdr (assoc "LOAD" ValLst)) " ")
								Val06	(if (and (> (strlen Val05) 0) (/= Val05 " ")) "L" " ")
								Val07	(if (assoc "BYPASS" ValLst) (cdr (assoc "BYPASS" ValLst)) " ")
								Val08	(if (and (> (strlen Val07) 0) (/= Val07 " ")) "B" " ")
								Val05Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "LOAD" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
								Val06Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "L_INDICATOR" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
								Val07Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "BYPASS" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
								Val08Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "B_INDICATOR" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
						)
					)
				)
				(setq	Bubba	(if Bug (princ "\n [BlkAttUpd] detected symbol {_OCR}\n"))
						Val05	" "
						Val06	" "
						Val07	" "
						Val08	" "
				)
			)
		)
		((or (wcmatch (strcase (nth 0 NoLst)) "SECT") (wcmatch (strcase (nth 0 NoLst)) "_SECT"))
			(if Bug (princ "\n [BlkAttUpd] Case 3 - {SECT}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "SECT#" ValLst) (cdr (assoc "SECT#" ValLst)) " ")
					Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "SECT#" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
					Val02	(if (and (assoc "TYPE" ValLst) (assoc "AMPS" ValLst))
								(strcat (cdr (assoc "AMPS" ValLst)) " " (cdr (assoc "TYPE" ValLst)))
								(if (assoc "TYPE" ValLst)
									(cdr (assoc "TYPE" ValLst))
									(if (assoc "AMPS" ValLst)
										(cdr (assoc "AMPS" ValLst))
										" "
									)
								)
							)
					Val02Box	(if (assoc "TYPE" ValLst)
								(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "TYPE" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
								(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "AMPS" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
							)
			)
		)
		((wcmatch (strcase (nth 0 NoLst)) "FD_NUM2")
			(if Bug (princ "\n [BlkAttUpd] Case 4 - {FD_NUM2}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "##" ValLst) (cdr (assoc "##" ValLst)) " ")
					Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "##" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
			)
		)
		((wcmatch (strcase (nth 0 NoLst)) "LOC")
			(if Bug (princ "\n [BlkAttUpd] Case 5 - {LOC}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "###" ValLst) (cdr (assoc "###" ValLst)) " ")
					Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "###" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
			)
		)
		((wcmatch (strcase (nth 0 NoLst)) "URD_LOC")
			(if Bug (princ "\n [BlkAttUpd] Case 6 - {URD_LOC}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "##" ValLst) (cdr (assoc "##" ValLst)) " ")
					Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "##" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
			)
		)
		((wcmatch (strcase (nth 0 NoLst)) "ATS")
			(if Bug (princ "\n [BlkAttUpd] Case 7 - {ATS}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "ATS" ValLst) (cdr (assoc "ATS" ValLst)) " ")
					Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "ATS" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
			)
		)
		((wcmatch (strcase (nth 0 NoLst)) "CE")
			(if Bug (princ "\n [BlkAttUpd] Case 8 - {CE}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "EQUIP" ValLst) (cdr (assoc "EQUIP" ValLst)) " ")
					Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "EQUIP" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
			)
		)
		((wcmatch (strcase (nth 0 NoLst)) "_KEY")
			(if Bug (princ "\n [BlkAttUpd] Case 9 - {_KEY}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "NAME" ValLst) (cdr (assoc "NAME" ValLst)) " ")
					Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "NAME" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
					Val02	(if (assoc "DESCRIP" ValLst) (cdr (assoc "DESCRIP" ValLst)) " ")
					Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "DESCRIP" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
			)
		)
		((wcmatch (strcase (nth 0 NoLst)) "SUB")
			(if Bug (princ "\n [BlkAttUpd] Case 10 - {SUB}\n"))
			(if (wcmatch (StpDot AppNam) "SUBTOOLS")
				(progn
					(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst))))
					(if (and (assoc "SIZE" ValLst) (assoc "MVA" ValLst))
						(setq	Val01	(if (assoc "SIZE" ValLst) (cdr (assoc "SIZE" ValLst)) " ")
								Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "SIZE" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
								Val02	(if (assoc "MVA" ValLst) (cdr (assoc "MVA" ValLst)) " ")
								Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "MVA" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
						)
						(if (assoc "SIZE" ValLst)
							(setq	Val01	(if (assoc "SIZE" ValLst) (cdr (assoc "SIZE" ValLst)) " ")
									Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "SIZE" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
							)
							(if (assoc "MVA" ValLst)
								(setq	Val01	(if (assoc "MVA" ValLst) (cdr (assoc "MVA" ValLst)) " ")
										Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "MVA" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
								)
							)
						)
					)
				)
				(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
						Val01	(if (assoc "SUBSTATION" ValLst) (cdr (assoc "SUBSTATION" ValLst)) " ")
						Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "SUBSTATION" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
						Val02	(if (assoc "RATING" ValLst) (cdr (assoc "RATING" ValLst)) " ")
						Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "RATING" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
				)
			)
		)
		((or (wcmatch (strcase (nth 0 NoLst)) "RACK_NC") (wcmatch (strcase (nth 0 NoLst)) "RACK_NO") (wcmatch (strcase (nth 0 NoLst)) "RACK_RO"))
			(if Bug (princ "\n [BlkAttUpd] Case 23 - {RACK_[NC,NO,RO]}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "NUMBER" ValLst) (cdr (assoc "NUMBER" ValLst)) " ")
					Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "NUMBER" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
					Val02	(if (assoc "SW1#" ValLst) (cdr (assoc "SW1#" ValLst)) " ")
					Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "SW1#" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
					Val03	(if (assoc "SW2#" ValLst) (cdr (assoc "SW2#" ValLst)) " ")
					Val03Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "SW2#" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
			)
		)
		((or (wcmatch (strcase (nth 0 NoLst)) "MODC") (wcmatch (strcase (nth 0 NoLst)) "MODO") (wcmatch (strcase (nth 0 NoLst)) "SWC") (wcmatch (strcase (nth 0 NoLst)) "SWO") (wcmatch (strcase (nth 0 NoLst)) "GSC") (wcmatch (strcase (nth 0 NoLst)) "GSO") (wcmatch (strcase (nth 0 NoLst)) "BKRC") (wcmatch (strcase (nth 0 NoLst)) "BKRO"))
			(if Bug (princ "\n [BlkAttUpd] Case 23 - {MOD[OC]}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst))))
			(if (and (assoc "NUMBER" ValLst) (assoc "TYPE" ValLst))
				(setq	Val01	(if (assoc "NUMBER" ValLst) (cdr (assoc "NUMBER" ValLst)) " ")
						Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "NUMBER" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
						Val02	(if (assoc "TYPE" ValLst) (cdr (assoc "TYPE" ValLst)) " ")
						Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "TYPE" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
				)
				(if (assoc "NUMBER" ValLst)
					(setq	Val01	(if (assoc "NUMBER" ValLst) (cdr (assoc "NUMBER" ValLst)) " ")
							Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "NUMBER" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
					)
					(if (assoc "TYPE" ValLst)
						(setq	Val01	(if (assoc "TYPE" ValLst) (cdr (assoc "TYPE" ValLst)) " ")
								Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "TYPE" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
						)
					)
				)
			)
		)
		((or (wcmatch (strcase (nth 0 NoLst)) "FSC") (wcmatch (strcase (nth 0 NoLst)) "FSO"))
			(if Bug (princ "\n [BlkAttUpd] Case 23 - {FS[OC]}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "TYPE" ValLst) (cdr (assoc "TYPE" ValLst)) " ")
					Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "TYPE" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
					Val02	(if (assoc "NUM" ValLst) (cdr (assoc "NUM" ValLst)) " ")
					Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "NUM" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
			)
		)
		((wcmatch (strcase (nth 0 NoLst)) "ARROW")
			(if Bug (princ "\n [BlkAttUpd] Case 23 - {ARROW}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "TYPE" ValLst) (cdr (assoc "TYPE" ValLst)) " ")
					Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "TYPE" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
			)
		)
		((or (wcmatch (strcase (nth 0 NoLst)) "FDR") (wcmatch (strcase (nth 0 NoLst)) "ARR_FDR"))
			(if Bug (princ "\n [BlkAttUpd] Case 23 - {FDR or ARR_FDR}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "FDR" ValLst) (cdr (assoc "FDR" ValLst)) " ")
					Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "FDR" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
			)
		)
		((or (wcmatch (strcase (nth 0 NoLst)) "KSC") (wcmatch (strcase (nth 0 NoLst)) "KSO"))
			(if Bug (princ "\n [BlkAttUpd] Case 23 - {KS[OC]}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "STOMP_ID" ValLst) (cdr (assoc "STOMP_ID" ValLst)) " ")
					Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "NUMBER" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
					Val02	(if (assoc "PLANT_ID" ValLst) (cdr (assoc "PLANT_ID" ValLst)) " ")
					Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "PLANT_ID" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
					Val03	(if (assoc "NUMBER" ValLst) (cdr (assoc "NUMBER" ValLst)) " ")
					Val03Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "STOMP_ID" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
			)
		)
		((wcmatch (strcase (nth 0 NoLst)) "SUB2")
			(if Bug (princ "\n [BlkAttUpd] Case 11 - {SUB2}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "SUBSTATION" ValLst) (cdr (assoc "SUBSTATION" ValLst)) " ")
					Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "SUBSTATION" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
					Val02	(if (assoc "RATING" ValLst) (cdr (assoc "RATING" ValLst)) " ")
					Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "RATING" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
			)
		)
		((wcmatch (strcase (nth 0 NoLst)) "SUBCUST")
			(if Bug (princ "\n [BlkAttUpd] Case 12 - {SUBCUST}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst))))
			(if (assoc "NAME" ValLst)
				(setq	Val01	(if (assoc "NAME" ValLst) (cdr (assoc "NAME" ValLst)) " ")
						Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "NAME" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
				)
				(if (assoc "SUBSTATION" ValLst)
					(setq	Val01	(if (assoc "SUBSTATION" ValLst) (cdr (assoc "SUBSTATION" ValLst)) " ")
							Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "SUBSTATION" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
					)
				)
			)
			(setq	Val02	(if (assoc "RATING" ValLst) (cdr (assoc "RATING" ValLst)) " ")
					Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "RATING" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
			)
		)
		((wcmatch (strcase (nth 0 NoLst)) "GETAWAY")
			(if Bug (princ "\n [BlkAttUpd] Case 13 - {GETAWAY}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "BREAKER" ValLst) (cdr (assoc "BREAKER" ValLst)) " ")
					Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "BREAKER" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
			)
		)
		((or (wcmatch (strcase (nth 0 NoLst)) "PAD") (wcmatch (strcase (nth 0 NoLst)) "PAD_END"))
			(if Bug (princ "\n [BlkAttUpd] Case 14 - {PAD}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "TX#" ValLst) (cdr (assoc "TX#" ValLst)) ".")
					Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "TX#" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
			)
		)
		((wcmatch (strcase (nth 0 NoLst)) "CAP")
			(if Bug (princ "\n [BlkAttUpd] Case 15 - {CAP}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst))))
			(cond
				((wcmatch (StpDot AppNam) "SUBTOOLS")
					(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst))))
					(if (and (assoc "SIZE" ValLst) (assoc "KVAR" ValLst))
						(setq	Val01	(if (assoc "SIZE" ValLst) (cdr (assoc "SIZE" ValLst)) " ")
								Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "SIZE" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
								Val02	(if (assoc "KVAR" ValLst) (cdr (assoc "KVAR" ValLst)) " ")
								Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "KVAR" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
						)
						(if (assoc "SIZE" ValLst)
							(setq	Val01	(if (assoc "SIZE" ValLst) (cdr (assoc "SIZE" ValLst)) " ")
									Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "SIZE" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
							)
							(if (assoc "KVAR" ValLst)
								(setq	Val01	(if (assoc "KVAR" ValLst) (cdr (assoc "KVAR" ValLst)) " ")
										Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "KVAR" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
								)
							)
						)
					)
				)
				((= (length ValLst) 2)
					(cond
						((isCKvar (cdr (nth 0 ValLst)))
							(setq	Val01	(cdr (nth 1 ValLst))
									Val02	(isCKvar (cdr (nth 0 ValLst)))
									Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 1 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 0 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Bubba	(if Bug (princ "\n {BlkAttUpd} Case [ 0 ]"))
							)
						)
						((isCKvar (cdr (nth 1 ValLst)))
							(setq	Val01	(cdr (nth 0 ValLst))
									Val02	(isCKvar (cdr (nth 1 ValLst)))
									Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 0 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 1 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Bubba	(if Bug (princ "\n {BlkAttUpd} Case [ 1 ]"))
							)
						)
						((and	(= (strlen (cdr (nth 0 ValLst))) 0)
								(> (strlen (cdr (nth 1 ValLst))) 0)
						 )
							(setq	Val01	(cdr (nth 1 ValLst))
									Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 1 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Bubba	(if Bug (princ "\n {BlkAttUpd} Case [ 1 Sole of 2]"))
							)
						)
						((and	(= (strlen (cdr (nth 1 ValLst))) 0)
								(> (strlen (cdr (nth 0 ValLst))) 0)
						 )
							(setq	Val01	(cdr (nth 0 ValLst))
									Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 0 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Bubba	(if Bug (princ "\n {BlkAttUpd} Case [ 0 Sole of 2]"))
							)
						)
						(T
							(setq	Val01	(cdr (nth 0 ValLst))
									Val02	(if (>= (strlen (cdr (nth 1 ValLst))) 2)
												(if (isCKvar (cdr (nth 1 ValLst)))
													(isCKvar (cdr (nth 1 ValLst)))
													(cdr (nth 1 ValLst))
												)
												" "
											)
									Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "CAPACITOR" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "KVAR" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Bubba	(if Bug (princ "\n {BlkAttUpd} Case [ T ]"))
							)
						)
					)
				)
				((>= (length ValLst) 3)
					(cond
						((and	(isCKvar (cdr (nth 0 ValLst)))
								(isCType (cdr (nth 1 ValLst)))
						 )
							(setq	Val01	(cdr (nth 2 ValLst))
									Val02	(strcat (isCKvar (cdr (nth 0 ValLst))) " " (isCType (cdr (nth 1 ValLst))))
									Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 2 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 0 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Bubba	(if Bug (princ "\n {BlkAttUpd} Case [ 0 1 ]"))
							)
						)
						((and	(isCKvar (cdr (nth 1 ValLst)))
								(isCType (cdr (nth 2 ValLst)))
						 )
							(setq	Val01	(cdr (nth 0 ValLst))
									Val02	(strcat (isCKvar (cdr (nth 1 ValLst))) " " (isCType (cdr (nth 2 ValLst))))
									Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 0 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 1 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Bubba	(if Bug (princ "\n {BlkAttUpd} Case [ 1 2 ]"))
							)
						)
						((and	(isCKvar (cdr (nth 2 ValLst)))
								(isCType (cdr (nth 0 ValLst)))
						 )
							(setq	Val01	(cdr (nth 1 ValLst))
									Val02	(strcat (isCKvar (cdr (nth 2 ValLst))) " " (isCType (cdr (nth 0 ValLst))))
									Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 1 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 2 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Bubba	(if Bug (princ "\n {BlkAttUpd} Case [ 2 0 ]"))
							)
						)
						((and	(isCKvar (cdr (nth 0 ValLst)))
								(isCType (cdr (nth 2 ValLst)))
						 )
							(setq	Val01	(cdr (nth 1 ValLst))
									Val02	(strcat (isCKvar (cdr (nth 0 ValLst))) " " (isCType (cdr (nth 2 ValLst))))
									Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 1 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 0 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Bubba	(if Bug (princ "\n {BlkAttUpd} Case [ 0 2 ]"))
							)
						)
						((and	(isCKvar (cdr (nth 1 ValLst)))
								(isCType (cdr (nth 0 ValLst)))
						 )
							(setq	Val01	(cdr (nth 2 ValLst))
									Val02	(strcat (isCKvar (cdr (nth 1 ValLst))) " " (isCType (cdr (nth 0 ValLst))))
									Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 2 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 1 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Bubba	(if Bug (princ "\n {BlkAttUpd} Case [ 1 0 ]"))
							)
						)
						((and	(isCKvar (cdr (nth 2 ValLst)))
								(isCType (cdr (nth 1 ValLst)))
						 )
							(setq	Val01	(cdr (nth 0 ValLst))
									Val02	(strcat (isCKvar (cdr (nth 2 ValLst))) " " (isCType (cdr (nth 1 ValLst))))
									Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 0 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 2 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Bubba	(if Bug (princ "\n {BlkAttUpd} Case [ 2 1 ]"))
							)
						)
						((and	(isCKvar (cdr (nth 1 ValLst)))
								(= (car (nth 2 ValLst)) "ID")
						 )
							(setq	Val01	(cdr (nth 0 ValLst))
									Val02	(isCKvar (cdr (nth 1 ValLst)))
									Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 0 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 1 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Bubba	(if Bug (princ "\n {BlkAttUpd} Case [ 1 plus ID]"))
							)
						)
						((and	(isCKvar (cdr (nth 0 ValLst)))
								(= (car (nth 2 ValLst)) "ID")
						 )
							(setq	Val01	(cdr (nth 1 ValLst))
									Val02	(isCKvar (cdr (nth 0 ValLst)))
									Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 1 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 0 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Bubba	(if Bug (princ "\n {BlkAttUpd} Case [ 0 plus ID]"))
							)
						)
						((and	(= (strlen (cdr (nth 0 ValLst))) 0)
								(= (strlen (cdr (nth 1 ValLst))) 0)
								(> (strlen (cdr (nth 2 ValLst))) 0)
						 )
							(setq	Val01	(cdr (nth 2 ValLst))
									Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 2 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Bubba	(if Bug (princ "\n {BlkAttUpd} Case [ 2 Sole of 3]"))
							)
						)
						((and	(= (strlen (cdr (nth 0 ValLst))) 0)
								(= (strlen (cdr (nth 2 ValLst))) 0)
								(> (strlen (cdr (nth 1 ValLst))) 0)
						 )
							(setq	Val01	(cdr (nth 1 ValLst))
									Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 1 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Bubba	(if Bug (princ "\n {BlkAttUpd} Case [ 1 Sole of 3]"))
							)
						)
						((and	(= (strlen (cdr (nth 1 ValLst))) 0)
								(= (strlen (cdr (nth 2 ValLst))) 0)
								(> (strlen (cdr (nth 0 ValLst))) 0)
						 )
							(setq	Val01	(cdr (nth 0 ValLst))
									Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 0 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Bubba	(if Bug (princ "\n {BlkAttUpd} Case [ 0 Sole of 3]"))
							)
						)
						(T
							(setq	Val01	(cdr (nth 0 ValLst))
									Val02	(if (> (length ValLst) 2)
												(if (and (>= (strlen (cdr (nth 1 ValLst))) 2) (<= (strlen (cdr (nth 2 ValLst))) 3))
													(if (isCKvar (cdr (nth 1 ValLst)))
														(strcat (isCKvar (cdr (nth 1 ValLst))) " " (cdr (nth 2 ValLst)))
														(strcat (cdr (nth 1 ValLst)) " " (cdr (nth 2 ValLst)))
													)
													(if (>= (strlen (cdr (nth 1 ValLst))) 2)
														(if (isCKvar (cdr (nth 1 ValLst)))
															(isCKvar (cdr (nth 1 ValLst)))
															(cdr (nth 1 ValLst))
														)
														(if (<= (strlen (cdr (nth 2 ValLst))) 3)
															(cdr (nth 2 ValLst))
															" "
														)
													)
												)
												(if (> (length ValLst) 1)
													(if (isCKvar (cdr (nth 1 ValLst)))
														(isCKvar (cdr (nth 1 ValLst)))
														(cdr (nth 1 ValLst))
													)
													" "
												)
											)
									Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "CAPACITOR" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "KVAR" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
									Bubba	(if Bug (princ "\n {BlkAttUpd} Case [ T ]"))
							)
						)
					)
				)
				(T
					(setq	Val01	(cdr (nth 0 ValLst))
							Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc (car (nth 0 ValLst)) ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
							Bubba	(if Bug (princ "\n {BlkAttUpd} Case [ T ]"))
					)
				)
			)
		)
		((or (wcmatch (strcase (nth 0 NoLst)) "_DA") (wcmatch (strcase (nth 0 NoLst)) "DA"))
			(if Bug (princ "\n [BlkAttUpd] Case 16 - {DA}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "NAME" ValLst) (cdr (assoc "NAME" ValLst)) " ")
					Val02	(if (assoc "SUBSTATION" ValLst) (cdr (assoc "SUBSTATION" ValLst)) " ")
					Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "NAME" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
					Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "SUBSTATION" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
			)
		)
		((or (wcmatch (strcase (nth 0 NoLst)) "BRKR_SUB") (wcmatch (strcase (nth 0 NoLst)) "KNIFESW") (wcmatch (strcase (nth 0 NoLst)) "TL"))
			(if Bug (princ "\n [BlkAttUpd] Case 17 - {BRKR_SUB}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "NUMBER" ValLst) (cdr (assoc "NUMBER" ValLst)) " ")
					Val02	" "
					Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "NUMBER" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
			)
		)
		((or (wcmatch (strcase (nth 0 NoLst)) "SMS") (wcmatch (strcase (nth 0 NoLst)) "_AUTOCON"))
			(if Bug (princ "\n [BlkAttUpd] Case 18 - {SMS}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "SWITCH" ValLst) (cdr (assoc "SWITCH" ValLst)) " ")
					Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "SWITCH" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
			)
			(if (wcmatch (strcase (nth 0 NoLst)) "SMS")
				(setq	Val02	(if (assoc "SM" ValLst) (cdr (assoc "SM" ValLst)) " ")
						Val03	(if (assoc "RTU" ValLst) (cdr (assoc "RTU" ValLst)) " ")
						Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "SM" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
						Val03Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "RTU" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
				)
			)
		)
		((or (wcmatch (strcase (nth 0 NoLst)) "REG") (wcmatch (strcase (nth 0 NoLst)) "REGA"))
			(if Bug (princ "\n [BlkAttUpd] Case 19 - {REG}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "AMPS" ValLst) (cdr (assoc "AMPS" ValLst)) " ")
					Val02	(if (assoc "TYPE" ValLst) (cdr (assoc "TYPE" ValLst)) " ")
			)
			(if (/= Val01 " ")
				(setq	Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "AMPS" ValLst) ValLst))) (cdr (nth 10 NoLst))))))))
			)
			(if (/= Val02 " ")
				(setq	Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "TYPE" ValLst) ValLst))) (cdr (nth 10 NoLst))))))))
			)
		)
		((wcmatch (strcase (nth 0 NoLst)) "STEPTRAN")
			(if Bug (princ "\n [BlkAttUpd] Case 20 - {STEPTRAN}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "TRAN_ID" ValLst) (cdr (assoc "TRAN_ID" ValLst)) " ")
					Val02	(if (assoc "TYPE" ValLst) (cdr (assoc "TYPE" ValLst)) " ")
					Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "TRAN_ID" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
					Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "TYPE" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
			)
		)
		((or (wcmatch (strcase (nth 0 NoLst)) "_SGEN") (wcmatch (strcase (nth 0 NoLst)) "SGEN"))
			(if Bug (princ "\n [BlkAttUpd] Case 21 - {DA}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "NUMBER" ValLst) (cdr (assoc "NUMBER" ValLst)) " ")
			)
		)
		((wcmatch (strcase (nth 0 NoLst)) "SENSOR")
			(if Bug (princ "\n [BlkAttUpd] Case 22 - {SENSOR}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "RTU" ValLst) (cdr (assoc "RTU" ValLst)) " ")
					Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "RTU" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
			)
		)
		((or (wcmatch (strcase (nth 0 NoLst)) "PM") (wcmatch (strcase (nth 0 NoLst)) "PM_END"))
			(if Bug (princ "\n [BlkAttUpd] Case 23 - {PM}\n"))
			(setq	ValLst	(mapcar (quote (lambda (x) (cons (nth 0 x) (nth 1 x)))) (cdr (nth 10 NoLst)))
					Val01	(if (assoc "CUST-NAME" ValLst) (cdr (assoc "CUST-NAME" ValLst)) " ")
					Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 (nth (- (length ValLst) (length (member (assoc "CUST-NAME" ValLst) ValLst))) (cdr (nth 10 NoLst)))))))
			)
		)
		((and (member (nth 0 NoLst) (list "CR" "CS" "CS2" "DR" "DS" "DS2" "GR" "GS" "GS2")) (> (distance (nth 5 (nth 1 (nth 10 NoLst))) Pnt1) (/ Gap 3.0)))
			(if Bug (princ "\n [BlkAttUpd] Case 24 - {Switch not in center}\n"))
			;For Switch Attributes that are not in the exact center of the Gap
			(setq	Cntr		0)
			(foreach	ValLst
					(cdr (nth 10 NoLst))
					(cond
						((and (= Cntr 0) (= (nth 10 ValLst) 0))
							(setq	Val01	(nth 1 ValLst)
									Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 1) (= (nth 10 ValLst) 0))
							(setq	Val02	(nth 1 ValLst)
									Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 2) (= (nth 10 ValLst) 0))
							(setq	Val03	(nth 1 ValLst)
									Val03Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 3) (= (nth 10 ValLst) 0))
							(setq	Val04	(nth 1 ValLst)
									Val04Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 4) (= (nth 10 ValLst) 0))
							(setq	Val05	(nth 1 ValLst)
									Val05Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 5) (= (nth 10 ValLst) 0))
							(setq	Val06	(nth 1 ValLst)
									Val06Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 6) (= (nth 10 ValLst) 0))
							(setq	Val07	(nth 1 ValLst)
									Val07Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 7) (= (nth 10 ValLst) 0))
							(setq	Val08	(nth 1 ValLst)
									Val08Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 8) (= (nth 10 ValLst) 0))
							(setq	Val09	(nth 1 ValLst)
									Val09Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 9) (= (nth 10 ValLst) 0))
							(setq	Val10	(nth 1 ValLst)
									Val10Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 10) (= (nth 10 ValLst) 0))
							(setq	Val11	(nth 1 ValLst)
									Val11Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
					)
			)
		)
		((member (nth 0 NoLst) (list "CR" "CS" "CS2" "DR" "DS" "DS2" "GR" "GS" "GS2" "UNO_PAD" "NO_TRF" "UGOPEN"))
			(if Bug (princ "\n [BlkAttUpd] Case 25 - {Switch in center}\n"))
			;For Switch Attributes that are in the exact center of the Gap, or devices that do not have the same Att positions
			(setq	Cntr		0)
			(foreach	ValLst
					(cdr (nth 10 NoLst))
					(cond
						((and (= Cntr 0) (= (nth 10 ValLst) 0))
							(setq	Val01	(nth 1 ValLst)
									;Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 1) (= (nth 10 ValLst) 0))
							(setq	Val02	(nth 1 ValLst)
									Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 2) (= (nth 10 ValLst) 0))
							(setq	Val03	(nth 1 ValLst)
									Val03Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 3) (= (nth 10 ValLst) 0))
							(setq	Val04	(nth 1 ValLst)
									Val04Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 4) (= (nth 10 ValLst) 0))
							(setq	Val05	(nth 1 ValLst)
									Val05Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 5) (= (nth 10 ValLst) 0))
							(setq	Val06	(nth 1 ValLst)
									Val06Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 6) (= (nth 10 ValLst) 0))
							(setq	Val07	(nth 1 ValLst)
									Val07Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 7) (= (nth 10 ValLst) 0))
							(setq	Val08	(nth 1 ValLst)
									Val08Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 8) (= (nth 10 ValLst) 0))
							(setq	Val09	(nth 1 ValLst)
									Val09Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 9) (= (nth 10 ValLst) 0))
							(setq	Val10	(nth 1 ValLst)
									Val10Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 10) (= (nth 10 ValLst) 0))
							(setq	Val11	(nth 1 ValLst)
									Val11Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
					)
			)
		)
		(T	;(not (member (nth 0 NoLst) (list "CR" "CS" "CS2" "DR" "DS" "DS2" "GR" "GS" "GS2" "UNO_PAD" "NO_TRF" "UGOPEN")))
			(if Bug (princ "\n [BlkAttUpd] Case 26 - {Other Switches}\n"))
			(setq	Cntr		0)
			(foreach	ValLst
					(cdr (nth 10 NoLst))
					(cond
						((and (= Cntr 0) (= (nth 10 ValLst) 0))
							(setq	Val01	(nth 1 ValLst)
									Val01Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 1) (= (nth 10 ValLst) 0))
							(setq	Val02	(nth 1 ValLst)
									Val02Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 2) (= (nth 10 ValLst) 0))
							(setq	Val03	(nth 1 ValLst)
									Val03Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 3) (= (nth 10 ValLst) 0))
							(setq	Val04	(nth 1 ValLst)
									Val04Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 4) (= (nth 10 ValLst) 0))
							(setq	Val05	(nth 1 ValLst)
									Val05Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 5) (= (nth 10 ValLst) 0))
							(setq	Val06	(nth 1 ValLst)
									Val06Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 6) (= (nth 10 ValLst) 0))
							(setq	Val07	(nth 1 ValLst)
									Val07Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 7) (= (nth 10 ValLst) 0))
							(setq	Val08	(nth 1 ValLst)
									Val08Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 8) (= (nth 10 ValLst) 0))
							(setq	Val09	(nth 1 ValLst)
									Val09Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 9) (= (nth 10 ValLst) 0))
							(setq	Val10	(nth 1 ValLst)
									Val10Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
						((and (= Cntr 10) (= (nth 10 ValLst) 0))
							(setq	Val11	(nth 1 ValLst)
									Val11Box	(AttBox Ang0 Dst0 (entget (handent (nth 2 ValLst))))
									Cntr		(1+ Cntr)
							)
						)
					)
			)
		)
	)
	(if Att1
		(if (and Val01 Val01Box)
			(setq	Att1		(subst (cons 1 Val01) (assoc 1 Att1) Att1)
					Att1		(subst (cons 8 AttLay) (assoc 8 Att1) Att1)
					Att1		(subst (cons 7 AttSty) (assoc 7 Att1) Att1)
					Att1		(AttValAdj Val01Box Att1)
					Att1		(if (assoc 62 Att1)
								(subst (cons 62 256) (assoc 62 Att1) Att1)
								(append Att1 (list (cons 62 256)))
							)
					Bubba	(entmod Att1)
			)
			(if Val01
				(setq	Att1		(subst (cons 1 Val01) (assoc 1 Att1) Att1)
						Att1		(subst (cons 8 AttLay) (assoc 8 Att1) Att1)
						Att1		(subst (cons 7 AttSty) (assoc 7 Att1) Att1)
						Att1		(if (assoc 62 Att1)
									(subst (cons 62 256) (assoc 62 Att1) Att1)
									(append Att1 (list (cons 62 256)))
								)
						Bubba	(entmod Att1)
				)
			)
		)
	)
	(if Att2
		(if (and Val02 Val02Box)
			(setq	Att2		(subst (cons 1 Val02) (assoc 1 Att2) Att2)
					Att2		(subst (cons 8 AttLay) (assoc 8 Att2) Att2)
					Att2		(subst (cons 7 AttSty) (assoc 7 Att2) Att2)
					Att2		(AttValAdj Val02Box Att2)
					Att2		(if (assoc 62 Att2)
								(subst (cons 62 256) (assoc 62 Att2) Att2)
								(append Att2 (list (cons 62 256)))
							)
					Bubba	(entmod Att2)
			)
			(if Val02
				(setq	Att2		(subst (cons 1 Val02) (assoc 1 Att2) Att2)
						Att2		(subst (cons 8 AttLay) (assoc 8 Att2) Att2)
						Att2		(subst (cons 7 AttSty) (assoc 7 Att2) Att2)
						Att2		(if (assoc 62 Att2)
									(subst (cons 62 256) (assoc 62 Att2) Att2)
									(append Att2 (list (cons 62 256)))
								)
						Bubba	(entmod Att2)
				)
			)
		)
	)
	(if Att2
		(if (/= (cdr (assoc 0 Att2)) "SEQEND")
			(if (/= (cdr (assoc 0 (entget (entnext (cdr (assoc -1 Att2)))))) "SEQEND")
				(setq	Att3		(entget (entnext (cdr (assoc -1 Att2)))))
			)
		)
	)
	(if Att3
		(if (and Val03 Val03Box)
			(setq	Att3		(subst (cons 1 Val03) (assoc 1 Att3) Att3)
					Att3		(subst (cons 8 AttLay) (assoc 8 Att3) Att3)
					Att3		(subst (cons 7 AttSty) (assoc 7 Att3) Att3)
					Att3		(AttValAdj Val03Box Att3)
					Att3		(if (assoc 62 Att3)
								(subst (cons 62 256) (assoc 62 Att3) Att3)
								(append Att3 (list (cons 62 256)))
							)
					Bubba	(entmod Att3)
			)
			(if Val03
				(setq	Att3		(subst (cons 1 Val03) (assoc 1 Att3) Att3)
						Att3		(subst (cons 8 AttLay) (assoc 8 Att3) Att3)
						Att3		(subst (cons 7 AttSty) (assoc 7 Att3) Att3)
						Att3		(if (assoc 62 Att3)
									(subst (cons 62 256) (assoc 62 Att3) Att3)
									(append Att3 (list (cons 62 256)))
								)
						Bubba	(entmod Att3)
				)
			)
		)
	)
	(if Att3
		(if (/= (cdr (assoc 0 (entget (entnext (cdr (assoc -1 Att3)))))) "SEQEND")
			(setq	Att4		(entget (entnext (cdr (assoc -1 Att3)))))
		)
	)
	(if Att4
		(if (and Val04 Val04Box)
			(setq	Att4		(subst (cons 1 Val04) (assoc 1 Att4) Att4)
					Att4		(subst (cons 8 AttLay) (assoc 8 Att4) Att4)
					Att4		(subst (cons 7 AttSty) (assoc 7 Att4) Att4)
					Att4		(AttValAdj Val04Box Att4)
					Att4		(if (assoc 62 Att4)
								(subst (cons 62 256) (assoc 62 Att4) Att4)
								(append Att4 (list (cons 62 256)))
							)
					Bubba	(entmod Att4)
			)
			(if Val04
				(setq	Att4		(subst (cons 1 Val04) (assoc 1 Att4) Att4)
						Att4		(subst (cons 8 AttLay) (assoc 8 Att4) Att4)
						Att4		(subst (cons 7 AttSty) (assoc 7 Att4) Att4)
						Att4		(if (assoc 62 Att4)
									(subst (cons 62 256) (assoc 62 Att4) Att4)
									(append Att4 (list (cons 62 256)))
								)
						Bubba	(entmod Att4)
				)
			)
		)
	)
	(if Att4
		(if (/= (cdr (assoc 0 (entget (entnext (cdr (assoc -1 Att4)))))) "SEQEND")
			(setq	Att5		(entget (entnext (cdr (assoc -1 Att4)))))
		)
	)
	(if Att5
		(if (and Val05 Val05Box)
			(setq	Att5		(subst (cons 1 Val05) (assoc 1 Att5) Att5)
					Att5		(subst (cons 8 AttLay) (assoc 8 Att5) Att5)
					Att5		(subst (cons 7 AttSty) (assoc 7 Att5) Att5)
					Att5		(AttValAdj Val05Box Att5)
					Att5		(if (assoc 62 Att5)
								(subst (cons 62 256) (assoc 62 Att5) Att5)
								(append Att5 (list (cons 62 256)))
							)
					Bubba	(entmod Att5)
			)
			(if Val05
				(setq	Att5		(subst (cons 1 Val05) (assoc 1 Att5) Att5)
						Att5		(subst (cons 8 AttLay) (assoc 8 Att5) Att5)
						Att5		(subst (cons 7 AttSty) (assoc 7 Att5) Att5)
						Att5		(if (assoc 62 Att5)
									(subst (cons 62 256) (assoc 62 Att5) Att5)
									(append Att5 (list (cons 62 256)))
								)
						Bubba	(entmod Att5)
				)
			)
		)
	)
	(if Att5
		(if (/= (cdr (assoc 0 (entget (entnext (cdr (assoc -1 Att5)))))) "SEQEND")
			(setq	Att6		(entget (entnext (cdr (assoc -1 Att5)))))
		)
	)
	(if Att6
		(if (and Val06 Val06Box)
			(setq	Att6		(subst (cons 1 Val06) (assoc 1 Att6) Att6)
					Att6		(subst (cons 8 AttLay) (assoc 8 Att6) Att6)
					Att6		(subst (cons 7 AttSty) (assoc 7 Att6) Att6)
					Att6		(AttValAdj Val06Box Att6)
					Att6		(if (assoc 62 Att6)
								(subst (cons 62 256) (assoc 62 Att6) Att6)
								(append Att6 (list (cons 62 256)))
							)
					Bubba	(entmod Att6)
			)
			(if Val06
				(setq	Att6		(subst (cons 1 Val06) (assoc 1 Att6) Att6)
						Att6		(subst (cons 8 AttLay) (assoc 8 Att6) Att6)
						Att6		(subst (cons 7 AttSty) (assoc 7 Att6) Att6)
						Att6		(if (assoc 62 Att6)
									(subst (cons 62 256) (assoc 62 Att6) Att6)
									(append Att6 (list (cons 62 256)))
								)
						Bubba	(entmod Att6)
				)
			)
		)
	)
	(if Att6
		(if (/= (cdr (assoc 0 (entget (entnext (cdr (assoc -1 Att6)))))) "SEQEND")
			(setq	Att7		(entget (entnext (cdr (assoc -1 Att6)))))
		)
	)
	(if Att7
		(if (and Val07 Val07Box)
			(setq	Att7		(subst (cons 1 Val07) (assoc 1 Att7) Att7)
					Att7		(subst (cons 8 AttLay) (assoc 8 Att7) Att7)
					Att7		(subst (cons 7 AttSty) (assoc 7 Att7) Att7)
					Att7		(AttValAdj Val07Box Att7)
					Att7		(if (assoc 62 Att7)
								(subst (cons 62 256) (assoc 62 Att7) Att7)
								(append Att7 (list (cons 62 256)))
							)
					Bubba	(entmod Att7)
			)
			(if Val07
				(setq	Att7		(subst (cons 1 Val07) (assoc 1 Att7) Att7)
						Att7		(subst (cons 8 AttLay) (assoc 8 Att7) Att7)
						Att7		(subst (cons 7 AttSty) (assoc 7 Att7) Att7)
						Att7		(if (assoc 62 Att7)
									(subst (cons 62 256) (assoc 62 Att7) Att7)
									(append Att7 (list (cons 62 256)))
								)
						Bubba	(entmod Att7)
				)
			)
		)
	)
	(if Att7
		(if (/= (cdr (assoc 0 (entget (entnext (cdr (assoc -1 Att7)))))) "SEQEND")
			(setq	Att8		(entget (entnext (cdr (assoc -1 Att7)))))
		)
	)
	(if Att8
		(if (and Val08 Val08Box)
			(setq	Att8		(subst (cons 1 Val08) (assoc 1 Att8) Att8)
					Att8		(subst (cons 8 AttLay) (assoc 8 Att8) Att8)
					Att8		(subst (cons 7 AttSty) (assoc 7 Att8) Att8)
					Att8		(AttValAdj Val08Box Att8)
					Att8		(if (assoc 62 Att8)
								(subst (cons 62 256) (assoc 62 Att8) Att8)
								(append Att8 (list (cons 62 256)))
							)
					Bubba	(entmod Att8)
			)
			(if Val08
				(setq	Att8		(subst (cons 1 Val08) (assoc 1 Att8) Att8)
						Att8		(subst (cons 8 AttLay) (assoc 8 Att8) Att8)
						Att8		(subst (cons 7 AttSty) (assoc 7 Att8) Att8)
						Att8		(if (assoc 62 Att8)
									(subst (cons 62 256) (assoc 62 Att8) Att8)
									(append Att8 (list (cons 62 256)))
								)
						Bubba	(entmod Att8)
				)
			)
		)
	)
	(if Att8
		(if (/= (cdr (assoc 0 (entget (entnext (cdr (assoc -1 Att8)))))) "SEQEND")
			(setq	Att9		(entget (entnext (cdr (assoc -1 Att8)))))
		)
	)
	(if Att9
		(if (and Val09 Val09Box)
			(setq	Att9		(subst (cons 1 Val09) (assoc 1 Att9) Att9)
					Att9		(subst (cons 8 AttLay) (assoc 8 Att9) Att9)
					Att9		(subst (cons 7 AttSty) (assoc 7 Att9) Att9)
					Att9		(AttValAdj Val09Box Att9)
					Att9		(if (assoc 62 Att9)
								(subst (cons 62 256) (assoc 62 Att9) Att9)
								(append Att9 (list (cons 62 256)))
							)
					Bubba	(entmod Att9)
			)
			(if Val09
				(setq	Att9		(subst (cons 1 Val09) (assoc 1 Att9) Att9)
						Att9		(subst (cons 8 AttLay) (assoc 8 Att9) Att9)
						Att9		(subst (cons 7 AttSty) (assoc 7 Att9) Att9)
						Att9		(if (assoc 62 Att9)
									(subst (cons 62 256) (assoc 62 Att9) Att9)
									(append Att9 (list (cons 62 256)))
								)
						Bubba	(entmod Att9)
				)
			)
		)
	)
	(if Att9
		(if (/= (cdr (assoc 0 (entget (entnext (cdr (assoc -1 Att9)))))) "SEQEND")
			(setq	Att10	(entget (entnext (cdr (assoc -1 Att9)))))
		)
	)
	(if Att10
		(if (and Val10 Val10Box)
			(setq	Att10		(subst (cons 1 Val10) (assoc 1 Att10) Att10)
					Att10		(subst (cons 8 AttLay) (assoc 8 Att10) Att10)
					Att10		(subst (cons 7 AttSty) (assoc 7 Att10) Att10)
					Att10		(AttValAdj Val10Box Att10)
					Att10		(if (assoc 62 Att10)
								(subst (cons 62 256) (assoc 62 Att10) Att10)
								(append Att10 (list (cons 62 256)))
							)
					Bubba	(entmod Att10)
			)
			(if Val10
				(setq	Att10		(subst (cons 1 Val10) (assoc 1 Att10) Att10)
						Att10		(subst (cons 8 AttLay) (assoc 8 Att10) Att10)
						Att10		(subst (cons 7 AttSty) (assoc 7 Att10) Att10)
						Att10		(if (assoc 62 Att10)
									(subst (cons 62 256) (assoc 62 Att10) Att10)
									(append Att10 (list (cons 62 256)))
								)
						Bubba	(entmod Att10)
				)
			)
		)
	)
	(if Att10
		(if (/= (cdr (assoc 0 (entget (entnext (cdr (assoc -1 Att10)))))) "SEQEND")
			(setq	Att11	(entget (entnext (cdr (assoc -1 Att10)))))
		)
	)
	(if Att11
		(if (and Val11 Val11Box)
			(setq	Att11		(subst (cons 1 Val11) (assoc 1 Att11) Att11)
					Att11		(subst (cons 8 AttLay) (assoc 8 Att11) Att11)
					Att11		(subst (cons 7 AttSty) (assoc 7 Att11) Att11)
					Att11		(AttValAdj Val11Box Att11)
					Att11		(if (assoc 62 Att11)
								(subst (cons 62 256) (assoc 62 Att11) Att11)
								(append Att11 (list (cons 62 256)))
							)
					Bubba	(entmod Att11)
			)
			(if Val11
				(setq	Att11		(subst (cons 1 Val11) (assoc 1 Att11) Att11)
						Att11		(subst (cons 8 AttLay) (assoc 8 Att11) Att11)
						Att11		(subst (cons 7 AttSty) (assoc 7 Att11) Att11)
						Att11		(if (assoc 62 Att11)
									(subst (cons 62 256) (assoc 62 Att11) Att11)
									(append Att11 (list (cons 62 256)))
								)
						Bubba	(entmod Att11)
				)
			)
		)
	)
	(if (= (car (last NoLst)) "XData")
		(setq	XLst		(mapcar (quote (lambda (XNam) (cons (car XNam) (list (cons 1000 (cdr XNam)))))) (cdr (last NoLst))))
		(setq	XLst		nil)
	)
	(if XLst
		(setq	XLst		(cons -3 XLst)
				EDat		(entget Ent1)
				EDat		(append EDat (list XLst))
				Bubba	(entmod EDat)
		)
	)
	(entupd Ent1)
)

(defun BlkXdatUpd ( NoLst /	EDat Ent1			; Updates associated XData
						XLst XNam )
	(setq	EDat		(entget (entlast))
			Ent1		(cdr (assoc -1 EDat))
	)
	(if (= (car (last NoLst)) "XData")
		(setq	XLst		(mapcar (quote (lambda (XNam) (cons (car XNam) (list (cons 1000 (cdr XNam)))))) (cdr (last NoLst))))
		(setq	XLst		nil)
	)
	(if XLst
		(setq	XLst		(cons -3 XLst)
				EDat		(append EDat (list XLst))
				Bubba	(entmod EDat)
		)
	)
	(entupd Ent1)
)

(defun GetPnScl ( BlkLay NoLst PnScl /	SclVal )	; Returns Panel Scale (rigorous)
	(if Bug (princ "\n{GetPnScl entered\n"))
	(cond
		((and BlkLay NoLst PnScl)
			(cond
				((> (nth 3 BlkLay) 5.0)
					(setq	SclVal	(nth 3 BlkLay))
				)
				((= (nth 9 NoLst) 1)
					(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
						(setq	SclVal	(nth 6 (nth 1 (nth 10 NoLst))))
						(if (/= (GetPS (nth 3 NoLst)) "0")
							(setq	SclVal	(atof (GetPS (nth 3 NoLst))))
							(setq	SclVal	PnScl)
						)
					)
				)
			)
		)
		((and NoLst PnScl)
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	SclVal	(nth 6 (nth 1 (nth 10 NoLst))))
					(if (/= (GetPS (nth 3 NoLst)) "0")
						(setq	SclVal	(atof (GetPS (nth 3 NoLst))))
						(setq	SclVal	PnScl)
					)
				)
				(setq	SclVal	PnScl)
			)
		)
		(PnScl
			(setq	SclVal	PnScl)
		)
		(T
			(setq	SclVal	1.0)
		)
	)
	(if Bug (princ "\nGetPnScl exited}\n"))
	SclVal
)

(defun GetNOLayEnd ( BlkLay PnScl /	LayVal	; Finds other Layer name for NO devices, if different
								OthLay SrchWid pt1 pt2 ssE Cntr )
	(setq	OthLay	(substr (nth 4 BlkLay) 1 3)
			SrchWid	0.0125
			LayVal	nil
	)
	(if (wcmatch (nth 5 BlkLay) "NotFound{0}")
		(setq	Bub	(if Bug (princ "\n{Bug} NotFound in 5th element\n"))
				pt1	(nth 1 BlkLay)
				pt2	(polar pt1 (/ pi 4.0) (* PnScl SrchWid))
				pt1	(polar pt1 (+ pi (/ pi 4.0)) (* PnScl SrchWid))
				ssE	(ssget	"C"
							pt1
							pt2
							(list	(cons 0 "*POLYLINE")
									(cons 8 "????CK-*")
							)
					)
		)
		(if (wcmatch (nth 6 BlkLay) "NotFound{0}")
			(setq	Bub	(if Bug (princ "\n{Bug} NotFound in 6th element\n"))
					pt1	(nth 2 BlkLay)
					pt2	(polar pt1 (/ pi 4.0) (* PnScl SrchWid))
					pt1	(polar pt1 (+ pi (/ pi 4.0)) (* PnScl SrchWid))
					ssE	(ssget	"C"
								pt1
								pt2
								(list	(cons 0 "*POLYLINE")
										(cons 8 "????CK-*")
								)
						)
			)
		)
	)
	(if (and Bug pt1 pt2)
		(progn
			(princ "\n{Bug} Drawing test box...\n")
			(grdraw (list (car pt1) (cadr pt1)) (list (car pt2) (cadr pt1)) -1 1)
			(grdraw (list (car pt2) (cadr pt1)) (list (car pt2) (cadr pt2)) -1 1)
			(grdraw (list (car pt2) (cadr pt2)) (list (car pt1) (cadr pt2)) -1 1)
			(grdraw (list (car pt1) (cadr pt2)) (list (car pt1) (cadr pt1)) -1 1)
		)
	)
	(if ssE
		(cond
			((= (sslength ssE) 1)
				(setq	LayVal	(cdr (assoc 8 (entget (ssname ssE 0)))))
			)
			((> (sslength ssE) 1)
				(setq	Cntr		0)
				(while (< Cntr (sslength ssE))
					(if (not LayVal)
						(if (not (= (strcase OthLay) (strcase (substr (cdr (assoc 8 (entget (ssname ssE Cntr)))) 1 3))))
							(setq	LayVal	(strcase (substr (cdr (assoc 8 (entget (ssname ssE Cntr)))) 1 3)))
						)
					)
					(setq	Cntr	(1+ Cntr))
				)
			)
		)
		(setq	LayVal	OthLay)
	)
	(cond
		((> (strlen LayVal) 3)
			(setq	LayVal	(substr LayVal 1 3))
		)
		((= (strlen LayVal) 2)
			(setq	LayVal	(strcat LayVal "_"))
		)
		((= (strlen LayVal) 1)
			(setq	LayVal	(strcat LayVal "__"))
		)
	)
	(if (= (strcase LayVal) (strcase OthLay))
		(setq	LayVal	(nth 4 BlkLay))
		(setq	LayVal	(strcat (nth 4 BlkLay) LayVal))
	)
)

(defun InsRep ( NoLst /	BlkLay BlkNam			; Internal Insert Replacement Routine
					Gap Dst1 Ang1 Pnt1 Ang2 Dst2 Pnt2 NoCnt NoNoCnt )
	(setq	BlkLay	(BlkLayEnd (nth 1 NoLst)))
	(if NoShwLst
		(setq	NoShwHnd		(mapcar (quote cadr) NoShwLst)
				NoNoShwHnd	(mapcar (quote car) NoShwLst)
		)
	)
	(setq	PnScl	(GetPnScl BlkLay NoLst PnScl))
	(command "_.Layer" "T" (nth 2 NoLst) "")
	(setvar "CLAYER" (nth 2 NoLst))
;;;	"ACC"			;SubTools	(Explode)		Complete
;;;	"ARR_FDR"			;SubTools A130 <-> 3830	Complete
;;;	"ARROW"			;SubTools A137 <-> 3837	Complete
;;;	"BKRC"			;SubTools A164 <-> 3864	Complete
;;;	"BKRO"			;SubTools A181 <-> 3881	Complete
;;;	"BRKR_SUB"		;SubTools A181 <-> 3881
;;;	"FDR"			;SubTools A130 <-> 3830	Complete
;;;	"FSC"			;SubTools A125 <-> 3825	Complete
;;;	"FSO"			;SubTools A170 <-> 3870	Complete
;;;	"FUSE"			;SubTools A131 <-> 3831	Complete
;;;	"GROUND"			;SubTools A132 <-> 3832	Complete
;;;	"GSC"			;SubTools A126 <-> 3826	Complete
;;;	"GSO"			;SubTools A173 <-> 3873	Complete
;;;	"KNIFESW"			;SubTools A124 <-> 3824	Complete
;;;	"LA"				;SubTools A134 <-> 3834
;;;	"LTC"			;SubTools A133 <-> 3833
;;;	"MODC"			;SubTools A196 <-> 3896
;;;	"MODO"			;SubTools A197 <-> 3897
;;;	"POT"			;SubTools A135 <-> 3835
;;;	"QUANTUM"			;SubTools A073 <-> 3773
;;;	"RACK_NC"			;SubTools A070 <-> 3770
;;;	"RACK_NO"			;SubTools A068 <-> 3768
;;;	"RACK_RO"			;SubTools A069 <-> 3769
;;;	"SWC"			;SubTools A124 <-> 3824	Complete
;;;	"SWO"			;SubTools A172 <-> 3872	Complete
;;;	"TL"				;SubTools A071 <-> 3771
	(cond
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "LTC")	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "LTC")) 0.3048) 0.381))
					(setq	Gap		(* (* PnScl (nth 1 (SymSizN "LTC")) 0.3048) 0.381))
				)
				(setq	Gap		(* (* PnScl (nth 1 (SymSizN "LTC")) 0.3048) 0.381))
			)
			(setq	BlkNam	(strcat _Path-Sym "A133")
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(polar (nth 3 NoLst) (/ (* pi 3.0) 2.0) (/ Gap 2.0))
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "LA")	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "LA")) 0.3048))
					(setq	Gap		(* PnScl (nth 1 (SymSizN "LA")) 0.3048))
				)
				(setq	Gap		(* PnScl (nth 1 (SymSizN "LA")) 0.3048))
			)
			(setq	BlkNam	(strcat _Path-Sym "A134")
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "RACK_NO")	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "RACK_NO")) 0.3048))
					(setq	Gap		(* PnScl (nth 1 (SymSizN "RACK_NO")) 0.3048))
				)
				(setq	Gap		(* PnScl (nth 1 (SymSizN "RACK_NO")) 0.3048))
			)
			(setq	BlkNam	(strcat _Path-Sym "A068")
					Gap		(* Gap 0.5)
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "RACK_RO")	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "RACK_RO")) 0.3048))
					(setq	Gap		(* PnScl (nth 1 (SymSizN "RACK_RO")) 0.3048))
				)
				(setq	Gap		(* PnScl (nth 1 (SymSizN "RACK_RO")) 0.3048))
			)
			(setq	BlkNam	(strcat _Path-Sym "A069")
					Gap		(* Gap 0.5)
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "RACK_NC")	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "RACK_NC")) 0.3048))
					(setq	Gap		(* PnScl (nth 1 (SymSizN "RACK_NC")) 0.3048))
				)
				(setq	Gap		(* PnScl (nth 1 (SymSizN "RACK_NC")) 0.3048))
			)
			(setq	BlkNam	(strcat _Path-Sym "A070")
					Gap		(* Gap 0.5)
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "QUANTUM")	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "QUANTUM")) 0.3048))
					(setq	Gap		(* PnScl (nth 1 (SymSizN "QUANTUM")) 0.3048))
				)
				(setq	Gap		(* PnScl (nth 1 (SymSizN "QUANTUM")) 0.3048))
			)
			(setq	BlkNam	(strcat _Path-Sym "A073")
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "TL")	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "TL")) 0.3048))
					(setq	Gap		(* PnScl (nth 1 (SymSizN "TL")) 0.3048))
				)
				(setq	Gap		(* PnScl (nth 1 (SymSizN "TL")) 0.3048))
			)
			(setq	BlkNam	(strcat _Path-Sym "A071")
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "MODO")	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "MODO")) 0.3048))
					(setq	Gap		(* PnScl (nth 1 (SymSizN "MODO")) 0.3048))
				)
				(setq	Gap		(* PnScl (nth 1 (SymSizN "MODO")) 0.3048))
			)
			(setq	BlkNam	(strcat _Path-Sym "A197")
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "MODC")	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "MODC")) 0.3048))
					(setq	Gap		(* PnScl (nth 1 (SymSizN "MODC")) 0.3048))
				)
				(setq	Gap		(* PnScl (nth 1 (SymSizN "MODC")) 0.3048))
			)
			(setq	BlkNam	(strcat _Path-Sym "A196")
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "POT")	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "POT")) 0.3048))
					(setq	Gap		(* PnScl (nth 1 (SymSizN "POT")) 0.3048))
				)
				(setq	Gap		(* PnScl (nth 1 (SymSizN "POT")) 0.3048))
			)
			(setq	BlkNam	(strcat _Path-Sym "A135")
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "SWO")	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "SWO")) 0.3048))
					(setq	Gap		(* PnScl (nth 1 (SymSizN "SWO")) 0.3048))
				)
				(setq	Gap		(* PnScl (nth 1 (SymSizN "SWO")) 0.3048))
			)
			(setq	BlkNam	(strcat _Path-Sym "A172")
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((or (= (car NoLst) "KNIFESW") (= (car NoLst) "SWC"))	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "SWC")) 0.3048))
					(setq	Gap		(* PnScl (nth 1 (SymSizN "SWC")) 0.3048))
				)
				(setq	Gap		(* PnScl (nth 1 (SymSizN "SWC")) 0.3048))
			)
			(setq	BlkNam	(strcat _Path-Sym "A124")
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "GSC")	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "GSC")) 0.3048))
					(setq	Gap		(* PnScl (nth 1 (SymSizN "GSC")) 0.3048))
				)
				(setq	Gap		(* PnScl (nth 1 (SymSizN "GSC")) 0.3048))
			)
			(setq	BlkNam	(strcat _Path-Sym "A126")
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "GSO")	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "GSO")) 0.3048))
					(setq	Gap		(* PnScl (nth 1 (SymSizN "GSO")) 0.3048))
				)
				(setq	Gap		(* PnScl (nth 1 (SymSizN "GSO")) 0.3048))
			)
			(setq	BlkNam	(strcat _Path-Sym "A173")
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "GROUND")	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "GROUND")) 0.3048))
					(setq	Gap		(* PnScl (nth 1 (SymSizN "GROUND")) 0.3048))
				)
				(setq	Gap		(* PnScl (nth 1 (SymSizN "GROUND")) 0.3048))
			)
			(setq	BlkNam	(strcat _Path-Sym "A132")
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "FUSE")	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "FUSE")) 0.3048))
					(setq	Gap		(* PnScl (nth 1 (SymSizN "FUSE")) 0.3048))
				)
				(setq	Gap		(* PnScl (nth 1 (SymSizN "FUSE")) 0.3048))
			)
			(setq	BlkNam	(strcat _Path-Sym "A131")
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "FSC")	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "FSC")) 0.3048))
					(setq	Gap		(* PnScl (nth 1 (SymSizN "FSC")) 0.3048))
				)
				(setq	Gap		(* PnScl (nth 1 (SymSizN "FSC")) 0.3048))
			)
			(setq	BlkNam	(strcat _Path-Sym "A125")
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "FSO")	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "FSO")) 0.3048))
					(setq	Gap		(* PnScl (nth 1 (SymSizN "FSO")) 0.3048))
				)
				(setq	Gap		(* PnScl (nth 1 (SymSizN "FSO")) 0.3048))
			)
			(setq	BlkNam	(strcat _Path-Sym "A170")
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "ARROW")	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "ARROW")) 0.3048))
					(setq	Gap		(* PnScl (nth 1 (SymSizN "ARROW")) 0.3048))
				)
				(setq	Gap		(* PnScl (nth 1 (SymSizN "ARROW")) 0.3048))
			)
			(setq	BlkNam	(strcat _Path-Sym "A137")
					NoCnt	nil
					Gap		(* Gap 0.5)
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((or (= (car NoLst) "ARR_FDR") (= (car NoLst) "FDR"))	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "ARR_FDR")) 0.3048))
					(setq	Gap		(* PnScl (nth 1 (SymSizN "ARR_FDR")) 0.3048))
				)
				(setq	Gap		(* PnScl (nth 1 (SymSizN "ARR_FDR")) 0.3048))
			)
			(setq	BlkNam	(strcat _Path-Sym "A130")
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "BKRC")	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "BKRC")) 0.3048))
					(setq	Gap		(* PnScl (nth 1 (SymSizN "BKRC")) 0.3048))
				)
				(setq	Gap		(* PnScl (nth 1 (SymSizN "BKRC")) 0.3048))
			)

			(setq	BlkNam	(strcat _Path-Sym "A164")
					NoCnt	nil
			)
			(setq	Ang1		0.0	;(+ (nth 7 NoLst) (/ (* 3.0 pi) 2.0)))
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "BKRO")	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "BKRO")) 0.3048))
					(setq	Gap		(* PnScl (nth 1 (SymSizN "BKRO")) 0.3048))
				)
				(setq	Gap		(* PnScl (nth 1 (SymSizN "BKRO")) 0.3048))
			)

			(setq	BlkNam	(strcat _Path-Sym "A181")
					NoCnt	nil
			)
			(setq	Ang1		0.0	;(+ (nth 7 NoLst) (/ (* 3.0 pi) 2.0)))
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "ACC")						;Unique InsRep Device
			(command "_.Explode" (handent (nth 1 NoLst)) "")
		)
		;;;================++++++++++++++++++==========================
		((or (= (car NoLst) "U") (= (car NoLst) "T"))	;Unique InsRep Device
			(setq	Pnt1		(nth 3 NoLst)
					Dst1		(nth 4 NoLst)
					Ang1		(nth 7 NoLst)
					Pnt2		(polar Pnt1 Ang1 (/ Dst1 2.0))
					Pnt3		(polar Pnt1 (+ Ang1 pi) (/ Dst1 2.0))
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(command	"_.Stretch"
					"C"
					(list (- (car Pnt2) (/ PnScl 100.0)) (- (cadr Pnt2) (/ PnScl 100.0)))
					(list (+ (car Pnt2) (/ PnScl 100.0)) (+ (cadr Pnt2) (/ PnScl 100.0)))
					""
					Pnt2
					Pnt1
			)
			(command	"_.Stretch"
					"C"
					(list (- (car Pnt3) (/ PnScl 100.0)) (- (cadr Pnt3) (/ PnScl 100.0)))
					(list (+ (car Pnt3) (/ PnScl 100.0)) (+ (cadr Pnt3) (/ PnScl 100.0)))
					""
					Pnt3
					Pnt1
			)
		)
		;;;================++++++++++++++++++==========================
		((or (= (car NoLst) "UNO_PAD") (= (car NoLst) "NO_TRF") (= (car NoLst) "NO_ISO"))	;Unique InsRep Device
			(if NoShwHnd
				(if (setq NoCnt (member (nth 1 NoLst) NoShwHnd))
					(setq	BlkNam		(strcat _Path-Sym "A109")
							NoCnt		(- (length NoShwLst) (length NoCnt))
							NoNoCnt		(car (nth NoCnt NoShwLst))
							NoNoShwHnd	(RemNumLst NoCnt NoNoShwHnd)
							NoShwLst		(RemNumLst NoCnt NoShwLst)
					)
					(setq	BlkNam	(strcat _Path-Sym "A109")
							NoCnt	nil
					)
				)
				(setq	BlkNam	(strcat _Path-Sym "A109"))
			)
			(setq	Pnt1		(nth 3 NoLst)
					Dst1		(nth 4 NoLst)
					Gap		(* PnScl (nth 1 (SymSizN "A109")) 0.3048)
					BlkNam	(strcat _Path-Sym "A109")
					BlkNam2	(strcat _Path-Sym "A079")
					Ang1		(nth 7 NoLst)
					Pnt2		(polar Pnt1 Ang1 (- Dst1 (/ (* 0.3688 Dst1) 2.0)))	;was Dst1 alone, modified for new PAD symbol
					Pnt3		(polar Pnt1 Ang1 Gap)
					Pnt4		(polar Pnt2 (+ Ang1 pi) (/ (* 0.3688 Dst1) 2.0))
					Pnt5		(polar Pnt1 Ang1 (/ Gap 2.0))
			)
			(if NoCnt
				(command "_.Erase" (handent (nth 1 NoLst)) (handent NoNoCnt) "")
				(command "_.Erase" (handent (nth 1 NoLst)) "")
			)
			(setq	ssI		(ssget Pnt1))
			(if ssI
				(setq	Ent1	(entget (ssname ssI 0) (list "*"))
						Ent2	(entget (entnext (cdr (assoc -1 Ent1))) (list "*"))
				)
				(setq	Ent1	nil
						Ent2	nil
				)
			)
			(if (and Ent1 Ent2)
				(setq	Ent1		(RemLst (assoc -1 Ent1) Ent1)
						Ent1		(RemLst (assoc 5 Ent1) Ent1)
						Ent2		(RemLst (assoc -1 Ent2) Ent2)
						Ent2		(RemLst (assoc 5 Ent2) Ent2)
						Ent2		(subst (cons 10 Pnt3) (assoc 10 Ent2) Ent2)
						Ent3		(subst (cons 10 Pnt4) (assoc 10 Ent2) Ent2)
						Ent4		(list
									(cons 0 "SEQEND")
									(cons 100 "AcDbEntity")
									(cons 67 0)
									(assoc 8 Ent2)
								)
						Bubba	(entmake Ent1)
						Bubba	(entmake Ent2)
						Bubba	(entmake Ent3)
						Bubba	(entmake Ent4)
				)
			)
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam2
					Pnt2
					(* 0.3688 Dst1)
					(* 0.3688 Dst1)
					(angtos (+ Ang1 pi))
			)
			(command	"_.Insert"
					BlkNam
					Pnt5
					Gap
					Gap
					(angtos (+ Ang1 pi))
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((and BlkLay (= (car NoLst) "CR"))	;Unique InsRep Device
			(if NoShwHnd
				(if (setq NoCnt (member (nth 1 NoLst) NoShwHnd))
					(setq	BlkNam		(strcat _Path-Sym "A170")
							NoCnt		(- (length NoShwLst) (length NoCnt))
							NoNoCnt		(car (nth NoCnt NoShwLst))
							NoNoShwHnd	(RemNumLst NoCnt NoNoShwHnd)
							NoShwLst		(RemNumLst NoCnt NoShwLst)
							NoNewLay		(GetNOLayEnd BlkLay PnScl)
					)
					(setq	BlkNam	(strcat _Path-Sym "A125")
							NoCnt	nil
							NoNewLay	nil
					)
				)
				(setq	BlkNam	(strcat _Path-Sym "A125")
						NoNewLay	nil
				)
			)
			(if NoNewLay
				(if (LayChk NoNewLay)
					(setq	Bubba	(command "_.Layer" "T" NoNewLay "")
							Bubba	(setvar "CLAYER" NoNewLay)
					)
					(setq	LayDat	(tblsearch "LAYER" (nth 2 NoLst))
							Bubba	(command "_.Layer" "M" NoNewLay "C" (cdr (assoc 62 LayDat)) "" "L" (cdr (assoc 6 LayDat)) "" "")
					)
				)
			)
			(setq	Gap		(* PnScl (nth 1 (SymSizN "CS")) 0.3048))
			(setq	Dst1		(distance (nth 1 BlkLay) (nth 2 BlkLay))
					Ang1		(angle (nth 1 BlkLay) (nth 2 BlkLay))
					Pnt1		(polar (nth 1 BlkLay) Ang1 (/ Gap 2.0))
					Ang2		(angle (nth 1 BlkLay) (nth 2 BlkLay))
					Pnt2		(polar (nth 1 BlkLay) Ang2 Gap)
					Dst2		(- Dst1 Gap)
			)
			(if (> Ang1 pi)
				(while (> Ang1 pi)
					(setq	Ang1	(- Ang1 pi))
				)
			)
			(if NoCnt
				(command "_.Erase" (handent (nth 1 NoLst)) (handent NoNoCnt) "")
				(command "_.Erase" (handent (nth 1 NoLst)) "")
			)
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 (+ Ang1 pi) (* Dst1 0.25))
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
			(command	"_.Insert"
					(strcat _Path-Sym "A140")
					Pnt2
					Dst2
					Dst2
					(angtos Ang2)
			)
		)
		;;;================++++++++++++++++++==========================
		((and BlkLay (or (= (car NoLst) "CS") (= (car NoLst) "CS2")))	;Unique InsRep Device
			(if NoShwHnd
				(if (setq NoCnt (member (nth 1 NoLst) NoShwHnd))
					(setq	BlkNam		(strcat _Path-Sym "A170")
							NoCnt		(- (length NoShwLst) (length NoCnt))
							NoNoCnt		(car (nth NoCnt NoShwLst))
							NoNoShwHnd	(RemNumLst NoCnt NoNoShwHnd)
							NoShwLst		(RemNumLst NoCnt NoShwLst)
							NoNewLay		(GetNOLayEnd BlkLay PnScl)
					)
					(setq	BlkNam	(strcat _Path-Sym "A125")
							NoCnt	nil
							NoNewLay	nil
					)
				)
				(setq	BlkNam	(strcat _Path-Sym "A125")
						NoNewLay	nil
				)
			)
			(if NoNewLay
				(if (LayChk NoNewLay)
					(setq	Bubba	(command "_.Layer" "T" NoNewLay "")
							Bubba	(setvar "CLAYER" NoNewLay)
					)
					(setq	LayDat	(tblsearch "LAYER" (nth 2 NoLst))
							Bubba	(command "_.Layer" "M" NoNewLay "C" (cdr (assoc 62 LayDat)) "" "L" (cdr (assoc 6 LayDat)) "" "")
					)
				)
			)
			(setq	Gap		(* PnScl (nth 1 (SymSizN "CS")) 0.3048))
			(setq	Dst1		(distance (nth 1 BlkLay) (nth 2 BlkLay))
					Ang1		(angle (nth 1 BlkLay) (nth 2 BlkLay))
					Pnt1		(polar (nth 1 BlkLay) Ang1 (/ Dst1 2.0))
			)
			(if (> Ang1 pi)
				(while (> Ang1 pi)
					(setq	Ang1	(- Ang1 pi))
				)
			)
			(if NoCnt
				(command "_.Erase" (handent (nth 1 NoLst)) (handent NoNoCnt) "")
				(command "_.Erase" (handent (nth 1 NoLst)) "")
			)
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(if (and Bug Ang1 Dst1) (princ (strcat "\n {InsRep} says: Ang1=[" (angtos Ang1 0 2) "] Dist1=[" (rtos Dst1 2 2) "] should move Ang=[" (angtos (+ Ang1 pi) 0 2) "] Dist=[" (rtos (* Dst1 0.25) 2 2) "]")))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 (+ Ang1 pi) (* Dst1 0.25))
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((and BlkLay (or (= (car NoLst) "SECT") (= (car NoLst) "_SECT")))	;Unique InsRep Device
			(if NoShwHnd
				(if (setq NoCnt (member (nth 1 NoLst) NoShwHnd))
					(setq	BlkNam		(strcat _Path-Sym "A176")
							NoCnt		(- (length NoShwLst) (length NoCnt))
							NoNoCnt		(car (nth NoCnt NoShwLst))
							NoNoShwHnd	(RemNumLst NoCnt NoNoShwHnd)
							NoShwLst		(RemNumLst NoCnt NoShwLst)
							NoNewLay		(GetNOLayEnd BlkLay PnScl)
					)
					(setq	BlkNam	(strcat _Path-Sym "A121")
							NoCnt	nil
							NoNewLay	nil
					)
				)
				(setq	BlkNam	(strcat _Path-Sym "A121")
						NoNewLay	nil
				)
			)
			(if NoNewLay
				(if (LayChk NoNewLay)
					(setq	Bubba	(command "_.Layer" "T" NoNewLay "")
							Bubba	(setvar "CLAYER" NoNewLay)
					)
					(setq	LayDat	(tblsearch "LAYER" (nth 2 NoLst))
							Bubba	(command "_.Layer" "M" NoNewLay "C" (cdr (assoc 62 LayDat)) "" "L" (cdr (assoc 6 LayDat)) "" "")
					)
				)
			)
			(setq	Gap		(* PnScl (nth 1 (SymSizN "SECT")) 0.3048))
			(setq	Dst1		(distance (nth 1 BlkLay) (nth 2 BlkLay))
					Ang1		(angle (nth 1 BlkLay) (nth 2 BlkLay))
					Pnt1		(polar (nth 1 BlkLay) Ang1 (/ Dst1 2.0))
			)
			(if NoCnt
				(command "_.Erase" (handent (nth 1 NoLst)) (handent NoNoCnt) "")
				(command "_.Erase" (handent (nth 1 NoLst)) "")
			)
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Dst1
					Dst1
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((and BlkLay (= (car NoLst) "DR"))	;Unique InsRep Device
			(if NoShwHnd
				(if (setq NoCnt (member (nth 1 NoLst) NoShwHnd))
					(setq	BlkNam		(strcat _Path-Sym "A172")
							NoCnt		(- (length NoShwLst) (length NoCnt))
							NoNoCnt		(car (nth NoCnt NoShwLst))
							NoNoShwHnd	(RemNumLst NoCnt NoNoShwHnd)
							NoShwLst		(RemNumLst NoCnt NoShwLst)
							NoNewLay		(GetNOLayEnd BlkLay PnScl)
					)
					(setq	BlkNam	(strcat _Path-Sym "A124")
							NoCnt	nil
							NoNewLay	nil
					)
				)
				(setq	BlkNam	(strcat _Path-Sym "A124")
						NoNewLay	nil
				)
			)
			(if NoNewLay
				(if (LayChk NoNewLay)
					(setq	Bubba	(command "_.Layer" "T" NoNewLay "")
							Bubba	(setvar "CLAYER" NoNewLay)
					)
					(setq	LayDat	(tblsearch "LAYER" (nth 2 NoLst))
							Bubba	(command "_.Layer" "M" NoNewLay "C" (cdr (assoc 62 LayDat)) "" "L" (cdr (assoc 6 LayDat)) "" "")
					)
				)
			)
			(setq	Gap		(* PnScl (nth 1 (SymSizN "DS")) 0.3048))
			(setq	Dst1		(distance (nth 1 BlkLay) (nth 2 BlkLay))
					Ang1		(angle (nth 1 BlkLay) (nth 2 BlkLay))
					Pnt1		(polar (nth 1 BlkLay) Ang1 (/ Gap 2.0))
					Ang2		(angle (nth 1 BlkLay) (nth 2 BlkLay))
					Pnt2		(polar (nth 1 BlkLay) Ang2 Gap)
					Dst2		(- Dst1 Gap)
			)
			(if (> Ang1 pi)
				(while (> Ang1 pi)
					(setq	Ang1	(- Ang1 pi))
				)
			)
			(if NoCnt
				(command "_.Erase" (handent (nth 1 NoLst)) (handent NoNoCnt) "")
				(command "_.Erase" (handent (nth 1 NoLst)) "")
			)
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 (+ Ang1 pi) (* Dst1 0.25))
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
			(command	"_.Insert"
					(strcat _Path-Sym "A140")
					Pnt2
					Dst2
					Dst2
					(angtos Ang2)
			)
		)
		;;;================++++++++++++++++++==========================
		((and BlkLay (or (= (car NoLst) "DS") (= (car NoLst) "DS2")))	;Unique InsRep Device
			(if NoShwHnd
				(if (setq NoCnt (member (nth 1 NoLst) NoShwHnd))
					(setq	BlkNam		(strcat _Path-Sym "A172")
							NoCnt		(- (length NoShwLst) (length NoCnt))
							NoNoCnt		(car (nth NoCnt NoShwLst))
							NoNoShwHnd	(RemNumLst NoCnt NoNoShwHnd)
							NoShwLst		(RemNumLst NoCnt NoShwLst)
							NoNewLay		(GetNOLayEnd BlkLay PnScl)
					)
					(setq	BlkNam	(strcat _Path-Sym "A124")
							NoCnt	nil
							NoNewLay	nil
					)
				)
				(setq	BlkNam	(strcat _Path-Sym "A124")
						NoNewLay	nil
				)
			)
			(if NoNewLay
				(if (LayChk NoNewLay)
					(setq	Bubba	(command "_.Layer" "T" NoNewLay "")
							Bubba	(setvar "CLAYER" NoNewLay)
					)
					(setq	LayDat	(tblsearch "LAYER" (nth 2 NoLst))
							Bubba	(command "_.Layer" "M" NoNewLay "C" (cdr (assoc 62 LayDat)) "" "L" (cdr (assoc 6 LayDat)) "" "")
					)
				)
			)
			(setq	Gap		(* PnScl (nth 1 (SymSizN "CS")) 0.3048))
			(setq	Dst1		(distance (nth 1 BlkLay) (nth 2 BlkLay))
					Ang1		(angle (nth 1 BlkLay) (nth 2 BlkLay))
					Pnt1		(polar (nth 1 BlkLay) Ang1 (/ Dst1 2.0))
			)
			(if (> Ang1 pi)
				(while (> Ang1 pi)
					(setq	Ang1	(- Ang1 pi))
				)
			)
			(if NoCnt
				(command "_.Erase" (handent (nth 1 NoLst)) (handent NoNoCnt) "")
				(command "_.Erase" (handent (nth 1 NoLst)) "")
			)
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 (+ Ang1 pi) (* Dst1 0.25))
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((and BlkLay (= (car NoLst) "GR"))	;Unique InsRep Device
			(if NoShwHnd
				(if (setq NoCnt (member (nth 1 NoLst) NoShwHnd))
					(setq	BlkNam		(strcat _Path-Sym "A173")
							NoCnt		(- (length NoShwLst) (length NoCnt))
							NoNoCnt		(car (nth NoCnt NoShwLst))
							NoNoShwHnd	(RemNumLst NoCnt NoNoShwHnd)
							NoShwLst		(RemNumLst NoCnt NoShwLst)
							NoNewLay		(GetNOLayEnd BlkLay PnScl)
					)
					(setq	BlkNam	(strcat _Path-Sym "A126")
							NoCnt	nil
							NoNewLay	nil
					)
				)
				(setq	BlkNam	(strcat _Path-Sym "A126")
						NoNewLay	nil
				)
			)
			(if NoNewLay
				(if (LayChk NoNewLay)
					(setq	Bubba	(command "_.Layer" "T" NoNewLay "")
							Bubba	(setvar "CLAYER" NoNewLay)
					)
					(setq	LayDat	(tblsearch "LAYER" (nth 2 NoLst))
							Bubba	(command "_.Layer" "M" NoNewLay "C" (cdr (assoc 62 LayDat)) "" "L" (cdr (assoc 6 LayDat)) "" "")
					)
				)
			)
			(setq	Gap		(* PnScl (nth 1 (SymSizN "GS")) 0.3048))
			(setq	Dst1		(distance (nth 1 BlkLay) (nth 2 BlkLay))
					Ang1		(angle (nth 1 BlkLay) (nth 2 BlkLay))
					Pnt1		(polar (nth 1 BlkLay) Ang1 (/ Gap 2.0))
					Ang2		(angle (nth 1 BlkLay) (nth 2 BlkLay))
					Pnt2		(polar (nth 1 BlkLay) Ang2 Gap)
					Dst2		(- Dst1 Gap)
			)
			(if (> Ang1 pi)
				(while (> Ang1 pi)
					(setq	Ang1	(- Ang1 pi))
				)
			)
			(if NoCnt
				(command "_.Erase" (handent (nth 1 NoLst)) (handent NoNoCnt) "")
				(command "_.Erase" (handent (nth 1 NoLst)) "")
			)
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 (+ Ang1 pi) (* Dst1 0.25))
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
			(command	"_.Insert"
					(strcat _Path-Sym "A140")
					Pnt2
					Dst2
					Dst2
					(angtos Ang2)
			)
		)
		;;;================++++++++++++++++++==========================
		((and BlkLay (or (= (car NoLst) "GS") (= (car NoLst) "GS2")))	;Unique InsRep Device
			(if NoShwHnd
				(if (setq NoCnt (member (nth 1 NoLst) NoShwHnd))
					(setq	BlkNam		(strcat _Path-Sym "A173")
							NoCnt		(- (length NoShwLst) (length NoCnt))
							NoNoCnt		(car (nth NoCnt NoShwLst))
							NoNoShwHnd	(RemNumLst NoCnt NoNoShwHnd)
							NoShwLst		(RemNumLst NoCnt NoShwLst)
							NoNewLay		(GetNOLayEnd BlkLay PnScl)
					)
					(setq	BlkNam	(strcat _Path-Sym "A126")
							NoCnt	nil
							NoNewLay	nil
					)
				)
				(setq	BlkNam	(strcat _Path-Sym "A126")
						NoNewLay	nil
				)
			)
			(if NoNewLay
				(if (LayChk NoNewLay)
					(setq	Bubba	(command "_.Layer" "T" NoNewLay "")
							Bubba	(setvar "CLAYER" NoNewLay)
					)
					(setq	LayDat	(tblsearch "LAYER" (nth 2 NoLst))
							Bubba	(command "_.Layer" "M" NoNewLay "C" (cdr (assoc 62 LayDat)) "" "L" (cdr (assoc 6 LayDat)) "" "")
					)
				)
			)
			(setq	Gap		(* PnScl (nth 1 (SymSizN "GS")) 0.3048))
			(setq	Dst1		(distance (nth 1 BlkLay) (nth 2 BlkLay))
					Ang1		(angle (nth 1 BlkLay) (nth 2 BlkLay))
					Pnt1		(polar (nth 1 BlkLay) Ang1 (/ Dst1 2.0))
			)
			(if (> Ang1 pi)
				(while (> Ang1 pi)
					(setq	Ang1	(- Ang1 pi))
				)
			)
			(if NoCnt
				(command "_.Erase" (handent (nth 1 NoLst)) (handent NoNoCnt) "")
				(command "_.Erase" (handent (nth 1 NoLst)) "")
			)
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 (+ Ang1 pi) (* Dst1 0.25))
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "MOGS")	;Unique InsRep Device
			(if NoShwHnd
				(if (setq NoCnt (member (nth 1 NoLst) NoShwHnd))
					(setq	BlkNam		(strcat _Path-Sym "A197")
							NoCnt		(- (length NoShwLst) (length NoCnt))
							NoNoCnt		(car (nth NoCnt NoShwLst))
							NoNoShwHnd	(RemNumLst NoCnt NoNoShwHnd)
							NoShwLst		(RemNumLst NoCnt NoShwLst)
							NoNewLay		(GetNOLayEnd BlkLay PnScl)
					)
					(setq	BlkNam	(strcat _Path-Sym "A196")
							NoCnt	nil
							NoNewLay	nil
					)
				)
				(setq	BlkNam	(strcat _Path-Sym "A196")
						NoNewLay	nil
				)
			)
			(if NoNewLay
				(if (LayChk NoNewLay)
					(setq	Bubba	(command "_.Layer" "T" NoNewLay "")
							Bubba	(setvar "CLAYER" NoNewLay)
					)
					(setq	LayDat	(tblsearch "LAYER" (nth 2 NoLst))
							Bubba	(command "_.Layer" "M" NoNewLay "C" (cdr (assoc 62 LayDat)) "" "L" (cdr (assoc 6 LayDat)) "" "")
					)
				)
			)
			(setq	Gap		(* PnScl (nth 1 (SymSizN "GS")) 0.3048))
			(setq	Dst1		(distance (nth 1 BlkLay) (nth 2 BlkLay))
					Ang1		(angle (nth 1 BlkLay) (nth 2 BlkLay))
					Pnt1		(polar (nth 1 BlkLay) Ang1 (/ Dst1 2.0))
			)
			(if (> Ang1 pi)
				(while (> Ang1 pi)
					(setq	Ang1	(- Ang1 pi))
				)
			)
			(if NoCnt
				(command "_.Erase" (handent (nth 1 NoLst)) (handent NoNoCnt) "")
				(command "_.Erase" (handent (nth 1 NoLst)) "")
			)
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 (+ Ang1 pi) (* Dst1 0.25))
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((and BlkLay (= (car NoLst) "UGOPEN"))	;Unique InsRep Device
			(if NoShwHnd
				(if (setq NoCnt (member (nth 1 NoLst) NoShwHnd))
					(setq	BlkNam		(strcat _Path-Sym "A109")
							NoCnt		(- (length NoShwLst) (length NoCnt))
							NoNoCnt		(car (nth NoCnt NoShwLst))
							NoNoShwHnd	(RemNumLst NoCnt NoNoShwHnd)
							NoShwLst		(RemNumLst NoCnt NoShwLst)
							NoNewLay		(GetNOLayEnd BlkLay PnScl)
					)
					(setq	BlkNam	(strcat _Path-Sym "A109")
							NoCnt	nil
							NoNewLay	nil
					)
				)
				(setq	BlkNam	(strcat _Path-Sym "A109")
						NoNewLay	nil
				)
			)
			(if NoNewLay
				(if (LayChk NoNewLay)
					(setq	Bubba	(command "_.Layer" "T" NoNewLay "")
							Bubba	(setvar "CLAYER" NoNewLay)
					)
					(setq	LayDat	(tblsearch "LAYER" (nth 2 NoLst))
							Bubba	(command "_.Layer" "M" NoNewLay "C" (cdr (assoc 62 LayDat)) "" "L" (cdr (assoc 6 LayDat)) "" "")
					)
				)
			)
			(setq	Gap		(* PnScl (nth 1 (SymSizN "A109")) 0.3048))
			(setq	Dst1		(distance (nth 1 BlkLay) (nth 2 BlkLay))
					Ang1		(angle (nth 1 BlkLay) (nth 2 BlkLay))
					Pnt1		(polar (nth 1 BlkLay) Ang1 (/ Dst1 2.0))
					Pnt2		(polar Pnt1 Ang1 (/ Dst1 2.0))
					Pnt3		(polar Pnt1 (+ Ang1 pi) (/ Dst1 2.0))
					Pnt4		(polar Pnt1 Ang1 (/ Gap 2.0))
					Pnt5		(polar Pnt1 (+ Ang1 pi) (/ Gap 2.0))
			)
			(if (> Ang1 pi)
				(while (> Ang1 pi)
					(setq	Ang1	(- Ang1 pi))
				)
			)
			(if NoCnt
				(command "_.Erase" (handent (nth 1 NoLst)) (handent NoNoCnt) "")
				(command "_.Erase" (handent (nth 1 NoLst)) "")
			)
			(command "_.Layer" "T" "????FL*" "")
			(command	"_.Stretch"
					"C"
					(list (- (car Pnt2) (/ PnScl 100.0)) (- (cadr Pnt2) (/ PnScl 100.0)))
					(list (+ (car Pnt2) (/ PnScl 100.0)) (+ (cadr Pnt2) (/ PnScl 100.0)))
					""
					Pnt2
					Pnt4
			)
			(command	"_.Stretch"
					"C"
					(list (- (car Pnt3) (/ PnScl 100.0)) (- (cadr Pnt3) (/ PnScl 100.0)))
					(list (+ (car Pnt3) (/ PnScl 100.0)) (+ (cadr Pnt3) (/ PnScl 100.0)))
					""
					Pnt3
					Pnt5
			)
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((and BlkLay (or (= (car NoLst) "_SS") (= (car NoLst) "NEWSS")))	;Unique InsRep Device
			(if NoShwHnd
				(if (setq NoCnt (member (nth 1 NoLst) NoShwHnd))
					(setq	BlkNam		(strcat _Path-Sym "A170S")
							NoCnt		(- (length NoShwLst) (length NoCnt))
							NoNoCnt		(car (nth NoCnt NoShwLst))
							NoNoShwHnd	(RemNumLst NoCnt NoNoShwHnd)
							NoShwLst		(RemNumLst NoCnt NoShwLst)
							NoNewLay		(GetNOLayEnd BlkLay PnScl)
					)
					(setq	BlkNam	(strcat _Path-Sym "A125S")
							NoCnt	nil
							NoNewLay	nil
					)
				)
				(setq	BlkNam	(strcat _Path-Sym "A125S")
						NoNewLay	nil
				)
			)
			(if NoNewLay
				(if (LayChk NoNewLay)
					(setq	Bubba	(command "_.Layer" "T" NoNewLay "")
							Bubba	(setvar "CLAYER" NoNewLay)
					)
					(setq	LayDat	(tblsearch "LAYER" (nth 2 NoLst))
							Bubba	(command "_.Layer" "M" NoNewLay "C" (cdr (assoc 62 LayDat)) "" "L" (cdr (assoc 6 LayDat)) "" "")
					)
				)
			)
			(setq	Gap		(* PnScl (nth 1 (SymSizN "_SS")) 0.3048))
			(setq	Dst1		(distance (nth 1 BlkLay) (nth 2 BlkLay))
					Ang1		(angle (nth 1 BlkLay) (nth 2 BlkLay))
					Pnt1		(polar (nth 1 BlkLay) Ang1 (/ Dst1 2.0))
			)
			(if (> Ang1 pi)
				(while (> Ang1 pi)
					(setq	Ang1	(- Ang1 pi))
				)
			)
			(if NoCnt
				(command "_.Erase" (handent (nth 1 NoLst)) (handent NoNoCnt) "")
				(command "_.Erase" (handent (nth 1 NoLst)) "")
			)
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Gap 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((and BlkLay (= (car NoLst) "_SSR"))	;Unique InsRep Device
			(if NoShwHnd
				(if (setq NoCnt (member (nth 1 NoLst) NoShwHnd))
					(setq	BlkNam		(strcat _Path-Sym "A170S")
							NoCnt		(- (length NoShwLst) (length NoCnt))
							NoNoCnt		(car (nth NoCnt NoShwLst))
							NoNoShwHnd	(RemNumLst NoCnt NoNoShwHnd)
							NoShwLst		(RemNumLst NoCnt NoShwLst)
							NoNewLay		(GetNOLayEnd BlkLay PnScl)
					)
					(setq	BlkNam	(strcat _Path-Sym "A125S")
							NoCnt	nil
							NoNewLay	nil
					)
				)
				(setq	BlkNam	(strcat _Path-Sym "A125S")
						NoNewLay	nil
				)
			)
			(if NoNewLay
				(if (LayChk NoNewLay)
					(setq	Bubba	(command "_.Layer" "T" NoNewLay "")
							Bubba	(setvar "CLAYER" NoNewLay)
					)
					(setq	LayDat	(tblsearch "LAYER" (nth 2 NoLst))
							Bubba	(command "_.Layer" "M" NoNewLay "C" (cdr (assoc 62 LayDat)) "" "L" (cdr (assoc 6 LayDat)) "" "")
					)
				)
			)
			(setq	Gap		(* PnScl (nth 1 (SymSizN "_SS")) 0.3048))
			(setq	Dst1		(distance (nth 1 BlkLay) (nth 2 BlkLay))
					Ang1		(angle (nth 1 BlkLay) (nth 2 BlkLay))
					Pnt1		(polar (nth 1 BlkLay) Ang1 (/ Gap 2.0))
					Ang2		(angle (nth 1 BlkLay) (nth 2 BlkLay))
					Pnt2		(polar (nth 1 BlkLay) Ang2 Gap)
					Dst2		(- Dst1 Gap)
			)
			(if (> Ang1 pi)
				(while (> Ang1 pi)
					(setq	Ang1	(- Ang1 pi))
				)
			)
			(if NoCnt
				(command "_.Erase" (handent (nth 1 NoLst)) (handent NoNoCnt) "")
				(command "_.Erase" (handent (nth 1 NoLst)) "")
			)
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Gap 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
			(command	"_.Insert"
					(strcat _Path-Sym "A140")
					Pnt2
					Dst2
					Dst2
					(angtos Ang2)
			)
		)
		;;;================++++++++++++++++++==========================
		((and BlkLay (member (car NoLst) (list "_OCR" "_OCR_BP" "_OCR_EL" "RECL" "RECLBP" "RECLBP_2" "RECLEL" "RECLEL_2" "RECLEL_3" "RECLEL_4" "RECLEL_5")))	;Unique InsRep Device
			(if NoShwHnd
				(if (setq NoCnt (member (nth 1 NoLst) NoShwHnd))
					(setq	BlkNam		(strcat _Path-Sym "A169")
							NoCnt		(- (length NoShwLst) (length NoCnt))
							NoNoCnt		(car (nth NoCnt NoShwLst))
							NoNoShwHnd	(RemNumLst NoCnt NoNoShwHnd)
							NoShwLst		(RemNumLst NoCnt NoShwLst)
							NoNewLay		(GetNOLayEnd BlkLay PnScl)
					)
					(setq	BlkNam	(strcat _Path-Sym "A105")
							NoCnt	nil
							NoNewLay	nil
					)
				)
				(setq	BlkNam	(strcat _Path-Sym "A105")
						NoNewLay	nil
				)
			)
			(if NoNewLay
				(if (LayChk NoNewLay)
					(setq	Bubba	(command "_.Layer" "T" NoNewLay "")
							Bubba	(setvar "CLAYER" NoNewLay)
					)
					(setq	LayDat	(tblsearch "LAYER" (nth 2 NoLst))
							Bubba	(command "_.Layer" "M" NoNewLay "C" (cdr (assoc 62 LayDat)) "" "L" (cdr (assoc 6 LayDat)) "" "")
					)
				)
			)
			(setq	Gap		(* PnScl (nth 1 (SymSizN "_OCR")) 0.3048))
			(setq	Dst1		(distance (nth 1 BlkLay) (nth 2 BlkLay))
					Ang1		(angle (nth 1 BlkLay) (nth 2 BlkLay))
					Pnt1		(polar (nth 1 BlkLay) Ang1 (/ Dst1 2.0))
					Pnt2		(polar Pnt1 Ang1 (/ Dst1 2.0))
					Pnt3		(polar Pnt1 (+ Ang1 pi) (/ Dst1 2.0))
					Pnt4		(polar Pnt1 Ang1 (/ Gap 2.0))
					Pnt5		(polar Pnt1 (+ Ang1 pi) (/ Gap 2.0))
			)
			(if NoCnt
				(command "_.Erase" (handent (nth 1 NoLst)) (handent NoNoCnt) "")
				(command "_.Erase" (handent (nth 1 NoLst)) "")
			)
			(command "_.Layer" "T" "????FL*" "")
			(command	"_.Stretch"
					"C"
					(list (- (car Pnt2) (/ PnScl 100.0)) (- (cadr Pnt2) (/ PnScl 100.0)))
					(list (+ (car Pnt2) (/ PnScl 100.0)) (+ (cadr Pnt2) (/ PnScl 100.0)))
					""
					Pnt2
					Pnt4
			)
			(command	"_.Stretch"
					"C"
					(list (- (car Pnt3) (/ PnScl 100.0)) (- (cadr Pnt3) (/ PnScl 100.0)))
					(list (+ (car Pnt3) (/ PnScl 100.0)) (+ (cadr Pnt3) (/ PnScl 100.0)))
					""
					Pnt3
					Pnt5
			)
			(if (> Ang1 (/ pi 3.0))
				(while (> Ang1 (/ pi 3.0))
					(setq	Ang1	(- Ang1 pi))
				)
			)
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Gap 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((or (= (car NoLst) "UGOPEN")	(= (car NoLst) "UNO"));Unique InsRep Device
			(if NoShwHnd
				(if (setq NoCnt (member (nth 1 NoLst) NoShwHnd))
					(setq	BlkNam		(strcat _Path-Sym "A109")
							NoCnt		(- (length NoShwLst) (length NoCnt))
							NoNoCnt		(car (nth NoCnt NoShwLst))
							NoNoShwHnd	(RemNumLst NoCnt NoNoShwHnd)
							NoShwLst		(RemNumLst NoCnt NoShwLst)
					)
					(setq	BlkNam	(strcat _Path-Sym "A109")
							NoCnt	nil
					)
				)
				(setq	BlkNam	(strcat _Path-Sym "A109"))
			)
			(if (= (car NoLst) "UNO")
				(setq	Gap		(* 0.581634 PnScl (nth 1 (SymSizN "A109")) 0.3048))
				(setq	Gap		(* PnScl (nth 1 (SymSizN "A109")) 0.3048))
			)
			(setq	Pnt0		(nth 3 NoLst)
					Pnt9 	(polar Pnt0 (nth 7 NoLst) (nth 4 NoLst))
					Dst1		(distance Pnt0 Pnt9)
					Ang1		(angle Pnt0 Pnt9)
					Pnt1		(polar Pnt0 Ang1 (/ Dst1 2.0))
			)
			(if (> Ang1 pi)
				(while (> Ang1 pi)
					(setq	Ang1	(- Ang1 pi))
				)
			)
			(if (> Ang1 (/ pi 3.0))
				(while (> Ang1 (/ pi 3.0))
					(setq	Ang1	(- Ang1 pi))
				)
			)
			(if NoCnt
				(command "_.Erase" (handent (nth 1 NoLst)) (handent NoNoCnt) "")
				(command "_.Erase" (handent (nth 1 NoLst)) "")
			)
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((or (= (car NoLst) "DA") (= (car NoLst) "_DA") (= (car NoLst) "SCADA") (wcmatch (car NoLst) "A$C*"))	;Unique InsRep Device
			(if (= (nth 9 NoLst) 1)
				(if (> (nth 6 (nth 1 (nth 10 NoLst))) 5.0)
					(setq	Gap		(* (nth 6 (nth 1 (nth 10 NoLst))) (nth 1 (SymSizN "_DA")) 0.3048))
					(setq	Gap		(* PnScl (nth 1 (SymSizN "_DA")) 0.3048))
				)
				(setq	Gap		(* PnScl (nth 1 (SymSizN "_DA")) 0.3048))
			)
			(if (and (wcmatch (StpDot AppNam) "SUBTOOLS") Gap)
				(setq	Gap	(* Gap 2.0))
			)
			(setq	BlkNam	(strcat _Path-Sym "A156")
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "FD_NUM2")	;Unique InsRep Device
			(setq	Gap		(* PnScl (nth 1 (SymSizN "FD_NUM2")) 0.3048))
			(setq	BlkNam	(strcat _Path-Sym "A080")
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "SENSOR")	;Unique InsRep Device
			(setq	Gap		(* PnScl (nth 1 (SymSizN "SENSOR")) 0.3048))
			(setq	BlkNam	(strcat _Path-Sym "A155")
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "CAP")	;Unique InsRep Device
			(setq	Gap		(* PnScl (nth 1 (SymSizN "CAP")) 0.3048))
			(setq	BlkNam	(strcat _Path-Sym "A101")
					NoCnt	nil
					Pnt1		(nth 3 NoLst)
			)
			(if (wcmatch (StpDot AppNam) "SUBTOOLS")
				(setq	Ang1		(nth 7 NoLst))
				(setq	Ang1		(+ (nth 7 NoLst) (/ pi 2.0)))
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((or (= (car NoLst) "PM") (= (car NoLst) "PM_END"))	;Unique InsRep Device
			(setq	Gap		(* PnScl (nth 1 (SymSizN "PM")) 0.3048))
			(setq	BlkNam	(strcat _Path-Sym "A150")
					NoCnt	nil
			)
			(if (= (car NoLst) "PM")
				(setq	Ang1		(nth 7 NoLst)
						Pnt1		(nth 3 NoLst)
				)
				(if (= (car NoLst) "PM_END")
					(setq	Ang1		(nth 7 NoLst)
							Pnt1		(polar (nth 3 NoLst) Ang1 (/ Gap 2.0))
					)
				)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((or (= (car NoLst) "SGEN") (= (car NoLst) "_SGEN"))	;Unique InsRep Device	;SGEN is bogus
			(setq	Gap		(* PnScl (nth 1 (SymSizN "_SGEN")) 0.3048))
			(setq	BlkNam	(strcat _Path-Sym "A104")
					NoCnt	nil
			)
			(setq	Ang1		(nth 7 NoLst)
					Pnt1		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "RISER")	;Unique InsRep Device
			(setq	Gap		(* PnScl (nth 1 (SymSizN "RISER")) 0.3048))
			(setq	BlkNam	(strcat _Path-Sym "A140")
					NoCnt	nil
					Pnt0		(nth 3 NoLst)
					Pnt9 	(polar Pnt0 (nth 7 NoLst) (nth 4 NoLst))
					Dst1		(distance Pnt0 Pnt9)
					Ang1		(angle Pnt0 Pnt9)
					Pnt1		(polar Pnt0 Ang1 (/ Dst1 2.0))
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt1
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "STEPTRAN")	;Unique InsRep Device
			(setq	Gap		(* PnScl (nth 1 (SymSizN "STEPTRAN")) 0.3048))
			(setq	BlkNam	(strcat _Path-Sym "A122")
					NoCnt	nil
					Pnt0		(nth 3 NoLst)
					Ang1		(nth 7 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt0
					Gap
					Gap
					(angtos (+ Ang1 (/ pi 2.0)))
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "REG")	;Unique InsRep Device
			(setq	Gap		(* PnScl (nth 1 (SymSizN "REG")) 0.3048))
			(setq	BlkNam	(strcat _Path-Sym "A133")
					NoCnt	nil
					Pnt0		(nth 3 NoLst)
					Ang1		(nth 7 NoLst)
			)
			(if (wcmatch (StpDot AppNam) "SUBTOOLS")
				(setq	Ang1		(+ Ang1 (/ pi 2.0))
						Gap		(/ Gap 4.0)
				)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt0
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "BRKR_SUB")	;Unique InsRep Device
			(setq	Gap		(* PnScl (nth 1 (SymSizN "BRKR_SUB")) 0.3048))
			(setq	BlkNam	(strcat _Path-Sym "A138")
					NoCnt	nil
					Pnt0		(nth 3 NoLst)
			)
			(if (wcmatch (StpDot AppNam) "SUBTOOLS")
				(setq	Ang1		0.0)	;(+ (nth 7 NoLst) (/ (* 3.0 pi) 2.0)))
				(setq	Ang1		(nth 7 NoLst))
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt0
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "REGA")	;Unique InsRep Device
			(setq	Gap		(* PnScl (nth 1 (SymSizN "REGA")) 0.3048))
			(setq	BlkNam	(strcat _Path-Sym "A120")
					NoCnt	nil
					Pnt0		(nth 3 NoLst)
					Ang1		(nth 7 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt0
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "GETAWAY")	;Unique InsRep Device
			(setq	Gap		(* PnScl (nth 1 (SymSizN "A165")) 0.3048))
			(setq	BlkNam	(strcat _Path-Sym "A165")
					NoCnt	nil
					Pnt0		(nth 3 NoLst)
					Ang1		(nth 7 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt0
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((or (= (car NoLst) "PAD") (= (car NoLst) "PAD_END"))	;Unique InsRep Device
			(setq	Gap		(nth 4 NoLst))
			(setq	BlkNam	(strcat _Path-Sym "A079")
					NoCnt	nil
					Ang1		(nth 7 NoLst)
					Pnt0		(polar (nth 3 NoLst) Ang1 (/ Gap 2.0))
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt0
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "PADMT")	;Unique InsRep Device
			(setq	Gap		(* 0.124753 (nth 4 NoLst)))
			(setq	BlkNam	(strcat _Path-Sym "A078")
					NoCnt	nil
					Ang1		(nth 7 NoLst)
					Pnt0		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt0
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "TRANSCL")	;Unique InsRep Device
			(setq	Gap		(* 0.124753 (nth 4 NoLst)))
			(setq	BlkNam	(strcat _Path-Sym "A077")
					NoCnt	nil
					Ang1		(nth 7 NoLst)
					Pnt0		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt0
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "_KEY")	;Unique InsRep Device
			(setq	Gap		(* PnScl (nth 1 (SymSizN "_KEY")) 0.3048))
			(setq	BlkNam	(strcat _Path-Sym "A183")
					NoCnt	nil
					Ang1		(nth 7 NoLst)
					Pnt0		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt0
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "CE")	;Unique InsRep Device
			(setq	Gap		(* PnScl (nth 1 (SymSizN "CE")) 0.3048))
			(setq	BlkNam	(strcat _Path-Sym "A082")
					NoCnt	nil
					Ang1		(nth 7 NoLst)
					Pnt0		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt0
					(* 1.5 Gap)
					(* 1.5 Gap)
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "LOC")	;Unique InsRep Device
			(setq	Gap		(* PnScl (nth 1 (SymSizN "LOC")) 0.3048))
			(setq	BlkNam	(strcat _Path-Sym "A086")
					NoCnt	nil
					Ang1		(nth 7 NoLst)
					Pnt0		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt0
					(* 0.5 Gap)
					(* 0.5 Gap)
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "ATS")	;Unique InsRep Device
			(setq	Gap		(* PnScl 0.51 0.3048))
			(setq	BlkNam	(strcat _Path-Sym "A084")
					NoCnt	nil
					Ang1		(nth 7 NoLst)
					Pnt0		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt0
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "URD_LOC")	;Unique InsRep Device
			(setq	Gap		(* PnScl (nth 1 (SymSizN "URD_LOC")) 0.3048))
			(setq	BlkNam	(strcat _Path-Sym "A081")
					NoCnt	nil
					Ang1		(nth 7 NoLst)
					Pnt0		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt0
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "SUB")	;Unique InsRep Device
			(if (wcmatch (StpDot AppNam) "SUBTOOLS")
				(progn
					(setq	Gap		(* PnScl (nth 1 (SymSizN "SUB")) 0.3048))
					(setq	Gap		(* Gap 0.6))
					(setq	BlkNam	(strcat _Path-Sym "A136")
							NoCnt	nil
							Ang1		(+ (nth 7 NoLst) (/ pi 2.0))
							Pnt0		(nth 3 NoLst)
					)
					(command "_.Erase" (handent (nth 1 NoLst)) "")
					(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
					(command	"_.Insert"
							BlkNam
							Pnt0
							Gap
							Gap
							(angtos Ang1)
					)
					(if (= (nth 9 NoLst) 1)
						(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
						(if (= (car (last NoLst)) "XData")
							(BlkXdatUpd NoLst)
						)
					)
				)
				(progn
					(setq	Gap		(* PnScl (nth 1 (SymSizN "SUB")) 0.3048))
					(setq	BlkNam	(strcat _Path-Sym "A074")
							NoCnt	nil
							Ang1		(+ (nth 7 NoLst) (/ pi 2.0))
							Pnt0		(nth 3 NoLst)
					)
					(command "_.Erase" (handent (nth 1 NoLst)) "")
					(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
					(command	"_.Insert"
							BlkNam
							Pnt0
							Gap
							Gap
							(angtos Ang1)
					)
					(if (= (nth 9 NoLst) 1)
						(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
						(if (= (car (last NoLst)) "XData")
							(BlkXdatUpd NoLst)
						)
					)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "SUB2")	;Unique InsRep Device
			(setq	Gap		(* PnScl (nth 1 (SymSizN "SUB2")) 0.3048))
			(setq	BlkNam	(strcat _Path-Sym "A075")
					NoCnt	nil
					Ang1		(+ (nth 7 NoLst) (/ pi 2.0))
					Pnt0		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt0
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((= (car NoLst) "SUBCUST")	;Unique InsRep Device
			(setq	PnScl	(GetPnScl BlkLay NoLst PnScl))
			(setq	Gap		(* PnScl (nth 1 (SymSizN "SUBCUST")) 0.3048))
			(setq	BlkNam	(strcat _Path-Sym "A076")
					NoCnt	nil
					Ang1		(nth 7 NoLst)
					Pnt0		(nth 3 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt0
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
		;;;================++++++++++++++++++==========================
		((and BlkLay (or (wcmatch (car NoLst) "SMS") (wcmatch (car NoLst) "_AUTOCON")))	;Unique InsRep Device
			(if NoShwHnd
				(if (setq NoCnt (member (nth 1 NoLst) NoShwHnd))
					(setq	BlkNam		(strcat _Path-Sym "A171")
							NoCnt		(- (length NoShwLst) (length NoCnt))
							NoNoCnt		(car (nth NoCnt NoShwLst))
							NoNoShwHnd	(RemNumLst NoCnt NoNoShwHnd)
							NoShwLst		(RemNumLst NoCnt NoShwLst)
							NoNewLay		(GetNOLayEnd BlkLay PnScl)
					)
					(setq	BlkNam	(strcat _Path-Sym "A123")
							NoCnt	nil
							NoNewLay	nil
					)
				)
				(setq	BlkNam	(strcat _Path-Sym "A123"))
			)
			(if NoNewLay
				(if (LayChk NoNewLay)
					(setq	Bubba	(command "_.Layer" "T" NoNewLay "")
							Bubba	(setvar "CLAYER" NoNewLay)
					)
					(setq	LayDat	(tblsearch "LAYER" (nth 2 NoLst))
							Bubba	(command "_.Layer" "M" NoNewLay "C" (cdr (assoc 62 LayDat)) "" "L" (cdr (assoc 6 LayDat)) "" "")
					)
				)
			)
			(setq	Gap		(* PnScl (nth 1 (SymSizN "SMS")) 0.3048))
			(if NoCnt
				(command "_.Erase" (handent (nth 1 NoLst)) (handent NoNoCnt) "")
				(command "_.Erase" (handent (nth 1 NoLst)) "")
			)
			(setq	Pnt0		(nth 3 NoLst)
					Ang1		(nth 7 NoLst)
			)
			(command "_.Erase" (handent (nth 1 NoLst)) "")
			(if (/= (getvar "ATTREQ") 0) (setvar "ATTREQ" 0))
			(command	"_.Insert"
					BlkNam
					Pnt0
					Gap
					Gap
					(angtos Ang1)
			)
			(if (= (nth 9 NoLst) 1)
				(BlkAttUpd NoLst Pnt1 Dst1 0.0 0.0)
				(if (= (car (last NoLst)) "XData")
					(BlkXdatUpd NoLst)
				)
			)
		)
	)
;;;	(if NoLst
;;;		(RemDevLst NoLst)
;;;	)
)

(defun Fix_EED ( InpIDLst /	UniqID )
	(if InpIDLst
		(foreach	UniqID
				InpIDLst
				(if (FndEEDev UniqID) (ChngUm T (FndEEDev UniqID)))
		)
	)
	(princ)
)

(defun sublst (lst startNew leng / rslt)
	(if (not (<= 1 leng (- (length lst) startNew)))
		(setq leng (- (length lst) (1- startNew)))
	)
	(repeat leng
		(setq rslt (cons (nth (1- startNew) lst) rslt)
			startNew (1+ startNew)
		)
	)
	(reverse rslt)
)

(defun split-list (lst n)
	(if lst
		(cons (sublst lst 1 n)
			(split-list (sublst lst (1+ n) nil) n)
		)
	)
) 


(defun C:CompLstID ( /	OutNam FilNam sSql FN	;Compare Unique ID Lists and refresh the Missing, List the Zombie
					Cntr MyIDLst UniqID )	;MsdIDLst ZmbIDLst
	(if (and (not PanLst) (= (substr (StpDot AppNam) 1 4) "SUBT"))
		(progn
			(setq	Panel		(getvar "DWGNAME"))
			(if (> (strlen Panel) 4)
				(setq	Panel		(strcase (substr Panel 1 (- (strlen Panel) 4))))
				(setq	Pan_ID	nil)
			)
			(if Panel
				(if (assoc Panel Lst_Pan_ID)
					(setq	Pan_ID	(cadr (assoc Panel Lst_Pan_ID))
							PanLst	(list Panel)
					)
					(setq	Pan_ID	nil
							Panel	nil
							PanLst	nil
					)
				)
				(setq	Pan_ID	nil
						Panel	nil
						PanLst	nil
				)
			)
		)
	)
	(if PanLst
		(if (= (length PanLst) 1)
			(progn
				(setq	BlkDatOutLst	nil
						UniqIDLst		nil
				)
				(C:GetDatOut)
				(if BlkDatOutLst
					(C:LstIDOut)
				)
				(if (= (substr (StpDot AppNam) 1 4) "SUBT")
					(if UniqIDLst
						(setq	OutNam	(strcat "C:\\SubTools\\" (car PanLst) ".SQL")
								FilNam	(strcat "C:\\SubTools\\" (car PanLst) ".Txt")
								ZmbNam	(strcat "C:\\SubTools\\" "Zombie.Txt")
						)
					)
					(if UniqIDLst
						(setq	OutNam	(strcat "C:\\Adds\\" (car PanLst) ".SQL")
								FilNam	(strcat "C:\\Adds\\" (car PanLst) ".Txt")
								ZmbNam	(strcat "C:\\Adds\\" "Zombie.Txt")
						)
					)
				)
				(if (and UniqIDLst OutNam FilNam ZmbNam)
					(setq	MyStorDat	(GetStorDate)
							sSql		"set time on;"
							sSql		(strcat sSql "\nset serveroutput on size 100000 pagesize 80 linesize 250;")
							sSql		(strcat sSql "\nset heading off;")
							sSql		(strcat sSql "\nnumpage none;")
							sSql		(strcat sSql "\nalter session set nls_date_format = 'YYYY-MM-DD-HH24:MI.SS';")
							sSql		(strcat sSql "\nclear columns;")
							sSql		(strcat sSql "\nspool " FilNam)
							sSql		(strcat sSql "\nselect '\"' || omd.device_id || '\"' FROM addsdb.objmstdev omd WHERE omd.adds_panel_id = " (itoa (PanID_from_Nam (car PanLst))) ";")
							sSql		(strcat sSql "\nspool off")
							sSql		(strcat sSql "\nquit")
							FN		(open OutNam "w")
							Bubba	(write-line sSql FN)
							Bubba	(close FN)
							MsdIDLst	nil
							ZmbIDLst	nil
					)
				)
			)
		)
	)
	(if FilNam
		(if (findfile FilNam)
			(dos_delete FilNam)
		)
	)
	(if OutNam
		(if (findfile OutNam)
			(dos_exewait (strcat "C:\\Southern\\orant\\BIN\\PLUS33.EXE GEWILYMS/GEWILYMS@" (nth 1 MyUsrInfo) " @" OutNam) 3)
		)
	)
	(if (and UniqIDLst FilNam)
		(setq	;FilNam	(getfiled "ID File Selection" (getvar "DWGPREFIX") "TXT" 8)
				MsdIDLst	nil
				ZmbIDLst	nil
				Cntr		0
		)
	)
	(if (and UniqIDLst FilNam)
		(if (findfile FilNam)
			(setq	MyIDLst	(GetFilAsLst (findfile FilNam)))
		)
	)
	(if MyIDLst
		(if (eq 'LIST (type (car MyIDLst)))
			(setq	MyIDLst	(mapcar (quote car) MyIDLst))
		)
	)
	(if (and UniqIDLst FilNam)
		(foreach	UniqID
				UniqIDLst
				(if (not (member UniqID MyIDLst))
					(if MsdIDLst
						(if (not (member UniqID MsdIDLst))
							(setq	MsdIDLst	(cons UniqID MsdIDLst)
									Cntr		(1+ Cntr)
							)
						)
						(setq	MsdIDLst	(list UniqID)
								Cntr		(1+ Cntr)
						)
					)
				)
		)
	)
	(if (and UniqIDLst FilNam)
		(if (> Cntr 0)
			(princ (strcat "\nMissing [" (itoa Cntr) "] ID's from Oracle..."))
		)
	)
	(setq	Cntr		0)
	(if (and UniqIDLst FilNam)
		(foreach	UniqID
				MyIDLst
				(if (not (member UniqID UniqIDLst))
					(if ZmbIDLst
						(if (not (member UniqID ZmbIDLst))
							(setq	ZmbIDLst	(cons UniqID ZmbIDLst)
									Cntr		(1+ Cntr)
							)
						)
						(setq	ZmbIDLst	(list UniqID)
								Cntr		(1+ Cntr)
						)
					)
				)
		)
	)
	(if (and UniqIDLst FilNam)
		(if (> Cntr 0)
			(princ (strcat "\nZombie [" (itoa Cntr) "] ID's in Adds..."))
		)
	)
	(if FilNam
		(if (and (findfile FilNam) (not Bug))
			(dos_delete FilNam)
		)
	)
	(if OutNam
		(if (and (findfile OutNam) (not Bug))
			(dos_delete OutNam)
		)
	)
	(if ZmbIDLst
		(if (findfile ZmbNam)
			(setq	ZmbFil	(open ZmbNam "a"))
			(setq	ZmbFil	(open ZmbNam "w"))
		)
	)
	(if ZmbIDLst
		(if (and ZmbIDLst OutNam FilNam ZmbNam)
			(progn
				(setq ETsLst	(split-list ZmbIDLst 1000))
				(setq indexLst 0)
				(repeat (length ETsLst)
					(setq TZmbIDLst (nth indexLst ETsLst))
					(setq indexLst (+ indexLst 1))
				;	(setq OutNam (strcat(itoa indexLst) OutNam))
					(setq	OutNam	(strcat "C:\\Adds\\" (car PanLst) "_" (itoa indexLst) ".SQL"))
					(princ "\n Pass Number: ") (prin1 indexLst) (princ "\n")
					(setq	sSql		"set time on;"
							sSql		(strcat sSql "\nset serveroutput on size 100000 pagesize 80 linesize 250;")
							sSql		(strcat sSql "\nalter session set nls_date_format = 'YYYY-MM-DD-HH24:MI.SS';")
							sSql		(strcat sSql "\nalter session set optimizer_mode = first_rows;")
							sSql		(strcat sSql "\nalter session set sort_area_size = 999999999;")
							sSql		(strcat sSql "\nDECLARE")
							sSql		(strcat sSql "\n\tin_dtm\tDATE;")
							sSql		(strcat sSql "\nBEGIN")
							sSql		(strcat sSql "\n\tin_dtm := Tmap.TZ_SYSDATE;")
					)
					(mapcar (quote (lambda (x) (setq sSql (strcat sSql "\n\tAddsDb.AddsDb_Destroyer.Del_Object_By_ID('" x "',in_dtm,USER);")))) TZmbIDLst) ;in_dtm
					(setq	sSql		(strcat sSql "\n\tCOMMIT;")
							sSql		(strcat sSql "\nEND;")
							sSql		(strcat sSql "\n/")
							sSql		(strcat sSql "\nquit")
							FN		(open OutNam "w")
							Bubba	(write-line sSql FN)
							Bubba	(close FN)
					)
					(if (findfile OutNam)
						(dos_exewait (strcat "C:\\Southern\\orant\\BIN\\PLUS33.EXE GEWILYMS/GEWILYMS@" (nth 1 MyUsrInfo) " @" OutNam) 3)
					)
				)
			)
		)
	)
	
	(if ZmbIDLst
		(foreach	ZmbID
				ZmbIDLst
				(princ (strcat "\nZombie ID {" ZmbID "} in Oracle, not Adds"))
				(if ZmbFil
					(write-line (strcat (itoa (PanID_from_Nam (car PanLst))) "," ZmbID "," MyStorDat "," (car PanLst)) ZmbFil)
				)
		)
	)
	(if ZmbFil
		(setq	Bubba	(close ZmbFil)
				ZmbFil	nil
		)
	)
	(if (= (substr (StpDot AppNam) 1 4) "SUBT")
		(if MsdIDLst
			(progn
				(Fix_EED MsdIDLst)
				(command "_.Zoom" "E")
				(C:Save)
			)
			(C:Save)
		)
		(if MsdIDLst
			(progn
				(Fix_EED MsdIDLst)
				(command "_.Zoom" "E")
				(SavClosEm)
			)
			(SavClosEm)
		)
	)
	(if (and PanLst (= (substr (StpDot AppNam) 1 4) "SUBT"))
		(setq	PanLst	nil)
	)
	(princ)
)

(defun C:LstIDOut ( /	DatLst UniqID MLen Cntr OutPutLst )
	(if BlkDatOutLst
		(setq	MLen		(length BlkDatOutLst)
				Cntr		0
				UniqIDLst	nil
				DupIDLst	nil
				Bubba	(princ (strcat "\nProcessing {" (itoa MLen) "} Devices.\n"))
				Bubba	(Twaddle Cntr MLen)
		)
	)
	(if BlkDatOutLst
		(foreach	DatLst
				BlkDatOutLst
				(setq	UniqID	(cdr (assoc "ID" (cdr (last DatLst))))
						Cntr		(1+ Cntr)
				)
				(if (and UniqID (not UniqIDLst))
					(setq	UniqIDLst	(list UniqID))
					(if (member UniqID UniqIDLst)
						(if OutPutLst
							(setq	OutPutLst	(strcat OutPutLst "\nDevice_ID [" UniqID "] is duplicated!")
									DupIDLst	(cons UniqID DupIDLst)
							)
							(setq	OutPutLst	(strcat "\nDevice_ID [" UniqID "] is duplicated!")
									DupIDLst	(list UniqID)
							)
						)
						(setq	UniqIDLst	(cons UniqID UniqIDLst))
					)
				)
				(Twaddle Cntr MLen)
		)
	)
	(if BlkDatOutLst
		(Twaddle (* -1 Cntr) MLen)
	)
	(if OutPutLst
		(princ OutPutLst)
	)
	(if BlkDatOutLst
		(princ (strcat "\nList [UniqIDLst] complete, [" (itoa (length BlkDatOutLst)) "] records."))
	)
	(princ)
)

(defun C:GetDatOut ( /	ss1 AttWas BlpWas ColWas LtWas LayWas CmdWas EchWas FilWas OsWas
					Cntr MLen )
	(if Bug (princ "\n{C:GetDatOut entered\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			ColWas	(getvar "CECOLOR")
			LtWas	(getvar "CELTYPE")
			LayWas	(getvar "CLAYER")
			CmdWas	(getvar "CMDDIA")
			EchWas	(getvar "CMDECHO")
			FilWas	(getvar "FILEDIA")
			OsWas	(getvar "OSMODE")
	)
	
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
		)
	)
	(if (not Twaddle)
		(LodStage "Utils")
	)
	(command "_.UNDO" "_BE")
	(setq	ss1			(ssget "X"	(list	(cons -4 "<OR")
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
									)
						)
			Cntr			0
			BlkDatOutLst	nil
	)
	(if ss1
		(setq	MLen		(sslength ss1)
				Bubba	(princ (strcat "\nProcessing {" (itoa MLen) "} Devices.\n"))
				Bubba	(Twaddle Cntr MLen)
		)
	)
	(if ss1
		(while (< Cntr MLen)
			(setq	EntDatOut	(EntDatLstR (ssname ss1 Cntr)))
			(if BlkDatOutLst
				(setq	BlkDatOutLst	(cons EntDatOut BlkDatOutLst))
				(setq	BlkDatOutLst	(list EntDatOut))
			)
			(setq	Cntr	(1+ Cntr))
			(Twaddle Cntr MLen)
		)
	)
	(if ss1
		(Twaddle (* -1 Cntr) MLen)
	)
	(if BlkDatOutLst
		(princ (strcat "\nList [BlkDatOutLst] complete, [" (itoa (length BlkDatOutLst)) "] records."))
	)
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CELTYPE" LtWas)
	(setvar "CLAYER" LayWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CMDECHO" EchWas)
	(setvar "FILEDIA" FilWas)
	(setvar "OSMODE" OsWas)
	(if Bug (princ "\nC:GetDatOut exited}\n"))
	(princ)
)

(defun GetNextISS ( /	tfile Bubba sid )		; Get Next Issue Number
	(setq	tfile	(open "S:/Workgroups/APC Power Delivery/Division Mapping/Shared Panels/Data/iss_file.txt" "r")
			sid		(1+ (atoi (read-line tfile)))
			Bubba	(close tfile)
			tfile	(open "S:/Workgroups/APC Power Delivery/Division Mapping/Shared Panels/Data/iss_file.txt" "w")
			Bubba	(write-line (itoa sid) tfile)
			Bubba	(close tfile)
	)
	sid
)

(defun C:IssLst ( / )						; AttWas BlpWas ColWas LtWas LayWas CmdWas EchWas FilWas OsWas
	(if Bug (princ "\n{C:IssLst entered\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			ColWas	(getvar "CECOLOR")
			LtWas	(getvar "CELTYPE")
			LayWas	(getvar "CLAYER")
			CmdWas	(getvar "CMDDIA")
			EchWas	(getvar "CMDECHO")
			FilWas	(getvar "FILEDIA")
			OsWas	(getvar "OSMODE")
	)
	
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
		)
	)
	(command "_.UNDO" "_BE")
	(StartApp "NotePad" "S:/Workgroups/APC Power Delivery/Division Mapping/Shared Panels/Data/FlgIssue.txt")
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CELTYPE" LtWas)
	(setvar "CLAYER" LayWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CMDECHO" EchWas)
	(setvar "FILEDIA" FilWas)
	(setvar "OSMODE" OsWas)
	(if Bug (princ "\nC:IssLst exited}\n"))
)

(defun TypCntr ( / )						; Enumerates Types Digested
	(if BlkDatOutLst
		(setq	BlkCnt	0
				PLdCnt	0
				TxtCnt	0
		)
	)
	(if BlkDatOutLst
		(foreach	EDat
				BlkDatOutLst
				(cond
					((= (car EDat) "POLYLINE")
						(setq	PLdCnt	(1+ PLdCnt))
					)
					((= (car EDat) "TEXT")
						(setq	TxtCnt	(1+ TxtCnt))
					)
					(T
						(setq	BlkCnt	(1+ BlkCnt))
					)
				)
		)
	)
	(if BlkDatOutLst
		(princ (strcat "\nFound:\nInserts:\t" (itoa BlkCnt) "\nPLines:\t" (itoa PLdCnt) "\nText:\t\t" (itoa TxtCnt) "\n"))
	)
	(princ)
)

(defun UpdateData (ent / entity old xda eed )	; Updates EED data (older)
;
	(setq	entity	(entget ent (list "*")))
	(if (assoc -3 entity)
		(setq	old		(cdadr (assoc -3 entity))
				app		(caadr (assoc -3 entity))
				;old		(cdr (cadr eed))
				Mstor	(cdr (nth 7 old))
				AVal		(cdr (nth 9 old))
				BVal		(cdr (nth 10 old))
				NVal		18
		)
		(setq	old		nil)
	)
	(if old
		(cond
			((and (= AVal 7) (member BVal (list 13 14 15)))
				(setq	Mstor	2)
				(if (and AVal Bug) (princ (strcat "\nAval:{" (itoa AVal) "}")))
				(if (and BVal Bug) (princ (strcat "\nBVal:{" (itoa BVal) "}")))
				(if (and Mstor Bug) (princ (strcat "\nMstor:{" (itoa (cdr (nth 7 old))) "-" (itoa Mstor) "}")))
				(setq xda
					(cons -3
						(list
							(cons app
								(list
									(nth  0 old)
									(nth  1 old)
									(nth  2 old)
									(nth  3 old)
									(nth  4 old)
									(nth  5 old)
									(nth  6 old)
									(cons 1070 Mstor)
									(nth  8 old)
									(nth  9 old)
									(cons 1070 NVal)
									(nth 11 old)
									(nth 12 old)
									(nth 13 old)
									(nth 14 old)
									(nth 15 old)
								)
							)
						)
					)
				)
				(entmod (subst xda (assoc -3 entity) entity))
			)
			((and (= AVal 7) (member BVal (list 16 17)))
				(setq	Mstor	3)
				(if (and AVal Bug) (princ (strcat "\nAval:{" (itoa AVal) "}")))
				(if (and BVal Bug) (princ (strcat "\nBVal:{" (itoa BVal) "}")))
				(if (and Mstor Bug) (princ (strcat "\nMstor:{" (itoa (cdr (nth 7 old))) "-" (itoa Mstor) "}")))
				(setq xda
					(cons -3
						(list
							(cons app
								(list
									(nth  0 old)
									(nth  1 old)
									(nth  2 old)
									(nth  3 old)
									(nth  4 old)
									(nth  5 old)
									(nth  6 old)
									(cons 1070 Mstor)
									(nth  8 old)
									(nth  9 old)
									(cons 1070 18)
									(nth 11 old)
									(nth 12 old)
									(nth 13 old)
									(nth 14 old)
									(nth 15 old)
								)
							)
						)
					)
				)
				(entmod (subst xda (assoc -3 entity) entity))
			)
		)
	)
)

(setq	LodVer	"3.0.3a")
