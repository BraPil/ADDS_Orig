(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " 67 Loading."))
	(princ "\nAddsPlot 67 Loading.")
)

(defun Cus67 ( / )
	(load (strcat _Path-User "Fdr_Grey"))
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(Cus67)
	(setq	LodVer	"1.50")
)
