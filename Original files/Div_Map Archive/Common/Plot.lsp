(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " Plot Loading."))
	(princ "\nAddsPlot Plot Loading.")
)

(defun GetActiveDoc ( / )
	(vl-load-com)
	(vla-get-activedocument (vlax-get-acad-object))
)

(defun GetActiveLayout ( / )
	(vla-get-activelayout (GetActiveDoc))
)

;	Purpose - to create list of plotter paper sizes for the passed in plotter name.
;			will also set the current active layout to use passed in plotter name.
;	Parameters -	PlotDeviceName
;	Result 	 -	Global Variable CurPlotDevLst
(defun GetPlotDeviceInfo (PltDev / )
	(SetPlotDevice PltDev)
	(setq CurPlotDevLst (GetPlotterPaperSizes))
	(princ)
)

(defun GetPlotDevices (/ hide lst)	;;; For obtaining a list of available printers/plotter
								;;; CET Test function for AutoCAD 2007
	(vl-load-com)
	(if (setq hide (= "1" (getenv "HideSystemPrinters")))
		(setenv "HideSystemPrinters" "0")
	)
	
	(setq layout (GetActiveLayout))
 	(if hide 
		(setenv "HideSystemPrinters" "1")
	)
	
	(vla-refreshplotdeviceinfo layout)
	
	(setq lst (vlax-invoke layout 'getplotdevicenames))
)

(defun GetPlotterPaperSizes ( / )
	(vl-load-com)
	(setq actlay (GetActiveLayout)
		 mediaNames (reverse(vlax-safearray->list (vlax-variant-value (vla-GetCanonicalMediaNames actlay))))
		 Index 0
		 SizesList (list)
	)
	(repeat (Length mediaNames)
		(setq mediaName (nth Index mediaNames)) 				;Get a canonical name by index
		(vla-put-CanonicalMediaName actlay mediaName)			;Set the canonical name as to determing paper size
		(setq localName (vla-GetLocaleMediaName actlay mediaName))
		(vla-GetPaperSize actlay (quote Width) (quote Height))		;Gets width and height in mm
		(setq	details	(list (+ Index 1) mediaName localName Width Height)) 
		(if SizesList
			(setq SizesList (append SizesList (list details)))
			(setq SizesList (append SizesList (list details)))
		)
		(setq Index (+ Index 1))
	)
	SizesList
)

(defun SetPlotDevice (Plotter / )
	(setq layout (GetActiveLayout))
	(vla-put-configname layout Plotter)
	(vla-refreshplotdeviceinfo layout)
)

(defun C:PlotPdf2Web ( / deltaX deltaY rotation result localDir localFileName loopCounter)
	(if Bug (princ "\n{C:PlotPdf2Web entered\n"))
	(princ "\n") (prin1 _Path-Dwf) (princ "\n")

	;	Update text styles to true type fonts
	(C:ChgTxtStyles)
	
	(vl-load-com)
	(setq acadObject (vlax-get-acad-object)
		 activeDoc  (vla-get-activedocument acadObject)
	)
	(vla-Regen activeDoc acAllViewports)
	
	;	Set plotter to Adobe Postscript driver and get ANSI E Canonical names for landscape and portart
	(GetPlotDeviceInfo "Adobe PDF.pc3")
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
	
	;	Check to see if in paper space if so switch to model space.
	(if (= (vla-get-ActiveSpace activeDoc) acPaperSpace)
		(progn
			(vla-put-Mspace activeDoc :vlax-true)
			(vla-put-ActiveSpace activeDoc acModelSpace)
			(setq activeDoc  (vla-get-activedocument acadObject))
		)
	)
	;	Check to see if the drawing needs to be rotated.
	(vla-zoomextents acadObject)
	(setq deltaX (- (car (getvar "EXTMAX")) (car (getvar "EXTMIN"))))
	(setq deltaY (- (cadr (getvar "EXTMAX")) (cadr (getvar "EXTMIN"))))
	(if (>= deltaX deltaY)
		(setq rotation nil)
		(setq rotation T)
	)
	(setq actLayout  (vla-get-activelayout activeDoc)
		 plotObject (vla-get-Plot activeDoc)
	)
	(setq desc "Adobe PDF.pc3")
	(if (/= (vla-get-ConfigName actLayout) "Adobe PDF.pc3")
		(vla-put-ConfigName actLayout "Adobe PDF.pc3")
	)
	
	;	Setup plotting settings
	(vla-put-CanonicalMediaName actLayout cNamePdfL)
	(vla-put-PlotRotation actLayout ac0degrees)
	
	(vla-put-PaperUnits actLayout acInches)
	(vla-put-PlotType actLayout acExtents)			; acExtents acDisplay
	(vla-put-StandardScale actLayout acScaleToFit)
	(vla-put-CenterPlot actLayout :vlax-true)
	(vla-put-PlotWithPlotStyles actLayout :vlax-true)	   ;true
	(vla-put-StyleSheet actLayout "Acad_2.ctb")
	(vla-put-PlotWithLineweights actLayout :vlax-false)

	;	Plot the objects in model space
	(if Bug (princ "\n{C:PlotPdf2Web about to plot}\n"))
	(setq result (vla-PlotToFile plotObject (strcat "C:\\Cadet\\in\\" pldname ".ps")desc))
	
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
	(if Bug (princ "\n{C:PlotPdf2Web done\n"))
	(princ)
)


(setq	LodVer	"3.0.0g")