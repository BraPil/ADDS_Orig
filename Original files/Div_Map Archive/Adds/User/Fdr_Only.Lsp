(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " Fdr_Only Loading."))
	(princ "\nAddsPlot Fdr_Only Loading.")
)

(defun C:Fdr_Only ( / );	notkeylst notkeystr		; Freezes all layers but the chosen feeder
				    ;	laydef kvFROMlaydef keylen keyFROMlaydef )
	(if cordkey
		(progn
			(if (not lst_vt_s)
				(progn
					(if (not bld_t_vlt) (load "TABLES"))
						(bld_t_vlt)
					)
			)
			(setq	notkeylst		(list )
					notkeystr		""
					keylen		(strlen (nth 0 cordkey))
					laydef		(tblnext "LAYER" T)
			)
			(while laydef
				(if (member (setq kvFROMlaydef (substr (cdr (assoc 2 laydef)) 9 2)) lst_vt_s)
					(progn
						(setq keyFROMlaydef (substr (cdr (assoc 2 laydef)) 1 keylen))
						(if	(and	(not (member keyFROMlaydef cordkey))
								(not (member keyFROMlaydef notkeylst))
							)
							(setq	notkeylst		(cons keyFROMlaydef notkeylst)
									notkeystr		(strcat notkeystr keyFROMlaydef "*,")
							)
						)
					)
				)
				(setq	laydef	(tblnext "LAYER"))
			)
			(if (> (strlen notkeystr) 0)
				(progn
					(setq notkeystr (substr notkeystr 1 (1- (strlen notkeystr))))
					(command "_.LAYER" "F" notkeystr "")
				)
			)
		)
	)
	(princ)
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(C:Fdr_Only)
	(setq	LodVer	"1.50")
)
