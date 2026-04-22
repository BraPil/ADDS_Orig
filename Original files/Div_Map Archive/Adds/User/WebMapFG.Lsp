(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " WebMapFG Loading."))
	(princ "\nAddsPlot WebMapFG Loading.")
)

(defun WebMapFG ( / )
	(if (= Div "M_")
		(if Desc_1
			(progn
				(load (strcat _PATH-USER "SymColor"))
				(setq	Desc_1	nil)
			)
		)
	)
	(load (strcat _path-user "View4SwL"))
	(load (strcat _path-user "View4Cap"))
	(load (strcat _path-user "AddURL"))
	(load (strcat _path-user "Fdr_Grey"))
	(load (strcat _path-user "NoFills"))
	;(load (strcat _path-user "Custom50"))
	(princ)
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(WebMapFG)
	(setq	LodVer	"1.50")
)
(setq	LodVer	"1.50")