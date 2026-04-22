(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " No23kV Loading."))
	(princ "\nAddsPlot No23kV Loading.")
)

(defun No23kV ( / )
	(command "_.Mspace")
	(command "_.-layer" "F" "????????23*,mask" "")
	(princ)
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(No23kV)
	(setq	LodVer	"1.50")
)
