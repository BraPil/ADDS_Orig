(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " NoFills Loading."))
	(princ "\nAddsPlot NoFills Loading.")
)

(defun NoFills ( / )
	(command "_.Mspace")
	(command "_.-layer" "F" "????fl*,mask" "")
	(princ)
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(NoFills)
	(setq	LodVer	"1.50")
)
(setq	LodVer	"1.50")