(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " LayReCol Loading."))
	(princ "\nAddsPlot LayReCol Loading.")
)

(defun LayReCol (	/	LayItm CktWas CktWillBe )
	(setq	LayItm		(tblnext "LAYER" T)
			LayLst		(list "0")
			CktWas		2
			CktWillBe		30
	)
	(while (setq LayItm (tblnext "LAYER"))
		(if LayItm
			(if (and (= (cdr (assoc 62 LayItm)) CktWas) (wcmatch (cdr (assoc 2 LayItm)) "????CK-*"))
				(setq	LayLst	(cons	(cdr (assoc 2 LayItm))
										LayLst
								)
				)
			)
		)
	)
	(if (> (length LayLst) 1)
		(setq	LayLst	(cdr (reverse LayLst)))
		(setq	LayLst	nil)
	)
	(if LayLst
		(mapcar (quote (lambda (x) (command "_.Layer" "C" CktWillBe x ""))) LayLst)
	)
	(if LayLst
		(command "RegenAll")
	)
	(princ)
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(LayReCol)
	(setq	LodVer	"1.50")
)
