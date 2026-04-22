(defun LCSp1 ( / )
	(if (= Div "M_")
		(progn
			(princ "\nRunning NoFills")
			(load (strcat _path-user "NoFills"))
			
			(princ "\nRunning SymColor")
			(load (strcat _path-user "SymColor"))
			
			(princ "\nRunning Quads")
			(load (strcat _path-user "Quads"))
		)
	)
	
	(command "_.LAYER" "T" "ViewPort" "S" "ViewPort" "P" "P" "" "")
	(command "_.Zoom" "E" "_.Zoom" "0.8x")
	(princ)
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(LCSp1)
	(setq	LodVer	"3.00a")
)