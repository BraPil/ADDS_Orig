(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " DwfPub03 Loading."))
	(princ "\nAddsPlot DwfPub03 Loading.")
)

(defun DwfPub03 ( / ViewD MinX MaxX MinY MaxY Fuzz ACTLst cmD ssBrk Elast adeSS ssGood ssMost ssDelete ssGon status )
	(if Bug (princ "\n{ DwfPub03 Entered"))
	(if (null flagNotForWeb)
		(setq _Path-Dwf (DecodeTargetPathDwf Det1))
	)
	(if ViewPorter
		(setq	ViewD	(ViewPorter))
		(progn
			(load "S:\\Workgroups\\APC Power Delivery\\Division Mapping\\Common\\Acad.lsp")
			(load "S:\\Workgroups\\APC Power Delivery\\Division Mapping\\Common\\Utils.lsp")
			(if ViewPorter
				(setq	ViewD	(ViewPorter))
			)
		)
	)
	(if _Path-DWF
		(progn
			(command "_.Undo" "C" "ALL" "_.Undo" "BE")
			(if (/= 0 (getvar "tilemode"))
				(command "_.tilemode" 0)
			)
			(if (= 1 (getvar "cvport"))
				(command "_.MSpace")
			)
			(command "_.Layer" "T" "*" "ON" "*" "U" "*" "S" "0" "" "_.Zoom" "0.8x")
			(setq	MinX		(car (nth 8 ViewD))
					MaxX		(car (nth 9 ViewD))
					MinY		(cadr (nth 8 ViewD))
					MaxY		(cadr (nth 9 ViewD))
					Fuzz		(if UsrBuf (if (>= UsrBuf 0.01) UsrBuf 10.0) 10.0)
					ACTLst	nil
					cmD		(getvar "CMDDIA")
					ssBrk	(ssget "C" (list (- MinX Fuzz) (- MinY Fuzz)) (list (+ MaxX Fuzz) (+ MaxY Fuzz)))
			)
			(setvar "CMDDIA" 0)
			
			; Depending on the DA plot name other panels are added to the model space beside the one there
			; due to the plot definition.
			(cond
				((= PldName "DABH43")
					(setq	ACTLst	(list	"4983740"
											"4983744"
											"5043708"
											"5043712"
											"5103708"
											"5103712"
											"5343724"
											"5343728"
											"5343732"
											"5343736"
											"5343740"
											"5343744"
											"5343748"
									)
					)
				)
				((= PldName "DABH44")
					(setq	ACTLst	(list	"5043700"
											"5043704"
											"5043708"
											"5283700"
											"5283704"
											"5283708"
											"5283712"
									)
					)
				)
				((= PldName "DABH45")
					(setq	ACTLst	(list	"5223712"
											"5223716"
											"5223720"
											"5223724"
											"5283708"
											"5283712"
											"5343708"
											"5343712"
											"5343736"
											"5403708"
											"5403712"
											"5403736"
											"5403740"
											"5403740"
											"5463712"
											"5463736"
											"5463740"
											"5523736"
											"5523740"
											"5583720"
											"5583724"
											"5583728"
											"5583732"
											"5583736"
									)
					)
				)
				((= PldName "DABH46")
					(setq	ACTLst	(list	"5283700"
											"5283704"
											"5343700"
											"5343704"
											"5343708"
											"5403700"
											"5403704"
											"5403708"
											"5403712"
											"5463708"
											"5463712"
											"5463716"
											"5283696"
											"5283692"
											"5343696"
											"5343692"
									)
					)
				)
				((= PldName "DABH47")
					(setq	Bubba	(princ "\nDABH47 is actually Metro13!\n"))
				)
				((= PldName "DABH48")
					(setq	ACTLst	(list	"5103688"
											"5103692"
											"5103696"
											"5163688"
											"5223704"
											"5223708"
											"5283700"
											"5283704"
											"5283708"
											"5283712"
									)
					)
				)
				((= PldName "DABH49")
					(setq	ACTLst	(list	"5163696"
											"5223696"
											"5463668"
											"5463672"
											"5463676"
											"5463680"
											"5463684"
											"5463688"
											"5463692"
											"5523676"
											"5523680"
									)
					)
				)
				((= PldName "DABH50")
					(setq	ACTLst	(list	"4983648"
											"4983652"
											"5043648"
											"5043652"
											"5103652"
											"5103672"
											"5163644"
											"5163648"
											"5163652"
											"5163672"
											"5163676"
											"5223648"
											"5223652"
											"5223672"
											"5223676"
											"5283672"
											"5283676"
											"5343648"
											"5343652"
											"5343672"
											"5343676"
											"5403652"
											"5463660"
											"5463664"
											"5463668"
											"5463672"
									)
					)
				)
				((= PldName "DABH51")
					(setq	ACTLst	(list	"4923676"
											"4923680"
											"4983668"
											"4983672"
											"4983676"
											"4983680"
											"5043668"
											"5043672"
											"5103668"
											"5103672"
											"5163664"
											"5163668"
											"5163672"
											"5163696"
											"5163700"
											"5223696"
											"5223700"
											"5283684"
											"5283688"
											"5283692"
											"5283696"
											"5283700"
											"5343684"
											"5343688"
											"5343692"
											"5343696"
											"5343700"
									)
					)
				)
				((= PldName "DABH52")
					(setq	ACTLst	(list	"4623696"
											"4623700"
											"4683692"
											"4683696"
											"4683700"
											"4683704"
											"4743692"
											"4743696"
											"4743700"
											"4743704"
											"4743708"
											"4923720"
											"4983664"
											"4983668"
											"4983672"
											"4983720"
											"4983724"
											"5043664"
											"5043668"
											"5043672"
											"5043720"
											"5043724"
											"5103708"
											"5103712"
											"5163708"
											"5163712"
									)
					)
				)
				((OR(= PldName "DAE_75")(= PldName "DAE_76")(= PldName "DAE_77")(= PldName "DAE_78"))
					(load (strcat _path-user "Fdr_Only"))
				)
				((= PldName "DAW_40")
					(setq	Bubba	(princ "\n DAW_40 is actually Central Western!\n"))
				)
				((= PldName "DAW_41")
					(setq	Bubba	(princ "\n DAW_41 is actually North Western!\n"))
				)
				((= PldName "DAW_42")
					(setq	Bubba	(princ "\n DAW_42 is actually South Western!\n"))
					(setq	ACTLst	(list	"3723640"
											"3723644"
											"3723648"
											"3723652"
											"3723656"
											"3723660"
											"3723664"
											"3723668"
											"3723672"
											"3723676"
											"3783640"
											"3783644"
											"3783648"
											"3783652"
											"3783656"
											"3783660"
											"3783664"
											"3783668"
											"3783672"
											"3783676"
											"3783680"
											"3783684"
											"3783688"
											"3783692"
											"3783696"
											"3783700"
											"3783704"
											"3783708"
											"3783712"
											"3783716"
											"3783720"
											"3843640"
											"3843644"
											"3843648"
											"3843652"
											"3843656"
											"3843660"
											"3843664"
											"3843668"
											"3843672"
											"3843676"
											"3843680"
											"3843684"
											"3843688"
											"3843692"
											"3843696"
											"3843700"
											"3843704"
											"3843708"
											"3843712"
											"3843716"
											"3843720"
											"3903644"
											"3903648"
											"3903652"
											"3903656"
											"3903660"
											"3903664"
											"3903668"
											"3903672"
											"3903676"
											"3903680"
											"3903684"
											"3903688"
											"3903692"
											"3903696"
											"3903700"
											"3903704"
											"3903708"
											"3903712"
											"3903716"
											"3903720"
											"3963652"
											"3963656"
											"3963660"
											"3963664"
											"3963668"
											"3963672"
											"3963676"
											"3963680"
											"3963684"
											"3963688"
											"3963692"
											"3963696"
											"3963700"
											"3963704"
											"3963708"
											"3963712"
											"3963716"
											"3963720"
											"4023640"
											"4023644"
											"4023648"
											"4023652"
											"4023656"
											"4023660"
											"4023664"
											"4023668"
											"4023672"
											"4023676"
											"4023680"
											"4023684"
											"4023688"
											"4023692"
											"4023696"
											"4023700"
											"4023704"
											"4023708"
											"4023712"
											"4023716"
											"4023720"
											"4083640"
											"4083644"
											"4083672"
											"4083676"
											"4083680"
											"4083684"
											"4083688"
											"4083692"
											"4083696"
											"4083700"
											"4083704"
											"4083708"
											"4083712"
											"4083716"
											"4083720"
											"4143640"
											"4143648"
											"4143664"
											"4143668"
											"4143672"
											"4143676"
											"4143680"
											"4143684"
											"4143688"
											"4143692"
											"4143696"
											"4143700"
											"4143704"
											"4143708"
											"4143712"
											"4143716"
											"4143720"
											"4143724"
											"4143728"
											"4203680"
											"4203684"
											"4203688"
											"4203692"
											"4203696"
											"4203700"
											"4203704"
											"4203708"
											"4263640"
											"4263684"
											"4263688"
											"4263692"
											"4263696"
											"4563572"
											"4563576"
											"4563580"
											"4563584"
											"4563588"
											"4623584"
											"4623588"
									)
					)
				)
				((= PldName "DAW_43")
					(setq	ACTLst	(list	"4503656"
											"4503660"
											"4503664"
											"4563652"
											"4563656"
											"4563660"
											"4563664"
											"4743680"
											"4803680"
											"4803684"
											"4863680"
											"4983668"
											"4983672"
											"4983676"
											"4983632"
											"4983636"
											"4983640"
											"4983644"
											"4983648"
											"4983652"
											"4983656"
											"5043632"
											"5043636"
											"5043640"
											"5043644"
											"5043648"
											"5043652"
											"5103636"
											"5103640"
									)
					)
				)
				((= PldName "DAW_47")
					(setq	ACTLst	(list	"4323760"
											"4383736"
											"4383740"
											"4383744"
											"4383748"
											"4383752"
											"4383756"
											"4383760"
											"4443736"
											"4443740"
											"4443744"
											"4443748"
											"4443752"
											"4443756"
											"4443760"
											"4443764"
											"4503756"
											"4503760"
											"4503764"
											"4563712"
											"4563716"
											"4563756"
											"4563760"
											"4563764"
											"4563768"
											"4563772"
											"4623708"
											"4623712"
											"4623716"
											"4623756"
											"4623760"
											"4623764"
											"4623768"
											"4683708"
											"4683712"
											"4683716"
											"4683756"
											"4683760"
											"4743708"
											"4743712"
											"4743716"
											"4743756"
											"4743760"
											"4743764"
											"4803708"
											"4803712"
											"4803716"
											"4803756"
											"4803760"
											"4863716"
											"4863756"
											"4803760"
											"4863756"
											"4863760"
											"4923716"
											"4983724"
											"4983728"
											"4983732"
											"4983736"
											"4983740"
											"4983744"
											"5043728"
											"5043732"
											"5043736"
											"5043740"
									)
					)
				)
				((= PldName "DAW_50")
					(setq	ACTLst	(list	"4203672"
											"4203676"
											"4203680"
											"4203684"
											"4203688"
											"4203700"
											"4203704"
											"4203708"
											"4323712"
											"4263672"
											"4323672"
										;	"4383672"
											"4383712"
										;	"4443672"
											"4443712"
;											"4503672"
											"4503712"
											"4503716"
											"4623708"
											"4623704"
											"4623700"
											"4623696"
									)
					)
				)
				((= PldName "DAW_51")
				;	(setq	Bubba	(princ "\n DAW_42 is actually South Western!\n"))
					(setq	ACTLst	(list	"4263636"
											"4263640"
											"4323644"
											"4323640"
											"4323636"
											"4383644"
											"4383640"
											"4383636"
											"4443644"
											"4443640"
											"4443636"
											"4503644"
											"4503640"
											"4563688"
											"4563684"
											"4563680"
											"4563676"
											"4563672"
											"4623696"
											"4623692"
											"4623688"
											"4623684"
											"4623680"
											"4623676"
											"4623672"
											"4683792"
											"4683688"
											"4683684"
											"4683680"
											"4683676"
											"4683672"
											"4743688"
											"4743684"
											"4743680"
											"4743676"
											"4743672"
											"4743668"
											"4743664"
											"4803688"
											"4803684"
										)
					)
				)
				(T
					(command	"_.PLINE"
							(list (- MinX Fuzz) (- MinY Fuzz))
							"W"
							"0.0"
							"0.0"
							(list (+ MaxX Fuzz) (- MinY Fuzz))
							(list (+ MaxX Fuzz) (+ MaxY Fuzz))
							(list (- MinX Fuzz) (+ MaxY Fuzz))
							"C"
					)
					(setq	Elast	(entlast))
					(setq 	adeSS (Map_DwgBreakObj ssBrk Elast 0 1))
					(command "_.ERASE" Elast "")
					(setq	ssBrk	nil
							Fuzz		(/ Fuzz 2.0)
							ssGood	(ssget "C" (list (- MinX Fuzz) (- MinY Fuzz)) (list (+ MaxX Fuzz) (+ MaxY Fuzz)))
							ssMost	(ssget "X")
					)
					(if (and ssMost ssGood)
						(command "_.Erase" ssMost "R" ssGood "")
					)
				)
			)
			(setvar "CMDDIA" cmD)
		)
	)
	(if ACTlst
		(progn
			(foreach pan ACTlst
				(if (findfile (strcat _PATH-PANEL pan ".DWG"))
					(command "_.INSERT" (strcat "*" _PATH-PANEL pan ".DWG") "0,0" "" "")
					(if (findfile (strcat _ALT_PATH-PANEL pan ".DWG"))
							(command "_.INSERT" (strcat "*" _ALT_PATH-PANEL pan ".DWG") "0,0" "" "")
					)
				)
			)
			(command)
			(command "_.Zoom" "E" "_.Zoom" "0.95x")
			(if kv_StrLst
				(progn
			    		(setq	ssDelete(ssget "X" (list (cons -4 "<AND")
														(cons -4 "<NOT") 
															(cons 2 "A122") 	; Stepdown Transformer
														(cons -4 "NOT>") 
														(cons 8 kv_StrLst) 
												(cons -4 "AND>"))))
					(command)
					(command "_.Erase" ssDelete "")
				)
			)
		)
	)

	(princ "\nRunning Fdr_Grey")
	(load (strcat _path-user "Fdr_Grey"))
	(if (= PlotType "DWF")
		(progn
			(princ "\nRunning View4SwL")
			(load (strcat _path-user "View4SwL"))
			(princ "\nRunning View4Cap")				
			(load (strcat _path-user "View4Cap"))
			(princ "\nRunning AddURL")
			(load (strcat _path-user "AddURL"))
		)
	)
	
	
	(princ "\nRunning NoFills")
	(load (strcat _path-user "NoFills"))
	(if kv_StrLst
		(if (/= Div "W_")
			(if (/= Vlt "AL")
				(progn
					(if (not (wcmatch kv_StrLst "*-SC-*"))
						(setq	kv_StrLst	(strcat kv_StrLst ",*-SC-*,????CP*"))
					)
  					(setq	ssGon	(ssget "X" (list (cons -4 "<AND")
														(cons -4 "<NOT") 
															(cons 2 "A122") 	; Stepdown Transformer
														(cons -4 "NOT>") 
														(cons 8 kv_StrLst) 
												(cons -4 "AND>")))
					)
					(if ssGon
						(progn
							(command)
							(command "_.Erase" ssGon "")
						)
					)
				)
			)
			(if (/= Vlt "AL")
				(progn
					(if (not (wcmatch kv_StrLst "*-SC-*"))
						(setq	kv_StrLst	(strcat kv_StrLst ",*-SC-*"))
					)
					(setq	ssGon	(ssget "X" (list (cons -4 "<AND")
														(cons -4 "<NOT") 
															(cons 2 "A122") 	; Stepdown Transformer
														(cons -4 "NOT>") 
														(cons 8 kv_StrLst) 
												(cons -4 "AND>")))
					)
					(if ssGon
						(command "_.Erase" ssGon "")
					)
				)
			)
		)
		(if (/= Div "W_")
			(progn
				(setq	ssGon	(ssget "X" (list (cons 8 "????CP*,----SC----"))))
				(if ssGon
					(command "_.Erase" ssGon "")
				)
			)
			(progn
				(setq	ssGon	(ssget "X" (list (cons 8 "----SC----"))))
				(if ssGon
					(command "_.Erase" ssGon "")
				)
			)
		)
	)
	;	Cleanup
	(if ssBrk		(setq ssBrk	nil))
	(if ssGood	(setq ssGood	nil))
	(if ssMost	(setq ssMost	nil))
	(if ssDelete	(setq ssDelete	nil))
	(if ssGon		(setq ssGon	nil))
	(if adeSS
		(setq status (ade_ssfree adeSS))
	)
	(gc)
	
	(if Bug (princ "\n DwfPub03 Exited}\n"))
	(princ)
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(DwfPub03)
	(setq	LodVer	"3.0.1")
)
