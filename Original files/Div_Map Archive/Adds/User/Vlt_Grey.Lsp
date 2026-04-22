(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " Vlt_Grey Loading."))
	(princ "\nAddsPlot Vlt_Grey Loading.")
)										   saf

;	Purpose:  To gray out all circuits which do not match AddsPlot definition voltage setting.  
;			As to show complte feeder if there is a step-down transformer in the circuit or adjacent circuit at different voltage level.
;	Global Vars:	lst_Vt_S, Vlt
;	By:		CET		Date:	04/14/2009
(defun Vlt_Grey ( / notkeylst laydef kvFROMlaydef )
	(if (/= Vlt "AL")
		(progn
			(setq 	notkeylst		(list )
					laydef		(tblnext "LAYER" T)
			)
			;	Figures out which voltage layer name should be greyed out.
			(while laydef
				(if (> (strlen (cdr (assoc 2 laydef))) 9)							;Checks to see if layer name lenght is greater than 9 characters
					(if (member (substr (cdr (assoc 2 laydef)) 9 2) lst_vt_s)				;Checks to see if voltage part of layer name is in standard voltage list.
						(if (not (member (setq kvFROMlaydef (substr (cdr (assoc 2 laydef)) 9 2)) (list Vlt)))	;Checks to see if voltage part of layer name is equal to Plotdef voltage. If it is saves it.
							(progn
								(setq	keyFROMlaydef (cdr (assoc 2 laydef))
										notkeylst		(cons keyFROMlaydef notkeylst)
								)
							)
						)
					)
				)
				(setq laydef (tblnext "LAYER"))
			)
			
			(C:ThA)	;	Thaws all layers
			
			;	Changes layers to grey
			(foreach notLayer notkeylst
				(if (LayChk "????NO????")
					(command "_.LAYER" "C" "252" notLayer "C" "3" "????NO????" "")
					(command "_.LAYER" "C" "252" notLayer "")
				)
			)
			(if (LayChk "????AA????")
				(command "_.LAYER" "C" "252" "????AA????" "")
			)
			(if (LayChk "????AB????")
				(command "_.LAYER" "C" "252" "????AB????" "")
			)
			(if (LayChk "????RD????")
				(command "_.LAYER" "C" "252" "????RD????" "")
			)
			(if (LayChk "????ST????")
				(command "_.LAYER" "C" "252" "????ST????" "")
			)
			(if (LayChk "????LM????")
				(command "_.LAYER" "C" "252" "????LM????" "")
			)	
		)
	)
	;	If for the website change plot path to website
	(if (= PlotType "PDF")
		(setq _Path-Dwf (DecodeTargetPathDwf Det1))
	)
	(princ)
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(Vlt_Grey)
	(setq	LodVer	"3.00a")
)