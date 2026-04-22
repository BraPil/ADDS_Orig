(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " ZinSert Loading."))
	(princ "\nAddsPlot ZinSert Loading...")
)

(Defun ZinSert ( / DscLst )
	(setq	DscLst	(strcat "(" Desc_1 ")")
			DscLst	(read DscLst)
	)
	(if (= (type DscLst) (quote LIST))
		(if (and (= (type (car DscLst)) (quote INT)) (= (length DscLst) 4))
			(progn
				(Command	"_.Mspace")
				(Command	"_.Zoom"
						"W"
						(list (nth 0 DscLst) (nth 1 DscLst))
						(list (nth 2 DscLst) (nth 3 DscLst))
				)
				(if (= (strcase CordFile) "FEEDER")
					(load (strcat _Path-User "Fdr_Grey"))
				)
				(load (strcat _Path-User "Quads"))
			)
		)
	)
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(ZinSert)
	(setq	LodVer	"1.50")
)
(princ) 