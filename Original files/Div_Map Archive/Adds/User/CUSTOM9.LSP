(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " Custom9 Loading."))
	(princ "\nAddsPlot Custom9 Loading.")
)

(defun Custom9 ( / )						; CUSTOMIZING ROUTINE FOR COMPUTER POINT MAPS FOR POSTING
	(if Bug (princ "\n{Custom9 entered\n"))
	(cond
		((= Div "E_")
			(setq	NOcol	"3"
					CPcol	"5"
			)
			(command "_.LAYER" "F" "????CE*" "C" CPcol "????CP*" "C" NOcol "????NO*" "T" (strcat "????CP??" a) "") ;  "F" "??????D*"
		)
		((= Div "M_")
			(command "_.LAYER" "F" "????CE*" "T" "????CP*" "C" "6" "????CP*,????CE*" "C" "7" "????CED*" "")
		)
		((= Div "W_")
			(setq	NOcol	"3"
					CPcol	"240"
			)
			(command "_.LAYER" "F" "????CE*" "C" CPcol "????CP??*" "C" NOcol "????NO*" "T" (strcat "????CP??" a) "")
		)
		(T
			(setq	NOcol	"9"
					CPcol	"5"
			)
			(command "_.LAYER" "F" "????CE*" "C" CPcol "????CP??*" "C" NOcol "????NO*" "T" (strcat "????CP??" a) "")
		)
	)
	(if Bug (princ "\nCustom9 exited}\n"))
	(princ)
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(Custom9)
	(setq	LodVer	"1.50")
)
