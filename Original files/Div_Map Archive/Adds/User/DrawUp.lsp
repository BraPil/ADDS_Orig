(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " DrawUp Loading."))
	(princ "\nAddsPlot DrawUp Loading.")
)

(defun DrawUp ( /	ViewD cmD InSS )			; Resets the Model Space window range and DrawOrders blocks to front
	(if ViewPorter
		(setq	ViewD	(ViewPorter))
		(progn
			(load "S:\\Workgroups\\APC Power Delivery\\Division Mapping\\Common\\Acad.lsp")
			(load "S:\\Workgroups\\APC Power Delivery\\Division Mapping\\Common\\Utils.lsp")
			(setq	ViewD	(ViewPorter))
		)
	)
	(command "_.Undo" "C" "ALL" "_.Undo" "BE")
	(setq	WlX		(car (nth 8 ViewD))
			WuX		(car (nth 9 ViewD))
			WlY		(cadr (nth 8 ViewD))
			WuY		(cadr (nth 9 ViewD))
			cmD		(getvar "CMDDIA")
	)
	(setvar "CMDDIA" 0)
	(if (/= 0 (getvar "tilemode"))
		(command "_.tilemode" 0)
	)
	(if (= 1 (getvar "cvport"))
		(command "_.MSpace")
	)
	(setq	InSS		(ssget "w" (list WlX WlY) (list WuX WuY) (list (cons 0 "Insert"))))
	(if InSS
		(princ "\nAttempting to DrawOrder the Masked blocks...")
	)
	(if InSS
		(command "_DrawOrder" InSS "" "F")
		(princ "\nNo InSS found!")
	)
	(command "_.Undo" "End")
	(setvar "CMDDIA" cmD)
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(DrawUp)
	(setq	LodVer	"2.0.0a")
)
