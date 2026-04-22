(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " SwMap Loading."))
	(princ "\nAddsPlot SwMap Loading.")
)

(defun SwMap ( /	CKcol )
	(princ "\nRunning SymColor")
	(if Desc_1
		(progn
			(load (strcat _PATH-USER "SymColor"))
			(setq	Desc_1	nil)
		)
	)
	(princ "\nRunning Fdr_Grey")
	(load (strcat _Path-User "Fdr_Grey"))
	(princ "\nRunning View4SwL")
	(load (strcat _Path-User "View4SwL"))
	(princ "\nDone Running SwMap!")
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(SwMap)
	(setq	LodVer	"1.50a")
)
