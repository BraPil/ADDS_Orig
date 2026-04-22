(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " WebMapFO Loading."))
	(princ "\nAddsPlot WebMapFO Loading.")
)

(defun WebMapFO ( / )
	(if (= Div "M_")
		(if Desc_1
			(progn
				(load (strcat _PATH-USER "SymColor"))
				(setq	Desc_1	nil)
			)
		)
	)
	(load (strcat _path-user "CUSTOM50"))
	(load (strcat _path-user "NOLANDMARK"))
	(load (strcat _path-user "View4SwL"))
	(load (strcat _path-user "View4Cap"))
	(load (strcat _path-user "AddURL"))
	(load (strcat _path-user "Fdr_Only"))
	(load (strcat _path-user "NoFills"))
	(load (strcat _path-user "NoMasks"))

	(princ)
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(WebMapFO)
	(setq	LodVer	"1.50")
)
