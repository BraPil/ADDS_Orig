(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " CPs2Blu Loading."))
	(princ "\nAddsPlot CPs2Blu Loading.")
)

(defun CPs2Blu ( /	a NOcol CPcol )			; CUSTOMIZING ROUTINE FOR COMPUTER POINT MAPS
	(cond								; CHANGE POINT NUMBERS TO BLUE & NORMAL OPEN DOTS TO RED
		((= vlt " ")
			(setq	a	"*")  
		)
		((= vlt "")
			(setq	a	"*")  
		)
		((= vlt "AL")
			(setq	a	"*")
		)
     	(T
			(if vlt
				(setq	a	vlt)
				(setq	a	"*")
			)
		)
	)
	(cond
		((= Div "E_")
			(setq	NOcol	"3"
					CPcol	"5"
			)
			(command "_.LAYER" "C" CPcol "????CP*" "C" NOcol "????NO*" "T" (strcat "????CP??" a) "") ;  "F" "??????D*"
		)
		((= Div "M_")
			(if Desc_1
				(progn
					(load (strcat _PATH-USER "SymColor"))
					(setq	Desc_1	nil)
				)
			)
			(command "_.LAYER" "T" "????CP*" "C" "6" "????CP*,????CE*" "C" "7" "????CED*" "")
		)
		((= Div "W_")
			(setq	NOcol	"3"
					CPcol	"240"
			)
			(command "_.LAYER" "C" CPcol "????CP??*" "C" NOcol "????NO*" "T" (strcat "????CP??" a) "")
		)
		(T
			(setq	NOcol	"9"
					CPcol	"5"
			)
			(command "_.LAYER" "C" CPcol "????CP??*" "C" NOcol "????NO*" "T" (strcat "????CP??" a) "")
		)
	)
	(setq cpss (ssget "X" '((8 . "????CP*"))))
	(if cpss
		(progn
			(command "_.layer" "n" "C_points" "c" "240" "c_points" "")
			(command "_.change" cpss "" "p" "la" "C_points" "c" "bylayer" "" )
		)
	)
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(CPs2Blu)
	(setq	LodVer	"1.50")
)
