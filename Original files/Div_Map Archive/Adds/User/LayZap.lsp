(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " LayZap Loading."))
	(princ "\nAddsPlot LayZap Loading.")
)

(defun LayZap ( /	cmD TmpLay ViewD )			; Cuts out viewing area for and posts to Bems
										; ViewD BemsDir PutFile MinX MinY MaxX MaxY Fuzz cmD ssBrk ELast ssGood
	(if Bug (princ "\n{LayZap Entered"))
	(setq	cmD		(getvar "CMDDIA")
			LayLst	nil
	)
	(if (= (getvar "ACADVER") "15.0")
		(if (not (member (strcase "DosLib2k.arx" T) (arx)))
			(if (findfile "doslib2k.arx")
				(arxload "doslib2k")
				(princ "\n*Buttons Error*: DosLIB Arx file not found on this system!")
			)
		)
		(if (not (member (strcase "DosLib14.arx" T) (arx)))
			(if (findfile "doslib14.arx")
				(arxload "doslib14")
				(princ "\n*Buttons Error*: DosLIB Arx file not found on this system!")
			)
		)
	)
	(if ViewPorter
		(setq	ViewD	(ViewPorter))
		(progn
			(load "S:\\Workgroups\\APC Power Delivery\\Division Mapping\\Common\\Acad.lsp")
			(load "S:\\Workgroups\\APC Power Delivery\\Division Mapping\\Common\\Utils.lsp")
			(if ViewPorter
				(setq	ViewD	(ViewPorter))
			)
		)
	)
	(setq	TmpLay	(tblnext "LAYER" T))
	(while TmpLay
		(if	(or	(< (cdr (assoc 62 TmpLay)) 0)
				(>= (cdr (assoc 70 TmpLay)) 1)
			)
			(if LayLst
				(setq	LayLst	(cons (cdr (assoc 2 TmpLay)) LayLst))
				(setq	LayLst	(list (cdr (assoc 2 TmpLay))))
			)
		)
		(setq	TmpLay	(tblnext "LAYER"))
	)
	(setq	DoLay	(mapcar '(lambda (x) (cons 8 x)) LayLst)
			DoLay	(cons (cons -4 "OR>") DoLay)
			DoLay	(cons (cons -4 "<OR") (reverse DoLay))
	)
	(if (and ViewD TmpLay)
		(progn
			(command "_.Undo" "C" "ALL" "_.Undo" "BE")
			(command "_.MSpace" "_.Zoom" "0.8x" "_.-Layer" "T" "*" "ON" "*" "U" "*" "S" "0" "")
			(setq	MinX		(car (nth 8 ViewD))
					MaxX		(car (nth 9 ViewD))
					MinY		(cadr (nth 8 ViewD))
					MaxY		(cadr (nth 9 ViewD))
					Fuzz		10.0
					cmD		(getvar "CMDDIA")
					ssBrk	(ssget	"C"
									(list (- MinX Fuzz) (- MinY Fuzz))
									(list (+ MaxX Fuzz) (+ MaxY Fuzz))
									DoLay
							)
			)
			(if ssBrk
				(command "_.Erase" ssBrk "")
			)
			(setvar "CMDDIA" 0)
			(command "_.Undo" "End" "_.PSpace")
		)
	)
	(setvar "CMDDIA" cmD)
	(if Bug (princ "\nLayZap Exited}\n"))
)

;;;(if (= (substr (strcase AppNam) 1 5) "ADDSP")
;;;	(LayZap)
;;;	(setq	LodVer	"2.0.0a")
;;;)
