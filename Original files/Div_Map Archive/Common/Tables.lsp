(if AppNam                              ; Code Version Indicator {1081 Lines of Code} [19 functions]
    (princ (strcat "\n" AppNam " Tables Loading."))
    (princ "\nCadet 2.1 Tables Loading.")
)

;   Globals defined:    Functions located:  Description:
;   Lst_Wr_S            Bld_Lst_Wire        Wire Size (Str)                 [ordinal position linked to Lst_Wr_T, Lst_Wr_S]
;   Lst_Wr_T            Bld_Lst_Wire        Wire Type (Str)                 [ordinal position linked to Lst_Wr_T, Lst_Wr_S]
;   Lst_No_Dev          Bld_No_Dev          Normal State Aware Device List - Current Block Name (Str) & Alternate Block Name (Str)
;   Lst_No_Ver          Bld_No_Ver          Normal State Version Device List - Block Name (Str)
;   Lst_Sub_Pos         Bld_Sub_Pos         Substation Position - Code (Str) & Dwg (Str) & Div (Str) & Desc (Str) & Org (Str) & Block (Str) & Easting (Str) & Northing (Str)
;   Lst_Fd_C            Bld_T_Fdr           Feeder Color (Int)              [ordinal position linked to Lst_Fd_V, Lst_Fd_C, Lst_Fd_S]
;   Lst_Fd_S            Bld_T_Fdr           Feeder Description (Str)        [ordinal position linked to Lst_Fd_V, Lst_Fd_C, Lst_Fd_S]
;   Lst_Fd_V            Bld_T_Fdr           Feeder Code (Three-Digit Str)   [ordinal position linked to Lst_Fd_V, Lst_Fd_C, Lst_Fd_S]
;   Lst_Sb_S            Bld_T_Fdr           SubStation Name (Str)           [ordinal position linked to Lst_Sb_S, Lst_Sb_V]
;   Lst_Sb_V            Bld_T_Fdr           SubStation Code (Two-Digit Str) [ordinal position linked to Lst_Sb_S, Lst_Sb_V]
;   Lst_Pan_ID          Bld_T_Panel         Panel List - Panel Name (Str) & Panel ID (Int)
;   Lst_Ph_C            Bld_T_Ph            Phase Color (Int)               [ordinal position linked to Lst_Ph_S, Lst_Ph_C, Lst_Ph_W]
;   Lst_Ph_S            Bld_T_Ph            Phase Name (Str)                [ordinal position linked to Lst_Ph_S, Lst_Ph_C, Lst_Ph_W]
;   Lst_Ph_W            Bld_T_Ph            Phase Width (Float)             [ordinal position linked to Lst_Ph_S, Lst_Ph_C, Lst_Ph_W]
;   Lst_Sp_AS           Bld_T_Sp1           Attribute Size (Float)          [ordinal position linked to Lst_Sp_xx]
;   Lst_Sp_Dn           Bld_T_Sp1           Device Name (Str)               [ordinal position linked to Lst_Sp_xx]
;   Lst_Sp_Er           Bld_T_Sp1           Edit Rule (Str)                 [ordinal position linked to Lst_Sp_xx]
;   Lst_Sp_Ln           Bld_T_Sp1           Layer Name (Str)                [ordinal position linked to Lst_Sp_xx]
;   Lst_Sp_Ma           Bld_T_Sp1           Mode Available (Str)            [ordinal position linked to Lst_Sp_xx]
;   Lst_Sp_Mu           Bld_T_Sp1           Menu Use (Str)                  [ordinal position linked to Lst_Sp_xx]
;   Lst_Sp_Oc           Bld_T_Sp1           Object Class (Str)              [ordinal position linked to Lst_Sp_xx]
;   Lst_Sp_Rt           Bld_T_Sp1           Rotated {Y or N} (Str)          [ordinal position linked to Lst_Sp_xx]
;   Lst_Sp_Sn           Bld_T_Sp1           Symbol Name (Str)               [ordinal position linked to Lst_Sp_xx];   Lst_Sp_Ss           Bld_T_Sp1           Symbol Size (Float)             [ordinal position linked to Lst_Sp_xx]
;   Lst_Ts_DN           Bld_T_Txt           Text Description (Str)          [ordinal position linked to Lst_Ts_ER, Lst_Ts_LN, Lst_Ts_HT, Lst_Ts_DN]
;   Lst_Ts_ER           Bld_T_Txt           Edit Rule {T,B or D} (Str)      [ordinal position linked to Lst_Ts_ER, Lst_Ts_LN, Lst_Ts_HT, Lst_Ts_DN]
;   Lst_Ts_HT           Bld_T_Txt           Text Height (Float) in (Str)    [ordinal position linked to Lst_Ts_ER, Lst_Ts_LN, Lst_Ts_HT, Lst_Ts_DN]
;   Lst_Ts_LN           Bld_T_Txt           Layer Name (Str)                [ordinal position linked to Lst_Ts_ER, Lst_Ts_LN, Lst_Ts_HT, Lst_Ts_DN]
;   Lst_Clr_kV          Bld_T_Vlt           Voltage Designator (Two-Digit Str) & Color (Int)
;   Lst_Vt_C            Bld_T_Vlt           Voltage Color (Int)             [ordinal position linked to Lst_Vt_S]
;   Lst_Vt_S            Bld_T_Vlt           Voltage Name (Str)              [ordinal position linked to Lst_Vt_C]
;   Lst_kV_Clr          Bld_T_Vlt           Voltage Designator (Three-Digit Str) & Color (Int)
;   Lst_Oh_S            Bld_T_Wire          Wire Name (Str)
;   Lst_Ug_S            Bld_T_Wire          Wire Name (Str)
;   Lst_Vld_MPG         Bld_Vld_MPG         Valid MPG Poster List - NT_ID (Str) & Full Name (Str)

;subroutines listed - 22oct14 - karl
;              Tables
;              Bld_Sht_Siz
;              Bld_UnqClr
;              C:ShwVUsr
;              Bld_Vld_MPG
;              Bld_No_Ver
;              Bld_No_Dev
;              Bld_Sub_Pos
;              Bld_Sub_Pos_Old
;              Bld_Sub_Pos_New
;              Bld_T_Panel
;              Bld_T_Panel_Old
;              Bld_T_Panel_New
;              Bld_T_URD
;              Bld_T_Vlt
;              Bld_T_Ph
;              Bld_T_Wire
;              Bld_T_Fdr
;              Bld_T_Fdr_Old
;              C:ETsTest
;              Bld_T_Fdr_New
;              Bld_T_Txt
;              Bld_Lst_Wire
;              Bld_T_Sp1
;              Bld_T_Sp2
;              Bld_Err_Lst
;              SubLoad
;              Stp2sp
;              QuadLoad
;              C:Sub

(defun Tables ( / )                     ; Runs all List Building Routines
    (Bld_T_Vlt)     ; Source Date Not from DB
    (Bld_T_Ph)      ; Source Date Not from DB
    (Bld_T_Wire)    ; Source Date Not from DB
    (Bld_T_Fdr)     ; Source Data from DB
    (Bld_T_Txt)     ; Source Date Not from DB
    (Bld_T_Sp1)     ; Source Date Not from DB - Maybe Lu_Symbols in future no CADET symbols in DB table text file has Cadet Symbols.
    (Bld_T_Sp2)     ; Source Date Not from DB - depends on Bld_T_Sp2
    (Bld_Lst_Wire)  ; Source Date Not from DB
    (Bld_Sub_Pos)   ; Source Data from DB
    (Bld_Err_Lst)   ; Source Date Not from DB
    (Bld_T_Panel)   ; Source Data from DB
    (Bld_No_Dev)    ; Source Data from DB
    (Bld_No_Ver)    ; Source Data from DB
    (Bld_Vld_MPG)   ; Source Data from DB
    (Bld_UnqClr)    ; Source Data from DB
    (Bld_Sht_Siz)   ; Source Data from DB
    (princ)
);end-of-defun
;
;
(defun Bld_Sht_Siz ( /  fp1                 ; Builds Valid Plotting Sheet Size List
                    _STR )
    (if Bug (princ "\n{ Bld_Sht_Siz entered}\n"))
    (setq LstShtSiz (list (cons "A" (list 10.5  8.0))
                          (cons "B" (list 16.0 10.0))
                          (cons "C" (list 21.0 16.0))
                          (cons "D" (list 33.0 21.0))
                          (cons "E" (list 43.0 33.0))
                          (cons "F" (list 40.0 28.0))
                    )
    )
    (if Bug (princ "\n{ Bld_Sht_Siz exited}\n"))
    (princ)
);end-of-defun
;
;
(defun Bld_UnqClr ( / )                     ; Builds Unique Color Value List
    (if (null Lst_UnqClrVal)
        (setq Lst_UnqClrVal (list (cons 1 "A")     ;results in ((1 . "A") (2 . "B") etc.
                                  (cons 2 "B")
                                  (cons 3 "C")
                                  (cons 4 "D")
                                  (cons 5 "E")
                                  (cons 6 "F")
                                  (cons 7 "G")
                                  (cons 8 "H")
                                  (cons 9 "I")
                                  (cons 10 "J")
                                  (cons 11 "K")
                                  (cons 12 "L")
                                  (cons 14 "M")
                                  (cons 20 "N")
                                  (cons 25 "P")
                                  (cons 30 "Q")
                                  (cons 32 "R")
                                  (cons 34 "S")
                                  (cons 36 "T")
                                  (cons 40 "V")
                                  (cons 86 "W")
                                  (cons 96 "X")
                                  (cons 191 "Y")
                                  (cons 226 "Z")   ;"o" & "u" missing
                            )
        )
    )
    (if Bug (princ "\n{ Bld_UnqClr exited}\n"))
    (princ)
);end-of-defun
;
;
(defun C:ShwVUsr ( /    AttWas              ; Displays Valid User List
                Ent0 Ent1 Ent2 Ent3 xd P_Max P_Num DA_Val dd
                BlpWas CmdWas ColWas EchWas ExWas FilWas LayWas LtWas OsWas TmdWas )
    (if Bug (princ "\n{ C:ShwVUsr entered}\n"))
    (if Lst_Vld_MPG
        (princ (strcat "\n" (PadCharR "NT_ID" 10) "Full Name\n" (PadCharR "*****" 10) "*********"))
    )
    (if Lst_Vld_MPG
        (mapcar (quote (lambda (x)
                           (princ (strcat "\n" (PadCharR (car x) 10) (cdr x)))
                       )
                )
                Lst_Vld_MPG
        )
    )
    (if Bug (princ "\n{ C:ShwVUsr exited}\n"))
    (princ)
);end-of-defun
;
;
;;;below - list of NTID's updated & alphabetized & made consistent across seven "tables.lsp" files. (11june14 - karl)
;;;        S:\Workgroups\APC Power Delivery\Division Mapping Test\Common\                    tables.lsp
;;;        S:\Workgroups\APC Power Delivery\Division Mapping Test\TestTransmission\Common\   tables.lsp
;;;        S:\Workgroups\APC Power Delivery\Division Mapping Test\Test Distribution\Common\  tables.lsp
;;;        S:\Workgroups\APC Power Delivery\Division Mapping\Common\                         tables.lsp
;;;        S:\Workgroups\APC Power Delivery-ACC\Transmap\ADDS_TMap\Common\                   tables.lsp
;;;        S:\Workgroups\GPC Real-Time Systems\STAFF\Transmap\ADDS_TMap\Common\              tables.lsp
;;;        S:\Workgroups\GPC Real-Time Systems\STAFF\Transmap\Division Mapping\Common\       tables.lsp
(defun Bld_Vld_MPG ( / )                    ; Builds Valid MPG Poster List
    (if Bug (princ "\n{ Bld_Vld_MPG entered}\n"))
    (setq Lst_Vld_MPG (list           ;Authorized Users...
                            ;	Support
                            (cons "CETAYLOR"   "Taylor, Ed")
					    (cons "GEWILYMS"   "Williams, G. Ed")
			    		    (cons "JSMARCHA"   "Marchant, Jeremy Scott")
					    (cons "X2BDPILE"   "Pileggi, Brandt Dylan")
                            (cons "MPGSELL"    "Gsell, Mickey Preston")
                            (cons "ZDING"      "DING, ZHIJUN")
					    ;	ACC
					    (cons "JESMITH"    "Smith, Joseph E.")
					    (cons "KECOLLIN"   "Collims, Kerry E.")
					    (cons "GRMARTIN"   "Martin, Gerald R.")
					    ;	GPC
					    (cons "RTVANDAM"   "Van Dam, Robert T.")
					    (cons "CDHUFF"     "Huff, Carl D.")
					    (cons "RCMCPHER"   "McPherson, Randall C.")
					    (cons "PETAIT"     "Tait, Phoebe E.")
					    ;	APC - DTS
                            (cons "JOELALDR"   "Aldridge, Joel")       ;results in ("JOELALDR" . "Aldridge, Joel") etc.
                            (cons "JAMMONS"    "Ammons, Janice S.")
                            (cons "GGBURTON"   "Burton,Gene G.")
                            (cons "MRBURK"     "Burk, Melinda R.")
                            (cons "RCHAMBER"   "Chambers, Robert")
                            (cons "X2MILDAV"   "Davis, Miles, I")
                            (cons "CJDUPREE"   "Dupree, Nedra, J")
                            (cons "JAMESEVA"   "Evans, James")
                            (cons "SFIELDS"    "Fields, Stephen")
                            (cons "RSFRANKL"   "Franklin, Rush S.")
                            (cons "RFRAZIER"   "Frazier, Roger")
                            (cons "X2MGIATT"   "Giattina, Marlena M.")
                            (cons "TAGRIFFI"   "Griffin, Tammie")
                            (cons "X2NHERND"   "Herndon, Noah")
                            (cons "X2JIMBRA"   "Imbragulio, John")
                            (cons "X2BLOPEZ"   "Lopez, Bobby (Dakota)")
                            (cons "X2WMARTI"   "Martin, Wesley")
                            (cons "AMEEKS"     "Murdock, Annette")
                            (cons "RSROCHEF"   "Rochefort, Randy")
                            (cons "JATWOOD"    "Wood, Jason")
                            (cons "X2SCMART"    "Martin, Scarlet")
                            (cons "JOLIVERI"    "Oliverius, Joseph")
                      );end-of-list
    );end-of-setq
    (if Bug (princ "\n{ Bld_Vld_MPG exited}\n"))
    (princ)
);end-of-defun
;
;
(defun Bld_No_Ver ( /   )                   ; Builds Normal State Version Device List    
    (if Bug (princ "\n{ Bld_No_Dev entered}\n"))
    (setq Lst_No_Ver (list  ;Adds Devices
                            "A085"  ;ATS Switch (NO)
                            "A188"  ;AutoBooster (NO)
                            "A171"  ;AutoContact Switch (NO)
                            "A181"  ;Breaker (NO)
                            "A172"  ;Disconnect Switch (NO)
                            "A175"  ;Elbow- Load Break
                            "A180"  ;Elbow- Non Load Break
                            "A191"  ;F-Type Switch (NO)
                            "A065"  ;Fuse (NO)
                            "A170"  ;Fused Cutout Switch (NO)
                            "A170S" ;Fused Cutout Switch (Small) (NO)
                            "A173"  ;Gang Switch (NO)
                            "A197"  ;MO Gang Switch (NO)
                            "A199"  ;Network Protector (NO)
                            "A158"  ;Oil-Type (NO)
                            "A069"  ;RackMount Disconnect (NO)
                            "A169"  ;Recloser (NO)
                            "A194"  ;Recloser BiDir (NO)
                            "A189"  ;Regulator (NO)
                            "A192"  ;Regulator BiDir (NO)
                            "A176"  ;Sectionalizer (NO)
                            "A142"  ;SubStation Breaker (NO)
                            "A109"  ;UG N.O. Switch <-> Jumper (NO)
                     )
    )
    (princ)
);end-of-defun
;
;
(defun Bld_No_Dev ( /   )                   ; Builds Normal State Aware Device List
    (if Bug (princ "\n{ Bld_No_Dev entered}\n"))
    (setq Lst_No_Dev (list  ;Adds Devices
                            (cons   "A120"  "A188")   ;AutoBooster            ;results in (("A120" . "A188") ("A188" . "A120") etc.
                            (cons   "A188"  "A120")   ;AutoBooster (NO)
                            (cons   "A123"  "A171")   ;AutoContact Switch
                            (cons   "A171"  "A123")   ;AutoContact Switch (NO)
                            (cons   "A084"  "A085")   ;AutoTransfer Switch
                            (cons   "A085"  "A084")   ;AutoTransfer Switch (NO)
                            (cons   "A164"  "A181")   ;Breaker
                            (cons   "A181"  "A164")   ;Breaker (NO)
                            (cons   "A101"  "A147")   ;Capacitor
                            (cons   "A147"  "A101")   ;Capacitor (NO)
                            (cons   "A148"  "A148")   ;Critical Customer
                            (cons   "A082"  "A082")   ;Customer Equipment
                            (cons   "A156"  "A156")   ;DA Device
                            (cons   "A124"  "A172")   ;Disconnect Switch
                            (cons   "A172"  "A124")   ;Disconnect Switch (NO)
                            (cons   "A167"  "A175")   ;Elbow- Load Break
                            (cons   "A175"  "A167")   ;Elbow- Load Break (NO)
                            (cons   "A177"  "A180")   ;Elbow- Non Load Break
                            (cons   "A180"  "A177")   ;Elbow- Non Load Break (NO)
                            (cons   "A190"  "A191")   ;F-Type Switch
                            (cons   "A191"  "A190")   ;F-Type Switch (NO)
                            (cons   "A106"  "A106")   ;Fault Detection
                            (cons   "A137"  "A137")   ;Feed Arrow
                            (cons   "A130"  "A130")   ;Feeder Arrow
                            (cons   "A080"  "A080")   ;Feeder Number
                            (cons   "A131"  "A065")   ;Fuse
                            (cons   "A065"  "A131")   ;Fuse (NO)
                            (cons   "A125"  "A170")   ;Fused Cutout Switch
                            (cons   "A170"  "A125")   ;Fused Cutout Switch (NO)
                            (cons   "A125S" "A170S")  ;Fused Cutout Switch (Small)
                            (cons   "A170S" "A125S")  ;Fused Cutout Switch (Small) (NO)
                            (cons   "A126"  "A173")   ;Gang Switch
                            (cons   "A173"  "A126")   ;Gang Switch (NO)
                            (cons   "A104"  "A104")   ;Generator
                            (cons   "A132"  "A132")   ;Ground
                            (cons   "A161"  "A160")   ;Interrupter
                            (cons   "A160"  "A161")   ;Interrupter (NO)
                            (cons   "A037"  "A037")   ;Junction
                            (cons   "A183"  "A183")   ;Key Customer
                            (cons   "A134"  "A134")   ;Lightning Arrestor
                            (cons   "A086"  "A086")   ;Location Marker
                            (cons   "A081"  "A081")   ;Location Marker UG
                            (cons   "A196"  "A197")   ;MO Gang Switch
                            (cons   "A197"  "A196")   ;MO Gang Switch (NO)
                            (cons   "A041"  "A041")   ;Manhole
                            (cons   "A198"  "A199")   ;Network Protector
                            (cons   "A199"  "A198")   ;Network Protector (NO)
                            (cons   "A157"  "A158")   ;Oil-Type
                            (cons   "A158"  "A157")   ;Oil-Type (NO)
                            (cons   "A079"  "A079")   ;Pad
                            (cons   "A078"  "A078")   ;Padmount
                            (cons   "A135"  "A135")   ;Potential Device
                            (cons   "A150"  "A150")   ;Primary meter
                            (cons   "A042"  "A042")   ;Pull Box
                            (cons   "A105"  "A169")   ;Recloser
                            (cons   "A169"  "A105")   ;Recloser (NO)
                            (cons   "A193"  "A194")   ;Recloser BiDir
                            (cons   "A194"  "A193")   ;Recloser BiDir (NO)
					    (cons   "A213"  "A214")   ;Recloser CX
                            (cons   "A133"  "A189")   ;Regulator
                            (cons   "A189"  "A133")   ;Regulator (NO)
                            (cons   "A195"  "A192")   ;Regulator BiDir
                            (cons   "A192"  "A195")   ;Regulator BiDir (NO)
                            (cons   "A140"  "A140")   ;Riser
                            (cons   "A155"  "A155")   ;Rtu sensor
                            (cons   "A038"  "A038")   ;Secondary Pedestal
                            (cons   "A121"  "A176")   ;Sectionalizer
                            (cons   "A176"  "A121")   ;Sectionalizer (NO)
                            (cons   "A138"  "A142")   ;SubStation Breaker
                            (cons   "A142"  "A138")   ;SubStation Breaker (NO)
                            (cons   "A136"  "A136")   ;SubStation Transformer
                            (cons   "A074"  "A074")   ;Substation
                            (cons   "A165"  "A165")   ;Substation Getaway
                            (cons   "A073"  "A073")   ;Substation Meter
                            (cons   "A076"  "A076")   ;Substation-Customer
                            (cons   "A075"  "A075")   ;Substation-Unit
                            (cons   "A040"  "A040")   ;Terminating Cabinet
                            (cons   "A077"  "A077")   ;Transclosure
                            (cons   "A033"  "A033")   ;Transformer-OH 1 Ph
                            (cons   "A035"  "A035")   ;Transformer-OH 3 Ph
                            (cons   "A034"  "A034")   ;Transformer-OH 3 Ph WYE
                            (cons   "A031"  "A031")   ;Transformer-PM 1 Ph
                            (cons   "A036"  "A036")   ;Transformer-PM 3 Ph
                            (cons   "A032"  "A032")   ;Transformer-PM 3 Ph WYE
                            (cons   "A122"  "A122")   ;Transformer-StepDown
                            (cons   "A071"  "A109")   ;UG N.O. Switch <-> Jumper
                            (cons   "A109"  "A071")   ;UG N.O. Switch <-> Jumper (NO)
                            (cons   "A039"  "A039")   ;Vault
                            
                            ;   Added 6/22/21
                            (cons   "A205"  "A206")   ;Interrupter Multi-Position 
					    (cons   "A203"  "A204")   ;Disconnect Multi-Position
                            (cons   "A207"  "A208")   ;Recloser (Dropout)
                            (cons   "A209"  "A209")   ;Recloser (Dropout) NCL
                            (cons   "A213"  "A214")   ;Recloser, Circuit SW
                            (cons   "A216"  "A216")   ;Recloser, Circuit SW NOP
                            (cons   "A210"  "A210")   ;Recloser (Dropout) NOP
                            
                            ;   GCC EMB Class B
                            (cons   "A906"  "A910")   ;Air Circuit Breaker CLO
                            (cons   "A910"  "A906")   ;Air Circuit Breaker OPN
                            (cons   "A901"  "A902")   ;Automatic Interrupter CLO
                            (cons   "A902"  "A901")   ;Automatic Interrupter OPN
                            (cons   "A907"  "A911")   ;Gas Circuit Breaker CLO
                            (cons   "A911"  "A907")   ;Gas Circuit Breaker OPN
                            (cons   "A905"  "A909")   ;Oil Circuit Breaker CLO
                            (cons   "A909"  "A905")   ;Oil Circuit Breaker OPN
                            (cons   "A908"  "A912")   ;Vacuum Circuit Breaker CLO
                            (cons   "A912"  "A908")   ;Vacuum Circuit Breaker OPN
                            
                            ;   GCC EMB Class DT
                            (cons   "A917"  "A918")   ;Fiber Optics CLO
                            (cons   "A918"  "A917")   ;Fiber Optics OPN
                            (cons   "A949"  "A950")   ;Transfer Trip CLO
                            (cons   "A950"  "A949")   ;Transfer Trip OPN
                            
                            ;   GCC EMB Class MO
                            (cons   "A932"  "A933")   ;Motor Operated Switch CLO
                            (cons   "A933"  "A932")   ;Motor Operated Switch OPN
                            
                            ;   GCC EMB Class RS
                            (cons   "A947"  "A948")   ;Carrier Trap CLO
                            (cons   "A948"  "A947")   ;Carrier Trap OPN
                            (cons   "A915"  "A916")   ;Dead Line Breaker CLO
                            (cons   "A916"  "A915")   ;Dead Line Breaker OPN
                            (cons   "A937"  "A938")   ;Pilot Wire CLO
                            (cons   "A938"  "A937")   ;Pilot Wire OPN
                            (cons   "A944"  "A945")   ;Transfer Cut Out CLO
                            (cons   "A945"  "A944")   ;Transfer Cut Out OPN
                            
                            ;   GCC EMB Class SW
                            (cons   "A919"  "A920")   ;Fused Switch CLO
                            (cons   "A920"  "A919")   ;Fused Switch OPN
                            (cons   "A924"  "A925")   ;Gang Operated Switch CLO
                            (cons   "A925"  "A924")   ;Gang Operated Switch OPN
                            (cons   "A928"  "A929")   ;Knife Switch CLO
                            (cons   "A929"  "A928")   ;Knife Switch OPN
                            (cons   "A940"  "A941")   ;Sectionalizer CLO
                            (cons   "A941"  "A940")   ;Sectionalizer OPN
                            (cons   "A942"  "A943")   ;Single Pole Switch CLO
                            (cons   "A943"  "A942")   ;Single Pole Switch OPN
                                
                      );end-of-list
    );end-of-setq
    (if Bug (princ "\n{ Bld_No_Dev exited}\n"))
    (princ)
);end-of-defun
;
;
(defun Bld_Sub_Pos ( / )
    (if (= (StpDot AppNam) "CADET")
        (Bld_Sub_Pos_Old)
        (Bld_Sub_Pos_New)
    )
);end-of-defun
;
;
(defun Bld_Sub_Pos_Old( /   fp1 STR )               ; Builds Substation Position
    (if Bug (princ "\n{ _Old entered}\n"))
    (if (and _Path-LUT (findfile (strcat _Path-LUT "SubPos.LUT")))
        (if (setq fp1 (open (strcat _Path-LUT "SubPos.LUT") "r"))
            (progn
                (setq Lst_Sub_Pos nil)
                (while (setq _STR (read-line fp1))
                    (setq Lst_Sub_Pos (append Lst_Sub_Pos
                                             (list (read (strcat "(" _STR ")")))
                                      )
                    )
                )
                (close fp1)
            )
            (alert (strcat "ERROR Opening: " _Path-LUT "SubPos.LUT"))
        )
    )
    (if Lst_Sub_Pos
        (setq Lst_Sub_Fnm (mapcar (quote (lambda (x) (strcase (cadr x)))) Lst_Sub_Pos))
    )
    (if Bug (princ "\n{ Bld_Sub_Pos exited}\n"))
    (princ)
);end-of-defun
;
;
(defun Bld_Sub_Pos_New ( / lstSubPoss index lstSubPos)
    (if Bug (princ "Bld_Sub_Pos_New - Start \n"))
    (if (null GetSubPosLUT)
        (command "netload" "C:\\Div_Map\\Common\\Adds.dll")
    )
    (setq lstSubPoss (GetSubPosLUT MyUsrInfo)
          Lst_Sub_Pos nil
    )
    (setq index 0)
    (repeat (length lstSubPoss)
        (setq lstSubPos (nth index lstSubPoss)
              index (+ index 1)
        )
        (setq Lst_Sub_Pos (append Lst_Sub_Pos (list lstSubPos)))
    )
    (if Lst_Sub_Pos
        (setq Lst_Sub_Fnm (mapcar (quote (lambda (x) (strcase (cadr x)))) Lst_Sub_Pos))
    )
    (if Bug(princ "Bld_Sub_Pos_New - Finished \n"))
    (princ)
);end-of-defun
;
;
(defun Bld_T_Panel ( / )
    (if (=(StpDot AppNam) "CADET")
        (Bld_T_Panel_Old)
        (Bld_T_Panel_New)
    )
);end-of-defun
;
;
(defun Bld_T_Panel_Old ( / fp1 _str )               ; Builds Panel ID List
; function to build table for Panel ID
    (if Bug(princ "Bld_T_Panel_Old - Start \n"))
    (if (and _Path-LUT (findfile (strcat _Path-LUT "Panel_ID.LUT")))
        (if (setq fp1 (open (strcat _Path-LUT "Panel_ID.LUT") "r"))
            (progn
                (setq Lst_Pan_ID nil)
                (while (setq _STR (read-line fp1))
                    (setq Lst_Pan_ID (append Lst_Pan_ID
                                            (list (read (strcat "(" _STR ")")))
                                     )
                    )
                )
                (close fp1)
            )
            (alert (strcat "ERROR Opening: " _Path-LUT "Panel_ID.LUT"))
        )
    )
    (if Bug(princ "Bld_T_Panel_Old - Finished \n"))
    (princ)
);end-of-defun
;
;
(defun Bld_T_Panel_New (/ )
    (if Bug(princ "Bld_T_Panel_New - Start \n"))
    (if (null GetPanelIDLUT)
        (command "netload" "C:\\Div_Map\\Common\\Adds.dll")
    )
    (setq lstPanels (GetPanelIDLUT MyUsrInfo)
          Lst_Pan_ID  nil
    )
    (setq index 0)
    (repeat (length lstPanels)
        (setq lstPanel (nth index lstPanels)
              index (+ index 1)
        )
        (setq Lst_Pan_ID (append Lst_Pan_ID (list lstPanel)))
    )
    (if Bug(princ "Bld_T_Panel_New - Finished \n"))
    (princ)
);end-of-defun
;
;
(defun Bld_T_URD ( / fp1 _str )             ; Builds Panel ID List
; function to build table for Panel ID
    (if (and _Path-LUT (findfile (strcat _Path-LUT "URD_Pos.LUT")))
        (if (setq fp1 (open (strcat _Path-LUT "URD_Pos.LUT") "r"))
            (progn
                (setq Lst_URD_Pos nil)
                (while (setq _STR (read-line fp1))
                    (setq Lst_URD_Pos (append Lst_URD_Pos
                                             (list (read (strcat "(" _STR ")")))
                                      )
                    )
                )
                (close fp1)
            )
            (alert (strcat "ERROR Opening: " _Path-LUT "Panel_ID.LUT"))
        )
    )
;;; (if Lst_URD_Pos
;;;     (setq   Lst_URD_Pos (mapcar (quote (lambda (x) (list (nth 0 x) (nth 1 x) (atoi (nth 2 x)) (atoi (nth 3 x)) (nth 4 x)))) Lst_URD_Pos))
;;; )
    (princ)
);end-of-defun
;
;
(defun Bld_T_Vlt ( / )                      ; Builds Voltage Lists
    (setq Lst_kV_Clr (list (list "04" 5)    ;04  kV (was 22)            ;results in (("04" 5) ("12" 7) ("13" 4) etc.
                           (list "12" 7)    ;12  kV (was 30)
                           (list "13" 4)    ;13  kV (was 30)
                           (list "20" 1)    ;20  kV
                           (list "23" 3)    ;23  kV (was 5)
                           (list "25" 3)    ;25  kV (was 5)
                           (list "35" 6)    ;35  kV (was 5)
                           (list "38" 6)    ;38  kV (was 5)
                           (list "44" 6)    ;44  kV (was 1)
                           (list "46" 6)    ;46  kV (was 1)
                           (list "69" 5)    ;69  kV
                           (list "15" 2)    ;115 kV
                           (list "61" 30)   ;161 kV
                           (list "08" 30)   ;208 kV
                           (list "30" 4)    ;230 kV (was 5)
                           (list "80" 2)    ;480 kV
                           (list "00" 3)    ;500 kV
                           (list "AL" 3)    ;All kV
                     )
          Lst_Clr_kV (list (list "004" 5)   ;04  kV (was 22)
                           (list "012" 7)   ;12  kV (was 30)
                           (list "013" 4)   ;13  kV (was 30)
                           (list "020" 1)   ;20  kV
                           (list "023" 3)   ;23  kV (was 5)
                           (list "025" 3)   ;25  kV (was 5)
                           (list "035" 6)   ;35  kV (was 5)
                           (list "038" 6)   ;38  kV (was 5)
                           (list "044" 6)   ;44  kV (was 1)
                           (list "046" 6)   ;46  kV (was 1)
                           (list "069" 5)   ;69  kV
                           (list "115" 2)   ;115 kV
                           (list "161" 30)  ;161 kV
                           (list "208" 30)  ;208 kV
                           (list "230" 4)   ;230 kV (was 5)
                           (list "480" 2)   ;480 kV
                           (list "500" 3)   ;500 kV
                           (list "ALL" 3)   ;All kV
                     )
          Lst_Vt_S (mapcar (quote car)  Lst_kV_Clr)    ;was (list "04" "12" "13" "23" "25" "35" "44" "15" "61" "30" "00")
          Lst_Vt_C (mapcar (quote cadr) Lst_kV_Clr)    ;was (list 5 7 4 6 6 6 1 2 30 5 3)
    );end-of-setq
    (princ)
);end-of-defun
;
;
(defun Bld_T_Ph ( / )                       ; Builds Phase List
;function to build table for number of phases
    (if (or (= (strcase (substr (StpDot AppNam) 1 4)) "ADDS")
            (= (strcase (substr (StpDot AppNam) 1 4)) "BEMS")
            (= (strcase (substr (StpDot AppNam) 1 6)) "CADET2")
            (= (strcase AppNam) "CADET 3.00")
            (= (strcase (substr (StpDot AppNam) 1 7)) "SUBTOOL")
            (= (strcase (substr (StpDot AppNam) 1 3)) "COM")
        )
        (setq Lst_Ph_S (list "ABC" "AB" "AC" "BC" "A" "B" "C")
              Lst_Ph_C (list 1 3 3 3 5 5 5)
              Lst_Ph_W (list 0.04 0.02 0.02 0.02 0.01 0.01 0.01)
        )
        (setq Lst_Ph_S (list "A" "AB" "ABC")
              Lst_Ph_C (list 5 3 1)
              Lst_Ph_W (list 0.01 0.02 0.03)
        )
    )
    (princ)
);end-of-defun
;
;
(defun Bld_T_Wire ( / fp1 _str )                ; Builds Wire Size List
; function to build table for wire size
    (if _Path-LUT
        (progn
            (if (setq fp1 (open (strcat _Path-LUT "wire_oh.lut") "r")) ;overhead portion
                (progn
                    (setq Lst_Oh_S nil)
                    (while (setq _STR (read-line fp1))
                        (setq Lst_Oh_S (append Lst_Oh_S
                                              (read (strcat "(" _STR ")"))
                                       )
                        )
                    )
                    (close fp1)
                )
                (alert (strcat "ERROR Opening: " _Path-LUT "wire_oh.lut"))
            )
            (if (setq fp1 (open (strcat _Path-LUT "wire_ug.lut") "r")) ;underground portion                
                (progn
                    (setq Lst_Ug_S nil)
                    (while (setq _STR (read-line fp1))
                        (setq Lst_Ug_S (append Lst_Ug_S
                                          (read (strcat "(" _STR ")"))
                                       )
                        )
                    )
                    (close fp1)
                )
                (alert (strcat  "ERROR Opening: " _Path-LUT "wire_ug.lut"))
            )
        )
        (princ "Path <_Path-LUT> is not set.")
    )
    (princ)
);end-of-defun
;
;
(defun Bld_T_Fdr ( / )
    (if (= (StpDot AppNam) "CADET")
        (if EtsTestFlag
            (C:ETsTest) ;  (Bld_T_Fdr_Old)
            (Bld_T_Fdr_Old)
        )
        (Bld_T_Fdr_New)
    )
);end-of-defun
;
;
(defun Bld_T_Fdr_Old ( /    fp1 _STR _LST FNam      ; Builds Feeder Data List
                    SbNam )
;function to build table for feeder
;Builds Text List Lst_Fd_V  ---> feeder value (ADDS FEEDER CODE)
;                 Lst_Fd_C  ---> feeder color number.
;                 Lst_Fd_S  ---> feeder description. (DOES number plus substation name.
;                 Lst_Sb_V  ---> sub value
;                 Lst_Sb_S  ---> sub description
    (if Bug (princ "\nBld_T_Fdr_Old - Start \n"))
    (setq FNam "feeder.lut")
    (if (not PadCharR)
        (if (findfile "Utils.lsp")
            (load "Utils")
            (load (strcat PrmRootPath "Common\\Utils.lsp")) ;   If cannot find on local Acad paths load it from here
        )
    )
    (if (= (strcase (substr AppNam 1 5)) "ADDS ")
        (cond
            ((= (StpDot AppNam) "ADDS")
                (if (or (= Div "S_") (= Div "S_"))
                    (setq FNam (strcat _Path-LUT "SB" FNam))
                    (setq FNam (strcat _Path-LUT Div  FNam))
                )
            );cond-1
            ((findfile (strcat _Path-LUT Div FNam))
                (setq FNam (strcat _Path-LUT Div FNam))
            );cond-2
            ((findfile (strcat _Path-LUT FNam))
                (setq FNam (strcat _Path-LUT FNam))
            );cond-3
            ((findfile (strcat _Path-Panel FNam))
                (setq FNam (strcat _Path-Panel FNam))
            );cond-4
            (T
                (if Bug
                    (princ (strcat "\nFnam={" FNam "} Not Found!"))
                    (progn
                        (alert (strcat "***" AppNam " Error!***"
                                       "\nFeeder Look-Up Table Not found!"))
                        (exit)
                    )
                )
                (setq FNam nil)
            );cond-5
        );end-of-condition
        (cond
            ((and Div _Path-LUT)
                (if (findfile (strcat _Path-LUT Div FNam))
                    (setq FNam (strcat _Path-LUT Div FNam))
                    (if (findfile (strcat _Path-LUT FNam))
                        (setq FNam (strcat _Path-LUT FNam))
                    )
                )
            );cond-1
            ((findfile (strcat _Path-LUT FNam))
                (setq FNam (strcat _Path-LUT FNam))
            );cond-2
            ((findfile (strcat _Path-Panel FNam))
                (setq FNam (strcat _Path-LUT FNam))
            );cond-3
            (T
                (if Bug
                    (princ (strcat "\nFnam={" FNam "} Not Found!"))
                    (progn
                        (alert (strcat "***" (if AppNam
                                                 AppNam
                                                 "Unknown Application"
                                             )
                                       " Error!***\nFeeder Look-Up Table Not found!")
                        )
                        (exit)
                    )
                )
                (setq FNam nil)
            );cond-4
        );end-of-condition
    );end-of-if
    (if (and Bug FNam) (princ (strcat "\nOpening " FNam " for import!")))
    (if (and _Path-LUT FNam)
        (if (setq fp1 (open (findfile FNam) "r"))
            (progn
                (setq Lst_Fd_C nil
                      Lst_Fd_S nil
                      Lst_Fd_R nil
                      Lst_Fd_V nil
                      Lst_Fd_B nil
                      Lst_Sb_V nil
                      Lst_Sb_S nil
                )
                (while (setq _STR (read-line fp1))
                    (setq _LST (read (strcat "(" _STR ")")))
                    (if (>= (length _LST) 4)
                        (setq Lst_Fd_V (append Lst_Fd_V (list (nth 0 _LST)))
                              Lst_Fd_C (append Lst_Fd_C (list (nth 1 _LST)))
                              Lst_Fd_B (append Lst_Fd_B (list (nth 2 _LST)))
                            ; Lst_Fd_S (append Lst_Fd_S (list (strcat (nth 2 _LST) " " (nth 3 _LST))))
                              Lst_Fd_S (append Lst_Fd_S (list (strcat (nth 3 _LST) " " (nth 2 _LST))))
                              Lst_Fd_R (append Lst_Fd_R (list (strcat (PadCharR (nth 3 _LST) 32) (nth 2 _LST))))
                        )
                    )
                    (if (>= (length _LST) 4)
                        (if Lst_Sb_V
                            (if (not (member (substr (nth 0 _LST) 1 2) Lst_Sb_V))
                                (setq Lst_Sb_V (append Lst_Sb_V (list (substr (nth 0 _LST) 1 2)))
                                      Lst_Sb_S (append Lst_Sb_S (list (nth 3 _LST)))
                                )
                            )
                            (setq Lst_Sb_V (list (substr (nth 0 _LST) 1 2))
                                  Lst_Sb_S (list (nth 3 _LST))
                            )
                        )
                    )
                );end-of-while
                (close fp1)
            );end-of-progn
            (alert (strcat "ERROR Opening: " _Path-LUT FNam))
        );end-of-if
        (princ "Path <_Path-LUT> is not set.")
    );end-of-if
    (if Bug (princ "\nBld_T_Fdr_Old - Finished \n"))
    (princ)
);end-of-defun
;
;
(defun C:ETsTest ( / )
    (if (not PadCharR)
        (if (findfile "Utils.lsp")
            (load "Utils")
            (load (strcat PrmRootPath "Common\\Utils.lsp")) ;   If cannot find on local Acad paths load it from here
        )
    )
    (if (null GetFeedersLUT)
        (command "netload" "C:\\Div_Map\\Common\\CADET.dll")
    )
    (setq lstFeeders (GetFeedersLUT Div)
          Lst_Fd_C nil
          Lst_Fd_S nil
          Lst_Fd_R nil
          Lst_Fd_V nil
          Lst_Fd_B nil
          Lst_Sb_V nil
          Lst_Sb_S nil
    )
    (setq index 0)
    (repeat (length lstFeeders)
        (setq itemFeeder (nth index lstFeeders)
              index (+ index 1)
        )
        (setq Lst_Fd_V (append Lst_Fd_V (list (nth 0 itemFeeder)))
              Lst_Fd_C (append Lst_Fd_C (list (nth 1 itemFeeder)))
              Lst_Fd_B (append Lst_Fd_B (list (nth 2 itemFeeder)))
            ;;Lst_Fd_S (append Lst_Fd_S (list (strcat (nth 2 itemFeeder) " " (nth 3 itemFeeder))))
              Lst_Fd_S (append Lst_Fd_S (list (strcat (nth 3 itemFeeder) " " (nth 2 itemFeeder))))
              Lst_Fd_R (append Lst_Fd_R (list (strcat (PadCharR (nth 3 itemFeeder) 32) (nth 2 itemFeeder))))
        )
        (if Lst_Sb_V
            (if (not (member (substr (nth 0 itemFeeder) 1 2) Lst_Sb_V))
                (setq Lst_Sb_V (append Lst_Sb_V (list (substr (nth 0 itemFeeder) 1 2)))
                      Lst_Sb_S (append Lst_Sb_S (list (nth 3 itemFeeder)))
                )
            )
            (setq Lst_Sb_V (list (substr (nth 0 itemFeeder) 1 2))
                  Lst_Sb_S (list (nth 3 itemFeeder))
            )
        )
    );end-of-repeat
    (setq EtsTestFlag T)
    (princ)
);end-of-defun
;
;
(defun Bld_T_Fdr_New ( / )
    (if Bug (princ "\nBld_T_Fdr_New - Start \n"))
    (if (not PadCharR)
        (if (findfile "Utils.lsp")
            (load "Utils")
            (load (strcat PrmRootPath "Common\\Utils.lsp")) ;   If cannot find on local Acad paths load it from here
        )
    )
    (if (null GetFeedersLUT)
        (command "netload" "C:\\Div_Map\\Common\\Adds.dll")
    )
    (if Bug (princ "\nBld_T_Fdr_New - 1a \n"))
    (setq lstFeeders (GetFeedersLUT Div MyUsrInfo)
          Lst_Fd_C nil
          Lst_Fd_S nil
          Lst_Fd_R nil
          Lst_Fd_V nil
          Lst_Fd_B nil
          Lst_Sb_V nil
          Lst_Sb_S nil
    )
    (if Bug (princ "\nBld_T_Fdr_New - 1b \n"))
    (setq index 0)
    (repeat (length lstFeeders)
        (setq itemFeeder (nth index lstFeeders)
              index (+ index 1)
        )
        (setq Lst_Fd_V (append Lst_Fd_V (list (nth 0 itemFeeder)))
              Lst_Fd_C (append Lst_Fd_C (list (nth 1 itemFeeder)))
              Lst_Fd_B (append Lst_Fd_B (list (nth 2 itemFeeder)))
              Lst_Fd_S (append Lst_Fd_S (list (strcat (nth 3 itemFeeder) " " (nth 2 itemFeeder) )))
              Lst_Fd_R (append Lst_Fd_R (list (strcat (PadCharR (nth 3 itemFeeder) 32) (nth 2 itemFeeder))))
        )
        (if (and (/= Div "GA")(/= Div "AL"))
            (if Lst_Sb_V
                (if (not (member (substr (nth 0 itemFeeder) 1 2) Lst_Sb_V))
                    (setq Lst_Sb_V (append Lst_Sb_V (list (substr (nth 0 itemFeeder) 1 2)))
                          Lst_Sb_S (append Lst_Sb_S (list (nth 3 itemFeeder)))
                    )
                )
                (setq Lst_Sb_V (list (substr (nth 0 itemFeeder) 1 2))
                      Lst_Sb_S (list (nth 3 itemFeeder))
                )
            )
        )
    );end-of-repeat
    
    (if (or (= Div "GA")(= Div "AL"))
        (progn
            (setq lstSubs (GetTransSubCor Div MyUsrInfo)
                  Lst_Sb_V nil
                  Lst_Sb_S nil
            )
            (setq index 0)
            (repeat (length lstSubs)
                (setq itemSub (nth index lstSubs)
                      index (+ index 1)
                )
                (if Lst_Sb_V
                    (if (not (member (nth 0 itemSub) Lst_Sb_V))
                        (setq Lst_Sb_V (append Lst_Sb_V (list (nth 0 itemSub)))
                              Lst_Sb_S (append Lst_Sb_S (list (nth 1 itemSub)))
                        )
                    )
                    (setq Lst_Sb_V (list (nth 0 itemSub))
                          Lst_Sb_S (list (nth 1 itemSub))
                    )
                )
            );end-of-repeat
        )
    );end-of-if
    
    (if Bug (princ "\nBld_T_Fdr_New - Finished \n"))
    (princ)
);end-of-defun
;
;
(defun Bld_T_Txt ( / fp1 _STR _LST )            ; Builds Text Lists
;Builds Text Lists      Lst_Ts_DN  ---> Text Description
;                           Lst_Ts_HT  ---> Text Height.
;                           Lst_Ts_LN  ---> Layer Name.
;                           Lst_Ts_ER  ---> Edit Rule T,B or D (ie... Above, Below or Horizontal(Dtext))
    (if _Path-LUT
        (if (setq fp1 (open (strcat _Path-LUT "TXT_PROP.LUT") "r"))
            (progn
                (setq Lst_Ts_DN (list)
                      Lst_Ts_HT (list)
                      Lst_Ts_LN (list)
                      Lst_Ts_ER (list)
                )
                (while (setq _STR (read-line fp1))
                    (setq _LST (read (strcat "(" _STR ")")))
                    (if (= (length _LST) 4)
                        (setq Lst_Ts_DN (append Lst_Ts_DN
                                            (list (nth 0 _LST))
                                        )
                             Lst_Ts_HT (append Lst_Ts_HT
                                            (list (nth 1 _LST))
                                        )
                             Lst_Ts_LN (append Lst_Ts_LN
                                            (list (nth 2 _LST))
                                        )
                             Lst_Ts_ER (append Lst_Ts_ER
                                            (list (nth 3 _LST))
                                        )
                        )
                    )
                )
                (close fp1)
            )
            (alert (strcat "Error opening file " _Path-LUT "TXT_PROP.LUT"))
        )
        (princ "Path <_Path-LUT> is not set.")
    )
    (princ)
);end-of-defun
;
;
(defun Bld_Lst_Wire ( / fp1 _STR _LST )     ; Builds Wire Data Lists
;function to build lists for wires
;Builds Wire List Lst_Wr_S   ---> Wire Size
;                 Lst_Wr_T   ---> Wire Type
    (if _Path-LUT
        (progn
            (if (setq fp1 (open (strcat _Path-LUT "WIRESIZE.LUT") "r"))
                (progn
                    (setq Lst_Wr_S (list))
                    (while (setq _STR (read-line fp1))
                        (setq _LST (read (strcat "(" _STR ")")))
                        (if (= (length _LST) 1)
                            (setq Lst_Wr_S (append Lst_Wr_S 
                                              (list (nth 0 _LST))
                                           )
                            )
                        )
                    )
                    (close fp1)
                )
                (alert (strcat "Error opening file " _Path-LUT "WIRESIZE.LUT"))
            )
            (if (setq fp1 (open (strcat _Path-LUT "WIRETYPE.LUT") "r"))
                (progn
                    (setq Lst_Wr_T (list))
                    (while (setq _STR (read-line fp1))
                        (setq _LST (read (strcat "(" _STR ")")))
                        (if (= (length _LST) 1)
                            (setq Lst_Wr_T (append Lst_Wr_T 
							                   (list (nth 0 _LST))
										   )
						    )
                        )
                    )
                    (close fp1)
                )
                (alert (strcat "Error opening file " _Path-LUT "WIRETYPE.LUT"))
            )
        )
        (princ "Path <_Path-LUT> is not set.")
    );end-of-if
    (princ)
);end-of-defun
;
;
(defun Bld_T_Sp1 ( / F S L )                    ; Builds Master Symbols List
; Builds Symbols List 
; Lst_Sp_Dn  ---> Device Name.
; Lst_Sp_Sn  ---> Symbol Name.
; Lst_Sp_Oc  ---> Object Class.
; Lst_Sp_Ss  ---> Symbol Size.  (percent of one)
; Lst_Sp_AS  ---> Attribute Size. (percent of one) - new field for Oracle and below
; Lst_Sp_Ln  ---> Layer Name. (2 chr. if fdr. related (CK,SW) else actual name.)
; Lst_Sp_Er  ---> Edit Rule. (i.e IN - InLine, OP - On Pole, numeric if OffSet)
; Lst_Sp_Ma  ---> Mode Availability Map (i.e. for Modes "EICR", "1000" = E only)
; Lst_Sp_Mu  ---> Menu Toolbar Use
; Lst_Sp_Rt  ---> Item is (Y) or is not (N) a rotated symbol
; L_Tmp1 is built for use by Bld_T_Sp2 and then set to NIL
    (if _Path-LUT
        (if (setq F (open (strcat _Path-LUT "SYM_PROP.LUT") "r"))
            (progn
                (setq Lst_Sp_Dn   (list)
                      Lst_Sp_Sn   (list)
                      Lst_Sp_Oc   (list)
                      Lst_Sp_Ss   (list)
                      Lst_Sp_AS   (list)
                      Lst_Sp_Ln   (list)
                      Lst_Sp_Er   (list)
                      Lst_Sp_Ma   (list)
                      Lst_Sp_Mu   (list)
                      Lst_Sp_Rt   (list)
                      L_Tmp1      (list)
                      Lst_Sp_Dn7  (list)
                      Lst_Sp_Sn7  (list)
                      Lst_Sp_Oc7  (list)
                      Lst_Sp_Ss7  (list)
                      Lst_Sp_AS7  (list)
                )
                (while (setq S (read-line F))
                    (setq L (read (strcat "(" S ")")))
                    (if (>= (length L) 8)
                        (progn
                            (setq Lst_Sp_Dn (append Lst_Sp_Dn (list (nth 0 L)))
                                  Lst_Sp_Sn (append Lst_Sp_Sn (list (nth 1 L)))
                                  Lst_Sp_Oc (append Lst_Sp_Oc (list (nth 2 L)))
                                  Lst_Sp_Ss (append Lst_Sp_Ss (list (nth 3 L)))
                                  Lst_Sp_AS (append Lst_Sp_AS (list (nth 4 L)))
                                  Lst_Sp_Ln (append Lst_Sp_Ln (list (nth 5 L)))
                                  Lst_Sp_Er (append Lst_Sp_Er (list (nth 6 L)))
                                  Lst_Sp_Ma (append Lst_Sp_Ma (list (nth 7 L)))
                                  Lst_Sp_Mu (append Lst_Sp_Mu (list (nth 8 L)))
                                  Lst_Sp_Rt (append Lst_Sp_Rt (list (nth 9 L)))
                            )
                            (if (assoc (nth 2 L) L_Tmp1)
                                (setq L_Tmp1 (subst (append (assoc (nth 2 L) L_Tmp1)
                                                            (list (nth 0 L))
                                                    )
                                                    (assoc (nth 2 L) L_Tmp1)
                                                    L_Tmp1
                                             )
                                )
                                (setq L_Tmp1 (append L_Tmp1
                                                    (list (list (nth 2 L) (nth 0 L)))
                                             )
                                )
                            )
                        )
                    )
                );end-of-while
                (close F)
                (if (null GetSymbolInfo2)
                    (if (=(StpDot AppNam) "CADET")
                        (command "netload" "C:\\Div_Map\\Common\\CADET.dll")
                        (command "netload" "C:\\Div_Map\\Common\\Adds.dll")
                    )
                    
                )
                (if (or (= (StpDot AppNam) "ADDSPLOT") (= (StpDot AppNam) "ADDS"))
                    (if (setq SymbolData (GetSymbolInfo2 div MyUsrInfo))
                        (foreach row SymbolData
                            (setq Lst_Sp_Dn7 (append Lst_Sp_Dn7 (list (nth 0 row)))
                                  Lst_Sp_Sn7 (append Lst_Sp_Sn7 (list (nth 1 row)))
                                  Lst_Sp_Oc7 (append Lst_Sp_Oc7 (list (nth 2 row)))
                                  Lst_Sp_Ss7 (append Lst_Sp_Ss7 (list (atof (nth 3 row))))
                                  Lst_Sp_AS7 (append Lst_Sp_AS7 (list (atof (nth 4 row))))
                            )
                        )
                    )
                )
            )
            (alert (strcat  "Error opening file " _Path-LUT "SYM_PROP.LUT"))
        );end-of-if
        (princ "Path <_Path-LUT> is not set.")
    );end-of-if
    (princ)
);end-of-defun
;
;
(defun Bld_T_Sp2 ( / F S ELEMENT L_Tmp2 )       ; Builds validation list for classes
; Builds attribute validation list for classes.  (i.e. valid sizes for objects.
; 'L_Tmp1' is a temporary list used to create an object class table 'Ls_CLASS'
; and for each class a list is created containing the Device Names in that class.
; The name for each class list will be 'Ls_????_Name' where ???? might be
; SWITCH, RECLOSER, TRANSFRM.
; Additionally, for each class a list will be created from the ????.LUT file
; and the list names will be 'Ls_????_Desc'.
    (if L_Tmp1
        (if _Path-LUT
            (progn
                (setq Ls_CLASS nil)
                (foreach ELEMENT L_Tmp1
                    (if Ls_CLASS
                        (setq Ls_CLASS
                                (append Ls_CLASS
                                       (list (car ELEMENT))
                                )
                        )
                        (setq Ls_CLASS (list (car ELEMENT)))
                    )
                    (set (read (strcat "Ls_" (car ELEMENT) "_Name"))
                         (cons "" (cdr ELEMENT))
                    )
                )
                (foreach ELEMENT L_Tmp1     ; Now read in the LUT files.
                    (if (setq F (open (strcat _Path-LUT (car ELEMENT) ".LUT") "r") )
                        (progn
                            (setq L_Tmp2 (list))
                            (while (setq S (read-line F))
                                (setq L_Tmp2
                                        (append L_Tmp2
                                               (list (read S))
                                        )
                                )
                            )
                            (close F)
                            (set (read (strcat "Ls_" (car ELEMENT) "_Desc"))
                                 (cons "" L_Tmp2)
                            )
                        )
                        (if (not (member (car ELEMENT) (list "GUY" "LAND" "MISC")))
                            (princ (strcat  "Error opening file " _Path-LUT (car ELEMENT) ".LUT"))
                        )
                    )
                )
                (setq Ls_TRANSFRM_Desc (cons "." (cdr Ls_TRANSFRM_Desc)))
            );end-of-progn
            (princ "Path <_Path-LUT> is not set.")
        );end-of-if
        (princ "Bld_T_Sp1 must be run first...")
    );end-of-if
    (setq Ls_Pole_Class (list " " "1" "2" "3" "4" "5" "6" "7" "UNK")
;          L_Tmp1 nil
    )
    (princ)
);end-of-defun
;
;
(defun Bld_Err_Lst ( /  )                   ; Builds Acad-Specific Error List
    (setq Err_Lst (list
                        (cons 0   "No error")
                        (cons 1   "Invalid symbol table name")
                        (cons 2   "Invalid entity or selection set name")
                        (cons 3   "Exceeded maximum number of selection sets")
                        (cons 4   "Invalid selection set")
                        (cons 5   "Improper use of block definition")
                        (cons 6   "Improper use of xref")
                        (cons 7   "Object selection: pick failed")
                        (cons 8   "End of entity file")
                        (cons 9   "End of block definition file")
                        (cons 10  "Failed to find last entity")
                        (cons 11  "Illegal attempt to delete viewport object")
                        (cons 12  "Operation not allowed during PLINE")
                        (cons 13  "Invalid handle")
                        (cons 14  "Handles not enabled")
                        (cons 15  "Invalid arguments in coordinate transform request")
                        (cons 16  "Invalid space in coordinate transform request")
                        (cons 17  "Invalid use of deleted entity")
                        (cons 18  "Invalid table name")
                        (cons 19  "Invalid table function argument")
                        (cons 20  "Attempt to set a read-only variable")
                        (cons 21  "Zero value not allowed")
                        (cons 22  "Value out of range")
                        (cons 23  "Complex REGEN in progress")
                        (cons 24  "Attempt to change entity type")
                        (cons 25  "Bad layer name")
                        (cons 26  "Bad linetype name")
                        (cons 27  "Bad color name")
                        (cons 28  "Bad text style name")
                        (cons 29  "Bad shape name")
                        (cons 30  "Bad field for entity type")
                        (cons 31  "Attempt to modify deleted entity")
                        (cons 32  "Attempt to modify seqend subentity")
                        (cons 33  "Attempt to change handle")
                        (cons 34  "Attempt to modify viewport visibility")
                        (cons 35  "Entity on locked layer")
                        (cons 36  "Bad entity type")
                        (cons 37  "Bad polyline entity")
                        (cons 38  "Incomplete complex entity in block")
                        (cons 39  "Invalid block name field")
                        (cons 40  "Duplicate block flag fields")
                        (cons 41  "Duplicate block name fields")
                        (cons 42  "Bad normal vector")
                        (cons 43  "Missing block name")
                        (cons 44  "Missing block flags")
                        (cons 45  "Invalid anonymous block")
                        (cons 46  "Invalid block definition ")
                        (cons 47  "Mandatory field missing")
                        (cons 48  "Unrecognized extended data (XDATA) type")
                        (cons 49  "Improper nesting of list in XDATA")
                        (cons 50  "Improper location of APPID field")
                        (cons 51  "Exceeded maximum XDATA size")
                        (cons 52  "Entity selection: null response")
                        (cons 53  "Duplicate APPID")
                        (cons 54  "Attempt to make or modify viewport entity")
                        (cons 55  "Attempt to make or modify an xref, xdef, or xdep")
                        (cons 56  "ssget filter: unexpected end of list")
                        (cons 57  "ssget filter: missing test operand")
                        (cons 58  "ssget filter: invalid opcode (-4) string")
                        (cons 59  "ssget filter: improper nesting or empty conditional clause")
                        (cons 60  "ssget filter: mismatched begin and end of conditional clause")
                        (cons 61  "ssget filter: wrong number of arguments in conditional clause (for NOT or XOR)")
                        (cons 62  "ssget filter: exceeded maximum nesting limit")
                        (cons 63  "ssget filter: invalid group code")
                        (cons 64  "ssget filter: invalid string test")
                        (cons 65  "ssget filter: invalid vector test")
                        (cons 66  "ssget filter: invalid real test")
                        (cons 67  "ssget filter: invalid integer test")
                        (cons 68  "Digitizer isnt a tablet")
                        (cons 69  "Tablet is not calibrated")
                        (cons 70  "Invalid tablet arguments")
                        (cons 71  "ADS error: Unable to allocate new result buffer")
                        (cons 72  "ADS error: Null pointer detected")
                        (cons 73  "Cant open executable file")
                        (cons 74  "Application is already loaded")
                        (cons 75  "Maximum number of applications already loaded")
                        (cons 76  "Unable to execute application")
                        (cons 77  "Incompatible version number")
                        (cons 78  "Unable to unload nested application")
                        (cons 79  "Application refused to unload")
                        (cons 80  "Application is not currently loaded")
                        (cons 81  "Not enough memory to load application")
                        (cons 82  "ADS error: Invalid transformation matrix")
                        (cons 83  "ADS error: Invalid symbol name")
                        (cons 84  "ADS error: Invalid symbol value")
                        (cons 85  "AutoLISP/ADS operation prohibited while a dialog box was displayed")
                  );end-of-list
    );end-of-setq
);end-of-defun
;
;
(defun SubLoad ( /  x PosOut                    ; Builds a list of substation names
                Lst_Pr_Fd Lst_Sn_Fd )
    (if (not Lst_Fd_V)
        (if (not Bld_T_Fdr)
            (progn
                (load "TABLES");tables.lsp (this file - yes, very funny - karl)
                (Bld_T_Fdr)
            )
            (Bld_T_Fdr)
        )
    )
    (setq Lst_Pr_Fd nil
          Lst_Sn_Fd nil
    )
    (foreach x Lst_Fd_V
            (if Bug (princ "."))
            (if Lst_Pr_Fd
                (if (assoc (substr x 1 2) Lst_Pr_Fd)
                    (if Bug (princ "x"))
                    (setq Lst_Pr_Fd (cons (cons (substr x 1 2) x) Lst_Pr_Fd)
                          Lst_Sn_Fd (cons (substr x 1 2) Lst_Sn_Fd)
                    )
                )
                (setq Lst_Pr_Fd (list (cons (substr x 1 2) x))
                      Lst_Sn_Fd (list (substr x 1 2))
                )
            )
    )
    (if Lst_Sn_Fd
        (setq Lst_Sn_Fd (acad_strlsort Lst_Sn_Fd))
    )
    (if Lst_Pr_Fd
        (foreach x Lst_Sn_Fd
                (if Bug (princ "+"))
                (if (member (cdr (assoc x Lst_Pr_Fd)) Lst_Fd_V)
                    (progn
                        (setq PosOut (- (length Lst_Fd_V) (length (member (cdr (assoc x Lst_Pr_Fd)) Lst_Fd_V))))
                        (if Bug (princ (strcat "\nPosOut: " (itoa PosOut))))
                        (if SubNames
                            (setq SubNames (cons (cons x (Stp2sp (nth PosOut Lst_Fd_S)))
                                                 SubNames
                                           )
                            )
                            (setq SubNames (list (cons x (Stp2sp (nth PosOut Lst_Fd_S)))))
                        )
                    )
                    (if Bug (princ (strcat "\nDied on: " (car x))))
                )
        )
    )
    (if SubNames
       (setq SubNames (reverse SubNames))
    )
);end-of-defun
;
;
(defun Stp2sp ( InStr / Found Cnt )         ; Utility to strip string up to the first space
    (setq StLen (strlen InStr)
          Found nil
          Cnt   1
    )
    (while (and (< Cnt StLen) (not Found))
        (if (= (substr InStr Cnt 1) (chr 32))
            (setq Found (1+ Cnt))
        )
        (setq Cnt (1+ Cnt))
    )
    (if Found
        (substr InStr Found)
        nil
    )
);end-of-defun
;
;
(defun QuadLoad ( / filen linein qdn qdd )      ; Builds a list of quad names
    (if (setq filen (open (strcat _PATH-LUT "quads.lut") "r"))
        (progn
            (setq Quad_Name (list ))
            (setq Quad_Desc (list ))
            (while (setq linein (read-line filen))
                (setq qdn nil)
                (setq qdd nil)
                (setq qdn (substr linein 16 8)
                      qdd (substr linein 2 13)
                )
                (if qdn
                    (setq Quad_Name (append Quad_Name (list qdn)))
                )
                (if qdd
                    (setq Quad_Desc (append Quad_Desc (list qdd)))
                )
            )
            (close filen)
        )
        (alert (strcat "***" AppNam " Error***\nCannot find Quads.LUT"))
    )
);end-of-defun
;
;
(defun C:Sub ( / aper ent plname sb fdr kv  ; Returns the substation name and feeder number
                 subnam tmp )
    (setq aper (getvar "APERTURE"))    ;--Save current setting
    (setvar "APERTURE" (getvar "PICKBOX"))
    (setq ent (entsel "\n Select circuit (Use button 0): "))
    (setvar "APERTURE" aper)
    (if (not subnames)
        (SubLoad)
    )
    (if ent
        (progn
            (setq ent     (entget (car ent))   ;sets <ent> to entity list of <ent>
                  plname  (cdr (assoc 8 ent))
                  sb      (substr plname 1 2)
                  fdr     (substr plname 3 1)
            )
            (if (= (substr plname 5 3) "CK-")
                (if (setq tmp (assoc sb subnames))
                    (progn
                        (setq subnam (cdr tmp)
                              kv     (substr subnam 1 2)
                        )
                        (princ (strcat "\n\n" subnam " Feeder # " (itoa (- (ascii fdr) 64)) "         "))
                    )
                    (princ "\n\nSubstation not found!")
                )
                (princ "\n\n   Entity selected is not a circuit")
            )
        )
        (princ "\n\nNo Entity Selected...")
    )
    (princ)
);end-of-defun
;
;
(setq LodVer "3.0.3g")