(if AppNam                                       ; Code Version Indicator {3456 Lines of Code} [14 functions]
    (princ (strcat "\n" AppNam " OracleFun Loading."))
    (princ "\nCadet 2.1 OracleFun Loading.")
)

(defun ReFormLst ( InpLst InSuff / )             ; ReFormats input lists for AMB_Analysis
    (cond     
              ((= InSuff "007")
                   (setq     CurMstDevLst   (mapcar   (quote    (lambda (x)    (list     (nth 0 x)
                                                                                         (nth 1 x)
                                                                                         (nth 2 x) 
                                                                                         (atoi (nth 3 x))
                                                                               )
                                                                )
                                                      ) 
                                                      InpLst
                                            )
                   )
              )
              ((= InSuff "006")
                   (setq     CurRegDatLst   (mapcar   (quote    (lambda (x)    (list     (nth 0 x)
                                                                                         (nth 1 x)
                                                                                         (nth 2 x) 
                                                                               )
                                                                )
                                                      ) 
                                                      InpLst
                                            )
                   )
              )
              ((= InSuff "004")
                   (setq     CurObjBlkLst   (mapcar   (quote    (lambda (x)    (list     (nth 0 x)
                                                                                         (nth 1 x)
                                                                                         (nth 2 x) 
                                                                                         (atof (nth 3 x))
                                                                                         (atof (nth 4 x))
                                                                                         (atof (nth 5 x))
                                                                                         (atof (nth 6 x))
                                                                                         (atof (nth 7 x))
                                                                                         (atof (nth 8 x))
                                                                                         (atof (nth 9 x))
                                                                                         (atoi (nth 10 x))
                                                                                         (atoi (nth 11 x))
                                                                                         (nth 12 x)
                                                                                         (atoi (nth 13 x))
                                                                               )
                                                                )
                                                      ) 
                                                      InpLst
                                            )
                   )
              )
              ((= InSuff "005")
                   (setq     CurObjAttLst   (mapcar   (quote    (lambda (x)    (list     (nth 0 x)
                                                                                         (nth 1 x)
                                                                                         (nth 2 x) 
                                                                                         (nth 3 x) 
                                                                                         (atof (nth 4 x))
                                                                                         (atof (nth 5 x))
                                                                                         (atof (nth 6 x))
                                                                                         (atof (nth 7 x))
                                                                                         (atof (nth 8 x))
                                                                                         (atof (nth 9 x))
                                                                                         (atof (nth 10 x))
                                                                                         (atof (nth 11 x))
                                                                                         (atof (nth 12 x))
                                                                                         (nth 13 x) 
                                                                                         (atoi (nth 14 x))
                                                                                         (atoi (nth 15 x))
                                                                                         (atoi (nth 16 x))
                                                                                         (atoi (nth 17 x))
                                                                                         (nth 18 x) 
                                                                               )
                                                                )
                                                      ) 
                                                      InpLst
                                            )
                   )
              )
              ((= InSuff "001")
                   (setq     CurObjPL_Lst   (mapcar   (quote    (lambda (x)    (list     (nth 0 x)
                                                                                         (nth 1 x)
                                                                                         (nth 2 x) 
                                                                                         (atof (nth 3 x))
                                                                                         (atof (nth 4 x))
                                                                                         (atof (nth 5 x))
                                                                                         (atoi (nth 6 x))
                                                                                         (atoi (nth 7 x))
                                                                                         (atoi (nth 8 x))
                                                                                         (atoi (nth 9 x))
                                                                                         (atoi (nth 10 x))
                                                                                         (atoi (nth 11 x))
                                                                                         (atoi (nth 12 x))
                                                                                         (atoi (nth 13 x))
                                                                                         (nth 14 x) 
                                                                                         (atoi (nth 15 x))
                                                                               )
                                                                )
                                                      ) 
                                                      InpLst
                                            )
                   )
              )
              ((= InSuff "002")
                   (setq     CurObjVrtLst   (mapcar   (quote    (lambda (x)    (list     (nth 0 x)
                                                                                         (nth 1 x)
                                                                                         (nth 2 x) 
                                                                                         (nth 3 x) 
                                                                                         (atof (nth 4 x))
                                                                                         (atof (nth 5 x))
                                                                                         (atof (nth 6 x))
                                                                                         (atof (nth 7 x))
                                                                                         (atof (nth 8 x))
                                                                                         (atof (nth 9 x))
                                                                                         (atof (nth 10 x))
                                                                                         (atoi (nth 11 x))
                                                                                         (nth 12 x) 
                                                                               )
                                                                )
                                                      ) 
                                                      InpLst
                                            )
                   )
              )
              ((= InSuff "008")
                   (setq     CurObj4PLLst   (mapcar   (quote    (lambda (x)    (list     (nth 0 x)
                                                                                         (atof (nth 1 x))
                                                                                         (atof (nth 2 x))
                                                                                         (atof (nth 3 x))
                                                                                         (atof (nth 4 x))
                                                                                         (atof (nth 5 x))
                                                                                         (atof (nth 6 x))
                                                                                         (atof (nth 7 x))
                                                                                         (atof (nth 8 x))
                                                                                         (atof (nth 9 x))
                                                                                         (atoi (nth 10 x))
                                                                                         (nth 11 x) 
                                                                                         (atoi (nth 12 x))
                                                                                         (nth 13 x) 
                                                                               )
                                                                )
                                                      ) 
                                                      InpLst
                                            )
                   )
              )
              ((= InSuff "003")
                   (setq     CurObjTxtLst   (mapcar   (quote    (lambda (x)    (list     (nth 0 x)
                                                                                         (nth 1 x)
                                                                                         (nth 2 x) 
                                                                                         (nth 3 x) 
                                                                                         (nth 4 x) 
                                                                                         (atof (nth 5 x)) 
                                                                                         (atof (nth 6 x)) 
                                                                                         (atof (nth 7 x)) 
                                                                                         (atof (nth 8 x)) 
                                                                                         (atof (nth 9 x)) 
                                                                                         (atof (nth 10 x)) 
                                                                                         (atof (nth 11 x)) 
                                                                                         (atof (nth 12 x)) 
                                                                                         (atof (nth 13 x)) 
                                                                                         (atoi (nth 14 x)) 
                                                                                         (atoi (nth 15 x)) 
                                                                                         (atoi (nth 16 x)) 
                                                                                         (atoi (nth 17 x)) 
                                                                                         (nth 18 x) 
                                                                                         (atoi (nth 19 x))
                                                                               )
                                                                )
                                                      ) 
                                                      InpLst
                                            )
                   )
              )
              ((= InSuff "077")
                   (setq     CurPlotDevLst  (mapcar   (quote    (lambda (x)    (list     (atoi (nth 0 x))
                                                                                         (strcat "User" (nth 1 x))
                                                                                         (nth 2 x) 
                                                                                         (atoi (nth 3 x))
                                                                                         (atoi (nth 4 x))
                                                                               )
                                                                )
                                                      ) 
                                                      InpLst
                                            )
                   )
              )
    )
)

(defun MyGetPanData ( MyPan_ID / )
    (cond 
         ((OR(= AcadVersion "18.2") (= AcadVersion "20.1") (= AcadVersion "23.0") (= AcadVersion "24.2"))
              (if (null MyGetPanData_2012)            
                   (command "netload" "C:\\Div_Map\\Common\\Adds.dll")
              )
              (MyGetPanData_2012 MyPan_ID)
         )
         (T
              (MyGetPanData_Old MyPan_ID)
         )
    )
)

(defun MyGetPanData_Old ( MyPan_ID /   AcadObj        ; Loads ActiveX MstDevObj pusher
                        MyChkAddsObj CntLstMin inCntMin WellDid CntLstCur inCntMax inCntCur MyElem MyObjLst dBName MyObjCnt )
    (setq     AcadObj        (vlax-get-acad-object)
              MyChkAddsObj   (vla-getinterfaceobject AcadObj "Acad_SCS.SCSB_Adds")
              WellDid        (vlax-put-property MyChkAddsObj 'mthdBcon (cadr MyUsrInfo))
              WellDid        (vlax-put-property MyChkAddsObj 'mthUsrID (caddr MyUsrInfo))
              WellDid        (vlax-put-property MyChkAddsObj 'mthPsWrd (cadddr MyUsrInfo))
              WellDid        (vlax-put-property MyChkAddsObj 'mthRoleS (nth 5 MyUsrInfo))
              WellDid        (vlax-invoke MyChkAddsObj "GetCurOraData" MyPan_ID)
              dBName         (vlax-get-property MyChkAddsObj 'mthdBcon)
              CurMstDevLst   nil  ;007
              CurRegDatLst   nil  ;006
              CurObjBlkLst   nil  ;004
              CurObjAttLst   nil  ;005
              CurObjTxtLst   nil  ;003
              CurObj4PLLst   nil  ;008
              CurObjPL_Lst   nil  ;001
              CurObjVrtLst   nil  ;002
    )
    ;;;**************************************** CurMstDevLst ****************************************
    (setq     inSuffix       "007"
              ModOprNam      "GetCurMstObj"
              CntLstCur      (vlax-invoke MyChkAddsObj "ReadRowCnt" inSuffix)
              inCntMax       (vlax-invoke MyChkAddsObj "ReadPosCnt" inSuffix)
              CntLstMin      0
              inCntMin       0
    )
    (if Bug 
         (if (>= CntLstCur CntLstMin)
              (princ (strcat "\nMyGetPanData :Pulling {" (itoa (1+ CntLstCur)) "} records, to (" ModOprNam "), starting at [" (GetOraDate) "]"))
         )
    )
    (while (>= CntLstCur CntLstMin)
         (setq     inCntCur  inCntMax)
         (while (>= inCntCur inCntMin)
              (if (= inCntCur inCntMax)
                   (setq     MyElem    (list (vlax-invoke MyChkAddsObj "ReadRowElem" CntLstCur inCntCur inSuffix)))
                   (setq     MyElem    (cons (vlax-invoke MyChkAddsObj "ReadRowElem" CntLstCur inCntCur inSuffix) MyElem))
              )
              (setq     inCntCur  (1- inCntCur))
         )
         (if MyObjLst
              (setq     MyObjLst  (cons MyElem MyObjLst))
              (setq     MyObjLst  (list MyElem))
         )
         (setq     CntLstCur (1- CntLstCur))
    )
    (if (and (> (length MyObjLst) 0) (/= (caar MyObjLst) "Test1"))
         (progn
              (ReFormLst MyObjLst inSuffix)                               ;    Creates CurMstDevLst in ReformLst call typ
              (setq     
                        MyObjCnt  (length MyObjLst)
                        MyObjLst  nil
              )
         )
         (setq     MyObjLst  nil)
    )
    ;;;**************************************** CurRegDatLst ****************************************
    (setq     inSuffix  "006"
              ModOprNam "GetCurRegDat"
              CntLstCur (vlax-invoke MyChkAddsObj "ReadRowCnt" inSuffix)
              inCntMax  (vlax-invoke MyChkAddsObj "ReadPosCnt" inSuffix)
              CntLstMin      0
              inCntMin       0
    )
    (if Bug 
         (if (>= CntLstCur CntLstMin)
              (princ (strcat "\nMyGetPanData :Pulling {" (itoa (1+ CntLstCur)) "} records, to (" ModOprNam "), starting at [" (GetOraDate) "]"))
         )
    )
    (while (>= CntLstCur CntLstMin)
         (setq     inCntCur  inCntMax)
         (while (>= inCntCur inCntMin)
              (if (= inCntCur inCntMax)
                   (setq     MyElem    (list (vlax-invoke MyChkAddsObj "ReadRowElem" CntLstCur inCntCur inSuffix)))
                   (setq     MyElem    (cons (vlax-invoke MyChkAddsObj "ReadRowElem" CntLstCur inCntCur inSuffix) MyElem))
              )
              (setq     inCntCur  (1- inCntCur))
         )
         (if MyObjLst
              (setq     MyObjLst  (cons MyElem MyObjLst))
              (setq     MyObjLst  (list MyElem))
         )
         (setq     CntLstCur (1- CntLstCur))
    )
    (if (and (> (length MyObjLst) 0) (/= (caar MyObjLst) "Test1"))
         (progn
              (ReFormLst MyObjLst inSuffix)
              (setq     MyObjLst  nil)
         )
         (setq     MyObjLst  nil)
    )
    ;;;**************************************** CurObjBlkLst ****************************************
    (setq     inSuffix  "004"
              ModOprNam "GetCurObjBlk"
              CntLstCur (vlax-invoke MyChkAddsObj "ReadRowCnt" inSuffix)
              inCntMax  (vlax-invoke MyChkAddsObj "ReadPosCnt" inSuffix)
              CntLstMin      0
              inCntMin       0
    )
    (if Bug 
         (if (>= CntLstCur CntLstMin)
              (princ (strcat "\nMyGetPanData :Pulling {" (itoa (1+ CntLstCur)) "} records, to (" ModOprNam "), starting at [" (GetOraDate) "]"))
         )
    )
    (while (>= CntLstCur CntLstMin)
         (setq     inCntCur  inCntMax)
         (while (>= inCntCur inCntMin)
              (if (= inCntCur inCntMax)
                   (setq     MyElem    (list (vlax-invoke MyChkAddsObj "ReadRowElem" CntLstCur inCntCur inSuffix)))
                   (setq     MyElem    (cons (vlax-invoke MyChkAddsObj "ReadRowElem" CntLstCur inCntCur inSuffix) MyElem))
              )
              (setq     inCntCur  (1- inCntCur))
         )
         (if MyObjLst
              (setq     MyObjLst  (cons MyElem MyObjLst))
              (setq     MyObjLst  (list MyElem))
         )
         (setq     CntLstCur (1- CntLstCur))
    )
    (if (and (> (length MyObjLst) 0) (/= (caar MyObjLst) "Test1"))
         (progn
              (ReFormLst MyObjLst inSuffix)
              (setq     MyObjLst  nil)
         )
         (setq     MyObjLst  nil)
    )
    ;;;**************************************** CurObjAttLst ****************************************
    (setq     inSuffix  "005"
              ModOprNam "GetCurObjAtt"
              CntLstCur (vlax-invoke MyChkAddsObj "ReadRowCnt" inSuffix)
              inCntMax  (vlax-invoke MyChkAddsObj "ReadPosCnt" inSuffix)
              CntLstMin      0
              inCntMin       0
    )
    (if Bug 
         (if (>= CntLstCur CntLstMin)
              (princ (strcat "\nMyGetPanData :Pulling {" (itoa (1+ CntLstCur)) "} records, to (" ModOprNam "), starting at [" (GetOraDate) "]"))
         )
    )
    (while (>= CntLstCur CntLstMin)
         (setq     inCntCur  inCntMax)
         (while (>= inCntCur inCntMin)
              (if (= inCntCur inCntMax)
                   (setq     MyElem    (list (vlax-invoke MyChkAddsObj "ReadRowElem" CntLstCur inCntCur inSuffix)))
                   (setq     MyElem    (cons (vlax-invoke MyChkAddsObj "ReadRowElem" CntLstCur inCntCur inSuffix) MyElem))
              )
              (setq     inCntCur  (1- inCntCur))
         )
         (if MyObjLst
              (setq     MyObjLst  (cons MyElem MyObjLst))
              (setq     MyObjLst  (list MyElem))
         )
         (setq     CntLstCur (1- CntLstCur))
    )
    (if (and (> (length MyObjLst) 0) (/= (caar MyObjLst) "Test1"))
         (progn
              (ReFormLst MyObjLst inSuffix)
              (setq     MyObjLst  nil)
         )
         (setq     MyObjLst  nil)
    )
    ;;;**************************************** CurObjPL_Lst ****************************************
    (setq     inSuffix  "001"
              ModOprNam "GetCurObj_PL"
              CntLstCur (vlax-invoke MyChkAddsObj "ReadRowCnt" inSuffix)
              inCntMax  (vlax-invoke MyChkAddsObj "ReadPosCnt" inSuffix)
              CntLstMin      0
              inCntMin       0
    )
    (if Bug 
         (if (>= CntLstCur CntLstMin)
              (princ (strcat "\nMyGetPanData :Pulling {" (itoa (1+ CntLstCur)) "} records, to (" ModOprNam "), starting at [" (GetOraDate) "]"))
         )
    )
    (while (>= CntLstCur CntLstMin)
         (setq     inCntCur  inCntMax)
         (while (>= inCntCur inCntMin)
              (if (= inCntCur inCntMax)
                   (setq     MyElem    (list (vlax-invoke MyChkAddsObj "ReadRowElem" CntLstCur inCntCur inSuffix)))
                   (setq     MyElem    (cons (vlax-invoke MyChkAddsObj "ReadRowElem" CntLstCur inCntCur inSuffix) MyElem))
              )
              (setq     inCntCur  (1- inCntCur))
         )
         (if MyObjLst
              (setq     MyObjLst  (cons MyElem MyObjLst))
              (setq     MyObjLst  (list MyElem))
         )
         (setq     CntLstCur (1- CntLstCur))
    )
    (if (and (> (length MyObjLst) 0) (/= (caar MyObjLst) "Test1"))
         (progn
              (ReFormLst MyObjLst inSuffix)
              (setq     MyObjLst  nil)
         )
         (setq     MyObjLst  nil)
    )
    ;;;**************************************** CurObjVrtLst ****************************************
    (setq     inSuffix  "002"
              ModOprNam "GetCurObjVrt"
              CntLstCur (vlax-invoke MyChkAddsObj "ReadRowCnt" inSuffix)
              inCntMax  (vlax-invoke MyChkAddsObj "ReadPosCnt" inSuffix)
              CntLstMin      0
              inCntMin       0
    )
    (if Bug 
         (if (>= CntLstCur CntLstMin)
              (princ (strcat "\nMyGetPanData :Pulling {" (itoa (1+ CntLstCur)) "} records, to (" ModOprNam "), starting at [" (GetOraDate) "]"))
         )
    )
    (while (>= CntLstCur CntLstMin)
         (setq     inCntCur  inCntMax)
         (while (>= inCntCur inCntMin)
              (if (= inCntCur inCntMax)
                   (setq     MyElem    (list (vlax-invoke MyChkAddsObj "ReadRowElem" CntLstCur inCntCur inSuffix)))
                   (setq     MyElem    (cons (vlax-invoke MyChkAddsObj "ReadRowElem" CntLstCur inCntCur inSuffix) MyElem))
              )
              (setq     inCntCur  (1- inCntCur))
         )
         (if MyObjLst
              (setq     MyObjLst  (cons MyElem MyObjLst))
              (setq     MyObjLst  (list MyElem))
         )
         (setq     CntLstCur (1- CntLstCur))
    )
    (if (and (> (length MyObjLst) 0) (/= (caar MyObjLst) "Test1"))
         (progn
              (ReFormLst MyObjLst inSuffix)
              (setq     MyObjLst  nil)
         )
         (setq     MyObjLst  nil)
    )
    ;;;**************************************** CurObj4PLLst ****************************************
    (setq     inSuffix  "008"
              ModOprNam "GetCurObj4PL"
              CntLstCur (vlax-invoke MyChkAddsObj "ReadRowCnt" inSuffix)
              inCntMax  (vlax-invoke MyChkAddsObj "ReadPosCnt" inSuffix)
              CntLstMin      0
              inCntMin       0
    )
    (if Bug 
         (if (>= CntLstCur CntLstMin)
              (princ (strcat "\nMyGetPanData :Pulling {" (itoa (1+ CntLstCur)) "} records, to (" ModOprNam "), starting at [" (GetOraDate) "]"))
         )
    )
    (while (>= CntLstCur CntLstMin)
         (setq     inCntCur  inCntMax)
         (while (>= inCntCur inCntMin)
              (if (= inCntCur inCntMax)
                   (setq     MyElem    (list (vlax-invoke MyChkAddsObj "ReadRowElem" CntLstCur inCntCur inSuffix)))
                   (setq     MyElem    (cons (vlax-invoke MyChkAddsObj "ReadRowElem" CntLstCur inCntCur inSuffix) MyElem))
              )
              (setq     inCntCur  (1- inCntCur))
         )
         (if MyObjLst
              (setq     MyObjLst  (cons MyElem MyObjLst))
              (setq     MyObjLst  (list MyElem))
         )
         (setq     CntLstCur (1- CntLstCur))
    )
    (if (and (> (length MyObjLst) 0) (/= (caar MyObjLst) "Test1"))
         (progn
              (ReFormLst MyObjLst inSuffix)
              (setq     MyObjLst  nil)
         )
         (setq     MyObjLst  nil)
    )
    ;;;**************************************** GetCurObjTxt ****************************************
    (setq     inSuffix  "003"
              ModOprNam "GetCurObjTxt"
              CntLstCur (vlax-invoke MyChkAddsObj "ReadRowCnt" inSuffix)
              inCntMax  (vlax-invoke MyChkAddsObj "ReadPosCnt" inSuffix)
              CntLstMin      0
              inCntMin       0
    )
    (if Bug 
         (if (>= CntLstCur CntLstMin)
              (princ (strcat "\nMyGetPanData :Pulling {" (itoa (1+ CntLstCur)) "} records, to (" ModOprNam "), starting at [" (GetOraDate) "]"))
         )
    )
    (while (>= CntLstCur CntLstMin)
         (setq     inCntCur  inCntMax)
         (while (>= inCntCur inCntMin)
              (if (= inCntCur inCntMax)
                   (setq     MyElem    (list (vlax-invoke MyChkAddsObj "ReadRowElem" CntLstCur inCntCur inSuffix)))
                   (setq     MyElem    (cons (vlax-invoke MyChkAddsObj "ReadRowElem" CntLstCur inCntCur inSuffix) MyElem))
              )
              (setq     inCntCur  (1- inCntCur))
         )
         (if MyObjLst
              (setq     MyObjLst  (cons MyElem MyObjLst))
              (setq     MyObjLst  (list MyElem))
         )
         (setq     CntLstCur (1- CntLstCur))
    )
    (if (and (> (length MyObjLst) 0) (/= (caar MyObjLst) "Test1"))
         (progn
              (ReFormLst MyObjLst inSuffix)
              (setq     MyObjLst  nil)
         )
         (setq     MyObjLst  nil)
    )
    (if Bug (princ "\n I am here at pt1"))
    ;;;**************************************** GetCurObjTxt ****************************************
    (if (and MyChkAddsObj (null (vlax-object-released-p MyChkAddsObj)))
         (vlax-release-object MyChkAddsObj)
    )
    (if (and AcadObj (null (vlax-object-released-p AcadObj)))
         (vlax-release-object AcadObj)
    )
    (setq     MyChkAddsObj   nil
              AcadObj   nil
    )
    (if CurMstDevLst
         (setq     MyObjCnt  (length CurMstDevLst))
         (setq     MyObjCnt  0)
    )
    (if (and MyObjCnt MyPan_ID dBName)
         (if Bug (princ (strcat "\nMyGetPanData: (" (itoa MyObjCnt) ") recs, from (" (itoa MyPan_ID) "), in (" dBName "), at (" (GetOraDate) ")")))
    )
    MyObjCnt
)

(defun EMB_Analyze ( Tdata Panel InTim /    Cnt  ; Analyze the Panel SelSet for AddsPlot
                                            MaxRec ints isecs outs osecs elss
                                            EntDatOut BlkDatOutLst )
    (if Bug (princ "\n{ EMB_Analyze entered\n"))
    (if (not XPanel)
         (if (/= Div  "AL")
              (setq     XPanel    6000.0)
              (setq     XPanel    60000.0)
         )
    )
    (if (not YPanel)
         (if (/= Div  "AL")
              (setq     YPanel    4000.0)
              (setq     YPanel    40000.0)
         )
    )
    (if (not Twaddle)
         (LodStage "Utils")
    )
    (if (not JtoC)
         (LodStage "Julian")
    )
    (if BlkDatOutLst
         (princ (strcat "\nRe-Formatting {" (itoa (length BlkDatOutLst)) "} Items..."))
    )
    (if (not Bld_T_Panel)
         (LodStage "Tables")
    )
    (if (not Bld_T_Panel)
         (if (findfile "C:/Div_Map/Common/Tables.Lsp")
              (load "C:/Div_Map/Common/Tables")
         )
    )
    (if (not Lst_Pan_ID)
         (Bld_T_Panel)
    )
    (if (not Lst_Pan_ID)
         (progn
              (alert "*Error*\n{Lst_Pan_ID} not identified in this session\n*Exiting...")
              (quit)
         )
    )
    (setq     Cnt            0
              MaxRec         (sslength Tdata)
              ints           (getvar "date")
              isecs          (* 86400.0 (- ints (fix ints)))
    )
    (princ (strcat "\nAnalyzing Panel {" Panel "} for EMB with {" (itoa MaxRec) "} records: " ))
;;; (if Tdata
;;;      (ChngUm nil Tdata)
;;; )
    (if Tdata
         (while (< Cnt MaxRec)
              (setq     EntDatOut (EntDatLstR (ssname Tdata Cnt)))
              (if EntDatOut       ; was EntDatLstR 
                   (if BlkDatOutLst
                        (setq     BlkDatOutLst   (cons EntDatOut BlkDatOutLst))
                        (setq     BlkDatOutLst   (list EntDatOut))
                   )
                   (princ "\n EMB_Analyze EntDatLstR is nil")
              )
              (if (not Bug)
                   (Twaddle Cnt MaxRec)
                   (princ (strcat "\n[Bug] Working Record:{" (itoa Cnt) "}"))
              )
              (setq     Cnt  (1+ Cnt))
         )
    )
    (if (not Bug)
         (Twaddle (- 0 Cnt) MaxRec)
         (princ (strcat "\n[Bug] Work Complete"))
    )
    (if (not Bug)
         (princ (strcat "\nDone Analyzing Panel {" Panel "} for EMB with {" (itoa (length BlkDatOutLst)) "} EMB records: " ))
    )
    (setq     outs      (getvar "date")
              osecs     (* 86400.0 (- outs (fix outs)))
              elss      (itoa (fix (- (* osecs 1000.0) (* isecs 1000.0))))
    )
    (if TimCode
         (princ (strcat "\nElapsed Milliseconds for [EntDatLstR on TData] = " elss "."))
    )
    (if (and BlkDatOutLst Panel EdCode)
         (setq     EdsBlkOut      BlkDatOutLst)
    )
    (if (and BlkDatOutLst Panel)
         (EMB_DatOut BlkDatOutLst Panel)
    )
    (setq     outs      (getvar "date")
              osecs     (* 86400.0 (- outs (fix outs)))
              elss      (itoa (fix (- (* osecs 1000.0) (* isecs 1000.0))))
    )
    (if TimCode
         (princ (strcat "\nElapsed Milliseconds for [Total] EMB_Analyze: " elss "."))
    )
    (if Bug (princ "\n EMB_Analyze exited}\n"))
    elss
)

(defun InStrLst ( InStr StrLst /  x Cnt1 Cnt2 )  ; Tests contents of StrLst against match from InStr
    (setq     Cnt1      0
              Cnt2      0
              CompLst   (mapcar (quote (lambda (x) (if (wcmatch x InStr) (setq Cnt1 (1+ Cnt1)) (setq Cnt2 (1+ Cnt2))))) StrLst)
    )
    (if (and Bug Cnt1 Cnt2)
         (princ (strcat "\nBug: Cnt1={" (itoa Cnt1) "}, Cnt2={" (itoa Cnt2) "}.\n"))
    )
    (if (> Cnt1 0)
         T
         nil
    )
)

(defun GetOraDate ( /   cdate c y m d c          ; Returns current date in my Oracle Format
                        hh mm ss ORAdate )
    (if (not JtoD)
         (progn
              (setq     LodGet    (LodStage "Julian"))
              (if (and LodGet LodLst)
                   (setq     LodLst    (cons LodGet LodLst))
              )
         )
    )
    (setq     cdate     (JtoD (setq j (getvar "date")))
              c         (fix cdate)
              y         (/ c 10000)              ; Get year
              m         (rem (/ c 100) 100)      ; Get month
              d         (rem c 100)              ; Get day
              c         (- cdate (fix cdate))    ; Strip date from date/time
              c         (fix (* c 1000000000))   ; Scale time to get HHMMSSmmm integer
              hh        (/ c 10000000)           ; Get hours
              mm        (rem (/ c 100000) 100)   ; Get minutes
              ss        (rem (/ c 1000) 100)     ; Get seconds
              msec      (rem c 1000)             ; Get milliseconds
              ORAdate   (strcat   (if (> m 9) "" "0")
                                  (itoa m)
                                  "-"
                                  (if (> d 9) "" "0")
                                  (itoa d)
                                  "-"
                                  (itoa y)
                                  " "
                                  (if (> hh 9) "" "0")
                                  (itoa hh)
                                  ":"
                                  (if (> mm 9) "" "0")
                                  (itoa mm)
                                  ":"
                                  (if (> ss 9) "" "0")
                                  (if (> ss 59) "00" (itoa ss))
                        )
    )
)

(defun GetStorDate ( /  cdate c y m d c          ; Returns current date in my Oracle Format
                        hh mm ss ORAdate )
    (if (not JtoD)
         (progn
              (setq     LodGet    (LodStage "Julian"))
              (if (and LodGet LodLst)
                   (setq     LodLst    (cons LodGet LodLst))
              )
         )
    )
    (setq     cdate     (JtoD (setq j (getvar "date")))
              c         (fix cdate)
              y         (/ c 10000)              ; Get year
              m         (rem (/ c 100) 100)      ; Get month
              d         (rem c 100)              ; Get day
              c         (- cdate (fix cdate))    ; Strip date from date/time
              c         (fix (* c 1000000000))   ; Scale time to get HHMMSSmmm integer
              hh        (/ c 10000000)           ; Get hours
              mm        (rem (/ c 100000) 100)   ; Get minutes
              ss        (rem (/ c 1000) 100)     ; Get seconds
              msec      (rem c 1000)             ; Get milliseconds
              ORAdate   (strcat   (itoa y)
                                  (if (> m 9) "" "0")
                                  (itoa m)
                                  (if (> d 9) "" "0")
                                  (itoa d)
                                  (if (> hh 9) "" "0")
                                  (itoa hh)
                                  (if (> mm 9) "" "0")
                                  (itoa mm)
                                  (if (> ss 9) "" "0")
                                  (itoa ss)
                        )
    )
)

(defun GetClnLst ( /    DatGet InData InpLst )   ; Loads ClnLst and MstrClnLst
    (setq     ClnLst         (list)
              MstrClnLst     (list)
    )
    (if (findfile "C:\\Adds\\ClnLst.txt")
         (setq     DatGet         (open "C:\\Adds\\ClnLst.txt" "r"))
         (setq     DatGet         nil)
    )
    (if DatGet
         (setq     InData    (read-line DatGet))
         (setq     InData    nil)
    )
    (while InData
         (if InData
              (if (= (ascii (substr InData 1 1)) 34)
                   (setq     InpLst    (read InData))
                   (setq     InpLst    nil)
              )
              (setq     InpLst    nil)
         )
         (if InpLst
              (if ClnLst
                   (setq     ClnLst    (cons InpLst ClnLst))
                   (setq     ClnLst    (list ClnLst))
              )
         )
         (if InData
              (setq     InData    (read-line DatGet))
         )
    )
    (if DatGet (close DatGet))
    (if ClnLst
         (setq     ClnLst    (reverse ClnLst))
    )
    (if (not (car ClnLst))
         (setq     ClnLst    (cdr ClnLst))
    )
    (if ClnLst
         (princ (strcat "\nLoaded <" (itoa (length ClnLst)) "> items in ClnLst !"))
    )
    (if (findfile "C:\\Adds\\MstrClnLst.txt")
         (setq     DatGet         (open "C:\\Adds\\MstrClnLst.txt" "r"))
         (setq     DatGet         nil)
    )
    (if DatGet
         (setq     InData    (read-line DatGet))
         (setq     InData    nil)
    )
    (while InData
         (if InData
              (if (= (ascii (substr InData 1 1)) 34)
                   (setq     InpLst    (read (strcat "(" InData ")")))
                   (setq     InpLst    nil)
              )
              (setq     InpLst    nil)
         )
         (if InpLst
              (if MstrClnLst
                   (setq     MstrClnLst     (cons InpLst MstrClnLst))
                   (setq     MstrClnLst     (list MstrClnLst))
              )
         )
         (if InData
              (setq     InData    (read-line DatGet))
         )
    )
    (if DatGet (close DatGet))
    (if MstrClnLst
         (setq     MstrClnLst     (reverse MstrClnLst))
    )
    (if (not (car MstrClnLst))
         (setq     MstrClnLst     (cdr MstrClnLst))
    )
    (if MstrClnLst
         (princ (strcat "\nLoaded <" (itoa (length MstrClnLst)) "> items in MstrClnLst !"))
    )
    (princ)
)

(defun ClnEdsLst ( ClnLst ForceUpd /   ClnItm )  ; Force Updates to Duplicate Unique_ID's!
    (if EdsBlkOut
         (if ForceUpd
              (setq     IdxObjMstLst   (mapcar (quote (lambda (x) (cdr (assoc "ID" (cdr (last x)))))) EdsBlkOut))
              (if (not IdxObjMstLst)
                   (setq     IdxObjMstLst   (mapcar (quote (lambda (x) (cdr (assoc "ID" (cdr (last x)))))) EdsBlkOut))
              )
         )
    )
    (if IdxObjMstLst
         (princ (strcat "\nIndex List is (" (itoa (length IdxObjMstLst)) ") items long."))
    )
    (if ClnLst
         (foreach  ClnItm
                   ClnLst
                   (if (member ClnItm IdxObjMstLst)
                        (setq     PosOut    (- (length IdxObjMstLst) (length (member ClnItm IdxObjMstLst))))
                        (setq     PosOut    nil)
                   )
                   (if PosOut
                        (setq     ClnDat    (nth PosOut EdsBlkOut))
                        (setq     ClnDat    nil)
                   )
                   (if ClnDat
                        (princ (strcat "\nFound object {" ClnItm "}, Header={" (car ClnDat) "}, Handle={" (cadr ClnDat) "}\n"))
                   )
                   (if (handent (cadr ClnDat))
                        (ChngUm T (handent (cadr ClnDat)))
                   )
         )
    )
    (princ)
)

(defun C:EntDat ( /     EntA AttWas              ; Does EntDatLstR on selected entity
                        BlpWas CmdWas ColWas EchWas ExWas FilWas LayWas LtWas OsWas TmdWas )
    (if Bug (princ "\n{ C:EntDat entered}\n"))
    (setq     AttWas    (getvar "ATTREQ")
              BlpWas    (getvar "BLIPMODE")
              CmdWas    (getvar "CMDDIA")
              ColWas    (getvar "CECOLOR")
              EchWas    (getvar "CMDECHO")
              ExWas     (getvar "EXPERT")
              FilWas    (getvar "FILEDIA")
              LayWas    (getvar "CLAYER")
              LtWas     (getvar "CELTYPE")
              OsWas     (getvar "OSMODE")
              TmdWas    (getvar "TILEMODE")
    )
    
    (if (not Bug)
         (progn
              (setvar "ATTREQ" 0)
              (setvar "BLIPMODE" 0)
              (setvar "CELTYPE" "BYLAYER")
              (setvar "CMDDIA" 0)
              (setvar "CMDECHO" 0)
              (setvar "EXPERT" 5)
              (setvar "FILEDIA" 0)
              (setvar "OSMODE" 0)
         )
    )
    (command "_.UNDO" "_BE")
    ;======================
    (setq     EntA      (entsel "\nTouch an EMB object: ")
              GrrDat    nil
    )
    (if EntA
         (setq     GrrDat    (EntDatLstR (car EntA)))
    )
    (if GrrDat
         (if (= (car (last GrrDat)) "XData")
              (if (assoc "ID" (cdr (last GrrDat)))
                   (princ (strcat "\nGrrDat built for object ID = {" (cdr (assoc "ID" (cdr (last GrrDat)))) "}!\n"))
                   (princ (strcat "\nGrrDat built for this object {XData defined, but no ID}!\n"))
              )
              (princ (strcat "\nGrrDat built for this object {No XData defined}!\n"))
         )
         (princ (strcat "\nGrrDat NOT built for this object!\n"))
    )
    ;======================
    (command "_.UNDO" "_EN")
    (setvar "ATTREQ" AttWas)
    (setvar "BLIPMODE" BlpWas)
    (setvar "CMDDIA" CmdWas)
    (setvar "CECOLOR" ColWas)
    (setvar "CMDECHO" EchWas)
    (setvar "EXPERT" ExWas)
    (setvar "FILEDIA" FilWas)
    (setvar "CLAYER" LayWas)
    (setvar "CELTYPE" LtWas)
    (setvar "OSMODE" OsWas)
    (setvar "TILEMODE" TmdWas)
    (if Bug (princ "\n{ C:EntDat exited}\n"))
    (princ)
)

(defun OraLin ( CurNum TotNum ModNum / )         ; Defines status line for Application
    (if Bug (princ "\n{ OraLin entered\n"))
    (setvar   "USERI1" CurNum)
    (setvar   "USERI2" TotNum)
    (setvar   "USERI3" ModNum)
    (if Div
         (setvar "USERS3" Div)
         (setvar "USERS3" "Unk")
    )
    (setvar   "MODEMACRO"
         (strcat
              "Working: $(getvar,USERI1)"
              " of $(getvar,USERI2)"
              ", with $(getvar,USERI3) modified in"
              "  Div: $(getvar,USERS3)"
         )
    )
    (if Bug (princ "\n OraLin exited}\n"))
)

(defun GetCurObjDat ( UniqID LstOL Det SCmp / )  ; Returns Object History in separate Global Lists
    (if LstOfLst
         (setq     CurMstDevLst   (nth 0 LstOL)
                   CurRegDatLst   (nth 1 LstOL)
                   CurObjBlkLst   (nth 2 LstOL)
                   CurObjAttLst   (nth 3 LstOL)
                   CurObjTxtLst   (nth 4 LstOL)
                   CurObj4PLLst   (nth 5 LstOL)
                   CurObjPL_Lst   (nth 6 LstOL)
                   CurObjVrtLst   (nth 7 LstOL)
         )
         (setq     CurMstDevLst   nil
                   CurRegDatLst   nil
                   CurObjBlkLst   nil
                   CurObjAttLst   nil
                   CurObjTxtLst   nil
                   CurObj4PLLst   nil
                   CurObjPL_Lst   nil
                   CurObjVrtLst   nil
         )
    )
    (if (assoc UniqID CurMstDevLst)
         (cond
              ((and (wcmatch (substr UniqID 1 2) "DS") (= Det 0))    ;Block Object itself
                   
              )
         )
         nil
    )
)

(defun GetCurOraData ( Panel /    FN FO Inp )    ; Returns Object History
                                  ;DatPath
                                  ;CurMstDevLst CurRegDatLst CurObjBlkLst CurObjAttLst
                                  ;CurObjTxtLst CurObj4PLLst CurObjPL_Lst CurObjVrtLst
                                  
    (setq     CurMstDevLst   nil  ;007
              CurRegDatLst   nil  ;006
              CurObjBlkLst   nil  ;004
              CurObjAttLst   nil  ;005
              CurObjTxtLst   nil  ;003
              CurObj4PLLst   nil  ;008
              CurObjPL_Lst   nil  ;001
              CurObjVrtLst   nil  ;002
    )
    (if (findfile (strcat _Path-Panel "Data\\" Panel ".007"))
         (setq     DatPath   (strcat _Path-Panel "Data\\"))
         (if (findfile (strcat _Alt_Path-Panel "Data\\" Panel ".007"))
              (setq     DatPath   (strcat _Alt_Path-Panel "Data\\"))
              (setq     DatPath   nil)
         )
    )
    (if DatPath
         (progn
         ;;;  *************************************************************************************************
              (if (findfile (setq FN (strcat DatPath Panel ".007")))
                   (setq     FO             (open FN "r")
                             CurMstDevLst   nil
                   )
                   (setq     FO   nil
                             CurMstDevLst   nil
                   )
              )
              (if FO
                   (setq     Inp            (read-line FO)
                             CurMstDevLst   (list (read (strcat "(" Inp ")")))
                   )
                   (setq     Inp       nil)
              )
              (if Inp
                   (while (setq Inp (read-line FO))
                        (if Inp (setq  CurMstDevLst   (cons (read (strcat "(" Inp ")")) CurMstDevLst)))
                   )
              )
              (if FO
                   (close FO)
              )
              (setq     FO   nil)
         ;;;  *************************************************************************************************
              (if (findfile (setq FN (strcat DatPath Panel ".006")))
                   (setq     FO             (open FN "r")
                             CurRegDatLst   nil
                   )
                   (setq     FO   nil
                             CurRegDatLst   nil
                   )
              )
              (if FO
                   (setq     Inp            (read-line FO)
                             CurRegDatLst   (list (read (strcat "(" Inp ")")))
                   )
                   (setq     Inp       nil)
              )
              (if Inp
                   (while (setq Inp (read-line FO))
                        (if Inp (setq  CurRegDatLst   (cons (read (strcat "(" Inp ")")) CurRegDatLst)))
                   )
              )
              (if FO
                   (close FO)
              )
              (setq     FO   nil)
         ;;;  *************************************************************************************************
              (if (findfile (setq FN (strcat DatPath Panel ".004")))
                   (setq     FO             (open FN "r")
                             CurObjBlkLst   nil
                   )
                   (setq     FO   nil
                             CurObjBlkLst   nil
                   )
              )
              (if FO
                   (setq     Inp            (read-line FO)
                             CurObjBlkLst   (list (read (strcat "(" Inp ")")))
                   )
                   (setq     Inp       nil)
              )
              (if Inp
                   (while (setq Inp (read-line FO))
                        (if Inp (setq  CurObjBlkLst   (cons (read (strcat "(" Inp ")")) CurObjBlkLst)))
                   )
              )
              (if FO
                   (close FO)
              )
              (setq     FO   nil)
         ;;;  *************************************************************************************************
              (if (findfile (setq FN (strcat DatPath Panel ".005")))
                   (setq     FO             (open FN "r")
                             CurObjAttLst   nil
                   )
                   (setq     FO   nil
                             CurObjAttLst   nil
                   )
              )
              (if FO
                   (setq     Inp            (read-line FO)
                             CurObjAttLst   (list (read (strcat "(" Inp ")")))
                   )
                   (setq     Inp       nil)
              )
              (if Inp
                   (while (setq Inp (read-line FO))
                        (if Inp (setq  CurObjAttLst   (cons (read (strcat "(" Inp ")")) CurObjAttLst)))
                   )
              )
              (if FO
                   (close FO)
              )
              (setq     FO   nil)
         ;;;  *************************************************************************************************
              (if (findfile (setq FN (strcat DatPath Panel ".003")))
                   (setq     FO             (open FN "r")
                             CurObjTxtLst   nil
                   )
                   (setq     FO   nil
                             CurObjTxtLst   nil
                   )
              )
              (if FO
                   (setq     Inp            (read-line FO)
                             CurObjTxtLst   (list (read (strcat "(" Inp ")")))
                   )
                   (setq     Inp       nil)
              )
              (if Inp
                   (while (setq Inp (read-line FO))
                        (if Inp (setq  CurObjTxtLst   (cons (read (strcat "(" Inp ")")) CurObjTxtLst)))
                   )
              )
              (if FO
                   (close FO)
              )
              (setq     FO   nil)
         ;;;  *************************************************************************************************
              (if (findfile (setq FN (strcat DatPath Panel ".008")))
                   (setq     FO             (open FN "r")
                             CurObj4PLLst   nil
                   )
                   (setq     FO   nil
                             CurObj4PLLst   nil
                   )
              )
              (if FO
                   (setq     Inp            (read-line FO)
                             CurObj4PLLst   (list (read (strcat "(" Inp ")")))
                   )
                   (setq     Inp       nil)
              )
              (if Inp
                   (while (setq Inp (read-line FO))
                        (if Inp (setq  CurObj4PLLst   (cons (read (strcat "(" Inp ")")) CurObj4PLLst)))
                   )
              )
              (if FO
                   (close FO)
              )
              (setq     FO   nil)
         ;;;  *************************************************************************************************
              (if (findfile (setq FN (strcat DatPath Panel ".001")))
                   (setq     FO             (open FN "r")
                             CurObjPL_Lst   nil
                   )
                   (setq     FO   nil
                             CurObjPL_Lst   nil
                   )
              )
              (if FO
                   (setq     Inp            (read-line FO)
                             CurObjPL_Lst   (list (read (strcat "(" Inp ")")))
                   )
                   (setq     Inp       nil)
              )
              (if Inp
                   (while (setq Inp (read-line FO))
                        (if Inp (setq  CurObjPL_Lst   (cons (read (strcat "(" Inp ")")) CurObjPL_Lst)))
                   )
              )
              (if FO
                   (close FO)
              )
              (setq     FO   nil)
         ;;;  *************************************************************************************************
              (if (findfile (setq FN (strcat DatPath Panel ".002")))
                   (setq     FO             (open FN "r")
                             CurObjVrtLst   nil
                   )
                   (setq     FO   nil
                             CurObjVrtLst   nil
                   )
              )
              (if FO
                   (setq     Inp            (read-line FO)
                             CurObjVrtLst   (list (read (strcat "(" Inp ")")))
                   )
                   (setq     Inp       nil)
              )
              (if Inp
                   (while (setq Inp (read-line FO))
                        (if Inp (setq  CurObjVrtLst   (cons (read (strcat "(" Inp ")")) CurObjVrtLst)))
                   )
              )
              (if FO
                   (close FO)
              )
              (setq     FO   nil)
         )
    )
    (if (and Bug CurMstDevLst) (princ (strcat "\nBug: CurMstDevLst has {" (itoa (length CurMstDevLst)) "} items.\n")))
    (if (and Bug CurRegDatLst) (princ (strcat "\nBug: CurRegDatLst has {" (itoa (length CurRegDatLst)) "} items.\n")))
    (if (and Bug CurObjBlkLst) (princ (strcat "\nBug: CurObjBlkLst has {" (itoa (length CurObjBlkLst)) "} items.\n")))
    (if (and Bug CurObjAttLst) (princ (strcat "\nBug: CurObjAttLst has {" (itoa (length CurObjAttLst)) "} items.\n")))
    (if (and Bug CurObjTxtLst) (princ (strcat "\nBug: CurObjTxtLst has {" (itoa (length CurObjTxtLst)) "} items.\n")))
    (if (and Bug CurObj4PLLst) (princ (strcat "\nBug: CurObj4PLLst has {" (itoa (length CurObj4PLLst)) "} items.\n")))
    (if (and Bug CurObjPL_Lst) (princ (strcat "\nBug: CurObjPL_Lst has {" (itoa (length CurObjPL_Lst)) "} items.\n")))
    (if (and Bug CurObjVrtLst) (princ (strcat "\nBug: CurObjVrtLst has {" (itoa (length CurObjVrtLst)) "} items.\n")))
    (list CurMstDevLst CurRegDatLst CurObjBlkLst CurObjAttLst CurObjTxtLst CurObj4PLLst CurObjPL_Lst CurObjVrtLst)
)

(defun OraDelay ( / )                            ; Delay for 2000 milliseconds
    (setq     curtime   (* (getvar "DATE") 1e8)
              ritardo   2000
    )
    (while (< (* (getvar "DATE") 1e8) (+ curtime ritardo))
    )
)

(defun GetNext_ID ( / )
    (cond
         ((OR (= AcadVersion  "18.2") (= AcadVersion  "20.1") (= AcadVersion "23.0") (= AcadVersion "24.2"))
              (GetNext_ID_2012)
         )
         (T
              (GetNext_ID_Old)
         )
    )
)

(defun GetNext_ID_Old (  /   AcadObj                  ; Loads ActiveX MstDevObj pusher
                        MyChkAddsObj WellDid dBName )
    (if Bug (princ "\nOracleFun.lsp!GetNext_ID - Entered\n"))
    (setq     AcadObj        (vlax-get-acad-object)
              MyChkAddsObj   (vla-getinterfaceobject AcadObj "Acad_SCS.SCSB_Adds")
    )
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthdBcon (cadr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthUsrID (caddr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthPsWrd (cadddr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthRoleS (nth 5 MyUsrInfo)))
    (setq     WellDid   (vlax-invoke MyChkAddsObj "GetNextNum"))
    (setq     dBName    (vlax-get-property MyChkAddsObj 'mthdBcon))
    (if (and MyChkAddsObj (null (vlax-object-released-p MyChkAddsObj)))
         (vlax-release-object MyChkAddsObj)
    )
    (if (and AcadObj (null (vlax-object-released-p AcadObj)))
         (vlax-release-object AcadObj)
    )
    (setq     MyChkAddsObj   nil
              AcadObj   nil
    )
    (if (> WellDid 0)
         (if Bug (princ (strcat "\nGetNext_ID: (" (rtos WellDid 2 0) "), from (" dBName "), at (" (GetOraDate) ")")))
    )
    (if Bug 
         (progn
              (princ "\nOracleFun.lsp!GetNext_ID - Done\n  Return value: ") 
              (prin1 WellDid) 
              (princ "\n")
         )
    )
    WellDid
)

(defun GetNextID ( /    tfile Bubba sid          ; Get Next ID
                        LckFilNam ID_FilNam LogN Lck WaitP )
    (if Bug (princ "\nOracleFun.lsp!GetNextID - Entered\n"))
    (cond
         ((boundp (quote GetNext_ID))
              (setq     sid  (atoi (rtos (GetNext_ID) 2 0)))
         )
         (T
;             (setq     LckFilNam "S:/Workgroups/APC Power Delivery/Division Mapping/Shared Panels/Data/id_file.lck"
;                       ID_FilNam "S:/Workgroups/APC Power Delivery/Division Mapping/Shared Panels/Data/id_file.txt"
              (setq     LckFilNam (strcat RootPathLst "Shared Panels\\Data\\id_file.lck") ;"M:/DivData/Shared Panels/Data/id_file.lck"
                        ID_FilNam (strcat RootPathLst "Shared Panels\\Data\\id_file.txt") ;"M:/DivData/Shared Panels/Data/id_file.txt"
                        LogN      (strcase (getvar "LOGINNAME"))
                        WaitP     nil
              )
              ;If there is a Lock File, wait!
              (if (findfile LckFilNam)
                   (if (not (equal (cdar (dos_filesize LckFilNam)) 0.0 0.1))
                        (while (findfile LckFilNam)
                             (if (not WaitP)
                                  (setq     WaitP     T
                                            rfile     (open (findfile LckFilNam) "r")
                                            Bubba     (princ (strcat "\n" (read-line rfile)))
                                            Bubba     (close rfile)
                                            Bubba     (princ "\nWaiting for Lock Release")
                                  )
                             )
                             (OraDelay)
                             (princ ".")
                        )
                        (while (findfile LckFilNam)
                             (if (not WaitP)
                                  (setq     WaitP     T
                                            Bubba     (princ "\nInvalid Lock File! {Size Zero}")
                                            Bubba     (princ "\nWaiting for Lock Release")
                                  )
                             )
                             (OraDelay)
                             (princ ".")
                        )
                   )
              )
              ;Once there is no lock file, write one!
              (setq     Lck       (open LckFilNam "w"))
              (write-line (strcat "ID File LOCKED on " (date_s) " at " (time_s) " (" LogN ")") lck)
              (close lck)
              ;Get the next number...
              (setq     tfile     (open ID_FilNam "r")
                        sid       (1+ (atoi (read-line tfile)))
                        Bubba     (close tfile)
                        tfile     (open ID_FilNam "w")
                        Bubba     (write-line (itoa sid) tfile)
                        Bubba     (close tfile)
              )
              ;Erase your own lock file!
              (if (findfile LckFilNam)
                   (dos_delete LckFilNam)
              )
         )
    )
    (if Bug 
         (progn
              (princ "\nOracleFun.lsp!GetNextID - Done\n  Return value: ") 
              (prin1 sid) 
              (princ "\n")
         )
    )
    sid
)

(defun EntDatLstR ( ent1 /   en1 EntDatOut en2   ; Virtualized Listing Function
                             ExDat ExDatOut ExDatLst ExDat0 At2 x )
    (setq     en1       (entget ent1 (list "*")))
    (cond
         ((= (cdr (assoc 0 en1)) "INSERT")
              (setq     EntDatOut (list     (cdr (assoc 2 en1))      ;00 BlockName
                                            (cdr (assoc 5 en1))      ;01 Block Handle
                                            (cdr (assoc 8 en1))      ;02 Block Layer
                                            (cdr (assoc 10 en1))     ;03 Block Insertion Point
                                            (cdr (assoc 41 en1))     ;04 Block X-Scale
                                            (cdr (assoc 42 en1))     ;05 Block Y-Scale
                                            (cdr (assoc 43 en1))     ;06 Block Z-Scale
                                            (cdr (assoc 50 en1))     ;07 Block Rotation
                                            (cdr (assoc 67 en1))     ;08 Block Space Mode (0=Model, 1=Paper)
                                            (if (assoc 66 en1)
                                                 (cdr (assoc 66 en1))     ;09 Block Attributes Follow (1=Yes, 0=No)
                                                 0
                                            )
                                  )                                  ;10 Attribute Data (in detail lists)
              )                                                      ;11 X-Data Summary (in reg. application lists)
              (if (= (cdr (assoc 66 en1)) 1)
                   (setq     en2  en1)
              )
              (if (= (cdr (assoc 66 en1)) 1)
                   (while (/= (cdr (assoc 0 en2)) "SEQEND")
                        (if (= (cdr (assoc 0 en2)) "ATTRIB")
                             (if (assoc (cdr (assoc 2 en2)) At2)
                                  (setq     At2  (subst    (cons     (cdr (assoc 2 en2))                          ;0 Attribute Tag
                                                                     (list
                                                                          (StpBadChar (cdr (assoc 1 en2)) 2)      ;1 Attribute Value
                                                                          (cdr (assoc 5 en2))                     ;2 Handle
                                                                          (cdr (assoc 8 en2))                     ;3 Layer
                                                                          (cdr (assoc 10 en2))                    ;4 Normal Insertion Pt
                                                                          (cdr (assoc 11 en2))                    ;5 Justified Insertion Pt
                                                                          (if (null (assoc 39 en2))               ;6 Thickness
                                                                               0.0
                                                                               (cdr (assoc 39 en2))
                                                                          )
                                                                          (cdr (assoc 40 en2))                    ;7 Attribute Height
                                                                          (cdr (assoc 50 en2))                    ;8 Attribute Rotation
                                                                          (cdr (assoc 7 en2))                     ;9 Attribute Style
                                                                          (if (assoc 70 en2)                      ;10 Attribute Flag 1=Invisible, 2=Constant, 4=Verify, 8=Preset
                                                                               (cdr (assoc 70 en2))
                                                                               0
                                                                          )
                                                                          (if (assoc 71 en2)                      ;11 Text Flag 2=Backward, 4=Upside Down
                                                                               (cdr (assoc 71 en2))
                                                                               0
                                                                          )
                                                                          (if (assoc 72 en2)                      ;12 Horiz Flag 0=Left, 1=Center, 2=Right, 3=Aligned, 4=Middle, 5=Fit
                                                                               (cdr (assoc 72 en2))
                                                                               0
                                                                          )
                                                                          (if (assoc 74 en2)                      ;13 Vert Flag 0=Baseline, 1=Bottom, 2=Middle, 3=Top
                                                                               (cdr (assoc 74 en2))
                                                                               0
                                                                          )
                                                                     )
                                                           )
                                                           (assoc (cdr (assoc 2 en2)) At2)
                                                           At2
                                                 )
                                  )
                                  (setq     At2  (append   At2
                                                           (list     (cons     (cdr (assoc 2 en2))                          ;0 Attribute Tag
                                                                               (list
                                                                                    (StpBadChar (cdr (assoc 1 en2)) 2)      ;1 Attribute Value
                                                                                    (cdr (assoc 5 en2))                     ;2 Handle
                                                                                    (cdr (assoc 8 en2))                     ;3 Layer
                                                                                    (cdr (assoc 10 en2))                    ;4 Normal Insertion Pt
                                                                                    (cdr (assoc 11 en2))                    ;5 Justified Insertion Pt
                                                                                    (if (null (assoc 39 en2))               ;6 Thickness
                                                                                         0.0
                                                                                         (cdr (assoc 39 en2))
                                                                                    )
                                                                                    (cdr (assoc 40 en2))                    ;7 Attribute Height
                                                                                    (cdr (assoc 50 en2))                    ;8 Attribute Rotation
                                                                                    (cdr (assoc 7 en2))                     ;9 Attribute Style
                                                                                    (if (assoc 70 en2)                      ;10 Attribute Flag 1=Invisible, 2=Constant, 4=Verify, 8=Preset
                                                                                         (cdr (assoc 70 en2))
                                                                                         0
                                                                                    )
                                                                                    (if (assoc 71 en2)                      ;11 Text Flag 2=Backward, 4=Upside Down
                                                                                         (cdr (assoc 71 en2))
                                                                                         0
                                                                                    )
                                                                                    (if (assoc 72 en2)                      ;12 Horiz Flag 0=Left, 1=Center, 2=Right, 3=Aligned, 4=Middle, 5=Fit
                                                                                         (cdr (assoc 72 en2))
                                                                                         0
                                                                                    )
                                                                                    (if (assoc 74 en2)                      ;13 Vert Flag 0=Baseline, 1=Bottom, 2=Middle, 3=Top
                                                                                         (cdr (assoc 74 en2))
                                                                                         0
                                                                                    )
                                                                               )
                                                                     )
                                                           )
                                                 )
                                  )
                             )
                        )
                        (setq en2 (entget (entnext (cdr (assoc -1 en2))) (list "*")))
                   )
              )
              (if (= (cdr (assoc 66 en1)) 1)
                   (if (and EntDatOut At2)
                        (setq     EntDatOut      (append EntDatOut (list (cons "Attrib" At2))))
                        (setq     EntDatOut      (append EntDatOut (list (cons "Attrib" "None"))))
                   )
                   (setq     EntDatOut      (append EntDatOut (list (cons "Attrib" "None"))))
              )
              (if (assoc -3 en1)
                   (setq     ExDat     (cdr (assoc -3 en1)))
                   (setq     ExDat     nil)
              )
              (if ExDat
                   (setq     ExDatLst  (mapcar (quote car) ExDat)
                             ExDatOut  (mapcar (quote (lambda (x) (cons x "None"))) ExDatLst)
                   )
                   (setq     ExDatOut  nil
                             ExDatLst  nil
                   )
              )
              (if ExDatLst
                   (foreach  ExDat0
                             ExDatLst
                             (if (assoc 1000 (cdr (assoc ExDat0 ExDat)))
                                  (setq     ExDatOut  (subst    (cons     ExDat0
                                                                          (cdr (assoc 1000 (cdr (assoc ExDat0 ExDat))))
                                                                )
                                                                (assoc ExDat0 ExDatOut)
                                                                ExDatOut
                                                      )
                                  )
                             )
                   )
                   (setq     ExDatOut  nil
                             ExDatLst  nil
                   )
              )
              (if ExDatOut
                   (setq     ExDatOut  (cons "XData" ExDatOut))
              )
              (if (and EntDatOut ExDatOut)
                   (setq     EntDatOut      (append EntDatOut (list ExDatOut)))
              )
         )
         ((= (cdr (assoc 0 en1)) "POLYLINE")
              (setq     EntDatOut (list     (cdr (assoc 0 en1))           ;00 PLine DataType
                                            (cdr (assoc 5 en1))           ;01 PLine Handle
                                            (cdr (assoc 8 en1))           ;02 PLine Layer
                                            (if (null (assoc 39 en1))     ;03 PLine Thickness Change ET from en2 to en1
                                                 0.0
                                                 (cdr (assoc 39 en1))
                                            )
                                            (cdr (assoc 40 en1))          ;04 PLine Width Begin
                                            (cdr (assoc 41 en1))          ;05 PLine Width End
                                            (cdr (assoc 66 en1))          ;06 PLine Variable attributes-follow flag
                                            (cdr (assoc 67 en1))          ;07 PLine Space Mode (0=Model, 1=Paper)
                                            (cdr (assoc 70 en1))          ;08 PLine Polyline flag (bit-coded) (1=Closed, 2=Curve-Fit, 4=Spline-Fit...)
                                            (cdr (assoc 71 en1))          ;09 PLine Polygon mesh M vertex count 
                                            (cdr (assoc 72 en1))          ;10 PLine Polygon mesh N vertex count 
                                            (cdr (assoc 73 en1))          ;11 PLine Smooth surface M density
                                            (cdr (assoc 74 en1))          ;12 PLine Smooth surface N density
                                            (cdr (assoc 75 en1))          ;13 PLine Curves and smooth surface type
                                  )
                        VCnt      0
                        At2       nil
              )
              (if (assoc -3 en1)
                   (setq     ExDat     (cdr (assoc -3 en1)))
                   (setq     ExDat     nil)
              )
              (if ExDat
                   (setq     ExDatLst  (mapcar (quote car) ExDat)
                             ExDatOut  (mapcar (quote (lambda (x) (cons x "None"))) ExDatLst)
                   )
                   (setq     ExDatOut  nil
                             ExDatLst  nil
                   )
              )
              (if ExDatLst
                   (foreach  ExDat0
                             ExDatLst
                             (if (assoc 1000 (cdr (assoc ExDat0 ExDat)))
                                  (setq     ExDatOut  (subst    (cons     ExDat0
                                                                          (cdr (assoc 1000 (cdr (assoc ExDat0 ExDat))))
                                                                )
                                                                (assoc ExDat0 ExDatOut)
                                                                ExDatOut
                                                      )
                                  )
                             )
                   )
                   (setq     ExDatOut  nil
                             ExDatLst  nil
                   )
              )
              (if ExDatOut
                   (setq     ExDatOut  (cons "XData" ExDatOut))
              )
              (if (= (cdr (assoc 66 en1)) 1)
                   (setq     en2  en1)
              )
              (if (= (cdr (assoc 66 en1)) 1)
                   (while (/= (cdr (assoc 0 en2)) "SEQEND")
                        (if (= (cdr (assoc 0 en2)) "VERTEX")
                             (if At2
                                  (setq     VCnt (1+ VCnt)
                                            At2  (append   At2
                                                           (list     (cons     (PadNum (itoa VCnt) 3)
                                                                               (list
                                                                                    (cdr (assoc 0 en2))      ;00 PLine DataType
                                                                                    (cdr (assoc 5 en2))      ;01 PLine Handle
                                                                                    (cdr (assoc 8 en2))      ;02 PLine Layer
                                                                                    (cdr (assoc 10 en2))     ;03 PLine Point
                                                                                    (cdr (assoc 40 en2))     ;04 PLine Width Begin
                                                                                    (cdr (assoc 41 en2))     ;05 PLine Width End
                                                                                    (cdr (assoc 42 en2))     ;06 PLine Bulge
                                                                                    (cdr (assoc 50 en2))     ;07 PLine Curve-Fit Tangent direction
                                                                                    (cdr (assoc 70 en2))     ;08 PLine Vertex flags
                                                                               )
                                                                     )
                                                           )
                                                 )
                                  )
                                  (setq     VCnt (1+ VCnt)
                                            At2  (list
                                                           (cons     (PadNum (itoa VCnt) 3)
                                                                     (list
                                                                          (cdr (assoc 0 en2))      ;00 PLine DataType
                                                                          (cdr (assoc 5 en2))      ;01 PLine Handle
                                                                          (cdr (assoc 8 en2))      ;02 PLine Layer
                                                                          (cdr (assoc 10 en2))     ;03 PLine Point
                                                                          (cdr (assoc 40 en2))     ;04 PLine Width Begin
                                                                          (cdr (assoc 41 en2))     ;05 PLine Width End
                                                                          (cdr (assoc 42 en2))     ;06 PLine Bulge
                                                                          (cdr (assoc 50 en2))     ;07 PLine Curve-Fit Tangent direction
                                                                          (cdr (assoc 70 en2))     ;08 PLine Vertex flags
                                                                     )
                                                           )
                                                 )
                                  )
                             )
                        )
                        (setq en2 (entget (entnext (cdr (assoc -1 en2))) (list "*")))
                   )
              )
              (if (= (cdr (assoc 66 en1)) 1)
                   (if (and EntDatOut At2)
                        (setq     EntDatOut      (append EntDatOut (list (cons "Vertices" At2))))
                        (setq     EntDatOut      (append EntDatOut (list (cons "Vertices" "None"))))
                   )
                   (setq     EntDatOut      (append EntDatOut (list (cons "Vertices" "None"))))
              )
              (if (and EntDatOut ExDatOut)
                   (setq     EntDatOut      (append EntDatOut (list ExDatOut)))
              )
         )
         ((= (cdr (assoc 0 en1)) "TEXT")
              (setq     EntDatOut (list     "TEXT"                                  ;00 What it is
                                            (cdr (assoc 5 en1))                     ;01 Text Handle
                                            (cdr (assoc 8 en1))                     ;02 Text Layer
                                            (StpBadChar (cdr (assoc 1 en1)) 2)      ;03 Text Value
                                            (cdr (assoc 7 en1))                     ;04 Text Style
                                            (cdr (assoc 10 en1))                    ;05 Normal Insertion Pt
                                            (cdr (assoc 11 en1))                    ;06 Justified Insertion Pt
                                            (if (null (assoc 39 en1))               ;07 Thickness
                                                 0.0
                                                 (cdr (assoc 39 en1))
                                            )
                                            (cdr (assoc 40 en1))                    ;08 Text Height
                                            (cdr (assoc 50 en1))                    ;09 Text Rotation
                                            (cdr (assoc 67 en1))                    ;10 Text Space Mode (0=Model, 1=Paper)
                                            (cdr (assoc 71 en1))                    ;11 Text Flag 2=Backward, 4=Upside Down
                                            (cdr (assoc 72 en1))                    ;12 Horiz Flag 0=Left, 1=Center, 2=Right, 3=Aligned, 4=Middle, 5=Fit
                                            (cdr (assoc 73 en1))                    ;13 Vert Flag 0=Baseline, 1=Bottom, 2=Middle, 3=Top
                                  )
              )
              (if (assoc -3 en1)
                   (setq     ExDat     (cdr (assoc -3 en1)))
                   (setq     ExDat     nil)
              )
              (if ExDat
                   (setq     ExDatLst  (mapcar (quote car) ExDat)
                             ExDatOut  (mapcar (quote (lambda (x) (cons x "None"))) ExDatLst)
                   )
                   (setq     ExDatOut  nil
                             ExDatLst  nil
                   )
              )
              (if ExDatLst
                   (foreach  ExDat0
                             ExDatLst
                             (if (assoc 1000 (cdr (assoc ExDat0 ExDat)))
                                  (setq     ExDatOut  (subst    (cons     ExDat0
                                                                          (cdr (assoc 1000 (cdr (assoc ExDat0 ExDat))))
                                                                )
                                                                (assoc ExDat0 ExDatOut)
                                                                ExDatOut
                                                      )
                                  )
                             )
                   )
                   (setq     ExDatOut  nil
                             ExDatLst  nil
                   )
              )
              (if ExDatOut
                   (setq     ExDatOut  (cons "XData" ExDatOut))
              )
              (if (and EntDatOut ExDatOut)
                   (setq     EntDatOut      (append EntDatOut (list ExDatOut)))
              )
         )
    )
    (if (null EntDatOut)
         (princ "\n OracleFun.lsp!EntDatLstR - EntDatOut is null \n")
    )
    EntDatOut
)

(defun EMB_DatOut ( BlkDatOutLst Panel /    Cntr ; Main Analyzer of Object Data
                                            EDat XDat NDat ADat ints isecs outs osecs elss ) ;OldCmdDia OldExpert OldFileDia OldNoMutt
    (setq     PLnDatLst      nil  ;Pline Items - One to One
              VrtDatLst      nil  ;Pline Items - Two to Many
              TxtDatLst      nil  ;Text Items - One to One
              BlkDatLst      nil  ;Insert Items - One to One
              AttDatLst      nil  ;Insert Items - Zero to Many
              RegDatLst      nil  ;All Items - One to Many
              Pln4DatLst     nil  ;Pline Items - One to Many
              Cntr           0    ;Starts at Zero
              MstDevLst      nil  ;Nothing to start with...per panel ->ObjMstDevLst is Master Object List from Oracle
              ObjectDiffP    nil  ;Defaults to Unique New Load
              ModiFlg        nil  ;Modified Flag - defaults to nil
              NT_ID          (caddr MyUsrInfo)   ;(StpDot (getvar "LOGINNAME"))
              Mach_ID        (StpDot (getenv "COMPUTERNAME"))
              ModMstDevLst   nil  ;Modified version
              ModRegDatLst   nil  ;Modified version
              ModPln4DatLst  nil  ;Modified version
              ModAttDatLst   nil  ;Modified version
              ModBlkDatLst   nil  ;Modified version
              ModTxtDatLst   nil  ;Modified version
              ModVrtDatLst   nil  ;Modified version
              ModPLnDatLst   nil  ;Modified version
              LstOfLst       nil  ;Return from GetCurOraData
              ObjAccountant  nil  ;List of UniqID's to account for, eh?
              CurMstDevLst   nil  ;Historical version
              CurRegDatLst   nil  ;Historical version
              CurObjBlkLst   nil  ;Historical version
              CurObjAttLst   nil  ;Historical version
              CurObjTxtLst   nil  ;Historical version
              CurObj4PLLst   nil  ;Historical version
              CurObjPL_Lst   nil  ;Historical version
              CurObjVrtLst   nil  ;Historical version
              PanChg_LogLst  nil  ;List to Log Panel Changes
              ModTotCnt      -1
              ObjDiffCnt     0    ;Object Differencing Counter
    )
    (if Panel
         (progn
              (setq     Panel     (strcase Panel)
                        Pan_ID    (cadr (assoc Panel Lst_Pan_ID))
              )
              
              ;    Creates Memory Table in DLL of all DeviceIDs not in the panel being saved for future call CheckMasterDevicesFor passed in deviceID
              (princ (strcat "\n  Getting all Device IDs  at {" (GetOraDate) "}" ))
              (setq     ObjMstDevLst (GetAllMasterDevicesNotInPanel MyUsrInfo Panel))         ; [Added for Trans]
         ;    (setq ObjMstDevLst nil)
              (princ (strcat "\n  Finished getting all Device IDs  at {" (GetOraDate) "}" ))
         )
         (progn
              (alert "*Error*\n{Panel} not identified for this drawing\n*Exiting...")
              (quit)
         )
    )
    (if (or (not Pan_ID) (not _Path-Panel) (not _Alt_Path-Panel))
         (cond
              ((not Pan_ID)
                   (if Panel
                        (alert (strcat "*Error*\n{Pan_ID} not identified for this Panel {" Panel "}\n*Exiting..."))
                        (alert "*Error*\n{Pan_ID} not identified for this Panel\n*Exiting...")
                   )
                   (quit)
              )
              ((not _Path-Panel)
                   (alert "*Error*\n{_Path-Panel} not identified for this Panel\n*Exiting...")
                   (quit)
              )
              ((not _Alt_Path-Panel)
                   (alert "*Error*\n{_Alt_Path-Panel} not identified for this Panel\n*Exiting...")
                   (quit)
              )
         )
    )
    (setq     ints           (getvar "date")
              isecs          (* 86400.0 (- ints (fix ints)))
    )
    
    ;    Populates ObjAccountant, CurMstDevLst, CurRegDatLst, and CurObjxxxLst
    (if MyGetPanData
         (progn
              (princ "\nLoading Object History...")
              (setq     ObjDiffCnt     (MyGetPanData Pan_ID))
              
              (setq     outs      (getvar "date")
                        osecs     (* 86400.0 (- outs (fix outs)))
                        elss      (itoa (fix (- (* osecs 1000.0) (* isecs 1000.0))))
              )
              (if EdCode
                   (princ (strcat "\nElapsed Milliseconds for [ObjDiff setup] = " elss "."))
              )
              
              (if (> ObjDiffCnt 0)
                   (setq     Bubba          (princ "\n ObjDiff is {On} - Object History Found!\n")
                             ObjectDiffP    T
                   )
                   (setq     Bubba          (princ "\n ObjDiff is {Off} - *No* Object History Found!\n")
                             ObjectDiffP    nil
                   )
              )
         )
    )
    (if ObjectDiffP
         (setq     Bubba          (if CurMstDevLst (princ (strcat "\n CurMstDevLst Length={" (itoa (length CurMstDevLst)) "}")) (princ "\n CurMstDevLst Length={0}"))
                   Bubba          (if CurRegDatLst (princ (strcat "\n CurRegDatLst Length={" (itoa (length CurRegDatLst)) "}")) (princ "\n CurRegDatLst Length={0}"))
                   Bubba          (if CurObjBlkLst (princ (strcat "\n CurObjBlkLst Length={" (itoa (length CurObjBlkLst)) "}")) (princ "\n CurObjBlkLst Length={0}"))
                   Bubba          (if CurObjAttLst (princ (strcat "\n CurObjAttLst Length={" (itoa (length CurObjAttLst)) "}")) (princ "\n CurObjAttLst Length={0}"))
                   Bubba          (if CurObjTxtLst (princ (strcat "\n CurObjTxtLst Length={" (itoa (length CurObjTxtLst)) "}")) (princ "\n CurObjTxtLst Length={0}"))
                   Bubba          (if CurObj4PLLst (princ (strcat "\n CurObj4PLLst Length={" (itoa (length CurObj4PLLst)) "}")) (princ "\n CurObj4PLLst Length={0}"))
                   Bubba          (if CurObjPL_Lst (princ (strcat "\n CurObjPL_Lst Length={" (itoa (length CurObjPL_Lst)) "}")) (princ "\n CurObjPL_Lst Length={0}"))
                   Bubba          (if CurObjVrtLst (princ (strcat "\n CurObjVrtLst Length={" (itoa (length CurObjVrtLst)) "}")) (princ "\n CurObjVrtLst Length={0}"))
         )
    )
    (if ObjectDiffP
         (progn         ;Create list IdxObjxxxList of Device ID's
              (if CurObjPL_Lst (setq IdxObjPL_Lst (mapcar (quote (lambda (x) (nth 14 x))) CurObjPL_Lst))                         (setq IdxObjPL_Lst nil))
              (if CurObjVrtLst (setq IdxObjVrtLst (mapcar (quote (lambda (x) (strcat (nth 12 x) "_" (nth 0 x)))) CurObjVrtLst))  (setq IdxObjVrtLst nil))
              (if CurObjTxtLst (setq IdxObjTxtLst (mapcar (quote (lambda (x) (nth 18 x))) CurObjTxtLst))                         (setq IdxObjTxtLst nil))
              (if CurObjBlkLst (setq IdxObjBlkLst (mapcar (quote (lambda (x) (nth 12 x))) CurObjBlkLst))                         (setq IdxObjBlkLst nil))
              (if CurObjAttLst (setq IdxObjAttLst (mapcar (quote (lambda (x) (strcat (nth 18 x) "_" (nth 0 x)))) CurObjAttLst))  (setq IdxObjAttLst nil))
              
              (if CurRegDatLst (setq IdxObjXD_Lst (mapcar (quote (lambda (x) (nth 0 x))) CurRegDatLst))                          (setq IdxObjXD_Lst nil))
              
              (if (> (length CurMstDevLst) 0)
                   (setq     Bubba          (princ (strcat "\n ObjDiff is Accounting for {" (itoa (length CurMstDevLst)) "} previously existing items."))
                             ObjAccountant  (mapcar (quote car) CurMstDevLst)  ;List of UniqID's to account for, eh?
                   )
                   (setq     Bubba          (princ (strcat "\n ObjDiff is Accounting for {0} previously existing items."))
                             ObjAccountant  nil                                ;List of UniqID's to account for, eh?
                   )
              )
              
         )
    )
    (setq     ints           (getvar "date")
              isecs          (* 86400.0 (- ints (fix ints)))
    )
    
    (if (and BlkDatOutLst Pan_ID)
         (foreach  EDat
                   BlkDatOutLst
                   (if (not Bug)
                        (Twaddle Cntr (length BlkDatOutLst))
                        (princ (strcat "\nItem {" (itoa Cntr) "} processing..."))
                   )
                   ;;;*** Pre-Load Test of Data ***
                   (if EDat                                               ;If this item even exists!
                        (if  (and                                              ;Is this item one of my targets?
                                  (wcmatch (car EDat) "[A]###,[A]###[S],POLY*,TEXT*")                             ; Warning do not check for lower case DB will not like correct dwg
                                  (if (and (wcmatch (car EDat) "POLY*") (/= Div "AL")(/= Div "GA"))               ; [Modified for Trans] 
                                       (if (wcmatch (nth 2 EDat) "????CK-???*")
                                            T 
                                            nil
                                       )
                                       T
                                  )
                             )
                             (if (= (type (last EDat)) (quote LIST))                ;Is last item in EDat a list?
                                  (if (= (car (last EDat)) "XData")                      ;Does last item include XData?
                                       (if (assoc "ID" (cdr (last EDat)))                     ;Does it already have an ID?
                                            (setq     UniqID         (cdr (assoc "ID" (cdr (last EDat))))
                                                      PreXtnt        "Y"                      ;Yes:Then that ID is Pre-Existent
                                            )
                                            (setq     Bubba          (ChngUm T (handent (cadr EDat)))
                                                      Bubba          (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} New ID is built! 1a")))
                                                      EDat           (EntDatLstR (handent (cadr EDat)))
                                                      UniqID         (cdr (assoc "ID" (cdr (last EDat))))
                                                      PreXtnt        "N"                      ;No:Then New ID is built
                                            )
                                       )
                                       (setq     Bubba          (ChngUm T (handent (cadr EDat)))
                                                 Bubba          (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} New ID is built! 1b")))
                                                 EDat           (EntDatLstR (handent (cadr EDat)))
                                                 UniqID         (cdr (assoc "ID" (cdr (last EDat))))
                                                 PreXtnt        "N"                      ;No:Then New ID is built
                                       )
                                  )
                                  (setq     Bubba          (ChngUm T (handent (cadr EDat)))
                                            Bubba          (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} New ID is built! 1c")))
                                            EDat           (EntDatLstR (handent (cadr EDat)))
                                            UniqID         (cdr (assoc "ID" (cdr (last EDat))))
                                            PreXtnt        "N"                      ;No:Then New ID is built
                                  )
                             )
                             (setq     UniqID         nil
                                       PreXtnt        "N"                      ;No:Then No ID is desired
                             )
                        )
                        (setq     UniqID         nil
                                  PreXtnt        "N"                      ;No:Then No ID is desired
                        )
                   )
                   ;;;*** Pre-Load Test of Duplication Errors! ***
                   (if (and ClnLst UniqID)
                        (if (member UniqID ClnLst)
                             (if (assoc UniqID MstrClnLst)
                                  (if (/= Pan_ID (cadr (assoc UniqID MstrClnLst)))
                                       (setq     Bubba          (ChngUm T (handent (cadr EDat)))
                                                 Bubba          (princ (strcat "\nClnLst Item {" UniqID "} is duplicated in Pan_ID={" (itoa (cadr (assoc UniqID MstrClnLst))) "} so a New ID is built for this Pan_ID={" (itoa Pan_ID) "}!\n"))
                                                 EDat           (EntDatLstR (handent (cadr EDat)))
                                                 UniqID         (cdr (assoc "ID" (cdr (last EDat))))
                                                 PreXtnt        "N"                      ;No:Then New ID is built
                                       )
                                  )
                                  (setq     Bubba          (ChngUm T (handent (cadr EDat)))
                                            Bubba          (princ (strcat "\nClnLst Item {" UniqID "} was never registered with Oracle, so a New ID is built for this Pan_ID={" (itoa Pan_ID) "}!\n"))
                                            EDat           (EntDatLstR (handent (cadr EDat)))
                                            UniqID         (cdr (assoc "ID" (cdr (last EDat))))
                                            PreXtnt        "N"                      ;No:Then New ID is built
                                  )
                             )
                        )
                   )
                   ;;;*** Pre-Load Test of Uniqueness ***
                   (if UniqID
                        (cond
                             ;Existing Object - Is in AddsDb - Object Differencing
                             (ObjectDiffP
                                  ;Make it Unique if it is not...
                                  (cond
                                       (MstDevLst
                                            (if (member UniqID MstDevLst)                     ;If this is a duplicate...
                                                 (setq     UniqFlg        nil
                                                           Bubba          (if (member UniqID MstDevLst) (princ (strcat "\nDevice_ID {" UniqID "} of type {" (car EDat) "} is not Unique - fixing....\nxx%")))
                                                           Bubba          (ChngUm T (handent (cadr EDat)))
                                                           EDat           (EntDatLstR (handent (cadr EDat)))
                                                           UniqID         (cdr (assoc "ID" (cdr (last EDat))))
                                                           UniqFlg        (if (member UniqID MstDevLst) nil T)
                                                           MstDevLst      (if UniqFlg (cons UniqID MstDevLst) MstDevLst)
                                                           Flagger        "I"
                                                           ChngFlg        nil
                                                           ModiFlg        T
                                                 )
                                                 (if (> (length ObjAccountant) 0)
                                                      (if (member UniqID ObjAccountant)       ;If it is accounted for...
                                                           (setq     ObjAccountant  (RemLst UniqID ObjAccountant)
                                                                     Bubba          (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} Removed from Accountant, added to MstDevLst!")))
                                                                     ChngFlg        T
                                                                     Flagger        "W"
                                                                     MstDevLst      (cons UniqID MstDevLst)
                                                                     UniqFlg        T
                                                                     ModiFlg        T
                                                           )
                                                           (setq     ChngFlg        nil       ;If it is unique...
                                                                     Bubba          (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} is a new Insert, updating it's UniqID...")))
                                                                     Flagger        "I"
                                                                     UniqFlg        nil
                                                                     Bubba          (ChngUm T (handent (cadr EDat)))
                                                                     EDat           (EntDatLstR (handent (cadr EDat)))
                                                                     UniqID         (cdr (assoc "ID" (cdr (last EDat))))
                                                                     UniqFlg        (if (member UniqID MstDevLst) nil T)
                                                                     MstDevLst      (if UniqFlg (cons UniqID MstDevLst) MstDevLst)
                                                                     ModiFlg        T
                                                           )
                                                      )
                                                      (setq     ChngFlg        nil            ;If it is unique (if ObjAccountant is empty, it must me!)...
                                                                Bubba          (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} is a new Insert, updating it's UniqID...")))
                                                                Flagger        "I"
                                                                UniqFlg        nil
                                                                Bubba          (ChngUm T (handent (cadr EDat)))
                                                                EDat           (EntDatLstR (handent (cadr EDat)))
                                                                UniqID         (cdr (assoc "ID" (cdr (last EDat))))
                                                                UniqFlg        (if (member UniqID MstDevLst) nil T)
                                                                MstDevLst      (if UniqFlg (cons UniqID MstDevLst) MstDevLst)
                                                                ModiFlg        T
                                                      )
                                                 )
                                            )
                                       )
                                       (T
                                            (if (> (length ObjAccountant) 0)
                                                 (if (member UniqID ObjAccountant)            ;If it is accounted for (MstDevLst created)...
                                                      (setq     ObjAccountant  (RemLst UniqID ObjAccountant)
                                                                Bubba          (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} Removed from Accountant, MstDevLst created!")))
                                                                ChngFlg        T
                                                                Flagger        "W"
                                                                MstDevLst      (list     UniqID)
                                                                UniqFlg        T
                                                                ModiFlg        T
                                                      )
                                                      (setq     ChngFlg        nil            ;If it is unique (MstDevLst created)...
                                                                Bubba          (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} is a new Insert, updating it's UniqID (MstDevLst created)...")))
                                                                Flagger        "I"
                                                                UniqFlg        nil
                                                                Bubba          (ChngUm T (handent (cadr EDat)))
                                                                EDat           (EntDatLstR (handent (cadr EDat)))
                                                                UniqID         (cdr (assoc "ID" (cdr (last EDat))))
                                                                UniqFlg        T
                                                                MstDevLst      (list     UniqID)
                                                                ModiFlg        T
                                                      )
                                                 )
                                                 (setq     ChngFlg        nil                 ;If it is unique (if ObjAccountant is empty, it must me!) (MstDevLst created?)...
                                                           Bubba          (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} is a new Insert, updating it's UniqID (MstDevLst created, ObjAccountant empty?)...")))
                                                           Flagger        "I"
                                                           UniqFlg        nil
                                                           Bubba          (ChngUm T (handent (cadr EDat)))
                                                           EDat           (EntDatLstR (handent (cadr EDat)))
                                                           UniqID         (cdr (assoc "ID" (cdr (last EDat))))
                                                           UniqFlg        T
                                                           MstDevLst      (list     UniqID)
                                                           ModiFlg        T
                                                 )
                                            )
                                       )
                                  )
                                  ;Compare it to the previous version of UniqID
                                  (if ChngFlg
                                       (cond
                                            ((wcmatch (car EDat) "POLYLINE")
                                                 (if (member UniqID IdxObjPL_Lst)
                                                      (setq     PlnOld    (nth (- (length CurObjPL_Lst) (length (member UniqID IdxObjPL_Lst))) CurObjPL_Lst)
                                                                Bubba     (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} PlnOld found!")))
                                                      )
                                                      (setq     PlnOld    nil
                                                                Bubba     (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} PlnOld (NOT) found!")))
                                                                Flagger   "U"
                                                                Bubba     (if ShwErrOnly (progn(princ (strcat "\nItem {" (itoa Cntr) "} PlnOld (NOT) found!"))))
                                                      )
                                                 )
                                                 (if PlnOld
                                                      (if  (and (wcmatch (nth 0 EDat) (nth 0 PlnOld))                            ;00 Polyline DataType
                                                                (wcmatch (nth 2 EDat) (nth 2 PlnOld))                            ;02 Polyline Layer
                                                                (equal (if (nth 3 EDat) (nth 3 EDat) 0.0) (nth 3 PlnOld) 0.01)   ;03 Polyline Thickness
                                                           ;    (equal (if (nth 4 EDat) (nth 4 EDat) 0.0) (nth 4 PlnOld) 0.01)   ;04 Polyline Width Begin
                                                           ;    (equal (if (nth 5 EDat) (nth 5 EDat) 0.0) (nth 5 PlnOld) 0.01)   ;05 Polyline Width End
                                                                (= (if (nth 6 EDat) (nth 6 EDat) 0) (nth 6 PlnOld))              ;06 Polyline Variable Att-Follow
                                                                (= (if (nth 7 EDat) (nth 7 EDat) 0) (nth 7 PlnOld))              ;07 Polyline Space Mode
                                                                (= (if (nth 8 EDat) (nth 8 EDat) 0) (nth 8 PlnOld))              ;08 Polyline Polyline Flag
                                                                (= (if (nth 9 EDat) (nth 9 EDat) 0) (nth 9 PlnOld))              ;09 Polyline Polygon Mesh M cnt
                                                                (= (if (nth 10 EDat) (nth 10 EDat) 0) (nth 10 PlnOld))           ;10 Polyline Polygon Mesh N cnt
                                                                (= (if (nth 11 EDat) (nth 11 EDat) 0) (nth 11 PlnOld))           ;11 Polyline Smooth Surface M cnt
                                                                (= (if (nth 12 EDat) (nth 12 EDat) 0) (nth 12 PlnOld))           ;12 Polyline Smooth Surface N cnt
                                                                (= (if (nth 13 EDat) (nth 13 EDat) 0) (nth 13 PlnOld))           ;13 Polyline Curve and Smooth surface type
                                                           )
                                                           (setq     ChngFlg        nil       ;It's exactly the Same!
                                                                     Flagger        "X"       ;Just to let ModMstDevLst know the status...
                                                           )
                                                           (setq     Flagger        "U"       ;It's kinda different!
                                                                     Bubba          (if (or ShwCode ShwErrOnly)
                                                                                         (progn
                                                                                              (princ (strcat "\nItem {" (itoa Cntr) "} Updated Polyline data found!"))
                                                                                              (princ "\n PlnOld = ") (prin1 PlnOld) (princ "\n\n EDat = ")(prin1 EDat) (princ "\n")
                                                                                              (princ    (strcat   "\n ShwCode says this about <POLYLINE>:"
                                                                                                             (if (not(wcmatch (nth 0 EDat) (nth 0 PlnOld))) "\n\t 0:\t<DIFF!> DataType" " ")
                                                                                                             (if (not(wcmatch (nth 2 EDat) (nth 2 PlnOld))) "\n\t 2:\t<DIFF!> Layer" "")
                                                                                                             (if (not(equal (if (nth 3 EDat) (nth 3 EDat) 0.0) (nth 3 PlnOld) 0.01)) "\n\t 3:\t<DIFF!> Thickness" " ")  ; This is the one causing the problem first time
                                                                                                        ;    (if (not(equal (if (nth 4 EDat) (nth 4 EDat) 0.0) (nth 4 PlnOld) 0.01)) "\n\t 4:\t<DIFF!> Width Begin" " ")
                                                                                                        ;    (if (not(equal (if (nth 5 EDat) (nth 5 EDat) 0.0) (nth 5 PlnOld) 0.01)) "\n\t 5:\t<DIFF!> Width End" " ")
                                                                                                             (if (not(= (if (nth 6 EDat) (nth 6 EDat) 0) (nth 6 PlnOld))) "\n\t 6:\t<DIFF!> Polyline Variable Att-Follow" " ")
                                                                                                             (if (not(= (if (nth 7 EDat) (nth 7 EDat) 0) (nth 7 PlnOld))) "\n\t 7:\t<DIFF!> Space Mode" " ")
                                                                                                             (if (not(= (if (nth 8 EDat) (nth 8 EDat) 0) (nth 8 PlnOld))) "\n\t 8:\t<DIFF!> Polyline Flag" " ")
                                                                                                             (if (not(= (if (nth 9 EDat) (nth 9 EDat) 0) (nth 9 PlnOld))) "\n\t 9:\t<DIFF!> Mesh M cnt" " ")
                                                                                                             (if (not(= (if (nth 10 EDat) (nth 10 EDat) 0) (nth 10 PlnOld))) "\n\t10:\t<DIFF!> Mesh N cnt" "")
                                                                                                             (if (not(= (if (nth 11 EDat) (nth 11 EDat) 0) (nth 11 PlnOld))) "\n\t11:\t<DIFF!> Smooth Surface M cnt" " ")
                                                                                                             (if (not(= (if (nth 12 EDat) (nth 12 EDat) 0) (nth 12 PlnOld))) "\n\t12:\t<DIFF!> Smooth Surface N cnt" " ")
                                                                                                             (if (not(= (if (nth 13 EDat) (nth 13 EDat) 0) (nth 13 PlnOld))) "\n\t13:\t<DIFF!> Curve and Smooth surface type\n" " ")
                                                                                                             "\n\n"
                                                                                                        )
                                                                                              )
                                                                                         )
                                                                                    )
                                                           )
                                                      )
                                                 )
                                                 (if (= Flagger "X")
                                                      (progn
                                                           (foreach  VrtObj
                                                                     (cdr (nth 14 EDat))
                                                                     (if (member (strcat UniqID "_" (car VrtObj)) IdxObjVrtLst)
                                                                          (setq     VrtOld    (nth (- (length CurObjVrtLst) (length (member (strcat UniqID "_" (car VrtObj)) IdxObjVrtLst))) CurObjVrtLst)
                                                                                    Bubba     (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} VrtOld {" (car VrtObj) "} found!")))
                                                                          )
                                                                          (setq     VrtOld    nil
                                                                                    Bubba     (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} VrtOld (NOT) found!")))
                                                                                    Flagger   "U"
                                                                                    Bubba     (if ShwErrOnly (princ (strcat "\nItem {" (itoa Cntr) "} VrtOld (NOT) found!")))
                                                                          )
                                                                     )
                                                                     (if (and VrtOld (= Flagger "X"))
                                                                          (if  (and (wcmatch (nth 0 VrtObj) (nth 0 VrtOld))                               ;00 Vertex Count
                                                                                    (wcmatch (nth 1 VrtObj) (nth 1 VrtOld))                               ;01 Vertex DataType
                                                                                    (wcmatch (nth 3 VrtObj) (nth 3 VrtOld))                               ;03 Vertex Layer
                                                                                    (equal (car (nth 4 VrtObj)) (nth 4 VrtOld) 0.5)                       ;04 Vertex Point X    was 0.01
                                                                                    (equal (cadr (nth 4 VrtObj)) (nth 5 VrtOld) 0.5)                      ;05 Vertex Point Y
                                                                                    (equal (caddr (nth 4 VrtObj)) (nth 6 VrtOld) 0.5)                     ;06 Vertex Point Z
                                                                                    (equal (if (nth 5 VrtObj) (nth 5 VrtObj) 0.0) (nth 7 VrtOld) 0.01)    ;07 Vertex Width Begin
                                                                                    (equal (if (nth 6 VrtObj) (nth 6 VrtObj) 0.0) (nth 8 VrtOld) 0.01)    ;08 Vertex Width End
                                                                                    (equal (if (nth 7 VrtObj) (nth 7 VrtObj) 0.0) (nth 9 VrtOld) 0.01)    ;09 Vertex Bulge
                                                                                    (equal (if (nth 8 VrtObj) (nth 8 VrtObj) 0.0) (nth 10 VrtOld) 0.01)   ;10 Vertex Curve-Fit Tangent Dir
                                                                                    (= (if (nth 9 VrtObj) (nth 9 VrtObj) 0) (nth 11 VrtOld))              ;11 Vertex Flags
                                                                               )
                                                                               (setq     ChngFlg        nil       ;It's exactly the Same!
                                                                                         Flagger        "X"       ;Just to let ModMstDevLst know the status...
                                                                               )
                                                                               (setq     Flagger        "U"       ;It's kinda different!
                                                                                         Bubba     (if ShwErrOnly 
                                                                                                        (progn
                                                                                                             (princ (strcat "\nItem {" (itoa Cntr) "} Updated Vertex data found!"))
                                                                                                             (princ "\n VrtOld = ") (prin1 VrtOld) (princ "\n\n VrtObj = ")(prin1 VrtObj) (princ "\n")
                                                                                                             (princ    (strcat "\n ShwCode says this about <Vertex>:"
                                                                                                                            (if (not(wcmatch (nth 0 VrtObj) (nth 0 VrtOld))) "\n\t 0:\t<DIFF!> Vertex Count" " ")
                                                                                                                            (if (not(wcmatch (nth 1 VrtObj) (nth 1 VrtOld))) "\n\t 1:\t<DIFF!> Vertex DataType" " ")
                                                                                                                            (if (not(wcmatch (nth 3 VrtObj) (nth 3 VrtOld))) "\n\t 3:\t<DIFF!> Vertex Layer" "")
                                                                                                                            (if (not(equal (car (nth 4 VrtObj)) (nth 4 VrtOld) 0.5)) "\n\t 4:\t<DIFF!> Vertex Point X" " ")
                                                                                                                            (if (not(equal (cadr (nth 4 VrtObj)) (nth 5 VrtOld) 0.5)) "\n\t 5:\t<DIFF!> Vertex Point Y" " ")
                                                                                                                            (if (not(equal (caddr (nth 4 VrtObj)) (nth 6 VrtOld) 0.5)) "\n\t 6:\t<DIFF!> Vertex Point Z" " ")
                                                                                                                            (if (not(equal (if (nth 5 VrtObj) (nth 5 VrtObj) 0.0) (nth 7 VrtOld) 0.01)) "\n\t 7:\t<DIFF!> Vertex Width Begin" " ")
                                                                                                                            (if (not(equal (if (nth 6 VrtObj) (nth 6 VrtObj) 0.0) (nth 8 VrtOld) 0.01)) "\n\t 8:\t<DIFF!> Vertex Width End" " ")
                                                                                                                            (if (not(equal (if (nth 7 VrtObj) (nth 7 VrtObj) 0.0) (nth 9 VrtOld) 0.01)) "\n\t 9:\t<DIFF!> Vertex Bulge" " ")
                                                                                                                            (if (not(equal (if (nth 8 VrtObj) (nth 8 VrtObj) 0.0) (nth 10 VrtOld) 0.01)) "\n\t10:\t<DIFF!> Curve-Fit Tangent" " ")
                                                                                                                            (if (not(= (if (nth 9 VrtObj) (nth 9 VrtObj) 0) (nth 11 VrtOld))) "\n\t11:\t<DIFF!> Vertex Flags" " ")
                                                                                                                            "\n\n"
                                                                                                                       )
                                                                                                             )
                                                                                                        )
                                                                                                   )
                                                                               )
                                                                          )
                                                                     )
                                                           )
                                                           (if (= Div "GA")
                                                                (if (member UniqID IdxObjXD_Lst)
                                                                     (progn         
                                                                          (setq StartLst (- (length IdxObjXD_Lst) (length (member UniqID IdxObjXD_Lst)))
                                                                                count    (length (member UniqID (reverse (member UniqID IdxObjXD_Lst))))
                                                                                index    StartLst
                                                                          )
                                                                          (setq OldXData nil
                                                                                flagDataChanged nil
                                                                          )
                                                                          (repeat count
                                                                               (setq OldXData (append OldXData (list (nth index CurRegDatLst))))
                                                                               (setq index (+ 1 index))
                                                                          )
                                                                          (if (/= (+ (Length OldXData) 1) (- (length (nth 15 EDat)) 1) )   ;    Top level check
                                                                               (progn
                                                                                    (setq     flagDataChanged      "T")
                                                                                    (setq eddat (cdr (nth 15 EDat)))
                                                                                    (princ (strcat "\n PL XData changed for " UniqID))
                                                                                    (princ " OldXData length: ")(prin1 (+ (Length OldXData) 1)) (princ (strcat " New length: " (itoa (length eddat)) " : " ))
                                                                               )
                                                                          ;    (setq eddat (list "XData" (cons "CLR_NUM"  "185") (cons "LINE_ID"  "11") (cons "ID"  "P_100565196")))
                                                                          )
                                                                          (if (not flagDataChanged)     ;    Check CLR_NUM attribute
                                                                               (if (assoc "CLR_NUM" (cdr (nth 15 EDat)))
                                                                                    (progn
                                                                                         (setq     newColor (cdr (assoc "CLR_NUM" (cdr (nth 15 EDat))) ))
                                                                                    ;    (princ "\n newColor: ") (prin1 newColor) (princ " - ")
                                                                                         (setq ETtest OldXData)
                                                                                         
                                                                                         (foreach item ETtest
                                                                                              (if (member "CLR_NUM" item)
                                                                                                   (progn
                                                                                                        (setq oldColor (cadr (member "CLR_NUM" item)))
                                                                                    ;                   (princ " oldColor: ") (prin1 oldColor)
                                                                                                        (if (/= oldColor newColor)
                                                                                                             (progn
                                                                                                                  (princ (strcat "\n Color overide changed for " UniqID " - "))
                                                                                                                  (setq     flagDataChanged      "T")
                                                                                                             )
                                                                                                        )
                                                                                                   )    
                                                                                              )
                                                                                         )
                                                                                         
                                                                                    )
                                                                               )
                                                                                    
                                                                          )
                                                                          (if flagDataChanged
                                                                               (setq     Flagger        "U")
                                                                               (setq     ChngFlg        nil       ;It's exactly the Same!
                                                                                    Flagger        "X"       ;Just to let ModMstDevLst know the status...
                                                                               )
                                                                          )
                                                                     )                        
                                                                )
                                                           )
                                                           
                                                      )
                                                 )
                                            )
                                            ((wcmatch (car EDat) "TEXT")
                                                 (if (member UniqID IdxObjTxtLst)
                                                      (setq     TxtOld    (nth (- (length CurObjTxtLst) (length (member UniqID IdxObjTxtLst))) CurObjTxtLst)
                                                                Bubba     (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} TxtOld found!")))
                                                      )
                                                      (setq     TxtOld    nil
                                                                Bubba     (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} TxtOld (NOT) found!")))
                                                                Flagger   "U"
                                                                Bubba     (if ShwErrOnly (princ (strcat "\nItem {" (itoa Cntr) "} TxtOld (NOT) found!")))
                                                      )
                                                 )
                                                 (if  TxtOld
                                                      (if  (and (wcmatch (nth 0 EDat) (nth 0 TxtOld))                            ;00 Text DataType
                                                                (wcmatch (nth 2 EDat) (nth 2 TxtOld))                            ;02 Text Layer
                                                                (= (nth 3 EDat) (nth 3 TxtOld))                                  ;03 Text Value
                                                                (wcmatch (nth 4 EDat) (nth 4 TxtOld))                            ;04 Text Style
                                                                (if (and (= (nth 12 EDat) 0)(= (nth 13 EDat) 0))                 ; checks to see if current alingment is baseline left justified if so use first alignment point if not use second.
                                                                     (and
                                                                          (equal (car (nth 5 EDat)) (nth 5 TxtOld) 0.01)                   ;05 Text Normal Ins X - First alignment point (in OCS)
                                                                          (equal (cadr (nth 5 EDat)) (nth 6 TxtOld) 0.01)                  ;06 Text Normal Ins Y
                                                                          (equal (caddr (nth 5 EDat)) (nth 7 TxtOld) 0.01)                 ;07 Text Normal Ins Z
                                                                     )
                                                                     (and
                                                                          (equal (car (nth 6 EDat)) (nth 8 TxtOld) 0.01)                   ;08 Text Justified Ins X - Second alignment point (in OCS) (optional)
                                                                          (equal (cadr (nth 6 EDat)) (nth 9 TxtOld) 0.01)                  ;09 Text Justified Ins Y
                                                                          (equal (caddr (nth 6 EDat)) (nth 10 TxtOld) 0.01)                ;10 Text Justified Ins Z
                                                                     )
                                                                )
                                                           ;    (equal (car (nth 5 EDat)) (nth 5 TxtOld) 0.01)                   ;05 Text Normal Ins X
                                                           ;    (equal (cadr (nth 5 EDat)) (nth 6 TxtOld) 0.01)                  ;06 Text Normal Ins Y
                                                           ;    (equal (caddr (nth 5 EDat)) (nth 7 TxtOld) 0.01)                 ;07 Text Normal Ins Z
                                                           ;    (equal (car (nth 6 EDat)) (nth 8 TxtOld) 0.01)                   ;08 Text Justified Ins X
                                                           ;    (equal (cadr (nth 6 EDat)) (nth 9 TxtOld) 0.01)                  ;09 Text Justified Ins Y
                                                           ;    (equal (caddr (nth 6 EDat)) (nth 10 TxtOld) 0.01)                ;10 Text Justified Ins Z
                                                                (equal (if (nth 7 EDat) (nth 7 EDat) 0.0) (nth 11 TxtOld) 0.01)  ;11 Text Thickness
                                                                (equal (if (nth 8 EDat) (nth 8 EDat) 0.0) (nth 12 TxtOld) 0.01)  ;12 Text Height
                                                                (equal (if (nth 9 EDat) (nth 9 EDat) 0.0) (nth 13 TxtOld) 0.01)  ;13 Text Rotation
                                                                (= (if (nth 10 EDat) (nth 10 EDat) 0) (nth 14 TxtOld))           ;14 Text Space Mode
                                                                (= (if (nth 11 EDat) (nth 11 EDat) 0) (nth 15 TxtOld))           ;15 Text Text Flag
                                                                (= (if (nth 12 EDat) (nth 12 EDat) 0) (nth 16 TxtOld))           ;16 Text Horiz Flag
                                                                (= (if (nth 13 EDat) (nth 13 EDat) 0) (nth 17 TxtOld))           ;17 Text Vert Flag
                                                           )
                                                           (setq     ChngFlg        nil       ;It's exactly the Same!
                                                                     Flagger        "X"       ;Just to let ModMstDevLst know the status...
                                                           )
                                                           (setq     Flagger        "U"       ;It's kinda different!
                                                                     Bubba          (if ShwErrOnly 
                                                                                                   (progn
                                                                                                        (princ (strcat "\n\nItem {" (itoa Cntr) "} Updated Text data found!"))
                                                                                                        (princ "\n TxtOld = ") (prin1 TxtOld) (princ "\n\n EDat = ")(prin1 EDat) (princ "\n")          
                                                                                                        (princ    (strcat "\n ShwCode says this about <Text>:"
                                                                                                                       (if (not(wcmatch (nth 0 EDat) (nth 0 TxtOld))) "\n\t 0:\t<DIFF!> DataType" " ")
                                                                                                                       (if (not(wcmatch (nth 2 EDat) (nth 2 TxtOld))) "\n\t 2:\t<DIFF!> Layer" " ")
                                                                                                                       (if (not(= (nth 3 EDat) (nth 3 TxtOld))) "\n\t 3:\t<DIFF!> Text Value" " ")
                                                                                                                       (if (not(wcmatch (nth 4 EDat) (nth 4 TxtOld))) "\n\t 4:\t<DIFF!> Text Value" " ")
                                                                                                                       (if (and (= (nth 12 EDat) 0)(= (nth 13 EDat) 0))
                                                                                                                            (strcat
                                                                                                                                 (if (not(equal (car (nth 5 EDat)) (nth 5 TxtOld) 0.01)) "\n\t 5:\t<DIFF!> Normal Ins X" " ")
                                                                                                                                 (if (not(equal (cadr (nth 5 EDat)) (nth 6 TxtOld) 0.01)) "\n\t 6:\t<DIFF!> Normal Ins Y" " ")
                                                                                                                                 (if (not(equal (caddr (nth 5 EDat)) (nth 7 TxtOld) 0.01)) "\n\t 7:\t<DIFF!> Normal Ins Z" " ")
                                                                                                                            )
                                                                                                                            (strcat
                                                                                                                                 (if (not(equal (car (nth 6 EDat)) (nth 8 TxtOld) 0.01)) "\n\t 8:\t<DIFF!> Justified Ins X" " ")
                                                                                                                                 (if (not(equal (cadr (nth 6 EDat)) (nth 9 TxtOld) 0.01)) "\n\t 9:\t<DIFF!> Justified Ins Y" " ")
                                                                                                                                 (if (not(equal (caddr (nth 6 EDat)) (nth 10 TxtOld) 0.01)) "\n\t10:\t<DIFF!> Justified Ins Z" " ")
                                                                                                                            )
                                                                                                                       )
                                                                                                                       (if (not(equal (if (nth 7 EDat) (nth 7 EDat) 0.0) (nth 11 TxtOld) 0.01)) "\n\t11:\t<DIFF!> Thickness" " ")
                                                                                                                       (if (not(equal (if (nth 8 EDat) (nth 8 EDat) 0.0) (nth 12 TxtOld) 0.01)) "\n\t12:\t<DIFF!> Height" " ")
                                                                                                                       (if (not(equal (if (nth 9 EDat) (nth 9 EDat) 0.0) (nth 13 TxtOld) 0.01)) "\n\t13:\t<DIFF!> Rotation" " ")
                                                                                                                       (if (not(= (if (nth 10 EDat) (nth 10 EDat) 0) (nth 14 TxtOld))) "\n\t14:\t<DIFF!> Space Mode" " ")
                                                                                                                       (if (not(= (if (nth 11 EDat) (nth 11 EDat) 0) (nth 15 TxtOld))) "\n\t15:\t<DIFF!> Text Flag" " ")
                                                                                                                       (if (not(= (if (nth 12 EDat) (nth 12 EDat) 0) (nth 16 TxtOld))) "\n\t16:\t<DIFF!> Horiz Flag" " ")
                                                                                                                       (if (not(= (if (nth 13 EDat) (nth 13 EDat) 0) (nth 17 TxtOld))) "\n\t17:\t<DIFF!> Vert Flag" " ")
                                                                                                                       "\n\n"
                                                                                                                  )
                                                                                                        )
                                                                                                   )
                                                                                    )
                                                           )
                                                      )
                                                 )
                                            )
                                            ((wcmatch (car EDat) "[Aa]###,[Aa]###[Ss]")
                                                 (if (member UniqID IdxObjBlkLst)
                                                      (setq     BlkOld    (nth (- (length CurObjBlkLst) (length (member UniqID IdxObjBlkLst))) CurObjBlkLst)
                                                                Bubba     (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} BlkOld found!")))
                                                      )
                                                      (setq     BlkOld    nil
                                                                Bubba     (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} BlkOld (NOT) found!")))
                                                                Flagger   "U"
                                                                Bubba     (if ShwErrOnly (princ (strcat "\nItem {" (itoa Cntr) "} BlkOld (NOT) found!")))
                                                      )
                                                 )
                                                 (if BlkOld
                                                      (if  (and (wcmatch (nth 0 EDat) (nth 0 BlkOld))                            ;00 BlockName
                                                                (wcmatch (nth 2 EDat) (nth 2 BlkOld))                            ;02 Block Layer
                                                                (equal (car (nth 3 EDat)) (nth 3 BlkOld) 0.01)                   ;03 Block Ins X
                                                                (equal (cadr (nth 3 EDat)) (nth 4 BlkOld) 0.01)                  ;04 Block Ins Y
                                                                (equal (caddr (nth 3 EDat)) (nth 5 BlkOld) 0.01)                 ;05 Block Ins Z
                                                                (equal (if (nth 4 EDat) (nth 4 EDat) 0.0) (nth 6 BlkOld) 0.01)   ;06 Block Scl X
                                                                (equal (if (nth 5 EDat) (nth 5 EDat) 0.0) (nth 7 BlkOld) 0.01)   ;07 Block Scl Y
                                                                (equal (if (nth 6 EDat) (nth 6 EDat) 0.0) (nth 8 BlkOld) 0.01)   ;08 Block Scl Z
                                                                (equal (if (nth 7 EDat) (nth 7 EDat) 0.0) (nth 9 BlkOld) 0.01)   ;09 Block Rot
                                                                (= (if (nth 8 EDat) (nth 8 EDat) 0) (nth 10 BlkOld))             ;10 Block Space Mode
                                                                (= (if (nth 9 EDat) (nth 9 EDat) 0) (nth 11 BlkOld))             ;11 Block Att Follow
                                                           )
                                                           (setq     ChngFlg        nil       ;It's exactly the Same!
                                                                     Flagger        "X"       ;Just to let ModMstDevLst know the status...
                                                           )
                                                           (setq     Flagger        "U"       ;It's kinda different!
                                                                     Bubba          (if ShwErrOnly 
                                                                                                   (progn
                                                                                                        (princ (strcat "\n\nItem {" (itoa Cntr) "} Updated Block data found!"))
                                                                                                        (princ "\n BlkOld = ") (prin1 BlkOld) (princ "\n\n EDat = ")(prin1 EDat) (princ "\n")
                                                                                                        (princ    (strcat "\n ShwCode says this about <Blocks>:"
                                                                                                                       (if (not(wcmatch (nth 0 EDat) (nth 0 BlkOld))) "\n\t 0:\t<DIFF!> BlockName" " ")
                                                                                                                       (if (not(wcmatch (nth 2 EDat) (nth 2 BlkOld))) "\n\t 2:\t<DIFF!> Block Layer" " ")
                                                                                                                       (if (not(equal (car (nth 3 EDat)) (nth 3 BlkOld) 0.01)) "\n\t 3:\t<DIFF!> Block Ins X" " ")
                                                                                                                       (if (not(equal (cadr (nth 3 EDat)) (nth 4 BlkOld) 0.01)) "\n\t 4:\t<DIFF!> Block Ins Y" " ")
                                                                                                                       (if (not(equal (caddr (nth 3 EDat)) (nth 5 BlkOld) 0.01)) "\n\t 5:\t<DIFF!> Block Ins Z" " ")
                                                                                                                       (if (not(equal (if (nth 4 EDat) (nth 4 EDat) 0.0) (nth 6 BlkOld) 0.01)) "\n\t 6:\t<DIFF!> Block Scl X" " ")
                                                                                                                       (if (not(equal (if (nth 5 EDat) (nth 5 EDat) 0.0) (nth 7 BlkOld) 0.01)) "\n\t 7:\t<DIFF!> Block Scl Y" " ")
                                                                                                                       (if (not(equal (if (nth 6 EDat) (nth 6 EDat) 0.0) (nth 8 BlkOld) 0.01)) "\n\t 8:\t<DIFF!> Block Scl Z" " ")
                                                                                                                       (if (not(equal (if (nth 7 EDat) (nth 7 EDat) 0.0) (nth 9 BlkOld) 0.01)) "\n\t 9:\t<DIFF!> Roatation" " ")
                                                                                                                       (if (not(= (if (nth 8 EDat) (nth 8 EDat) 0) (nth 10 BlkOld))) "\n\t10:\t<DIFF!> Space Mode" " ")
                                                                                                                       (if (not(= (if (nth 9 EDat) (nth 9 EDat) 0) (nth 11 BlkOld))) "\n\t11:\t<DIFF!> Att Follow" " ")
                                                                                                                       "\n\n"
                                                                                                                  )
                                                                                                        )
                                                                                                   )
                                                                                    )
                                                                     ETsTestDat     EDat
                                                           )
                                                      )
                                                 )
                                                 (if (= (nth 9 EDat) 1)
                                                      (foreach  AttObj
                                                                (cdr (nth 10 EDat))
                                                                (if (member (strcat UniqID "_" (car AttObj)) IdxObjAttLst)
                                                                     (setq     AttOld    (nth (- (length CurObjAttLst) (length (member (strcat UniqID "_" (car AttObj)) IdxObjAttLst))) CurObjAttLst)
                                                                               Bubba     (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} AttOld {" (car AttObj) "} found!")))
                                                                     )
                                                                     (setq     AttOld    nil
                                                                               Bubba     (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} AttOld (NOT) found!")))
                                                                               Flagger   "U"
                                                                     )
                                                                )
                                                                (if (and AttOld (= Flagger "X"))
                                                                     (if  (and (if (and (= (ascii (nth 0 AttObj)) 35)(= (ascii (nth 0 AttOld)) 35)) T (wcmatch (nth 0 AttObj) (nth 0 AttOld)))              ;00 Attribute Tag
                                                                               (wcmatch (vl-string-trim " " (StpBadChar (nth 1 AttObj) 3)) (vl-string-trim " " (StpBadChar (nth 1 AttOld) 3)) )   ;01 Attribute Value
                                                                               (if (or (= (nth 0 EDat) "A075")(= (nth 0 EDat) "A080")(= (nth 0 EDat) "A081") (= (nth 0 EDat) "A082") 
                                                                                         (= (nth 0 EDat) "A104")(= (nth 0 EDat) "A130")(= (nth 0 EDat) "A150")
                                                                                    ) T (wcmatch (nth 3 AttObj) (nth 3 AttOld))
                                                                               );03 Attribute Layer
                                                                               (if (and (= (nth 12 AttObj) 0)(= (nth 13 AttObj) 0))                  ; checks to see if current alingment is baseline left justified if so use first alignment point if not use second.
                                                                                    (and
                                                                                         (equal (car (nth 4 AttObj)) (nth 4 AttOld) 0.01)                      ;04 Attribute Normal Ins X
                                                                                         (equal (cadr (nth 4 AttObj)) (nth 5 AttOld) 0.01)                     ;05 Attribute Normal Ins Y
                                                                                         (equal (caddr (nth 4 AttObj)) (nth 6 AttOld) 0.01)                    ;06 Attribute Normal Ins Z
                                                                                    )
                                                                                    (and
                                                                                         (equal (car (nth 5 AttObj)) (nth 7 AttOld) 0.01)                      ;07 Attribute Justified Ins X
                                                                                         (equal (cadr (nth 5 AttObj)) (nth 8 AttOld) 0.01)                     ;08 Attribute Justified Ins Y
                                                                                         (equal (caddr (nth 5 AttObj)) (nth 9 AttOld) 0.01)                    ;09 Attribute Justified Ins Z
                                                                                    )
                                                                               )
                                                                               (equal (if (nth 6 AttObj) (nth 6 AttObj) 0.0) (nth 10 AttOld) 0.01)   ;10 Attribute Thickness
                                                                               (equal (if (nth 7 AttObj) (nth 7 AttObj) 0.0) (nth 11 AttOld) 0.01)   ;11 Attribute Height
                                                                               (equal (if (nth 8 AttObj) (nth 8 AttObj) 0.0) (nth 12 AttOld) 0.01)   ;12 Attribute Rotation
                                                                               (wcmatch (nth 9 AttObj) (nth 13 AttOld))                              ;13 Attribute Style
                                                                               (= (if (nth 10 AttObj) (nth 10 AttObj) 0) (nth 14 AttOld))            ;14 Attribute Flag
                                                                               (= (if (nth 11 AttObj) (nth 11 AttObj) 0) (nth 15 AttOld))            ;15 Attribute Text Flag
                                                                               (= (if (nth 12 AttObj) (nth 12 AttObj) 0) (nth 16 AttOld))            ;16 Attribute Horiz Flag
                                                                               (= (if (nth 13 AttObj) (nth 13 AttObj) 0) (nth 17 AttOld))            ;17 Attribute Vert Flag
                                                                          )
                                                                          (setq     ChngFlg        nil       ;It's exactly the Same!
                                                                                    Flagger        "X"       ;Just to let ModMstDevLst know the status...
                                                                          )
                                                                          (setq     Flagger        "U"       ;It's kinda different!
                                                                                    Bubba     (if ShwErrOnly 
                                                                                                   (progn
                                                                                                        (princ (strcat "\n\nItem {" (itoa Cntr) "} Updated Attribute data found! in block: " (nth 0 EDat)))
                                                                                                        (princ "\n AttOld = ") (prin1 AttOld) (princ "\n\n AttObj = ")(prin1 AttObj) (princ "\n")
                                                                                                        (princ    (strcat "\n ShwCode says this about <Attributes>:"
                                                                                                                       (if (not(wcmatch (nth 0 AttObj) (nth 0 AttOld))) "\n\t 0:\t<DIFF!> Attribute Tag" " ")
                                                                                                                       (if (not(wcmatch (nth 1 AttObj) (nth 1 AttOld))) "\n\t 1:\t<DIFF!> Attribute Value" " ")
                                                                                                                       (if (not(wcmatch (nth 3 AttObj) (nth 3 AttOld))) "\n\t 3:\t<DIFF!> Attribute Layer" " ")
                                                                                                                       (if (and (= (nth 12 AttObj) 0)(= (nth 13 AttObj) 0))                  ; checks to see if current alingment is baseline left justified if so use first alignment point if not use second.
                                                                                                                            (strcat
                                                                                                                                 (if (not(equal (car (nth 4 AttObj)) (nth 4 AttOld) 0.01)) "\n\t 4:\t<DIFF!> Normal Ins X" " ")
                                                                                                                                 (if (not(equal (cadr (nth 4 AttObj)) (nth 5 AttOld) 0.01)) "\n\t 5:\t<DIFF!> Normal Ins Y" " ")
                                                                                                                                 (if (not(equal (caddr (nth 4 AttObj)) (nth 6 AttOld) 0.01)) "\n\t 6:\t<DIFF!> Normal Ins Z" " ")
                                                                                                                            )
                                                                                                                            (strcat
                                                                                                                                 (if (not(equal (car (nth 5 AttObj)) (nth 7 AttOld) 0.01)) "\n\t 7:\t<DIFF!> Justified Ins X" " ")
                                                                                                                                 (if (not(equal (cadr (nth 5 AttObj)) (nth 8 AttOld) 0.01)) "\n\t 8:\t<DIFF!> Justified Ins Y" " ")
                                                                                                                                 (if (not(equal (caddr (nth 5 AttObj)) (nth 9 AttOld) 0.01)) "\n\t 9:\t<DIFF!> Justified Ins Z" " ")
                                                                                                                            )
                                                                                                                       )
                                                                                                                       (if (not(equal (if (nth 6 AttObj) (nth 6 AttObj) 0.0) (nth 10 AttOld) 0.01)) "\n\t10:\t<DIFF!> Thickness" " ")
                                                                                                                       (if (not(equal (if (nth 7 AttObj) (nth 7 AttObj) 0.0) (nth 11 AttOld) 0.01)) "\n\t11:\t<DIFF!> Height" " ")
                                                                                                                       (if (not(equal (if (nth 8 AttObj) (nth 8 AttObj) 0.0) (nth 12 AttOld) 0.01)) "\n\t12:\t<DIFF!> Rotation" " ")
                                                                                                                       (if (not(wcmatch (nth 9 AttObj) (nth 13 AttOld))) "\n\t13:\t<DIFF!> Style" " ")
                                                                                                                       (if (not(= (if (nth 10 AttObj) (nth 10 AttObj) 0) (nth 14 AttOld))) "\n\t14:\t<DIFF!> Attribute Flag" " ")
                                                                                                                       (if (not(= (if (nth 11 AttObj) (nth 11 AttObj) 0) (nth 15 AttOld))) "\n\t15:\t<DIFF!> Text Flag" " ")
                                                                                                                       (if (not(= (if (nth 12 AttObj) (nth 12 AttObj) 0) (nth 16 AttOld))) "\n\t16:\t<DIFF!> Horiz Flag" " ")
                                                                                                                       (if (not(= (if (nth 13 AttObj) (nth 13 AttObj) 0) (nth 17 AttOld))) "\n\t17:\t<DIFF!> Vert Flag" " ")
                                                                                                                  )
                                                                                                        )
                                                                                                   )
                                                                                              )
                                                                          )
                                                                     )
                                                                )
                                                      )
                                                 )
                                            )
                                       )
                                  )
                                  ;Flagger for AddsDb
                                  (if (= Flagger "X")
                                       (setq     ModiFlg   nil
                                                 Bubba     (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} ModiFlg set nil - No Changes found! \n")))
                                       )
                                       (if ModMstDevLst
                                            (setq     ModMstDevLst        (cons (list UniqID Flagger) ModMstDevLst)
                                                      ModTotCnt           (1+ ModTotCnt)
                                                      Bubba               (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} ModiFlg set T - {" (itoa ModTotCnt) "} Total Changes found! \n")))
                                            )
                                            (setq     ModMstDevLst        (list (list UniqID Flagger))
                                                      ModTotCnt           (1+ ModTotCnt)
                                                      Bubba               (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} ModiFlg set T - {" (itoa ModTotCnt) "} Total Changes found! \n")))
                                            )
                                       )
                                  )
                             )
                             ;Unique New Object - Not in AddsDb - No Object Differencing
                             (T                                           
                                  (setq flagInObjMstDevLst (CheckMasterDevicesFor UniqID))              ;    [Added for Trans]
                                  (cond
                                       (MstDevLst
                                            (if (or (member UniqID MstDevLst) flagInObjMstDevLst)
                                                 (setq     UniqFlg        nil
                                                           Bubba          (if (member UniqID MstDevLst) 
                                                                               (princ (strcat "\nDevice_ID {" UniqID "} of type {" (car EDat) "} with Handle {" (cadr EDat) "} is not Unique - fixing....\nxx%"))
                                                                               (princ (strcat "\nDevice_ID {" UniqID "} of type {" (car EDat) "} with Handle {" (cadr EDat) "} is not Unique <across panels - 1>\nxx%"))
                                                                          )
                                                           Bubba          (ChngUm T (handent (cadr EDat)))
                                                           EDat           (EntDatLstR (handent (cadr EDat)))
                                                           UniqID         (cdr (assoc "ID" (cdr (last EDat))))
                                                           UniqFlg        (if (member UniqID MstDevLst) nil T)                   ;    [Added for Trans]
                                                           MstDevLst      (if UniqFlg (cons UniqID MstDevLst) MstDevLst)
                                                           ModiFlg        T
                                                           Flagger        "I"
                                                 )
                                                 (setq     MstDevLst      (cons UniqID MstDevLst)
                                                           UniqFlg        T
                                                           ModiFlg        T
                                                           Flagger        "I"
                                                 )
                                            )
                                            (if ModMstDevLst
                                                 (setq     ModMstDevLst        (cons (list UniqID Flagger) ModMstDevLst)
                                                           ModTotCnt           (1+ ModTotCnt)
                                                           Bubba               (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} ModiFlg set T - {" (itoa ModTotCnt) "} Total Changes found!")))
                                                 )
                                                 (setq     ModMstDevLst        (list (list UniqID Flagger))
                                                           ModTotCnt           (1+ ModTotCnt)
                                                           Bubba               (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} ModiFlg set T - {" (itoa ModTotCnt) "} Total Changes found!")))
                                                 )
                                            )
                                       )
                                       (ObjMstDevLst
                                       ;    (if (member UniqID ObjMstDevLst)
                                            (if flagInObjMstDevLst
                                                 (setq     UniqFlg        nil
                                                           Bubba          (if flagInObjMstDevLst (princ (strcat "\nDevice_ID {" UniqID "} of type {" (car EDat) "} with Handle {" (cadr EDat) "} is not Unique <across panels - 2>\nxx%")))    ; [Changed for Trans]
                                                           Bubba          (ChngUm T (handent (cadr EDat)))
                                                           EDat           (EntDatLstR (handent (cadr EDat)))
                                                           UniqID         (cdr (assoc "ID" (cdr (last EDat))))
                                                           UniqFlg        (if (member UniqID MstDevLst) nil T)                   ;    [Added for Trans]
                                                           MstDevLst      (if UniqFlg (list   UniqID) nil)
                                                           ModiFlg        T
                                                           Flagger        "I"
                                                 )
                                                 (setq     MstDevLst      (list     UniqID)
                                                           UniqFlg        T
                                                           ModiFlg        T
                                                           Flagger        "I"
                                                 )
                                            )
                                            (if ModMstDevLst
                                                 (setq     ModMstDevLst        (cons (list UniqID Flagger) ModMstDevLst)
                                                           ModTotCnt           (1+ ModTotCnt)
                                                           Bubba               (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} ModiFlg set T - {" (itoa ModTotCnt) "} Total Changes found!")))
                                                 )
                                                 (setq     ModMstDevLst        (list (list UniqID Flagger))
                                                           ModTotCnt           (1+ ModTotCnt)
                                                           Bubba               (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} ModiFlg set T - {" (itoa ModTotCnt) "} Total Changes found!")))
                                                 )
                                            )
                                       )
                                       (T
                                            (setq     MstDevLst      (list     UniqID)
                                                      UniqFlg        T
                                                      ModiFlg        T
                                                      Flagger        "I"
                                            )
                                            (if ModMstDevLst
                                                 (setq     ModMstDevLst        (cons (list UniqID Flagger) ModMstDevLst)
                                                           ModTotCnt           (1+ ModTotCnt)
                                                           Bubba               (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} ModiFlg set T - {" (itoa ModTotCnt) "} Total Changes found!")))
                                                 )
                                                 (setq     ModMstDevLst        (list (list UniqID Flagger))
                                                           ModTotCnt           (1+ ModTotCnt)
                                                           Bubba               (if ShwCode (princ (strcat "\nItem {" (itoa Cntr) "} ModiFlg set T - {" (itoa ModTotCnt) "} Total Changes found!")))
                                                 )
                                            )
                                       )
                                  )
                             )
                        )
                   )
                   ;;;*** Loading Registered Application Data per Valid Object ***
                   (if (and UniqID UniqFlg)
                        (foreach  XDat
                                  (cdr (last EDat))
                                ; (if (not (member (strcase (car XDat)) (list "LINE_ID" "ID" "PLANT_ID")))
                                  (if (not (member (strcase (car XDat)) (list "ID")))
                                       (progn
                                            (setq     RegDat    (list     UniqID         ;RegApp Unique ID
                                                                          (car XDat)     ;RegApp AppNam
                                                                          (cdr XDat)     ;RegApp AppData
                                                                )
                                            )
                                            (if RegDatLst
                                                 (setq     RegDatLst (cons RegDat RegDatLst))
                                                 (setq     RegDatLst (list RegDat))
                                            )
                                       )
                                  )
                        )
                   )
                   (if (and UniqID ModiFlg)
                        (foreach  XDat
                                  (cdr (last EDat))
                                  ;    (if (not (member (strcase (car XDat)) (list "LINE_ID" "ID" "PLANT_ID")))
                                  (if (not (member (strcase (car XDat)) (list "ID")))
                                       (progn
                                            (setq     RegDat    (list     UniqID         ;RegApp Unique ID
                                                                          (car XDat)     ;RegApp AppNam
                                                                          (cdr XDat)     ;RegApp AppData
                                                                )
                                            )
                                            (if ModRegDatLst
                                                 (setq     ModRegDatLst   (cons RegDat ModRegDatLst))
                                                 (setq     ModRegDatLst   (list RegDat))
                                            )
                                       )
                                  )
                        )
                   )
                   ;;;*** Loading All Other Data per Valid Object Type ***
                   (if (and UniqID UniqFlg)
                        (cond
                             ((and (wcmatch (car EDat) "POLYLINE") (nth 4 (cadr (nth 14 EDat))))
                                  ;;;************************** PolyLine Entity Handling **************************
                                  (setq     NDat      nil
                                            PLnDat    (list     (nth 0 EDat)             ;00 Polyline DataType
                                                                (nth 1 EDat)             ;01 Polyline Handle
                                                                (nth 2 EDat)             ;02 Polyline Layer
                                                                (nth 3 EDat)             ;03 Polyline Thickness
                                                                (nth 4 EDat)             ;04 Polyline Width Begin
                                                                (nth 5 EDat)             ;05 Polyline Width End
                                                                (nth 6 EDat)             ;06 Polyline Variable Att-Follow
                                                                (nth 7 EDat)             ;07 Polyline Space Mode
                                                                (nth 8 EDat)             ;08 Polyline Polyline Flag
                                                                (nth 9 EDat)             ;09 Polyline Polygon Mesh M cnt
                                                                (nth 10 EDat)            ;10 Polyline Polygon Mesh N cnt
                                                                (nth 11 EDat)            ;11 Polyline Smooth Surface M cnt
                                                                (nth 12 EDat)            ;12 Polyline Smooth Surface N cnt
                                                                (nth 13 EDat)            ;13 Polyline Curve and Smooth surface type
                                                                UniqID                   ;14 Unique ID
                                                                Pan_ID                   ;15 Panel Name
                                                      )
                                            Pln4Hdr   (list     (nth 4 EDat)             ;03 Polyline Width Begin
                                                                (nth 2 EDat)             ;02 Polyline Layer
                                                      )
                                            Pln4Dat   Pln4Hdr
                                            Cnt4      0
                                            NCntR     0
                                  )
                                  (if PLnDatLst
                                       (setq     PLnDatLst (cons PLnDat PLnDatLst))
                                       (setq     PLnDatLst (list PLnDat))
                                  )
                                  (if ModiFlg
                                       (if ModPLnDatLst
                                            (setq     ModPLnDatLst   (cons PLnDat ModPLnDatLst)
                                                      ModPln4Cntr    (length Pln4DatLst)
                                            )
                                            (setq     ModPLnDatLst   (list PLnDat)
                                                      ModPln4Cntr    (length Pln4DatLst)
                                            )
                                       )
                                  )
                                  (if (= (nth 6 EDat) 1)
                                       (foreach  NDat
                                                 (cdr (nth 14 EDat))
                                                 (setq     VrtDat    (list     (nth 0 NDat)             ;00 Vertex Count
                                                                               (nth 1 NDat)             ;01 Vertex DataType
                                                                               (nth 2 NDat)             ;02 Vertex Handle
                                                                               (nth 3 NDat)             ;03 Vertex Layer
                                                                               (car (nth 4 NDat))       ;04 Vertex Point X
                                                                               (cadr (nth 4 NDat))      ;05 Vertex Point Y
                                                                               (caddr (nth 4 NDat))     ;06 Vertex Point Z
                                                                               (nth 5 NDat)             ;07 Vertex Width Begin
                                                                               (nth 6 NDat)             ;08 Vertex Width End
                                                                               (nth 7 NDat)             ;09 Vertex Bulge
                                                                               (nth 8 NDat)             ;10 Vertex Curve-Fit Tangent Dir
                                                                               (nth 9 NDat)             ;11 Vertex Flags
                                                                               UniqID                   ;12 Unique ID
                                                                     )
                                                 )
                                                 (if (> NCntR 0)
                                                      (if BlgDat
                                                           ;If this pair is a curve (Bulge <> 0)
                                                           (setq     Pln4Dat        (list     (nth 3 VrtDat)           ;00 Pln4Pnt Layer
                                                                                              (if (>= (nth 7 VrtDat) 1.0)
                                                                                                   (nth 7 VrtDat)      ;01 Pln4Pnt Width
                                                                                                   1.0
                                                                                              )
                                                                                              (car (nth 3 BlgDat))     ;02 Pln4Pnt PntX1
                                                                                              (cadr (nth 3 BlgDat))    ;03 Pln4Pnt PntY1
                                                                                              (nth 0 BlgDat)           ;04 Pln4Pnt PntX2
                                                                                              (nth 0 BlgDat)           ;05 Pln4Pnt PntY2
                                                                                              (nth 1 BlgDat)           ;06 Pln4Pnt PntX3
                                                                                              (nth 2 BlgDat)           ;07 Pln4Pnt PntY3
                                                                                              0.0                      ;08 Pln4Pnt PntX4
                                                                                              0.0                      ;09 Pln4Pnt PntY4
                                                                                              3                        ;10 Pln4Pnt Point_Cnt
                                                                                              UniqID                   ;11 Pln4Pnt Device_ID
                                                                                              Pan_ID                   ;12 Pln4Pnt Adds_Panel_ID
                                                                                              (PadNum (itoa NCntR) 3)  ;13 Pln4Pnt Segment Count
                                                                                    )
                                                                     Pln4DatLst     (if Pln4DatLst (cons Pln4Dat Pln4DatLst) (list Pln4Dat))
                                                                     ModPln4DatLst  (if ModiFlg
                                                                                         (if ModPln4DatLst
                                                                                              (setq     ModPln4DatLst  (cons Pln4Dat ModPln4DatLst))
                                                                                              (setq     ModPln4DatLst  (list Pln4Dat))
                                                                                         )
                                                                                         (if ModPln4DatLst
                                                                                              (setq     ModPln4DatLst  ModPln4DatLst)
                                                                                              (setq     ModPln4DatLst  nil)
                                                                                         )
                                                                                    )
                                                           )
                                                           ;If this pair is a line segment (Bulge = 0)
                                                           (setq     Pln4Dat        (list     (nth 3 VrtDat)           ;00 Pln4Pnt Layer
                                                                                              (nth 7 VrtDat)           ;01 Pln4Pnt Width
                                                                                              PlnX                     ;02 Pln4Pnt PntX1
                                                                                              PlnY                     ;03 Pln4Pnt PntY1
                                                                                              (car (nth 4 NDat))       ;04 Pln4Pnt PntX2
                                                                                              (cadr (nth 4 NDat))      ;05 Pln4Pnt PntY2
                                                                                              0.0                      ;06 Pln4Pnt PntX3
                                                                                              0.0                      ;07 Pln4Pnt PntY3
                                                                                              0.0                      ;08 Pln4Pnt PntX4
                                                                                              0.0                      ;09 Pln4Pnt PntY4
                                                                                              2                        ;10 Pln4Pnt Point_Cnt
                                                                                              UniqID                   ;11 Pln4Pnt Device_ID
                                                                                              Pan_ID                   ;12 Pln4Pnt Adds_Panel_ID
                                                                                              (PadNum (itoa NCntR) 3)  ;13 Pln4Pnt Segment Count
                                                                                    )
                                                                     Pln4DatLst     (if Pln4DatLst (cons Pln4Dat Pln4DatLst) (list Pln4Dat))
                                                                     ModPln4DatLst  (if ModiFlg
                                                                                         (if ModPln4DatLst
                                                                                              (setq     ModPln4DatLst  (cons Pln4Dat ModPln4DatLst))
                                                                                              (setq     ModPln4DatLst  (list Pln4Dat))
                                                                                         )
                                                                                         (if ModPln4DatLst
                                                                                              (setq     ModPln4DatLst  ModPln4DatLst)
                                                                                              (setq     ModPln4DatLst  nil)
                                                                                         )
                                                                                    )
                                                           )
                                                      )
                                                 )
                                                 (if (and (not (equal (nth 7 NDat) 0.0 0.001)) (/= (1+ NCntR) (length (cdr (nth 14 EDat)))))
                                                      (setq     BlgDat    (CalcBlgDat    (list (car (nth 4 NDat)) (cadr (nth 4 NDat)))
                                                                                         (list (car (nth 4 (nth (1+ NCntR) (cdr (nth 14 EDat))))) (cadr (nth 4 (nth (1+ NCntR) (cdr (nth 14 EDat))))))
                                                                                         (nth 7 NDat)
                                                                          )
                                                                PlnX      (car (nth 4 NDat))
                                                                PlnY      (cadr (nth 4 NDat))
                                                                Pln4Dat   nil
                                                                NCntR     (1+ NCntR)
                                                      )
                                                      (setq     BlgDat    nil
                                                                PlnX      (car (nth 4 NDat))
                                                                PlnY      (cadr (nth 4 NDat))
                                                                Pln4Dat   nil
                                                                NCntR     (1+ NCntR)
                                                      )
                                                 )
                                                 (if VrtDat
                                                      (if (car VrtDat)
                                                           (if VrtDatLst
                                                                (setq     VrtDatLst (cons VrtDat VrtDatLst))
                                                                (setq     VrtDatLst (list VrtDat))
                                                           )
                                                      )
                                                 )
                                                 (if ModiFlg
                                                      (if VrtDat
                                                           (if (car VrtDat)
                                                                (if ModVrtDatLst
                                                                     (setq     ModVrtDatLst   (cons VrtDat ModVrtDatLst))
                                                                     (setq     ModVrtDatLst   (list VrtDat))
                                                                )
                                                           )
                                                      )
                                                 )
                                       )
                                  )
                             )
                             ((wcmatch (car EDat) "TEXT")
                                  ;;;************************** Text Entity Handling **************************
                                  (setq     TxtDat    (list     (nth 0 EDat)             ;00 Text DataType
                                                                (nth 1 EDat)             ;01 Text Handle
                                                                (nth 2 EDat)             ;02 Text Layer
                                                                (nth 3 EDat)             ;03 Text Value
                                                                (nth 4 EDat)             ;03 Text Style
                                                                (car (nth 5 EDat))       ;04 Text Normal Ins X
                                                                (cadr (nth 5 EDat))      ;05 Text Normal Ins Y
                                                                (caddr (nth 5 EDat))     ;06 Text Normal Ins Z
                                                                (car (nth 6 EDat))       ;07 Text Justified Ins X
                                                                (cadr (nth 6 EDat))      ;08 Text Justified Ins Y
                                                                (caddr (nth 6 EDat))     ;09 Text Justified Ins Z
                                                                (nth 7 EDat)             ;10 Text Thickness
                                                                (nth 8 EDat)             ;11 Text Height
                                                                (nth 9 EDat)             ;12 Text Rotation
                                                                (nth 10 EDat)            ;14 Text Space Mode
                                                                (nth 11 EDat)            ;15 Text Text Flag
                                                                (nth 12 EDat)            ;16 Text Horiz Flag
                                                                (nth 13 EDat)            ;17 Text Vert Flag
                                                                UniqID                   ;18 Unique ID
                                                                Pan_ID                   ;19 Panel Name
                                                      )
                                  )
                                  (if TxtDatLst
                                       (setq     TxtDatLst (cons TxtDat TxtDatLst))
                                       (setq     TxtDatLst (list TxtDat))
                                  )
                                  (if ModiFlg
                                       (if ModTxtDatLst
                                            (setq     ModTxtDatLst   (cons TxtDat ModTxtDatLst))
                                            (setq     ModTxtDatLst   (list TxtDat))
                                       )
                                  )
                             )
                             ((wcmatch (car EDat) "[Aa]###,[Aa]###[Ss]")
                                  ;;;************************** Insert Entity Handling **************************
                                  (setq     BlkDat    (list     (nth 0 EDat)             ;00 BlockName
                                                                (nth 1 EDat)             ;01 Block Handle
                                                                (nth 2 EDat)             ;02 Block Layer
                                                                (car (nth 3 EDat))       ;03 Block Ins X
                                                                (cadr (nth 3 EDat))      ;04 Block Ins Y
                                                                (caddr (nth 3 EDat))     ;05 Block Ins Z
                                                                (nth 4 EDat)             ;06 Block Scl X
                                                                (nth 5 EDat)             ;07 Block Scl Y
                                                                (nth 6 EDat)             ;08 Block Scl Z
                                                                (nth 7 EDat)             ;09 Block Rot
                                                                (nth 8 EDat)             ;10 Block Space Mode
                                                                (nth 9 EDat)             ;11 Block Att Follow
                                                                UniqID                   ;12 Unique ID
                                                                Pan_ID                   ;13 Panel Name
                                                      )
                                  )
                                  (if BlkDatLst
                                       (setq     BlkDatLst (cons BlkDat BlkDatLst))
                                       (setq     BlkDatLst (list BlkDat))
                                  )
                                  (if ModiFlg
                                       (if ModBlkDatLst
                                            (setq     ModBlkDatLst   (cons BlkDat ModBlkDatLst))
                                            (setq     ModBlkDatLst   (list BlkDat))
                                       )
                                  )
                                  (if (= (nth 9 EDat) 1)
                                       (foreach  ADat
                                                 (cdr (nth 10 EDat))
                                                 (setq     AttDat    (list     (nth 0 ADat)                       ;00 Attribute Tag
                                                                               (StpBadChar (nth 1 ADat) 2)        ;01 Attribute Value
                                                                               (nth 2 ADat)                       ;02 Attribute Handle
                                                                               (nth 3 ADat)                       ;03 Attribute Layer
                                                                               (car (nth 4 ADat))                 ;04 Attribute Normal Ins X
                                                                               (cadr (nth 4 ADat))                ;05 Attribute Normal Ins Y
                                                                               (caddr (nth 4 ADat))               ;06 Attribute Normal Ins Z
                                                                               (car (nth 5 ADat))                 ;07 Attribute Justified Ins X
                                                                               (cadr (nth 5 ADat))                ;08 Attribute Justified Ins Y
                                                                               (caddr (nth 5 ADat))               ;09 Attribute Justified Ins Z
                                                                               (nth 6 ADat)                       ;10 Attribute Thickness
                                                                               (nth 7 ADat)                       ;11 Attribute Height
                                                                               (nth 8 ADat)                       ;12 Attribute Rotation
                                                                               (nth 9 ADat)                       ;13 Attribute Style
                                                                               (nth 10 ADat)                      ;14 Attribute Flag
                                                                               (nth 11 ADat)                      ;15 Attribute Text Flag
                                                                               (nth 12 ADat)                      ;16 Attribute Horiz Flag
                                                                               (nth 13 ADat)                      ;17 Attribute Vert Flag
                                                                               UniqID                             ;18 Attribute 
                                                                     )
                                                 )
;;;                                              (if (= (strcase (nth 0 ADat)) "LOC_NUM")
;;;                                                   (setq     RegDat    (list     UniqID                        ;RegApp Unique ID
;;;                                                                                 "OPERPTNUM"                   ;RegApp AppNam
;;;                                                                                 (StpBadChar (nth 1 ADat) 2)   ;RegApp AppData
;;;                                                                       )
;;;                                                             RegDatLst (cons RegDat RegDatLst)
;;;                                                   )
;;;                                              )
                                                 (if AttDatLst
                                                      (setq     AttDatLst (cons AttDat AttDatLst))
                                                      (setq     AttDatLst (list AttDat))
                                                 )
                                                 (if ModiFlg
                                                      (if ModAttDatLst
                                                           (setq     ModAttDatLst   (cons AttDat ModAttDatLst))
                                                           (setq     ModAttDatLst   (list AttDat))
                                                      )
                                                 )
                                       )
                                  )
                             )
                        )
                   )
                   (setq     Cntr (1+ Cntr))
         )
    )
    (if (and BlkDatOutLst (not ShwCode))
         (Twaddle (* -1 Cntr) (length BlkDatOutLst))
    )
    (setq     outs      (getvar "date")
              osecs     (* 86400.0 (- outs (fix outs)))
              elss      (itoa (fix (- (* osecs 1000.0) (* isecs 1000.0))))
    )
    (if ModMstDevLst
         (princ (strcat "\nModifying ModMstDevLst {" (itoa (length ModMstDevLst)) "} items at {" (GetOraDate) "}"))
    )
    (setq     outs      (getvar "date")
              osecs     (* 86400.0 (- outs (fix outs)))
              elss      (itoa (fix (- (* osecs 1000.0) (* isecs 1000.0))))
              ORAdate   (if GrpOraDate GrpOraDate (GetOraDate))
    )
    (if ModMstDevLst
         (setq ModMstDevLst (mapcar (quote (lambda (x) (append x (list OraDate)))) ModMstDevLst))
    )
    (if ModMstDevLst
         (setq ModMstDevLst (mapcar (quote (lambda (x) (append x (list Pan_ID)))) ModMstDevLst))
    )
    (if ModMstDevLst
         (if ObjectDiffP
              (if ObjAccountant
                   (foreach  MDat
                             ModMstDevLst
                             (setq     ObjAccountant  (cons (car MDat) ObjAccountant))
                   )
                   (setq     ObjAccountant  (mapcar (quote car) ModMstDevLst))
              )
         )
    )
    (if EdCode
         (setq     EdCode    nil)
    )
    (if (or ObjectDiffP ModMstDevLst)
         (if (not EdCode)
              (progn
                   (setq     PanChg_FdrCntLst    (GetLayLst "???[OU]CK-###*"))
                   (if PanChg_FdrCntLst
                        (setq     PanChg_SubLst  (list (substr (car PanChg_FdrCntLst) 1 2)))
                   )
                   (if PanChg_FdrCntLst
                        (foreach  PanChg_LayNam
                                  PanChg_FdrCntLst
                                  (if (not (member (substr PanChg_LayNam 1 2) PanChg_SubLst))
                                       (setq     PanChg_SubLst  (cons (substr PanChg_LayNam 1 2) PanChg_SubLst))
                                  )
                        )
                   )
                   (setq     PanChg_LogLst  (list     (list     (PadCharL (if Div Div "__") 2)                              ;00 DIVNAM
                                                      (if Panel Panel "0000000")                                            ;01 PANELNAM
                                                      (PadCharL (if MyScl MyScl "NoSc") 4)                                  ;02 SCLBLK
                                                      (length PanChg_SubLst)                                                ;03 FDRCKTS
                                                      (if NT_ID NT_ID "********")                                           ;04 NT_ID
                                                      (if elss (atoi elss ) 0)                                              ;05 ADDSUP_MS
                                                      (if InTim (atoi InTim ) 0)                                            ;06 BRKPAN_MS
                                                      (if ORADate (PadCharL ORADate 19) "09-11-2002 23:59:59")              ;07 LOADED_DTM
                                            )
                                       )
                   )
                   (if PanChg_LogLst
                        (setq     myBigLst  (list PanChg_LogLst))
                   )
              )
         )
    )
    (if (and ObjAccountant (not EdCode))
         (setq     myBigLst  (append myBigLst (list ObjAccountant)))
         (setq     myBigLst  (append myBigLst (list nil)))
    )
    (if (and ModMstDevLst (not EdCode))
         (setq     bub9      (mapcar (quote (lambda (x) (list (nth 0 x) (nth 2 x) (nth 1 x) (itoa (nth 3 x))))) ModMstDevLst)
                   myBigLst  (append myBigLst (list bub9))
         )
         (setq     myBigLst  (append myBigLst (list nil)))
    )
    (if (and ModRegDatLst (not EdCode))
         (setq     myBigLst  (append myBigLst (list ModRegDatLst)))
         (setq     myBigLst  (append myBigLst (list nil)))
    )
    (if (and ModBlkDatLst (not EdCode))
         (setq     myBigLst  (append myBigLst (list ModBlkDatLst)))
         (setq     myBigLst  (append myBigLst (list nil)))
    )
    (if (and ModAttDatLst (not EdCode))
         (setq     myBigLst  (append myBigLst (list ModAttDatLst)))
         (setq     myBigLst  (append myBigLst (list nil)))
    )
    (if (and ModPLnDatLst (not EdCode))
         (setq     myBigLst  (append myBigLst (list ModPLnDatLst)))
         (setq     myBigLst  (append myBigLst (list nil)))
    )
    (if (and ModVrtDatLst (not EdCode))
         (setq     myBigLst  (append myBigLst (list ModVrtDatLst)))
         (setq     myBigLst  (append myBigLst (list nil)))
    )
    (if (and ModPln4DatLst (not EdCode))
         (setq     myBigLst  (append myBigLst (list ModPln4DatLst)))
         (setq     myBigLst  (append myBigLst (list nil)))
    )
    (if (and ModTxtDatLst (not EdCode))
         (setq     myBigLst  (append myBigLst (list ModTxtDatLst)))
         (setq     myBigLst  (append myBigLst (list nil)))
    )
    (if (= (length myBigLst) 10)
         (princ (strcat "\nStarting  Push=>AddsDb {" (itoa (length ModMstDevLst)) "} items at {" (GetOraDate) "}"))
    )
    (setq     Bug  T)
    (if (= (length myBigLst) 10)
         (MyNewPanObj myBigLst)
    )
    (if Bug
         (setq     Bug  nil)
    )
    (setq EdsTest myBigLst)
    (if (= (length myBigLst) 10)
         (princ (strcat "\nCompleted Push=>AddsDb {" (itoa (length ModMstDevLst)) "} items at {" (GetOraDate) "}"))
    )
    (if (and AppNam AppMode)
         (SetLin AppNam AppMode)
    )
    (princ)
)

(defun MyChkDev_ID_Obj (                         ; Checks to see if selected Object exists in AddsDb
                        myOperPt_Num                  ; Input OperPt_Num (switch number)
                        myFeeder_Num                  ; Input Feeder_Num (feeder number)
                        myBlk_Nam                     ; Input Block Name (switch type)
                        / )
    (cond 
         ((OR(= AcadVersion "18.2") (= AcadVersion "20.1") (= AcadVersion "23.0") (= AcadVersion "24.2"))
              (if (null MyChkDev_ID_Obj_2012)              
                   (command "netload" "C:\\Div_Map\\Common\\Adds.dll")
              )
              (MyChkDev_ID_Obj_2012 myOperPt_Num myFeeder_Num myBlk_Nam)
         )
         (T
              (MyChkDev_ID_Obj_Old  myOperPt_Num myFeeder_Num myBlk_Nam)
         )
    )
)

(defun MyChkDev_ID_Obj_Old (                     ; Checks to see if selected Object exists in AddsDb
                        myOperPt_Num                  ; Input OperPt_Num (switch number)
                        myFeeder_Num                  ; Input Feeder_Num (feeder number)
                        myBlk_Nam                     ; Input Block Name (switch type)
                        /    AcadObj MyChkAddsObj WellDid dBName )
    (setq     AcadObj        (vlax-get-acad-object)
              MyChkAddsObj   (vla-getinterfaceobject AcadObj "Acad_SCS.SCSB_Adds")
    )
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthdBcon (cadr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthUsrID (caddr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthPsWrd (cadddr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthRoleS (nth 5 MyUsrInfo)))
    (setq     WellDid   (vlax-invoke MyChkAddsObj "ChkDev_ID_Exist" myOperPt_Num myFeeder_Num myBlk_Nam))
    (setq     dBName    (vlax-get-property MyChkAddsObj 'mthdBcon))
    (if (and MyChkAddsObj (null (vlax-object-released-p MyChkAddsObj)))
         (vlax-release-object MyChkAddsObj)
    )
    (if (and AcadObj (null (vlax-object-released-p AcadObj)))
         (vlax-release-object AcadObj)
    )
    (setq     MyChkAddsObj   nil
              AcadObj   nil
    )
    (if (= WellDid -1)
         (if Bug (princ (strcat "\nMyChkDevObj: to (" dBName "), at (" (GetOraDate) ")")))
    )
    WellDid
)

(defun MyChkDevDescObj (                         ; Checks to see if selected Object exists in AddsDb
                        myDevice_ID                   ; Input Device_ID
                        /    AcadObj MyChkAddsObj WellDid dBName )
    (setq     AcadObj        (vlax-get-acad-object)
              MyChkAddsObj   (vla-getinterfaceobject AcadObj "Acad_SCS.SCSB_Adds")
    )
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthdBcon (cadr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthUsrID (caddr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthPsWrd (cadddr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthRoleS (nth 5 MyUsrInfo)))
    (setq     WellDid   (vlax-invoke MyChkAddsObj "ChkDevDesc" myDevice_ID))
    (setq     dBName    (vlax-get-property MyChkAddsObj 'mthdBcon))
    (IF (AND MYCHKADDSOBJ (NULL (VLAX-OBJECT-RELEASED-P MYCHKADDSOBJ)))
         (vlax-release-object MyChkAddsObj)
    )
    (if (and AcadObj (null (vlax-object-released-p AcadObj)))
         (vlax-release-object AcadObj)
    )
    (setq     MyChkAddsObj   nil
              AcadObj   nil
    )
    (if (= WellDid -1)
         (if Bug (princ (strcat "\nMyChkDevDescObj: to (" dBName "), at (" (GetOraDate) ")")))
    )
    WellDid
)

(defun MyChkDevObj (                             ; Checks to see if selected Object exists in AddsDb
                        myOperPt_Num                  ; Input OperPt_Num (switch number)
                        myFeeder_Num                  ; Input Feeder_Num (feeder number)
                        myBlk_Nam                     ; Input Block Name (switch type)
                        /    AcadObj MyChkAddsObj WellDid dBName )
    (setq     AcadObj        (vlax-get-acad-object)
              MyChkAddsObj   (vla-getinterfaceobject AcadObj "Acad_SCS.SCSB_Adds")
    )
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthdBcon (cadr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthUsrID (caddr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthPsWrd (cadddr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthRoleS (nth 5 MyUsrInfo)))
    (setq     WellDid   (vlax-invoke MyChkAddsObj "CHKDEVEXIST" myOperPt_Num myFeeder_Num myBlk_Nam))
    (setq     dBName    (vlax-get-property MyChkAddsObj 'mthdBcon))
    (if (and MyChkAddsObj (null (vlax-object-released-p MyChkAddsObj)))
         (vlax-release-object MyChkAddsObj)
    )
    (if (and AcadObj (null (vlax-object-released-p AcadObj)))
         (vlax-release-object AcadObj)
    )
    (setq     MyChkAddsObj   nil
              AcadObj   nil
    )
    (if (= WellDid -1)
         (if Bug (princ (strcat "\nMyChkDevObj: to (" dBName "), at (" (GetOraDate) ")")))
    )
    WellDid
)

(defun MyChkDevPan (                             ; Checks to see if selected Panel Object exists in AddsDb
                        myDevice_ID              ; Input Device_ID
                        /    AcadObj MyChkAddsObj WellDid dBName )
    (setq     AcadObj        (vlax-get-acad-object)
              MyChkAddsObj   (vla-getinterfaceobject AcadObj "Acad_SCS.SCSB_Adds")
    )
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthdBcon (cadr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthUsrID (caddr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthPsWrd (cadddr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthRoleS (nth 5 MyUsrInfo)))
    (setq     WellDid   (vlax-invoke MyChkAddsObj "GetPanel_ID" myDevice_ID))
    (setq     dBName    (vlax-get-property MyChkAddsObj 'mthdBcon))
    (if (and MyChkAddsObj (null (vlax-object-released-p MyChkAddsObj)))
         (vlax-release-object MyChkAddsObj)
    )
    (if (and AcadObj (null (vlax-object-released-p AcadObj)))
         (vlax-release-object AcadObj)
    )
    (setq     MyChkAddsObj   nil
              AcadObj   nil
    )
    (if (= WellDid -1)
         (if Bug (princ (strcat "\nMyChkPanObj: to (" dBName "), at (" (GetOraDate) ")")))
    )
    WellDid
)

(defun MyChkLayNamObj (                          ; Checks to see if selected Object exists in AddsDb
                        myDevice_ID                   ; Input Device_ID
                        /    AcadObj MyChkAddsObj WellDid dBName )
    (setq     AcadObj        (vlax-get-acad-object)
              MyChkAddsObj   (vla-getinterfaceobject AcadObj "Acad_SCS.SCSB_Adds")
    )
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthdBcon (cadr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthUsrID (caddr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthPsWrd (cadddr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthRoleS (nth 5 MyUsrInfo)))
    (setq     WellDid   (vlax-invoke MyChkAddsObj "ChkLayNam" myDevice_ID))
    (setq     dBName    (vlax-get-property MyChkAddsObj 'mthdBcon))
    (if (and MyChkAddsObj (null (vlax-object-released-p MyChkAddsObj)))
         (vlax-release-object MyChkAddsObj)
    )
    (if (and AcadObj (null (vlax-object-released-p AcadObj)))
         (vlax-release-object AcadObj)
    )
    (setq     MyChkAddsObj   nil
              AcadObj   nil
    )
    (if (= WellDid -1)
         (if Bug (princ (strcat "\nMyChkLayNamObj: to (" dBName "), at (" (GetOraDate) ")")))
    )
    WellDid
)

(defun MyChkPanObj_Old (                             ; Checks to see if selected Panel Object exists in AddsDb
                        myPan_ID                      ; Input Panel ID (adds_panel_id)
                        /    AcadObj MyChkAddsObj WellDid dBName )
    (setq     AcadObj        (vlax-get-acad-object)
              MyChkAddsObj   (vla-getinterfaceobject AcadObj "Acad_SCS.SCSB_Adds")
    )
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthdBcon (cadr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthUsrID (caddr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthPsWrd (cadddr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthRoleS (nth 5 MyUsrInfo)))
    (setq     WellDid   (vlax-invoke MyChkAddsObj "ChkPanExist" myPan_ID))
    (setq     dBName    (vlax-get-property MyChkAddsObj 'mthdBcon))
    (if (and MyChkAddsObj (null (vlax-object-released-p MyChkAddsObj)))
         (vlax-release-object MyChkAddsObj)
    )
    (if (and AcadObj (null (vlax-object-released-p AcadObj)))
         (vlax-release-object AcadObj)
    )
    (setq     MyChkAddsObj   nil
              AcadObj   nil
    )
    (if (= WellDid -1)
         (if Bug (princ (strcat "\nMyChkPanObj: to (" dBName "), at (" (GetOraDate) ")")))
    )
    WellDid
)

(defun MyNewPanObj ( inBigLst / )
    (cond 
         ((OR(= AcadVersion "18.2") (= AcadVersion "20.1")(= AcadVersion "23.0") (= AcadVersion "24.2"))
              (if (null MyGetPanData_2012)            
                   (command "netload" "C:\\Div_Map\\Common\\Adds.dll")
              )
              (MyNewPanObj_2012 inBigLst)
         )
         (T
              (MyNewPanObj_Old inBigLst)
         )
    )
)

(defun MyNewPanObj_Old ( inBigLst /    AcadObj        ; Loads ActiveX MstDevObj pusher
                        MyChkAddsObj WellDid dBName CntLstCur CntLstMin inCntCur inCntMin inSuffix ModOprNam )
    (setq     AcadObj        (vlax-get-acad-object)
              MyChkAddsObj   (vla-getinterfaceobject AcadObj "Acad_SCS.SCSB_Adds")
              MaxLinCnt      1
;             MyBigPush      nil
              MyBigPushLst   (list)
              MyPushLimit    2000
    )
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthdBcon (cadr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthUsrID (caddr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthPsWrd (cadddr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthRoleS (nth 5 MyUsrInfo)))

    (if Bug
         (setq     MyLogFile      (open "C:\\Data\\EMB_Log.Log" "w"))
    )
    (if (not (null (nth 0 inBigLst)))       ;PutCurPanLog
         (setq     MyBigPush      (strcat   "insert into addsdb.panelchglog values ('"
                                            (Force2Str (nth 0 (nth 0 (car inBigLst)))) "', '" (Force2Str (nth 1 (nth 0 (car inBigLst)))) "', '" (Force2Str (nth 2 (nth 0 (car inBigLst)))) "', '" (Force2Str (nth 3 (nth 0 (car inBigLst)))) "', '" 
                                            (Force2Str (nth 4 (nth 0 (car inBigLst)))) "', " (Force2Str (nth 5 (nth 0 (car inBigLst)))) ", " (Force2Str (nth 6 (nth 0 (car inBigLst)))) ", to_date('" 
                                            (Force2Str (nth 7 (nth 0 (car inBigLst)))) "', 'MM-DD-YYYY HH24:MI:SS'), 1) "
                                  )
                   MyBigPushLst   (list MyBigPush)
                   Bubba          (if Bug (write-line MyBigPush MyLogFile))
                   MyBigPush      ""
                   MyBigPushLen   (strlen MyBigPush)
                   LinCntR        1
         )
    )
    (if (not (null (nth 1 inBigLst)))       ;DelCurMstDev     execute 
         (foreach  ObjDel
                   (nth 1 inBigLst)
                   (setq     MyBigPush      (strcat   MyBigPush
                                                      "AddsDb.AddsDb_Destroyer.Del_Object_By_ID ('" ObjDel "', to_date('" ORADate "', 'MM-DD-YYYY HH24:MI:SS'), '" NT_ID "') "
                                            )
                             MyBigPushLen   (strlen MyBigPush)
                             LinCntR        (1+ LinCntR)
                   )
                   (if (or (>= LinCntR MaxLinCnt) (> MyBigPushLen MyPushLimit))
                        (setq     MyBigPushLst   (cons MyBigPush MyBigPushLst)
                                  Bubba          (if Bug (write-line MyBigPush MyLogFile))
                                  MyBigPush      ""   ;"begin"
                                  MyBigPushLen   (strlen MyBigPush)
                                  LinCntR        1
                        )
                   )
         )
    )
    (if (not (null (nth 2 inBigLst)))       ;PutCurMstDev
         (foreach  MstObj
                   (nth 2 inBigLst)
                   (setq     MyBigPush      (strcat   MyBigPush
                                                      "insert into addsdb.objmstdev values ('" 
                                                      (nth 0 MstObj) "',to_date('" (nth 1 MstObj) "','MM-DD-YYYY HH24:MI:SS')" ",'" (nth 2 MstObj) "', " (nth 3 MstObj) ") "
                                            )
                             MyBigPushLen   (strlen MyBigPush)
                             LinCntR        (1+ LinCntR)
                   )
                   (if (or (>= LinCntR MaxLinCnt) (> MyBigPushLen MyPushLimit))
                        (setq     MyBigPushLst   (cons MyBigPush MyBigPushLst)
                                  Bubba          (if Bug (write-line MyBigPush MyLogFile))
                                  MyBigPush      ""   ;"begin"
                                  MyBigPushLen   (strlen MyBigPush)
                                  LinCntR        1
                        )
                   )
         )
    )
    (if (not (null (nth 3 inBigLst)))       ;PutCurRegDat
         (foreach  RegObj
                   (nth 3 inBigLst)
                   (setq     MyBigPush      (strcat   MyBigPush
                                                      "insert into addsdb.objrgapp values ('"
                                                      (nth 0 RegObj) "', '" (nth 1 RegObj) "', '" (nth 2 RegObj) "') "
                                            )
                             MyBigPushLen   (strlen MyBigPush)
                             LinCntR        (1+ LinCntR)
                   )
                   (if (or (>= LinCntR MaxLinCnt) (> MyBigPushLen MyPushLimit))
                        (setq     MyBigPushLst   (cons MyBigPush MyBigPushLst)
                                  Bubba          (if Bug (write-line MyBigPush MyLogFile))
                                  MyBigPush      ""   ;"begin"
                                  MyBigPushLen   (strlen MyBigPush)
                                  LinCntR        1
                        )
                   )
         )
    )
    (if (not (null (nth 4 inBigLst)))       ;PutCurObjBlk
         (foreach  BlkObj
                   (nth 4 inBigLst)
                   (setq     MyBigPush      (strcat   MyBigPush
                                                      "insert into addsdb.objblk "
                                                      "values ('" (Force2Str (nth 0 BlkObj)) "', '" (Force2Str (nth 1 BlkObj)) "', '" 
                                                      (Force2Str (nth 2 BlkObj)) "', " (Force2Str (nth 3 BlkObj)) ", " 
                                                      (Force2Str (nth 4 BlkObj)) ", " (Force2Str (nth 5 BlkObj)) ", "
                                                      (Force2Str (nth 6 BlkObj)) ", " (Force2Str (nth 7 BlkObj)) ", "
                                                      (Force2Str (nth 8 BlkObj)) ", " (Force2Str (nth 9 BlkObj)) ", "
                                                      (Force2Str (nth 10 BlkObj)) ", " (Force2Str (nth 11 BlkObj)) ", '"
                                                      (Force2Str (nth 12 BlkObj)) "', " (Force2Str (nth 13 BlkObj)) ", null, null) "
                                            )
                             MyBigPushLen   (strlen MyBigPush)
                             LinCntR        (1+ LinCntR)
                   )
                   (if (or (>= LinCntR MaxLinCnt) (> MyBigPushLen MyPushLimit))
                        (setq     MyBigPushLst   (cons MyBigPush MyBigPushLst)
                                  Bubba          (if Bug (write-line MyBigPush MyLogFile))
                                  MyBigPush      ""   ;"begin"
                                  MyBigPushLen   (strlen MyBigPush)
                                  LinCntR        1
                        )
                   )
         )
    )
    (if (not (null (nth 5 inBigLst)))       ;PutCurObjAtt
         (foreach  AttObj
                   (nth 5 inBigLst)
                   (setq     MyBigPush      (strcat   MyBigPush
                                                      "insert into addsdb.objatt "
                                                      "values ('" (Force2Str (nth 0 AttObj)) "', '"
                                                      (Force2Str (nth 1 AttObj)) "', '" (Force2Str (nth 2 AttObj)) "', '" (Force2Str (nth 3 AttObj))
                                                      "', " (Force2Str (nth 4 AttObj)) ", " (Force2Str (nth 5 AttObj))
                                                      ", " (Force2Str (nth 6 AttObj)) ", " (Force2Str (nth 7 AttObj))
                                                      ", " (Force2Str (nth 8 AttObj)) ", " (Force2Str (nth 9 AttObj))
                                                      ", " (Force2Str (nth 10 AttObj)) ", " (Force2Str (nth 11 AttObj))
                                                      ", " (Force2Str (nth 12 AttObj)) ", '" (Force2Str (nth 13 AttObj)) "', "
                                                      (Force2Str (nth 14 AttObj)) ", " (Force2Str (nth 15 AttObj)) ", "
                                                      (Force2Str (nth 16 AttObj)) ", " (Force2Str (nth 17 AttObj)) ", '" (Force2Str (nth 18 AttObj)) "') "
                                            )
                             MyBigPushLen   (strlen MyBigPush)
                             LinCntR        (1+ LinCntR)
                   )
                   (if (or (>= LinCntR MaxLinCnt) (> MyBigPushLen MyPushLimit))
                        (setq     MyBigPushLst   (cons MyBigPush MyBigPushLst)
                                  Bubba          (if Bug (write-line MyBigPush MyLogFile))
                                  MyBigPush      ""   ;"begin"
                                  MyBigPushLen   (strlen MyBigPush)
                                  LinCntR        1
                        )
                   )
         )
    )
    (if (not (null (nth 6 inBigLst)))       ;PutCurObj_PL
         (foreach  PL_Obj
                   (nth 6 inBigLst)
                   (setq     MyBigPush      (strcat   MyBigPush
                                                      "insert into addsdb.objpl "
                                                      "values ('" (Force2Str (nth 0 PL_Obj)) "', '"
                                                      (Force2Str (nth 1 PL_Obj)) "', '" (Force2Str (nth 2 PL_Obj)) "', "
                                                      (Force2Str (nth 3 PL_Obj)) ", " (Force2Str (nth 4 PL_Obj)) ", "
                                                      (Force2Str (nth 5 PL_Obj)) ", " (Force2Str (nth 6 PL_Obj)) ", "
                                                      (Force2Str (nth 7 PL_Obj)) ", " (Force2Str (nth 8 PL_Obj)) ", "
                                                      (Force2Str (nth 9 PL_Obj)) ", " (Force2Str (nth 10 PL_Obj)) ", "
                                                      (Force2Str (nth 11 PL_Obj)) ", " (Force2Str (nth 12 PL_Obj)) ", "
                                                      (Force2Str (nth 13 PL_Obj)) ", '" (Force2Str (nth 14 PL_Obj)) "', " (Force2Str (nth 15 PL_Obj)) ", 0.0) "
                                            )
                             MyBigPushLen   (strlen MyBigPush)
                             LinCntR        (1+ LinCntR)
                   )
                   (if (or (>= LinCntR MaxLinCnt) (> MyBigPushLen MyPushLimit))
                        (setq     MyBigPushLst   (cons MyBigPush MyBigPushLst)
                                  Bubba          (if Bug (write-line MyBigPush MyLogFile))
                                  MyBigPush      ""   ;"begin"
                                  MyBigPushLen   (strlen MyBigPush)
                                  LinCntR        1
                        )
                   )
         )
    )
    (if (not (null (nth 7 inBigLst)))       ;PutCurObjVrt
         (foreach  VrtObj
                   (nth 7 inBigLst)
                   (setq     MyBigPush      (strcat   MyBigPush
                                                      "insert into addsdb.objvrt "
                                                      "values ('"
                                                      (Force2Str (nth 0 VrtObj)) "', '" (Force2Str (nth 1 VrtObj)) "', '" (Force2Str (nth 2 VrtObj))
                                                      "', '" (Force2Str (nth 3 VrtObj)) "', " (Force2Str (nth 4 VrtObj)) ", "
                                                      (Force2Str (nth 5 VrtObj)) ", " (Force2Str (nth 6 VrtObj)) ", "
                                                      (Force2Str (nth 7 VrtObj)) ", " (Force2Str (nth 8 VrtObj)) ", "
                                                      (Force2Str (nth 9 VrtObj)) ", " (Force2Str (nth 10 VrtObj)) ", "
                                                      (Force2Str (nth 11 VrtObj)) ", '" (Force2Str (nth 12 VrtObj)) "') "
                                            )
                             MyBigPushLen   (strlen MyBigPush)
                             LinCntR        (1+ LinCntR)
                   )
                   (if (or (>= LinCntR MaxLinCnt) (> MyBigPushLen MyPushLimit))
                        (setq     MyBigPushLst   (cons MyBigPush MyBigPushLst)
                                  Bubba          (if Bug (write-line MyBigPush MyLogFile))
                                  MyBigPush      ""   ;"begin"
                                  MyBigPushLen   (strlen MyBigPush)
                                  LinCntR        1
                        )
                   )
         )
    )
    (if (not (null (nth 8 inBigLst)))       ;PutCurObj4Pl
         (foreach  PL4Obj
                   (nth 8 inBigLst)
                   (setq     MyBigPush      (strcat   MyBigPush
                                                      "insert into addsdb.obj4pntpl "
                                                      "values ('" (Force2Str (nth 0 PL4Obj))
                                                      "', " (Force2Str (nth 1 PL4Obj)) ", " (Force2Str (nth 2 PL4Obj)) ", "
                                                      (Force2Str (nth 3 PL4Obj)) ", " (Force2Str (nth 4 PL4Obj)) ", " (Force2Str (nth 5 PL4Obj))
                                                      ", " (Force2Str (nth 6 PL4Obj)) ", " (Force2Str (nth 7 PL4Obj)) ", "
                                                      (Force2Str (nth 8 PL4Obj)) ", " (Force2Str (nth 9 PL4Obj)) ", " (Force2Str (nth 10 PL4Obj))
                                                      ", '" (Force2Str (nth 11 PL4Obj)) "', " (Force2Str (nth 12 PL4Obj)) ", '" (Force2Str (nth 13 PL4Obj)) "') "
                                            )
                             MyBigPushLen   (strlen MyBigPush)
                             LinCntR        (1+ LinCntR)
                   )
                   (if (or (>= LinCntR MaxLinCnt) (> MyBigPushLen MyPushLimit))
                        (setq     MyBigPushLst   (cons MyBigPush MyBigPushLst)
                                  Bubba          (if Bug (write-line MyBigPush MyLogFile))
                                  MyBigPush      ""   ;"begin"
                                  MyBigPushLen   (strlen MyBigPush)
                                  LinCntR        1
                        )
                   )
         )
    )
    (if (not (null (nth 9 inBigLst)))       ;PutCurObjTxt
         (foreach  TxtObj
                   (nth 9 inBigLst)
                   (setq     MyBigPush      (strcat   MyBigPush
                                                      "insert into addsdb.objtxt "
                                                      "values ('" (Force2Str (nth 0 TxtObj)) "','" (Force2Str (nth 1 TxtObj)) "','"
                                                      (Force2Str (nth 2 TxtObj)) "','" (Force2Str (nth 3 TxtObj)) "','" (Force2Str (nth 4 TxtObj)) "', "
                                                      (Force2Str (nth 5 TxtObj)) ", " (Force2Str (nth 6 TxtObj)) ", " (Force2Str (nth 7 TxtObj))
                                                      ", " (Force2Str (nth 8 TxtObj)) ", " (Force2Str (nth 9 TxtObj)) ", "
                                                      (Force2Str (nth 10 TxtObj)) ", " (Force2Str (nth 11 TxtObj)) ", " (Force2Str (nth 12 TxtObj))
                                                      ", " (Force2Str (nth 13 TxtObj)) ", " (Force2Str (nth 14 TxtObj)) ", "
                                                      (Force2Str (nth 15 TxtObj)) ", " (Force2Str (nth 16 TxtObj)) ", " (Force2Str (nth 17 TxtObj))
                                                      ", '" (Force2Str (nth 18 TxtObj)) "', " (Force2Str (nth 19 TxtObj)) ") "
                                            )
                             MyBigPushLen   (strlen MyBigPush)
                             LinCntR        (1+ LinCntR)
                   )
                   (if (or (>= LinCntR MaxLinCnt) (> MyBigPushLen MyPushLimit))
                        (setq     MyBigPushLst   (cons MyBigPush MyBigPushLst)
                                  Bubba          (if Bug (write-line MyBigPush MyLogFile))
                                  MyBigPush      ""   ;"begin"
                                  MyBigPushLen   (strlen MyBigPush)
                                  LinCntR        1
                        )
                   )
         )
    )
    
    (if (> LinCntR 0)
         (setq     Bubba          (if MyLogFile (close MyLogFile))
                   MyLogFile      nil
                   MyBigPush      nil
                   MyBigPushLen   (length MyBigPushLst)
                   LinCntR        0
         )
    )
    (if (not (null (nth 0 inBigLst)))
         (progn
              (setq     CntLstCur      (1- (length MyBigPushLst))
                        CntLstMin      0
                        inSuffix       "888"
                        ModOprNam      "PutBigLst"
                        GrpMaxNum      25000
                        cntGroup       GrpMaxNum
                        cntTrouble     0
              )
              (if Bug (princ (strcat "\nMyNewPanObj :Pushing {" (PadCharR (itoa (length MyBigPushLst)) 6) "} records, to (" ModOprNam "), starting at [" (GetOraDate) "]")))
              (vlax-invoke MyChkAddsObj "ResetArr" inSuffix)    ;    Clears holding Arrays in DLL as to receive the various list to update, etc.
              (while (>= CntLstCur CntLstMin)                   ;    Loads the lists
                   (vlax-invoke MyChkAddsObj "AddRowElem" (nth CntLstCur MyBigPushLst) CntLstCur CntLstMin inSuffix)
                   (setq     CntLstCur (1- CntLstCur)
                             cntGroup  (- cntGroup 1)
                             cntTrouble (+ cntTrouble 1)
                   )
                   (if ( = cntGroup 0)
                        (progn
                             (princ "\n --- I am in the Group Set and Reset Array loop --- ")(prin1 CntLstCur)
                             (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthdBcon (cadr MyUsrInfo)))
                             (setq     WellDid   (vlax-invoke MyChkAddsObj "PutNewOraData"))  ;    Doest the Ocralc update, etc.
                             (vlax-invoke MyChkAddsObj "ResetArr" inSuffix)                   ;    Clears holding Arrays in DLL as to receive the various list to update, etc.
                             (setq     cntGroup       GrpMaxNum)
                        )
                   )
              )
              (if (/= cntGroup GrpMaxNum)
                   (progn
                        (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthdBcon (cadr MyUsrInfo)))
                        (setq     WellDid   (vlax-invoke MyChkAddsObj "PutNewOraData"))       ;    Doest the Ocralc update, etc.
                   )
              )
         )
    )
    
    (if Bug
         (princ    (strcat   "\nMyNewPanObj :Inserting {"
                             (itoa     (+   (length (nth 0 inBigLst))
                                            (length (nth 1 inBigLst))
                                            (length (nth 2 inBigLst))
                                            (length (nth 3 inBigLst))
                                            (length (nth 4 inBigLst))
                                            (length (nth 5 inBigLst))
                                            (length (nth 6 inBigLst))
                                            (length (nth 7 inBigLst))
                                            (length (nth 8 inBigLst))
                                            (length (nth 9 inBigLst))
                                       )
                             )
                             "} records, to (" 
                             "PutCurOraData" 
                             "), starting at [" 
                             (GetOraDate) 
                             "]"
                   )
         )
    )
    (setq     dBName    (vlax-get-property MyChkAddsObj 'mthdBcon))
    (if (and MyChkAddsObj (null (vlax-object-released-p MyChkAddsObj)))
         (vlax-release-object MyChkAddsObj)
    )                                                                          
    (if (and AcadObj (null (vlax-object-released-p AcadObj)))
         (vlax-release-object AcadObj)
    )
    (setq     MyChkAddsObj   nil
              AcadObj   nil
    )
    (if (= WellDid -1)
         (if Bug (princ (strcat "\nMyNewPanObj: to (" dBName "), at (" (GetOraDate) ")")))
    )
    WellDid
)

(defun MyLoginObj ( DbNam / )
    (cond
         ((OR(= AcadVersion "18.2") (= AcadVersion "20.1") (= AcadVersion "23.0") (= AcadVersion "24.2"))
              (MyLoginObj_2012 DbNam)
         )
         (T
              (MyLoginObj_Old DbNam)        )
    )
)

(defun MyLoginObj_Old ( DbNam /   AcadObj             ; Loads ActiveX MstDevObj pusher
                        MyChkAddsObj WellDid dBName dUsrID dPsWrd dScLvl dRoleS)
    (setq     AcadObj        (vlax-get-acad-object)
              MyChkAddsObj   (vla-getinterfaceobject AcadObj "Acad_SCS.SCS_Login")
    )
    (if (not DbNam)
         (setq     DbNam     "dembau1")
    )
    (if (AND (= (StpDot AppNam) "ADDS") DevMark)                    ;[Modified for Trans]
         (setq     WellDid   (vlax-invoke MyChkAddsObj "Login" DbNam "addsdb" (strcat _Path-Person "AddsTestLogin.ini") "Adds User" "EMBADDS" 'False))
         (setq     WellDid   (vlax-invoke MyChkAddsObj "Login" DbNam "addsdb" (strcat _Path-Person "DIV_MAP.INI") "Adds User" "EMBADDS" 'False))
    )
    
    (setq     dBName    (vlax-get-property MyChkAddsObj 'mthdBcon)
              dUsrID    (vlax-get-property MyChkAddsObj 'mthUsrID)
              dPsWrd    (vlax-get-property MyChkAddsObj 'mthPsWrd)
              dScLvl    (vlax-get-property MyChkAddsObj 'mthScLvl)
              dRoleS    (vlax-get-property MyChkAddsObj 'mthRoleS)
    )
    (if (and MyChkAddsObj (null (vlax-object-released-p MyChkAddsObj)))
         (vlax-release-object MyChkAddsObj)
    )
    (if (and AcadObj (null (vlax-object-released-p AcadObj)))
         (vlax-release-object AcadObj)
    )
    (setq     MyChkAddsObj   nil
              AcadObj   nil
    )
    (if (= WellDid -1)
         (if Bug (princ (strcat "\nMyLoginObj: to (" dBName "), at (" (GetOraDate) ")")))
    )
    (list WellDid dBName dUsrID dPsWrd dScLvl dRoleS)
)

(defun MySubObj ( /     AcadObj                  ; Loads ActiveX MstDevObj pusher
                        MyChkAddsObj WellDid dBName dSubDiv dSubNam 
                        dSubDwg dSubOrg dSscada dSubEMB dSub_ID )
    (setq     AcadObj   (vlax-get-acad-object)
              MyChkAddsObj   (vla-getinterfaceobject AcadObj "Acad_SCS.SCSB_Adds")
    )
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthdBcon (cadr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthUsrID (caddr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthPsWrd (cadddr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthRoleS (nth 5 MyUsrInfo)))
    (cond     ((= Div "BH")
                   (setq     WellDid   (vlax-invoke MyChkAddsObj "SelectSub" "1" ""))
              )
              ((= Div "E_")
                   (setq     WellDid   (vlax-invoke MyChkAddsObj "SelectSub" "2" ""))
              )
              ((= Div "M_")
                   (setq     WellDid   (vlax-invoke MyChkAddsObj "SelectSub" "5" ""))
              )
              ((= Div "S_")
                   (setq     WellDid   (vlax-invoke MyChkAddsObj "SelectSub" "3" ""))
              )
              ((= Div "SE")
                   (setq     WellDid   (vlax-invoke MyChkAddsObj "SelectSub" "6" ""))
              )
              ((= Div "W_")
                   (setq     WellDid   (vlax-invoke MyChkAddsObj "SelectSub" "4" ""))
              )
              ((= Div "AL")
                   (setq     WellDid   (vlax-invoke MyChkAddsObj "SelectSub" "0" ""))
              )
              ((= Div "GA")
                   (setq     WellDid   (vlax-invoke MyChkAddsObj "SelectSub" "0" ""))
              )
    )
    (setq     dBName    (vlax-get-property MyChkAddsObj 'mthdBcon))
    (setq     dSubDiv   (vlax-get-property MyChkAddsObj 'mthDvNam))
    (setq     dSubNam   (vlax-get-property MyChkAddsObj 'mthdSDsc))
    (setq     dSubDwg   (vlax-get-property MyChkAddsObj 'mthDgNam))
    (setq     dSubOrg   (vlax-get-property MyChkAddsObj 'mthdBOrg))
    (setq     dSscada   (vlax-get-property MyChkAddsObj 'mthScada))
    (setq     dSubEMB   (vlax-get-property MyChkAddsObj 'mthdBEMB))
    (setq     dSub_ID   (vlax-get-property MyChkAddsObj 'mthdB_ID))
    (if (and MyChkAddsObj (null (vlax-object-released-p MyChkAddsObj)))
         (vlax-release-object MyChkAddsObj)
    )
    (if (and AcadObj (null (vlax-object-released-p AcadObj)))
         (vlax-release-object AcadObj)
    )
    (setq     MyChkAddsObj   nil
              AcadObj   nil
    )
    (cond     ((= dSubDiv "1") (setq dSubDiv "BH"))
              ((= dSubDiv "2") (setq dSubDiv "E_"))
              ((= dSubDiv "3") (setq dSubDiv "S_"))
              ((= dSubDiv "4") (setq dSubDiv "W_"))
              ((= dSubDiv "5") (setq dSubDiv "M_"))
              ((= dSubDiv "6") (setq dSubDiv "SE"))
              ((= dSubDiv "0") (setq dSubDiv "AL"))
              ((= dSubDiv "0") (setq dSubDiv "GA"))
    )
    (if (= WellDid -1)
         (if Bug (princ (strcat "\nMySubObj: to (" dBName "), at (" (GetOraDate) ")")))
    )
    (list WellDid dBName dSubDiv dSubNam dSubDwg dSubOrg dSscada dSubEMB dSub_ID)
)

(defun MyURDObj ( /     AcadObj                  ; Loads ActiveX MstDevObj pusher
                        MyChkAddsObj WellDid dBName dURDDiv dURDNam
                        dURDDwg dURDOrg dURDEMB dURD_ID dURDOpt dURDFdr )
    (setq     AcadObj   (vlax-get-acad-object)
              MyChkAddsObj   (vla-getinterfaceobject AcadObj "Acad_SCS.SCSB_Adds")
    )
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthdBcon (cadr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthUsrID (caddr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthPsWrd (cadddr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthRoleS (nth 5 MyUsrInfo)))
    (cond     ((= Div "BH")
                   (setq     WellDid   (vlax-invoke MyChkAddsObj "SelectURD" "1" ""))
              )
              ((= Div "E_")
                   (setq     WellDid   (vlax-invoke MyChkAddsObj "SelectURD" "2" ""))
              )
              ((= Div "M_")
                   (setq     WellDid   (vlax-invoke MyChkAddsObj "SelectURD" "5" ""))
              )
              ((= Div "S_")
                   (setq     WellDid   (vlax-invoke MyChkAddsObj "SelectURD" "3" ""))
              )
              ((= Div "SE")
                   (setq     WellDid   (vlax-invoke MyChkAddsObj "SelectURD" "3" ""))
              )
              ((= Div "W_")
                   (setq     WellDid   (vlax-invoke MyChkAddsObj "SelectURD" "4" ""))
              )
    )
    (setq     dBName    (vlax-get-property MyChkAddsObj 'mthdBcon))
    (setq     dURDDiv   (vlax-get-property MyChkAddsObj 'mthDvNam))
    (setq     dURDNam   (vlax-get-property MyChkAddsObj 'mthdSDsc))
    (setq     dURDDwg   (vlax-get-property MyChkAddsObj 'mthDgNam))
    (setq     dURDOrg   (vlax-get-property MyChkAddsObj 'mthdBOrg))
    (setq     dURDEMB   (vlax-get-property MyChkAddsObj 'mthdBEMB))
    (setq     dURD_ID   (vlax-get-property MyChkAddsObj 'mthdB_ID))
    (setq     dURDOpt   (vlax-get-property MyChkAddsObj 'mthOpNum))
    (setq     dURDFdr   (vlax-get-property MyChkAddsObj 'mthdbFdr))
    (if (and MyChkAddsObj (null (vlax-object-released-p MyChkAddsObj)))
         (vlax-release-object MyChkAddsObj)
    )
    (if (and AcadObj (null (vlax-object-released-p AcadObj)))
         (vlax-release-object AcadObj)
    )
    (setq     MyChkAddsObj   nil
              AcadObj   nil
    )
    (cond     ((= dURDDiv "1") (setq dURDDiv "BH"))
              ((= dURDDiv "2") (setq dURDDiv "E_"))
              ((= dURDDiv "3") (setq dURDDiv "S_"))
              ((= dURDDiv "4") (setq dURDDiv "W_"))
              ((= dURDDiv "5") (setq dURDDiv "M_"))
              ((= dURDDiv "6") (setq dURDDiv "SE"))
    )
    (if (= WellDid -1)
         (if Bug (princ (strcat "\nMyURDObj: to (" dBName "), at (" (GetOraDate) ")")))
    )
    (list WellDid dBName dURDDiv dURDNam dURDDwg dURDOrg dURDEMB dURD_ID dURDOpt dURDFdr)
)

(defun MyPlotObj (Plds / )
    (cond 
         ((OR(= AcadVersion "18.2") (= AcadVersion "20.1") (= AcadVersion "23.0") (= AcadVersion "24.2"))
		     (if (null MyGetPanData_2012)            
                   (command "netload" "C:\\Div_Map\\Common\\Adds.dll")
              )
              (GetPlotDefByPlotName PldNam Div);function in addsplot.cs line 36
         )
    )
)


(defun GetPlotDefByPlotGroup_Old (PlotGroup GroupOrder / AcadObj 
                                  MyChkAddsObj WellDid PlotDefs inSuffix rowCount positionCount curRowCount)
    (setq     AcadObj             (vlax-get-acad-object)
              MyChkAddsObj        (vla-getinterfaceobject AcadObj "Acad_SCS.SCSB_Adds")
              WellDid             (vlax-put-property MyChkAddsObj 'mthdBcon (cadr MyUsrInfo))
              WellDid             (vlax-put-property MyChkAddsObj 'mthUsrID (caddr MyUsrInfo))
              WellDid             (vlax-put-property MyChkAddsObj 'mthPsWrd (cadddr MyUsrInfo))
              WellDid             (vlax-put-property MyChkAddsObj 'mthRoleS (nth 5 MyUsrInfo))
              WellDid             (vlax-invoke MyChkAddsObj "GetPlotDefByPlotGroup" PlotGroup GroupOrder)
              PlotDefs            nil
    )
    (setq     inSuffix       "079"
              rowCount       (vlax-invoke MyChkAddsObj "ReadRowCnt" inSuffix)
              positionCount  (vlax-invoke MyChkAddsObj "ReadPosCnt" inSuffix)
              curRowCount    0
    )
    (while (<= curRowCount rowCount)
         (setq curItemCount 0
               rowElem nil
         )
         (while (<= curItemCount positionCount)
              (if rowElem
                   (setq rowElem (cons (vlax-invoke MyChkAddsObj "ReadRowElem" curRowCount curItemCount inSuffix)rowElem))
                   (setq rowElem (list (vlax-invoke MyChkAddsObj "ReadRowElem" curRowCount curItemCount inSuffix)))
              )
              (setq curItemCount (+ curItemCount 1))
         )
         (setq rowElem (reverse rowElem))
         (if PlotDefs
              (setq     PlotDefs  (cons rowElem PlotDefs))
              (setq     PlotDefs  (list rowElem))
         )
;             (setq curItemCount (+ curItemCount 1))
;        )
         (setq curRowCount (+ curRowCount 1))
    )
    (if (and MyChkAddsObj (null (vlax-object-released-p MyChkAddsObj)))
         (vlax-release-object MyChkAddsObj)
    )
    (if (and AcadObj (null (vlax-object-released-p AcadObj)))
         (vlax-release-object AcadObj)
    )
    (setq     MyChkAddsObj   nil
              AcadObj   nil
    )
    PlotDefs
)

(defun GetSymbolInfoList ( / )
    (setq     AcadObj             (vlax-get-acad-object)
              MyChkAddsObj        (vla-getinterfaceobject AcadObj "Acad_SCS.SCSB_Adds")
              WellDid             (vlax-put-property MyChkAddsObj 'mthdBcon (cadr MyUsrInfo))
              WellDid             (vlax-put-property MyChkAddsObj 'mthUsrID (caddr MyUsrInfo))
              WellDid             (vlax-put-property MyChkAddsObj 'mthPsWrd (cadddr MyUsrInfo))
              WellDid             (vlax-put-property MyChkAddsObj 'mthRoleS (nth 5 MyUsrInfo))
              WellDid             (vlax-invoke MyChkAddsObj "GetSymbolInfo")
              lstSymbolInfo            nil
    )
    (setq     inSuffix       "Sym"
              rowCount       (vlax-invoke MyChkAddsObj "ReadRowCnt" inSuffix)
              positionCount  (vlax-invoke MyChkAddsObj "ReadPosCnt" inSuffix)
              curRowCount    0
    )
    
    (while (<= curRowCount rowCount)
         (setq curItemCount 0
               rowElem nil
         )
         (while (<= curItemCount positionCount)
              (if rowElem
                   (setq rowElem (cons (vlax-invoke MyChkAddsObj "ReadRowElem" curRowCount curItemCount inSuffix)rowElem))
                   (setq rowElem (list (vlax-invoke MyChkAddsObj "ReadRowElem" curRowCount curItemCount inSuffix)))
              )
              (setq curItemCount (+ curItemCount 1))
         )
         (setq rowElem (reverse rowElem))
         (if lstSymbolInfo
              (setq     lstSymbolInfo  (cons rowElem lstSymbolInfo))
              (setq     lstSymbolInfo  (list rowElem))
         )
         (setq curRowCount (+ curRowCount 1))
    )
    
    (if (and MyChkAddsObj (null (vlax-object-released-p MyChkAddsObj)))
         (vlax-release-object MyChkAddsObj)
    )
    (if (and AcadObj (null (vlax-object-released-p AcadObj)))
         (vlax-release-object AcadObj)
    )
    (setq     MyChkAddsObj   nil
              AcadObj   nil
    )
    lstSymbolInfo
)

(defun MyGetPlotDevInf ( MyPlotDev /   AcadObj   ; Loads ActiveX MstDevObj pusher
                        MyChkAddsObj CntLstMin inCntMin WellDid CntLstCur inCntMax inCntCur MyElem MyObjLst dBName MyObjCnt )
    (setq     AcadObj        (vlax-get-acad-object)
              MyChkAddsObj   (vla-getinterfaceobject AcadObj "Acad_SCS.SCSB_Adds")
              WellDid        (vlax-invoke MyChkAddsObj "GetDevPapInfo" MyPlotDev)
              CurPlotDevLst  nil  ;077
              Bubba          (if Bug (mapcar (quote (lambda (x) (princ (strcat (PadCharR (itoa (nth 0 x)) 6) (PadCharR (nth 1 x) 9) (nth 2 x) "\n")))) CurPlotDevLst))
    )
    ;;;**************************************** CurPlotDevLst ****************************************
    (setq     inSuffix       "077"
              ModOprNam      "GetDevPapInfo"
              CntLstCur      (vlax-invoke MyChkAddsObj "ReadRowCnt" inSuffix)
              inCntMax       (vlax-invoke MyChkAddsObj "ReadPosCnt" inSuffix)
              CntLstMin      0
              inCntMin       0
    )
    (if Bug 
         (if (>= CntLstCur CntLstMin)
              (princ (strcat "\nMyGetPlotDevInf :Pulling {" (itoa (1+ CntLstCur)) "} records, to (" ModOprNam "), starting at [" (GetOraDate) "]"))
         )
    )
    (while (>= CntLstCur CntLstMin)
         (setq     inCntCur  inCntMax)
         (while (>= inCntCur inCntMin)
              (if (= inCntCur inCntMax)
                   (setq     MyElem    (list (vlax-invoke MyChkAddsObj "ReadRowElem" CntLstCur inCntCur inSuffix)))
                   (setq     MyElem    (cons (vlax-invoke MyChkAddsObj "ReadRowElem" CntLstCur inCntCur inSuffix) MyElem))
              )
              (setq     inCntCur  (1- inCntCur))
         )
         (if MyObjLst
              (setq     MyObjLst  (cons MyElem MyObjLst))
              (setq     MyObjLst  (list MyElem))
         )
         (setq     CntLstCur (1- CntLstCur))
    )
    (if (and (> (length MyObjLst) 0) (/= (caar MyObjLst) "Test1"))
         (progn
              (ReFormLst MyObjLst inSuffix)
              (setq     
                        MyObjCnt  (length MyObjLst)
                        MyObjLst  nil
              )
         )
         (setq     MyObjLst  nil)
    )
    ;;;**************************************** GetCurObjTxt ****************************************
    (if (and MyChkAddsObj (null (vlax-object-released-p MyChkAddsObj)))
         (vlax-release-object MyChkAddsObj)
    )
    (if (and AcadObj (null (vlax-object-released-p AcadObj)))
         (vlax-release-object AcadObj)
    )
    (setq     MyChkAddsObj   nil
              AcadObj   nil
    )
    (if CurPlotDevLst
         (setq     MyObjCnt  (length CurPlotDevLst))
         (setq     MyObjCnt  0)
    )
    (if (and MyObjCnt MyPlotDev)
         (if Bug (princ (strcat "\nMyGetPlotDevInf (" (itoa MyObjCnt) ") recs, from (" MyPlotDev "), at (" (GetOraDate) ")")))
    )
    MyObjCnt
)

(defun MyPlotExt ( myCrdFil myCrdKy /  AcadObj   ; Loads ActiveX AddsPlot decider...
                                       MyChkAddsObj WellDid 
                                       myUlX myUlY myUuX myUuY )
    (setq     AcadObj   (vlax-get-acad-object)
              MyChkAddsObj   (vla-getinterfaceobject AcadObj "Acad_SCS.SCSB_Adds")
    )
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthdBcon (cadr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthUsrID (caddr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthPsWrd (cadddr MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthRoleS (nth 5 MyUsrInfo)))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthCordfile myCrdFil))
    (setq     WellDid   (vlax-put-property MyChkAddsObj 'mthCordkey myCrdKy))
    (setq     WellDid   (vlax-invoke MyChkAddsObj "ChkVariable_Extents" myCrdFil myCrdKy))
    (setq     myUlX     (vlax-get-property MyChkAddsObj 'mthUlX))
    (setq     myUlY     (vlax-get-property MyChkAddsObj 'mthUlY))
    (setq     myUuX     (vlax-get-property MyChkAddsObj 'mthUuX))
    (setq     myUuY     (vlax-get-property MyChkAddsObj 'mthUuY))
    (if (and MyChkAddsObj (null (vlax-object-released-p MyChkAddsObj)))
         (vlax-release-object MyChkAddsObj)
    )
    (if (and AcadObj (null (vlax-object-released-p AcadObj)))
         (vlax-release-object AcadObj)
    )
    (setq     MyChkAddsObj   nil
              AcadObj   nil
    )
    (if (= WellDid -1)
         (if Bug (princ (strcat "\nMyPlotExt: to (" dBName "), at (" (GetOraDate) ")")))
    )
    (list     WellDid myCrdFil myCrdKy myUlX myUlY myUuX myUuY)
)

(setq    LodVer    "16.0.0")
