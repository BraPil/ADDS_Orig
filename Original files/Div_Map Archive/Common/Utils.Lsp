(if AppNam								; Code Version Indicator {12802 Lines of Code}
	(princ (strcat "\n" AppNam " Utils Loading."))
	(princ "\nCadet 2.1 Utils Loading.")
)

(defun C:InIER ( /	AttWas					;Inserts an Area of Responsibility block
					SclFct BlpWas CmdWas ColWas EchWas ExWas FilWas LayWas LtWas OsWas TmdWas )
	(if Bug (princ "\n{ C:InIER entered}\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			CmdWas	(getvar "CMDDIA")
			ColWas	(getvar "CECOLOR")
			EchWas	(getvar "CMDECHO")
			ExWas	(getvar "EXPERT")
			FilWas	(getvar "FILEDIA")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			TmdWas	(getvar "TILEMODE")
	)
	
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 1)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 3)
		)
	)
	(command "_.UNDO" "_BE")
	(if (= (substr (StpDot AppNam) 1 4) "SUBT")
		(setq	SclFct 0.45)
		(setq	SclFct 0.15)
	)
	(setq	Pnt01	nil
			Aor01	nil
	)
	(setq	Pnt01	(getpoint "\nSelect point for IER Indicator: "))
	(initget "1 2 3 4")
	(setq	Aor01	(getkword "\nEnter the IER Value [1 2 3 4]: "))
	(if (and Pnt01 Aor01)
		(command "_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" "" "_.Insert" (strcat _Path-Sym "A055.dwg") Pnt01 (* SclFct sf) (* SclFct sf) "0" Aor01)
	)
	(c:HdFl)
;;;	(if Aor01
;;;		(if (> (strlen Aor01) 0)
;;;			(command "_.Text" "S" "AOR" "@1.25,-13" "8" "0" Aor01)
;;;		)
;;;	)
;;;	(setq	Aor02	(getstring T "\nEnter the IER Rating (or Enter to skip:) "))
;;;	(if Aor02
;;;		(if (> (strlen Aor02) 0)
;;;			(command "_.Text" "S" "AOR" "@0,-13" "8" "0" Aor02)
;;;		)
;;;	)
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CMDECHO" EchWas)
	(setvar "EXPERT" ExWas)
	(setvar "FILEDIA" FilWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "TILEMODE" TmdWas)
	(if Bug (princ "\n{ C:InIER exited}\n"))
	(princ)
)


(defun C:SavURD ( / fp fn fo )				;Saves file in all three locations
	(setq	fp		(getvar "dwgprefix")
			fn		(getvar "dwgname")
			FileN	"DOSLib17.arx"
	)
	(if (not RevOrd) (load "C:\\Div_Map\\Common\\Acad.Lsp"))
	(if (not Twizzle) (load "C:\\Div_Map\\Common\\Utils.Lsp"))
	(if (findfile FileN)
		(if (not (member (strcase FileN T) (arx)))
			(arxload (findfile FileN))
		)
	)
	(if (eq (strcase (substr fp 1 2)) "S:")
		(cond	
				((eq (strcase (substr fp 19 5)) "BIRMI")
					(setq	fo	(strcat AltPrmRootDwg "Birmingham\\UnderGround\\"))
				)
				((eq (strcase (substr fp 19 5)) "EASTE")
					(setq	fo	(strcat AltPrmRootDwg "Eastern\\UnderGround\\"))
				)
				((eq (strcase (substr fp 19 5)) "MOBIL")
					(setq	fo	(strcat AltPrmRootDwg "Mobile\\UnderGround\\"))
				)
				((eq (strcase (substr fp 19 5)) "SOUTH")
					(setq	fo	(strcat AltPrmRootDwg "Southern\\UnderGround\\"))
				)
				((eq (strcase (substr fp 19 5)) "WESTE")
					(setq	fo	(strcat AltPrmRootDwg "Western\\UnderGround\\"))
				)
		)
		(cond	
				((eq (strcase (substr fp 12 5)) "BIRMI")
					(setq	fo	"S:\\Workgroups\\APC Birmingham Division\\Division Mapping\\UnderGround\\")
				)
				((eq (strcase (substr fp 12 5)) "EASTE")
					(setq	fo	"S:\\Workgroups\\APC Eastern Division\\Division Mapping\\UnderGround\\")
				)
				((eq (strcase (substr fp 12 5)) "MOBIL")
					(setq	fo	"S:\\Workgroups\\APC Mobile Division\\Division Mapping\\UnderGround\\")
				)
				((eq (strcase (substr fp 12 5)) "SOUTH")
					(setq	fo	"S:\\Workgroups\\APC Southern Division\\Division Mapping\\UnderGround\\")
				)
				((eq (strcase (substr fp 12 5)) "WESTE")
					(setq	fo	"S:\\Workgroups\\APC Western Division\\Division Mapping\\UnderGround\\")
				)
		)
	)
	(cond	((eq (strcase (substr fp 1 2)) "M:")
				(command "_.QSave")
				(dos_copy (strcat fp fn) (strcat "N:" (substr fp 3) fn))
				(if fo (dos_copy (strcat fp fn) (strcat fo fn)))
				(command "_.QSave")
			)
			((eq (strcase (substr fp 1 2)) "N:")
				(command "_.QSave")
				(dos_copy (strcat fp fn) (strcat "M:" (substr fp 3) fn))
				(if fo (dos_copy (strcat fp fn) (strcat fo fn)))
				(command "_.QSave")
			)
			((eq (strcase (substr fp 1 2)) "S:")
				(command "_.QSave")
				(if fo (dos_copy (strcat fp fn) (strcat fo fn)))
				(dos_copy (strcat fp fn) (strcat "N:" (substr fo 3) fn))
				(command "_.QSave")
			)
	)
	(princ)
)

(defun C:PdfLay ( / )
	(setq	OutNam	(strcat "C:\\Cadet\\" "PdfWrk.SQL")
			FilNam	(strcat "C:\\Cadet\\" "PdfWrk.Txt")
			DwgNam	(strcase (getvar "DWGNAME"))
			Bug	T
			FileN	"DOSLib17.arx"
	)
	(if(> (strlen dwgnam) 7)
		(progn
			(vl-load-com)
			(vlax-for item
			  (vla-get-Layouts
			     (vla-get-ActiveDocument
			       (vlax-get-acad-object)
			     )  
			  )
			  (if (not (eq (vla-get-Name item) "Model"))
			    (vla-delete item)
			)
			)
		)
	)
	(if (not RevOrd) (load "C:\\Div_Map\\Common\\Acad.Lsp"))
	(if (not Twizzle) (load "C:\\Div_Map\\Common\\Utils.Lsp"))
	(if (findfile FileN)
		(if (not (member (strcase FileN T) (arx)))
			(arxload (findfile FileN))
		)
	)
	(if OutNam
		(if (findfile OutNam)
			(dos_delete OutNam)
		)
	)
	(if (and OutNam FilNam)
		(setq	
				sSql		"set time on;"
				sSql		(strcat sSql "\nset serveroutput on size 100000 pagesize 80 linesize 250;")
				sSql		(strcat sSql "\nset heading off;")
				sSql		(strcat sSql "\nnumpage none;")
				sSql		(strcat sSql "\nalter session set nls_date_format = 'YYYY-MM-DD-HH24:MI.SS';")
				sSql		(strcat sSql "\nclear columns;")
				sSql		(strcat sSql "\nspool " FilNam)
				sSql		(strcat sSql "\nSELECT '\"' || urp.urdtag || '\"' FROM addsdb.urd_panel urp , addsdb.targetpage tp , addsdb.targetpage_2_urd_panel t2u , addsdb.objdwgfile odf WHERE (urp.dwgfile_id = t2u.urdpanel_id) AND (t2u.targetpage_id = tp.targetpage_id) AND (urp.dwgfile_id = odf.dwgfile_id) AND (tp.statusflag = 2) AND (upper(trim(odf.filename)) = '" DwgNam "') order by urp.urdtag;")
				sSql		(strcat sSql "\nspool off")
				sSql		(strcat sSql "\nquit")
				FN		(open OutNam "w")
				Bubba	(write-line sSql FN)
				Bubba	(close FN)
		)
	)

	(if FilNam
		(if (findfile FilNam)
			(dos_delete FilNam)
		)
	)
	(if OutNam
		(if (findfile OutNam)
			(dos_exewait (strcat "C:\\Southern\\Oracle10\\bin\\sqlplusw.exe GEWILYMS/GEWILYMS@DEMBAP1 @" OutNam) 3)  ; was dembap1  CADET command
		)
	)
	(if FilNam
		(if (findfile FilNam)
			(setq	MyPDFLst	(GetFilAsLst (findfile FilNam)))
		)
	)
	(if MyPDFLst
		(if (eq 'LIST (type (car (last MyPDFLst))))
			(PDFLay (car (last MyPDFLst)))
			(if (eq 'STR (type (car (last MyPDFLst))))
				(PDFLay (car (last MyPDFLst)))
			)
		)
	)
	(princ)
)

(defun C:BMLay ( /	OsmWas FilWas Pt1 Pt2 Pt3 )	;Moves content from PaperSpace to ModelSpace
	(if Bug (princ "\n{ C:BMLay entered"))
	(setq	OsmWas	(getvar "OSMODE")
			FilWas	(getvar "FILEDIA")
	)
	(if (/= (getvar "OSMODE") 67) (setvar "OSMODE" 67))
	(setq	Bubba	(command "_.Zoom" "A" "_.Zoom" "0.8x")
			Pt1		(getpoint "\nInsertion Point? ")
			Pt2		(getpoint "\nSelection Set? ")
			Pt3		(getpoint "\nOther Corner? " Pt2)
	)
	(command "_.Block" "temp1" Pt1 "C" Pt2 Pt3 "")
	(SetCurrLayout "Model")
	(command "_.Insert" "*temp1" "0,0" "1" "0" "_.Zoom" "E")
	(if (/= (getvar "OSMODE") OsmWas) (setvar "OSMODE" OsmWas))
	(princ)
)

(defun C:DefWb ( /	CmdWas FilWas ssO ssI		;Wblocks out the contents in a default manner
				Vctr Vsiz Ssiz Pt1 Pt2 NewPth Ipnt )
	(if Bug (princ "\n{ DefWb entered"))
	(setq	CmdWas	(getvar "CMDDIA")
			FilWas	(getvar "FILEDIA")
	)
	(if (/= (getvar "CMDDIA") 0) (setvar "CMDDIA" 0))
	(if (/= (getvar "FILEDIA") 0) (setvar "FILEDIA" 0))
	(if (/= (getvar "NOMUTT") 1) (setvar "NOMUTT" 1))
	(if (/= (getvar "EXPERT") 5) (setvar "EXPERT" 5))
	(setq ssO (ssget "X" (list (cons -4 ">=") (cons 67 1))))
	(setq ssI (ssget "X" ))
	(if ssO
		(if (> (sslength ssO) (/ (sslength ssI) 2.0))
			(progn
				(SetCurrLayout (cdr (assoc 410 (entget (ssname ssO 0)))))
				(setq	NewPth	(strcase (getvar "DWGNAME"))
						NewPth	(strcat "C:\\Cadet\\" (substr NewPth 1 1) (strcase (substr NewPth 2) T))
						Bubba	(command "_.Zoom" "E" "_.Zoom" "0.9x")
						Vctr		(getvar "viewctr")
						Vsiz		(getvar "viewsize")
						Ssiz		(getvar "screensize")
						Pt1		(list (- (car Vctr) (* (/ (car Ssiz) (cadr Ssiz)) (/ Vsiz 2.0))) (- (cadr Vctr) (/ Vsiz 2.0)))
						Pt2		(list (+ (car Vctr) (* (/ (car Ssiz) (cadr Ssiz)) (/ Vsiz 2.0))) (+ (cadr Vctr) (/ Vsiz 2.0)))
				)
				(command "_.Wblock" NewPth "" Pt1 "C" Pt1 Pt2 "" "N") 
			)
			(progn
				(SetCurrLayout "Model")
				(setq	NewPth	(strcase (getvar "DWGNAME"))
						NewPth	(strcat "C:\\Cadet\\" (substr NewPth 1 1) (strcase (substr NewPth 2) T))
						Bubba	(command "_.Zoom" "E" "_.Zoom" "0.9x")
						Ipnt		(getvar "insbase")
						Vctr		(getvar "viewctr")
						Vsiz		(getvar "viewsize")
						Ssiz		(getvar "screensize")
						Pt1		(list (- (car Vctr) (* (/ (car Ssiz) (cadr Ssiz)) (/ Vsiz 2.0))) (- (cadr Vctr) (/ Vsiz 2.0)))
						Pt2		(list (+ (car Vctr) (* (/ (car Ssiz) (cadr Ssiz)) (/ Vsiz 2.0))) (+ (cadr Vctr) (/ Vsiz 2.0)))
				)
				(command "_.Wblock" NewPth "" Ipnt "C" Pt1 Pt2 "" "N") 
			)
		)
		(progn
			(SetCurrLayout "Model")
			(setq	NewPth	(strcase (getvar "DWGNAME"))
					NewPth	(strcat "C:\\Cadet\\" (substr NewPth 1 1) (strcase (substr NewPth 2) T))
					Bubba	(command "_.Zoom" "E" "_.Zoom" "0.9x")
					Ipnt		(getvar "insbase")
					Vctr		(getvar "viewctr")
					Vsiz		(getvar "viewsize")
					Ssiz		(getvar "screensize")
					Pt1		(list (- (car Vctr) (* (/ (car Ssiz) (cadr Ssiz)) (/ Vsiz 2.0))) (- (cadr Vctr) (/ Vsiz 2.0)))
					Pt2		(list (+ (car Vctr) (* (/ (car Ssiz) (cadr Ssiz)) (/ Vsiz 2.0))) (+ (cadr Vctr) (/ Vsiz 2.0)))
			)
			(command "_.Wblock" NewPth "" Ipnt "C" Pt1 Pt2 "" "N") 
		)
	)
	(if (/= (getvar "CMDDIA") CmdWas) (setvar "CMDDIA" CmdWas))
	(if (/= (getvar "FILEDIA") FilWas) (setvar "FILEDIA" FilWas))
	(princ)
)

(defun PDFPlotMeds ( CfgNam / )
	(vl-load-com)
	(setq acadObject (vlax-get-acad-object)
		 activeDoc  (vla-get-activedocument acadObject)
	)
	(vla-Regen activeDoc acAllViewports)
	(GetPlotDeviceInfo CfgNam)
	(if CurPlotDevLst		
		(foreach	PltInf  CurPlotDevLst
			(cond
				((and (= (rtos (nth 3 PltInf) 2 1) "1117.6") (= (rtos (nth 4 PltInf) 2 1) "863.6"))	;ANSI E 34 x 44
						(setq	cNamePdfL  (nth 1 PltInf))
				)
				((and (= (rtos (nth 3 PltInf) 2 1) "863.6") (= (rtos (nth 4 PltInf) 2 1) "1117.6"))	;ANSI E 34 x 44
						(setq	cNamePdfP  (nth 1 PltInf))
				)
			)
		)
	)
	(list cNamePdfP cNamePdfL)
)

(defun PdfLay ( ShtNam /	WellDid PltDev )
	(setq	AttWas	(getvar "ATTREQ"))
	(if (/= (getvar "ATTREQ") 1) (setvar "ATTREQ" 1))
	(if (/= (getvar "REGENMODE") 1) (setvar "REGENMODE" 1))
	(setq	Bug	T
			FileN	"DOSLib17.arx"
	)
	(if (findfile FileN)
		(if (not (member (strcase FileN T) (arx)))
			(arxload (findfile FileN))
		)
	)
	;	Update text styles to True-Type fonts
	(StyMChkE)
	(C:ChgTxtStyles)
	
	(if (not RevOrd) (load "C:\\Div_Map\\Common\\Acad.Lsp"))
	(if (not GetPlotDeviceInfo) (load "C:\\Div_Map\\Common\\Plot.Lsp"))
	(if (not (member ShtNam (GetLayoutNames)))
		(progn
			(SetCurrLayout "Model")
			;	Thaw, turn on, unlock all layers. Set the current layer to 0, 
			;	make layer Vport and set it as current layer set color to magenta
			;	Set plotting preference to No, Set the current layer to 0, then zoom to extents
			(command "_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" "M" "Vport" "C" "6" "" "P" "N" "" "S" "0" "" "_.Zoom" "E")
			(setq 	EdgeMax (getvar "EXTMAX")
		 			EdgeMin (getvar "EXTMIN")
					DeltaX  (- (car EdgeMax) (car EdgeMin))
					DeltaY  (- (cadr EdgeMax) (cadr EdgeMin))
					insertPt (list (+ (car EdgeMin) (* DeltaX 0.9)) (+ (cadr EdgeMin) (* Deltay 0.2)))
			)
			(setq	Vctr		(getvar "viewctr")		;center of current view port in model space
					Vsiz		(getvar "viewsize")		;height of current view port
					Ssiz		(getvar "screensize")	;current viewport in pixels (X & Y)
					;	Calculates lower left coordinates in drawing units by using the aspect ratio as Pt1
					Pt1		(list (- (car Vctr) (* (/ (car Ssiz) (cadr Ssiz)) (/ Vsiz 2.0))) (- (cadr Vctr) (/ Vsiz 2.0)))
					Pt2		(list (+ (car Vctr) (* (/ (car Ssiz) (cadr Ssiz)) (/ Vsiz 2.0))) (+ (cadr Vctr) (/ Vsiz 2.0)))
					Ds1		(distance Pt1 Pt2)
					Pt3		(list (- 	(+ (car Vctr) (* (/ (car Ssiz) (cadr Ssiz)) (/ Vsiz 2.0))) 	; Pt2 X
									(* 0.125 Ds1)) 
								 (+ (- (cadr Vctr) (/ Vsiz 2.0)) (* 0.125 Ds1)))				; Pt1 Y
			)
			(StyMChkE)
			(C:ChgTxtStyles)
				(progn
					;(princ "\nTesting for A081")
					(setq BlkTest nil)
						(if	(setq ss (ssget "X" (list (cons 2 "A081"))))
							(setq BlkTest "A081 Exists")
							(command "_.Insert" "C:\\Div_Map\\Cadet\\Sym\\A081.dwg" Pt3 (* 0.03125 Ds1) (* 0.03125 Ds1) 0.0 ShtNam "")
						)					
				)

			(command "_.Layer" "S" "Vport" "F" "MASK,????FL????*" "P" "N" "Mask,Vport" "" "_.Zoom" "E")
			(setq tester 0)
				(foreach layoutname (layoutlist)(if (= (strcase layoutname) (strcase ShtNam)) (setq tester 1)))
			(if ShtNam
				(if (= tester 0)
					(setq	StyNam	"Acad_4.ctb"
							CfgNam	"ADOBE PDF.pc3"
							MedNam	(cadr (PDFPlotMeds CfgNam))
							_Path-PDF	"C:\\Cadet\\in\\"				
					          WellDid (addMyLayout(list ShtNam StyNam CfgNam MedNam 1 1 0 0 0))
							Bubba	(command "_.MSpace" "_.Zoom" "E" "_.PSpace" )		;"_.PSpace"
							Bubba	(command "PSLTSCALE" "0" "REGENALL")
							Bubba	0
					)
					(setq	StyNam	"Acad_4.ctb"
							CfgNam	"ADOBE PDF.pc3"
							MedNam	(cadr (PDFPlotMeds CfgNam))
							_Path-PDF	"C:\\Cadet\\in\\"				
					          Bubba	(command "_.MSpace" "_.Zoom" "E" "_.PSpace" )		;"_.PSpace"
							Bubba	(command "PSLTSCALE" "0" "REGENALL")
							Bubba	0
					)
				)
			)
			(if (= Bubba 0)
				(MakPDF ShtNam _Path-PDF CfgNam MedNam StyNam)
			)
			(DeleteLayout "Layout1")
		)
		(if ShtNam
			(setq	WellDid	(SetCurrLayout ShtNam)
					Bubba	(command "_.Layer" "P" "N" "Mask,Vport" "")
					StyNam	"Acad_4.ctb"
					CfgNam	"ADOBE PDF.pc3"
					MedNam	"User269" ; (cadr (PDFPlotMeds CfgNam)) 
					_Path-PDF	"C:\\Cadet\\in\\"
					WellDid	(MakPDF ShtNam _Path-PDF CfgNam MedNam StyNam)
					Bubba	0
			)
		)
	)
	(if (/= (getvar "ATTREQ") AttWas) (setvar "ATTREQ" AttWas))
	(princ)
)

(defun MakPDF ( ShtNam _Path-PDF CfgNam MedNam StyNam / )
	(if bug
		(progn
			(princ "\nUtils.Lsp!MakPDF")
			(princ "\nParameters:") 
			(princ "\n    ShtNam ")(prin1 ShtNam)
			(princ "\n    _Path-PDF: ")(prin1 _Path-PDF)
			(princ "\n    CfgNam: ")(prin1 CfgNam)
			(princ "\n    MedNam: ")(prin1 MedNam)
			(princ "\n    StyNam: ")(prin1 StyNam)(princ "\n")
		)
	)
	
	(if (= (strcase CfgNam) "ADOBE PDF.PC3")
		(if (dos_filep "C:\\Program Files\\Adobe\\Acrobat 10.0\\Acrobat\\acrodist.exe")
			(startapp "C:\\Program Files\\Adobe\\Acrobat 10.0\\Acrobat\\acrodist")
			(if (dos_filep "C:\\Program Files\\Adobe\\Acrobat 9.0\\Acrobat\\acrodist.exe")
				(startapp "C:\\Program Files\\Adobe\\Acrobat 9.0\\Acrobat\\acrodist")
				(startapp "C:\\Program Files\\Adobe\\Acrobat 8.0\\Acrobat\\acrodist")
			)
		)
	)

	(if (= Div "M_")
		(progn
			(command "_.Layer" "T" "MASK,????FL????*" "P" "P" "Mask" "" "_.Zoom" "E")
			
			(vl-load-com)
			(setq acadObject (vlax-get-acad-object)
				 activeDoc  (vla-get-activedocument acadObject)
			)
			(if (null acadObject) 	(alert "ERROR: AcadObject not created correctly..!"))
			(if activeDoc
				(progn 
					(if Bug (princ "\n{MakPDF about to setup layout}\n"))
					(setq actLayout  (vla-get-activelayout activeDoc))
					(if actLayout
						(progn
							(setq desc "Adobe PDF.pc3")
							(if (/= 	(vla-get-ConfigName actLayout) "Adobe PDF.pc3")
								(vla-put-ConfigName actLayout "Adobe PDF.pc3")
							)
							;	Setup plotting settings
							(if Bug (princ "\n{MakPDF setting up rotation and paper selection\n"))

							;	Check to see if district area map if so use large paper size for Adobe
							(vla-put-CanonicalMediaName actLayout MedNam)

							(vla-put-PlotRotation 		actLayout ac0degrees)
							
							(vla-put-PaperUnits 		actLayout acInches)
							(vla-put-PlotType 			actLayout acExtents)			; acExtents acDisplay acLayout
							(vla-put-StandardScale		actLayout acScaleToFit)
							(vla-put-CenterPlot 		actLayout :vlax-true)
							(vla-put-PlotWithPlotStyles	actLayout :vlax-true)	   ;true
							
							;	Sets Style Sheet
							(setq colorTabFilePath (strcat _Path-LUT "Plot Styles\\acad_m.ctb"))  ; was read from memory due to what was thought as file locking problem (vl-bb-ref 'gColorTabFile))
							(vla-put-StyleSheet 		actLayout colorTabFilePath)
							
							(vla-put-PlotWithLineweights actLayout :vlax-false)
						)
						(alert "ERROR: ActLayout not created correctly..!")
					)
					
					;	Plot the objects in model space
					(setq 	plotObject (vla-get-Plot activeDoc))
					(if plotObject
						(progn
							(if Bug (princ "\n{MakPDF about to plot}\n"))
							(vla-purgeall activeDoc)
					  ;		(purgeappid)
							(gc)
							(while (eq 1 (logand 1 (getvar "CMDACTIVE")))	; cause AutoCAD to wait until last command is finished.
								(command pause)
							)
							(if Bug (princ "\n{MakPDF about to plot after wait for last command 1}\n"))
							(setq result (vla-PlotToFile plotObject (strcat "C:\\Addsplot\\in\\" ShtNam ".ps")desc))		; causes Regeneration of model
							(if Bug (princ "\n{MakPDF about to plot after wait for last command 1a}\n"))
							(while (eq 1 (logand 1 (getvar "CMDACTIVE")))	; cause AutoCAD to wait until plot is finished.
								(command pause)
							)
							(if Bug (princ "\n{MakPDF about to plot after wait for last command 2}\n"))
							(if (= result :vlax-true)
								(progn
									(princ "\nPlot successful; please wait for the process to finish before viewing the file.")
									;;; 	Check to see if Single plot definition if so copy pdf file to S drive
								)
								(progn
									(if Bug (princ "\n{MakPDF ERROR Plot Failed..!"))
									(alert (strcat "ERROR: " pldname " Plot failed..!"))
								)
							)
						)
						(alert "ERROR: PlotObject not created correctly..!")
					)
				)
				(alert "ERROR: ActiveDoc not created correctly..!")
			)
			
			(command "_.Layer" "F" "MASK,????FL????*" "P" "N" "Mask,Vport" "")
			
			;	Release and freeup memory for AutoCAD objects
			(if (and plotObject (null (vlax-object-released-p plotObject)))
				(vlax-release-object plotObject)
			)
			(if (and actLayout (null (vlax-object-released-p actLayout)))
				(vlax-release-object actLayout)
			)
			(if (and activeDoc (null (vlax-object-released-p activeDoc)))
				(vlax-release-object activeDoc)
			)
			(if (and acadObject (null (vlax-object-released-p acadObject)))
				(vlax-release-object acadObject)
			)
			(setq	acadObject 	nil
					activeDoc		nil
					actLayout		nil
					plotObject	nil
			)
			(gc)
		)
		(progn
			(command 	"_.Plot"
				""								;Detailed plot configuration [Yes/No] <No>:
				ShtNam							;Enter a layout name or [?] <current>:
				""								;Enter a page setup name < >:
				CfgNam							;Enter an output device name or [?] <current>:
				"Y"								;Write the plot to a file [Yes/No] <current>:
				(strcat _Path-PDF ShtNam)			;Enter file name: <dwgname-layoutname. plt>:
				"N"								;Save changes to layout [Yes/No] <No>:
				"Y"								;Proceed with Plot [Yes/No] <Y>:
			)
		)
	)
	(princ)
)

(defun StyMChkE ( /	ssMTx CntR CntM entM		;Makes all MText use Arial Bold ttf
				strM strM3 )
	(setq	ssMTx	(ssget "X" (list (cons 0 "MTEXT")))
			CntR		0
			CntM		0
	)
	(if ssMTx (princ (strcat "\nFound [" (itoa (sslength ssMTx)) "] MText entities")))
	(if ssMTx
		(while (< CntR (sslength ssMTx))
			(if (not Bug) (Twizzle CntR))
			(setq	entM	(entget (ssname ssMTx CntR) (list "*"))
					strM	(cdr (assoc 1 entM))
			)
			(if (assoc 3 entM)
				(setq	strM3	(cdr (assoc 3 entM)))
				(setq	strM3	nil)
			)
			(if (assoc 71 entM)
				(if (/= (cdr (assoc 71 entM)) 1)
					(setq	entM		(subst (cons 71 1) (assoc 3 entM) entM))
				)
			)
			(if (assoc 72 entM)
				(if (/= (cdr (assoc 72 entM)) 1)
					(setq	entM		(subst (cons 72 1) (assoc 3 entM) entM))
				)
			)
			(if (wcmatch (strcase strM t) "\\f*;*")
				(setq	strM		(strcat "\\fArial|b1|i0|c0|p34;" (substr strM (1+ (InStr strM 59))))
						entM		(subst (cons 1 strM) (assoc 1 entM) entM)
						entM		(if (assoc 7 entM)
									(subst (cons 7 "STANDARD") (assoc 7 entM) entM)
								)
						bubba	(entmod entM)
						CntM		(1+ CntM)
				)
			)
			(if strM3
				(if (wcmatch (strcase strM3 t) "\\f*;*")
					(setq	strM3		(strcat "\\fArial|b1|i0|c0|p34;" (substr strM3 (1+ (InStr strM3 59))))
							entM		(subst (cons 3 strM3) (assoc 3 entM) entM)
							entM		(if (assoc 7 entM)
										(subst (cons 7 "STANDARD") (assoc 7 entM) entM)
									)
							bubba	(entmod entM)
							CntM		(1+ CntM)
					)
				)
			)
			(setq	CntR	(1+ CntR))
		)
	)
	(Twizzle (- 0 CntR))
	(if (> CntM 0) (princ (strcat "\nFixed [" (itoa CntM) "] MText entities!")))
	CntM
)

(defun UpdURL_DA ( PanNam DevID / SucVal )
	(setq	SucVal	nil)
	(if (null sf)
		(setq	sff		1000
				sf		(* sff 0.3048)
				Bubba	(setvar "THICKNESS" (float sff))
		)
	)
	(if (> (length PanLst) 0)
		(if (not (member PanNam PanLst))
			(GetPan PanNam)
		)
		(if (null PanLst)
			(GetPan PanNam)
		)
	)
	(if (setq Ent0 (FndEEDev DevID))
		(progn
			(setq	Ent1	(cons Ent0 (list (cdr (assoc 10 (entget Ent0))))))
			(if Ent1
				(command "_.DetachURL" Ent1 "")
			)
			(if Ent1
				(setq	SucVal	(ChngUm T (car Ent1)))
			)
			(if Ent1
				(redraw (car Ent1) 3)
			)
		)
	)
	(command "_.Zoom" "E")
	SucVal
)

(defun C:InSOP ( /	AttWas					;Inserts an SOP block
					BlpWas CmdWas ColWas EchWas ExWas FilWas LayWas LtWas OsWas TmdWas )
	(if Bug (princ "\n{ C:InSOP entered}\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			CmdWas	(getvar "CMDDIA")
			ColWas	(getvar "CECOLOR")
			EchWas	(getvar "CMDECHO")
			ExWas	(getvar "EXPERT")
			FilWas	(getvar "FILEDIA")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			TmdWas	(getvar "TILEMODE")
	)
	
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 1)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 3)
		)
	)
	(command "_.UNDO" "_BE")
	(setq	Pnt01	(getpoint "\nSelect point for SOP Plate: "))
	(if Pnt01
		(if (> (car Pnt01) 300000.0)
			(command "_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" "" "_.Insert" (strcat _Path-Sym "A060.dwg") Pnt01 (* 0.25 sf) "" "0" "SOP" "")
			(command "_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" "" "_.Insert" (strcat _Path-Sym "A060.dwg") Pnt01 (* 0.50 sf) "" "0" "SOP" "")
		)
	)
	(setq	Aor01	(getstring T "\nEnter the SOP Link: "))
	(if Aor01
		(if (> (strlen Aor01) 0)
			(progn
				(ChngUm T (entlast))
				(setq	APID		"PE_URL")
				(if (null (tblsearch "APPID" APID))
					(regapp APID)
				)
				(setq	b		(entget (entlast))
						APID		"PE_URL"
						xd		(list APID (cons 1000 Aor01))
						xd		(list -3 xd)
						Bubba	(entmod (append b (list xd)))
						Bubba	(entupd (cdr (assoc -1 b)))
				)
			)
		)
	)
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CMDECHO" EchWas)
	(setvar "EXPERT" ExWas)
	(setvar "FILEDIA" FilWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "TILEMODE" TmdWas)
	(if Bug (princ "\n{ C:InSOP exited}\n"))
	(princ)
)

(defun C:UE ()
	(if (/= nil attwas)(setvar "ATTREQ" AttWas))
	(if (/= nil BlpWas)(setvar "BLIPMODE" BlpWas))
	(if (/= nil CmdWas)(setvar "CMDDIA" CmdWas))
	(if (/= nil ColWas)(setvar "CECOLOR" ColWas))
	(if (/= nil EchWas)(setvar "CMDECHO" EchWas))
	(if (/= nil ExWas)(setvar "EXPERT" ExWas))
	(if (/= nil FilWas)(setvar "FILEDIA" FilWas))
	(if (/= nil LayWas)(setvar "CLAYER" LayWas))
	(if (/= nil LtWas)(setvar "CELTYPE" LtWas))
	(if (/= nil OsWas)(setvar "OSMODE" OsWas))
	(if (/= nil TmdWas)(setvar "TILEMODE" TmdWas))
)

(defun Str2Lst ( StrIn DLim CasChz / OutLst Pos StPos )
	(setq	StPos	1)
	(if (not (setq Pos (vl-string-position (ascii DLim) StrIn)))
		(setq	OutLst	(list StrIn))
		(while Pos
			(if OutLst
				(setq	OutLst	(cons (substr StrIn (1+ StPos) (- Pos StPos)) OutLst))
				(setq	OutLst	(list (substr StrIn StPos Pos)))
			)
			(setq	StPos	(1+ Pos)
					Pos		(vl-string-position (ascii DLim) StrIn StPos)
			)
		)
	)
	(if (and (> (strlen StrIn) StPos) (/= StPos 1))
		(setq	OutLst	(cons (substr StrIn (1+ StPos)) OutLst))
	)
	(if CasChz
		(if (and (eq (strcase CasChz) "U") OutLst)
			(setq	OutLst	(mapcar (quote strcase) OutLst))
			(setq	OutLst	(mapcar (quote (lambda (x) (strcase x T))) OutLst))
		)
	)
	OutLst
)

(defun C:HdFL ( / )						;CL Hides Fill Lines
	(if Bug (princ "\n{ C:HdFL entered}\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			CmdWas	(getvar "CMDDIA")
			ColWas	(getvar "CECOLOR")
			EchWas	(getvar "CMDECHO")
			ExWas	(getvar "EXPERT")
			FilWas	(getvar "FILEDIA")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			TmdWas	(getvar "TILEMODE")
	)
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 23)
		)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 1)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 1)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 1)
			(setvar "OSMODE" 23)
		)
	)
	(command "_.UNDO" "_BE")
	(command "_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" "F" "????FL*,Mask" "")
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CMDECHO" EchWas)
	(setvar "EXPERT" ExWas)
	(setvar "FILEDIA" FilWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "TILEMODE" TmdWas)
	(if Bug (princ "\n{ C:HdFL exited}\n"))
	(princ)
)

(defun C:ThA ( / )							;CL Thaw All Layers
	(if Bug (princ "\n{ C:ThA entered}\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			CmdWas	(getvar "CMDDIA")
			ColWas	(getvar "CECOLOR")
			EchWas	(getvar "CMDECHO")
			ExWas	(getvar "EXPERT")
			FilWas	(getvar "FILEDIA")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			TmdWas	(getvar "TILEMODE")
	)
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 23)
		)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 1)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 1)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 1)
			(setvar "OSMODE" 23)
		)
	)
	(command "_.UNDO" "_BE")
	(command "_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" "")
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CMDECHO" EchWas)
	(setvar "EXPERT" ExWas)
	(setvar "FILEDIA" FilWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "TILEMODE" TmdWas)
	(if Bug (princ "\n{ C:ThA exited}\n"))
	(princ)
)

(defun HasDot ( Str / Cnt DotStr )			; Detects periods in string
	(setq	Cnt		1
			DotStr	nil
	)
	(while (and (<= Cnt (strlen Str)) (not DotStr))
		(if	(= (ascii (substr Str Cnt 1)) 46)
			(setq	DotStr	T)
		)
		(setq	Cnt		(1+ Cnt))
	)
	DotStr
)

(defun C:RepBlk ( / )						;CL Replace Block (replaces Insert with different one, retains Attributes)
	(if Bug (princ "\n{ C:RepBlk entered}\n"))
		(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			CmdWas	(getvar "CMDDIA")
			ColWas	(getvar "CECOLOR")
			EchWas	(getvar "CMDECHO")
			ExWas	(getvar "EXPERT")
			FilWas	(getvar "FILEDIA")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			TmdWas	(getvar "TILEMODE")
	)
	(command "_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" "F" "Mask" "")
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 23)
		)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 1)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 1)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 1)
			(setvar "OSMODE" 23)
		)
	)
	(command "_.UNDO" "_BE")
	(setq	sent	(entsel "\nSelect device to mutate: "))
	(if sent
		(if (= (type (car sent)) (quote ENAME))
			(setq	snam		(car sent)
					slst		(entget snam (list "*"))
					newBlk	(strcase(getstring "\nEnter new block name: "))
			)
			(setq	newBlk	nil)
		)
	)
	(if newBlk
		(progn
			(if (= (stpDot AppNam) "CADET")
				(progn
					(setq	newTst	T
							layerName	(cdr (assoc 8 slst))
					)
					;	Determine base symbol of the new block for inserting on correct layer.
					(cond 
						((< (atoi newBlk) 300)
							(setq 	baseBlock	newBlk
									modeCode		""
							)
						)
						((AND (> (atoi newBlk) 300) (< (atoi newBlk) 500))
							(setq baseBlock	(itoa (-(atoi newBlk) 200))
									modeCode		"I"
							)
						)
						((AND (> (atoi newBlk) 500) (< (atoi newBlk) 700))
							(setq baseBlock	(itoa (-(atoi newBlk) 400))
									modeCode		"C"
							
							)
						)
						((> (atoi newBlk) 700)
							(setq baseBlock	(itoa (-(atoi newBlk) 600))
									modeCode		"R"
							)
						)
					)
					(setq PosOut	(-	(length Lst_Sp_Sn) (length (member baseBlock Lst_Sp_Sn))))
					
					;	Build new layer name for CADET block
					(setq newLayer (strcat (substr layerName 1 4) (nth PosOut Lst_Sp_Ln)(substr layerName 7 4) modeCode ))
					(mklay newLayer)
				)
			)
			(if (= (stpDot AppNam) "ADDS")
				(if (assoc (strcase newBlk) Lst_No_Dev)
					(setq	newTst	(assoc (strcase newBlk) Lst_No_Dev))
					(setq	newTst	nil)
				)
			)
		)
	)
	(if newTst
		(progn
			(if	(not (tblsearch "BLOCK" newBlk))
				(if	(findfile (strcat _Path-SYM newBlk ".DWG"))
					(command	"_.Insert" (strcat _Path-SYM newBlk) (command))
				)
			)
			(setq	slst	(subst (cons 2 newBlk) (assoc 2 slst) slst))
			(if (= (stpDot AppNam) "CADET")
				(setq	slst	(subst (cons 8 newLayer) (assoc 8 slst) slst))	;	Set CADET Layer name
			)
			(entmod slst)
			(entupd snam)
		)
	)
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CMDECHO" EchWas)
	(setvar "EXPERT" ExWas)
	(setvar "FILEDIA" FilWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "TILEMODE" TmdWas)
	(if Bug (princ "\n{ C:RepBlk exited}\n"))
	(princ)
)

(defun C:EqpIt ( /	ObjEnt ObjDat tmp MyID		; Launches EquipLog for selected switch & breaker
				MyLoc tmp3 MyFdr MyPos MyBrk MyApp MyURL )
	(princ "\n C:EqpIt => Select an Insert Entity to launch: ")
	(setq	ObjEnt	(entsel))
	(if ObjEnt
		(setq	ObjEnt	(car ObjEnt))
	)
	(if ObjEnt
		(if (= (cdr (assoc 0 (setq ObjDat (entget ObjEnt (list "*"))))) "INSERT")
			(setq	tmp		(EntDatLstR ObjEnt)
					MyID		(cdr (assoc "ID" (cdr (last tmp))))
					MyLoc	(if (= (nth 9 tmp) 1)
								(if (assoc "LOC_NUM" (cdr (nth 10 tmp)))
									(cadr (assoc "LOC_NUM" (cdr (nth 10 tmp))))
									nil
								)
								nil
							)
					MyDes	(if (= (nth 9 tmp) 1)
								(if (assoc "DESCRIPT" (cdr (nth 10 tmp)))
									(cadr (assoc "DESCRIPT" (cdr (nth 10 tmp))))
									nil
								)
								nil
							)
			)
		)
	)
	(if ObjDat
		(setq	tmp3	(cdr (assoc 8 ObjDat)))
	)
	(if tmp3
		(setq	MyFdr	(substr tmp3 1 3))
	)
	(if MyFdr
		(if (member MyFdr Lst_Fd_V)
			(setq	MyPos	(- (length Lst_Fd_V) (length (member MyFdr Lst_Fd_V)))
					MyBrk	(nth MyPos Lst_Fd_B)
			)
		)
	)
	(if (and MyLoc MyID MyDes MyBrk)
		(princ (strcat "\n C:EqpIt => Loc_Num:{" MyLoc "} ID:{" MyID "} Desc:{" MyDes "} Brkr:{" MyBrk "}"))
		(princ "\n C:EqpIt => Loc_Num, ID, Descript or Brkr not valid!")
	)
	(if (and MyLoc MyBrk)
		(setq	MyApp	(findfile (strcat (getenv "ProgramFiles") "\\Internet Explorer\\iexplore.exe"))
				MyURL	(strcat	"https://gabrielleois.southernco.com/applications/customer/gabquickequiplog.asp?FeederNumber="
								MyBrk
								"&DeviceNumber="
								MyLoc
						)
		)
	)
	(if (and MyApp MyURL)
		(StartApp MyApp MyURL)
		(princ "\n C:EqpIt => Browser or URL not valid!")
	)
	(princ)
)

(defun Force2Str ( InpVal / )				; Formats any atom into a string
	(cond
		((eq (quote STR) (type InpVal))
			InpVal
		)
		((eq (quote INT) (type InpVal))
			(itoa InpVal)
		)
		((eq (quote REAL) (type InpVal))
			(rtos InpVal 2 4)
		)
		((null (type InpVal))
			""
		)
		(T
			"UNK"
		)
	)
)

(defun C:DrawGood ( /	ViewD )				; Sorts the Display List to show Blocks on Top (AddsPlot)
	(if (/= 1 (getvar "tilemode"))
		(if ViewPorter
			(setq	ViewD	(ViewPorter))
			(progn
				(load (strcat PrmRootPath "Common\\Acad.lsp"))
				(setq	ViewD	(ViewPorter))
			)
		)
		(setq	ViewD	nil)
	)
	(command "_.Undo" "C" "ALL" "_.Undo" "BE")
	(if ViewD
		(setq	WlX		(car (nth 8 ViewD))
				WuX		(car (nth 9 ViewD))
				WlY		(cadr (nth 8 ViewD))
				WuY		(cadr (nth 9 ViewD))
				cmD		(getvar "CMDDIA")
		)
		(setq	cmD		(getvar "CMDDIA"))
	)
	(setvar "CMDDIA" 0)
	(if ViewD
		(if (= 1 (getvar "cvport"))
			(command "_.MSpace")
		)
	)
	(if ViewD
		(setq	InSS		(ssget "w" (list WlX WlY) (list WuX WuY) (list (cons 0 "Insert")))
				InQD		(ssget "w" (list WlX WlY) (list WuX WuY) (list (cons 8 "Dlg_*")))
		)
		(setq	InSS		(ssget "X" (list (cons 0 "Insert")))
				InQD		(ssget "X" (list (cons 8 "Dlg_*")))
		)
	)
	(cond
		((and InSS InQD)
			(princ "\nAttempting to DrawOrder the Quads...")
			(command "_DrawOrder" InQD "" "B")
			(princ "\nAttempting to DrawOrder the Masked blocks...")
			(command "_DrawOrder" InSS "" "F")
		)
		(InSS
			(princ "\nAttempting to DrawOrder the Masked blocks...")
			(command "_DrawOrder" InSS "" "F")
		)
		(InQD
			(princ "\nAttempting to DrawOrder the Quads...")
			(command "_DrawOrder" InQD "" "B")
		)
		(T
			(princ "\nNo InSS found!")
		)
	)
	(if ViewD
		(if (= 1 (getvar "cvport"))
			(command "_.PSpace")
		)
	)
	(command "_.Undo" "End")
	(setvar "CMDDIA" cmD)
	(princ)
)


(defun LstSort ( input OnCompare /	fun )	; LstSort sorts lists by rule
;; ----------------------------------------------------------------
;; Merging complex list sort
;;
;; LstSort.LSP implements a modified version of the classic 
;; merge sort algorithm that sorts arbitrarily-complex lists
;; using a caller-defined relational predicate function.
;;
;;  (LstSort <list> <OnCompare>)
;;
;;  <OnCompare> is a function that takes two arguments,
;;  and returns non-nil if the first argument is greater 
;;  than the second, or nil otherwise. The arguments are 
;;  the elements of the list to be sorted. This argument 
;;  must be quoted.
;;  
;;  The default sort order is descending. To change the
;;  sort order to ascending, the <OnCompare> function can 
;;  return the logical complement (not) of its result.
;;
;; Examples:
;;
;;  1.  Sort a list of coordinates on the Y-component:
;;
;;      Assume unsorted data is in 'UNSORTED
;;
;;    (setq sorted 
;;       (LstSort unsorted 
;;         '(lambda (a b)
;;             (> (cadr a) (cadr b))
;;          )
;;       )
;;    )
;;              
;;
;;  2.  Sort a list of entity names by layer
;;      (although it is very ineffecient):
;;
;;    (setq sorted 
;;       (LstSort unsorted 
;;         '(lambda (e1 e2) 
;;            (> (cdr (assoc 8 (entget e1)))
;;               (cdr (assoc 8 (entget e2)))
;;            )
;;          )
;;       )
;;    )
;;    
;;  3.  Sort a list of coordinates on multiple
;;      keys (first by the X ordinate, and then 
;;      by the Y ordinate):
;;    
;;     (setq epsilon 1e-6)
;;     
;;     (defun compare-points (p1 p2)
;;        (cond
;;           (  (equal (car p1) (car p2) epsilon)  ; if x are equal,
;;              (> (cadr p1) (cadr p2)))           ; then compare y,
;;           (t (> (car p1) (car p2)))             ; else compare x
;;        )
;;     )
;;     
;;     (setq sorted (LstSort unsorted 'compare-points))
;;    
	(setq	fun		(cond (OnCompare) (t (quote >))))
	(LstSort-aux input)
)

(defun LstSort-aux ( input / )				; Aux function of LstSort
	(if (cdr input)
		(	(lambda	(tlist)
					(LstSort-merge 
						(LstSort-aux (car tlist))
						(LstSort-aux (cadr tlist))
					)
			)
			(LstSort-split input)
		)
		input
	)
)

(defun LstSort-split (right / left)			; Split function of LstSort
	(repeat (/ (length right) 2)
		(setq	left		(cons (car right) left)
				right	(cdr right)
		)
	)
	(list left right)
)

(defun LstSort-merge (left right / out)		; Merge function of LstSort
	(while (and left right)
		(if (apply fun (list (car left) (car right)))
			(setq	out		(cons (car left) out)
					left		(cdr left)
			)
			(setq	out		(cons (car right) out)
					right	(cdr right)
			)
		)
	)
	(append (reverse out) left right)
)

(defun StripAlt ( FIn Fout / )				; opens an ASCII file, writes one w/o upper (>126)
	(if (findfile FIn)
		(progn
			(setq	Fget	(open (findfile FIn) "r")
					Fput	(open Fout "w")
					InData	(read-char Fget)
			)
			(while InData
				(if InData
					(if (and (> InData 8) (< InData 126))
						(write-char InData Fput)
					)
				)
				(setq	InData	(read-char Fget))
			)
			(close Fget)
			(close Fput)
		)
	)
)

(defun Toggle ( VarNam / )					; Legacy Code, to toggle boolean variables
; Toggle ("name")
; Toggles variable passed to True or NIL. ** quote variable name when passed **
	(if (eval (read VarNam))
		(progn
			(if (= (strcase VarNam) "DRAGATT")
				(setvar "USERI4" 0)
			)
			(set (read VarNam) nil)
			(princ (strcat "\n" VarNam " Now DISABLED !!!!"))
		)
		(progn
			(if (= (strcase VarNam) "DRAGATT")
				(setvar "USERI4" 1)
			)
			(set (read VarNam) T)
			(princ (strcat "\n" VarNam " Now ENABLED !!!!"))
		)
	)
	(princ)
)

(defun RtD ( r / )							; Legacy Code, Radians to Degrees
; Rtd 
; Function: Converts a radian value into degrees.
	(* (/ r pi) 180.0)
)

(defun DtR ( a / )							; Legacy Code, Degrees to Radians
; Name: dtr
; Function: Converts degrees into radians.
	(* pi (/ a 180.0))
)

(defun StartTimer ( / )						; Legacy Code, Starts Timer
; Name: StartTimer
; Function: Works with StopTimer for benchmarking. (resets stopwatch)
	(setq _StartTimer (getvar "DATE"))
	(princ)
)

(defun StopTimer ( / secs )					; Legacy Code, Stops Timer
;  Name: StopTimer
;  Function: Returns time elasped since StartTime was run.
;  Returns value string or error string
	(if _StartTimer
		(progn
			(setq secs (* (- (- (getvar "DATE") _StartTimer)
						  (fix (- (getvar "DATE") _StartTimer))
					    )
					    86400.0
					 )
			)
			(strcat " "
				   (itoa (fix (/ secs 60.0)))
				   " mins. and "
				   (rtos (rem secs 60) 2 2)
				   " secs."
			)
		)
	   ; else
		(princ "\nThe function StartTimer() must be run first.")
	)
)

(Defun Cir ( PT clr /	H C0 S0 A C1 S1		; Legacy Code, draws highlite circle
					LOOP F X1 X2 Y1 Y2 )
; Draws graphic circle around a point.
	(SETQ H  (* (GETVAR "VIEWSIZE") 0.06)
		 C0 1.0
		 S0 0.0
		 A  0.392699081
	)
	(WHILE (<= A 6.675885117)
		(SETQ C1	 (COS A)
			 S1	 (SIN A)
			 F	 H
			 LOOP 1
		)
		(WHILE (< LOOP 4)
			(SETQ F  (* F 0.65)
				 X1 (+ (CAR PT) (* F C0))
				 X2 (+ (CAR PT) (* F C1))
				 Y1 (+ (CADR PT) (* F S0))
				 Y2 (+ (CADR PT) (* F S1))
			)
			(GRDRAW (LIST X1 Y1) (LIST X2 Y2) clr 0)
			(SETQ LOOP (1+ LOOP))
		)
		(SETQ C0 C1
			 S0 S1
			 A  (+ A 0.392699081)
		)
	)
)

(defun Beep ( / f )						; Legacy Code, Beep plays speaker tone
; Name:     Beep
; Function: sounds bell in all situations (as oppossed to the prompt "\7",
;           which doesnt seem to work much of the time)
	(setq f (open "con" "w"))
	(write-char 7 f)
	(close f)
	(setq f nil)
	(princ)
)

(defun RWav ( Pick /	CTim SPath-Wav			; Plays chosen or random Wave files from list	; MyLst
					Bubba Bubba2 )			; nil for random (normal) windows sound
										; -1 for random (not-normal) wave file
	(if Bug (princ "\n RWav entered."))
	(if (boundp (quote dos_drives))
		(setq	_Path-Wav	     "C:\\div_map\\lookuptable\\sounds\\" ;	(strcat (getenv "windir") "\\Media\\")
				SPath-Wav		(strcat PrmRootPath "Setup\\Sound\\")
		)
		(setq	_Path-Wav	nil)
	)
	(setq	MyLst	(list	
						(list	"Chord.Wav"		0	"WinDefaultSound"							"Chord.Wav")
						(list	"Chimes.Wav"		1	"WinDefaultSound"							"Chimes.Wav")
						(list	"Ding.Wav"		2	"WinDefaultSound"							"Ding.Wav")
						(list	"Tada.Wav"		3	"WinDefaultSound"							"Tada.Wav")
						(list	"TheMic~1.Wav"		4	"WinDefaultSound"							"The Microsoft Sound.Wav")
						(list	"Window~1.Wav"		5	"WinDefaultSound"							"Windows NT Logoff Sound.Wav")
						(list	"Window~2.Wav"		6	"WinDefaultSound"							"Windows NT Logon Sound.Wav")
						(list	"Ringin.Wav"		7	"WinDefaultSound"							"RingIn.Wav")
						(list	"Ringout.Wav"		8	"WinDefaultSound"							"RingOut.Wav")
						(list	"Ricochet.Wav"		9	"WinDefaultSound"							"Ricochet.Wav")
						(list	"Coke.Wav"		10	"Always, Coca-Cola"							"Coke.Wav")
						(list	"Makeit.Wav"		11	"Make it so."								"MakeIt.Wav")
						(list	"Photon.Wav"		12	"Star Trek Photon Torpedo"					"Photon.Wav")
						(list	"Laser.Wav"		13	"Generic Laser Blast"						"Laser.Wav")
						(list	"Boingity.Wav"		14	"Like it sounds"							"Boingity.Wav")
						(list	"ByYourCo.Wav"		15	"By Your command!"							"ByYourCo.Wav")
						(list	"DeadJim.Wav"		16	"He's dead, Jim"							"DeadJim.Wav")
						(list	"Crypt_Ha.Wav"		17	"Evil laugh..."							"Crypt_Ha.Wav")
						(list	"DkPissD3.Wav"		18	"When my work is done, I'm coming back for you!"	"DKPissd3.Wav")
						(list	"Hallelu.Wav"		19	"Hallelluia!"								"Hallelu.Wav")
						(list	"BudlBudl.Wav"		20	"Like it sounds"							"BudlBudl.Wav")
						(list	"CantDo.Wav"		21	"I can't do that, "							"CantDo.Wav")
						(list	"Cheering.Wav"		22	"the sound of Applause"						"Cheering.Wav")
						(list	"Destruct.Wav"		23	"This tape will self-destruct"				"Destruct.Wav")
						(list	"FerSure.Wav"		24	"Valley talk girl"							"FerSure.Wav")
						(list	"George_J.Wav"		25	"George of the Jungle"						"George_J.Wav")
						(list	"Kaboom.Wav"		26	"Marvin the Martian"						"Kaboom.Wav")
						(list	"SoSure.Wav"		27	"More Valley Talk"							"SoSure.Wav")
						(list	"ThankMe.Wav"		28	"Don't everybody thank me at once."			"ThankMe.Wav")
						(list	"OhNo.Wav"		29	"Like it sounds"							"OhNo.Wav")
						(list	"BB_Mis~1.Wav"		30	"We're on a Mission from God"					"BB_Mishion_Short.Wav")
						(list	"BB_Pet~1.Wav"		31	"Peter Gunn Theme"							"BB_PeterGunn_Short.Wav")
						(list	"Scum&Vil.Wav"		32	"a more wretched hive of scum and villainy..."	"Scum&Vil.Wav")
						(list	"BAD-OLE.WAV"		33	"Bad Ole Puddy Tat!"						"BAD-OLE.WAV")
						(list	"NOSIR.WAV"		34	"No Sir, I didn't like it."					"NOSIR.WAV")
						(list	"RaceCar.Wav"		35	"a Race Car sound..."						"RaceCar.Wav")
						(list	"WhipCrak.Wav"		36	"Whip Crack - get back to work!"				"WhipCrak.Wav")
						(list	"YodaHelp.Wav"		37	"Help you I can, yes, hmmm..."				"YodaHelp.Wav")
						(list	"BB_Fee~1.Wav"		38	"I feel good... - James Brown"				"BB_FeelGood.Wav")
						(list	"Affair.Wav"		39	"A Current Affair sound"						"Affair.Wav")
					)
	)
	(if (not WavLst)
		(foreach	Wav
				MyLst
				(if (findfile (strcat _Path-Wav (car Wav)))
					(if WavLst
						(setq	WavLst	(reverse (cons (car Wav) (reverse WavLst))))
						(setq	WavLst	(list (car Wav)))
					)
					(progn
						(dos_copy (strcat SPath-Wav (car Wav)) (strcat _Path-Wav (car Wav)))
						(if (findfile (strcat _Path-Wav (car Wav)))
							(if WavLst
								(setq	WavLst	(reverse (cons (car Wav) (reverse WavLst))))
								(setq	WavLst	(list (car Wav)))
							)
							(progn
								(dos_copy (strcat SPath-Wav (last Wav)) (strcat _Path-Wav (last Wav)))
								(if (findfile (strcat _Path-Wav (last Wav)))
									(if WavLst
										(setq	WavLst	(reverse (cons (last Wav) (reverse WavLst))))
										(setq	WavLst	(list (last Wav)))
									)
								)
							)
						)
					)
				)
		)
	)
	(if Pick
		(if (and (>= Pick 0) (<= Pick (1- (length WavLst))))		;Pick within valid limits
			(setq	CTim		Pick)
			(if (< Pick 0)
				(if (= Pick -1)							;Pick = -1 - Generates value from 10-37
					(setq	CTim		(getvar "CDATE")
							CTim		(- CTim (fix CTim))
							Bubba	(if Bug
										(princ (strcat "\nCTim: " (rtos CTim 2 8)))
									)
							CTim		(+	(atoi (substr (rtos CTim 2 8) 8 1))
										(atoi (substr (rtos CTim 2 8) 7 1))
										(atoi (substr (rtos CTim 2 8) 6 1))
										10
									)
					)
					(setq	CTim		nil)					;Pick < -1 No Sound Generated
				)
				(setq	CTim		(getvar "CDATE")			;Pick greater than maximum - Generates value from 0-9
						CTim		(- CTim (fix CTim))
						Bubba	(if Bug
									(princ (strcat "\nCTim: " (rtos CTim 2 8)))
								)
						CTim		(atoi (substr (rtos CTim 2 8) 8 1))
				)
			)
		)
		(setq	CTim		(getvar "CDATE")					;Pick is nil - Generates value from 0-9
				CTim		(- CTim (fix CTim))
				Bubba	(if Bug
							(princ (strcat "\nCTim: " (rtos CTim 2 8)))
						)
				CTim		(atoi (substr (rtos CTim 2 8) 8 1))
		)
	)
	(if (and _Path-Wav CTim WavLst)
		(if (findfile (strcat _Path-Wav (nth CTim WavLst)))
			(dos_wav (strcat _Path-Wav (nth CTim WavLst)))	    ;	Plays sound ?
		)
	)
	(if (and Bug CTim WavLst)
		(princ (strcat "\nWav: " (nth CTim WavLst)))
	)
	(if Bug (princ "\nRWav exited."))
	(princ)
)

(defun Add2LstEnd ( Lst Itm / )				; Adds Itm to end of Lst (Was 'AddLst')
	(if Lst
		(setq	Lst	(reverse (cons Itm (reverse Lst))))
		(setq	Lst	(list Itm))
	)
)

(defun MemLst ( Memb MLst / Numb IsIt )		; Returns numeric placement in list
	(setq IsIt (member Memb MLst)
		 Numb nil
	)
	(if IsIt
		(setq Numb (- (length MLst) (length (member Memb MLst))))
	)
	Numb
)

(defun C:DupNBreak ( / FirstPic Ent1 EntBack )	; Breaks selected Pline, replaces with 2 new ones
;Function:		C:DupNBreak
;Description:	command-line function to test DupNBrk functionality
	(setq FirstPic (entsel))
	(if FirstPic
		(setq EntBack (DupNBrk FirstPic))
		(princ "\nNothing Selected!")
	)
	(princ)
)

(defun CalcBlgInt ( Vpt1 Vpt2 Ppt1 Blg1 /	Xpt0	; Calculates Bulge Intercept
									Crv2 Crv1 Ang1 Ang2 Ang3 Dst1 Cpt1 Ang4
									Dst2 Ang5 Ang6 )
;****************************************************************************
;Function:		CalcBlgInt
;Description:		Calculates the two arcs created by breaking a pline on an arc,
;				returns the point of intersection and two Bulges
;Called by:		Make2OPoly
;Required funs:	None
;Arguments:		Segment end 1 & 2, picked point and Bulge data from curve
;Returns:		Intersection point, Bulge 1 & 2
;Globals:		None
;****************************************************************************
	(if Bug
		(progn
			(princ "\nUtils.Lsp!CalcBlgInt - Entered")
			(princ "\n   - Vpt1:  ") (prin1 Vpt1)
			(princ "\n   - Vpt2:  ") (prin1 Vpt2)
			(princ "\n   - Ppt1:  ") (prin1 Ppt1)
			(princ "\n   - Blg1:  ") (prin1 Blg1)(princ "\n")
		)
	)
	(setq	Ang1		(angle Vpt1 Vpt2)
			Ang2		(if (> Blg1 0.0)
						(- (+ Ang1 (/ pi 2.0)) (* 2.0 (atan Blg1)))
						(+ (- Ang1 (/ pi 2.0)) (* 2.0 (atan Blg1)))
					)
			Ang3 	(if (> Blg1 0.0)
						(+ (+ Ang1 (/ pi 2.0)) (* 2.0 (atan Blg1)))
						(- (- Ang1 (/ pi 2.0)) (* 2.0 (atan Blg1)))
					)
			Dst1 	(* (distance Vpt1 Vpt2) (/ 1.0 (atan Blg1)))
			Xpt0 	nil
			Crv1 	nil
			Crv2 	nil
			Cpt1		(if (> Blg1 0.0)
						(inters	Vpt1
								(polar Vpt1 Ang2 Dst1)
								Vpt2
								(polar Vpt2 Ang3 Dst1)
								T
						)
						(inters	Vpt1
								(polar Vpt1 Ang3 Dst1)
								Vpt2
								(polar Vpt2 Ang2 Dst1)
								T
						)
					)
	)
	(if Cpt1
		(setq	Ang4		(angle Cpt1 Ppt1)
				Dst2		(distance Cpt1 Vpt1)
				Xpt0		(polar Cpt1 Ang4 Dst2)
				Ang5		(/ (abs (- (angle Cpt1 Vpt1) (angle Cpt1 Xpt0))) 4.0)
				Ang6		(/ (abs (- (angle Cpt1 Xpt0) (angle Cpt1 Vpt2))) 4.0)
				Crv1 	(atan Ang5)
				Crv2 	(atan Ang6)
		)
	)
	(if Bug
		(progn
			(princ "\nUtils.Lsp!CalcBlgInt - done\n   - returns:  ")
			(prin1 (list Xpt0 Crv1 Crv2 Cpt1))
		)
	)
	(list Xpt0 Crv1 Crv2 Cpt1)
)

(defun Make2OPoly ( Back0 Ppt1 /	Sub1 Vrt1 Vpt1	; Returns list for generating two old Plines
							Vrt2 Vpt2 Blg1 Cnt MakNum BLen
							Ang Xpt1 Xpt2 Xpt0 CrvT CrvLst
							Crv1 Crv2 NVrt1 NVrt2 NVrt3 Back1
							Back2 Soff Bubba Back8 Back9 IntNum
							MPtLst PolyDat X )
;****************************************************************************
;Function:		Make2OPoly
;Description:		Reads entdata list generated by ReadxPoly funs and writes entdata list
;				for two Plines that replicate a Pline broken at a point
;Called by:		DupNBrk
;Required funs:	CalcBlgInt
;Arguments:		entdata list (describing Pline, generated by ReadPoly funs) and point on entity
;Returns:		list of two entity names created from entdata lists
;Globals:		None
;****************************************************************************
	(if Bug 
		(progn
			(princ "\nUtils.Lsp!Make2OPoly - Enter parameters:\n   Back0(list): ")
			(prin1 Back0)
			(princ (strcat "\n   Ppt1: " (rtos (car Ppt1) 2 2)", " (rtos (cadr Ppt1) 2 2)"\n")) 
		)
	)
	(if Bug
		(princ (strcat	"\nMake2PtSent = "
					(rtos (car Ppt1) 2 2)
					","
					(rtos (cadr Ppt1) 2 2)
			  )
		)
	)
	(setq Back9 (cadr Back0)		; gets 3rd element of list
		 Back8 (cddr Back0)		; gets 2rd element of list
	)
	(mapcar (quote (lambda (x) (setq Back9 (append Back9 x)))) Back8)
	(setq MPtLst  (BldMstPLst Back9 Ppt1)
		 NumLst  (nth 1 MPtLst)
		 MPtLst  (nth 0 MPtLst)
		 PolyDat (FindIntPoly MPtLst Ppt1)
		 IntNum  (car PolyDat)
		 Vrt1    (nth (1+ IntNum) Back0)
		 Vrt2    (nth (+ 2 IntNum) Back0)
		 Vpt1    (cdr (assoc 10 Vrt1))
		 Vpt2    (cdr (assoc 10 Vrt2))
		 Blg1    (cdr (assoc 42 Vrt1))
		 Cnt	    0
		 MakNum  nil
		 BLen    (length Back0)
	)
	(if Bug
		(princ (strcat	"\nSegEnd1 = "
					(rtos (car Vpt1) 2 2)
					","
					(rtos (cadr Vpt1) 2 2)
			  )
		)
	)
	(if Bug
		(princ (strcat	"\nSegEnd2 = "
					(rtos (car Vpt2) 2 2)
					","
					(rtos (cadr Vpt2) 2 2)
			  )
		)
	)
	(if (equal Blg1 0.0 0.001)
		(setq Ang	  (angle Vpt1 Vpt2)
			 Xpt1  (polar Ppt1 (+ Ang (/ pi 2.0)) 50.0)
			 Xpt2  (polar Ppt1 (- Ang (/ pi 2.0)) 50.0)
			 Xpt0  (inters Vpt1 Vpt2 Xpt1 Xpt2)
			 CrvT  nil
			 Bubba (if Bug
					  (princ "\nNot a bulge-data PLine")
				  )
			 Bubba (if Bug
					  (princ (strcat "\nIntLin1 = "
								  (rtos (car Xpt1) 2 2)
								  ","
								  (rtos (cadr Xpt1) 2 2)
						    )
					  )
				  )
			 Bubba (if Bug
					  (princ (strcat "\nIntLin2 = "
								  (rtos (car Xpt2) 2 2)
								  ","
								  (rtos (cadr Xpt2) 2 2)
						    )
					  )
				  )
		)
		(setq CrvT   T
			 CrvLst (CalcBlgInt
					   Vpt1
					   Vpt2
					   Ppt1
					   (cdr (assoc 42 Vrt1))
				   )
			 Xpt0   (nth 0 CrvLst)
			 Crv1   (nth 1 CrvLst)
			 Crv2   (nth 2 CrvLst)
			 Bubba  (if Bug
					   (princ "\nA bulge-data PLine")
				   )
		)
	)
	(if Bug
		(if Xpt0
			(princ (strcat	"\nIntersPtFound = "
						(rtos (car Xpt0) 2 2)
						","
						(rtos (cadr Xpt0) 2 2)
				  )
			)
			(princ "\nInters not Found!")
		)
	)
	(while (< Cnt BLen)
		(if (equal (cdr (assoc 10 (nth Cnt Back0))) Vpt1 0.01)
			(setq MakNum Cnt
				 Cnt	   (1+ BLen)
			)
			(if Bug
				(princ "\nFound a Vertex!")
			)
		)
		(setq Cnt (1+ Cnt))
	)
	(if MakNum
		(progn
			(setq NVrt2 (subst (cons 10 Xpt0)
						    (assoc 10 (nth MakNum Back0))
						    (nth MakNum Back0)
					  )
				 NVrt2 (if CrvT
						  (subst (cons 42 Crv2)
							    (assoc 42 NVrt2)
							    NVrt2
						  )
						  NVrt2
					  )
				 NVrt1 (if CrvT
						  (subst (cons 42 Crv1)
							    (assoc 42 (nth MakNum Back0))
							    (nth MakNum Back0)
						  )
						  (nth MakNum Back0)
					  )
				 NVrt3 (subst (cons 42 0.0)
						    (assoc 42 NVrt2)
						    NVrt2
					  )
				 Back2 (list (car Back0)
						   NVrt2
					  )
				 Back2 (append	Back2
							(cdr (member (nth MakNum Back0) Back0))
					  )
				 Back1 (reverse Back0)
				 Soff  (- BLen MakNum)
			)
			(repeat Soff
				(setq Back1 (cdr Back1))
			)
			(setq Back1 (append	(reverse Back1)
							(list NVrt1)
							(list NVrt3)
							(list (last Back2))
					  )
			)
		)
		(if Bug
			(princ "\nCounter MakNum not found!")
		)
	)
	(if Bug 
		(progn
			(princ "\nUtils.Lsp!Make2OPoly - Return(list):\n   ")
			(prin1 (list Back1)) (princ "\n\n") (prin1 (list Back2))
			(princ "\n")
		)
	)
	(list Back1 Back2)
)

(defun Make2NPoly ( Back0 Ppt1 /	Sub1 Vrt1 Vpt1	; Returns list for generating two new Plines
							Vrt2 Vpt2 Blg1 Cnt MakNum BLen
							Ang Xpt1 Xpt2 Xpt0 CrvT CrvLst
							Crv1 Crv2 NVrt1 NVrt2 NVrt3 Back1
							Back2 Soff Bubba MPtLst PtLst Numb
							NumLst Ang1 HedLen IntNum PHed PolyDat
							VLen1 VLen2 )
;****************************************************************************
;Function:		Make2NPoly
;Description:	Reads entdata list generated by ReadxPoly funs and writes entdata list
;				for two Plines that replicate a Pline broken at a point
;Called by:		DupNBrk
;Required funs:	CalcBlgInt
;Arguments:		entdata list (describing Pline, generated by ReadPoly funs) and point on entity
;Returns:		list of two entdata lists
;Globals:		None
;****************************************************************************
	(if Bug
		(princ (strcat	"\nMake2PtSent = "
					(rtos (car Ppt1) 2 2)
					","
					(rtos (cadr Ppt1) 2 2)
			  )
		)
	)
	(setq MPtLst  (BldMstPLst Back0 Ppt1)
		 NumLst  (nth 1 MPtLst)
		 MPtLst  (nth 0 MPtLst)
		 PolyDat (FindIntPoly MPtLst Ppt1)
		 IntNum  (car PolyDat)
		 HedLen  (- (length Back0) (car NumLst))
		 PHed    (reverse Back0)
		 VLen1   (1+ IntNum)
		 VLen2   (- (length MPtLst) VLen1)
		 Cnt	    0
	)
	(if Bug
		(princ (strcat "\nVLen1 = " (itoa VLen1)))
	)
	(if Bug
		(princ (strcat "\nVLen2 = " (itoa VLen2)))
	)
	(repeat HedLen (setq PHed (cdr PHed)))
	(setq Back1 (reverse PHed)
		 Back1 (subst (cons 90 (1+ VLen1))
				    (assoc 90 Back1)
				    Back1
			  )
		 Back2 (reverse PHed)
		 Back2 (subst (cons 90 (1+ VLen2))
				    (assoc 90 Back2)
				    Back2
			  )
		 Vpt1  (list (nth 1 (nth IntNum MPtLst))
				   (nth 2 (nth IntNum MPtLst))
			  )
		 Vpt2  (list (nth 1 (nth (1+ IntNum) MPtLst))
				   (nth 2 (nth (1+ IntNum) MPtLst))
			  )
		 Ang1  (angle Vpt1 Vpt2)
		 Blg1  (nth 5 (nth IntNum MPtLst))
	)
	(if (= (length (nth IntNum MPtLst)) 6)
		(if (equal (nth 5 (nth IntNum MPtLst)) 0.00 0.001)
			(setq Xpt1
					(inters (polar Ppt1 (+ Ang1 (/ pi 2.0)) 100.0)
						   (polar Ppt1 (- Ang1 (/ pi 2.0)) 100.0)
						   Vpt1
						   Vpt2
					)
			)
			(setq CrvLst (CalcBlgInt Vpt1 Vpt2 Ppt1 Blg1)
				 Xpt1   (nth 0 CrvLst)
				 Crv1   (nth 1 CrvLst)
				 Crv2   (nth 2 CrvLst)
			)
		)
	)
	(repeat VLen1
		(if CrvLst
			(if (= (length (nth Cnt MPtLst)) 6)
				(setq Back1
						(append
							Back1
							(list
								(cons
									10
									(list (nth 1
											 (nth Cnt MPtLst)
										 )
										 (nth 2
											 (nth Cnt MPtLst)
										 )
									)
								)
								(cons 40
									 (nth 3 (nth Cnt MPtLst))
								)
								(cons 41
									 (nth 4 (nth Cnt MPtLst))
								)
								(cons 42
									 (if	(/= (1- Vlen1) Cnt)
										 (nth 5
											 (nth Cnt MPtLst)
										 )
										(if Crv1
										 	Crv1
											0.0
										)
									 )
								)
							)
						)
				)
				(setq Back1
						(append
							Back1
							(list
								(cons
									10
									(list (nth 1
											 (nth Cnt MPtLst)
										 )
										 (nth 2
											 (nth Cnt MPtLst)
										 )
									)
								)
								(cons 40
									 (nth 3 (nth Cnt MPtLst))
								)
								(cons 41
									 (nth 4 (nth Cnt MPtLst))
								)
								(cons 42
									 (if	(/= (1- Vlen1) Cnt)
										 0.0
										 (if Crv1
										 	Crv1
											0.0
										)
									 )
								)
							)
						)
				)
			)
			(if (= (length (nth Cnt MPtLst)) 6)
				(setq Back1
						(append
							Back1
							(list
								(cons
									10
									(list (nth 1
											 (nth Cnt MPtLst)
										 )
										 (nth 2
											 (nth Cnt MPtLst)
										 )
									)
								)
								(cons 40
									 (nth 3 (nth Cnt MPtLst))
								)
								(cons 41
									 (nth 4 (nth Cnt MPtLst))
								)
								(cons 42
									 (nth 5 (nth Cnt MPtLst))
								)
							)
						)
				)
				(setq Back1
						(append
							Back1
							(list
								(cons
									10
									(list (nth 1
											 (nth Cnt MPtLst)
										 )
										 (nth 2
											 (nth Cnt MPtLst)
										 )
									)
								)
								(cons 40
									 (nth 3 (nth Cnt MPtLst))
								)
								(cons 41
									 (nth 4 (nth Cnt MPtLst))
								)
								(cons 42 0.0)
							)
						)
				)
			)
		)
		(setq Cnt (1+ Cnt))
	)
	(setq Back1 (append	Back1
					(list (cons 10 Xpt1)
						 (cons 40 (nth 3 (nth IntNum MPtLst)))
						 (cons 41 (nth 4 (nth IntNum MPtLst)))
						 (cons 42 0.0)
						 (assoc 210 Back0)
					)
			  )
	)
	(if CrvLst
		(setq Back2 (append	Back2
						(list (cons 10 Xpt1)
							 (cons 40 (nth 3 (nth IntNum MPtLst)))
							 (cons 41 (nth 4 (nth IntNum MPtLst)))
							 (cons 42 
							 		(if Crv2
										Crv2
										0.0
									)
							)
						)
				  )
			 Cnt	  (1+ Vlen1)
		)
		(setq Back2 (append	Back2
						(list (cons 10 Xpt1)
							 (cons 40 (nth 3 (nth IntNum MPtLst)))
							 (cons 41 (nth 4 (nth IntNum MPtLst)))
							 (cons 42 0.0)
						)
				  )
			 Cnt	  (1+ Vlen1)
		)
	)
	(setq Cnt Vlen1)
	(repeat VLen2
		(if (= (length (nth Cnt MPtLst)) 6)
			(setq Back2
					(append
						Back2
						(list (cons 10
								  (list (nth 1 (nth Cnt MPtLst))
									   (nth 2 (nth Cnt MPtLst))
								  )
							 )
							 (cons 40 (nth 3 (nth Cnt MPtLst)))
							 (cons 41 (nth 4 (nth Cnt MPtLst)))
							 (cons 42 (nth 5 (nth Cnt MPtLst)))
						)
					)
			)
			(setq Back2
					(append
						Back2
						(list (cons 10
								  (list (nth 1 (nth Cnt MPtLst))
									   (nth 2 (nth Cnt MPtLst))
								  )
							 )
							 (cons 40 (nth 3 (nth Cnt MPtLst)))
							 (cons 41 (nth 4 (nth Cnt MPtLst)))
							 (cons 42 0.0)
						)
					)
			)
		)
		(setq Cnt (1+ Cnt))
	)
	(setq Back2 (append Back2 (list (assoc 210 Back0))))
	(list Back1 Back2)
)

(defun FindIntPoly ( MPtLst Ppt1 /	Plen Cnt	; Find Intercept in Polylines
								Vpt1 Vpt2 Ang1 Blg1 Xpt1 Dst1 Ang2 Ang3 Dst2
								Cpt1 Ang4 Dst3 Xpt0 Dst0 Num0 )
;****************************************************************************
;Function:		FindIntPoly
;Description:	reads the MPtLst vertice list and determines which segment is nearest mathematically
;Called by:		Make2NPoly
;Required funs:	None
;Arguments:		Vertice data list (MPtLst), point
;Returns:		list of data as follows
;					Num0 First vertex number from MPtLst that defines the intersecting segment
;					Xpt0 Intersection point (nearest)
;					Vptx Nearest segment point (endpoint)
;					Vptx The other segment point
;					Ang1 The angle between segments
;					Cpt1 Centerpoint of the bulge (if any)
;Globals:		None
;****************************************************************************
	(if Bug 
		(progn
			(princ "\nUtils.Lsp!FindIntPoly - Enter parameters")
			(princ "\n - MPtLst = ") (prin1 MPtLst)
			(princ "\n - Ppt1 = ") (prin1 Ppt1)
		)
	)
	
	(setq Plen (length MPtLst)
		 Cnt	 0
	)
	(while (< Cnt (1- Plen))
		(setq Vpt1 (list (nth 1 (nth Cnt MPtLst))
					  (nth 2 (nth Cnt MPtLst))
				 )
			 Vpt2 (list (nth 1 (nth (1+ Cnt) MPtLst))
					  (nth 2 (nth (1+ Cnt) MPtLst))
				 )
			 Ang1 (angle Vpt1 Vpt2)
			 Blg1 (nth 5 (nth Cnt MPtLst))
		)
		(if (and Bug Vpt1)
			(princ (strcat	"\nVpt1: "
						(rtos (car Vpt1) 2 4)
						","
						(rtos (cadr Vpt1) 2 4)
				  )
			)
		)
		(if (and Bug Vpt2)
			(princ (strcat	"\nVpt2: "
						(rtos (car Vpt2) 2 4)
						","
						(rtos (cadr Vpt2) 2 4)
				  )
			)
		)
		(if (and Bug Ang1)
			(princ (strcat "\nAng1: " (rtos Ang1 2 4)))
		)
		(if (and Bug Blg1)
			(princ (strcat "\nBlg1: " (rtos Blg1 2 4)))
		)
		(cond
			((equal Blg1 0.0 0.001)		; If its a straight line segment
				(setq	Xpt1		(inters	(polar Ppt1 (+ Ang1 (/ pi 2.0)) 100.0)
										(polar Ppt1 (- Ang1 (/ pi 2.0)) 100.0)
										Vpt1
										Vpt2
								)
				)
			 	(if Xpt1
					(setq	Dst1		(distance Xpt1 Ppt1))	; How far to intersection?
					(setq	Xpt1		(list 0.0 0.0 0.0)		; If no intersection, must not be right one.
							Dst1		(distance Xpt1 Ppt1)
					)
				)
			)
			(T						; If its not straight
				(setq	Ang2		(if (> Blg1 0.0)			; Angle towards center from pt 1
									(-	(+ Ang1 (/ pi 2.0))
										(* 2.0 (atan Blg1))
									)
									(+	(- Ang1 (/ pi 2.0))
										(* 2.0 (atan Blg1))
									)
								)
						Ang3		(if (> Blg1 0.0)			; Angle towards center from pt 2
									(+	(+ Ang1 (/ pi 2.0))
										(* 2.0 (atan Blg1))
									)
									(-	(- Ang1 (/ pi 2.0))
										(* 2.0 (atan Blg1))
									)
								)
						Dst2		(*	(distance Vpt1 Vpt2)	; a proportional distance that doesnt reach!
									(/ 1.0 (atan Blg1))
								)
		   				CrvLst	(CalcBlgInt Vpt1 Vpt2 Ppt1 Blg1)
						Xpt1		(nth 0 CrvLst)
						Cpt1		(nth 3 CrvLst)
;;;				   		Cpt1		(inters	Vpt1
;;;							 			(polar Vpt1 Ang2 Dst2)
;;;							 			Vpt2
;;;							 			(polar Vpt2 Ang3 Dst2)
;;;							 			nil				; Onseg argument set to find centerpoint from line segs that dont touch
;;;					   			)
				)
				(if Cpt1
					(setq	Ang4		(angle Cpt1 Ppt1)		; angle toward pick point
							Dst3		(distance Cpt1 Vpt1)	; radius distance
;;;							Xpt1		(polar Cpt1 Ang4 Dst3)	; nearest to pick point
					   		Dst1		(distance Xpt1 Ppt1)	; How far to intersection?
					)
				)
			)
		)
		(if Xpt0
			(if (< Dst1 Dst0)
				(setq Xpt0 Xpt1
					 Dst0 Dst1
					 Num0 Cnt
				)
			)
			(setq Xpt0 Xpt1
				 Dst0 Dst1
				 Num0 Cnt
			)
		)
		(if (and Bug Dst)
			(princ (strcat "\nShortest = " (rtos Dst0 2 4)))
		)
		(setq Cnt (1+ Cnt))
	)
	(if (< (distance Xpt0 Vpt1) (distance Xpt0 Vpt2))
		(setq result (list Num0 Xpt0 Vpt1 Vpt2 Ang1 Cpt1))
		(setq result (list Num0 Xpt0 Vpt2 Vpt1 Ang1 Cpt1))
	)
	(if Bug 
		(progn
			(princ "\nUtils.Lsp!FindIntPoly - return = ")
			(prin1 result) (princ "\n")
		)
	)
	(if (< (distance Xpt0 Vpt1) (distance Xpt0 Vpt2))
		(list Num0 Xpt0 Vpt1 Vpt2 Ang1 Cpt1)
		(list Num0 Xpt0 Vpt2 Vpt1 Ang1 Cpt1)
	)
)

(defun XCutLstR ( ItmStr En /	LstLen ALst	; removes ItmStr identified Xdata from Lst
							ALen RLst RCnt Cnt )
	(setq	Lst	(entget En (list "*"))
			Lst3	(cdr (assoc -3 Lst))
	)
	(if Lst3
		(setq	LstCnt	(length Lst3))		
	)
	(if (and ItmStr Lst3)
		(foreach	Thng
				Lst3
				(if (member ItmStr Thng)
					(setq	Itm	Thng)	;Which group contains the appid we care about?
				)
		)
	)
	(if (and Lst3 Itm)
		(if (member Itm Lst3)
			(progn
				(setq LstLen (length Lst3)	;How many registered appids are there?
					 ALen   (length (member Itm Lst3))
				)
				(cond ((= ALen 1)			;Is this the last appid?
					  (setq Lst3 (reverse (cdr (reverse Lst3))))
					 )
					 ((= ALen LstLen)		;Is this the first appid?
					  (setq Lst3 (cdr Lst3))
					 )
					 (T					;Must be in the middle...
					  (setq RLst (cdr (member Itm Lst3))
						   ALst (list (car Lst3))
						   RCnt (- LstLen ALen)
						   Cnt  1
					  )
					  (while (< Cnt RCnt)
						  (setq ALst (append ALst (list (nth Cnt Lst3)))
							   Cnt  (1+ Cnt)
						  )
					  )
					  (setq Lst3 (append ALst RLst))
					 )
				)
			)
		)
	)
	(if (and Lst3 Itm)
		(setq	Lst	(subst (cons -3 Lst3) (assoc -3 Lst) Lst))
	)
	(if (= (car (nth 0 Lst)) -1)
		(setq	Lst	(cdr Lst))
	)
	(if (= (car (nth 0 Lst)) 0)
		(setq	Lost	(car Lst)
				Lst	(cdr Lst)
		)
	)
	(if (= (car (nth 0 Lst)) 330)
		(setq	Lst	(cdr Lst))
	)
	(if (= (car (nth 0 Lst)) 5)
		(setq	Lst	(cdr Lst))
	)
	(setq	BLst		(cons Lost Lst)
			TstR		"Gunk"
			Nen		nil
			NLst		nil
	)
	(if	(or	(= (cdr (assoc 0 BLst)) "POLYLINE")
			(and
				(= (cdr (assoc 0 BLst)) "INSERT")
				(= (cdr (assoc 66 BLst)) 1)
			)
		)
		(while	(/= TstR "SEQEND")
			(if Nen
				(setq	Nen	(entnext Nen))
				(setq	Nen	(entnext En))
			)
			(setq	CLst	(entget Nen (list "*"))
					TstR	(cdr (assoc 0 CLst))
			)
			(if NLst
				(setq	NLst	(cons CLst NLst))
				(setq	NLst	(list CLst))
			)
		)
	)
	(if NLst
		(setq	OutLst	(List "CUD" BLst (reverse NLst)))
		(setq	OutLst	BLst)
	)
)

(defun StmpURL ( En /	ItmStr Booga )			; Stomps hard-coded URLs out of drawing entities
	(if (not En)
		(setq	En	(car (entsel)))
	)
	(setq	ItmStr	"PE_URL"
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

(defun MakLst ( Itm Num / LLst )				; Make List of <Itm>, Multiple <Num> times
	(if (and Itm (> Num 0))
		(setq	LLst		(list Itm))
		(setq	LLst		nil)
	)
	(if (and Itm (> Num 1))
		(repeat (1- Num)
			(setq	LLst		(cons Itm LLst))
		)
	)
	LLst
)

(defun RemLst ( DelItem InLst /	RedLst OutLst	; Removes Item from List
							Cnt PosCut )
	(if (member DelItem InLst)
		(cond	((= (length (member DelItem InLst)) (length InLst))
					(setq	OutLst	(cdr InLst))
				)
				((= (length (member DelItem InLst)) 1)
					(setq	OutLst	(reverse (cdr (reverse InLst))))
				)
				(T
					(setq	RedLst	(cdr (member DelItem InLst))
							OutLst	(reverse (cdr (member DelItem (reverse InLst))))
							OutLst	(append OutLst RedLst)
					)
;;;					(setq	PosCut	(- (length InLst) (length (member DelItem InLst)))
;;;							RedLst	(cdr (member DelItem InLst))
;;;							OutLst	(list (car InLst))
;;;							Cnt		1
;;;					)
;;;					(while (< Cnt PosCut)
;;;						(setq	OutLst	(append OutLst (list (nth Cnt InLst)))
;;;								Cnt		(1+ Cnt)
;;;						)
;;;					)
;;;					(setq	OutLst	(append OutLst RedLst))
				)
		)
		(setq	OutLst	InLst)
	)
	OutLst
)

(defun RemNumLst ( ItemNum InLst /	RedLst 	; Removes Item from List
								OutLst Cnt PosCut )
	(if (and ItemNum InLst)
		(if (and (>= ItemNum 0) (< ItemNum (length InLst)))
			(cond	((= ItemNum 0)
						(setq	OutLst	(cdr InLst))
					)
					((= (1- (length InLst)) ItemNum)
						(setq	OutLst	(reverse (cdr (reverse InLst))))
					)
					(T
						(setq	OutLst	(list (car InLst))
								Cnt		1
						)
						(while (< Cnt ItemNum)
							(setq	OutLst	(append OutLst (list (nth Cnt InLst)))
									Cnt		(1+ Cnt)
							)
						)
						(setq	Cnt	(1+ ItemNum))
						(while (< Cnt (length InLst))
							(setq	OutLst	(append OutLst (list (nth Cnt InLst)))
									Cnt		(1+ Cnt)
							)
						)
					)
			)
			(setq	OutLst	InLst)
		)
		(setq	OutLst	InLst)
	)
	OutLst
)

(defun DupNBrk ( FirstPic /	Ent1 Back1 BakLst	; Duplicate and Break
						Back2 Back3 E1 E2 Sp1 Bubba)
;****************************************************************************
;Function:		DupNBrk
;Description:	Tests if Pline, if so it breaks by Erasing original and creating
;				two new Plines
;Called by:		TstBreakIt
;Required funs:	ReadOPoly (reads in data list from existing Old Polyline)
;				ReadNPoly (reads in data list from existing LW Polyline)
;				Make2OPoly (accepts data list and point, returns two entdata lists)
;Arguments:		(entsel pair) Entity name and picked point (point on entity)
;Returns:		list of two entity names created from entdata lists
;Globals:		None
;****************************************************************************
	(if Bug 
		(progn
			(princ "\nUtils.Lsp!DupNBrk - Enter parameter FirstPic(list): ")
			(prin1 FirstPic)
			(princ "\n")
		)
	)

	(if (and Bug (= (type (car FirstPic)) (quote ENAME)))
		(princ "\nDup got ename!")
	)
	(if (and Bug (= (type (cdr FirstPic)) (quote LIST)))
		(princ "\nDup got Pt List!")
	)
	(if Bug
		(princ (strcat	"\nDupBrkPtSent = "
					(rtos (car (nth 1 FirstPic)) 2 2)
					","
					(rtos (cadr (nth 1 FirstPic)) 2 2)
			  )
		)
	)
	(if FirstPic
		(setq Ent1 (entget (car FirstPic) (list "*")))
		(princ "\nNothing Selected!")
	)
	(if Ent1
		(if (= (cdr (assoc 0 Ent1)) "POLYLINE")
			(setq Back1 (ReadOPoly Ent1)
				 Bubba (if Bug
						  (princ "\nOriginal Polyline read in.")
					  )
			)
			(if (= (cdr (assoc 0 Ent1)) "LWPOLYLINE")
				(setq Back1 (ReadNPoly Ent1)
					 Bubba (if Bug
							  (princ
								  "\nOptimized Polyline read in."
							  )
						  )
				)
				(princ "\nNot any kind of Polyline!")
			)
		)
		(princ "\nNo Valid Data!")
	)
	(if Back1
		(if (= (cdr (assoc 0 Ent1)) "POLYLINE")
			(setq BakLst (Make2OPoly Back1 (cadr FirstPic))
				 Bubba  (if Bug
						   (if (and (car BakLst) (nth 1 BakLst))
							   (princ
								   "\nTwo Original Polyline definitions written."
							   )
							   (princ
								   "\nTwo Original Polyline definitions NOT written.\n"
							   )
						   )
					   )
			)
			(if (= (cdr (assoc 0 Ent1)) "LWPOLYLINE")
				(setq BakLst (Make2NPoly Back1 (cadr FirstPic))
					 Bubba  (if Bug
							   (princ
								   "\nTwo Optimized Polyline definitions written.\n"
							   )
						   )
				)
				(princ "\nNot any kind of Polyline!")
			)
		)
	)
	(if BakLst
		(setq Back2 (nth 0 BakLst)
			 Back3 (nth 1 BakLst)
		)
	)
	(command "_.ERASE" (car FirstPic) "")
	(if Ent1
		(if (= (cdr (assoc 0 Ent1)) "POLYLINE")
			(if Back2
				(progn
					(mapcar (quote entmake) Back2)
					(setq E1 (entlast))
				)
				(princ "\nNo First EntLst for PLine Make!")
			)
			(if Back2
				(progn
					(entmake Back2)
					(setq E1 (entlast))
				)
				(princ "\nNo First EntLst for PLine Make!")
			)
		)
	)
	(if Ent1
		(if (= (cdr (assoc 0 Ent1)) "POLYLINE")
			(if Back3
				(progn
					(mapcar (quote entmake) Back3)
					(setq E2 (entlast))
				)
				(princ "\nNo Second EntLst for PLine Make!")
			)
			(if Back3
				(progn
					(entmake Back3)
					(setq E2 (entlast))
				)
				(princ "\nNo Second EntLst for PLine Make!")
			)
		)
	)
	(if (and Ent1 (or (= (stpDot AppNam) "CADET20")(= (stpDot AppNam) "CADET")))
		(if (= (cdr (assoc 0 Ent1)) "POLYLINE")
			(if (setq	Sp1 (ssget "X"
							 (list (assoc 0 (car Back2))
								  (assoc 8 (car Back2))
							 )
					    )
			    )
				(progn
					(if (= (getvar "REGENMODE") 0)
						(setvar "REGENMODE" 1)
					)
					(command "DRAWORDER" Sp1 "" "B")
				)
			)
			(if (setq	Sp1 (ssget
						    "X"
						    (list (assoc 0 Back2) (assoc 8 Back2))
					    )
			    )
				(progn
					(if (= (getvar "REGENMODE") 0)
						(setvar "REGENMODE" 1)
					)
					(command "DRAWORDER" Sp1 "" "B")
				)
			)
		)
		(if (= (getvar "REGENMODE") 0)
			(setvar "REGENMODE" 1)
		)
	)
	(if Bug 
		(progn
			(princ "\nUtils.Lsp!DupNBrk - Return(list): ")
			(prin1 (list E1 E2))
			(princ "\n")
		)
	)

	(list E1 E2)
)

(defun TstBreakIt ( Ent_Sel /	Bubba EntNam	; Test Plines and Break by Rules
							Pta RLst Ptb Ptc Ptx Pty Ptz Ent
							e2 Lyr Fuzz e3 Cnt EntBak )
;****************************************************************************
;Function:		TstBreakIt
;Description:	Tests Pline entity & point to see if point selected is:
;					1) Ultimate endpoint of Pline (no break performed)
;					2) Within Fuzz of segment endpoint (break performed at endpoint)
;					3) Pline is broken at nearest point to selected point
;Called by:		DrawPolyline
;Required funs:	DupNBrk (which performs Erase and redraws both resulting plines)
;Arguments:		(entsel pair) Entity name and picked point
;Returns:		(entsel pair) Entity name and point on entity
;Globals:		Lst_Ph_W	SF (used to calculate Fuzz factor)
;****************************************************************************
	(if Bug 
		(progn
			(princ "\nUtils.Lsp!TstBreakIt - Enter parameter Ent_Sel(list): ")
			(prin1 Ent_Sel)
			(princ "\n")
		)
	)
	(setq	Pta		(cadr Ent_Sel)
			Ent		(car Ent_Sel)
			Ptb		(osnap Pta "end") ;End point of selected object
			Ptc		(osnap Pta "nea") ;Nea point of selected object
			Ptx		nil			   ;Beginning polyline point
			Pty		nil			   ;End Polyline point
			e2		(entget Ent (list "*"))
			Lyr		(cdr (assoc 8 (entget Ent)))
			Fuzz		(if (and(/= Div "GA")(/= Div "AL"))
			    			(* (nth (atoi (substr Lyr 8 1)) Lst_Ph_W) SF)
						0.30480
					)
	)
	;Sets Ptx and Pty to the end points of the selected polyline
	(cond ((= (cdr (assoc 0 e2)) "POLYLINE")
		  (setq e3  (entnext Ent)   ;Set e3 to the next polyline segment
			   Ptx (cdr (assoc 10 (entget e3)))
		  )
		  (while (/= (cdr (assoc 0 (entget e3))) "SEQEND")
			  (setq Pty (cdr (assoc 10 (entget e3)))
				   e3  (entnext e3)
			  )
		  )
		 )
		 ((= (cdr (assoc 0 e2)) "LWPOLYLINE")
		  (setq Cnt 0)
		  (repeat	(length e2)
			  (if (= (car (nth Cnt e2)) 10)
				  (progn
					  (if (null Ptx)
						  (setq Ptx (cdr (nth Cnt e2)))
					  )
					  (setq Pty (cdr (nth Cnt e2)))
				  )
			  )
			  (setq Cnt (1+ Cnt))
		  )
		 )
	)
	(if (and Ptx Pty)
		(cond ((equal Ptb Ptc Fuzz)	;Check end point and near point to see if they are within the Fuzz distance
			  (if (or (equal Ptb Ptx 0.001) (equal Ptb Pty 0.001))	    ;Check to see if end point is withing .001 of the polylines end points 
				  (setq Ptz   Ptb
					   RLst  (cons Ent (list Ptz))
					   Bubba (if Bug
							    (princ
								    "\nTstBreakIt found at End of PolyLine, no break made."
							    )
						    )
				  )
				  (progn
					  (setq Ptz	Ptb
						   Bubba	(if Bug
									(princ
										(strcat
											"\nPtz = "
											(rtos (car Ptz) 2 2)
											","
											(rtos (cadr Ptz)
												 2
												 2
											)
										)
									)
								)
						   EntBak	(DupNBrk (cons Ent (list Ptz)))
						   Bubba	(if Bug
									(princ
										"\nTstBreakIt found to be End of Segment, break made."
									)
								)
					  )
					  (if (= (cdr (assoc 0 e2)) "POLYLINE")
						  (setq EntNam	(cadr EntBak)
							   AltNam	(car EntBak)
							   RLst	(cons EntNam (list Ptz))
						  )
						  (setq RLst (cons Ent (list Ptz)))
					  )
				  )
			  )
			  (if Bug
				  (princ (strcat "\nPta = "
							  (rtos (car Pta) 2 2)
							  ","
							  (rtos (cadr Pta) 2 2)
							  " Original Pick"
							  "\nPtb = "
							  (rtos (car Ptb) 2 2)
							  ","
							  (rtos (cadr Ptb) 2 2)
							  " End Osnap"
							  "\nPtc = "
							  (rtos (car Ptc) 2 2)
							  ","
							  (rtos (cadr Ptc) 2 2)
							  " Near Osnap"
							  "\nPtx = "
							  (rtos (car Ptx) 2 2)
							  ","
							  (rtos (cadr Ptx) 2 2)
							  " PLine End One"
							  "\nPty = "
							  (rtos (car Pty) 2 2)
							  ","
							  (rtos (cadr Pty) 2 2)
							  " PLine End Two"
							  "\nFuzz = "
							  (rtos Fuzz 2 2)
					    )
				  )
			  )
			 )
			 (T
			  (setq Ptz	Ptc
				   Bubba	(if Bug
							(princ (strcat	"\nPtz = "
										(rtos (car Ptz) 2 2)
										","
										(rtos (cadr Ptz) 2 2)
								  )
							)
						)
				   EntBak	(DupNBrk (cons Ent (list Ptz)))
				   Bubba	(if Bug
							(princ
								"\nTstBreakIt found in between, break made."
							)
						)
			  )
			  (if (= (cdr (assoc 0 e2)) "POLYLINE")
				  (setq EntNam	(cadr EntBak)
					   AltNam	(car EntBak)
					   RLst	(cons EntNam (list Ptz))
				  )
				  (setq RLst (cons Ent (list Ptz)))
			  )
			  (if Bug
				  (princ (strcat "\nPta = "
							  (rtos (car Pta) 2 2)
							  ","
							  (rtos (cadr Pta) 2 2)
							  " Original Pick"
							  "\nPtb = "
							  (rtos (car Ptb) 2 2)
							  ","
							  (rtos (cadr Ptb) 2 2)
							  " End Osnap"
							  "\nPtc = "
							  (rtos (car Ptc) 2 2)
							  ","
							  (rtos (cadr Ptc) 2 2)
							  " Near Osnap"
							  "\nPtx = "
							  (rtos (car Ptx) 2 2)
							  ","
							  (rtos (cadr Ptx) 2 2)
							  " PLine End One"
							  "\nPty = "
							  (rtos (car Pty) 2 2)
							  ","
							  (rtos (cadr Pty) 2 2)
							  " PLine End Two"
							  "\nFuzz = "
							  (rtos Fuzz 2 2)
					    )
				  )
			  )
			 )
		)
		(progn
			(setq Ptz	   Ptc
				 Bubba  (if Bug
						   (princ	(strcat "\nPtz = "
									   (rtos (car Ptz) 2 2)
									   ","
									   (rtos (cadr Ptz) 2 2)
								)
						   )
					   )
				 EntBak (DupNBrk (cons Ent (list Ptz)))
			)
			(if (= (cdr (assoc 0 e2)) "POLYLINE")
				(setq EntNam (cadr EntBak)
					 AltNam (car EntBak)
					 RLst   (cons EntNam (list Ptz))
				)
				(setq RLst (cons Ent (list Ptz)))
			)
			(if Bug
				(princ (strcat	"\nPta = "
							(rtos (car Pta) 2 2)
							","
							(rtos (cadr Pta) 2 2)
							" Original Pick"
							"\nPtb = "
							(rtos (car Ptb) 2 2)
							","
							(rtos (cadr Ptb) 2 2)
							" End Osnap"
							"\nPtc = "
							(rtos (car Ptc) 2 2)
							","
							(rtos (cadr Ptc) 2 2)
							" Near Osnap"
							"\nFuzz = "
							(rtos Fuzz 2 2)
					  )
				)
			)
		)
	)
	(if Bug 
		(progn
			(princ "\nUtils.Lsp!TstBreakIt - Done return(list): ")
			(prin1 RLst)
			(princ "\n")
		)
	)
	RLst
)

(defun GetPLDat ( FirstPic / Ent1 Back1 Bubba	; Get and return Pline Data
						Back8 Back9 MPtLst NumLst PolyDat X )
	(if Bug 
		(progn
			(princ "\nUtils.Lsp!GetPLDat - Enter parameter FirstPic(list): ")
			(prin1 FirstPic)
			(princ "\n")
		)
	)
	
	(if (and Bug (= (type (car FirstPic)) (quote ENAME)))
		(princ "\nGetPLDat got ename!")
	)
	(if (and Bug (= (type (cdr FirstPic)) (quote LIST)))
		(princ "\nGetPLDat got Pt List!")
	)
	(if Bug
		(princ (strcat	"\nGetPLDat = "
					(rtos (car (nth 1 FirstPic)) 2 2)
					","
					(rtos (cadr (nth 1 FirstPic)) 2 2)
			  )
		)
	)
	(if FirstPic
		(setq Ent1 (entget (car FirstPic) (list "*")))
		(princ "\nNothing Selected!")
	)
	(if Ent1
		(if (= (cdr (assoc 0 Ent1)) "POLYLINE")
			(setq Back1 (ReadOPoly Ent1)
				 Bubba (if Bug
						  (princ "\nOriginal Polyline read in.")
					  )
			)
			(if (= (cdr (assoc 0 Ent1)) "LWPOLYLINE")
				(setq Back1 (ReadNPoly Ent1)
					 Bubba (if Bug
							  (princ
								  "\nOptimized Polyline read in."
							  )
						  )
				)
				(princ "\nNot any kind of Polyline!")
			)
		)
		(princ "\nNo Valid Data!")
	)
	(if Back1
		(if (= (cdr (assoc 0 Ent1)) "POLYLINE")
			(progn
				(setq Back9 (cadr Back1)
					 Back8 (cddr Back1)
				)
				(mapcar (quote (lambda (x) (setq Back9 (append Back9 x)))) Back8)
				(setq 	MPtLst	(BldMstPLst Back9 (cadr FirstPic))
					 	NumLst	(nth 1 MPtLst)
					 	MPtLst	(nth 0 MPtLst)
						Bubba	(if Bug (setq EdsMpt MPtLst))
					 	PolyDat	(FindIntPoly MPtLst (cadr FirstPic))
					 	IntNum 	(car PolyDat)
					 	Vrt1   	(nth (1+ IntNum) Back1)
					 	Vrt2   	(nth (+ 2 IntNum) Back1)
					 	Vpt1   	(cdr (assoc 10 Vrt1))
					 	Vpt2   	(cdr (assoc 10 Vrt2))
					 	Blg1   	(cdr (assoc 42 Vrt1))
					 	Cnt	  	0
					 	MakNum 	nil
					 	BLen   	(length Back1)
				)
				(if (equal Blg1 0.0 0.001)
					(setq Ang	  (angle Vpt1 Vpt2)
						 Xpt1  (polar (cadr FirstPic) (+ Ang (/ pi 2.0)) 50.0)
						 Xpt2  (polar (cadr FirstPic) (- Ang (/ pi 2.0)) 50.0)
						 Xpt0  (inters Vpt1 Vpt2 Xpt1 Xpt2)
						 CrvT  nil
						 Bubba (if Bug
								  (princ "\nNot a bulge-data PLine")
							  )
					)
					(setq CrvT   T
						 CrvLst (CalcBlgInt
								   Vpt1
								   Vpt2
								   (cadr FirstPic)
								   (cdr (assoc 42 Vrt1))
							   )
						 Xpt0   (nth 0 CrvLst)
						 Crv1   (nth 1 CrvLst)
						 Crv2   (nth 2 CrvLst)
						 Bubba  (if Bug
								   (princ "\nA bulge-data PLine")
							   )
					)
				)
				(setq 	WolyDat	(list	(nth 0 PolyDat)
										(nth 1 PolyDat)
										(list	(nth 1 (nth (car PolyDat) MPtLst))
												(nth 2 (nth (car PolyDat) MPtLst))
										)
										(list	(nth 1 (nth (1+ (car PolyDat)) MPtLst))
												(nth 2 (nth (1+ (car PolyDat)) MPtLst))
										)
										(angle	(list	(nth 1 (nth (car PolyDat) MPtLst))
														(nth 2 (nth (car PolyDat) MPtLst))
												)
												(list	(nth 1 (nth (1+ (car PolyDat)) MPtLst))
														(nth 2 (nth (1+ (car PolyDat)) MPtLst))
												)
										)
										(nth 5 PolyDat)
								)
						Bubba	(if Bug
									(princ "\nPolyDat Found.")
								)
				)
			)
			(if (= (cdr (assoc 0 Ent1)) "LWPOLYLINE")
				(setq	MPtLst	(BldMstPLst Back1 (cadr FirstPic))
						NumLst	(nth 1 MPtLst)
						MPtLst	(nth 0 MPtLst)
						Bubba	(if Bug (setq EdsMpt MPtLst))
						PolyDat	(FindIntPoly MPtLst (cadr FirstPic))
						WolyDat	(list	(nth 0 PolyDat)
										(nth 1 PolyDat)
										(list	(nth 1 (nth (car PolyDat) MPtLst))
												(nth 2 (nth (car PolyDat) MPtLst))
										)
										(list	(nth 1 (nth (1+ (car PolyDat)) MPtLst))
												(nth 2 (nth (1+ (car PolyDat)) MPtLst))
										)
										(angle	(list	(nth 1 (nth (car PolyDat) MPtLst))
														(nth 2 (nth (car PolyDat) MPtLst))
												)
												(list	(nth 1 (nth (1+ (car PolyDat)) MPtLst))
														(nth 2 (nth (1+ (car PolyDat)) MPtLst))
												)
										)
										(nth 5 PolyDat)
								)
						Bubba	(if Bug
									(princ "\nPolyDat Found.")
								)
				)
				(princ "\nNot any kind of Polyline!")
			)
		)
	)
	WolyDat
)

(defun MakBox ( Ent1 /	Pdat PtLst Pt1 Pt2 Pt3	; Make Box
					Pt4 Ang0 Ang1 Dst0 dX dY )
	(setq Pdat  (textbox Ent1)
		 PtLst (list (mapcar (quote +) (cdr (assoc 10 Ent1)) (nth 0 Pdat))
				   (mapcar (quote +) (cdr (assoc 10 Ent1)) (nth 1 Pdat))
			  )
	)
	(if (assoc 50 Ent1)
		(setq Ang1 (cdr (assoc 50 Ent1)))
		(setq Ang1 0.0)
	)
	(if (equal Ang1 0.0 0.01)
		(setq Pt1	(nth 0 PtLst)
			 dX	(- (car (nth 1 PtLst)) (car (nth 0 PtLst)))
			 dY	(- (cadr (nth 1 PtLst)) (cadr (nth 0 PtLst)))
			 Pt2	(list (car (nth 1 PtLst)) (cadr (nth 0 PtLst)))
			 Pt3	(nth 1 PtLst)
			 Pt4	(list (car (nth 0 PtLst)) (cadr (nth 1 PtLst)))
		)
		(setq Ang0 (angle (cdr (assoc 10 Ent1)) (nth 0 PtLst))
			 Dst0 (distance (cdr (assoc 10 Ent1)) (nth 0 PtLst))
			 dX	 (- (car (nth 1 PtLst)) (car (nth 0 PtLst)))
			 dY	 (- (cadr (nth 1 PtLst)) (cadr (nth 0 PtLst)))
			 Pt1	 (polar (cdr (assoc 10 Ent1)) (+ Ang1 Ang0) Dst0)
			 Pt2	 (polar Pt1 Ang1 dX)
			 Pt3	 (polar Pt2 (+ Ang1 (/ pi 2.0)) dY)
			 Pt4	 (polar Pt3 (+ Ang1 pi) dX)
		)
	)
	(if Bug
		(princ (strcat	"\nFound dX = "
					(rtos dX 2 4)
					"\nFound dY = "
					(rtos dY 2 4)
			  )
		)
	)
	(list Pt1 Pt2 Pt3 Pt4)
)

(defun AttBox ( Ang0 Dst0 EntLst /	EntBox	; Returns Bounding Box of Text/Attribute
								Pt1 Pt2 Pt3 Pt4 Pt5 Pt6 Pt7 Pt8 Pt9 )
	(if EntLst
		(setq	EntBox	(textbox EntLst)
				Pt1		(mapcar (quote +) (cdr (assoc 10 EntLst)) (nth 0 EntBox))
		)
	)
	(if (and Ang0 Dst0)
		(setq	Pt1	(polar Pt1 Ang0 Dst0))
	)
	(if Pt1
		(setq	Pt2		(polar	Pt1								;1 Lower-Right Point
								(cdr (assoc 50 EntLst))
								(- (car (nth 1 EntBox)) (car (nth 0 EntBox)))
						)
				Pt3		(polar	Pt2								;2 Upper-Right Point
								(+ (cdr (assoc 50 EntLst)) (/ pi 2.0))
								(- (cadr (nth 1 EntBox)) (cadr (nth 0 EntBox)))
						)
				Pt4		(polar	Pt1								;3 Upper-Left Point
								(+ (cdr (assoc 50 EntLst)) (/ pi 2.0))
								(- (cadr (nth 1 EntBox)) (cadr (nth 0 EntBox)))
						)
				Pt5		(polar	Pt1								;4 Center-Bottom Point
								(cdr (assoc 50 EntLst))
								(/ (- (car (nth 1 EntBox)) (car (nth 0 EntBox))) 2.0)
						)
				Pt6		(polar	Pt5								;5 Center-Top Point
								(+ (cdr (assoc 50 EntLst)) (/ pi 2.0))
								(- (cadr (nth 1 EntBox)) (cadr (nth 0 EntBox)))
						)
				Pt7		(polar	Pt1								;6 Middle-Left Point
								(+ (cdr (assoc 50 EntLst)) (/ pi 2.0))
								(/ (- (cadr (nth 1 EntBox)) (cadr (nth 0 EntBox))) 2.0)
						)
				Pt8		(polar	Pt2								;7 Middle-Right Point
								(+ (cdr (assoc 50 EntLst)) (/ pi 2.0))
								(/ (- (cadr (nth 1 EntBox)) (cadr (nth 0 EntBox))) 2.0)
						)
				Pt9		(polar	Pt5								;8 Middle-Middle Point
								(+ (cdr (assoc 50 EntLst)) (/ pi 2.0))
								(/ (- (cadr (nth 1 EntBox)) (cadr (nth 0 EntBox))) 2.0)
						)
		)
	)
	(list Pt1 Pt2 Pt3 Pt4 Pt5 Pt6 Pt7 Pt8 Pt9 (cdr (assoc 40 EntLst)) (cdr (assoc 50 EntLst)))
)

(defun AttRotBox ( Ang0 Dst0 Rot0 EntLst /	Pt1	; Returns Bounding Box of Text/Attribute
									EntBox Pt2 Pt3 Pt4 Pt5 Pt6 Pt7 Pt8 Pt9 )
	(if EntLst
		(setq	EntBox	(textbox EntLst)
				Pt1		(mapcar (quote +) (cdr (assoc 10 EntLst)) (nth 0 EntBox))
				Pt3		(mapcar (quote +) (cdr (assoc 10 EntLst)) (nth 1 EntBox))
		)
	)
	(if (and Ang0 Dst0)												;Is there a displacement position?
		(setq	Pt1	(polar Pt1 Ang0 Dst0))
	)
	(if Pt1
		(setq	Pt2		(polar	Pt1								;1 Lower-Right Point
								(cdr (assoc 50 EntLst))
								(- (car (nth 1 EntBox)) (car (nth 0 EntBox)))
						)
				Pt3		(polar	Pt2								;2 Upper-Right Point
								(+ (cdr (assoc 50 EntLst)) (/ pi 2.0))
								(- (cadr (nth 1 EntBox)) (cadr (nth 0 EntBox)))
						)
				Pt4		(polar	Pt1								;3 Upper-Left Point
								(+ (cdr (assoc 50 EntLst)) (/ pi 2.0))
								(- (cadr (nth 1 EntBox)) (cadr (nth 0 EntBox)))
						)
				Pt5		(polar	Pt1								;4 Center-Bottom Point
								(cdr (assoc 50 EntLst))
								(/ (- (car (nth 1 EntBox)) (car (nth 0 EntBox))) 2.0)
						)
				Pt6		(polar	Pt5								;5 Center-Top Point
								(+ (cdr (assoc 50 EntLst)) (/ pi 2.0))
								(- (cadr (nth 1 EntBox)) (cadr (nth 0 EntBox)))
						)
				Pt7		(polar	Pt1								;6 Middle-Left Point
								(+ (cdr (assoc 50 EntLst)) (/ pi 2.0))
								(/ (- (cadr (nth 1 EntBox)) (cadr (nth 0 EntBox))) 2.0)
						)
				Pt8		(polar	Pt2								;7 Middle-Right Point
								(+ (cdr (assoc 50 EntLst)) (/ pi 2.0))
								(/ (- (cadr (nth 1 EntBox)) (cadr (nth 0 EntBox))) 2.0)
						)
				Pt9		(polar	Pt5								;8 Middle-Middle Point
								(+ (cdr (assoc 50 EntLst)) (/ pi 2.0))
								(/ (- (cadr (nth 1 EntBox)) (cadr (nth 0 EntBox))) 2.0)
						)
		)
	)
	(if (and Rot0 Pt9)												;Is there a rotational change?
		(setq	EntLst	(subst (cons 50 (+ Rot0 (cdr (assoc 50 EntLst)))) (assoc 50 EntLst) EntLst)
				Pt5		(polar	Pt9								;4 Center-Bottom Point
								(+ (cdr (assoc 50 EntLst)) (/ (* pi 3.0) 2.0))
								(/ (- (cadr (nth 1 EntBox)) (cadr (nth 0 EntBox))) 2.0)
						)
				Pt6		(polar	Pt5								;5 Center-Top Point
								(+ (cdr (assoc 50 EntLst)) (/ pi 2.0))
								(- (cadr (nth 1 EntBox)) (cadr (nth 0 EntBox)))
						)
				Pt1		(polar	Pt5								;0 Lower-Left Point
								(+ (cdr (assoc 50 EntLst)) pi)
								(/ (- (car (nth 1 EntBox)) (car (nth 0 EntBox))) 2.0)
						)
				Pt2		(polar	Pt1								;1 Lower-Right Point
								(cdr (assoc 50 EntLst))
								(- (car (nth 1 EntBox)) (car (nth 0 EntBox)))
						)
				Pt3		(polar	Pt2								;2 Upper-Right Point
								(+ (cdr (assoc 50 EntLst)) (/ pi 2.0))
								(- (cadr (nth 1 EntBox)) (cadr (nth 0 EntBox)))
						)
				Pt4		(polar	Pt1								;3 Upper-Left Point
								(+ (cdr (assoc 50 EntLst)) (/ pi 2.0))
								(- (cadr (nth 1 EntBox)) (cadr (nth 0 EntBox)))
						)
				Pt7		(polar	Pt1								;6 Middle-Left Point
								(+ (cdr (assoc 50 EntLst)) (/ pi 2.0))
								(/ (- (cadr (nth 1 EntBox)) (cadr (nth 0 EntBox))) 2.0)
						)
				Pt8		(polar	Pt2								;7 Middle-Right Point
								(+ (cdr (assoc 50 EntLst)) (/ pi 2.0))
								(/ (- (cadr (nth 1 EntBox)) (cadr (nth 0 EntBox))) 2.0)
						)
		)
	)
	(list Pt1 Pt2 Pt3 Pt4 Pt5 Pt6 Pt7 Pt8 Pt9 (cdr (assoc 40 EntLst)) (cdr (assoc 50 EntLst)))
)

(defun AttValAdj ( ValBoxLst AttLst / )		; Adjusts Attribute Group Codes to match incoming list
	(cond
		((and (= (cdr (assoc 72 AttLst)) 0) (or (= (cdr (assoc 74 AttLst)) 0) (= (cdr (assoc 74 AttLst)) 1)))
															;Plain Left-Baseline Justified
			(setq	AttLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 AttLst) AttLst)	;0  Lower-Left Point
					AttLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 AttLst) AttLst)
					AttLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 AttLst) AttLst)
			)
		)
		((and (= (cdr (assoc 72 AttLst)) 1) (or (= (cdr (assoc 74 AttLst)) 0) (= (cdr (assoc 74 AttLst)) 1)))
															;Plain Center-Baseline Justified
			(setq	AttLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 AttLst) AttLst)	;0  Lower-Left Point
					AttLst		(subst (cons 11 (nth 4 ValBoxLst)) (assoc 11 AttLst) AttLst)	;4  Center-Bottom Point
					AttLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 AttLst) AttLst)
					AttLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 AttLst) AttLst)
			)
		)
		((and (= (cdr (assoc 72 AttLst)) 2) (or (= (cdr (assoc 74 AttLst)) 0) (= (cdr (assoc 74 AttLst)) 1)))
															;Plain Right-Baseline Justified
			(setq	AttLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 AttLst) AttLst)	;0  Lower-Left Point
					AttLst		(subst (cons 11 (nth 1 ValBoxLst)) (assoc 11 AttLst) AttLst)	;1  Lower-Right Point
					AttLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 AttLst) AttLst)
					AttLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 AttLst) AttLst)
			)
		)
		((and (= (cdr (assoc 72 AttLst)) 4) (or (= (cdr (assoc 74 AttLst)) 0) (= (cdr (assoc 74 AttLst)) 1)))
															;Plain Middle-Baseline Justified
			(setq	AttLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 AttLst) AttLst)	;0  Lower-Left Point
					AttLst		(subst (cons 11 (nth 8 ValBoxLst)) (assoc 11 AttLst) AttLst)	;4  Center-Bottom Point
					AttLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 AttLst) AttLst)	;Was (nth 4 ValBoxLst)
					AttLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 AttLst) AttLst)
			)
		)
		((and (= (cdr (assoc 72 AttLst)) 0) (= (cdr (assoc 74 AttLst)) 2))	;Middle-Left Justified
			(setq	AttLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 AttLst) AttLst)	;0  Lower-Left Point
					AttLst		(subst (cons 11 (nth 6 ValBoxLst)) (assoc 11 AttLst) AttLst)	;6  Middle-Left Point
					AttLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 AttLst) AttLst)
					AttLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 AttLst) AttLst)
			)
		)
		((and (= (cdr (assoc 72 AttLst)) 1) (= (cdr (assoc 74 AttLst)) 2))	;Middle-Center Justified
			(setq	AttLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 AttLst) AttLst)	;0  Lower-Left Point
					AttLst		(subst (cons 11 (nth 8 ValBoxLst)) (assoc 11 AttLst) AttLst)	;8  Middle-Middle Point
					AttLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 AttLst) AttLst)
					AttLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 AttLst) AttLst)
			)
		)
		((and (= (cdr (assoc 72 AttLst)) 2) (= (cdr (assoc 74 AttLst)) 2))	;Middle-Right Justified
			(setq	AttLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 AttLst) AttLst)	;0  Lower-Left Point
					AttLst		(subst (cons 11 (nth 7 ValBoxLst)) (assoc 11 AttLst) AttLst)	;7  Middle-Right Point
					AttLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 AttLst) AttLst)
					AttLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 AttLst) AttLst)
			)
		)
		((and (= (cdr (assoc 72 AttLst)) 4) (= (cdr (assoc 74 AttLst)) 2))	;Middle-Middle Justified
			(setq	AttLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 AttLst) AttLst)	;0  Lower-Left Point
					AttLst		(subst (cons 11 (nth 8 ValBoxLst)) (assoc 11 AttLst) AttLst)	;8  Middle-Middle Point
					AttLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 AttLst) AttLst)	
					AttLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 AttLst) AttLst)
			)
		)
		((and (= (cdr (assoc 72 AttLst)) 0) (= (cdr (assoc 74 AttLst)) 3))	;Top-Left Justified
			(setq	AttLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 AttLst) AttLst)	;0  Lower-Left Point
					AttLst		(subst (cons 11 (nth 3 ValBoxLst)) (assoc 11 AttLst) AttLst)	;3  Upper-Left Point
					AttLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 AttLst) AttLst)
					AttLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 AttLst) AttLst)
			)
		)
		((and (= (cdr (assoc 72 AttLst)) 1) (= (cdr (assoc 74 AttLst)) 3))	;Top-Center Justified
			(setq	AttLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 AttLst) AttLst)	;0  Lower-Left Point
					AttLst		(subst (cons 11 (nth 5 ValBoxLst)) (assoc 11 AttLst) AttLst)	;5  Center-Top Point
					AttLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 AttLst) AttLst)
					AttLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 AttLst) AttLst)
			)
		)
		((and (= (cdr (assoc 72 AttLst)) 2) (= (cdr (assoc 74 AttLst)) 3))	;Top-Right Justified
			(setq	AttLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 AttLst) AttLst)	;0  Lower-Left Point
					AttLst		(subst (cons 11 (nth 2 ValBoxLst)) (assoc 11 AttLst) AttLst)	;2  Upper-Right Point
					AttLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 AttLst) AttLst)
					AttLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 AttLst) AttLst)
			)
		)
		((and (= (cdr (assoc 72 AttLst)) 4) (= (cdr (assoc 74 AttLst)) 3))	;Top-Middle Justified
			(setq	AttLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 AttLst) AttLst)	;0  Lower-Left Point
					AttLst		(subst (cons 11 (nth 5 ValBoxLst)) (assoc 11 AttLst) AttLst)	;5  Center-Top Point
					AttLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 AttLst) AttLst)
					AttLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 AttLst) AttLst)
			)
		)
	)
	AttLst
)

(defun TxtValAdj ( ValBoxLst TxtLst / )		; Adjusts Text Group Codes to match incoming list
	(cond
		((and (= (cdr (assoc 72 TxtLst)) 0) (or (= (cdr (assoc 73 TxtLst)) 0) (= (cdr (assoc 73 TxtLst)) 1)))
															;Plain Left-Baseline Justified
			(setq	TxtLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 TxtLst) TxtLst)	;0  Lower-Left Point
					TxtLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 TxtLst) TxtLst)
					TxtLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 TxtLst) TxtLst)
			)
		)
		((and (= (cdr (assoc 72 TxtLst)) 1) (or (= (cdr (assoc 73 TxtLst)) 0) (= (cdr (assoc 73 TxtLst)) 1)))
															;Plain Center-Baseline Justified
			(setq	TxtLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 TxtLst) TxtLst)	;0  Lower-Left Point
					TxtLst		(subst (cons 11 (nth 4 ValBoxLst)) (assoc 11 TxtLst) TxtLst)	;4  Center-Bottom Point
					TxtLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 TxtLst) TxtLst)
					TxtLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 TxtLst) TxtLst)
			)
		)
		((and (= (cdr (assoc 72 TxtLst)) 2) (or (= (cdr (assoc 73 TxtLst)) 0) (= (cdr (assoc 73 TxtLst)) 1)))
															;Plain Right-Baseline Justified
			(setq	TxtLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 TxtLst) TxtLst)	;0  Lower-Left Point
					TxtLst		(subst (cons 11 (nth 1 ValBoxLst)) (assoc 11 TxtLst) TxtLst)	;1  Lower-Right Point
					TxtLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 TxtLst) TxtLst)
					TxtLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 TxtLst) TxtLst)
			)
		)
		((and (= (cdr (assoc 72 TxtLst)) 4) (or (= (cdr (assoc 73 TxtLst)) 0) (= (cdr (assoc 73 TxtLst)) 1)))
															;Plain Middle-Baseline Justified
			(setq	TxtLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 TxtLst) TxtLst)	;0  Lower-Left Point
					TxtLst		(subst (cons 11 (nth 8 ValBoxLst)) (assoc 11 TxtLst) TxtLst)	;4  Center-Bottom Point
					TxtLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 TxtLst) TxtLst)	;Was (nth 4 ValBoxLst)
					TxtLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 TxtLst) TxtLst)
			)
		)
		((and (= (cdr (assoc 72 TxtLst)) 0) (= (cdr (assoc 73 TxtLst)) 2))	;Middle-Left Justified
			(setq	TxtLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 TxtLst) TxtLst)	;0  Lower-Left Point
					TxtLst		(subst (cons 11 (nth 6 ValBoxLst)) (assoc 11 TxtLst) TxtLst)	;6  Middle-Left Point
					TxtLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 TxtLst) TxtLst)
					TxtLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 TxtLst) TxtLst)
			)
		)
		((and (= (cdr (assoc 72 TxtLst)) 1) (= (cdr (assoc 73 TxtLst)) 2))	;Middle-Center Justified
			(setq	TxtLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 TxtLst) TxtLst)	;0  Lower-Left Point
					TxtLst		(subst (cons 11 (nth 8 ValBoxLst)) (assoc 11 TxtLst) TxtLst)	;8  Middle-Middle Point
					TxtLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 TxtLst) TxtLst)
					TxtLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 TxtLst) TxtLst)
			)
		)
		((and (= (cdr (assoc 72 TxtLst)) 2) (= (cdr (assoc 73 TxtLst)) 2))	;Middle-Right Justified
			(setq	TxtLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 TxtLst) TxtLst)	;0  Lower-Left Point
					TxtLst		(subst (cons 11 (nth 7 ValBoxLst)) (assoc 11 TxtLst) TxtLst)	;7  Middle-Right Point
					TxtLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 TxtLst) TxtLst)
					TxtLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 TxtLst) TxtLst)
			)
		)
		((and (= (cdr (assoc 72 TxtLst)) 4) (= (cdr (assoc 73 TxtLst)) 2))	;Middle-Middle Justified
			(setq	TxtLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 TxtLst) TxtLst)	;0  Lower-Left Point
					TxtLst		(subst (cons 11 (nth 8 ValBoxLst)) (assoc 11 TxtLst) TxtLst)	;8  Middle-Middle Point
					TxtLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 TxtLst) TxtLst)	
					TxtLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 TxtLst) TxtLst)
			)
		)
		((and (= (cdr (assoc 72 TxtLst)) 0) (= (cdr (assoc 73 TxtLst)) 3))	;Top-Left Justified
			(setq	TxtLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 TxtLst) TxtLst)	;0  Lower-Left Point
					TxtLst		(subst (cons 11 (nth 3 ValBoxLst)) (assoc 11 TxtLst) TxtLst)	;3  Upper-Left Point
					TxtLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 TxtLst) TxtLst)
					TxtLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 TxtLst) TxtLst)
			)
		)
		((and (= (cdr (assoc 72 TxtLst)) 1) (= (cdr (assoc 73 TxtLst)) 3))	;Top-Center Justified
			(setq	TxtLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 TxtLst) TxtLst)	;0  Lower-Left Point
					TxtLst		(subst (cons 11 (nth 5 ValBoxLst)) (assoc 11 TxtLst) TxtLst)	;5  Center-Top Point
					TxtLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 TxtLst) TxtLst)
					TxtLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 TxtLst) TxtLst)
			)
		)
		((and (= (cdr (assoc 72 TxtLst)) 2) (= (cdr (assoc 73 TxtLst)) 3))	;Top-Right Justified
			(setq	TxtLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 TxtLst) TxtLst)	;0  Lower-Left Point
					TxtLst		(subst (cons 11 (nth 2 ValBoxLst)) (assoc 11 TxtLst) TxtLst)	;2  Upper-Right Point
					TxtLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 TxtLst) TxtLst)
					TxtLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 TxtLst) TxtLst)
			)
		)
		((and (= (cdr (assoc 72 TxtLst)) 4) (= (cdr (assoc 73 TxtLst)) 3))	;Top-Middle Justified
			(setq	TxtLst		(subst (cons 10 (nth 0 ValBoxLst)) (assoc 10 TxtLst) TxtLst)	;0  Lower-Left Point
					TxtLst		(subst (cons 11 (nth 5 ValBoxLst)) (assoc 11 TxtLst) TxtLst)	;5  Center-Top Point
					TxtLst		(subst (cons 40 (nth 9 ValBoxLst)) (assoc 40 TxtLst) TxtLst)
					TxtLst		(subst (cons 50 (nth 10 ValBoxLst)) (assoc 50 TxtLst) TxtLst)
			)
		)
	)
	TxtLst
)

(defun C:MakBox ( / Ent1 E1 PBoxLst )			; CL Make Box
	(setq E1 nil)
	(while (null E1)
		(princ "\nSelect Text Entity to Box in: ")
		(setq E1 (entsel))
		(if E1
			(setq Ent1 (entget (car E1) (list "*")))
			(setq Ent1 nil)
		)
		(if Ent1
			(if (= (cdr (assoc 0 Ent1)) "TEXT")
				(setq PboxLst (MakBox Ent1))
				(setq E1 nil)
			)
			(setq E1 nil)
		)
	)
	(if PboxLst
		(if (nth 0 PboxLst)
			(command "_.PLINE"
				    (nth 0 PboxLst)
				    "W"
				    "0.0"
				    "0.0"
				    (nth 1 PboxLst)
				    (nth 2 PboxLst)
				    (nth 3 PboxLst)
				    "C"
			)
		)
	)
	(princ)
)

(defun C:AMakBox ( / Ent1 E1 PBoxLst )			; CL Make Box
	(setq E1 nil)
	(while (null E1)
		(princ "\nSelect Attrib Entity to Box in: ")
		(setq E1 (nentsel))
		(if E1
			(setq Ent1 (entget (car E1) (list "*")))
			(setq Ent1 nil)
		)
		(if Ent1
			(if (= (cdr (assoc 0 Ent1)) "ATTRIB")
				(setq PboxLst (MakBox Ent1))
				(setq E1 nil)
			)
			(setq E1 nil)
		)
	)
	(if PboxLst
		(if (nth 0 PboxLst)
			(command "_.PLINE"
				    (nth 0 PboxLst)
				    "W"
				    "0.0"
				    "0.0"
				    (nth 1 PboxLst)
				    (nth 2 PboxLst)
				    (nth 3 PboxLst)
				    "C"
			)
		)
	)
	(princ)
)

(defun PadNum ( LED DesLen / LEDlen )			; Pads numbers with 0 to desired length
	(setq	LEDlen	(strlen LED))
	(if (< LEDlen DesLen)
		(progn
			(while (< LEDlen DesLen)
				(setq	LED	(strcat "0" LED)
					LEDlen	(strlen LED)
				)
			)
			LED
		)
		(substr LED 1 DesLen)
	)
)

(defun LayChk ( Layt / TestR TestL )			; Tests for valid layer
	(setq Layt  (strcase Layt)
		 TestR nil
		 TestL (strcase (cdr (assoc 2 (tblnext "LAYER" T))))
	)
	(if (= TestL Layt)
		(setq TestR T)
		(while (setq TestL (cdr (assoc 2 (tblnext "LAYER"))))
			(if (wcmatch (strcase TestL) Layt)
				(setq TestR T)
			)
		)
	)
	TestR
)

(defun StyChk ( Styt / TestR TestL )			; Tests for valid style
	(setq Styt  (strcase Styt)
		 TestR nil
		 TestL (strcase (cdr (assoc 2 (tblnext "STYLE" T))))
	)
	(if (= TestL Styt)
		(setq TestR T)
		(while (setq TestL (cdr (assoc 2 (tblnext "STYLE"))))
			(if (wcmatch (strcase TestL) Styt)
				(setq TestR T)
			)
		)
	)
	TestR
)

(defun ViewChk ( ViewT / TestR TestL )			; Tests for valid view
	(setq ViewT  (strcase ViewT)
		 TestR nil
		 TestL (strcase (cdr (assoc 2 (tblnext "VIEW" T))))
	)
	(if (= TestL ViewT)
		(setq TestR T)
		(while (setq TestL (cdr (assoc 2 (tblnext "VIEW"))))
			(if (wcmatch (strcase TestL) ViewT)
				(setq TestR T)
			)
		)
	)
	TestR
)

(defun BlkDefExt ( BlkNam /	bData IPnt ObjN	; Determines extents of a block definition
						ObjX e2 IsX IsY MaxX MaxY MinX MinY IsV IsB IsW Pt1 Pt2 IsAng0
						IsAng1 IsAng2 ObjI ObjM ObjT ObjOne )
	(setq	bData	(tblsearch "BLOCK" BlkNam)
			Cnt		0
			AMaxX	0.0
			AMaxY	0.0
			AMinX	0.0
			AMinY	0.0
			AttCnt	0
			IPnt		nil
			ObjOne	T
	)
	(if bData
		(setq	ObjM		(cdr (assoc -2 bData))
				ObjI		(cdr (assoc 10 bData))
		)
		(setq	ObjM		nil)
	)
	(if ObjM
		(setq	ObjN		ObjM
				ObjLst	(list ObjN)
		)
	)
	(while ObjN
		(if ObjN
			(setq	ObjD		(entget ObjN))
			(setq	ObjD		nil)
		)
		(if ObjD
			(setq	ObjN		(entnext (cdr (assoc -1 ObjD))))
			(setq	ObjN		nil)
		)
		(if (and ObjN ObjLst)
			(setq	ObjLst	(append ObjLst	(list ObjN)))
		)
	)
	(if (and Bug ObjLst) (princ (strcat "\nFound " (itoa (length ObjLst)) " entities in " BlkNam)))
	(if ObjLst
		(foreach	ObjX
				ObjLst
				(setq	e2	(entget ObjX (list "*"))
						ObjT	(cdr (assoc 0 e2))
				)
				(cond
					((= ObjT "ATTDEF")
						(setq	AttCnt	(1+ AttCnt))
						(if Bug (princ "\nFound a AttDef!"))
					)
					((= ObjT "TEXT")
						(if Bug (princ "\nFound some Text!"))
					)
					((= ObjT "LWPOLYLINE")
						(setq	IsX	(car (cdr (assoc 10 e2)))
								IsY	(cadr (cdr (assoc 10 e2)))
								MinX	IsX
								MinY	IsY
								MaxX	IsX
								MaxY	IsY
								Icnt	0
								Vcnt	0
						)
						(if (assoc 43 e2)
							(setq	IsW	(/ (cdr (assoc 43 e2)) 2.0))
							(setq	IsW	nil)
						)
						(repeat (length e2)
							(if (= (car (nth Icnt e2)) 10)
								(if IsW
									(setq	IsX	(- (car (cdr (nth Icnt e2))) IsW)
											IsY	(- (cadr (cdr (nth Icnt e2))) IsW)
											IsV	T
									)
									(setq	IsX	(car (cdr (nth Icnt e2)))
											IsY	(cadr (cdr (nth Icnt e2)))
											IsV	T
									)
								)
								(setq	IsV	nil)
							)
							(if IsV	(if (> IsX MaxX) (setq MaxX IsX)))
							(if IsV	(if (> IsY MaxY) (setq MaxY IsY)))
							(if IsV	(if (< IsX MinX) (setq MinX IsX)))
							(if IsV	(if (< IsY MinY) (setq MinY IsY)))
							(if (and IsV IsW)
								(setq	IsX	(+ (car (cdr (nth Icnt e2))) IsW)
										IsY	(+ (cadr (cdr (nth Icnt e2))) IsW)
								)
							)
							(if IsV	(if (> IsX MaxX) (setq MaxX IsX)))
							(if IsV	(if (> IsY MaxY) (setq MaxY IsY)))
							(if IsV	(if (< IsX MinX) (setq MinX IsX)))
							(if IsV	(if (< IsY MinY) (setq MinY IsY)))
							(if IsV	(setq Vcnt (1+ Vcnt)))
							(setq	Icnt	(1+ Icnt))
						)
						(if Bug (princ (strcat "\nFound a LWPoly with " (itoa Vcnt) " vertices!")))
					)
					((= ObjT "POLYLINE")
						(setq	IsW		(cdr (assoc 40 e2))
								IsV		T
						)
						(if Bug (princ "\nFound a Poly!"))
					)
					((= ObjT "VERTEX")
						(setq	IsX	(car (cdr (assoc 10 e2)))
								IsY	(cadr (cdr (assoc 10 e2)))
						)
						(if (assoc 42 e2)
							(setq	IsB	(cdr (assoc 42 e2)))
							(setq	IsB	nil)
						)
						(if (and (> IsW 0.001) IsB)
							(progn
								(setq	IsAng0	(* 4.0 (atan IsB))
										IsAng1	(+ IsAng0 (/ pi 2.0))
										IsAng2	(- IsAng0 (/ pi 2.0))
										Pt1		(polar (list IsX IsY) IsAng1 IsW)
										Pt2		(polar (list IsX IsY) IsAng2 IsW)
										IsX		(car Pt1)
										IsY		(cadr Pt1)
								)
								(if IsV
									(setq	MinX	IsX
											MinY	IsY
											MaxX	IsX
											MaxY	IsY
											IsV	nil
									)
									(progn
										(if (> IsX MaxX) (setq MaxX IsX))
										(if (> IsY MaxY) (setq MaxY IsY))
										(if (< IsX MinX) (setq MinX IsX))
										(if (< IsY MinY) (setq MinY IsY))
									)
								)
								(setq	IsX		(car Pt2)
										IsY		(cadr Pt2)
								)
								(if (> IsX MaxX) (setq MaxX IsX))
								(if (> IsY MaxY) (setq MaxY IsY))
								(if (< IsX MinX) (setq MinX IsX))
								(if (< IsY MinY) (setq MinY IsY))
							)
							(progn
								(if IsV
									(setq	MinX	IsX
											MinY	IsY
											MaxX	IsX
											MaxY	IsY
											IsV	nil
									)
									(progn
										(if (> IsX MaxX) (setq MaxX IsX))
										(if (> IsY MaxY) (setq MaxY IsY))
										(if (< IsX MinX) (setq MinX IsX))
										(if (< IsY MinY) (setq MinY IsY))
									)
								)
							)
						)
						(if Bug (princ "\nFound a Vertex!"))
					)
					((= ObjT "SEQEND")
						(if Bug (princ "\nFound a SeqEnd!"))
					)
					((= ObjT "LINE")
						(setq	IsX	(car (cdr (assoc 10 e2)))
								IsY	(cadr (cdr (assoc 10 e2)))
								MinX	IsX
								MinY	IsY
								MaxX	IsX
								MaxY	IsY
								IsX	(car (cdr (assoc 11 e2)))
								IsY	(cadr (cdr (assoc 11 e2)))
						)
						(if (> IsX MaxX) (setq MaxX IsX))
						(if (> IsY MaxY) (setq MaxY IsY))
						(if (< IsX MinX) (setq MinX IsX))
						(if (< IsY MinY) (setq MinY IsY))
						(if Bug (princ "\nFound a Line!"))
					)
					((= ObjT "ARC")
						(setq	Pt1	(polar (cdr (assoc 10 e2)) (cdr (assoc 50 e2)) (cdr (assoc 40 e2)))
								Pt2	(polar (cdr (assoc 10 e2)) (cdr (assoc 51 e2)) (cdr (assoc 40 e2)))
								IsX	(car Pt1)
								IsY	(cadr Pt1)
								MinX	IsX
								MinY	IsY
								MaxX	IsX
								MaxY	IsY
								IsX	(car Pt2)
								IsY	(cadr Pt2)
						)
						(if (> IsX MaxX) (setq MaxX IsX))
						(if (> IsY MaxY) (setq MaxY IsY))
						(if (< IsX MinX) (setq MinX IsX))
						(if (< IsY MinY) (setq MinY IsY))
						(if Bug (princ "\nFound a Arc!"))
					)
					((= ObjT "SOLID")
						(setq	IsX	(car (cdr (assoc 10 e2)))
								IsY	(cadr (cdr (assoc 10 e2)))
								MinX	IsX
								MinY	IsY
								MaxX	IsX
								MaxY	IsY
								IsX	(car (cdr (assoc 11 e2)))
								IsY	(cadr (cdr (assoc 11 e2)))
						)
						(if (> IsX MaxX) (setq MaxX IsX))
						(if (> IsY MaxY) (setq MaxY IsY))
						(if (< IsX MinX) (setq MinX IsX))
						(if (< IsY MinY) (setq MinY IsY))
						(setq	IsX	(car (cdr (assoc 12 e2)))
								IsY	(cadr (cdr (assoc 12 e2)))
						)
						(if (> IsX MaxX) (setq MaxX IsX))
						(if (> IsY MaxY) (setq MaxY IsY))
						(if (< IsX MinX) (setq MinX IsX))
						(if (< IsY MinY) (setq MinY IsY))
						(setq	IsX	(car (cdr (assoc 13 e2)))
								IsY	(cadr (cdr (assoc 13 e2)))
						)
						(if (> IsX MaxX) (setq MaxX IsX))
						(if (> IsY MaxY) (setq MaxY IsY))
						(if (< IsX MinX) (setq MinX IsX))
						(if (< IsY MinY) (setq MinY IsY))
						(if Bug (princ "\nFound a Solid!"))
					)
					((= ObjT "HATCH")
						(setq	IsX	(car (cdr (assoc 10 e2)))
								IsY	(cadr (cdr (assoc 10 e2)))
								MinX	IsX
								MinY	IsY
								MaxX	IsX
								MaxY	IsY
								Icnt	0
						)
						(repeat (1- (length e2))
							(if (= (car (nth Icnt e2)) 10)
								(setq	IsX	(car (cdr (nth Icnt e2)))
										IsY	(cadr (cdr (nth Icnt e2)))
										IsV	T
								)
								(setq	IsV	nil)
							)
							(if IsV	(if (> IsX MaxX) (setq MaxX IsX)))
							(if IsV	(if (> IsY MaxY) (setq MaxY IsY)))
							(if IsV	(if (< IsX MinX) (setq MinX IsX)))
							(if IsV	(if (< IsY MinY) (setq MinY IsY)))
							(setq	Icnt	(1+ Icnt))
						)
						(if Bug (princ "\nFound a Hatch!"))
					)
					((= ObjT "CIRCLE")
						(setq	IsX	(car (cdr (assoc 10 e2)))
								IsY	(cadr (cdr (assoc 10 e2)))
								IsR	(cdr (assoc 40 e2))
								MinX	(- IsX IsR)
								MinY	(- IsY IsR)
								MaxX	(+ IsX IsR)
								MaxY	(+ IsY IsR)
						)
						(if Bug (princ "\nFound a Circle!"))
					)
					(T
					)
				)
				(if MaxX
					(if ObjOne
						(setq	AMaxX	MaxX)
						(if (> MaxX AMaxX)
							(setq AMaxX MaxX)
						)
					)
				)
				(if MaxY
					(if ObjOne
						(setq	AMaxY	MaxY)
						(if (> MaxY AMaxY)
							(setq AMaxY MaxY)
						)
					)
				)
				(if MinX
					(if ObjOne
						(setq	AMinX	MinX)
						(if (< MinX AMinX)
							(setq AMinX MinX)
						)
					)
				)
				(if MinY
					(if ObjOne
						(setq	AMinY	MinY)
						(if (< MinY AMinY)
							(setq AMinY MinY)
						)
					)
				)
				(if (and ObjOne AMaxX AMaxY AMinX AMinY)
					(setq	ObjOne	nil)
				)
				(if (and Bug MinX MinY MaxX MaxY)
					(princ (strcat "\nMinX:\t" (rtos MinX 2 2) " MinY:\t" (rtos MinY 2 2) " MaxX:\t" (rtos MaxX 2 2) " MaxY:\t" (rtos MaxY 2 2)))
				)
				(if (and Bug AMinX AMinY AMaxX AMaxY)
					(princ (strcat "\nAMinX:\t" (rtos AMinX 2 2) " AMinY:\t" (rtos AMinY 2 2) " AMaxX:\t" (rtos AMaxX 2 2) " AMaxY:\t" (rtos AMaxY 2 2)))
				)
		)
		(princ (strcat "\nBlock: " BlkNam " not defined!"))
	)
	(list AMinX AMinY AMaxX AMaxY ObjI AttCnt)
)

(defun Disp_Data ( SVals /	Blnk PosOut 		; Loads DispToggle Data in dialog box
						fd ph )
	(setq	Blnk		(chr 32)
			MFD_Lst	nil
	)
	(if (not Lst_Wr_S)
		(if (not Bld_Lst_Wire)
			(progn
				(load (strcat _Path-LISP "TABLES"))
				(Bld_Lst_Wire)
			)
			(Bld_Lst_Wire)
		)
	)
	(if Bug
		(princ "\nChecking OorU")
	)
	(if (member "O" (nth 2 SVals))
		(progn
			(mode_tile "oh_toggle" 0)
			(if Bug (princ "\nOverhead enabled"))
		)
		(progn
			(mode_tile "oh_toggle" 1)
			(if Bug (princ "\nOverhead disabled"))
		)
	)
	(if (member "U" (nth 2 SVals))
		(progn
			(mode_tile "ug_toggle" 0)
			(if Bug (princ "\nUnderground enabled"))
			(mode_tile "Neu_S_popup" 0)
			(mode_tile "Neu_S_popup" 0)
		)
		(progn
			(mode_tile "ug_toggle" 1)
			(if Bug (princ "\nUnderground disabled"))
			(mode_tile "Neu_S_popup" 1)
			(mode_tile "Neu_S_popup" 1)
		)
	)
	(if Bug
		(princ "\nChecking Fdr")
	)
	(if (nth 1 SVals)
		(foreach	fd
				(nth 1 SVals)
				(setq	PosOut	(- (length Lst_Fd_V) (length (member fd Lst_Fd_V))))
				(if PosOut
					(if (< PosOut (length Lst_Fd_V))
						(if MFD_Lst
							(setq	MFD_Lst	(cons (nth PosOut Lst_Fd_S) MFD_Lst))
							(setq	MFD_Lst	(list (nth PosOut Lst_Fd_S)))
						)
					)
				)
		)
	)
	(if MFD_Lst
		(progn
			(start_list "fd_vlist" 3)
			(add_list Blnk)
			(mapcar (quote add_list) (reverse MFD_Lst))
			(end_list)
			(if Bug (princ (strcat "\nMegaFeederList enabled - " (itoa (length MFD_Lst)) " items")))
		)
	)
	(if Bug
		(princ "\nChecking Kv")
	)
	(if (nth 4 SVals)
		(progn
			(start_list "vt_vlist" 3)
			(add_list Blnk)
			(mapcar (quote add_list) (nth 4 SVals))
			(end_list)
			(if Bug (princ (strcat "\nVoltageList enabled - " (itoa (length (nth 4 SVals))) " items")))
		)
	)
	(if Bug
		(princ "\nChecking Ph")
	)
	(if (nth 3 SVals)
		(progn
			(start_list "ph_vlist" 3)
			(add_list Blnk)
			(foreach	ph
					(nth 3 SVals)
					(add_list (nth (atoi ph) Lst_Ph_S))
			)
			(end_list)
			(if Bug (princ (strcat "\nPhaseList enabled - " (itoa (length (nth 3 SVals))) " items")))
		)
	)
	(if Lst_Wr_S
		(progn
			(start_list "Pri_S_vlist" 3)
			(add_list Blnk)
			(mapcar (quote add_list) (reverse Lst_Wr_S))
			(end_list)
		)
	)
	(if Lst_Wr_S
		(progn
			(start_list "Neu_S_vlist" 3)
			(add_list Blnk)
			(mapcar (quote add_list) (reverse Lst_Wr_S))
			(end_list)
		)
	)
	(if Lst_Wr_T
		(progn
			(start_list "Pri_T_vlist" 3)
			(add_list Blnk)
			(mapcar (quote add_list) (reverse Lst_Wr_T))
			(end_list)
		)
	)
	(if Lst_Wr_T
		(progn
			(start_list "Neu_T_vlist" 3)
			(add_list Blnk)
			(mapcar (quote add_list) (reverse Lst_Wr_T))
			(end_list)
		)
	)
	(list	(get_tile "fd_vlist")
			(get_tile "oh_toggle")
			(get_tile "ug_toggle")
			(get_tile "vt_vlist")
			(get_tile "ph_vlist")
			(get_tile "Pri_S_vlist")
			(get_tile "Pri_T_vlist")
			(get_tile "Neu_S_vlist")
			(get_tile "Neu_T_vlist")
	)
)

(defun GetSelVals ( /	OorULst KVLst FdLst		; Screens existing layers for dialog display
					PhLst LayDat LayNam Sub Fdr OorU Ph Kv )
	(if Bug (princ "\nUtils.Lsp!GetSelVals - Started"))
	(setq	SubLst	nil
			FdrLst	nil
			OorULst	nil
			PhLst	nil
			KVLst	nil
			LayDat	(tblnext "LAYER" T)
	)
	(while (setq LayDat (tblnext "LAYER"))
		(if LayDat
			(if (> (strlen (setq LayNam (cdr (assoc 2 LayDat)))) 9)
				(if	(or	(= (substr LayNam 5 2) "CK")
						(= (substr LayNam 5 2) "FL")
					)
					(setq	Sub		(substr LayNam 1 2)
							Fdr		(substr LayNam 1 3)
							OorU		(substr LayNam 4 1)
							Ph		(substr LayNam 8 1)
							Kv		(substr LayNam 9 2)
					)
					(setq	Sub		nil
							Fdr		nil
							OorU		nil
							Ph		nil
							Kv		nil
					)
				)
				(setq	Sub		nil
						Fdr		nil
						OorU		nil
						Ph		nil
						Kv		nil
				)
			)
			(setq	Sub		nil
					Fdr		nil
					OorU		nil
					Ph		nil
					Kv		nil
			)
		)
		(if Sub
			(if SubLst
				(if (not (member Sub SubLst))
					(setq	SubLst	(cons Sub SubLst))
				)
				(setq	SubLst	(list Sub))
			)
		)
		(if Fdr
			(if FdrLst
				(if (not (member Fdr FdrLst))
					(setq	FdrLst	(cons Fdr FdrLst))
				)
				(setq	FdrLst	(list Fdr))
			)
		)
		(if OorU
			(if OorULst
				(if (not (member OorU OorULst))
					(setq	OorULst	(cons OorU OorULst))
				)
				(setq	OorULst	(list OorU))
			)
		)
		(if Ph
			(if PhLst
				(if (not (member Ph PhLst))
					(setq	PhLst	(cons Ph PhLst))
				)
				(setq	PhLst	(list Ph))
			)
		)
		(if Kv
			(if KvLst
				(if (not (member Kv KvLst))
					(setq	KvLst	(cons Kv KvLst))
				)
				(setq	KvLst	(list Kv))
			)
		)
	)
	(if SubLst
		(acad_strlsort SubLst)
	)
	(if FdrLst
		(progn
			(setq	SubNamLst	nil)
			(foreach	fdr
					FdrLst
					(setq	PosOut	(- (length Lst_Fd_V) (length (member fdr Lst_Fd_V))))
					(if (/= PosOut (length Lst_Fd_V))
						(if SubNamLst
							(setq	SubNamLst	(cons (nth PosOut Lst_Fd_S) SubNamLst))
							(setq	SubNamLst	(list (nth PosOut Lst_Fd_S)))
						)
						(if Bug (princ (strcat "\nSubNam not found for >" fdr "<")))
					)
			)
			(if SubNamLst
				(setq	SubNamLst	(acad_strlsort SubNamLst))
			)
			(setq	EdsFLst	FdrLst
					EdsSLst	SubNamLst
					FdrLst	nil
			)
			(if SubNamLst
				(foreach	SubNam
						SubNamLst
						(setq	PosOut	(- (length Lst_Fd_S) (length (member SubNam Lst_Fd_S))))
						(if FdrLst
							(setq	FdrLst	(cons (nth PosOut Lst_Fd_V) FdrLst))
							(setq	FdrLst	(list (nth PosOut Lst_Fd_V)))
						)
				)
			)
		)
	)
	(if PhLst
		(acad_strlsort PhLst)
	)
	(if KVLst
		(acad_strlsort KVLst)
	)
	(if Bug (princ "\nUtils.Lsp!GetSelVals - Done"))
	(list	SubLst
			FdrLst
			OorULst
			PhLst
			KVLst
	)
)

(defun C:DispToggle ( / dlg dcl_id )			; Dialog Toggle Display function
	(setq	SVals	(GetSelVals)
			TVals	(list "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0")
			dlg		4
			DVals	nil
	)
	(if (> (setq dcl_id	(load_dialog "utils.dcl")) 0)
		(progn
			(while (> dlg 3)
				(new_dialog "DispTog1" dcl_id)
				(setq	GVals	(Disp_Data SVals)
						DoOU		(get_tile "aou_tog")
				)
				(action_tile "fd_vlist" "(setq GVals (RepLst GVals $value 0))")
				(action_tile "oh_toggle" "(setq GVals (RepLst GVals $value 1))")
				(action_tile "ug_toggle" "(setq GVals (RepLst GVals $value 2))")
				(action_tile "aou_tog" "(setq DoOU $value)")
				(action_tile "vt_vlist" "(setq GVals (RepLst GVals $value 3))")
				(action_tile "ph_vlist" "(setq GVals (RepLst GVals $value 4))")
				(action_tile "Pri_S_vlist" "(setq GVals (RepLst GVals $value 5))")
				(action_tile "Pri_T_vlist" "(setq GVals (RepLst GVals $value 6))")
				(action_tile "Neu_S_vlist" "(setq GVals (RepLst GVals $value 7))")
				(action_tile "Neu_T_vlist" "(setq GVals (RepLst GVals $value 8))")
				(action_tile "grd_tog" "(setq TVals (RepLst TVals $value 0))")
				(action_tile "agrd_tog" "(setq TVals (RepLst TVals $value 1))")
				(action_tile "fil_tog" "(setq TVals (RepLst TVals $value 2))")
				(action_tile "afil_tog" "(setq TVals (RepLst TVals $value 3))")
				(action_tile "sel_tog" "(setq TVals (RepLst TVals $value 4))")
				(action_tile "asel_tog" "(setq TVals (RepLst TVals $value 5))")
				(action_tile "sws_tog" "(setq TVals (RepLst TVals $value 6))")
				(action_tile "asws_tog" "(setq TVals (RepLst TVals $value 7))")
				(action_tile "no_tog" "(setq TVals (RepLst TVals $value 8))")
				(action_tile "ano_tog" "(setq TVals (RepLst TVals $value 9))")
				(action_tile "att_tog" "(setq TVals (RepLst TVals $value 10))")
				(action_tile "aatt_tog" "(setq TVals (RepLst TVals $value 11))")
				(action_tile "swa_tog" "(setq TVals (RepLst TVals $value 12))")
				(action_tile "aswa_tog" "(setq TVals (RepLst TVals $value 13))")
				(action_tile "hid_tog" "(setq TVals (RepLst TVals $value 14))")
				(action_tile "ahid_tog" "(setq TVals (RepLst TVals $value 15))")
				(action_tile "act_but" "(setq DVals (DispAct GVals TVals SVals))(done_dialog 3)")
				(action_tile "ok_button" "(done_dialog 1)")
				(action_tile "cancel_button" "(done_dialog 0)")
				(setq dlg (start_dialog))
				(if (= dlg 3)
					(if DVals
						(progn
							(DispView DVals)
							(setq	dlg	4)
						)
					)
					(if (= dlg 1)
						(DispView DVals)
					)
				)
			)
			(unload_dialog dcl_id)
		)
		(alert (strcat	"ERROR: Opening Dialog Box Utils.dcl"))
	)
	(princ)
)

(defun Disp_Data2 ( SVals /	Blnk PosOut 		; Loads DispToggle Data in dialog box
						fd ph )
	(setq	Blnk		(chr 32)
			MFD_Lst	nil
	)
	(if (not Lst_Wr_S)
		(if (not Bld_Lst_Wire)
			(progn
				(load (strcat _Path-LISP "TABLES"))
				(Bld_Lst_Wire)
			)
			(Bld_Lst_Wire)
		)
	)
	(if Bug
		(princ "\nChecking OorU")
	)
	(if (member "O" (nth 2 SVals))
		(progn
			(mode_tile "oh_toggle" 0)
			(if Bug (princ "\nOverhead enabled"))
		)
		(progn
			(mode_tile "oh_toggle" 1)
			(if Bug (princ "\nOverhead disabled"))
		)
	)
	(if (member "U" (nth 2 SVals))
		(progn
			(mode_tile "ug_toggle" 0)
			(if Bug (princ "\nUnderground enabled"))
			(mode_tile "Neu_S_popup" 0)
			(mode_tile "Neu_S_popup" 0)
		)
		(progn
			(mode_tile "ug_toggle" 1)
			(if Bug (princ "\nUnderground disabled"))
			(mode_tile "Neu_S_popup" 1)
			(mode_tile "Neu_S_popup" 1)
		)
	)
	(if Bug
		(princ "\nChecking Fdr")
	)
	(if (nth 1 SVals)
		(foreach	fd
				(nth 1 SVals)
				(setq	PosOut	(- (length Lst_Fd_V) (length (member fd Lst_Fd_V))))
				(if PosOut
					(if (< PosOut (length Lst_Fd_V))
						(if MFD_Lst
							(setq	MFD_Lst	(cons (nth PosOut Lst_Fd_S) MFD_Lst))
							(setq	MFD_Lst	(list (nth PosOut Lst_Fd_S)))
						)
					)
				)
		)
	)
	(if MFD_Lst
		(progn
			(start_list "fd_vlist" 3)
			(add_list Blnk)
			(mapcar (quote add_list) (reverse MFD_Lst))
			(end_list)
			(if Bug (princ (strcat "\nMegaFeederList enabled - " (itoa (length MFD_Lst)) " items")))
		)
	)
	(if Bug
		(princ "\nChecking Kv")
	)
	(if (nth 4 SVals)
		(progn
			(start_list "vt_vlist" 3)
			(add_list Blnk)
			(mapcar (quote add_list) (nth 4 SVals))
			(end_list)
			(if Bug (princ (strcat "\nVoltageList enabled - " (itoa (length (nth 4 SVals))) " items")))
		)
	)
	(if Bug
		(princ "\nChecking Ph")
	)
	(if (nth 3 SVals)
		(progn
			(start_list "ph_vlist" 3)
			(add_list Blnk)
			(foreach	ph
					(nth 3 SVals)
					(add_list (nth (atoi ph) Lst_Ph_S))
			)
			(end_list)
			(if Bug (princ (strcat "\nPhaseList enabled - " (itoa (length (nth 3 SVals))) " items")))
		)
	)
	(list	(get_tile "fd_vlist")
			(get_tile "oh_toggle")
			(get_tile "ug_toggle")
			(get_tile "vt_vlist")
			(get_tile "ph_vlist")
			"0"
			"0"
			"0"
			"0"
	)
)

(defun C:NewDispToggle ( /	dlg dcl_id		; Dialog Toggle Display function
						SVals TVals DVals )
	(setq	SVals	(GetSelVals)
			TVals	(list "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0")
			dlg		18
			DVals	nil
	)
	(if (> (setq dcl_id	(load_dialog "utils.dcl")) 0)
		(progn
			(while (> dlg 16)
				(new_dialog "DispTog2" dcl_id)
				(setq	GVals	(Disp_Data2 SVals)
						DoOU		(get_tile "aou_tog")
				)
				(action_tile "fd_vlist" "(setq GVals (RepLst GVals $value 0))")
				(action_tile "oh_toggle" "(setq GVals (RepLst GVals $value 1))")
				(action_tile "ug_toggle" "(setq GVals (RepLst GVals $value 2))")
				(action_tile "vt_vlist" "(setq GVals (RepLst GVals $value 3))")
				(action_tile "ph_vlist" "(setq GVals (RepLst GVals $value 4))")
				(action_tile "fz_but_prop" "(done_dialog 1)")
				(action_tile "th_but_prop" "(done_dialog 2)")
				(action_tile "fz_but_gd" "(done_dialog 3)")
				(action_tile "th_but_gd" "(done_dialog 4)")
				(action_tile "fz_but_fl" "(done_dialog 5)")
				(action_tile "th_but_fl" "(done_dialog 6)")
				(action_tile "fz_but_cp" "(done_dialog 7)")
				(action_tile "th_but_cp" "(done_dialog 8)")
				(action_tile "fz_but_sw" "(done_dialog 9)")
				(action_tile "th_but_sw" "(done_dialog 10)")
				(action_tile "fz_but_no" "(done_dialog 11)")
				(action_tile "th_but_no" "(done_dialog 12)")
				(action_tile "fz_but_att" "(done_dialog 13)")
				(action_tile "th_but_att" "(done_dialog 14)")
				(action_tile "fz_but_all" "(done_dialog 15)")
				(action_tile "th_but_all" "(done_dialog 16)")
				(action_tile "cancel_button" "(done_dialog 0)")
				(setq dlg (start_dialog))
				(if (> dlg 0)
					(cond	((= dlg 1)
								(setq	DVals	(DetVals2 GVals SVals))
								(DoLay "F" "Prop" DVals)
								(setq	dlg		18)
							)
							((= dlg 2)
								(setq	DVals	(DetVals2 GVals SVals))
								(DoLay "T" "Prop" DVals)
								(setq	dlg		18)
							)
							((= dlg 3)
								(DoLay "F" "Grid" GVals)
								(setq	dlg		18)
							)
							((= dlg 4)
								(DoLay "T" "Grid" GVals)
								(setq	dlg		18)
							)
							((= dlg 5)
								(DoLay "F" "Fill" GVals)
								(setq	dlg		18)
							)
							((= dlg 6)
								(DoLay "T" "Fill" GVals)
								(setq	dlg		18)
							)
							((= dlg 7)
								(DoLay "F" "CPnt" GVals)
								(setq	dlg		18)
							)
							((= dlg 8)
								(DoLay "T" "CPnt" GVals)
								(setq	dlg		18)
							)
							((= dlg 9)
								(DoLay "F" "Sw" GVals)
								(setq	dlg		18)
							)
							((= dlg 10)
								(DoLay "T" "Sw" GVals)
								(setq	dlg		18)
							)
							((= dlg 11)
								(DoLay "F" "Nope" GVals)
								(setq	dlg		18)
							)
							((= dlg 12)
								(DoLay "T" "Nope" GVals)
								(setq	dlg		18)
							)
							((= dlg 13)
								(DoLay "F" "Att" GVals)
								(setq	dlg		18)
							)
							((= dlg 14)
								(DoLay "T" "Att" GVals)
								(setq	dlg		18)
							)
							((= dlg 15)
								(DoLay "F" "All" GVals)
								(setq	dlg		18)
							)
							((= dlg 16)
								(DoLay "T" "All" GVals)
								(setq	dlg		18)
							)
					)
				)
			)
			(unload_dialog dcl_id)
		)
		(alert (strcat	"ERROR: Opening Dialog Box Utils.dcl"))
	)
	(princ)
)

(defun DetVals2 ( GVals SVals /	RetWrk )		; Looks up correct filter values from lists
	(if (/= (nth 0 GVals) "0")				; Sets Feeder Match
		(setq	RetWrk	(nth (1- (atoi (nth 0 gvals))) (nth 1 svals)))
		(setq	RetWrk	"???")
	)
	(if Bug (princ (strcat "\nGVals 0:" (nth 0 GVals))))
	(if Bug (princ (strcat "\nGVals 1:" (nth 1 GVals))))
	(if Bug (princ (strcat "\nGVals 2:" (nth 2 GVals))))
	(if Bug (princ (strcat "\nGVals 3:" (nth 3 GVals))))
	(if Bug (princ (strcat "\nGVals 4:" (nth 4 GVals))))
	(if (/= (nth 1 GVals) "0")
		(if (/= (nth 2 GVals) "0")
			(setq	RetWrk	(strcat RetWrk "[OU]???"))
			(setq	RetWrk	(strcat RetWrk "O???"))
		)
		(if (/= (nth 2 GVals) "0")
			(setq	RetWrk	(strcat RetWrk "U???"))
			(setq	RetWrk	(strcat RetWrk "????"))
		)
	)
	(if (/= (nth 4 GVals) "0")
		(setq	RetWrk	(strcat RetWrk (nth (1- (atoi (nth 4 gvals))) (nth 3 svals))))
		(setq	RetWrk	(strcat RetWrk "?"))
	)
	(if (/= (nth 3 GVals) "0")
		(setq	RetWrk	(strcat RetWrk (nth (1- (atoi (nth 3 gvals))) (nth 4 svals)) "*"))
		(setq	RetWrk	(strcat RetWrk "??" "*"))
	)
	(if (and Bug RetWrk)
		(princ (strcat "\nLayer match string - <" RetWrk ">"))
	)
	RetWrk
)

(defun DoLay ( Act Grp GVals /	WrkLst )		; Freezes/Thaws layers...
	(cond	((= Grp "Prop")
				(setq	WrkLst	GVals)
			)
			((= Grp "Grid")
				(setq	WrkLst	"----GRD---")
			)
			((= Grp "Fill")
				(setq	WrkLst	"????FL*")
			)
			((= Grp "CPnt")
				(setq	WrkLst	"????CP*")
			)
			((= Grp "Sw")
				(setq	WrkLst	"????SW*")
			)
			((= Grp "Nope")
				(setq	WrkLst	"????NO*")
			)
			((= Grp "Att")
				(setq	WrkLst	"????SWD*")
			)
			((= Grp "All")
				(setq	WrkLst	"*")
			)
			((= Grp "Sect")
				(setq	WrkLst	"----GRD---")
			)
			((= Grp "sect")
				(setq	WrkLst	"property,street,serv*,light,location,misc,lot_no")
			)
			((= Grp "lit")
				(setq	WrkLst	"serv*,property,street,trees,center,water,misc")
			)
			((= Grp "pri")
				(setq	WrkLst	"????CK*")
			)
			((= Grp "sec")
				(setq	WrkLst	"????PA*")
			)
			((= Grp "svc")
				(setq	WrkLst	"serv*")
			)
			((= Grp "str")
				(setq	WrkLst	"street")
			)
			((= Grp "prop")
				(setq	WrkLst	"property")
			)
			((= Grp "misc")
				(setq	WrkLst	"misc")
			)
			((= Grp "sw")
				(setq	WrkLst	"????SW*")
			)
			((= Grp "xfr")
				(setq	WrkLst	"????XF*")
			)
			((= Grp "lites")
				(setq	WrkLst	"light")
			)
			((= Grp "const_notes")
				(setq	WrkLst	"const_notes")
			)
	)
	(if WrkLst
		(if (= Act "F")
			(if (not (wcmatch (strcase (getvar "CLAYER")) (strcase WrkLst)))
				(command "-LAYER" "F" WrkLst "")
				(command "-LAYER" "T" "0" "U" "0" "On" "0" "S" "0" "F" WrkLst "")
			)
			(command "-LAYER" "T" WrkLst "")
		)
	)
	(command "regen")
)

(defun DispView ( DVals / )					; Activates layer command string
	(if Bug
		(setvar "CMDECHO" 1)
	)
	(if DVals
		(progn
			(setq	DVals	(cons "LAYER" DVals)
					DVals	(append DVals (list ""))
			)
			(mapcar (quote command) DVals)
		)
	)
	(if Bug
		(setvar "CMDECHO" 0)
	)
)

(defun DispAct ( GVals TVals SVals / )			; Builds layer command per dialog toggles
	(if (/= (getvar "CLAYER") "0")
		(setq	DVals	(list "T" "0" "ON" "0" "U" "0" "S" "0"))
		(setq	DVals	(list "S" "0"))
	)
	(if (and Bug TVals)
		(princ	(strcat	"\nToggles Say:"
						"\nGrid:\t\t\t"
						(if (= (nth 0 TVals) "1") "Show\t" "Hide\t")
						(if (= (nth 1 TVals) "1") "Do It" "Dont Do It")
						"\nFill Lines:\t\t"
						(if (= (nth 2 TVals) "1") "Show\t" "Hide\t")
						(if (= (nth 3 TVals) "1") "Do It" "Dont Do It")
						"\nCircuit:\t\t"
						(if (= (nth 4 TVals) "1") "Show\t" "Hide\t")
						(if (= (nth 5 TVals) "1") "Do It" "Dont Do It")
						"\nSwitch:\t\t"
						(if (= (nth 6 TVals) "1") "Show\t" "Hide\t")
						(if (= (nth 7 TVals) "1") "Do It" "Dont Do It")
						"\nNOpen:\t\t\t"
						(if (= (nth 8 TVals) "1") "Show\t" "Hide\t")
						(if (= (nth 9 TVals) "1") "Do It" "Dont Do It")
						"\nSwitch Attributes:\t"
						(if (= (nth 10 TVals) "1") "Show\t" "Hide\t")
						(if (= (nth 11 TVals) "1") "Do It" "Dont Do It")
						"\nShowAll:\t\t"
						(if (= (nth 12 TVals) "1") "Show\t" "Hide\t")
						(if (= (nth 13 TVals) "1") "Do It" "Dont Do It")
						"\nHideAll:\t\t"
						(if (= (nth 14 TVals) "1") "Show\t" "Hide\t")
						(if (= (nth 15 TVals) "1") "Do It\n" "Dont Do It\n")
				)
		)
	)
	(if (= (nth 15 TVals) "1")
		(if (= (nth 14 TVals) "1")
			(setq	DVals	(append DVals (list "F" "*")))
		)
	)
	(if (= (nth 13 TVals) "1")
		(if (= (nth 12 TVals) "1")
			(setq	DVals	(append DVals (list "T" "*")))
		)
	)
	(if (= (nth 11 TVals) "1")
		(if (= (nth 10 TVals) "0")
			(setq	DVals	(append DVals (DetVals "F" "SWD" SVals GVals)))
			(setq	DVals	(append DVals (DetVals "T" "SWD" SVals GVals)))
		)
	)
	(if (= (nth 9 TVals) "1")
		(if (= (nth 8 TVals) "0")
			(setq	DVals	(append DVals (DetVals "F" "NO" SVals GVals)))
			(setq	DVals	(append DVals (DetVals "T" "NO" SVals GVals)))
		)
	)
	(if (= (nth 7 TVals) "1")
		(if (= (nth 6 TVals) "0")
			(setq	DVals	(append DVals (DetVals "F" "SW" SVals GVals)))
			(setq	DVals	(append DVals (DetVals "T" "SW" SVals GVals)))
		)
	)
	(if (= (nth 5 TVals) "1")
		(if (= (nth 4 TVals) "0")
			(setq	DVals	(append DVals (DetVals "F" "CK" SVals GVals)))
			(setq	DVals	(append DVals (DetVals "T" "CK" SVals GVals)))
		)
	)
	(if (= (nth 3 TVals) "1")
		(if (= (nth 2 TVals) "0")
			(setq	DVals	(append DVals (DetVals "F" "FL" SVals GVals)))
			(setq	DVals	(append DVals (DetVals "T" "FL" SVals GVals)))
		)
	)
	(if (= (nth 1 TVals) "1")
		(if (= (nth 0 TVals) "0")
			(setq	DVals	(append DVals (list "F" "----GRD---")))
			(setq	DVals	(append DVals (list "T" "----GRD---")))
		)
	)
	(list "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0")
)

(defun DetVals ( Act Wrk SVals GVals /	OutLst	; Determines correct layer values from conditions
								Fdr OorU Vt Ph )
	(setq	OutLst	(list Act))
	(if (/= (nth 0 GVals) "0")
		(setq	Fdr	(nth (1- (atoi (nth 0 GVals))) (nth 1 SVals)))
		(setq	Fdr	"???")
	)
	(cond	((= DoOU "0")
				(setq	OorU		"[-OU]")
			)
			((and (/= (nth 1 GVals) "0") (/= (nth 2 GVals) "0"))
				(setq	OorU		"[-OU]")
			)
			((/= (nth 1 GVals) "0")
				(setq	OorU		"[-O]")
			)
			((/= (nth 2 GVals) "0")
				(setq	OorU		"[-U]")
			)
			((and (= (nth 1 GVals) "0") (= (nth 2 GVals) "0"))
				(setq	OorU		"-")
			)
			(T
				(setq	OorU		"-")
			)
	)
	(if (/= (nth 3 GVals) "0")
		(setq	Vt	(nth (1- (atoi (nth 3 GVals))) (nth 4 SVals)))
		(setq	Vt	"??")
	)
	(if (/= (nth 4 GVals) "0")
		(setq	Ph	(nth (1- (atoi (nth 4 GVals))) (nth 3 SVals)))
		(setq	Ph	"?")
	)
	(if Bug (princ (strcat "\nTest:" Fdr OorU "XXX" Ph Vt)))
	(cond	((= Wrk "SWD")
				(setq	OutLst	(append OutLst (list (strcat Fdr OorU "SWD" Ph Vt "*"))))
			)
			((= Wrk "NO")
				(setq	OutLst	(append OutLst (list (strcat Fdr OorU "NO?" Ph Vt "*"))))
			)
			((= Wrk "SW")
				(setq	OutLst	(append OutLst (list (strcat Fdr OorU "SW?" Ph Vt "*"))))
			)
			((= Wrk "CK")
				(setq	OutLst	(append OutLst (list (strcat Fdr OorU "CK?" Ph Vt "*"))))
			)
			((= Wrk "FL")
				(setq	OutLst	(append OutLst (list (strcat Fdr OorU "FL?" Ph Vt "*"))))
			)
			(T
				(setq	OutLst	(append OutLst (list (strcat Fdr OorU "???" Ph Vt "*"))))
			)
	)
	OutLst
)

(defun MakLstTxt ( Witch /					; Passes List Text to WiroSizer <g>
						 ) ; DstDivLst WirSizLst
	(setq	DstDivLst		(list	""
								"BIRMINGHAM"
								"EAST JEFFERSON"
								"GARDENDALE"
								"SHELBY"
								"SHADES CAHABA"
								"WEST JEFFERSON"
								"EASTERN"
								"SOUTHERN"
								"WESTERN"
								"DISTRICT"
								"DIVISION"
						)
			WirSizLst		(list	"795  AAC"
								"397  ACSR"
								"4/0  ACSR"
								"2/0  ACSR"
								"1/0  ACSR"
								"2  ACSR"
								"4  ACSR"
								"795  AL"
								"397  AL"
								"4/0  AL"
								"2/0  AL"
								"1/0  AL"
								"2  AL"
								"4  AL"
								"4/0  CU"
								"2/0  CU"
								"1/0  CU"
								"2  CU"
								"4  CU"
								"6  CU"
						)
	)
	(cond	((= Witch 1)
				(WireSize DstDivLst)
			)
			((= Witch 2)
				(WireSize WirSizLst)
			)
	)
	(princ)
)

(defun LayPhFilt ( / LayN LayTmp LayLst )		; Layer Phase Filter
	(setq	LayN		(tblnext "LAYER" T)
			LayTmp	(list (cdr (assoc 2 LayN)))
	)
	(while (setq LayN (tblnext "LAYER"))
		(if LayN
			(setq	LayTmp	(cons (cdr (assoc 2 LayN)) LayTmp))
		)
	)
	(foreach		x
				LayTmp
				(if (= (strlen x) 10)
					(if (member (substr x 8 1) (list "0" "1" "2" "3" "4" "5" "6"))
						(if LayLst
							(setq	LayLst	(append LayLst (list x)))
							(setq	LayLst	(list x))
						)
					)
				)
	)
	LayLst
)

(defun ErrUp ( Dnam StrOut / Enam FilOut )		; Error Update
	(setq	Enam		(strcat Dnam ".ERR"))
	(if (findfile Enam)
		(setq	FilOut	(open (findfile Enam) "a"))
		(setq	FilOut	(open Enam "w"))
	)
	(if FilOut
		(write-line StrOut FilOut)
	)
	(if FilOut
		(close FilOut)
	)
	(princ)
)

(defun RenLayers ( LayLstOld LayLstNew / )		; Renames Layers
	(setq	LayPair	(mapcar (quote cons) LayLstOld LayLstNew))
	(foreach	NamePair
			layPair
			(if	(and	(tblsearch "LAYER" (car NamePair))
					(not (tblsearch "LAYER" (cdr NamePair)))
				)
				(command "_.RENAME" "_LA" (car NamePair) (cdr NamePair))
			)
	)
	(princ)
)

(defun LayUpdObj ( Enam LayT / LayD Edat T1 e2 )	; Layer Update Object
	(if Bug 
		(progn
			(princ "\nUtils.Lsp!LayUpdObj - Entered")
			(princ "\n   parameter Enam: ") (prin1 Enam)
			(princ "\n   parameter LayT: ") (prin1 LayT) 
		)
	)
	(setq	Edat		(entget Enam (quote ("*"))))
	(if (not MkLay)
		(LodStage "Symbols")
	)
	(if (not LayT)
		(setq	LayT		(cdr (assoc 8 Edat)))
	)
	(if (null (tblsearch "LAYER" LayT))
		(MkLay LayT)
	)
	(if Edat
		(cond
			((and (= (cdr (assoc 0 Edat)) "INSERT") (> (cdr (assoc 66 Edat)) 0))	; Checks to see if attributes follows
				(setq	T1		(cdr (assoc -1 Edat))
						Edat		(subst	(cons 8 LayT)
										(assoc 8 Edat)
										Edat
								)
						LayD		(if (> (strlen (cdr (assoc 8 Edat))) 9)
									(strcat (substr (cdr (assoc 8 Edat)) 1 6) "D" (substr (cdr (assoc 8 Edat)) 8 3))
									(strcat (cdr (assoc 8 Edat)) "D")
								)
						e2		(entnext (cdr (assoc -1 Edat)))
				)
				(if (null (tblsearch "LAYER" LayD))
					(MkLay LayD)
				)
				(entmod Edat)
				(while (/= (cdr (assoc 0 (entget e2))) "SEQEND")
					(setq	Edat		(entget e2)
							Edat		(subst	(cons 8 LayD)
											(assoc 8 Edat)
											Edat
									)
							e2		(entnext (cdr (assoc -1 Edat)))
					)
					(if (assoc 62 Edat)
						(setq	Edat		(subst	(cons 62 256)
												(assoc 62 Edat)
												Edat
										)
						)
					)
					(entmod Edat)
				)
				(if (= (cdr (assoc 0 (entget e2))) "SEQEND")
					(progn
						(setq	Edat		(entget e2)
								Edat		(subst	(cons 8 LayT)
												(assoc 8 Edat)
												Edat
										)
						)
						(if (assoc 62 Edat)
							(setq	Edat		(subst	(cons 62 256)
													(assoc 62 Edat)
													Edat
											)
							)
						)
						(entmod Edat)
					)
				)
				(entupd T1)
			)
			((= (cdr (assoc 0 Edat)) "INSERT")
				(setq	Edat	(subst	(cons 8 LayT)
									(assoc 8 Edat)
									Edat
							)
				)
				(entmod Edat)
				(setq	T1	(cdr (assoc -1 Edat))
						e2	(entnext (cdr (assoc -1 Edat)))
				)
				(if e2												;	[Added Due to Mobile Error]
					(if (= (cdr (assoc 0 (entget e2))) "SEQEND")
						(progn
							(setq	Edat		(entget e2)
									Edat		(subst	(cons 8 LayD)
													(assoc 8 Edat)
													Edat
											)
									e2		(entnext (cdr (assoc -1 Edat)))
							)
							(if (assoc 62 Edat)
								(setq	Edat		(subst	(cons 62 256)
														(assoc 62 Edat)
														Edat
												)
								)
							)
							(entmod Edat)
						)
					)
				)
				(entupd T1)
			)
			((= (cdr (assoc 0 Edat)) "TEXT")
				(setq	Edat	(subst	(cons 8 LayT)
									(assoc 8 Edat)
									Edat
							)
				)
				(entmod Edat)
			)
			((= (cdr (assoc 0 Edat)) "CIRCLE")
				(setq	Edat	(subst	(cons 8 LayT)
									(assoc 8 Edat)
									Edat
							)
				)
				(entmod Edat)
			)
			((= (cdr (assoc 0 Edat)) "POLYLINE")
				(setq	Edat	(subst	(cons 8 LayT)
									(assoc 8 Edat)
									Edat
							)
				)
				(if TstRpt
					(if (= (strlen LayT) 10)
						(if	(or	(= (substr LayT 5 2) "CK")
								(= (substr LayT 5 2) "FL")
							)
							(FdrLenTst Edat)
						)
					)
				)
				(entmod Edat)
			)
			((= (cdr (assoc 0 Edat)) "LWPOLYLINE")
				(setq	Edat	(subst	(cons 8 LayT)
									(assoc 8 Edat)
									Edat
							)
				)
				(if TstRpt
					(if (= (strlen LayT) 10)
						(if	(or	(= (substr LayT 5 2) "CK")
								(= (substr LayT 5 2) "FL")
							)
							(FdrLenTst Edat)
						)
					)
				)
				(entmod Edat)
			)
			(T
				(princ (strcat "\nFound Object: " (cdr (assoc 0 Edat))))
				(setq	Edat	(subst	(cons 8 LayT)
									(assoc 8 Edat)
									Edat
							)
				)
				(entmod Edat)
			)
		)
	)
	(if Bug (princ "\nUtils.Lsp!LayUpdObj - Done \n"))
	(princ)
)

(defun FdrLenTst ( Edat /	PLnLen Fnam 		; Feeder Length Test
						Dnam LayT )
	(setq	PLnLen	(GetPLen Edat))
	(if PLnLen
		(progn
			(setq	Fnam		(open "FdrLenPh.TXT" "a")
					Dnam		(strcase (getvar "DWGNAME"))
					LayT		(cdr (assoc 8 Edat))
			)
			(if Dnam
				(if (> (strlen Dnam) 4)
					(if (= ".DWG" (substr Dnam (- (strlen Dnam) 3) 4))
						(setq	Dnam	(substr Dnam 1 (- (strlen Dnam) 4)))
					)
				)
				(setq	Dnam		(car PanLst))
			)
			(write-line (strcat Div Dnam "=>" LayT "=>" (rtos PLnLen 2 4)) Fnam)
			(if Fnam
				(close Fnam)
			)
		)
	)
)

(defun UpdSym ( ssG /	set2chg slen c			; Changes Symbol Mode
					snam slst OK newBlk newlay symf Msnam AttFol LayNam )
	(setq	MinP		(getvar "EXTMIN")
			MaxP		(getvar "EXTMAX")
			WorkD	(* (- (car MaxP) (car MinP)) 0.02)
			WorkP	(list	(- (car MinP) WorkD)
							(- (cadr MinP) WorkD)
					)
			WorkP1	(list	(- (car WorkP) 2.0)
							(- (cadr WorkP) 2.0)
					)
			WorkP2	(list	(+ (car WorkP) 2.0)
							(+ (cadr WorkP) 2.0)
					)
			WorkE1	(ssname ssG 0)
			WorkE2	(entget WorkE1)
			WorkN	(cdr (assoc 2 WorkE2))
	)
	(setq	ExN		(getvar "EXPERT"))
	(setvar "EXPERT" 1)
	(command "_.ZOOM" "_C" WorkP (* WorkD 2.0))
	(command "INSERT" (strcat "*NEW_" WorkN) WorkP "1" "0")
	(command "BLOCK" WorkN "Y" WorkP "C" WorkP1 WorkP2 "")
	(command "_.ZOOM" "_P")
	(setvar "EXPERT" ExN)
)

(defun StatLin ( StrtNum EndNum / )			; Defines status line for Application
	(setvar	"USERI1" StrtNum)
	(setvar	"USERI2" EndNum)
	(if Div
		(setvar "USERS3" Div)
	)
	(setvar	"MODEMACRO"
		(strcat
			"Working on: $(getvar,USERI1)"
			" of $(getvar,USERI2)"
			"  Div: $(getvar,USERS3)"
		)
	)
)

(defun StatStep ( / )						; Updates status line for Application
	(if (and (>= (getvar "USERI1") 1) (>= (getvar "USERI2") 1))
		(if (< (getvar "USERI1") (getvar "USERI2"))
			(setvar "USERI1" (1+ (getvar "USERI1")))
		)
	)
	(princ)
)

(defun Bld_Fdr_Lst_Tmp ( / fp1 _STR _LST FNam )	; Builds Feeder Data List
;function to build table for feeder
;Builds Text List Lst_Fd_V  ---> feeder value (ADDS FEEDER CODE)
;                 Lst_Fd_C  ---> feeder color number.
;                 Lst_Fd_S  ---> feeder description. (DOES number plus substation name.
	(setq	FNam	"feeder.lut")
	(if Bug (princ (strcat "\nOpening " FNam " for import!")))
	(if (setq fp1 (open FNam "r"))
		(progn
			(setq Lst_Fd_C	nil
				 Lst_Fd_S	nil
				 Lst_Fd_V	nil
			)
			(while (setq _STR (read-line fp1))
				(setq _LST (read (strcat "(" _STR ")")))
				(if (>= (length _LST) 4)
					(setq Lst_Fd_V	(append Lst_Fd_V
									   (list (nth 0 _LST))
								)
						 Lst_Fd_C	(append Lst_Fd_C
									   (list (nth 1 _LST))
								)
						 Lst_Fd_S	(append
									Lst_Fd_S
									(list (strcat
											 (nth 2 _LST)
											 " "
											 (nth 3 _LST)
										 )
									)
								)
					)
				)
			)
			(close fp1)
		)
		(alert (strcat "ERROR Opening: " FNam))
	)
	(princ)
)

(defun LayPhChg ( /	Dnam Fnam LayN LayTmp x	; Layer Phase Change
					LayT LayD ColD LytD Cnt ssL e1 e2 T1 ssCap ssNo
					Cntr LayLst LayOne LayTwo LayThr Wnam Bubba )
;;;	Function to perform one-time drawing update to bring R12 drawings into R14,
;;;	with appropriate new phase descriptors and updated block & color definitions	
;;;	Uses these funtions internally:
;;;		Bld_Fdr_Lst_Tmp	requires feeder.lut local!
;;;		StatLin
;;;		UpdSym
;;;		Twizzle
;;;		PadNum
;;;		ErrUp
;;;		MkLay
;;;		LayUpdObj
;;;			FdrLenTst
;;;				GetPLen
	(cond
		((= (substr (getvar "ACADVER") 1 4) "17.0")
			(if (not (member (strcase "DosLib17.Arx" T) (arx)))
				(if (findfile "DosLib17.Arx")
					(arxload "DosLib17")
					(if AppNam
						(princ (strcat "\n*" AppNam " Error*: DosLib Arx file not found on this system!"))
						(princ "\n*Buttons Error*: DosLIB Arx file not found on this system!")
					)
				)
			)
		)
		((= (getvar "ACADVER") "14.0")
			(if (not (member (strcase "DosLib14.arx" T) (arx)))
				(if (findfile "doslib14.arx")
					(arxload "doslib14")
					(if AppNam
						(princ (strcat "\n*" AppNam " Error*: DosLib Arx file not found on this system!"))
						(princ "\n*Buttons Error*: DosLIB Arx file not found on this system!")
					)
				)
			)
		)
	)
	(if (not (and Lst_Fd_C Lst_Fd_V))
		(Bld_Fdr_Lst_Tmp)
	)
	(if (not MkLay)
		(load "Symbols")
	)
	(if (not Div)
		(progn
			(setq	Div	(getenv "DIVMAP"))
			(if Div
				(if (= (strlen Div) 1)
					(setq	Div	(strcat Div "_"))
					(if (> (strlen Div) 2)
						(setq	Div	(substr Div 1 2))
						(if (not (= (strlen Div) 2))
							(setq	Div	nil)
						)
					)
				)
			)
		)
	)
;;;	(if StrtNum
;;;		(setq	StrtNum	(1+ StrtNum)
;;;				Bubba	(setvar "USERI1" StrtNum)
;;;				Bubba	(StatLin StrtNum EndNum)
;;;		)
;;;		(setq	StrtNum	1
;;;				EndLst	(dos_dir "*.dwg")
;;;				EndNum	(length EndLst)
;;;				EndLst	(cdr EndLst)
;;;				Bubba	(StatLin StrtNum EndNum)
;;;		)
;;;	)
	(setvar "CMDECHO" 0)
	(setvar "FILEDIA" 0)
	(setvar "CMDDIA" 0)
	(setvar "GRIDMODE" 0)
	(setvar "SNAPMODE" 0)
	(setvar "ORTHOMODE" 0)
	(setvar "REGENMODE" 1)
	(setvar "OSMODE" 0)
	(setvar "EXPERT" 5)
	(princ "\nGathering Layer List...")
	(command "_.LAYER" "_T" "*" "_ON" "*" "_U" "*" "_S" "0" "" "_.ZOOM" "_E" "_.ZOOM" "0.7x")
;;;	(setq	ssCap	(ssget "X" '((0 . "INSERT")(2 . "CAP*"))))
;;;	(if ssCap
;;;		(UpdSym ssCap)
;;;	)
;;;	(setq	ssNo		(ssget "X" '((0 . "INSERT")(2 . "NO"))))
;;;	(if ssNo
;;;		(UpdSym ssNo)
;;;	)
	(setq	LayLst	nil
			LayN		(tblnext "LAYER" T)
			Dnam		(strcase (getvar "DWGNAME"))
			LayTmp	(list (cdr (assoc 2 LayN)))
			Cntr		0
	)
	(if (> (strlen Dnam) 4)
		(if (= ".DWG" (substr Dnam (- (strlen Dnam) 3) 4))
			(setq	Dnam	(substr Dnam 1 (- (strlen Dnam) 4)))
		)
	)
	(while (setq LayN (tblnext "LAYER"))
		(if LayN
			(setq	LayTmp	(cons (cdr (assoc 2 LayN)) LayTmp))
		)
	)
	(foreach		x
				LayTmp
				(Twizzle Cntr)
				(setq	Cntr	(1+ Cntr))
				(if (>= (strlen x) 10)
					(if (member (substr x 8 1) (list "1" "2" "3"))
						(if LayLst
							(setq	LayLst	(append LayLst (list x)))
							(setq	LayLst	(list x))
						)
					)
				)
	)
	(Twizzle (- 0 Cntr))
	(setq	Cntr		0)
	(if LayLst
		(princ "\nSeparating Layer by Phase...")
	)
	(if LayLst
		(foreach		x
					LayLst
					(Twizzle Cntr)
					(setq	Cntr	(1+ Cntr))
					(if (= (substr x 8 1) "1")
						(if LayOne
							(setq	LayOne	(append LayOne (list x)))
							(setq	LayOne	(list x))
						)
						(if (= (substr x 8 1) "2")
							(if LayTwo
								(setq	LayTwo	(append LayTwo (list x)))
								(setq	LayTwo	(list x))
							)
							(if (= (substr x 8 1) "3")
								(if LayThr
									(setq	LayThr	(append LayThr (list x)))
									(setq	LayThr	(list x))
								)
							)
						)
					)
		)
	)
	(if LayLst
		(Twizzle (- 0 Cntr))
	)
	(setq	Cntr		0)
	(if LayOne
		(princ (strcat "\nCounting " (itoa (length LayOne)) " layers were Phase One."))
	)
	(if LayTwo
		(princ (strcat "\nCounting " (itoa (length LayTwo)) " layers were Phase Two."))
	)
	(if LayThr
		(princ (strcat "\nCounting " (itoa (length LayThr)) " layers were Phase Three."))
	)
	(if LayOne
		(princ "\nGenerating Layers for Single Phase...")
	)
	(if LayOne
		(foreach		x
					LayOne
					(Twizzle Cntr)
					(setq	Cntr	(1+ Cntr))
					(setq	LayT	(strcat (substr x 1 7) "4" (substr x 9 2))
							LayD	(tblsearch "LAYER" x)
					)
					(if Lst_Fd_V
						(setq	PosOut	(- (length Lst_Fd_V) (length (member (substr x 1 3) Lst_Fd_V))))
					)
					(if PosOut
						(if (= PosOut (length Lst_Fd_V))
							(setq	PosOut	nil
									Bubba	(ErrUp "Lst_Err" (strcat Div (getvar "DWGNAME") "->" x "->" (PadNum (itoa (cdr (assoc 62 LayD))) 3) "->" "Not in Fdr List?"))
							)
						)
						(setq	Bubba	(ErrUp "Lst_Err" (strcat Div (getvar "DWGNAME") "->" x "->" (PadNum (itoa (cdr (assoc 62 LayD))) 3) "->" "Not in Fdr List?")))
					)
					(if (/= (strcase (substr x 5 3)) "CK-")
						(setq	PosOut	nil)
					)
					(if PosOut
						(setq	ColD		(nth PosOut Lst_Fd_C))
						(if (assoc 62 LayD)
							(if (/= (itoa (cdr (assoc 62 LayD))) "7")
								(setq	ColD		(itoa (cdr (assoc 62 LayD))))
								(if (= (substr x 5 3) "CK-")
									(setq	ColD		(itoa (cdr (assoc 62 LayD)))
											Bubba	(ErrUp "CritErr" (strcat (getvar "DWGNAME") "->" x "->" "Col7?"))
									)
									(setq	ColD		(itoa (cdr (assoc 62 LayD)))
											Bubba	(ErrUp "SimpErr" (strcat (getvar "DWGNAME") "->" x "->" "Col7?"))
									)
								)
							)
							(setq	ColD		"7"
									Bubba	(ErrUp "SimpErr" (strcat (getvar "DWGNAME") "->" x "->" "No 62?"))
							)
						)
					)
					(if (assoc 6 LayD)
						(setq	LytD	(cdr (assoc 6 LayD)))
						(setq	LytD	"CONTINUOUS")
					)
					(if (and (>= (ascii (substr x 3 1)) 48) (<= (ascii (substr x 3 1)) 57) (assoc (substr x 9 2) Lst_kV_Clr))
						(setq	ColD		(cadr (assoc (substr x 9 2) Lst_kV_Clr)))
					)
					(command "_.LAYER" "_M" LayT "_C" ColD LayT "_L" LytD LayT "")
		)
	)
	(if LayOne
		(Twizzle (- 0 Cntr))
	)
	(setq	Cntr		0)
	(if LayTwo
		(princ "\nGenerating Layers for Double Phase...")
	)
	(if LayTwo
		(foreach		x
					LayTwo
					(Twizzle Cntr)
					(setq	Cntr	(1+ Cntr))
					(setq	LayT	(strcat (substr x 1 7) "1" (substr x 9 2))
							LayD	(tblsearch "LAYER" x)
					)
					(if Lst_Fd_V
						(setq	PosOut	(- (length Lst_Fd_V) (length (member (substr x 1 3) Lst_Fd_V))))
					)
					(if PosOut
						(if (= PosOut (length Lst_Fd_V))
							(setq	PosOut	nil
									Bubba	(ErrUp "Lst_Err" (strcat Div (getvar "DWGNAME") "->" x "->" (PadNum (itoa (cdr (assoc 62 LayD))) 3) "->" "Not in Fdr List?"))
							)
						)
						(setq	Bubba	(ErrUp "Lst_Err" (strcat Div (getvar "DWGNAME") "->" x "->" (PadNum (itoa (cdr (assoc 62 LayD))) 3) "->" "Not in Fdr List?")))
					)
					(if (/= (strcase (substr x 5 3)) "CK-")
						(setq	PosOut	nil)
					)
					(if PosOut
						(setq	ColD		(nth PosOut Lst_Fd_C))
						(if (assoc 62 LayD)
							(if (/= (itoa (cdr (assoc 62 LayD))) "7")
								(setq	ColD		(itoa (cdr (assoc 62 LayD))))
								(if (= (substr x 5 3) "CK-")
									(setq	ColD		(itoa (cdr (assoc 62 LayD)))
											Bubba	(ErrUp "CritErr" (strcat (getvar "DWGNAME") "->" x "->" "Col7?"))
									)
									(setq	ColD		(itoa (cdr (assoc 62 LayD)))
											Bubba	(ErrUp "SimpErr" (strcat (getvar "DWGNAME") "->" x "->" "Col7?"))
									)
								)
							)
							(setq	ColD		"7"
									Bubba	(ErrUp "SimpErr" (strcat (getvar "DWGNAME") "->" x "->" "No 62?"))
							)
						)
					)
					(if (assoc 6 LayD)
						(setq	LytD	(cdr (assoc 6 LayD)))
						(setq	LytD	"CONTINUOUS")
					)
					(if (and (>= (ascii (substr x 3 1)) 48) (<= (ascii (substr x 3 1)) 57) (assoc (substr x 9 2) Lst_kV_Clr))
						(setq	ColD		(cadr (assoc (substr x 9 2) Lst_kV_Clr)))
					)
					(command "_.LAYER" "_M" LayT "_C" ColD LayT "_L" LytD LayT "")
		)
	)
	(if LayTwo
		(Twizzle (- 0 Cntr))
	)
	(setq	Cntr		0)
	(if LayThr
		(princ "\nGenerating Layers for Triple Phase...")
	)
	(if LayThr
		(foreach		x
					LayThr
					(Twizzle Cntr)
					(setq	Cntr	(1+ Cntr))
					(setq	LayT	(strcat (substr x 1 7) "0" (substr x 9 2))
							LayD	(tblsearch "LAYER" x)
					)
					(if Lst_Fd_V
						(setq	PosOut	(- (length Lst_Fd_V) (length (member (substr x 1 3) Lst_Fd_V))))
					)
					(if PosOut
						(if (= PosOut (length Lst_Fd_V))
							(setq	PosOut	nil
									Bubba	(ErrUp "Lst_Err" (strcat Div (getvar "DWGNAME") "->" x "->" (PadNum (itoa (cdr (assoc 62 LayD))) 3) "->" "Not in Fdr List?"))
							)
						)
						(setq	Bubba	(ErrUp "Lst_Err" (strcat Div (getvar "DWGNAME") "->" x "->" (PadNum (itoa (cdr (assoc 62 LayD))) 3) "->" "Not in Fdr List?")))
					)
					(if (/= (strcase (substr x 5 3)) "CK-")
						(setq	PosOut	nil)
					)
					(if PosOut
						(setq	ColD		(nth PosOut Lst_Fd_C))
						(if (assoc 62 LayD)
							(if (/= (itoa (cdr (assoc 62 LayD))) "7")
								(setq	ColD		(itoa (cdr (assoc 62 LayD))))
								(if (= (substr x 5 3) "CK-")
									(setq	ColD		(itoa (cdr (assoc 62 LayD)))
											Bubba	(ErrUp "CritErr" (strcat (getvar "DWGNAME") "->" x "->" "Col7?"))
									)
									(setq	ColD		(itoa (cdr (assoc 62 LayD)))
											Bubba	(ErrUp "SimpErr" (strcat (getvar "DWGNAME") "->" x "->" "Col7?"))
									)
								)
							)
							(setq	ColD		"7"
									Bubba	(ErrUp "SimpErr" (strcat (getvar "DWGNAME") "->" x "->" "No 62?"))
							)
						)
					)
					(if (assoc 6 LayD)
						(setq	LytD	(cdr (assoc 6 LayD)))
						(setq	LytD	"CONTINUOUS")
					)
					(if (and (>= (ascii (substr x 3 1)) 48) (<= (ascii (substr x 3 1)) 57) (assoc (substr x 9 2) Lst_kV_Clr))
						(setq	ColD		(cadr (assoc (substr x 9 2) Lst_kV_Clr)))
					)
					(command "_.LAYER" "_M" LayT "_C" ColD LayT "_L" LytD LayT "")
		)
	)
	(if LayThr
		(Twizzle (- 0 Cntr))
	)
	(setq	Cntr		0)
	(if LayOne
		(princ "\nValidating Objects for Single Phase...")
	)
	(if LayOne
		(foreach		x
					LayOne
					(Twizzle Cntr)
					(setq	Cntr	(1+ Cntr))
					(setq	ssL	(ssget "X" (list (cons 8 x)))
							LayL	0.0
							LayT	(strcat (substr x 1 7) "4" (substr x 9 2))
					)
					(if ssL
						(setq	Cnt		0)
						(setq	Cnt		nil)
					)
					(if Cnt
						(while (< Cnt (sslength ssL))
							(setq	e1	(ssname ssL Cnt)
									Doit	(LayUpdObj e1 LayT)
									Cnt	(1+ Cnt)
							)
						)
					)
					(setq	ssL	nil)
		)
	)
	(if LayOne
		(Twizzle (- 0 Cntr))
	)
	(setq	Cntr		0)
	(if LayTwo
		(princ "\nValidating Objects for Double Phase...")
	)
	(if LayTwo
		(foreach		x
					LayTwo
					(Twizzle Cntr)
					(setq	Cntr	(1+ Cntr))
					(setq	ssL	(ssget "X" (list (cons 8 x)))
							LayL	0.0
							LayT	(strcat (substr x 1 7) "1" (substr x 9 2))
					)
					(if ssL
						(setq	Cnt		0)
						(setq	Cnt		nil)
					)
					(if Cnt
						(while (< Cnt (sslength ssL))
							(setq	e1	(ssname ssL Cnt)
									Doit	(LayUpdObj e1 LayT)
									Cnt	(1+ Cnt)
							)
						)
					)
					(setq	ssL	nil)
		)
	)
	(if LayTwo
		(Twizzle (- 0 Cntr))
	)
	(setq	Cntr		0)
	(if LayThr
		(princ "\nValidating Objects for Triple Phase...")
	)
	(if LayThr
		(foreach		x
					LayThr
					(Twizzle Cntr)
					(setq	Cntr	(1+ Cntr))
					(setq	ssL	(ssget "X" (list (cons 8 x)))
							LayL	0.0
							LayT	(strcat (substr x 1 7) "0" (substr x 9 2))
					)
					(if ssL
						(setq	Cnt		0)
						(setq	Cnt		nil)
					)
					(if Cnt
						(while (< Cnt (sslength ssL))
							(setq	e1	(ssname ssL Cnt)
									Doit	(LayUpdObj e1 LayT)
									Cnt	(1+ Cnt)
							)
						)
					)
					(setq	ssL	nil)
		)
	)
	(if LayThr
		(Twizzle (- 0 Cntr))
	)
	(setq	Cntr		0)

	(setvar "FILEDIA" 1)
	(setvar "CMDDIA" 1)
	(if (= (getvar "USERI5") 0)
		(setvar "USERI5" 1)
		(setvar "USERI5" 0)
	)
	(princ)
)

(defun PurgeA14 ( / )						; Automatic Purge and Save
	(command "_.PURGE" "_A" "*" "_N")
	(command "_.QSAVE")
	(if (= (getvar "USERI5") 0)
		(setvar "USERI5" 1)
		(setvar "USERI5" 0)
	)
	(princ)
)

(defun C:LayUp ( / )						; CL - Runs LayPhChg and then PurgeA14
	(command "_.Layer" "T" "*" "on" "*" "U" "*" "S" "0" "" "_.Zoom" "E")
	(PurgeA14)
	(princ)
)

(defun DoCompFdr ( FNam1 FNam2 / )			; Compares Feeders from different tables
	(if FNam1
		(princ (strcat "\nFdr #1: " FNam1))
	)
	(if FNam2
		(princ (strcat "\nFdr #2: " FNam2))
	)
	(if (and Lst1_Fd_V Lst2_Fd_V)
		(foreach	Fdr_V
				Lst2_Fd_V
				(cond	((not (member Fdr_V Lst1_Fd_V))
							(princ (strcat "\nFeeder Number " Fdr_V " does not exist in Fdr #1"))
						)
						(T
							(setq	PosOut1	(- (length Lst1_Fd_V) (length (member Fdr_V Lst1_Fd_V)))
									PosOut2	(- (length Lst2_Fd_V) (length (member Fdr_V Lst2_Fd_V)))
							)
							(if (/= (nth PosOut1 Lst1_Fd_C) (nth PosOut2 Lst2_Fd_C))
								(princ (strcat "\nFeeder Number " Fdr_V " mismatches Colors 1->" (itoa (nth PosOut1 Lst1_Fd_C)) " Colors 2->" (itoa (nth PosOut2 Lst2_Fd_C))))
								(if Bug
									(princ (strcat "\nFeeder Number " Fdr_V " ___matches Colors 1->" (itoa (nth PosOut1 Lst1_Fd_C)) " Colors 2->" (itoa (nth PosOut2 Lst2_Fd_C))))
								)
							)
							(if (/= (strcase (nth PosOut1 Lst1_Fd_S)) (strcase (nth PosOut2 Lst2_Fd_S)))
								(princ (strcat "\nFeeder Number " Fdr_V " mismatches Name 1->" (nth PosOut1 Lst1_Fd_S) " Name 2->" (nth PosOut2 Lst2_Fd_S)))
								(if Bug
									(princ (strcat "\nFeeder Number " Fdr_V " ___matches Name 1->" (nth PosOut1 Lst1_Fd_S) " Name 2->" (nth PosOut2 Lst2_Fd_S)))
								)
							)
						)
				)
		)
	)
)

(defun C:Comp_Fdr ( /	fp1 fp2 _STR _LST FNam1 	; Compares Feeder Data List
					FNam2 )
;function to build temp tables for feeders
;Builds Text List Lst_Fd_V  ---> feeder value (ADDS FEEDER CODE)
;                 Lst_Fd_C  ---> feeder color number.
;                 Lst_Fd_S  ---> feeder description. (DOES number plus substation name.
	(setq	FNam1	(getfiled "Feeder File #1" "h:/data/" "lut" 4))
	(princ (strcat "\nOpening #1 " FNam1 " for import!"))
	(if (setq fp1 (open FNam1 "r"))
		(progn
			(setq Lst1_Fd_C	nil
				 Lst1_Fd_S	nil
				 Lst1_Fd_V	nil
			)
			(while (setq _STR (read-line fp1))
				(setq _LST (read (strcat "(" _STR ")")))
				(if (>= (length _LST) 4)
					(setq Lst1_Fd_V	(append Lst1_Fd_V
									   (list (nth 0 _LST))
								)
						 Lst1_Fd_C	(append Lst1_Fd_C
									   (list (nth 1 _LST))
								)
						 Lst1_Fd_S	(append
									Lst1_Fd_S
									(list (strcat
											 (nth 2 _LST)
											 " "
											 (nth 3 _LST)
										 )
									)
								)
					)
				)
			)
			(close fp1)
		)
		(alert (strcat "ERROR Opening: " FNam1))
	)
	(setq	FNam2	(getfiled "Feeder File #2" "s:/workgr~1/apcpow~1/divisi~1/lookup~1/" "lut" 4))
	(princ (strcat "\nOpening #2 " FNam2 " for import!"))
	(if (setq fp2 (open FNam2 "r"))
		(progn
			(setq Lst2_Fd_C	nil
				 Lst2_Fd_S	nil
				 Lst2_Fd_V	nil
			)
			(while (setq _STR (read-line fp2))
				(setq _LST (read (strcat "(" _STR ")")))
				(if (>= (length _LST) 4)
					(setq Lst2_Fd_V	(append Lst2_Fd_V
									   (list (nth 0 _LST))
								)
						 Lst2_Fd_C	(append Lst2_Fd_C
									   (list (nth 1 _LST))
								)
						 Lst2_Fd_S	(append
									Lst2_Fd_S
									(list (strcat
											 (nth 2 _LST)
											 " "
											 (nth 3 _LST)
										 )
									)
								)
					)
				)
			)
			(close fp2)
		)
		(alert (strcat "ERROR Opening: " FNam2))
	)
	(DoCompFdr FNam1 FNam2)
	(princ)
)

(defun ForceLay ( _LAY / CmdStr _POS _CLR _LT )	; Forces a Layer to match rules
	(setq	_LT	"CONTINUOUS")
	(setq ColorBy "FD")
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
	(if	(= (substr _LAY 1 1) "-")
		(setq	_LT	"DASHED")
		(if (null DontE)
			(if (and (or (= (stpDot AppNam) "CADET20")(= (stpDot AppNam) "CADET"))
				    (<= (strlen _LAY) 10)
			    )
				(cond ((and (= AppMode "I")
						  (= (substr _LAY 5 2) "CK")
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
					 ((= AppMode "C")
					  (setq _LAY (strcat _LAY "C")
						   _LT  "CONTINUOUS"
					  )
					 )
					 ((= AppMode "R")
					  (setq _LAY (strcat _LAY "R")
						   _LT  "CONTINUOUS"
					  )
					 )
					 (T (setq _LT "CONTINUOUS"))
				)
				(if (or (= (substr _LAY 11 1) "I")
					   (= (substr _LAY 11 1) "C")
				    )
					(setq _LT "HIDDEN2")
					(setq _LT "CONTINUOUS")
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
	)
	(if AppNam
		(if (= (StpDot AppNam) "BEMS")
			(if	(= _CLR 3)
				(setq	_CLR		195
						Bubba	(if Bug (princ "\n{Bug:In BEMS, no Green feeders!}\n"))
				)
				(if	(and	(>= _CLR 70)
						(<= _CLR 90)
					)
					(setq	_CLR		(+ _CLR 115)
							Bubba	(if Bug (princ "\n{Bug:In BEMS, no Green-ish feeders!}\n"))
					)
				)
			)
		)
	)
	(if (null (tblsearch "LAYER" _LAY))
		(setq	CmdStr	(list "m" _LAY "c" _CLR _LAY "lt" _LT _LAY))
		(progn
			(setq	NLay		(tblsearch "LAYER" _LAY)
					NCol		(cdr (assoc 62 NLay))
					NLt		(cdr (assoc 6 NLay))
			)
			(if (or	(/= NCol _CLR)
					(/= NLt _LT)
				)
				(setq	CmdStr	(list "c" _CLR _LAY "lt" _LT _LAY))
			)
		)
	)
	(if	(and	Bug
			(or	(/= NCol _CLR)
				(/= NLt _LT)
			)
		)
		(if _CLR
			(if (= (type _CLR) (quote INT))
				(princ (strcat	"\nForceLay = " _LAY ", Lt = " _LT ", _CLR =" (itoa _CLR) "  "))
			)
		)
	)
	CmdStr
)

(defun Kv_Clr ( / )						; Reset circuit colors by voltage level
	(if Bug (princ "kv_clr entered"))
	(command	"_.LAYER"
			"C"	"5"	"??#???-?04*"	;04 kV
			"C"	"7"	"??#???-?12*"	;12 kV
			"C"	"4"	"??#???-?13*"	;13 kV
			"C"	"1"	"??#???-?20*"	;20 kV
			"C"	"3"	"??#???-?23*"	;23 kV
			"C"	"6"	"??#???-?35*"	;35 kV
			"C"	"6"	"??#???-?38*"	;38 kV
			"C"	"6"	"??#???-?44*"	;44 kV
			"C"	"6"	"??#???-?46*"	;46 kV
			"C"	"5"	"??#???-?69*"	;69 kV
			"C"	"2"	"??#???-?15*"	;115 kV
			"C"	"30"	"??#???-?61*"	;161 kV
			"C"	"30"	"??#???-?08*"	;208 kV
			"C"	"4"	"??#???-?30*"	;230 kV
			"C"	"2"	"??#???-?80*"	;480 kV
			"C"	"3"	"??#???-?00*"	;500 kV
			"C"	"2"	"????CP*"		;Computer Points
			"C"	"15"	"????CE*"		;Customer Equipment
			"C"	"7"	"????NO*"		;Normal Opens
			"C"	"15"	"???ULO*"
			"C"	"15"	"????PM*"
			""
	)
	(if Bug (princ "kv_clr exited"))
)

(defun ValiDo ( /	LayN x					; Layer Phase Change
				LayT LayD 
				Cntr BadEnts )
;;;	Uses these funtions internally:
;;;		Twizzle
;;;		PadNum
;;;		LayUpdObj
;;;			FdrLenTst
;;;				GetPLen
	(if (not (and Lst_Fd_C Lst_Fd_V))
		(progn
			(alert (strcat "***" AppNam " Error*\nNo LookUpTable found..."))
			(exit)
		)
	)
	(setvar "CMDECHO" 0)
	(setvar "FILEDIA" 0)
	(setvar "CMDDIA" 0)
	(setvar "GRIDMODE" 0)
	(setvar "SNAPMODE" 0)
	(setvar "ORTHOMODE" 0)
	(setvar "REGENMODE" 1)
	(setvar "OSMODE" 0)
	(setvar "EXPERT" 5)
	(princ "\nGathering Layer List...")
	(if (and (not PanLst) (= (substr (StpDot AppNam) 1 4) "SUBT"))
		(command "_.LTScale" "12")
	)
	(Kv_Clr)
	(command "_.LAYER" "_T" "*" "_ON" "*" "_U" "*" "_S" "0" "" "_.ZOOM" "_E" "_.ZOOM" "0.7x")
	(setq	LayLst	nil
			WrkLst	nil
			LayTmp	nil
			GetSSl	nil
			WrkObj	nil
			Cntr		0
			LayTst	(nth 1 (GetSelVals))
			LayN		(tblnext "LAYER" T)
			LayTmp	(list (cdr (assoc 2 LayN)))
	)
	(while (setq LayN (tblnext "LAYER"))
		(if LayN
			(setq	LayTmp	(cons (cdr (assoc 2 LayN)) LayTmp))
		)
	)
	(if (and LayTmp Bug) (princ (strcat "\nFound " (itoa (length LayTmp)) " layers!")))
	(if LayTst
		(foreach		x
					LayTmp
					(Twizzle Cntr)
					(setq	Cntr	(1+ Cntr))
					(if (= (strlen x) 10)
						(if (member (substr x 1 3) LayTst)
							(if LayLst
								(setq	LayLst	(append LayLst (list x)))
								(setq	LayLst	(list x))
							)
							(if Bug (princ "."))
						)
					)
		)
		(setq	LayLst	nil)
	)
	(Twizzle (- 0 Cntr))
	(setq	Cntr		0
			LayOop	0
	)
	(if (and LayLst Bug) (princ (strcat "\nFound " (itoa (length LayLst)) " working layers!")))
	(if LayLst
		(foreach		x
					LayLst
					(Twizzle Cntr)
					(setq	Cntr	(1+ Cntr)
							LayW	(ForceLay x)
					)
					(if LayW
						(if WrkLst
							(setq	WrkLst	(append WrkLst LayW)
									LayOop	(1+ LayOop)
							)
							(setq	WrkLst	LayW
									LayOop	(1+ LayOop)
							)
						)
					)
		)
	)
	(if LayLst
		(Twizzle (- 0 Cntr))
	)
	(setq	Cntr		0)
	(if WrkLst
		(progn
			(princ (strcat "\nExecuting " (itoa LayOop) " Layer Changes..."))
			(setq	WrkLst	(cons "" (reverse WrkLst))
					WrkLst	(cons "_.LAYER" (reverse WrkLst))
			)
			(mapcar (quote command) WrkLst)
		)
	)
	(setq	LayFltStr	(mapcar (quote (lambda (x) (cons 8 (strcat x "*")))) LayTst))
;;;	(setq	FltrStr	(list	(cons -4 "<OR")
;;;							(cons 0 "*POLY*")
;;;							(cons 0 "INSERT")
;;;							(cons 0 "*TEXT")
;;;							(cons 0 "CIRCLE")
;;;							(cons -4 "OR>")
;;;					)
;;;			TstStr	(cons	(cons -4 "OR>") (reverse LayFltStr))
;;;			TstStr	(cons	(cons -4 "<OR") (reverse TstStr))
;;;			TstStr	(append TstStr FltrStr)
;;;			TstStr	(cons	(cons -4 "AND>") (reverse TstStr))
;;;			TstStr	(cons	(cons -4 "<AND") (reverse TstStr))
;;;			GetSSl	(ssget "X" TstStr)
;;;	)
	(setq	GetSSl		(ssget "X"	(list	(cons -4 "<OR")
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
	)
	(if GetSSl
		(setq	WrkObj	(EntNamGrp GetSSl)
				Cntr		0
				Bubba	(princ (strcat "\nWorking " (itoa (length WrkObj)) " objects."))
		)
	)
	(if WrkObj
		(foreach	Obj
				WrkObj
				(Twizzle Cntr)
				(setq	Cntr	(1+ Cntr))
				(LayUpdObj Obj nil)
		)
	)
	(Twizzle (- 0 Cntr))
	(setq	Cntr		0)
	(if (setq BadEnts (ssget "X" (list (cons 0 "INSERT")(cons 2 "LOCK"))))
		(progn
			(command "_.ERASE" BadEnts "")
			(RepOutFil "Erased Lock Graphic!")
		)
	)
	(if (setq	BadEnts	(ssget "X"	(list	(cons -4 "<OR")
												(cons 0 "ARC")
												(cons 0 "LINE")
											(cons -4 "OR>")
									)
						)
		)
		(RepOutFil (strcat "Converted " (itoa (ConVert2Poly BadEnts)) " objects to PolyLines"))
	)
	(if (setq	BadEnts	(ssget "X" (list (cons 0 "LWPOLYLINE"))))
		(RepOutFil (strcat "*Error*\t\tFound " (itoa (sslength BadEnts)) " LWPolyLines!"))
	)
	(setvar "FILEDIA" 1)
	(setvar "CMDDIA" 1)
	(princ)
)

(defun C:ValiDoIt ( / )						; CL - Layer Phase Change
	(ValiDo)
	(princ)
)

(defun ColorUp ( /	Cntr LayTst LayN LayTmp x	; Update Layer Colors from Table
				LayOop LayLst LayW WrkLst ssCirc )
;;;	Uses these funtions internally:
;;;		Twizzle
;;;		ForceLay
;;;		Bld_T_Fdr
	(if Bld_T_Fdr
		(Bld_T_Fdr)
		(progn
			(alert (strcat "***" AppNam " Error*\nTable functions not found..."))
			(exit)
		)
	)
	(if (not (and Lst_Fd_C Lst_Fd_V))
		(progn
			(alert (strcat "***" AppNam " Error*\nNo LookUpTable found..."))
			(exit)
		)
	)
	(setvar "CMDECHO" 0)
	(setvar "FILEDIA" 0)
	(setvar "CMDDIA" 0)
	(setvar "GRIDMODE" 0)
	(setvar "SNAPMODE" 0)
	(setvar "ORTHOMODE" 0)
	(setvar "REGENMODE" 1)
	(setvar "OSMODE" 0)
	(setvar "EXPERT" 5)
	(princ "\nGathering Layer List...")
	(if Kv_Clr
		(Kv_Clr)
	)
	(command "_.LAYER" "_T" "*" "_ON" "*" "_U" "*" "_S" "0" "" "_.ZOOM" "_E" "_.ZOOM" "0.7x")
	(setq	ssCirc	(ssget "X"	(list	(cons 0 "POLYLINE")
										(cons 8 "????CK-###*")
								)
					)
	)
	(if ssCirc
		(command "_.ChProp" ssCirc "" "C" "ByLayer" "")
	)
	(if ssCirc
		(setq	ssCirc	nil)
	)
	(setq	Cntr		0
			LayTst	(nth 1 (GetSelVals))
			LayN		(tblnext "LAYER" T)
			LayTmp	(list (cdr (assoc 2 LayN)))
	)
	(while (setq LayN (tblnext "LAYER"))
		(if LayN
			(setq	LayTmp	(cons (cdr (assoc 2 LayN)) LayTmp))
		)
	)
;	(if Bug (prin1 LayTmp))
	(if (and LayTmp Bug) (princ (strcat "\nFound " (itoa (length LayTmp)) " layers!\n")))
	(if Bug (prin1 LayTst))
	(if LayTst
		(foreach		x
					LayTmp
					(Twizzle Cntr)
					(setq	Cntr	(1+ Cntr))
					(if (= (strlen x) 10)
						(if (member (substr x 1 3) LayTst)
							(if LayLst
								(setq	LayLst	(append LayLst (list x)))
								(setq	LayLst	(list x))
							)
							(if Bug (princ (strcat "\nDoes not match: " (substr x 1 3) "  ")))
						)
					)
		)
		(setq	LayLst	nil)
	)
	(Twizzle (- 0 Cntr))
	(setq	Cntr		0
			LayOop	0
	)
;	(if Bug (prin1 LayLst))
	(if (and LayLst Bug) (princ (strcat "\nFound " (itoa (length LayLst)) " working layers!")))
	(if LayLst
		(foreach		x
					LayLst
					(Twizzle Cntr)
					(setq	Cntr	(1+ Cntr)
							LayW	(ForceLay x)
					)
					(if LayW
						(if WrkLst
							(setq	WrkLst	(append WrkLst LayW)
									LayOop	(1+ LayOop)
							)
							(setq	WrkLst	LayW
									LayOop	(1+ LayOop)
							)
						)
					)
		)
	)
	(if LayLst
		(Twizzle (- 0 Cntr))
	)
	(setq	Cntr		0)
	(if WrkLst
		(progn
			(princ (strcat "\nExecuting " (itoa LayOop) " Layer Changes..."))
			(setq	WrkLst	(cons "" (reverse WrkLst))
					WrkLst	(cons "_.LAYER" (reverse WrkLst))
			)
			(mapcar (quote command) WrkLst)
		)
	)
	(setvar "FILEDIA" 1)
	(setvar "CMDDIA" 1)
	(princ)
)

(defun C:ColorUp ( / )						; CL - Update Layer Colors from Table
	(ColorUp)
	(princ)
)

(defun C:DLM ( / )							; CL - DL in Meters
	(DLx "METERS")
)

(defun C:DLF ( / )							; CL - DL in Feet
	(DLx "FEET")
)

(defun DLx ( inwhat /	lyr pt1 pt2 ang1		; Draw pLine at angle/distance in DefPoints
					dist ang2 )
	; If <inwhat> not equal to METERS, then defaults to FEET.
	(setq	lyr	(getvar "CLAYER"))
	(command	"_.LAYER" "m" "DEFPOINTS" "")
	(setq	pt1		(getpoint "\nPick 1st Point of Line: "))
	(setq	pt2		(getpoint pt1 "\nPick 2nd Point of Line: "))
	(setq	ang1		(angle pt1 pt2))
	(mark pt1)
	(cnct pt1 pt2)
	(mark pt2)
	(setq dist 0)
	(setq	ptlst	(list pt1))
	(setq	ptlst	(cons pt2 ptlst))
	(while dist
		(setq	pt1		pt2)
		(setq	dist		(getreal "\nDistance to next point: "))
		(if dist
			(if (/= dist 0)
				(progn
					(cond
						((and (= (substr AppNam 1 5) "Adds ") (= inwhat "METERS"))
							(setq	dist		dist)
						)
						((and (= (substr AppNam 1 5) "Adds ") (= inwhat "FEET"))
							(setq	dist		(* dist 0.3048))
						)
						((and (= (substr AppNam 1 5) "Cadet") (= inwhat "METERS"))
							(setq	dist		(/ dist 0.3048))
						)
						((and (= (substr AppNam 1 5) "Cadet") (= inwhat "FEET"))
							(setq	dist		dist)
						)
					)
					(setq	ang2		(getint "\nAngle to next point (+ Left) (- Right): "))
					(if (/= ang2 nil)
						(progn
							(setq	ang2		(/ (* ang2 pi) 180.0))
							(setq	ang1		(+ ang1 ang2))
							(setq	pt2		(polar pt1 ang1 dist))
						)
						(progn
							(setq	ang2		(getangle pt1 "\nPick angle "))
							(setq	pt2		(polar pt1 ang2 dist))
						)
					)
					(setq	ptlst	(cons pt2 ptlst))
					(cnct pt1 pt2)
					(mark pt2)
				)
	               (if (> (length ptlst) 2)
					(progn
						(setq	lpt		(nth 0 ptlst))
						(Erx lpt)
						(setq	ptlst	(cdr ptlst))
						(setq	pt2		(nth 0 ptlst))
						(setq	ang1		(angle (nth 1 ptlst) (nth 0 ptlst)))
					)
					(princ "\nCANNOT BACK UP ANYMORE !!!\n ")
				)
			)
		)
	)
	(command	"_.LAYER" "m" lyr "")
	(princ)
)

(defun Erx ( pt /	x y x1 x2 y1 y2 )			; Called by DL
	(setq x (car pt))
	(setq y (cadr pt))
	(setq x1 (- x 0.1))
	(setq x2 (+ x 0.1))
	(setq y1 (- y 0.1))
	(setq y2 (+ y 0.1))
	(setq p1 (list x1 y1))
	(setq p2 (list x2 y2))
	(if (setq ss (ssget "C" p1 p2 (list (cons 8 "DEFPOINTS"))))
		(command "_.ERASE" ss "")
	)
)

(defun CnCt ( p1 p2 /	)					; Called by DL
	(command "pline" p1 "w" "0" "" p2 "")
)

(defun Mark ( pt /	sz )						; Called by DL
	(setq	sz	10.0)
	(command "point" pt)
	(command "pline" pt "w" "0" "" (polar pt (* pi 0.25) sz) "")
	(command "pline" pt "w" "0" "" (polar pt (* pi 0.75) sz) "")
	(command "pline" pt "w" "0" "" (polar pt (* pi 1.25) sz) "")
	(command "pline" pt "w" "0" "" (polar pt (* pi 1.75) sz) "")
)

(defun C:BdL ( /	lyr pt1 pt2 ang1 dist ang2 )	; Function draws a line at distance/bearing
	(setq	lyr		(getvar "CLAYER"))
	(command	"_.LAYER" "m" "DEFPOINTS" "")
	(setq	pt2		(getpoint "\nPick Starting Point: "))
	(mark pt2)
	(setq	dist		0)
	(setq	ptlst	(list pt2))
	(while dist
		(setq	pt1		pt2)
		(setq	dist		(getreal "\nDistance to next point: "))
		(if dist
			(if (/= dist 0)
				(progn
					(setq	ang2		(getint "\nBearing to next point: "))
					(setq	ang2		(- 0 ang2))
					(setq	ang2		(+ ang2 90))
					(setq	ang2		(/ (* ang2 pi) 180.0))
					(setq	pt2		(polar pt1 ang2 dist))
					(setq	ptlst	(cons pt2 ptlst))
					(cnct pt1 pt2)
					(mark pt2)
				)
				(if (> (length ptlst) 2)
					(progn
						(setq	lpt		(nth 0 ptlst))
						(Erx lpt)
						(setq	ptlst	(cdr ptlst))
						(setq	pt2		(nth 0 ptlst))
						(setq	ang1		(angle (nth 1 ptlst) (nth 0 ptlst)))
					)
					(princ "\nCANNOT BACK UP ANYMORE !!!\n ")
				)
			)
		)
	)
	(command	"_.LAYER" "m" lyr "")
	(princ)
)

(defun C:Tim ( /	act )					; Command line Timer function
	(setq act (getstring "What command to benchmark?"))
	(if act
		(timr act)
	)
	(princ)
)

(defun Timr ( act /	ints isecs outs 		; Timer function
					osecs elss )
	(if act
		(progn
			(setq ints (getvar "date"))
			(setq isecs (* 86400.0 (- ints (fix ints))))
			(command act)
			(setq outs (getvar "date"))
			(setq osecs (* 86400.0 (- outs (fix outs))))
			(setq elss (itoa (fix (- (* osecs 1000.0) (* isecs 1000.0)))))
			(princ (strcat "\nElapsed Milliseconds = " elss))
		)
	)
	(princ)
)

;;;	Purpose:		To change any existing text style Fonts to True Type fonts.
;;; Parameters:	Active Document Object
(defun C:ChgTxtStyles ( / actDoc TxtStylesCol TextStyle fontFile winDir )
	(setq actDoc		(vla-get-activedocument (vlax-get-acad-object))
		 TxtStylesCol 	(vla-get-TextStyles actDoc)
		 winDir       	(getenv "windir")
	)
	(vlax-for TextStyle TxtStylesCol 
		(setq 	fontFile  (vla-get-FontFile TextStyle))
		(if (> (strlen fontFile) 3)
			(if (= (strcase (substr fontFile (- (strlen fontFile) 3))) ".SHX")
				(setq	fontFile	(substr fontFile 1 (- (strlen fontFile) 4)))
			)
		)
		(cond
			((wcmatch (strcase fontFile) "COMPLEX")
				(setq file (findfile (strcat winDir "\\fonts\\ROMANTIC.TTF")))
				(vla-put-FontFile TextStyle file)
			)
			((wcmatch (strcase fontFile) "GOTHIC*")
				(setq file (findfile (strcat winDir "\\fonts\\ROMANTIC.TTF")))
				(vla-put-FontFile TextStyle file)
			)
			((wcmatch (strcase fontFile) "ITALIC*")
				(setq file (findfile (strcat winDir "\\fonts\\TAHOMA.TTF")))
				(vla-put-FontFile TextStyle file)
			)
			((or (wcmatch (strcase fontFile) "MONOSIMP") (wcmatch (strcase fontFile) "MONOTXT"))
				(setq file (findfile (strcat winDir "\\fonts\\ROMANTIC.TTF")))
				(vla-put-FontFile TextStyle file)
			)
			((wcmatch (strcase fontFile) "ROMAN[DS]")
				(setq file (findfile (strcat winDir "\\fonts\\ARIAL.TTF")))
				(vla-put-FontFile TextStyle file)
			)
			((wcmatch (strcase fontFile) "ROMAN[CT]")
				(setq file (findfile (strcat winDir "\\fonts\\ROMANTIC.TTF")))
				(vla-put-FontFile TextStyle file)
			)
			((wcmatch (strcase fontFile) "SCRIPT*")
				(setq file (findfile (strcat winDir "\\fonts\\VLADIMIR.TTF")))
				(vla-put-FontFile TextStyle file)
			)
			((wcmatch(strcase fontFile) "SIMPLEX")
				(setq file (findfile (strcat winDir "\\fonts\\TAHOMA.TTF")))
				(vla-put-FontFile TextStyle file)
			)
			((wcmatch(strcase fontFile) "TXT")
				(setq file (findfile (strcat winDir "\\fonts\\TAHOMA.TTF")))
				(vla-put-FontFile TextStyle file)
			)
		)
	)

	(if (and TextStyle (null (vlax-object-released-p TextStyle)))
		(vlax-release-object TextStyle)
	)
	(if (and TxtStylesCol (null (vlax-object-released-p TxtStylesCol)))
		(vlax-release-object TxtStylesCol)
	)
	(if (and actDoc (null (vlax-object-released-p actDoc)))
		(vlax-release-object actDoc)
	)
	(setq 	actDoc		nil
			TxtStylesCol	nil
			actDoc		nil
	)
	(gc)
	(princ)
)

(defun C:ChgTxtToCalibri (/ actDoc TxtStylesCol TextStyle winDir fontFile file)
	(setq actDoc		(vla-get-activedocument (vlax-get-acad-object))
		 TxtStylesCol 	(vla-get-TextStyles actDoc)
		 winDir       	(getenv "windir")
	)
	
	(vlax-for TextStyle TxtStylesCol 
		(setq 	fontFile  (vla-get-FontFile TextStyle))
		(setq file (findfile (strcat winDir "\\fonts\\CALIBRI.TTF")))
		(vla-put-FontFile TextStyle file)
	)
	(command "_.REGENALL")
	(princ)
)

(defun C:ChgTxtHeightToStd (/)
	(if (setq	 ss 	(ssget "X" '((0 . "MTEXT"))))
		(progn
			(setq	count	0
					new_ht	2.3
			)
			(repeat (sslength ss)
				(setq	ent	(ssname	ss count)
						cont	(entget	ent)
						cont	(subst	(cons 40 new_ht)	(assoc 40 cont)	cont)
				)
				(entmod	cont)
				(setq	count(+ 1 count))
			)
			(command "_.REGENALL")
		)
	)
	(princ)	
)


(defun ConVert2Poly ( plines	/	count ss Vcmd	; Supposed to Convert a Arcs & Lines to PLine
							Vfil )
	(setvar "PLINETYPE" 0)
	(setq	Vcmd		(getvar "CMDECHO")
			Vfil		(getvar "FILEDIA")
	)
	(if (> Vcmd 0)
		(setvar "CMDECHO" 0)
	)
	(if (> Vfil 0)
		(setvar "FILEDIA" 0)
	)
	(if plines
		(progn
			(setq ss (ssadd))
			(setq count 0)
			(while (< count (sslength plines))
				(if  
				 	(or	(equal (assoc 0 (entget (ssname plines count))) (list (cons 0 "ARC")))
				     	(equal (assoc 0 (entget (ssname plines count))) (list (cons 0 "LINE")))
				 	)
					(progn
						(command "_.pedit" (ssname plines count) "_yes" "_exit")
						(ssadd (entlast) ss)
					)
					(ssadd (ssname plines count) ss)
				)
				(setq count (1+ count))
			)
		)
		(princ "\nNo convertable objects passed to ConVerter!")
	)
	(setvar "CMDECHO" Vcmd)
	(setvar "FILEDIA" Vfil)
	count
)

(defun RepOutFil ( OutStr /	ONam Fnam DNam )	; Appends Str to ErrReport in Path-Panel
	(if (and _Path-DLG _Path-Panel)
		(setq	ONam		(strcat _Path-Panel "ErrReport.txt"))
		(setq	ONam		"ErrReport.txt")
	)
	(setq	FNam		(open ONam "a")
			DNam		(strcase (getvar "DWGNAME"))
	)
	(if (= DNam "DRAWING.DWG")
		(setq	DNam		"AddsFile")
		(if (> (strlen DNam) 4)
			(setq	DNam		(substr DNam 1 (- (strlen DNam) 4)))
		)
	)
	(if FNam
		(write-line (strcat DNam "\t" OutStr) FNam)
	)
	(if FNam
		(close FNam)
	)
)


(defun RevOPoly ( OPLst /	OP1 OP2 NPLst )	; Reverse an OPoly list correctly
	(setq	OP1		(nth 0 OPLst)
			OP2		(last OPLst)
			NPLst	(StpVrtLst OPLst T)
			NPLst	(append (list OP1) NPLst)
			NPLst	(append NPLst (list OP2))
	)
	(if (and Bug NLst)
		(BugRepOPoly NPLst)
	)
	NPLst
)

(defun BugRepOPoly ( NLst /	Cnt Fuzz LstLen	; Bug Reports on Old Polyline definitions
						ILst )
	(setq	Cnt		0
			Fuzz		0.01
			LstLen	(length NLst)
	)
	(princ "\nBugRepOPoly Says:\nNumber\t\t\tX,Y\t\tWidthA\tWidthB\tBulge\n==========================================================================")
	(foreach	ILst
			NLst
			(cond
				((= (cdr (assoc 0 ILst)) "POLYLINE")
					(princ	(strcat	"\nPolyLine on Layer "
									(cdr (assoc 8 ILst))
									", with "
									(itoa (- LstLen 2))
									" Vertices and"
									(if (assoc 39 ILst)
										" with Thickness of "
										" with no Thickness."
									)
									(if (assoc 39 ILst)
										(rtos (cdr (assoc 39 ILst)) 2 1)
									)
							)
					)
				)
				((= (cdr (assoc 0 ILst)) "VERTEX")
					(setq	Cnt		(1+ Cnt))
					(princ	(strcat	"\n"
									(itoa Cnt)
									"\t"
									(rtos (cadr (assoc 10 ILst)) 2 4)
									","
									(rtos (caddr (assoc 10 ILst)) 2 4)
									"\t"
									(rtos (cdr (assoc 40 ILst)) 2 4)
									"\t"
									(rtos (cdr (assoc 41 ILst)) 2 4)
									"\t"
									(if (equal (cdr (assoc 42 ILst)) 0.0 Fuzz)
										"Straight"
										(strcat (rtos (cdr (assoc 42 ILst)) 2 6) " Bulge")
									)
							)
					)
				)
			)
	)
	(princ "\n")
	(princ)
)

(defun Weeder ( PLst /	Wid GFlg Cnt			; Weeds out un-needed vertices in polylines, now with curves!
					Fuzz BadOne NLst TPnt ) ; MLst SLst BadLst 
	(if Bug (princ "\n{Weeder entered"))
	(if Bug (setq EdsLst PLst))
	(setq	NLst		(cdr (reverse PLst))	; Remove the Header & Seqend
			NLst		(cdr (reverse NLst))
			Wid		(cdr (assoc 41 (car NLst)))
			GFlg		T
			Cnt		0
			Fuzz		0.01
			BadLst	nil
			SLst		nil
			MLst		nil
	)
	(mapcar	(quote	(lambda (x)
						(if GFlg
							(if (not (equal Wid (cdr (assoc 41 x)) Fuzz))
								(setq	GFlg		nil)
							)
						)
						(if GFlg
							(if (not (equal Wid (cdr (assoc 40 x)) Fuzz))
								(setq	GFlg		nil)
							)
						)
						(if (and TPnt (> Cnt 0))
							(if LCrv
								(if MLst
									(setq	MLst		(cons (* -1.0 (angle TPnt (cdr (assoc 10 x)))) MLst))
									(setq	MLst		(list (* -1.0 (angle TPnt (cdr (assoc 10 x))))))
								)
								(if MLst
									(setq	MLst		(cons (angle TPnt (cdr (assoc 10 x))) MLst))
									(setq	MLst		(list (angle TPnt (cdr (assoc 10 x)))))
								)
							)
						)
						(if GFlg
							(if (not (equal 0.0 (cdr (assoc 42 x)) Fuzz))
								(setq	LCrv		T)
								(setq	LCrv		nil)
							)
						)
						(setq	TPnt		(cdr (assoc 10 x))
								Cnt		(1+ Cnt)
						)
					)
			)
			NLst
	)
	(if MLst (setq	MLst (reverse MLst)))
	(setq	Cnt		0)
	(if (and GFlg MLst)
		(repeat (1- (length MLst))
			(cond
				((equal (nth Cnt MLst) (abs (nth (1+ Cnt) MLst)) Fuzz)
					(if SLst
						(setq	SLst		(cons 1 SLst))
						(setq	SLst		(list 1))
					)
					(if Bug
						(princ (strcat "\n1=>" (rtos (nth Cnt MLst) 2 2) "=" (rtos (nth (1+ Cnt) MLst) 2 2)))
					)
				)
				((< (nth Cnt MLst) -0.001)
					(if SLst
						(setq	SLst		(cons 2 SLst))
						(setq	SLst		(list 2))
					)
					(if Bug
						(princ (strcat "\n2=>" (rtos (nth Cnt MLst) 2 2) "<0"))
					)
				)
				(T
					(if SLst
						(setq	SLst		(cons 0 SLst))
						(setq	SLst		(list 0))
					)
					(if Bug
						(princ (strcat "\n0=>" (rtos (nth Cnt MLst) 2 2) "<>" (rtos (nth (1+ Cnt) MLst) 2 2)))
					)
				)
			)
;;;			(if (> (nth Cnt MLst) -0.001)
;;;				(if (equal (nth Cnt MLst) (abs (nth (1+ Cnt) MLst)) Fuzz)
;;;					(if SLst
;;;						(setq	SLst		(cons 1 SLst))
;;;						(setq	SLst		(list 1))
;;;					)
;;;					(if SLst
;;;						(setq	SLst		(cons nil SLst))
;;;						(setq	SLst		(list nil))
;;;					)
;;;				)
;;;				(if SLst
;;;					(setq	SLst		(cons 2 SLst))
;;;					(setq	SLst		(list 2))
;;;				)
;;;			)
			(setq	Cnt		(1+ Cnt))
		)
	)
	(if SLst (setq	SLst (reverse SLst)))
	(setq	Cnt		0)
	(if (and Bug MLst SLst GFlg)
		(repeat (length NLst)
			(if (zerop Cnt) (princ "\nWeeder Says:\n============================"))
			(if (zerop Cnt)
				(princ	(strcat	"\n"
								(itoa (1+ Cnt))
								"\t"
								(rtos (cadr (assoc 10 (nth Cnt NLst))) 2 4)
								","
								(rtos (caddr (assoc 10 (nth Cnt NLst))) 2 4)
								"\t\n"
						)
				)
				(princ	(strcat	"\n"
								(itoa (1+ Cnt))
								"\t"
								(rtos (cadr (assoc 10 (nth Cnt NLst))) 2 4)
								","
								(rtos (caddr (assoc 10 (nth Cnt NLst))) 2 4)
								"\t"
								(PadCharL (rtos (nth (1- Cnt) MLst) 2 4) 8)
								"\n\t\t\t\t\t\t\t"
								(if (/= Cnt (1- (length NLst)))
									(if (equal (nth (1- Cnt) SLst) 1)
										"Straight"
										(if (equal (nth (1- Cnt) SLst) 2)
											"Curved"
											"Not Straight"
										)
									)
									"\n"
								)
						)
				)
			)
			(setq	Cnt		(1+ Cnt))
		)
	)
	(setq	Cnt		0)
	(if SLst
		(repeat (length SLst)
			(if (= (nth Cnt SLst) 1)
				(if BadLst
					(setq	BadLst	(cons (1+ Cnt) BadLst))
					(setq	BadLst	(list (1+ Cnt)))
				)
			)
			(setq	Cnt		(1+ Cnt))
		)
	)
	(if BadLst
		(foreach	BadOne
				BadLst
				(setq	NLst		(RemLst (nth BadOne NLst) NLst))
		)
	)
	(if Bug (princ "\nWeeder exited}"))
	(if GFlg
		(setq	NLst		(cons (last PLst) (reverse NLst))	; Return the Header & Seqend
				NLst		(cons (car PLst) (reverse NLst))
		)
		(setq	NLst		PLst)
	)
)

(defun Rd2Deg ( rad / )						; Converts a radian value into degrees
	(if rad
		(* (/ rad pi) 180.0)
		0.0
	)
)

(defun Deg2Rd ( deg / )						; Converts a degree value into radians
	(if deg
		(* (/ deg 180.0) pi)
		0.0
	)
)

(defun ViewPorter ( /	GetVPS CVP Cntr e1		; Returns info about current Mspace window in Pspace
					VPS_Hand PxWid PyWid PtCen EED MyWid MxWid MPtCen MPtLL MPtUR OutPutLst )
	(if (= (getvar "TILEMODE") 0)		; Layout Tab ~ 0
		(command "_.Mspace")		; Switches from paper space to a model space viewport
	)
	(setq	GetVPS	(ssget "X"	(list	(cons 0 "VIEWPORT")))
			CVP		(getvar "CVPORT")		;Displays the identification number of the current viewport.
			Cntr		0
	)
	(if GetVPS
		(while (/= (cdr (assoc 69 (setq e1 (entget (ssname GetVPS Cntr) (list "*"))))) CVP)	; 69 ~ Viewport ID 
			(setq	Cntr		(1+ Cntr))
		)
	)
	(if e1
		(setq	VPS_Hand	(cdr (assoc 5 e1))
				PxWid	(cdr (assoc 40 e1))			;Width in paper space units
				PyWid	(cdr (assoc 41 e1))			;Height in paper space units
				PtCen	(cdr (assoc 10 e1))			;Center point (in WCS)
				EED		(cdadr (assoc -3 e1))		;APP: extended data (XDATA) sentinel (fixed)
				MyWid	(cdr (nth 6 EED))
				MxWid	(/ (* PxWid MyWid) PyWid)
				MPtCen	(list	(cdr (nth 7 EED))
								(cdr (nth 8 EED))
								0.0
						)
				MPtLL	(list	(- (cdr (nth 7 EED)) (/ MxWid 2.0))
								(- (cdr (nth 8 EED)) (/ MyWid 2.0))
								0.0
						)
				MPtUR	(list	(+ (cdr (nth 7 EED)) (/ MxWid 2.0))
								(+ (cdr (nth 8 EED)) (/ MyWid 2.0))
								0.0
						)
				OutPutLst	(list	VPS_Hand	; Viewport Handle
								CVP		; Viewport Number
								PxWid	; Pspace Vport Width
								PyWid	; Pspace Vport Height
								PtCen	; Pspace Center Point
								MxWid	; Mspace Window Width
								MyWid	; Mspace Window Height
								MPtCen	; Mspace Window Center Point
								MPtLL	; Mspace Window Lower-Left Point
								MPtUR	; Mspace Window Upper-Right Point
						)
		)
	)
	(if (= (getvar "TILEMODE") 0)
		(command "_.Pspace")
	)
	OutPutLst
)

(defun EED_LstStr ( EED_Lst /	EED_Out		; Reformats the contents of EED groups to list of strings
							Grp EED_Grp )
	(if EED_Lst
		(setq	EED_Out	(list (caadr EED_Lst))	; Registered Application Name is first in list of values
				EED_Grp	(cdadr EED_Lst)
		)
		(setq	EED_Out	nil)
	)
	(if EED_Grp
		(foreach	Grp
				EED_Grp
				(cond
					; 1000 String
					; 1001 Application Name
					; 1002 Control String
					; 1003 Layer Name
					((member (car Grp) (list 1000 1001 1002 1003))
						(setq	EED_Out	(append EED_Out (list (cdr Grp))))
					)
					; 1005 Entity Handle
					((= 1005 (car Grp))
						(princ "\nEED Group contained entity handle!")
					)
					; 1010 3D Point
					; 1011 World Space Position
					; 1012 World Space Displacement
					; 1013 World Direction
					((member (car Grp) (list 1010 1011 1012 1013))
						(setq	EED_Out	(append EED_Out	(list	(strcat	(rtos (nth 0 (cdr Grp)) 2 4)
																","
																(rtos (nth 1 (cdr Grp)) 2 4)
																","
																(rtos (nth 2 (cdr Grp)) 2 4)
														)
												)
									)
						)
					)
					; 1040 A Real Value
					; 1041 Distance
					; 1042 Scale Factor
					; 1071 32-bit signed integer (long int) handled as Real Value
					((member (car Grp) (list 1040 1041 1042 1071))
						(setq	EED_Out	(append EED_Out	(list	(rtos (cdr Grp) 2 4))))
					)
					; 1070 16-bit integer (signed or unsigned)
					((= 1070 (car Grp))
						(setq	EED_Out	(append EED_Out	(list	(itoa (cdr Grp)))))
					)
				)
		)
	)
	EED_Out
)

(defun GetPLEnd ( Ent /	EntDat ENam EED_Lst		; Returns the ultimate endpoints of Plines
					Ptx Pty EEDat Cnt )
	(if Bug (princ "\n{GetPLEnd entered"))
	(setq	EntDat	(entget Ent (list "*"))
			EEDat	(assoc -3 EntDat)
	)
	(if EEDat
		(setq	EED_Lst	(EED_LstStr EEDat))
		(setq	EED_Lst	nil)
	)
	(cond ((= (cdr (assoc 0 EntDat)) "POLYLINE")
		  (setq	ENam		(entnext Ent)
				Ptx		(cdr (assoc 10 (entget ENam)))
		  )
		  (while (/= (cdr (assoc 0 (entget ENam))) "SEQEND")
			  (setq Pty (cdr (assoc 10 (entget ENam)))
				   ENam  (entnext ENam)
			  )
		  )
		 )
		 ((= (cdr (assoc 0 EntDat)) "LWPOLYLINE")
		  (setq Cnt 0)
		  (repeat	(length EntDat)
			  (if (= (car (nth Cnt EntDat)) 10)
				  (progn
					  (if (null Ptx)
						  (setq Ptx (cdr (nth Cnt EntDat)))
					  )
					  (setq Pty (cdr (nth Cnt EntDat)))
				  )
			  )
			  (setq Cnt (1+ Cnt))
		  )
		 )
	)
	(if Bug (princ "\nGetPLEnd exited}\n"))
	(list Ptx Pty EED_Lst)
)

(defun TransCord ( Sys1 Sys2 Pt1 /	Chk1		; Transforms Points from Coord System 1->2
								Chk2 Res1 )
	(setq	Chk1		(ade_projsetsrc Sys1)	; Adds is in UTM27-16
			Chk2		(ade_projsetdest Sys2)	; Segis is in UTM83-16F
	)									; Honda plant is in AL83-EF
	(if (and Chk1 Chk2 Pt1)
		(setq	Res1		(ade_projptforward Pt1))
	)
	Res1
)

(defun C:LLUTM ( /	PtX PtY Loc1 BlpWas )		; Converts points from Lat-Long 83 to UTM27-16 (Adds)
	(setq	PtX		(getreal "\nEnter the Longtitude (West is negative): ")
			PtY		(getreal "\nEnter the Latitude (North is positive): ")
			BlpWas	(getvar "BLIPMODE")
	)
	(if (and PtX PtY)
		(setq	Loc1		(TransCord "LL83" "UTM27-16" (list PtX PtY)))
	)
	(if Loc1
		(if (= (type Loc1) (quote LIST))
			(progn
				(if (= BlpWas 0)
					(setvar "BLIPMODE" 1)
				)
				(princ (strcat "\nPoint is X: " (rtos (car Loc1) 2 4) " Y: " (rtos (cadr Loc1) 2 4)))
				(command "_.Zoom" "C" Loc1 "1500")
				(command "ID" Loc1)
			)
		)
	)
	(setvar "BLIPMODE" BlpWas)
	(princ)
)

(defun C:LL83 ( /	Pt1 NthD NthM NthS			; Converts points from UTM27-16 (Adds) to Lat-Long 83
				NthStr WstD WstM WstS WstStr );  Loc1
	(setq	Pt1		(getpoint "\nSelect Point to convert: "))
	(if Pt1
		(setq	Loc1		(TransCord "UTM27-16" "LL83" Pt1))
	)
	(if Loc1
		(setq	NthD		(nth 1 Loc1)
				NthDir	(if (>= NthD 0.0) "N" "S")
				NthD		(if (< NthD 0.0) (* -1.0 NthD) NthD)
				NthM		(- NthD (fix NthD))
				NthD		(fix (- NthD NthM))
				NthM		(* 60.0 NthM)
				NthS		(- NthM (fix NthM))
				NthM		(fix (- NthM NthS))
				NthS		(* 60.0 NthS)
				NthStr	(strcat	NthDir
								(itoa NthD)
								"%%d "
								(itoa NthM)
								"\047 "
								(rtos NthS 2 2)
								"\042"
						)
				WstD		(nth 0 Loc1)
				WstDir	(if (>= WstD 0.0) "E" "W")
				WstD		(if (< WstD 0.0) (* -1.0 WstD) WstD)
				WstM		(- WstD (fix WstD))
				WstD		(fix (- WstD WstM))
				WstM		(* 60.0 WstM)
				WstS		(- WstM (fix WstM))
				WstM		(fix (- WstM WstS))
				WstS		(* 60.0 WstS)
				WstStr	(strcat	WstDir
								(itoa WstD)
								"%%d "
								(itoa WstM)
								"\047 "
								(rtos WstS 2 2)
								"\042"
						)
		)
	)
	(if (and NthStr WstStr)
		(princ	(strcat	"\nUTM27-16 State Plane Meters Pt:"
						(rtos (nth 0 Pt1) 2 4)
						", "
						(rtos (nth 1 Pt1) 2 4)
						"\n"
						"is located at (Lat-Long 83:) " WstStr ", " NthStr
						"\n or " (rtos (car Loc1) 2 6) ", " (rtos (cadr Loc1) 2 6)
				)
		)
	)
	(princ)
)

(defun StpSpac ( InStr /	OutStr StLen		; Utility to strip leading & trailing spaces
						Fnd1 Fnd2 Cnt )
;;;	(setq	StLen	(strlen InStr)
;;;			Fnd1		nil
;;;			Fnd2		nil
;;;			Cnt		1
;;;			OutStr	nil
;;;	)
;;;	(if (and Bug InStr)
;;;		(princ (strcat "\nInStr:{" InStr "}"))
;;;	)
;;;	(if (= (substr InStr 1 1) (chr 32))
;;;		(while (and (< Cnt StLen) (not Fnd1))
;;;			(if (/= (substr InStr Cnt 1) (chr 32))
;;;				(setq	Fnd1		Cnt)
;;;			)
;;;			(setq	Cnt	(1+ Cnt))
;;;		)
;;;	)
;;;	(if (and Bug Fnd1)
;;;		(princ (strcat "\nFound1:" (itoa Fnd1)))
;;;	)
;;;	(setq	Cnt		(1- StLen))
;;;	(if (= (substr InStr StLen 1) (chr 32))
;;;		(while (and (> Cnt 1) (not Fnd2))
;;;			(if (/= (substr InStr Cnt 1) (chr 32))
;;;				(setq	Fnd2		Cnt)
;;;			)
;;;			(setq	Cnt	(1- Cnt))
;;;		)
;;;	)
;;;	(if (and Bug Fnd2)
;;;		(princ (strcat "\nFound2:" (itoa Fnd2)))
;;;	)
;;;	(cond
;;;		((and Fnd1 Fnd2)
;;;			(setq	OutStr	(substr InStr Fnd1 (- (1+ Fnd2) Fnd1)))
;;;		)
;;;		(Fnd1
;;;			(setq	OutStr	(substr InStr Fnd1))
;;;		)
;;;		(Fnd2
;;;			(setq	OutStr	(substr InStr 1 Fnd2))
;;;		)
;;;		(T
;;;			(setq	OutStr	"")
;;;		)
;;;	)
	(setq	OutStr	(LTrim InStr))
	(setq	OutStr	(RTrim OutStr))
	OutStr
)

(defun LTrim ( string /	n)					; Returns string minus leading spaces
; Returns variable passed after trimming off any leading spaces--
; Example call: (setq s (ltrim s))
; Example results: before s="  RALSTON"  & after s="RALSTON"
	(if (> (strlen string) 0)
		(if (and (> (strlen string) 1) (= (substr string 1 1) " "))
			(while (and (> (strlen string) 1) (= (substr string 1 1) " "))
				(setq	string	(substr string 2))
			)
			(if (and (= (strlen string) 1) (= (substr string 1 1) " "))
				(setq	string	"")
				(setq	string	string)
			)
		)
		(setq	string	"")
	)
	(if (and (= (strlen string) 1) (= (substr string 1 1) " "))
		(setq	string	"")
		(setq	string	string)
	)
	string
)

(defun RTrim ( StrIn /	n )					; Returns variable passed after trimming off any trailing spaces
	(setq	n	(strlen StrIn))
	(while	(and	(> n 0)
				(= (substr StrIn n 1) " ")
			)
		(setq	n	(1- n))
	)
	(if (> n 0)
		(substr StrIn 1 n)
		StrIn
	)
)

(defun Parse_Str2Lst ( s /	n tmp strC )		; Returns List from space delimited string
; funct. subsets a string, that is space delimited, into a list.
	(setq	n	1)
	(setq	tmp	"")
	(repeat (strlen s)
		(if (= (setq strC (substr s n 1)) " ")
			(setq	tmp	(strcat tmp "\042 \042"))
			(setq	tmp	(strcat tmp strC))
		)
		(setq n (1+ n))
	)
	(read (strcat "(\042" tmp "\042)"))
)

(defun StatTxt ( InStr / )					; Defines status line for Application
	(if (= (type InStr) (quote STR))
		(setvar	"MODEMACRO"	InStr)
	)
	(princ)
)

(defun NextPt ( x y d ang /	dx dy nextx nexty	; return the next calculated point
						npt )
;	(if Bug (princ "\n{NextPt entered\n"))
	(setq	dx		(* d (cos ang))	 
			dy		(* d (sin ang))
			nextx	(+ x dx)
			nexty	(+ y dy)
 			npt		(list nextx nexty)
	)
;	(if Bug (princ "\nNextPt exited}\n"))
	npt
)

(defun SubFence ( xpt ypt angr fud /	pta ptb	; used to return a points 
								npt ptc )	; drop back away from x and y pts
;	(if Bug (princ "\n{SubFence entered\n"))
	(setq	npt	(NextPt xpt ypt (* -5.0 fud) angr)
			pta	(NextPt (car npt) (cadr npt) (* 54.0 fud) angr)
			ptb	(NextPt (car pta) (cadr pta) (* fud -61.0) (+ angr (/ pi 6)))
			ptc	(NextPt (car pta) (cadr pta) (* fud -61.0) (- angr (/ pi 6)))
	)
	(if (and pta ptb ptc)
		(progn
			(grdraw pta ptb -1 1)
			(grdraw ptb ptc -1 1)
			(grdraw ptc pta -1 1)
		)
	)
;	(if Bug (princ "\nSubFence exited}\n"))
	(list pta ptb ptc pta)
)

(defun GetLayLst ( Ptrn /	LayDat LayLst )	; Returns list of layers matching `Ptrn'
	(if Bug (princ "\n{GetLayLst entered\n"))
	(setq	LayDat	(tblnext "LAYER" T)
			LayLst	nil
	)
	(while LayDat
		(if (wcmatch (cdr (assoc 2 LayDat)) Ptrn)
			(if LayLst
				(setq	LayLst	(cons (cdr (assoc 2 LayDat)) LayLst))
				(setq	LayLst	(list (cdr (assoc 2 LayDat))))
			)
		)
		(setq	LayDat	(tblnext "LAYER"))
	)
	(if Bug (princ "\nGetLayLst exited}\n"))
	LayLst
)

(defun SubMakLay ( /	SubSet Cntr SubLen el	; Interactive tool for manual cleanup of layer phasing
					xpt ypt lay angr fud ss2 c i kv flag ent entl
					Nam ENamLst code OldMode ) ; LayLstA LayLstB LayLstC
	(if Bug (princ "\n{SubMakLay entered\n"))
	(setq	SubSet	(ssget "X"	(list	(cons 0 "INSERT")
										(cons -4 "<OR")
											(cons 2 "SUB")
											(cons 2 "SUB2")
;;;											(cons 2 "SUBCUST")
											(cons 2 "A074")		;	Substation, Solid
											(cons 2 "A075")		;	Substation, Unit
;;;											(cons 2 "A076")		;	Substation, Customer
										(cons -4 "OR>")
										(cons 8 "--*")
								)
					)
			OldMode	(getvar "MODEMACRO")
	)
	(if SubSet
		(setq	Cntr		0
				Bubba	(RWav 14)
				SubLen	(sslength SubSet)
				Bubba	(command "_.UNDO" "_BEGIN")
				Bubba	(command "_.View" "S" "SubDef")
		)
	)
	(setq	LayLstA	(GetLayLst "????SB????"))
	(if SubLen (command "_.-Layer" "T" "*" "ON" "*" "U" "*" "S" "----SB----" "F" "*" "T" "--*,????CK????,????FL????,??????[BTD]???" "" "_.Zoom" "E"))
	(if SubLen (princ (strcat "\nSubLen has " (itoa SubLen) " items.")))
	(if SubSet
		(while (< Cntr SubLen)
			(setq	el		(entget (ssname SubSet Cntr))			;entity data
					blk		(cdr (assoc 2 el))					;blkname
					xpt		(rtos (cadr (assoc 10 el)) 2 0)		;insert of block-x
					ypt		(rtos (caddr (assoc 10 el)) 2 0)		;insert of block-y
					lay		(cdr (assoc 8 el))					;layer of block
					angr		(if (> (* (cdr (assoc 41 el)) (cdr (assoc 42 el))) 0.0001)
								(+ (cdr (assoc 50 el)) pi)		;rotation angle in radians + 180
								(+ (cdr (assoc 50 el)) (* pi 2.0))	;rotation angle in radians + 360
							)
					fud		(* (/ (cdr (assoc 42 el)) 38.1)  1.25)	;a fudge factor based on scale of symbol
			)
			(if ENamLst
				(setq	ENamLst	(cons (ssname SubSet Cntr) ENamLst))
				(setq	ENamLst	(list (ssname SubSet Cntr)))
			)
			(command "_.Zoom" "C" (cdr (assoc 10 el)) (* 12.5 (abs (cdr (assoc 41 el)))))
			(setq	ss2		(ssget "f"	(subfence	(atoi xpt)	;select based on a fence around sub block
												(atoi ypt)
												angr
												fud
										)
										(list	(cons 0 "*POLYLINE")
												(cons 8 "????[CF][KL]????")
										)
							)
					c		0
					i		0
					kv		35
					poss		nil
					flag		nil
			)
			(if ss2
				(while (setq ent (ssname ss2 c))						;loop till it runs out of entities
					(setq	entl		(entget ent))
					(if (= i 0)
						(setq	kv	(atoi (substr (cdr (assoc 8 entl)) 9 2))	; get the voltage of first circuit
								code	(substr (cdr (assoc 8 entl)) 1 2)			; get the sub code from the circuit
								poss	(list code)
								flag	T
						)
						(if (< (atoi (substr (cdr (assoc 8 entl)) 9 2)) kv)		; we want the sub code of the smallest voltage
							(setq	code	(substr (cdr (assoc 8 entl)) 1 2)		; get the sub code from the circuit
									flag	T
							)
						)
					)
					(if (not (member code poss))
						(setq	poss		(cons code poss))
					)
					(setq	i	(1+ i)
							c	(1+ c)
					)
				)
			)
			(if (and Cntr lay)
				(if (> (length poss) 1)
					(StatTxt (strcat "Item:{" (itoa (1+ Cntr)) "} Layer:{" lay "} Poss:{" (itoa (length poss)) "}"))
					(StatTxt (strcat "Item:{" (itoa (1+ Cntr)) "} Layer:{" lay "}"))
				)
			)
			(if (and ss2)
				(cond
					((= (length poss) 1)
						(setq	BugInp	"Yes")
					)
					((= (length poss) 2)
						(RWav 15)
						(initget 1 "Yes No 1 2")
						(setq	BugInp	(getkword (strcat "\nChoices (1:" (Mem_Sb_S (nth 0 poss)) "[" (Mem_Sb_C (nth 0 poss)) "],2:" (Mem_Sb_S (nth 1 poss)) "[" (Mem_Sb_C (nth 1 poss)) "]):")))
					)
					((= (length poss) 3)
						(RWav 17)
						(initget 1 "Yes No 1 2 3")
						(setq	BugInp	(getkword (strcat "\nChoices (1:" (Mem_Sb_S (nth 0 poss)) "[" (Mem_Sb_C (nth 0 poss)) "],2:" (Mem_Sb_S (nth 1 poss)) "[" (Mem_Sb_C (nth 1 poss)) "],3:" (Mem_Sb_S (nth 2 poss)) "[" (Mem_Sb_C (nth 2 poss)) "]):")))
					)
					((= (length poss) 4)
						(RWav 18)
						(initget 1 "Yes No 1 2 3 4")
						(setq	BugInp	(getkword (strcat "\nChoices (1:" (Mem_Sb_S (nth 0 poss)) "[" (Mem_Sb_C (nth 0 poss)) "],2:" (Mem_Sb_S (nth 1 poss)) "[" (Mem_Sb_C (nth 1 poss)) "],3:" (Mem_Sb_S (nth 2 poss)) "[" (Mem_Sb_C (nth 2 poss)) "],4:" (Mem_Sb_S (nth 3 poss)) "[" (Mem_Sb_C (nth 3 poss)) "]):")))
					)
					(T
						(initget 1 "Yes No 1 2")
						(setq	BugInp	(getkword (strcat "\nChoices (1:" (Mem_Sb_S (nth 0 poss)) "[" (Mem_Sb_C (nth 0 poss)) "],2:" (Mem_Sb_S (nth 1 poss)) "[" (Mem_Sb_C (nth 1 poss)) "]):")))
					)
				)
			)
			
			(cond
				((= BugInp "Yes")
					(setq	lay		(strcat code "--SB----")
							el		(subst	(cons 8 lay)
											(assoc 8 el)
											el
									)
							Bubba	(entmod el)
							Bubba	(entupd (ssname SubSet Cntr))
					)
					(if (and flag Bug) (princ (strcat "\n[Bug=" (itoa (1+ Cntr)) "] Old Lay:{" lay "} New Lay:{" code "--SB----}")))
				)
				((= BugInp "1")
					(if Bug (princ (strcat "\n[Bug=" (itoa (1+ Cntr)) "] Choice<" BugInp "> Old Lay:{" lay "} New Lay:{" (nth (1- (atoi BugInp)) poss) "--SB----}")))
					(setq	lay		(strcat (nth (1- (atoi BugInp)) poss) "--SB----")
							el		(subst	(cons 8 lay)
											(assoc 8 el)
											el
									)
							Bubba	(entmod el)
							Bubba	(entupd (ssname SubSet Cntr))
					)
				)
				((= BugInp "2")
					(if Bug (princ (strcat "\n[Bug=" (itoa (1+ Cntr)) "] Choice<" BugInp "> Old Lay:{" lay "} New Lay:{" (nth (1- (atoi BugInp)) poss) "--SB----}")))
					(setq	lay		(strcat (nth (1- (atoi BugInp)) poss) "--SB----")
							el		(subst	(cons 8 lay)
											(assoc 8 el)
											el
									)
							Bubba	(entmod el)
							Bubba	(entupd (ssname SubSet Cntr))
					)
				)
				((= BugInp "3")
					(if Bug (princ (strcat "\n[Bug=" (itoa (1+ Cntr)) "] Choice<" BugInp "> Old Lay:{" lay "} New Lay:{" (nth (1- (atoi BugInp)) poss) "--SB----}")))
					(setq	lay		(strcat (nth (1- (atoi BugInp)) poss) "--SB----")
							el		(subst	(cons 8 lay)
											(assoc 8 el)
											el
									)
							Bubba	(entmod el)
							Bubba	(entupd (ssname SubSet Cntr))
					)
				)
				((= BugInp "4")
					(if Bug (princ (strcat "\n[Bug=" (itoa (1+ Cntr)) "] Choice<" BugInp "> Old Lay:{" lay "} New Lay:{" (nth (1- (atoi BugInp)) poss) "--SB----}")))
					(setq	lay		(strcat (nth (1- (atoi BugInp)) poss) "--SB----")
							el		(subst	(cons 8 lay)
											(assoc 8 el)
											el
									)
							Bubba	(entmod el)
							Bubba	(entupd (ssname SubSet Cntr))
					)
				)
			)
			(setq	Cntr		(1+ Cntr))
		)
	)
	(setq	LayLstB	(GetLayLst "????SB????")
			LayLstC	(GetLayLst "????SB??[~-][~-]")
	)
	(if ENamLst
		(foreach	Nam
				ENamLst
				(LayUpdObj Nam nil)
		)
	)
	(if SubSet
		(setq	Bubba	(setvar "MODEMACRO" OldMode)
				Bubba	(command "_.View" "R" "SubDef")
				Bubba	(command "_.View" "D" "SubDef")
				Bubba	(command "_.UNDO" "_END")
				Bubba	(command "_.-Layer" "T" "*" "ON" "*" "U" "*" "S" "0" "")
		)
	)
	(if Bug (princ "\nSubMakLay exited}\n"))
)

(defun AddsUpAnalyze ( Tdata Panel InTim /	Cnt	; Analyze the Panel SelSet for AddsPlot
									MaxRec ints isecs outs osecs elss Bubba BobDat
									; SwDataLst CPDataLst BkDataLst SubLst
									ZeroLen ZeroLenCkt ZeroThk ZeroThkCkt AvgThk AvgThkLst SubBadLay
									EntNam EntLst EntLay EntTyp EntPt
									AttPair AttPairLst SwData CPData BkData
									EntFolNam EntFolLst SubNod SubNam VrtLst PLenth PWhere
									AddsUpNam AddsUpFil MyScl PanRepStr )
	(if Bug
		(princ "\n{AddsUpAnalyze entered\n")
		(setq	Bug	nil)
	)
	(setq	Cnt			0
			MaxRec		(sslength Tdata)
			ints			(getvar "date")
			isecs		(* 86400.0 (- ints (fix ints)))
			SwDataLst		nil
			CPDataLst		nil
			BkDataLst		nil
			SubLst		nil
			ZeroLen		nil
			ZeroLenCkt	nil
			ZeroThk		nil
			ZeroThkCkt	nil
			AvgThk		nil
			AvgThkLst		nil
			SubBadLay		nil
			EntTypLst		nil
	)
	(princ (strcat "\nAnalyzing Panel for Adds_Up with {" (itoa MaxRec) "} records: " ))
	(repeat MaxRec	;(1- MaxRec)
		(if (not Bug) (Twaddle Cnt MaxRec) (princ (strcat "\n[Bug] Working Record:{" (itoa Cnt) "}")))
		(setq	EntNam		(ssname Tdata Cnt)
				EntLst		(entget EntNam (list "*"))
				EntLay		(cdr (assoc 8 EntLst))
				EntTyp		(cdr (assoc 0 EntLst))
				EntPt		(cdr (assoc 10 EntLst))
				AttPair		nil
				AttPairLst	nil
				SwData		nil
				CPData		nil
				BkData		nil
				EntFolNam		nil
				EntFolLst		nil
				SubNod		nil
				SubNam		nil
				VrtLst		nil
				PLenth		nil
				PWhere		nil
		)
		(if EntTypLst
			(if (not (member EntTyp EntTypLst))
				(setq	EntTypLst		(cons EntTyp EntTypLst))
			)
			(setq	EntTypLst		(list EntTyp))
		)
		(cond
			((= EntTyp "INSERT")						;All Inserted Blocks
				(if (setq EntFolNam (entnext EntNam))
					(progn
						(setq	EntFolLst	(entget EntFolNam))
						(if (= (cdr (assoc 0 EntFolLst)) "ATTRIB")
							(while (= (cdr (assoc 0 EntFolLst)) "ATTRIB")
								(if (and (assoc 1 EntFolLst) (assoc 2 EntFolLst))
									(setq	AttPair	(cons (cdr (assoc 2 EntFolLst)) (cdr (assoc 1 EntFolLst)))
											Bubba	(if Bug (princ (strcat "\nBugRec{" (itoa Cnt) "} Att:[" (cdr (assoc 2 EntFolLst)) "] Val:[" (cdr (assoc 1 EntFolLst)) "]")))
									)
									(setq	AttPair	nil)
								)
								(if AttPair
									(if AttPairLst
										(setq	AttPairLst	(cons AttPair AttPairLst))
										(setq	AttPairLst	(list AttPair))
									)
								)
								(setq	EntFolNam	(entnext EntFolNam))
								(if EntFolNam
									(setq	EntFolLst	(entget EntFolNam))
									(setq	EntFolLst	nil)
								)
							)
						)
						(if AttPairLst					;Attribute list of any block
							(setq	AttPairLst	(reverse AttPairLst)
									SwData		nil
							)
						)
					)
					(setq	SwData	nil)
				)
				(if (or (wcmatch EntLay "????CK-*") (wcmatch EntLay "????SW-*"))	;Analyzing Switch Blocks
					(if AttPairLst
						(foreach	AttPair
								AttPairLst
								(if (StpDot (cdr AttPair))
									(if (and (not SwData) (member (car AttPair) (list "SWITCH" "RISER" "OCR" "_OCR" "_OCR_BP" "_OCR_EL" "SW1" "SW2" "BYPASS" "NUMBER" "LOAD" "SOURCE" "#SECT" "SECT#" "LOC_NUM" "SW_S" "SW_L" "SW_B")))
										(setq	SwData	(list	(cdr AttPair)
																(rtos (car EntPt) 2 0)
																(rtos (cadr EntPt) 2 0)
																(substr EntLay 1 3)
														)
												Bubba	(if Bug (princ (strcat "\n[SW] Cnt:{" (itoa Cnt) "} Att:{" (nth 0 SwData) "} X:{" (nth 1 SwData) "} Y:{" (nth 2 SwData) "} Fdr:{" (nth 3 SwData) "}")))
										)
									)
								)
								(if SwData
									(if SwDataLst
										(setq	SwDataLst	(cons SwData SwDataLst)
												SwData	nil
										)
										(setq	SwDataLst	(list SwData)
												SwData	nil
										)
									)
								)
						)
					)
				)
				(if (member (cdr (assoc 2 EntLst)) (list "A074" "A075" "SUB2" "SUB" "CP"))		;Analyzing CP's and Subs
					(progn
						(setq	CPData	(list	(cdr (assoc 2 EntLst))
												(rtos (car EntPt) 2 0)
												(rtos (cadr EntPt) 2 0)
												(substr EntLay 1 12)
												Panel
										)
						)
						(if (member (cdr (assoc 2 EntLst)) (list "SUB2" "SUB" "A074" "A075"))
							(if (equal (substr EntLay 1 2) "--")
								(if SubBadLay
									(setq	SubBadLay		(1+ SubBadLay))
									(setq	SubBadLay		1)
								)
							)
						)
						(if AttPairLst
							(foreach	AttPair
									AttPairLst
									(setq	CPData	(append CPData (list (cdr AttPair))))
							)
						)
						(if CPDataLst
							(setq	CPDataLst	(cons CPData CPDataLst))
							(setq	CPDataLst	(list CPData))
						)
					)
				)
				(if (/= (cdr (assoc 2 EntLst)) "CP")					;Analyzing anything but CP's
					(progn
						(setq	BkData	(list	(cdr (assoc 2 EntLst))
												(rtos (car EntPt) 2 0)
												(rtos (cadr EntPt) 2 0)
												(substr EntLay 1 12)
												Panel
										)
						)
						(if AttPairLst
							(foreach	AttPair
									AttPairLst
									(setq	BkData	(append BkData (list (cdr AttPair))))
							)
						)
						(if BkDataLst
							(setq	BkDataLst	(cons BkData BkDataLst))
							(setq	BkDataLst	(list BkData))
						)
					)
				)
			)
			((wcmatch EntTyp "*POLYLINE")			;All Polylines
				(cond						;Analyzing Circuit Polylines
					((wcmatch EntLay "????CK-*,????FL-*")
						(setq	SubNam	(substr EntLay 1 3)
								BobDat	(if (= EntTyp "POLYLINE")
											(PLDistL EntNam)
											(LWDistL EntNam)
										)
								PLenth	(car BobDat)
								PWhere	(cdr BobDat)
								SubNod	(cons SubNam PWhere)
								SubNod	(cond
											((and (= (strcase (substr EntLay 4 1)) "O") (= (substr EntLay 8 1) "0"))
												(append SubNod (list 0.0 0.0 PLenth 0.0 0.0 0.0 0.0))
											)
											((and (= (strcase (substr EntLay 4 1)) "O") (member (substr EntLay 8 1) (list "1" "2" "3")))
												(append SubNod (list 0.0 PLenth 0.0 0.0 0.0 0.0 0.0))
											)
											((and (= (strcase (substr EntLay 4 1)) "O") (member (substr EntLay 8 1) (list "4" "5" "6")))
												(append SubNod (list PLenth 0.0 0.0 0.0 0.0 0.0 0.0))
											)
											((and (= (strcase (substr EntLay 4 1)) "U") (= (substr EntLay 8 1) "0"))
												(append SubNod (list 0.0 0.0 0.0 0.0 0.0 PLenth 0.0))
											)
											((and (= (strcase (substr EntLay 4 1)) "U") (member (substr EntLay 8 1) (list "1" "2" "3")))
												(append SubNod (list 0.0 0.0 0.0 0.0 PLenth 0.0 0.0))
											)
											((and (= (strcase (substr EntLay 4 1)) "U") (member (substr EntLay 8 1) (list "4" "5" "6")))
												(append SubNod (list 0.0 0.0 0.0 PLenth 0.0 0.0 0.0))
											)
											(T
												(append SubNod (list 0.0 0.0 0.0 0.0 0.0 0.0 PLenth))
											)
										)
						)
						(if SubLst
							(if (assoc SubNam SubLst)
								(setq	SubLst	(subst	(AddsUpMerge SubNod (assoc SubNam SubLst))
														(assoc SubNam SubLst)
														SubLst
												)
								)
								(setq	SubLst	(cons SubNod SubLst))
							)
							(setq	SubLst	(list SubNod))
						)
					)
					(T						;Analyzing all other polylines
					)
				)
			)
		)
		(setq	Cnt	(1+ Cnt))
	)
	(if (not Bug) (Twaddle (- 0 Cnt) MaxRec))
	(if (or CPDataLst BkDataLst SwDataLst SubLst (>= MaxRec 1))
		(if (findfile (strcat _Path-Panel Panel ".dwg"))
			(setq	AddsUpNam	(strcat _Path-Panel "Data\\" Panel ".dat"))
			(if (findfile (strcat _Alt_Path-Panel Panel ".dwg"))
				(setq	AddsUpNam	(strcat _Alt_Path-Panel "Data\\" Panel ".dat"))
				(setq	AddsUpNam	nil)
			)
		)
	)
	(if AddsUpNam
		(setq	AddsUpFil	(open AddsUpNam "w"))
	)
	(if AddsUpFil
		(progn
			(if (member Panel PanLst)
				(setq MyScl (cadr (member Panel sclist)))
			)
			(if (not MyScl)
				(setq	MyScl	"NoSc")
			)
			(if CPDataLst
				(foreach	CPData
						CPDataLst
						(write-line	(strcat	(PadCharR "[CP]" 10)		;Code Identifier
											(PadCharR (nth 0 CPData) 10)	;Blk Name
											(PadCharR (nth 1 CPData) 10)	;X Value
											(PadCharR (nth 2 CPData) 10)	;Y Value
											(PadCharR (nth 3 CPData) 12)	;Layer Name
											(if (nth 4 CPData) (PadCharR (nth 4 CPData) 20) (RepChar "" 20))
											(if (nth 5 CPData) (PadCharR (nth 5 CPData) 20) (RepChar "" 20))
											(if (nth 6 CPData) (PadCharR (nth 6 CPData) 20) (RepChar "" 20))
											(if (nth 7 CPData) (PadCharR (nth 7 CPData) 10) (RepChar "" 10))
											(if (nth 8 CPData) (PadCharR (nth 8 CPData) 10) (RepChar "" 10))
											(if (nth 9 CPData) (PadCharR (nth 9 CPData) 10) (RepChar "" 10))
									)
									AddsUpFil
						)
				)
			)
			(if BkDataLst
				(foreach	BkData
						BkDataLst
						(write-line	(strcat	(PadCharR "[BLK]" 10)		;Code Identifier
											(PadCharR (nth 0 BkData) 10)	;Blk Name
											(PadCharR (nth 1 BkData) 10)	;X Value
											(PadCharR (nth 2 BkData) 10)	;Y Value
											(PadCharR (nth 3 BkData) 12)	;Layer Name
											(if (nth 4 BkData) (PadCharR (nth 4 BkData) 20) (RepChar "" 20))
											(if (nth 5 BkData) (PadCharR (nth 5 BkData) 20) (RepChar "" 20))
											(if (nth 6 BkData) (PadCharR (nth 6 BkData) 20) (RepChar "" 20))
											(if (nth 7 BkData) (PadCharR (nth 7 BkData) 10) (RepChar "" 20))
											(if (nth 8 BkData) (PadCharR (nth 8 BkData) 10) (RepChar "" 20))
											(if (nth 9 BkData) (PadCharR (nth 9 BkData) 10) (RepChar "" 20))
									)
									AddsUpFil
						)
				)
			)
			(if SwDataLst
				(foreach	SwData
						SwDataLst
						(write-line	(strcat	(PadCharR "[SW]" 10)		;Code Identifier
											(PadCharR (nth 0 SwData) 10)	;Blk Name
											(PadCharR (nth 1 SwData) 10)	;X Value
											(PadCharR (nth 2 SwData) 10)	;Y Value
											(PadCharR (nth 3 SwData) 3)	;Feeder Name
									)
									AddsUpFil
						)
				)
			)
			(if SubLst
				(foreach	SubNod
						SubLst
						(write-line	(strcat	(PadCharR "[SUB]" 10)					;Code Identifier
											(PadCharR (nth 0 SubNod) 10)				;Feeder Name
											(PadCharR (rtos (nth 1 SubNod) 2 0) 10)		;MinX Value
											(PadCharR (rtos (nth 2 SubNod) 2 0) 10)		;MinY Value
											(PadCharR (rtos (nth 3 SubNod) 2 0) 10)		;MaxX Value
											(PadCharR (rtos (nth 4 SubNod) 2 0) 10)		;MaxY Value
											(PadCharR (rtos (nth 5 SubNod) 2 2) 12)		;Feeder Length Overhead 3 Phase
											(PadCharR (rtos (nth 6 SubNod) 2 2) 12)		;Feeder Length Overhead 2 Phase
											(PadCharR (rtos (nth 7 SubNod) 2 2) 12)		;Feeder Length Overhead 1 Phase
											(PadCharR (rtos (nth 8 SubNod) 2 2) 12)		;Feeder Length UnderGround 3 Phase
											(PadCharR (rtos (nth 9 SubNod) 2 2) 12)		;Feeder Length UnderGround 2 Phase
											(PadCharR (rtos (nth 10 SubNod) 2 2) 12)	;Feeder Length UnderGround 1 Phase
									)
									AddsUpFil
						)
				)
			)
			(setq	outs		(getvar "date")
					osecs	(* 86400.0 (- outs (fix outs)))
					elss		(itoa (fix (- (* osecs 1000.0) (* isecs 1000.0))))
			)
			(if DevMark
				(princ (strcat "\nElapsed Milliseconds for AddsUpAnalyze: " elss))
			)
			(setq	PanRepStr	(strcat	(PadCharR "[CHK]" 10)
									"Name: {"			Panel
									"} Scale: {"		(PadCharL (if MyScl MyScl "NoSc") 4)
									"} Fdrs: {"		(PadCharLX (if SubLst (itoa (length SubLst)) "0") 2 "0")
									"} SaveBy: {"
									(if (getvar "LOGINNAME") (PadCharL (strcase (getvar "loginname")) 8) "********")
									"} on {"
									(if (date_s) (date_s) "NoDate")
									"} at {"
									(if (time_s) (PadCharL (time_s) 10) "NoTime")
									"} "
									(if elss "AddsUp{" "       ")
									(if elss (PadCharLX elss 8 "0") "        ")
									(if elss "}" " ")
									(if InTim " BrkPan{" "        ")
									(if InTim (PadCharLX InTim 8 "0") "00000000")
									(if InTim "}" " ")
									(if SubBadLay " SubBadLay: {" "             ")
									(if SubBadLay (PadCharLX (itoa SubBadLay) 3 "0") "   ")
									(if SubBadLay "} " "  ")
							)
			)
			(if (and Bug PanRepStr) (princ (strcat "\n[Bug]: " PanRepStr)))
			(write-line PanRepStr AddsUpFil)
			(close AddsUpFil)
		)
	)
	(if Bug (princ "\nAddsUpAnalyze exited}\n"))
	(if PanRepStr (substr PanRepStr 11))
)

(defun AddsUpMerge ( SubNod1 SubNod2 /	SubNod3 )	; Returns Merged Sub Data with same code
	(if Bug (princ "\n{AddsUpMerge entered\n"))
	(if (= (car SubNod1) (car SubNod2))
		(setq	SubNod3	(list	(car SubNod1)						;Feeder Code
								(if (< (nth 1 SubNod1) (nth 1 SubNod2))	;MinX
									(nth 1 SubNod1)
									(nth 1 SubNod2)
								)
								(if (< (nth 2 SubNod1) (nth 2 SubNod2))	;MinY
									(nth 2 SubNod1)
									(nth 2 SubNod2)
								)
								(if (> (nth 3 SubNod1) (nth 3 SubNod2))	;MaxX
									(nth 3 SubNod1)
									(nth 3 SubNod2)
								)
								(if (> (nth 4 SubNod1) (nth 4 SubNod2))	;MaxY
									(nth 4 SubNod1)
									(nth 4 SubNod2)
								)
								(+ (nth 5 SubNod1) (nth 5 SubNod2))	;1 Phase Overhead PLenth
								(+ (nth 6 SubNod1) (nth 6 SubNod2))	;2 Phase Overhead PLenth
								(+ (nth 7 SubNod1) (nth 7 SubNod2))	;3 Phase Overhead PLenth
								(+ (nth 8 SubNod1) (nth 8 SubNod2))	;1 Phase UnderGround PLenth
								(+ (nth 9 SubNod1) (nth 9 SubNod2))	;2 Phase UnderGround PLenth
								(+ (nth 10 SubNod1) (nth 10 SubNod2))	;3 Phase UnderGround PLenth
								(+ (nth 11 SubNod1) (nth 11 SubNod2))	;Unknown PLenth
						)
		)
		(setq	SubNod3	(alert (strcat "* " AppNam "Error *\nCan't merge different feeders!")))
	)
	(if Bug (princ "\nAddsUpMerge exited}\n"))
	SubNod3
)

(defun BldMstPLst ( Back9 Ppt1 /	Cnt PtLst		; Build Master Point List
							MPtLst NumLst Numb )
	(if Bug 
		(progn
			(princ "\nUtils.Lsp!BldMstPLst - Enter parameters:\n   Back9(list): ")
			(prin1 Back9)
			(princ (strcat "\n   Ppt1: " (rtos (car Ppt1) 2 2)", " (rtos (cadr Ppt1) 2 2)"\n")) 
		)
	)
	(setq	Cnt		0
			PtLst	nil
			MPtLst	nil
			NumLst	nil
	)
	(while (< Cnt (length Back9))				; step thru incoming data list
		(if (= (car (nth Cnt Back9)) 10)		; if its a point element
			(if MPtLst					; generate Master Point List, with Line Segment Number + PointX + PointY
				(setq PtLst  (list Cnt
							    (nth 1 (nth Cnt Back9))
							    (nth 2 (nth Cnt Back9))
						   )
					 MPtLst (append MPtLst (list PtLst))
					 Numb   Cnt
					 NumLst (append NumLst (list Numb))
				)
				(setq PtLst  (list Cnt
							    (nth 1 (nth Cnt Back9))
							    (nth 2 (nth Cnt Back9))
						   )
					 MPtLst (list PtLst)
					 Numb   Cnt
					 NumLst (list Numb)
				)
			)
		)
		(if (= (car (nth Cnt Back9)) 40) ; if its a st_width element
			(if (member Numb NumLst) ; if its line segment is listed
				(if (= (length (assoc Numb MPtLst)) 3) ; if its st_width is missing
					(setq PtLst  (append (assoc Numb MPtLst)
									 (list (cdr (nth Cnt Back9)))
							   )
						 MPtLst (subst	PtLst
									(assoc Numb MPtLst)
									MPtLst
							   )
					)
				)
			)
		)
		(if (= (car (nth Cnt Back9)) 41) ; if its a end_width element
			(if (member Numb NumLst) ; if its line segment is listed
				(if (= (length (assoc Numb MPtLst)) 4) ; if its end_width is missing
					(setq PtLst  (append (assoc Numb MPtLst)
									 (list (cdr (nth Cnt Back9)))
							   )
						 MPtLst (subst	PtLst
									(assoc Numb MPtLst)
									MPtLst
							   )
					)
				)
			)
		)
		(if (= (car (nth Cnt Back9)) 42) ; if its a bulge data element
			(if (member Numb NumLst) ; if its line segment is listed
				(if (= (length (assoc Numb MPtLst)) 5) ; if its bulge data is missing
					(setq PtLst  (append (assoc Numb MPtLst)
									 (list (cdr (nth Cnt Back9)))
							   )
						 MPtLst (subst	PtLst
									(assoc Numb MPtLst)
									MPtLst
							   )
					)
				)
			)
		)
		(setq Cnt (1+ Cnt))
	)
	(if Bug 
		(progn
			(princ "\nUtils.Lsp!BldMstPLst - Return(list):\n   ")
			(prin1 (list MPtLst NumLst))
			(princ "\n")
		)
	)
	(list MPtLst NumLst)
)

(defun CalcArcLen ( Vpt1 Vpt2 Blg1 /	Ang1 Ang2	; Returns the ArcLength of a Pline Arc
								Ang1a Ang3 Dst1 Cpt1 Ang4 Ang5 Dst2 Ang6 ArcD Bubba )
	(if Bug (princ "\n{CalcArcLen entered\n"))
	(setq	Ang1		(angle Vpt1 Vpt2)
			Bubba	(if (and Bug Ang1) (princ (strcat "\nAng1:" (rtos Ang1 2 4))))
			Ang1a	(if (>= Blg1 0.0)
						(+ Ang1 (/ (* 5.0 pi) 2.0))	; (/ pi 2.0))
						(+ Ang1 (/ (* 3.0 pi) 2.0))
					)
			Bubba	(if (and Bug Ang1a) (princ (strcat "\nAng1a:" (rtos Ang1a 2 4))))
			Ang2		(if (>= Blg1 0.0)
						(- Ang1a (* 2.0 (atan Blg1)))
						(+ Ang1a (* 2.0 (atan (abs Blg1))))
					)
			Bubba	(if (and Bug Ang2) (princ (strcat "\nAng2:" (rtos Ang2 2 4))))
			Ang3 	(if (>= Blg1 0.0)
						(+ Ang1a (* 2.0 (atan Blg1)))
						(- Ang1a (* 2.0 (atan (abs Blg1))))
					)
			Bubba	(if (and Bug Ang3) (princ (strcat "\nAng3:" (rtos Ang3 2 4))))
			Dst1 	(* (distance Vpt1 Vpt2) (/ 1.0 (atan (abs Blg1))))
			Bubba	(if Bug (grdraw Vpt1 (polar Vpt1 Ang2 Dst1) 1 1))
			Bubba	(if Bug (grdraw Vpt2 (polar Vpt2 Ang3 Dst1) 3 1))
			Cpt1		(inters	Vpt1
							(polar Vpt1 Ang2 Dst1)
							Vpt2
							(polar Vpt2 Ang3 Dst1)
							T
					)
	)
	(if Cpt1
		(setq	Ang4		(angle Cpt1 Vpt1)
				Bubba	(if (and Bug Ang4) (princ (strcat "\nAng4:" (rtos Ang4 2 4))))
				Ang5		(angle Cpt1 Vpt2)
				Bubba	(if (and Bug Ang5) (princ (strcat "\nAng5:" (rtos Ang5 2 4))))
				Dst2		(distance Cpt1 Vpt1)
				Bubba	(if (and Bug Dst2) (princ (strcat "\nDst2:" (rtos Dst2 2 4))))
				Ang6		(if (>= Blg1 0.0)
							(if (> Ang4 Ang5)				;clockwise -> if crosses x=0 axis
								(+	(- (* pi 2.0) Ang4)
									Ang5
								)
								(-	Ang5
									Ang4
								)
							)
							(if (> Ang5 Ang4)				;counter-clockwise ->if crosses x=0 axis
								(+	(- (* pi 2.0) Ang5)
									Ang4
								)
								(-	Ang4
									Ang5
								)
							)
						)
				Bubba	(if (and Bug Ang6) (princ (strcat "\nAng6:" (rtos Ang6 2 4))))
				Ang6		(if (>= Ang6 (* 2.0 pi))
							(- Ang6 (* 2.0 pi))
							Ang6
						)
				Bubba	(if (and Bug Ang6) (princ (strcat "\nAng6:" (rtos Ang6 2 4))))
				ArcD		(*	Dst2
							Ang6
						)
		)
		(setq	ArcD		(distance Vpt1 Vpt2)
				Bubba	(if Bug (princ "\nNo Valid ArcLength found!"))
		)
	)
	(if Bug (princ "\nCalcArcLen exited}\n"))
	ArcD
)

(defun Date_S ( / d )						; Legacy Code, Date String
	(setq d (rtos (getvar "CDATE") 2 6))
	(strcat (substr d 5 2)
		   "/"
		   (substr d 7 2)
		   "/"
		   (substr d 1 4)
	)
)

(defun GetPLen ( Ent1 /	Back1 Bubba Back9 Back8	; Returns True Length of Pline
					NumLst MPtLst PLenth	; requires ReadOPoly, ReadNPoly, BldMstPLst, CalcArcLen
					Cnt NLenth )
	(if Bug 
		(progn
			(princ "\nUtils.Lsp!GetPLen - Enter parameter\n  Ent1: ")
			(prin1 Ent1)
			(princ "\n")
		)
	)
	(setq	PLenth	0.0)
	(if Ent1
		(if (= (cdr (assoc 0 Ent1)) "POLYLINE")
			(setq Back1 (ReadOPoly Ent1)
				 Bubba (if Bug
						  (princ "\nOriginal Polyline read in.")
					  )
			)
			(if (= (cdr (assoc 0 Ent1)) "LWPOLYLINE")
				(setq Back1 (ReadNPoly Ent1)
					 Bubba (if Bug
							  (princ
								  "\nOptimized Polyline read in."
							  )
						  )
				)
				(princ "\nNot any kind of Polyline!")
			)
		)
		(princ "\nNo Valid Data!")
	)
	(if Back1
		(if (= (cdr (assoc 0 Ent1)) "POLYLINE")
			(progn
				(setq Back9 (cadr Back1)
					 Back8 (cddr Back1)
				)
				(mapcar (quote (lambda (x) (setq Back9 (append Back9 x))))
					   Back8
				)
				(setq	MPtLst	(BldMstPLst Back9 (cadr FirstPic))
						NumLst	(nth 1 MPtLst)
						MPtLst	(nth 0 MPtLst)
				)
			)
			(if (= (cdr (assoc 0 Ent1)) "LWPOLYLINE")
				(setq	MPtLst	(BldMstPLst Back1 (cadr FirstPic))
						NumLst	(nth 1 MPtLst)
						MPtLst	(nth 0 MPtLst)
				)
				(princ "\nNot any kind of Polyline!")
			)
		)
	)
	(if MPtLst
		(setq	Cnt	0)
		(setq	Cnt	nil)
	)
	(if (and Bug MPtLst)
		(setq EdsMptLst MPtLst)
	)
	(if Cnt
		(while (< Cnt (1- (length MPtLst)))
			(if (equal (last (nth Cnt MPtLst)) 0.0 0.01)
				(setq	NLenth	(distance	(list	(nth 1 (nth Cnt MPtLst))
												(nth 2 (nth Cnt MPtLst))
										)
										(list	(nth 1 (nth (1+ Cnt) MPtLst))
												(nth 2 (nth (1+ Cnt) MPtLst))
										)
								)
						Bubba	(if (and Bug NLenth) (princ (strcat "\nNLenth:" (rtos NLenth 2 3) "\n")))
						PLenth	(+ PLenth NLenth)
						Cnt		(1+ Cnt)
				)
				(setq	NLenth	(CalcArcLen	(list	(nth 1 (nth Cnt MPtLst))
													(nth 2 (nth Cnt MPtLst))
											)
											(list	(nth 1 (nth (1+ Cnt) MPtLst))
													(nth 2 (nth (1+ Cnt) MPtLst))
											)
											(last (nth Cnt MPtLst))
								)
						Bubba	(if (and Bug NLenth) (princ (strcat "\nNLenth:" (rtos NLenth 2 3) "\n")))
						PLenth	(+ PLenth NLenth)
						Cnt		(1+ Cnt)
				)
			)
		)
	)
	(if Bug (princ "\nGetPLen exited}\n"))
	PLenth
)

(defun Mod ( Inp Root / Ans )				; Returns Mod of Division
	(if (= (type Inp) (quote INT))
		(setq	Inp		(float Inp))
	)
	(if (= (type Root) (quote INT))
		(setq	Root		(float Root))
	)
	(setq	Ans		(- (/ Inp Root) (fix (/ Inp Root)))
			Ans		(if (< (* Ans Root) 1.0) 0 (fix (* Ans Root)))
	)
)

(defun PadChar ( LED DesLen / LEDlen )			; Returns LED padded Left Justified to DesLen
	(setq LEDlen (strlen LED))
	(if (< LEDlen DesLen)
		(progn
			(while (< LEDlen DesLen)
				(setq	LED (strcat LED " ")
					LEDlen (strlen LED)
				)
			)
			LED
		)
		(progn
			(if Bug (princ (strcat "\n***<" LED ">*** is {" (itoa (- LEDlen DesLen)) "} chars to large!")))
			(substr LED 1 DesLen)
		)
	)
)

(defun PadCharR ( LED DesLen / LEDlen )		; Returns LED padded Right Justified to DesLen
	(setq LEDlen (strlen LED))
	(if (< LEDlen DesLen)
		(progn
			(while (< LEDlen DesLen)
				(setq	LED (strcat LED " ")
					LEDlen (strlen LED)
				)
			)
			LED
		)
		(progn
			(if Bug (princ (strcat "\n***<" LED ">*** is {" (itoa (- LEDlen DesLen)) "} chars to large!")))
			(substr LED 1 DesLen)
		)
	)
)

(defun PadCharL ( LED DesLen / LEDlen )		; Returns LED padded Left Justified to DesLen
	(setq LEDlen (strlen LED))
	(if (< LEDlen DesLen)
		(progn
			(while (< LEDlen DesLen)
				(setq	LED (strcat " " LED)
					LEDlen (strlen LED)
				)
			)
			LED
		)
		(progn
			(if Bug (princ (strcat "\n***<" LED ">*** is {" (itoa (- LEDlen DesLen)) "} chars to large!")))
			(substr LED 1 DesLen)
		)
	)
)

(defun PadCharLX ( LED DesLen Ch / LEDlen )		; Returns LED padded Left Justified to DesLen
	(setq LEDlen (strlen LED))
	(if (< LEDlen DesLen)
		(progn
			(while (< LEDlen DesLen)
				(setq	LED (strcat Ch LED)
					LEDlen (strlen LED)
				)
			)
			LED
		)
		(progn
			(if Bug (princ (strcat "\n***<" LED ">*** is {" (itoa (- LEDlen DesLen)) "} chars to large!")))
			(substr LED 1 DesLen)
		)
	)
)

(defun PadCharRX ( LED DesLen Ch / LEDlen )		; Returns LED padded Right Justified to DesLen
	(setq LEDlen (strlen LED))
	(if (< LEDlen DesLen)
		(progn
			(while (< LEDlen DesLen)
				(setq	LED (strcat LED Ch)
					LEDlen (strlen LED)
				)
			)
			LED
		)
		(progn
			(if Bug (princ (strcat "\n***<" LED ">*** is {" (itoa (- LEDlen DesLen)) "} chars to large!")))
			(substr LED 1 DesLen)
		)
	)
)

(defun PExtent ( VLst /	MinX MinY MaxX MaxY		; Returns the Extents of a Vertex List
					e2 IsX IsY IsB IsW
					IsAng0 IsAng1 IsAng2 Pt1 Pt2 IsV )
	(if Bug (princ "\n{PExtent entered\n"))
	(setq	MinX		(car (cdr (assoc 10 (car VLst))))
			MinY		(cadr (cdr (assoc 10 (car VLst))))
			MaxX		(car (cdr (assoc 10 (car VLst))))
			MaxY		(cadr (cdr (assoc 10 (car VLst))))
	)
	(foreach	e2
			VLst
			(setq	IsX	(car (cdr (assoc 10 e2)))
					IsY	(cadr (cdr (assoc 10 e2)))
			)
			(if (assoc 42 e2)
				(setq	IsB	(cdr (assoc 42 e2)))
				(setq	IsB	nil)
			)
			(if (and (> IsW 0.001) IsB)
				(progn
					(setq	IsAng0	(* 4.0 (atan IsB))
							IsAng1	(+ IsAng0 (/ pi 2.0))
							IsAng2	(- IsAng0 (/ pi 2.0))
							Pt1		(polar (list IsX IsY) IsAng1 IsW)
							Pt2		(polar (list IsX IsY) IsAng2 IsW)
							IsX		(car Pt1)
							IsY		(cadr Pt1)
					)
					(if IsV
						(setq	MinX	IsX
								MinY	IsY
								MaxX	IsX
								MaxY	IsY
								IsV	nil
						)
						(progn
							(if (> IsX MaxX) (setq MaxX IsX))
							(if (> IsY MaxY) (setq MaxY IsY))
							(if (< IsX MinX) (setq MinX IsX))
							(if (< IsY MinY) (setq MinY IsY))
						)
					)
					(setq	IsX		(car Pt2)
							IsY		(cadr Pt2)
					)
					(if (> IsX MaxX) (setq MaxX IsX))
					(if (> IsY MaxY) (setq MaxY IsY))
					(if (< IsX MinX) (setq MinX IsX))
					(if (< IsY MinY) (setq MinY IsY))
				)
				(progn
					(if IsV
						(setq	MinX	IsX
								MinY	IsY
								MaxX	IsX
								MaxY	IsY
								IsV	nil
						)
						(progn
							(if (> IsX MaxX) (setq MaxX IsX))
							(if (> IsY MaxY) (setq MaxY IsY))
							(if (< IsX MinX) (setq MinX IsX))
							(if (< IsY MinY) (setq MinY IsY))
						)
					)
				)
			)
	)
	(if Bug (princ "\nPExtent exited}\n"))
	(list MinX MinY MaxX MaxY)
)

(defun ReadNPoly ( Ent1 /	PTyp PLyr PSpc PElv	; Reads new Pline entlist, returns formatted
						PNum PCwd PLtp PCol PThk PEED PFlg PVnm
						PMain PLst Cnt )
	(if Bug (princ "\n{ReadNPoly entered\n"))
	(setq PTyp  (assoc 0 Ent1)
		 PLyr  (assoc 8 Ent1)
		 PSpc  (assoc 67 Ent1)
		 PElv  (assoc 38 Ent1)
		 PThk  (assoc 39 Ent1)
		 PNum  (assoc 90 Ent1)
		 PCwd  (assoc 43 Ent1)
		 PLtp  (assoc 6 Ent1)
		 PCol  (assoc 62 Ent1)
		 PEED  (assoc -3 Ent1)
		 PFlg  (assoc 70 Ent1)
		 PVnm  (assoc 210 Ent1)
		 PMain (list PTyp
				   PLyr
				   (cons 100 "AcDbEntity")
				   PSpc
				   (cons 100 "AcDbPolyline")
				   PNum
			  )
		 PMain (if PLtp
				  (append PMain (list PLtp))
				  (append PMain (list (cons 6 "BYLAYER")))
			  )
		 PMain (if PCol
				  (append PMain (list PCol))
				  (append PMain (list (cons 62 256)))
			  )
		 PMain (if PFlg
				  (append PMain (list PFlg))
				  PMain
			  )
		 PMain (if PCwd
				  (append PMain (list PCwd))
				  PMain
			  )
		 PMain (if PThk
				  (append PMain (list PThk))
				  PMain
			  )
		 Cnt	  0
		 PLst  PMain
	)
	(repeat (length Ent1)
		(if (= (car (nth Cnt Ent1)) 10)
			(setq PLst (append PLst (list (nth Cnt Ent1))))
		)
		(if (= (car (nth Cnt Ent1)) 40)
			(setq PLst (append PLst (list (nth Cnt Ent1))))
		)
		(if (= (car (nth Cnt Ent1)) 41)
			(setq PLst (append PLst (list (nth Cnt Ent1))))
		)
		(if (= (car (nth Cnt Ent1)) 42)
			(setq PLst (append PLst (list (nth Cnt Ent1))))
		)
		(setq Cnt (1+ Cnt))
	)
	(setq PLst (if	PVnm
				 (append PLst (list PVnm))
				 PLst
			 )
	)
	(setq PLst (if	PEED
				 (append PLst (list PEED))
				 PLst
			 )
	)
	(if Bug (princ "\nReadNPoly exited}\n"))
	PLst
)

(defun ReadOPoly ( Ent1 /	PTyp PLyr PThk PLtp	; Reads old Pline entlist, returns formatted
						PEED PCol PFol PFlg Ent2 PMain PTan PVrt
						PLst PBlg PWd1 PWd2 PPnt )
	(if Bug 
		(progn
			(princ "\nUtils.lsp!ReadOPoly - Entered} Parameters:\n   Ent1:  ")
			(prin1 Ent1)
			(princ "\n")
		)
	)
	(setq PTyp  (assoc 0 Ent1)
		 PLyr  (assoc 8 Ent1)
		 PThk  (assoc 39 Ent1)
		 PLtp  (assoc 6 Ent1)
		 PCol  (assoc 62 Ent1)
		 PEED  (assoc -3 Ent1)
		 PFol  (assoc 66 Ent1)
		 PFlg  (assoc 70 Ent1)
		 Ent2  (entnext (cdr (assoc -1 Ent1)))
		 PMain (list PTyp
				   PLyr
			  )
		 PMain (if PThk
				  (append PMain (list PThk))
				  PMain
			  )
		 PMain (if PLtp
				  (append PMain (list PLtp))
				  (append PMain (list (cons 6 "BYLAYER")))
			  )
		 PMain (if PCol
				  (append PMain (list PCol))
				  (append PMain (list (cons 62 256)))
			  )
		 PMain (if PFol
				  (append PMain (list PFol))
				  PMain
			  )
		 PMain (if PFlg
				  (append PMain (list PFlg))
				  PMain
			  )
		 PMain (if PEED
				  (append PMain (list PEED))
				  PMain
			  )
	)
	(if PFol
		(setq PLst (list PMain))
	)
	(if PFol
		(while (/= (cdr (assoc 0 (entget Ent2))) "SEQEND")
			(setq PTyp (assoc 0 (entget Ent2))
				 PLyr (assoc 8 (entget Ent2))
				 PPnt (assoc 10 (entget Ent2))
				 PWd1 (assoc 40 (entget Ent2))
				 PWd2 (assoc 41 (entget Ent2))
				 PBlg (assoc 42 (entget Ent2))
				 PFlg (assoc 70 (entget Ent2))
				 PTan (assoc 50 (entget Ent2))
				 PVrt (list PTyp
						  PLyr
						  PPnt
					 )
				 PVrt (if	PWd1
						 (append PVrt (list PWd1))
						 PVrt
					 )
				 PVrt (if	PWd2
						 (append PVrt (list PWd2))
						 PVrt
					 )
				 PVrt (if	PBlg
						 (append PVrt (list PBlg))
						 PVrt
					 )
				 PVrt (if	PFlg
						 (append PVrt (list PFlg))
						 PVrt
					 )
				 PVrt (if	PTan
						 (append PVrt (list PTan))
						 PVrt
					 )
				 PLst (append PLst (list PVrt))
				 Ent2 (entnext Ent2)
			)
		)
	)
	(if PFol
		(setq PTyp (assoc 0 (entget Ent2))
			 PVrt (list PTyp)
			 PLst (append PLst (list PVrt))
		)
	)
	(if Bug 
		(progn
			(princ "\nUtils.lsp!ReadOPoly - Done\n  Return value: ") 
			(prin1 PLst) 
			(princ "\n")
		)
	)
	PLst
)

(defun InStr ( Str Chrn /	StrPos CntR )		; Finds first use of Chrn character number
	(if Bug (princ "\n{ InStr entered\n"))
	(setq	CntR		1
			StrPos	0
	)
	(if Chrn
		(if (and (>= Chrn 0) (<= Chrn 150))
			(if Str
				(if (>= (strlen Str) 1)
					(while (and (<= CntR (strlen Str)) (= StrPos 0))
						(if	(and (= (ascii (substr Str CntR 1)) Chrn) (= StrPos 0))
							(setq	StrPos	CntR)
						)
						(setq	CntR		(1+ CntR))
					)
				)
				(princ "\nInStr: No String")
			)
			(princ "\nInStr: Chrn out-of-range")
		)
		(princ "\nInStr: No Chrn")
	)
	(setq	WasVal	(list
						0	;null
						8	;backspace
						9	;tab
						10	;linefeed
						13	;carriage return
						27	;escape
						32	;space
						33	;exclamation
						34	;double-quote
						35	;pound sign
						36	;dollar sign
						37	;percent sign
						38	;ampersand
						39	;reverse single-quote (or escape)
						40	;left parenthesis
						41	;right parenthesis
						42	;asterisk
						43	;plus sign
						44	;comma
						45	;dash
						46	;period
						47	;forward slash
						58	;colon
						59	;semi-colon
						60	;less than
						61	;equal to
						62	;greater than
						63	;question mark
						64	;at sign
						91	;left square bracket
						92	;backslash
						93	;right square bracket
						94	;caret
						95	;underscore
						96	;single-quote
						123	;left curly brace
						124	;vertical pipe
						125	;right curly brace
						126	;tilde
					)
	)
	(if Bug (princ "\n InStr exited}\n"))
	StrPos
)

(defun RepLChar ( Str Was ShouldBe Action /	Cnt	; Replaces 'Was' with 'ShouldBe' in a string
								TmpStr WasVal )
	(setq	Cnt		1
			TmpStr	"X"
			WasVal	(ascii Was)
	)
	(while (<= Cnt (strlen Str))
		(if	(not	(= (ascii (substr Str Cnt 1)) WasVal))
			(if (= Action 1)
				(setq	TmpStr	(strcat TmpStr (substr Str Cnt 1)))
				(setq	TmpStr	(strcat TmpStr (strcase (substr Str Cnt 1))))
			)
			(setq	TmpStr	(strcat TmpStr ShouldBe))
		)
		(setq	Cnt		(1+ Cnt))
	)
	(if (> (strlen TmpStr) 1)
		(setq	TmpStr	(substr TmpStr 2))
		(setq	TmpStr	nil)
	)
	TmpStr
)

(defun RepLStr ( Str Was ShouldBe Action /		; Replaces 'Was' with 'ShouldBe' in a string
								TmpStr )
	(if (vl-string-search Was Str)
		(if (> (vl-string-search Was Str) 0)
			(setq	TmpStr	(strcat (substr Str 1 (vl-string-search Was Str)) ShouldBe (substr Str (+ 1 (strlen Was) (vl-string-search Was Str)))))
			(setq	TmpStr	(strcat ShouldBe (substr Str (+ 1 (strlen Was) (vl-string-search Was Str)))))
		)
	)
	(if (= Action 1)
		(if (vl-string-search Was TmpStr)
			(while (vl-string-search Was TmpStr)
				(if (vl-string-search Was TmpStr)
					(setq	TmpStr	(strcat (substr TmpStr 1 (vl-string-search Was TmpStr)) ShouldBe (substr TmpStr (+ 1 (strlen Was) (vl-string-search Was TmpStr)))))
				)
			)
		)
	)
	TmpStr
)

(defun FndSeqStr ( Str FrmStr ToStr /	Cnt		; Replaces 'Was' with 'ShouldBe' in a string
								TmpStr )
	(cond
		((and (vl-string-search FrmStr Str) (vl-string-search ToStr Str))
			(setq	TmpStr	(substr Str (1+ (vl-string-search FrmStr Str)) (+ (- (vl-string-search ToStr Str) (vl-string-search FrmStr Str)) (strlen ToStr))))
		)
		((vl-string-search FrmStr Str)
			(setq	TmpStr	(substr Str (1+ (vl-string-search FrmStr Str))))
		)
		((vl-string-search ToStr Str)
			(setq	TmpStr	(substr Str 1 (+ (vl-string-search FrmStr Str) (1+ (strlen ToStr)))))
		)
	)
	TmpStr
)

(defun FndMultSeqStr ( Str FrmStr ToStr /		; Replaces 'Was' with 'ShouldBe' in a string
									LstStrPos StrPos LstTmpStr TmpStr )
	(setq	LstTmpStr	nil)
	(if (setq StrPos (vl-string-search FrmStr Str))
		(setq	LstStrPos	(list StrPos))
	)
	(if StrPos
		(if (vl-string-search FrmStr Str (1+ StrPos))
			(while (setq StrPos (vl-string-search FrmStr Str (1+ StrPos)))
				(setq	LstStrPos	(cons StrPos LstStrPos))
			)
		)
	)
	(if LstStrPos
		(foreach	StrPos
				LstStrPos
				(cond
					((and (vl-string-search FrmStr Str StrPos) (vl-string-search ToStr Str StrPos))
						(setq	TmpStr	(substr Str (1+ (vl-string-search FrmStr Str StrPos)) (+ (- (vl-string-search ToStr Str StrPos) (vl-string-search FrmStr Str StrPos)) (strlen ToStr))))
					)
					((vl-string-search FrmStr Str)
						(setq	TmpStr	(substr Str (1+ (vl-string-search FrmStr Str StrPos))))
					)
					((vl-string-search ToStr Str)
						(setq	TmpStr	(substr Str 1 (+ (vl-string-search FrmStr Str StrPos) (1+ (strlen ToStr)))))
					)
				)
				(if LstTmpStr
					(setq	LstTmpStr	(cons TmpStr LstTmpStr))
					(setq	LstTmpStr	(list TmpStr))
				)
		)
	)
	LstTmpStr
)

(defun StrpHtmlTags ( StrIn /	LstPairs		; Strip HTML tags to find file paths and display text
						StrOne BegPair EndPair StrPos StrTarget )
	(setq	LstPairs	(FndMultSeqStr StrIn "<" ">")
			BegPair	nil
			EndPair	nil
	)
	(if LstPairs
		(progn
			(foreach	StrOne
					LstPairs
					(if BegPair
						(if (or (vl-string-search "<a href=\"file" StrOne) (vl-string-search "<option value=\"file" StrOne))
							(if Bug (princ "\nBug:[Duplicate Beginning Pair found!]"))
						)
						(if (vl-string-search "<a href=\"file" StrOne)
							(setq	BegPair	StrOne)
							(if (vl-string-search "<option value=\"file" StrOne)
								(setq	BegPair	StrOne)
							)
						)
					)
					(if EndPair
						(if (or (vl-string-search "</a>" StrOne) (vl-string-search "</option>" StrOne))
							(if Bug (princ "\nBug:[Duplicate Ending Pair found!]"))
						)
						(if (vl-string-search "</a>" StrOne)
							(setq	EndPair	StrOne)
							(if (vl-string-search "</option>" StrOne)
								(setq	EndPair	StrOne)
							)
						)
					)
			)
			(if (and EndPair BegPair)
				(progn
					(setq	InBtwn	(substr StrIn (+ 1 (vl-string-search BegPair StrIn) (strlen BegPair)) (- (vl-string-search EndPair StrIn (1+ (vl-string-search BegPair StrIn))) (+ (vl-string-search BegPair StrIn) (strlen BegPair)))))
					(if (vl-string-search "%20" BegPair)
						(setq	BegPair	(RepLStr BegPair "%20" " " 1))
					)
					(if (vl-string-search "S:" BegPair)
						(setq	BegPair	(substr BegPair (1+ (vl-string-search "S:" BegPair))))
					)
					(if (vl-string-search "\">" BegPair)
						(setq	BegPair	(substr BegPair 1 (vl-string-search "\">" BegPair)))
					)
					(if (vl-string-search "/" BegPair)
						(setq	BegPair	(RepLChar BegPair "/" "\\" 1))
					)
					(if (vl-string-search "\" target=" BegPair)
						(setq	BegPair	(substr BegPair 1 (vl-string-search "\" target=" BegPair)))
					)
					(if (vl-string-search "\\" BegPair)
						(setq	StrPos	(vl-string-search "\\" BegPair))
					)
					(if StrPos
						(while (vl-string-search "\\" BegPair (1+ StrPos))
							(if (vl-string-search "\\" BegPair (1+ StrPos))
								(setq	StrPos	(vl-string-search "\\" BegPair (1+ StrPos)))
							)
						)
					)
					(if StrPos
						(setq	StrTarget	(substr BegPair (+ 2 StrPos)))
						(setq	StrTarget	"")
					)
					(if (vl-string-search "&amp;" InBtwn)
						(while (vl-string-search "&amp;" InBtwn)
							(if (= (vl-string-search "&amp;" InBtwn) 0)
								(setq	InBtwn	(substr InBtwn 6))
								(if (= (+ 5 (vl-string-search "&amp;" InBtwn)) (strlen InBtwn))
									(setq	InBtwn	(substr InBtwn 1 (vl-string-search "&amp;" InBtwn)))
									(setq	InBtwn	(strcat	(substr InBtwn 1 (vl-string-search "&amp;" InBtwn))
															(substr InBtwn (+ 6 (vl-string-search "&amp;" InBtwn)))
													)
									)
								)
							)
							
						)
					)
					(if (vl-string-search "<" InBtwn)
						(while (and (vl-string-search "<" InBtwn) (vl-string-search ">" InBtwn (1+ (vl-string-search "<" InBtwn))))
							(setq	InBtwn	(StrpKillPairs InBtwn "<" ">"))
						)
					)
					(if (and InBtwn LstPairs)
						(setq	LstPairs	(reverse LstPairs)
								LstPairs	(cons InBtwn LstPairs)
								LstPairs	(reverse LstPairs)
								LstPairs	(cons BegPair LstPairs)
								LstPairs	(cons StrTarget LstPairs)
						)
					)
				)
				(setq	LstPairs	nil)
			)
		)
	)
	LstPairs
)

(defun StrpKillPairs ( StrIn PairBeg PairEnd / )
	(if (and (vl-string-search PairBeg StrIn) (vl-string-search PairEnd StrIn (1+ (vl-string-search PairBeg StrIn))))
		(if (= (vl-string-search PairBeg StrIn) 0)
			(setq	TmpStr	(substr StrIn (+ 2 (vl-string-search PairEnd StrIn))))
			(if (= (1+ (vl-string-search PairEnd StrIn)) (strlen TmpStr))
				(setq	TmpStr	(substr StrIn 1 (vl-string-search PairBeg StrIn)))
				(setq	TmpStr	(strcat	(substr StrIn 1 (vl-string-search PairBeg StrIn))
										(substr StrIn (1+ (vl-string-search PairEnd StrIn (1+ (vl-string-search PairBeg StrIn)))))
								)
				)
			)
		)
		(setq	TmpStr	StrIn)
	)
	TmpStr
)

(defun HtmRead ( Fnam /	Fn2 InpLin			; Reads the tags of an Html file
					LstHtml BigLstHtml CntR Fn3 )
	(setq	CntR		0)
	(if (findfile Fnam)
		(progn
			(setq Fn2 (open Fnam "r"))
			(while (setq InpLin (read-line Fn2))
				(setq	CntR		(1+ CntR))
				(if InpLin
					(setq	LstHtml	(StrpHtmlTags InpLin))
				)
				(if LstHtml
					(if BigLstHtml
						(setq	LstHtml		(list	(itoa CntR)
													(nth 0 LstHtml)
													(nth 1 LstHtml)
													(last LstHtml)
													(if (vl-file-systime (nth 1 LstHtml)) 1 0)
													Fnam
											)
								BigLstHtml	(cons LstHtml BigLstHtml)
						)
						(setq	LstHtml		(list	(itoa CntR)
													(nth 0 LstHtml)
													(nth 1 LstHtml)
													(last LstHtml)
													(if (vl-file-systime (nth 1 LstHtml)) 1 0)
													Fnam
											)
								BigLstHtml	(list LstHtml)
						)
					)
				)
				(if Bug
					(princ (strcat "\nBug:{" (itoa CntR) "}"))
				)
			)
			(close Fn2)
		)
	)
	(if BigLstHtml
		(setq	BigLstHtml	(reverse BigLstHtml))
	)
	(if BigLstHtml
		(princ (strcat "\nFile={" (last (nth 0 BigLstHtml)) "}"))
	)
	(if BigLstHtml
		(setq	Bubba	(mapcar (quote (lambda (x) (princ (strcat "\n" (PadCharR (nth 0 x) 8) (PadCharR (strcat "{" (nth 1 x) "}") 28) "{" (itoa (nth 4 x)) "} {" (nth 3 x) "}")))) BigLstHtml)
				Fn3		(open "C:\\ARMSResources\\PD_Dist_DMC\\WebLst.txt" "a")
				Bubba	(mapcar (quote (lambda (x) (write-line (strcat (nth 0 x) "~" (nth 1 x) "~" (nth 3 x) "~" (nth 2 x) "~" (nth 5 x) "~" (itoa (nth 4 x))) Fn3))) BigLstHtml)
				Bubba	(close Fn3)
				Bubba	nil
		)
	)
	BigLstHtml
)

(defun RepChar ( Sub Cnt / OutStr )			; Repeat Char
	(if Bug (princ "\n{RepChar entered\n"))
	(setq	OutStr	Sub
			Cnt		(1- Cnt)
	)
	(if Sub
		(if (= Cnt 1)
			(setq	OutStr	(strcat OutStr Sub))
			(if (< Cnt 0)
				(setq OutStr "")
				(repeat Cnt (setq OutStr (strcat OutStr Sub)))
			)
		)
	)
	(if Bug (princ "\nRepChar exited}\n"))
	OutStr
)

(defun RevBlg ( Vpt1 Vpt2 Blg1 /	Ang1 Ang2 Ang3	; Reverses Bulge data
							Dst1 Cpt1 Ang4 Crv1 )
	(if Bug (princ "\n{RevBlg entered\n"))
	(setq Ang1 (angle Vpt1 Vpt2)
		 Ang2 (if	(> Blg1 0.0)
				 (- (+ Ang1 (/ pi 2.0)) (* 2.0 (atan Blg1)))
				 (+ (- Ang1 (/ pi 2.0)) (* 2.0 (atan Blg1)))
			 )
		 Ang3 (if	(> Blg1 0.0)
				 (+ (+ Ang1 (/ pi 2.0)) (* 2.0 (atan Blg1)))
				 (- (- Ang1 (/ pi 2.0)) (* 2.0 (atan Blg1)))
			 )
		 Dst1 (* (distance Vpt1 Vpt2) (/ 1.0 (atan Blg1)))
		 Cpt1 (inters Vpt1
				    (polar Vpt1 Ang2 Dst1)
				    Vpt2
				    (polar Vpt2 Ang3 Dst1)
				    T
			 )
	)
	(if Cpt1
		(setq Ang4 (/ (abs (- (angle Cpt1 Vpt2) (angle Cpt1 Vpt1)))
				    4.0
				 )
			 Crv1 (atan Ang4)
		)
	)
	(if (>= Blg1 0.0)
		(setq	Crv1		(* -1.0 Crv1))
		(setq	Crv1		Crv1)
	)
	(if Bug
		(princ	(strcat	"\nRevBlg Returns:\t"
						(rtos Crv1 2 4)
						"\nCurve Starts  :\t"
						(rtos (car Vpt1) 2 4) "," (rtos (cadr Vpt1) 2 4)
						"\nCurve Ends    :\t"
						(rtos (car Vpt2) 2 4) "," (rtos (cadr Vpt2) 2 4)
						"\nCurve Includes:\t"
						(rtos (rtd (- Ang3 Ang2)) 2 4) "%%d"
						"\nCentered At   :\t"
						(rtos (car Cpt1) 2 4) "," (rtos (cadr Cpt1) 2 4)
				)
		)
	)
	(if Bug (princ "\nRevBlg exited}\n"))
	Crv1
)

(defun RevBlgLst ( NLst /	RNLst Cnt			; Reverse a Polyline vertex list, mindful of bulges
						Fuzz BLst XLst		; requires RevBlg
						RLst ARLst )
	(if Bug (princ "\n{RevBlgLst entered"))
	(setq	Cnt		0
			Fuzz		0.01
			RLst		nil
			BLst		nil
			XLst		nil
	)
	(setq	BLst		(mapcar	(quote	(lambda (x)
										(cdr (assoc 42 x))
									)
							)
							NLst
					)
	)
	(setq	XLst		(mapcar	(quote	(lambda (x)
										 (cdr (assoc 10 x))
									)
							)
							NLst
					)
	)
	(while (< Cnt (length XLst))
		(if (/= Cnt (1- (length XLst)))
			(if (not (equal (nth Cnt BLst) 0.0 Fuzz))
				(if RLst
					(setq	RLst		(cons	(RevBlg	(nth Cnt XLst)
													(nth (1+ Cnt) XLst)
													(nth Cnt BLst)
											)
											RLst
									)
					)
					(setq	RLst		(list	(RevBlg	(nth Cnt XLst)
													(nth (1+ Cnt) XLst)
													(nth Cnt BLst)
											)
									)
					)
				)
				(if RLst
					(setq	RLst		(cons 0.0 RLst))
					(setq	RLst		(list 0.0))
				)
			)
			(if (not (equal (nth Cnt BLst) 0.0 Fuzz))
				(if RLst
					(setq	RLst		(cons	(RevBlg	(nth 0 XLst)
													(nth Cnt XLst)
													(nth Cnt BLst)
											)
											RLst
									)
					)
					(setq	RLst		(list	(RevBlg	(nth 0 XLst)
													(nth Cnt XLst)
													(nth Cnt BLst)
											)
									)
					)
				)
				(if RLst
					(setq	RLst		(cons 0.0 RLst))
					(setq	RLst		(list 0.0))
				)
			)
		)
		(setq	Cnt		(1+ Cnt))
	)
	(if RLst
		(setq	RLst1	(car RLst)
				RLst2	(cdr RLst)
				ARLst	(reverse (append RLst2 (list RLst1)))
		)
	)
	(setq	Cnt		0)
	(while (< Cnt (length XLst))
		(if RNLst
			(setq	RNLst	(cons	(subst	(cons 42 (nth Cnt ARLst))
											(assoc 42 (nth Cnt NLst))
											(nth Cnt NLst)
									)
									RNLst
							)
			)
			(setq	RNLst	(list	(subst	(cons 42 (nth Cnt ARLst))
											(assoc 42 (nth Cnt NLst))
											(nth Cnt NLst)
									)
							)
			)
		)
		(setq	Cnt		(1+ Cnt))
	)
	(if Bug (princ "\nRevBlgLst exited}"))
	RNLst
)

(defun StpVrtLst ( PLst RevAct /	NLst 		; Strips the Head & Foot of VrtLst, minds the bulge on reverse
							Fuzz BFlg Cnt	;
							BlgLst Bubba VrtEggs Vrt0 Vrt8 Vrt10
							Vrt40 Vrt41 Vrt42 Vrt70 Vrt50 )
	(if Bug (princ "\n{StpVrtLst entered"))
	(if Bug (setq EdsPLst PLst))
	(if (assoc 0 PLst)
		(cond
			((= (cdr (assoc 0 PLst)) "LWPOLYLINE")
				(setq	Cnt		(- (length PLst) (length (member (assoc 10 PLst) PLst)))
						Vrt0		(cons 0 "VERTEX")
						Vrt8		(assoc 8 PLst)
						Vrt10	(assoc 10 PLst)
						NLst		nil
				)
				(if (and Bug Cnt) (princ (strcat "\n[Bug:LWPOLYLINE] Cnt starts at:" (itoa Cnt) ", total length=" (itoa (length PLst)) ".")))
				(while (< Cnt (length PLst))
					(setq	Cnt	(1+ Cnt))
					(if (nth Cnt PLst)
						(cond
							((= (car (nth Cnt PLst)) 10)
								(if Bug (princ (strcat "\n[Bug] Got 10 Group on {" (itoa Cnt) "}")))
								(setq	VrtEggs	(list	Vrt0
														Vrt8
														Vrt10
														(if Vrt40 Vrt40 (cons 40 0.0))
														(if Vrt41 Vrt41 (cons 41 0.0))
														(if Vrt42 Vrt42 (cons 42 0.0))
														(if Vrt70 Vrt70 (cons 70 0))
														(if Vrt50 Vrt50 (cons 50 0.0))
												)
										Vrt10	(nth Cnt PLst)
										Vrt40	nil
										Vrt41	nil
										Vrt42	nil
										Vrt70	nil
										Vrt50	nil
								)
								(if NLst
									(setq	NLst		(cons VrtEggs NLst))
									(setq	NLst		(list VrtEggs))
								)
							)
							((= (car (nth Cnt PLst)) 40)
								(if Bug (princ (strcat "\n[Bug] Got 40 Group on {" (itoa Cnt) "}")))
								(setq	Vrt40	(nth Cnt PLst))
							)
							((= (car (nth Cnt PLst)) 41)
								(if Bug (princ (strcat "\n[Bug] Got 41 Group on {" (itoa Cnt) "}")))
								(setq	Vrt41	(nth Cnt PLst))
							)
							((= (car (nth Cnt PLst)) 42)
								(if Bug (princ (strcat "\n[Bug] Got 42 Group on {" (itoa Cnt) "}")))
								(setq	Vrt42	(nth Cnt PLst))
							)
							((= (car (nth Cnt PLst)) 70)
								(if Bug (princ (strcat "\n[Bug] Got 70 Group on {" (itoa Cnt) "}")))
								(setq	Vrt70	(nth Cnt PLst))
							)
							((= (car (nth Cnt PLst)) 50)
								(if Bug (princ (strcat "\n[Bug] Got 50 Group on {" (itoa Cnt) "}")))
								(setq	Vrt50	(nth Cnt PLst))
							)
							((= (car (nth Cnt PLst)) 210)
								(if Bug (princ (strcat "\n[Bug] Got 210 Group on {" (itoa Cnt) "}")))
								(setq	VrtEggs	(list	Vrt0
														Vrt8
														Vrt10
														(if Vrt40 Vrt40 (cons 40 0.0))
														(if Vrt41 Vrt41 (cons 41 0.0))
														(if Vrt42 Vrt42 (cons 42 0.0))
														(if Vrt70 Vrt70 (cons 70 0))
														(if Vrt50 Vrt50 (cons 50 0.0))
												)
										Vrt10	nil
										Vrt40	nil
										Vrt41	nil
										Vrt42	nil
										Vrt70	nil
										Vrt50	nil
								)
								(if NLst
									(setq	NLst		(cons VrtEggs NLst))
									(setq	NLst		(list VrtEggs))
								)
							)
						)
					)
				)
				(setq	NLst		(reverse NLst))
			)
		)
		(if (assoc 0 (nth 0 PLst))
			(if (= (cdr (assoc 0 (nth 0 PLst))) "POLYLINE")
				(setq	NLst		(cdr (reverse PLst))	; Remove the Header & Seqend
						NLst		(cdr (reverse NLst))
						Cnt		0
						Bubba	(if Bug (princ (strcat "\n[Bug:POLYLINE] total vertices=" (itoa (- (length PLst) 2)) ".")))
				)
			)
		)
	)
	(setq	Cnt		0
			Fuzz		0.01
			BFlg		T
	)
	(if NLst
		(setq	BlgLst		(mapcar	(quote	(lambda (x)
												(if (assoc 42 x)
													(if (equal (cdr (assoc 42 x)) 0.0 Fuzz)
														0.0
														(cdr (assoc 42 x))
													)
													0.0
												)
											)
									)
									NLst
							)
		)
	)
	(if BlgLst
		(mapcar	(quote	(lambda (x)
							(if BFlg
								(if (not (equal x 0.0 Fuzz))
									(setq	BFlg		nil)
								)
							)
						)
				)
				BlgLst
		)
	)
	(if RevAct								; If you need to Reverse it...
		(if BFlg								; If there are no Bulges...
			(setq	Bubba	(if Bug (princ "\nNo Bulges!"))
					NLst		(reverse NLst)
			)
			(setq	Bubba	(if Bug (princ "\nBulges!"))
					NLst		(RevBlgLst NLst)
			)
		)
		(if Bug (princ "\nNo Reverse Order Flag!"))
	)
	(if Bug (princ "\nStpVrtLst exited}"))
	NLst
)

(defun Time_S ( / Tf h ampm )				; Legacy Code, Time String
	(setq Tf (rtos (getvar "CDATE") 2 6)
		 h  (atoi (substr Tf 10 2))
	)
	(if (= h 0)
		(setq ampm "am"
			 h	 (itoa (+ h 12))
		)
		(if (< h 12)
			(setq ampm "am"
				 h	 (itoa h)
			)
			(if (= h 12)
				(setq ampm "pm"
					 h	 (itoa h)
				)
				(if (> h 12)
					(setq ampm "pm"
						 h	 (itoa (- h 12))
					)
				)
			)
		)
	)
	(strcat h ":" (if (= (substr Tf 12 2) "60") "00" (substr Tf 12 2)) ":" (if (= (substr Tf 14 2) "60") "00" (substr Tf 14 2)) ampm)
)

(defun Twaddle ( NumB NumG /	Work Wudat )		; Progress Bar
	(setq	Work		(* (/ (float NumB) (float NumG)) 100.0)
			Wudat	(rtos Work 2 0)
	)
	(if (> (strlen Wudat) 2)
		(setq	Wudat	"99")
		(if (< (strlen Wudat) 2)
			(setq	Wudat	(strcat "0" Wudat))
		)
	)
	(if (equal NumB 0.0 0.0001)
		(princ (strcat "\nWorking...00%"))
		(if (> NumB 0)
			(princ	(strcat	"\010\010\010" Wudat "%"))         ; \010 is octal code for backspace (so three backspaces - karl)
			(princ "\010\010\010Complete!")
		)
	)
)

(defun Twizzle ( NumB / Work )				; Displays "Twirling" Progress Character
	(setq	Work	(Mod NumB 8))
	(if (zerop NumB)
		(princ (strcat "\nWorking...*"))
		(if (> NumB 0)
			(cond
				((= Work 0)(princ "\010/"))
				((= Work 1)(princ "\010-"))
				((= Work 2)(princ "\010\\"))
				((= Work 3)(princ "\010|"))
				((= Work 4)(princ "\010/"))
				((= Work 5)(princ "\010-"))
				((= Work 6)(princ "\010\\"))
				((= Work 7)(princ "\010|"))
			)
			(princ "\010Complete!")
		)
	)
)

(defun PLDistL ( plname /	vtxnam vtxlst		; Returns straight-line length of PolyLines and Extents
						vn_tmp vl_tmp vtxsum lx ly ux uy )
	(if Bug (princ "\n{PLDist entered\n"))
	(setq	VTXSUM	0
			VTXNAM	(entnext PLNAME)
			VTXLST	(entget VTXNAM)
			LX		(fix (cadr (assoc 10 VtxLST)))
			UX		(fix (cadr (assoc 10 VtxLST)))
			LY		(fix (caddr (assoc 10 VtxLST)))
			UY		(fix (caddr (assoc 10 VtxLST)))
	)
	(while (/= (cdr (assoc 0 VTXLST)) "SEQEND")
		(setq	VN_TMP	VTXNAM
				VL_TMP	VTXLST
				VTXNAM	(entnext VTXNAM)
				VTXLST	(entget VTXNAM)
		)
		(if (= (cdr (assoc 0 VTXLST)) "VERTEX")
			(setq	VTXSUM	(+ VTXSUM (distance (cdr (assoc 10 VL_TMP)) (cdr (assoc 10 VTXLST))))
					LX		(min LX (fix (cadr (assoc 10 VtxLST))))
					LY		(min LY (fix (caddr (assoc 10 VtxLST))))
					UX		(max UX (fix (cadr (assoc 10 VtxLST))))
					UY		(max UY (fix (caddr (assoc 10 VtxLST))))
			)
		)
	)
	(if Bug (princ "\nPLDist exited}\n"))
	(list VTXSUM LX LY UX UY)
)

(defun LWDistL ( PLNAME / )					; Returns straight-line length of LwPolyLines and Extents
		; PLLIST PTSLST L LWLEN C LX LY UX UY 
	(if Bug (princ "\n{LWDist entered\n"))
	(setq	PLLIST	(entget PLNAME)
			PTSLST	(list)
	)
	(foreach L PLLIST
		(if (= (car L) 10)
			(setq	PTSLST	(append PTSLST (list (cdr L))))
		)
	)
	(setq	LWLEN	0
			LX		9999999.0
			UX		0.0
			LY		9999999.0
			UY		0.0
			C		0
	)
	(repeat (length PTSLST)
		(if (< (1+ c) (length PTSLST))
			(setq	LWLEN	(+ LWLEN (distance (nth C PTSLST) (nth (1+ C) PTSLST))))
		)
		(setq	LX		(min LX (fix (car (nth c PTSLST))))
				LY		(min LY (fix (cadr (nth c PTSLST))))
				UX		(max UX (fix (car (nth c PTSLST))))
				UY		(max UY (fix (cadr (nth c PTSLST))))
				c		(1+ c)
		)
	)
	(if Bug (princ "\nLWDist exited}\n"))
	(list LWLEN LX LY UX UY)
)

(defun ChangeAns ( / dcl_fl dcl_id Ans )		; Used by open, new and validate user input
	(if Bug (princ "\n{ChangeAns Entered"))
	(if (setq dcl_fl (findfile "Utils.Dcl"))
		(if (> (setq dcl_id (load_dialog dcl_fl)) 0)
			(progn
				(if (new_dialog "ChgUnits" dcl_id)
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
	(if Bug (princ "\nChangeAns Exited}\n"))
	ans
)

(defun Mt2Ft ( Chz /	Ans )				; Converts from Meters to Feet
	(if (not Chz)
		(if (>= (setq Ans (ChangeAns)) 2)
			(if (= Ans 3)
				(progn
					(setq	Chz	T)
					(exit)
				)
				(exit)
			)
		)
	)
	(cond
		(Chz
			(command "_.Layer" "T" "*" "U" "*" "ON" "*" "S" "0" "" "_.Zoom" "E")
			(setq	ssEverybody	(ssget "X"	(list	(cons -4 "<OR")
														(cons -4 "<NOT")
															(cons 0 "INSERT")
														(cons -4 "NOT>")
														(cons -4 "<AND")
															(cons 0 "INSERT")
															(cons -4 "<NOT")
																(cons -4 "<OR")
																	(cons 2 "LEGEND")
																	(cons 2 "[ABCDEFX]SHEET")
																(cons -4 "OR>")
															(cons -4 "NOT>")
														(cons -4 "AND>")
													(cons -4 "OR>")
											)
								)
					cPnt			(getvar "VIEWCTR")
			)
			(if ssEverybody
				(command "_.Scale" ssEverybody "" cPnt (/ 1.0 0.3048) "_.Zoom" "E")
			)
		)
	)
	(princ)
)

(defun Ft2Mt ( Chz /	Ans )				; Converts from Feet to Meters
	(if (not Chz)
		(if (>= (setq Ans (ChangeAns)) 2)
			(if (= Ans 3)
				(progn
					(setq	Chz	T)
					(exit)
				)
				(exit)
			)
		)
	)
	(cond
		(Chz
			(command "_.Layer" "T" "*" "U" "*" "ON" "*" "S" "0" "" "_.Zoom" "E")
			(setq	ssEverybody	(ssget "X"	(list	(cons -4 "<OR")
														(cons -4 "<NOT")
															(cons 0 "INSERT")
														(cons -4 "NOT>")
														(cons -4 "<AND")
															(cons 0 "INSERT")
															(cons -4 "<NOT")
																(cons -4 "<OR")
																	(cons 2 "LEGEND")
																	(cons 2 "[ABCDEFX]SHEET")
																(cons -4 "OR>")
															(cons -4 "NOT>")
														(cons -4 "AND>")
													(cons -4 "OR>")
											)
								)
					cPnt			(getvar "VIEWCTR")
			)
			(if ssEverybody
				(command "_.Scale" ssEverybody "" cPnt 0.3048 "_.Zoom" "E")
			)
		)
	)
	(princ)
)

(defun StpBadChar ( InStr Opt /	OutStr		; Utility to strip bad characters
							BgLst SmLst WrkLst )
	(if Bug (princ "\n{StpBadChar entered"))
	(if (and Bug InStr)
		(princ (strcat "\nInStr:{" InStr "}"))
	)
	(setq	BgLst	(list	(chr 34)	;double-quote "
							(chr 39)	;single-quote '
							(chr 96)	;reverse-single-quote `
							(chr 10)	;return
							(chr 37)	;percent %
							(chr 63)	;question mark ?
							(chr 64)	;at sign @
							(chr 47)	;forward slash /
							(chr 92)	;backward slash \
							(chr 35)	;pound sign #
							(chr 41)	;Right paren )
							(chr 40)	;Left paren (
							(chr 42)	;asterisk *
							(chr 43)	;plus sign +
							(chr 45)	;dash -
							(chr 46)	;period .
							(chr 44)	;comma ,
					)
			SmLst	(list	(chr 34)	;double-quote "
							(chr 39)	;single-quote '
							(chr 96)	;reverse-single-quote `
							(chr 64)	;at sign @
							(chr 10)	;return
					)
			;	Wild-Card Character used in wcmatch
			WcLst	(list	(chr 35) ;pound sign #
							(chr 64)	;at sign @
							(chr 46)	;period .
							(chr 42)	;asterisk *
							(chr 63)	;question mark ?
							(chr 126)	;Tide ~
							(chr 91)	;Left Square Bracket [
							(chr 93)	;Right Square Bracket [
							(chr 45)	;dash -
							(chr 44)	;comma ,
							(chr 96)	;reverse quote `
					)
	)
	(if Opt
		(cond	((= Opt 1)
					(setq	WrkLst	BgLst)
				)
				((= Opt 2)
					(setq	WrkLst	SmLst)
				)
				((= Opt 3)
					(setq	WrkLst	WcLst)
				)
				(T
					(setq	WrkLst	nil)
				)
		)
		(setq	WrkLst	nil)
	)
	(if WrkLst
		(while InStr
			(if (not (member (substr InStr 1 1) WrkLst))
				(if OutStr
					(setq	OutStr	(strcat OutStr (substr InStr 1 1)))
					(setq	OutStr	(substr InStr 1 1))
				)
			)
			(if (> (strlen InStr) 1)
				(setq	InStr	(substr InStr 2))
				(setq	InStr	nil)
			)
		)
	)
	(if (not OutStr)
		(setq	OutStr	"")
	)
	(if (and Bug OutStr)
		(princ (strcat "\nOutStr:{" OutStr "}"))
	)
	(if Bug (princ "\nStpBadChar exited}\n"))
	OutStr
)

(defun LayWhat ( /	x LayLst LayItm Bubba		; Returns 2 lists: VisLayLst & NoVisLayLst
				CvP VpD VpDe VpDL VpD_NV VisLayLst NoVisLayLst )
	(setq	LayItm		(tblnext "LAYER" T)
			LayLst		(list LayItm)
	)
	(while (setq LayItm (tblnext "LAYER"))
		(if LayItm
			(setq	LayLst	(cons	LayItm
									LayLst
							)
			)
		)
	)
	
	(if (= (getvar "TILEMODE") 0)
		(if (> (setq CvP (getvar "CVPORT")) 1)
			(setq	VpD		(ssget "X"	(list	(cons 0 "VIEWPORT")
												(cons 67 1)
												(cons 69 CvP)
										)
							)
					Bubba	(princ (strcat "\nWorking Viewport {" (itoa CvP) "}\n"))
			)
			(setq	VpD	nil)
		)
		(setq	VpD	nil)
	)
	(if VpD
		(setq	VpDe	(entget (ssname VpD 0) (list "*"))
				VpDL	(cdadr (assoc -3 VpDe))
		)
		(setq	VpDe	nil
				VpDL	nil
		)
	)
	(if VpDL
		(mapcar	(quote	(lambda (x)
							(if (= (car x) 1003)
								(if VpD_NV
									(setq	VpD_NV	(cons (cdr x) VpD_NV))
									(setq	VpD_NV	(list (cdr x)))
								)
							)
						)
				)
				VpDL
		)
	)
	(if Bug
		(if VpD_NV
			(mapcar	(quote	(lambda (x)
								(if	(and	(>= (cdr (assoc 62 x)) 0)
										(/= (boole 1 1 (cdr (assoc 70 x))) 1)
									)
									(if (member (cdr (assoc 2 x)) VpD_NV)
										(princ (strcat "\nBug: Layer {" (cdr (assoc 2 x)) "} should not be visible."))
										(princ (strcat "\nBug: Layer {" (cdr (assoc 2 x)) "} should be visible."))
									)
								)
							)
					)
					LayLst
			)
		)
	)
	(if VpD_NV
		(mapcar	(quote	(lambda (x)
							(if	(and	(>= (cdr (assoc 62 x)) 0)
									(/= (boole 1 1 (cdr (assoc 70 x))) 1)
								)
								(if (not (member (cdr (assoc 2 x)) VpD_NV))
									(if VisLayLst
										(setq	VisLayLst		(cons (cons (cdr (assoc 2 x)) (cdr (assoc 62 x))) VisLayLst))
										(setq	VisLayLst		(list (cons (cdr (assoc 2 x)) (cdr (assoc 62 x)))))
									)
								)
							)
						)
				)
				LayLst
		)
		(mapcar	(quote	(lambda (x)
							(if	(and	(>= (cdr (assoc 62 x)) 0)
									(/= (boole 1 1 (cdr (assoc 70 x))) 1)
								)
								(if VisLayLst
									(setq	VisLayLst		(cons (cons (cdr (assoc 2 x)) (cdr (assoc 62 x))) VisLayLst))
									(setq	VisLayLst		(list (cons (cdr (assoc 2 x)) (cdr (assoc 62 x)))))
								)
							)
						)
				)
				LayLst
		)
	)
	(if VpD_NV
		(mapcar	(quote	(lambda (x)
							(if	(or	(< (cdr (assoc 62 x)) 0)
									(= (boole 1 1 (cdr (assoc 70 x))) 1)
									(member (cdr (assoc 2 x)) VpD_NV)
								)
								(if NoVisLayLst
									(setq	NoVisLayLst	(cons (cons (cdr (assoc 2 x)) (NoVisCalc (cdr (assoc 70 x)) (cdr (assoc 62 x)))) NoVisLayLst))
									(setq	NoVisLayLst	(list (cons (cdr (assoc 2 x)) (NoVisCalc (cdr (assoc 70 x)) (cdr (assoc 62 x))))))
								)
							)
						)
				)
				LayLst
		)
		(mapcar	(quote	(lambda (x)
							(if	(or	(< (cdr (assoc 62 x)) 0)
									(= (boole 1 1 (cdr (assoc 70 x))) 1)
								)
								(if NoVisLayLst
									(setq	NoVisLayLst	(cons (cons (cdr (assoc 2 x)) (NoVisCalc (cdr (assoc 70 x)) (cdr (assoc 62 x)))) NoVisLayLst))
									(setq	NoVisLayLst	(list (cons (cdr (assoc 2 x)) (NoVisCalc (cdr (assoc 70 x)) (cdr (assoc 62 x))))))
								)
							)
						)
				)
				LayLst
		)
	)
	(if (and VisLayLst NoVisLayLst)
		(princ (strcat "\nFound {" (itoa (length VisLayLst)) "} Visible Layers, and {" (itoa (length NoVisLayLst)) "} Non-Visible Layers."))
		(if VisLayLst
			(princ (strcat "\nFound {" (itoa (length VisLayLst)) "} Visible Layers."))
			(if NoVisLayLst
				(princ (strcat "\nFound {" (itoa (length NoVisLayLst)) "} Non-Visible Layers."))
				(princ (strcat "\nFound {0} Layers - That's not right!"))
			)
		)
	)
	(list VisLayLst NoVisLayLst CvP)
)

(defun NoVisCalc ( FlagNum ColNum /	OutNum )	; Function that determines Layer Visibility
	(setq	OutNum	-2000)
	(cond
		((= FlagNum 4)						;Layer Locked
			(setq	OutNum	-900)
			(if ColNum
				(if (numberp ColNum)
					(if (>= ColNum 0)
						(setq	OutNum	(+ (abs OutNum) ColNum))
						(setq	OutNum	(+ OutNum ColNum))
					)
					(setq	OutNum	-8888)
				)
				(setq	OutNum	-9999)
			)
		)
		((= FlagNum 2)						;Layer Frozen by Default in New Viewports
			(setq	OutNum	-600)
			(if ColNum
				(if (numberp ColNum)
					(if (>= ColNum 0)
						(setq	OutNum	(+ (abs OutNum) ColNum))
						(setq	OutNum	(+ OutNum ColNum))
					)
					(setq	OutNum	-8888)
				)
				(setq	OutNum	-9999)
			)
		)
		((= FlagNum 1)						;Layer Frozen
			(setq	OutNum	-300)
			(if ColNum
				(if (numberp ColNum)
					(if (>= ColNum 0)
						(setq	OutNum	ColNum)
						(setq	OutNum	(+ OutNum ColNum))
					)
					(setq	OutNum	-8888)
				)
				(setq	OutNum	-9999)
			)
		)
		((= FlagNum 0)						;No Flag Value
			(setq	OutNum	0)
			(if ColNum
				(if (numberp ColNum)
					(if (>= ColNum 0)
						(setq	OutNum	(+ (abs OutNum) ColNum))
						(setq	OutNum	(+ OutNum ColNum))
					)
					(setq	OutNum	-8888)
				)
				(setq	OutNum	-9999)
			)
		)
		(T
			(if ColNum
				(if (numberp ColNum)
					(if (>= ColNum 0)
						(setq	OutNum	(+ (abs OutNum) ColNum))
						(setq	OutNum	(+ OutNum ColNum))
					)
					(setq	OutNum	-8888)
				)
				(setq	OutNum	-9999)
			)
		)
	)
	OutNum
)

(defun eMillFmt ( esecs /	edys ehrs emins )	; Function to format elapsed time > one day
	(if (> esecs 59999.9)
		(setq	emins	(float (fix (/ esecs 60000.0)))
				esecs	(- esecs (* emins 60000.0))
		)
		(setq	emins	0.0)
	)
	(if (> emins 59.9)
		(setq	ehrs		(float (fix (/ emins 60.0)))
				emins	(- emins (* ehrs 60.0))
		)
		(setq	ehrs		0.0)
	)
	(if (> ehrs 23.9)
		(setq	edys		(float (fix (/ ehrs 24.0)))
				ehrs		(- ehrs (* edys 24.0))
		)
		(setq	edys		0.0)
	)
	(list edys ehrs emins esecs)
)

(defun C:NoSwp ( / )						; CL Function to swap Normal Open states
	(setq origError *error*)
	(setq *error* *custom_error*)
	(defun *custom_error* (msg)
		(princ "Custom error:")
		(princ msg)
		(setq *error* 	*origError*)
		(princ)
	)
	
	(if (setq ssI (ssget "I" (list (cons 0 "INSERT") (cons -4 "<OR") (cons 2 "A###") (cons 2 "A###S") (cons -4 "OR>"))))
		(setq	ssLen	(sslength ssI)
				Cntr		0
				Bubba	(princ (strcat "\nNoSwp found {" (itoa ssLen) "} items to swap states..."))
				Bubba	(while (< Cntr ssLen)
							(setq	Ent2		(entget (ssname ssI Cntr) (list "*"))
									PntA		(cdr (assoc 10 Ent2))
									Ent0		(cons (cdr (assoc -1 Ent2)) (list PntA))
									Bubba	(NOPop Ent0)
									Cntr		(1+ Cntr)
							)
						)
		)
		(progn
			(setq	Ent0		(entsel "\nSelect the Device to Swap States: "))
			(if Ent0
					(setq	Bubba	(NOPop Ent0)
							Bubba	(ChngUm nil (car Ent0))
					)
					(alert "Nothing Selected - try again but you need to re-enter the command.")
			)
		)
	)
	(princ)
)

(defun NOPop ( Ent0 /	Ent1 Ent_NO AtWas Bubba ); Swaps Adds & SubTools Symbols Normal state
	(if Ent0
		(setq	Pnt0		(cdr Ent0)
				Ent0		(car Ent0)
		)
		(setq	Ent0		nil)
	)
	(if Ent0
		(setq	Ent1		(entget Ent0 (list "*")))
		(setq	Ent1		nil)
	)
	(if Ent1
		(if (assoc (cdr (assoc 2 Ent1)) Lst_No_Dev)
			(setq	Ent_NO	(assoc (cdr (assoc 2 Ent1)) Lst_No_Dev))
			(setq	Ent_NO	nil)
		)
	)
	(if (and Ent1 Ent_NO)
		(if (BlkChk (cdr Ent_NO))
			(setq	Ent1		(subst (cons 2 (cdr Ent_NO)) (assoc 2 Ent1) Ent1)
					Bubba	(entmod Ent1)
			)
			(setq	AtWas	(getvar "ATTREQ")
					Bubba	(setvar "ATTREQ" 0)
					Bubba	(command "_.Insert" (strcat _Path-Sym (cdr Ent_NO)))
					Bubba	(command)
					Bubba	(setvar "ATTREQ" AtWas)
					Ent1		(subst (cons 2 (cdr Ent_NO)) (assoc 2 Ent1) Ent1)
					Bubba	(entmod Ent1)
			)
		)
	)
	(princ)
)

(defun BlkChk ( BlkT / TestR TestL )			; Tests for valid block
	(setq BlkT  (strcase BlkT)
		 TestR nil
		 TestL (strcase (cdr (assoc 2 (tblnext "BLOCK" T))))
	)
	(if (= TestL BlkT)
		(setq TestR T)
		(while (setq TestL (cdr (assoc 2 (tblnext "BLOCK"))))
			(if (wcmatch (strcase TestL) BlkT)
				(setq TestR T)
			)
		)
	)
	TestR
)

(defun ZeroLen ( /	PLSet Cnt MinLen ZeroLst		; ZeroLen() looks for Zero length plines
				PLName Ent0 ELen )
	(setq	PLSet	(ssget "X"	(list	(cons -4 "<OR")
											(cons 0 "POLYLINE")
											(cons 0 "LWPOLYLINE")
										(cons -4 "OR>")
								)
					)
			Cnt		0
			MinLen	0.5
			ZeroLst	(list)
	)
	(if PLSet
		(while (setq PLName (ssname PLSet Cnt))
			(setq	Ent0		(entget PLName (list "*"))
					ELen		(GetPLen Ent0)
			)
			(if	(<= ELen MinLen)
				(setq	ZeroLst	(cons PLName ZeroLst))
			)
			(setq	Cnt		(1+ Cnt))
		)
	)
	(if PLSet
		(setq	PLSet	nil)
	)
	(gc)
	ZeroLst
)

(defun ZeroKill ( /	PLSET Vtx1 Vtx2 cnt 	; ZeroKill kills Zero length plines
					NumOut Are0 PLNAME ZeroLst )
	(setq	ZeroLst	(ZeroLen))
	(if ZeroLst
		(if (> (length ZeroLst) 0)
			(progn
				(setq	PLSet	(ssadd))
				(mapcar (quote (lambda (x) (setq PLSet (ssadd x PLSet)))) ZeroLst)
			)
		)
	)
	(if (> (length ZeroLst) 0)
		(princ (strcat "\nZeroKill erases {" (itoa (length ZeroLst)) "} PolyLines!"))
	)
	(setq	Fnam		(open "FdrLenPh.TXT" "a")
			Dnam		(strcase (getvar "DWGNAME"))
			LayT		(cdr (assoc 8 Edat))
	)
	(if Dnam
		(if (> (strlen Dnam) 4)
			(if (= ".DWG" (substr Dnam (- (strlen Dnam) 3) 4))
				(setq	Dnam	(substr Dnam 1 (- (strlen Dnam) 4)))
			)
		)
		(setq	Dnam		(car PanLst))
	)

	(if	(and	(> (length ZeroLst) 0)
			(> (getvar "DWGTITLED") 0)
			EdsLocal
		)
		(if (setq	fn	(open "C:\\Adds\\ZeroKill.csv" "a"))
			(setq	Dnam		(strcase (getvar "DWGNAME"))
					Dnam		(if (> (strlen Dnam) 4)
								(if (= ".DWG" (substr Dnam (- (strlen Dnam) 3) 4))
									(substr Dnam 1 (- (strlen Dnam) 4))
									Dnam
								)
								Dnam
							)
					Bubba	(write-line (strcat "\"" Dnam "\"," (itoa (length ZeroLst))) fn)
					Bubba	(close fn)
			)
		)
	)
	(if	(and	(> (length ZeroLst) 0)
			(> (getvar "DWGTITLED") 0)
			EdsLocal
		)
		(if (setq	fn	(open "C:\\Adds\\ZeroKill.scr" "a"))
			(setq	Dnam		(strcase (getvar "DWGNAME"))
					Dnam		(if (> (strlen Dnam) 4)
								(if (= ".DWG" (substr Dnam (- (strlen Dnam) 3) 4))
									(substr Dnam 1 (- (strlen Dnam) 4))
									Dnam
								)
								Dnam
							)
					Bubba	(write-line (strcat "(GetPan \"" Dnam "\")") fn)
					Bubba	(write-line (strcat "(ZeroKill)") fn)
					Bubba	(write-line (strcat "(ChngUm nil nil)") fn)
					Bubba	(write-line (strcat "(if (member \"" Dnam "\" PanLst) (SavPan \"" Dnam "\" 4))") fn)
					Bubba	(close fn)
			)
		)
	)
	(if PLSet
		(command "_.Erase" PLSet "")
	)
	(if PLSet
		(setq	PLSet	nil)
	)
	(gc)
	(princ)
)

(defun FndEEDev ( Dev /	DevChz CCnt NoMatch		; Finds and displays items with AppID
					 CNam ETrg EDat )  ;ssDev
	(if Dev
		(setq	DevChz	(strcase (substr Dev 1 2))
				CCnt		0
				NoMatch	T
		)
		(setq	DevChz	nil)
	)
	
	(if DevChz
		(cond	((or (= DevChz "DS") (and (= (strcase(substr DevChz 1 1)) "S") (/= (substr Dev (- (strlen Dev) 1) 1) "~")) (= DevChz "D_")) ; [Modified for TRANS]
					(setq	ssDev	(ssget "X" (list (cons 0 "INSERT") (list -3 (list "ID"))))  )
					(if Bug (princ (strcat "\nBug:Symbol Choice [" Dev "] Checking [" (itoa (sslength ssDev)) "] pieces")))
					(if ssDev
						(while (and (setq CNam (ssname ssDev CCnt)) NoMatch)
							(if CNam
								(if	(wcmatch	(strcase (cdr (cadadr (assoc -3 (entget CNam (list "ID"))))))
											(strcase Dev)
									)
									(setq	ETrg	(cdr (assoc -1 (entget CNam))))
								)
							)
							(setq	CCnt	(1+ CCnt))
						)
					)
					(if ssDev
						(setq	ssDev	nil
								Bubba	(gc)
						)
					)
					(if ETrg
						(setq	EDat		(entget ETrg (list "*"))
								Bubba	(command "_.Zoom" "C" (cdr (assoc 10 EDat)) (* 5.0 (cdr (assoc 41 EDat))))
								Bubba	(redraw ETrg 3)
								Bubba	(princ (strcat "\nFindEED Found the target insert, handle[" (cdr (assoc 5 EDat)) "]!"))
						)
						(princ "\nFindEED did not find the target insert!")
					)
				)
				((or (= DevChz "DP") (= (substr DevChz 1 1) "L") (= DevChz "P_"))
					(setq	ssDev	(ssget "X" (list (cons 0 "POLYLINE") (list -3 (list "ID")))))
					(if Bug (princ (strcat "\nBug:PLine Choice [" Dev "] Checking [" (itoa (sslength ssDev)) "] pieces")))
					(if ssDev
						(while (and (setq CNam (ssname ssDev CCnt)) NoMatch)
							(if CNam
							
								(if	(wcmatch	(strcase (cdr (cadadr (assoc -3 (entget CNam (list "ID"))))))
											(strcase Dev)
									)
									(setq	ETrg	(cdr (assoc -1 (entget CNam))))
								)
							)
							(setq	CCnt	(1+ CCnt))
						)
					)
					(if ssDev
						(setq	ssDev	nil
								Bubba	(gc)
						)
					)
					(if ETrg
						(setq	PtLst	(GetPLEnd ETrg)
								Pt1		(nth 0 PtLst)
								Pt2		(nth 1 PtLst)
								EDat		(entget ETrg (list "*"))
								Bubba	(command "_.Zoom" "C"	(list	(+ (car Pt1) (/ (- (car Pt2) (car Pt1)) 2.0))
																	(+ (cadr Pt1) (/ (- (cadr Pt2) (cadr Pt1)) 2.0))
															)
															(* (if (zerop (distance Pt1 Pt2)) 50.0 (distance Pt1 Pt2)) 2.0)
										)
								Bubba	(redraw ETrg 3)
								Bubba	(if (zerop (distance Pt1 Pt2))
											(princ (strcat "\nFindEED Found the [*Zero Length*] target polyline, handle[" (cdr (assoc 5 EDat)) "], erasing!"))
											(princ (strcat "\nFindEED Found the target polyline, handle[" (cdr (assoc 5 EDat)) "]!"))
										)
								Bubba	(if (zerop (distance Pt1 Pt2)) (command "_.Erase" ETrg ""))
						)
						(princ "\nFindEED did not find the target polyline!")
					)
				)
				((or (= DevChz "DT") (= (substr DevChz 1 1) "T") (and (= (substr DevChz 1 1) "S") (= (substr Dev (- (strlen Dev) 1) 1) "~")))
					(setq	ssDev	(ssget "X" (list (cons 0 "TEXT") (list -3 (list "ID")))))
					(if Bug (princ (strcat "\nBug:Text Choice [" Dev "] Checking [" (itoa (sslength ssDev)) "] pieces")))
					(if ssDev
						(while (and (setq CNam (ssname ssDev CCnt)) NoMatch)
							(if CNam
								(if	(wcmatch	(strcase (cdr (cadadr (assoc -3 (entget CNam (list "ID"))))))
											(strcase Dev)
									)
									(setq	ETrg	(cdr (assoc -1 (entget CNam))))
								)
							)
							(setq	CCnt	(1+ CCnt))
						)
					)
					(if ssDev
						(setq	ssDev	nil
								Bubba	(gc)
						)
					)
					(if ETrg
						(setq	EDat		(entget ETrg (list "*"))
								Bubba	(command "_.Zoom" "C" (cdr (assoc 10 EDat)) (* 5.0 (cdr (assoc 40 EDat))))
								Bubba	(redraw ETrg 3)
								Bubba	(princ (strcat "\nFindEED Found the target text, handle[" (cdr (assoc 5 EDat)) "]!"))
						)
						(princ "\nFindEED did not find the target text!")
					)
				)
		)
	)
	ETrg
)

(defun C:FindEED ( /	AttWas				; Finds Text, Polyline or Insert with the ID given
					BlpWas CmdWas ColWas EchWas ExWas FilWas LayWas LtWas OsWas TmdWas FndStr )
	(if Bug (princ "\n{ C:FindEED entered}\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			CmdWas	(getvar "CMDDIA")
			ColWas	(getvar "CECOLOR")
			EchWas	(getvar "CMDECHO")
			ExWas	(getvar "EXPERT")
			FilWas	(getvar "FILEDIA")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			TmdWas	(getvar "TILEMODE")
	)
	
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
		)
	)
	(command "_.UNDO" "_BE")
	
	;(command "_.Layer" "T" "*" "U" "*" "ON" "*" "S" "0" "" "_.Zoom" "E")
	(setq	FndStr	(getstring "\nEnter the Unique ID you are searching for: "))
	(if FndStr
		(FndEEDev FndStr)
	)
	
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CMDECHO" EchWas)
	(setvar "EXPERT" ExWas)
	(setvar "FILEDIA" FilWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "TILEMODE" TmdWas)
	(if Bug (princ "\n{ C:FindEED exited}\n"))
	(princ)
)

(defun BldMstPntLst ( Ent0 /	Cnt PtLst			; Build Master Point List
						MPtLst NumLst Numb )
	(if Bug (princ "\n{ BldMstPntLst entered}\n"))
	(if Ent0
		(if (= (type Ent0) (quote ENAME))
			(setq	Ent0	(entget Ent0 (list "*")))
		)
		(setq	Ent0	(entget (car (entsel "\nSelect Object to Build:")) (list "*")))
	)
	(setq	Cnt		0
			PtLst	nil
			MPtLst	nil
			NumLst	nil
			Numb		nil
	)
	(cond
		((= (cdr (assoc 0 Ent0)) "POLYLINE")
			(setq	Ent1	(cdr (assoc -1 Ent0)))
			(while (= (cdr (assoc 0 (entget (setq Ent1 (entnext Ent1)) (list "*")))) "VERTEX")
				(if (= (cdr (assoc 0 (entget Ent1 (list "*")))) "VERTEX")
					(if MPtLst
						(setq	Cnt		(1+ Cnt)
								PtLst	(list	Cnt
												(cadr (assoc 10 (entget Ent1)))
												(caddr (assoc 10 (entget Ent1)))
												(cdr (assoc 40 (entget Ent1)))
												(cdr (assoc 41 (entget Ent1)))
												(cdr (assoc 42 (entget Ent1)))
										)
								MPtLst	(append MPtLst (list PtLst))
						)
						(setq	Cnt		(1+ Cnt)
								PtLst	(list	Cnt
												(cadr (assoc 10 (entget Ent1)))
												(caddr (assoc 10 (entget Ent1)))
												(cdr (assoc 40 (entget Ent1)))
												(cdr (assoc 41 (entget Ent1)))
												(cdr (assoc 42 (entget Ent1)))
										)
								MPtLst	(list PtLst)
						)
					)
				)
			)
		)
		((= (cdr (assoc 0 Ent0)) "LWPOLYLINE")
			(while (< Cnt (length Ent0))				; step thru incoming data list
				(if (= (car (nth Cnt Ent0)) 10)		; if its a point element
					(if MPtLst					; generate Master Point List, with Line Segment Number + PointX + PointY
						(setq PtLst  (list Cnt
									    (nth 1 (nth Cnt Ent0))
									    (nth 2 (nth Cnt Ent0))
								   )
							 MPtLst (append MPtLst (list PtLst))
							 Numb   Cnt
							 NumLst (append NumLst (list Numb))
						)
						(setq PtLst  (list Cnt
									    (nth 1 (nth Cnt Ent0))
									    (nth 2 (nth Cnt Ent0))
								   )
							 MPtLst (list PtLst)
							 Numb   Cnt
							 NumLst (list Numb)
						)
					)
				)
				(if (= (car (nth Cnt Ent0)) 40) ; if its a st_width element
					(if (member Numb NumLst) ; if its line segment is listed
						(if (= (length (assoc Numb MPtLst)) 3) ; if its st_width is missing
							(setq PtLst  (append (assoc Numb MPtLst)
											 (list (cdr (nth Cnt Ent0)))
									   )
								 MPtLst (subst	PtLst
											(assoc Numb MPtLst)
											MPtLst
									   )
							)
						)
					)
				)
				(if (= (car (nth Cnt Ent0)) 41) ; if its a end_width element
					(if (member Numb NumLst) ; if its line segment is listed
						(if (= (length (assoc Numb MPtLst)) 4) ; if its end_width is missing
							(setq PtLst  (append (assoc Numb MPtLst)
											 (list (cdr (nth Cnt Ent0)))
									   )
								 MPtLst (subst	PtLst
											(assoc Numb MPtLst)
											MPtLst
									   )
							)
						)
					)
				)
				(if (= (car (nth Cnt Ent0)) 42) ; if its a bulge data element
					(if (member Numb NumLst) ; if its line segment is listed
						(if (= (length (assoc Numb MPtLst)) 5) ; if its bulge data is missing
							(setq PtLst  (append (assoc Numb MPtLst)
											 (list (cdr (nth Cnt Ent0)))
									   )
								 MPtLst (subst	PtLst
											(assoc Numb MPtLst)
											MPtLst
									   )
							)
						)
					)
				)
				(setq Cnt (1+ Cnt))
			)
		)
	)
	(if Bug (princ "\n{ BldMstPntLst exited}\n"))
	MPtLst
)

(defun CalcBlgDat ( Vpt1 Vpt2 Blg1 /	Ang1 Ang2	; Calculates Bulge Data
								Ang3 Dst1 Cpt1 Ang4 Dst2 Ang5 )
	(cond	((equal Blg1 1.0 0.001)
				(setq	Ang1		(angle Vpt1 Vpt2)
						Dst1		(distance Vpt1 Vpt2)
						Cpt1		(polar Vpt1 Ang1 (/ Dst1 2.0))
						Ang4		(angle Cpt1 Vpt1)
						Dst2		(distance Cpt1 Vpt1)
						Ang5		(angle Cpt1 Vpt2)
						Dst1 	(* 2.0 (abs (* (distance Vpt1 Vpt2) (/ 1.0 (atan Blg1)))))
						Ang2		(angle Vpt1 Cpt1)
						Ang3		(angle Vpt2 Cpt1)
				)
			)
			((equal Blg1 -1.0 0.001)
				(setq	Ang1		(angle Vpt1 Vpt2)
						Dst1		(distance Vpt1 Vpt2)
						Cpt1		(polar Vpt1 Ang1 (/ Dst1 2.0))
						Ang4		(angle Cpt1 Vpt1)
						Dst2		(distance Cpt1 Vpt1)
						Ang5		(angle Cpt1 Vpt2)
						Dst1 	(* 2.0 (abs (* (distance Vpt1 Vpt2) (/ 1.0 (atan Blg1)))))
						Ang2		(angle Vpt1 Cpt1)
						Ang3		(angle Vpt2 Cpt1)
				)
			)
			(T
				(setq	Ang1		(angle Vpt1 Vpt2)
						Ang2		(if (> Blg1 0.0)
									(- (+ Ang1 (/ pi 2.0)) (* 2.0 (atan Blg1)))
									(+ (- Ang1 (/ pi 2.0)) (* 2.0 (atan Blg1)))
								)
						Ang3 	(if (> Blg1 0.0)
									(+ (+ Ang1 (/ pi 2.0)) (* 2.0 (atan Blg1)))
									(- (- Ang1 (/ pi 2.0)) (* 2.0 (atan Blg1)))
								)
						Dst1 	(* 2.0 (abs (* (distance Vpt1 Vpt2) (/ 1.0 (atan Blg1)))))
						Cpt1		(if (> Blg1 0.0)
									(inters	Vpt1
											(polar Vpt1 Ang2 Dst1)
											Vpt2
											(polar Vpt2 Ang3 Dst1)
											T
									)
									(inters	Vpt1
											(polar Vpt1 Ang3 Dst1)
											Vpt2
											(polar Vpt2 Ang2 Dst1)
											T
									)
								)
				)
				(if Cpt1
					(if (> Blg1 0.0)
						(setq	Ang4		(angle Cpt1 Vpt1)
								Dst2		(distance Cpt1 Vpt1)
								Ang5		(angle Cpt1 Vpt2)
						)
						(setq	Ang4		(angle Cpt1 Vpt2)
								Dst2		(distance Cpt1 Vpt1)
								Ang5		(angle Cpt1 Vpt1)
						)
					)
				)
			)
	)
	(list Dst2 Ang4 Ang5 Cpt1 Vpt1 Vpt2 Blg1 Ang1 Ang2 Ang3 Dst1)
)

(defun Up2Spac ( InStr / )					; Cnt StLen Fnd1 Fnd2 OutStr
	(setq	StLen	(strlen InStr)
			Fnd1		nil
			Fnd2		nil
			Cnt		1
			OutStr	nil
	)
	(if (and Bug InStr)
		(princ (strcat "\nInStr:{" InStr "}"))
	)
	(if (= (substr InStr 1 1) (chr 32))
		(while (and (< Cnt StLen) (not Fnd1))
			(if (/= (substr InStr Cnt 1) (chr 32))
				(setq	Fnd1		Cnt)
			)
			(setq	Cnt	(1+ Cnt))
		)
	)
	(if (and Bug Fnd1)
		(princ (strcat "\nFound1:" (itoa Fnd1) "\n"))
	)
	(if Fnd1
		(setq	Cnt		(1+ Fnd1))
	)
	(if (/= (substr InStr Cnt 1) (chr 32))
		(while (and (< Cnt StLen) (not Fnd2))
			(if (= (substr InStr Cnt 1) (chr 32))
				(setq	Fnd2		Cnt)
			)
			(setq	Cnt	(1+ Cnt))
		)
	)
	(if (and Bug Fnd2)
		(princ (strcat "\nFound2:" (itoa Fnd2) "\n"))
	)
	(cond
		((and Fnd1 Fnd2)
			(setq	OutStr	(substr InStr Fnd1 (- Fnd2 Fnd1)))
		)
		(Fnd1
			(setq	OutStr	(substr InStr Fnd1))
		)
		(Fnd2
			(setq	OutStr	(substr InStr 1 (1- Fnd2)))
		)
		(T
			(setq	OutStr	"")
		)
	)
)

(defun C:PanID ( /	AttWas					; CL Returns Panel Name from Pan_ID
					BlpWas CmdWas ColWas EchWas ExWas FilWas LayWas LtWas OsWas TmdWas )
	(if Bug (princ "\n{ C:PanID entered}\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			CmdWas	(getvar "CMDDIA")
			ColWas	(getvar "CECOLOR")
			EchWas	(getvar "CMDECHO")
			ExWas	(getvar "EXPERT")
			FilWas	(getvar "FILEDIA")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			TmdWas	(getvar "TILEMODE")
	)
	
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
		)
	)
	(command "_.UNDO" "_BE")
	(if Lst_Pan_ID
		(setq	Pan_ID	(getreal "\nWhat Pan_ID do you want to lookup?: "))
	)
	(if Pan_ID
		(setq	Pan_ID	(fix Pan_ID))
	)
	(if Pan_ID
		(setq	PanWhat	(PanNam_from_ID Pan_ID))
	)
	(if PanWhat
		(princ (strcat "\nFound Panel {" PanWhat "} with Pan_ID {" (itoa Pan_ID) "}"))
		(princ (strcat "\nNo Match found for {" (itoa Pan_ID) "}"))
	)
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CMDECHO" EchWas)
	(setvar "EXPERT" ExWas)
	(setvar "FILEDIA" FilWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "TILEMODE" TmdWas)
	(if Bug (princ "\n{ C:PanID exited}\n"))
	(princ)
)

(defun C:Pan_Nam ( /	AttWas				; CL Returns Pan_ID from Panel Name
					BlpWas CmdWas ColWas EchWas ExWas FilWas LayWas LtWas OsWas TmdWas )
	(if Bug (princ "\n{ C:Pan_Nam entered}\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			CmdWas	(getvar "CMDDIA")
			ColWas	(getvar "CECOLOR")
			EchWas	(getvar "CMDECHO")
			ExWas	(getvar "EXPERT")
			FilWas	(getvar "FILEDIA")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			TmdWas	(getvar "TILEMODE")
	)
	
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
		)
	)
	(command "_.UNDO" "_BE")
	(if Lst_Pan_ID
		(setq	Pan_Nam	(getstring "\nWhat Panel Name do you want to lookup?: "))
	)
	(if Pan_ID
		(setq	PanWhat	(PanID_from_Nam Pan_Nam))
	)
	(if PanWhat
		(princ (strcat "\nFound Panel {" Pan_Nam "} with Pan_ID {" (itoa PanWhat) "}"))
		(princ (strcat "\nNo Match found for {" Pan_Nam "}"))
	)
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CMDECHO" EchWas)
	(setvar "EXPERT" ExWas)
	(setvar "FILEDIA" FilWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "TILEMODE" TmdWas)
	(if Bug (princ "\n{ C:Pan_Nam exited}\n"))
	(princ)
)

(defun PanNam_from_ID ( Pan_ID / PanWhat )		; Returns Panel Name from Pan_ID
	(if Pan_ID
		(setq	Pan_ID	(fix Pan_ID))
	)
	(if (and Lst_Pan_ID Pan_ID)
		(if (assoc Pan_ID (mapcar (quote reverse) Lst_Pan_ID))
			(setq	PanWhat	(cadr (assoc Pan_ID (mapcar (quote reverse) Lst_Pan_ID))))
			(if (assoc (itoa Pan_ID) Lst_Pan_ID)
				(setq	PanWhat	(itoa (cadr (assoc (itoa Pan_ID) Lst_Pan_ID))))
			)
		)
	)
	PanWhat
)

(defun PanID_from_Nam ( Pan_Nam / PanWhat )		; Returns Pan_ID from Panel Name
	(if Pan_Nam
		(setq	Pan_Nam	(StpDot Pan_Nam))
	)
	(if (and Lst_Pan_ID Pan_Nam)
		(if (assoc Pan_Nam Lst_Pan_ID)
			(setq	PanWhat	(cadr (assoc Pan_Nam Lst_Pan_ID)))
		)
	)
	PanWhat
)

(defun addMyLayout ( CfgLst /	acadApp		; Adds PaperSpace Layouts
							acadDoc layouts objLayout layoutObj currPStyle currConfig currMedNam
							LOutNm StyNam CfgNam MedNam CntrPt PltTyp PapUnt PltRot PltScl
							currLayOut currCntrPt currPltTyp currPapUnt currPltRot currPltScl CanMedNamLst )
							
							(princ CfgLst)
	(vl-load-com)
	(setq	acadApp	(vlax-get-Acad-object)
			acadDoc	(vla-get-ActiveDocument acadApp)
			layouts	(vla-get-Layouts acadDoc)
			LOutNm	(nth 0 CfgLst)		;.Name				"Test"
			StyNam	(nth 1 CfgLst)		;.StyleSheet			"Acad.ctb"
			CfgNam	(nth 2 CfgLst)		;.ConfigName			"PublishToWeb DWF.pc3"
			MedNam	(nth 3 CfgLst)		;.CanonicalMediaName	"ANSI_expand_B_(11.00_x_17.00_Inches)"
			CntrPt	(nth 4 CfgLst)		;.CenterPlot			:vlax-true :vlax-false
			PltTyp	(nth 5 CfgLst)		;.PlotType			acDisplay=0 acExtents=1 acLimits=2 acView=3 acWindow=4 acLayout=5
			PapUnt	(nth 6 CfgLst)		;.PaperUnits			acInches=0 acMillimeters=1 acPixels=2
			PltRot	(nth 7 CfgLst)		;.PlotRotation			ac0degrees=0 ac90degrees=1 ac180degrees=2 ac270degrees=3
			PltScl	(nth 8 CfgLst)		;.StandardScale		acScaleToFit=0 ac1_1=16 ac1ft_1ft=15 ...
	)
	(vlax-for objLayout layouts
		(if (= (vla-get-name objLayout) LOutNm)
			(progn
				(if Bug (princ (strcat "\nDeleted Layout named " (vla-get-name objLayout) "...")))
				(vla-delete objLayout)
				(vlax-release-object objLayout)
			)
			(if Bug (princ (strcat "\nIgnored Layout named " (vla-get-name objLayout) "...")))
		)
	)
	(setq	layoutObj	(vla-add layouts LOutNm))
	(vla-put-StyleSheet layoutObj StyNam)				; Assign Grayscale.CTB to the Layout
	(vla-put-configname layoutObj CfgNam)				; Assign DWF configuration to the Layout 
	(setq	CanMedNamLst	(vlax-invoke layoutObj "GetCanonicalMediaNames"))
	(if MedNam									; Assign Paper Size to the Layout   
		(if (member MedNam CanMedNamLst)
			(vla-put-canonicalmedianame layoutObj MedNam)
			(progn
				(setq	MedSht	(strcase (substr MedNam 1 6))
						ShtFnd	nil
						LstLen	(length CanMedNamLst)
						CntR		0
				)
				(while (and (< CntR (1- LstLen)) (not ShtFnd))
					(if (and (= MedSht (strcase (substr (nth CntR CanMedNamLst) 1 6))) (not ShtFnd))
						(setq	Mednam	(nth CntR CanMedNamLst)
								ShtFnd	T
						)
					)
					(setq	CntR	(1+ CntR))
				)
				(if ShtFnd
					(vla-put-canonicalmedianame layoutObj MedNam)
				)
			)
		)
	)
	(if PltTyp
		(if (and (/= PltTyp 5) CntrPt)
			(progn
				(vla-put-PlotType layoutObj PltTyp)
				(if (= CntrPt 1)
					(vla-put-CenterPlot layoutObj :vlax-true)
					(vla-put-CenterPlot layoutObj :vlax-false)
				)
			)
			(vla-put-PlotType layoutObj PltTyp)
		)
	)
	(if PapUnt
		(vla-put-PaperUnits layoutObj PapUnt)
	)
	(if Bug (progn(princ "\nMyLayout PltRot = ")(prin1 PltRot) (princ "\n")))
	(if PltRot
		(vla-put-PlotRotation layoutObj PltRot)
	)
	(if PltScl
		(vla-put-StandardScale layoutObj PltScl)
	)
	(vla-put-activelayout acadDoc layoutObj)			; Make the new Layout Active
	(setq	currPStyle	(vla-Get-StyleSheet layoutObj)
			currConfig	(vla-Get-configname layoutObj)
			currMedNam	(vla-Get-canonicalmedianame layoutObj)
			currLayOut	(vla-get-name layoutObj)
	)
	(if (and layoutObj (null (vlax-object-released-p layoutObj)))
		(vlax-release-object layoutObj)
	)
	(if (and objLayout (null (vlax-object-released-p objLayout)))
		(vlax-release-object objLayout)
	)
	(if (and layouts (null (vlax-object-released-p layouts)))
		(vlax-release-object layouts)
	)
	(if (and acadDoc (null (vlax-object-released-p acadDoc)))
		(vlax-release-object acadDoc)
	)
	(if (and acadApp (null (vlax-object-released-p acadApp)))
		(vlax-release-object acadApp)
	)
	(setq	layoutObj	nil
			objLayout	nil
			layouts	nil
			acadDoc	nil
			acadApp	nil
	)
	(list currPStyle currConfig currMedNam currLayOut)
)

(defun GetCurrLayout ( /	acadApp			; Gets PaperSpace Layouts
						acadDoc objLayout layouts layoutObj currPStyle currConfig 
						currMedNam currLayOut currCntrPt currPltTyp currPapUnt currPltRot currPltScl )
	(vl-load-com)
	(setq	acadApp	(vlax-get-Acad-object)
			acadDoc	(vla-get-ActiveDocument acadApp)
			layouts	(vla-get-Layouts acadDoc)
	)
	(setq	layoutObj		(vla-Get-activelayout acadDoc))			; Check the Active Layout 
	(if layoutObj
		(setq	currPStyle	(vla-Get-StyleSheet layoutObj)
				currConfig	(vla-Get-configname layoutObj)
				currMedNam	(vla-Get-canonicalmedianame layoutObj)
				currLayOut	(vla-get-name layoutObj)
				currCntrPt	(vla-Get-CenterPlot layoutObj)
				currPltTyp	(vla-Get-PlotType layoutObj)
				currPapUnt	(vla-Get-PaperUnits layoutObj)
				currPltRot	(vla-Get-PlotRotation layoutObj)
				currPltScl	(vla-Get-StandardScale layoutObj)
		)
	)
	(if (and layoutObj (null (vlax-object-released-p layoutObj)))
		(vlax-release-object layoutObj)
	)
	(if (and layouts (null (vlax-object-released-p layouts)))
		(vlax-release-object layouts)
	)
	(if (and acadDoc (null (vlax-object-released-p acadDoc)))
		(vlax-release-object acadDoc)
	)
	(if (and acadApp (null (vlax-object-released-p acadApp)))
		(vlax-release-object acadApp)
	)
	(setq	layoutObj	nil
			layouts	nil
			acadDoc	nil
			acadApp	nil
	)
	(list currPStyle currConfig currMedNam currLayOut LayOutLst currCntrPt currPltTyp currPapUnt currPltRot currPltScl)
)

(defun SetCurrLayout ( LOutNm /	acadApp		; Sets PaperSpace Layouts
							acadDoc objLayout layouts layoutObj currPStyle currConfig currMedNam currLayOut )
	(vl-load-com)
	(setq	acadApp	(vlax-get-Acad-object)
			acadDoc	(vla-get-ActiveDocument acadApp)
			layouts	(vla-get-Layouts acadDoc)
	)
	(vlax-for objLayout layouts
		(if (= (vla-get-name objLayout) LOutNm)
			(setq	layoutObj	objLayout
					Bubba	(vla-put-activelayout acadDoc layoutObj)
			)
			(if Bug (princ (strcat "\nIgnored Layout named " (vla-get-name objLayout) "...")))
		)
	)
	(setq	currPStyle	(vla-Get-StyleSheet layoutObj)
			currConfig	(vla-Get-configname layoutObj)
			currMedNam	(vla-Get-canonicalmedianame layoutObj)
			currLayOut	(vla-get-name layoutObj)
			currPapSzX	0.0
			currPapSzY	0.0
			currPapMargLL	0.0
			currPapMargUR	0.0
	)
	(setq	Bubba	(vlax-invoke-method layoutObj "GetPaperSize" currPapSzX currPapSzY))
	(setq	Bubba	(vlax-invoke-method layoutObj "GetPaperMargins" currPapMargLL currPapMargUR))
	(if (and layoutObj (null (vlax-object-released-p layoutObj)))
		(vlax-release-object layoutObj)
	)
	(if (and layouts (null (vlax-object-released-p layouts)))
		(vlax-release-object layouts)
	)
	(if (and acadDoc (null (vlax-object-released-p acadDoc)))
		(vlax-release-object acadDoc)
	)
	(if (and acadApp (null (vlax-object-released-p acadApp)))
		(vlax-release-object acadApp)
	)
	(setq	layoutObj	nil
			layouts	nil
			acadDoc	nil
			acadApp	nil
	)
	(list currPStyle currConfig currMedNam currLayOut currPapSzX currPapSzY currPapMargLL currPapMargUR)
)

(defun DeleteLayout ( LOutNm /	acadApp		; Deletes PaperSpace Layouts
							acadDoc objLayout layouts layoutObj currPStyle currConfig currMedNam currLayOut )
	(vl-load-com)
	(setq	acadApp	(vlax-get-Acad-object)
			acadDoc	(vla-get-ActiveDocument acadApp)
			layouts	(vla-get-Layouts acadDoc)
	)
	(setq	layoutObj	(vla-Get-activelayout acadDoc))			; Check the Active Layout 
	(if (= (vla-get-name layoutObj) LOutNm)
		(SetCurrLayout "Model")
	)
	(if (/= (strcase LOutNm) "MODEL")
		(vlax-for objLayout layouts
			(if (= (vla-get-name objLayout) LOutNm)
				(progn
					(if Bug (princ (strcat "\nDeleted Layout named " (vla-get-name objLayout) "...")))
					(vla-delete objLayout)
					(vlax-release-object objLayout)
				)
				(if Bug (princ (strcat "\nIgnored Layout named " (vla-get-name objLayout) "...")))
			)
		)
		(alert (strcat "***" AppNam " Error***\nCannot delete Layout named \"Model\""))
	)
	(if (and objLayout (null (vlax-object-released-p objLayout)))
		(vlax-release-object objLayout)
	)
	(if (and layoutObj (null (vlax-object-released-p layoutObj)))
		(vlax-release-object layoutObj)
	)
	(if (and layouts (null (vlax-object-released-p layouts)))
		(vlax-release-object layouts)
	)
	(if (and acadDoc (null (vlax-object-released-p acadDoc)))
		(vlax-release-object acadDoc)
	)
	(if (and acadApp (null (vlax-object-released-p acadApp)))
		(vlax-release-object acadApp)
	)
	(setq	objLayout	nil
			layoutObj	nil
			layouts	nil
			acadDoc	nil
			acadApp	nil
	)
)

(defun GetLayoutNames ( /	acadApp			; Enumerates PaperSpace Layouts
						acadDoc objLayout layouts layoutObj objName objLst )
	(vl-load-com)
	(setq	acadApp	(vlax-get-Acad-object)
			acadDoc	(vla-get-ActiveDocument acadApp)
			layouts	(vla-get-Layouts acadDoc)
	)
	(vlax-for objLayout layouts
		(setq	objName	(vla-get-name objLayout))
		(if objLst
			(setq	objLst	(cons objName objLst))
			(setq	objLst	(list objName))
		)
	)
	(if (and objLayout (null (vlax-object-released-p objLayout)))
		(vlax-release-object objLayout)
	)
	(if (and layoutObj (null (vlax-object-released-p layoutObj)))
		(vlax-release-object layoutObj)
	)
	(if (and layouts (null (vlax-object-released-p layouts)))
		(vlax-release-object layouts)
	)
	(if (and acadDoc (null (vlax-object-released-p acadDoc)))
		(vlax-release-object acadDoc)
	)
	(if (and acadApp (null (vlax-object-released-p acadApp)))
		(vlax-release-object acadApp)
	)
	(setq	layoutObj	nil
			layouts	nil
			acadDoc	nil
			acadApp	nil
	)
	objLst
)

(defun C:MkC ( / EntOne Ent01)				; CL Make Construction
	(if Bug (princ "\n{ C:MkC entered\n"))
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
			(setvar "ATTREQ" 1)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
		)
	)
	(command "_.UNDO" "_BE")
	(if (not (LayChk "-20UCK-405"))
		(command	"_.Layer" "M" "-20UCK-405" "C" "5" "" "")
	)
	(princ "\nSelect item(s) to make on Construction Note layer: ")
	(setq	ssEnt01	(ssget))
	(if ssEnt01
		(setq	Cntr		0
				ssLen	(sslength ssEnt01)
		)
	)
	(while (< Cntr ssLen)
		(setq	Ent01	(entget (ssname ssEnt01 Cntr) (list "*")))
		(if (assoc 62 Ent01)
			(setq	Ent01	(subst (cons 8 "-20UCK-405") (assoc 8 Ent01) Ent01)
					Ent01	(subst (cons 62 256) (assoc 62 Ent01) Ent01)
					Bubba	(entmod Ent01)
			)
			(setq	Ent01	(subst (cons 8 "-20UCK-405") (assoc 8 Ent01) Ent01)
					Bubba	(entmod Ent01)
			)
		)
		(setq	Cntr	(1+ Cntr))
	)

	(command "_.UNDO" "_EN")
	(setvar "CECOLOR" ColWas)
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CELTYPE" LtWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CMDECHO" EchWas)
	(setvar "FILEDIA" FilWas)
	(setvar "OSMODE" OsWas)
	(if Bug (princ "\n C:MkC exited}\n"))
	(princ)
)

(defun ReSiz ( InSht / )					; Resizes to Sheet Size
	(command	"_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" ""
			"_.Zoom" "E" 
			"_.Zoom" "0.8x"
	)
	(if (assoc InSht LstShtSiz)
		(progn
			(setq	MinPt	(getvar "EXTMIN")
					MaxPt	(getvar "EXTMAX")
					LimX		(cadr (assoc InSht LstShtSiz))
					LimY		(caddr (assoc InSht LstShtSiz))
			)
			(if (not (equal MinPt (list 0.0 0.0) 0.1))
				(progn
					(command	"_.Move" "ALL" "" MinPt (list 0.0 0.0)
							"_.Zoom" "E" 
							"_.Zoom" "0.8x"
					)
					(setq	MinPt	(getvar "EXTMIN")
							MaxPt	(getvar "EXTMAX")
					)
					(if (not (equal MaxPt (cdr (assoc InSht LstShtSiz)) 1.1))
						(progn
							(if (<= (/ LimX (car MaxPt)) (/ LimY (cadr MaxPt)))
								(setq	ScVal	(/ LimX (car MaxPt)))
								(setq	ScVal	(/ LimY (cadr MaxPt)))
							)
							(command	"_.Scale" "ALL" "" MinPt ScVal
									"_.Zoom" "E" 
									"_.Zoom" "0.8x"
							)
							(setq	MinPt	(getvar "EXTMIN")
									MaxPt	(getvar "EXTMAX")
							)
						)
					)
				)
			)
			(if (not (LayChk "-20UCK-405"))
				(command	"_.Layer" "M" "-20UCK-405" "C" "5" "" "")
			)
			(command "_.PLine" "0,0" "W" "0.0" "0.0" (list LimX 0.0) (list LimX LimY) (list 0.0 LimY) "C")
		)
	)
)

(defun C:ReSiz ( / ShtSiz )					; CL Resizes to Sheet Size
	(if Bug (princ "\n{ C:ReSiz entered\n"))
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
			(setvar "ATTREQ" 1)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
			(setvar "REGENMODE" 1)
		)
	)
	(command "_.UNDO" "_BE")
	(initget 1 "A B C D E F")
	(setq	ShtSiz	(getkword "\nEnter the Sheet Size to match: "))
	(ReSiz ShtSiz)
	(command "_.UNDO" "_EN")
	(setvar "CECOLOR" ColWas)
	(setvar "ATTREQ" 1)
	(setvar "BLIPMODE" 1)
	(setvar "CELTYPE" "BYLAYER")
	(setvar "CMDDIA" 1)
	(setvar "CMDECHO" 0)
	(setvar "FILEDIA" 1)
	(setvar "OSMODE" 0)
	(if Bug (princ "\n C:ReSiz exited}\n"))
	(princ)
)

(defun C:DwfMak ( /	WellDid ViewD			; loads LayOus into Paperspace of drawing
				acadApp acadDoc Bubba LstDwfVal ShtNam ZTws ZPnt ZHgt ZMin ZMax )
	(if Bug (princ "\n C:DwfMak entered"))
	(vl-load-com)
	(setq	acadApp	(vlax-get-Acad-object)
			acadDoc	(vla-get-ActiveDocument acadApp)
			LstDwfVal		(list	(list	"WebDwf"					;ShtNam
										"A"						;PageSize
										"0"						;DView TWist
										(list 20.0 14.0)			;ViewCtr
										33.35					;ViewSize
										"0.05,0.15"				;ViewPort LL
										"9.5,7.9"					;ViewPort UR
										"Y"						;Hide Boundary
								)
						)
	)
	(if (and LimX LimY)
		(setq	LstDwfVal		(list	(RepLst (car LstDwfVal) (list (/ LimX 2.0) (/ LimY 2.0)) 3))
				LstDwfVal		(list	(RepLst (car LstDwfVal) (* 33.35 (/ LimY 14.0)) 4))
		)
	)
	(setq	ShtNam	"WebDwf"
			ZTws		(nth 2 (assoc ShtNam LstDwfVal))
			ZPnt		(nth 3 (assoc ShtNam LstDwfVal))
			ZHgt		(nth 4 (assoc ShtNam LstDwfVal))
			ZMin		(nth 5 (assoc ShtNam LstDwfVal))
			ZMax		(nth 6 (assoc ShtNam LstDwfVal))
	)
	(setq	WellDid	(addMyLayout (list ShtNam "Acad_2.ctb" "DWF6 ePlot.pc3" "ANSI_A_(8.50_x_11.00_Inches)" nil nil nil nil nil)))
	(if (not (LayChk "ViewPort"))
		(command	"_.Layer" "M" "ViewPort" "C" "6" "" "S" "ViewPort" "")
		(command	"_.Layer" "T" "ViewPort" "ON" "ViewPort" "U" "ViewPort" "S" "ViewPort" "")
	)
	(if ViewPorter
		(setq	ViewD	(ViewPorter))
	)
	(if ViewD
		(progn
			(command "_.Erase" (handent (car ViewD)) "")
			(command "_.MView" ZMin ZMax)
			(if (/= ZTws "0")
				(command "_.MSpace" "UcsIcon" "On" "_.DView" "" "TW" ZTws "" "_.Zoom" "E" "_.PSpace")
				(command "_.MSpace" "UcsIcon" "On" "_.Zoom" "E" "_.PSpace")
			)
			(command	"_.Layer" "T" "0" "U" "0" "On" "0" "S" "0" "")
		)
	)
	(if Mug
		(setq	acadPlot		(vla-get-Plot acadDoc)
				PlotFileOut	(strcat _Path-Plot (car PanLst) "-" ShtNam ".Dwf")
				Bubba		(vlax-invoke-method acadPlot "PlotToFile" PlotFileOut "DWF6 ePlot.pc3")
		)
	)
	(if (and acadPlot (null (vlax-object-released-p acadPlot)))
		(vlax-release-object acadPlot)
	)
	(if (and acadDoc (null (vlax-object-released-p acadDoc)))
		(vlax-release-object acadDoc)
	)
	(if (and acadApp (null (vlax-object-released-p acadApp)))
		(vlax-release-object acadApp)
	)
	(setq	acadPlot	nil
			acadDoc	nil
			acadApp	nil
	)
	(if Bug (princ "\n C:DwfMak exited"))
	(princ)
)

(defun OpnGis ( PntLst / PntA PntB )			; Function to Open Panels & GrDraw outline of coords...
	(if PntLst
		(setq	PntX1	(nth 0 PntLst)
				PntY1	(nth 1 PntLst)
				PntX2	(nth 2 PntLst)
				PntY2	(nth 3 PntLst)
		)
	)
	(if (and PntX1 PntY1)
		(setq	PntA		(TransCord "UTM83-16F" "UTM27-16" (list PntX1 PntY1)))
	)
	(if (and PntX2 PntY2)
		(setq	PntB		(TransCord "UTM83-16F" "UTM27-16" (list PntX2 PntY2)))
	)
	(if (and GetWin PntA PntB)
		(GetWin PntA PntB)
	)
	(grdraw (list (car PntA) (cadr PntA)) (list (car PntB) (cadr PntA)) -1 1)
	(grdraw (list (car PntB) (cadr PntA)) (list (car PntB) (cadr PntB)) -1 1)
	(grdraw (list (car PntB) (cadr PntB)) (list (car PntA) (cadr PntB)) -1 1)
	(grdraw (list (car PntA) (cadr PntB)) (list (car PntA) (cadr PntA)) -1 1)
	(list PntA PntB)
)

(defun C:OpnGis ( /	PntX1 PntY1			; Function to Open Panels & GrDraw outline of coords...
					PntX2 PntY2 RetVal )
	(setq	PntX1	(getreal "\nMinX: ")
			PntY1	(getreal "\nMinY: ")
			PntX2	(getreal "\nMaxX: ")
			PntY2	(getreal "\nMaxY: ")
	)
	(setq	RetVal	(OpnGis (list PntX1 PntY1 PntX2 PntY2)))
	(if RetVal
		(princ (strcat "\nOpnGis got (" (rtos (caar RetVal) 2 2) "," (rtos (cadar RetVal) 2 2) ") to (" (rtos (caadr RetVal) 2 2) "," (rtos (cadadr RetVal) 2 2) ") from DistGis"))
	)
	(princ)
)


(defun C:CntObjs ( 	/	Cntr				; List Counts of all entity types in drawing...
						LstObjTyp LstObjCnt ssAllObjects ssLen Ent01	ChkTyp ChkLay PosCntr )
	(setq	LstObjTyp			nil
			LstObjCnt			nil
			ssAllObjects		(ssget "ALL")
	)
	(if ssAllObjects
		(setq	Cntr		0
				ssLen	(sslength ssAllObjects)
		)
	)
	(while (< Cntr ssLen)
		(setq	Ent01	(entget (ssname ssAllObjects Cntr) (list "*"))
				ChkTyp	(cdr (assoc 0 Ent01))
				ChkLay	(cdr (assoc 8 Ent01))
		)
		(if (not Bug) (Twaddle CntR ssLen))
		(if LstObjTyp
			(if (not (member ChkTyp LstObjTyp))
				(setq	LstObjTyp		(cons ChkTyp LstObjTyp)
						LstObjCnt		(cons 1 LstObjCnt)
				)
				(setq	PosCntr		(- (length LstObjTyp) (length (member ChkTyp LstObjTyp)))
						LstObjCnt		(RepLst LstObjCnt (1+ (nth PosCntr LstObjCnt)) PosCntr)
				)
			)
			(setq	LstObjTyp		(list ChkTyp)
					LstObjCnt		(list 1)
			)
		)
		(setq	Cntr		(1+ Cntr))
	)
	(if (not Bug) (Twaddle (- 0 CntR) ssLen))
	(setq	Cntr		0)
	(if LstObjTyp
		(while (<= Cntr (1- (length LstObjTyp)))
			(princ (strcat "\nObjType {" (nth Cntr LstObjTyp) "}\thas {" (itoa (nth Cntr LstObjCnt)) "} items"))
			(setq	Cntr		(1+ Cntr))
		)
	)
	(princ)
)

(defun C:VrtCntr ( /	EntNam Ent01			; CL Counts Vertices of PolyLines
					CurLay VrtCnt )
	(princ "\nSelect a Polyline to count: ")
	(setq	EntNam	(car (entsel)))
	(if EntNam
		(progn
			(redraw EntNam 3)
			(setq	Ent01	(entget EntNam (list "*"))
					CurLay	(cdr (assoc 8 Ent01))
					VrtCnt	0
			)
			(if (= (cdr (assoc 0 Ent01)) "POLYLINE")
				(progn
					(setq	EntVrt	(entget (entnext (cdr (assoc -1 Ent01))) (list "*")))
					(setq	VrtCnt	(1+ VrtCnt))
					(while (/= (cdr (assoc 0 (setq EntVrt (entget (entnext (cdr (assoc -1 EntVrt))) (list "*"))))) "SEQEND")
						(setq	VrtCnt	(1+ VrtCnt))
					)
				)
			)
			(if (= (cdr (assoc 0 Ent01)) "POLYLINE")
				(cond	((wcmatch CurLay "-#0UCK-401")
							(princ (strcat "\nC:VrtCntr {" (PadCharR (itoa VrtCnt) 5) "} vertices of Parcel"))
						)
						((wcmatch CurLay "-#0UCK-402")
							(princ (strcat "\nC:VrtCntr {" (PadCharR (itoa VrtCnt) 5) "} vertices of Road"))
						)
						((wcmatch CurLay "-#0UCK-403")
							(princ (strcat "\nC:VrtCntr {" (PadCharR (itoa VrtCnt) 5) "} vertices of Service"))
						)
						((wcmatch CurLay "-#0UCK-405")
							(princ (strcat "\nC:VrtCntr {" (PadCharR (itoa VrtCnt) 5) "} vertices of Water"))
						)
						((wcmatch CurLay "????CK-###")
							(princ (strcat "\nC:VrtCntr {" (PadCharR (itoa VrtCnt) 5) "} vertices of Circuit"))
						)
						(T
							(princ (strcat "\nC:VrtCntr {" (PadCharR (itoa VrtCnt) 5) "} vertices of Unknown"))
						)
				)
			)
		)
	)
	(princ)
)

(defun UpdArcObjs ( DoIt	/	Cntr			; Update (or just test) objects C:LodArc doesn't catch...
							Cnt1 Cnt2 Cnt3 Cnt5 CntO Max1 Max2 Max3 Max5 MaxO Bcn1 Bcn2 Bcn3 Bcn5 BcnO
							ssAllObjects ssLen Ent01 ChkLay VrtCnt ChkEED Chk_ID EntVrt ItmDat NoEED WtEED )
	(setq	LstItmDat			nil
			LstNoEED			nil
			LstWtEED			nil
			ssAllObjects		(ssget "X"	(list	(cons -4 "<OR")
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
	)
	(if ssAllObjects
		(setq	Cntr		0
				UltVrtCnt	0
				UlPVrtCnt	0
				ssLen	(sslength ssAllObjects)
		)
	)
	(while (< Cntr ssLen)
		(setq	Ent01	(entget (ssname ssAllObjects Cntr) (list "*"))
				ChkLay	(cdr (assoc 8 Ent01))
				VrtCnt	0
				ChkEED	nil
				Chk_ID	nil
		)
		(if (assoc -3 Ent01)
			(if (assoc "ID" (cdr (assoc -3 Ent01)))
				(setq	ChkEED	T
						Chk_ID	T
				)
				(setq	ChkEED	T
						Chk_ID	nil
				)
			)
			(setq	ChkEED	nil)
		)
		(if (= (cdr (assoc 0 Ent01)) "POLYLINE")
			(progn
				(setq	EntVrt	(entget (entnext (cdr (assoc -1 Ent01))) (list "*")))
				(setq	VrtCnt	(1+ VrtCnt))
				(if (wcmatch ChkLay "-#0UCK-40#")
					(setq	UlPVrtCnt	(1+ UlPVrtCnt))
				)
				(setq	UltVrtCnt	(1+ UltVrtCnt))
				(while (/= (cdr (assoc 0 (setq EntVrt (entget (entnext (cdr (assoc -1 EntVrt))) (list "*"))))) "SEQEND")
					(setq	VrtCnt	(1+ VrtCnt))
					(setq	UltVrtCnt	(1+ UltVrtCnt))
					(if (wcmatch ChkLay "-#0UCK-40#")
						(setq	UlPVrtCnt	(1+ UlPVrtCnt))
					)
				)
			)
		)
		(setq	ItmDat	(list	(cdr (assoc 0 Ent01))
								ChkLay
								ChkEED
								Chk_ID
								VrtCnt
								(cdr (assoc -1 Ent01))
								(cdr (assoc 5 Ent01))
								Cntr
						)
				Cntr		(1+ Cntr)
		)
		(if LstItmDat
			(setq	LstItmDat		(cons ItmDat LstItmDat))
			(setq	LstItmDat		(list ItmDat))
		)
		(if (> VrtCnt 50)
			(if LstBDat
				(setq	LstBDat		(cons ItmDat LstBDat))
				(setq	LstBDat		(list ItmDat))
			)
		)
	)
	(setq	NoEED		0
			WtEED		0
			ssAllObjects	nil
	)
	(if LstItmDat
		(mapcar	(quote	(lambda (x)
							(if (nth 2 x)
								(progn
									(setq	WtEED	(1+ WtEED))
									(if LstNoEED
										(setq	LstWtEED	(cons (list (nth 5 x) (nth 7 x)) LstWtEED))
										(setq	LstWtEED	(list (list (nth 5 x) (nth 7 x))))
									)
								)
								(progn
									(setq	NoEED	(1+ NoEED))
									(if LstNoEED
										(setq	LstNoEED	(cons (list (nth 5 x) (nth 7 x)) LstNoEED))
										(setq	LstNoEED	(list (list (nth 5 x) (nth 7 x))))
									)
								)
							)
						)
				)
				LstItmDat
		)
	)
	(setq	CntTx		0
			CntIn		0
			CntPL		0
	)
	(if LstItmDat
		(mapcar	(quote	(lambda (x)
							(if (= (nth 0 x) "TEXT")
								(setq	CntTx	(1+ CntTx))
								(if (= (nth 0 x) "INSERT")
									(setq	CntIn	(1+ CntIn))
									(if (= (nth 0 x) "POLYLINE")
										(setq	CntPL	(1+ CntPL))
									)
								)
							)
						)
				)
				LstItmDat
		)
	)
	(princ (strcat "\nUpdArcObjs {" (PadCharR (itoa CntTx) 5) "} Text items"))
	(princ (strcat "\nUpdArcObjs {" (PadCharR (itoa CntIn) 5) "} Device items"))
	(princ (strcat "\nUpdArcObjs {" (PadCharR (itoa CntPL) 5) "} Polyline items"))
	(princ (strcat "\nUpdArcObjs {" (PadCharR (itoa UltVrtCnt) 5) "} vertices, Property{" (PadCharR (itoa UlPVrtCnt) 5) "}"))
	(princ (strcat "\nUpdArcObjs {" (PadCharR (itoa WtEED) 5) "} items with Device_ID!"))
	(princ (strcat "\nUpdArcObjs {" (PadCharR (itoa NoEED) 5) "} items *without* Device_ID!"))
	(setq	Cnt1		0
			Cnt2		0
			Cnt3		0
			Cnt5		0
			CntO		0
			Max1		0
			Max2		0
			Max3		0
			Max5		0
			MaxO		0
			Bcn1		0
			Bcn2		0
			Bcn3		0
			Bcn5		0
			BcnO		0
	)
	(if LstItmDat
		(mapcar	(quote	(lambda (x)
							(if (= (nth 0 x) "POLYLINE")
								(cond
									((= (nth 1 x) "-20UCK-401")
										(setq	Cnt1		(1+ Cnt1))
										(if (> (nth 4 x) Max1)
											(setq	Max1	(nth 4 x))
										)
										(if (> (nth 4 x) 100)
											(setq	Bcn1	(1+ Bcn1))
										)
									)
									((= (nth 1 x) "-20UCK-402")
										(setq	Cnt2		(1+ Cnt2))
										(if (> (nth 4 x) Max2)
											(setq	Max2	(nth 4 x))
										)
										(if (> (nth 4 x) 100)
											(setq	Bcn2	(1+ Bcn2))
										)
									)
									((= (nth 1 x) "-20UCK-403")
										(setq	Cnt3		(1+ Cnt3))
										(if (> (nth 4 x) Max3)
											(setq	Max3	(nth 4 x))
										)
										(if (> (nth 4 x) 100)
											(setq	Bcn3	(1+ Bcn3))
										)
									)
									((= (nth 1 x) "-20UCK-405")
										(setq	Cnt5		(1+ Cnt5))
										(if (> (nth 4 x) Max5)
											(setq	Max5	(nth 4 x))
										)
										(if (> (nth 4 x) 100)
											(setq	Bcn5	(1+ Bcn5))
										)
									)
									(T
										(setq	CntO		(1+ CntO))
										(if (> (nth 4 x) MaxO)
											(setq	MaxO	(nth 4 x))
										)
										(if (> (nth 4 x) 100)
											(setq	BcnO	(1+ BcnO))
										)
									)
								)
							)
						)
				)
				LstItmDat
		)
	)
	(if (> Bcn1 0)
		(princ (strcat "\nUpdArcObjs {" (PadCharR (itoa Cnt1) 5) "} items on {-20UCK-401} with max vert {" (PadCharR (itoa Max1) 3) "} and {" (PadCharR (itoa Bcn1) 3) "} over 100!"))
		(princ (strcat "\nUpdArcObjs {" (PadCharR (itoa Cnt1) 5) "} items on {-20UCK-401} with max vert {" (PadCharR (itoa Max1) 3) "}!"))
	)
	(if (> Bcn2 0)
		(princ (strcat "\nUpdArcObjs {" (PadCharR (itoa Cnt2) 5) "} items on {-20UCK-402} with max vert {" (PadCharR (itoa Max2) 3) "} and {" (PadCharR (itoa Bcn2) 3) "} over 100!"))
		(princ (strcat "\nUpdArcObjs {" (PadCharR (itoa Cnt2) 5) "} items on {-20UCK-402} with max vert {" (PadCharR (itoa Max2) 3) "}!"))
	)
	(if (> Bcn3 0)
		(princ (strcat "\nUpdArcObjs {" (PadCharR (itoa Cnt3) 5) "} items on {-20UCK-403} with max vert {" (PadCharR (itoa Max3) 3) "} and {" (PadCharR (itoa Bcn3) 3) "} over 100!"))
		(princ (strcat "\nUpdArcObjs {" (PadCharR (itoa Cnt3) 5) "} items on {-20UCK-403} with max vert {" (PadCharR (itoa Max3) 3) "}!"))
	)
	(if (> Bcn5 0)
		(princ (strcat "\nUpdArcObjs {" (PadCharR (itoa Cnt5) 5) "} items on {-20UCK-405} with max vert {" (PadCharR (itoa Max5) 3) "} and {" (PadCharR (itoa Bcn5) 3) "} over 100!"))
		(princ (strcat "\nUpdArcObjs {" (PadCharR (itoa Cnt5) 5) "} items on {-20UCK-405} with max vert {" (PadCharR (itoa Max5) 3) "}!"))
	)
	(if (> BcnO 0)
		(princ (strcat "\nUpdArcObjs {" (PadCharR (itoa CntO) 5) "} items on {????CK-###} with max vert {" (PadCharR (itoa MaxO) 3) "} and {" (PadCharR (itoa BcnO) 3) "} over 100!"))
		(princ (strcat "\nUpdArcObjs {" (PadCharR (itoa CntO) 5) "} items on {????CK-###} with max vert {" (PadCharR (itoa MaxO) 3) "}!"))
	)
	(setq	CntR		0)
	(if (and LstNoEED DoIt)
		(foreach	Itm
				LstNoEED
				(if (not Bug) (Twizzle CntR))
				(ChngUm T (car Itm))
				(redraw (car Itm) 3)
				(setq	CntR		(1+ CntR))
		)
	)
	(if (and LstNoEED DoIt)
		(if (not Bug) (Twizzle (- 0 CntR)))
	)
	(princ)
)

(defun C:LodMyArc ( / )							;CL - Loads ArcInfo Exports
	(if Bug (princ "\n{ C:LodMyArc entered\n"))
	(LodMyArc nil)
	(if Bug (princ "\n C:LodMyArc exited}\n"))
	(princ)
)

(defun LodMyArc ( MyPanImp /	ss0 Cnt OkV_Old		; Loads ArcInfo Exports into Adds Intelligent Format
						MyPanImp MyPanXML ssN01 ssALL Sent99 CntR 
						ssLen Sent00 ssWAS ssMarkR Ent2 ssMarkE 
						ssSWL eLst_Erase ObjNam )
  	(if Bug 
		(progn
			(princ "\nUtils.Lsp!LodMyArc - Entered Parameter:\n   MyPanImp:  ")
			(prin1 MyPanImp)
			(princ "\n")
		)
	)
	
	(if (and MyLoginObj (not MyUsrInfo))
		(AppndLognDat)
	)
	(if (and MyLoginObj (not MyUsrInfo))
		(setq	MyUsrInfo		(MyLoginObj AppDbNam))
	)
	(if MyUsrInfo
		(if (= (car MyUsrInfo) 1)
			(princ (strcat "\nLogged into {" (nth 1 MyUsrInfo) "} as {" (nth 2 MyUsrInfo) "} with role {" (nth 4 MyUsrInfo) "}"))
			(progn
				(alert (strcat "*** " AppNam " Login Error ***\n*Not* an Authorized Oracle Login: {" (strcase (getvar "LOGINNAME")) "} to instance [" (cadr MyUsrInfo) "]"))
				(command "_.Quit" "Y")
			)
		)
		
	)
	
	
	;	Sets variables to record existing system variables before changing them so they can be restored
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
			(setvar "ATTREQ" 1)			;Turns on prompts or a dialog box for attribute values
			(setvar "BLIPMODE" 0)		;Turns off marker blips
			(setvar "CELTYPE" "BYLAYER")	;Sets the linetype of new objects
			(setvar "CMDDIA" 0)			;Turns off display of the In-Place Text Editor for the QLEADER command
			(setvar "CMDECHO" 0)		;Turns off echoing
			(setvar "FILEDIA" 0)		;Does not display file navigation dialog boxes.
			(setvar "OSMODE" 0)			;Turns off running object snaps.
			(setvar "REGENMODE" 1)		;Turns on the REGENAUTO command.
		)
	)
	(command "_.UNDO" "_BE")					;Sets begin point for undo command.
	(command "AdeSetCrdSys" "S" "UTM27-16" "X")	;Assigns a global coordinate system code for the current drawing  
	
	(setq 	ss0		(ssget "ALL")
			Cnt		0
			OkV_Old	"12"
			MapQ		"C:"
			MapPath	"\\MapQry\\"
			MyPanXML	(strcat MapQ MapPath "URD_So_b.ipf")
			EdCode	T
	)
	(if (null MyPanImp)
		(setq	MyPanFil		(getfiled "Shape Selection" (strcat PrmRootPath "LTC_Export_ET\\" "SHP" 0))
				MyDirDat		(dos_splitpath MyPanFil)
				MyDirLst		(dos_dir (strcat (nth 0 MyDirDat) (nth 1 MyDirDat) "*" (nth 3 MyDirDat)))
		)
		(if (null (findfile (strcat MyPanImp "\\ByFeed.shp")))
			(setq	MyPanXML		nil)
 		)
	)
	
	;	If there are existing drawing objects in the current drawing then erase them.
	(if ss0
		(if (> (sslength ss0) 0)
			(command "_.Erase" ss0 "")
		)
	)

	(if (or (and MyPanImp MyPanXML) (and MyDirLst MyPanXML))
		(progn
			(if MyDirLst
				;Import all shape files in the selected directory
				(foreach	MyPan	MyDirLst
					(princ (strcat "\nMapImporting {Shape} [" MyPan "]\n"))
					(command "MapImport" "SHAPE" (strcat (nth 0 MyDirDat) (nth 1 MyDirDat) MyPan) "Y" MyPanXML "P")
				)
				(command "MapImport" "SHAPE" MyPanImp "Y" MyPanXML "P")
			)
			(command	"_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" "F" "Mask,UrdPoly" ""
					"_.Zoom" "E" 
					"_.Zoom" "0.8x"
			)
			(if (null sff)		;If Scale Factor in Feet is not set then have user to set it.
				(progn
					(setq	sff	100
							sf	(* sff 0.3048)
					)
					(setvar "LTScale" SFF)
					(setvar "THICKNESS" SFF)
				)
			)
			(if (not (LayChk "Street"))
				(command	"_.Layer" "M" "Street" "C" "8" "" "")
			)
			(if (setq ssN01 (ssget "X" (list (cons 8 "Roads"))))
				(command "_.ChProp" ssN01 "" "LA" "Street" "")
			)
			
			(setq	ssN01	nil)
			(if (not (LayChk "Property"))
				(progn 
					(command	"_.Layer" "M" "Property" "C" "3" "" "")
				)
			)
			(if (setq ssN01 (ssget "X" (list (cons 8 "PropLine"))))
				(command "_.ChProp" ssN01 "" "LA" "Property" "")
			)
			(setq	ssN01	nil)
			(if (setq ssN01 (ssget "X" (list (cons 8 "LandArcs"))))
				(command "_.ChProp" ssN01 "" "LA" "Property" "")
			)
			(setq	ssN01	nil)
			(if (setq ssN01 (ssget "X" (list (cons 8 "ugArea"))))
				(command "_.ChProp" ssN01 "" "LA" "Property" "")
			)

			
			(setq	ssN01	nil)
			(if (not (LayChk "-20UCK-403"))
				(command	"_.Layer" "M" "-20UCK-403" "C" "30" "" "")
			)
			(if (setq ssN01 (ssget "X" (list (cons 8 "SecoCond"))))
				(command "_.ChProp" ssN01 "" "LA" "-20UCK-403" "")
			)
			(setq	ssN01	nil)
			(if (setq ssN01 (ssget "X" (list (cons 8 "ServCond"))))
				(command "_.ChProp" ssN01 "" "LA" "-20UCK-403" "")
			)
			(setq	ssN01	nil)
			(if (not (LayChk "-20UCK-405"))
				(command	"_.Layer" "M" "-20UCK-405" "C" "5" "" "")
			)
			(if (setq ssN01 (ssget "X" (list (cons 8 "Water"))))
				(command "_.ChProp" ssN01 "" "LA" "-20UCK-405" "")
			)
			(getstring "Pt1")
			;	Create a selection set containing Polylines or lines that are on layers for electical circuits
			(setq	ssN01	nil)
			(if Lst_Fd_B
				(setq	ssALL	(ssget "X"	(list	(cons -4 "<OR")
														(cons 0 "POLYLINE")
														(cons 0 "LINE")
													(cons -4 "OR>")
													(cons -4 "<NOT")
														(cons 8 "-20UCK-403,Property,Street,-20UCK-405,Conduit")
													(cons -4 "NOT>")
											)
								)
				)
				(princ "Load DivPret, or no go!")
			)
			(if ssALL
				(setq	ssLen	(sslength ssALL)
						CntR		0
				)
			)
			(if ssALL
				(princ (strcat "\nUpdating {" (itoa ssLen) "} Circuits"))
			)
			
			(if ssALL
				(while	(<= CntR (1- ssLen))
					(if (ssname ssALL CntR)
						(progn
							(if (not Bug) (Twaddle CntR ssLen))
						  	(setq Sent99 (entget (ssname ssALL CntR) (list "*")))
							(Work_OD (ssname ssALL CntR))
							(if	(or	(and	(= (cdr (assoc 0 (entget (ssname ssALL CntR)))) "POLYLINE")
										(wcmatch (cdr (assoc 8 (entget (ssname ssALL CntR)))) "????CK-###*")
										(= (cdr (assoc 67 (entget (ssname ssALL CntR)))) 0)
									)
									(and	(= (cdr (assoc 0 (entget (ssname ssALL CntR)))) "INSERT")
										(wcmatch (cdr (assoc 2 (entget (ssname ssALL CntR)))) "[Aa]###,[Aa]###[Ss]")
										(= (cdr (assoc 67 (entget (ssname ssALL CntR)))) 0)
									)
									(and	(= (cdr (assoc 0 (entget (ssname ssALL CntR)))) "TEXT")
										(wcmatch (cdr (assoc 2 (entget (ssname ssALL CntR)))) "*")
										(= (cdr (assoc 67 (entget (ssname ssALL CntR)))) 0)
									)
								)
								(ChngUm T (ssname ssALL CntR))
							)
						)
					)
				  	(setq Sent00 (entget (ssname ssALL CntR) (list "*")))
					(setq	CntR		(1+ CntR))
				)
			)
			(if ssALL
				(if (not Bug) (Twaddle (- 0 CntR) ssLen))
			)
			(setq	ssALL	nil)
			(setq	ssWAS	(ssget "X" (list (cons 0 "LINE")(cons -4 "<NOT")(cons 8 "ByFeed")(cons -4 "NOT>"))))
			(if ssWAS
				(setq	ssLen	(sslength ssWAS)
						ssMarkR	(entlast)
						CntR		0
				)
			)
			(if ssWAS
				(princ (strcat "\nConverting {" (itoa ssLen) "} Lines"))
			)
			(if ssWAS
				(while	(<= CntR (1- ssLen))
					(if (ssname ssWAS CntR)
						(progn
							(if (not Bug) (Twaddle CntR ssLen))
							(setq	Bubba	(entget (ssname ssWAS CntR) (list "*"))
									Ent2		(list (cdr (assoc -1 Bubba)) (cdr (assoc 10 Bubba)))
							)

						  (command "_.PEdit" Ent2 "Y" "")
						)
					)
					(setq	CntR		(1+ CntR))
				)
			)
			(if ssWAS
				(if (not Bug) (Twaddle (- 0 CntR) ssLen))
			)
			(setq	ssWAS	nil)
			(getstring "Pt2")
			(UpdArcObjs nil)
			(command "MapClean" (strcat MapQ MapPath "Comp401.dpf"))
			(command "MapClean" (strcat MapQ MapPath "Comp402.dpf"))
			(command "MapClean" (strcat MapQ MapPath "Comp403.dpf"))
			(command "MapClean" (strcat MapQ MapPath "Comp405.dpf"))
			(if ssMarkR
				(setq	CntR		0)
			)
			(if ssMarkR
				(while (setq ssMarkR (entnext ssMarkR))
					(if (= (cdr (assoc 0 (setq ssMarkE (entget ssMarkR)))) "POLYLINE")
						(if	(or	(and	(= (cdr (assoc 0 ssMarkE)) "POLYLINE")
									(wcmatch (cdr (assoc 8 ssMarkE)) "????CK-###*")
									(= (cdr (assoc 67 ssMarkE)) 0)
								)
								(and	(= (cdr (assoc 0 ssMarkE)) "INSERT")
									(wcmatch (cdr (assoc 2 ssMarkE)) "[Aa]###,[Aa]###[Ss]")
									(= (cdr (assoc 67 ssMarkE)) 0)
								)
								(and	(= (cdr (assoc 0 ssMarkE)) "TEXT")
									(wcmatch (cdr (assoc 2 ssMarkE)) "*")
									(= (cdr (assoc 67 ssMarkE)) 0)
								)
							)
							(progn
								(if (not Bug) (Twizzle CntR))
								(ChngUm T ssMarkR)
								(redraw ssMarkR)
								(setq	CntR		(1+ CntR))
							)
						)
					)
				)
			)
			(if ssMarkR
				(if (not Bug) (Twizzle (- 0 CntR)))
			)
			(if Lst_Fd_B
		;;		(setq	ssSWL	(ssget "X" (list (cons -4 "<NOT")(cons 0 "POLYLINE")(cons 0 "LINE")(cons -4 "NOT>"))))
				(setq	ssSWL	(ssget "X" (list (cons 0 "INSERT"))))
				(princ "Load DivPret, or no go!")
			)
			(if ssSWL
				(setq	ssLen	(sslength ssSWL)
						CntR		0
				)
			)
			(command)
			(if ssSWL
				(princ (strcat "\nUpdating {" (itoa ssLen) "} Devices"))
			)
			(if ssSWL
				(while	(<= CntR (1- ssLen))
					(if (not Bug) (Twaddle CntR ssLen))
					(if (= (cdr (assoc 0 (entget (ssname ssSWL CntR)))) "INSERT")
						(command "_.Scale" (ssname ssSWL CntR) "" (cdr (assoc 10 (entget (ssname ssSWL CntR)))) 10.0)
					)
					(Work_OD (ssname ssSWL CntR))
							(if	(or	(and	(= (cdr (assoc 0 (entget (ssname ssSWL CntR)))) "POLYLINE")
										(wcmatch (cdr (assoc 8 (entget (ssname ssSWL CntR)))) "????CK-###*")
										(= (cdr (assoc 67 (entget (ssname ssSWL CntR)))) 0)
									)
									(and	(= (cdr (assoc 0 (entget (ssname ssSWL CntR)))) "INSERT")
										(wcmatch (cdr (assoc 2 (entget (ssname ssSWL CntR)))) "[Aa]###,[Aa]###[Ss]")
										(= (cdr (assoc 67 (entget (ssname ssSWL CntR)))) 0)
									)
									(and	(= (cdr (assoc 0 (entget (ssname ssSWL CntR)))) "TEXT")
										(wcmatch (cdr (assoc 2 (entget (ssname ssSWL CntR)))) "*")
										(= (cdr (assoc 67 (entget (ssname ssSWL CntR)))) 0)
									)
								)
								(ChngUm T (ssname ssSWL CntR))
							)
					(setq	CntR		(1+ CntR))
				)
			)
			(if ssSWL
				(if (not Bug) (Twaddle (- 0 CntR) ssLen))
			)
			(setq	ssSWL	nil)
			(setq	ssSWL	(ssget "X" (list (cons -4 "<OR")(cons 2 "U177")(cons 0 "POINT")(cons 8 "Conduit")(cons -4 "OR>"))))
			(if ssSWL
				(command "_.Erase" ssSWL "")
			)
			(setq	ssSWL	nil)
			(if eLst_Erase
				(progn
					(setq	ssSWL	(ssadd))
					(foreach	ObjNam
							eLst_Erase
							(setq	ssSWL	(ssadd ObjNam ssSWL))
					)
				)
			)
			(if ssSWL
				(command "_.Erase" ssSWL "")
			)
			(setq	ssSWL	nil)
			(UpdArcObjs T)
			(command	"_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" ""
					"_.Zoom" "E" 
					"_.Zoom" "0.8x"
			)
			(C:WrkPadMA)
			(DispRd_Name)
			(setvar "NOMUTT" 1)
			(command "_.Purge" "A" "*" "N")
			(command "_.Purge" "A" "*" "N")
			(setvar "NOMUTT" 0)
			(command	"_.Layer" "S" "0" "F" "Mask,UrdPoly,????PL*,RoadName" "" "RegenAll")
			(setq	ssSWL	nil)
			(setq	ssSWL	(ssget "X" (list (cons 8 "byfeed*"))))
			(if ssSWL
				(princ (strcat "\n*Error*=>\tFound {" (itoa (sslength ssSWL)) "} circuits that did not inherit layer! [ssSWL]"))
			)
			(command	"_.Layer" "M" "----GRD---" "C" "15" "" "M" "----SC----" "C" "7" "" "S" "0" "")
		)
	)
	(command "_.UNDO" "_EN")
	(setvar "CECOLOR" ColWas)
	(setvar "ATTREQ" 1)
	(setvar "BLIPMODE" 1)
	(setvar "CELTYPE" "BYLAYER")
	(setvar "CMDDIA" 1)
	(setvar "CMDECHO" 0)
	(setvar "FILEDIA" 1)
	(setvar "OSMODE" 0)
	(setvar "REGENMODE" 1)
	(if Bug (princ "\n LodMyArc exited}\n"))
	(princ)
)

(defun C:LodArc ( /	ss0 Cnt OkV_Old		; Loads ArcInfo Exports into Adds Intelligent Format
					MyPanImp MyPanXML ssN01 ssALL Sent99 CntR 
					ssLen Sent00 ssWAS ssMarkR Ent2 ssMarkE 
					ssSWL eLst_Erase ObjNam )
	(if Bug (princ "\n{ C:LodArc entered\n"))
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
			(setvar "ATTREQ" 1)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
			(setvar "REGENMODE" 1)
		)
	)
	(command "_.UNDO" "_BE")
	(if (> (length PanLst) 0)
		(setq	ss0			(ssget "ALL")
				Cnt			0
				OkV_Old		"12"
;;;				MyPanImp		(strcat _M_AltS-Panel "URD_Data\\" (car PanLst))
				MyPanImp		"C:\\MapQry\\LTC_Export"
				MyPanXML		"C:\\MapQry\\URD_So_f.ipf"
;;;				MyPanXML		(if (= (car PanLst) "URD_GDA") 
;;;								(strcat _M_AltS-Panel "URD_Data\\" "URD_GDA.ipf")
;;;								(if (= (car PanLst) "URD_E25") 
;;;									(strcat _M_AltS-Panel "URD_Data\\" "URD_So_E25.ipf")
;;;									(if (= (car PanLst) "URD_E31")
;;;										(strcat _M_AltS-Panel "URD_Data\\" "URD_So_E31.ipf")
;;;										(if (= (car PanLst) "URD_EG8")
;;;											(strcat _M_AltS-Panel "URD_Data\\" "URD_So_EG8.ipf")
;;;											(strcat _M_AltS-Panel "URD_Data\\" "URD_So_f.ipf")
;;;										)
;;;									)
;;;								)
;;;							)
				ObjMstDevLst	nil 
				MstDevLst		nil 
				ModMstDevLst	nil 
				myBigLst		nil
				EdCode		T
		)
	)
	(if (> (sslength ss0) 0)
		(command "_.Erase" ss0 "")
	)
	(command "AdeSetCrdSys" "S" "UTM27-16" "X")
	(if (> (length PanLst) 0)
		(command "MapImport" "SHAPE" MyPanImp "Y" MyPanXML "P")
	)
	(command	"_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" "F" "Mask,UrdPoly" ""
			"_.Zoom" "E" 
			"_.Zoom" "0.8x"
	)
	(if (null sff)
		(progn
			(setq	sff	100
					sf	(* sff 0.3048)
			)
			(setvar "LTScale" SFF)
			(setvar "THICKNESS" SFF)
		)
	)
	(if (not (LayChk "-20UCK-401"))
		(command	"_.Layer" "M" "-20UCK-401" "C" "8" "" "")
	)
	(if (setq ssN01 (ssget "X" (list (cons 8 "Roads"))))
		(command "_.ChProp" ssN01 "" "LA" "-20UCK-401" "")
	)
	(setq	ssN01	nil)
	(if (not (LayChk "-20UCK-402"))
		(command	"_.Layer" "M" "-20UCK-402" "C" "9" "" "")
	)
	(if (setq ssN01 (ssget "X" (list (cons 8 "PropLine"))))
		(command "_.ChProp" ssN01 "" "LA" "-20UCK-402" "")
	)
	(setq	ssN01	nil)
	(if (setq ssN01 (ssget "X" (list (cons 8 "LandArcs"))))
		(command "_.ChProp" ssN01 "" "LA" "-20UCK-402" "")
	)
	(setq	ssN01	nil)
	(if (not (LayChk "-20UCK-403"))
		(command	"_.Layer" "M" "-20UCK-403" "C" "30" "" "")
	)
	(if (setq ssN01 (ssget "X" (list (cons 8 "SecoCond"))))
		(command "_.ChProp" ssN01 "" "LA" "-20UCK-403" "")
	)
	(setq	ssN01	nil)
	(if (setq ssN01 (ssget "X" (list (cons 8 "ServCond"))))
		(command "_.ChProp" ssN01 "" "LA" "-20UCK-403" "")
	)
	(setq	ssN01	nil)
	(if (not (LayChk "-20UCK-405"))
		(command	"_.Layer" "M" "-20UCK-405" "C" "5" "" "")
	)
	(if (setq ssN01 (ssget "X" (list (cons 8 "Water"))))
		(command "_.ChProp" ssN01 "" "LA" "-20UCK-405" "")
	)
	(setq	ssN01	nil)
	(if Lst_Fd_B
		(setq	ssALL	(ssget "X"	(list	(cons -4 "<OR")
												(cons 0 "POLYLINE")
												(cons 0 "LINE")
											(cons -4 "OR>")
											(cons -4 "<NOT")
												(cons 8 "-20UCK-403,-20UCK-402,-20UCK-401,-20UCK-405,Conduit")
											(cons -4 "NOT>")
									)
						)
		)
		(princ "Load DivPret, or no go!")
	)
	(if ssALL
		(setq	ssLen	(sslength ssALL)
				CntR		0
		)
	)
	(if ssALL
		(princ (strcat "\nUpdating {" (itoa ssLen) "} Circuits"))
	)
	(if ssALL
		(while	(<= CntR (1- ssLen))
			(if (ssname ssALL CntR)
				(progn
					(if (not Bug) (Twaddle CntR ssLen))
				  	(setq Sent99 (entget (ssname ssALL CntR) (list "*")))
					(Work_OD (ssname ssALL CntR))
					(if	(or	(and	(= (cdr (assoc 0 (entget (ssname ssALL CntR)))) "POLYLINE")
								(wcmatch (cdr (assoc 8 (entget (ssname ssALL CntR)))) "????CK-###*")
								(= (cdr (assoc 67 (entget (ssname ssALL CntR)))) 0)
							)
							(and	(= (cdr (assoc 0 (entget (ssname ssALL CntR)))) "INSERT")
								(wcmatch (cdr (assoc 2 (entget (ssname ssALL CntR)))) "[Aa]###,[Aa]###[Ss]")
								(= (cdr (assoc 67 (entget (ssname ssALL CntR)))) 0)
							)
							(and	(= (cdr (assoc 0 (entget (ssname ssALL CntR)))) "TEXT")
								(wcmatch (cdr (assoc 2 (entget (ssname ssALL CntR)))) "*")
								(= (cdr (assoc 67 (entget (ssname ssALL CntR)))) 0)
							)
						)
						(ChngUm T (ssname ssALL CntR))
					)
				)
			)
		  	(setq Sent00 (entget (ssname ssALL CntR) (list "*")))
			(setq	CntR		(1+ CntR))
		)
	)
	(if ssALL
		(if (not Bug) (Twaddle (- 0 CntR) ssLen))
	)
	(setq	ssALL	nil)
	(setq	ssWAS	(ssget "X" (list (cons 0 "LINE")(cons -4 "<NOT")(cons 8 "ByFeed")(cons -4 "NOT>"))))
	(if ssWAS
		(setq	ssLen	(sslength ssWAS)
				ssMarkR	(entlast)
				CntR		0
		)
	)
	(if ssWAS
		(princ (strcat "\nConverting {" (itoa ssLen) "} Lines"))
	)
	(if ssWAS
		(while	(<= CntR (1- ssLen))
			(if (ssname ssWAS CntR)
				(progn
					(if (not Bug) (Twaddle CntR ssLen))
					(setq	Bubba	(entget (ssname ssWAS CntR) (list "*"))
							Ent2		(list (cdr (assoc -1 Bubba)) (cdr (assoc 10 Bubba)))
					)
					(command "_.PEdit" Ent2 "Y" "")
				)
			)
			(setq	CntR		(1+ CntR))
		)
	)
	(if ssWAS
		(if (not Bug) (Twaddle (- 0 CntR) ssLen))
	)
	(setq	ssWAS	nil)
	(UpdArcObjs nil)
	(command "MapClean" (strcat _M_AltS-Panel "URD_Data\\" "Comp401.dpf"))
	(command "MapClean" (strcat _M_AltS-Panel "URD_Data\\" "Comp402.dpf"))
	(command "MapClean" (strcat _M_AltS-Panel "URD_Data\\" "Comp403.dpf"))
	(command "MapClean" (strcat _M_AltS-Panel "URD_Data\\" "Comp405.dpf"))
	(if ssMarkR
		(setq	CntR		0)
	)
	(if ssMarkR
		(while (setq ssMarkR (entnext ssMarkR))
			(if (= (cdr (assoc 0 (setq ssMarkE (entget ssMarkR)))) "POLYLINE")
				(if	(or	(and	(= (cdr (assoc 0 ssMarkE)) "POLYLINE")
							(wcmatch (cdr (assoc 8 ssMarkE)) "????CK-###*")
							(= (cdr (assoc 67 ssMarkE)) 0)
						)
						(and	(= (cdr (assoc 0 ssMarkE)) "INSERT")
							(wcmatch (cdr (assoc 2 ssMarkE)) "[Aa]###,[Aa]###[Ss]")
							(= (cdr (assoc 67 ssMarkE)) 0)
						)
						(and	(= (cdr (assoc 0 ssMarkE)) "TEXT")
							(wcmatch (cdr (assoc 2 ssMarkE)) "*")
							(= (cdr (assoc 67 ssMarkE)) 0)
						)
					)
					(progn
						(if (not Bug) (Twizzle CntR))
						(ChngUm T ssMarkR)
						(redraw ssMarkR)
						(setq	CntR		(1+ CntR))
					)
				)
			)
		)
	)
	(if ssMarkR
		(if (not Bug) (Twizzle (- 0 CntR)))
	)
	(if Lst_Fd_B
;;		(setq	ssSWL	(ssget "X" (list (cons -4 "<NOT")(cons 0 "POLYLINE")(cons 0 "LINE")(cons -4 "NOT>"))))
		(setq	ssSWL	(ssget "X" (list (cons 0 "INSERT"))))
		(princ "Load DivPret, or no go!")
	)
	(if ssSWL
		(setq	ssLen	(sslength ssSWL)
				CntR		0
		)
	)
	(command)
	(if ssSWL
		(princ (strcat "\nUpdating {" (itoa ssLen) "} Devices"))
	)
	(if ssSWL
		(while	(<= CntR (1- ssLen))
			(if (not Bug) (Twaddle CntR ssLen))
			(if (= (cdr (assoc 0 (entget (ssname ssSWL CntR)))) "INSERT")
				(command "_.Scale" (ssname ssSWL CntR) "" (cdr (assoc 10 (entget (ssname ssSWL CntR)))) 10.0)
			)
			(Work_OD (ssname ssSWL CntR))
					(if	(or	(and	(= (cdr (assoc 0 (entget (ssname ssSWL CntR)))) "POLYLINE")
								(wcmatch (cdr (assoc 8 (entget (ssname ssSWL CntR)))) "????CK-###*")
								(= (cdr (assoc 67 (entget (ssname ssSWL CntR)))) 0)
							)
							(and	(= (cdr (assoc 0 (entget (ssname ssSWL CntR)))) "INSERT")
								(wcmatch (cdr (assoc 2 (entget (ssname ssSWL CntR)))) "[Aa]###,[Aa]###[Ss]")
								(= (cdr (assoc 67 (entget (ssname ssSWL CntR)))) 0)
							)
							(and	(= (cdr (assoc 0 (entget (ssname ssSWL CntR)))) "TEXT")
								(wcmatch (cdr (assoc 2 (entget (ssname ssSWL CntR)))) "*")
								(= (cdr (assoc 67 (entget (ssname ssSWL CntR)))) 0)
							)
						)
						(ChngUm T (ssname ssSWL CntR))
					)
			(setq	CntR		(1+ CntR))
		)
	)
	(if ssSWL
		(if (not Bug) (Twaddle (- 0 CntR) ssLen))
	)
	(setq	ssSWL	nil)
	(setq	ssSWL	(ssget "X" (list (cons -4 "<OR")(cons 2 "U177")(cons 0 "POINT")(cons 8 "Conduit")(cons -4 "OR>"))))
	(if ssSWL
		(command "_.Erase" ssSWL "")
	)
	(setq	ssSWL	nil)
	(if eLst_Erase
		(progn
			(setq	ssSWL	(ssadd))
			(foreach	ObjNam
					eLst_Erase
					(setq	ssSWL	(ssadd ObjNam ssSWL))
			)
		)
	)
	(if ssSWL
		(command "_.Erase" ssSWL "")
	)
	(setq	ssSWL	nil)
	(UpdArcObjs T)
	(command	"_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" ""
			"_.Zoom" "E" 
			"_.Zoom" "0.8x"
	)
	(C:WrkPadMA)
	(DispRd_Name)
	(setvar "NOMUTT" 1)
	(command "_.Purge" "A" "*" "N")
	(command "_.Purge" "A" "*" "N")
	(setvar "NOMUTT" 0)
	(command	"_.Layer" "S" "0" "F" "Mask,UrdPoly,????PL*,RoadName" "" "RegenAll")
	(setq	ssSWL	nil)
	(setq	ssSWL	(ssget "X" (list (cons 8 "byfeed*"))))
	(if ssSWL
		(princ (strcat "\n*Error*=>\tFound {" (itoa (sslength ssSWL)) "} circuits that did not inherit layer! [ssSWL]"))
	)
	(command	"_.Layer" "M" "----GRD---" "C" "15" "" "M" "----SC----" "C" "7" "" "S" "0" "")
	(command "_.UNDO" "_EN")
	(setvar "CECOLOR" ColWas)
	(setvar "ATTREQ" 1)
	(setvar "BLIPMODE" 1)
	(setvar "CELTYPE" "BYLAYER")
	(setvar "CMDDIA" 1)
	(setvar "CMDECHO" 0)
	(setvar "FILEDIA" 1)
	(setvar "OSMODE" 0)
	(setvar "REGENMODE" 1)
	(if Bug (princ "\n C:LodArc exited}\n"))
	(princ)
)

(defun C:TS ( / )							; CL Thaw Sectionalizing
	(command	"_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" "F" "Mask,UrdPoly,????FL*,RoadName" "")
)

(defun C:TM ( / )							; CL Thaw More
	(command	"_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" "F" "Mask,UrdPoly,RoadName" "")
)

(defun C:TA ( / )							; CL Thaw All
	(command	"_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" "")
)

(defun Work_OD ( source_obj /	tbllist		; Manipulates Blocks
							tbl numrec tbldef tblstr fldnamelist fldtypelist fld
							fldnme AttCom EntM LocNum AClr NClr E_Fdr_ID PHgt PCls
							BSiz BTyp OHUG_Cod OkV kVRat FRat FTyp OPhas OLNum ONope
							OSubT ATag PTag TTyp fldtyp fldnamelist ct vallist typ
							val cttemp fldtypelist SEnt1 )
	(setq	SEnt1		(entget source_obj (list "*")))
	(if (null sff)
		(progn
			(setq	sff	100
					sf	(* sff 0.3048)
			)
			(setvar "LTScale" SFF)
			(setvar "THICKNESS" SFF)
		)
	)
	(setq	tbllist		(ade_odgettables source_obj))			;Lists the tables attached to an object base on AutoCAD object name (source_obj)
	(if tbllist
		(setq	tbl			(car tbllist))
		(princ (strcat "\nWork_OD => Entity:" (cdr (assoc 0 SEnt1)) " with handle {" (cdr (assoc 5 SEnt1)) "} has no OD!"))
	)
	(if tbl
		(setq	numrec		(ade_odrecordqty source_obj tbl))	;Counts the records attached to an object
	)
	(if numrec
		(setq	tbldef		(ade_odtabledefn tbl))			;Gets a table definition
	)
	(if tbldef
		(setq	tblstr		(cdr (nth 2 tbldef)))
	)
	(if tblstr
		(progn
			(setq	fldnamelist	()
					fldtypelist	()
					LocNum		nil
					AClr			nil
					NClr			nil
					E_Fdr_ID		nil
					PHgt			nil
					PCls			nil
					BSiz			nil
					BTyp			nil
					OHUG_Cod		nil
					OkV			nil
					kVRat		nil
					FRat			nil
					FTyp			nil
					OPhas		nil
					OLNum		nil
					ONope		nil
					OSubT		nil
					ATag			nil
					PTag			nil
					TTyp			nil
					RName		nil
					Virt_ID		nil
			)
			(foreach	fld
					tblstr
				(setq	fldnme		(cdr (nth 0 fld)))
				(setq	fldtyp		(cdr (nth 2 fld)))
				(setq	fldnamelist	(append fldnamelist (list fldnme)))
				(setq	fldtypelist	(append fldtypelist (list fldtyp)))
			)
			(setq	ct			0)
			(while (< ct numrec)
				(setq	cttemp	0
						vallist	()
				)
				(foreach	fld
						fldnamelist
					(setq	typ		(nth cttemp fldtypelist)
							SEnt2	nil
					)
					;(princ (strcat "\nBug: Typ={" typ "}"))
					(setq	cttemp	(+ cttemp 1))
					(setq	val		(ade_odgetfield source_obj tbl fld ct))	;Gets a field value.
					(if (= typ "Integer")
						(setq	val	(itoa val))
					)
					(if (= typ "Real")
						(setq	val	(rtos val 2 4))
					)
					(cond
						((wcmatch (strcase fld) (strcase "ALT_NAME"))
							(if (null RName)
								(setq	RName	val
										Bubba	(if Bug (princ (strcat "\n RName => {" RName "}")))
								)
							)
						)
						((wcmatch (strcase fld) (strcase "NAME"))
							(setq	RName	val
									Bubba	(if Bug (princ (strcat "\n RName => {" RName "}")))
							)
						)
						((wcmatch (strcase fld) (strcase "LOC_NUM"))
							(setq	LocNum	val
									Bubba	(if Bug (princ (strcat "\n LocNum => {" LocNum "}")))
							)
						)
						((wcmatch (strcase fld) (strcase "ALTCOLOR"))	;See this in uprim
							(setq	AClr		val
									NClr		(atoi val)
									Bubba	(if Bug (princ (strcat "\n AClr => {" AClr "}")))
							)
							(if (and (/= NClr 0) (/= NClr 256))
								(progn
									(if (null (assoc 62 SEnt1))
										(setq	SEnt1	(append SEnt1 (list (cons 62 NClr)))
												Bubba	(entmod SEnt1)
										)
										(setq	SEnt1	(subst (cons 62 NClr) (assoc 62 SEnt1) SEnt1)
												Bubba	(entmod SEnt1)
										)
									)
									(if LstUnqNClr
										(if (not (member NClr LstUnqNClr))
											(setq	LstUnqNClr	(cons NClr LstUnqNClr))
										)
										(setq	LstUnqNClr	(list NClr))
									)
								)
								(setq	NClr		nil)
							)
						)
						((wcmatch (strcase fld) (strcase "AutoSymbol"))
							(setq	SEnt1	(subst (cons 50 (dtr (atoi val))) (assoc 50 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
						)
						((wcmatch (strcase fld) (strcase "FEEDERID"))	;See this in uprim
							(setq	E_Fdr_ID	val
									Bubba	(if Bug (princ (strcat "\n E_Fdr_ID => {" E_Fdr_ID "}")))
							)
						)
						((wcmatch (strcase fld) (strcase "HEIGHT"))
							(setq	PHgt	val
									Bubba	(if Bug (princ (strcat "\n PHgt => {" PHgt "}")))
							)
						)
						((wcmatch (strcase fld) (strcase "CLASS"))
							(setq	PCls	val
									Bubba	(if Bug (princ (strcat "\n PCls => {" PCls "}")))
							)
						)
						((wcmatch (strcase fld) (strcase "BILL_SIZ"))
							(setq	BSiz	val
									Bubba	(if Bug (princ (strcat "\n BSiz => {" BSiz "}")))
							)
						)
						((wcmatch (strcase fld) (strcase "BILL_LTYPE"))
							(setq	BTyp	val
									Bubba	(if Bug (princ (strcat "\n BTyp => {" BTyp "}")))
							)
						)
						((wcmatch (strcase fld) (strcase "OHUG_COD"))
							(setq	OHUG_Cod	val
									Bubba	(if Bug (princ (strcat "\n OHUG_Cod => {" OHUG_Cod "}")))
							)
						)
						((wcmatch (strcase fld) (strcase "OVOLTAGE"))	;See this in uprim
							(setq	OkV		val
									Bubba	(if Bug (princ (strcat "\n OkV => {" OkV "}")))
							)
						)
						((wcmatch (strcase fld) (strcase "KVA_RATING"))
							(setq	kVRat	(rtos (atoi val) 2 0)
									Bubba	(if Bug (princ (strcat "\n kVRat => {" kVRat "}")))
							)
						)
						((wcmatch (strcase fld) (strcase "FRATE"))
							(setq	FRat		(if (/= val "0") (rtos (atoi val) 2 0) "")
									Bubba	(if Bug (princ (strcat "\n FRat => {" FRat "}")))
							)
						)
						((wcmatch (strcase fld) (strcase "FTYPE"))
							(setq	FTyp		val
									Bubba	(if Bug (princ (strcat "\n FTyp => {" FTyp "}")))
							)
						)
						;See this in uprim
						((or (wcmatch (strcase fld) (strcase "PHASES")) (wcmatch (strcase fld) (strcase "PHASEDESIG")))
							(setq	OPhas	val
									Bubba	(if Bug (princ (strcat "\n OPhas => {" OPhas "}")))
							)
						)
						((wcmatch (strcase fld) (strcase "LOC_NUM"))
							(setq	OLNum	val
									Bubba	(if Bug (princ (strcat "\n OLNum => {" OLNum "}")))
							)
						)
						((wcmatch (strcase fld) (strcase "NORMAL_OPE"))
							(setq	ONope	val
									Bubba	(if Bug (princ (strcat "\n ONope => {" ONope "}")))
							)
						)
						((wcmatch (strcase fld) (strcase "SUBTYPECD"))	;See this in uprim
							(setq	OSubT	val
									Bubba	(if Bug (princ (strcat "\n OSubT => {" OSubT "}")))
							)
						)
						((wcmatch (strcase fld) (strcase "PTAG"))
							(setq	PTag		val
									Bubba	(if Bug (princ (strcat "\n PTag => {" PTag "}")))
							)
						)
						((wcmatch (strcase fld) (strcase "ATAG"))	;See this in uprim
							(setq	ATag		val
									Bubba	(if Bug (princ (strcat "\n ATag => {" ATag "}")))
							)
						)
						((wcmatch (strcase fld) (strcase "TYPE"))
							(setq	TTyp		val
									Bubba	(if Bug (princ (strcat "\n TTyp => {" TTyp "}")))
							)
						)
						((wcmatch (strcase fld) (strcase "VOLT_CLASS"))
							(setq	VCls		val
									Bubba	(if Bug (princ (strcat "\n VCls => {" VCls "}")))
							)
						)
						(T
						 	(if Bug (princ (strcat "\n\tField:{" fld "} Value:{" val "}")))
						)
					)
					(setq	vallist	(append vallist (list val)))
				)
				(if (= (cdr (assoc 0 SEnt1)) "INSERT")
					(if (not (and E_Fdr_ID OHUG_Cod OkV OPhas))	;(and E_Fdr_ID (not (and E_Fdr_ID OHUG_Cod OkV OPhas)))
						(progn
							(command "_.Zoom" "C" (cdr (assoc 10 SEnt1)) (/ (float sff) 0.5))
							(setq	Fuzz		(/ (float sff) 5.0)
									MinX		(cadr (assoc 10 SEnt1))
									MinY		(caddr (assoc 10 SEnt1))
									MaxX		(cadr (assoc 10 SEnt1))
									MaxY		(caddr (assoc 10 SEnt1))
									StopSrch	nil
							)
							(while	(and	(null StopSrch)
										(null	(setq	ssOne	(ssget	"C"
																		(list (- MinX Fuzz) (- MinY Fuzz))
																		(list (+ MaxX Fuzz) (+ MaxY Fuzz))
																		(list	(cons 0 "POLYLINE")
																				(cons 8 "????CK-###")
																				(cons -4 "<NOT")
																					(cons 8 "-20UCK-405,-20UCK-403,-20UCK-402,-20UCK-401,Conduit")
																				(cons -4 "NOT>")
																		)
																)
												)
										)
									)
									(if Bug (grdraw (list (- MinX Fuzz) (- MinY Fuzz)) (list (+ MaxX Fuzz) (- MinY Fuzz)) -1 1))
									(if Bug (grdraw (list (+ MaxX Fuzz) (- MinY Fuzz)) (list (+ MaxX Fuzz) (+ MaxY Fuzz)) -1 1))
									(if Bug (grdraw (list (+ MaxX Fuzz) (+ MaxY Fuzz)) (list (- MinX Fuzz) (+ MaxY Fuzz)) -1 1))
									(if Bug (grdraw (list (- MinX Fuzz) (+ MaxY Fuzz)) (list (- MinX Fuzz) (- MinY Fuzz)) -1 1))
									(setq	Fuzz		(+ Fuzz 1.0))
									(if (> Fuzz (+ (/ (float sff) 5.0) 65.0))
										(setq	StopSrch	T)
									)
							)
			;;;				(setq	ssOne	(ssget (cdr (assoc 10 SEnt1)) (list (cons 0 "POLYLINE"))))
							(if ssOne
								(setq	EntOne	(entget (ssname ssOne 0))
										LayT		(cdr (assoc 8 EntOne))
										OHUG_Cod	(substr LayT 4 1)
										LayN		(substr LayT 1 3)
										Posn		(- (length Lst_Fd_V) (length (member LayN Lst_Fd_V)))
										E_Fdr_ID	(nth Posn Lst_Fd_B)
										OPhas	(substr LayT 8 1)
										OkV		(substr LayT 9 2)
										Bubba	(if Bug (princ (strcat "\n E_Fdr_ID [Inherit] => {" E_Fdr_ID "}")))
										Bubba	(if Bug (princ (strcat "\n OHUG_Cod [Inherit] => {" OHUG_Cod "}")))
										Bubba	(if Bug (princ (strcat "\n OkV [Inherit] => {" OkV "}")))
										Bubba	(if Bug (princ (strcat "\n OPhas [Inherit] => {" OPhas "}")))
										EntOne	nil
										LayT		nil
										ssOne	nil
									)
							)
							(command "_.Zoom" "P")
						)
					)
				)
				(if (= (cdr (assoc 0 SEnt1)) "INSERT")
					(cond
						((and (= OSubT "105") (= ONope "N"))	; Recloser N.C. = A105
							(setq	SEnt1	(subst (cons 2 "A105") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "LOC_NUM" LocNum)
							)
							(if (and FRat FTyp)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat FRat FTyp))
							)
						)
						((and (= OSubT "105") (= ONope "Y"))	; Recloser N.O. = A169
							(setq	SEnt1	(subst (cons 2 "A169") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "LOC_NUM" LocNum)
							)
							(if (and FRat FTyp)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat FRat FTyp))
							)
						)
						
						((and (= OSubT "193") (= ONope "N"))	; Recloser BiDir N.C. = A193
							(setq	SEnt1	(subst (cons 2 "A193") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "LOC_NUM" LocNum)
							)
							(if (and FRat FTyp)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat FRat FTyp))
							)
						)
						((and (= OSubT "193") (= ONope "Y"))	; Recloser BiDir N.O. = A194
							(setq	SEnt1	(subst (cons 2 "A194") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "LOC_NUM" LocNum)
							)
							(if (and FRat FTyp)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat FRat FTyp))
							)
						)
						
						((and (= OSubT "190") (= ONope "N"))	; F-Type Switch N.C. = A190
							(setq	SEnt1	(subst (cons 2 "A190") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "LOC_NUM" LocNum)
							)
							(if (and FRat FTyp)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat FRat FTyp))
							)
						)
						((and (= OSubT "190") (= ONope "Y"))	; F-Type Switch N.O. = A191
							(setq	SEnt1	(subst (cons 2 "A191") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "LOC_NUM" LocNum)
							)
							(if (and FRat FTyp)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat FRat FTyp))
							)
						)
						
						((and (= OSubT "164") (= ONope "N"))	; Breaker N.C. = A164
							(setq	SEnt1	(subst (cons 2 "A164") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "LOC_NUM" LocNum)
							)
							(if (and FRat FTyp)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat FRat FTyp))
							)
						)
						((and (= OSubT "164") (= ONope "Y"))	; Breaker N.O. = A181
							(setq	SEnt1	(subst (cons 2 "A181") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "LOC_NUM" LocNum)
							)
							(if (and FRat FTyp)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat FRat FTyp))
							)
						)
						
						((and (= OSubT "109") (= ONope "Y"))	; OpenCirc N.O. = A114
							(setq	SEnt1	(subst (cons 2 "A114") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "LOC_NUM" LocNum)
							)
							(if (and FRat FTyp)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat FRat FTyp))
							)
						)
						((and (= OSubT "109") (= ONope "N"))	; OpenCirc N.C. = A109
							(setq	SEnt1	(subst (cons 2 "A109") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "LOC_NUM" LocNum)
							)
							(if (and FRat FTyp)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat FRat FTyp))
							)
						)
						
						((and (= OSubT "123") (= ONope "Y"))	; Auto Contact N.O. = A171
							(setq	SEnt1	(subst (cons 2 "A171") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "LOC_NUM" LocNum)
							)
							(if (and FRat FTyp)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat FRat FTyp))
							)
						)
						((and (= OSubT "123") (= ONope "N"))	; Auto Contact N.C. = A123
							(setq	SEnt1	(subst (cons 2 "A123") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "LOC_NUM" LocNum)
							)
							(if (and FRat FTyp)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat FRat FTyp))
							)
						)
						
						((and (= OSubT "118") (= ONope "Y"))	; Cubicle Switch N.O. = A085
							(setq	SEnt1	(subst (cons 2 "A085") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "LOC_NUM" LocNum)
							)
							(if (and FRat FTyp)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat FRat FTyp))
							)
						)
						((and (= OSubT "118") (= ONope "N"))	; Cubicle Switch N.C. = A084
							(setq	SEnt1	(subst (cons 2 "A084") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "LOC_NUM" LocNum)
							)
							(if (and FRat FTyp)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat FRat FTyp))
							)
						)
						
						((and (= OSubT "124") (= ONope "Y"))	; Disconnect N.O. = A172
							(setq	SEnt1	(subst (cons 2 "A172") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "LOC_NUM" LocNum)
							)
							(if (and FRat FTyp)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat FRat FTyp))
							)
						)
						((and (= OSubT "124") (= ONope "N"))	; Disconnect N.C. = A124
							(setq	SEnt1	(subst (cons 2 "A124") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "LOC_NUM" LocNum)
							)
							(if (and FRat FTyp)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat FRat FTyp))
							)
						)
						
						((and (= OSubT "125") (= ONope "Y"))	; Fused Cutout N.O. = A170
							(setq	SEnt1	(subst (cons 2 "A170") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "LOC_NUM" LocNum)
							)
							(if (and FRat FTyp)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat FRat FTyp))
							)
						)
						((and (= OSubT "125") (= ONope "N"))	; Fused Cutout N.C. = A125
							(setq	SEnt1	(subst (cons 2 "A125") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "LOC_NUM" LocNum)
							)
							(if (and FRat FTyp)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat FRat FTyp))
							)
						)
						
						((and (= OSubT "126") (= ONope "Y"))	; Gang N.O. = A173
							(setq	SEnt1	(subst (cons 2 "A173") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "LOC_NUM" LocNum)
							)
							(if (and FRat FTyp)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat FRat FTyp))
							)
						)
						((and (= OSubT "126") (= ONope "N"))	; Gang N.C. = A126
							(setq	SEnt1	(subst (cons 2 "A126") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "LOC_NUM" LocNum)
							)
							(if (and FRat FTyp)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat FRat FTyp))
							)
						)
						
						((and (= OSubT "108") (= ONope "Y"))	; Power Fuse N.O. = A065
							(setq	SEnt1	(subst (cons 2 "A065") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "LOC_NUM" LocNum)
							)
							(if (and FRat FTyp)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat FRat FTyp))
							)
						)
						((and (= OSubT "108") (= ONope "N"))	; Power Fuse N.C. = A131
							(setq	SEnt1	(subst (cons 2 "A131") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "LOC_NUM" LocNum)
							)
							(if (and FRat FTyp)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat FRat FTyp))
							)
						)
						
						((= OSubT "135")					; Anchor = U135
							(setq	SEnt1	(subst (cons 2 "U135") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
						)
						((= OSubT "101")					; Capacitor = A101
							(setq	SEnt1	(subst (cons 2 "A101") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
						)
						((= OSubT "163")					; Capacitor = A101
							(setq	SEnt1	(subst (cons 2 "A101") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
						)
						((= OSubT "107")					; Switching Junction = A147
							(setq	SEnt1	(subst (cons 2 "A147") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if (not (null TTyp))
								(UpdAttVals SEnt1 "LOC_NUM" TTyp)
							)
						)
						((= OSubT "153")					; Government Light = U153
							(setq	SEnt1	(subst (cons 2 "U153") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if (and BSiz BTyp)
								(UpdAttVals SEnt1 "LOC_NUM" (strcat BSiz BTyp))
							)
						)
						((= OSubT "149")					; Private Light = U149
							(setq	SEnt1	(subst (cons 2 "U149") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if (and BSiz BTyp)
								(UpdAttVals SEnt1 "LOC_NUM" (strcat BSiz BTyp))
							)
						)
						((= OSubT "143")					; Meter Pedestal = A150
							(setq	SEnt1	(subst (cons 2 "A150") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
						)
						((= OSubT "113")					; Secondary Pedestal = A160
							(setq	SEnt1	(subst (cons 2 "A160") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
						)
;						((= OSubT "138")					; Distribution Pole = U138
;							(setq	SEnt1	(subst (cons 2 "U138") (assoc 2 SEnt1) SEnt1)
;									Bubba	(entmod SEnt1)
;							)
;							(if PHgt
;								(UpdAttVals SEnt1 "HGT" PHgt)
;							)
;							(if PCls
;								(UpdAttVals SEnt1 "CLS" PCls)
;							)
;						)

;						((= OSubT "139")					; Foreign Pole = U139
;							(setq	SEnt1	(subst (cons 2 "U139") (assoc 2 SEnt1) SEnt1)
;									Bubba	(entmod SEnt1)
;							)
;							(if PHgt
;								(UpdAttVals SEnt1 "HGT" PHgt)
;							)
;							(if PCls
;								(UpdAttVals SEnt1 "CLS" PCls)
;							)
;						)

						((= OSubT "168")					; Transmission Pole = U168
							(setq	SEnt1	(subst (cons 2 "U168") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if PHgt
								(UpdAttVals SEnt1 "HGT" PHgt)
							)
							(if PCls
								(UpdAttVals SEnt1 "CLS" PCls)
							)
						)

						((= OSubT "157")					; Transmission Pole = U168
							(setq	SEnt1	(subst (cons 2 "U168") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if PHgt
								(UpdAttVals SEnt1 "HGT" PHgt)
							)
							(if PCls
								(UpdAttVals SEnt1 "CLS" PCls)
							)
						)

						((= OSubT "140")					; Pothead - Riser = A140
							(setq	SEnt1	(subst (cons 2 "A140") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
						)
						((= OSubT "166")					; DA Switchgroup = A156
							(setq	SEnt1	(subst (cons 2 "A156") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
						)
						((= OSubT "178")					; Padmount Switch = A078
							(setq	SEnt1	(subst (cons 2 "A078") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if TTyp
								(UpdAttVals SEnt1 "DESCRIPT" TTyp)
							)
						)
						((= OSubT "129")					; OH 1 Phase Transformer = A154
							(setq	SEnt1	(subst (cons 2 "A078") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if (and kVRat OPhas)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat kVRat " " OPhas))
							)
						)
						((= OSubT "179")					; OH 2 Phase Transformer = A154
							(setq	SEnt1	(subst (cons 2 "A078") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if (and kVRat OPhas)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat kVRat " " OPhas))
							)
						)
						((= OSubT "131")					; OH 3 Phase Transformer = A158
							(setq	SEnt1	(subst (cons 2 "A078") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if (and kVRat OPhas)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat kVRat " " OPhas))
							)
						)
						((= OSubT "130")					; OH 3 Phase Transformer WYE = A157
							(setq	SEnt1	(subst (cons 2 "A078") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if (and kVRat OPhas)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat kVRat " " OPhas))
							)
						)
						((= OSubT "122")					; OH step up/down Transformer = A122
							(setq	SEnt1	(subst (cons 2 "A122") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if (and kVRat OPhas)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat kVRat " " OPhas))
							)
						)
						((= OSubT "119")					; UG 1 Phase Transformer = A116
							(setq	SEnt1	(subst (cons 2 "A078") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if (and kVRat OPhas)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat kVRat " " OPhas))
							)
						)
						((= OSubT "161")					; UG 2 Phase Transformer = A116
							(setq	SEnt1	(subst (cons 2 "A078") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if (and kVRat OPhas)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat kVRat " " OPhas))
							)
						)
						((= OSubT "159")					; UG 3 Phase Transformer = A159
							(setq	SEnt1	(subst (cons 2 "A078") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if (and kVRat OPhas)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat kVRat " " OPhas))
							)
						)
						((= OSubT "111")					; UG 3 Phase Transformer WYE = A115
							(setq	SEnt1	(subst (cons 2 "A078") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if (and kVRat OPhas)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat kVRat " " OPhas))
							)
						)
						((= OSubT "110")					; UG step up/down Transformer = A122
							(setq	SEnt1	(subst (cons 2 "A122") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if (and kVRat OPhas)
								(UpdAttVals SEnt1 "DESCRIPT" (strcat kVRat " " OPhas))
							)
						)
						((= OSubT "103")					; Handhole = U103
							(setq	SEnt1	(subst (cons 2 "U103") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
						)
						((= OSubT "142")					; Manhole = U142
							(setq	SEnt1	(subst (cons 2 "A163") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
						)
						((= OSubT "144")					; Pull Box = U116
							(setq	SEnt1	(subst (cons 2 "A166") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
						)
						((= OSubT "145")					; Terminating Cabinet = U145
							(setq	SEnt1	(subst (cons 2 "A162") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
						)
						((= OSubT "146")					; Transclosure = A077
							(setq	SEnt1	(subst (cons 2 "A077") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
						)
						((= OSubT "147")					; Vault = U147
							(setq	SEnt1	(subst (cons 2 "A161") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
						)
						((= OSubT "141")					; Cable Marker = U094
							(setq	SEnt1	(subst (cons 2 "U094") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
							(if LocNum
								(UpdAttVals SEnt1 "###" LocNum)
							)
						)
						((= OSubT "177")					; Stub Up = U177
							(setq	SEnt1	(subst (cons 2 "U177") (assoc 2 SEnt1) SEnt1)
									Bubba	(entmod SEnt1)
							)
						)
					)
				)
				(if Bug
					(if (= (cdr (assoc 0 SEnt1)) "INSERT")
						(if (and LocNum E_Fdr_ID)
							(princ (strcat "\nChkDevExist{" (itoa CntR) "/" (itoa ssLen) "} {" LocNum "} {" E_Fdr_ID "} {" (cdr (assoc 2 SEnt1)) "}"))
						)
					)
				)
				(if (= (cdr (assoc 0 SEnt1)) "INSERT")
					(if (and LocNum E_Fdr_ID (/= (strlen E_Fdr_ID) 0) (/= (strlen LocNum) 0) (/= "False" (MyChkDevObj LocNum E_Fdr_ID (cdr (assoc 2 SEnt1)))))
						(if (setq	Virt_ID	(MyChkDev_ID_Obj LocNum E_Fdr_ID (cdr (assoc 2 SEnt1))))
							(progn
								(setq	VLay_ID	(MyChkLayNamObj Virt_ID)
										VDescrp	(MyChkDevDescObj Virt_ID)
								)
								(if (and LocNum E_Fdr_ID)
									(princ (strcat "\nMyChkDev_ID_Obj{" (itoa CntR) "/" (itoa ssLen) "} {" LocNum "} {" E_Fdr_ID "} {" (cdr (assoc 2 SEnt1)) "}"))
								)
								(setq	APID		"VIRT_ID")
								(if (null (tblsearch "APPID" APID))
									(regapp APID)
								)
								(if (not (null Virt_ID))
									(setq	xd		(list APID (cons 1000 Virt_ID))
											xd		(list -3 xd)
											Bubba	(entmod (append SEnt1 (list xd)))
											Bubba	(entupd (cdr (assoc -1 SEnt1)))
									)
								)
								(if (/= (cdr (assoc 8 SEnt1)) VLay_ID)
									(setq	Bubba	(if (not (LayChk VLay_ID)) (MkLay VLay_ID))
											SEnt1	(subst (cons 8 VLay_ID) (assoc 8 SEnt1) SEnt1)
											Bubba	(entmod SEnt1)
									)
								)
								(if (/= "False" VDescrp)
									(setq	Bubba	(UpdAttVals SEnt1 "DESCRIPT" VDescrp))
								)
							)
							(progn
								(command "_.Zoom" "C" (cdr (assoc 10 SEnt1)) (/ (float sff) 0.5))
								(setq	LayWas2	(getvar "CLAYER")
										Bubba	(setvar "CLAYER" "-20UCK-405")
								)
								(redraw (cdr (assoc -1 SEnt1)) 3)
								(command "_.Text" "S" "LocBlk" "J" "M" 
											(cdr (assoc 10 SEnt1)) 
											(/ (cdr (assoc 41 SEnt1)) 2.0)
											(angtos (+ (cdr (assoc 50 SEnt1)) (/ pi 2.0)))
											(strcat "Blk{" (cdr (assoc 2 SEnt1)) "} LocNum{" LocNum "} on %%C" (if OPhas OPhas "Unk") " in OH")
								)
								(command)
								(setvar "CLAYER" LayWas2)
								(if eLst_Erase
									(setq	eLst_Erase	(cons (cdr (assoc -1 SEnt1)) eLst_Erase))
									(setq	eLst_Erase	(list (cdr (assoc -1 SEnt1))))
								)
								(command "_.Zoom" "P")
							)
						)
					)
				)
				(setq	APID		"RNAME")
				(if (null (tblsearch "APPID" APID))
					(regapp APID)
				)
				(if (not (null RName))
					(setq	xd		(list APID (cons 1000 RName))
							xd		(list -3 xd)
							Bubba	(entmod (append SEnt1 (list xd)))
							Bubba	(entupd (cdr (assoc -1 SEnt1)))
					)
				)
				(setq	APID		"ATAG")
				(if (null (tblsearch "APPID" APID))
					(regapp APID)
				)
				(if (not (null ATag))
					(setq	xd		(list APID (cons 1000 ATag))
							xd		(list -3 xd)
							Bubba	(entmod (append SEnt1 (list xd)))
							Bubba	(entupd (cdr (assoc -1 SEnt1)))
					)
				)
				(setq	APID		"SUBTCD")
				(if (null (tblsearch "APPID" APID))
					(regapp APID)
				)
				(if (not (null OSubT))
					(setq	xd		(list APID (cons 1000 OSubT))
							xd		(list -3 xd)
							Bubba	(entmod (append SEnt1 (list xd)))
							Bubba	(entupd (cdr (assoc -1 SEnt1)))
					)
				)
				(setq	APID		"PTAG")
				(if (null (tblsearch "APPID" APID))
					(regapp APID)
				)
				(if (not (null PTag))
					(setq	xd		(list APID (cons 1000 PTag))
							xd		(list -3 xd)
							Bubba	(entmod (append SEnt1 (list xd)))
							Bubba	(entupd (cdr (assoc -1 SEnt1)))
					)
				)
				(if (and E_Fdr_ID OHUG_Cod OkV OPhas)
				  (if (> (strlen E_Fdr_ID) 1)
						(progn
							(LayApp SEnt1 E_Fdr_ID OHUG_Cod OkV OPhas OLNum ONope OSubT)
							(setq	E_Fdr_ID	nil)
						)
				  )
				)
				(if (= (cdr (assoc 0 SEnt1)) "INSERT")
					(if (and AttAct (= (cdr (assoc 66 SEnt1)) 1))
						(setq	AttCom	"NR"
								EntM		(cdr (assoc -1 SEnt1))
								Bubba	(AttAct)
						)
					)
				)
				(setq ct (+ ct 1))
			)
		)
	)
	(princ)
)

(defun UpdAttVals ( SEnt1 ValNam ValVal / SEnt2 ); Updates Matching Attribute Values
	(if (= (cdr (assoc 2 (entget (entnext (cdr (assoc -1 SEnt1)))))) ValNam)
		(setq	SEnt2	(entget (entnext (cdr (assoc -1 SEnt1))))
				SEnt2	(subst (cons 1 ValVal) (assoc 1 SEnt2) SEnt2)
				Bubba	(entmod SEnt2)
				Bubba	(entupd (cdr (assoc -1 SEnt1)))
		)
		(if (= (cdr (assoc 2 (entget (entnext (cdr (assoc -1 (entget (entnext (cdr (assoc -1 SEnt1)))))))))) ValNam)
			(setq	SEnt2	(entget (entnext (cdr (assoc -1 (entget (entnext (cdr (assoc -1 SEnt1))))))))
					SEnt2	(subst (cons 1 ValVal) (assoc 1 SEnt2) SEnt2)
					Bubba	(entmod SEnt2)
					Bubba	(entupd (cdr (assoc -1 SEnt1)))
			)
		)
	)
)

(defun LayApp (	SEnt1 E_Fdr_ID OHUG_Cod OkV	; Relayers items based on input
				OPhas OLNum ONope OSubT / )
	(setq	LayN		nil)
	(if (and E_Fdr_ID Lst_Fd_B)
		(if (member E_Fdr_ID Lst_Fd_B)
			(setq	Posn		(- (length Lst_Fd_B) (length (member E_Fdr_ID Lst_Fd_B)))
					LayN		(nth Posn Lst_Fd_V)
					LayC		(nth Posn Lst_Fd_C)
			)
		)
	)
	(if (or (null NClr) (= NClr 0) (= NClr 256))
		(if (and LayN OHUG_Cod)
			(if (= OHUG_Cod "O")	;(member (strcase OHUG_Cod) (list "O" "U"))
				(setq	LayN		(strcat LayN (strcase OHUG_Cod)))
				(setq	LayN		(strcat LayN "U"))
			)
		)
		(if (assoc NClr Lst_UnqClrVal)
			(setq	LayN		(strcat LayN (cdr (assoc NClr Lst_UnqClrVal))))
			(alert (strcat "\n*LayApp Error*=>\tCannot LookUp NClr value [" (itoa NClr) "] from Lst_UnqClrVal!"))
		)
	)
	(if (and LayN SEnt1)
		(if (or (= (cdr (assoc 0 SEnt1)) "LINE") (= (cdr (assoc 0 SEnt1)) "POLYLINE") (= (cdr (assoc 0 SEnt1)) "LWPOLYLINE"))
			(setq	LayN		(strcat LayN "CK-"))
			(if (wcmatch (cdr (assoc 2 SEnt1)) "U*")
				(setq	LayN		(strcat LayN "PL-"))
				(setq	LayN		(strcat LayN "SW-"))
			)
		)
	)
	(if (and LayN OPhas)
		(cond
			((> (strlen OPhas) 2)
				(setq	LayN		(strcat LayN "0"))
			)
			((or (= OPhas "AB") (= OPhas "BA"))
				(setq	LayN		(strcat LayN "1"))
			)
			((or (= OPhas "AC") (= OPhas "CA"))
				(setq	LayN		(strcat LayN "2"))
			)
			((or (= OPhas "CB") (= OPhas "BC"))
				(setq	LayN		(strcat LayN "3"))
			)
			((= OPhas "A")
				(setq	LayN		(strcat LayN "4"))
			)
			((= OPhas "B")
				(setq	LayN		(strcat LayN "5"))
			)
			((= OPhas "C")
				(setq	LayN		(strcat LayN "6"))
			)
			((= OPhas "6")
				(setq	LayN		(strcat LayN "6"))
			)
			((= OPhas "5")
				(setq	LayN		(strcat LayN "5"))
			)
			((= OPhas "4")
				(setq	LayN		(strcat LayN "4"))
			)
			((= OPhas "3")
				(setq	LayN		(strcat LayN "3"))
			)
			((= OPhas "2")
				(setq	LayN		(strcat LayN "2"))
			)
			((= OPhas "1")
				(setq	LayN		(strcat LayN "1"))
			)
			((= OPhas "0")
				(setq	LayN		(strcat LayN "0"))
			)
			(T
				(setq	LayN		nil)
			)
		)
	)
	(if (and LayN VCls)
		(cond
			((= (substr VCls 1 2) "4")
				(setq	LayN		(strcat LayN "04"))
			)
			((= (substr VCls 1 2) "12")
				(setq	LayN		(strcat LayN "12"))
			)
			((= (substr VCls 1 2) "13")
				(setq	LayN		(strcat LayN "13"))
			)
			((= (substr VCls 1 2) "20")
				(setq	LayN		(strcat LayN "20"))
			)
			((= (substr VCls 1 2) "23")
				(setq	LayN		(strcat LayN "24"))
			)
			((= (substr VCls 1 2) "25")
				(setq	LayN		(strcat LayN "24"))
			)
			((= (substr VCls 1 2) "35")
				(setq	LayN		(strcat LayN "35"))
			)
		)
		(if (and LayN OkV)
			(cond
				((= OkV "2.4KV")
					(setq	LayN		(strcat LayN "04"))
				)
				((= OkV "4.16KV")
					(setq	LayN		(strcat LayN "04"))
				)
				((= OkV "4.8KV")
					(setq	LayN		(strcat LayN "04"))
				)
				((= OkV "7.2KV")
					(setq	LayN		(strcat LayN "12"))
				)
				((= OkV "7.62KV")
					(setq	LayN		(strcat LayN "13"))
				)
				((= OkV "12.47KV")
					(setq	LayN		(strcat LayN "12"))
				)
				((= OkV "13.2KV")
					(setq	LayN		(strcat LayN "13"))
				)
				((= OkV "13.8KV")
					(setq	LayN		(strcat LayN "12"))
				)
				((= OkV "14.4KV")
					(setq	LayN		(strcat LayN "25"))
				)
				((= OkV "19.9KV")
					(setq	LayN		(strcat LayN "35"))
				)
				((= OkV "22.9KV")
					(setq	LayN		(strcat LayN "23"))
				)
				((= OkV "24.9KV")
					(setq	LayN		(strcat LayN "25"))
				)
				((= OkV "34.5KV")
					(setq	LayN		(strcat LayN "35"))
				)
				((= OkV "12.0KV")
					(setq	LayN		(strcat LayN "12"))
				)
			)
			(if (and LayN OkV_Old (not OkV))
				(cond
					((= OkV_Old "2.4KV")
						(setq	LayN		(strcat LayN "04"))
					)
					((= OkV_Old "4.16KV")
						(setq	LayN		(strcat LayN "04"))
					)
					((= OkV_Old "4.8KV")
						(setq	LayN		(strcat LayN "04"))
					)
					((= OkV_Old "7.2KV")
						(setq	LayN		(strcat LayN "12"))
					)
					((= OkV_Old "7.62KV")
						(setq	LayN		(strcat LayN "13"))
					)
					((= OkV_Old "12.47KV")
						(setq	LayN		(strcat LayN "12"))
					)
					((= OkV_Old "13.2KV")
						(setq	LayN		(strcat LayN "13"))
					)
					((= OkV_Old "13.8KV")
						(setq	LayN		(strcat LayN "12"))
					)
					((= OkV_Old "14.4KV")
						(setq	LayN		(strcat LayN "25"))
					)
					((= OkV_Old "19.9KV")
						(setq	LayN		(strcat LayN "35"))
					)
					((= OkV_Old "22.9KV")
						(setq	LayN		(strcat LayN "23"))
					)
					((= OkV_Old "24.9KV")
						(setq	LayN		(strcat LayN "25"))
					)
					((= OkV_Old "34.5KV")
						(setq	LayN		(strcat LayN "35"))
					)
					((= OkV_Old "12.0KV")
						(setq	LayN		(strcat LayN "12"))
					)
				)
			)
		)
	)
	(if LayN
		(if (not (LayChk LayN))
			(if NClr
				(command "_.Layer" "M" LayN "C" NClr "" "")
				(if LayC
					(command "_.Layer" "M" LayN "C" LayC "" "")
					(command "_.Layer" "M" LayN "")
				)
			)
			(command "_.Layer" "T" LayN "On" LayN "U" LayN "")
		)
	)
	(if (and LayN SEnt1)
		(setq	SEnt1	(subst (cons 8 LayN) (assoc 8 SEnt1) SEnt1)
				Bubba	(entmod SEnt1)
		)
	)
)

(defun DetPrmry ( Ent1 /	EntD Pt1 An1 Ds1	; Detects Primary circuit crossing the boundary of a square insert
						HPi PtA PtB PtC PtD PtE ssPrm Pt_Lst RetVal PtWrk AnW PtI )
	(if Ent1
		(setq	EntD	(entget Ent1 (list "*")))
		(setq	EntD	nil)
	)
	(if (/= (getvar "ATTREQ") 0)
		(setvar "ATTREQ" 0)
	)
	(if EntD
		(if (= (cdr (assoc 0 EntD)) "INSERT")
			(setq	Pt1	(cdr (assoc 10 EntD))
					An1	(cdr (assoc 50 EntD))
					Ds1	(/ (cdr (assoc 41 EntD)) 2.0)
					HPi	(/ pi 2.0)
					PtA	(polar Pt1 An1 Ds1)
					PtB	(polar PtA (+ An1 HPi) Ds1)
					PtC	(polar PtB (+ An1 HPi HPi) (* Ds1 2.0))
					PtD	(polar PtC (+ An1 HPi HPi HPi) (* Ds1 2.0))
					PtE	(polar PtD An1 (* Ds1 2.0))
			)
			(setq	PtB	nil
					PtC	nil
					PtD	nil
					PtE	nil
			)
		)
		(setq	PtB	nil
				PtC	nil
				PtD	nil
				PtE	nil
		)
	)
	(command "_.Zoom" "C" (cdr (assoc 10 EntD)) (/ (float sff) 0.5))
	(setq	ssPrm	nil)
	(if (and PtB PtC)
		(setq	ssPrm	(ssget "F" (list PtB PtC) (list (cons 0 "POLYLINE") (cons 8 "[~-]???CK-###*"))))
	)
	(if ssPrm
		(setq	Pt_Lst	(DetPolyInts ssPrm PtB PtC))
	)
	(setq	ssPrm	nil)
	(if (and PtC PtD)
		(setq	ssPrm	(ssget "F" (list PtC PtD) (list (cons 0 "POLYLINE") (cons 8 "[~-]???CK-###*"))))
	)
	(if ssPrm
		(if Pt_Lst
			(setq	RetVal	(DetPolyInts ssPrm PtC PtD)
					Pt_Lst	(append Pt_Lst RetVal)
			)
			(setq	Pt_Lst	(DetPolyInts ssPrm PtC PtD))
		)
	)
	(setq	ssPrm	nil)
	(if (and PtD PtE)
		(setq	ssPrm	(ssget "F" (list PtD PtE) (list (cons 0 "POLYLINE") (cons 8 "[~-]???CK-###*"))))
	)
	(if ssPrm
		(if Pt_Lst
			(setq	RetVal	(DetPolyInts ssPrm PtD PtE)
					Pt_Lst	(append Pt_Lst RetVal)
			)
			(setq	Pt_Lst	(DetPolyInts ssPrm PtD PtE))
		)
	)
	(setq	ssPrm	nil)
	(if (and PtE PtB)
		(setq	ssPrm	(ssget "F" (list PtE PtB) (list (cons 0 "POLYLINE") (cons 8 "[~-]???CK-###*"))))
	)
	(if ssPrm
		(if Pt_Lst
			(setq	RetVal	(DetPolyInts ssPrm PtE PtB)
					Pt_Lst	(append Pt_Lst RetVal)
			)
			(setq	Pt_Lst	(DetPolyInts ssPrm PtE PtB))
		)
	)
	(setq	ssPrm	nil)
	(if Pt_Lst
		(foreach	PtWrk
				Pt_Lst
				(setq	AnW		(angle Pt1 PtWrk)
						PtI		(polar PtWrk AnW (/ Ds1 2.0))
						Bubba	(command "_.Insert" (strcat _Path-Sym "A167.dwg") PtI Ds1 Ds1 (angtos AnW 0 4))
				)
		)
	)
	(command "_.Zoom" "P")
)

(defun DetPolyInts ( ssPrm PtX PtY /	CntR		; Detects Intersections between Polyline vertices and virtual line
								CntMax PLst PtN PtNew PtGt PtGtLst )
	(if Bug 
		(progn
			(princ "\nUtils.Lsp!DetPolyInts - Enter parameter\n  ssPrm: ")
			(prin1 ssPrm)
			(princ "\n  PtX:  ")
			(prin1 Ptx)
			(princ "\n  PtY:  ")
			(prin1 PtY)
			(princ "\n")
		)
	)
	(setq	CntR		0
			CntMax	(sslength ssPrm)
	)
	(while (< CntR CntMax)
		(setq	PLst		(ReadOPoly (entget (ssname ssPrm CntR))))
		(if PLst
			(setq	PLst	(cdr PLst)
					PLst	(cdr (reverse PLst))
					PLst	(mapcar (quote (lambda (x) (cdr (assoc 10 x)))) PLst)
					PtN	(car PLst)
					PLst	(cdr PLst)
			)
		)
		(if PLst
			(foreach	PtNew
					PLst
					(if (inters PtN PtNew PtX PtY)
						(setq	PtGt		(inters PtN PtNew PtX PtY)
								Bubba	(if Bug
											(princ	(strcat	"\nFound One: {"
															(rtos (car (inters PtN PtNew PtX PtY)) 2 2)
															","
															(rtos (cadr (inters PtN PtNew PtX PtY)) 2 2)
															"}"
													)
											)
										)
						)
						(setq	PtGt		nil)
					)
					(if PtGt
						(if PtGtLst
							(setq	PtGtLst	(cons PtGt PtGtLst))
							(setq	PtGtLst	(list PtGt))
						)
					)
					(setq	PtN	PtNew)
			)
		)
		(setq	CntR		(1+ CntR))
	)
	PtGtLst
)

(defun DispRd_Name ( /	ssRdN EndD CntR CntMax	; Displays Road Names for incoming Shape Files
					PlyD PoLen PickP )
	(if Bug (princ "\nUtils.lsp!DispRd_Name - Entered\n"))
	(if (/= (getvar "ATTREQ") 0)
		(setvar "ATTREQ" 0)
	)
	(if (LayChk "ROADNAME")
		(command	"_.Layer" "T" "ROADNAME" "" "_.Zoom" "E")
	)
	(setq	ssRdN	(ssget "X"	(list	(cons 0 "POLYLINE")
										(cons 8 "ROADNAME")
								)
					)
			EndD		nil
	)
	(if ssRdN
		(if (LayChk "RoadName_Text")
			(command	"_.Layer" "T" "RoadName_Text" "S" "RoadName_Text" "")
			(command	"_.Layer" "M" "RoadName_Text" "C" 4 "" "")
		)
	)
	(if ssRdN
		(if (null (tblsearch "BLOCK" "A101"))
			(setq	Bubba	(command "_.Insert" (strcat _Path-Sym "A101") (getvar "VIEWCTR") "1" "1" "0")
					Bubba	(command "_.Erase" "L" "")
			)
		)
	)
	(if ssRdN
		(setq	EndD		(entget (entlast) (list "*"))
				CntR		0
				CntMax	(sslength ssRdN)
		)
	)
	(if EndD
		(if (= (cdr (assoc 0 EndD)) "INSERT")
			(if (cdr (assoc 66 EndD))
				(if (= (cdr (assoc 66 EndD)) 1)
					(while (/= (cdr (assoc 0 EndD)) "SEQEND")
						(setq	EndD	(entget (entnext (cdr (assoc -1 EndD))) (list "*")))
					)
				)
			)
		)
	)
	(while (< CntR CntMax)
		(setq	PlyD		(entget (ssname ssRdN CntR) (list "*"))
				PoLen	(vla-get-length (vlax-ename->vla-object (ssname ssRdN CntR)))
				VrtLst	(ReadOPoly PlyD)
				VrtLst	(mapcar (quote (lambda (x) (cdr (assoc 10 x)))) (cdr (reverse (cdr VrtLst))))
				PickP	(cons (ssname ssRdN CntR) (list (nth 0 VrtLst)))
		)
		(if (assoc -3 PlyD)
			(if (assoc "RNAME" (cdr (assoc -3 PlyD)))
				(if (< PoLen (* sff 2.0))
					(command "_.Measure" PickP "B" "A101" "Y" (- PoLen 5.0))
					(command "_.Measure" PickP "B" "A101" "Y" (* sff 2.0))
				)
			)
		)
		(command)
		(if (entnext (cdr (assoc -1 EndD)))
			(while (entnext (cdr (assoc -1 EndD)))
				(setq	EndD	(entget (entnext (cdr (assoc -1 EndD))) (list "*")))
				(if EndD
					(if (and (= (cdr (assoc 0 EndD)) "INSERT") (= (cdr (assoc 2 EndD)) "A101"))
						(command	"_.Text" "S" "LocBlk" "J" "M" 
								(cdr (assoc 10 EndD))
								5.0
								(if (and (>= (cdr (assoc 50 EndD)) (dtr 105.0)) (<= (cdr (assoc 50 EndD)) (dtr 255.0)))
									(angtos (+ pi (cdr (assoc 50 EndD))))
									(angtos (cdr (assoc 50 EndD)))
								)
								(cdadr (assoc "RNAME" (cdr (assoc -3 PlyD))))
								"_.Erase" (cdr (assoc -1 EndD)) ""
						)
					)
				)
				(command)
			)
		)
		(setq	CntR	(1+ CntR))
	)
	(setq	ssRdN	nil)
	(if (LayChk "ROADNAME")
		(command	"_.Layer" "T" "0" "ON" "0" "U" "0" "S" "0" "F" "ROADNAME" "")
	)
)

(defun C:WrkPadMA ( /	ssPad CntR CntMax )		; CL for DetPrmry to all PadMounts
	(if Bug (princ "\n{ C:WrkPadMA entered\n"))
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
	(setq	ssPad	(ssget "X"	(list	(cons 0 "INSERT")
										(cons 2 "A078")
								)
					)
			CntR		0
	)
	(if ssPad
		(setq	CntMax	(sslength ssPad))
	)
	(if ssPad
		(while (< CntR CntMax)
			(DetPrmry (ssname ssPad CntR))
			(setq	CntR	(1+ CntR))
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
	(if Bug (princ "\n C:WrkPadMA exited}\n"))
	(princ)
)

(defun GrCir ( GcLst /	DoLoop Cos00 Sin00		; GrDraws Circles, with options
					GcPt GcClr GcHgt GcLoop GcHLt GcAng 
					Cos01 Sin01 DoHgt PtX1 PtX2 PtY1 PtY2 )
	(setq	GcPt		(nth 0 GcLst)
			GcClr	(nth 1 GcLst)
			GcHgt	(nth 2 GcLst)
			GcLoop	(nth 3 GcLst)
			GcHLt	(nth 4 GcLst)
	)
	(if (null GcHgt)
		(setq	GcHgt	(* (getvar "VIEWSIZE") 0.06))
	)
	(if (null GcLoop)
		(setq	GcLoop	1)
	)
	(if (null GcHLt)
		(setq	GcHLt	0)
	)
	(setq	Cos00	1.0
			Sin00	0.0
			GcAng	(/ pi 8.0)
	)
	(while (<= GcAng (+ (* pi 2.0) (/ pi 12.0)))
		(setq	Cos01	(cos GcAng)
				Sin01	(sin GcAng)
				DoHgt	GcHgt
				DoLoop	0
		)
		(while (< DoLoop GcLoop)
			(setq	DoHgt	(* DoHgt 0.75)
					PtX1		(+ (car GcPt)  (* DoHgt Cos00))
					PtX2		(+ (car GcPt)  (* DoHgt Cos01))
					PtY1		(+ (cadr GcPt) (* DoHgt Sin00))
					PtY2		(+ (cadr GcPt) (* DoHgt Sin01))
			)
			(grdraw (list PtX1 PtY1) (list PtX2 PtY2) GcClr GcHLt)
			(setq	DoLoop	(1+ DoLoop))
		)
		(setq	Cos00	Cos01
				Sin00	Sin01
				GcAng	(+ GcAng (/ pi 8.0))
		)
	)
	(princ)
)

(defun ssCir ( ssLst /	Cos00 Sin00 ssAng		; Draws Circles
					Cos01 Sin01 GcPt GcHgt GcFLt PtX1 PtX2 PtY1 PtY2 ssPntLst )
	(setq	GcPt		(nth 0 ssLst)
			GcHgt	(nth 1 ssLst)
			GcFLt	(nth 2 ssLst)
	)
	(if (null GcHgt)
		(setq	GcHgt	(* (getvar "VIEWSIZE") 0.06))
	)
	(setq	Cos00	1.0
			Sin00	0.0
			ssAng	(/ pi 8.0)
	)
	(while (<= ssAng (+ (* pi 2.0) (/ pi 12.0)))
		(setq	Cos01	(cos ssAng)
				Sin01	(sin ssAng)
				PtX1		(+ (car GcPt)  (* GcHgt Cos00))
				PtX2		(+ (car GcPt)  (* GcHgt Cos01))
				PtY1		(+ (cadr GcPt) (* GcHgt Sin00))
				PtY2		(+ (cadr GcPt) (* GcHgt Sin01))
		)
		(if (not ssPntLst)
			(setq	ssPntLst	(list (list PtX1 PtY1) (list PtX2 PtY2)))
			(setq	ssPntLst	(append ssPntLst (list (list PtX2 PtY2))))
		)
		(setq	Cos00	Cos01
				Sin00	Sin01
				ssAng	(+ ssAng (/ pi 8.0))
		)
	)
	ssPntLst
)

(defun C:CGM ( /	AttWas					; Updates Device_ID and other EED fields
				Ent0 Ent1 Ent2 Ent3 xd P_Max P_Num DA_Val dd
				BlpWas CmdWas ColWas EchWas ExWas FilWas LayWas LtWas OsWas TmdWas )
	(if Bug (princ "\n{ C:CGM entered}\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			CmdWas	(getvar "CMDDIA")
			ColWas	(getvar "CECOLOR")
			EchWas	(getvar "CMDECHO")
			ExWas	(getvar "EXPERT")
			FilWas	(getvar "FILEDIA")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			TmdWas	(getvar "TILEMODE")
	)
	
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 3)
		)
	)
	(command "_.UNDO" "_BE")
	(setq	Ent1	(entsel "\nSelect entity to Force Update EED: "))
	(if Ent1
		(if (= (cdr (assoc 66 (entget (car Ent1) (list "*")))) 1)
			(setq	Ent2		(entget (entnext (car Ent1)) (list "*")))
			(setq	Ent2		nil)
		)
	)
	(if (and Ent1 (/= Div "AL"))
		(command "_.DetachURL" Ent1 "")
	)
	(if Ent2
		(if	(or	(and (= (cdr (assoc 2 Ent2)) "LOC_NUM") (< (strlen (cdr (assoc 1 Ent2))) 1))
				(= (cdr (assoc 2 Ent2)) "DESCRIPT")
			)
			(setq	Ent3		(entget (entnext (cdr (assoc -1 Ent2))) (list "*")))
			(setq	Ent3		nil)
		)
	)
	(if Ent2
		(if	(and	(and (= (cdr (assoc 2 Ent2)) "LOC_NUM")  (< (strlen (cdr (assoc 1 Ent2))) 1))
				(and (= (cdr (assoc 2 Ent3)) "DESCRIPT") (> (strlen (cdr (assoc 1 Ent3))) 0))
			)
			(setq	DA_Val	(cdr (assoc 1 Ent3))
					Ent2		(subst (cons 1 DA_Val) (assoc 1 Ent2) Ent2)
					Ent3		(subst (cons 1 "") (assoc 1 Ent3) Ent3)
					DA_Val	nil
					Bubba	(entmod Ent2)
					Bubba	(entmod Ent3)
					Bubba	(entupd (car Ent1))
			)
			(if	(and	(and (= (cdr (assoc 2 Ent2)) "DESCRIPT") (> (strlen (cdr (assoc 1 Ent2))) 0))
					(and (= (cdr (assoc 2 Ent3)) "LOC_NUM") (< (strlen (cdr (assoc 1 Ent3))) 1))
				)
				(setq	DA_Val	(cdr (assoc 1 Ent2))
						Ent3		(subst (cons 1 DA_Val) (assoc 1 Ent3) Ent3)
						Ent2		(subst (cons 1 "") (assoc 1 Ent2) Ent2)
						DA_Val	nil
						Bubba	(entmod Ent2)
						Bubba	(entmod Ent3)
						Bubba	(entupd (car Ent1))
				)
			)
		)
	)
	(if Ent1
		(ChngUm T (car Ent1))
	)
	(if Ent1
		(redraw (car Ent1) 3)
	)
	(if Ent1
		(if (assoc -3 (entget (car Ent1) (list "*")))
			(setq	Ent0	(entget (car Ent1) (list "*"))
					xd	(cdr (assoc -3 Ent0))
			)
			(setq	xd	nil)
		)
	)
	(if xd
		(princ (strcat "\n" (PadCharR "Item" 8) "\tValue"))
	)
	(if xd
		(foreach	dd
				xd
				(princ (strcat "\n" (PadCharR (car dd) 8) "\t" (cdadr dd)))
		)
	)
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CMDECHO" EchWas)
	(setvar "EXPERT" ExWas)
	(setvar "FILEDIA" FilWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "TILEMODE" TmdWas)
	(if Bug (princ "\n{ C:CGM exited}\n"))
	(princ)
)

(defun C:CGA ( /	AttWas ssEnts EntLst CntR	; Updates Device_ID and other EED fields on whole SS
				Ent0 Ent1 Ent2 Ent3 xd P_Max P_Num DA_Val dd CntMax
				BlpWas CmdWas ColWas EchWas ExWas FilWas LayWas LtWas OsWas TmdWas )
	(if Bug (princ "\n{ C:CGA entered}\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			CmdWas	(getvar "CMDDIA")
			ColWas	(getvar "CECOLOR")
			EchWas	(getvar "CMDECHO")
			ExWas	(getvar "EXPERT")
			FilWas	(getvar "FILEDIA")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			TmdWas	(getvar "TILEMODE")
	)
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 3)
		)
	)
	(princ "\nSelect objects to Force update EED: ")
	(setq	EntLst	nil
			Ent1		nil
			ssEnts	(ssget)
	)
	(if ssEnts
		(if (> (setq CntMax (sslength ssEnts)) 0)
			(progn
				(command "_.UNDO" "_BE")
				(setq	CntR		0)
				(while (< CntR CntMax)
					(if EntLst
						(setq	EntLst	(cons (ssname ssEnts CntR) EntLst))
						(setq	EntLst	(list (ssname ssEnts CntR)))
					)
					(setq	CntR	(1+ CntR))
				)
				(setq	CntR		0)
				(foreach	Ent1
						EntLst
						(if Ent1
							(if (= (cdr (assoc 66 (entget Ent1 (list "*")))) 1)
								(setq	Ent2		(entget (entnext Ent1) (list "*")))
								(setq	Ent2		nil)
							)
						)
						(if (and Ent1 (/= Div "AL"))
							(if Ent1
								(command "_.DetachURL" Ent1 "")
							)
						)
						(if Ent2
							(if	(or	(and (= (cdr (assoc 2 Ent2)) "LOC_NUM") (< (strlen (cdr (assoc 1 Ent2))) 1))
									(= (cdr (assoc 2 Ent2)) "DESCRIPT")
								)
								(setq	Ent3		(entget (entnext (cdr (assoc -1 Ent2))) (list "*")))
								(setq	Ent3		nil)
							)
						)
						(if Ent2
							(if	(and	(and (= (cdr (assoc 2 Ent2)) "LOC_NUM") (< (strlen (cdr (assoc 1 Ent2))) 1))
									(and (= (cdr (assoc 2 Ent3)) "DESCRIPT") (> (strlen (cdr (assoc 1 Ent3))) 0))
								)
								(setq	DA_Val	(cdr (assoc 1 Ent3))
										Ent2		(subst (cons 1 DA_Val) (assoc 1 Ent2) Ent2)
										Ent3		(subst (cons 1 "") (assoc 1 Ent3) Ent3)
										DA_Val	nil
										Bubba	(entmod Ent2)
										Bubba	(entmod Ent3)
										Bubba	(entupd Ent1)
								)
								(if	(and	(and (= (cdr (assoc 2 Ent2)) "DESCRIPT") (> (strlen (cdr (assoc 1 Ent2))) 0))
										(and (= (cdr (assoc 2 Ent3)) "LOC_NUM") (< (strlen (cdr (assoc 1 Ent3))) 1))
									)
									(setq	DA_Val	(cdr (assoc 1 Ent2))
											Ent3		(subst (cons 1 DA_Val) (assoc 1 Ent3) Ent3)
											Ent2		(subst (cons 1 "") (assoc 1 Ent2) Ent2)
											DA_Val	nil
											Bubba	(entmod Ent2)
											Bubba	(entmod Ent3)
											Bubba	(entupd Ent1)
									)
								)
							)
						)
						(if Ent1
							(ChngUm T Ent1)
						)
						(if Ent1
							(redraw Ent1 3)
						)
						(if Ent1
							(if (assoc -3 (entget Ent1 (list "*")))
								(setq	Ent0	(entget Ent1 (list "*"))
										xd	(cdr (assoc -3 Ent0))
								)
								(setq	xd	nil)
							)
						)
						(if xd
							(princ (strcat "\n\n" (PadCharR "Item" 8) (PadCharR "\tValue" 9) "->No " (itoa (1+ CntR))))
						)
						(if xd
							(foreach	dd
									xd
									(princ (strcat "\n" (PadCharR (car dd) 8) "\t" (cdadr dd)))
							)
						)
						(setq	CntR	(1+ CntR))
				)
				(command "_.UNDO" "_EN")
			)
		)
	)
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CMDECHO" EchWas)
	(setvar "EXPERT" ExWas)
	(setvar "FILEDIA" FilWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "TILEMODE" TmdWas)
	(if Bug (princ "\n{ C:CGA exited}\n"))
	(princ)
)

(defun C:ShwDat ( /	AttWas				; Updates Device_ID and other EED fields
				Ent0 Ent1 Ent2 Ent3 xd P_Max P_Num DA_Val dd
				BlpWas CmdWas ColWas EchWas ExWas FilWas LayWas LtWas OsWas TmdWas )
	(if Bug (princ "\n{ C:ShwDat entered}\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			CmdWas	(getvar "CMDDIA")
			ColWas	(getvar "CECOLOR")
			EchWas	(getvar "CMDECHO")
			ExWas	(getvar "EXPERT")
			FilWas	(getvar "FILEDIA")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			TmdWas	(getvar "TILEMODE")
	)
	
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 3)
		)
	)
	(command "_.UNDO" "_BE")
	(setq	Ent1	(entsel "\nSelect entity to Display Data: "))
	(if Ent1
		(if (assoc -3 (setq Bubba (entget (car Ent1) (list "*"))))
			(setq	Ent0	(entget (car Ent1) (list "*"))
					xd	(cdr (assoc -3 Ent0))
			)
			(setq	Ent0	(entget (car Ent1) (list "*"))
					xd	nil
			)
		)
	)
	(if xd
		(princ (strcat "\n" (PadCharR "Type" 8) (PadCharR "Item" 8) "\tValue"))
	)
	(if xd
		(foreach	dd
				xd
				(princ (strcat "\n" (PadCharR "EED->" 8) (PadCharR (car dd) 8) "\t" (cdadr dd)))
		)
	)
	(if Ent0
		(if (= (cdr (assoc 0 Ent0)) "INSERT")
			(if (= (cdr (assoc 66 Ent0)) 1)
				(while (= (cdr (assoc 0 (entget (entnext (cdr (assoc -1 Ent0))) (list "*")))) "ATTRIB")
					(setq Ent0 (entget (entnext (cdr (assoc -1 Ent0))) (list "*")))
					(princ (strcat "\n" (PadCharR "Attr->" 8) (PadCharR (cdr (assoc 2 Ent0)) 8) "\t" (cdr (assoc 1 Ent0))))
				)
			)
		)
	)
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CMDECHO" EchWas)
	(setvar "EXPERT" ExWas)
	(setvar "FILEDIA" FilWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "TILEMODE" TmdWas)
	(if Bug (princ "\n{ C:ShwDat exited}\n"))
	(princ)
)

(defun C:AddSLB ( /	AttWas				; Updates Device_ID and other EED fields  Ent0 Ent1 xd EntA EntB EntC EntD EntE EntF EntG DoThr DoFor DoFiv
				BlpWas CmdWas ColWas EchWas ExWas FilWas LayWas LtWas OsWas TmdWas )
	(if Bug (princ "\n{ C:AddSLB entered}\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			CmdWas	(getvar "CMDDIA")
			ColWas	(getvar "CECOLOR")
			EchWas	(getvar "CMDECHO")
			ExWas	(getvar "EXPERT")
			FilWas	(getvar "FILEDIA")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			TmdWas	(getvar "TILEMODE")
			Ent0		nil
			Ent1		nil
			EntA		nil
			EntB		nil
			EntC		nil
			EntD		nil
			EntE		nil
			EntF		nil
			EntG		nil
			DoThr	nil
			DoFor	nil
			DoFiv	nil
			aHgt		nil
			aAng		nil
			aPos		nil
			bPos		nil
	)
	
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 3)
		)
	)
	(command "_.UNDO" "_BE")
	(setq	Ent1		(entsel "\nSelect entity to Add SLB to: "))
	(if Ent1
		(if (assoc -3 (setq Bubba (entget (car Ent1) (list "*"))))
			(setq	Ent0	(entget (car Ent1) (list "*"))
					EntA	Ent0
					xd	(cdr (assoc -3 Ent0))
			)
			(setq	Ent0	(entget (car Ent1) (list "*"))
					EntA	Ent0
					xd	nil
			)
		)
	)
	(if xd
		(if Bug
			(princ (strcat "\n" (PadCharR "Type" 8) (PadCharR "Item" 8) "\tValue"))
		)
	)
	(if xd
		(foreach	dd
				xd
				(if Bug
					(princ (strcat "\n" (PadCharR "EED->" 8) (PadCharR (car dd) 8) "\t" (cdadr dd)))
				)
		)
	)
	(if Ent0
		(if (= (cdr (assoc 0 Ent0)) "INSERT")
			(if (= (cdr (assoc 66 Ent0)) 1)
				(progn
					(while (= (cdr (assoc 0 (entget (entnext (cdr (assoc -1 Ent0))) (list "*")))) "ATTRIB")
						(setq Ent0 (entget (entnext (cdr (assoc -1 Ent0))) (list "*")))
						(if (= (cdr (assoc 2 Ent0)) "LOC_NUM")
							(setq	EntB	Ent0)
						)
						(if (and (= (cdr (assoc 2 Ent0)) "DESCRIPT") (> (strlen (cdr (assoc 1 Ent0))) 0))
							(setq	EntC	Ent0)
						)
						(if (and (= (cdr (assoc 2 Ent0)) "SW_S") (> (strlen (cdr (assoc 1 Ent0))) 0))
							(setq	EntD	Ent0)
						)
						(if (and (= (cdr (assoc 2 Ent0)) "SW_L") (> (strlen (cdr (assoc 1 Ent0))) 0))
							(setq	EntE	Ent0)
						)
						(if (and (= (cdr (assoc 2 Ent0)) "SW_B") (> (strlen (cdr (assoc 1 Ent0))) 0))
							(setq	EntF	Ent0)
						)
						(if Bug
							(princ (strcat "\n" (PadCharR "Attr->" 8) (PadCharR (cdr (assoc 2 Ent0)) 8) "\t" (cdr (assoc 1 Ent0))))
						)
					)
				)
			)
		)
	)
	(if (= (cdr (assoc 0 (entget (entnext (cdr (assoc -1 Ent0))) (list "*")))) "SEQEND")
		(setq EntG (entget (entnext (cdr (assoc -1 Ent0))) (list "*")))
	)
	(if (null EntB)
		(setq	aHgt		10.0
				aAng		0.0
				aPos		(cdr (assoc 10 EntA))
				bPos		(cdr (assoc 11 EntA))
		)
		(if (null EntC)
			(setq	aHgt		(cdr (assoc 40 EntB))
					aAng		(cdr (assoc 50 EntB))
					aPos		(polar (cdr (assoc 10 EntB)) (+ aAng (/ (* pi 3.0) 2.0)) (* aHgt 1.5))
					bPos		(polar (cdr (assoc 11 EntB)) (+ aAng (/ (* pi 3.0) 2.0)) (* aHgt 1.5))
			)
			(if (null EntD)
				(setq	aHgt		(cdr (assoc 40 EntC))
						aAng		(cdr (assoc 50 EntC))
						DoThr	(strcase (getstring T "\nSource Side Switch: "))
						aPos		(polar (cdr (assoc 10 EntC)) (+ aAng (/ (* pi 3.0) 2.0)) (* aHgt 1.5))
						bPos		(polar (cdr (assoc 11 EntC)) (+ aAng (/ (* pi 3.0) 2.0)) (* aHgt 1.5))
				)
				(if (null EntE)
					(setq	aHgt		(cdr (assoc 40 EntD))
							aAng		(cdr (assoc 50 EntD))
							DoFor	(strcase (getstring T "\nLoad Side Switch: "))
							aPos		(polar (cdr (assoc 10 EntD)) (+ aAng (/ (* pi 3.0) 2.0)) (* aHgt 1.5))
							bPos		(polar (cdr (assoc 11 EntD)) (+ aAng (/ (* pi 3.0) 2.0)) (* aHgt 1.5))
					)
					(if (null EntF)
						(setq	aHgt		(cdr (assoc 40 EntE))
								aAng		(cdr (assoc 50 EntE))
								DoFiv	(strcase (getstring T "\nBypass Switch: "))
								aPos		(polar (cdr (assoc 10 EntE)) (+ aAng (/ (* pi 3.0) 2.0)) (* aHgt 1.5))
								bPos		(polar (cdr (assoc 11 EntE)) (+ aAng (/ (* pi 3.0) 2.0)) (* aHgt 1.5))
						)
					)
				)
			)
		)
	)
	(command "_.Erase" Ent1 "")
	(if (and (null EntD) (null DoThr))
		(setq	DoThr	(strcase (getstring T "\nSource Side Switch: ")))
	)
	(if (and (null EntE) (null DoFor))
		(setq	DoFor	(strcase (getstring T "\nLoad Side Switch: ")))
	)
	(if (and (null EntF) (null DoFiv))
		(setq	DoFiv	(strcase (getstring T "\nBypass Switch: ")))
	)
	(if DoThr
		(if (> (strlen DoThr) 0)
			(setq	EntD		(subst (cons 1 (strcat DoThr " S")) (assoc 1 EntB) EntB)
					EntD		(subst (cons 2 "SW_S") (assoc 2 EntD) EntD)
					EntD		(subst (cons 10 aPos) (assoc 10 EntD) EntD)
					EntD		(subst (cons 11 bPos) (assoc 11 EntD) EntD)
					aPos		(polar (cdr (assoc 10 EntD)) (+ aAng (/ (* pi 3.0) 2.0)) (* aHgt 1.5))
					bPos		(polar (cdr (assoc 11 EntD)) (+ aAng (/ (* pi 3.0) 2.0)) (* aHgt 1.5))
			)
		)
	)
	(if DoFor
		(if (> (strlen DoFor) 0)
			(setq	EntE		(subst (cons 1 (strcat DoFor " L")) (assoc 1 EntB) EntB)
					EntE		(subst (cons 2 "SW_L") (assoc 2 EntE) EntE)
					EntE		(subst (cons 10 aPos) (assoc 10 EntE) EntE)
					EntE		(subst (cons 11 bPos) (assoc 11 EntE) EntE)
					aPos		(polar (cdr (assoc 10 EntE)) (+ aAng (/ (* pi 3.0) 2.0)) (* aHgt 1.5))
					bPos		(polar (cdr (assoc 11 EntE)) (+ aAng (/ (* pi 3.0) 2.0)) (* aHgt 1.5))
			)
		)
	)
	(if DoFiv
		(if (> (strlen DoFiv) 0)
			(setq	EntF		(subst (cons 1 (strcat DoFiv " B")) (assoc 1 EntB) EntB)
					EntF		(subst (cons 2 "SW_B") (assoc 2 EntF) EntF)
					EntF		(subst (cons 10 aPos) (assoc 10 EntF) EntF)
					EntF		(subst (cons 11 bPos) (assoc 11 EntF) EntF)
					aPos		(polar (cdr (assoc 10 EntF)) (+ aAng (/ (* pi 3.0) 2.0)) (* aHgt 1.5))
					bPos		(polar (cdr (assoc 11 EntF)) (+ aAng (/ (* pi 3.0) 2.0)) (* aHgt 1.5))
			)
		)
	)
	(entmake EntA)
	(if EntB
		(entmake EntB)
	)
	(if EntC
		(entmake EntC)
	)
	(if EntD
		(entmake EntD)
	)
	(if EntE
		(entmake EntE)
	)
	(if EntF
		(entmake EntF)
	)
	(entmake EntG)
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CMDECHO" EchWas)
	(setvar "EXPERT" ExWas)
	(setvar "FILEDIA" FilWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "TILEMODE" TmdWas)
	(if Bug (princ "\n{ C:AddSLB exited}\n"))
	(princ)
)

(defun GetFilAsLst ( FNam /	FN Inp LstI		; Returns a CDF as a List structure
						LstO Cntr )
	(if (findfile FNam)
		(setq	FN	(open (findfile FNam) "r")
				Inp	(read-line FN)
				Msd	T
		)
	)
	(if Inp
		(if (/= (StpBadChar Inp 2) "")
			(setq	LstI	(read (strcat "(" Inp ")"))
					LstO	(list LstI)
					Cntr	0
					Msd	nil
			)
			(while (and (setq Inp (read-line FN)) Msd)
				(if Inp
					(if (/= (StpBadChar Inp 2) "")
						(setq	LstI	(read (strcat "(" Inp ")"))
								LstO	(if LstO (cons LstI LstO) (list LstI))
								Cntr	0
								Msd	nil
						)
					)
				)
			)
		)
	)
	(if (and Twizzle (not Bug))
		(progn
			(princ "\nBegin File Load:")
			(Twizzle Cntr)
		)
	)
	(if Inp
		(while (setq Inp (read-line FN))
			(if Inp
				(if (/= (StpBadChar Inp 2) "")
					(if (= (ascii Inp) 34)
						(setq	LstI	(read (strcat "(" Inp ")"))
								LstO	(cons LstI LstO)
								Cntr	(1+ Cntr)
						)
					)
				)
				(setq	Cntr	(- 0 Cntr))
			)
			(if (and Twizzle (not Bug))
				(Twizzle Cntr)
			)
		)
	)
	(if (and Twizzle (not Bug))
		(Twizzle (- 0 Cntr))
	)
	(if FN
		(close FN)
	)
	LstO
)

(defun MakViews ( DoOneLst AScl OprP /	PtX LocN	; Makes View Windows for Inserts
								PtXa PtXb )
	(if Bug (princ "\n{ MakViews entered\n"))
	(setq	PtX		(last DoOneLst)
			LocN		(ReplBadChars (nth 1 DoOneLst))
			PtXa		(list (- (car PtX) AScl) (- (cadr PtX) AScl))
			PtXb		(list (+ (car PtX) AScl) (+ (cadr PtX) AScl))
			OprShrN	(nth 11 DoOneLst)
	)
	(if OprP
		(if (> OprShrN 0)
			(command "_.View" "W" LocN PtXa PtXb)
		)
		(command "_.View" "W" LocN PtXa PtXb)
	)
	(if Bug (princ "\n MakViews exited}\n"))
)

(defun PutFilAsLst ( LstIn FNam Fmtr Act /	FN	; Optionally Formats List elements and writes to CDF
									Inp LstI LstO Cntr )
	(if (and LstIn FNam)
		(if (= Act 1)
			(setq	FN	(open FNam "w")
					Cntr	0
			)
			(setq	FN	(open FNam "a")
					Cntr	0
			)
		)
		(setq	FN	nil)
	)
	(if (and Cntr Twizzle (not Bug))
		(progn
			(princ "\nBegin File Save:")
			(Twizzle Cntr)
		)
	)
	(if FN
		(foreach	LstO
				LstIn
				(if Fmtr
					(write-line (Fmtr LstO) FN)
					(write-line LstO FN)
				)
				(setq	Cntr	(1+ Cntr))
				(if (and Cntr Twizzle (not Bug))
					(Twizzle Cntr)
				)
		)
	)
	(if (and Cntr Twizzle (not Bug))
		(Twizzle (- 0 Cntr))
	)
	(if FN
		(close FN)
	)
	LstO
)

(defun ReplBadChars ( Str /	TmpStr )			; Strips out bad characters
	(if Bug (princ "\n{ ReplBadChars entered\n"))
	(setq	Cnt		1
			TmpStr	"X"
			WasVal	(list
						0	;null
						8	;backspace
						9	;tab
						10	;linefeed
						13	;carriage return
						27	;escape
						32	;space
						33	;exclamation
						34	;double-quote
						35	;pound sign
						36	;dollar sign
						37	;percent sign
						38	;ampersand
						39	;reverse single-quote (or escape)
						40	;left parenthesis
						41	;right parenthesis
						42	;asterisk
						43	;plus sign
						44	;comma
						45	;dash
						46	;period
						47	;forward slash
						58	;colon
						59	;semi-colon
						60	;less than
						61	;equal to
						62	;greater than
						63	;question mark
						64	;at sign
						91	;left square bracket
						92	;backslash
						93	;right square bracket
						94	;caret
						95	;underscore
						96	;single-quote
						123	;left curly brace
						124	;vertical pipe
						125	;right curly brace
						126	;tilde
					)
			ShouldBe	"_"
	)
	(if Str
		(if (>= (strlen Str) 1)
			(while (<= Cnt (strlen Str))
				(if	(not	(member (ascii (substr Str Cnt 1)) WasVal))
					(setq	TmpStr	(strcat TmpStr (strcase (substr Str Cnt 1))))
					(setq	TmpStr	(strcat TmpStr ShouldBe))
				)
				(setq	Cnt		(1+ Cnt))
			)
		)
	)
	(if (> (strlen TmpStr) 1)
		(setq	TmpStr	(substr TmpStr 2))
		(setq	TmpStr	"")
	)
	(if Bug (princ "\n ReplBadChars exited}\n"))
	TmpStr
)

(defun FndKey ( Dev /	CCnt MaxRec			; Finds and displays items matching Key
					NoMatch ssDev CNam ETrg EDat Cnt EntDatOut )
	(if Dev
		(setq	CCnt		0
				NoMatch	T
		)
	)
	(if (and Dev (not ssDevOutLst))
		(progn
			(setq	ssDev	(ssget "X" (list (cons 0 "INSERT")(cons 2 "SubPos") (cons -4 "<OR") (cons 8 "Sub_Stomp") (cons 8 "Sub_LUT") (cons -4 "OR>"))))
			(if ssDev
				(setq	Cnt			0
						MaxRec		(sslength ssDev)
						Bubba		(princ (strcat "\nAnalyzing Panel {" (getvar "DWGNAME") "} for EMB with {" (itoa MaxRec) "} records: " ))
				)
			)
			(if ssDev
				(while (< Cnt MaxRec)
					(setq	EntDatOut	(EntDatLstR (ssname ssDev Cnt)))
					(if ssDevOutLst
						(setq	ssDevOutLst	(cons EntDatOut ssDevOutLst))
						(setq	ssDevOutLst	(list EntDatOut))
					)
					(if (not Bug)
						(Twaddle Cnt MaxRec)
						(princ (strcat "\n[Bug] Working Record:{" (itoa Cnt) "}"))
					)
					(setq	Cnt	(1+ Cnt))
				)
			)
			(if (not Bug)
				(Twaddle (- 0 Cnt) MaxRec)
				(princ (strcat "\n[Bug] Work Complete"))
			)
			(if ssDev
				(princ (strcat "\n C:FindKey ->Got {" (itoa MaxRec) "} items from ssDev into ssDevOutLst!"))
			)
			(if ssDev
				(setq	ssDev	nil
						Bubba	(gc)
				)
			)
		)
	)
	(if ssDevOutLst
		(while (and (setq CNam (nth CCnt ssDevOutLst)) NoMatch)
			(if CNam
				(if (= (nth 9 CNam) 1)
					(if	(wcmatch	(strcase (nth 1 (assoc "KEY" (cdr (nth 10 CNam)))))
								(strcase Dev)
						)
						(setq	ETrg		(handent (nth 1 CNam))
								NoMatch	nil
						)
					)
				)
			)
			(setq	CCnt	(1+ CCnt))
		)
	)
	(if ETrg
		(setq	EDat		(entget ETrg (list "*"))
				Bubba	(command "_.Zoom" "C" (cdr (assoc 10 EDat)) 10000.0)
				Bubba	(princ (strcat "\nFndKey Found the target insert, handle[" (cdr (assoc 5 EDat)) "]!"))
		)
		(princ "\nFndKey did not find the target insert!")
	)
	ETrg
)

(defun C:FindKey ( /	AttWas				; Finds Text, Polyline or Insert with the ID given
					BlpWas CmdWas ColWas EchWas ExWas FilWas LayWas LtWas OsWas TmdWas FndStr )
	(if Bug (princ "\n{ C:FindKey entered}\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			CmdWas	(getvar "CMDDIA")
			ColWas	(getvar "CECOLOR")
			EchWas	(getvar "CMDECHO")
			ExWas	(getvar "EXPERT")
			FilWas	(getvar "FILEDIA")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			TmdWas	(getvar "TILEMODE")
	)
	
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
		)
	)
	(command "_.UNDO" "_BE")
	
	(setq	FndStr	(getstring "\nEnter the Key ID you are searching for: "))
	(if FndStr
		(FndKey FndStr)
	)
	
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CMDECHO" EchWas)
	(setvar "EXPERT" ExWas)
	(setvar "FILEDIA" FilWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "TILEMODE" TmdWas)
	(if Bug (princ "\n{ C:FindKey exited}\n"))
	(princ)
)

(defun ValiStrLst ( Lst DigLen /	OutLst		; Validates that Lists of Strings contain correct length stings 
							Itm Accept )
	(if Bug (princ "\n{ValiStrLst entered\n"))
	(setq	OutLst	nil)
	(if Lst
		(if (= (type Lst) (quote LIST))
			(setq	Accept	T)
			(setq	Accept	nil)
		)
		(setq	Accept	nil)
	)
	(if Accept
		(foreach	Itm
				Lst
				(if (= (strlen Itm) DigLen)
					(if OutLst
						(setq	OutLst	(cons Itm OutLst))
						(setq	OutLst	(list Itm))
					)
				)
		)
	)
	(if Bug (princ "\nValiStrLst exited}\n"))
	(if OutLst
		(reverse OutLst)
		nil
	)
)

(defun C:LayUpd ( / CntR CntMax x y z )		;Updates phasing for Hi Side layers
	(command	"_.LAYER" "T" "*" "On" "*" "U" "*" "S" "0" "" "_.Zoom" "E" "_.Zoom" "0.8x")
	(setq	LayLst	(LayWhat)
			LayFix	nil
			LayRep	nil
	)
	(mapcar	(quote	(lambda (x)
						(if (wcmatch (car x) "??#????[-123456]##")
							(if LayFix
								(setq	LayFix	(cons (car x) LayFix))
								(setq	LayFix	(list (car x)))
							)
						)
					)
			)
			(car LayLst)
	)
	(if LayFix
		(setq	LayRep	(mapcar (quote (lambda (y) (strcat (substr y 1 7) "0" (substr y 9 2)))) LayFix)
				LayWrk	(apply (quote strcat) (mapcar (quote (lambda (z) (strcat "," z))) LayRep))
				LayWrk	(substr LayWrk 2)
				CntR		0
				CntMax	(length LayFix)
				Bubba	(princ (strcat "\n C:LayUpd found [" (itoa CntMax) "] layers {" LayWrk "} to fix phase on..."))
		)
	)
	(if (and LayFix LayRep)
		(while (< CntR CntMax)
			(command "_.Rename" "LA" (nth CntR LayFix) (nth CntR LayRep))
			(setq	CntR	(1+ CntR))
		)
	)
	(setq	ssWrk	(ssget "X" (list (cons 8 LayWrk))))
	(if ssWrk
		(ChngUm T ssWrk)
	)
	(if ssWrk
		(setq	ssWrk	nil)
	)
	(gc)
	(C:Validoit)
	(C:LayUp)
	(C:Save)
	(princ)
)

(defun RemChr (ChrRem StrIn /	NewStr CntR )	;Recursively Removes Character from String
	(if Bug (princ "\n RemChr entered."))
	(if (wcmatch StrIn (STRCAT "*" ChrRem "*"))
		(progn
			(setq	LenStr	(strlen StrIn)
					CntR		1
					NewStr	"")
			(While (<= CntR LenStr)
				(if (/= (strcase (substr StrIn CntR 1)) (strcase ChrRem))
					(setq NewStr (strcat NewStr (substr StrIn CntR 1)))
				)
				(setq	CntR	(1+ CntR))
			)
			(RemChr ChrRem NewStr) 
		)
		(setq NewStr StrIn)
	)
	(if Bug (princ "\n RemChr exited."))
	NewStr
)

(defun OpnDwg ( DwgNam Action /	acadObject	;Multi- or Single-document Open command (Revised for Acad 2004+)
							acadDocs acadTemp )
	(if Bug 
		(progn 
			(princ "\nUtils.Lsp-OpnDwg - Start \n")
			(princ (strcat "  Parameters DwgName: " DwgNam "\n  Action: "))
			(prin1 Action)
			(princ "\n")
		)
	)
	(if (findfile DwgNam)
		(cond
			((and (= (getvar "SDI") 0) (= Action 1))		;Multi-document with File Save
				(if (/= (getvar "AcadLspAsDoc") 1)
					(setvar "AcadLspAsDoc" 1)
				)
				(if (/= (getvar "LispInit") 1)
					(setvar "LispInit" 1)
				)
				(if (> (getvar "DBMOD") 0)
					(command "_.QSave")
				)
				(setq	acadObject	(vlax-get-acad-object)
						acadDocs		(vla-get-Documents acadObject)
						acadTemp		(vla-open acadDocs (findfile DwgNam))
						Bubba		(vla-activate acadTemp)
				)
			)
			((and (= (getvar "SDI") 0) (= Action 0))		;Multi-document without File Save
				(if (/= (getvar "AcadLspAsDoc") 1)
					(setvar "AcadLspAsDoc" 1)
				)
				(if (/= (getvar "LispInit") 1)
					(setvar "LispInit" 1)
				)
				(setq	acadObject	(vlax-get-acad-object)
						acadDocs		(vla-get-Documents acadObject)
						acadTemp		(vla-open acadDocs (findfile DwgNam))
						Bubba		(vla-activate acadTemp)
				)
			)
			((and (= (getvar "SDI") 1) (= Action 1))		;Single-document with File Save
				(command "_.QSave")
				(command "_.Open" (findfile DwgNam))
			)
			((and (= (getvar "SDI") 1) (= Action 0))		;Single-document without File Save
				(if (> (getvar "DBMOD") 0)
					(command "_.Open" "Y" (findfile DwgNam))
					(command "_.Open" (findfile DwgNam))
				)
			)
		)
	)
	(if Bug (princ "\nUtils.Lsp-OpnDwg - Done \n"))
	(princ)
)

(defun NewDwg ( Action DwtNam /	acadObject	;Multi- or Single-document New command (Revised for Acad 2004+)
							acadDocs acadTemp MyDwt )
	(if Bug
		(princ (strcat "\nUtils.Lsp NewDwg - Entered with" "\n Action = " (itoa Action) "\n DwtNam = " DwtNam "\n"))
	)
	(if DwtNam									;If passed-in Template file
		(if (findfile DwtNam)
			(setq	MyDwt	(findfile DwtNam))
			(if (findfile (strcat (getvar "LocalRootPrefix") "Template\\" DwtNam))
				(setq	MyDwt	(findfile (strcat (getvar "LocalRootPrefix") "Template\\" DwtNam)))
				(setq	MyDwt	nil)
			)
		)
	)
	(if (not MyDwt)								;If Global App-based Template file
		(if AppDwtNam
			(if (findfile AppDwtNam)
				(setq	MyDwt	(findfile AppDwtNam))
				(if (findfile (strcat (getvar "LocalRootPrefix") "Template\\Acad.dwt"))
					(setq	MyDwt	(findfile (strcat (getvar "LocalRootPrefix") "Template\\Acad.dwt")))
					(setq	MyDwt	"Acad.dwt")
				)
			)
		)
	)
	(if MyDwt
		(cond
			((and (= (getvar "SDI") 0) (= Action 1))	;Multi-document with File Save
				(if Bug
					(princ "\nUtils.Lsp-NewDwg - Multi-document with File Save \n")
				)
				(if (/= (getvar "AcadLspAsDoc") 1)		;Loads acad.lsp into every drawing opened
					(setvar "AcadLspAsDoc" 1)
				)
				(if (/= (getvar "LispInit") 1)		;AutoLISP functions and variables are valid in the current drawing only
					(setvar "LispInit" 1)
				)
				(if (> (getvar "DBMOD") 0)			;Indicates the drawing modification status
					(command "_.QSave")
				)
				(setq	acadObject	(vlax-get-acad-object)
						acadDocs		(vla-get-Documents acadObject)
						acadTemp		(vla-add acadDocs MyDwt)
						Bubba		(vla-activate acadTemp)
				)
			)
			((and (= (getvar "SDI") 0) (= Action 0))	;Multi-document without File Save
				(if Bug
					(princ "\nUtils.Lsp-NewDwg - Multi-document without File Save \n")
				)
				(if (/= (getvar "AcadLspAsDoc") 1)
					(setvar "AcadLspAsDoc" 1)		;Loads acad.lsp into every drawing opened
				)
				(if (/= (getvar "LispInit") 1)   ; was 1 and 1
					(setvar "LispInit" 1)			;AutoLISP functions and variables are valid in the current drawing only
				)
				(setq	acadObject	(vlax-get-acad-object)
						acadDocs		(vla-get-Documents acadObject)
						acadTemp		(vla-add acadDocs MyDwt)
						Bubba		(vla-activate acadTemp)
				)
			)
			
			((and (= (getvar "SDI") 1) (= Action 1))	;Single-document with File Save
				(if Bug
					(princ "\nUtils.Lsp-NewDwg - Single-document with File Save \n")
				)
				(command "_.QSave")
				(command "_.New" MyDwt)
			)
			
			((and (= (getvar "SDI") 1) (= Action 0))	;Single-document without File Save
				(if Bug
					(princ (strcat "\nUtils.Lsp-NewDwg - Single-document without File Save "  MyDwt " \n"))
				)
				(if (/= (getvar "LispInit") 1)   ; was 1 and 1
					(setvar "LispInit" 1)			;AutoLISP functions and variables are valid in the current drawing only
				)

				(setq	FilWas	(getvar "FILEDIA"))
				(if (/= (getvar "FILEDIA") 0) (setvar "FILEDIA" 0))	;  Turns off File Dialog box need for New command
  				(if (> (getvar "DBMOD") 0)						;  Indicates the drawing modification status. 0~Initial value,  
					(progn
						(command "_.New" "Y" MyDwt)
					)
					(progn
						(command "_.New" MyDwt)	
					)
  				)
				(if (/= (getvar "FILEDIA") FilWas) (setvar "FILEDIA" FilWas))
			)
		)
	)
	;	Release and freeup memory for AutoCAD objects
	(if (and activeDoc (null (vlax-object-released-p acadDocs)))
		(vlax-release-object acadDocs)
	)
	(if (and acadObject (null (vlax-object-released-p acadObject)))
		(vlax-release-object acadObject)
	)
	(setq	acadObject 	nil
			acadDocs		nil
	)
	(gc)
	(if Bug
		(princ "\nUtils.Lsp NewDwg - Finished \n")
	)
	(princ)
)

(defun C:DeVolve ( /	BigLst ObjOrder Obj		;CL - Retrieves Info about Dwgs
					PosN StrOut TotCnt 
					LayN LayOrder BlkN BlkOrder )
	(if Bug (princ "\n{ C:DeVolve entered}\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			CmdWas	(getvar "CMDDIA")
			ColWas	(getvar "CECOLOR")
			EchWas	(getvar "CMDECHO")
			ExWas	(getvar "EXPERT")
			FilWas	(getvar "FILEDIA")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			TmdWas	(getvar "TILEMODE")
	)
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 23)
		)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 1)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 1)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 1)
			(setvar "OSMODE" 23)
		)
	)
	(command "_.UNDO" "_BE")
	(setq	BigLst	(DeVolve)
			TotCnt	0
			LayT		(tblnext "LAYER" T)
			LayL		(list (cdr (assoc 2 LayT)))
			LayW		0
	)
	(while (setq LayT (tblnext "LAYER"))
		(if LayT
			(setq	LayL	(cons (cdr (assoc 2 LayT)) LayL))
		)
	)
	(setq	LayM		(mapcar (quote strlen) LayL))
	(foreach	LayS 
			LayM
			(if (> LayS LayW)
				(setq	LayW		LayS)
			)
	)
	(setq	LayW		(1+ LayW))
	(if BigLst
		(progn
			(setq	ObjOrder	(acad_strlsort (nth 0 BigLst)))
			(princ	(strcat	"\n"
							(PadCharR "Object" LayW)
							(PadCharL "Qty" 6)
							(PadCharL "Lay" 6)
					)
			)
			(princ	(strcat	"\n"
							(PadCharR "============" LayW)
							(PadCharL "=====" 6)
							(PadCharL "=====" 6)
					)
			)
			(foreach	Obj
					ObjOrder
					(setq	PosN		(- (length (nth 0 BigLst)) (length (member Obj (nth 0 BigLst))))
							TotCnt	(+ TotCnt (cdr (nth PosN (nth 1 BigLst))))
							StrOut	(strcat	"\n"
											(PadCharR Obj LayW)
											(PadCharL (itoa (cdr (nth PosN (nth 1 BigLst)))) 6)
											(PadCharL (itoa (length (nth PosN (nth 2 BigLst)))) 6)
									)
							Bubba	(princ StrOut)
					)
			)
			(princ	(strcat	"\n"
							(PadCharR " " LayW)
							(PadCharL "-----" 6)
					)
			)
			(princ	(strcat	"\n"
							(PadCharR "Total Count" LayW)
							(PadCharL (itoa TotCnt) 8)
							"\n\nObject/Layer Details...\n"
					)
			)
			(foreach	Obj
					ObjOrder
					(setq	PosN		(- (length (nth 0 BigLst)) (length (member Obj (nth 0 BigLst))))
							LayOrder	(acad_strlsort (mapcar (quote car) (nth PosN (nth 2 BigLst))))
					)
					(princ (strcat "\nObject [" Obj "] Tot Qty:" (itoa (cdr (nth PosN (nth 1 BigLst)))) "\nLayers:"))
					(foreach	LayN
							LayOrder
							(setq	Bubba	(assoc LayN (nth PosN (nth 2 BigLst)))
									StrOut	(strcat	"\n  " (PadCharR (car Bubba) LayW) (itoa (cdr Bubba)))
									Bubba	(princ StrOut)
							)
					)
					(princ "\n")
			)
			(if (nth 3 BigLst)
				(progn
					(princ	(strcat	"\n"
									(PadCharR "Total Count" LayW)
									(PadCharL (itoa TotCnt) 8)
									"\n\nBlock/Count Details...\n"
							)
					)
					(setq	BlkOrder	(acad_strlsort (mapcar (quote car) (nth 3 BigLst))))
					(foreach	BlkN
							BlkOrder
							(princ (strcat "\n  Block " (PadCharR (strcat "[" BlkN "]") LayW) " Qty:" (itoa (cdr (assoc BlkN (nth 3 BigLst))))))
					)
					(princ "\n")
				)
				(princ "\n\nNo Block/Count Details...")
			)
		)
	)
	(command "_.UNDO" "_EN")
	(command "_.UNDO" "1")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CMDECHO" EchWas)
	(setvar "EXPERT" ExWas)
	(setvar "FILEDIA" FilWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "TILEMODE" TmdWas)
	(if Bug (princ "\n{ C:DeVolve exited}\n"))
	(princ)
)

(defun DeVolve ( /	ssAll CntR MaxRec Ent1		;Retrieves Info about Dwgs
				ObjDatOutLst CntDatOutLst 
				LayDatOutLst BlkDatOutLst
				ssBlk CntB MaxBec BPosN AttDatOutLst )
	(command "_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" "" "_.Zoom" "E" "_.Zoom" "0.8x")
	(setq	ssAll		(ssget "X" (list (cons 67 0)))
			CntR			0
	)
	(if ssAll
		(setq	MaxRec	(sslength ssAll)
				Bubba	(princ "\nCollecting Object Info...")
		)
	)
	(if ssAll
		(while (< CntR MaxRec)
			(setq	Ent1		(entget (ssname ssAll CntR) (list "*")))
			(if ObjDatOutLst
				(if (not (member (cdr (assoc 0 Ent1)) ObjDatOutLst))
					(setq	ObjDatOutLst	(cons (cdr (assoc 0 Ent1)) ObjDatOutLst)
							CntDatOutLst	(cons (cons (cdr (assoc 0 Ent1)) 1) CntDatOutLst)
							LayDatOutLst	(cons (list (cons (cdr (assoc 8 Ent1)) 1)) LayDatOutLst)
					)
					(progn
						(setq	PosN			(- (length ObjDatOutLst) (length (member (cdr (assoc 0 Ent1)) ObjDatOutLst)))
								ObjCnt		(1+ (cdr (nth PosN CntDatOutLst)))
								CntDatOutLst	(RepLst CntDatOutLst (cons (cdr (assoc 0 Ent1)) ObjCnt) PosN)
						)
						(if (not (assoc (cdr (assoc 8 Ent1)) (nth PosN LayDatOutLst)))
							(setq	LayDatOutLst	(RepLst LayDatOutLst (cons (cons (cdr (assoc 8 Ent1)) 1) (nth PosN LayDatOutLst)) PosN))
							(setq	NPosN		(- (length (nth PosN LayDatOutLst)) (length (member (assoc (cdr (assoc 8 Ent1)) (nth PosN LayDatOutLst)) (nth PosN LayDatOutLst))))
									PosLst		(RepLst (nth PosN LayDatOutLst) (cons (cdr (assoc 8 Ent1)) (1+ (cdr (assoc (cdr (assoc 8 Ent1)) (nth PosN LayDatOutLst))))) NPosN)
									LayDatOutLst	(RepLst LayDatOutLst PosLst PosN)
							)
						)
					)
				)
				(setq	ObjDatOutLst	(list (cdr (assoc 0 Ent1)))
						CntDatOutLst	(list (cons (cdr (assoc 0 Ent1)) 1))
						LayDatOutLst	(list (list (cons (cdr (assoc 8 Ent1)) 1)))
				)
			)
			(if (not Bug)
				(Twaddle CntR MaxRec)
				(princ (strcat "\n[Bug] Working Object Record:{" (itoa CntR) "}"))
			)
			(setq	CntR	(1+ CntR))
		)
	)
	(if ssAll
		(setq	ssAll	nil
				Bubba	(gc)
				Bubba	(if (not Bug)
							(Twaddle -1 MaxRec)
							(princ (strcat "\n[Bug] Working Objects Complete"))
						)
		)
	)
	(if (member "INSERT" ObjDatOutLst)
		(progn
			(setq	ssBlk		(ssget "X" (list (cons 67 0) (cons 0 "INSERT")))
					CntB			0
			)
			(if ssBlk
				(setq	MaxBec	(sslength ssBlk)
						Bubba	(princ "\nCollecting Block Info...")
				)
			)
			(if ssBlk
				(while (< CntB MaxBec)
					(setq	Ent1		(entget (ssname ssBlk CntB) (list "*")))
					(if BlkDatOutLst
						(if (not (assoc (cdr (assoc 2 Ent1)) BlkDatOutLst))
							(setq	BlkDatOutLst	(cons (cons (cdr (assoc 2 Ent1)) 1) BlkDatOutLst)
									AttDatOutLst	(cons (AttLst Ent1) AttDatOutLst)
							)
							(setq	BPosN		(- (length BlkDatOutLst) (length (member (assoc (cdr (assoc 2 Ent1)) BlkDatOutLst) BlkDatOutLst)))
									BlkDatOutLst	(RepLst BlkDatOutLst (cons (cdr (assoc 2 Ent1)) (1+ (cdr (assoc (cdr (assoc 2 Ent1)) BlkDatOutLst)))) BPosN)
							)
						)
						(setq	BlkDatOutLst	(list (cons (cdr (assoc 2 Ent1)) 1))
								AttDatOutLst	(list (AttLst Ent1))
						)
					)
					(if (not Bug)
						(Twaddle CntB MaxBec)
						(princ (strcat "\n[Bug] Working Block Record:{" (itoa CntB) "}"))
					)
					(setq	CntB	(1+ CntB))
				)
			)
			(if ssBlk
				(setq	ssBlk	nil
						Bubba	(gc)
						Bubba	(if (not Bug)
									(Twaddle -1 MaxBec)
									(princ (strcat "\n[Bug] Working Blocks Complete"))
								)
				)
			)
		)
	)
	(princ "\n")
	(list ObjDatOutLst CntDatOutLst LayDatOutLst BlkDatOutLst AttDatOutLst)
)

(defun AttLst ( Ent1 /	BlkDat Ent2 )
	(setq	BlkDat	(list (cdr (assoc 2 Ent1)))
			Ent2		Ent1
	)
	(if (assoc 66 Ent1)
		(if (> (cdr (assoc 66 Ent1)) 0)
			(while (= (cdr (assoc 0 (setq ent2 (entget (entnext (cdr (assoc -1 ent2))) (list "*"))))) "ATTRIB")
				(if (= (cdr (assoc 0 Ent2)) "ATTRIB")
					(setq	BlkDat	(cons (cdr (assoc 2 Ent2)) BlkDat))
				)
			)
		)
	)
	(if (> (length BlkDat) 1)
		(setq	BlkDat	(reverse BlkDat))
	)
	BlkDat
)

(defun DevAtom ( /	AllDa DaLen DaLst			;Devolves the Atoms-Family to variable types and quantities
				TpLst KyLst DaLek )
	(setq	AllDa	(atoms-family 0)
			DaLek	0
			DaLen	(length AllDa)
			DaLst	(list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
			TpLst	(list 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
			KyLst	(list	"ENAME"		;0
							"EXRXSUBR"	;1
							"FILE"		;2
							"INT"		;3
							"LIST"		;4
							"PAGETB"		;5
							"PICKSET"		;6
							"REAL"		;7
							"SAFEARRAY"	;8
							"STR"		;9
							"SUBR"		;10
							"SYM"		;11
							"VARIANT"		;12
							"USUBR"		;13
							"VLA-object"	;14
							"Unknown"		;15
					)
			SmLst	(list	(list nil)
							(list nil)
							(list nil)
							(list nil)
							(list nil)
							(list nil)
							(list nil)
							(list nil)
							(list nil)
							(list nil)
							(list nil)
							(list nil)
							(list nil)
							(list nil)
							(list nil)
							(list nil)
					)
	)
	(while (< DaLek DaLen)
		(if (< DaLek DaLen)
			(cond
				((= (type (eval (nth DaLek AllDa))) (quote ENAME))
					(setq	PlHld	0)
					(if (= (nth PlHld TpLst) 0)
						(setq	TpLst	(RepLst TpLst 1 PlHld))
					)
					(setq	DaLst	(RepLst DaLst (1+ (nth PlHld DaLst)) PlHld))
					(setq	SmLst	(RepLst SmLst (if (> (length (nth PlHld SmLst)) 1) (cons (nth DaLek AllDa) (nth PlHld SmLst)) (if (null (car (nth PlHld SmLst))) (list (nth DaLek AllDa)) (cons (nth DaLek AllDa) (nth PlHld SmLst)))) PlHld))
				)

				((= (type (eval (nth DaLek AllDa))) (quote EXRXSUBR))
					(setq	PlHld	1)
					(if (= (nth PlHld TpLst) 0)
						(setq	TpLst	(RepLst TpLst 1 PlHld))
					)
					(setq	DaLst	(RepLst DaLst (1+ (nth PlHld DaLst)) PlHld))
					(setq	SmLst	(RepLst SmLst (if (> (length (nth PlHld SmLst)) 1) (cons (nth DaLek AllDa) (nth PlHld SmLst)) (if (null (car (nth PlHld SmLst))) (list (nth DaLek AllDa)) (cons (nth DaLek AllDa) (nth PlHld SmLst)))) PlHld))
				)

				((= (type (eval (nth DaLek AllDa))) (quote FILE))
					(setq	PlHld	2)
					(if (= (nth PlHld TpLst) 0)
						(setq	TpLst	(RepLst TpLst 1 PlHld))
					)
					(setq	DaLst	(RepLst DaLst (1+ (nth PlHld DaLst)) PlHld))
					(setq	SmLst	(RepLst SmLst (if (> (length (nth PlHld SmLst)) 1) (cons (nth DaLek AllDa) (nth PlHld SmLst)) (if (null (car (nth PlHld SmLst))) (list (nth DaLek AllDa)) (cons (nth DaLek AllDa) (nth PlHld SmLst)))) PlHld))
				)

				((= (type (eval (nth DaLek AllDa))) (quote INT))
					(setq	PlHld	3)
					(if (= (nth PlHld TpLst) 0)
						(setq	TpLst	(RepLst TpLst 1 PlHld))
					)
					(setq	DaLst	(RepLst DaLst (1+ (nth PlHld DaLst)) PlHld))
					(setq	SmLst	(RepLst SmLst (if (> (length (nth PlHld SmLst)) 1) (cons (nth DaLek AllDa) (nth PlHld SmLst)) (if (null (car (nth PlHld SmLst))) (list (nth DaLek AllDa)) (cons (nth DaLek AllDa) (nth PlHld SmLst)))) PlHld))
				)

				((= (type (eval (nth DaLek AllDa))) (quote LIST))
					(setq	PlHld	4)
					(if (= (nth PlHld TpLst) 0)
						(setq	TpLst	(RepLst TpLst 1 PlHld))
					)
					(setq	DaLst	(RepLst DaLst (1+ (nth PlHld DaLst)) PlHld))
					(setq	SmLst	(RepLst SmLst (if (> (length (nth PlHld SmLst)) 1) (cons (nth DaLek AllDa) (nth PlHld SmLst)) (if (null (car (nth PlHld SmLst))) (list (nth DaLek AllDa)) (cons (nth DaLek AllDa) (nth PlHld SmLst)))) PlHld))
				)

				((= (type (eval (nth DaLek AllDa))) (quote PAGETB))
					(setq	PlHld	5)
					(if (= (nth PlHld TpLst) 0)
						(setq	TpLst	(RepLst TpLst 1 PlHld))
					)
					(setq	DaLst	(RepLst DaLst (1+ (nth PlHld DaLst)) PlHld))
					(setq	SmLst	(RepLst SmLst (if (> (length (nth PlHld SmLst)) 1) (cons (nth DaLek AllDa) (nth PlHld SmLst)) (if (null (car (nth PlHld SmLst))) (list (nth DaLek AllDa)) (cons (nth DaLek AllDa) (nth PlHld SmLst)))) PlHld))
				)

				((= (type (eval (nth DaLek AllDa))) (quote PICKSET))
					(setq	PlHld	6)
					(if (= (nth PlHld TpLst) 0)
						(setq	TpLst	(RepLst TpLst 1 PlHld))
					)
					(setq	DaLst	(RepLst DaLst (1+ (nth PlHld DaLst)) PlHld))
					(setq	SmLst	(RepLst SmLst (if (> (length (nth PlHld SmLst)) 1) (cons (nth DaLek AllDa) (nth PlHld SmLst)) (if (null (car (nth PlHld SmLst))) (list (nth DaLek AllDa)) (cons (nth DaLek AllDa) (nth PlHld SmLst)))) PlHld))
				)

				((= (type (eval (nth DaLek AllDa))) (quote REAL))
					(setq	PlHld	7)
					(if (= (nth PlHld TpLst) 0)
						(setq	TpLst	(RepLst TpLst 1 PlHld))
					)
					(setq	DaLst	(RepLst DaLst (1+ (nth PlHld DaLst)) PlHld))
					(setq	SmLst	(RepLst SmLst (if (> (length (nth PlHld SmLst)) 1) (cons (nth DaLek AllDa) (nth PlHld SmLst)) (if (null (car (nth PlHld SmLst))) (list (nth DaLek AllDa)) (cons (nth DaLek AllDa) (nth PlHld SmLst)))) PlHld))
				)

				((= (type (eval (nth DaLek AllDa))) (quote SAFEARRAY))
					(setq	PlHld	8)
					(if (= (nth PlHld TpLst) 0)
						(setq	TpLst	(RepLst TpLst 1 PlHld))
					)
					(setq	DaLst	(RepLst DaLst (1+ (nth PlHld DaLst)) PlHld))
					(setq	SmLst	(RepLst SmLst (if (> (length (nth PlHld SmLst)) 1) (cons (nth DaLek AllDa) (nth PlHld SmLst)) (if (null (car (nth PlHld SmLst))) (list (nth DaLek AllDa)) (cons (nth DaLek AllDa) (nth PlHld SmLst)))) PlHld))
				)

				((= (type (eval (nth DaLek AllDa))) (quote STR))
					(setq	PlHld	9)
					(if (= (nth PlHld TpLst) 0)
						(setq	TpLst	(RepLst TpLst 1 PlHld))
					)
					(setq	DaLst	(RepLst DaLst (1+ (nth PlHld DaLst)) PlHld))
					(setq	SmLst	(RepLst SmLst (if (> (length (nth PlHld SmLst)) 1) (cons (nth DaLek AllDa) (nth PlHld SmLst)) (if (null (car (nth PlHld SmLst))) (list (nth DaLek AllDa)) (cons (nth DaLek AllDa) (nth PlHld SmLst)))) PlHld))
				)

				((= (type (eval (nth DaLek AllDa))) (quote SUBR))
					(setq	PlHld	10)
					(if (= (nth PlHld TpLst) 0)
						(setq	TpLst	(RepLst TpLst 1 PlHld))
					)
					(setq	DaLst	(RepLst DaLst (1+ (nth PlHld DaLst)) PlHld))
					(setq	SmLst	(RepLst SmLst (if (> (length (nth PlHld SmLst)) 1) (cons (nth DaLek AllDa) (nth PlHld SmLst)) (if (null (car (nth PlHld SmLst))) (list (nth DaLek AllDa)) (cons (nth DaLek AllDa) (nth PlHld SmLst)))) PlHld))
				)

				((= (type (eval (nth DaLek AllDa))) (quote SYM))
					(setq	PlHld	11)
					(if (= (nth PlHld TpLst) 0)
						(setq	TpLst	(RepLst TpLst 1 PlHld))
					)
					(setq	DaLst	(RepLst DaLst (1+ (nth PlHld DaLst)) PlHld))
					(setq	SmLst	(RepLst SmLst (if (> (length (nth PlHld SmLst)) 1) (cons (nth DaLek AllDa) (nth PlHld SmLst)) (if (null (car (nth PlHld SmLst))) (list (nth DaLek AllDa)) (cons (nth DaLek AllDa) (nth PlHld SmLst)))) PlHld))
				)

				((= (type (eval (nth DaLek AllDa))) (quote VARIANT))
					(setq	PlHld	12)
					(if (= (nth PlHld TpLst) 0)
						(setq	TpLst	(RepLst TpLst 1 PlHld))
					)
					(setq	DaLst	(RepLst DaLst (1+ (nth PlHld DaLst)) PlHld))
					(setq	SmLst	(RepLst SmLst (if (> (length (nth PlHld SmLst)) 1) (cons (nth DaLek AllDa) (nth PlHld SmLst)) (if (null (car (nth PlHld SmLst))) (list (nth DaLek AllDa)) (cons (nth DaLek AllDa) (nth PlHld SmLst)))) PlHld))
				)

				((= (type (eval (nth DaLek AllDa))) (quote USUBR))
					(setq	PlHld	13)
					(if (= (nth PlHld TpLst) 0)
						(setq	TpLst	(RepLst TpLst 1 PlHld))
					)
					(setq	DaLst	(RepLst DaLst (1+ (nth PlHld DaLst)) PlHld))
					(setq	SmLst	(RepLst SmLst (if (> (length (nth PlHld SmLst)) 1) (cons (nth DaLek AllDa) (nth PlHld SmLst)) (if (null (car (nth PlHld SmLst))) (list (nth DaLek AllDa)) (cons (nth DaLek AllDa) (nth PlHld SmLst)))) PlHld))
				)

				((= (type (eval (nth DaLek AllDa))) (quote VLA-object))
					(setq	PlHld	14)
					(if (= (nth PlHld TpLst) 0)
						(setq	TpLst	(RepLst TpLst 1 PlHld))
					)
					(setq	DaLst	(RepLst DaLst (1+ (nth PlHld DaLst)) PlHld))
					(setq	SmLst	(RepLst SmLst (if (> (length (nth PlHld SmLst)) 1) (cons (nth DaLek AllDa) (nth PlHld SmLst)) (if (null (car (nth PlHld SmLst))) (list (nth DaLek AllDa)) (cons (nth DaLek AllDa) (nth PlHld SmLst)))) PlHld))
				)

				(T
					(setq	PlHld	15)
					(if (= (nth PlHld TpLst) 0)
						(setq	TpLst	(RepLst TpLst 1 PlHld))
					)
					(setq	DaLst	(RepLst DaLst (1+ (nth PlHld DaLst)) PlHld))
					(setq	SmLst	(RepLst SmLst (if (> (length (nth PlHld SmLst)) 1) (cons (nth DaLek AllDa) (nth PlHld SmLst)) (if (null (car (nth PlHld SmLst))) (list (nth DaLek AllDa)) (cons (nth DaLek AllDa) (nth PlHld SmLst)))) PlHld))
				)
			)
		)
		(setq	DaLek	(1+ Dalek))
	)
	(princ "\nDevAtom found...\nAtom Type       Count\n*********       *****")
	(setq	DaLek	0)
	(while (< DaLek (length TpLst))
		(if (< DaLek (length TpLst))
			(if (> (nth DaLek TpLst) 0)
				(princ	(strcat	"\n"
								(PadCharR (nth DaLek KyLst) 15)
								(PadCharL (itoa (nth DaLek DaLst)) 6)
						)
				)
			)
		)
		(setq	DaLek	(1+ Dalek))
	)
	(princ)
)

(defun AppndCadetDat ( /	Fnam LogDat FWrt )		; Appends Cadet info to the end of Div_Map.INI if needed
	(setq	Fnam	(Find_INI))
	(if (null (setq LogDat (dos_getini "Cadet" "Person" Fnam)))
		(progn
			(princ "\nCadet Header [Bad]...")
			(setq	FWrt		(open Fnam "a")
					Bubba	(write-line "" FWrt)
					Bubba	(write-line "[CADET]" FWrt)
					Bubba	(write-line "UserName=Grumpy" FWrt)
					Bubba	(write-line "HD=C:\\Cadet\\" FWrt)
					Bubba	(write-line "Person=C:\\DIV_MAP\\" FWrt)
					Bubba	(write-line "Lisp=C:\\Div_Map\\Cadet\\LISP\\" FWrt)
					Bubba	(write-line "LUT=C:\\Div_Map\\LookUpTable\\" FWrt)
					Bubba	(write-line "Menu=C:\\Div_Map\\Cadet\\MENU\\" FWrt)
					Bubba	(write-line "Sym=C:\\Div_Map\\Cadet\\Sym\\" FWrt)
					Bubba	(write-line "DLG=C:\\Div_Map\\Quad\\" FWrt)
					Bubba	(write-line "UserP=C:\\Div_Map\\Adds\\User\\" FWrt)
					Bubba	(write-line "DwtNam=C:\\Div_Map\\LookUpTable\\Template\\Cadet_T.dwt" FWrt)
					Bubba	(write-line "Dwg=S:\\WorkGroups\\APC Birmingham Division\\Division Mapping\\Cadet\\Dwg\\" FWrt)
					Bubba	(write-line "Plot=S:\\WorkGroups\\APC Birmingham Division\\Division Mapping\\Cadet\\Plot\\" FWrt)
					Bubba	(write-line "BH.Division=*S:\\WorkGroups\\APC Birmingham Division\\Division Mapping\\Cadet\\" FWrt)
					Bubba	(write-line "E_.Division=S:\\WorkGroups\\APC Eastern Division\\Division Mapping\\Cadet\\" FWrt)
					Bubba	(write-line "M_.Division=S:\\WorkGroups\\APC Mobile Division\\Division Mapping\\Cadet\\" FWrt)
					Bubba	(write-line "S_.Division=S:\\WorkGroups\\APC Southern Division\\Division Mapping\\Cadet\\" FWrt)
					Bubba	(write-line "SE.Division=S:\\WorkGroups\\APC SouthEast Division\\Division Mapping\\Cadet\\" FWrt)
					Bubba	(write-line "W_.Division=S:\\WorkGroups\\APC Western Division\\Division Mapping\\Cadet\\" FWrt)
					Bubba	(write-line "Old=H:\\" FWrt)
					Bubba	(write-line "Net=H:\\" FWrt)
					Bubba	(write-line "SndPick01Test=1" FWrt)
					Bubba	(write-line "SndPick01Val=31" FWrt)
					Bubba	(write-line "SndPick02Test=1" FWrt)
					Bubba	(write-line "SndPick02Val=36" FWrt)
					Bubba	(write-line "" FWrt)
					Bubba	(close FWrt)
			)
			(if (null (setq LogDat (dos_getini "Cadet" "Person" Fnam)))
				(princ "\nCadet Header [Still Bad]")
				(princ "\nCadet Header [Fixed]")
			)
		)
		(princ "\nCadet Header [OK]")
	)
	(princ)
)

(defun AppndAddsDat ( /	Fnam LogDat FWrt )		; Appends Cadet info to the end of Div_Map.INI if needed
	(setq	Fnam	(Find_INI))
	(if (null (setq LogDat (dos_getini "Adds" "Person" Fnam)))
		(progn
			(princ "\nAdds Header [Bad]...")
			(setq	FWrt		(open Fnam "a")
					Bubba	(write-line "" FWrt)
					Bubba	(write-line "[ADDS]" FWrt)
					Bubba	(write-line "TMult=100" FWrt)
					Bubba	(write-line "SMult=100" FWrt)
					Bubba	(write-line "Server=dembau1" FWrt)
					Bubba	(write-line "UserName=Grumpy" FWrt)
					Bubba	(write-line "Person=C:\\DIV_MAP\\" FWrt)
					Bubba	(write-line "HD=C:\\Adds\\Plot\\" FWrt)
					Bubba	(write-line "Person=C:\\DIV_MAP\\" FWrt)
					Bubba	(write-line "DwtNam=C:\\Div_Map\\LookUpTable\\Template\\Adds_T.dwt" FWrt)
					Bubba	(write-line "Dwg=S:\\WorkGroups\\APC Birmingham Division\\Division Mapping\\Adds\\Dwg\\" FWrt)
					Bubba	(write-line "Dwf=S:\\WorkGroups\\APC Birmingham Division\\Division Mapping\\Adds\\Dwf\\" FWrt)
					Bubba	(write-line "Plot=S:\\WorkGroups\\APC Birmingham Division\\Division Mapping\\Adds\\Plot\\" FWrt)
					Bubba	(write-line "UserP=C:\\Div_Map\\Adds\\User\\" FWrt)
					Bubba	(write-line "Lisp=C:\\Div_Map\\Adds\\LISP\\" FWrt)
					Bubba	(write-line "LUT=C:\\Div_Map\\LookUpTable\\" FWrt)
					Bubba	(write-line "Menu=C:\\Div_Map\\Adds\\MENU\\" FWrt)
					Bubba	(write-line "Sym=C:\\Div_Map\\Adds\\Sym\\" FWrt)
					Bubba	(write-line "DLG=C:\\Div_Map\\Quad\\" FWrt)
					Bubba	(write-line "Support=S:\\WorkGroups\\APC Birmingham Division\\Division Mapping\\Adds\\Support\\" FWrt)
					Bubba	(write-line "BH.Division=*S:\\WorkGroups\\APC Birmingham Division\\Division Mapping\\Adds\\Panel\\" FWrt)
					Bubba	(write-line "E_.Division=S:\\WorkGroups\\APC Eastern Division\\Division Mapping\\Adds\\Panel\\" FWrt)
					Bubba	(write-line "M_.Division=S:\\WorkGroups\\APC Mobile Division\\Division Mapping\\Adds\\Panel\\" FWrt)
					Bubba	(write-line "S_.Division=S:\\WorkGroups\\APC Southern Division\\Division Mapping\\Adds\\Panel\\" FWrt)
					Bubba	(write-line "SE.Division=S:\\WorkGroups\\APC SouthEast Division\\Division Mapping\\Adds\\Panel\\" FWrt)
					Bubba	(write-line "W_.Division=S:\\WorkGroups\\APC Western Division\\Division Mapping\\Adds\\Panel\\" FWrt)
					Bubba	(write-line "SndPick01Test=1" FWrt)
					Bubba	(write-line "SndPick01Val=36" FWrt)
					Bubba	(write-line "SndPick02Test=1" FWrt)
					Bubba	(write-line "SndPick02Val=34" FWrt)
					Bubba	(write-line "" FWrt)
					Bubba	(close FWrt)
			)
			(if (null (setq LogDat (dos_getini "Adds" "Person" Fnam)))
				(princ "\nAdds Header [Still Bad]")
				(princ "\nAdds Header [Fixed]")
			)
		)
		(princ "\nAdds Header [OK]")
	)
	(princ)
)

(defun AppndAddsPlotDat ( /	Fnam LogDat FWrt )		; Appends AddsPlot info to the end of Div_Map.INI if needed
	(setq	Fnam	(Find_INI))
	(if (null (setq LogDat (dos_getini "AddsPlot" "Person" Fnam)))
		(progn
			(princ "\nAddsPlot Header [Bad]...")
			(setq	FWrt		(open Fnam "a")
					Bubba	(write-line "" FWrt)
					Bubba	(write-line "[ADDSPLOT]" FWrt)
					Bubba	(write-line "TMult=100" FWrt)
					Bubba	(write-line "SMult=100" FWrt)
					Bubba	(write-line "Server=dembau1" FWrt)
					Bubba	(write-line "UserName=Grumpy" FWrt)
					Bubba	(write-line "Person=C:\\DIV_MAP\\" FWrt)
					Bubba	(write-line "HD=C:\\Adds\\Plot\\" FWrt)
					Bubba	(write-line "Person=C:\\DIV_MAP\\" FWrt)
					Bubba	(write-line "DwtNam=C:\\Div_Map\\LookUpTable\\Template\\AddsPlot_T.dwt" FWrt)
					Bubba	(write-line "Dwg=S:\\WorkGroups\\APC Birmingham Division\\Division Mapping\\Adds\\Dwg\\" FWrt)
					Bubba	(write-line "Dwf=S:\\WorkGroups\\APC Birmingham Division\\Division Mapping\\Adds\\Dwf\\" FWrt)
					Bubba	(write-line "Plot=S:\\WorkGroups\\APC Birmingham Division\\Division Mapping\\Adds\\Plot\\" FWrt)
					Bubba	(write-line "UserP=C:\\Div_Map\\Adds\\User\\" FWrt)
					Bubba	(write-line "Lisp=C:\\Div_Map\\Addsplot\\LISP\\" FWrt)
					Bubba	(write-line "LUT=C:\\Div_Map\\LookUpTable\\" FWrt)
					Bubba	(write-line "Menu=C:\\Div_Map\\Addsplot\\MENU\\" FWrt)
					Bubba	(write-line "Sym=C:\\Div_Map\\Adds\\Sym\\" FWrt)
					Bubba	(write-line "DLG=C:\\Div_Map\\Quad\\" FWrt)
					Bubba	(write-line "BH.Division=*S:\\WorkGroups\\APC Birmingham Division\\Division Mapping\\Adds\\Panel\\" FWrt)
					Bubba	(write-line "S_.Division=S:\\WorkGroups\\APC Southern Division\\Division Mapping\\Adds\\Panel\\" FWrt)
					Bubba	(write-line "W_.Division=S:\\WorkGroups\\APC Western Division\\Division Mapping\\Adds\\Panel\\" FWrt)
					Bubba	(write-line "E_.Division=S:\\WorkGroups\\APC Eastern Division\\Division Mapping\\Adds\\Panel\\" FWrt)
					Bubba	(write-line "M_.Division=S:\\WorkGroups\\APC Mobile Division\\Division Mapping\\Adds\\Panel\\" FWrt)
					Bubba	(write-line "SE.Division=S:\\WorkGroups\\APC SouthEast Division\\Division Mapping\\Adds\\Panel\\" FWrt)
					Bubba	(write-line "SndPick01Test=1" FWrt)
					Bubba	(write-line "SndPick01Val=-1" FWrt)
					Bubba	(write-line "SndPick02Test=1" FWrt)
					Bubba	(write-line "SndPick02Val=36" FWrt)
					Bubba	(write-line "" FWrt)
					Bubba	(close FWrt)
			)
			(if (null (setq LogDat (dos_getini "AddsPlot" "Person" Fnam)))
				(princ "\nAddsPlot Header [Still Bad]")
				(princ "\nAddsPlot Header [Fixed]")
			)
		)
		(princ "\nAddsPlot Header [OK]")
	)
	(princ)
)

(defun AppndLognDat ( /	Fnam LogDat FWrt )		; Appends Login.INI info to the end of Div_Map.INI if needed
	(setq	Fnam	(Find_INI))
	(if (null (setq LogDat (dos_getini "LOGIN" "DBDefault" Fnam)))
		(progn
			(princ "Login Header [Bad]...")
			(setq	FWrt		(open Fnam "a")
					Bubba	(write-line "" FWrt)
					Bubba	(write-line "[LOGIN]" FWrt)
					Bubba	(if DevMark
								(progn
									(write-line "DBDefault=DemBau1 User/DemBau1" FWrt)
									(write-line "DBName=DemBap1 Prod1/DemBap1" FWrt)
									(write-line "DBName=DemBap2 Prod2/DemBap2" FWrt)
								)
								(if (assoc (strcase (getvar "LOGINNAME")) Lst_Vld_MPG)
									(progn
										(write-line "DBDefault=DemBap1 Prod1/DemBap1" FWrt)
										(write-line "DBName=DemBap2 Prod2/DemBap2" FWrt)
										(write-line "DBName=DemBau1 User/DemBau1" FWrt)
									)
									(progn
										(write-line "DBDefault=DemBap2 Prod2/DemBap2" FWrt)
										(write-line "DBName=DemBap1 Prod1/DemBap1" FWrt)
										(write-line "DBName=DemBau1 User/DemBau1" FWrt)
									)
								)
							)
					Bubba	(write-line "DBName=DemBad1 Dev1/DemBad1" FWrt)
					Bubba	(write-line "DBName=DemBad2 Dev2/DemBad2" FWrt)
					Bubba	(write-line "DBName=TemBap1 Prod1/TemBap1" FWrt)
					Bubba	(write-line "DBName=TemBap2 Prod2/TemBap2" FWrt)
					Bubba	(write-line "DBName=TemBau1 User/TemBau1" FWrt)
					Bubba	(write-line "DBName=TemBad1 Dev1/TemBad1" FWrt)
					Bubba	(write-line "DBName=TemBad2 Dev2/TemBad2" FWrt)
					Bubba	(write-line "" FWrt)
					Bubba	(write-line "; Allow user to use Network password to log in and automatically change Oracle password to match" FWrt)
					Bubba	(write-line ";LoginLogic=Old" FWrt)
					Bubba	(write-line "; Force user to login using Oracle password." FWrt)
					Bubba	(write-line "LoginLogic=New" FWrt)
					Bubba	(close FWrt)
			)
			(if (null (setq LogDat (dos_getini "LOGIN" "DBDefault" Fnam)))
				(princ "Login Header [Still Bad]")
				(princ "Login Header [Fixed]")
			)
		)
		(princ "Login Header [OK]")
	)
	(princ)
)

(defun C:Ht ( /	newht )
	(setq	CmdEchoOld (getvar "CmdEcho"))
	(if (/= "CmdEchoOld" 1)
		(setvar "CmdEcho" 1)
	)
	(setq newht (getstring "Enter new height :"))
	(while newht
		(command "attedit" "" "" "" "" pause "" "h" newht "p" pause "")
	)
	(if (/= CmdEchoOld 1)
		(setvar "CmdEcho" CmdEchoOld)
	)
	(princ)
)

(defun C:DwgCleanUp ( / )
	
	;	Get the save window from user and create need variables
	(setq 	ptLL 	(getpoint "Select lower left corner of save area")
		 	ptUR		(getcorner ptLL "Select upper right corner of save area")
			pt1		ptLL
			pt2		(list(car ptUR) (cadr ptLL))
			pt3		ptUR
			pt4 		(list(car ptLL) (cadr ptUR))
			ptList	(list pt1 pt2 pt3 pt4)
	)
	
	;	Delete all drawing objects out side of the save window
	(setq 	ssAll 	(ssget "X")
			ssSave	(ssget "_CP" ptList)
	)
	(command "_.ERASE" ssAll "R" ssSave "")
	(command "REGENALL")
	
	(C:ChgTxtStyles)
	(vla-purgeall (vla-get-activeDocument (vlax-get-acad-object)))  ;; [TODO] if Adds comment out or add logic not to purge
	
	;	Check remaining blocks to see if any attributes are outside of the box and move them to LL corner
	(setq 	ssBlocks	(ssget "X" '((0 . "INSERT")(66 . 1))))
	(setq index 0
		 index2 0
	)
	(repeat (sslength ssBlocks)
		(setq	entName (ssName ssBlocks index)			;Get the entity name of the block
				entList (entget entName)					;Get the DXF group codes
				blkType (cdr(assoc 0 entlist))			;Save the type of entity
		)
		(if (= blkType "INSERT")							;- If the entity type is an Insert entity
			(progn 
				(if (= (cdr(assoc 66 entList)) 1)			;Check to see if Attributes exists
					(progn
						(setq	entAtt (entnext entName)	;Get the next sub-entity
								entAttList (entget entAtt)
						)
						(while (/= (cdr(assoc 0 entAttList)) "SEQEND")
							(if (or 	(< (nth 1	(assoc 10 entAttList)) (nth 0 ptLL))
									(< (nth 2 (assoc 10 entAttList)) (nth 1 ptLL))
									(> (nth 1 (assoc 10 entAttList)) (nth 0 ptUR))
									(> (nth 2 (assoc 10 entAttList)) (nth 1 ptUR))
								)
								(progn 
									(setq ptBase	(cdr (assoc 10 entList))
										 ptMove   (list (+ (car ptll) index2)(cadr ptll) 0.0)
									)
									(princ "\n") (prin1 ptMove)
									(moveAtt entAtt ptMove)
;									(command "_.line" ptLL ptBase "")
									(setq index2 (+ index2 1))
								)
							)
							(setq	entAtt 	(entnext entAtt)	;Get the next sub-entity
									entAttList(entget entAtt)
							)
						)
					)
				)
			)
		)
		(setq ptBase nil)
		(setq index (+ 1 index))
	)
	(vla-purgeall (vla-get-activeDocument (vlax-get-acad-object)))
)

(defun moveAtt (EName ptTo / )
	(setq 	entList	(entget EName))
	(setq 	deltaX 	(- (car ptTo)(nth 1 (assoc 10 entlist)))
	 		deltaY 	(- (nth 1 ptTo)(nth 2 (assoc 10 entlist)))
	)
	(setq	entList	(subst	(cons 10	ptTo)(assoc 10 entList) entList))
	
	(if (or (> (cdr (assoc 72 entList)) 0)(> (cdr (assoc 74 entList)) 0))
		(progn
			(setq	entList	(subst	(cons 11 
				(list 
					(+ (nth 1 (assoc 11 entList)) deltaX)
					(+ (nth 2 (assoc 11 entList)) deltaY) 
					0.0
				))
				(assoc 11 entList)
				entList)
			)
		)
		(progn
			(setq entList	(subst	(cons 72	0)(assoc 72 entList) entList)
				 entList	(subst	(cons 74	0)(assoc 74 entList) entList)
			)
		)
	)
;	(setq	entList	(subst	(cons 72	0)(assoc 72 entList) entList))
;	(setq	entList	(subst	(cons 74	0)(assoc 74 entList) entList))
	(entmod 	entList)
	(entupd EName)
	(command "REGENALL")
)

(defun C:LogFileCleanup (/)
	(LogFileCleanup)
)

(defun LogFileCleanup (/ logFiles logFiles2 baseDate file)
	(if Bug (princ "\nUtils.Lsp!C:LogFileCleanup - Start \n"))
	
	(if (null AppLst)
		(setq	ValProf "")
		(setq	ValProf	(nth 0 AppLst))
	)
	;	Check to make sure Adds Series application
	(if (or	(= (strcase ValProf) (strcase "AddsPlot"))	(= (strcase ValProf) (strcase "AddsPlot_T")) (= (strcase ValProf) (strcase "AddsPlot19"))
			(= (strcase ValProf) (strcase "Adds")) 		(= (strcase ValProf) (strcase "Adds_T"))
			(= (strcase ValProf) (strcase "Cadet")) 	(= (strcase ValProf) (strcase "Cadet_T"))
		)
		(progn 
			;	Get log files from log & temp subdirectories and todays date
			(setq 	logFiles  (dos_Filedate (strcat (getvar "LogFilePath") "*.log"))
					logFiles2 (dos_Filedate (strcat (getenv "TempDirectory") "Drawing*.log"))
					baseDate	(getvar "CDate")
			)
			;	Delete log files older than 7 days from log subdirectory.
			(foreach file logFiles
				(if (< (cdr file) (- baseDate 6.0))
					(vl-file-delete (strcat (getvar "LogFilePath") (car file)))
				)
			)
			;	Delete log files older than 1 days from users temp subdirectory for cleanup prior to 
			;	changes to log file handling code.  Can only check for AddsPlot log files.
			(foreach file logFiles2
				(if (< (cdr file) (- baseDate 1.0))
					(vl-file-delete (strcat (getenv "TempDirectory") (car file)))
				)
			)
		)
		(Alert "You cannot run LogFileCleanup if you are not in an Adds Series application.")
	)
	(if Bug (princ "\nUtils.Lsp!C:LogFileCleanup - Done \n"))
	(princ)
)
(defun C:InATS ( /	AttWas					;Inserts an ATS block
					BlpWas CmdWas ColWas EchWas ExWas FilWas LayWas LtWas OsWas TmdWas )
	(if Bug (princ "\n{ C:InSOP entered}\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			CmdWas	(getvar "CMDDIA")
			ColWas	(getvar "CECOLOR")
			EchWas	(getvar "CMDECHO")
			ExWas	(getvar "EXPERT")
			FilWas	(getvar "FILEDIA")
			LayWas	(getvar "CLAYER")
			LtWas	(getvar "CELTYPE")
			OsWas	(getvar "OSMODE")
			TmdWas	(getvar "TILEMODE")
	)
	
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 1)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "EXPERT" 5)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 3)
		)
	)
	(command "_.UNDO" "_BE")
	(setq	Pnt01	(getpoint "\nSelect point for ATS block: "))
	(if Pnt01
		(if (> (car Pnt01) 300000.0)
			(command "_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" "" "_.Insert" (strcat _Path-Sym "084.dwg") Pnt01 (* 0.25 sf) "" "0")
			(command "_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" "" "_.Insert" (strcat _Path-Sym "084.dwg") Pnt01 (* 0.50 sf) "" "0")
		)
	)
	
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CMDECHO" EchWas)
	(setvar "EXPERT" ExWas)
	(setvar "FILEDIA" FilWas)
	(setvar "CLAYER" LayWas)
	(setvar "CELTYPE" LtWas)
	(setvar "OSMODE" OsWas)
	(setvar "TILEMODE" TmdWas)
	(if Bug (princ "\n{ C:InATS exited}\n"))
	(princ)
)

(setq	LodVer	"3.0.2")
