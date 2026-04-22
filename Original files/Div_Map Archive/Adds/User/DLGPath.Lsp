(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " DLGPath Loading."))
	(princ "\nAddsPlot DLGPath Loading.")
)

(defun DLGPath ( / )
	(setq	_Path-DLG		"S:\\Workgroups\\APC Power Delivery\\Division Mapping Test\\QUAD\\")
	(princ "\nPath for DLG query set to Division Mapping Test.")
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(DLGPath)
	(setq	LodVer	"2.0.0")
)
