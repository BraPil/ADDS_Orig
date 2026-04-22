(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " Wall_NL Loading."))
	(princ "\nAddsPlot Wall_NL Loading.")
)

(defun Wall_NL ( / )
	(load (strcat _PATH-USER "4"))
	(princ "\nRWallMap")
	(load (strcat _path-user "WallMap"))
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(Wall_NL)
	(setq	LodVer	"1.50")
)
