(if AppNam                                       ; Code Version Indicator {2597 Lines of Code}
    (princ (strcat "\n" AppNam " Switch Loading."))
    (princ "\nAdds Switch Loading.")
)
;19sept14 - karl - added two blocks to adds. (a205 & a206)
;
;
;documented 19sept14 - karl
;listed subroutines     TestEnds (PtL1  PtL2  PtA  PtB  PtC  PtD)
;                       SymEntry (Sym)
;                       SymEntryOld (Sym  LType  Fnct  Invrt  Rot)
;                       PFindN (AskT)
;                       Do_GapN (Sym  SymLst  PFLst)
;                       In_LineN (Sym  SymLst  Invrt  Rot  PFLst)
;                       FreeStandN (SymLst  PFLst)
;                       PM_OnLineN (SymLst  PFLst  LType)
;                       PM_EndLineN (SymLst  PFLst  Invrt  Rot)
;                       RegArrN (SymLst  PFLst)
;                       Do_Gap (Sym)
;                       SubLoc (Sym)
;                       MovLast
;                       Drw_Arr (flag)
;                       NOARR
;                       Sym_online (Sym  offset  ltype)
;                       End_Ln (Sym)
;                       CPins
;                       CP_Ins (FO  CPNum  plname  Lngth)
;                       RegArr
;                       OcrFix
;                       SubGet (SymN)
;                       Fdr_Load_Data
;                       Cb_Fdr_Test_Ok
;                       Cb_Fdr_Vt_popup
;                       Cb_Fdr_Fd_popup
;                       Sub_Load_Data
;                       Cb_Sub_Test_Ok
;                       Cb_Sub_Vt_popup
;                       Cb_Sub_Sb_popup
;                       FixNearVrt (entL  Pt2)
;                       Put (SymTyp  Pos  Lname  Inv  Rot)
;                       OnPoleN (SymTyp  lname)
;                       Vtx1
;                       Vtx2 (which)
;                       SetThk (el)
;                       
;                       
(defun TestEnds ( PtL1 PtL2 PtA PtB PtC PtD /    ; Compares Two Double Pt Lists, Good if one each within range
                                                 GoodPt )
    (if Bug (princ "\n{TestEnds entered"))
    (setq GoodPt T)
    (if Bug (princ "\nTestEnds exited}\n"))
    GoodPt
);end-of-defun
;
;
(defun SymEntry (Sym / 
                    AttWas symbDesc addsSymSize addsAttSize EMBSymNum EMBState EMBClass EMBSubClass 
                    addsLayerType addsSymFunction addsSymGapType addsSymGap addsSymPrompts omod pfent spt cpt)
                    
    (if Bug 
         (progn 
              (princ "\n{SymEntry entered")
              (princ "\n   Parameter Sym: ")(prin1 Sym)
         )
    )
    (setq AttWas (getvar "ATTREQ"))
    (if (/= (getvar "ATTREQ") 1) (setvar "ATTREQ" 1))
    (if (/= (getvar "INSUNITS") 0) (setvar "INSUNITS" 0))
	
	(setq AttDWas (getvar "ATTDIA"))					   ; [ADDED] due to AutoCAD 2016
	(if (/= (getvar "ATTDIA") 0) (setvar "ATTDIA" 0))
	
    (cond
         ((and (not sff) sf)
              (setq sff (/ sf 0.3048))
         );cond-1
         ((and (not sf) sff)
              (setq sf (* sff 0.3048))
         );cond-2
         ((and (not sff) (not sf))
              (SetScale)
         );cond-3
    );end-of-condition
    (command "_.UNDO" "_BE")
    
    ;    Get Symbol Information from external database
	;                   ("A126" "3826" "Switch, Gang Operated CLO" "SWITCH" "0.25" "0.0850" "CLO" "SW" 
    ;                    "DGS" "SW" "IL" "C" "0.25" "IL_SW" ("Switch Number:" "Description:"))
    (setq symbInfo (SymEntryInfo Sym MyUsrInfo);function in "adds.cs" line 1108
          symbDesc        (nth 2 symbInfo)
          addsClass       (nth 3 symbInfo)
          addsSymSize     (nth 4 symbInfo)
          addsAttSize     (nth 5 symbInfo)
          EMBSymNum       (nth 1 symbInfo);corrected 23sept14 karl
          EMBState        (nth 6 symbInfo)
          EMBClass        (nth 7 symbInfo)
          EMBSubClass     (nth 8 symbInfo)
          addsLayerType   (nth 9 symbInfo)
          addsSymFunction (nth 10 symbInfo)
          addsSymGapType  (nth 11 symbInfo)
          addsSymGap      (atof (nth 12 symbInfo))
          addsSymPrompts  (nth 14 symbInfo)
    )
    ;    Need for old calls to FreeStandN and PM_OnLineN
    (if (= DwgType "SLD")
         (setq SymLst (list addsSymGapType (* addsSymGap fugdeFactor) (strcat _Path-Sym Sym)))
         (setq SymLst (list addsSymGapType (* addsSymGap SMult)       (strcat _Path-Sym Sym)))
    )
    ;    Get Polyline or entity information
    (setq omod (getvar "OSMODE"))
    (setvar "OSMODE" 0)
    (if (= addsSymFunction "FS")
         (setq PFLst (PFindN T))
         (setq PFLst (PFindN nil))
    )
    
    (if PFLst
         (setq pfent  (nth 0 PFLst)
               spt    (nth 1 PFLst)
               cpt    (nth 2 PFLst)
               m      (nth 3 PFLst)
               slope  (nth 4 PFLst)
               mp     (nth 5 PFLst)
               slopep (nth 6 PFLst)
               plname (nth 7 PFLst);polyline layer name
               hlfwth (nth 8 PFLst)
               plthk  (nth 9 PFLst)
               ipt    (nth 10 PFLst)
         )
         (progn
              (alert (strcat "**" AppNam " Error**\nNo Polydata passed"))
              (exit)
         )
    );end-of-if

    ;    Create Layer names need for symbol to be inserted
    (if addsSymFunction                                            ; [TODO] modify for transmission
         (if (/= addsSymFunction "FS")
              (if (or (= addsLayerType "SW") (= addsSymFunction "IL"))
                   (if (not (tblsearch "LAYER" (strcat (substr PLName 1 4) "FL-" (substr PLName 8))))
                        (MkLay                 (strcat (substr PLName 1 4) "FL-" (substr PLName 8)))
                   )
              )
         )
    )
    (cond
         ((or (= Div "AL")(= Div "GA"))                                                  ; [Modified for Trans]
              (setq LName  PLName)
         );cond-1
         ((= addsSymFunction "FS")
              (if (= addsLayerType "LM")
                   (setq LName "----LM----")
                   (if (member addsLayerType (list "ULO--" "-LO--" "-NO--"))
                        (setq LName (MkLay (strcat (substr PLName 1 3) addsLayerType (substr PLName 9))))
                        (if addsLayerType
                             (setq LName (MkLay (strcat (substr PLName 1 4) addsLayerType (substr PLName 7))))
                             (setq LName PLName)
                        )
                   )
              )
              (if Bug (princ "\naddsSymFunction = FS \n"))
         );cond-2
         ((= addsSymFunction "PM")
              (if Bug (princ "\naddsSymFunction = PM"))
         );cond-3
         ((= addsLayerType "SW")
              (if Bug (princ "\nSym = CS"))
              (MkLay      (strcat (substr PLName 1 4) "SW-" (substr PLName 8)))
              (MkLay      (strcat (substr PLName 1 4) "SWD" (substr PLName 8)))
              (setq LName (strcat (substr PLName 1 4) "SW-" (substr PLName 8)))
         );cond-4
         ((= Sym "A080")
              (if Bug (princ "\nSym = A080"))
              (setq LName (strcat (substr PLName 1 3) "O" (substr PLName 5)))
         );cond-5
         (addsLayerType
              (if Bug (princ (strcat "\naddsLayerType=" addsLayerType)))
              (MkLay      (strcat (substr PLName 1 4) addsLayerType (substr PLName 7)))
              (setq LName (strcat (substr PLName 1 4) addsLayerType (substr PLName 7)))
         );cond-6
         (T
              (setq LName  PLName)
         );cond-7
    );end-of-condition
    
    (if (and LName SymLst)
         (setq SymLst (reverse (cons LName (reverse SymLst))))
    )
    
    ;    Get Attribute information from user.
    (setq DoIt   nil
          DoTemp nil
    )
    (foreach strPrompt addsSymPrompts
         (setq DoIt (append DoIt (list (strcase (getstring T (strcat "\n" strPrompt))))))
    )
    ;note below: 100 series blocks are mostly ADDS, 800 series blocks are alabama transmission,
    ;            900 series blocks are georgia
    ;    Insert symbol and perform actions based on symbol grouping
    (cond
         ;    Landmark Symbols without any attributes
         ((and (member Sym (list "A914" "A927" "A953" "A954"))
               (= addsSymFunction "FS"))
              (setq DoTo (FreeStandN SymLst PFLst)
                    DoTo (cons "INSERT" DoTo)
              )
              (mapcar (quote command) DoTo)
              (setthk (entget (entlast)))
         );cond-1
         ;    Primarily Landmark symbols with attributes
         ((and (member Sym (list "_BLDG" "_CHURCH" "_SCHOOL" "CEMETERY" "A081" "A086"
                                 "A917" "A918" "A926" "A951" "A952"))
               (= addsSymFunction "FS")
              )
              (setq DoTo (FreeStandN SymLst PFLst))
              (if (and Bug DoTo) (setq EdsDoTo DoTo))
              
              (setq DoTo (cons "INSERT" DoTo)
                    DoTo (append DoTo DoIt)
              )
              (mapcar (quote command) DoTo)
              (MovLast)
              (setthk (entget (entlast)))
              (Att-Chg-Lay)
         );cond-2
         ((and (member Sym (list "A082" "A100" "A104" "A156" "A183"
                                 "A922" "A937" "A938" "A944" "A945" "A949" "A950"))
               (= addsSymFunction "FS")
          )
              (setq DoTo (FreeStandN SymLst PFLst))
              (if (and Bug DoTo) (setq EdsDoTo DoTo))
              
              ;    Override Attributes for special cases
              (cond
                   ((member Sym (list "A082"))                       ;    Customer Equipment symbol
                     (setq DoOne  (nth 0 DoIt)
                           DoOne  (if (> (strlen DoOne) 2)
                                      (if (/= (strcase (substr DoOne 1 2)) "CE") (strcat "CE-" DoOne) DoOne)
                                      (strcat "CE-" DoOne)
                                  )
                           DoTwo  (nth 1 DoIt)
                           DoTemp (append DoTemp (list DoOne DoTwo))
                           DoIt   DoTemp
                     )
                   )
              );end-of-condition
              
              (setq DoTo (cons "INSERT" DoTo)
                    DoTo (append DoTo DoIt)
              )
              (mapcar (quote command) DoTo)
              (MovLast)
              (setthk (entget (entlast)))
              (Att-Chg-Lay)
              (Drw_Arr nil)
         );cond-3
         ((and (member Sym (list "A076" "A136"))
               (= addsSymFunction "FS")
          )
              (setq DoTo (FreeStandN SymLst PFLst))                         
              (setq DoTo (cons "INSERT" DoTo)
                    DoTo (append DoTo DoIt)
              )
              (mapcar (quote command) DoTo)
              (MovLast)
              (setthk (entget (entlast)))
              (Att-Chg-Lay)
              (Att-NM)
         );cond-4
         ((member Sym (list "A150"))   ; "PM"
              (setq DoTo (PM_OnLineN SymLst PFLst (atof addsLayerType)))                         
              (setq DoTo (cons "INSERT" DoTo)
                    DoTo (append DoTo DoIt)
              )
              (mapcar (quote command) DoTo)
              (setthk (entget (entlast)))
              (Att-NM)
         );cond-5
         ;    [TODO] - A071 
         ((and (= addsSymFunction "IL") 
               (member Sym (list "A065" "A071" "A077" "A078" "A079" "A084" "A085" "A109" "A121" "A123"
                                 "A126" "A131" "A135" "A138" "A142" "A154" "A157" "A160" "A161" "A164"
                                 "A171" "A173" "A176" "A181" "A190" "A191" "A196" "A197" "A198" "A199" 
                                 "A901" "A902" "A903" "A905" "A906" "A907" "A908" "A909" "A910" "A911"
                                 "A912" "A915" "A916" "A919" "A920" "A921" "A924" "A925" "A928" "A929"
                                 "A932" "A933" "A940" "A941" "A942" "A943" 
                                 "A205" "A206"   ;added 19sept14 karl
                           )
               )
          );end-of-and
              (setq DoTo (In_LineN Sym SymLst nil nil PFLst))
              
              (cond
                   ((member Sym (list "A084" "A085"))
                        (setq DoOne  (nth 0 DoIt)
                              DoOne  (if (> (strlen DoOne) 3)
                                          (if (/= (strcase (substr DoOne 1 3)) "ATS") 
                                               (strcat "ATS-" DoOne) 
                                               DoOne
                                          )
                                          (strcat "ATS-" DoOne)
                                     )
                              DoTwo  (nth 1 DoIt)
                              DoTemp (append DoTemp (list DoOne DoTwo))
                              DoIt   DoTemp
                        )
                   )
              )
                             
              (setq DoTo (cons "INSERT" DoTo)
                    DoTo (append DoTo DoIt)
              )
              (mapcar (quote command) DoTo)
              (setthk (entget (entlast)))
              (Att-Up)
              (Att-Chg-Lay)
         );cond-6
         ;    No unknown reason for this grouping symbols A132 ~ Ground, A134 ~ Lightning Arrestor,
         ;    A167 & A175 & A177 & A180 are URD are not IL but nil function code
         ;    What is going on with "A994" ?
         ((and (= addsSymFunction "IL") 
              (member Sym (list "A101" "A105" "A122" "A124" "A125" "A125S" "A132" "A134" "A148" "A155"
                                "A169" "A170" "A170S" "A172" "A193" "A194" "A167" "A175" "A177" "A180" "A213" "A214" 
                                "A913" "A934" "A936" "A947" "A948" "A994")));end-of-and              
              (setq DoTo (In_LineN Sym SymLst nil nil PFLst))              
              (cond 
                   ((member Sym (list "A122" "A132" "A134" "A913" "A934"));Transformer, OH Step Up/Down, Ground, Lightning Arrestor symbol
                        (setq DoTo (RepLst DoTo (+ (nth 4 DoTo) 90.0) 4))
                   );cond-1
                   ((member Sym (list "A105" "A169" "A193" "A194" "A213" "A214"))  ;    Recloser symbols
                        (setq DoOne  (nth 0 DoIt)
                              DoTwo  (nth 1 DoIt)
                              DoThr  (nth 2 DoIt)
                              DoFor  (nth 3 DoIt)
                              DoFiv  (nth 4 DoIt)
                              DoTemp (append DoTemp (list DoOne DoTwo DoThr
                                                          (if (and (>= (strlen DoThr) 1) (/= DoThr " "))
                                                              "S"
                                                              " "
                                                          )
                                                          DoFor
                                                          (if (and (>= (strlen DoFor) 1) (/= DoFor " "))
                                                              "L"
                                                              " "
                                                          )
                                                          DoFiv
                                                          (if (and (>= (strlen DoFiv) 1) (/= DoFiv " "))
                                                              "B"
                                                              " "
                                                          )
                                                    )
                                     )
                              DoIt   DoTemp
                        );end-of-setq
                   );cond-2
                   ((member Sym (list "A101"))                       ;    "CAP  Adds_Class CAPACTR"
                        (setq DoOne  (nth 0 DoIt)
                              DoTwo  (nth 1 DoIt)
                              DoThr  (nth 2 DoIt)
                              DoThr  (if (or (< (strlen DoThr) 1) (= DoThr " ")) "S" DoThr)
                              DoTemp (append DoTemp (list DoOne (strcat DoTwo " " DoThr)))
                              DoIt   DoTemp
                              DoTo   (RepLst DoTo (+ (nth 4 DoTo) 90.0) 4)
                        )
                   );cond-3
              );end-of-condition
              
              (setq DoTo (cons "_.INSERT" DoTo)
                    DoTo (append DoTo DoIt)
              )
              
              (mapcar (quote command) DoTo)
              (setthk (entget (entlast)))
              (if (member Sym (list "A122"))
                   (Att-Up)
              )
              (Att-Chg-Lay)
              (if (member Sym (list  "A122"))
                   (Att-NM)
              )
         );cond-7
         ;    Adds_Class REGLATOR symbols (All)
         ;    [TODO} Check with Ed W none of Symbols are completely set up in menu code to call
         ((and (member Sym (list "A120" "A133" "A188" "A189" "A192" "A195"))
               (= addsSymFunction "IL"))
              (setq DoTo (In_LineN Sym SymLst nil nil PFLst))
              (setq DoTo (cons "INSERT" DoTo)
                    DoTo (append DoTo DoIt)
              )
              
              (mapcar (quote command) DoTo)
              (setthk (entget (entlast)))
              (Att-Up)
              (Att-Chg-Lay)
              (Att-NM)
              (setthk (entget (entlast)))
         );cond-8
         ;    Feeder Indicator symbol
         ((and (member Sym (list "A080"))
               (= addsSymFunction "IL"))
              (setq DoTo (In_LineN Sym SymLst Invrt Rot PFLst))
              
              ;    Overrides Attribute information for Feeder Number of Substation if required (normal state)
              (if LName
                   (setq GetOne (ascii (substr LName 3 1))
                         DoOne  (if (and (>= GetOne 65) (<= GetOne 90))
                                     (list(itoa (- GetOne 64)))
                                     (if (and (>= GetOne 97) (<= GetOne 122))
                                          (list(itoa (- GetOne 96)))
                                          DoIt
                                     )
                                )
                   )
                   (setq DoOne  DoIt)
              )
              (setq DoTo (cons "INSERT" DoTo)
                    DoTo (append DoTo DoOne)
              )
                   
              (mapcar (quote command) DoTo)
              (setthk (entget (entlast)))
              (Att-Up)
              (Att-Chg-Lay)
              (Att-NR)
         );cond-9
         ;    Symbols without any attributes Fault Indicator & Riser
         ((and (member Sym (list "A106" "A140" "A923" "A930" "A931" "A935" "A939" "A946"))
               (= addsSymFunction "IL"))
              (setq DoTo (In_LineN Sym SymLst nil nil PFLst))
              (if (member Sym (list "A923" "A930" "A931"))
                        (setq DoTo (RepLst DoTo (+ (nth 4 DoTo) 90.0) 4))
              )
              (setq DoTo (cons "INSERT" DoTo))
              (mapcar (quote command) DoTo)
              (setthk (entget (entlast)))
         );cond-10
    );end-of-condition
    ;    Cleanup and exit
    (setvar "OSMODE" omod)
    (setvar "ATTREQ" AttWas)
	(setvar "ATTDIA" AttDWas)		; [ADDED] due to AutoCAD 2016
    (command "_.UNDO" "_EN")
    (if Bug (princ "\nSymEntryNew exited}\n"))
    (princ)
);end-of-defun
;
;
(defun SymEntryOld (    Sym LType Fnct Invrt Rot /    ; Hopeful menu entry replacement
                   Bubba Gap Lngth SymNam PLName LName
                   DoOne DoTwo DoThr DoFor DoFiv GetOne
                   pfent spt cpt m slope pos omod
                   mp slopep plname hlfwth plthk ipt AttWas ) ; DoTo PFLst SymLst
;   Functions called:
;        SetScale
;        PFindN
;        SymSizN
;        MkLay
;        FreeStandN
;        movlast
;        setthk
;        Att-Chg-Lay
;        Drw_Arr
;        Att-NM
;        Att-Up
;        ocrfix
;        regarr
    (if Bug (princ "\n{SymEntryN entered"))
    (setq     AttWas    (getvar "ATTREQ"))
    (if (/= (getvar "ATTREQ") 1) (setvar "ATTREQ" 1))
    (cond
         ((and (not sff) sf)
              (setq     sff  (/ sf 0.3048))
         );cond-1
         ((and (not sf) sff)
              (setq     sf   (* sff 0.3048))
         );cond-2
         ((and (not sff) (not sf))
              (SetScale)
         );cond-3
    );end-of-condition
    (command "_.UNDO" "_BE")
    (setq     omod      (getvar "OSMODE"))
    (setvar "OSMODE" 0)
    (if (= Fnct "FS")
         (setq PFLst (PFindN T))
         (setq PFLst (PFindN nil))
    )
    (if PFLst
         (setq pfent  (nth 0 PFLst)
               spt    (nth 1 PFLst)
               cpt    (nth 2 PFLst)
               m      (nth 3 PFLst)
               slope  (nth 4 PFLst)
               mp     (nth 5 PFLst)
               slopep (nth 6 PFLst)
               plname (nth 7 PFLst)
               hlfwth (nth 8 PFLst)
               plthk  (nth 9 PFLst)
               ipt    (nth 10 PFLst)
         )
         (progn
              (alert (strcat "**" AppNam " Error**\nNo Polydata passed"))
              (exit)
         )
    );end-of-if
    (setq SymLst (SymSizN Sym)
          Gap    (nth 0 SymLst)
          Lngth  (nth 1 SymLst)
          SymNam (nth 2 SymLst)
    )
    (if Fnct
         (if (/= Fnct "FS")
              (if (or (= LType "SW") (= Fnct "IL"))
                   (if (not (tblsearch "LAYER" (strcat (substr PLName 1 4) "FL-" (substr PLName 8))))
                        (MkLay                 (strcat (substr PLName 1 4) "FL-" (substr PLName 8)))
                   )
              )
         )
    )
    
    (if (and LName SymLst)
         (setq SymLst (reverse (cons LName (reverse SymLst))))
    )
    (cond
         ((= Fnct "FS")
              (if (= LType "LM")
                   (setq LName "----LM----")
                   (if (member LType (list "ULO--" "-LO--" "-NO--"))
                        (setq LName (MkLay (strcat (substr PLName 1 3) LType (substr PLName 9))))
                        (if LType
                             (setq LName (MkLay (strcat (substr PLName 1 4) LType (substr PLName 7))))
                             (setq LName PLName)
                        )
                   )
              )
              (if Bug (princ "\nFnct = FS"))
         );cond-1
         ((= Fnct "PM")
              (if Bug (princ "\nFnct = PM"))
         );cond-2
         ((= LType "CP")
              (if Bug (princ "\nLType = CP"))
              (MkLay      (strcat (substr PLName 1 3) "-" LType "--" (substr PLName 9)))
              (setq LName (strcat (substr PLName 1 3) "-" LType "--" (substr PLName 9)))
         );cond-3
         ((= LType "SW")
              (if Bug (princ "\nSym = CS"))
              (MkLay      (strcat (substr PLName 1 4) "SW-" (substr PLName 8)))
              (MkLay      (strcat (substr PLName 1 4) "SWD" (substr PLName 8)))
              (setq LName (strcat (substr PLName 1 4) "SW-" (substr PLName 8)))
         );cond-4
         ((or (= Sym "FD_NUM2") (= Sym "A080"))
              (if Bug (princ "\nSym = FD_NUM2 or A080"))
              (setq LName (strcat (substr PLName 1 3) "O" (substr PLName 5)))
         );cond-5
         (LType
              (if Bug (princ (strcat "\nLType=" LType)))
              (MkLay      (strcat (substr PLName 1 4) LType (substr PLName 7)))
              (setq LName (strcat (substr PLName 1 4) LType (substr PLName 7)))
         );cond-5
         (T
              (setq LName  PLName)
         );cond-6
    );end-of-condition
    (if (and LName SymLst)
         (setq SymLst (reverse (cons LName (reverse SymLst))))
    )
    (cond
         ((and     (member Sym (list "_BLDG" "_CHURCH" "_SCHOOL" "CEMETERY" "A081" "A086"))   ; "PARCEL" "NO" "URD_LOC" "TREE"
                   (= Fnct "FS")
          )
              (setq DoTo (FreeStandN SymLst PFLst))
              (if (and Bug Doto) (setq EdsDoto Doto))
              (cond
;                  ((member Sym (list "PARCEL"))
;                       (setq DoOne (strcase (getstring T "\nParcel Number: "))
;                             DoTo  (cons "INSERT" DoTo)
;                             DoTo  (append DoTo (list DoOne))
;                       )
;                  )
                   ((member Sym (list "_CHURCH"))
                        (setq DoOne (strcase (getstring T "\nChurch Name: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne))
                        )
                   );cond-1
                   ((member Sym (list "_SCHOOL"))
                        (setq DoOne (strcase (getstring T "\nSchool Name: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne))
                        )
                   );cond-2
                   ((member Sym (list "_BLDG"))
                        (setq DoOne (strcase (getstring T "\nBuilding Name: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne))
                        )
                   );cond-3
                   ((member Sym (list "CEMETERY"))
                        (setq DoOne (strcase (getstring T "\nCemetery Name: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne))
                        )
                   );cond-4
;                  ((member Sym (list "NO"))
;                       (setq DoTo (cons "INSERT" DoTo))
;                  )
;                  ((member Sym (list "URD_LOC"))
;                       (setq DoOne (strcase (getstring T "\nUnderground Location: "))
;                             DoTo  (cons "INSERT" DoTo)
;                             DoTo  (append DoTo (list DoOne))
;                       )
;                  )
                   ((member Sym (list "A081"))
                        (setq DoOne (strcase (getstring T "\nUnderground Location Number: "))
                              DoTwo (strcase (getstring T "\nDescription: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-5
                   ((member Sym (list "A086"))
                        (setq DoOne (strcase (getstring T "\nWork Location Number: "))
                              DoTwo (strcase (getstring T "\nDescription: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-6
;                  ((member Sym (list "TREE"))
;                       (setq DoTo (cons "INSERT" DoTo))
;                  )
              );end-of-condition
              (mapcar (quote command) DoTo)
              (MovLast)
              (setthk (entget (entlast)))
              (Att-Chg-Lay)
         );cond-1
         ((and (member Sym (list "A183"  "A104"  "A100"  "A082"  "A156"))   ; "LFSP" "_KEY" "_SGEN" "_CATV" "_DA" "ANG" "CE" "LOC" "LTNO" "SENSNO" "SWNO" "STN"
               (= Fnct "FS")
          )
              (setq DoTo (FreeStandN SymLst PFLst))
              (cond
;                  ((member Sym (list "LFSP"))
;                       (setq DoOne (strcase (getstring T "\nLife Support Name: "))
;                             DoTwo (strcase (getstring T "\nLife Support Description: "))
;                             DoTo  (cons "INSERT" DoTo)
;                             DoTo  (append DoTo (list DoOne DoTwo))
;                       )
;                  )
                   ((member Sym (list "_KEY" "A183"))
                        (setq DoOne (strcase (getstring T "\nKey Account Name: "))
                              DoTwo (strcase (getstring T "\nKey Account Description: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-1
                   ((member Sym (list "_DA" "A156"))
                        (setq DoOne (strcase (getstring T "\nRTU Number: "))
                              DoTwo (strcase (getstring T "\nSCADA Substation Name: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-2
;                  ((member Sym (list "_SGEN"))
;                       (setq DoOne (strcase (getstring T "\nAPCO Customer Equipment Number: "))
;                             DoTo  (cons "INSERT" DoTo)
;                             DoTo  (append DoTo (list DoOne))
;                       )
;                  )
                   ((member Sym (list "A104"))
                        (setq DoOne (strcase (getstring T "\nGenerator Number: "))
                              DoTwo (strcase (getstring T "\nDescription: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-3
;                  ((member Sym (list "_CATV"))
;                       (setq DoOne (strcase (getstring T "\nCATV Number: "))
;                             DoTo  (cons "INSERT" DoTo)
;                             DoTo  (append DoTo (list DoOne))
;                       )
;                  )
                   ((member Sym (list "A100"))
                        (setq DoOne (strcase (getstring T "\nCATV Number: "))
                              DoTwo (strcase (getstring T "\nDescription: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-4
;                  ((member Sym (list "ANG"))
;                       (setq DoOne (strcase (getstring T "\nAngle: "))
;                             DoTo  (cons "INSERT" DoTo)
;                             DoTo  (append DoTo (list DoOne))
;                       )
;                  )
;                  ((member Sym (list "CE"))
;                       (setq DoOne (strcase (getstring T "\nAPCO Customer Equipment Number: "))
;                             DoTo  (cons "INSERT" DoTo)
;                             DoTo  (append DoTo (list DoOne))
;                       )
;                  )
                   ((member Sym (list "A082"))
                        (setq DoOne (strcase (getstring T "\nAPCO Customer Equipment Number: "))
                              DoOne (if (> (strlen DoOne) 2)
                                         (if (/= (strcase (substr DoOne 1 2)) "CE") (strcat "CE-" DoOne) DoOne)
                                         (strcat "CE-" DoOne)
                                    )
                              DoTwo (strcase (getstring T "\nDescription: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-5
;                  ((member Sym (list "LOC"))
;                       (setq DoOne (strcase (getstring T "\nLocation Number: "))
;                             DoTo  (cons "INSERT" DoTo)
;                             DoTo  (append DoTo (list DoOne))
;                       )
;                  )
;                  ((member Sym (list "LTNO"))
;                       (setq DoOne (strcase (getstring T "\nLight Number: "))
;                             DoTo  (cons "INSERT" DoTo)
;                             DoTo  (append DoTo (list DoOne))
;                       )
;                  )
;                  ((member Sym (list "SENSNO"))
;                       (setq DoOne (strcase (getstring T "\nRTU Number: "))
;                             DoTo  (cons "INSERT" DoTo)
;                             DoTo  (append DoTo (list DoOne))
;                       )
;                  )
;                  ((member Sym (list "SWNO"))
;                       (setq DoOne (strcase (getstring T "\nSwitch Number: "))
;                             DoTwo (strcase (getstring T "\nFuse Info: "))
;                             DoTo  (cons "INSERT" DoTo)
;                             DoTo  (append DoTo (list DoOne))
;                             DoTo  (append DoTo (list DoTwo))
;                       )
;                  )
;                  ((member Sym (list "STN"))
;                       (setq DoOne (strcase (getstring T "\nPrefix to Station Number: "))
;                             DoTwo (strcase (getstring T "\nStation Number: "))
;                             DoTo  (cons "INSERT" DoTo)
;                             DoTo  (append DoTo (list DoOne))
;                             DoTo  (append DoTo (list DoTwo))
;                       )
;                  )
              );end-of-condition
              (mapcar (quote command) DoTo)
              (MovLast)
              (setthk (entget (entlast)))
              (Att-Chg-Lay)
              (Drw_Arr nil)
         );cond-2
         ((and     (member Sym (list "A076"))    ; "SUBCUST"
                   (= Fnct "FS")
          )
              (setq DoTo (FreeStandN SymLst PFLst))
              (cond
                   ((member Sym (list "SUBCUST" "A076"))
                        (setq DoOne (strcase (getstring T "\nCustomer Substation Number: "))
                              DoTwo (strcase (getstring T "\nSubstation Rating: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   )
              );end-of-condition
              (mapcar (quote command) DoTo)
              (MovLast)
              (setthk (entget (entlast)))
              (Att-Chg-Lay)
              (Att-NM)
         );cond-3
         ((member Sym (list "A150"))   ; "PM"
              (setq DoTo (PM_OnLineN SymLst PFLst LType))
              (cond
;                  ((member Sym (list "PM"))
;                       (setq DoOne (strcase (getstring T "\nCustomer Name: "))
;                             DoTo  (cons "INSERT" DoTo)
;                             DoTo  (append DoTo (list DoOne))
;                       )
;                  )
                   ((member Sym (list "A150"))
                        (setq DoOne (strcase (getstring T "\nCustomer Name: "))
                              DoTwo (strcase (getstring T "\nDescription: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   )
              )
              (mapcar (quote command) DoTo)
              (setthk (entget (entlast)))
              (Att-NM)
         );cond-4
;        ((member Sym (list "PM_END"))
;             (setq DoTo (PM_EndLineN SymLst PFLst Invrt Rot))
;             (cond
;                  ((member Sym (list "PM_END"))
;                       (setq DoOne (strcase (getstring T "\nCustomer Name: "))
;                             DoTo  (cons "INSERT" DoTo)
;                             DoTo  (append DoTo (list DoOne))
;                       )
;                  )
;             )
;             (mapcar (quote command) DoTo)
;             (setthk (entget (entlast)))
;             (if (and (= Invrt "Y") (= Rot "Y"))
;                  (Att-Up)
;             )
;             (Att-NM)
;        )
         ((and (= Fnct "IL") (member Sym (list "A065" "A071" "A077" "A078" "A079" "A084" "A085" "A109" "A154" "A157"
                                               "A160" "A161" "A121" "A123" "A126" "A131" "A135" "A138" "A142" "A164"
                                               "A171" "A173" "A176" "A181" "A190" "A191" "A196" "A197" "A198" "A199")
                             )) ;"CR" "CS" "CS2" "DR" "DS" "DS2" "GR" "GS" "GS2" "MOGS" "SMS" "UGOPEN"
              (setq DoTo (In_LineN Sym SymLst Invrt Rot PFLst))
              (cond
                   ((member Sym (list "CR" "DR" "GR" "CS" "DS" "GS" "CS2" "DS2" "GS2" "UGOPEN" "A084" "A085"))
                        (setq DoOne (strcase (getstring T "\nSwitch Number: "))
                              DoOne (if (> (strlen DoOne) 3)
                                         (if (/= (strcase (substr DoOne 1 3)) "ATS") (strcat "ATS-" DoOne) DoOne)
                                         (strcat "ATS-" DoOne)
                                    )
                              DoTwo (strcase (getstring T "\nAmperage: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-1                   
                   ((member Sym (list "A135"))
                        (setq DoOne (strcase (getstring T "\nPotential Device Number: "))
                              DoTwo (strcase (getstring T "\nDescription: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-2
                   ((member Sym (list "A065" "A131"))
                        (setq DoOne (strcase (getstring T "\nFuse Number: "))
                              DoTwo (strcase (getstring T "\nDescription: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-3
                   ((member Sym (list "A160" "A161"))
                        (setq DoOne (strcase (getstring T "\nInterrupter Number: "))
                              DoTwo (strcase (getstring T "\nDescription: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-4
                   ((member Sym (list "A154" "A157"))
                        (setq DoOne (strcase (getstring T "\nOil Switch Number: "))
                              DoTwo (strcase (getstring T "\nDescription: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-5
                   ((member Sym (list "A164" "A181"))
                        (setq DoOne (strcase (getstring T "\nBreaker Number: "))
                              DoTwo (strcase (getstring T "\nDescription: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-6
                   ((member Sym (list "A138" "A142"))
                        (setq DoOne (strcase (getstring T "\nFeeder Breaker Number: "))
                              DoTwo (strcase (getstring T "\nDescription: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-7
                   ((member Sym (list "A198" "A199"))
                        (setq DoOne (strcase (getstring T "\nProtector Number: "))
                              DoTwo (strcase (getstring T "\nDescription: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-8
                   ((member Sym (list "MOGS"))
                        (setq DoOne (strcase (getstring T "\nSwitch Number: "))
                              DoTwo (strcase (getstring T "\nRTU Number: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-9
                   ((member Sym (list "A190" "A191" "A126" "A173" "A196" "A197" "A171" "A123" "A176" "A121"))
                        (setq DoOne (strcase (getstring T "\nSwitch Number: "))
                              DoTwo (strcase (getstring T "\nDescription: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-10
                   ((member Sym (list "A078" "A079"))
                        (setq DoOne (strcase (getstring T "\nPad Number: "))
                              DoTwo (strcase (getstring T "\nDescription: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-11
                   ((member Sym (list "A077"))
                        (setq DoOne (strcase (getstring T "\nTransclosure Number: "))
                              DoTwo (strcase (getstring T "\nDescription: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-12
                   ((member Sym (list "A109" "A071"))
                        (setq DoOne (strcase (getstring T "\nOpen Circuit Number: "))
                              DoTwo (strcase (getstring T "\nDescription: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-13
;                  ((member Sym (list "SMS"))
;                       (setq DoOne (strcase (getstring T "\nSwitch Number: "))
;                             DoTwo (strcase (getstring T "\nSCADA Mate Number: "))
;                             DoThr (strcase (getstring T "\nRTU Number: "))
;                             DoTo  (cons "INSERT" DoTo)
;                             DoTo  (append DoTo (list DoOne DoTwo DoThr))
;                       )
;                  )
              );end-of-condition
              (mapcar (quote command) DoTo)
              (setthk (entget (entlast)))
              (Att-Up)
              (Att-Chg-Lay)
         );cond-5
         ((and (= Fnct "IL") (member Sym (list "A101" "A105" "A122" "A124" "A125" "A125S" "A132" "A134" "A148"
                                               "A155" "A169" "A170" "A170S" "A172" "A193" "A194" "A167" "A175"
                                               "A177" "A180"))) ;"CAP" "SENSOR" "STEPTRAN" "_CC_B" "_CC_T"
                                                                ;"_OCR" "_OCR_BP" "_OCR_EL" "_SECT" "_SS" "_SSR"
              (setq     DoTo      (In_LineN Sym SymLst Invrt Rot PFLst))
              (cond
                   ((member Sym (list "STEPTRAN" "A122"))
                        (setq DoOne (strcase (getstring T "\nTransformer Number: "))
                              DoTwo (strcase (getstring T "\nTransformer Type: "))
                              DoTo  (if (member Sym (list "A122"))
                                         (RepLst DoTo (+ (nth 4 DoTo) 90.0) 4)
                                         DoTo
                                    )
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-1
                   ((member Sym (list "_OCR"))
                        (setq DoOne (strcase (getstring T "\nOCR Number: "))
                              DoTwo (strcase (getstring T "\nOCR Size: "))
                              DoThr (strcase (getstring T "\nOCR Type: "))
                              DoFor (strcase (getstring T "\nSource Side Number: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo DoThr DoFor "S"))
                        )
                   );cond-2
                   ((member Sym (list "A105" "A169" "A193" "A194"))
                        (setq DoOne (strcase (getstring T "\nOCR Number: "))
                              DoTwo (strcase (getstring T "\nDescription (Size and Type): "))
                              DoThr (strcase (getstring T "\nSource Side Switch: "))
                              DoFor (strcase (getstring T "\nLoad Side Switch: "))
                              DoFiv (strcase (getstring T "\nBypass Switch: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne
                                                       DoTwo
                                                       DoThr
                                                       (if (and (>= (strlen DoThr) 1) (/= DoThr " "))
                                                           "S"
                                                           " "
                                                       )
                                                       DoFor
                                                       (if (and (>= (strlen DoFor) 1) (/= DoFor " "))
                                                           "L"
                                                           " "
                                                       )
                                                       DoFiv
                                                       (if (and (>= (strlen DoFiv) 1) (/= DoFiv " "))
                                                           "B"
                                                           " "
                                                       )
                                                 )
                                    )
                        );end-of-setq
                   );cond-3
  ;                ((member Sym (list "_OCR_BP"))
  ;                     (setq DoOne (strcase (getstring T "\nOCR Number: "))
  ;                           DoTwo (strcase (getstring T "\nOCR Size: "))
  ;                           DoThr (strcase (getstring T "\nOCR Type: "))
  ;                           DoFor (strcase (getstring T "\nSource Side Number: "))
  ;                           DoFiv (strcase (getstring T "\nBypass Number: "))
  ;                           DoTo  (cons "INSERT" DoTo)
  ;                           DoTo  (append DoTo (list DoOne DoTwo DoThr DoFor "S" DoFiv "B"))
  ;                     )
  ;                )
  ;                ((member Sym (list "_OCR_EL"))
  ;                     (setq DoOne (strcase (getstring T "\nOCR Number: "))
  ;                           DoTwo (strcase (getstring T "\nOCR Size: "))
  ;                           DoThr (strcase (getstring T "\nOCR Type: "))
  ;                           DoFor (strcase (getstring T "\nSource Side Number: "))
  ;                           DoFiv (strcase (getstring T "\nBypass Number: "))
  ;                           DoSix (strcase (getstring T "\nLoad Side Number: "))
  ;                           DoTo  (cons "INSERT" DoTo)
  ;                           DoTo  (append DoTo (list DoOne DoTwo DoThr DoFor "S" DoFiv "B" DoSix "L"))
  ;                     )
  ;                )
                   ((member Sym (list "A170S" "A125S" "A170" "A125" "A172" "A124"))      ;"_SS" "_SSR"
                        (setq DoOne (strcase (getstring T "\nSwitch Number: "))
                              DoTwo (strcase (getstring T "\nAmperage: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-4
                   ((member Sym (list "A167" "A175" "A177" "A180"))
                        (setq DoOne (strcase (getstring T "\nElbow Number: "))
                              DoTwo (strcase (getstring T "\nDescription: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-5
  ;                ((member Sym (list "_SECT"))
  ;                     (setq DoOne (strcase (getstring T "\nSectionalizer Number: "))
  ;                           DoTwo (strcase (getstring T "\nSectionalizer Size: "))
  ;                           DoTo  (cons "INSERT" DoTo)
  ;                           DoTo  (append DoTo (list DoOne DoTwo))
  ;                     )
  ;                )                   
                   ((member Sym (list "A132" "A134"))
                        (setq DoOne (strcase (getstring T "\nUnit Number: "))
                              DoTwo (strcase (getstring T "\nDescription: "))
                              DoTo  (RepLst DoTo (+ (nth 4 DoTo) 90.0) 4)
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-6
                   ((member Sym (list "A101"))   ; "CAP"
                        (setq DoOne (strcase (getstring T "\nCapacitor Number: "))
                              DoTwo (strcase (getstring T "\nKVAR: "))
                              DoThr (strcase (getstring T "\nSwitched? <S>: "))
                              DoThr (if (or (< (strlen DoThr) 1) (= DoThr " ")) "S" DoThr)
                              DoTo  (RepLst DoTo (+ (nth 4 DoTo) 90.0) 4)
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (if (member Sym (list "CAP"))
                                         (append DoTo (list DoOne DoTwo DoThr))
                                         (append DoTo (list DoOne (strcat DoTwo " " DoThr)))
                                    )
                        )
                   );cond-7
;                  ((member Sym (list "_CC_B" "_CC_T"))
;                       (setq DoOne (strcase (getstring T "\nCritical Customer Number: "))
;                             DoTo  (cons "INSERT" DoTo)
;                             DoTo  (append DoTo (list DoOne))
;                       )
;                  )
                   ((member Sym (list "A148"))
                        (setq DoOne (strcase (getstring T "\nCritical Customer Number: "))
                              DoTwo (strcase (getstring T "\nDescription: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   );cond-8
                   ((member Sym (list "A155"))   ;"SENSOR" 
                        (setq DoOne (strcase (getstring T "\nSensor Number: "))
                              DoTwo (if (member Sym (list "A155"))
                                         (strcase (getstring T "\nDescription: "))
                                         " "
                                    )
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (if (member Sym (list "SENSOR"))
                                         (append DoTo (list DoOne))
                                         (append DoTo (list DoOne DoTwo))
                                    )
                        )
                   );cond-9
              );end-of-condition
              (mapcar (quote command) DoTo)
              (setthk (entget (entlast)))
;             (if (member Sym (list "_OCR" "_OCR_BP" "_OCR_EL"))
;                  (ocrfix)
;             )
              (if (member Sym (list "A122"));"STEPTRAN" "_OCR" "_OCR_BP" "_OCR_EL" "_SS" "_SSR" "_SECT" "CAP" "_CC_T" "_CC_B" "SENSOR"
                   (Att-Up)
              )
              (Att-Chg-Lay)
              (if (member Sym (list "A122"));"STEPTRAN" "_OCR" "_OCR_BP" "_OCR_EL" "_SS" "_SSR" "_SECT" "CAP" "_CC_T" "_CC_B" "SENSOR"
                   (Att-NM)
              )
         );cond-6
         ((and (= Fnct "IL")(member Sym (list "A120" "A133" "A188" "A189" "A192" "A195")))    ; "REG" "REGA"
              (setq DoTo (In_LineN Sym SymLst Invrt Rot PFLst))
              (cond
;                  ((member Sym (list "REG"))
;                       (setq DoOne (strcase (getstring T "\nAmps: "))
;                             DoTwo (strcase (getstring T "\nRegulator Type: "))
;                             DoTo  (cons "INSERT" DoTo)
;                             DoTo  (append DoTo (list DoOne DoTwo))
;                       )
;                  )
                   ((member Sym (list "A120" "A188"))                               ; "REGA"
                        (setq DoOne (strcase (getstring T "\nBooster Type: "))
                              DoTwo (strcase (getstring T "\nAmps: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   )
                   ((member Sym (list "A133" "A195" "A189" "A192"))
                        (setq DoOne (strcase (getstring T "\nRegulator Number: "))
                              DoTwo (strcase (getstring T "\nRegulator Description: "))
                              DoTo  (cons "INSERT" DoTo)
                              DoTo  (append DoTo (list DoOne DoTwo))
                        )
                   )
              )
              (mapcar (quote command) DoTo)
              (setthk (entget (entlast)))
              (Att-Up)
              (Att-Chg-Lay)
              (Att-NM)
              (if (member Sym (list "REG" "REGA"))
                   (RegArrN SymLst PFLst)
              )
              (setthk (entget (entlast)))
         );cond-7
         ((and (= Fnct "IL")(member Sym (list "A080")))    ;"FD_NUM2"
              (setq DoTo (In_LineN Sym SymLst Invrt Rot PFLst))
              (cond
                   ((member Sym (list "A080"))   ;"FD_NUM2" 
                        (if LName
                             (setq GetOne (ascii (substr LName 3 1))
                                   DoOne (if (and (>= GetOne 65) (<= GetOne 90))
                                              (itoa (- GetOne 64))
                                              (if (and (>= GetOne 97) (<= GetOne 122))
                                                   (itoa (- GetOne 96))
                                                   (strcase (getstring T "\nFeeder Number: "))
                                              )
                                         )
                                   DoTo  (cons "INSERT" DoTo)
                                   DoTo  (append DoTo (list DoOne))
                             )
                             (setq DoOne (strcase (getstring T "\nFeeder Number: "))
                                   DoTo  (cons "INSERT" DoTo)
                                   DoTo  (append DoTo (list DoOne))
                             )
                        )
                   )
              );end-of-condition
              (mapcar (quote command) DoTo)
              (setthk (entget (entlast)))
              (Att-Up)
              (Att-Chg-Lay)
              (Att-NR)
         );cond-8
         ((and (= Fnct "IL") (member Sym (list "A106" "A140")))      ;"_FI_B" "_FI_T" "T" "U" "RISER" 
              (setq DoTo (In_LineN Sym SymLst Invrt Rot PFLst)
                    DoTo (cons "INSERT" DoTo)
              )
              (mapcar (quote command) DoTo)
              (setthk (entget (entlast)))
         );cond-9
    );end-of-condition
    (setvar "OSMODE" omod)
    (setvar "ATTREQ" AttWas)
    (command "_.UNDO" "_EN")
    (if Bug (princ "\nSymEntryN exited}\n"))
    (princ)
);end-of-defun
;
;
(defun PFindN ( AskT    /    pfent spt cpt m mp  ; Retrieves pline info and finds insertion point
                             slope perpm slopep plname hlfwth plthk ipt aper Fuzz omod )
    (if Bug (princ "\n{PFindN entered"))
    (setq aper  (getvar "APERTURE") ;--Save current setting
          omod  (getvar "OSMODE")
          pfent nil
          Fuzz  0.0001
    )
    (setvar "APERTURE" (getvar "PICKBOX"))
    (setvar "OSMODE" 0)
    (if (/= (strcase Mouse) "YES") (command "TABLET" "OFF"))
    (while (null pfent)
         (if (setq pfent (entsel "\nSelect polyline: "))
              (progn
                   (setq spt (cadr pfent)             ; sets <spt> to point on edge of poly.
                         cpt (osnap spt "NEA")  ; sets <cpt> to nearest point of <spt> removed QUICK parameter W10
                   )
                   (while (equal spt cpt 0.0001)
                        (alert (strcat "*** " AppNam " Error ***"
                                       "\nStart symbol insertion again and"
                                       "\nDON'T USE OBJECT SNAP for 1st pick!"
                               )
                        )
                        (setq pfent (entsel "\nSelect polyline: ")
                              spt   (cadr pfent)
                              cpt   (osnap spt "NEA")
                        )
                   )
                   (setq pfent (entget (car pfent))) ;sets <pfent> to entity list of <pfent>
                   (if (/= (cdr (assoc 0 pfent)) "POLYLINE")
                        (setq pfent nil
                              Bubba (alert "Selected entity was not a POLYLINE...Please retry!")
                        )
                   )
              )
         )
    );end-of-while
    (if (equal (car spt) (car cpt) Fuzz)    ;---to avoid a divide-by-zero problem for
         (setq m  0                   ;   horizontal lines
               mp (/ pi 2)
         )
         (progn
              (setq mp (atan (/ (- (cadr spt) (cadr cpt)) (- (car spt) (car cpt)))))
              (if (> mp 0)
                   (setq m (- mp (/ pi 2)))
                   (progn
                        (setq m  (+ mp (/ pi 2)))
                        (setq mp (+ mp pi))
                   )
              )
         )
    )
    (setq slope  (/ (* m 180.0) pi)
          perpm  (+ m (/ pi 2))
          slopep (/ (* perpm 180.0) pi)
          plname (cdr (assoc 8 pfent))
          hlfwth (if (and Lst_Ph_W SF)
                      (* 0.5 (nth (atoi (substr (cdr (assoc 8 pfent)) 8 1)) Lst_Ph_W) SF)
                      (if (not Lst_Ph_W)
                           (alert "Tables not loaded!")
                           (if (not SF)
                                (progn
                                     (SetScale)
                                     (* 0.5 (nth (atoi (substr (cdr (assoc 8 pfent)) 8 1)) Lst_Ph_W) SF)
                                )
                           )
                      )
                 )
    );end-of-setq
    (if (assoc 39 pfent)
         (setq plthk (cdr (assoc 39 pfent)))
         (setq plthk 0.0)
    )
    (if AskT
         (setq ipt  cpt)
         (progn
              (princ "\nPress\t<Enter> to use existing insertion point or")
              (setq ipt (Getpoint "\n\tuse OSNAP to redefine point: "))
              (if (null ipt)
                   (setq ipt cpt)
                   (setq ipt (osnap ipt "NEA"))
              )
         )
    )
    (if plname
         (setvar "CLAYER" plname)
    )
    (setvar "OSMODE" omod)
    (setvar "APERTURE" aper)
; Passed Lst  :(Return Value)
;             : pfent - is ENTITY LIST of polyline selected
;             : spt - is point on edge of polyline selected
;             : cpt - is OSNAP of spt
;             : m, slope - is the slope in radians/degrees respectfully
;             : mp, slopep - is the perpendicular in rad./deg. respectfully
;             : plname - is name of polyline
;             : hlfwth - is distance from center to edge of polyline
;             : plthk  - is the thickness of the polyline.
;             : ipt - is the insertion point using object snap (ctr pline)
    (if Bug (princ "\nPFindN exited}\n"))
    (list pfent spt cpt m slope mp slopep plname hlfwth plthk ipt)
);end-of-defun
;
;
(defun Do_GapN ( Sym SymLst PFLst / Hole      ; cuts a hole in an existing polyline at a point
                                    pfent spt cpt m slope
                                    mp slopep plname hlfwth plthk ipt
                                    Gap Lngth SymNam LName
                                    Pt1 Pt2 ss1 ss2 PfEnts ent1 ent2
                                    entPt1 entPt2 Bubba omod FLay )
    (if Bug 
         (progn
              (princ "\n{Do_GapN entered - Parameters")
              (princ "\n  - Sym = ") (prin1 Sym)
              (princ "\n  - SymLst = ") (prin1 SymLst)
              (princ "\n  - PFLst = ") (prin1 PFLst)
         )
    )
    (setq     omod      (getvar "OSMODE"))
    (setvar "OSMODE" 0)
    (if PFLst
         (setq pfent  (nth 0 PFLst)
               spt    (nth 1 PFLst)
               cpt    (nth 2 PFLst)
               m      (nth 3 PFLst)
               slope  (nth 4 PFLst)
               mp     (nth 5 PFLst)
               slopep (nth 6 PFLst)
               plname (nth 7 PFLst)
               hlfwth (nth 8 PFLst)
               plthk  (nth 9 PFLst)
               ipt    (nth 10 PFLst)
               Bubba  (if (and Bug PLName)
			 		(progn
                           (princ (strcat "\nDo_GapN->PLName:" PLName))
					   (princ "\n  - ipt = ") (prin1 ipt)
                      	)
				   )
               AbsWth (cdr (assoc 40 (entget (entnext (cdr (assoc -1 pfent))))))
         )		
         (progn
              (alert (strcat "**" AppNam " Error**\nNo Polydata passed"))
              (exit)
         )
    );end-of-if
    (if (and Bug SymLst)
         (princ (strcat "\nSymLst is " (itoa (length SymLst)) " items"))
    )
    (if SymLst
         (setq Gap   (nth 0 SymLst)
               Bubba (if (and Bug Gap)
                          (princ (strcat "\nDo_GapN->Gap:" Gap))
                     )
               Lngth (nth 1 SymLst)
               Bubba (if (and Bug Lngth)
                          (princ (strcat "\nDo_GapN->Lngth:" (rtos Lngth 2 4)))
                     )
               SymNam(nth 2 SymLst)
               Bubba (if (and Bug SymNam)
                          (princ (strcat "\nDo_GapN->SymNam:" SymNam))
                     )
               LName (nth 3 SymLst)
               Bubba (if (and Bug LName)
                          (princ (strcat "\nDo_GapN->LName:" LName))
                     )
         )
         (progn
              (alert (strcat "**" AppNam " Error**\nNo Polydata passed"))
              (exit)
         )
    );end-of-if
    (if Lngth
         (setq Hole (* sf Lngth))
    )
    (if (and Gap pfent)
         (cond
              ((= Gap "N")                       ;--- If Gap="N", don't do anything-------
                   (if Bug (princ "\nGap=N, do nothing!"))
                   (setq Pt2 nil
                         Pt1 nil
                   )
              );cond-1
              ((= Gap "C")
                   (if Bug (princ "\nGap=C, do centered!"))
                   (if (member Sym (list "_FI_T" "_FI_B" "_CC_T" "_CC_B" "CAP" "A106" "A148" "A101"))
                        (setq Pt2  ipt
                              Pt1  ipt
                        )
                        (setq Pt2  (polar ipt m (/ Hole 2))
                              Pt1  (polar ipt (+ pi m) (/ Hole 2))
                        )
                   )
				(if Bug (princ "\nGap=C, do centered! - DONE"))
              );cond-2
              ((= Gap "M")
                   (if Bug (princ "\nGap=M, do middle!"))
                   (setq Pt2  (polar ipt m Hole)
                         Pt1  ipt
                   )
              );cond-3
              (T
                   (if Bug (princ "\nGap=T, do nothing!"))
                   (setq Pt2  nil
                         Pt1  nil
                   )
              );cond-4
         );end-of-condition
    );end-of-if
    (if (and Pt1 Pt2)
         (setq ss0 (ssget "CP" (list (polar Pt1 (+ (/ pi 2.0) m) (* 1.05 AbsWth))
                                     (polar Pt2 (+ (/ pi 2.0) m) (* 1.05 AbsWth))
                                     (polar Pt2 (+ (/ (* 3.0 pi) 2.0) m) (* 1.05 AbsWth))
                                     (polar Pt1 (+ (/ (* 3.0 pi) 2.0) m) (* 1.05 AbsWth))
                               )
                               (list (cons 0 "INSERT")
                                     (cons 8 "????SW-*")
                               )
                   )
         )
         (setq ss0 nil)
    )
    (if ss0
         (progn                   ; If switch interferes, tell the user...
              (alert (strcat "**" AppNam " Error**\nNon-valid Circuit Location\nSwitch Interference!"))
              (exit)
         )
    )
	(if (and Pt1 Pt2)
         (setq ss1 (ssget "CP" (list (polar Pt1 (+ (/ pi 2.0) m) (* 1.05 AbsWth))
                                     (polar Pt2 (+ (/ pi 2.0) m) (* 1.05 AbsWth))
                                     (polar Pt2 (+ (/ (* 3.0 pi) 2.0) m) (* 1.05 AbsWth))
                                     (polar Pt1 (+ (/ (* 3.0 pi) 2.0) m) (* 1.05 AbsWth))
                               )
                               (list (cons 0 "POLYLINE")
                                     (cons 8 "????CK-*")
                               )
                   )
         )
         (setq ss1 nil)
    )
	(if ss1
         (cond
              ((= (sslength ss1) 1)              ; If there is just one PLine...
                   (setq PfEnts (cons (cdr (assoc -1 pfent)) (list Pt1))
                         ss2    (ssget "F" (list (polar Pt2 (+ (/ pi 2.0) m) (* 1.05 AbsWth))
                                                 (polar Pt2 (+ (/ (* 3.0 pi) 2.0) m) (* 1.05 AbsWth))
                                           )
                                           (list (cons 0 "POLYLINE")
                                                 (cons 8 PLName)
                                           )
                                )
                         entL   (entlast)
                   )
                   (if ss2                       ; If the same PLine is at the other end of the Switch...
                        (if (equal (ssname ss2 0) (cdr (assoc -1 PfEnt)))
                             (progn
                                  (setq Bubba   (if Bug (princ "\nDo_GapN breaks one continuous PLine!"))
                                        NentLst (list T)
                                  )
                                  (command "BREAK" PfEnts Pt2)
                                  (FixNearVrt entL Pt2)
                             )
                        )
                        (progn                   ; If no PLine at endpoint, tell the user...
                             (alert (strcat "**" AppNam " Error**\nNo endpoint Circuit"))
                             (exit)
                        )
                   )
              );cond-1
              ((= (sslength ss1) 2)              ; If there are two PLines...
                   (if (equal (ssname ss1 0) (cdr (assoc -1 PfEnt)))
                        (setq ent2 (ssname ss1 1)
                              ent1 (ssname ss1 0)
                              ss2  (ssget "F" (list (polar Pt2 (+ (/ pi 2.0) m) (* 1.05 AbsWth))
                                                    (polar Pt2 (+ (/ (* 3.0 pi) 2.0) m) (* 1.05 AbsWth))
                                              )
                                              (list (cons 0 "POLYLINE")
                                                    (cons 8 PLName)
                                              )
                                   )
                        )
                        (setq ent2 (ssname ss1 0)
                              ent1 (ssname ss1 1)
                              ss2  (ssget "F" (list (polar Pt2 (+ (/ pi 2.0) m) (* 1.05 AbsWth))
                                                    (polar Pt2 (+ (/ (* 3.0 pi) 2.0) m) (* 1.05 AbsWth))
                                              )
                                              (list (cons 0 "POLYLINE")
                                                    (cons 8 PLName)
                                              )
                                   )
                        )
                   );end-of-if
                   (if ss2                       ; If the 2nd PLine is similar...
                        (if (equal (ssname ss2 0) (cdr (assoc -1 PfEnt)))
                             (progn
                                  (alert (strcat "**" AppNam " Error**\nNon-valid Circuit Configuration\nToo Many Circuits!"))
                                  (exit)
                             )
                             (if  (TestEnds (GetPLEnd ent1)
                                            (GetPLEnd ent2)
                                            (polar Pt1 (+ (/ pi 2.0) m) (* 1.05 AbsWth))
                                            (polar Pt2 (+ (/ pi 2.0) m) (* 1.05 AbsWth))
                                            (polar Pt2 (+ (/ (* 3.0 pi) 2.0) m) (* 1.05 AbsWth))
                                            (polar Pt1 (+ (/ (* 3.0 pi) 2.0) m) (* 1.05 AbsWth))
                                  )
                                  (setq entPt1 (cons ent1 (list Pt1))
                                        entPt2 (cons ent2 (list Pt2))
                                        Bubba  (if Bug (setq EdsTE (list (GetPLEnd ent1)
                                                                         (GetPLEnd ent2)
                                                                         (polar Pt1 (+ (/ pi 2.0) m) (* 1.05 AbsWth))
                                                                         (polar Pt2 (+ (/ pi 2.0) m) (* 1.05 AbsWth))
                                                                         (polar Pt2 (+ (/ (* 3.0 pi) 2.0) m) (* 1.05 AbsWth))
                                                                         (polar Pt1 (+ (/ (* 3.0 pi) 2.0) m) (* 1.05 AbsWth))
                                                                   )
                                                       )
                                               )
                                        Bubba  (if Bug (princ "\nDo_GapN breaks two like PLines!"))
                                        Bubba  (command "BREAK" entPt1 Pt2)
                                        Bubba  (command "BREAK" entPt2 Pt1)
                                  )
                                  (progn
                                       (alert (strcat "**" AppNam
                                                      " Error**\nNon-valid Circuit Configuration"
                                                      "\nNot enough Endpoints in Area!"))
                                       (exit)
                                  )
                             );end-of-if
                        );end-of-if
                        (if Bug (princ "\nDo_GapN finds no second selection set to test!"))
                   );end-of-if
              );cond-2
              (T
                   (alert (strcat "**" AppNam " Error**"
                                  "\nNon-valid Circuit Location\n{"
                                  (itoa (sslength ss1))
                                  "} items interfere"
                          )
                   )
                   (exit)
              );cond-3
         );end-of-condition
         (if (member Sym (list "_FI_T" "_FI_B" "_CC_T" "_CC_B" "CAP" "A106" "A148" "A101"))
              (setq PfEnts (cons (cdr (assoc -1 pfent)) (list ipt))
                    Bubba  (if Bug (princ "\nDo_GapN breaks one PLine for Zero-Gap C items!"))
                    Bubba  (command "_.BREAK" PfEnts "F" ipt ipt)
              )
              (if Bug (princ "\nDo_GapN finds no selection set to test!"))
         )
    );end-of-if
	(cond
         ((= Gap "M")
              (setq FLay (strcat (substr plname 1 4) "FL-" (substr plname 8)))
              (if (not (LayChk FLay))
                   (MkLay FLay)
              )
              (command  "_.LAYER" "T" FLay "S" FLay "")
              (command "PLINE" Pt1 "W" (* 2 HlfWth) "" Pt2 "")
              (setthk (entget (entlast)))
         );cond-1
         ((and (= Gap "C") (not (member Sym (list "U" "T" "G" "LOC_IN" "_CC_T" "_CC_B" "_FI_T" "_FI_B"))))
              (setq FLay (strcat (substr plname 1 4) "FL-" (substr plname 8)))
              (if (not (LayChk FLay))
                   (MkLay FLay)
              )
              (command "_.LAYER" "T" FLay "S" FLay "")
              (command "PLINE" Pt1 "W" (* 2 HlfWth) "" ipt Pt2 "")
              (setthk (entget (entlast)))
         );cond-2
         (T
              (if Bug (princ "\nDo_GapN creates no Fill Line!"))
         );cond-3
    );end-of-condition
    (setvar "OSMODE" omod)
    (if Bug (princ "\nDo_GapN exited}\n"))
    PFLst
);end-of-defun
;
;
(defun In_LineN ( Sym SymLst Invrt Rot PFLst /   ; prompts the user for the placement of a Symbol
                                                 sscale hole pfent spt cpt m slope
                                                 mp slopep plname hlfwth plthk ipt
                                                 contin Gap Lngth SymNam )
; Function: The IN-LINE function prompts the user for the placement of a
;           Symbol and inserts the Symbol.
    (if Bug 
         (progn
              (princ "\n{In-LineN entered")
              (princ "\n - Parameter Sym: ")     (prin1 Sym)
              (princ "\n - Parameter SymLst: ")  (prin1 SymLst)
              (princ "\n - Parameter Invrt: ")   (prin1 Invrt)
              (princ "\n - Parameter Rot: ")     (prin1 Rot)
              (princ "\n - Parameter PFLst: ")   (prin1 PFLst)
              (princ "\n")
         )
    )
    (if PFLst
         (setq pfent  (nth 0 PFLst)
               spt    (nth 1 PFLst)
               cpt    (nth 2 PFLst)
               m      (nth 3 PFLst)
               slope  (nth 4 PFLst)
               mp     (nth 5 PFLst)
               slopep (nth 6 PFLst)
               plname (nth 7 PFLst)
               hlfwth (nth 8 PFLst)
               plthk  (nth 9 PFLst)
               ipt    (nth 10 PFLst)
         )
         (progn
              (alert (strcat "**" AppNam " Error**\nNo Polydata passed"))
              (exit)
         )
    )
    (if SymLst
         (setq Gap    (nth 0 SymLst)
               Lngth  (nth 1 SymLst)
               SymNam (nth 2 SymLst)
               LName  (nth 3 SymLst)
         )
         (progn
              (alert (strcat "**" AppNam " Error**\nNo SymbolData passed"))
              (exit)
         )
    )
    (setq sscale (* Lngth sf)
          hole   sscale
    )
    (if (= Rot "Y")
         (setq slope (+ slope 180)
               m     (+ m pi)
               PFLst (RepLst PFLst slope 4)
               PFLst (RepLst PFLst m 3)
         )
    )
    (if (= Invrt "Y")
         (setq InVert -1)
         (setq InVert 1)
    )
    (setq contin T)
    (if off_sw         ;---if global "offset switch" set, then reset ipt
         (if (not (equal ipt cpt 0.001))
              (setq ipt (polar ipt (angle ipt cpt) (* Lngth sf off_sw)))
              (progn
                   (princ "\nUnable to determine angle to offset switch! \n")
                   (setq contin nil) ;---to force abort of insertion routine
              )
         )
    )
    (if contin
         (progn
              (setq PFLst (Do_GapN Sym SymLst PFLst))
              (command "_.LAYER" "T" lname "S" lname "")
         )
    )
    (if Bug (princ "\nIn-LineN exited}\n"))
    (list (strcat _PATH-Sym Sym) ipt sscale (* invert sscale) slope)
);end-of-defun
;
;
(defun FreeStandN ( SymLst PFLst / pfent spt ; inserts the symbol 'Sym'
                                   cpt m slope mp slopep plname hlfwth plthk ipt
                                   Gap Lngth SymNam LName SymTyp )
    (if Bug (princ "\n{FreeStandN entered"))
    (if PFLst
         (cond
              ((= (type PFLst) (quote LIST))
                   (setq pfent  (nth 0 PFLst)
                         spt    (nth 1 PFLst)
                         cpt    (nth 2 PFLst)
                         m      (nth 3 PFLst)
                         slope  (nth 4 PFLst)
                         mp     (nth 5 PFLst)
                         slopep (nth 6 PFLst)
                         plname (nth 7 PFLst)
                         hlfwth (nth 8 PFLst)
                         plthk  (nth 9 PFLst)
                         ipt    (nth 10 PFLst)
                   )
              );cond-1
              ((= (type PFLst) (quote STR))
                   (setq LName PFLst)
              );cond-2
              (T
                   (alert (strcat "**" AppNam " Error**\nNo PolyData passed"))
                   (exit)
              );cond-3
         );end-of-condition
         (progn
              (setq PFLst  (PFindN T)
                    pfent  (nth 0 PFLst)
                    spt    (nth 1 PFLst)
                    cpt    (nth 2 PFLst)
                    m      (nth 3 PFLst)
                    slope  (nth 4 PFLst)
                    mp     (nth 5 PFLst)
                    slopep (nth 6 PFLst)
                    plname (nth 7 PFLst)
                    hlfwth (nth 8 PFLst)
                    plthk  (nth 9 PFLst)
                    ipt    (nth 10 PFLst)
              )
         )
    );end-of-if
    (if SymLst
         (cond
              ((= (type SymLst) (quote LIST))
                   (setq Gap    (nth 0 SymLst)
                         Lngth  (nth 1 SymLst)
                         SymNam (nth 2 SymLst)
                   )
                   (if (nth 3 SymLst)
                        (setq LName (nth 3 SymLst))
                   )
              );cond-1
              ((= (type SymLst) (quote STR))
                   (setq SymTyp SymLst
                         SymLst (SymSizN SymTyp)
                         Gap    (nth 0 SymLst)
                         Lngth  (nth 1 SymLst)
                         SymNam (nth 2 SymLst)
                   )
              );cond-2
              (T
                   (alert (strcat "**" AppNam " Error**\nNo SymbolData passed"))
                   (exit)
              );cond-3
         );end-of-condition
         (progn
              (alert (strcat "**" AppNam " Error**\nNo SymbolData passed"))
              (exit)
         )
    );end-of-if
    (cond
         ((and (= (strcase (substr AppNam 1 4)) "BEMS") (member (strcase Sym) (list "ANG" "LOC")))
              (setq LName "BUDCONST_NOTES")
         );cond-1
         ((and (= (strcase (substr AppNam 1 4)) "BEMS") (member (strcase Sym) (list "CE" "LFSP" "TREE")))
              (setq LName "BUDMISC")
         );cond-2
    );end-of-condition
    (command  "_.LAYER" "T" LName "S" LName "")
    (if Bug (princ (strcat "\nFreeStandN exited}" LName "\n")))
    (if Lngth
         (list SymNam (getvar "VIEWCTR") (* sf Lngth) "" "0")
         (list SymNam (getvar "VIEWCTR") sf "" "0")
    )
);end-of-defun
;
;
(defun PM_OnLineN ( SymLst PFLst LType / ans  ; Insert a Symbol above or below the circuit.
                                         tbx dist offset pfent spt cpt m slope mp slopep plname
                                         hlfwth plthk ipt Gap Lngth SymNam LName )
    (if Bug (princ "\n{PM_OnLineN entered"))
    (if PFLst
         (setq pfent  (nth 0 PFLst)
               spt    (nth 1 PFLst)
               cpt    (nth 2 PFLst)
               m      (nth 3 PFLst)
               slope  (nth 4 PFLst)
               mp     (nth 5 PFLst)
               slopep (nth 6 PFLst)
               plname (nth 7 PFLst)
               hlfwth (nth 8 PFLst)
               plthk  (nth 9 PFLst)
               ipt    (nth 10 PFLst)
         )
         (progn
              (alert (strcat "**" AppNam " Error**\nNo PolyData passed"))
              (exit)
         )
    )
    (if SymLst
         (setq Gap    (nth 0 SymLst)
               Lngth  (nth 1 SymLst)
               SymNam (nth 2 SymLst)
         )
         (progn
              (alert (strcat "**" AppNam " Error**\nNo SymbolData passed"))
              (exit)
         )
    )
    (setq offset  LType)
    (initget 0 "Top Bottom")
    (setq ans (getkword "\nPlace device on [T]op or on [B]ottom of circuit <T> ?"))
    (if ans
         (setq tbx (strcase (substr ans 1 1)))
         (setq tbx "T")
    )
    (setq dist (+ (* offset sf) hlfwth))
    (if (= tbx "B")
         (setq dist (- dist))
         (setq tbx  "T")
    )
    (setq ipt   (polar ipt mp dist))
    (setq LNAME (MkLay (strcat (substr plname 1 4) "PM" tbx (substr plname 8 3))))
    (command  "_.LAYER" "T" lname "S" lname "")
    (if Bug (princ "\nPM_OnLineN exited}\n"))
    (list (strcat _PATH-Sym Sym) ipt (* sf Lngth) "" slope)
);end-of-defun
;
;
(defun PM_EndLineN ( SymLst PFLst Invrt Rot /    ; insert a Symbol at the end of a line
                                                 invert sipt sang pfent spt cpt m slope mp slopep plname
                                                 sscale hlfwth plthk ipt Gap Lngth SymNam LName )
    (if Bug (princ "\n{PM_EndLineN entered"))
    (if PFLst
         (setq pfent  (nth 0 PFLst)
               spt    (nth 1 PFLst)
               cpt    (nth 2 PFLst)
               m      (nth 3 PFLst)
               slope  (nth 4 PFLst)
               mp     (nth 5 PFLst)
               slopep (nth 6 PFLst)
               plname (nth 7 PFLst)
               hlfwth (nth 8 PFLst)
               plthk  (nth 9 PFLst)
               ipt    (nth 10 PFLst)
         )
         (progn
              (alert (strcat "**" AppNam " Error**\nNo PolyData passed"))
              (exit)
         )
    )
    (if SymLst
         (setq Gap    (nth 0 SymLst)
               Lngth  (nth 1 SymLst)
               SymNam (nth 2 SymLst)
         )
         (progn
              (alert (strcat "**" AppNam " Error**\nNo SymbolData passed"))
              (exit)
         )
    )
    (setq LName (MkLay (strcat (substr plname 1 4) "PM-" (substr plname 8))))
    (setq sscale (* Lngth sf))
    (if (= Rot "Y")
         (setq slope (+ slope 180)
               m     (+ m pi)
         )
    )
    (if (= Invrt "Y")
         (setq invert -1)
         (setq invert 1)
    )
    (setq sipt (osnap ipt "END")  ; SETS sipt to End point of [ipt] - Removed "QUICK" for W10
          sang (if (not (equal ipt sipt 0.02))
                    (rtd (angle ipt sipt))
                    slope
               )
    )
    (if Bug
         (princ (strcat "\nSang=" (rtos sang 2 4)))
    )
    (command  "_.LAYER" "T" lname "S" lname "")
    (if Bug (princ "\nPM_EndLineN exited}\n"))
    (list (strcat _PATH-Sym Sym) sipt sscale (* invert sscale) sang)
);end-of-defun
;
;
(defun RegArrN ( SymLst PFLst /   sscale         ; Insert arrow for regulators and auto-boosters
                                  pfent spt cpt m slope mp slopep plname
                                  hlfwth plthk ipt Gap Lngth SymNam LName )
    (if PFLst
         (setq pfent  (nth 0 PFLst)
               spt    (nth 1 PFLst)
               cpt    (nth 2 PFLst)
               m      (nth 3 PFLst)
               slope  (nth 4 PFLst)
               mp     (nth 5 PFLst)
               slopep (nth 6 PFLst)
               plname (nth 7 PFLst)
               hlfwth (nth 8 PFLst)
               plthk  (nth 9 PFLst)
               ipt    (nth 10 PFLst)
         )
         (progn
              (alert (strcat "**" AppNam " Error**\nNo PolyData passed"))
              (exit)
         )
    )
    (if SymLst
         (setq Gap    (nth 0 SymLst)
               Lngth  (nth 1 SymLst)
               SymNam (nth 2 SymLst)
               LName  (nth 3 SymLst)
         )
         (progn
              (alert (strcat "**" AppNam " Error**\nNo SymbolData passed"))
              (exit)
         )
    )
    (if Lngth
         (setq sscale (* sf Lngth))
         (setq sscale sf)
    )
    (if (and Bug LName)
         (princ (strcat "\nLName:" LName))
    )
    (if Bug
         (princ (strcat "\nCmdActive:" (itoa (getvar "CMDACTIVE"))))
    )
    (command  "_.LAYER" "T" LName "S" LName "")
    (command "INSERT" (strcat _PATH-Sym "REGARR") ipt sscale "" pause)
    (if Bug (princ "\nPM_EndLineN exited}\n"))
);end-of-defun
;
;
(defun Do_Gap ( Sym /   tmpset pos ent2 )        ; cuts a hole in an existing polyline at a point
; Name:     do_gap
; Function: cuts a hole in an existing polyline at a specified point
;           and size, creates a polyline to fill the gap, and moves it to
;           the appropriate layer depending on the value of 'gap'
;              gap = "N"   do not create gap
;              gap = "M"   make a gap and a fill line
;              gap = "C"   make a gap centered on the insertion point, but do not save it
;           Global variables:  pt, hole, slope
; Author:   JVG - GRS
    (if Bug (princ "do_gap entered"))
    (if (and Bug HlfWth) (princ (strcat "\nHlfWth=" (rtos hlfwth 2 4))))
    (if (and Bug plname) (princ (strcat "\nPLName=" PLName)))
    (if (and Bug lname) (princ (strcat "\nLName=" LName)))
    (if (and Bug Gap Sym)
         (princ (strcat "\nSym=" Sym ", Gap=" gap))
         (if (and Bug Sym)
              (princ (strcat "\nSym=" Sym))
         )
    )
    (if (and gap (/= gap "N"))      ;--- If gap="N", don't do anything-------
    ;------ Create a gap --------------------------------------------------
         (progn
              (if (member sym '("_FI_T" "_FI_B" "_CC_T" "_CC_B"))
                   (setq pt2  ipt
                         pt1  ipt
                   )
                   (if (= gap "C")               ;--- If gap="C", create a centered gap---
                        (if (or (= Sym "CAP") (= Sym "A101"))
                             (setq Bubba (if Bug (princ "\nCap do_gap choice!"))
                                   Edpt1 pt1
                                   pt2   pt1
                             )
                             (setq pt2 (polar ipt m (/ hole 2))
                                   pt1 (polar ipt (+ pi m) (/ hole 2))
                             )
                        )
                        (setq pt2 (polar ipt m hole)
                              pt1 ipt
                        )
                   )
              )
              (setq ept1 (polar pt1 (+ (/ pi 2.0) m) hlfwth)
                    ss1  (ssget ept1 '((0 . "POLYLINE")))
                    ept2 (polar pt2 (+ (/ pi 2.0) m) hlfwth)
                    ss2  (ssget ept2 '((0 . "POLYLINE")))
              )
              (if (and ss1 ss2)
                   (if (equal (setq ent1 (ssname ss1 0)) (setq ent2 (ssname ss2 0)))
                        (progn
                             ;--build an 'entsel' type list (entity name and selection point) ; OLD  10/11/93  RER
                             ;  to feed to BREAK (pfent is the PLINE selected in PFIND)       ; OLD  10/11/93  RER
                             (setq pfent (cons (cdr (car pfent)) (list pt1))                  ; OLD  10/11/93  RER
                                   Bubba (if Bug (princ "\nIf & equal do_gap choice!"))
                             )
                             (command "BREAK" pfent pt2)                                      ; OLD  10/11/93  RER
                        )
                        (progn
                             (setq entpt1 (cons ent1 (list pt1))
                                   entpt2 (cons ent2 (list pt2))
                             )
                             (command "BREAK" entpt1 pt2)
                             (command "BREAK" entpt2 pt1)
                        )
                   )
                   (progn
                        ;--build an 'entsel' type list (entity name and selection point)      ; OLD  10/11/93  RER
                        ;  to feed to BREAK (pfent is the PLINE selected in PFIND)            ; OLD  10/11/93  RER
                        (setq pfent (cons (cdr (car pfent)) (list pt1)))                      ; OLD  10/11/93  RER
                        (command "BREAK" pfent pt2)                                           ; OLD  10/11/93  RER
                   )
              )
              ;----- Create fill line if symbol in diff. layer than circuit----
              (if (or (and (/= plname lname) (/= pt2 pt1)) (= sym "FD_NUM2"))
                   (progn
                        (command "_.LAYER" "T" (strcat (substr plname 1 4) "FL-" (substr plname 8))
                                 "S" (strcat (substr plname 1 4) "FL-" (substr plname 8)) ""
                        )
                        (if (= gap "C") ;--- If gap="C", create a centered gap---
                             (command "PLINE" pt1 "W" (* 2 hlfwth) "" ipt pt2 "")
                             ;else         ;--- If gap="M", make a gap-----
                             (command "PLINE" pt1 "W" (* 2 hlfwth) "" pt2 "")
                        )
                        (setthk (entget (entlast)))  ;sets thickness
                   )
              )
         );end-of-progn
         (if (or (= Sym "CAP") (= Sym "A101"))
              (setq Bubba (if Bug (princ "\nCap w/o Gap do_gap choice!"))
                    pfent (cons (cdr (car pfent)) (list ipt))
                    Bubba (command "BREAK" pfent ipt)
              )
         )
    );end-of-if
    (if Bug (princ "do_gap exited"))
);end-of-defun
;
;
(defun SubLoc ( Sym /   SymLst Gap Lngth SymNam  ; Prompts user for insertion point for substation
                   SubNam SubRat Sb_Data Ipt )
; Function: Prompts user for insertion point for substation, then lets
;           user rotate it as necessary.
    (if Bug (princ "\n{SubLoc entered\n"))
    (cond
         ((and (not sff) sf)
              (setq sff (/ sf 0.3408))
         );cond-1
         ((and (not sf) sff)
              (setq sf (* sff 0.3408))
         );cond-2
         ((and (not sff) (not sf))
              (SetScale)
         );cond-3
    );end-of-condition
    (setq SymLst (SymSizN Sym)
          Gap    (nth 0 SymLst)
          Lngth  (nth 1 SymLst)
          SymNam (nth 2 SymLst)
          dlg    4
    )
    (if (> (setq dcl_id (load_dialog (strcat _path-lisp "Adds.dcl"))) 0)
         (progn
              (while (> dlg 3)
                   (new_dialog "PropSub" dcl_id)
                   (Sub_Load_Data)
                   (Cb_Sub_Test_Ok)
                   (action_tile "vt_popup" "(Cb_Sub_Vt_popup)")
                   (action_tile "sb_popup" "(Cb_Sub_Sb_popup)")
                   (action_tile "ok_button" "(done_dialog 1)")
                   (action_tile "cancel_button" "(done_dialog 0)")
                   (Cb_Sub_Test_Ok)
                   (setq dlg (start_dialog))
              )
              (unload_dialog dcl_id)
              (if Bug
                   (princ (strcat "\n" (itoa dlg)))
              )
              (if (= dlg 1)
                   (progn
                        (princ (strcat "\nGot Stuff:" Sb_Data "-SB----"))
                        (command "_.Layer" "M" (strcat Sb_Data "--SB----") "C" "7" "" "")
                        (setq PosNum (- (length Lst_Sb_V) (length (member Sb_Data Lst_Sb_V)))
                              BrkNum (nth PosNum Lst_Sb_S)
                        )
;;;                     (if BrkUse
;;;                          (setq     DoTo      (list     "INSERT"
;;;                                                        (strcat _Path-Sym "GETAWAY")
;;;                                                        (getvar "VIEWCTR")
;;;                                                        (* (nth 0 Lst_Ph_W) SF 1.50)
;;;                                                        ""
;;;                                                        ""
;;;                                                        BrkUse
;;;                                              )
;;;                          )
;;;                          (setq     DoTo      (list     "INSERT"
;;;                                                        (strcat _Path-Sym "GETAWAY")
;;;                                                        (getvar "VIEWCTR")
;;;                                                        (* (nth 0 Lst_Ph_W) SF 1.50)
;;;                                                        ""
;;;                                                        ""
;;;                                                        "NotFound"
;;;                                              )
;;;                          )
;;;                     )
;;;                     (mapcar (quote command) DoTo)
;;;                     (MovLast)
                   );end-of-progn
              );end-of-if
         );end-of-progn
         (alert (strcat "ERROR: Opening Dialogue Box Adds.dcl"))
    );end-of-if
;;; (initget 1 "S H")
;;; (if (= "S" (getkword "Solid or Hollow sub symbol (S or H)? "))
;;;      (setq     Sym       "A074")
;;;      (setq     Sym       "A075")
;;; )
    (if (= Sym "A074")
         (if BrkNum
              (setq SubNam BrkNum
                    SubRat (strcat Vt_Data " kV")
              )
              (setq SubNam (getstring T "\nEnter Substation Name: ")
                    SubRat (getstring T "\nEnter Substation Rating: ")
              )
         )
         (if BrkNum
              (setq SubNam BrkNum
                    SubRat (strcat Vt_Data " kV")
                    Bubba  (initget 1 "")
                    UnitNo (itoa (getint "\nEnter Substation Unit Number: "))
              )
              (setq SubNam (getstring T "\nEnter Substation Name: ")
                    SubRat (getstring T "\nEnter Substation Rating: ")
                    Bubba  (initget 1 "")
                    UnitNo (itoa (getint "\nEnter Substation Unit Number: "))
              )
         )
    )
    (princ "\n\nPick the point for the base of the substation...")
    (setq Ipt (getpoint "\nThen, rotate the symbol as desired.\n"))
    (if (= Sym "A074")
         (command "_.Insert" (strcat _PATH-SYM Sym) Ipt (* Lngth sf) "" pause SubNam SubRat)
         (command "_.Insert" (strcat _PATH-SYM Sym) Ipt (* Lngth sf) "" pause SubNam SubRat UnitNo)
    )
    (setthk (entget (entlast)))
    (if (= Sym "A074")
         (Att-NM)
    )
    (Att-Chg-Lay)
    (if Bug (princ "\nSubLoc exited}\n"))
    (princ)
);end-of-defun
;
;
(defun MovLast ( / )                             ; Moves last entity
    (princ "\n \nSelect the symbol insertion point:")
    (command "MOVE" (entlast) "" (cdr (assoc 10 (entget (entlast)))) pause)
);end-of-defun
;
;
(defun Drw_Arr ( flag / apt1 pt ang )            ; draws an arrow between two user-selected points
; Function: The Drw_Arr function draws an arrow between two user-selected
;           points.  'flag' non-nil eliminates user prompts.
    (if Bug (princ "\nDrw_Arr entered"))
    (if (not flag) (initget "Yes No"))
    (if (or flag (= "Yes" (getkword "\n\nDo you wish to draw an arrow? <N>: ")))
         (progn
              ;(if flag (command  "_.LAYER" "T" "----LM----" "S" "----LM----" ""))
              (setq apt1 (getpoint "\nPick the origin of the arrow:"))
              (princ "\nPick the end point of the arrow:")
              (command "PLINE" apt1 "W" "0" "" pause "")
              (setthk (entget (entlast)))
              (setq pt  (getvar "LASTPOINT")
                    ang (rtd (getvar "LASTANGLE"))
              )
              (command "INSERT" (strcat _PATH-SYM "A130") pt (* sf 0.09 smult) "" ang)
              (setthk (entget (entlast)))
         )
    )
    (if Bug (princ "\nDrw_Arr exited"))
    (princ)
);end-of-defun
;
;
(defun NOARR ( / apt arrowang sscale)            ; inserts the NORTH ARROW SYMBOL
; Function: inserts the NORTH ARROW SYMBOL at the user defined point and angle.
    (if Bug (princ "noarr routine"))
    (setq apt (getpoint "\n \nSelect the insertion point for north arrow "))
    (command  "_.LAYER" "T" "----NA----" "S" "----NA----" "")
    (setq arrowang (getangle apt "\nPick the angle of the arrow: "))
    (if (= arrowang nil)
         (setq arrowang 0)
         (setq arrowang (rtd arrowang))
    )
    (command "INSERT" sw-sym apt sf "" (- arrowang 90.0))
    (setthk (entget (entlast)))  ;sets thickness
    (if Bug (princ "noarr routine"))
    (princ)
);end-of-defun
;
;
(defun Sym_online ( Sym offset ltype / )         ; Insert a Symbol above or below the circuit.
; Function: Insert a Symbol above or below the circuit.
;
    (if Bug (princ "Sym_online entered"))
    (initget 0 "Top Bottom")
    (setq ans (getkword "\nPlace device on [T]op or on [B]ottom of circuit <T> ?"))
    (if ans
         (setq tbx (strcase (substr ans 1 1)))
         (setq tbx "T")
    )
    (setq dist (+ (* offset sf) hlfwth))
    (if (= tbx "B")
         (setq dist (- dist))
         (setq tbx  "T")
    )
    (setq ipt (polar ipt mp dist))
    (if (= ltype nil)
         (setq LNAME (MkLay (strcat (substr plname 1 6) tbx (substr plname 8 3))))
         (setq LNAME (MkLay (strcat (substr plname 1 4) ltype tbx (substr plname 8 3))))
    )
    (command "_.LAYER" "T" lname "S" lname "")
    (if Bug (princ "Sym_online exited"))
    (list (strcat _PATH-Sym Sym) ipt (* sf Lngth) "" slope)
);end-of-defun
;
;
(defun End_Ln ( Sym / )                          ; insert a Symbol at the end of a line
; Function: insert a Symbol at the end of a line and with the slope of the line
    (if Bug (princ "end_ln entered"))
    (cond
         ((and (not sff) sf)
              (setq sff (/ sf 0.3408))
         );cond-1
         ((and (not sf) sff)
              (setq sf (* sff 0.3408))
         );cond-2
         ((and (not sff) (not sf))
              (SetScale)
         );cond-3
    );end-of-condition
    (setq     lname     (MkLay (strcat (substr plname 1 4) "PM-" (substr plname 8))))
    (setq sscale (* Lngth sf))
    (if (= rot "Y")
         (setq slope (+ slope 180)
               m     (+ m pi)
         )
    )
    (if (= inv "Y")
         (setq invert -1)
         (setq invert 1)
    )
    (setq ipt (osnap ipt "END"))  ; SETS [ipt] to End point of [ipt]  - Removed "QUICK" for W10
    (command "_.LAYER" "T" lname "S" lname "")
    (if Bug (princ "end_ln exited"))
    (list (strcat _PATH-Sym Sym) ipt sscale (* invert sscale) slope)
);end-of-defun
;
;
(defun CPins ( /   SymLst Gap Lngth SymNam       ; Offer two ways to insert a computer point
                   pfent spt cpt m slope mp slopep plname hlfwth plthk ipt
                   PFLst lname cpnum )
; Function:  Offer two ways to insert a computer point
    (if Bug (princ "\n{CPins entered\n"))
    (cond
         ((and (not sff) sf)
              (setq sff (/ sf 0.3408))
         );cond-1
         ((and (not sf) sff)
              (setq sf (* sff 0.3408))
         );cond-2
         ((and (not sff) (not sf))
              (SetScale)
         );cond-3
    );end-of-condition
    (setq SymLst (SymSizN "CP")
          Gap    (nth 0 SymLst)
          Lngth  (nth 1 SymLst)
          SymNam (nth 2 SymLst)
    )
    (initget 1 "F O")
    (if (= "O" (getkword "\n \nMake computer point Freestanding or On-line [F or O]? "))
         (progn
              (setq PFLst (PFindN nil))
              (if PFLst
                   (setq pfent  (nth 0 PFLst)
                         spt    (nth 1 PFLst)
                         cpt    (nth 2 PFLst)
                         m      (nth 3 PFLst)
                         slope  (nth 4 PFLst)
                         mp     (nth 5 PFLst)
                         slopep (nth 6 PFLst)
                         plname (nth 7 PFLst)
                         hlfwth (nth 8 PFLst)
                         plthk  (nth 9 PFLst)
                         ipt    (nth 10 PFLst)
                   )
                   (progn
                        (alert (strcat "**" AppNam " Error**\nNo Polydata passed"))
                        (exit)
                   )
              )
              (setq lname (MkLay (strcat (substr plname 1 3) "-CP--" (substr plname 9 2))))
              (while (not cpnum)
                   (setq cpnum (getstring "\n\nEnter the Computer Point number: "))
                   (if (or (/= (type cpnum) 'STR)
                           (< (strlen cpnum) 1)
                           (= (chr 32) cpnum)
                       )
                       (setq     cpnum     nil)
                   )
              )
              (command  "_.LAYER" "T" lname "S" lname "")
              (command "_.INSERT" (strcat _PATH-Sym "CP") ipt (* Lngth sf) "" "" cpnum)
              (setthk (entget (entlast)))  ;sets thickness
              (Att-Chg-Lay)
              (Att-MR)
              (Drw_Arr nil)
         );end-of-progn
         (progn
              (setq plname (getlay "CK"))
              (setq lname  (MkLay (strcat (substr plname 1 3) "-CP--" (substr plname 9 2))))
              (command "_.LAYER" "T" lname "S" lname "")
              (setq cpnum (getstring "\n\nEnter the computer point number: "))
              (setq ipt   (getpoint "\nSelect the Symbol insertion point:"))
              (command "INSERT" (strcat _path-Sym "CP") ipt (* sf Lngth) "" "" cpnum)
              (setthk (entget (entlast)))  ;sets thickness
              (Att-Chg-Lay)
              (Att-MR)
              (Drw_Arr nil)
         );end-of-progn
    );end-of-if
    (if Bug (princ "\nCPins exited}\n"))
    (princ)
);end-of-defun
;
;
(defun CP_Ins ( FO CPNum plname Lngth / gap  ; Offer two ways to insert a computer point
                                        lname symnam LayDat SymLst ipt pfthk )
    (if Bug (princ "CP_Ins entered"))
    (if (and Bug FO) (princ (strcat "\nFO: " FO)))
    (if (and Bug CPNum) (princ (strcat "\nCPNum: " (rtos CPNum 2 0))))
    (if (and Bug plname) (princ (strcat "\nplname: " plname)))
    (if (and Bug Lngth) (princ (strcat "\nlen: " (rtos Lngth 2 0))))
    (cond
         ((and (not sff) sf)
              (setq sff (/ sf 0.3408))
         );cond-1
         ((and (not sf) sff)
              (setq sf (* sff 0.3408))
         );cond-2
         ((and (not sff) (not sf))
              (SetScale)
         );cond-3
    );end-of-condition
    (if (not Lngth)
         (progn
              (setq SymLst (SymSizN "CP"))
              (if SymLst
                   (setq Gap    (nth 0 SymLst)
                         Lngth  (nth 1 SymLst)
                         SymNam (nth 2 SymLst)
                   )
              )
         )
    )
    (if (not CPNum)
         (setq CPNum (getstring "\n \nEnter the computer point number: "))
         (setq CPNum (rtos CPNum 2 0))
    )
    (if FO
         (if (= (strcase FO) "F")
              (progn
                   (if Bug (princ "\nFO=F"))
                   (if (not plname)
                        (setq LayDat (P_Find)
                              ipt    (nth 0 LayDat)
                              plname (nth 1 LayDat)
                              pfthk  (nth 2 LayDat)
                        )
                   )
                   (setq lname (MkLay (strcat (substr plname 1 3) "-CP--" (substr plname 9 2))))
                   (command "_.LAYER" "T" lname "S" lname "")
                   (setq ipt (getpoint "\nSelect the Symbol insertion point:"))
                   (command "INSERT" (strcat _PATH-Sym "CP") ipt (* Lngth sf) "" "" cpnum)
                   (setthk (entget (entlast)))  ;sets thickness
                   (Att-Chg-Lay)
                   (Att-MR)
                   (Drw_Arr nil)
              );end-of-progn
              (if (= (strcase FO) "O")
                   (progn
                        (if Bug (princ "\nFO=O"))
                        (if (not plname)
                             (setq LayDat (P_Find)
                                   ipt    (nth 0 LayDat)
                                   plname (nth 1 LayDat)
                                   pfthk  (nth 2 LayDat)
                             )
                        )
                        (setq lname (MkLay (strcat (substr plname 1 3) "-CP--" (substr plname 9 2))))
                        (setq omode (getvar "OSNAPMODE"))
                        (setvar "OSNAPMODE" 512)
                        (setq ipt (getpoint "\nSelect the Symbol insertion point:"))
                        (setvar "OSNAPMODE" omode)
                        (command "_.LAYER" "T" lname "S" lname "")
                        (command "INSERT" (strcat _PATH-Sym "CP") ipt (* Lngth sf) "" "" cpnum)
                        (setthk (entget (entlast)))  ;sets thickness
                        (Att-Chg-Lay)
                        (Att-MR)
                        (Drw_Arr nil)
                   )
              );end-of-if
         );end-of-if
         (progn
              (if Bug (princ "\nNo FO"))
              (initget 1 "F O")
              (if (= "O" (getkword "\n\nMake computer point Freestanding or On-line [F or O]? "))
                   (progn
                        (if (not plname)
                             (setq LayDat (P_Find)
                                   ipt    (nth 0 LayDat)
                                   plname (nth 1 LayDat)
                                   pfthk  (nth 2 LayDat)
                             )
                        )
                        (setq lname (MkLay (strcat (substr plname 1 3) "-CP--" (substr plname 9 2))))
                        (setq omode (getvar "OSNAPMODE"))
                        (setvar "OSNAPMODE" 512)
                        (setq ipt (getpoint "\nSelect the Symbol insertion point:"))
                        (setvar "OSNAPMODE" omode)
                        (command "_.LAYER" "T" lname "S" lname "")
                        (command "INSERT" (strcat _PATH-Sym "CP") ipt (* Lngth sf) "" "" cpnum)
                        (setthk (entget (entlast)))  ;sets thickness
                        (Att-Chg-Lay)
                        (Att-MR)
                        (Drw_Arr nil)
                   );end-of-progn
                   (progn
                        (if (not plname)
                             (setq LayDat (P_Find)
                                   ipt    (nth 0 LayDat)
                                   plname (nth 1 LayDat)
                                   pfthk  (nth 2 LayDat)
                             )
                        )
                        (setq lname (MkLay (strcat (substr plname 1 3) "-CP--" (substr plname 9 2))))
                        (setq ipt   (getpoint "\nSelect the Symbol insertion point:"))
                        (command  "_.LAYER" "T" lname "S" lname "")
                        (command "INSERT" (strcat _PATH-Sym "CP") ipt (* Lngth sf) "" "" cpnum)
                        (setthk (entget (entlast)))  ;sets thickness
                        (Att-Chg-Lay)
                        (Att-MR)
                        (Drw_Arr nil)
                   );end-of-progn
              );end-of-if
         );end-of-progn
    );end-of-if
    (if Bug (princ "CP_Ins exited"))
    (princ)
);end-of-defun
;
;
(defun RegArr ( / )                              ; Insert arrow for regulators and auto-boosters
; Function:  Insert arrow for regulators and auto-boosters
   (command "_.LAYER" "T" lname "S" lname ""
            "INSERT" (strcat _PATH-Sym "REGARR") ipt sscale "" pause)
);end-of-defun
;
;
(defun OcrFix ( /  Ename Elist Ept Eang Edist    ; Move "S", "B",and "L" closer to switch number
                   Iname Ilist )
    (if (member (cdr (assoc 2 (entget (entlast)))) (list "_OCR" "_OCR_BP" "_OCR_EL"))
         (progn
              (setq Ename (entnext (entnext (entnext (entnext (entlast)))))
                    Elist (entget Ename)
                    Ept   (cdr (assoc 10 Elist))
                    Eang  (cdr (assoc 50 Elist))
                    Edist (* (1+ (strlen (cdr (assoc 1 Elist)))) (cdr (assoc 40 Elist)))
              )
              (setq Iname (entnext Ename)
                    Ilist (entget Iname)
                    Ilist (subst (cons 10 (polar Ept Eang Edist))
                                 (assoc 10 Ilist)
                                 Ilist
                          )
              )
              (entmod Ilist)
              (if  (/= (cdr (assoc 0 (entget (entnext Iname)))) "SEQEND")
                   (progn
                        (setq Ename (entnext Iname)
                              Elist (entget Ename)
                              Ept   (cdr (assoc 10 Elist))
                              Eang  (cdr (assoc 50 Elist))
                              Edist (* (1+ (strlen (cdr (assoc 1 Elist)))) (cdr (assoc 40 Elist)))
                        )
                        (setq Iname (entnext Ename)
                              Ilist (entget Iname)
                              Ilist (subst (cons 10 (polar Ept Eang Edist))
                                           (assoc 10 Ilist)
                                           Ilist
                                    )
                        )
                        (entmod Ilist)
                        (if  (/= (cdr (assoc 0 (entget (entnext Iname)))) "SEQEND")
                             (progn
                                  (setq Ename (entnext Iname)
                                        Elist (entget Ename)
                                        Ept   (cdr (assoc 10 Elist))
                                        Eang  (cdr (assoc 50 Elist))
                                        Edist (* (1+ (strlen (cdr (assoc 1 Elist)))) (cdr (assoc 40 Elist)))
                                  )
                                  (setq Iname (entnext Ename)
                                        Ilist (entget Iname)
                                        Ilist (subst (cons 10 (polar Ept Eang Edist))
                                                     (assoc 10 Ilist)
                                                     Ilist
                                              )
                                  )
                                  (entmod Ilist)
                                  ;(princ "\nPositioned attributes for recloser Symbol _OCR_EL    ")
                             )
                             ;(princ "\nPositioned attributes for recloser Symbol _OCR_BP    ")
                        )
                   );end-of-progn
                   ;(princ "\nPositioned attributes for recloser Symbol _OCR    ")
              );end-of-if
              (entupd Iname)
              (princ)
         );end-of-progn
         ;else  ENTITY NOT A RECLOSER
         (princ "\nItem was NOT... _OCR, _OCR_BP, or _OCR_EL , only works on these items!!! ")
    );end-of-if
);end-of-defun
;
;
(defun SubGet ( SymN /  dlg dcl_id )             ; Inserts Sub Getaway Symbol with logic
; Needs Fdr_Load_Data for display
    (setq dlg 4)
    (cond
         ((and (not sff) sf)
              (setq sff (/ sf 0.3408))
         );cond-1
         ((and (not sf) sff)
              (setq sf (* sff 0.3408))
         );cond-2
         ((and (not sff) (not sf))
              (SetScale)
         );cond-3
    );end-of-condition
    (setq SymLst (SymSizN SymN)
          Gap    (nth 0 SymLst)
          Lngth  (nth 1 SymLst)
          SymNam (nth 2 SymLst)
    )
    (if (> (setq dcl_id (load_dialog (strcat _path-lisp "Adds.dcl"))) 0)
         (progn
              (while (> dlg 3)
                   (new_dialog "PropFdr" dcl_id)
                   (Fdr_Load_Data)
                   (Cb_Fdr_Test_Ok)
                   (action_tile "vt_popup" "(Cb_Fdr_Vt_popup)")
                   (action_tile "fd_popup" "(Cb_Fdr_Fd_popup)")
                   (action_tile "ok_button" "(done_dialog 1)")
                   (action_tile "cancel_button" "(done_dialog 0)")
                   (Cb_Fdr_Test_Ok)
                   (setq dlg (start_dialog))
              )
              (unload_dialog dcl_id)
              (if Bug
                   (princ (strcat "\n" (itoa dlg)))
              )
              (if (= dlg 1)
                   (progn
                        (princ (strcat "\nGot Stuff:" Fd_Data "-CK-0" Vt_Data))
                        (MkLay (strcat Fd_Data "-CK-0" Vt_Data))
                        (setq PosNum (- (length Lst_Fd_V) (length (member Fd_Data Lst_Fd_V)))
                              BrkNum (nth PosNum Lst_Fd_S)
                        )
                        (if (= (type BrkNum) 'STR)
                             (cond ((= (substr BrkNum 2 1) (chr 32))
                                        (setq BrkUse (substr BrkNum 1 1))
                                   );cond-1
                                   ((= (substr BrkNum 3 1) (chr 32))
                                        (setq BrkUse (substr BrkNum 1 2))
                                   );cond-2
                                   ((= (substr BrkNum 4 1) (chr 32))
                                        (setq BrkUse (substr BrkNum 1 3))
                                   );cond-3
                                   ((= (substr BrkNum 5 1) (chr 32))
                                        (setq BrkUse (substr BrkNum 1 4))
                                   );cond-4
                                   ((= (substr BrkNum 6 1) (chr 32))
                                        (setq BrkUse (substr BrkNum 1 5))
                                   );cond-5
                                   ((= (substr BrkNum 7 1) (chr 32))
                                        (setq BrkUse (substr BrkNum 1 6))
                                   );cond-6
                             );end-of-condition
                        );end-of-if
                        (if (= SymN "A165")
                             (if BrkUse
                                  (setq DoTo (list "INSERT"
                                                   SymNam
                                                   (getvar "VIEWCTR")
                                                   (* (nth 0 Lst_Ph_W) SF 1.50)
                                                   ""
                                                   ""
                                                   BrkUse
                                                   "Blank"
                                             )
                                  )
                                  (setq DoTo (list "INSERT"
                                                   SymNam
                                                   (getvar "VIEWCTR")
                                                   (* (nth 0 Lst_Ph_W) SF 1.50)
                                                   ""
                                                   ""
                                                   "NotFound"
                                                   "Blank"
                                             )
                                  )
                             )
                             (if BrkUse
                                  (setq DoTo (list "INSERT"
                                                   SymNam
                                                   (getvar "VIEWCTR")
                                                   (* (nth 0 Lst_Ph_W) SF 1.50)
                                                   ""
                                                   ""
                                                   BrkUse
                                             )
                                  )
                                  (setq DoTo (list "INSERT"
                                                   SymNam
                                                   (getvar "VIEWCTR")
                                                   (* (nth 0 Lst_Ph_W) SF 1.50)
                                                   ""
                                                   ""
                                                   "NotFound"
                                             )
                                  )
                             )
                        );end-of-if
                        (mapcar (quote command) DoTo)
                        (MovLast)
                   );end-of-progn
              );end-of-if
         );end-of-progn
         (alert (strcat "ERROR: Opening Dialogue Box Adds.dcl"))
    );end-of-if
    (princ)
);end-of-defun
;
;
(defun Fdr_Load_Data ( / kvp fdp             ; Loads Data in dialog box
                         php bk Bubba DezVals )
    (setq kv     nil
          fd     nil
          bk     " "
          Number 3
    )
    (if Bug
         (princ "\nChecking Kv")
    )
    (setq kvp (Check_Member kv Lst_Vt_S))
    (setq PopBak (Pop_Lst "vt_popup" kv kvp Lst_Vt_S Number)
          kv   (nth 0 PopBak)
          kvp  (nth 1 PopBak)
          kvps (nth 2 PopBak)
          kvs  (nth 3 PopBak)
    )
    (if Bug
         (princ "\nChecking Fd")
    )
    (setq fdp (Check_Member fd Lst_Fd_V))
    (setq PopBak (Pop_Lst "fd_popup" fd fdp Lst_Fd_S Number)
          fd   (nth 0 PopBak)
          fdp  (nth 1 PopBak)
          fdps (nth 2 PopBak)
          fds  (nth 3 PopBak)
    )
    (setq Vt_Data (get_tile "vt_popup")
          Fd_Data (get_tile "fd_popup")
    )
    (if kvs
         (setq Vt_Data (nth (atoi Vt_Data) Lst_Vt_S))
         (setq Vt_Data "0")
    )
    (if fds
         (setq Fd_Data (nth (atoi Fd_Data) Lst_Fd_V))
         (setq Fd_Data "0")
    )
);end-of-defun
;
;
(defun Cb_Fdr_Test_Ok ( / )                      ; Call Back - Test OK
    (if (or (null kvs)
            (null fds)
        )
         (mode_tile "ok_button" 1)
         (mode_tile "ok_button" 0)
    )
    (princ)
);end-of-defun
;
;
(defun Cb_Fdr_Vt_popup ( / )                     ; Call Back - Voltage OK
    (setq Vt_Data (get_tile "vt_popup"))
    (if (RngData Vt_Data Lst_Vt_S kvps)
         (setq kvs T)
         (setq kvs nil)
    )
    (if (or (null kvs)
            (null fds)
        )
         (mode_tile "ok_button" 1)
         (mode_tile "ok_button" 0)
    )
    (if kvps
         (if (not (eq Vt_Data "0"))
              (setq Vt_Data (nth (1- (atoi Vt_Data)) Lst_Vt_S))
         )
         (setq Vt_Data (nth (atoi Vt_Data) Lst_Vt_S))
    )
);end-of-defun
;
;
(defun Cb_Fdr_Fd_popup ( / )                     ; Call Back - Feeder OK
    (setq Fd_Data (get_tile "fd_popup"))
    (if (RngData Fd_Data Lst_Fd_V fdps)
         (setq fds T)
         (setq fds nil)
    )
    (if (or (null kvs)
            (null fds)
        )
         (mode_tile "ok_button" 1)
         (mode_tile "ok_button" 0)
    )
    (if fdps
         (if (not (eq Fd_Data "0"))
              (setq Fd_Data (nth (- (atoi Fd_Data) 1) Lst_Fd_V))
         )
         (setq Fd_Data (nth (atoi Fd_Data) Lst_Fd_V))
    )
);end-of-defun
;
;
(defun Sub_Load_Data ( /     kvp sbp             ; Loads Data in dialog box
                             php bk Bubba DezVals )
    (setq kv     nil
          sb     nil
          bk     " "
          Number 3
    )
    (if Bug
         (princ "\nChecking Kv")
    )
    (setq kvp (Check_Member kv Lst_Vt_S))
    (setq PopBak (Pop_Lst "vt_popup" kv kvp Lst_Vt_S Number)
          kv   (nth 0 PopBak)
          kvp  (nth 1 PopBak)
          kvps (nth 2 PopBak)
          kvs  (nth 3 PopBak)
    )
    (if Bug
         (princ "\nChecking Sb")
    )
    (setq sbp (Check_Member sb Lst_Sb_V))
    (setq PopBak (Pop_Lst "sb_popup" sb sbp Lst_Sb_S Number)
          sb   (nth 0 PopBak)
          sbp  (nth 1 PopBak)
          sbps (nth 2 PopBak)
          sbs  (nth 3 PopBak)
    )
    (setq Vt_Data (get_tile "vt_popup")
          Sb_Data (get_tile "sb_popup")
    )
    (if kvs
         (setq Vt_Data (nth (atoi Vt_Data) Lst_Vt_S))
         (setq Vt_Data "0")
    )
    (if sbs
         (setq Sb_Data (nth (atoi Sb_Data) Lst_Sb_V))
         (setq Sb_Data "0")
    )
);end-of-defun
;
;
(defun Cb_Sub_Test_Ok ( / )                      ; Call Back - Test OK
    (if (or (null kvs)
            (null sbs)
        )
         (mode_tile "ok_button" 1)
         (mode_tile "ok_button" 0)
    )
    (princ)
);end-of-defun
;
;
(defun Cb_Sub_Vt_popup ( / )                     ; Call Back - Voltage OK
    (setq Vt_Data (get_tile "vt_popup"))
    (if (RngData Vt_Data Lst_Vt_S kvps)
         (setq kvs T)
         (setq kvs nil)
    )
    (if (or (null kvs)
            (null sbs)
        )
         (mode_tile "ok_button" 1)
         (mode_tile "ok_button" 0)
    )
    (if kvps
         (if (not (eq Vt_Data "0"))
              (setq Vt_Data (nth (1- (atoi Vt_Data)) Lst_Vt_S))
         )
         (setq Vt_Data (nth (atoi Vt_Data) Lst_Vt_S))
    )
);end-of-defun
;
;
(defun Cb_Sub_Sb_popup ( / )                     ; Call Back - Substation OK
    (setq Sb_Data (get_tile "sb_popup"))
    (if (RngData Sb_Data Lst_Sb_V sbps)
         (setq sbs T)
         (setq sbs nil)
    )
    (if (or (null kvs)
            (null sbs)
        )
         (mode_tile "ok_button" 1)
         (mode_tile "ok_button" 0)
    )
    (if sbps
         (if (not (eq Sb_Data "0"))
              (setq Sb_Data (nth (- (atoi Sb_Data) 1) Lst_Sb_V))
         )
         (setq Sb_Data (nth (atoi Sb_Data) Lst_Sb_V))
    )
);end-of-defun
;
;
(defun FixNearVrt ( entL Pt2 /    )              ; Moves nearest created vertex to new location
                                       ; NentLst x xEnt InfLst Cnt MinC MinD MinP
    (setq NentLst nil
          MinC    nil
          MinD    nil
          MinP    nil
          InfLst  nil
          x       nil
          xEnt    nil
    )
    (if Bug (princ "\n{FixNearVrt entered"))
    (while (setq entL (entnext entL))
         (if entL
              (if NentLst
                   (setq NentLst (cons entL NentLst))
                   (setq NentLst (list entL))
              )
         )
    )
    (if NentLst
         (setq NentLst (reverse NentLst))
    )
    (if NentLst
         (mapcar (quote (lambda (x)
                             (If x
                                  (setq xEnt (entget x (quote ("*"))))
                                  (setq xEnt nil)
                             )
                             (if xEnt
                                  (if (= (cdr (assoc 0 xEnt)) "VERTEX")
                                       (if InfLst
                                            (setq InfLst (cons (distance Pt2 (cdr (assoc 10 xEnt))) InfLst))
                                            (setq InfLst (list (distance Pt2 (cdr (assoc 10 xEnt)))))
                                       )
                                       (if InfLst
                                            (setq InfLst (cons 999.9 InfLst))
                                            (setq InfLst (list 999.9))
                                       )
                                  )
                             )
                        )
                 )
                 NentLst
         )
    );end-of-if
    (if InfLst
         (setq InfLst (reverse InfLst))
    )
    (setq Cnt 0)
    (if NentLst
         (while (< Cnt (length NentLst))
              (if MinD
                   (if (< (nth Cnt InfLst) MinD)
                        (setq MinD (nth Cnt InfLst)
                              MinC Cnt
                        )
                   )
                   (setq MinD (nth Cnt InfLst)
                         MinC Cnt
                   )
              )
              (setq Cnt (1+ Cnt))
         )
    )
    (setq     Cnt       0)
    (if NentLst
         (while (< Cnt MinC)
              (if (= (cdr (assoc 0 (entget (nth Cnt NentLst) (quote ("*"))))) "POLYLINE")
                   (setq MinP  Cnt)
              )
              (setq Cnt  (1+ Cnt))
         )
    )
    (if (and NentLst MinC MinD MinP)
         (progn
              (if Bug (princ (strcat "\nMoving Vertex " (itoa MinC) " of PolyLine " (itoa MinP) ".")))
              (setq entN (entget (nth MinC NentLst) (quote ("*")))
                    entN (subst (cons 10 Pt2)
                                (assoc 10 entN)
                                entN
                         )
              )
              (entmod entN)
              (entupd (nth MinP NentLst))
         )
    )
    (if Bug (princ "\nFixNearVrt exited}\n"))
    (princ)
);end-of-defun
;
;
(defun Put ( SymTyp Pos Lname Inv Rot /          ; Puts Cadet 1.5 symbols into dwg
                                       SymLst Gap Lngth SymNam OLname PFLst
                                       pfent spt cpt m slope mp slopep plname hlfwth plthk ipt
                                       temp sscale hole Whump rd_flag )
    (if Bug (princ "\n{PUT entered\n"))
    (setq SymLst (SymSizN SymTyp)
          Gap    (nth 0 SymLst)
          Lngth  (nth 1 SymLst)
          SymNam (nth 2 SymLst)
          OLname (getvar "CLAYER")
    )
    (setq temp  T)
    (while temp
         (if (= pos "VTX")
              (Vtx1)
              (progn
                   (setq PFLst (PFindN nil))
                   (if PFLst
                        (setq pfent  (nth 0 PFLst)
                              spt    (nth 1 PFLst)
                              cpt    (nth 2 PFLst)
                              m      (nth 3 PFLst)
                              slope  (nth 4 PFLst)
                              mp     (nth 5 PFLst)
                              slopep (nth 6 PFLst)
                              plname (nth 7 PFLst)
                              hlfwth (nth 8 PFLst)
                              plthk  (nth 9 PFLst)
                              ipt    (nth 10 PFLst)
                        )
                        (progn
                             (alert (strcat "**" AppNam " Error**\nNo Polydata passed"))
                             (exit)
                        )
                   )
              )
         );end-of-if
         (setq sscale (* Lngth sf))
         (if (= inv "Y")
              (setq invert -1)
              (setq invert 1)
         )
         (cond
              ((= pos "IN")
                   (if (= rot "Y")
                        (setq m     (+ m pi)
                              PFLst (RepLst PFLst m 3)
                        )
                   )
                   (setq hole  sscale)
                   (setq PFLst (Do_GapN SymTyp SymLst PFLst))
              );cond-1
              ((or (= pos "ON") (= pos "VTX"))
                   (if (= rot "B")
                        (setq ipt (polar ipt mp (- (+ (* Lngth 0.5 sf) hlfwth))))
                        (setq ipt (polar ipt mp (+ (* Lngth 0.5 sf) hlfwth)))
                   )
              );cond-2
              ((= pos "END")
                   (setq ipt (osnap ipt "END"))		; - Removed "QUICK" for W10
                   (if (= rot "Y")
                        (setq m (+ m pi))
                   )
              );cond-3
         );end-of-condition
         (if (= (substr (strcase AppNam) 1 4) "BEMS")
              (if (wcmatch OLname "BUD##[JPR]")
                   (command "_.Layer" "_T" OLname "_S" OLname "")
                   (progn
                        (setq Whump T)
                        (while Whump
                             (princ "\nSelect a Layer for the Changed Symbol - do not select white layers!")
                             (setq OLname (Open_Clr))
                             (if OLname
                                  (if (/= (car OLname) 7)
                                       (setq OLname (cdr OLname)
                                             Whump  nil
                                       )
                                       (setq OLname nil)
                                  )
                             )
                        )
                        (command "_.Layer" "_T" OLname "_S" OLname "")
                   )
              )
              (if lname
                   (command "_.Layer" "_T" lname "_S" lname "")
              )
         );end-of-if
         (command "_.Insert" SymNam ipt sscale (* invert sscale) (RD2DEG m))
         (if rd_flag (command "_.Regen"))
         (if again
              (princ "\n\nREPEAT Mode is ON......")
              (setq temp nil)
         )
    );end-of-while
    (if Bug (princ "\nPUT exited}\n"))
    (princ)
);end-of-defun
;
;
(defun OnPoleN ( SymTyp lname /   temp pfent     ; Inserts Symbol On a Pole, eh?
                                  CLay SymLst Gap Lngth SymNam )
    (if Bug (princ "\n{OnPole entered\n"))
    (setq Temp T
          CLay (getvar "CLAYER")
    )
    (while Temp
         (setq pfent nil)
         (while (null pfent)
              (if (setq pfent (entsel "\nPick a pole to attach symbol"))
                   (progn
                        (setq pfent (entget (car pfent)))
                        (if (and Bug pfent)
                             (princ (strcat "\nBug: pfent is a " (cdr (assoc 2 pfent))))
                        )
                        (if (and Bug pfent)
                             (redraw (cdr (assoc -1 pfent)) 3)
                        )
                        (if (and (= (cdr (assoc 0 pfent)) "INSERT")
                                 (= (substr (cdr (assoc 2 pfent))
                                            (- (strlen (cdr (assoc 2 pfent))) 3)
                                             4
                                    )
                                    "POLE"
                                 )
                            );end-of-and
                            (progn
                                 (setq SymLst (SymSizN SymTyp)
                                       Gap    (nth 0 SymLst)
                                       Lngth  (nth 1 SymLst)
                                       SymNam (nth 2 SymLst)
                                 )
                                 (if lname
                                      (command "_.Layer" "_T" lname "_S" lname "")
                                 )
                                 (command "_.INSERT" SymNam 
                                          (polar (cdr (assoc 10 pfent)) 0.0 (/ (+ (* sf Lngth) (cdr (assoc 41 pfent))) 2.0))
                                          (* sf Lngth) "" "-90.0")
                                 (command "_.Rotate" (entlast) "" (cdr (assoc 10 pfent)) pause)
                                 (if (and Bug pfent)
                                      (redraw (cdr (assoc -1 pfent)) 4)
                                 )
                            )
                            (progn
                                 (princ "\n\nThis time try picking a pole!")
                                 (if (and Bug pfent)
                                      (redraw (cdr (assoc -1 pfent)) 4)
                                 )
                                 (setq pfent nil)
                            )
                        );end-of-if
                   );end-of-progn
              );end-of-if
         );end-of-while
         (if again
              (princ "\n\nREPEAT Mode is ON......")
              (setq temp nil)
         )
    );end-of-while
    (setvar "CLAYER" CLay)
    (if Bug (princ "\nOnPole exited}\n"))
);end-of-defun
;
;
(defun Vtx1 ( / )                                ; Front-End for Interactive Vertex selector
    (setq aper (getvar "APERTURE")
          cpt  'cpt1
          ept  'ept1
          ang  'ang1
    )
    (setvar "APERTURE" (getvar "PICKBOX")) ;--Make sure both are the same
    (Vtx2 "FIRST")
    (setq cpt 'cpt2
          ept 'ept2
          ang 'ang2
    )
    (Vtx2 "SECOND")
    (setq diff (abs (- ang1 ang2)))
    (if (> diff pi)
         (setq mp (+ (- (min ang1 ang2) pi) (/ diff 2)))
         (setq mp (+ (min ang1 ang2) (/ diff 2)))
    )
    (setq ipt    ept2
          hlfwth (* (cdr (assoc 40 (entget (car pfent)))) 0.5)
          m      (- MP (/ pi 2))
    )
    (setvar "APERTURE" aper)
);end-of-defun
;
;
(defun Vtx2 ( which / )                          ; Interactive Vertex selector
    (setq pfent nil)
    (while (null pfent)
         (if (setq pfent (entsel (strcat "\n Select " which " POLYLINE near Vertex (Use button 0): ")))
              (if (not (or (= (cdr (assoc 0 pfent)) "LWPOLYLINE") (= (cdr (assoc 0 pfent)) "POLYLINE")))
                   (progn
                        (princ "\n\nSelected entity was not a POLYLINE...Please retry!")
                        (setq pfent nil)
                   )
                   (progn
                        (setq spt (cadr pfent))
                        (set  cpt (osnap spt "NEA"))
                        (set  ept (osnap spt "END"))		; - Removed "QUICK" for W10
                        (set  ang (angle (eval cpt) (eval ept)))
                        (if (or (equal spt (eval cpt) 0.0001) (equal spt (eval ept) 0.0001))
                             (progn
                                  (princ "\nTry again and DON'T USE OBJECT SNAP for pick!")
                                  (setq pfent nil)
                             )
                        )
                   )
              );end-of-if
              (progn
                   (princ "\n\nSelected entity was not FOUND...Please retry!")
                   (setq     pfent     nil)
              )
         );end-of-if
    );end-of-while
);end-of-defun
;
;
(defun SetThk ( el /    newthk )                 ; sets thickness of the main entities
;------------------------------------------------------------------------------
;!setthk(el) sets thickness of the main entities whose entity list is passed.
    (if Bug (princ "setthk entered/exited"))
    (cond
         ((and (not sff) sf)
              (setq sff (/ sf 0.3408))
         );cond-1
         ((and (not sf) sff)
              (setq sf (* sff 0.3408))
         );cond-2
         ((and (not sff) (not sf))
              (SetScale)
         );cond-3
    );end-of-condition
    (if sff
         (if (= (substr (cdr (assoc 8 el)) 5 2) "FL") ; If FL Layer
              (if (assoc 39 el)                  ; If FL has Thickness, replace it...
                   (setq el (subst (cons 39 (+ (cdr (assoc 39 el)) (* sff 0.01)))
                                   (assoc 39 el)
                                   el
                            )
                   )
                   (if (assoc 40 el)             ; If FL has no Thickness, create it based on start width?
                        (setq el (cons (cons 39 (+ (/ (cdr (assoc 40 el))
                                                      (* (getwid (cdr (assoc 8 el))) 0.3048)
                                                   )
                                                   (* sff 0.01)
                                                )
                                       )
                                       el
                                 )
                        )
                        (setq el (cons (cons 39 (* sff 0.01))
                                       el
                                 )
                        )
                   )
              );end-of-if
              (if (or (= (substr (cdr (assoc 8 el)) 7 1) "T")
                      (= (substr (cdr (assoc 8 el)) 7 1) "B")
                  )
                  (if (assoc 39 el)             ; If T/B Text set Thickness based on PlThk?
                       (setq el (subst (cons 39 (+ sff (* plthk 0.01)))
                                       (assoc 39 el)
                                       el
                                )
                       )
                       (setq el (cons (cons 39 (+ sff (* plthk 0.01)))
                                      el
                                )
                       )
                  )
                  (if (assoc 39 el)             ; If anything else, set Thickness based on SFF!
                       (setq el (subst (cons 39 sff)
                                       (assoc 39 el)
                                       el
                                )
                       )
                       (setq el (cons (cons 39 sff) el))
                  )
              );end-of-if
         );end-of-if
    );end-of-if
    (if sff
         (entmod el)
    )
    (princ)
);end-of-defun
;
;
(setq    LodVer    "2.5.2f")
