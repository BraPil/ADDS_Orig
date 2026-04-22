(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " kV_Color Loading."))
	(princ "\nAddsPlot kV_Color Loading.")
)

(defun kV_Color ( / )						;Colors circuit by voltage
	(if Bug (princ "\n{kV_Color entered\n"))
	(command	"_.-LAYER"
			"C" "10"	"??????-?04"			;04  kV
			"C" "1"	"??????-?1[23]"		;12  or 13 kV
			"C" "5"	"??????-?2[35]"		;23  or 25 kV
			"C" "5"	"??????-?35"			;35  kV
			"C" "1"	"??????-?44"			;44  kV
			"C" "2"	"??????-?15"			;115 kV
			"C" "30"	"??????-?61"			;161 kV
			"C" "5"	"??????-?30"			;230 kV
			"C" "3"	"??????-?00"			;500 kV
			"C" "2"	"????CP*"
			"C" "15"	"????CE*"
			"C" "7"	"????NO*"
			"C" "15"	"???ULO*"
			"C" "15"	"????PM*"
			""
	)
	(if Bug (princ "\nkV_Color exited}\n"))
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(kV_Color)
	(setq	LodVer	"1.50")
)
