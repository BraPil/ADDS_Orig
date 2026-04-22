(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " SavDWFHiRes Loading."))
	(princ "\nAddsPlot SavDWFHiRes Loading.")
)

(defun SavDWFHiRes ( / )
	(if Bug (princ "\n{SavDWFHiRes entered\n"))
	(command "_.mspace")
	(command "_DWFOUTD" (strcat _path-DWF "HiRes\\" pldname) "B" "H" "Y" "Y")	; Was "B" "H" "Y" "Y") - changed to Medium Precision to save space.
	(command "_.pspace")
	(princ (strcat "\n \nThe Hi-Res file <" pldname ".DWF> has been created under " _PATH-DWF))
	(if Bug (princ "\nSavDWFHiRes exited}\n"))
	(princ)
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(SavDWFHiRes)
	(setq	LodVer	"1.50b")
)
