(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " Custom9 Loading."))
	(princ "\nAddsPlot Custom9 Loading.")
)

(defun Cus9 ( / )
	(load (strcat _Path-User "Custom9"))
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(Cus9)
	(setq	LodVer	"1.50")
)
