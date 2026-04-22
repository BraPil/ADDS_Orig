(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " WallMap Loading."))
	(princ "\nAddsPlot WallMap Loading.")
)

(defun WallMap ( / )
	(if (= Div "M_")
		(progn
			(princ "\nRunning Quads")
			(load (strcat _path-user "Quads"))
			
			(princ "\nRunning Xtitle")
			(load (strcat _path-user "Xtitle"))
			(command "_.PSpace")
		)
	)
	(command "_.LAYER" "T" "ViewPort" "S" "ViewPort" "P" "P" "" "")
	(command "_.Zoom" "E" "_.Zoom" "0.8x")
	(princ)
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(WallMap)
	(setq	LodVer	"3.00a")
)