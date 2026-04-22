(defun Acad_ADO_Init ( / )					; Initialization ID Line
	(vlisp-import-symbol 'AppNam)
	(vlisp-import-symbol 'DevMark)
	(if AppNam
		(princ (strcat "\n" AppNam " Acad_ADO Loading."))
		(progn
			(setq	AppNam	"Adds 3.0.1a")
			(princ (strcat "\n" AppNam " Acad_ADO Loading."))
		)
	)
	(if (not (vl-registry-descendents "HKEY_CLASSES_ROOT\\Acad_SCS.SCSB_Adds" nil))
		(princ "\n*Error*\tModule [SCSB_Adds] not found!")
	)
	(setq	LodVer	"3.0.1a")
	(vl-acad-defun 'ADO_GetDevInfo)
	(vl-acad-defun 'ADO_GetCurOraData)
	(vl-acad-defun 'ADO_GetObjMst)
	(vl-acad-defun 'ADO_GetObjReg)
	(vl-acad-defun 'ADO_GetObjBlk)
	(vl-acad-defun 'ADO_GetObjAtt)
	(vl-acad-defun 'ADO_GetObjTxt)
	(vl-acad-defun 'ADO_GetObj4PL)
	(vl-acad-defun 'ADO_GetObj_PL)
	(vl-acad-defun 'ADO_GetObjVrt)
	(vl-acad-defun 'ADO_GetNextNum)
	(vl-acad-defun 'ADO_GetNextNumR)
	(vl-acad-defun 'ADO_DelObjMst)
	(vl-acad-defun 'ADO_PutObj_PL)
	(vl-acad-defun 'ADO_PutObj4PL)
	(vl-acad-defun 'ADO_PutObjAtt)
	(vl-acad-defun 'ADO_PutObjBlk)
	(vl-acad-defun 'ADO_PutObjMst)
	(vl-acad-defun 'ADO_PutObjReg)
	(vl-acad-defun 'ADO_PutObjTxt)
	(vl-acad-defun 'ADO_PutObjVrt)
	(vl-acad-defun 'ADO_PutPanLog)
	(princ)
	(vlisp-export-symbol 'LodVer)
)

(defun ADO_GetMstCnt ( OraInst Panel_ID /		;Puts Master Object List for a panel directly into Oracle
					SQLStatement ADO_DLLPath ConnectionObject coState coMode
					aCommandObject aParameterObject afield dvalue fvalue
					SQLStatement RecBlkLst RecCnt ValueCnt ValueItm ValueLst ParamLst Bubba )
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(vlisp-import-symbol 'Bug)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq	RecCnt		0
					ErrCnt		0
					ErrFnd		nil
			)
			(setq	ParamLst			(list
										(list 8 adok-adVarChar adok-adParamInput)
										(list 25 adok-adVarChar adok-adParamReturnValue)
									)
					ValueLst			(list	(itoa Panel_ID)
									)
					ColumLst			(list	"} Adds_Blk_Nam {"
									)
					ModNam			"ADO_GetMstCnt"
					Bubba			(ADO_Mak_CmdObj	(list	OraInst
															"AddsDb.Get_PanCnt"
															ParamLst
													)
									)
					ConnectionObject	(if Bubba (nth 0 Bubba) nil)
					aCommandObject		(if Bubba (nth 1 Bubba) nil)
					aParameterObject	(if Bubba (nth 2 Bubba) nil)
					ValueCnt	0
			)
			(vlax-invoke-method	ConnectionObject 'BeginTrans)
			(foreach	ValueItm
					ValueLst
					(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
					(vlax-put-property afield 'Value (nth ValueCnt ValueLst))
					(setq	ValueCnt	(1+ ValueCnt))
			)
			;;;***************** Execute *****************
			(vlax-invoke-method aCommandObject "Execute" nil nil nil)
			(setq	ErrObj	(vlax-get-property ConnectionObject 'Errors))
	  		(setq	ErrCnt	(vlax-get-property ErrObj 'Count))
	  		(if (> ErrCnt 0)
				(setq	Bubba	"\nClearing ConnectionObject Errors..."
						ErrItm	(vlax-get-property ErrObj 'Item 0)
						Bubba	(vlax-invoke-method ErrObj 'Clear)
				)
			)
			(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
		  	(setq	fvalue	(vlax-variant-value (vlax-get-property afield 'Value)))
	  		(if (= (substr fvalue 1 5) "FALSE")
				(if (not ErrFnd)
					(setq	ErrFnd	T)
				)
			)
	  		(if (= (substr fvalue 1 5) "FALSE")
			  	(ScLog_PutLin	"Acad_ADO"
							(strcat	"\nError [ " ModNam
									" ] RecCnt {" (itoa RecCnt) 
									(apply (quote strcat) (mapcar (quote (lambda (x y) (strcat x y))) ColumLst ValueLst))
									"}"
							)
				)
			)
			(setq	RecCnt	(atoi fvalue))
			(vlax-invoke-method	ConnectionObject 'CommitTrans)
			(if (and aParameterObject (null (vlax-object-released-p aParameterObject)))
				(vlax-release-object aParameterObject)
			)
			(setq	aParameterObject		nil)
			(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
				(vlax-release-object aCommandObject)
			)
			(setq	aCommandObject		nil)
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateOpen)
				(vlax-invoke-method ConnectionObject "Close")
			)
			(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
				(vlax-release-object ConnectionObject)
			)
			(setq	ConnectionObject	nil
					afield			nil
			)
		)
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(if ErrFnd
		-1
		RecCnt
	)
)

(defun ADO_GetDevInfo ( OraInst Device_ID /		;Gets Selected Info about a Device, by Device_ID
					SQLStatement ADO_DLLPath ConnectionObject coState coMode
					aCommandObject aParameterObject afield dvalue fvalue
					SQLStatement RecBlkLst DevInfoLst ValueCnt ValueItm ValueLst ParamLst Bubba )
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(vlisp-import-symbol 'Bug)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq	DevInfoLst	"Nothing"
					ErrCnt		0
					ErrFnd		nil
			)
			(setq	ParamLst			(list
										(list 25 adok-adVarChar adok-adParamInput)
										(list 25 adok-adVarChar adok-adParamReturnValue)
									)
					ValueLst			(list	(itoa Panel_ID)
									)
					ColumLst			(list	"} Adds_Blk_Nam {"
									)
					ModNam			"ADO_GetDevInfo"
					Bubba			(ADO_Mak_CmdObj	(list	OraInst
															"AddsDb.Get_DevInf"
															ParamLst
													)
									)
					ConnectionObject	(if Bubba (nth 0 Bubba) nil)
					aCommandObject		(if Bubba (nth 1 Bubba) nil)
					aParameterObject	(if Bubba (nth 2 Bubba) nil)
					ValueCnt	0
			)
			(vlax-invoke-method	ConnectionObject 'BeginTrans)
			(foreach	ValueItm
					ValueLst
					(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
					(vlax-put-property afield 'Value (nth ValueCnt ValueLst))
					(setq	ValueCnt	(1+ ValueCnt))
			)
			;;;***************** Execute *****************
			(vlax-invoke-method aCommandObject "Execute" nil nil nil)
			(setq	ErrObj	(vlax-get-property ConnectionObject 'Errors))
	  		(setq	ErrCnt	(vlax-get-property ErrObj 'Count))
	  		(if (> ErrCnt 0)
				(setq	Bubba	"\nClearing ConnectionObject Errors..."
						ErrItm	(vlax-get-property ErrObj 'Item 0)
						Bubba	(vlax-invoke-method ErrObj 'Clear)
				)
			)
			(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
		  	(setq	fvalue	(vlax-variant-value (vlax-get-property afield 'Value)))
	  		(if (= (substr fvalue 1 5) "FALSE")
				(if (not ErrFnd)
					(setq	ErrFnd	T)
				)
			)
	  		(if (= (substr fvalue 1 5) "FALSE")
			  	(ScLog_PutLin	"Acad_ADO"
							(strcat	"\nError [ " ModNam
									" ] DevInfoLst {" DevInfoLst 
									(apply (quote strcat) (mapcar (quote (lambda (x y) (strcat x y))) ColumLst ValueLst))
									"}"
							)
				)
			)
			(setq	DevInfoLst	fvalue)
			(vlax-invoke-method	ConnectionObject 'CommitTrans)
			(if (and aParameterObject (null (vlax-object-released-p aParameterObject)))
				(vlax-release-object aParameterObject)
			)
			(setq	aParameterObject		nil)
			(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
				(vlax-release-object aCommandObject)
			)
			(setq	aCommandObject		nil)
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateOpen)
				(vlax-invoke-method ConnectionObject "Close")
			)
			(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
				(vlax-release-object ConnectionObject)
			)
			(setq	ConnectionObject	nil
					afield			nil
			)
		)
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(if ErrFnd
		-1
		DevInfoLst
	)
)

(defun ADO_GetCurOraData ( Panel_ID /	Bubba	; Returns Object History
								CurMstDevLst CurRegDatLst CurObjBlkLst CurObjAttLst TimStrt TimEnd
								CurObjTxtLst CurObj4PLLst CurObjPL_Lst CurObjVrtLst OraInst )
	(if (= (type Panel_ID) 'STR)
		(setq	Panel_ID	(cadr (assoc Panel_ID Lst_Pan_ID)))
	)
	(vlisp-import-symbol 'Bug)
	(setq	OraInst		"DEMBAU1"
			TimStrt		(if Bug (TimLap nil))
			MstLstCnt		(ADO_GetMstCnt OraInst Panel_ID)	;007
	)
;;;	(setq	OraInst		"DEMBAU1"
;;;			TimStrt		(if Bug (TimLap nil))
;;;			CurObjMstLst	(ADO_GetObjMst OraInst Panel_ID)	;007
;;;			Bubba		(if (and Bug CurObjMstLst) (princ (strcat "\nBug: CurMstDevLst has {" (itoa (length CurObjMstLst)) "} items.\n")))
;;;			TimEnd		(if Bug (TimLap TimStrt))
;;;			TimStrt		(if Bug (TimLap nil))
;;;			;;CurObjRegLst	(ADO_GetObjReg OraInst Panel_ID)	;006
;;;			CurObjRegLst	(list (list (caar CurObjMstLst) "ID" (caar CurObjMstLst)))
;;;			Bubba		(if (and Bug CurObjRegLst) (princ (strcat "\nBug: CurRegDatLst has {" (itoa (length CurObjRegLst)) "} items.\n")))
;;;			TimEnd		(if Bug (TimLap TimStrt))
;;;			TimStrt		(if Bug (TimLap nil))
;;;			CurObjBlkLst	(ADO_GetObjBlk OraInst Panel_ID)	;004
;;;			Bubba		(if (and Bug CurObjBlkLst) (princ (strcat "\nBug: CurObjBlkLst has {" (itoa (length CurObjBlkLst)) "} items.\n")))
;;;			TimEnd		(if Bug (TimLap TimStrt))
;;;			TimStrt		(if Bug (TimLap nil))
;;;			CurObjAttLst	(ADO_GetObjAtt OraInst Panel_ID)	;005
;;;			Bubba		(if (and Bug CurObjAttLst) (princ (strcat "\nBug: CurObjAttLst has {" (itoa (length CurObjAttLst)) "} items.\n")))
;;;			TimEnd		(if Bug (TimLap TimStrt))
;;;			TimStrt		(if Bug (TimLap nil))
;;;			CurObjTxtLst	(ADO_GetObjTxt OraInst Panel_ID)	;003
;;;			Bubba		(if (and Bug CurObjTxtLst) (princ (strcat "\nBug: CurObjTxtLst has {" (itoa (length CurObjTxtLst)) "} items.\n")))
;;;			TimEnd		(if Bug (TimLap TimStrt))
;;;			TimStrt		(if Bug (TimLap nil))
;;;			CurObj4PLLst	(ADO_GetObj4PL OraInst Panel_ID)	;008
;;;			Bubba		(if (and Bug CurObj4PLLst) (princ (strcat "\nBug: CurObj4PLLst has {" (itoa (length CurObj4PLLst)) "} items.\n")))
;;;			TimEnd		(if Bug (TimLap TimStrt))
;;;			TimStrt		(if Bug (TimLap nil))
;;;			CurObjPL_Lst	(ADO_GetObj_PL OraInst Panel_ID)	;001
;;;			Bubba		(if (and Bug CurObjPL_Lst) (princ (strcat "\nBug: CurObjPL_Lst has {" (itoa (length CurObjPL_Lst)) "} items.\n")))
;;;			TimEnd		(if Bug (TimLap TimStrt))
;;;			TimStrt		(if Bug (TimLap nil))
;;;			CurObjVrtLst	(ADO_GetObjVrt OraInst Panel_ID)	;002
;;;			Bubba		(if (and Bug CurObjVrtLst) (princ (strcat "\nBug: CurObjVrtLst has {" (itoa (length CurObjVrtLst)) "} items.\n")))
;;;			TimEnd		(if Bug (TimLap TimStrt))
;;;	)
;;;	(list CurObjMstLst CurObjRegLst CurObjBlkLst CurObjAttLst CurObjTxtLst CurObj4PLLst CurObjPL_Lst CurObjVrtLst)

)

(defun ADO_GetMstCnt_Old ( OraInst Panel_ID /	;Gets Master Object List for a panel directly from Oracle
						SQLStatement ADO_DLLPath ConnectionObject coState coMode
						aCommandObject RecordSetObject
						SuppAddNew rsState fvalue nvalue reccnt
						RecMstLst Field00 Field01 Field02 Field03 CurObjMstLst
						aBOF aEOF fieldsObj i )
	(if Panel_ID
		(setq	SQLStatement	(strcat	"SELECT count(omd.device_id) FROM addsdb.objmstdev omd"
									" where (omd.adds_panel_id = "
									(itoa Panel_ID)
									")"
							)
				CurObjMstLst	nil
		)
		(progn
			(setq	SQLStatement	nil
					CurObjMstLst	nil
			)
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq ConnectionObject (vlax-create-object "ADODB.Connection"))
			(vlax-put-property ConnectionObject "Provider"  "OraOLEDB.Oracle.1")
			(vlax-put-property ConnectionObject "CommandTimeout" 30)
			(setq coMode (vlax-get-property ConnectionObject 'Mode)) ; = 0
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateClosed)
				(vlax-put-property ConnectionObject 'Mode adok-adModeReadWrite)
			)
			(vlax-invoke-method	ConnectionObject					;;; Use the Oracle OLEDB Drivers
							"Open"
							OraInst
							"GEWILYMS"
							"GEWILYMS"
							adok-adConnectUnspecified
			)
			(setq RecordSetObject (vlax-create-object "ADODB.RecordSet"))
			(vlax-put-property RecordSetObject 'CursorType adok-adOpenDynamic)
			(vlax-put-property RecordSetObject 'LockType   adok-adLockOptimistic)
			(setq aCommandObject (vlax-create-object "ADODB.Command"))
			(vlax-put-property aCommandObject 'ActiveConnection ConnectionObject)
			(vlax-put-property aCommandObject 'CommandText SQLStatement)
			(vlax-put-property aCommandObject 'CommandType adok-adCmdText)
			(setq RecordSetObject (vlax-invoke-method aCommandObject "Execute" nil nil nil))
;;;			(setq SuppAddNew (vlax-invoke-method RecordSetObject 'Supports adok-adAddNew))
			(setq rsState (vlax-get-property RecordSetObject 'State))
			(if (= rsState adok-adStateOpen)
				(progn
					(setq	fieldsObj		(vlax-get-property RecordSetObject 'Fields)
							Field00		(vlax-get-property fieldsObj 'Item 0)	;;; Count
					)
					(if (and (= (setq aBOF (vlax-get-property RecordSetObject 'BOF)) :vlax-false) (= (setq aEOF (vlax-get-property RecordSetObject 'EOF)) :vlax-false))
					  (progn
						(setq	RecMstLst	(vlax-variant-value (vlax-get-property Field00 'Value)))	;;; Count
						(if CurObjMstLst
							(setq	CurObjMstLst	(cons RecMstLst CurObjMstLst))
							(setq	CurObjMstLst	(list RecMstLst))
						)
						(vlax-invoke-method RecordSetObject 'MoveNext)
					  )
					)
;;;					(while (and (= (setq aBOF (vlax-get-property RecordSetObject 'BOF)) :vlax-false) (= (setq aEOF (vlax-get-property RecordSetObject 'EOF)) :vlax-false))
;;;						(setq	RecMstLst	(list	(vlax-variant-value (vlax-get-property Field00 'Value))		;;; Device_ID
;;;												(vlax-variant-value (vlax-get-property Field01 'Value))		;;; Edit_DTM
;;;												(vlax-variant-value (vlax-get-property Field02 'Value))		;;; Status_Flag
;;;												(atoi (vlax-variant-value (vlax-get-property Field03 'Value)))	;;; Adds_Panel_ID
;;;										)
;;;						)
;;;						(if CurObjMstLst
;;;							(setq	CurObjMstLst	(cons RecMstLst CurObjMstLst))
;;;							(setq	CurObjMstLst	(list RecMstLst))
;;;						)
;;;						(vlax-invoke-method RecordSetObject 'MoveNext)
;;;					)
				)
				(princ (strcat "\nRecord Set NOT Available, Record Set State = " (itoa rsState)))
			)
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateOpen)
				(vlax-invoke-method ConnectionObject "Close")
			)
			(if (and Field00 (null (vlax-object-released-p Field00)))
				(vlax-release-object Field00)
			)
			(if (and fieldsObj (null (vlax-object-released-p fieldsObj)))
				(vlax-release-object fieldsObj)
			)
			(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
				(vlax-release-object aCommandObject)
			)
			(if (and RecordSetObject (null (vlax-object-released-p RecordSetObject)))
				(vlax-release-object RecordSetObject)
			)
			(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
				(vlax-release-object ConnectionObject)
			)
			(setq	ConnectionObject	nil
					RecordSetObject	nil
					aCommandObject		nil
					fieldsObj			nil
					Field00			nil
			)
		)
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	CurObjMstLst
)

(defun ADO_GetObjMst ( OraInst Panel_ID /		;Gets Master Object List for a panel directly from Oracle
						SQLStatement ADO_DLLPath ConnectionObject coState coMode
						aCommandObject RecordSetObject
						SuppAddNew rsState fvalue nvalue reccnt
						RecMstLst Field00 Field01 Field02 Field03 CurObjMstLst
						aBOF aEOF fieldsObj i )
	(if Panel_ID
		(setq	SQLStatement	(strcat	"SELECT omd.device_id, to_char(omd.edit_dtm,'MM-DD-YYYY HH24:MI:SS') as Edit_DTM,"
									" omd.status_flag, to_char(omd.adds_panel_id) as Adds_Panel_ID FROM addsdb.objmstdev omd"
									" where (omd.adds_panel_id = "
									(itoa Panel_ID)
									")"
							)
				CurObjMstLst	nil
		)
		(progn
			(setq	SQLStatement	nil
					CurObjMstLst	nil
			)
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq ConnectionObject (vlax-create-object "ADODB.Connection"))
			(vlax-put-property ConnectionObject "Provider"  "OraOLEDB.Oracle.1")
			(vlax-put-property ConnectionObject "CommandTimeout" 30)
			(setq coMode (vlax-get-property ConnectionObject 'Mode)) ; = 0
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateClosed)
				(vlax-put-property ConnectionObject 'Mode adok-adModeReadWrite)
			)
			(vlax-invoke-method	ConnectionObject					;;; Use the Oracle OLEDB Drivers
							"Open"
							OraInst
							"GEWILYMS"
							"GEWILYMS"
							adok-adConnectUnspecified
			)
			(setq RecordSetObject (vlax-create-object "ADODB.RecordSet"))
			(vlax-put-property RecordSetObject 'CursorType adok-adOpenDynamic)
			(vlax-put-property RecordSetObject 'LockType   adok-adLockOptimistic)
			(setq aCommandObject (vlax-create-object "ADODB.Command"))
			(vlax-put-property aCommandObject 'ActiveConnection ConnectionObject)
			(vlax-put-property aCommandObject 'CommandText SQLStatement)
			(vlax-put-property aCommandObject 'CommandType adok-adCmdText)
			(setq RecordSetObject (vlax-invoke-method aCommandObject "Execute" nil nil nil))
			(setq SuppAddNew (vlax-invoke-method RecordSetObject 'Supports adok-adAddNew))
			(setq rsState (vlax-get-property RecordSetObject 'State))
			(if (= rsState adok-adStateOpen)
				(progn
					(setq	fieldsObj		(vlax-get-property RecordSetObject 'Fields)
							Field00		(vlax-get-property fieldsObj 'Item 0)	;;; Device_ID
							Field01		(vlax-get-property fieldsObj 'Item 1)	;;; Edit_DTM
							Field02		(vlax-get-property fieldsObj 'Item 2)	;;; Status_Flag
							Field03		(vlax-get-property fieldsObj 'Item 3)	;;; Adds_Panel_ID
					)
					(while (and (= (setq aBOF (vlax-get-property RecordSetObject 'BOF)) :vlax-false) (= (setq aEOF (vlax-get-property RecordSetObject 'EOF)) :vlax-false))
						(setq	RecMstLst	(list	(vlax-variant-value (vlax-get-property Field00 'Value))		;;; Device_ID
												(vlax-variant-value (vlax-get-property Field01 'Value))		;;; Edit_DTM
												(vlax-variant-value (vlax-get-property Field02 'Value))		;;; Status_Flag
												(atoi (vlax-variant-value (vlax-get-property Field03 'Value)))	;;; Adds_Panel_ID
										)
						)
						(if CurObjMstLst
							(setq	CurObjMstLst	(cons RecMstLst CurObjMstLst))
							(setq	CurObjMstLst	(list RecMstLst))
						)
						(vlax-invoke-method RecordSetObject 'MoveNext)
					)
				)
				(princ (strcat "\nRecord Set NOT Available, Record Set State = " (itoa rsState)))
			)
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateOpen)
				(vlax-invoke-method ConnectionObject "Close")
			)
			(if (and Field00 (null (vlax-object-released-p Field00)))
				(vlax-release-object Field00)
			)
			(if (and Field01 (null (vlax-object-released-p Field01)))
				(vlax-release-object Field01)
			)
			(if (and Field02 (null (vlax-object-released-p Field02)))
				(vlax-release-object Field02)
			)
			(if (and Field03 (null (vlax-object-released-p Field03)))
				(vlax-release-object Field03)
			)
			(if (and fieldsObj (null (vlax-object-released-p fieldsObj)))
				(vlax-release-object fieldsObj)
			)
			(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
				(vlax-release-object aCommandObject)
			)
			(if (and RecordSetObject (null (vlax-object-released-p RecordSetObject)))
				(vlax-release-object RecordSetObject)
			)
			(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
				(vlax-release-object ConnectionObject)
			)
			(setq	ConnectionObject	nil
					RecordSetObject	nil
					aCommandObject		nil
					fieldsObj			nil
					Field00			nil
					Field01			nil
					Field02			nil
					Field03			nil
			)
		)
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	CurObjMstLst
)

(defun ADO_GetObjReg ( OraInst Panel_ID /		;Gets Master Object List for a panel directly from Oracle
						SQLStatement ADO_DLLPath ConnectionObject reccnt
						aCommandObject SuppAddNew rsState fvalue nvalue coState
						RecDatLst Field00 Field01 Field02 CurObjRegLst
						RecordSetObject aBOF aEOF fieldsObj afield i )
	(if Panel_ID
		(setq	SQLStatement	(strcat	"SELECT orp.device_id, orp.xdtname, orp.xdtvalue FROM addsdb.objrgapp orp"
									" where (orp.device_id in (select omd.device_id from addsdb.objmstdev omd where omd.adds_panel_id = "
									(itoa Panel_ID)
									"))"
							)
				CurObjRegLst	nil
		)
		(progn
			(setq	SQLStatement	nil
					CurObjRegLst	nil
			)
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq ConnectionObject (vlax-create-object "ADODB.Connection"))
			(vlax-put-property ConnectionObject "Provider"  "OraOLEDB.Oracle.1")
			(vlax-put-property ConnectionObject "CommandTimeout" 30)
			(setq coMode (vlax-get-property ConnectionObject 'Mode)) ; = 0
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateClosed)
				(vlax-put-property ConnectionObject 'Mode adok-adModeReadWrite)
			)
			(vlax-invoke-method	ConnectionObject					;;; Use the Oracle OLEDB Drivers
							"Open"
							OraInst
							"GEWILYMS"
							"GEWILYMS"
							adok-adConnectUnspecified
			)
			(setq RecordSetObject (vlax-create-object "ADODB.RecordSet"))
			(vlax-put-property RecordSetObject 'CursorType adok-adOpenDynamic)
			(vlax-put-property RecordSetObject 'LockType   adok-adLockOptimistic)
			(setq aCommandObject (vlax-create-object "ADODB.Command"))
			(vlax-put-property aCommandObject 'ActiveConnection ConnectionObject)
			(vlax-put-property aCommandObject 'CommandText SQLStatement)
			(vlax-put-property aCommandObject 'CommandType adok-adCmdText)
			(setq RecordSetObject (vlax-invoke-method aCommandObject "Execute" nil nil nil))
			(setq SuppAddNew (vlax-invoke-method RecordSetObject 'Supports adok-adAddNew))
			(setq rsState (vlax-get-property RecordSetObject 'State))
			(if (= rsState adok-adStateOpen)
				(progn
					(setq	fieldsObj		(vlax-get-property RecordSetObject 'Fields)
							Field00		(vlax-get-property fieldsObj 'Item 0)	;;; Device_ID
							Field01		(vlax-get-property fieldsObj 'Item 1)	;;; XtdName
							Field02		(vlax-get-property fieldsObj 'Item 2)	;;; XtdValue
					)
					(while (and (= (setq aBOF (vlax-get-property RecordSetObject 'BOF)) :vlax-false) (= (setq aEOF (vlax-get-property RecordSetObject 'EOF)) :vlax-false))
						(setq	RecDatLst	(list	(vlax-variant-value (vlax-get-property Field00 'Value))	;;; Device_ID
												(vlax-variant-value (vlax-get-property Field01 'Value))	;;; XtdName
												(vlax-variant-value (vlax-get-property Field02 'Value))	;;; XtdValue
										)
						)
						(if CurObjRegLst
							(setq	CurObjRegLst	(cons RecDatLst CurObjRegLst))
							(setq	CurObjRegLst	(list RecDatLst))
						)
						(vlax-invoke-method RecordSetObject 'MoveNext)
					)
				)
				(princ (strcat "\nRecord Set NOT Available, Record Set State = " (itoa rsState)))
			)
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateOpen)
				(vlax-invoke-method ConnectionObject "Close")
			)
			(if (and Field00 (null (vlax-object-released-p Field00)))
				(vlax-release-object Field00)
			)
			(if (and Field01 (null (vlax-object-released-p Field01)))
				(vlax-release-object Field01)
			)
			(if (and Field02 (null (vlax-object-released-p Field02)))
				(vlax-release-object Field02)
			)
			(if (and fieldsObj (null (vlax-object-released-p fieldsObj)))
				(vlax-release-object fieldsObj)
			)
			(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
				(vlax-release-object aCommandObject)
			)
			(if (and RecordSetObject (null (vlax-object-released-p RecordSetObject)))
				(vlax-release-object RecordSetObject)
			)
			(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
				(vlax-release-object ConnectionObject)
			)
			(setq	ConnectionObject	nil
					RecordSetObject	nil
					aCommandObject		nil
					fieldsObj			nil
					Field00			nil
					Field01			nil
					Field02			nil
			)
		)
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	CurObjRegLst
)

(defun ADO_GetObjBlk ( OraInst Panel_ID /		;Gets Master Object List for a panel directly from Oracle
						SQLStatement ADO_DLLPath ConnectionObject reccnt
						aCommandObject SuppAddNew rsState fvalue nvalue coState
						RecBlkLst Field00 Field01 Field02 Field03 CurObjBlkLst
						Field04 Field05 Field06 Field07 Field08 Field09 Field10 Field11
						Field12 Field13 RecordSetObject aBOF aEOF fieldsObj afield i )
	(if Panel_ID
		(setq	SQLStatement	(strcat	"SELECT obk.Adds_Blk_Nam,"
									" obk.BlkHandle,"
									" obk.Adds_Layer_Nam,"
									" to_char(obk.BlkPntX) as BlkPntX,"
									" to_char(obk.BlkPntY) as BlkPntY,"
									" to_char(obk.BlkPntZ) as BlkPntZ,"
									" to_char(obk.BlkSclX) as BlkSclX,"
									" to_char(obk.BlkSclY) as BlkSclY,"
									" to_char(obk.BlkSclZ) as BlkSclZ,"
									" to_char(obk.BlkRot) as BlkRot,"
									" to_char(obk.BlkSpace) as BlkSpace,"
									" to_char(obk.BlkAttFlw) as BlkAttFlw,"
									" obk.Device_ID,"
									" to_char(obk.adds_panel_id) as Adds_Panel_ID"
									" FROM addsdb.objblk obk"
									" where (obk.adds_panel_id = "
									(itoa Panel_ID)
									")"
							)
				CurObjBlkLst	nil
		)
		(progn
			(setq	SQLStatement	nil
					CurObjBlkLst	nil
			)
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq ConnectionObject (vlax-create-object "ADODB.Connection"))
			(vlax-put-property ConnectionObject "Provider"  "OraOLEDB.Oracle.1")
			(vlax-put-property ConnectionObject "CommandTimeout" 30)
			(setq coMode (vlax-get-property ConnectionObject 'Mode)) ; = 0
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateClosed)
				(vlax-put-property ConnectionObject 'Mode adok-adModeReadWrite)
			)
			(vlax-invoke-method	ConnectionObject					;;; Use the Oracle OLEDB Drivers
							"Open"
							OraInst
							"GEWILYMS"
							"GEWILYMS"
							adok-adConnectUnspecified
			)
			(setq RecordSetObject (vlax-create-object "ADODB.RecordSet"))
			(vlax-put-property RecordSetObject 'CursorType adok-adOpenDynamic)
			(vlax-put-property RecordSetObject 'LockType   adok-adLockOptimistic)
			(setq aCommandObject (vlax-create-object "ADODB.Command"))
			(vlax-put-property aCommandObject 'ActiveConnection ConnectionObject)
			(vlax-put-property aCommandObject 'CommandText SQLStatement)
			(vlax-put-property aCommandObject 'CommandType adok-adCmdText)
			(setq RecordSetObject (vlax-invoke-method aCommandObject "Execute" nil nil nil))
			(setq SuppAddNew (vlax-invoke-method RecordSetObject 'Supports adok-adAddNew))
			(setq rsState (vlax-get-property RecordSetObject 'State))
			(if (= rsState adok-adStateOpen)
				(progn
					(setq	fieldsObj		(vlax-get-property RecordSetObject 'Fields)
							Field00		(vlax-get-property fieldsObj 'Item 0)	;;; Adds_Blk_Nam
							Field01		(vlax-get-property fieldsObj 'Item 1)	;;; BlkHandle
							Field02		(vlax-get-property fieldsObj 'Item 2)	;;; Adds_Layer_Nam
							Field03		(vlax-get-property fieldsObj 'Item 3)	;;; BlkPntX
							Field04		(vlax-get-property fieldsObj 'Item 4)	;;; BlkPntY
							Field05		(vlax-get-property fieldsObj 'Item 5)	;;; BlkPntZ
							Field06		(vlax-get-property fieldsObj 'Item 6)	;;; BlkSclX
							Field07		(vlax-get-property fieldsObj 'Item 7)	;;; BlkSclY
							Field08		(vlax-get-property fieldsObj 'Item 8)	;;; BlkSclZ
							Field09		(vlax-get-property fieldsObj 'Item 9)	;;; BlkRot
							Field10		(vlax-get-property fieldsObj 'Item 10)	;;; BlkSpace
							Field11		(vlax-get-property fieldsObj 'Item 11)	;;; BlkAttFlw
							Field12		(vlax-get-property fieldsObj 'Item 12)	;;; Device_ID
							Field13		(vlax-get-property fieldsObj 'Item 13)	;;; Adds_Panel_ID
					)
					(while (and (= (setq aBOF (vlax-get-property RecordSetObject 'BOF)) :vlax-false) (= (setq aEOF (vlax-get-property RecordSetObject 'EOF)) :vlax-false))
						(setq	RecBlkLst	(list	(vlax-variant-value (vlax-get-property Field00 'Value))		;;; Adds_Blk_Nam
												(vlax-variant-value (vlax-get-property Field01 'Value))		;;; BlkHandle
												(vlax-variant-value (vlax-get-property Field02 'Value))		;;; Adds_Layer_Nam
												(atof (vlax-variant-value (vlax-get-property Field03 'Value)))	;;; BlkPntX
												(atof (vlax-variant-value (vlax-get-property Field04 'Value)))	;;; BlkPntY
												(atof (vlax-variant-value (vlax-get-property Field05 'Value)))	;;; BlkPntZ
												(atof (vlax-variant-value (vlax-get-property Field06 'Value)))	;;; BlkSclX
												(atof (vlax-variant-value (vlax-get-property Field07 'Value)))	;;; BlkSclY
												(atof (vlax-variant-value (vlax-get-property Field08 'Value)))	;;; BlkSclZ
												(atof (vlax-variant-value (vlax-get-property Field09 'Value)))	;;; BlkRot
												(atoi (vlax-variant-value (vlax-get-property Field10 'Value)))	;;; BlkSpace
												(atoi (vlax-variant-value (vlax-get-property Field11 'Value)))	;;; BlkAttFlw
												(vlax-variant-value (vlax-get-property Field12 'Value))		;;; Device_ID
												(atoi (vlax-variant-value (vlax-get-property Field13 'Value)))	;;; Adds_Panel_ID
										)
						)
						(if CurObjBlkLst
							(setq	CurObjBlkLst	(cons RecBlkLst CurObjBlkLst))
							(setq	CurObjBlkLst	(list RecBlkLst))
						)
						(vlax-invoke-method RecordSetObject 'MoveNext)
					)
				)
				(princ (strcat "\nRecord Set NOT Available, Record Set State = " (itoa rsState)))
			)
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateOpen)
				(vlax-invoke-method ConnectionObject "Close")
			)
			(if (and Field00 (null (vlax-object-released-p Field00)))
				(vlax-release-object Field00)
			)
			(if (and Field01 (null (vlax-object-released-p Field01)))
				(vlax-release-object Field01)
			)
			(if (and Field02 (null (vlax-object-released-p Field02)))
				(vlax-release-object Field02)
			)
			(if (and Field03 (null (vlax-object-released-p Field03)))
				(vlax-release-object Field03)
			)
			(if (and Field04 (null (vlax-object-released-p Field04)))
				(vlax-release-object Field04)
			)
			(if (and Field05 (null (vlax-object-released-p Field05)))
				(vlax-release-object Field05)
			)
			(if (and Field06 (null (vlax-object-released-p Field06)))
				(vlax-release-object Field06)
			)
			(if (and Field07 (null (vlax-object-released-p Field07)))
				(vlax-release-object Field07)
			)
			(if (and Field08 (null (vlax-object-released-p Field08)))
				(vlax-release-object Field08)
			)
			(if (and Field09 (null (vlax-object-released-p Field09)))
				(vlax-release-object Field09)
			)
			(if (and Field10 (null (vlax-object-released-p Field10)))
				(vlax-release-object Field10)
			)
			(if (and Field11 (null (vlax-object-released-p Field11)))
				(vlax-release-object Field11)
			)
			(if (and Field12 (null (vlax-object-released-p Field12)))
				(vlax-release-object Field12)
			)
			(if (and Field13 (null (vlax-object-released-p Field13)))
				(vlax-release-object Field13)
			)
			(if (and fieldsObj (null (vlax-object-released-p fieldsObj)))
				(vlax-release-object fieldsObj)
			)
			(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
				(vlax-release-object aCommandObject)
			)
			(if (and RecordSetObject (null (vlax-object-released-p RecordSetObject)))
				(vlax-release-object RecordSetObject)
			)
			(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
				(vlax-release-object ConnectionObject)
			)
			(setq	ConnectionObject	nil
					RecordSetObject	nil
					aCommandObject		nil
					fieldsObj			nil
					Field00			nil
					Field01			nil
					Field02			nil
					Field03			nil
					Field04			nil
					Field05			nil
					Field06			nil
					Field07			nil
					Field08			nil
					Field09			nil
					Field10			nil
					Field11			nil
					Field12			nil
					Field13			nil
			)
		)
		;;; Exit if Type Library has NOT been loaded.
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	CurObjBlkLst
)

(defun ADO_GetObjAtt ( OraInst Panel_ID /		;Gets Master Object List for a panel directly from Oracle
						SQLStatement ADO_DLLPath ConnectionObject reccnt
						aCommandObject SuppAddNew rsState fvalue nvalue coState
						RecAttLst Field00 Field01 Field02 Field03 CurObjAttLst
						Field04 Field05 Field06 Field07 Field08 Field09 Field10 Field11
						Field12 Field13 Field14 Field15 Field16 Field17 Field18
						RecordSetObject aBOF aEOF fieldsObj afield i )
	(if Panel_ID
		(setq	SQLStatement	(strcat	"SELECT Oat.AttTag,"
									" Oat.AttValue,"
									" Oat.AttHandle,"
									" Oat.Adds_Layer_Nam,"
									" to_char(Oat.AttNPntX) as AttNPntX,"
									" to_char(Oat.AttNPntY) as AttNPntY,"
									" to_char(Oat.AttNPntZ) as AttNPntZ,"
									" to_char(Oat.AttJPntX) as AttJPntX,"
									" to_char(Oat.AttJPntY) as AttJPntY,"
									" to_char(Oat.AttJPntZ) as AttJPntZ,"
									" to_char(Oat.AttThicK) as AttThicK,"
									" to_char(Oat.AttHgt) as AttHgt,"
									" to_char(Oat.AttRot) as AttRot,"
									" Oat.Adds_Style,"
									" to_char(Oat.AttFlag) as AttFlag,"
									" to_char(Oat.AttTxtFlag) as AttTxtFlag,"
									" to_char(Oat.AttHorzFlag) as AttHorzFlag,"
									" to_char(Oat.AttVertFlag) as AttVertFlag,"
									" Oat.Device_ID"
									" FROM addsdb.objatt Oat"
									" where (oat.device_id in (select obk.device_id from addsdb.objblk obk"
									" where obk.adds_panel_id = "
									(itoa Panel_ID)
									"))"
							)
				CurObjAttLst	nil
		)
		(progn
			(setq	SQLStatement	nil
					CurObjAttLst	nil
			)
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq ConnectionObject (vlax-create-object "ADODB.Connection"))
			(vlax-put-property ConnectionObject "Provider"  "OraOLEDB.Oracle.1")
			(vlax-put-property ConnectionObject "CommandTimeout" 30)
			(setq coMode (vlax-get-property ConnectionObject 'Mode)) ; = 0
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateClosed)
				(vlax-put-property ConnectionObject 'Mode adok-adModeReadWrite)
			)
			(vlax-invoke-method	ConnectionObject					;;; Use the Oracle OLEDB Drivers
							"Open"
							OraInst
							"GEWILYMS"
							"GEWILYMS"
							adok-adConnectUnspecified
			)
			(setq RecordSetObject (vlax-create-object "ADODB.RecordSet"))
			(vlax-put-property RecordSetObject 'CursorType adok-adOpenDynamic)
			(vlax-put-property RecordSetObject 'LockType   adok-adLockOptimistic)
			(setq aCommandObject (vlax-create-object "ADODB.Command"))
			(vlax-put-property aCommandObject 'ActiveConnection ConnectionObject)
			(vlax-put-property aCommandObject 'CommandText SQLStatement)
			(vlax-put-property aCommandObject 'CommandType adok-adCmdText)
			(setq RecordSetObject (vlax-invoke-method aCommandObject "Execute" nil nil nil))
			(setq SuppAddNew (vlax-invoke-method RecordSetObject 'Supports adok-adAddNew))
			(setq rsState (vlax-get-property RecordSetObject 'State))
			(if (= rsState adok-adStateOpen)
				(progn
					(setq	fieldsObj		(vlax-get-property RecordSetObject 'Fields)
							Field00		(vlax-get-property fieldsObj 'Item 0)	;;; AttTag
							Field01		(vlax-get-property fieldsObj 'Item 1)	;;; AttValue
							Field02		(vlax-get-property fieldsObj 'Item 2)	;;; AttHandle
							Field03		(vlax-get-property fieldsObj 'Item 3)	;;; Adds_Layer_Nam
							Field04		(vlax-get-property fieldsObj 'Item 4)	;;; AttNPntX
							Field05		(vlax-get-property fieldsObj 'Item 5)	;;; AttNPntY
							Field06		(vlax-get-property fieldsObj 'Item 6)	;;; AttNPntZ
							Field07		(vlax-get-property fieldsObj 'Item 7)	;;; AttJPntX
							Field08		(vlax-get-property fieldsObj 'Item 8)	;;; AttJPntY
							Field09		(vlax-get-property fieldsObj 'Item 9)	;;; AttJPntZ
							Field10		(vlax-get-property fieldsObj 'Item 10)	;;; AttThicK
							Field11		(vlax-get-property fieldsObj 'Item 11)	;;; AttHgt
							Field12		(vlax-get-property fieldsObj 'Item 12)	;;; AttRot
							Field13		(vlax-get-property fieldsObj 'Item 13)	;;; Adds_Style
							Field14		(vlax-get-property fieldsObj 'Item 14)	;;; AttFlag
							Field15		(vlax-get-property fieldsObj 'Item 15)	;;; AttTxtFlag
							Field16		(vlax-get-property fieldsObj 'Item 16)	;;; AttHorzFlag
							Field17		(vlax-get-property fieldsObj 'Item 17)	;;; AttVertFlag
							Field18		(vlax-get-property fieldsObj 'Item 18)	;;; Device_ID
					)
					(while (and (= (setq aBOF (vlax-get-property RecordSetObject 'BOF)) :vlax-false) (= (setq aEOF (vlax-get-property RecordSetObject 'EOF)) :vlax-false))
						(setq	RecAttLst	(list	(vlax-variant-value (vlax-get-property Field00 'Value))
												(if (vlax-variant-value (vlax-get-property Field01 'Value)) (vlax-variant-value (vlax-get-property Field01 'Value)) "")
												(vlax-variant-value (vlax-get-property Field02 'Value))
												(vlax-variant-value (vlax-get-property Field03 'Value))
												(atof (vlax-variant-value (vlax-get-property Field04 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field05 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field06 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field07 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field08 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field09 'Value)))
												(atoi (vlax-variant-value (vlax-get-property Field10 'Value)))
												(atoi (vlax-variant-value (vlax-get-property Field11 'Value)))
												(atoi (vlax-variant-value (vlax-get-property Field12 'Value)))
												(vlax-variant-value (vlax-get-property Field13 'Value))
												(atoi (vlax-variant-value (vlax-get-property Field14 'Value)))
												(atoi (vlax-variant-value (vlax-get-property Field15 'Value)))
												(atoi (vlax-variant-value (vlax-get-property Field16 'Value)))
												(atoi (vlax-variant-value (vlax-get-property Field17 'Value)))
												(vlax-variant-value (vlax-get-property Field18 'Value))
										)
						)
						(if CurObjAttLst
							(setq	CurObjAttLst	(cons RecAttLst CurObjAttLst))
							(setq	CurObjAttLst	(list RecAttLst))
						)
						(vlax-invoke-method RecordSetObject 'MoveNext)
					)
				)
				(princ (strcat "\nRecord Set NOT Available, Record Set State = " (itoa rsState)))
			)
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateOpen)
				(vlax-invoke-method ConnectionObject "Close")
			)
			(if (and Field00 (null (vlax-object-released-p Field00)))
				(vlax-release-object Field00)
			)
			(if (and Field01 (null (vlax-object-released-p Field01)))
				(vlax-release-object Field01)
			)
			(if (and Field02 (null (vlax-object-released-p Field02)))
				(vlax-release-object Field02)
			)
			(if (and Field03 (null (vlax-object-released-p Field03)))
				(vlax-release-object Field03)
			)
			(if (and Field04 (null (vlax-object-released-p Field04)))
				(vlax-release-object Field04)
			)
			(if (and Field05 (null (vlax-object-released-p Field05)))
				(vlax-release-object Field05)
			)
			(if (and Field06 (null (vlax-object-released-p Field06)))
				(vlax-release-object Field06)
			)
			(if (and Field07 (null (vlax-object-released-p Field07)))
				(vlax-release-object Field07)
			)
			(if (and Field08 (null (vlax-object-released-p Field08)))
				(vlax-release-object Field08)
			)
			(if (and Field09 (null (vlax-object-released-p Field09)))
				(vlax-release-object Field09)
			)
			(if (and Field10 (null (vlax-object-released-p Field10)))
				(vlax-release-object Field10)
			)
			(if (and Field11 (null (vlax-object-released-p Field11)))
				(vlax-release-object Field11)
			)
			(if (and Field12 (null (vlax-object-released-p Field12)))
				(vlax-release-object Field12)
			)
			(if (and Field13 (null (vlax-object-released-p Field13)))
				(vlax-release-object Field13)
			)
			(if (and Field14 (null (vlax-object-released-p Field14)))
				(vlax-release-object Field14)
			)
			(if (and Field15 (null (vlax-object-released-p Field15)))
				(vlax-release-object Field15)
			)
			(if (and Field16 (null (vlax-object-released-p Field16)))
				(vlax-release-object Field16)
			)
			(if (and Field17 (null (vlax-object-released-p Field17)))
				(vlax-release-object Field17)
			)
			(if (and Field18 (null (vlax-object-released-p Field18)))
				(vlax-release-object Field18)
			)
			(if (and fieldsObj (null (vlax-object-released-p fieldsObj)))
				(vlax-release-object fieldsObj)
			)
			(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
				(vlax-release-object aCommandObject)
			)
			(if (and RecordSetObject (null (vlax-object-released-p RecordSetObject)))
				(vlax-release-object RecordSetObject)
			)
			(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
				(vlax-release-object ConnectionObject)
			)
			(setq	ConnectionObject	nil
					RecordSetObject	nil
					aCommandObject		nil
					fieldsObj			nil
					Field00			nil
					Field01			nil
					Field02			nil
					Field03			nil
					Field04			nil
					Field05			nil
					Field06			nil
					Field07			nil
					Field08			nil
					Field09			nil
					Field10			nil
					Field11			nil
					Field12			nil
					Field13			nil
					Field14			nil
					Field15			nil
					Field16			nil
					Field17			nil
					Field18			nil
			)
		)
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	CurObjAttLst
)

(defun ADO_GetObjTxt ( OraInst Panel_ID /		;Gets Master Object List for a panel directly from Oracle
						SQLStatement ADO_DLLPath ConnectionObject reccnt
						aCommandObject SuppAddNew rsState fvalue nvalue coState
						RecTxtLst Field00 Field01 Field02 Field03 CurObjTxtLst
						Field04 Field05 Field06 Field07 Field08 Field09 Field10 Field11
						Field12 Field13 Field14 Field15 Field16 Field17 Field18 Field19
						RecordSetObject aBOF aEOF fieldsObj afield i )
	(if Panel_ID
		(setq	SQLStatement	(strcat	"SELECT Otx.TxtDataType,"
									" Otx.TxtHandle,"
									" Otx.Adds_Layer_Nam,"
									" Otx.TxtValue,"
									" Otx.Adds_Style,"
									" to_char(Otx.TxtNPntX) as TxtNPntX,"
									" to_char(Otx.TxtNPntY) as TxtNPntY,"
									" to_char(Otx.TxtNPntZ) as TxtNPntZ,"
									" to_char(Otx.TxtJPntX) as TxtJPntX,"
									" to_char(Otx.TxtJPntY) as TxtJPntY,"
									" to_char(Otx.TxtJPntZ) as TxtJPntZ,"
									" to_char(Otx.TxtThicK) as TxtThicK,"
									" to_char(Otx.TxtHgt) as TxtHgt,"
									" to_char(Otx.TxtRot) as TxtRot,"
									" to_char(Otx.TxtSpace) as TxtSpace,"
									" to_char(Otx.TxtFlag) as TxtFlag,"
									" to_char(Otx.TxtHorzFlag) as TxtHorzFlag,"
									" to_char(Otx.TxtVertFlag) as TxtVertFlag,"
									" Otx.Device_ID,"
									" to_char(Otx.Adds_Panel_ID) as Adds_Panel_ID"
									" FROM addsdb.objtxt Otx"
									" where (Otx.Adds_Panel_ID = "
									(itoa Panel_ID)
									")"
							)
				CurObjTxtLst	nil
		)
		(progn
			(setq	SQLStatement	nil
					CurObjTxtLst	nil
			)
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq ConnectionObject (vlax-create-object "ADODB.Connection"))
			(vlax-put-property ConnectionObject "Provider"  "OraOLEDB.Oracle.1")
			(vlax-put-property ConnectionObject "CommandTimeout" 30)
			(setq coMode (vlax-get-property ConnectionObject 'Mode)) ; = 0
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateClosed)
				(vlax-put-property ConnectionObject 'Mode adok-adModeReadWrite)
			)
			(vlax-invoke-method	ConnectionObject					;;; Use the Oracle OLEDB Drivers
							"Open"
							OraInst
							"GEWILYMS"
							"GEWILYMS"
							adok-adConnectUnspecified
			)
			(setq RecordSetObject (vlax-create-object "ADODB.RecordSet"))
			(vlax-put-property RecordSetObject 'CursorType adok-adOpenDynamic)
			(vlax-put-property RecordSetObject 'LockType   adok-adLockOptimistic)
			(setq aCommandObject (vlax-create-object "ADODB.Command"))
			(vlax-put-property aCommandObject 'ActiveConnection ConnectionObject)
			(vlax-put-property aCommandObject 'CommandText SQLStatement)
			(vlax-put-property aCommandObject 'CommandType adok-adCmdText)
			(setq RecordSetObject (vlax-invoke-method aCommandObject "Execute" nil nil nil))
			(setq SuppAddNew (vlax-invoke-method RecordSetObject 'Supports adok-adAddNew))
			(setq rsState (vlax-get-property RecordSetObject 'State))
			(if (= rsState adok-adStateOpen)
				(progn
					(setq	fieldsObj		(vlax-get-property RecordSetObject 'Fields)
							Field00		(vlax-get-property fieldsObj 'Item 0)	;;; TxtDataType
							Field01		(vlax-get-property fieldsObj 'Item 1)	;;; TxtHandle
							Field02		(vlax-get-property fieldsObj 'Item 2)	;;; Adds_Layer_Nam
							Field03		(vlax-get-property fieldsObj 'Item 3)	;;; TxtValue
							Field04		(vlax-get-property fieldsObj 'Item 4)	;;; Adds_Style
							Field05		(vlax-get-property fieldsObj 'Item 5)	;;; TxtNPntX
							Field06		(vlax-get-property fieldsObj 'Item 6)	;;; TxtNPntY
							Field07		(vlax-get-property fieldsObj 'Item 7)	;;; TxtNPntZ
							Field08		(vlax-get-property fieldsObj 'Item 8)	;;; TxtJPntX
							Field09		(vlax-get-property fieldsObj 'Item 9)	;;; TxtJPntY
							Field10		(vlax-get-property fieldsObj 'Item 10)	;;; TxtJPntZ
							Field11		(vlax-get-property fieldsObj 'Item 11)	;;; TxtThicK
							Field12		(vlax-get-property fieldsObj 'Item 12)	;;; TxtHgt
							Field13		(vlax-get-property fieldsObj 'Item 13)	;;; TxtRot
							Field14		(vlax-get-property fieldsObj 'Item 14)	;;; TxtSpace
							Field15		(vlax-get-property fieldsObj 'Item 15)	;;; TxtFlag
							Field16		(vlax-get-property fieldsObj 'Item 16)	;;; TxtHorzFlag
							Field17		(vlax-get-property fieldsObj 'Item 17)	;;; TxtVertFlag
							Field18		(vlax-get-property fieldsObj 'Item 18)	;;; Device_ID
							Field19		(vlax-get-property fieldsObj 'Item 19)	;;; Adds_Panel_ID
					)
					(while (and (= (setq aBOF (vlax-get-property RecordSetObject 'BOF)) :vlax-false) (= (setq aEOF (vlax-get-property RecordSetObject 'EOF)) :vlax-false))
						(setq	RecTxtLst	(list	(vlax-variant-value (vlax-get-property Field00 'Value))
												(vlax-variant-value (vlax-get-property Field01 'Value))
												(vlax-variant-value (vlax-get-property Field02 'Value))
												(if (vlax-variant-value (vlax-get-property Field03 'Value)) (vlax-variant-value (vlax-get-property Field03 'Value)) "")
												(vlax-variant-value (vlax-get-property Field04 'Value))
												(atof (vlax-variant-value (vlax-get-property Field05 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field06 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field07 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field08 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field09 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field10 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field11 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field12 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field13 'Value)))
												(atoi (vlax-variant-value (vlax-get-property Field14 'Value)))
												(atoi (vlax-variant-value (vlax-get-property Field15 'Value)))
												(atoi (vlax-variant-value (vlax-get-property Field16 'Value)))
												(atoi (vlax-variant-value (vlax-get-property Field17 'Value)))
												(vlax-variant-value (vlax-get-property Field18 'Value))
												(atoi (vlax-variant-value (vlax-get-property Field19 'Value)))
										)
						)
						(if CurObjTxtLst
							(setq	CurObjTxtLst	(cons RecTxtLst CurObjTxtLst))
							(setq	CurObjTxtLst	(list RecTxtLst))
						)
						(vlax-invoke-method RecordSetObject 'MoveNext)
					)
				)
				(princ (strcat "\nRecord Set NOT Available, Record Set State = " (itoa rsState)))
			)
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateOpen)
				(vlax-invoke-method ConnectionObject "Close")
			)
			(if (and Field00 (null (vlax-object-released-p Field00)))
				(vlax-release-object Field00)
			)
			(if (and Field01 (null (vlax-object-released-p Field01)))
				(vlax-release-object Field01)
			)
			(if (and Field02 (null (vlax-object-released-p Field02)))
				(vlax-release-object Field02)
			)
			(if (and Field03 (null (vlax-object-released-p Field03)))
				(vlax-release-object Field03)
			)
			(if (and Field04 (null (vlax-object-released-p Field04)))
				(vlax-release-object Field04)
			)
			(if (and Field05 (null (vlax-object-released-p Field05)))
				(vlax-release-object Field05)
			)
			(if (and Field06 (null (vlax-object-released-p Field06)))
				(vlax-release-object Field06)
			)
			(if (and Field07 (null (vlax-object-released-p Field07)))
				(vlax-release-object Field07)
			)
			(if (and Field08 (null (vlax-object-released-p Field08)))
				(vlax-release-object Field08)
			)
			(if (and Field09 (null (vlax-object-released-p Field09)))
				(vlax-release-object Field09)
			)
			(if (and Field10 (null (vlax-object-released-p Field10)))
				(vlax-release-object Field10)
			)
			(if (and Field11 (null (vlax-object-released-p Field11)))
				(vlax-release-object Field11)
			)
			(if (and Field12 (null (vlax-object-released-p Field12)))
				(vlax-release-object Field12)
			)
			(if (and Field13 (null (vlax-object-released-p Field13)))
				(vlax-release-object Field13)
			)
			(if (and Field14 (null (vlax-object-released-p Field14)))
				(vlax-release-object Field14)
			)
			(if (and Field15 (null (vlax-object-released-p Field15)))
				(vlax-release-object Field15)
			)
			(if (and Field16 (null (vlax-object-released-p Field16)))
				(vlax-release-object Field16)
			)
			(if (and Field17 (null (vlax-object-released-p Field17)))
				(vlax-release-object Field17)
			)
			(if (and Field18 (null (vlax-object-released-p Field18)))
				(vlax-release-object Field18)
			)
			(if (and Field19 (null (vlax-object-released-p Field19)))
				(vlax-release-object Field19)
			)
			(if (and fieldsObj (null (vlax-object-released-p fieldsObj)))
				(vlax-release-object fieldsObj)
			)
			(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
				(vlax-release-object aCommandObject)
			)
			(if (and RecordSetObject (null (vlax-object-released-p RecordSetObject)))
				(vlax-release-object RecordSetObject)
			)
			(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
				(vlax-release-object ConnectionObject)
			)
			(setq	ConnectionObject	nil
					RecordSetObject	nil
					aCommandObject		nil
					fieldsObj			nil
					Field00			nil
					Field01			nil
					Field02			nil
					Field03			nil
					Field04			nil
					Field05			nil
					Field06			nil
					Field07			nil
					Field08			nil
					Field09			nil
					Field10			nil
					Field11			nil
					Field12			nil
					Field13			nil
					Field14			nil
					Field15			nil
					Field16			nil
					Field17			nil
					Field18			nil
					Field19			nil
			)
		)
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	CurObjTxtLst
)

(defun ADO_GetObj4PL ( OraInst Panel_ID /		;Gets Master Object List for a panel directly from Oracle
						SQLStatement ADO_DLLPath ConnectionObject reccnt
						aCommandObject SuppAddNew rsState fvalue nvalue coState
						Rec4PLLst Field00 Field01 Field02 Field03 CurObj4PLLst
						Field04 Field05 Field06 Field07 Field08 Field09 Field10 Field11
						Field12 Field13
						RecordSetObject aBOF aEOF fieldsObj afield i )
	(if Panel_ID
		(setq	SQLStatement	(strcat	"SELECT Op4.Adds_Layer_Nam,"
									" to_char(Op4.PlWid) as PlWid,"
									" to_char(Op4.PntX1) as PntX1,"
									" to_char(Op4.PntY1) as PntY1,"
									" to_char(Op4.PntX2) as PntX2,"
									" to_char(Op4.PntY2) as PntY2,"
									" to_char(Op4.PntX3) as PntX3,"
									" to_char(Op4.PntY3) as PntY3,"
									" to_char(Op4.PntX4) as PntX4,"
									" to_char(Op4.PntY4) as PntY4,"
									" to_char(Op4.Point_Cnt) as Point_Cnt,"
									" Op4.Device_ID,"
									" to_char(Op4.Adds_Panel_ID) as Adds_Panel_ID,"
									" Op4.SegCnt"
									" FROM addsdb.obj4pntpl Op4"
									" where (Op4.Adds_Panel_ID = "
									(itoa Panel_ID)
									")"
							)
				CurObj4PLLst	nil
		)
		(progn
			(setq	SQLStatement	nil
					CurObj4PLLst	nil
			)
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq ConnectionObject (vlax-create-object "ADODB.Connection"))
			(vlax-put-property ConnectionObject "Provider"  "OraOLEDB.Oracle.1")
			(vlax-put-property ConnectionObject "CommandTimeout" 30)
			(setq coMode (vlax-get-property ConnectionObject 'Mode)) ; = 0
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateClosed)
				(vlax-put-property ConnectionObject 'Mode adok-adModeReadWrite)
			)
			(vlax-invoke-method	ConnectionObject					;;; Use the Oracle OLEDB Drivers
							"Open"
							OraInst
							"GEWILYMS"
							"GEWILYMS"
							adok-adConnectUnspecified
			)
			(setq RecordSetObject (vlax-create-object "ADODB.RecordSet"))
			(vlax-put-property RecordSetObject 'CursorType adok-adOpenDynamic)
			(vlax-put-property RecordSetObject 'LockType   adok-adLockOptimistic)
			(setq aCommandObject (vlax-create-object "ADODB.Command"))
			(vlax-put-property aCommandObject 'ActiveConnection ConnectionObject)
			(vlax-put-property aCommandObject 'CommandText SQLStatement)
			(vlax-put-property aCommandObject 'CommandType adok-adCmdText)
			(setq RecordSetObject (vlax-invoke-method aCommandObject "Execute" nil nil nil))
			(setq SuppAddNew (vlax-invoke-method RecordSetObject 'Supports adok-adAddNew))
			(setq rsState (vlax-get-property RecordSetObject 'State))
			(if (= rsState adok-adStateOpen)
				(progn
					(setq	fieldsObj		(vlax-get-property RecordSetObject 'Fields)
							Field00		(vlax-get-property fieldsObj 'Item 0)	;;; Adds_Layer_Nam
							Field01		(vlax-get-property fieldsObj 'Item 1)	;;; PlWid
							Field02		(vlax-get-property fieldsObj 'Item 2)	;;; PntX1
							Field03		(vlax-get-property fieldsObj 'Item 3)	;;; PntY1
							Field04		(vlax-get-property fieldsObj 'Item 4)	;;; PntX2
							Field05		(vlax-get-property fieldsObj 'Item 5)	;;; PntY2
							Field06		(vlax-get-property fieldsObj 'Item 6)	;;; PntX3
							Field07		(vlax-get-property fieldsObj 'Item 7)	;;; PntY3
							Field08		(vlax-get-property fieldsObj 'Item 8)	;;; PntX4
							Field09		(vlax-get-property fieldsObj 'Item 9)	;;; PntY4
							Field10		(vlax-get-property fieldsObj 'Item 10)	;;; Point_Cnt
							Field11		(vlax-get-property fieldsObj 'Item 11)	;;; Device_ID
							Field12		(vlax-get-property fieldsObj 'Item 12)	;;; Adds_Panel_ID
							Field13		(vlax-get-property fieldsObj 'Item 13)	;;; SegCnt
					)
					(while (and (= (setq aBOF (vlax-get-property RecordSetObject 'BOF)) :vlax-false) (= (setq aEOF (vlax-get-property RecordSetObject 'EOF)) :vlax-false))
						(setq	Rec4PLLst	(list	(vlax-variant-value (vlax-get-property Field00 'Value))
												(atof (vlax-variant-value (vlax-get-property Field01 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field02 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field03 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field04 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field05 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field06 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field07 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field08 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field09 'Value)))
												(atoi (vlax-variant-value (vlax-get-property Field10 'Value)))
												(vlax-variant-value (vlax-get-property Field11 'Value))
												(atoi (vlax-variant-value (vlax-get-property Field12 'Value)))
												(vlax-variant-value (vlax-get-property Field13 'Value))
										)
						)
						(if CurObj4PLLst
							(setq	CurObj4PLLst	(cons Rec4PLLst CurObj4PLLst))
							(setq	CurObj4PLLst	(list Rec4PLLst))
						)
						(vlax-invoke-method RecordSetObject 'MoveNext)
					)
				)
				(princ (strcat "\nRecord Set NOT Available, Record Set State = " (itoa rsState)))
			)
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateOpen)
				(vlax-invoke-method ConnectionObject "Close")
			)
			(if (and Field00 (null (vlax-object-released-p Field00)))
				(vlax-release-object Field00)
			)
			(if (and Field01 (null (vlax-object-released-p Field01)))
				(vlax-release-object Field01)
			)
			(if (and Field02 (null (vlax-object-released-p Field02)))
				(vlax-release-object Field02)
			)
			(if (and Field03 (null (vlax-object-released-p Field03)))
				(vlax-release-object Field03)
			)
			(if (and Field04 (null (vlax-object-released-p Field04)))
				(vlax-release-object Field04)
			)
			(if (and Field05 (null (vlax-object-released-p Field05)))
				(vlax-release-object Field05)
			)
			(if (and Field06 (null (vlax-object-released-p Field06)))
				(vlax-release-object Field06)
			)
			(if (and Field07 (null (vlax-object-released-p Field07)))
				(vlax-release-object Field07)
			)
			(if (and Field08 (null (vlax-object-released-p Field08)))
				(vlax-release-object Field08)
			)
			(if (and Field09 (null (vlax-object-released-p Field09)))
				(vlax-release-object Field09)
			)
			(if (and Field10 (null (vlax-object-released-p Field10)))
				(vlax-release-object Field10)
			)
			(if (and Field11 (null (vlax-object-released-p Field11)))
				(vlax-release-object Field11)
			)
			(if (and Field12 (null (vlax-object-released-p Field12)))
				(vlax-release-object Field12)
			)
			(if (and Field13 (null (vlax-object-released-p Field13)))
				(vlax-release-object Field13)
			)
			(if (and fieldsObj (null (vlax-object-released-p fieldsObj)))
				(vlax-release-object fieldsObj)
			)
			(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
				(vlax-release-object aCommandObject)
			)
			(if (and RecordSetObject (null (vlax-object-released-p RecordSetObject)))
				(vlax-release-object RecordSetObject)
			)
			(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
				(vlax-release-object ConnectionObject)
			)
			(setq	ConnectionObject	nil
					RecordSetObject	nil
					aCommandObject		nil
					fieldsObj			nil
					Field00			nil
					Field01			nil
					Field02			nil
					Field03			nil
					Field04			nil
					Field05			nil
					Field06			nil
					Field07			nil
					Field08			nil
					Field09			nil
					Field10			nil
					Field11			nil
					Field12			nil
					Field13			nil
			)
		)
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	CurObj4PLLst
)

(defun ADO_GetObj_PL ( OraInst Panel_ID /		;Gets Master Object List for a panel directly from Oracle
						SQLStatement ADO_DLLPath ConnectionObject reccnt
						aCommandObject SuppAddNew rsState fvalue nvalue coState
						RecPL_Lst Field00 Field01 Field02 Field03 CurObjPL_Lst
						Field04 Field05 Field06 Field07 Field08 Field09 Field10 Field11
						Field12 Field13 Field14 Field15
						RecordSetObject aBOF aEOF fieldsObj afield i )
	(if Panel_ID
		(setq	SQLStatement	(strcat	"SELECT OPL.PlDataType,"
									" OPL.PlHandle,"
									" OPL.Adds_Layer_Nam,"
									" to_char(OPL.PlThick) as PlThick,"
									" to_char(OPL.PlWidBegin) as PlWidBegin,"
									" to_char(OPL.PlWidEnd) as PlWidEnd,"
									" to_char(OPL.PlAttFlw) as PlAttFlw,"
									" to_char(OPL.PlSpace) as PlSpace,"
									" to_char(OPL.PlFlag) as PlFlag,"
									" to_char(OPL.PlPolyMshM) as PlPolyMshM,"
									" to_char(OPL.PlPolyMshN) as PlPolyMshN,"
									" to_char(OPL.PlPolysMthM) as PlPolysMthM,"
									" to_char(OPL.PlPolysMthN) as PlPolysMthN,"
									" to_char(OPL.PlCrvSmtTyp) as PlCrvSmtTyp,"
									" OPL.Device_ID,"
									" to_char(OPL.Adds_Panel_ID) as Adds_Panel_ID"
									" FROM addsdb.objpl OPL"
									" where (OPL.Adds_Panel_ID = "
									(itoa Panel_ID)
									")"
							)
				CurObjPL_Lst	nil
		)
		(progn
			(setq	SQLStatement	nil
					CurObjPL_Lst	nil
			)
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq ConnectionObject (vlax-create-object "ADODB.Connection"))
			(vlax-put-property ConnectionObject "Provider"  "OraOLEDB.Oracle.1")
			(vlax-put-property ConnectionObject "CommandTimeout" 30)
			(setq coMode (vlax-get-property ConnectionObject 'Mode)) ; = 0
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateClosed)
				(vlax-put-property ConnectionObject 'Mode adok-adModeReadWrite)
			)
			(vlax-invoke-method	ConnectionObject					;;; Use the Oracle OLEDB Drivers
							"Open"
							OraInst
							"GEWILYMS"
							"GEWILYMS"
							adok-adConnectUnspecified
			)
			(setq RecordSetObject (vlax-create-object "ADODB.RecordSet"))
			(vlax-put-property RecordSetObject 'CursorType adok-adOpenDynamic)
			(vlax-put-property RecordSetObject 'LockType   adok-adLockOptimistic)
			(setq aCommandObject (vlax-create-object "ADODB.Command"))
			(vlax-put-property aCommandObject 'ActiveConnection ConnectionObject)
			(vlax-put-property aCommandObject 'CommandText SQLStatement)
			(vlax-put-property aCommandObject 'CommandType adok-adCmdText)
			(setq RecordSetObject (vlax-invoke-method aCommandObject "Execute" nil nil nil))
			(setq SuppAddNew (vlax-invoke-method RecordSetObject 'Supports adok-adAddNew))
			(setq rsState (vlax-get-property RecordSetObject 'State))
			(if (= rsState adok-adStateOpen)
				(progn
					(setq	fieldsObj		(vlax-get-property RecordSetObject 'Fields)
							Field00		(vlax-get-property fieldsObj 'Item 0)	;;; PlDataType
							Field01		(vlax-get-property fieldsObj 'Item 1)	;;; PlHandle
							Field02		(vlax-get-property fieldsObj 'Item 2)	;;; Adds_Layer_Nam
							Field03		(vlax-get-property fieldsObj 'Item 3)	;;; PlThick
							Field04		(vlax-get-property fieldsObj 'Item 4)	;;; PlWidBegin
							Field05		(vlax-get-property fieldsObj 'Item 5)	;;; PlWidEnd
							Field06		(vlax-get-property fieldsObj 'Item 6)	;;; PlAttFlw
							Field07		(vlax-get-property fieldsObj 'Item 7)	;;; PlSpace
							Field08		(vlax-get-property fieldsObj 'Item 8)	;;; PlFlag
							Field09		(vlax-get-property fieldsObj 'Item 9)	;;; PlPolyMshM
							Field10		(vlax-get-property fieldsObj 'Item 10)	;;; PlPolyMshN
							Field11		(vlax-get-property fieldsObj 'Item 11)	;;; PlPolysMthM
							Field12		(vlax-get-property fieldsObj 'Item 12)	;;; PlPolysMthN
							Field13		(vlax-get-property fieldsObj 'Item 13)	;;; PlCrvSmtTyp
							Field14		(vlax-get-property fieldsObj 'Item 14)	;;; Device_ID
							Field15		(vlax-get-property fieldsObj 'Item 15)	;;; Adds_Panel_ID
					)
					(while (and (= (setq aBOF (vlax-get-property RecordSetObject 'BOF)) :vlax-false) (= (setq aEOF (vlax-get-property RecordSetObject 'EOF)) :vlax-false))
						(setq	RecPL_Lst	(list	(vlax-variant-value (vlax-get-property Field00 'Value))
												(vlax-variant-value (vlax-get-property Field01 'Value))
												(vlax-variant-value (vlax-get-property Field02 'Value))
												(atof (vlax-variant-value (vlax-get-property Field03 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field04 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field05 'Value)))
												(atoi (vlax-variant-value (vlax-get-property Field06 'Value)))
												(atoi (vlax-variant-value (vlax-get-property Field07 'Value)))
												(atoi (vlax-variant-value (vlax-get-property Field08 'Value)))
												(atoi (vlax-variant-value (vlax-get-property Field09 'Value)))
												(atoi (vlax-variant-value (vlax-get-property Field10 'Value)))
												(atoi (vlax-variant-value (vlax-get-property Field11 'Value)))
												(atoi (vlax-variant-value (vlax-get-property Field12 'Value)))
												(atoi (vlax-variant-value (vlax-get-property Field13 'Value)))
												(vlax-variant-value (vlax-get-property Field14 'Value))
												(atoi (vlax-variant-value (vlax-get-property Field15 'Value)))
										)
						)
						(if CurObjPL_Lst
							(setq	CurObjPL_Lst	(cons RecPL_Lst CurObjPL_Lst))
							(setq	CurObjPL_Lst	(list RecPL_Lst))
						)
						(vlax-invoke-method RecordSetObject 'MoveNext)
					)
				)
				(princ (strcat "\nRecord Set NOT Available, Record Set State = " (itoa rsState)))
			)
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateOpen)
				(vlax-invoke-method ConnectionObject "Close")
			)
			(if (and Field00 (null (vlax-object-released-p Field00)))
				(vlax-release-object Field00)
			)
			(if (and Field01 (null (vlax-object-released-p Field01)))
				(vlax-release-object Field01)
			)
			(if (and Field02 (null (vlax-object-released-p Field02)))
				(vlax-release-object Field02)
			)
			(if (and Field03 (null (vlax-object-released-p Field03)))
				(vlax-release-object Field03)
			)
			(if (and Field04 (null (vlax-object-released-p Field04)))
				(vlax-release-object Field04)
			)
			(if (and Field05 (null (vlax-object-released-p Field05)))
				(vlax-release-object Field05)
			)
			(if (and Field06 (null (vlax-object-released-p Field06)))
				(vlax-release-object Field06)
			)
			(if (and Field07 (null (vlax-object-released-p Field07)))
				(vlax-release-object Field07)
			)
			(if (and Field08 (null (vlax-object-released-p Field08)))
				(vlax-release-object Field08)
			)
			(if (and Field09 (null (vlax-object-released-p Field09)))
				(vlax-release-object Field09)
			)
			(if (and Field10 (null (vlax-object-released-p Field10)))
				(vlax-release-object Field10)
			)
			(if (and Field11 (null (vlax-object-released-p Field11)))
				(vlax-release-object Field11)
			)
			(if (and Field12 (null (vlax-object-released-p Field12)))
				(vlax-release-object Field12)
			)
			(if (and Field13 (null (vlax-object-released-p Field13)))
				(vlax-release-object Field13)
			)
			(if (and Field14 (null (vlax-object-released-p Field14)))
				(vlax-release-object Field14)
			)
			(if (and Field15 (null (vlax-object-released-p Field15)))
				(vlax-release-object Field15)
			)
			(if (and fieldsObj (null (vlax-object-released-p fieldsObj)))
				(vlax-release-object fieldsObj)
			)
			(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
				(vlax-release-object aCommandObject)
			)
			(if (and RecordSetObject (null (vlax-object-released-p RecordSetObject)))
				(vlax-release-object RecordSetObject)
			)
			(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
				(vlax-release-object ConnectionObject)
			)
			(setq	ConnectionObject	nil
					RecordSetObject	nil
					aCommandObject		nil
					fieldsObj			nil
					Field00			nil
					Field01			nil
					Field02			nil
					Field03			nil
					Field04			nil
					Field05			nil
					Field06			nil
					Field07			nil
					Field08			nil
					Field09			nil
					Field10			nil
					Field11			nil
					Field12			nil
					Field13			nil
					Field14			nil
					Field15			nil
			)
		)
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	CurObjPL_Lst
)

(defun ADO_GetObjVrt ( OraInst Panel_ID /		;Gets Master Object List for a panel directly from Oracle
		  				SQLStatement ADO_DLLPath ConnectionObject reccnt
						aCommandObject SuppAddNew rsState fvalue nvalue coState
						RecVrtLst Field00 Field01 Field02 Field03 CurObjVrtLst
						Field04 Field05 Field06 Field07 Field08 Field09 Field10 Field11
						Field12
						RecordSetObject aBOF aEOF fieldsObj afield i )
	(if Panel_ID
		(setq	SQLStatement	(strcat	"SELECT Ovt.VrtCnt,"
									" Ovt.VrtDataType,"
									" Ovt.VrtHandle,"
									" Ovt.AddS_Layer_Nam,"
									" to_char(Ovt.VrtPntX) as VrtPntX,"
									" to_char(Ovt.VrtPntY) as VrtPntY,"
									" to_char(Ovt.VrtPntZ) as VrtPntZ,"
									" to_char(Ovt.VrtWidBegin) as VrtWidBegin,"
									" to_char(Ovt.VrtWidEnd) as VrtWidEnd,"
									" to_char(Ovt.VrtBulge) as VrtBulge,"
									" to_char(Ovt.VrtTan) as VrtTan,"
									" to_char(Ovt.VrtFlag) as VrtFlag,"
									" Ovt.Device_ID"
									" FROM addsdb.objvrt Ovt"
									" where (Ovt.device_id in (select OPL.device_id from addsdb.objpl OPL"
									" where OPL.adds_panel_id = "
									(itoa Panel_ID)
									"))"
							)
				CurObjVrtLst	nil
		)
		(progn
			(setq	SQLStatement	nil
					CurObjVrtLst	nil
			)
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq ConnectionObject (vlax-create-object "ADODB.Connection"))
			(vlax-put-property ConnectionObject "Provider"  "OraOLEDB.Oracle.1")
			(vlax-put-property ConnectionObject "CommandTimeout" 30)
			(setq coMode (vlax-get-property ConnectionObject 'Mode)) ; = 0
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateClosed)
				(vlax-put-property ConnectionObject 'Mode adok-adModeReadWrite)
			)
			(vlax-invoke-method	ConnectionObject					;;; Use the Oracle OLEDB Drivers
							"Open"
							OraInst
							"GEWILYMS"
							"GEWILYMS"
							adok-adConnectUnspecified
			)
			(setq RecordSetObject (vlax-create-object "ADODB.RecordSet"))
			(vlax-put-property RecordSetObject 'CursorType adok-adOpenDynamic)
			(vlax-put-property RecordSetObject 'LockType   adok-adLockOptimistic)
			(setq aCommandObject (vlax-create-object "ADODB.Command"))
			(vlax-put-property aCommandObject 'ActiveConnection ConnectionObject)
			(vlax-put-property aCommandObject 'CommandText SQLStatement)
			(vlax-put-property aCommandObject 'CommandType adok-adCmdText)
			(setq RecordSetObject (vlax-invoke-method aCommandObject "Execute" nil nil nil))
			(setq SuppAddNew (vlax-invoke-method RecordSetObject 'Supports adok-adAddNew))
			(setq rsState (vlax-get-property RecordSetObject 'State))
			(if (= rsState adok-adStateOpen)
				(progn
					(setq	fieldsObj		(vlax-get-property RecordSetObject 'Fields)
							Field00		(vlax-get-property fieldsObj 'Item 0)	;;; VrtCnt
							Field01		(vlax-get-property fieldsObj 'Item 1)	;;; VrtDataType
							Field02		(vlax-get-property fieldsObj 'Item 2)	;;; VrtHandle
							Field03		(vlax-get-property fieldsObj 'Item 3)	;;; AddS_Layer_Nam
							Field04		(vlax-get-property fieldsObj 'Item 4)	;;; VrtPntX
							Field05		(vlax-get-property fieldsObj 'Item 5)	;;; VrtPntY
							Field06		(vlax-get-property fieldsObj 'Item 6)	;;; VrtPntZ
							Field07		(vlax-get-property fieldsObj 'Item 7)	;;; VrtWidBegin
							Field08		(vlax-get-property fieldsObj 'Item 8)	;;; VrtWidEnd
							Field09		(vlax-get-property fieldsObj 'Item 9)	;;; VrtBulge
							Field10		(vlax-get-property fieldsObj 'Item 10)	;;; VrtTan
							Field11		(vlax-get-property fieldsObj 'Item 11)	;;; VrtFlag
							Field12		(vlax-get-property fieldsObj 'Item 12)	;;; Device_ID
					)
					(while (and (= (setq aBOF (vlax-get-property RecordSetObject 'BOF)) :vlax-false) (= (setq aEOF (vlax-get-property RecordSetObject 'EOF)) :vlax-false))
						(setq	RecVrtLst	(list	(vlax-variant-value (vlax-get-property Field00 'Value))
												(vlax-variant-value (vlax-get-property Field01 'Value))
												(vlax-variant-value (vlax-get-property Field02 'Value))
												(vlax-variant-value (vlax-get-property Field03 'Value))
												(atof (vlax-variant-value (vlax-get-property Field04 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field05 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field06 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field07 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field08 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field09 'Value)))
												(atof (vlax-variant-value (vlax-get-property Field10 'Value)))
												(atoi (vlax-variant-value (vlax-get-property Field11 'Value)))
												(vlax-variant-value (vlax-get-property Field12 'Value))
										)
						)
						(if CurObjVrtLst
							(setq	CurObjVrtLst	(cons RecVrtLst CurObjVrtLst))
							(setq	CurObjVrtLst	(list RecVrtLst))
						)
						(vlax-invoke-method RecordSetObject 'MoveNext)
					)
				)
				(princ (strcat "\nRecord Set NOT Available, Record Set State = " (itoa rsState)))
			)
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateOpen)
				(vlax-invoke-method ConnectionObject "Close")
			)
			(if (and Field00 (null (vlax-object-released-p Field00)))
				(vlax-release-object Field00)
			)
			(if (and Field01 (null (vlax-object-released-p Field01)))
				(vlax-release-object Field01)
			)
			(if (and Field02 (null (vlax-object-released-p Field02)))
				(vlax-release-object Field02)
			)
			(if (and Field03 (null (vlax-object-released-p Field03)))
				(vlax-release-object Field03)
			)
			(if (and Field04 (null (vlax-object-released-p Field04)))
				(vlax-release-object Field04)
			)
			(if (and Field05 (null (vlax-object-released-p Field05)))
				(vlax-release-object Field05)
			)
			(if (and Field06 (null (vlax-object-released-p Field06)))
				(vlax-release-object Field06)
			)
			(if (and Field07 (null (vlax-object-released-p Field07)))
				(vlax-release-object Field07)
			)
			(if (and Field08 (null (vlax-object-released-p Field08)))
				(vlax-release-object Field08)
			)
			(if (and Field09 (null (vlax-object-released-p Field09)))
				(vlax-release-object Field09)
			)
			(if (and Field10 (null (vlax-object-released-p Field10)))
				(vlax-release-object Field10)
			)
			(if (and Field11 (null (vlax-object-released-p Field11)))
				(vlax-release-object Field11)
			)
			(if (and Field12 (null (vlax-object-released-p Field12)))
				(vlax-release-object Field12)
			)
			(if (and fieldsObj (null (vlax-object-released-p fieldsObj)))
				(vlax-release-object fieldsObj)
			)
			(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
				(vlax-release-object aCommandObject)
			)
			(if (and RecordSetObject (null (vlax-object-released-p RecordSetObject)))
				(vlax-release-object RecordSetObject)
			)
			(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
				(vlax-release-object ConnectionObject)
			)
			(setq	ConnectionObject	nil
					RecordSetObject	nil
					aCommandObject		nil
					fieldsObj			nil
					Field00			nil
					Field01			nil
					Field02			nil
					Field03			nil
					Field04			nil
					Field05			nil
					Field06			nil
					Field07			nil
					Field08			nil
					Field09			nil
					Field10			nil
					Field11			nil
					Field12			nil
			)
		)
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	CurObjVrtLst
)

(defun ADO_GetNextNumR ( OraInst /			;Gets Next Unique_ID directly from Oracle Sequence
						SQLStatement ADO_DLLPath ConnectionObject
						aCommandObject SuppAddNew rsState
						recno RecordSetObject aBOF aEOF fieldsObj reccnt afield i fvalue coState)
	;;; Setup a SQL statement ->

	(setq	SQLStatement	"select to_char(addsdb.Get_Next_ID()) as myNextNum from dual")

	;;; Normal path to the ADO DLL, change as needed:
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")

	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)

	;;; Proceed if Type Library has been loaded.
	(if adom-Append
		(progn	;;; Create A Connection Object
			(setq ConnectionObject (vlax-create-object "ADODB.Connection"))
			(vlax-put-property ConnectionObject "Provider"  "OraOLEDB.Oracle.1")
			(vlax-put-property ConnectionObject "CommandTimeout" 30)
			;;; Check the mode of the Connection Object
			(setq coMode (vlax-get-property ConnectionObject 'Mode)) ; = 0
			;;; Valid Mode values are:
			;;;  adok-adModeUnknown = 0
			;;;  adok-adModeRead = 1
			;;;  adok-adModeWrite = 2
			;;;  adok-adModeReadWrite = 3
			;;;  adok-adModeShareDenyRead = 4
			;;;  adok-adModeShareDenyWrite = 8
			;;;  adok-adModeShareExclusive = 12
			;;;  adok-adModeShareDenyNone = 16

			(setq coState (vlax-get-property ConnectionObject 'State))

			(if (= coState adok-adStateClosed)
				(vlax-put-property ConnectionObject 'Mode adok-adModeReadWrite)
			)
 
			;;; Use the Oracle OLEDB Drivers
			(vlax-invoke-method
				ConnectionObject
				"Open"
				OraInst
				"GEWILYMS"
				"GEWILYMS"
				adok-adConnectUnspecified
			)

			;;; Create the RecordSet Object
			(setq RecordSetObject (vlax-create-object "ADODB.RecordSet"))

			;;; Set the CursorType, and Locking Type
			(vlax-put-property RecordSetObject 'CursorType adok-adOpenDynamic)
			;;; Where the property values are:
     
			;;;	adok-adOpenForwardOnly = 0
			;;;	adok-adOpenKeyset = 1
			;;;	adok-adOpenDynamic = 2
			;;;	adok-adOpenStatic = 3

			(vlax-put-property RecordSetObject 'LockType   adok-adLockOptimistic)
			;;; Where the property values are:

			;;;  adok-adLockReadOnly = 1
			;;;  adok-adLockPessimistic = 2
			;;;  adok-adLockOptimistic = 3
			;;;  adok-adLockBatchOptimistic = 4

			;;; The following code will not work, do not use it.
			;(setq RecordSetObject
			;;; The following fails with a "Type mismatch" error
			;	  (vlax-invoke-method
			;	    ConnectionObject "Execute" SQLStatement 'RecordsAffected
			;	    adok-adCmdText
			;	   )
			;  )

			;;; Create a Command Object and Connect it to the Connection Object
			(setq aCommandObject (vlax-create-object "ADODB.Command"))
			(vlax-put-property aCommandObject 'ActiveConnection ConnectionObject)

			;;; Setup the Command Object, and Execute the SQL query
			(vlax-put-property aCommandObject 'CommandText SQLStatement)
			(vlax-put-property aCommandObject 'CommandType adok-adCmdText)
			;;; adok-adCmdText = 1
			;;; adok-adCmdTable = 2
			;;; adok-adCmdTableDirect = 512
			;;; adok-adCmdStoredProc = 4
			;;; adok-adCmdUnknown = 8
			;;; adok-adCommandFile = nil
			;;; adok-adExecuteNoRecords = 182
 
			(setq RecordSetObject (vlax-invoke-method aCommandObject "Execute" nil nil nil))
			(setq SuppAddNew (vlax-invoke-method RecordSetObject 'Supports adok-adAddNew))

			;;; Check to see that the RecordSet is available here ->
			(setq rsState (vlax-get-property RecordSetObject 'State))
			;;;   adok-adStateClosed = 0
			;;;   adok-adStateOpen = 1
			;;;   adok-adStateConnecting = 2
			;;;   adok-adStateExecuting = 4
			;;;   adok-adStateFetching = 8
 
			(if (= rsState adok-adStateOpen)
				(progn
					(setq recno 0)
					(while (and (= (setq aBOF (vlax-get-property RecordSetObject 'BOF)) :vlax-false) (= (setq aEOF (vlax-get-property RecordSetObject 'EOF)) :vlax-false))
						(setq	fieldsObj	(vlax-get-property RecordSetObject 'Fields))
						(setq	reccnt	(vlax-get-property fieldsObj 'Count)
								i		0
						)
						(princ (strcat "\nRecord " (itoa recno) ":\n"))
						(while (< i reccnt)
							(setq	afield	(vlax-get-property fieldsObj 'Item i))
							(setq	fvalue	(vlax-variant-value (vlax-get-property afield 'Value)))
							(setq	i	(1+ i))
						)
						(princ "\n")
						(setq	recno	(1+ recno))
						(vlax-invoke-method RecordSetObject 'MoveNext)
					)
				)
				(princ (strcat "\nRecord Set NOT Available, Record Set State = " (itoa rsState)))
			)

			;;; Close only works if it's Opened !, this can usually be tested by checking if a LDB file exists.
			;;; Check to see that the Connection Object is open here ->
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateOpen)
				(vlax-invoke-method ConnectionObject "Close")
			)
			(if (and aField (null (vlax-object-released-p aField)))
				(vlax-release-object aField)
			)
			(if (and fieldsObj (null (vlax-object-released-p fieldsObj)))
				(vlax-release-object fieldsObj)
			)
			(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
				(vlax-release-object aCommandObject)
			)
			(if (and RecordSetObject (null (vlax-object-released-p RecordSetObject)))
				(vlax-release-object RecordSetObject)
			)
			(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
				(vlax-release-object ConnectionObject)
			)
			(setq	ConnectionObject	nil
					RecordSetObject	nil
					aCommandObject		nil
					fieldsObj			nil
					aField			nil
			)
		)
		;;; Exit if Type Library has NOT been loaded.
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(princ)
	(if fvalue (atoi fvalue) nil)
)

(defun TimLap ( isecs /	ints outs osecs elss )	; Timer function
	(if isecs
		(setq	outs		(getvar "date")
				osecs	(* 86400.0 (- outs (fix outs)))
				elss		(fix (- (* osecs 1000.0) (* isecs 1000.0)))
				Bubba	(princ (strcat "\nElapsed Milliseconds = " (itoa elss)))
				elap		(fix (- (* osecs 1000.0) (* isecs 1000.0)))
		)
		(setq	ints		(getvar "date")
				isecs	(* 86400.0 (- ints (fix ints)))
		)
	)
)

(defun ADO_GetNextNum ( OraInst /				;Puts Master Object List for a panel directly into Oracle
						SQLStatement ADO_DLLPath ConnectionObject coState coMode
						aCommandObject aParameterObject afield dvalue fvalue
						SQLStatement RecMstLst RecCnt )
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(vlisp-import-symbol 'Bug)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq ConnectionObject (vlax-create-object "ADODB.Connection"))
			(vlax-put-property ConnectionObject "Provider"  "OraOLEDB.Oracle.1")
			(vlax-put-property ConnectionObject "CommandTimeout" 30)
			(setq coMode (vlax-get-property ConnectionObject 'Mode))
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateClosed)
				(vlax-put-property ConnectionObject 'Mode adok-adModeReadWrite)
			)
			(vlax-invoke-method	ConnectionObject					;;; Use the Oracle OLEDB Drivers
							"Open"
							OraInst
							"GEWILYMS"
							"GEWILYMS"
							adok-adConnectUnspecified
			)
			(setq	aCommandObject	(vlax-create-object "ADODB.Command")
					ErrCnt		0
					ErrFnd		nil
			)
			(vlax-put-property aCommandObject 'ActiveConnection ConnectionObject)
			(vlax-put-property aCommandObject 'CommandText "AddsDb.Get_NextNum")
			(vlax-put-property aCommandObject 'CommandType adok-adCmdStoredProc)
			(setq aParameterObject (vlax-get-property aCommandObject 'Parameters.Refresh))
	  		(setq	ErrObj	(vlax-get-property ConnectionObject 'Errors))
			;;;***************** Device_ID *****************
			(setq	afield	(vlax-get-property aParameterObject 'Item 0))
			(vlax-put-property afield 'Size 25)
			(vlax-put-property afield 'Type adok-adVarChar)
			(vlax-put-property afield 'Direction adok-adParamInput)
			(if Bug	(setq	dvalue		(cons	(vlax-get-property afield 'Name)
												"DP_BHM_153000"
										)
							SQLStatement	(list dvalue)
					)
			)
		  	(vlax-put-property afield 'Value "DP_BHM_153000")
			;;;***************** Ret_NextNum_Good *****************
			(setq	afield	(vlax-get-property aParameterObject 'Item 1))
			(vlax-put-property afield 'Size 25)
			(vlax-put-property afield 'Type adok-adVarChar)
			(vlax-put-property afield 'Direction adok-adParamReturnValue)
			(if Bug	(setq	dvalue		(cons	(vlax-get-property afield 'Name)
												"Prepared"
										)
							SQLStatement	(cons dvalue SQLStatement)
					)
			)
			;;;***************** Execute *****************
			(vlax-invoke-method aCommandObject "Execute" nil nil nil)
	  		(setq	ErrCnt	(vlax-get-property ErrObj 'Count))
	  		(if (> ErrCnt 0)
				(setq	Bubba	"\nClearing ConnectionObject Errors..."
						ErrItm	(vlax-get-property ErrObj 'Item 0)
						Bubba	(vlax-invoke-method ErrObj 'Clear)
				)
			)
			(setq	afield	(vlax-get-property aParameterObject 'Item 1))
		  	(setq	fvalue	(vlax-variant-value (vlax-get-property afield 'Value)))
	  		(setq	fvalue	(StpDot fvalue))
			(if Bug	(setq	dvalue		(cons	(vlax-get-property afield 'Name)
												(if fvalue fvalue "Empty")
										)
							SQLStatement	(cons dvalue SQLStatement)
					)
			)
			(if Bug (princ (strcat "\nValues-Row(" (itoa 1) ")\n**********************************")))
			(if Bug (mapcar (quote (lambda (x) (princ (strcat "\nField {" (car x) "} Value {" (cdr x) "}")))) SQLStatement))
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateOpen)
				(vlax-invoke-method ConnectionObject "Close")
			)
			(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
				(vlax-release-object aCommandObject)
			)
			(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
				(vlax-release-object ConnectionObject)
			)
			(setq	ConnectionObject	nil
					aCommandObject		nil
					afield			nil
			)
		)
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	fvalue
)

(defun ADO_DelObjMst_Old ( ObjAccountant OraInst /	;Puts Master Object List for a panel directly into Oracle
						SQLStatement ADO_DLLPath ConnectionObject coState coMode
						aCommandObject aParameterObject afield dvalue fvalue
						SQLStatement RecMstLst RecCnt )
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(vlisp-import-symbol 'Bug)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq ConnectionObject (vlax-create-object "ADODB.Connection"))
			(vlax-put-property ConnectionObject "Provider"  "OraOLEDB.Oracle.1")
			(vlax-put-property ConnectionObject "CommandTimeout" 30)
			(setq coMode (vlax-get-property ConnectionObject 'Mode))
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateClosed)
				(vlax-put-property ConnectionObject 'Mode adok-adModeReadWrite)
			)
			(vlax-invoke-method	ConnectionObject					;;; Use the Oracle OLEDB Drivers
							"Open"
							OraInst
							"GEWILYMS"
							"GEWILYMS"
							adok-adConnectUnspecified
			)
			(setq	aCommandObject	(vlax-create-object "ADODB.Command")
					RecCnt		0
					ErrCnt		0
					ErrFnd		nil
			)
			(vlax-put-property aCommandObject 'ActiveConnection ConnectionObject)
			(vlax-put-property aCommandObject 'CommandText "AddsDb.Del_MstObj")
			(vlax-put-property aCommandObject 'CommandType adok-adCmdStoredProc)
		  	(vlax-put-property aCommandObject 'Prepared 1)
			(setq aParameterObject (vlax-get-property aCommandObject 'Parameters.Refresh))
	  		(setq	ErrObj	(vlax-get-property ConnectionObject 'Errors))
			;;;***************** Device_ID *****************
			(setq	afield	(vlax-get-property aParameterObject 'Item 0))
			(vlax-put-property afield 'Size 25)
			(vlax-put-property afield 'Type adok-adVarChar)
			(vlax-put-property afield 'Direction adok-adParamInput)
			;;;***************** InUserID *****************
			(setq	afield	(vlax-get-property aParameterObject 'Item 1))
			(vlax-put-property afield 'Size 8)
			(vlax-put-property afield 'Type adok-adVarChar)
			(vlax-put-property afield 'Direction adok-adParamInput)
			;;;***************** Ret_DelObj_Good *****************
			(setq	afield	(vlax-get-property aParameterObject 'Item 2))
			(vlax-put-property afield 'Size 25)
			(vlax-put-property afield 'Type adok-adVarChar)
			(vlax-put-property afield 'Direction adok-adParamReturnValue)
			(setq	Bubba	(vlax-invoke-method	ConnectionObject 'BeginTrans))
			(foreach	UniqID
					ObjAccountant
					(if (= (Mod RecCnt 100) 0)
						(if (> RecCnt 0)
							(setq	Bubba	(vlax-invoke-method	ConnectionObject 'CommitTrans)
									Bubba	(vlax-invoke-method	ConnectionObject 'BeginTrans)
							)
						)
					)
					;;;***************** Device_ID *****************
					(setq	afield	(vlax-get-property aParameterObject 'Item 0))
					(if Bug	(setq	dvalue		(cons	(vlax-get-property afield 'Name)
														UniqID
												)
									SQLStatement	(list dvalue)
							)
					)
				  	(vlax-put-property afield 'Value UniqID)
					;;;***************** InUserID *****************
					(setq	afield	(vlax-get-property aParameterObject 'Item 1))
					(if Bug	(setq	dvalue		(cons	(vlax-get-property afield 'Name)
														(strcase (getvar "LOGINNAME"))
												)
									SQLStatement	(cons dvalue SQLStatement)
							)
					)
				  	(vlax-put-property afield 'Value (strcase (getvar "LOGINNAME")))
					;;;***************** Ret_DelObj_Good *****************
					(setq	afield	(vlax-get-property aParameterObject 'Item 2))
					(if Bug	(setq	dvalue		(cons	(vlax-get-property afield 'Name)
														"Prepared"
												)
									SQLStatement	(cons dvalue SQLStatement)
							)
					)
					;;;***************** Execute *****************
					(vlax-invoke-method aCommandObject "Execute" nil nil nil)
			  		(setq	ErrCnt	(vlax-get-property ErrObj 'Count))
			  		(if (> ErrCnt 0)
						(setq	Bubba	"\nClearing ConnectionObject Errors..."
								ErrItm	(vlax-get-property ErrObj 'Item 0)
								Bubba	(vlax-invoke-method ErrObj 'Clear)
						)
					)
					(setq	afield	(vlax-get-property aParameterObject 'Item 2))
				  	(setq	fvalue	(vlax-variant-value (vlax-get-property afield 'Value)))
					(if Bug	(setq	dvalue		(cons	(vlax-get-property afield 'Name)
														(if fvalue fvalue "Empty")
												)
									SQLStatement	(cons dvalue SQLStatement)
							)
					)
					(setq	RecCnt	(1+ RecCnt))
			  		(if (= (substr fvalue 1 5) "FALSE")
						(if (not ErrFnd)
							(setq	ErrFnd	T)
						)
					)
			  		(if (= (substr fvalue 1 5) "FALSE")
						(princ	(strcat	"\nError Deleting RecCnt {" (itoa RecCnt) "} Device {" UniqID
										"} InUserID {" (strcase (getvar "LOGINNAME"))
										"}"
								)
						)
					)
					(if Bug (princ (strcat "\nValues-Row(" (itoa RecCnt) ")\n**********************************")))
					(if Bug (mapcar (quote (lambda (x) (princ (strcat "\nField {" (car x) "} Value {" (cdr x) "}")))) SQLStatement))
			)
			(setq	Bubba	(vlax-invoke-method	ConnectionObject 'CommitTrans))
			(setq coState (vlax-get-property ConnectionObject 'State))
			(if (= coState adok-adStateOpen)
				(vlax-invoke-method ConnectionObject "Close")
			)
			(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
				(vlax-release-object aCommandObject)
			)
			(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
				(vlax-release-object ConnectionObject)
			)
			(setq	ConnectionObject	nil
					aCommandObject		nil
					afield			nil
			)
		)
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(if ErrFnd
		-1
		RecCnt
	)
)

(defun ADO_DelObjMst ( ObjAccountant OraInst /	;Puts Master Object List for a panel directly into Oracle
					SQLStatement ADO_DLLPath ConnectionObject coState coMode
					aCommandObject aParameterObject afield dvalue fvalue
					SQLStatement RecMstLst RecCnt ValueCnt ValueItm ValueLst ParamLst Bubba )
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(vlisp-import-symbol 'Bug)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq	RecCnt		0
					ErrCnt		0
					ErrFnd		nil
					User_ID		(strcase (getvar "LOGINNAME"))
			)
			(foreach	UniqID
					ObjAccountant
					(setq	ParamLst			(list
												(list 25 adok-adVarChar adok-adParamInput)
												(list 8 adok-adVarChar adok-adParamInput)
												(list 25 adok-adVarChar adok-adParamReturnValue)
											)
							ValueLst			(list	UniqID
													User_ID
											)
							ColumLst			(list	"} Device {"
													"} User_ID {"
											)
							ModNam			"ADO_DelObjMst"
							Bubba			(ADO_Mak_CmdObj	(list	OraInst
																	"AddsDb.Del_MstObj"
																	ParamLst
															)
											)
							ConnectionObject	(if Bubba (nth 0 Bubba) nil)
							aCommandObject		(if Bubba (nth 1 Bubba) nil)
							aParameterObject	(if Bubba (nth 2 Bubba) nil)
							ValueCnt	0
					)
					(vlax-invoke-method	ConnectionObject 'BeginTrans)
					(foreach	ValueItm
							ValueLst
							(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
							(vlax-put-property afield 'Value (nth ValueCnt ValueLst))
							(setq	ValueCnt	(1+ ValueCnt))
					)
					;;;***************** Execute *****************
					(vlax-invoke-method aCommandObject "Execute" nil nil nil)
					(setq	ErrObj	(vlax-get-property ConnectionObject 'Errors))
			  		(setq	ErrCnt	(vlax-get-property ErrObj 'Count))
			  		(if (> ErrCnt 0)
						(setq	Bubba	"\nClearing ConnectionObject Errors..."
								ErrItm	(vlax-get-property ErrObj 'Item 0)
								Bubba	(vlax-invoke-method ErrObj 'Clear)
						)
					)
					(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
				  	(setq	fvalue	(vlax-variant-value (vlax-get-property afield 'Value)))
			  		(if (= (substr fvalue 1 5) "FALSE")
						(if (not ErrFnd)
							(setq	ErrFnd	T)
						)
					)
			  		(if (= (substr fvalue 1 5) "FALSE")
					  	(ScLog_PutLin	"Acad_ADO"
									(strcat	"\nError [ " ModNam
											" ] RecCnt {" (itoa RecCnt) 
											(apply (quote strcat) (mapcar (quote (lambda (x y) (strcat x y))) ColumLst ValueLst))
											"}"
									)
						)
					)
					(setq	RecCnt	(1+ RecCnt))
					(vlax-invoke-method	ConnectionObject 'CommitTrans)
					(if (and aParameterObject (null (vlax-object-released-p aParameterObject)))
						(vlax-release-object aParameterObject)
					)
					(setq	aParameterObject		nil)
					(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
						(vlax-release-object aCommandObject)
					)
					(setq	aCommandObject		nil)
					(setq coState (vlax-get-property ConnectionObject 'State))
					(if (= coState adok-adStateOpen)
						(vlax-invoke-method ConnectionObject "Close")
					)
					(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
						(vlax-release-object ConnectionObject)
					)
					(setq	ConnectionObject	nil
							afield			nil
					)
			)
			(if ErrFnd
			  	(ScLog_PutLin	"Acad_ADO" (strcat "\n  Error: [ " ModNam " ] pushed RecCnt {" (itoa RecCnt) "} records"))
			  	(ScLog_PutLin	"Acad_ADO" (strcat "\nSuccess: [ " ModNam " ] pushed RecCnt {" (itoa RecCnt) "} records"))
			)
		)
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(if ErrFnd
		-1
		RecCnt
	)
)

(defun ADO_PutPanLog ( PanChg_LogLst OraInst /	;Puts Master Object List for a panel directly into Oracle
					SQLStatement ADO_DLLPath ConnectionObject coState coMode
					aCommandObject aParameterObject afield dvalue fvalue
					SQLStatement RecMstLst RecCnt ValueCnt ValueItm ValueLst ParamLst Bubba )
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(vlisp-import-symbol 'Bug)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq	RecCnt		0
					ErrCnt		0
					ErrFnd		nil
			)
			(foreach	RecPanLog
					PanChg_LogLst
					(setq	ParamLst			(list
												(list 2 adok-adVarChar adok-adParamInput)
												(list 7 adok-adVarChar adok-adParamInput)
												(list 4 adok-adVarChar adok-adParamInput)
												(list 3 adok-adVarChar adok-adParamInput)
												(list 8 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 25 adok-adVarChar adok-adParamInput)
												(list 25 adok-adVarChar adok-adParamReturnValue)
											)
							ValueLst			(list	(nth 0 RecPanLog)
													(nth 1 RecPanLog)
													(nth 2 RecPanLog)
													(substr (itoa (nth 3 RecPanLog)) 1 3)
													(nth 4 RecPanLog)
													(rtos (nth 5 RecPanLog) 2 4)
													(rtos (nth 6 RecPanLog) 2 4)
													(nth 7 RecPanLog)
											)
							ColumLst			(list	"} DivNam {"
													"} PanelNam {"
													"} SclBlk {"
													"} FdrCkts {"
													"} Nt_ID {"
													"} AddsUp_ms {"
													"} BrkPan_ms {"
													"} Loaded_DTM {"
											)
							ModNam			"ADO_PutPanLog"
							Bubba			(ADO_Mak_CmdObj	(list	OraInst
																	"AddsDb.Ins_PanLog"
																	ParamLst
															)
											)
							ConnectionObject	(if Bubba (nth 0 Bubba) nil)
							aCommandObject		(if Bubba (nth 1 Bubba) nil)
							aParameterObject	(if Bubba (nth 2 Bubba) nil)
							ValueCnt	0
					)
					(vlax-invoke-method	ConnectionObject 'BeginTrans)
					(foreach	ValueItm
							ValueLst
							(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
							(vlax-put-property afield 'Value (nth ValueCnt ValueLst))
							(setq	ValueCnt	(1+ ValueCnt))
					)
					;;;***************** Execute *****************
					(vlax-invoke-method aCommandObject "Execute" nil nil nil)
					(setq	ErrObj	(vlax-get-property ConnectionObject 'Errors))
			  		(setq	ErrCnt	(vlax-get-property ErrObj 'Count))
			  		(if (> ErrCnt 0)
						(setq	Bubba	"\nClearing ConnectionObject Errors..."
								ErrItm	(vlax-get-property ErrObj 'Item 0)
								Bubba	(vlax-invoke-method ErrObj 'Clear)
						)
					)
					(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
				  	(setq	fvalue	(vlax-variant-value (vlax-get-property afield 'Value)))
			  		(if (= (substr fvalue 1 5) "FALSE")
						(if (not ErrFnd)
							(setq	ErrFnd	T)
						)
					)
			  		(if (= (substr fvalue 1 5) "FALSE")
					  	(ScLog_PutLin	"Acad_ADO"
									(strcat	"\nError [ " ModNam
											" ] RecCnt {" (itoa RecCnt) 
											(apply (quote strcat) (mapcar (quote (lambda (x y) (strcat x y))) ColumLst ValueLst))
											"}"
									)
						)
					)
					(setq	RecCnt	(1+ RecCnt))
					(vlax-invoke-method	ConnectionObject 'CommitTrans)
					(if (and aParameterObject (null (vlax-object-released-p aParameterObject)))
						(vlax-release-object aParameterObject)
					)
					(setq	aParameterObject		nil)
					(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
						(vlax-release-object aCommandObject)
					)
					(setq	aCommandObject		nil)
					(setq coState (vlax-get-property ConnectionObject 'State))
					(if (= coState adok-adStateOpen)
						(vlax-invoke-method ConnectionObject "Close")
					)
					(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
						(vlax-release-object ConnectionObject)
					)
					(setq	ConnectionObject	nil
							afield			nil
					)
			)
			(if ErrFnd
			  	(ScLog_PutLin	"Acad_ADO" (strcat "\n  Error: [ " ModNam " ] pushed RecCnt {" (itoa RecCnt) "} records"))
			  	(ScLog_PutLin	"Acad_ADO" (strcat "\nSuccess: [ " ModNam " ] pushed RecCnt {" (itoa RecCnt) "} records"))
			)
		)
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(if ErrFnd
		-1
		RecCnt
	)
)

(defun ADO_PutObjMst ( ModObjMstLst OraInst /	;Puts Master Object List for a panel directly into Oracle
					SQLStatement ADO_DLLPath ConnectionObject coState coMode
					aCommandObject aParameterObject afield dvalue fvalue
					SQLStatement RecMstLst RecCnt ValueCnt ValueItm ValueLst ParamLst Bubba )
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(vlisp-import-symbol 'Bug)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq	RecCnt		0
					ErrCnt		0
					ErrFnd		nil
			)
			(foreach	RecMstLst
					ModObjMstLst
					(setq	ParamLst			(list
												(list 25 adok-adVarChar adok-adParamInput)
												(list 25 adok-adVarChar adok-adParamInput)
												(list 1 adok-adVarChar adok-adParamInput)
												(list 5 adok-adVarChar adok-adParamInput)
												(list 25 adok-adVarChar adok-adParamReturnValue)
											)
							ValueLst			(list	(nth 0 RecMstLst)
													(nth 2 RecMstLst)
													(nth 1 RecMstLst)
													(itoa (nth 3 RecMstLst))
											)
							ColumLst			(list	"} Device {"
													"} Edit_DTM {"
													"} Status_Flag {"
													"} Adds_Panel_ID {"
											)
							ModNam			"ADO_PutObjMst"
							Bubba			(ADO_Mak_CmdObj	(list	OraInst
																	"AddsDb.Ins_MstDev"
																	ParamLst
															)
											)
							ConnectionObject	(if Bubba (nth 0 Bubba) nil)
							aCommandObject		(if Bubba (nth 1 Bubba) nil)
							aParameterObject	(if Bubba (nth 2 Bubba) nil)
							ValueCnt	0
					)
					(vlax-invoke-method	ConnectionObject 'BeginTrans)
					(foreach	ValueItm
							ValueLst
							(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
							(vlax-put-property afield 'Value (nth ValueCnt ValueLst))
							(setq	ValueCnt	(1+ ValueCnt))
					)
					;;;***************** Execute *****************
					(vlax-invoke-method aCommandObject "Execute" nil nil nil)
					(setq	ErrObj	(vlax-get-property ConnectionObject 'Errors))
			  		(setq	ErrCnt	(vlax-get-property ErrObj 'Count))
			  		(if (> ErrCnt 0)
						(setq	Bubba	"\nClearing ConnectionObject Errors..."
								ErrItm	(vlax-get-property ErrObj 'Item 0)
								Bubba	(vlax-invoke-method ErrObj 'Clear)
						)
					)
					(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
				  	(setq	fvalue	(vlax-variant-value (vlax-get-property afield 'Value)))
			  		(if (= (substr fvalue 1 5) "FALSE")
						(if (not ErrFnd)
							(setq	ErrFnd	T)
						)
					)
			  		(if (= (substr fvalue 1 5) "FALSE")
					  	(ScLog_PutLin	"Acad_ADO"
									(strcat	"\nError [ " ModNam
											" ] RecCnt {" (itoa RecCnt) 
											(apply (quote strcat) (mapcar (quote (lambda (x y) (strcat x y))) ColumLst ValueLst))
											"}"
									)
						)
					)
					(setq	RecCnt	(1+ RecCnt))
					(vlax-invoke-method	ConnectionObject 'CommitTrans)
					(if (and aParameterObject (null (vlax-object-released-p aParameterObject)))
						(vlax-release-object aParameterObject)
					)
					(setq	aParameterObject		nil)
					(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
						(vlax-release-object aCommandObject)
					)
					(setq	aCommandObject		nil)
					(setq coState (vlax-get-property ConnectionObject 'State))
					(if (= coState adok-adStateOpen)
						(vlax-invoke-method ConnectionObject "Close")
					)
					(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
						(vlax-release-object ConnectionObject)
					)
					(setq	ConnectionObject	nil
							afield			nil
					)
			)
			(if ErrFnd
			  	(ScLog_PutLin	"Acad_ADO" (strcat "\n  Error: [ " ModNam " ] pushed RecCnt {" (itoa RecCnt) "} records"))
			  	(ScLog_PutLin	"Acad_ADO" (strcat "\nSuccess: [ " ModNam " ] pushed RecCnt {" (itoa RecCnt) "} records"))
			)
		)
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(if ErrFnd
		-1
		RecCnt
	)
)

(defun Mod ( Inp Root / Ans )				; Returns Mod of Division
	(if (= (type Inp) 'INT)
		(setq	Inp		(float Inp))
	)
	(if (= (type Root) 'INT)
		(setq	Root		(float Root))
	)
	(setq	Ans		(- (/ Inp Root) (fix (/ Inp Root)))
			Ans		(fix (* Ans Root))
	)
)

(defun ADO_Mak_CmdObj ( CmdLst /	afield		;Creates ADO Command Object and initializes Parameters
					ConnectionObject CmdTxt ParamLst ParamCnt OraInst
					ParamItm aCommandObject aParameterObject coMode coState  )
	(setq	OraInst	(nth 0 CmdLst)
			CmdTxt			(nth 1 CmdLst)
			ParamLst			(nth 2 CmdLst)
			ParamCnt			0
	)
	(setq ConnectionObject (vlax-create-object "ADODB.Connection"))
	(vlax-put-property ConnectionObject "Provider"  "OraOLEDB.Oracle.1")
	(vlax-put-property ConnectionObject "CommandTimeout" 30)
	(setq coMode (vlax-get-property ConnectionObject 'Mode))
	(setq coState (vlax-get-property ConnectionObject 'State))
	(if (= coState adok-adStateClosed)
		(vlax-put-property ConnectionObject 'Mode adok-adModeReadWrite)
	)
	(vlax-invoke-method	ConnectionObject	"Open"			;;; Use the Oracle OLEDB Drivers
									OraInst
									"GEWILYMS"
									"GEWILYMS"
									adok-adConnectUnspecified
	)
	(if ConnectionObject
		(progn
			(setq	aCommandObject	(vlax-create-object "ADODB.Command"))
			(vlax-put-property aCommandObject 'ActiveConnection ConnectionObject)
			(vlax-put-property aCommandObject 'CommandText CmdTxt)
			(vlax-put-property aCommandObject 'CommandType adok-adCmdStoredProc)
			(vlax-put-property aCommandObject 'Prepared 1)
			(setq aParameterObject (vlax-get-property aCommandObject 'Parameters.Refresh))
			(foreach	ParamItm
					ParamLst
					(setq	afield	(vlax-get-property aParameterObject 'Item ParamCnt))
					(vlax-put-property afield 'Size (nth 0 ParamItm))
					(vlax-put-property afield 'Type (nth 1 ParamItm))
					(vlax-put-property afield 'Direction (nth 2 ParamItm))
					(setq	ParamCnt	(1+ ParamCnt))
			)
		)
	)
	(list ConnectionObject aCommandObject aParameterObject)
)

(defun ADO_PutObjReg ( ModObjRegLst OraInst /	;Puts Master Object List for a panel directly into Oracle
					SQLStatement ADO_DLLPath ConnectionObject coState coMode
					aCommandObject aParameterObject afield dvalue fvalue
					SQLStatement RecRegLst RecCnt ValueCnt ValueItm ValueLst ParamLst Bubba )
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(vlisp-import-symbol 'Bug)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq	RecCnt		0
					ErrCnt		0
					ErrFnd		nil
			)
			(foreach	RecRegLst
					ModObjRegLst
					(setq	ParamLst			(list
												(list 25 adok-adVarChar adok-adParamInput)
												(list 50 adok-adVarChar adok-adParamInput)
												(list 250 adok-adVarChar adok-adParamInput)
												(list 25 adok-adVarChar adok-adParamReturnValue)
											)
							ValueLst			(list	(nth 0 RecRegLst)
													(nth 1 RecRegLst)
													(nth 2 RecRegLst)
											)
							ColumLst			(list	"} Device {"
													"} XdtName {"
													"} XdtValue {"
											)
							ModNam			"ADO_PutObjReg"
							Bubba			(ADO_Mak_CmdObj	(list	OraInst
																	"AddsDb.Ins_RegDat"
																	ParamLst
															)
											)
							ConnectionObject	(if Bubba (nth 0 Bubba) nil)
							aCommandObject		(if Bubba (nth 1 Bubba) nil)
							aParameterObject	(if Bubba (nth 2 Bubba) nil)
							ValueCnt	0
					)
					(vlax-invoke-method	ConnectionObject 'BeginTrans)
					(foreach	ValueItm
							ValueLst
							(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
							(vlax-put-property afield 'Value (nth ValueCnt ValueLst))
							(setq	ValueCnt	(1+ ValueCnt))
					)
					;;;***************** Execute *****************
					(vlax-invoke-method aCommandObject "Execute" nil nil nil)
					(setq	ErrObj	(vlax-get-property ConnectionObject 'Errors))
			  		(setq	ErrCnt	(vlax-get-property ErrObj 'Count))
			  		(if (> ErrCnt 0)
						(setq	Bubba	"\nClearing ConnectionObject Errors..."
								ErrItm	(vlax-get-property ErrObj 'Item 0)
								Bubba	(vlax-invoke-method ErrObj 'Clear)
						)
					)
					(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
				  	(setq	fvalue	(vlax-variant-value (vlax-get-property afield 'Value)))
			  		(if (= (substr fvalue 1 5) "FALSE")
						(if (not ErrFnd)
							(setq	ErrFnd	T)
						)
					)
			  		(if (= (substr fvalue 1 5) "FALSE")
					  	(ScLog_PutLin	"Acad_ADO"
									(strcat	"\nError [ " ModNam
											" ] RecCnt {" (itoa RecCnt) 
											(apply (quote strcat) (mapcar (quote (lambda (x y) (strcat x y))) ColumLst ValueLst))
											"}"
									)
						)
					)
					(setq	RecCnt	(1+ RecCnt))
					(vlax-invoke-method	ConnectionObject 'CommitTrans)
					(if (and aParameterObject (null (vlax-object-released-p aParameterObject)))
						(vlax-release-object aParameterObject)
					)
					(setq	aParameterObject		nil)
					(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
						(vlax-release-object aCommandObject)
					)
					(setq	aCommandObject		nil)
					(setq coState (vlax-get-property ConnectionObject 'State))
					(if (= coState adok-adStateOpen)
						(vlax-invoke-method ConnectionObject "Close")
					)
					(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
						(vlax-release-object ConnectionObject)
					)
					(setq	ConnectionObject	nil
							afield			nil
					)
			)
			(if ErrFnd
			  	(ScLog_PutLin	"Acad_ADO" (strcat "\n  Error: [ " ModNam " ] pushed RecCnt {" (itoa RecCnt) "} records"))
			  	(ScLog_PutLin	"Acad_ADO" (strcat "\nSuccess: [ " ModNam " ] pushed RecCnt {" (itoa RecCnt) "} records"))
			)
		)
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(if ErrFnd
		-1
		RecCnt
	)
)

(defun ScLog_PutLin ( AppNam LinItm /			;Puts Log messages in the standard place...
					ScLog_DLLPath CoolLogObj Bubba )
	(setq ScLog_DLLPath "C:\\Southern\\Apps\\CoolLog\\Components\\Bin\\")	;;; Normal path to the CoolLog DLL, change as needed:
	(if (null clgk-SeverityLevelInformation)
		(if (findfile (strcat ScLog_DLLPath "CoolLog.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ScLog_DLLPath "CoolLog.dll")
				:methods-prefix	"clgm-"
				:properties-prefix	"clgp-"
				:constants-prefix	"clgk-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ScLog_DLLPath "CoolLog.dll\""))
				(exit)
			)
		)
	)
	(setq CoolLogObj (vlax-create-object "ScCoolLog.Log"))
	(setq	CoolGood	(vlax-invoke-method	CoolLogObj 'LoadAppRegistry AppNam True "Southern Company"))
	(vlax-invoke-method	CoolLogObj 'LogText clgk-SeverityLevelInformation LinItm clgk-MessageTypeDefault)
	(if (and CoolLogObj (null (vlax-object-released-p CoolLogObj)))
		(vlax-release-object CoolLogObj)
	)
	(setq	CoolLogObj	nil)
)

(defun ScLog_PutLinEx ( AppNam LinItm /		;Puts Log messages in the standard place...
					ScLog_DLLPath CoolLogObj Bubba )
	(setq ScLog_DLLPath "C:\\Southern\\Apps\\CoolLog\\Components\\Bin\\")	;;; Normal path to the CoolLog DLL, change as needed:
	(if (null clgk-SeverityLevelInformation)
		(if (findfile (strcat ScLog_DLLPath "CoolLog.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ScLog_DLLPath "CoolLog.dll")
				:methods-prefix	"clgm-"
				:properties-prefix	"clgp-"
				:constants-prefix	"clgk-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ScLog_DLLPath "CoolLog.dll\""))
				(exit)
			)
		)
	)
	(setq CoolLogObj (vlax-create-object "ScCoolLog.LogEx"))
	(setq	CoolGood	(vlax-invoke-method	CoolLogObj 'LoadAppRegistry AppNam True "Southern Company"))
	(vlax-invoke-method	CoolLogObj 'LogText clgk-SeverityLevelInformation LinItm clgk-MessageTypeDefault)
	(if (and CoolLogObj (null (vlax-object-released-p CoolLogObj)))
		(vlax-release-object CoolLogObj)
	)
	(setq	CoolLogObj	nil)
)

(defun ADO_PutObjBlk ( ModObjBlkLst OraInst /	;Puts Master Object List for a panel directly into Oracle
					SQLStatement ADO_DLLPath ConnectionObject coState coMode
					aCommandObject aParameterObject afield dvalue fvalue
					SQLStatement RecBlkLst RecCnt ValueCnt ValueItm ValueLst ParamLst Bubba )
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(vlisp-import-symbol 'Bug)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq	RecCnt		0
					ErrCnt		0
					ErrFnd		nil
			)
			(foreach	RecBlkLst
					ModObjBlkLst
					(setq	ParamLst			(list
												(list 8 adok-adVarChar adok-adParamInput)
												(list 16 adok-adVarChar adok-adParamInput)
												(list 50 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 25 adok-adVarChar adok-adParamInput)
												(list 5 adok-adVarChar adok-adParamInput)
												(list 25 adok-adVarChar adok-adParamReturnValue)
											)
							ValueLst			(list	(nth 0 RecBlkLst)
													(nth 1 RecBlkLst)
													(nth 2 RecBlkLst)
													(rtos (nth 3 RecBlkLst) 2 4)
													(rtos (nth 4 RecBlkLst) 2 4)
													(rtos (nth 5 RecBlkLst) 2 4)
													(rtos (nth 6 RecBlkLst) 2 4)
													(rtos (nth 7 RecBlkLst) 2 4)
													(rtos (nth 8 RecBlkLst) 2 4)
													(rtos (nth 9 RecBlkLst) 2 4)
													(substr (itoa (nth 10 RecBlkLst)) 1 1)
													(substr (itoa (nth 11 RecBlkLst)) 1 1)
													(nth 12 RecBlkLst)
													(rtos (nth 13 RecBlkLst) 2 0)
											)
							ColumLst			(list	"} Adds_Blk_Nam {"
													"} BlkHandle {"
													"} Adds_Layer_Nam {"
													"} BlkPntX {"
													"} BlkPntY {"
													"} BlkPntZ {"
													"} BlkSclX {"
													"} BlkSclY {"
													"} BlkSclZ {"
													"} BlkRot {"
													"} BlkSpace {"
													"} BlkAttFlw {"
													"} Device_ID {"
													"} Adds_Panel_ID {"
											)
							ModNam			"ADO_PutObjBlk"
							Bubba			(ADO_Mak_CmdObj	(list	OraInst
																	"AddsDb.Ins_ObjBlk"
																	ParamLst
															)
											)
							ConnectionObject	(if Bubba (nth 0 Bubba) nil)
							aCommandObject		(if Bubba (nth 1 Bubba) nil)
							aParameterObject	(if Bubba (nth 2 Bubba) nil)
							ValueCnt	0
					)
					(vlax-invoke-method	ConnectionObject 'BeginTrans)
					(foreach	ValueItm
							ValueLst
							(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
							(vlax-put-property afield 'Value (nth ValueCnt ValueLst))
							(setq	ValueCnt	(1+ ValueCnt))
					)
					;;;***************** Execute *****************
					(vlax-invoke-method aCommandObject "Execute" nil nil nil)
					(setq	ErrObj	(vlax-get-property ConnectionObject 'Errors))
			  		(setq	ErrCnt	(vlax-get-property ErrObj 'Count))
			  		(if (> ErrCnt 0)
						(setq	Bubba	"\nClearing ConnectionObject Errors..."
								ErrItm	(vlax-get-property ErrObj 'Item 0)
								Bubba	(vlax-invoke-method ErrObj 'Clear)
						)
					)
					(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
				  	(setq	fvalue	(vlax-variant-value (vlax-get-property afield 'Value)))
			  		(if (= (substr fvalue 1 5) "FALSE")
						(if (not ErrFnd)
							(setq	ErrFnd	T)
						)
					)
			  		(if (= (substr fvalue 1 5) "FALSE")
					  	(ScLog_PutLin	"Acad_ADO"
									(strcat	"\nError [ " ModNam
											" ] RecCnt {" (itoa RecCnt) 
											(apply (quote strcat) (mapcar (quote (lambda (x y) (strcat x y))) ColumLst ValueLst))
											"}"
									)
						)
					)
					(setq	RecCnt	(1+ RecCnt))
					(vlax-invoke-method	ConnectionObject 'CommitTrans)
					(if (and aParameterObject (null (vlax-object-released-p aParameterObject)))
						(vlax-release-object aParameterObject)
					)
					(setq	aParameterObject		nil)
					(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
						(vlax-release-object aCommandObject)
					)
					(setq	aCommandObject		nil)
					(setq coState (vlax-get-property ConnectionObject 'State))
					(if (= coState adok-adStateOpen)
						(vlax-invoke-method ConnectionObject "Close")
					)
					(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
						(vlax-release-object ConnectionObject)
					)
					(setq	ConnectionObject	nil
							afield			nil
					)
			)
			(if ErrFnd
			  	(ScLog_PutLin	"Acad_ADO" (strcat "\n  Error: [ " ModNam " ] pushed RecCnt {" (itoa RecCnt) "} records"))
			  	(ScLog_PutLin	"Acad_ADO" (strcat "\nSuccess: [ " ModNam " ] pushed RecCnt {" (itoa RecCnt) "} records"))
			)
		)
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(if ErrFnd
		-1
		RecCnt
	)
)

(defun ADO_PutObjAtt ( ModObjAttLst OraInst /	;Puts Master Object List for a panel directly into Oracle
					SQLStatement ADO_DLLPath ConnectionObject coState coMode
					aCommandObject aParameterObject afield dvalue fvalue
					SQLStatement RecAttLst RecCnt ValueCnt ValueItm ValueLst ParamLst Bubba )
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(vlisp-import-symbol 'Bug)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq	RecCnt		0
					ErrCnt		0
					ErrFnd		nil
			)
			(foreach	RecAttLst
					ModObjAttLst
					(setq	ParamLst			(list
												(list 255 adok-adVarChar adok-adParamInput)
												(list 255 adok-adVarChar adok-adParamInput)
												(list 16 adok-adVarChar adok-adParamInput)
												(list 50 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 16 adok-adVarChar adok-adParamInput)
												(list 1 adok-adVarChar adok-adParamInput)
												(list 1 adok-adVarChar adok-adParamInput)
												(list 1 adok-adVarChar adok-adParamInput)
												(list 1 adok-adVarChar adok-adParamInput)
												(list 25 adok-adVarChar adok-adParamInput)
												(list 25 adok-adVarChar adok-adParamReturnValue)
											)
							ValueLst			(list	(nth 0 RecAttLst)
													(nth 1 RecAttLst)
													(nth 2 RecAttLst)
													(nth 3 RecAttLst)
													(rtos (nth 4 RecAttLst) 2 4)
													(rtos (nth 5 RecAttLst) 2 4)
													(rtos (nth 6 RecAttLst) 2 4)
													(rtos (nth 7 RecAttLst) 2 4)
													(rtos (nth 8 RecAttLst) 2 4)
													(rtos (nth 9 RecAttLst) 2 4)
													(rtos (nth 10 RecAttLst) 2 4)
													(rtos (nth 11 RecAttLst) 2 4)
													(rtos (nth 12 RecAttLst) 2 4)
													(nth 13 RecAttLst)
													(substr (itoa (nth 14 RecAttLst)) 1 1)
													(substr (itoa (nth 15 RecAttLst)) 1 1)
													(substr (itoa (nth 16 RecAttLst)) 1 1)
													(substr (itoa (nth 17 RecAttLst)) 1 1)
													(nth 18 RecAttLst)
											)
							ColumLst			(list	"} AttTag {"
													"} AttValue {"
													"} AttHandle {"
													"} Adds_Layer_Nam {"
													"} AttNPntX {"
													"} AttNPntY {"
													"} AttNPntZ {"
													"} AttJPntX {"
													"} AttJPntY {"
													"} AttJPntZ {"
													"} AttThick {"
													"} AttHgt {"
													"} AttRot {"
													"} Adds_Style {"
													"} AttFlag {"
													"} AttTxtFlag {"
													"} AttHorzFlag {"
													"} AttVertFlag {"
													"} Device_ID {"
											)
							ModNam			"ADO_PutObjAtt"
							Bubba			(ADO_Mak_CmdObj	(list	OraInst
																	"AddsDb.Ins_ObjAtt"
																	ParamLst
															)
											)
							ConnectionObject	(if Bubba (nth 0 Bubba) nil)
							aCommandObject		(if Bubba (nth 1 Bubba) nil)
							aParameterObject	(if Bubba (nth 2 Bubba) nil)
							ValueCnt	0
					)
					(vlax-invoke-method	ConnectionObject 'BeginTrans)
					(foreach	ValueItm
							ValueLst
							(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
							(vlax-put-property afield 'Value (nth ValueCnt ValueLst))
							(setq	ValueCnt	(1+ ValueCnt))
					)
					;;;***************** Execute *****************
					(vlax-invoke-method aCommandObject "Execute" nil nil nil)
					(setq	ErrObj	(vlax-get-property ConnectionObject 'Errors))
			  		(setq	ErrCnt	(vlax-get-property ErrObj 'Count))
			  		(if (> ErrCnt 0)
						(setq	Bubba	"\nClearing ConnectionObject Errors..."
								ErrItm	(vlax-get-property ErrObj 'Item 0)
								Bubba	(vlax-invoke-method ErrObj 'Clear)
						)
					)
					(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
				  	(setq	fvalue	(vlax-variant-value (vlax-get-property afield 'Value)))
			  		(if (= (substr fvalue 1 5) "FALSE")
						(if (not ErrFnd)
							(setq	ErrFnd	T)
						)
					)
			  		(if (= (substr fvalue 1 5) "FALSE")
					  	(ScLog_PutLin	"Acad_ADO"
									(strcat	"\nError [ " ModNam
											" ] RecCnt {" (itoa RecCnt) 
											(apply (quote strcat) (mapcar (quote (lambda (x y) (strcat x y))) ColumLst ValueLst))
											"}"
									)
						)
					)
					(setq	RecCnt	(1+ RecCnt))
					(vlax-invoke-method	ConnectionObject 'CommitTrans)
					(if (and aParameterObject (null (vlax-object-released-p aParameterObject)))
						(vlax-release-object aParameterObject)
					)
					(setq	aParameterObject		nil)
					(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
						(vlax-release-object aCommandObject)
					)
					(setq	aCommandObject		nil)
					(setq coState (vlax-get-property ConnectionObject 'State))
					(if (= coState adok-adStateOpen)
						(vlax-invoke-method ConnectionObject "Close")
					)
					(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
						(vlax-release-object ConnectionObject)
					)
					(setq	ConnectionObject	nil
							afield			nil
					)
			)
			(if ErrFnd
			  	(ScLog_PutLin	"Acad_ADO" (strcat "\n  Error: [ " ModNam " ] pushed RecCnt {" (itoa RecCnt) "} records"))
			  	(ScLog_PutLin	"Acad_ADO" (strcat "\nSuccess: [ " ModNam " ] pushed RecCnt {" (itoa RecCnt) "} records"))
			)
		)
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(if ErrFnd
		-1
		RecCnt
	)
)

(defun ADO_PutObj_PL ( ModPLnDatLst OraInst /	;Puts Master Object List for a panel directly into Oracle
					SQLStatement ADO_DLLPath ConnectionObject coState coMode
					aCommandObject aParameterObject afield dvalue fvalue
					SQLStatement Rec_PLLst RecCnt ValueCnt ValueItm ValueLst ParamLst Bubba )
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(vlisp-import-symbol 'Bug)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq	RecCnt		0
					ErrCnt		0
					ErrFnd		nil
			)
			(foreach	Rec_PLLst
					ModPLnDatLst
					(setq	ParamLst			(list
												(list 16 adok-adVarChar adok-adParamInput)
												(list 16 adok-adVarChar adok-adParamInput)
												(list 50 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 5 adok-adVarChar adok-adParamInput)
												(list 5 adok-adVarChar adok-adParamInput)
												(list 5 adok-adVarChar adok-adParamInput)
												(list 1 adok-adVarChar adok-adParamInput)
												(list 1 adok-adVarChar adok-adParamInput)
												(list 1 adok-adVarChar adok-adParamInput)
												(list 1 adok-adVarChar adok-adParamInput)
												(list 1 adok-adVarChar adok-adParamInput)
												(list 25 adok-adVarChar adok-adParamInput)
												(list 5 adok-adVarChar adok-adParamInput)
												(list 25 adok-adVarChar adok-adParamReturnValue)
											)
							ValueLst			(list	(nth 0 Rec_PLLst)
													(nth 1 Rec_PLLst)
													(nth 2 Rec_PLLst)
													(rtos (nth 3 Rec_PLLst) 2 4)
													(rtos (nth 4 Rec_PLLst) 2 4)
													(rtos (nth 5 Rec_PLLst) 2 4)
													(substr (itoa (nth 6 Rec_PLLst)) 1 5)
													(substr (itoa (nth 7 Rec_PLLst)) 1 5)
													(substr (itoa (nth 8 Rec_PLLst)) 1 5)
													(substr (itoa (nth 9 Rec_PLLst)) 1 1)
													(substr (itoa (nth 10 Rec_PLLst)) 1 1)
													(substr (itoa (nth 11 Rec_PLLst)) 1 1)
													(substr (itoa (nth 12 Rec_PLLst)) 1 1)
													(substr (itoa (nth 13 Rec_PLLst)) 1 1)
													(nth 14 Rec_PLLst)
													(rtos (nth 15 Rec_PLLst) 2 0)
											)
							ColumLst			(list	"} PlDatatype {"
													"} PlHandle {"
													"} Adds_Layer_Nam {"
													"} PlThick {"
													"} PlWidBegin {"
													"} PlWidEnd {"
													"} PlAttFlw {"
													"} PlSpace {"
													"} PlFlag {"
													"} PlPolyMshM {"
													"} PlPolyMshN {"
													"} PlPolySmthM {"
													"} PlPolySmthN {"
													"} PlCrvSmtTyp {"
													"} Device_ID {"
													"} Adds_Panel_ID {"
											)
							ModNam			"ADO_PutObj_PL"
							Bubba			(ADO_Mak_CmdObj	(list	OraInst
																	"AddsDb.Ins_Obj_PL"
																	ParamLst
															)
											)
							ConnectionObject	(if Bubba (nth 0 Bubba) nil)
							aCommandObject		(if Bubba (nth 1 Bubba) nil)
							aParameterObject	(if Bubba (nth 2 Bubba) nil)
							ValueCnt	0
					)
					(vlax-invoke-method	ConnectionObject 'BeginTrans)
					(foreach	ValueItm
							ValueLst
							(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
							(vlax-put-property afield 'Value (nth ValueCnt ValueLst))
							(setq	ValueCnt	(1+ ValueCnt))
					)
					;;;***************** Execute *****************
					(vlax-invoke-method aCommandObject "Execute" nil nil nil)
					(setq	ErrObj	(vlax-get-property ConnectionObject 'Errors))
			  		(setq	ErrCnt	(vlax-get-property ErrObj 'Count))
			  		(if (> ErrCnt 0)
						(setq	Bubba	"\nClearing ConnectionObject Errors..."
								ErrItm	(vlax-get-property ErrObj 'Item 0)
								Bubba	(vlax-invoke-method ErrObj 'Clear)
						)
					)
					(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
				  	(setq	fvalue	(vlax-variant-value (vlax-get-property afield 'Value)))
			  		(if (= (substr fvalue 1 5) "FALSE")
						(if (not ErrFnd)
							(setq	ErrFnd	T)
						)
					)
			  		(if (= (substr fvalue 1 5) "FALSE")
					  	(ScLog_PutLin	"Acad_ADO"
									(strcat	"\nError [ " ModNam
											" ] RecCnt {" (itoa RecCnt) 
											(apply (quote strcat) (mapcar (quote (lambda (x y) (strcat x y))) ColumLst ValueLst))
											"}"
									)
						)
					)
					(setq	RecCnt	(1+ RecCnt))
					(vlax-invoke-method	ConnectionObject 'CommitTrans)
					(if (and aParameterObject (null (vlax-object-released-p aParameterObject)))
						(vlax-release-object aParameterObject)
					)
					(setq	aParameterObject		nil)
					(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
						(vlax-release-object aCommandObject)
					)
					(setq	aCommandObject		nil)
					(setq coState (vlax-get-property ConnectionObject 'State))
					(if (= coState adok-adStateOpen)
						(vlax-invoke-method ConnectionObject "Close")
					)
					(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
						(vlax-release-object ConnectionObject)
					)
					(setq	ConnectionObject	nil
							afield			nil
					)
			)
			(if ErrFnd
			  	(ScLog_PutLin	"Acad_ADO" (strcat "\n  Error: [ " ModNam " ] pushed RecCnt {" (itoa RecCnt) "} records"))
			  	(ScLog_PutLin	"Acad_ADO" (strcat "\nSuccess: [ " ModNam " ] pushed RecCnt {" (itoa RecCnt) "} records"))
			)
		)
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(if ErrFnd
		-1
		RecCnt
	)
)

(defun ADO_PutObjVrt ( ModVrtDatLst OraInst /	;Puts Master Object List for a panel directly into Oracle
					SQLStatement ADO_DLLPath ConnectionObject coState coMode
					aCommandObject aParameterObject afield dvalue fvalue
					SQLStatement RecVrtLst RecCnt ValueCnt ValueItm ValueLst ParamLst Bubba )
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(vlisp-import-symbol 'Bug)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq	RecCnt		0
					ErrCnt		0
					ErrFnd		nil
			)
			(foreach	RecVrtLst
					ModVrtDatLst
					(setq	ParamLst			(list
												(list 3 adok-adVarChar adok-adParamInput)
												(list 16 adok-adVarChar adok-adParamInput)
												(list 16 adok-adVarChar adok-adParamInput)
												(list 50 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 5 adok-adVarChar adok-adParamInput)
												(list 25 adok-adVarChar adok-adParamInput)
												(list 25 adok-adVarChar adok-adParamReturnValue)
											)
							ValueLst			(list	(nth 0 RecVrtLst)
													(nth 1 RecVrtLst)
													(nth 2 RecVrtLst)
													(nth 3 RecVrtLst)
													(rtos (nth 4 RecVrtLst) 2 4)
													(rtos (nth 5 RecVrtLst) 2 4)
													(rtos (nth 6 RecVrtLst) 2 4)
													(rtos (nth 7 RecVrtLst) 2 4)
													(rtos (nth 8 RecVrtLst) 2 4)
													(rtos (nth 9 RecVrtLst) 2 4)
													(rtos (nth 10 RecVrtLst) 2 4)
													(substr (itoa (nth 11 RecVrtLst)) 1 5)
													(nth 12 RecVrtLst)
											)
							ColumLst			(list	"} VrtCnt {"
													"} VrtDataType {"
													"} VrtHandle {"
													"} Adds_Layer_Nam {"
													"} VrtPntX {"
													"} VrtPntY {"
													"} VrtPntZ {"
													"} VrtWidBegin {"
													"} VrtWidEnd {"
													"} VrtBulge {"
													"} VrtTan {"
													"} VrtFlag {"
													"} Device_ID {"
											)
							ModNam			"ADO_PutObjVrt"
							Bubba			(ADO_Mak_CmdObj	(list	OraInst
																	"AddsDb.Ins_ObjVrt"
																	ParamLst
															)
											)
							ConnectionObject	(if Bubba (nth 0 Bubba) nil)
							aCommandObject		(if Bubba (nth 1 Bubba) nil)
							aParameterObject	(if Bubba (nth 2 Bubba) nil)
							ValueCnt	0
					)
					(vlax-invoke-method	ConnectionObject 'BeginTrans)
					(foreach	ValueItm
							ValueLst
							(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
							(vlax-put-property afield 'Value (nth ValueCnt ValueLst))
							(setq	ValueCnt	(1+ ValueCnt))
					)
					;;;***************** Execute *****************
					(vlax-invoke-method aCommandObject "Execute" nil nil nil)
					(setq	ErrObj	(vlax-get-property ConnectionObject 'Errors))
			  		(setq	ErrCnt	(vlax-get-property ErrObj 'Count))
			  		(if (> ErrCnt 0)
						(setq	Bubba	"\nClearing ConnectionObject Errors..."
								ErrItm	(vlax-get-property ErrObj 'Item 0)
								Bubba	(vlax-invoke-method ErrObj 'Clear)
						)
					)
					(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
				  	(setq	fvalue	(vlax-variant-value (vlax-get-property afield 'Value)))
			  		(if (= (substr fvalue 1 5) "FALSE")
						(if (not ErrFnd)
							(setq	ErrFnd	T)
						)
					)
			  		(if (= (substr fvalue 1 5) "FALSE")
					  	(ScLog_PutLin	"Acad_ADO"
									(strcat	"\nError [ " ModNam
											" ] RecCnt {" (itoa RecCnt) 
											(apply (quote strcat) (mapcar (quote (lambda (x y) (strcat x y))) ColumLst ValueLst))
											"}"
									)
						)
					)
					(setq	RecCnt	(1+ RecCnt))
					(vlax-invoke-method	ConnectionObject 'CommitTrans)
					(if (and aParameterObject (null (vlax-object-released-p aParameterObject)))
						(vlax-release-object aParameterObject)
					)
					(setq	aParameterObject		nil)
					(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
						(vlax-release-object aCommandObject)
					)
					(setq	aCommandObject		nil)
					(setq coState (vlax-get-property ConnectionObject 'State))
					(if (= coState adok-adStateOpen)
						(vlax-invoke-method ConnectionObject "Close")
					)
					(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
						(vlax-release-object ConnectionObject)
					)
					(setq	ConnectionObject	nil
							afield			nil
					)
			)
			(if ErrFnd
			  	(ScLog_PutLin	"Acad_ADO" (strcat "\n  Error: [ " ModNam " ] pushed RecCnt {" (itoa RecCnt) "} records"))
			  	(ScLog_PutLin	"Acad_ADO" (strcat "\nSuccess: [ " ModNam " ] pushed RecCnt {" (itoa RecCnt) "} records"))
			)
		)
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(if ErrFnd
		-1
		RecCnt
	)
)

(defun ADO_PutObj4PL ( ModObj4PLLst OraInst /	;Puts Master Object List for a panel directly into Oracle
					SQLStatement ADO_DLLPath ConnectionObject coState coMode
					aCommandObject aParameterObject afield dvalue fvalue
					SQLStatement Rec4PLLst RecCnt ValueCnt ValueItm ValueLst ParamLst Bubba )
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(vlisp-import-symbol 'Bug)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq	RecCnt		0
					ErrCnt		0
					ErrFnd		nil
			)
			(foreach	Rec4PLLst
					ModObj4PLLst
					(setq	ParamLst			(list
												(list 50 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 8 adok-adVarChar adok-adParamInput)
												(list 25 adok-adVarChar adok-adParamInput)
												(list 5 adok-adVarChar adok-adParamInput)
												(list 3 adok-adVarChar adok-adParamInput)
												(list 25 adok-adVarChar adok-adParamReturnValue)
											)
							ValueLst			(list	(nth 0 Rec4PLLst)
													(rtos (nth 1 Rec4PLLst) 2 4)
													(rtos (nth 2 Rec4PLLst) 2 4)
													(rtos (nth 3 Rec4PLLst) 2 4)
													(rtos (nth 4 Rec4PLLst) 2 4)
													(rtos (nth 5 Rec4PLLst) 2 4)
													(rtos (nth 6 Rec4PLLst) 2 4)
													(rtos (nth 7 Rec4PLLst) 2 4)
													(rtos (nth 8 Rec4PLLst) 2 4)
													(rtos (nth 9 Rec4PLLst) 2 4)
													(rtos (nth 10 Rec4PLLst) 2 4)
													(nth 11 Rec4PLLst)
													(rtos (nth 12 Rec4PLLst) 2 0)
													(nth 13 Rec4PLLst)
											)
							ColumLst			(list	"} Adds_Layer_Nam {"
													"} PlWid {"
													"} PntX1 {"
													"} PntY1 {"
													"} PntX2 {"
													"} PntY2 {"
													"} PntX3 {"
													"} PntY3 {"
													"} PntX4 {"
													"} PntY4 {"
													"} Point_Cnt {"
													"} Device_ID {"
													"} Adds_Panel_ID {"
													"} SegCnt {"
											)
							ModNam			"ADO_PutObj4PL"
							Bubba			(ADO_Mak_CmdObj	(list	OraInst
																	"AddsDb.Ins_Obj4PL"
																	ParamLst
															)
											)
							ConnectionObject	(if Bubba (nth 0 Bubba) nil)
							aCommandObject		(if Bubba (nth 1 Bubba) nil)
							aParameterObject	(if Bubba (nth 2 Bubba) nil)
							ValueCnt	0
					)
					(vlax-invoke-method	ConnectionObject 'BeginTrans)
					(foreach	ValueItm
							ValueLst
							(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
							(vlax-put-property afield 'Value (nth ValueCnt ValueLst))
							(setq	ValueCnt	(1+ ValueCnt))
					)
					;;;***************** Execute *****************
					(vlax-invoke-method aCommandObject "Execute" nil nil nil)
					(setq	ErrObj	(vlax-get-property ConnectionObject 'Errors))
			  		(setq	ErrCnt	(vlax-get-property ErrObj 'Count))
			  		(if (> ErrCnt 0)
						(setq	Bubba	"\nClearing ConnectionObject Errors..."
								ErrItm	(vlax-get-property ErrObj 'Item 0)
								Bubba	(vlax-invoke-method ErrObj 'Clear)
						)
					)
					(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
				  	(setq	fvalue	(vlax-variant-value (vlax-get-property afield 'Value)))
			  		(if (= (substr fvalue 1 5) "FALSE")
						(if (not ErrFnd)
							(setq	ErrFnd	T)
						)
					)
			  		(if (= (substr fvalue 1 5) "FALSE")
					  	(ScLog_PutLin	"Acad_ADO"
									(strcat	"\nError [ " ModNam
											" ] RecCnt {" (itoa RecCnt) 
											(apply (quote strcat) (mapcar (quote (lambda (x y) (strcat x y))) ColumLst ValueLst))
											"}"
									)
						)
					)
					(setq	RecCnt	(1+ RecCnt))
					(vlax-invoke-method	ConnectionObject 'CommitTrans)
					(if (and aParameterObject (null (vlax-object-released-p aParameterObject)))
						(vlax-release-object aParameterObject)
					)
					(setq	aParameterObject		nil)
					(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
						(vlax-release-object aCommandObject)
					)
					(setq	aCommandObject		nil)
					(setq coState (vlax-get-property ConnectionObject 'State))
					(if (= coState adok-adStateOpen)
						(vlax-invoke-method ConnectionObject "Close")
					)
					(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
						(vlax-release-object ConnectionObject)
					)
					(setq	ConnectionObject	nil
							afield			nil
					)
			)
			(if ErrFnd
			  	(ScLog_PutLin	"Acad_ADO" (strcat "\n  Error: [ " ModNam " ] pushed RecCnt {" (itoa RecCnt) "} records"))
			  	(ScLog_PutLin	"Acad_ADO" (strcat "\nSuccess: [ " ModNam " ] pushed RecCnt {" (itoa RecCnt) "} records"))
			)
		)
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(if ErrFnd
		-1
		RecCnt
	)
)

(defun ADO_PutObjTxt ( ModObjTxtLst OraInst /	;Puts Master Object List for a panel directly into Oracle
					SQLStatement ADO_DLLPath ConnectionObject coState coMode
					aCommandObject aParameterObject afield dvalue fvalue
					SQLStatement RecTxtLst RecCnt ValueCnt ValueItm ValueLst ParamLst Bubba )
	(setq ADO_DLLPath "c:\\program files\\common files\\system\\ado\\")	;;; Normal path to the ADO DLL, change as needed:
	(if (null adom-Append)
		(if (findfile (strcat ADO_DLLPath "msado15.dll"))
			(vlax-import-type-library
				:tlb-filename		(strcat ADO_DLLPath "msado15.dll")
				:methods-prefix	"adom-"
				:properties-prefix	"adop-"
				:constants-prefix	"adok-"
			)
			(progn
				(alert (strcat "Exiting - Can't find \"" ADO_DLLPath "msado15.dll\""))
				(exit)
			)
		)
	)
	(vlisp-import-symbol 'Bug)
	(if adom-Append											;;; Proceed if Type Library has been loaded.
		(progn												;;; Create A Connection Object
			(setq	RecCnt		0
					ErrCnt		0
					ErrFnd		nil
			)
			(foreach	RecTxtLst
					ModObjTxtLst
					(setq	ParamLst			(list
												(list 16 adok-adVarChar adok-adParamInput)
												(list 16 adok-adVarChar adok-adParamInput)
												(list 50 adok-adVarChar adok-adParamInput)
												(list 255 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 15 adok-adVarChar adok-adParamInput)
												(list 1 adok-adVarChar adok-adParamInput)
												(list 1 adok-adVarChar adok-adParamInput)
												(list 1 adok-adVarChar adok-adParamInput)
												(list 1 adok-adVarChar adok-adParamInput)
												(list 25 adok-adVarChar adok-adParamInput)
												(list 5 adok-adVarChar adok-adParamInput)
												(list 25 adok-adVarChar adok-adParamReturnValue)
											)
							ValueLst			(list	(nth 0 RecTxtLst)
													(nth 1 RecTxtLst)
													(nth 2 RecTxtLst)
													(nth 3 RecTxtLst)
													(nth 4 RecTxtLst)
													(rtos (nth 5 RecTxtLst) 2 4)
													(rtos (nth 6 RecTxtLst) 2 4)
													(rtos (nth 7 RecTxtLst) 2 4)
													(rtos (nth 8 RecTxtLst) 2 4)
													(rtos (nth 9 RecTxtLst) 2 4)
													(rtos (nth 10 RecTxtLst) 2 4)
													(rtos (nth 11 RecTxtLst) 2 4)
													(rtos (nth 12 RecTxtLst) 2 4)
													(rtos (nth 13 RecTxtLst) 2 4)
													(substr (itoa (nth 14 RecTxtLst)) 1 1)
													(substr (itoa (nth 15 RecTxtLst)) 1 1)
													(substr (itoa (nth 16 RecTxtLst)) 1 1)
													(substr (itoa (nth 17 RecTxtLst)) 1 1)
													(nth 18 RecTxtLst)
													(itoa (nth 19 RecTxtLst))
											)
							ColumLst			(list	"} TxtDatatype {"
													"} TxtHandle {"
													"} Adds_Layer_Nam {"
													"} TxtValue {"
													"} Adds_Style {"
													"} TxtNPntX {"
													"} TxtNPntY {"
													"} TxtNPntZ {"
													"} TxtJPntX {"
													"} TxtJPntY {"
													"} TxtJPntZ {"
													"} TxtThick {"
													"} TxtHgt {"
													"} TxtRot {"
													"} TxtSpace {"
													"} TxtFlag {"
													"} TxtHorzFlag {"
													"} TxtVertFlag {"
													"} Device_ID {"
													"} Adds_Panel_ID {"
													
											)
							ModNam			"ADO_PutObjTxt"
							Bubba			(ADO_Mak_CmdObj	(list	OraInst
																	"AddsDb.Ins_ObjTxt"
																	ParamLst
															)
											)
							ConnectionObject	(if Bubba (nth 0 Bubba) nil)
							aCommandObject		(if Bubba (nth 1 Bubba) nil)
							aParameterObject	(if Bubba (nth 2 Bubba) nil)
							ValueCnt	0
					)
					(vlax-invoke-method	ConnectionObject 'BeginTrans)
					(foreach	ValueItm
							ValueLst
							(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
							(vlax-put-property afield 'Value (nth ValueCnt ValueLst))
							(setq	ValueCnt	(1+ ValueCnt))
					)
					;;;***************** Execute *****************
					(vlax-invoke-method aCommandObject "Execute" nil nil nil)
					(setq	ErrObj	(vlax-get-property ConnectionObject 'Errors))
			  		(setq	ErrCnt	(vlax-get-property ErrObj 'Count))
			  		(if (> ErrCnt 0)
						(setq	Bubba	"\nClearing ConnectionObject Errors..."
								ErrItm	(vlax-get-property ErrObj 'Item 0)
								Bubba	(vlax-invoke-method ErrObj 'Clear)
						)
					)
					(setq	afield	(vlax-get-property aParameterObject 'Item ValueCnt))
				  	(setq	fvalue	(vlax-variant-value (vlax-get-property afield 'Value)))
			  		(if (= (substr fvalue 1 5) "FALSE")
						(if (not ErrFnd)
							(setq	ErrFnd	T)
						)
					)
			  		(if (= (substr fvalue 1 5) "FALSE")
					  	(ScLog_PutLin	"Acad_ADO"
									(strcat	"\nError [ " ModNam
											" ] RecCnt {" (itoa RecCnt) 
											(apply (quote strcat) (mapcar (quote (lambda (x y) (strcat x y))) ColumLst ValueLst))
											"}"
									)
						)
					)
					(setq	RecCnt	(1+ RecCnt))
					(vlax-invoke-method	ConnectionObject 'CommitTrans)
					(if (and aParameterObject (null (vlax-object-released-p aParameterObject)))
						(vlax-release-object aParameterObject)
					)
					(setq	aParameterObject		nil)
					(if (and aCommandObject (null (vlax-object-released-p aCommandObject)))
						(vlax-release-object aCommandObject)
					)
					(setq	aCommandObject		nil)
					(setq coState (vlax-get-property ConnectionObject 'State))
					(if (= coState adok-adStateOpen)
						(vlax-invoke-method ConnectionObject "Close")
					)
					(if (and ConnectionObject (null (vlax-object-released-p ConnectionObject)))
						(vlax-release-object ConnectionObject)
					)
					(setq	ConnectionObject	nil
							afield			nil
					)
			)
			(if ErrFnd
			  	(ScLog_PutLin	"Acad_ADO" (strcat "\n  Error: [ " ModNam " ] pushed RecCnt {" (itoa RecCnt) "} records"))
			  	(ScLog_PutLin	"Acad_ADO" (strcat "\nSuccess: [ " ModNam " ] pushed RecCnt {" (itoa RecCnt) "} records"))
			)
		)
		(progn
			(alert (strcat "Exiting - Type Library was Not Loaded: \"" ADO_DLLPath "msado15.dll\""))
			(exit)
		)
	)
	(if ErrFnd
		-1
		RecCnt
	)
)

(defun StpDot ( Str / Cnt TmpStr )			; Strips periods and spaces from string
	(setq	Cnt		1
			TmpStr	"X"
	)
	(while (<= Cnt (strlen Str))
		(if	(not	(or	(= (ascii (substr Str Cnt 1)) 32)
					(= (ascii (substr Str Cnt 1)) 34)
					(= (ascii (substr Str Cnt 1)) 40)
					(= (ascii (substr Str Cnt 1)) 41)
					(= (ascii (substr Str Cnt 1)) 46)
				)
			)
			(setq	TmpStr	(strcat TmpStr (strcase (substr Str Cnt 1))))
		)
		(setq	Cnt		(1+ Cnt))
	)
	(if (> (strlen TmpStr) 1)
		(cond
			((wcmatch (substr TmpStr 2 6) "ADDS19")			;	[CET 2019 - Added for AutoCAD 2019]
				(substr TmpStr 2 4)
			)
			((wcmatch (substr TmpStr 2 6) "ADDS16")			;	[CET 2016 - Added for AutoCAD 2016]
				(substr TmpStr 2 4)
			)
			((wcmatch (substr TmpStr 2 6) "ADDS30")
				(substr TmpStr 2 4)
			)
			((wcmatch (substr TmpStr 2 5) "ADDS#")
				(substr TmpStr 2 6)
			)
			((= (substr TmpStr 2 5) "ADDSP")
				(substr TmpStr 2 8)
			)
			((wcmatch (substr TmpStr 2 5) "BEMS#")
				(substr TmpStr 2 4)
			)
			((wcmatch (substr TmpStr 2 7) "CADET[2]#")
				"CADET20"
			)
			((wcmatch (substr TmpStr 2 7) "CADET[3]#")
				"CADET30"
			)

			((= (substr TmpStr 2 8) "SUBTOOLS")
				(substr TmpStr 2 8)
			)
			(T
				(substr TmpStr 2)
			)
		)
		nil
	)
)

(Acad_ADO_Init)
