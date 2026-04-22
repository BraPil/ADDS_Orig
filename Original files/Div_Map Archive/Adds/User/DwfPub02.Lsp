(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " DwfPub02 Loading."))
	(princ "\nAddsPlot DwfPub02 Loading.")
)

;Purpose: 	To thaw, turn on, unlock all layers, set currrent layer to zero
;Parameters:  clayers is a pointer to the collection of layers in the active drawing.
(defun LayerTs0 ( cLayers / index aLayer ) 
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
	(princ)
)
;Purpose:	To Zoom to extents
(defun ZoomExt ( acadObject / )
	(vla-zoomextents acadObject )
	(princ)
)
;Purpose:	To Zoom to a scale factor
(defun ZoomScale(acadObject scale / )
	(vla-zoomscaled acadObject scale acZoomScaledRelative)
	(princ)
)

(defun DwfPub02 ( / basePath 
				 acadObj actDoc layersCol)
	(if Bug (princ "\n{ DwfPub02 Entered"))
	(if (null flagNotForWeb)
		(setq _Path-Dwf (DecodeTargetPathDwf Det1))
	)
	(cond
		((= Div "BH")
			(cond
				((= Det1 "SUBSINGLE MAP")
					(setq	_Path-Dwg	"S:\\Workgroups\\APC Birmingham Division\\Division Mapping\\SUBTOOLS\\Dwg\\")
				)
			)
		)
		((= Div "E_")
			(cond
				((= Det1 "SUBSINGLE MAP")
					(setq	_Path-Dwg	"S:\\Workgroups\\APC Eastern Division\\Division Mapping\\SUBTOOLS\\Dwg\\")
				)
			)
		)
		((= Div "M_")
			(cond
				((= Det1 "SUBSINGLE MAP")
					(setq	_Path-Dwg	"S:\\Workgroups\\APC Mobile Division\\Division Mapping\\SUBTOOLS\\Dwg\\")
				)
			)
		)
		((= Div "S_")
			(cond
				((= Det1 "SUBSINGLE MAP")
					(setq	_Path-Dwg	"S:\\Workgroups\\APC Southern Division\\Division Mapping\\SUBTOOLS\\Dwg\\")
				)
			)
		)
		((= Div "SE")
			(cond
				((= Det1 "SUBSINGLE MAP")
					(setq	_Path-Dwg	"S:\\Workgroups\\APC SouthEast Division\\Division Mapping\\SUBTOOLS\\Dwg\\")
				)
			)
		)
		((= Div "W_")
			(cond
				((= Det1 "SUBSINGLE MAP")
					(setq	_Path-Dwg	"S:\\Workgroups\\APC Western Division\\Division Mapping\\SUBTOOLS\\Dwg\\")
				)
			)
		)
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
			(LayerTs0 layersCol)
			(ZoomScale acadObj 0.8)
			
			(setq	MinX		(car (nth 8 ViewD))
					MaxX		(car (nth 9 ViewD))
					MinY		(cadr (nth 8 ViewD))
					MaxY		(cadr (nth 9 ViewD))
					Fuzz		(if UsrBuf (if (>= UsrBuf 0.01) UsrBuf 10.0) 10.0)
					cmD		(getvar "CMDDIA")
					ssMost	(ssget "X" (list (cons 67 0)))
			)
			(setvar "CMDDIA" 0)
			(if ssMost
				(command "_.Erase" ssMost "")
			)
			(if Dwg_Num
				(if (findfile (strcat _Path-Dwg Dwg_Num ".Dwg"))
					(command "_.Insert" (strcat "*" _Path-Dwg Dwg_Num ".Dwg") "0,0" "1" "0")
				)
			)
			(LayerTs0 layersCol)
			(ZoomExt acadObj)
			(ZoomScale acadObj 0.8)
			
			;	Cleanup
			(setvar "CMDDIA" cmD)
			(setq 	ssMost	nil)
			(if (and layersCol (null (vlax-object-released-p layersCol)))
				(vlax-release-object layersCol)
			)
			(if (and actDoc (null (vlax-object-released-p actDoc)))
				(vlax-release-object actDoc)
			)
			(if (and acadObj (null (vlax-object-released-p acadObj)))
				(vlax-release-object acadObj)
			)
			(gc)
		)
	)
	(if (= Div "M_")
		(progn
			(princ "\nRunning Fdr_Only")
			(load (strcat _path-user "Fdr_Only"))
		)
		(progn
			(princ "\nRunning Fdr_Grey")
			(load (strcat _path-user "Fdr_Grey"))
		)
	)
	(if (/= PlotType "PDF")
		(progn
			(princ "\nRunning View4SwL")
			(load (strcat _path-user "View4SwL"))
			(princ "\nRunning View4Cap")
			(load (strcat _path-user "View4Cap"))
			(princ "\nRunning AddURL")
			(load (strcat _path-user "NoFills"))
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
	
	(if Bug (princ "\n DwfPub01 Exited}\n"))
	(command "_.Layer" "F" "????CP*" "")
	(princ)
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(DwfPub02)
	(setq	LodVer	"2.51c")
)
