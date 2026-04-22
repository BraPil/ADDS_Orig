(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " NoMasks Loading."))
	(princ "\nAddsPlot NoFills Loading.")
)

(defun NoFills ( / )
	(command "_.Mspace")
	(command "_.-layer" "F" "*mask*" "")
	(princ)
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(NoFills)
	(setq	LodVer	"1.50")
)
