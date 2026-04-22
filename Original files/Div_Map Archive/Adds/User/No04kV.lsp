(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " No04kV Loading."))
	(princ "\nAddsPlot No04kV Loading.")
)

(defun No04kV ( / )
	(command "_.Mspace")
	(command "_.-layer" "F" "????????04*,mask" "")
	(princ)
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(No04kV)
	(setq	LodVer	"1.50")
)
