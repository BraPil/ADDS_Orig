(defun AddProfArg ( ProFiLst /	AcadObj AppObj PrefObj )
	(vl-load-com)
	(setq	AcadObj	(vlax-get-acad-object))
	(if AcadObj
		(setq	AppObj	(vlax-get AcadObj "Preferences"))
	)
	(if AppObj
		(setq	PrefObj	(vlax-get AppObj "Profiles"))
	)
	(if ProFiLst
		(if (findfile (nth 1 ProFiLst))
			(vlax-invoke PrefObj "ImportProfile" (nth 0 ProFiLst) (nth 1 ProFiLst) :vlax-true)
		)
	)
)
