(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " AddURL Loading."))
	(princ "\nAddsPlot AddURL Loading.")
)

(defun AddURL ( / )
;;;	(setq	Bug		T
;;;			OldErr	*error*
;;;			*error*	nil
;;;	)
;;;	(load "h:/div_map/common/utils")
;;;	(setvar "cmdecho" 1)
	(if Bug (princ "\n{AddURL entered\n"))
	(setq	cmdE		(getvar "CMDECHO")
			Cnt			0
	)
	(setvar "cmdecho" 0)
	(if (not SubFence)
		(load "Utils")
	)
	(command "CONVERT" "P" "")
	(setq	ssLWP	(ssget "X"	(list	(cons -4 "<OR")
											(cons 0 "LWPOLYLINE")
											(cons 0 "INSERT")
											(cons 0 "TEXT")
										(cons -4 "OR>")
										(cons -4 "<NOT")
											(cons -4 "<OR")
												(cons 2 "SUB")
												(cons 2 "SUB2")
												(cons 2 "SUBCUST")
												(cons 2 "A074")
												(cons 2 "A075")
												(cons 2 "A076")
											(cons -4 "OR>")
										(cons -4 "NOT>")
								)
					)
			ssLen	(sslength ssLWP)
	)
	(while (< Cnt ssLen)
		(setq	ent	(ssname ssLWP Cnt))
		(StmpURL ent)
		(if (not Bug)
			(Twaddle Cnt ssLen)
		)
		(setq	Cnt	(1+ Cnt))
	)
	(if (not Bug)
		(Twaddle (- 0 Cnt) ssLen)
	)
	(setvar "cmdecho" cmdE)
	
	;	Cleanup
	(if ssLWP	(setq ssLWP nil))
	(gc)

	(if Bug (princ "\nAddURL exited}\n"))
	(princ)
)

(defun AddURL_New ( /	URL Cnt cmdE )
	(if Bug (princ "\n{AddURL entered\n"))
	(setq	cmdE		(getvar "CMDECHO")
			Cnt			0
	)
	(setvar "cmdecho" 0)
	(if (not SubFence)
		(load "Utils")
	)
	(cond
		((= Div "BH")																			;;;	"http:\\\\powerdelivery.southernco.com\\apc\\div\\BD\\sub_single_line\\"
;;;			(setq	_Path-Sub	"..\\sub_single_line\\")		;;;	"file:////gaxgpsw03/pwrdel$/apc/div/BD/sub_single_line/"
;;;			(setq	_Path-Sub	"http:\\\\powerdelivery.southernco.com\\apc\\div\\BD\\sub_single_line\\")
			(setq	_Path-Sub	"file:///S:/Workgroups/APC%20Power%20Delivery/Division%20Mapping/Public/Birmingham/SingleLine/")
		)
		((= Div "E_")
			(setq	_Path-Sub	"http:\\\\powerdelivery.southernco.com\\apc\\div\\ED\\essl\\"				;;;	"file:////gaxgpsw03/pwrdel$/apc/div/ED/essl/"
;;;					_Path-Sub	"http:\\\\powerdelivery.southernco.com\\apc\\div\\ED\\essl\\"				;;;	"file:////gaxgpsw03/pwrdel$/apc/div/ED/essl/"
					_Path-Und	"file:///S:/Workgroups/APC%20Power%20Delivery/Division%20Mapping/Public/Eastern/SingleLine/"				;;;	"U:\apc\div\ED\undgrd"
			)
		)
		((= Div "M_")
			(setq	_Path-Sub	"file:///S:/Workgroups/APC%20Power%20Delivery/Division%20Mapping/Public/Mobile/SingleLine/")
;;;			(setq	_Path-Sub	"http:\\\\powerdelivery.southernco.com\\apc\\div\\mob\\Mapping\\Schematics\\")
;;;			(setq	_Path-Sub	"http:\\\\powerdelivery.southernco.com\\apc\\div\\mob\\sub_single_line\\")
		)
		((= Div "S_")
			(setq	_Path-Sub	"file:///S:/Workgroups/APC%20Power%20Delivery/Division%20Mapping/Public/Montgomery/SingleLine/")	;;;	"file:////gaxgpsw03/pwrdel$/apc/div/SD/MappingData/secthtm/"
;;;			(setq	_Path-Sub	"http:\\\\powerdelivery.southernco.com\\apc\\div\\SD\\MappingData\\secthtm\\")	;;;	"file:////gaxgpsw03/pwrdel$/apc/div/SD/MappingData/secthtm/"
		)
		((= Div "SE")
			(setq	_Path-Sub	"file:///S:/Workgroups/APC%20Power%20Delivery/Division%20Mapping/Public/Montgomery/SingleLine/")			;;;	"file:////gaxgpsw03/pwrdel$/apc/div/SED/secthtm/"
;;;			(setq	_Path-Sub	"http:\\\\powerdelivery.southernco.com\\apc\\div\\SED\\secthtm\\")			;;;	"file:////gaxgpsw03/pwrdel$/apc/div/SED/secthtm/"
		)
		((= Div "W_")
			(setq	_Path-Sub	"file:///S:/Workgroups/APC%20Power%20Delivery/Division%20Mapping/Public/Tuscaloosa/SingleLine/")			;;;	"file:////gaxgpsw03/pwrdel$/apc/div/WD/maps/sub/"
;;;			(setq	_Path-Sub	"http:\\\\powerdelivery.southernco.com\\apc\\div\\WD\\maps\\sub\\")			;;;	"file:////gaxgpsw03/pwrdel$/apc/div/WD/maps/sub/"
		)
		(T
			(setq	_Path-Sub	"file:///S:/Workgroups/APC%20Power%20Delivery/Division%20Mapping/Public/Birmingham/SingleLine/")
		)
	)
	(if (/= 0 (getvar "tilemode"))
		(command "_.tilemode" 0)
	)
	(if (= 1 (getvar "cvport"))
		(command "_.MSpace")
	)
	(if	(setq eset	(ssget "X"	(list	(cons -4 "<OR")		; get subs
											(cons 2 "SUB")
											(cons 2 "SUB2")
											(cons 2 "A074")
											(cons 2 "A075")
											(cons 2 "A076")
										(cons -4 "OR>")
								)
					)
		)
		(progn
			(princ (strcat "\nAddURL is working {" (itoa (sslength Eset)) "} Subs..."))
			(while (setq en (ssname eset Cnt))							; while I have a substation...
				(setq	b	(entget en (list "PE_URL"))
						orl	(assoc -3 b)
				)
				(if (or (not orl) (= Div "M_"))
					(if (setq URL (FormURL en))							; form an URL
						(command "_.AttachURL" "" en "" URL)				; attach to symbol
					)
				)
				(setq	Cnt	(1+ Cnt))
				(if Bug (princ (strcat "\nCnt = " (itoa Cnt))))			; next substation
			)
		)
	)
	(setvar "cmdecho" cmdE)
		;	Cleanup
	(if eset 
		(progn 
			(setq eset nil)
			(gc)
		)
	)
	(if Bug (princ "\nAddURL exited}\n"))
	(princ)
)

(defun AddURL_Old ( /	URL Cnt cmdE )
	(if Bug (princ "\n{AddURL entered\n"))
	(setq	cmdE		(getvar "CMDECHO")
			Cnt			0
	)
	(setvar "cmdecho" 0)
	(if (not SubFence)
		(load "Utils")
	)
	(cond
		((= Div "BH")																			;;;	"http:\\\\powerdelivery.southernco.com\\apc\\div\\BD\\sub_single_line\\"
;;;			(setq	_Path-Sub	"..\\sub_single_line\\")		;;;	"file:////gaxgpsw03/pwrdel$/apc/div/BD/sub_single_line/"
;;;			(setq	_Path-Sub	"http:\\\\powerdelivery.southernco.com\\apc\\div\\BD\\sub_single_line\\")
			(setq	_Path-Sub	"file:///S:/Workgroups/APC%20Power%20Delivery/Division%20Mapping/Public/Birmingham/SingleLine/")
		)
		((= Div "E_")
			(setq	_Path-Sub	"http:\\\\powerdelivery.southernco.com\\apc\\div\\ED\\essl\\"				;;;	"file:////gaxgpsw03/pwrdel$/apc/div/ED/essl/"
;;;					_Path-Sub	"http:\\\\powerdelivery.southernco.com\\apc\\div\\ED\\essl\\"				;;;	"file:////gaxgpsw03/pwrdel$/apc/div/ED/essl/"
					_Path-Und	"file:///S:/Workgroups/APC%20Power%20Delivery/Division%20Mapping/Public/Eastern/SingleLine/"				;;;	"U:\apc\div\ED\undgrd"
			)
		)
		((= Div "M_")
			(setq	_Path-Sub	"file:///S:/Workgroups/APC%20Power%20Delivery/Division%20Mapping/Public/Mobile/SingleLine/")
;;;			(setq	_Path-Sub	"http:\\\\powerdelivery.southernco.com\\apc\\div\\mob\\Mapping\\Schematics\\")
;;;			(setq	_Path-Sub	"http:\\\\powerdelivery.southernco.com\\apc\\div\\mob\\sub_single_line\\")
		)
		((= Div "S_")
			(setq	_Path-Sub	"file:///S:/Workgroups/APC%20Power%20Delivery/Division%20Mapping/Public/Montgomery/SingleLine/")	;;;	"file:////gaxgpsw03/pwrdel$/apc/div/SD/MappingData/secthtm/"
;;;			(setq	_Path-Sub	"http:\\\\powerdelivery.southernco.com\\apc\\div\\SD\\MappingData\\secthtm\\")	;;;	"file:////gaxgpsw03/pwrdel$/apc/div/SD/MappingData/secthtm/"
		)
		((= Div "SE")
			(setq	_Path-Sub	"file:///S:/Workgroups/APC%20Power%20Delivery/Division%20Mapping/Public/Montgomery/SingleLine/")			;;;	"file:////gaxgpsw03/pwrdel$/apc/div/SED/secthtm/"
;;;			(setq	_Path-Sub	"http:\\\\powerdelivery.southernco.com\\apc\\div\\SED\\secthtm\\")			;;;	"file:////gaxgpsw03/pwrdel$/apc/div/SED/secthtm/"
		)
		((= Div "W_")
			(setq	_Path-Sub	"file:///S:/Workgroups/APC%20Power%20Delivery/Division%20Mapping/Public/Tuscaloosa/SingleLine/")			;;;	"file:////gaxgpsw03/pwrdel$/apc/div/WD/maps/sub/"
;;;			(setq	_Path-Sub	"http:\\\\powerdelivery.southernco.com\\apc\\div\\WD\\maps\\sub\\")			;;;	"file:////gaxgpsw03/pwrdel$/apc/div/WD/maps/sub/"
		)
		(T
			(setq	_Path-Sub	"file:///S:/Workgroups/APC%20Power%20Delivery/Division%20Mapping/Public/Birmingham/SingleLine/")
		)
	)
	(if (/= 0 (getvar "tilemode"))
		(command "_.tilemode" 0)
	)
	(if (= 1 (getvar "cvport"))
		(command "_.MSpace")
	)
	(if	(setq eset	(ssget "X"	(list	(cons -4 "<OR")		; get subs
											(cons 2 "SUB")
											(cons 2 "SUB2")
											(cons 2 "A074")
											(cons 2 "A075")
											(cons 2 "A076")
										(cons -4 "OR>")
								)
					)
		)
		(progn
			(if Bug (princ (strcat "\n{Bug:Got [" (itoa (sslength eset)) "] Sub(2) Blocks...\n")))
			(while (setq en (ssname eset Cnt))							; while I have a substation...
				(if (setq URL (FormURL en))							; form an URL
					(command "_.AttachURL" "" en "" URL)				; attach to symbol
				)
				(setq	Cnt	(1+ Cnt))
				(if Bug (princ (strcat "\nCnt = " (itoa Cnt))))			; next substation
			)
		)
	)
	(setvar "cmdecho" cmdE)

	;	Cleanup
	(if eset	(setq eset nil))
	(gc)

	(if Bug (princ "\nAddURL exited}\n"))
	(princ)
)

(defun FormURL ( EntNam /	url fdrcode
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

(defun GetCode ( el /	Cnt blk xpt ypt lay ang
					fud ss2 ent ent1 code )
	(if Bug (princ "\n{GetCode entered\n"))
	(setq	blk	(cdr (assoc 2 el))
			xpt	(rtos (cadr (assoc 10 el)) 2 0)					; insert of block
			ypt	(rtos (caddr (assoc 10 el)) 2 0)
			lay	(cdr (assoc 8 el))								; layer of block
			angr	(+ (cdr (assoc 50 el)) pi)						; rotation angle in radians + 180
			fud	(* (/ (cdr (assoc 42 el)) 38.1)  1.1)				; a fudge factor based on scale of symbol
			Cnt	0
			flag	nil
	)
	(if (wcmatch (substr lay 1 2) "??")
		(setq	code		(substr lay 1 2))
		(if (setq ss2 (ssget "f" (SubFence (atoi xpt) (atoi ypt) angr fud)))	; select based on a fence around sub block
			(while (and (setq ent (ssname ss2 Cnt)) (not flag))			; loop till it runs out of entities
				(setq	entl		(entget ent))
				(if (= (substr (cdr (assoc 8 entl)) 5 2) "ck")			; must get a circuit
					(setq	code	(substr (cdr (assoc 8 entl)) 1 2)		; get the sub code from the circuit
							flag	T
					)
				)
				(setq	Cnt	(1+ Cnt))
			)
		)
	)
	(if (and code Bug)
		(princ (strcat "\nGetCode got:{" code "}\n"))
		(if Bug (princ (strcat "\nGot No Code!{" lay "}\n")))
	)
	
	;	Cleanup
	(if ss2	(setq ss2 nil))
	(gc)
	
	(if Bug (princ "\nGetCode exited}\n"))
	code
)

(defun GetSubDwg ( acode /	fp1 _STR _LST
						index dwgname lst_codes lst_dwgs )
	(if Bug (princ "\n{GetSubDwg entered\n"))
	(if (setq fp1 (open (strcat _Path-User "SubsDwg.txt") "r"))
		(progn
			(setq	lst_codes	nil
					lst_dwgs	nil
			)
			(while (setq _STR (read-line fp1))
				(setq	_LST		(read (strcat "(" _STR ")")))
				(if (>= (length _LST) 2)
					(setq	lst_codes	(append lst_codes (list (nth 0 _LST)))
							lst_dwgs	(append lst_dwgs (list (nth 1 _LST)))
					)
				)
			)
			(close fp1)
			(setq	index	(- (length lst_codes) (length (member acode lst_codes)))
					dwgname	(nth index lst_dwgs)	;sub code has to be in the list 
			)
		)
		(alert "ERROR Opening: " (strcat _Path-User "SubsDwg.txt"))
	)
	(if (and dwgname Bug)
		(princ (strcat "\nGetSubDwg got:{" dwgname "}\n"))
		(if Bug (princ "\nGot No SubDwg!\n"))
	)
	(if Bug (princ "\nGetSubDwg exited}\n"))
	dwgname
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(AddURL_Old)
	(setq	LodVer	"2.0.2a")
)
(setq	LodVer	"3.0.0a")