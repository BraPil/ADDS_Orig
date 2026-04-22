(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " Custom67 Loading."))
	(princ "\nAddsPlot Custom67 Loading.")
)

(defun Custom67 ( / )
	(load (strcat _Path-User "Fdr_Grey"))
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(Custom67)
	(setq	LodVer	"1.50")
)
