(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " Custom97 Loading."))
	(princ "\nAddsPlot Custom97 Loading.")
)

(defun Custom97 ( /	ssNodes )				; Customizing routine for tree maps, freezes point numbers
	(setq	ssNodes	(ssget "x" (list (cons 2 "NODE-SUB"))))
	(if ssNodes
		(command "_.LAYER" "F" "????CP*" "" "_.ERASE" ssNodes "")
		(command "_.LAYER" "F" "????CP*" "")
	)
	(princ)
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(Custom97)
	(setq	LodVer	"1.50")
)
