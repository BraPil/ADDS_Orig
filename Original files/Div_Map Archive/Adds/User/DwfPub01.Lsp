(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " DwfPub01 Loading."))
	(princ "\nAddsPlot DwfPub01 Loading.")
)

;Purpose: 	To thaw, turn on, unlock all layers, set currrent layer to zero then zoom to 80%
;Parameters:  clayers is a pointer to the collection of layers in the active drawing.
(defun LayerTs0Z80 ( cLayers / index aLayer ) 
	(setq index 0)
   	(repeat (vla-get-count cLayers)
		(setq aLayer (vla-item cLayers index))
    	(if (= (vla-get-Freeze alayer):vlax-true)
			(vla-put-freeze aLayer :vlax-false)		; Thaws the item layer
		)
		(vla-put-LayerOn aLayer :vlax-true)			; Turn On the item layer
		(vla-put-Lock aLayer :vlax-false)				; Un-locks the item layer
		(setq index (1+ index))
   	)	;repeat

	(setq aLayer (vla-item layersCol "0"))				; Gets layer 0 pointer
	(vla-put-ActiveLayer actDoc alayer)				; Sets the current layer to 0
	(vla-zoomscaled (vlax-get-acad-object) 0.8 acZoomScaledRelative)
	(princ)
)

(defun DwfPub01 ( / basePath acadObj actDoc layersCol adeSS status )
	(if Bug (princ "\n{ DwfPub01 Entered"))
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
			(vl-load-com)
			;	Get exising active drawing selection set collection
			(setq acadObj 		(vlax-get-acad-object)
				 actDoc 		(vla-get-activedocument acadObj)
				 layersCol 	(vla-get-layers actDoc)			; Gets the layers collection
			)			
			
			(command "_.Undo" "C" "ALL" "_.Undo" "BE")
			(if (/= 0 (getvar "tilemode"))
				(command "_.tilemode" 0)
			)
			(if (= 1 (getvar "cvport"))
				(command "_.MSpace")
			)
			; Calls vla- user function to thaw, turn on, unlock all layers, set currrent layer to zero then zoom to 80%			
			(LayerTs0Z80 layersCol)			    			
			
			(setq	MinX		(car (nth 8 ViewD))
					MaxX		(car (nth 9 ViewD))
					MinY		(cadr (nth 8 ViewD))
					MaxY		(cadr (nth 9 ViewD))
					Fuzz		(if UsrBuf (if (>= UsrBuf 0.01) UsrBuf 10.0) 10.0)
					cmD		(getvar "CMDDIA")
					ssBrk	(ssget "C" (list (- MinX Fuzz) (- MinY Fuzz)) (list (+ MaxX Fuzz) (+ MaxY Fuzz)))
			)
			(setvar "CMDDIA" 0)
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
			(setq adeSS (Map_DwgBreakObj ssBrk Elast 0 1))
			(command "_.ERASE" Elast "")
			(setq	ssBrk	nil
					Fuzz		(/ Fuzz 2.0)
					ssGood	(ssget "C" (list (- MinX Fuzz) (- MinY Fuzz)) (list (+ MaxX Fuzz) (+ MaxY Fuzz)))
					ssMost	(ssget "X")
			)
			(if (and ssMost ssGood)
				(command "_.Erase" ssMost "R" ssGood "")
			)
			
			;	Cleanup
			(setq 	ssBrk	nil
					ssGood 	nil
					ssMost	nil
			)
			(setvar "CMDDIA" cmD)
			
			(if (and layersCol (null (vlax-object-released-p layersCol)))
				(vlax-release-object layersCol)
			)
			(if (and actDoc (null (vlax-object-released-p actDoc)))
				(vlax-release-object actDoc)
			)
			(if (and acadObj (null (vlax-object-released-p acadObj)))
				(vlax-release-object acadObj)
			)
			(if adeSS
				(setq status (ade_ssfree adeSS))
			)
			(gc)
		)
	)
	(princ "\nRunning Fdr_Grey")
	(load (strcat _path-user "Fdr_Grey"))
	(if (/= PlotType "PDF")
		(progn
			(princ "\nRunning View4SwL")
			(load (strcat _path-user "View4SwL"))
			(princ "\nRunning View4Cap")
			(load (strcat _path-user "View4Cap"))
			(princ "\nRunning AddURL")
			(load (strcat _path-user "AddURL"))
		)
	)
	
	(if (= Div "M_")
		(if Desc_1
			(progn
				(load (strcat _PATH-USER "SymColor"))
				(setq	Desc_1	nil)
			)
		)
	)
	
	(princ "\nRunning NoFills")
	(load (strcat _path-user "NoFills"))
	(if Bug (princ "\n DwfPub01 Exited}\n"))
	(command "_.Layer" "F" "????CP*" "")
	(princ)
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(DwfPub01)
	(setq	LodVer	"3.0.0e")
)

(setq	LodVer	"3.0.0e")
