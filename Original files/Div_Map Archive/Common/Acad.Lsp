(setq  SCS_A_Ver		"2.0.1w")				; Code Version Indicator {7764 Lines of Code}
(if DevMark								; Load Status Call - informative warning
	(setq	Bubba	(princ (strcat "\nLoading SouthernCo " DevMark " Customizations version [" SCS_A_Ver "]...")))
	(setq	Bubba	(princ (strcat "\nLoading SouthernCo Customizations version [" SCS_A_Ver "]...")))
)

(defun FilUpDatR ( Path1 Path2 FileN / CoolFlag )
	(setq	CoolFlag	nil)
	(if (member (strcase (substr FileN (- (strlen FileN) 2))) (list "ARX"))
		(if (member (strcase FileN T) (arx))
			(arxunload FileN)
		)
	)
	(if (member (strcase (substr FileN (- (strlen FileN) 2))) (list "VLX"))
		(if (vl-vlx-loaded-p FileN)
			(vl-unload-vlx FileN)
		)
	)
	(if	(and	(vl-file-directory-p Path1)
			(not	(equal	(vl-file-size (strcat Path1 FileN))	;Source Path & File
						(vl-file-size (strcat Path2 FileN))	;Destination Path & File
				)
			)
		)
		(progn
			(princ (strcat "\nUpdating " FileN "..."))
			(vl-file-delete (strcat Path2 FileN))
			(vl-file-copy (strcat Path1 FileN) (strcat Path2 FileN))
			(if (member (strcase (substr FileN (- (strlen FileN) 2))) (list "VLX" "MNL" "LSP"))
				(load (strcat Path2 FileN))
			)
			(if (member (strcase (substr FileN (- (strlen FileN) 2))) (list "ARX"))
				(arxload (strcat Path2 FileN))
			)
			(if (member (strcase (substr FileN (- (strlen FileN) 2))) (list "DLL"))
				(startapp (strcat "C:\\WINDOWS\\system32\\regsvr32 /s " Path2 FileN))
			)
			(setq	CoolFlag	nil)
		)
		(progn
			(princ (strcat "\nNot Updating " FileN "..."))
			(if (member (strcase (substr FileN (- (strlen FileN) 2))) (list "VLX" "MNL" "LSP"))
				(load (strcat Path2 FileN))
			)
			(if (member (strcase (substr FileN (- (strlen FileN) 2))) (list "ARX"))
				(arxload (strcat Path2 FileN))
			)
			(setq	CoolFlag	nil)
		)
	)
	CoolFlag
)

(defun C:DivPrtA ( / )						; Division Pretend - CL
	(DivPretendAdds nil)
	(princ)
)

(defun DivPretendAdds ( TDiv / )				; Division Pretend sets variables for test
	(if TDiv
		(setq	Div		(strcase TDiv))
		(if (not Div)
			(setq	Div	(strcase (getstring "\nEnter Division Abbreviation: ")))
		)
	)
	(setq	AppNam			"Adds 3.00"
			_Path-LUT			(strcat PrmRootPath "ADDS\\LUT\\")
			_Path-Lisp		(strcat PrmRootPath "ADDS\\LISP\\")
			_Path-Menu		(strcat PrmRootPath "Adds\\Menu\\")
			_Path-Sym			(strcat PrmRootPath "Adds\\Sym\\")
			_Path-DLG			(strcat PrmRootPath "Quad\\")
			_Alt_Path-Panel	(strcat PrmRootPath "Shared Panels\\")
	)
	(cond
		((or (= Div "BH") (= Div "1"))
			(setq	_Path-Panel	"S:\\WORKGROUPS\\APC Birmingham Division\\DIVISION MAPPING\\ADDS\\Panel\\"
					Div			"BH"
			)
		)
		((or (= Div "E_") (= Div "2"))
			(setq	_Path-Panel	"S:\\WORKGROUPS\\APC Eastern Division\\DIVISION MAPPING\\ADDS\\Panel\\"
					Div			"E_"
			)
		)
		((or (= Div "M_") (= Div "5"))
			(setq	_Path-Panel	"S:\\WORKGROUPS\\APC Mobile Division\\DIVISION MAPPING\\ADDS\\Panel\\"
					Div			"M_"
			)
		)
		((or (= Div "S_") (= Div "3"))
			(setq	_Path-Panel	"S:\\WORKGROUPS\\APC Southern Division\\DIVISION MAPPING\\ADDS\\Panel\\"
					Div			"S_"
			)
		)
		((or (= Div "SE") (= Div "6"))
			(setq	_Path-Panel	"S:\\WORKGROUPS\\APC SouthEast Division\\DIVISION MAPPING\\ADDS\\Panel\\"
					Div			"SE"
			)
		)
		((or (= Div "W_") (= Div "4"))
			(setq	_Path-Panel	"S:\\WORKGROUPS\\APC Western Division\\DIVISION MAPPING\\ADDS\\Panel\\"
					Div			"W_"
			)
		)
		(T
			(setq	_Path-Panel	"S:\\WORKGROUPS\\APC Birmingham Division\\DIVISION MAPPING\\ADDS\\Panel\\"
					Div			"BH"
			)
		)
	)
	(setvar	"USERS3"	Div)
	(cond
		((= (getvar "ACADVER") "14.0")		;	AutoCAD r14 February 1997
			(setq	_Dos-Ver	"DosLib14"
					_Cad-Ver	"14.0"
					_Cad-Plat	"14.0"
					_Cad-Prod	"Map2"
					_SCS_Ver	"Acad_SCS"
					_SCS_Suf	"arx"
			)
			(princ	(strcat	"\n*Loading {" _Dos-Ver "} for [" _Cad-Prod " - " _Cad-Plat "]*\n"))
			(if (not (member (strcase "DosLib14.arx" T) (arx)))
				(if (findfile "doslib14.arx")
					(setq	Bubba	(arxload (findfile "doslib14.arx"))
							Failp	nil
					)
					(setq	Bubba	(princ	(strcat	"\n*Buttons Error*: "
													_Dos-Ver
													" Arx file not found on this system!"
											)
									)
							Failp	T
					)
				)
			)
			(if (not C:VerPrefs)
				(if (findfile (strcat _SCS_Ver "." _SCS_Suf))
					(if (= _SCS_Suf "arx")
						(setq	Bubba	(arxload (findfile (strcat _SCS_Ver "." _SCS_Suf)))
								Fail2p	nil
						)
						(setq	Bubba	(load (findfile (strcat _SCS_Ver "." _SCS_Suf)))
								Fail2p	nil
						)
					)
					(if (findfile (strcat TestPrmRootPath "Common\\" _SCS_Ver "." _SCS_Suf))
						(if (= _SCS_Suf "arx")
							(setq	Bubba	(arxload (findfile (strcat TestPrmRootPath "Common\\" _SCS_Ver "." _SCS_Suf)))
									Fail2p	nil
							)
							(setq	Bubba	(load (findfile (strcat TestPrmRootPath "Common\\" _SCS_Ver "." _SCS_Suf)))
									Fail2p	nil
							)
						)
						(setq	Bubba	(princ	(strcat	"\n*Buttons Error*: "
														_SCS_Ver " " _SCS_Suf
														" file not found on this system!"
												)
										)
								Fail2p	T
						)
					)
				)
			)
		)
		((= (substr (getvar "ACADVER") 1 4) "17.0")	;	AutoCAD 2007
			(setq	_Dos-Ver	"DosLib17"
					_Dos-Suf	"Arx"
					_Cad-Ver	"17.0"
					_Cad-Plat	"2007"
					_Cad-Prod	"Map2007"
					_SCS_Ver	"Acad_SCS_2007"
					_SCS_Suf	"Vlx"
					_SCSBVer	"Acad_SCS"
					_SCSBSuf	"DLL"
			)
			(princ	(strcat	"\n*Loading {" _Dos-Ver "} for [" _Cad-Prod " - AutoCad " _Cad-Ver "]*\n"))
			(if (not (vl-file-directory-p "C:\\Div_Map"))
				(vl-mkdir "C:\\Div_Map")
			)
			(if (not (vl-file-directory-p "C:\\Div_Map\\DosLib"))
				(vl-mkdir "C:\\Div_Map\\DosLib")
			)
			(if (not (member (strcase (strcat _Dos-Ver "." _Dos-Suf) T) (arx)))
				(if (findfile (strcat _Dos-Ver "." _Dos-Suf))
					(setq	Bubba	(FilUpDatR (strcat PrmRootPath "DosLib\\") "C:\\Div_Map\\DosLib\\" (strcat _Dos-Ver "." _Dos-Suf))
							Failp	nil
					)
					(setq	Bubba	(princ	(strcat	"\n*" AppNam " Error*: "
													_Dos-Ver " " _Dos-Suf
													" file not found on this system!"
											)
									)
							Failp	T
					)
				)
			)
			(if (findfile (strcat "C:\\WINDOWS\\system32\\" _SCSBVer "." _SCSBSuf))
				(vl-file-delete (strcat "C:\\WINDOWS\\system32\\" _SCSBVer "." _SCSBSuf))
			)
			(if (not (vl-file-directory-p "C:\\Div_Map"))
				(progn
					(vl-mkdir "C:\\Div_Map")
					(vl-mkdir "C:\\Div_Map\\Common")
				)
			)
			(setq	Fail3p	(FilUpDatR (strcat PrmRootPath "Common\\") "C:\\Div_Map\\Common\\"  (strcat _SCSBVer "." _SCSBSuf)))
			(princ	(strcat	"\n*Loading {" _SCS_Ver "} for [" _Cad-Prod " - AutoCad " _Cad-Ver "] from Acad.Lsp*\n"))
			(if (not C:VerPrefs)
				(if (findfile (strcat _SCS_Ver "." _SCS_Suf))
					(if (= (strcase _SCS_Suf T) "arx")
;						(setq	Bubba	(arxload (findfile (strcat _SCS_Ver "." _SCS_Suf)))
						(setq	Bubba	(FilUpDatR (strcat PrmRootPath "Common\\") "C:\\Div_Map\\Common\\" (strcat _SCS_Ver "." _SCS_Suf))
								Fail2p	nil
						)
						(setq	Bubba	(load (findfile (strcat _SCS_Ver "." _SCS_Suf)))
								Fail2p	nil
						)
					)
					(setq	Bubba	(princ	(strcat	"\n*" AppNam " Error*: "
													_SCS_Ver " " _SCS_Suf
													" file not found on this system!"
											)
									)
							Fail2p	T
					)
				)
			)
		)
		(T
			(setq	_Dos-Ver	"DosLib??"
					_Cad-Ver	"???"
					_Cad-Plat	"???"
					_Cad-Prod	"???"
					Failp	T
					_SCS_Ver	"Acad_SCS"
					Fail2p	T
			)
			(princ "\n*Unrecognized version of AutoCad - No DosLib load attempted*\n")
		)
	)
	(if Failp
		(progn
			(alert (strcat "***Failure Loading {" _Dos-Ver "} - program exitting***"))
			(exit)
		)
	)
	(if Fail2p
		(progn
			(alert (strcat "***Failure Loading {" _SCS_Ver "." _SCS_Suf "} - program exitting***"))
			(exit)
		)
	)
	(if Fail3p
		(progn
			(alert (strcat "***Failure Loading {" _SCSBVer "." _SCSBSuf "} - program exitting***"))
			(exit)
		)
	)
	(if (and DevLev LodVer)
		(setq	LodLst	(list (list "Adds30" DevLev LodVer)))
	)
	(setq	AppMode		"E"
			LodVer		"3.0.0"
			_DEFAULT-DIV	"PWR_DEL"						;PWR_DEL
			project		"UTM27M"
			XPanel		6000.0
			YPanel		4000.0
	)
	(setq	Whuf		"Acad_ADO"
			LodLev	4
			LodVer	(load (strcat (strcat PrmRootPath "Common\\") Whuf ".Lsp"))
			LodGet	(list Whuf LodLev LodVer)
			LodLst	(cons LodGet LodLst)
	)
	(setq	Whuf		"Att_Chg"
			LodLev	4
			LodVer	(load (strcat (strcat PrmRootPath "Common\\") Whuf ".Lsp"))
			LodGet	(list Whuf LodLev LodVer)
			LodLst	(cons LodGet LodLst)
	)
	(setq	Whuf		"DLGLod"
			LodLev	4
			LodVer	(load (strcat (strcat PrmRootPath "Common\\") Whuf ".Lsp"))
			LodGet	(list Whuf LodLev LodVer)
			LodLst	(cons LodGet LodLst)
	)
	(setq	Whuf		"Get_Init"
			LodLev	4
			LodVer	(load (strcat (strcat PrmRootPath "Common\\") Whuf ".Lsp"))
			LodGet	(list Whuf LodLev LodVer)
			LodLst	(cons LodGet LodLst)
	)
	(setq	Whuf		"GetPoints"
			LodLev	4
			LodVer	(load (strcat (strcat PrmRootPath "Common\\") Whuf ".Lsp"))
			LodGet	(list Whuf LodLev LodVer)
			LodLst	(cons LodGet LodLst)
	)
	(setq	Whuf		"Julian"
			LodLev	4
			LodVer	(load (strcat (strcat PrmRootPath "Common\\") Whuf ".Lsp"))
			LodGet	(list Whuf LodLev LodVer)
			LodLst	(cons LodGet LodLst)
	)
	(setq	Whuf		"OracleFun"
			LodLev	4
			LodVer	(load (strcat (strcat PrmRootPath "Common\\") Whuf ".Lsp"))
			LodGet	(list Whuf LodLev LodVer)
			LodLst	(cons LodGet LodLst)
	)
	(setq	Whuf		"Property"
			LodLev	4
			LodVer	(load (strcat (strcat PrmRootPath "Common\\") Whuf ".Lsp"))
			LodGet	(list Whuf LodLev LodVer)
			LodLst	(cons LodGet LodLst)
	)
	(setq	Whuf		"Switch"
			LodLev	4
			LodVer	(load (strcat (strcat PrmRootPath "Common\\") Whuf ".Lsp"))
			LodGet	(list Whuf LodLev LodVer)
			LodLst	(cons LodGet LodLst)
	)
	(setq	Whuf		"Symbols"
			LodLev	4
			LodVer	(load (strcat (strcat PrmRootPath "Common\\") Whuf ".Lsp"))
			LodGet	(list Whuf LodLev LodVer)
			LodLst	(cons LodGet LodLst)
	)
	(setq	Whuf		"Tables"
			LodLev	4
			LodVer	(load (strcat (strcat PrmRootPath "Common\\") Whuf ".Lsp"))
			LodGet	(list Whuf LodLev LodVer)
			LodLst	(cons LodGet LodLst)
	)
	(setq	Whuf		"Utils"
			LodLev	4
			LodVer	(load (strcat (strcat PrmRootPath "Common\\") Whuf ".Lsp"))
			LodGet	(list Whuf LodLev LodVer)
			LodLst	(cons LodGet LodLst)
	)
	(setq	Whuf		"Adds"
			LodLev	5
			LodVer	(load (strcat (strcat PrmRootPath "Adds\\Lisp\\") Whuf ".Lsp"))
			LodGet	(list Whuf LodLev LodVer)
			LodLst	(cons LodGet LodLst)
	)
	(setq	Whuf		"Commands"
			LodLev	5
			LodVer	(load (strcat (strcat PrmRootPath "Adds\\Lisp\\") Whuf ".Lsp"))
			LodGet	(list Whuf LodLev LodVer)
			LodLst	(cons LodGet LodLst)
	)
	(setq	Whuf		"Common"
			LodLev	5
			LodVer	(load (strcat (strcat PrmRootPath "Adds\\Lisp\\") Whuf ".Lsp"))
			LodGet	(list Whuf LodLev LodVer)
			LodLst	(cons LodGet LodLst)
	)
	(setq	Whuf		"EditSym"
			LodLev	5
			LodVer	(load (strcat (strcat PrmRootPath "Adds\\Lisp\\") Whuf ".Lsp"))
			LodGet	(list Whuf LodLev LodVer)
			LodLst	(cons LodGet LodLst)
	)
	(setq	Whuf		"Fnct1"
			LodLev	5
			LodVer	(load (strcat (strcat PrmRootPath "Adds\\Lisp\\") Whuf ".Lsp"))
			LodGet	(list Whuf LodLev LodVer)
			LodLst	(cons LodGet LodLst)
	)
	(setq	Whuf		"Layers"
			LodLev	5
			LodVer	(load (strcat (strcat PrmRootPath "Adds\\Lisp\\") Whuf ".Lsp"))
			LodGet	(list Whuf LodLev LodVer)
			LodLst	(cons LodGet LodLst)
	)
	(setq	Whuf		"Panel"
			LodLev	5
			LodVer	(load (strcat (strcat PrmRootPath "Adds\\Lisp\\") Whuf ".Lsp"))
			LodGet	(list Whuf LodLev LodVer)
			LodLst	(cons LodGet LodLst)
	)
	(TABLES)
	(if (AND (/= Div "AL") (/= Div "GA"))
		(progn
			(DivGetUnix Div)
			(SubLoad)
			(QuadLoad)
		)
	)
	
	
	(c:DoSplash)
	(cond
		((= (strcase (substr AppNam 1 5)) "ADDS ")
			(if (null DRAGATT)
				(toggle "DRAGATT")
			)
		)
	)
	(setq	Amode	"STARTUP")
	(if Lst_Vld_MPG
		(if (assoc (strcase (getvar "LOGINNAME")) Lst_Vld_MPG)
			(setq	Vld_MPG	(assoc (strcase (getvar "LOGINNAME")) Lst_Vld_MPG))
			(setq	Vld_MPG	nil)
		)
		(setq	Vld_MPG	nil)
	)
	(if (not Vld_MPG)
		(progn
			(alert (strcat "*** " AppNam " Operator Error ***\n*Not* an Authorized MPG Poster: {" (strcase (getvar "LOGINNAME")) "}"))
			(command "_.Quit" "Y")
		)
	)
	(command)
	(setq	olderr	*error*
			*error*	S:err
	)
	(princ	(strcat	"\nStarting " AppNam " Now..."))
	(if (and MyLoginObj (not MyUsrInfo))
		(AppndLognDat)
	)
	(if (and MyLoginObj (not MyUsrInfo))
		(setq	MyUsrInfo		(MyLoginObj AppDbNam))
	)
	(if MyUsrInfo
		(if (= (car MyUsrInfo) 1)
			(princ (strcat "\nLogged into {" (nth 1 MyUsrInfo) "} as {" (nth 2 MyUsrInfo) "} with role {" (nth 4 MyUsrInfo) "}"))
			(progn
				(alert (strcat "*** " AppNam " Login Error ***\n*Not* an Authorized Oracle Login: {" (strcase (getvar "LOGINNAME")) "} to instance [" (cadr MyUsrInfo) "]"))
				(command "_.Quit" "Y")
			)
		)
		
	)
	(princ)
)

(defun C:ShwPld ( /	y )					; CL - Generates PldDatLst and Views AddsPlot Variables from within AddsPlot
	(setq	LodNam	"Utils"
			LodBub	(load (strcat PrmRootPath "Common\\Utils.lsp"))
			LodLev	0
			LodBub	(list LodNam LodLev LodVer)
	)
	(if (and LodBub LodLst)
		(setq	LodLst	(UpdLodLst LodBub LodLst))
	)
	(if PldName
		(setq	PldDatLst		nil
				PldDatLst		(list (cons "PldName" PldName))
				PldDatLst		(if (and Grp1 (> (strlen Grp1) 1))					(cons (cons "Group1" Grp1) PldDatLst) (cons (cons "Group1" "None") PldDatLst))
				PldDatLst		(if (and Grp2 (> (strlen Grp2) 1))					(cons (cons "Group2" Grp2) PldDatLst) (cons (cons "Group2" "None") PldDatLst))
				PldDatLst		(if (and Cust1 (> (strlen Cust1) 1))				(cons (cons "Custom1" Cust1) PldDatLst) (cons (cons "Custom1" "None") PldDatLst))
				PldDatLst		(if (and Cust2 (> (strlen Cust2) 1))				(cons (cons "Custom2" Cust2) PldDatLst) (cons (cons "Custom2" "None") PldDatLst))
				PldDatLst		(if (and Cordfile (> (strlen Cordfile) 1))			(cons (cons "CordFile" Cordfile) PldDatLst) (cons (cons "CordFile" "None") PldDatLst))
;;;				PldDatLst		(if (and Cordkey (> (length Cordkey) 0))			(cons (cons "CordKey(s)" (apply (quote strcat) (mapcar (quote (lambda (x) (strcat "[" x "] "))) Cordkey))) PldDatLst) (cons (cons "CordKey(s)" "None") PldDatLst))
				PldDatLst		(if Cordkey
								(if (= (type cordkey) (quote LIST))
									(if (and (> (length Cordkey) 0) (/= (car Cordkey) ""))
										(cons (cons "CordKey(s)" (apply (quote strcat) (mapcar (quote (lambda (x) (strcat "[" x "] "))) Cordkey))) PldDatLst)
										(cons (cons "CordKey(s)" "None") PldDatLst)
									)
									(if (= (type cordkey) (quote STR))
										(if (/= Cordkey " ")
											(cons (cons "CordKey(s)" (strcat "[" Cordkey "] ")) PldDatLst)
											(cons (cons "CordKey(s)" "None") PldDatLst)
										)
									)
								)
								(cons (cons "CordKey(s)" "None") PldDatLst)
							)
				PldDatLst		(if (and UlX (not (zerop UlX)) UlY (not (zerop UlY)))	(cons (cons "Lower-Left Point" (strcat (rtos UlX 2 0) "," (rtos UlY 2 0))) PldDatLst) (cons (cons "Lower-Left Point" "0,0") PldDatLst))
				PldDatLst		(if (and UuX (not (zerop UuX)) UuY (not (zerop UuY)))	(cons (cons "Upper-Right Point" (strcat (rtos UuX 2 0) "," (rtos UuY 2 0))) PldDatLst) (cons (cons "Upper-Right Point" "0,0") PldDatLst))
				PldDatLst		(if (and Usrbuf (not (zerop Usrbuf)))				(cons (cons "Buffer" (rtos Usrbuf 2 2)) PldDatLst) (cons (cons "Buffer" "0") PldDatLst))
				PldDatLst		(if (and Sht (> (strlen Sht) 0))					(cons (cons "Sheet" Sht) PldDatLst) (cons (cons "Sheet" "None") PldDatLst))
				PldDatLst		(if (and Pltsc (not (zerop Pltsc)))				(cons (cons "Plot Scale" (rtos Pltsc 2 1)) PldDatLst) (cons (cons "Plot Scale" "0") PldDatLst))
				PldDatLst		(if (and Symsc (not (zerop Symsc)))				(cons (cons "Symbol Scale" (rtos Symsc 2 1)) PldDatLst) (cons (cons "Symbol Scale" "0") PldDatLst))
				PldDatLst		(if (and Txtsc (not (zerop Txtsc)))				(cons (cons "Text Scale" (rtos Txtsc 2 1)) PldDatLst) (cons (cons "Text Scale" "0") PldDatLst))
				PldDatLst		(if (and Vlt (> (strlen Vlt) 0))					(cons (cons "Volt" Vlt) PldDatLst) (cons (cons "Volt" "None") PldDatLst))
				PldDatLst		(if (and Job_nam (> (strlen Job_nam) 0))			(cons (cons "Job Name" Job_nam) PldDatLst) (cons (cons "Job Name" "None") PldDatLst))
				PldDatLst		(if (and Det1 (> (strlen Det1) 0))					(cons (cons "Detail" Det1) PldDatLst) (cons (cons "Detail" "None") PldDatLst))
				PldDatLst		(if (and Desc_1 (> (strlen Desc_1) 0))				(cons (cons "Description" Desc_1) PldDatLst) (cons (cons "Description" "None") PldDatLst))
				PldDatLst		(if (and DefinedBy (> (strlen DefinedBy) 0))			(cons (cons "Defined By" DefinedBy) PldDatLst) (cons (cons "Defined By" "None") PldDatLst))
				PldDatLst		(if (and DateDefine (> (strlen DateDefine) 0))		(cons (cons "Defined On" DateDefine) PldDatLst) (cons (cons "Defined On" "None") PldDatLst))
				PldDatLst		(if (and Dwg_num (> (strlen Dwg_num) 0))			(cons (cons "Dwg Number" Dwg_num) PldDatLst) (cons (cons "Dwg Number" "None") PldDatLst))
				PldDatLst		(if (and Sht_num (> (strlen Sht_num) 0))			(cons (cons "Sheet Number" Sht_num) PldDatLst) (cons (cons "Sheet Number" "None") PldDatLst))
				PldDatLst		(if (and Num_shts (> (strlen Num_shts) 0))			(cons (cons "Number of Sheets" Num_shts) PldDatLst) (cons (cons "Number of Sheets" "None") PldDatLst))
				PldDatLst		(if (and Lt_mtch_to (> (strlen Lt_mtch_to) 0))		(cons (cons "Left Match To" Lt_mtch_to) PldDatLst) (cons (cons "Left Match To" "None") PldDatLst))
				PldDatLst		(if (and Tp_mtch_to (> (strlen Tp_mtch_to) 0))		(cons (cons "Top Match To" Tp_mtch_to) PldDatLst) (cons (cons "Top Match To" "None") PldDatLst))
				PldDatLst		(if (and Rt_mtch_to (> (strlen Rt_mtch_to) 0))		(cons (cons "Right Match To" Rt_mtch_to) PldDatLst) (cons (cons "Right Match To" "None") PldDatLst))
				PldDatLst		(if (and Bt_mtch_to (> (strlen Bt_mtch_to) 0))		(cons (cons "Bottom Match To" Bt_mtch_to) PldDatLst) (cons (cons "Bottom Match To" "None") PldDatLst))
				PldDatLst		(reverse PldDatLst)
		)
		(setq	PldDatLst		nil)
	)
	(if (and PldDatLst PadCharR)
		(mapcar (quote (lambda (y) (princ (strcat "\n" (PadCharR (car y) 18) (cdr y))))) PldDatLst)
	)
	(princ)
)

(defun C:URDPgon ( /	Pt1 PtLst NtLst Whaf	; Writes URD Polygon Boundary files
					Ent1 Ent2 sPlyNam E1 E2 MyFdr MyPos MyBrk Bubba )
	(setq	Whaf		(getfiled	"Polygon Boundary File"
							"c:/Data/"
							"csv"
							1
					)
	)
	(if Whaf
		(princ (strcat "\nURD Polygon Boundary File: {" Whaf "}"))
	)
	(if Whaf
		(setq	Ent1		(entsel "\nSelect UnderGround Location Symbol: "))
	)
	(if Ent1
		(setq	E1		(entget (car Ent1) (list "*"))
				E1Ed		(cdadr (assoc "ID" (cdr (assoc -3 E1))))
				Bubba	(redraw (car Ent1) 3)
		)
	)
	(if (not E1Ed)
		(setq	E1Ed		"Bogus")
	)
	(if Ent1
		(if (= (strcase (cdr (assoc 2 E1))) "A081")
			(if (assoc 66 E1)
				(if (= (cdr (assoc 66 E1)) 1)
					(while (/= (cdr (assoc 0 (setq E1 (entget (entnext (cdr (assoc -1 E1))) (list "*"))))) "SEQEND")
						(if (= (cdr (assoc 2 E1)) "LOC_NUM")
							(setq	Loc_Num	(cdr (assoc 1 E1))
									Bubba	(princ (strcat "\nURD Loc_Num: {" Loc_Num "}"))
							)
						)
						(if (= (cdr (assoc 2 E1)) "DESCRIPT")
							(setq	sPlyNam	(cdr (assoc 1 E1))
									Bubba	(princ (strcat "\nUnderGround Location Description: {" sPlyNam "}"))
							)
						)
					)
					(setq	Ent1		nil)
				)
				(setq	Ent1		nil)
			)
			(setq	Ent1		nil)
		)
	)
	(if (not sPlyNam)
		(setq	sPlyNam	(getstring T "\nEnter UnderGround Location Description: ")
				Bubba	(princ (strcat "\nUnderGround Location Description: {" sPlyNam "}"))
		)
	)
	(if Ent1
		(setq	Ent2		(entsel "\nSelect Related Switch Symbol: "))
	)
	(if Ent2
		(setq	E2		(entget (car Ent2) (list "*"))
				E2Ed		(cdadr (assoc "ID" (cdr (assoc -3 E2))))
				Bubba	(redraw (car Ent2) 3)
		)
	)
	(if (not E2Ed)
		(setq	E2Ed		"Bogus")
	)
	(if Ent2
		(if (assoc 66 E2)
			(if (= (cdr (assoc 66 E2)) 1)
				(while (/= (cdr (assoc 0 (setq E2 (entget (entnext (cdr (assoc -1 E2))) (list "*"))))) "SEQEND")
					(if (= (cdr (assoc 2 E2)) "LOC_NUM")
						(setq	OperPt_Num	(cdr (assoc 1 E2))
								Bubba		(princ (strcat "\nSwitch OperPt_Num: {" OperPt_Num "}"))
						)
					)
				)
			)
		)
	)
	(if Ent2
		(setq	MyFdr	(substr (cdr (assoc 8 (entget (car Ent2)))) 1 3))
	)
	(if MyFdr
		(if (member MyFdr Lst_Fd_V)
			(setq	MyPos	(- (length Lst_Fd_V) (length (member MyFdr Lst_Fd_V)))
					MyBrk	(nth MyPos Lst_Fd_B)
					Bubba	(princ (strcat "\nFeeder Breaker: {" MyBrk "}"))
			)
		)
	)
	(if MyPos
		(setq	Pt1	(getpoint "\nSelect Starting Point: "))
	)
	(if Pt1
		(setq	PtLst	(list Pt1))
	)
	(if PtLst
		(while (setq	Pt1	(getpoint Pt1 "\nSelect Next Point: "))
			(if Pt1
				(setq	PtLst	(cons Pt1 PtLst)
						Bubba	(grdraw (nth 0 PtLst) (nth 1 PtLst) -1 1)
				)
			)
		)
	)
	(if PtLst
		(setq	Pt1		(last PtLst)
				PtLst	(cons Pt1 PtLst)
				Bubba	(grdraw (nth 0 PtLst) (nth 1 PtLst) -1 1)
		)
	)
	(if PtLst
		(princ "\nPoints in UTM27-16:")
	)
	(if PtLst
		(mapcar (quote (lambda (x) (princ (strcat "\n" (rtos (car x) 2 0) "," (rtos (cadr x) 2 0))))) PtLst)
	)
	(princ "")
	(if PtLst
		(setq	NtLst	(mapcar (quote (lambda (x) (transcord "UTM27-16" "UTM83-16F" x))) PtLst))
	)
	(princ "")
	(if NtLst
		(princ "\nPoints in UTM83-16F:")
	)
	(if NtLst
		(mapcar (quote (lambda (x) (princ (strcat "\n" (rtos (car x) 2 0) "," (rtos (cadr x) 2 0))))) NtLst)
	)
	(if NtLst
		(progn
			(setq	FileN	(open Whaf "w"))
			(write-line	(strcat	"\"Subdivision Description\","
								"\"LocNum\","
								"\"Loc_ID\","
								"\"Easting\","
								"\"Northing\","
								"\"Switch\","
								"\"Switch_ID\","
								"\"FeederID\""
						)
						FileN
			)
			(write-line	(strcat	"\""	sPlyNam	"\","
								"\""	Loc_Num	"\","
								"\""	E1Ed	"\","
								"\""	(rtos (caar NtLst) 2 0)	"\","
								"\""	(rtos (cadar NtLst) 2 0)	"\","
								"\""	OperPt_Num	"\","
								"\""	E2Ed	"\","
								"\""	MyBrk	"\""
						)
						FileN
			)
			(mapcar (quote (lambda (x) (write-line (strcat "\"\",\"\",\"\",\"" (rtos (car x) 2 0) "\",\"" (rtos (cadr x) 2 0) "\",\"\",\"\",\"\"") FileN))) (cdr NtLst))
			(close FileN)
		)
	)
	(if Ent1
		(redraw (car Ent1) 4)
	)
	(if Ent2
		(redraw (car Ent2) 4)
	)
	;(command "_.Redraw")
	(princ)
)

(defun C:ShwPth ( / )						; Path Status indicator
	(if _Path-Person
		(princ (strcat "\n********************\nPath-Person\n" _Path-Person))
		(princ "\n********************\nPath-Person\nNot Found")
	)
	(if _Path-DIV
		(princ (strcat "\n********************\nPath-DIV\n" _Path-DIV))
		(princ "\n********************\nPath-DIV\nNot Found")
	)
	(if _Path-DLG
		(princ (strcat "\n********************\nPath-DLG\n" _Path-DLG))
		(princ "\n********************\nPath-DLG\nNot Found")
	)
	(if _Path-DWF
		(princ (strcat "\n********************\nPath-DWF\n" _Path-DWF))
		(princ "\n********************\nPath-DWF\nNot Found")
	)
	(if _Path-DWG
		(princ (strcat "\n********************\nPath-Dwg\n" _Path-Dwg))
		(princ "\n********************\nPath-Dwg\nNot Found")
	)
	(if _Path-Lisp
		(princ (strcat "\n********************\nPath-Lisp\n" _Path-Lisp))
		(princ "\n********************\nPath-Lisp\nNot Found")
	)
	(if _Path-LUT
		(princ (strcat "\n********************\nPath-LUT\n" _Path-LUT))
		(princ "\n********************\nPath-LUT\nNot Found")
	)
	(if _Path-Menu
		(princ (strcat "\n********************\nPath-Menu\n" _Path-Menu))
		(princ "\n********************\nPath-Menu\nNot Found")
	)
	(if _Path-Plot
		(princ (strcat "\n********************\nPath-Plot\n" _Path-Plot))
		(princ "\n********************\nPath-Plot\nNot Found")
	)
	(if _Path-Quad
		(princ (strcat "\n********************\nPath-Quad\n" _Path-Quad))
		(princ "\n********************\nPath-Quad\nNot Found")
	)
	(if _Path-Sym
		(princ (strcat "\n********************\nPath-Sym\n" _Path-Sym))
		(princ "\n********************\nPath-Sym\nNot Found")
	)
	(if _Path-User
		(princ (strcat "\n********************\nPath-User\n" _Path-User))
		(princ "\n********************\nPath-User\nNot Found")
	)
	(if _Path-Wav
		(princ (strcat "\n********************\nPath-Wav\n" _Path-Wav))
		(princ "\n********************\nPath-Wav\nNot Found")
	)
	(if _Path-Panel
		(princ (strcat "\n********************\nPath-Panel\n" _Path-Panel))
		(princ "\n********************\nPath-Panel\nNot Found")
	)
	(if _Alt_Path-Panel
		(princ (strcat "\n********************\nAlt_Path-Panel\n" _Alt_Path-Panel))
		(princ "\n********************\nAlt_Path-Panel\nNot Found")
	)
	(if (= (StpDot AppNam) "ADDS")
		(progn
			(if _M_Path-Panel
				(princ (strcat "\n********************\nM_Path-Panel\n" _M_Path-Panel))
				(princ "\n********************\nM_Path-Panel\nNot Found")
			)
		;	(if _M_AltP-Panel
		;		(princ (strcat "\n********************\nM_AltP-Panel\n" _M_AltP-Panel))
		;		(princ "\n********************\nM_AltP-Panel\nNot Found")
		;	)
			(princ (strcat "\n********************\nM_AltP-Panel\n" 
					(if (or (not _M_AltP-Panel) (= _M_AltP-Panel ""))
						"Not Found"
						_M_AltP-Panel
					)
				 )
			)
			(if _M_AltS-Panel
				(princ (strcat "\n********************\nM_AltS-Panel\n" _M_AltS-Panel))
				(princ "\n********************\nM_AltS-Panel\nNot Found")
			)
			(if _N_Path-Panel
				(princ (strcat "\n********************\nN_Path-Panel\n" _N_Path-Panel))
				(princ "\n********************\nN_Path-Panel\nNot Found")
			)
			(if _N_AltP-Panel
				(princ (strcat "\n********************\nN_AltP-Panel\n" _N_AltP-Panel))
				(princ "\n********************\nN_AltP-Panel\nNot Found")
			)
			(if _N_AltS-Panel
				(princ (strcat "\n********************\nN_AltS-Panel\n" _N_AltS-Panel))
				(princ "\n********************\nN_AltS-Panel\nNot Found")
			)
			(if _AltSPath-Panel
				(princ (strcat "\n********************\nAltSPath-Panel\n" _AltSPath-Panel))
				(princ "\n********************\nAltSPath-Panel\nNot Found")
			)
		)
	)
	(princ)
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
				"CADET"
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

(defun C:ShwLod ( /	LodSrt MinLev LodNam )	; Displays internal versioning of modules
	(if LodLst
		(princ	(strcat	"\n"
						(PadCharR "Module Name" 15)
						(PadCharR "Level" 6)
						(PadCharL "Version" 8)
				)
		)
	)
	(if LodLst
		(princ	(strcat	"\n" (RepChar "=" 28)))
	)
	(if LodLst
		(setq	LodSrt	(acad_strlsort (mapcar (quote car) LodLst))
				MinLev	99
		)
	)
	(if (and LodLst LodSrt)
		(foreach	LodNam
				LodSrt
				(if (< (nth 1 (assoc LodNam LodLst)) MinLev)
					(setq	MinLev	(nth 1 (assoc LodNam LodLst)))
				)
				(princ	(strcat	"\n"
								(PadCharR (nth 0 (assoc LodNam LodLst)) 15)
								(PadCharR (itoa (nth 1 (assoc LodNam LodLst))) 8)
								(PadCharR (nth 2 (assoc LodNam LodLst)) 8)
						)
				)
		)
	)
	(if (and MinLev DevLev)
		(if (< MinLev DevLev)
			(cond
				((= MinLev 0)
					(setvar "USERS5" " {*Test-MyDevC*}")
					(setq	DevLev	LodLev)
				)
				((= MinLev 1)
					(setvar "USERS5" " {*Test-MyDevC*}")
					(setq	DevLev	LodLev)
				)
				((= MinLev 2)
					(setvar "USERS5" " {*Test-MyDevH*}")
					(setq	DevLev	LodLev)
				)
				((= MinLev 3)
					(setvar "USERS5" " {*Test-MyDevH*}")
					(setq	DevLev	LodLev)
				)
				((= MinLev 4)
					(setvar "USERS5" " {*Test-DevRC*}")
					(setq	DevLev	LodLev)
				)
				((= MinLev 5)
					(setvar "USERS5" " {*Test-DevRC*}")
					(setq	DevLev	LodLev)
				)
				((= MinLev 6)
					(setvar "USERS5" " {*Test-DevGold*}")
					(setq	DevLev	LodLev)
				)
				((= MinLev 7)
					(setvar "USERS5" " {*Test-DevGold*}")
					(setq	DevLev	LodLev)
				)
			)
		)
	)
	(if (and (not DevMark) (> MinLev 6))
		(princ "\nProduction Level Code!")
		(if (and DevLev (> (strlen (getvar "USERS5")) 1))
			(princ (strcat "\n\nMinimum Development Level=" (itoa DevLev) " which is" (getvar "USERS5")))
			(princ "\nUnKnown Development Level")
		)
	)
	(princ)
)

(defun FixCols ( /	ssE Cnt Bubba EdsFil e1 e2	; Fix Colors
				e3 e4 F1 )
	(command "PURGE" "A" "*" "N")
	(setq	ssE		(ssget "X")
			Cnt		0
			Bubba	nil
			EdsFil	"c:\\data\\edsfiles\\colorup.txt"
	)
	(if ssE
		(progn
			(while (< Cnt (sslength ssE))
				(setq	e1	(ssname ssE Cnt)
						e2	(entget e1 (quote ("*")))
						e3	(cdr (assoc 8 e2))
						e4	(assoc 62 e2)
				)
				(if e4
					(if	(and	(/= (cdr e4) 0)
							(/= (cdr e4) 255)
							(/= (cdr e4) 250)
						)
						(cond	((= (strcase e3) "MASK")
									(if	(or	(= (cdr e4) 7)
											(= (cdr e4) 3)
										)
										(setq	F1		(open EdsFil "a")
												Bubba	(strcat	"Entity "
																(cdr	(assoc 0 e2))
																" with color "
																(itoa (cdr e4))
																" in dwg "
																(getvar "DWGNAME")
														)
												Bubba	(write-line Bubba F1)
												Bubba	(close F1)
										)
									)
									(setq	e2	(subst	(cons 62 250)
														(assoc 62 e2)
														e2
												)
									)
									(entmod e2)
								)
								((= (cdr (assoc 0 e2)) "ATTDEF")
									(if	(or	(= (cdr e4) 7)
											(= (cdr e4) 3)
										)
										(setq	F1		(open EdsFil "a")
												Bubba	(strcat	"Entity "
																(cdr	(assoc 0 e2))
																" with color "
																(itoa (cdr e4))
																" in dwg "
																(getvar "DWGNAME")
														)
												Bubba	(write-line Bubba F1)
												Bubba	(close F1)
										)
									)
									(setq	e2	(subst	(cons 62 255)
														(assoc 62 e2)
														e2
												)
									)
									(entmod e2)
								)
								((= (cdr e4) 3)
									(setq	F1		(open EdsFil "a")
											Bubba	(strcat	"Entity "
															(cdr (assoc 0 e2))
															" with color "
															(itoa (cdr e4))
															" in dwg "
															(getvar "DWGNAME")
													)
											Bubba	(write-line Bubba F1)
											Bubba	(close F1)
									)
								)
								(T
									(setq	e2	(subst	(cons 62 0)
														(assoc 62 e2)
														e2
												)
									)
									(entmod e2)
								)
						)
					)
					(cond	((= (strcase e3) "MASK")
								(setq	F1		(open EdsFil "a")
										Bubba	(strcat	"Entity "
														(cdr (assoc 0 e2))
														" with color Bylayer in dwg "
														(getvar "DWGNAME")
												)
										Bubba	(write-line Bubba F1)
										Bubba	(close F1)
										e2		(append e2 (list (cons 62 0)))
								)
								(entmod e2)
								(setq	e2	(subst	(cons 62 250)
													(assoc 62 e2)
													e2
											)
								)
								(entmod e2)
							)
							((= (cdr (assoc 0 e2)) "ATTDEF")
								(setq	F1		(open EdsFil "a")
										Bubba	(strcat	"Entity "
														 (cdr (assoc 0 e2))
														 " with color Bylayer in dwg "
														 (getvar "DWGNAME")
												)
										Bubba	(write-line Bubba F1)
										Bubba	(close F1)
										e2		(append e2 (list (cons 62 0)))
								)
								(entmod e2)
								(setq	e2	(subst	(cons 62 255)
													(assoc 62 e2)
													e2
											)
								)
								(entmod e2)
							)
							(T
								(setq	F1		(open EdsFil "a")
										Bubba	(strcat	"Entity "
														 (cdr (assoc 0 e2))
														 " with color Bylayer in dwg "
														 (getvar "DWGNAME")
												)
									      Bubba	(write-line Bubba F1)
									      Bubba	(close F1)
									      e2		(append e2 (list (cons 62 0)))
								)
								(entmod e2)
								(setq	e2	(subst	(cons 62 0)
													(assoc 62 e2)
													e2
											)
								)
								(entmod e2)
							)
					)
				)
				(setq	Cnt	(1+ Cnt))
			)
			(RevOrd)
			(if (= (getvar "USERI5") 0)
				(setvar "USERI5" 1)
				(setvar "USERI5" 0)
			)
		)
	)
	;	Cleanup
	(if ssE	(setq ssE nil))
	(gc)

	(princ)
)

(defun FixAttCol ( et1 /	e1 e2 )			; Fixes Damaged Attribute Colors
	(setq e1 (entnext et1))
	(while e1
		(if (/= (cdr (assoc 0 (setq e2 (entget e1 (list "*"))))) "SEQEND")
			(if (assoc 62 e2)
				(if (= (cdr (assoc 62 e2)) 255)
					(progn
						(setq e2 (subst (cons 62 7) (assoc 62 e2) e2))
						(entmod e2)
						(if Bug (princ "\nFound One!"))
						(setq e1 (entnext e1))
					)
					(setq e1 (entnext e1))
				)
				(setq e1 (entnext e1))
			)
			(setq e1 nil)
		)
	)
	(entupd et1)
	(princ)
)

(defun C:FixAttCol ( /	ssE Cnt e1			; Fix Damaged Attribute Colors - CL
					LayNam LayGrp )
	(setq	LayNam	(tblnext "LAYER" T)
			LayLst	nil
	)
	(while (setq LayNam (tblnext "LAYER"))
		(if LayNam
			(if (= 255 (cdr (assoc 62 LayNam)))
				(setq	LayGrp	(cons	(cdr (assoc 2 LayNam))
										(cdr (assoc 62 LayNam))
								)
				)
				(setq	LayGrp	nil)
			)
		)
		(if LayGrp
			(if LayLst
				(setq	LayLst	(cons LayGrp LayLst))
				(setq	LayLst	(list LayGrp))
			)
		)
	)
	(if LayLst
		(foreach	LayN
				LayLst
				(setq	LayDo	(list "C" "7" (car LayN)))
				(if LayDoLst
					(setq	LayDoLst	(append LayDoLst LayDo))
					(setq	LayDoLst	(append (list "-LAYER") LayDo))
				)
		)
		(setq	LayDoLst	nil)
	)
	(if LayDoLst
		(setq	LayDoLst	(append LayDoLst (list "")))
	)
	(if LayDoLst
		(mapcar (quote command) LayDoLst)
	)
	(setq	ssE		(ssget "X" (list (cons 0 "INSERT")))
			Cnt		0
	)
	(if ssE
		(while (< Cnt (sslength ssE))
			(setq	e1	(ssname ssE Cnt))
			(FixAttCol e1)
			(setq	Cnt	(1+ Cnt))
		)
	)
	;	Cleanup
	(if ssE
		(progn
			(setq ssE nil)
			(gc)
		)
	)
	(princ "\nFixAttCol has corrected your Layers and Symbols.")
	(princ)
)

(defun SetAttCol ( et1 Col /	e1 e2 )			; Sets Attribute Colors
	(setq e1 (entnext et1))
	(while e1
		(if (/= (cdr (assoc 0 (setq e2 (entget e1 (list "*"))))) "SEQEND")
			(if (assoc 62 e2)
				(if (/= (cdr (assoc 62 e2)) Col)
					(progn
						(setq e2 (subst (cons 62 Col) (assoc 62 e2) e2))
						(entmod e2)
						(if Bug (princ "\nFound One!"))
						(setq e1 (entnext e1))
					)
					(setq e1 (entnext e1))
				)
				(progn
					(setq e2 (append e2 (list (cons 62 Col))))
					(entmod e2)
					(if Bug (princ "\nFound One!"))
					(setq e1 (entnext e1))
				)
			)
			(setq e1 nil)
		)
	)
	(entupd et1)
	(princ)
)

(defun C:SetAttCol ( /	Col ssE Cnt e1 ColWas)	; Sets all attribute colors
	(setq	ColWas	(getvar "CECOLOR"))
	(if (/= (substr (getvar "ACADVER") 1 4) "17.0")
		(c:ddcolor)
		(progn
			(initdia)
			(command "_.Color")
		)
	)
	(setq	ssE		(ssget)
			Col		(atoi (getvar "CECOLOR"));(getint "\nEnter the color to force: ")
			Cnt		0
	)
	(if Col
		(if ssE
			(while (< Cnt (sslength ssE))
				(setq	e1	(ssname ssE Cnt))
				(SetAttCol e1 Col)
				(setq	Cnt	(1+ Cnt))
			)
		)
	)
	;	Cleanup
	(if ssE	(setq ssE nil))
	(gc)
	(setvar "CECOLOR" ColWas)

	(princ "\nSetAttCol has corrected your Symbols.")
	(princ)
)

(defun SetAttLay ( et1 Lay /	e1 e2 )			; Sets Attribute Layers
	(setq e1 (entnext et1))
	(while e1
		(if (/= (cdr (assoc 0 (setq e2 (entget e1 (list "*"))))) "SEQEND")
			(if (/= (cdr (assoc 8 e2)) Lay)
				(progn
					(setq e2 (subst (cons 8 Lay) (assoc 8 e2) e2))
					(entmod e2)
					(if Bug (princ "\nFound One!"))
					(setq e1 (entnext e1))
				)
				(setq e1 (entnext e1))
			)
			(setq e1 nil)
		)
	)
	(entupd et1)
	(princ)
)

(defun C:SetAttLay ( /	Lay ssE Cnt e1 )		; Sets all attribute layers
	(setq	ssE		(ssget "X" (list (cons 0 "INSERT")))
			Lay		(getstring "\nEnter the layer to force: ")
			Cnt		0
	)
	(if Lay
		(if ssE
			(while (< Cnt (sslength ssE))
				(setq	e1	(ssname ssE Cnt))
				(SetAttLay e1 Lay)
				(setq	Cnt	(1+ Cnt))
			)
		)
	)
	;	Cleanup
	(if ssE	(setq ssE nil))
	(gc)

	(princ "\nSetAttLay has corrected your Symbols.")
	(princ)
)

(defun C:GetStrF ( /	Whaf FileN InData InLst	; Read String File, write file with matches
					Cnt Whuf Uggo TstLst Doit GotDat )
	(setq	Whaf	(getfiled	"Source Text File"
						"c:/CodeWright/"
						"txt;1st;me;doc"
						10
				)
	)
	(if (findfile Whaf)
		(setq	FileN	(open Whaf "r")
				InData	(read-line FileN)
				InLst	(list InData)
				Cnt		0
				Whuf		(strcat (substr Whaf 1 (- (strlen Whaf) 4)) ".OUT")
				Uggo		"UhUhUhUh"
		)
	)
	(if InData
		(while (setq InData (read-line FileN))
			(if InData
				(setq	InLst	(append InLst (list InData)))
			)
		)
	)
	(close FileN)
	(while (> (strlen Uggo) 1)
		(setq	Uggo	(getstring "\nEnter file search term: (Return to exit) "))
		(if Uggo
			(if (> (strlen Uggo) 1)
				(if	TstLst
					(setq	TstLst	(append TstLst (list Uggo)))
					(setq	TstLst	(list Uggo))
				)
			)
		)
	)
	(princ "\nFile Search Terms include:")
	(mapcar (quote (lambda (x) (princ (strcat "\n\t" (strcase x))))) TstLst)
	(if (> (length InLst) 1)
		(repeat (length InLst)
			(if (TstForDat (nth Cnt InLst) TstLst)
				(if	GotDat
					(setq	GotDat	(append GotDat (list (nth Cnt InLst))))
					(setq	GotDat	(list (nth Cnt InLst)))
				)
			)
			(setq	Cnt	(1+ Cnt))
		)
	)
	(if GotDat (princ (strcat "\nGotDat has " (itoa (length GotDat)) " items.")))
	(if (findfile Whuf)
		(progn
			(initget "Yes No")
			(setq	Doit	(getkword	(strcat	"\nOutput file <"
										Whuf
										"> already exists. Replace (Yes No): "
								)
						)
			)
		)
		(progn
			(setq	Doit	"Yes")
			(princ	(strcat	"\nOutput file <"
							Whuf
							"> prepared for data."
					)
			)
		)
	)
	(if (= Doit "Yes")
		(if (and GotDat Whuf)
			(progn
				(setq	FileO	(open Whuf "w"))
				(mapcar (quote (lambda (x) (write-line x FileO))) GotDat)
				(close FileO)
			)
		)
	)
	(princ)
)

(defun TstForDat ( SrcStr TstLst / Found x )	; Test for That
	(setq	SrcStr	(strcase SrcStr)
			Found	nil
	)
	(mapcar
		(quote	(lambda (x)
					(if (not Found)
						(if (wcmatch SrcStr (strcat "*" (strcase x) "*"))
							(setq	Found	T)
						)
					)
				 )
		)
		TstLst
	)
	Found
)

(defun C:MemFd ( / )						; Feeder Member function
	(if (not Tables)
		(progn
			(LodStage2 "Tables")
			(Tables)
		)
	)
	(Mem_Fd (strcase (getstring "\nThree-Digit Feeder Name? ")))
	(princ)
)

(defun Mem_Fd ( Memb / Hit )					; Test for Member of Feeder
	(if Bug (princ "\n{Mem_Fd entered\n"))
	(if (= (type Memb) (quote INT))
		(if (nth Memb Lst_Fd_V)
			(setq	Hit	(princ	(strcat	"\nLst_Fd_C="
										(itoa (nth Memb Lst_Fd_C))
										"\nLst_Fd_V="
										(nth Memb Lst_Fd_V)
										"\nLst_Fd_S="
										(nth Memb Lst_Fd_S)
								)
						)
			)
		)
	)
	(if (= (type Memb) (quote STR))
		(if (member Memb Lst_Fd_V)
			(setq	Memb	(-	(length Lst_Fd_V)
							(length (member Memb Lst_Fd_V))
						)
					Hit	(princ	(strcat "\nLst_Fd_C="
										(itoa (nth Memb Lst_Fd_C))
										"\nLst_Fd_V="
										(nth Memb Lst_Fd_V)
										"\nLst_Fd_S="
										(nth Memb Lst_Fd_S)
								)
						)
			)
		)
	)
	(if Bug (princ "\nMem_Fd exited}\n"))
	(princ)
)

(defun Mem_Sb_S ( Memb / Hit )				; Test for Member of Substation
	(if Bug (princ "\n{Mem_Sb_S entered\n"))
	(if (= (type Memb) (quote INT))
		(if (nth Memb Lst_Sb_V)
			(setq	Hit	(nth Memb Lst_Sb_S))
		)
	)
	(if (= (type Memb) (quote STR))
		(if (member Memb Lst_Sb_V)
			(setq	Memb	(-	(length Lst_Sb_V)
							(length (member Memb Lst_Sb_V))
						)
					Hit	(nth Memb Lst_Sb_S)
			)
		)
	)
	(if Bug (princ "\nMem_Sb_S exited}\n"))
	Hit
)

(defun Mem_Sb_C ( Memb /	Cntr Itm HitLst	; Test for Colors of Substation
						Hit )
	(if Bug (princ "\n{Mem_Sb_C entered\n"))
	(setq	FdrMLst	nil)
	(if (= (type Memb) (quote STR))
		(if (= (strlen Memb) 2)
			(setq	FdrMLst	(mapcar (quote (lambda (x) (if (wcmatch x (strcat Memb "?")) x nil))) Lst_Fd_V))
		)
	)
	(if FdrMLst
		(setq	Cntr		0)
	)
	(while (< Cntr (length FdrMLst))
		(if (nth Cntr FdrMLst)
			(if HitLst
				(setq	HitLst	(cons Cntr HitLst))
				(setq	HitLst	(list Cntr))
			)
		)
		(setq	Cntr		(1+ Cntr))
	)
	(if HitLst
		(foreach	Itm
				HitLst
				(if Hit
					(setq	Hit	(strcat Hit "," (itoa (nth Itm Lst_Fd_C))))
					(setq	Hit	(itoa (nth Itm Lst_Fd_C)))
				)
		)
		(setq	Hit		nil)
	)
	(if Bug (princ "\nMem_Sb_C exited}\n"))
	Hit
)

(defun C:MemSym ( / )						; Symbology Member function
	(MemSym (strcase (getstring "\nSymbol Name? ")))
	(princ)
)

(defun MemSym ( Memb / Hit PosM )				; Member of Symbol test
	(setq	PosM	nil)
	(if (= (type Memb) (quote STR))
		(if (member Memb Lst_Sp_Dn)
			(setq	PosM		(-	(length Lst_Sp_Dn)
								(length (member Memb Lst_Sp_Dn))
							)
			)
		)
		(if (= (type Memb) (quote INT))
			(setq	PosM		Memb)
		)
	)
	(if PosM
		(princ	(strcat	"\nDevice Name\t\t"
						(nth PosM Lst_Sp_Dn)
						"\nSymbol Name\t\t"
						(nth PosM Lst_Sp_Sn)
						"\nObject Class\t\t"
						(nth PosM Lst_Sp_Oc)
						"\nSymbol Size\t\t"
						(rtos (nth PosM Lst_Sp_Ss) 2 4)
						"\nAttribute Size\t"
						(rtos (nth PosM Lst_Sp_AS) 2 4)
						"\nLayer Name\t\t"
						(nth PosM Lst_Sp_Ln)
						"\nEdit Rule\t\t"
						(nth PosM Lst_Sp_Er)
						"\nMode Availability\t"
						(nth PosM Lst_Sp_Ma)
						"\nMenu Use\t\t"
						(nth PosM Lst_Sp_Mu)
						"\nRotated\t\t"
						(nth PosM Lst_Sp_Rt)
				)
		)
		(princ "\nItem not found.")
	)
	(princ)
)

(defun C:WhoDat ( /	FOrg InData InList		; CL - Who is That atom query
					CurrList TmpIt Cnt )
	(setq	FOrg		(open "C:\\CodeWright\\Projects\\Lsp1.kwd" "r")
			InData	(read-line FOrg)
			WhoOut	nil
	)
	(if InData
		(progn
			(setq	InList	(list InData))
			(while (setq InData (read-line FOrg))
				(setq	InList	(cons InData InList))
			)
			(close FOrg)
			(setq	InList	(reverse InList)
					CurrList	(atoms-family 1)
					WhoLst	(list "000")
			)
			(while CurrList
				(setq	TmpIt	(car CurrList))
				(if (> (length CurrList) 1)
					(setq	CurrList	(cdr CurrList))
					(if (= (length CurrList) 1)
						(setq	CurrList	nil)
					)
				)
				(if (not (member TmpIt InList))
					(setq	WhoLst	(cons TmpIt WhoLst))
				)
			)
			(if (> (length WhoLst) 1)
				(setq	WhoLst	(acad_strlsort (cdr (reverse WhoLst))))
				(setq	WhoLst	nil)
			)
		)
	)
	(if WhoLst
		(setq	WhoWhat	(getstring "\nWhat you lookin for? "))
	)
	(if WhoWhat
		(progn
			(setq	WhoWhat	(strcase WhoWhat)
					Cnt		0
			)
			(repeat (length WhoLst)
				(if (wcmatch (nth Cnt WhoLst) (strcat "*" WhoWhat "*"))
					(if WhoOut
						(setq	WhoOut	(append WhoOut (list (nth Cnt WhoLst))))
						(setq	WhoOut	(list (nth Cnt WhoLst)))
					)
				)
				(setq	Cnt	(1+ Cnt))
			)
		)
	)
	(if WhoOut
		(mapcar (quote (lambda (x) (princ (strcat "\n" x)))) WhoOut)
	)
	(princ (strcat "\n" (itoa (length WhoOut)) " matches."))
	(princ)
)

(defun C:WhoDatA ( /	FOrg InData InList		; CL - Who Dat All? atom query
					CurrList TmpIt Cnt )
	(setq	WhoALst	(atoms-family 1)
			WhoALst	(acad_strlsort (cdr (reverse WhoALst)))
			WhoOut	nil
	)
	(if WhoALst
		(setq	WhoWhat	(getstring "\nWhat you lookin for? "))
	)
	(if WhoWhat
		(progn
			(setq	WhoWhat	(strcase WhoWhat)
					Cnt     0
			)
			(repeat (length WhoALst)
				(if	(wcmatch (nth Cnt WhoALst) (strcat "*" WhoWhat "*"))
					(if WhoOut
						(setq	WhoOut	(append WhoOut (list (nth Cnt WhoALst))))
						(setq	WhoOut	(list (nth Cnt WhoALst)))
					)
				)
				(setq	Cnt	(1+ Cnt))
			)
		)
	)
	(if WhoOut
		(mapcar (quote (lambda (x) (princ (strcat "\n" x)))) WhoOut)
	)
	(princ (strcat "\n" (itoa (length WhoOut)) " matches."))
	(princ)
)

(defun RevOrd ( / SsO SsM SsN )				; Revise Order, moves Hatch to first, Mask to last then Qsaves
	(command "_.LAYER" "T" "*" "ON" "*" "U" "*" "S" "0" "")
	(command "_.ZOOM" "E" "_.ZOOM" "0.9x")
	(if (setq SsO	(ssget "X" (list (cons 8 "MASK"))))
		(progn
			(setq	;Everything but Mask and Hatch
					SsM	(ssget "X"	(list	(cons -4 "<NOT")
												(cons -4 "<OR")
													(cons 8 "MASK")
													(cons 0 "HATCH")
												(cons -4 "OR>")
											(cons -4 "NOT>")
									)
						)
					;Just Hatch, not Mask
					SsN	(ssget "X"	(list	(cons 0 "HATCH")
											(cons -4 "<NOT")
												(cons 8 "MASK")
											(cons -4 "NOT>")
									)
						)
			)
			(if (not SsN)
				(setq	SsN	(ssget "X"	(list	(cons -4 "<OR")
													(cons 8 "Change")
													(cons 8 "Remove")
												(cons -4 "OR>")
										)
							)
				)
			)
			(if SsN	;Copy Hatch, then erase (makes Hatch first)
				(command "COPY" SsN "" "0,0" "0,0" "_.ERASE" SsN "")
			)
			(if SsM	;Copy Everything, then erase (leaves Mask last)
				(command "COPY" SsM "" "0,0" "0,0" "_.ERASE" SsM "")
			)
		)
	)
	(if SsO (setq SsO nil))
	(if SsN (setq SsN nil))
	(if SsM (setq SsM nil))
	(gc)
	(command "_.QSave")
	(princ)
)

(defun LoadUp ( / Fn1 In1 Lst )				; Reads in a list of files
	(setq	Fn1	(open "files.lst" "r")
			In1	(read-line Fn1)
			Lst	(list In1)
	)
	(while (setq In1 (read-line Fn1))
		(if In1
			(setq	Lst	(cons In1 Lst))
		)
	)
	(close Fn1)
	(setq	Lst	(reverse Lst))
)

(defun C:NexUp ( / )						; CL - Runs RevOrd and opens next file
	(if (not NexLst)
		(setq	NexLst	(LoadUp))
	)
	(if (not StatLin)
		(load "UTILS")
	)
	(if (not Div)
		(setq	Div	(getstring "\nEnter Division Abbreviation: "))
	)
	(if (not DoIt)
		(while (not DoIt)
			(setq	DoIt		(strcase (getstring "\nAccess Code for NexUp? ")))
			(if (not (member DoIt (list "PHASE" "SYM" "CADET")))
				(setq	DoIt		nil)
			)
		)
	)
	(if NexLst
		(setq	Gon		(car NexLst)
				NexLst	(cdr NexLst)
		)
		(setq	Gon		nil)
	)
	(if StrtNum
		(setq	StrtNum	(1+ StrtNum)
				Bubba	(setvar "USERI1" StrtNum)
				Bubba	(StatLin StrtNum EndNum)
		)
		(setq	StrtNum	1
				EndLst	(dos_dir "*.dwg")
				EndNum	(length EndLst)
				Bubba	(StatLin StrtNum EndNum)
		)
	)
	(cond
		((= DoIt "SYM")
			(CleanUp)
		)
		((= DoIt "CADET")
			(RevOrd)
		)
		((= DoIt "PHASE")
			(C:GetBoth)
		)
	)
	(if Gon
		(if (> (getvar "DBMOD") 0)
			(command "_.OPEN" "N" Gon)
			(command "_.OPEN" Gon)
		)
	)
	(princ)
)

(defun CentRUp ( / Pt1 Pt2 Pt3 SsM OMod )		; Centers object from two points and moves->origin
	(if (< (setq OMod (getvar "OSMODE")) 1)
		(setvar "OSMODE" 63)
	)
	(setq	Pt1		(getpoint "\nSelect first point: ")
			Pt2		(getpoint Pt1 "\nSelect second point: ")
			Pt3		(list	(+ (car Pt1) (/ (- (car Pt2) (car Pt1)) 2.0))
							(+ (cadr Pt1) (/ (- (cadr Pt2) (cadr Pt1)) 2.0))
					)
			SsM		(ssget "X" (list (cons 8 "MASK")))
	)
	(setvar "OSMODE" 0)
	(command "_.MOVE" "ALL" "" Pt3 "0,0" "_.ZOOM" "E" "BASE" "0,0,0")
	(if SsM
		(RevOrd)
	)
	(princ)
)

(defun CleanUp ( / Ibs )					; Purges, restores defaults, saves
	(command "_.LAYER" "T" "*" "ON" "*" "U" "*" "S" "0" "")
	(command "_.ZOOM" "E")
	(command "PURGE" "A" "*" "N")
	(setq	SsM	(ssget "X" (list (cons 8 "MASK"))))
	(if (> (getvar "UCSICON") 0) (setvar "UCSICON" 0))
	(if (< (getvar "REGENMODE") 1) (setvar "REGENMODE" 1))
	(if (> (getvar "CMDECHO") 0) (setvar "CMDECHO" 0))
	(if (> (getvar "GRIDMODE") 0) (setvar "GRIDMODE" 0))
	(if (> (getvar "ORTHOMODE") 0) (setvar "ORTHOMODE" 0))
	(if (< (getvar "BLIPMODE") 1) (setvar "BLIPMODE" 1))
	(if (> (getvar "SNAPMODE") 0) (setvar "SNAPMODE" 0))
	(if (equal (setq Ibs (getvar "INSBASE")) (list 0.0 0.0 0.0) 0.010)
		(princ "\nInsert at 0,0")
		(setq	Bubba	(princ	(strcat	"\nInsert NOT at 0,0 - "
										(rtos (car Ibs) 2 4)
										","
										(rtos (cadr Ibs) 2 4)
								)
						)
				Bubba	(command "ID" Ibs)
				Bubba	(CentRUp)
		)
	)
	(if SsM
		(progn
			(RevOrd)
			(if (= (getvar "USERI5") 0)
				(setvar "USERI5" 1)
				(setvar "USERI5" 0)
			)
		)
		(progn
			(command "QSAVE")
			(if (= (getvar "USERI5") 0)
				(setvar "USERI5" 1)
				(setvar "USERI5" 0)
			)
		)
	)
	;	Cleanup
	(if SsM	(setq SsM nil))
	(gc)
	
	(princ)
)

(defun EntCallStep ( EntLst / Cnt EntLen )		; Ent Call Step
	(setq	EntLen	(length EntLst)
			OutLst	(list "000")
			Cnt		0
	)
	(foreach	x
			EntLst
			(cond
				((= (type (cdr x)) (quote LIST))
					(if (= (type (car (cdr x))) (quote STR))
						(setq	StrLst	(apply	(quote strcat)
												(mapcar	(list lambda (x) (strcat x (chr 32)))
						 								(cdr x)
												)
										)
								OutOne	(strcat	(itoa (car x))
												(RepChar	(chr 32)
													(- 5 (strlen (itoa (car x))))
												)
												StrLst
												(RepChar	(chr 32)
													(- 20 (strlen StrLst))
												)
												"List of Strings"
										)
								OutLst	(cons OutOne OutLst)
						)
					)
					(if (= (type (car (cdr x))) (quote REAL))
						(setq	StrLst	(apply	(quote strcat)
												(mapcar	(list lambda (x) (strcat (rtos x 2 4) (chr 32)))
														(cdr x)
												)
										)
								OutOne	(strcat	(itoa (car x))
												(RepChar	(chr 32)
													(- 5 (strlen (itoa (car x))))
												)
												StrLst
												(RepChar	(chr 32)
													(- 20 (strlen StrLst))
												)
												"List of Reals"
										)
								OutLst	(cons OutOne OutLst)
						)
					)
					(if (= (type (car (cdr x))) (quote INT))
						(setq	StrLst	(apply	(quote strcat)
												(mapcar	(list lambda (x) (strcat (itoa x) (chr 32)))
														(cdr x)
												)
										)
								OutOne	(strcat	(itoa (car x))
												(RepChar	(chr 32)
													(- 5 (strlen (itoa (car x))))
												)
												StrLst
												(RepChar	(chr 32)
													(- 20 (strlen StrLst))
												)
												"List of Ints"
										)
								OutLst	(cons OutOne OutLst)
						)
					)
				)
				((= (type (cdr x)) (quote ENAME))
					(setq	OutOne	(strcat	(itoa (car x))
											(RepChar	(chr 32)
												(- 5 (strlen (itoa (car x))))
											)
											(RepChar (chr 32) 20)
											"Ename"
									)
							OutLst	(cons OutOne OutLst)
					)
				)
				((= (type (cdr x)) (quote REAL))
					(setq	OutOne	(strcat	(itoa (car x))
											(RepChar	(chr 32)
												(- 5 (strlen (itoa (car x))))
											)
											(rtos (cdr x) 2 4)
											(RepChar	(chr 32)
												(- 20 (strlen (rtos (cdr x) 2 4)))
											)
											"Real"
									)
							OutLst	(cons OutOne OutLst)
					)
				)
				((= (type (cdr x)) (quote INT))
					(setq	OutOne	(strcat	(itoa (car x))
											(RepChar	(chr 32)
												(- 5 (strlen (itoa (car x))))
											)
											(itoa (cdr x))
											(RepChar	(chr 32)
												(- 20 (strlen (itoa (cdr x))))
											)
											"Int"
									)
							OutLst	(cons OutOne OutLst)
					)
				)
				((= (type (cdr x)) (quote STR))
					(setq	OutOne	(strcat	(itoa (car x))
											(RepChar	(chr 32)
												(- 5 (strlen (itoa (car x))))
											)
											(cdr x)
											(RepChar	(chr 32)
												(- 20 (strlen (cdr x)))
											)
											"String"
									)
							OutLst	(cons OutOne OutLst)
					)
				)
				(T
					(setq	OutOne	(strcat	(itoa (car x))
											(RepChar	(chr 32)
												(- 5 (strlen (itoa (car x))))
											)
											(RepChar (chr 32) 20)
											"Unknown"
									)
							OutLst	(cons OutOne OutLst)
					)
				)
			)
	)
	(if (> (length OutLst) 1)
		(setq	OutLst	(cdr (reverse OutLst)))
		(setq	OutLst	nil)
	)
)

(defun FunVarStp ( StrLst / VarLst FunLst )		; Function Variable Strip
	(setq	FunLst	(list	"000")
			VarLst	(list	"000")
			ExtLst	(list	"000")
			ChkLst	(list	"ChkLst"
							"UnqLst"
							"VarLst"
							"ExtLst"
							"FunLst"
							"StrLst"
							"OutStr"
							"x"
							"MaxLen"
							"Cnt"
							"InDLst1"
							"InDLst2"
							"InD1"
							"Fn1"
							"Fnam1"
							"Fn3"
							"Fnam3"
							"Fn4"
							"Fnam4"
							"Fn5"
							"Fnam5"
					)
	)
	(foreach	x
			StrLst
			(cond
				((member x ChkLst)
					(setq	ExtLst	(cons x ExtLst))
				)
				((= (type (eval (read x))) (quote LIST))
					(if	(or	(= (type (car (eval (read x)))) (quote STR))
							(= (type (car (eval (read x)))) (quote REAL))
							(= (type (car (eval (read x)))) (quote INT))
						)
						(setq	VarLst	(cons x VarLst))
						(setq	FunLst	(cons x FunLst))
					)
				)
				((= (type (eval (read x))) (quote SUBR))
					(setq ExtLst (cons x ExtLst))
				)
				((= (type (eval (read x))) (quote FILE))
					(setq ExtLst (cons x ExtLst))
				)
				((= (type (eval (read x))) (quote EXSUBR))
					(setq ExtLst (cons x ExtLst))
				)
				((= (type (eval (read x))) (quote PICKSET))
					(setq ExtLst (cons x ExtLst))
				)
				((= (type (eval (read x))) (quote PAGETB))
					(setq ExtLst (cons x ExtLst))
				)
				((= (type (eval (read x))) (quote ENAME))
					(setq VarLst (cons x VarLst))
				)
				((= (type (eval (read x))) (quote REAL))
					(setq VarLst (cons x VarLst))
				)
				((= (type (eval (read x))) (quote INT))
					(setq VarLst (cons x VarLst))
				)
				((= (type (eval (read x))) (quote STR))
					(setq VarLst (cons x VarLst))
				)
				((= (type (eval (read x))) (quote SYM))
					(setq VarLst (cons x VarLst))
				)
				(T
					(setq ExtLst (cons x ExtLst))
				)
			)
	)
	(if (> (length FunLst) 1)
		(setq FunLst (cdr (reverse FunLst)))
		(setq FunLst nil)
	)
	(if (> (length VarLst) 1)
		(setq VarLst (cdr (reverse VarLst)))
		(setq VarLst nil)
	)
	(if (> (length ExtLst) 1)
		(setq ExtLst (cdr (reverse ExtLst)))
		(setq ExtLst nil)
	)
	(list VarLst FunLst ExtLst)
)

(defun StartSCS ( / )						; default StartUp function
	(if (> (getvar "PLINETYPE") 0) (setvar "PLINETYPE" 0))
	(princ)
)

(defun C:MakLayLst ( /	LayNam LayLst			; Builds Layer List File
					Dnam Fnam FOut )
	(setq	LayNam	(tblnext "LAYER" T)
			LayLst	nil
			Dnam		(strcase (getvar "DWGNAME"))
	)
	(if (= (substr Dnam (- (strlen Dnam) 3)) ".DWG")
		(setq	Dnam		(substr Dnam 1 (- (strlen Dnam) 4)))
	)
	(while (setq LayNam (tblnext "LAYER"))
		(if LayNam
			(if LayLst
				(setq	LayLst	(cons (strcase (cdr (assoc 2 LayNam))) LayLst))
				(setq	LayLst	(list (strcase (cdr (assoc 2 LayNam)))))
			)
		)
	)
	(if (findfile (strcat Dnam ".TXT"))
		(command "SHELLP" (strcat "Del " Dnam ".TXT"))
	)
	(setq	Fnam		(strcat Dnam ".TXT")
			FOut		(open Fnam "w")
	)
	(if FOut
		(foreach	LayNam
				LayLst
				(write-line LayNam FOut)
		)
	)
	(if FOut
		(close FOut)
	)
	(princ)
)

(defun C:WrkLayLst ( /	LayNam 				; Works Layer List File
					Fnam FOut )	; LayLst
	(command	"_.LAYER" "T" "*" "U" "*" "ON" "*" "S" "0" "" "ZOOM" "E")
	(setvar "CMDECHO" 0)
	(setvar "CMDDIA" 0)
	(setq	LayNam	(tblnext "LAYER" T)
			LayLst	nil
			WrkLst	nil
			DifSch	nil
			ssDif	nil
			Dnam		(strcase (getvar "DWGNAME"))
	)
	(if (= (substr Dnam (- (strlen Dnam) 3)) ".DWG")
		(setq	Dnam		(substr Dnam 1 (- (strlen Dnam) 4)))
	)
	(while (setq LayNam (tblnext "LAYER"))
		(if LayNam
			(if LayLst
				(setq	LayLst	(cons (strcase (cdr (assoc 2 LayNam))) LayLst))
				(setq	LayLst	(list (strcase (cdr (assoc 2 LayNam)))))
			)
		)
	)
	(if (findfile (strcat Dnam ".TXT"))
		(progn
			(setq	Fnam		(strcat Dnam ".TXT")
					FOut		(open Fnam "r")
			)
			(if FOut
				(setq	InData	(read-line FOut))
			)
			(if Indata
				(setq	WrkLst	(list InData)
						InData	(read-line FOut)
				)
			)
			(if Indata
				(while InData
					(if InData
						(setq	WrkLst	(cons InData WrkLst))
					)
					(setq	InData	(read-line FOut))
				)
			)
			(if FOut
				(close FOut)
			)
		)
	)
	(if (and WrkLst LayLst)
		(princ (strcat "\nWrkLst = " (itoa (length WrkLst)) " LayLst = " (itoa (length LayLst))))
	)
	(if (and WrkLst LayLst)
		(if (< (length WrkLst) (length LayLst))
			(foreach	LayNam
					LayLst
					(if (not (member LayNam WrkLst))
						(if DifLst
							(setq	DifLst	(cons LayNam DifLst))
							(setq	DifLst	(list LayNam))
						)
					)
			)
			(setq	DifLst	nil)
		)
	)
	(if DifLst
		(if (> (length DifLst) 1)
			(setq	DifSch	(mapcar (quote (lambda (x) (cons 8 x))) DifLst)
					DifSch	(cons (cons -4 "<OR") DifSch)
					DifSch	(append DifSch (list (cons -4 "OR>")))
			)
			(if (= (length DifLst) 1)
				(setq	DifSch	(list (cons 8 (car DifLst))))
			)
		)
		(setq	DifSch	nil)
	)
	(if DifSch
		(setq	ssDif	(ssget "X" DifSch))
		(setq	ssDif	nil)
	)
	(if (and Dnam ssDif)
		(command	"WBLOCK"
				(strcat "C:\\DATA\\PHASED\\" Dnam)
				""
				"0,0"
				ssDif
				""
				"N"
		)
	)
	;	Cleanup
	(if ssDif	(setq ssDif nil))
	(gc)

	(princ)
)

(defun C:DoReplace ( / )					; Inserts Dwgs and WBlocks Out
	(command	"_.LAYER" "T" "*" "U" "*" "ON" "*" "S" "0" "" "ZOOM" "E")
	(setvar "CMDECHO" 0)
	(setvar "CMDDIA" 0)
	(setq	Dnam		(strcase (getvar "DWGNAME")))
	(if (findfile (strcat "C:\\Data\\Phased\\" Dnam))
		(progn
			(command	"INSERT"
					(strcat "*C:\\Data\\Phased\\" Dnam)
					"0,0"
					"1"
					"0"
			)
			(command	"WBLOCK"
					(strcat "C:\\DATA\\Zip\\" Dnam)
					"*"
					"N"
			)
		)
	)
	(princ)
)

(defun C:OutPut ( / )						; Saves Out for conv fix
	(command	"_.LAYER" "T" "*" "U" "*" "ON" "*" "S" "0" "" "ZOOM" "E")
	(setvar "CMDECHO" 0)
	(setvar "CMDDIA" 0)
	(setq	Dnam		(strcase (getvar "DWGNAME")))
	(command	"WBLOCK"
			(strcat "C:\\DATA\\Zip\\" Dnam)
			"*"
			"N"
	)
	(princ)
)

(defun C:ColorFixM ( /	LayNam LayLst LayGrp	; Fix Damaged Text Colors - CL
					LayN LayDo LayDoLst )	; Fixes Top, Bottom or Landmark Layers
	(setq	LayNam	(tblnext "LAYER" T)		; to not be color 15, and saves DWG!
			LayLst	nil
	)
	(while (setq LayNam (tblnext "LAYER"))
		(if LayNam
			(if	(and	(= 15 (cdr (assoc 62 LayNam)))
					(or	(wcmatch (cdr (assoc 2 LayNam)) "??????[TB]???")
						(wcmatch (cdr (assoc 2 LayNam)) "*-LM-*")
					)
				)
				(setq	LayGrp	(cons	(cdr (assoc 2 LayNam))
										(cdr (assoc 62 LayNam))
								)
				)
				(setq	LayGrp	nil)
			)
		)
		(if LayGrp
			(if LayLst
				(setq	LayLst	(cons LayGrp LayLst))
				(setq	LayLst	(list LayGrp))
			)
		)
	)
	(if LayLst
		(foreach	LayN
				LayLst
				(setq	LayDo	(list "C" "7" (car LayN)))
				(if LayDoLst
					(setq	LayDoLst	(append LayDoLst LayDo))
					(setq	LayDoLst	(append (list "-LAYER") LayDo))
				)
		)
		(setq	LayDoLst	nil)
	)
	(if LayDoLst
		(setq	LayDoLst	(append LayDoLst (list "")))
	)
	(if LayDoLst
		(mapcar (quote command) LayDoLst)
	)
	(if (> (getvar "DBMOD") 0)
		(progn
			(command "_.QSAVE")
			(princ "\nColorFixM has corrected your Layers & saved your changes.")
		)
		(princ "\nColorFixM has not changed your Layers - no changes made.")
	)
	(princ)
)

(defun C:ClrFixM ( /	LayNam LayLst LayGrp	; Fix Damaged Text Colors - CL +
					LayN LayDo LayDoLst )	; Fixes Top, Bottom or Landmark Layers
	(setq	LayNam	(tblnext "LAYER" T)		; to not be color 15!
			LayLst	nil
	)
	(while (setq LayNam (tblnext "LAYER"))
		(if LayNam
			(if	(and	(= 15 (cdr (assoc 62 LayNam)))
					(or	(wcmatch (cdr (assoc 2 LayNam)) "??????[TB]???")
						(wcmatch (cdr (assoc 2 LayNam)) "*-LM-*")
					)
				)
				(setq	LayGrp	(cons	(cdr (assoc 2 LayNam))
										(cdr (assoc 62 LayNam))
								)
				)
				(setq	LayGrp	nil)
			)
		)
		(if LayGrp
			(if LayLst
				(setq	LayLst	(cons LayGrp LayLst))
				(setq	LayLst	(list LayGrp))
			)
		)
	)
	(if LayLst
		(foreach	LayN
				LayLst
				(setq	LayDo	(list "C" "7" (car LayN)))
				(if LayDoLst
					(setq	LayDoLst	(append LayDoLst LayDo))
					(setq	LayDoLst	(append (list "-LAYER") LayDo))
				)
		)
		(setq	LayDoLst	nil)
	)
	(if LayDoLst
		(setq	LayDoLst	(append LayDoLst (list "")))
	)
	(if LayDoLst
		(mapcar (quote command) LayDoLst)
	)
	(princ)
)

(defun C:ColorFixNO ( /	LayNam LayLst LayGrp	; Fix Damaged Text Colors - CL +
					LayN LayDo LayDoLst )	; Fixes NO layers that are not 3 to be 3
	(setq	LayNam	(tblnext "LAYER" T)
			LayLst	nil
	)
	(while (setq LayNam (tblnext "LAYER"))
		(if LayNam
			(if	(and	(/= 3 (cdr (assoc 62 LayNam)))
					(wcmatch (cdr (assoc 2 LayNam)) "????NO????")
				)
				(setq	LayGrp	(cons	(cdr (assoc 2 LayNam))
										(cdr (assoc 62 LayNam))
								)
				)
				(setq	LayGrp	nil)
			)
		)
		(if LayGrp
			(if LayLst
				(setq	LayLst	(cons LayGrp LayLst))
				(setq	LayLst	(list LayGrp))
			)
		)
	)
	(if LayLst
		(foreach	LayN
				LayLst
				(setq	LayDo	(list "C" "3" (car LayN)))
				(if LayDoLst
					(setq	LayDoLst	(append LayDoLst LayDo))
					(setq	LayDoLst	(append (list "-LAYER") LayDo))
				)
		)
		(setq	LayDoLst	nil)
	)
	(if LayDoLst
		(setq	LayDoLst	(append LayDoLst (list "")))
	)
	(if LayDoLst
		(mapcar (quote command) LayDoLst)
	)
	(if (> (getvar "DBMOD") 0)
		(progn
			(command "_.QSAVE")
			(princ "\nColorFixNO has corrected your Layers & saved your changes.")
		)
		(princ "\nColorFixNO has not changed your Layers - no changes made.")
	)
	(princ)
)

(defun C:LockRid	( /	ssi )				; Removes Locked Graphics from Panels
	(setq	ssi	(ssget "X" (list (cons 0 "INSERT")(cons 2 "LOCK"))))
	(if ssi
		(progn
			(command "_.ERASE" ssi "" ".QSAVE")
			(if (> (getvar "DBMOD") 0)
				(progn
					(command "_.QSAVE")
					(princ "\nLockRid has removed your Locks & saved your changes.")
				)
				(princ "\nLockRid has not found or removed any Locks & - no changes made.")
			)
			(setq ssi nil)
			(gc)
		)
		(gc)
	)
	;	Cleanup
	(if ssi	(setq ssi nil))
	(gc)
	
	(princ)
)

(defun C:ClnDupKill ( /	Bubba2 Bubba3 )		; Remove Dups - CL
	(setvar "CMDECHO" 0)
	(setvar "CMDDIA" 0)
	(setvar "FILEDIA" 0)
	(if (not chk_inserts)
		(if (not _Path-Lisp)
			(progn
				(load (strcat PrmRootPath "ADDS\\LISP\\REMDUPS"))
				(if (not LayChk)
					(load (strcat PrmRootPath "COMMON\\UTILS"))
				)
			)
			(progn
				(load (strcat _Path-Lisp "REMDUPS"))
				(if (not LayChk)
					(load "UTILS")
				)
			)
		)
	)
	(if (LayChk "????CK-*")
		(command "_ADEDWGCLEAN" "OB" "A" "X" "C" "M" "X" "O" "A" "X" "P")
	)
	(setq	Bubba2	(Chk_Inserts))
	(if (> Bubba2 0) (RepOutFil (strcat "Removed " (itoa Bubba2) " duplicate Inserts")))
	(setq	Bubba3	(Chk_Text))
	(if (> Bubba3 0) (RepOutFil (strcat "Removed " (itoa Bubba3) " duplicate Text")))
	(setvar "CMDDIA" 1)
	(setvar "FILEDIA" 1)
	(princ)
)

(defun C:AutoDupKill ( / )					; Remove Dups for Batch process
	(setvar "CMDECHO" 0)
	(setvar "CMDDIA" 0)
	(setvar "FILEDIA" 0)
	(if (not chk_inserts)
		(if (not _Path-Lisp)
			(progn
				(load (strcat PrmRootPath "ADDS\\LISP\\REMDUPS"))
				(load (strcat PrmRootPath "COMMON\\UTILS"))
			)
			(load (strcat _Path-Lisp "REMDUPS"))
		)
	)
	(if (LayChk "????CK-*")
		(command "_ADEDWGCLEAN" "OB" "A" "X" "C" "M" "X" "O" "A" "X" "P")
	)
	(Chk_Inserts)
	(Chk_Text)
	(setvar "CMDDIA" 1)
	(setvar "FILEDIA" 1)
	(if (> (getvar "DBMOD") 0)
		(progn
			(command "_.QSAVE")
			(princ "\nDupKill has removed dupes & saved your changes.")
		)
		(princ "\nDupKill has removed no dupes - no changes made.")
	)
	(princ)
)

(defun C:KeyUp ( /	ssb Cnt )					; DrawOrder for Adds Panel Status Dwg - ssa
	(setq	ssa	(ssget "X"	(list	(cons -4 "<NOT")
										(cons 0 "SOLID")
									(cons -4 "NOT>")
									(cons -4 "<OR")
										(cons 8 "PAN*")
										(cons 8 "DIV*")
									(cons -4 "OR>")
							)
				)
			ssb	(ssget "X"	(list	(cons 0 "SOLID")
									(cons 8 "*LOCK")
							)
				)
			Cnt	0
	)
	(if (and ssa ssb)
		(repeat (sslength ssb)
			(setq	ssa	(ssadd (ssname ssb Cnt) ssa)
					Cnt	(1+ Cnt)
			)
		)
		(if ssb
			(setq	ssa	ssb)
		)
	)
	(command "_.draworder" ssa "" "F")
	(setq	ssa	nil)
	(setq	ssa	(ssget "X"	(list	(cons 0 "*POLYLINE")
									(cons 8 "DIV_LINE")
							)
				)
	)
	(if ssa
		(command "_.draworder" ssa "" "F")
	)
	;	Cleanup
	(if ssa	(setq ssa nil))
	(if ssb	(setq ssb nil))
	(gc)
	(command "_.regenall")
	(princ)
)

(defun LstGet ( dFil /	rFil Imp ImpLst )		; List Reader
	(setq	rFil		(open dFil "r")
			Imp		(read-line rFil)
			ImpLst	(list (substr (strcase Imp) 1 7))
	)
	(while Imp
		(setq	Imp	(read-line rFil))
		(if Imp
			(setq	ImpLst	(cons (substr (strcase Imp) 1 7) ImpLst))
		)
	)
	(if rFil (close rFil))
	ImpLst
)

(defun C:RepShr ( /	Imp BGot EGot MGot		; Report on Shares
					SGot SEGot WGot )
	(setq	BigShrLst		(list (car BShrLst)))
	(foreach	Imp
			BShrLst
			(if (not (member Imp BigShrLst))
				(setq	BigShrLst	(cons Imp BigShrLst))
			)
	)
	(foreach	Imp
			EShrLst
			(if (not (member Imp BigShrLst))
				(setq	BigShrLst	(cons Imp BigShrLst))
			)
	)
	(foreach	Imp
			MShrLst
			(if (not (member Imp BigShrLst))
				(setq	BigShrLst	(cons Imp BigShrLst))
			)
	)
	(foreach	Imp
			SShrLst
			(if (not (member Imp BigShrLst))
				(setq	BigShrLst	(cons Imp BigShrLst))
			)
	)
	(foreach	Imp
			SEShrLst
			(if (not (member Imp BigShrLst))
				(setq	BigShrLst	(cons Imp BigShrLst))
			)
	)
	(foreach	Imp
			WShrLst
			(if (not (member Imp BigShrLst))
				(setq	BigShrLst	(cons Imp BigShrLst))
			)
	)
	(setq	BigShrLst		(acad_strlsort BigShrLst))
	(if BigShrLst
		(foreach	Imp
				BigShrLst
				(if (member Imp BShrLst)
					(setq	BGot		T)
					(setq	BGot		nil)
				)
				(if (member Imp EShrLst)
					(setq	EGot		T)
					(setq	EGot		nil)
				)
				(if (member Imp MShrLst)
					(setq	MGot		T)
					(setq	MGot		nil)
				)
				(if (member Imp SShrLst)
					(setq	SGot		T)
					(setq	SGot		nil)
				)
				(if (member Imp SEShrLst)
					(setq	SEGot		T)
					(setq	SEGot		nil)
				)
				(if (member Imp WShrLst)
					(setq	WGot		T)
					(setq	WGot		nil)
				)
				(setq	OutP		(strcat	"\""
										Imp
										"\","
										(if BGot "1,0," "0,0,")
										(if EGot "1,0," "0,0,")
										(if MGot "1,0," "0,0,")
										(if SGot "1,0," "0,0,")
										(if SEGot "1,0," "0,0,")
										(if WGot "1,0,0" "0,0,0")
								)
				)
				(if OutPLst
					(setq	OutPLst	(cons OutP OutPLst))
					(setq	OutPLst	(list OutP))
				)
				(princ	(strcat	"\nPanel\t"
								Imp "\t"
								(if BGot "BH\t" "\t")
								(if EGot "E_\t" "\t")
								(if MGot "M_\t" "\t")
								(if SGot "S_\t" "\t")
								(if SEGot "SE\t" "\t")
								(if WGot "W_\t" "\t")
						)
				)
		)
	)
	(princ)
)

(defun C:RepShrRef ( /	GetNum GetFil GetNam )	; Reports from RepShrRef - CL
	(setq	GetNum	(getint "\nDivision Number to Test Locks? ")
			GetLst	nil
			GetLst	(RepShrRef GetNum)
	)
	(if GetLst
		(progn
			(setq	GetLst	(acad_strlsort GetLst))
			(initget 1 "Yes No")
			(setq	GetFil	(getkword "\nWrite List to File? "))
			(if (= GetFil "Yes")
				(setq	GetNam	(getstring "\nFile Name? ")
						GetFil	nil
				)
				(setq	GetFil	nil)
			)
			(if GetNam
				(progn
					(setq	GetFil	(open GetNam "w"))
					(mapcar (quote (lambda (x) (write-line x GetFil))) GetLst)
					(close GetFil)
				)
			)
		)
	)
	(princ)
)

(defun RepShrRef ( DivN /	RefLst )			; Reports on Panels Shared & Locked for Refresh Activities
	(if (and (>= DivN 1) (<= DivN 6))
		(mapcar	(quote	(lambda (x)
							(if	(and	(nth DivN x)
									(nth (+ 6 DivN) x)
								)
								(if RefLst
									(setq	RefLst	(cons (nth 0 x) RefLst))
									(setq	RefLst	(list (nth 0 x)))
								)
							)
						)
				)
				All_Lck_Lst
		)
	)
	RefLst
)

(defun GetWid ( lname /	ou_ph )				; Returns width of polyline, based on layer
; Function: Returns width (for output, in inches) of polyline, based on layer.
; By: Ralston 10/20/92									
;	(setq	ou_ph	(substr lname 4 5))
;		((or (= ou_ph "OCK-3") (= ou_ph "OFL-3"))  0.04)
;		((or (= ou_ph "OCK-2") (= ou_ph "OFL-2"))  0.02)
;		((member (substr lname 5 3) (list "CK-" "FL-" "DV-" "DT-" "TA-" "TB-" "TC-" "TD-" "TE-" "AA-" "AB-" "AC-" "AD-"))  0.0099)
	(cond
		((and (/= Div "AL") (/= Div "GA")(>= (atoi (substr lname 8 1)) 0))		;[TODO] Check change from > to >= with EDW before depolying 
			(if (null SF)
				(SclFactor)
				(if (< SF 0.00)
					(SclFactor)
				)
			)
			(if (null Lst_Ph_W)
				(if Tables
					(Bld_T_Ph)
					(progn
						(load (strcat _Path-Lisp "Tables"))
						(Bld_T_Ph)
					)
				)
			)
			(* SF (nth (atoi (substr lname 8 1)) Lst_Ph_W))
		)
		(T 0.0099)
	)
)

(defun GetWidTst ( lname /	ou_ph )			; ChkWids Width Tester for DoBadWid
	(cond
		((> (atoi (substr lname 8 1)) 0)
			(if (null SF)
				(SclFactor)
				(if (< SF 0.00)
					(SclFactor)
				)
			)
			(if (null Lst_Ph_W)
				(if Tables
					(Bld_T_Ph)
					(progn
						(load "Tables")
						(Bld_T_Ph)
					)
				)
			)
			(* SF (nth (atoi (substr lname 8 1)) Lst_Ph_W))
		)
		(T -1)
	)
)

(defun ChkWid ( /	ssPoly Cnt HiC Ent1 Ent2		; Collects Width Data for DoBadWid
				ILst DoI DiDoI TstDef TstSff )
	(setq	ssPoly	(ssget "X"	(list	(cons -4 "<AND")
;											(cons -4 "<OR")
												(cons 0 "POLYLINE")
;												(cons 0 "LWPOLYLINE")
;											(cons -4 "OR>")
											(cons -4 "<OR")
												(cons 8 "???OCK????")
												(cons 8 "???OFL????")
											(cons -4 "OR>")
										(cons -4 "AND>")
								)
					)
			TstDef	(ssget "X" (list (cons 0 "ATTDEF") (cons 8 "----SC----")))
	)
	(if TstDef
		(setq	TstSff	(atoi (cdr (assoc 1 (entget (ssname TstDef 0))))))
		(setq	TstSff	nil)
	)
	(if TstSff
		(setq	sff		TstSff
				sf		(* sff 0.3048)
				Bubba	(princ (strcat "\nScale: " (rtos sff 2 0)))
		)
		(princ "\nNo Scale Found!")
	)
	(if (and ssPoly TstSff)
		(progn
			(setq	Cnt	0
					HiC	(sslength ssPoly)
			)
			(repeat HiC
				(setq	Ent1		(ssname ssPoly Cnt)
						Ent2		(entget Ent1)
						Cnt		(1+ Cnt)
						ILst		(list	(cdr (assoc 8 Ent2))
										(cdr (assoc 40 (entget (entnext Ent1))))
										(GetWidTst (cdr (assoc 8 Ent2)))
										(cdr (assoc 10 (entget (entnext Ent1))))
										(if (assoc 39 Ent2)
											(* (* (cdr (assoc 39 Ent2)) 0.3048) (nth (atoi (substr (cdr (assoc 8 Ent2)) 8 1)) Lst_Ph_W))
											-2
										)
										TstSff
										Ent1
								)
				)
				(if DoI
					(setq	DoI	(cons ILst DoI))
					(setq	DoI	(list ILst))
				)
			)
			(princ (strcat "\nFound " (itoa HiC) " Polylines..."))
			(setq	ssPoly	nil)
		)
		(setq	HiC	nil
				DoI	nil
		)
	)
	(if DoI
		(if (> (length DoI) 1)
			(setq	Cnt		0
					HiC		(length DoI)
					DiDoI	DoI
			)
			(setq	Cnt		nil
					HiC		nil
			)
		)
		(setq	Cnt		nil
				HiC		nil
		)
	)
	;	Cleanup
	(if ssPoly 	(setq ssPoly nil))
 	(if TstDef 	(setq TstDef nil))
	(gc)

	DoI
)

(defun HiBadWid ( DoI /	ILst BLst Fuzz )		; Compares Widths for DoBadWid
	(setq	TstCnt	0
			Fuzz		0.1
	)
	(if DoI
		(foreach	ILst
				DoI
				(if (> (nth 2 ILst) 0)
					(if	(or	(not (equal (nth 1 ILst) (nth 2 ILst) Fuzz))
							(not (equal (nth 1 ILst) (nth 4 ILst) Fuzz))
						)
						(progn
							(redraw (last ILst) 3)
							(setq	TstCnt	(1+ TstCnt))
							(if BLst
								(setq	BLst		(cons ILst BLst))
								(setq	BLst		(list ILst))
							)
						)
					)
				)
		)
	)
	(princ (strcat "\nFound " (itoa TstCnt) " Bad Widths"))
	BLst
)

(defun C:DoBadWid ( /	BadLst DNam BNam		; Circuit Width Reporter for So Div Fix
					ILst ChkLin Fuzz QNam ONam PNam )
	(setq	BadLst	(HiBadWid (ChkWid))
			FixLst	nil
			LayN		nil
			Fuzz		0.2
	)
	(if (not PadCharL)
		(load "UTILS")
	)
	(if BadLst
		(progn
			(setq	DNam		(getvar "DWGNAME"))
			(if (> (strlen DNam) 4)
				(setq	DNam		(substr DNam 1 (- (strlen DNam) 4)))
			)
			(setq	BNam		(open (strcat Div "BadWid.txt") "a")
					ONam		(open (strcat Div "3BadWd.txt") "a")
					PNam		(open (strcat Div "2BadWd.txt") "a")
					QNam		(open (strcat Div "1BadWd.txt") "a")
			)
			(foreach	ILst
					BadLst
					(setq	ChkLin	(strcat	DNam
											"  "
											(nth 0 ILst)
											(PadCharL (rtos (nth 1 ILst) 2 4) 10)
											(PadCharL (rtos (nth 2 ILst) 2 4) 10)
											(PadCharL (rtos (nth 4 ILst) 2 4) 10)
											(PadCharL (rtos (nth 5 ILst) 2 1) 9)
											"  "
											(rtos (car (nth 3 ILst)) 2 4)
											","
											(rtos (cadr (nth 3 ILst)) 2 4)
									)
					)
					(cond
						((= (substr (nth 0 ILst) 8 1) "3")
							(setq	LayN		(strcat (substr (nth 0 ILst) 1 7) "0" (substr (nth 0 ILst) 9)))
							(if (equal (nth 1 ILst) (* 2.0 (nth 4 ILst)) Fuzz)
								(if FixLst
									(setq	FixLst	(BldLayChg FixLst LayN (nth 6 ILst))
											ChkLin	(strcat ChkLin " 3->0")
									)
									(setq	FixLst	(BldLayChg nil LayN (nth 6 ILst))
											ChkLin	(strcat ChkLin " 3->0")
									)
								)
							)
							(write-line ChkLin ONam)
						)
						((= (substr (nth 0 ILst) 8 1) "2")
							(setq	LayN		(strcat (substr (nth 0 ILst) 1 7) "1" (substr (nth 0 ILst) 9)))
							(if (equal (nth 1 ILst) (nth 4 ILst) Fuzz)
								(if FixLst
									(setq	FixLst	(BldLayChg FixLst LayN (nth 6 ILst))
											ChkLin	(strcat ChkLin " 2->1")
									)
									(setq	FixLst	(BldLayChg nil LayN (nth 6 ILst))
											ChkLin	(strcat ChkLin " 2->1")
									)
								)
							)
							(write-line ChkLin PNam)
						)
						((= (substr (nth 0 ILst) 8 1) "1")
							(setq	LayN		(strcat (substr (nth 0 ILst) 1 7) "4" (substr (nth 0 ILst) 9)))
							(if (equal (* 2.0 (nth 1 ILst)) (nth 4 ILst) Fuzz)
								(if FixLst
									(setq	FixLst	(BldLayChg FixLst LayN (nth 6 ILst))
											ChkLin	(strcat ChkLin " 1->4")
									)
									(setq	FixLst	(BldLayChg nil LayN (nth 6 ILst))
											ChkLin	(strcat ChkLin " 1->4")
									)
								)
							)
							(write-line ChkLin QNam)
						)
						(T
							(write-line ChkLin BNam)
						)
					)
			)
			(if BNam (close BNam))
			(if ONam (close ONam))
			(if PNam (close PNam))
			(if QNam (close QNam))
		)
	)
	(if FixLst
		(MakLayChg FixLst)
	)
;;;	(if (> (getvar "DBMOD") 0)
;;;		(progn
;;;			(command "_.QSAVE")
;;;			(princ "\nDoBadWid has saved your changes.")
;;;		)
;;;		(princ "\nDoBadWid - no changes made.")
;;;	)
	(princ)
)

(defun C:DivPret ( / )						; Division Pretend - CL
	(DivPretend nil)
	(princ)
)

(defun DivPretend ( TDiv / )					; Division Pretend sets variables for test
	(if TDiv
		(setq	Div		(strcase TDiv))
		(if (not Div)
			(setq	Div	(strcase (getstring "\nEnter Division Abbreviation: ")))
		)
	)
	(cond
		((or (= Div "BH") (= Div "1"))
			(setq	_Path-Panel	"S:\\WORKGROUPS\\APC Birmingham Division\\DIVISION MAPPING\\ADDS\\Panel\\"
					Div			"BH"
			)
		)
		((or (= Div "E_") (= Div "2"))
			(setq	_Path-Panel	"S:\\WORKGROUPS\\APC Eastern Division\\DIVISION MAPPING\\ADDS\\Panel\\"
					Div			"E_"
			)
		)
		((or (= Div "M_") (= Div "5"))
			(setq	_Path-Panel	"S:\\WORKGROUPS\\APC Mobile Division\\DIVISION MAPPING\\ADDS\\Panel\\"
					Div			"M_"
			)
		)
		((or (= Div "S_") (= Div "3"))
			(setq	_Path-Panel	"S:\\WORKGROUPS\\APC Southern Division\\DIVISION MAPPING\\ADDS\\Panel\\"
					Div			"S_"
			)
		)
		((or (= Div "SE") (= Div "6"))
			(setq	_Path-Panel	"S:\\WORKGROUPS\\APC SouthEast Division\\DIVISION MAPPING\\ADDS\\Panel\\"
					Div			"SE"
			)
		)
		((or (= Div "W_") (= Div "4"))
			(setq	_Path-Panel	"S:\\WORKGROUPS\\APC Western Division\\DIVISION MAPPING\\ADDS\\Panel\\"
					Div			"W_"
			)
		)
		((or (= Div "SH") (= Div "7"))
			(setq	_Path-Panel	"S:\\WORKGROUPS\\APC SouthEast Division\\DIVISION MAPPING\\ADDS\\Panel\\"
					Div			"SH"
			)
		)
		((or (= Div "GA") (= Div "8"))
			(setq	_Path-Panel	"C:\\MapQry\\Adds_GA\\"
					Div			"GA"
			)
		)
		((or (= Div "AL") (= Div "9"))
			(setq	_Path-Panel	"C:\\MapQry\\Adds_AL\\"
					Div			"AL"
			)
		)
		(T
			(setq	_Path-Panel	"S:\\WORKGROUPS\\APC Birmingham Division\\DIVISION MAPPING\\ADDS\\Panel\\"
					Div			"BH"
			)
		)
	)
	(if (not (member Div (list "AL" "GA")))
		(setq	AppNam			"Adds 3.00"
				_Path-LUT			(strcat PrmRootPath "ADDS\\LUT\\")
				_Path-Lisp		(strcat PrmRootPath "ADDS\\LISP\\")
				_Path-Menu		(strcat PrmRootPath "ADDS\\Menu\\")
				_Path-Sym			(strcat PrmRootPath "ADDS\\Sym\\")
				_Path-DLG			(strcat PrmRootPath "Quad\\")
				_Alt_Path-Panel	(strcat PrmRootPath "Shared Panels\\")
		)
	)
	(if (= Div "AL")
		(setq	AppNam			"Adds 3.00"
				_Path-LUT			"C:\\Div_Map\\LookUpTable\\"
				_Path-Lisp		"C:\\Div_Map\\Adds\\Lisp\\"
				_Path-Menu		"C:\\Div_Map\\Adds\\Menu\\"
				_Path-Sym			"C:\\Div_Map\\Adds\\Sym\\"
				_Path-DLG			"C:\\Div_Map\\Quad\\"
				_Alt_Path-Panel	"C:\\MapQry\\Adds_AL\\"
		)
	)
	(if (= Div "GA")
		(setq	AppNam			"Adds 3.00"
				_Path-LUT			"C:\\Div_Map\\LookUpTable\\"
				_Path-Lisp		"C:\\Div_Map\\Adds\\Lisp\\"
				_Path-Menu		"C:\\Div_Map\\Adds\\Menu\\"
				_Path-Sym			"C:\\Div_Map\\Adds\\Sym\\"
				_Path-DLG			"C:\\Div_Map\\Quad\\"
				_Alt_Path-Panel	"C:\\MapQry\\Adds_GA\\"
		)
	)
	(setvar	"USERS3"	Div)
)

(defun WhatIDo ( /	ssAll Ent1 Ent2 EntT EntNex	; Builds data lists (before & after convert)
				Cntr EntGrpLst ELst EntL EntP EntI EntN EntJ1 EntJ2 )
;;;	(setvar "CMDECHO" 0)
;;;	(setvar "FILEDIA" 0)
;;;	(setvar "CMDDIA" 0)
	(princ "\nGathering Info...")
	(command "_.LAYER" "_T" "*" "_ON" "*" "_U" "*" "_S" "0" "" "_.ZOOM" "_E")
	(setq	Cntr		0
			ssAll	(ssget "X")
			EntGrpLst	nil
	)
	(setvar "USERI3" 9)
	(if ssAll
		(repeat (sslength ssAll)
			(setq	Ent1		(ssname ssAll Cntr)
					Ent2		(entget Ent1)
					EntT		(cdr (assoc 0 Ent2))
					Cntr		(1+ Cntr)
					ELst		nil
			)
			(cond	((= EntT "TEXT")
						(setq	EntL		(cdr (assoc 8 Ent2))
								EntP		(cdr (assoc 10 Ent2))
								EntI		(cdr (assoc 11 Ent2))
								EntJ1	(assoc 72 Ent2)
								EntJ2	(assoc 73 Ent2)
						)
						(if EntJ1
							(if (> (cdr EntJ1) 0)
								(setq	ELst		(list EntT EntL EntI 11))
								(if EntJ2
									(if (> (cdr EntJ2) 0)
										(setq	ELst		(list EntT EntL EntI 11))
										(setq	ELst		(list EntT EntL EntP 10))
									)
									(setq	ELst		(list EntT EntL EntP 10))
								)
							)
							(if EntJ2
								(if (> (cdr EntJ2) 0)
									(setq	ELst		(list EntT EntL EntI 11))
									(setq	ELst		(list EntT EntL EntP 10))
								)
								(setq	ELst		(list EntT EntL EntP 10))
							)
						)
					)
					((= EntT "INSERT")
						(setq	EntL		(cdr (assoc 8 Ent2))
								EntN		(cdr (assoc 2 Ent2))
								EntI		(cdr (assoc 10 Ent2))
								ELst		(list EntT EntL EntN EntI)
						)
					)
					((= EntT "POLYLINE")
						(setq	EntL		(cdr (assoc 8 Ent2))
								EntNex	(entnext Ent1)
								ELst		(list EntT EntL)
						)
						(while (/= "SEQEND" (cdr (assoc 0 (entget EntNex))))
							(if (/= "SEQEND" (cdr (assoc 0 (entget EntNex))))
								(setq	ELst		(append ELst (list (cdr (assoc 10 (entget EntNex)))))
										EntNex	(entnext EntNex)
								)
							)
						)
					)
					((= EntT "CIRCLE")
						(setq	EntL		(cdr (assoc 8 Ent2))
								EntR		(cdr (assoc 40 Ent2))
								EntI		(cdr (assoc 10 Ent2))
								ELst		(list EntT EntL EntR EntI)
						)
					)
					(T
						(princ (strcat "\nObject type not handled: " EntT))
					)
			)
			(if ELst
				(if EntGrpLst
					(setq	EntGrpLst		(cons ELst EntGrpLst))
					(setq	EntGrpLst		(list ELst))
				)
			)
		)
	)
	(if EntGrpLst
		(princ (strcat "\nObject data found for " (itoa (length EntGrpLst)) " objects."))
	)
	;	Cleanup
	(if ssAll (setq ssAll nil))
	(gc)
;;;	(setvar "CMDECHO" 1)
;;;	(setvar "FILEDIA" 1)
;;;	(setvar "CMDDIA" 1)
	EntGrpLst
)

(defun WhatIGot ( /	ssAll Ent1 Ent2 EntT	; Builds data lists from current panel
					Cntr EntGrpLst ELst EntL EntP EntI EntN EntNex EntJ1 EntJ2
					GoodLst Itm TxtGot InsGot CirGot PlyGot )
	(princ "\nGathering Info...")
	(command "_.LAYER" "_T" "*" "_ON" "*" "_U" "*" "_S" "0" "" "_.ZOOM" "_E")
	(setq	Cntr		0
			ssAll	(ssget "X")
			EntGrpLst	nil
	)
	(if ssAll
		(repeat (sslength ssAll)
			(setq	Ent1		(ssname ssAll Cntr)
					Ent2		(entget Ent1)
					EntT		(cdr (assoc 0 Ent2))
					Cntr		(1+ Cntr)
					ELst		nil
			)
			(cond	((= EntT "TEXT")
						(setq	EntL		(cdr (assoc 8 Ent2))
								EntP		(cdr (assoc 10 Ent2))
								EntI		(cdr (assoc 11 Ent2))
								EntJ1	(assoc 72 Ent2)
								EntJ2	(assoc 73 Ent2)
						)
						(if EntJ1
							(if (> (cdr EntJ1) 0)
								(setq	ELst		(list EntT EntL EntI 11 Ent1))
								(if EntJ2
									(if (> (cdr EntJ2) 0)
										(setq	ELst		(list EntT EntL EntI 11 Ent1))
										(setq	ELst		(list EntT EntL EntP 10 Ent1))
									)
									(setq	ELst		(list EntT EntL EntP 10 Ent1))
								)
							)
							(if EntJ2
								(if (> (cdr EntJ2) 0)
									(setq	ELst		(list EntT EntL EntI 11 Ent1))
									(setq	ELst		(list EntT EntL EntP 10 Ent1))
								)
								(setq	ELst		(list EntT EntL EntP 10 Ent1))
							)
						)
					)
					((= EntT "INSERT")
						(setq	EntL		(cdr (assoc 8 Ent2))
								EntN		(cdr (assoc 2 Ent2))
								EntI		(cdr (assoc 10 Ent2))
								ELst		(list EntT EntL EntN EntI Ent1)
						)
					)
					((= EntT "POLYLINE")
						(setq	EntL		(cdr (assoc 8 Ent2))
								EntNex	(entnext Ent1)
								ELst		(list EntT EntL Ent1)
						)
						(while (/= "SEQEND" (cdr (assoc 0 (entget EntNex))))
							(if (/= "SEQEND" (cdr (assoc 0 (entget EntNex))))
								(setq	ELst		(append ELst (list (cdr (assoc 10 (entget EntNex)))))
										EntNex	(entnext EntNex)
								)
							)
						)
					)
					((= EntT "CIRCLE")
						(setq	EntL		(cdr (assoc 8 Ent2))
								EntR		(cdr (assoc 40 Ent2))
								EntI		(cdr (assoc 10 Ent2))
								ELst		(list EntT EntL EntR EntI Ent1)
						)
					)
					(T
						(princ (strcat "\nObject type not handled: " EntT))
					)
			)
			(if ELst
				(if EntGrpLst
					(setq	EntGrpLst		(cons ELst EntGrpLst))
					(setq	EntGrpLst		(list ELst))
				)
			)
		)
	)
	(if EntGrpLst
		(princ (strcat "\nObject data found for " (itoa (length EntGrpLst)) " target objects."))
	)
	(if EntGrpLst
		(foreach	Itm
				EntGrpLst
				(cond
					((= (nth 0 Itm) "TEXT")
						(if TxtGot
							(setq	TxtGot	(cons Itm TxtGot))
							(setq	TxtGot	(list Itm))
						)
					)
					((= (nth 0 Itm) "INSERT")
						(if InsGot
							(setq	InsGot	(cons Itm InsGot))
							(setq	InsGot	(list Itm))
						)
					)
					((= (nth 0 Itm) "CIRCLE")
						(if CirGot
							(setq	CirGot	(cons Itm CirGot))
							(setq	CirGot	(list Itm))
						)
					)
					((= (nth 0 Itm) "POLYLINE")
						(if PlyGot
							(setq	PlyGot	(cons Itm PlyGot))
							(setq	PlyGot	(list Itm))
						)
					)
				)
		)
	)
	(setq	GoodLst	(list	(if TxtGot
								TxtGot
								nil
							)
							(if InsGot
								InsGot
								nil
							)
							(if CirGot
								CirGot
								nil
							)
							(if PlyGot
								PlyGot
								nil
							)
					)
	)
	;	Cleanup
	(if ssAll (setq ssAll nil))
	(gc)

	GoodLst
)

(defun CompLst ( Lst1 Lst2 /	Cntr Fuzz GoodLst	; Compares WhatIDo Lists, returns valid items
						InsLst PlyLst CirLst TxtLst Itm Good )
	(setq	Cntr		0
			Fuzz		0.02
			TxtLst	nil
			InsLst	nil
			PlyLst	nil
			CirLst	nil
			GoodLst	nil
	)
	(foreach	Itm
			Lst1
			(setq	Good		nil)
			(cond
				((= (car Itm) "TEXT")
					(if (equal (nth 2 Itm) (nth 2 (nth Cntr Lst2)) Fuzz)
						(setq	Good		(list	(nth 0 Itm)
												(nth 1 Itm)
												(nth 1 (nth Cntr Lst2))
												(nth 2 Itm)
												(nth 3 Itm)
										)
						)
						(princ (strcat "\nText Item " (itoa Cntr) " not equal!"))
					)
					(if Good
						(if (= (nth 1 Good) (nth 2 Good))
							(princ (strcat "\nText Item " (itoa Cntr) " shows same layers!"))
							(if TxtLst
								(setq	TxtLst	(cons Good TxtLst))
								(setq	TxtLst	(list Good))
							)
						)
					)
				)
				((= (car Itm) "INSERT")
					(if (equal (nth 3 Itm) (nth 3 (nth Cntr Lst2)) Fuzz)
						(setq	Good		(list	(nth 0 Itm)
												(nth 1 Itm)
												(nth 1 (nth Cntr Lst2))
												(nth 2 Itm)
												(nth 3 Itm)
										)
						)
						(princ (strcat "\nInsert Item " (itoa Cntr) " not equal!"))
					)
					(if Good
						(if (= (nth 1 Good) (nth 2 Good))
							(princ (strcat "\nInsert Item " (itoa Cntr) " shows same layers!"))
							(if InsLst
								(setq	InsLst	(cons Good InsLst))
								(setq	InsLst	(list Good))
							)
						)
					)
				)
				((= (car Itm) "CIRCLE")
					(if (equal (nth 3 Itm) (nth 3 (nth Cntr Lst2)) Fuzz)
						(setq	Good		(list	(nth 0 Itm)
												(nth 1 Itm)
												(nth 1 (nth Cntr Lst2))
												(nth 2 Itm)
												(nth 3 Itm)
										)
						)
						(princ (strcat "\nCircle Item " (itoa Cntr) " not equal!"))
					)
					(if Good
						(if (= (nth 1 Good) (nth 2 Good))
							(princ (strcat "\nCircle Item " (itoa Cntr) " shows same layers!"))
							(if CirLst
								(setq	CirLst	(cons Good CirLst))
								(setq	CirLst	(list Good))
							)
						)
					)
				)
				((= (car Itm) "POLYLINE")
					(if (equal (nth 2 Itm) (nth 2 (nth Cntr Lst2)) Fuzz)
						(setq	Good		(list	(nth 0 Itm)
												(nth 1 Itm)
												(nth 1 (nth Cntr Lst2))
										)
								Good		(append Good (cdr (cdr Itm)))
						)
						(princ (strcat "\nPolyline Item " (itoa Cntr) " not equal!"))
					)
					(if Good
						(if (= (nth 1 Good) (nth 2 Good))
							(princ (strcat "\nPolyline Item " (itoa Cntr) " shows same layers!"))
							(if PlyLst
								(setq	PlyLst	(cons Good PlyLst))
								(setq	PlyLst	(list Good))
							)
						)
					)
				)
			)
			(setq	Cntr		(1+ Cntr))
			(if Bug
				(princ (strcat "\nItem: " (itoa Cntr)))
			)
	)
	(setq	GoodLst	(list	(if TxtLst
								TxtLst
								nil
							)
							(if InsLst
								InsLst
								nil
							)
							(if CirLst
								CirLst
								nil
							)
							(if PlyLst
								PlyLst
								nil
							)
					)
	)
	GoodLst
)

(defun TxtFind ( Lst1 Tst /	Cntr Itm )		; Finds Text indicated by CompLst
	(setq	Cntr		0)
	(foreach	Itm
			Lst1
			(if (wcmatch (nth 1 Itm) Tst)
				(princ (strcat "\nItem " (itoa Cntr) " contains \"" Tst "\""))
			)
			(setq	Cntr		(1+ Cntr))
	)
	(princ)
)

(defun RepComp ( Lst1 Lst2 /	Cntr Fuzz			; Compares WhatIDo & WhatIGot, performs changes
						TxtGot InsGot CirGot PlyGot FixLst
						TxtRCnt InsRCnt CirRCnt PlyFCnt PlyRCnt PlyUCnt ) ; Itm SNam 
	(setq	TxtGot	(nth 0 Lst2)
			InsGot	(nth 1 Lst2)
			CirGot	(nth 2 Lst2)
			PlyGot	(nth 3 Lst2)
			TxtRCnt	0
			InsRCnt	0
			CirRCnt	0
			PlyFCnt	0
			PlyRCnt	0
			PlyUCnt	0
			FixLst	nil
			Fuzz		0.02
	)
	(if (not DNam)
		(setq	DNam		(strcase (getvar "DWGNAME")))
	)
	(if DNam
		(if (> (strlen DNam) 4)
			(setq	SNam		(substr DNam 1 (- (strlen DNam) 4)))
			(setq	SNam		DNam)
		)
		(setq	SNam		"0000000")
	)
	(if (and TxtGot (nth 0 Lst1))
		(princ (strcat "\nProcessing " (itoa (length (nth 0 Lst1))) " Text Errors"))
	)
	(if (and TxtGot (nth 0 Lst1))
		(foreach	Itm
				(nth 0 Lst1)
				(setq	Good		nil
						Fixd		nil
						Cntr		0
				)
				(while (< Cntr (length TxtGot))
					(setq	Tst	(nth Cntr TxtGot))
					(if	(= (nth 1 Itm) (nth 1 Tst))				; if Current Layer Match
						(if (equal (nth 3 Itm) (nth 2 Tst) Fuzz)	; and Point List Match
							(setq	Good		Cntr)			; then its good to be ReLayered!
						)
						(if	(= (nth 2 Itm) (nth 1 Tst))
							(if (equal (nth 3 Itm) (nth 2 Tst) Fuzz)	; if Fixed Layer Match
								(setq	Good		Cntr				; and Point List Match
										Fixd		T				; then its been Fixed!
								)
							)
						)
					)
					(if Good
						(setq	Cntr		(1+ (length TxtGot)))
						(setq	Cntr		(1+ Cntr))
					)
				)
				(if Good
					(if Fixd
						(setq	OutL		(strcat	(PadCharL SNam 8)
												(PadCharL (nth 0 Itm) 10)
												" ["
												(nth 1 Itm)
												"] ["
												(nth 2 Itm)
												"] "
												(rtos (car (nth 3 Itm)) 2 2)
												","
												(rtos (cadr (nth 3 Itm)) 2 2)
												" Fixed!"
										)
								ONam		(open "RepT0.txt" "a")
								Bubba	(write-line OutL ONam)
								Bubba	(close ONam)
						)
						(setq	OutL		(strcat	(PadCharL SNam 8)
												(PadCharL (nth 0 Itm) 10)
												" ["
												(nth 1 Itm)
												"] ["
												(nth 2 Itm)
												"] "
												(rtos (car (nth 3 Itm)) 2 2)
												","
												(rtos (cadr (nth 3 Itm)) 2 2)
												" ReLayered!"
										)
								TxtRCnt	(1+ TxtRCnt)
								ONam		(open "RepT1.txt" "a")
								FixLst	(BldLayChg FixLst (nth 2 Itm) (last (nth Good TxtGot)))
								Bubba	(write-line OutL ONam)
								Bubba	(close ONam)
						)
					)
					(setq	OutL		(strcat	(PadCharL SNam 8)
											(PadCharL (nth 0 Itm) 10)
											" ["
											(nth 1 Itm)
											"] ["
											(nth 2 Itm)
											"] "
											(rtos (car (nth 3 Itm)) 2 2)
											","
											(rtos (cadr (nth 3 Itm)) 2 2)
											" UnMatched!"
									)
							ONam		(open "RepT2.txt" "a")
							Bubba	(write-line OutL ONam)
							Bubba	(close ONam)
					)
				)
		)
	)
	(if (and InsGot (nth 1 Lst1))
		(princ (strcat "\nProcessing " (itoa (length (nth 1 Lst1))) " Insert Errors"))
	)
	(if (and InsGot (nth 1 Lst1))
		(foreach	Itm
				(nth 1 Lst1)
				(setq	Good		nil
						Fixd		nil
						Cntr		0
				)
				(while (< Cntr (length InsGot))
					(setq	Tst	(nth Cntr InsGot))
					(if	(= (nth 1 Itm) (nth 1 Tst))				; if Current Layer Match
						(if (equal (nth 4 Itm) (nth 3 Tst) Fuzz)	; and Point List Match
							(setq	Good		Cntr)			; then its good to be ReLayered!
						)
						(if	(= (nth 2 Itm) (nth 1 Tst))				; if Fixed Layer Match
							(if (equal (nth 4 Itm) (nth 3 Tst) Fuzz)	; and Point List Match
								(setq	Good		Cntr				; then its been Fixed!
										Fixd		T
								)
							)
						)
					)
					(if Good
						(setq	Cntr		(1+ (length InsGot)))
						(setq	Cntr		(1+ Cntr))
					)
				)
				(if Good
					(if Fixd
						(setq	OutL		(strcat	(PadCharL SNam 8)
												(PadCharL (nth 0 Itm) 10)
												" ["
												(nth 1 Itm)
												"] ["
												(nth 2 Itm)
												"] "
												(rtos (car (nth 4 Itm)) 2 2)
												","
												(rtos (cadr (nth 4 Itm)) 2 2)
												" {"
												(PadCharL (nth 3 Itm) 8)
												"} Fixed!"
										)
								ONam		(open "RepI0.txt" "a")
								Bubba	(write-line OutL ONam)
								Bubba	(close ONam)
						)
						(setq	OutL		(strcat	(PadCharL SNam 8)
												(PadCharL (nth 0 Itm) 10)
												" ["
												(nth 1 Itm)
												"] ["
												(nth 2 Itm)
												"] "
												(rtos (car (nth 4 Itm)) 2 2)
												","
												(rtos (cadr (nth 4 Itm)) 2 2)
												" {"
												(PadCharL (nth 3 Itm) 8)
												"} ReLayered!"
										)
								FixLst	(BldLayChg FixLst (nth 2 Itm) (last (nth Good InsGot)))
								InsRCnt	(1+ InsRCnt)
								ONam		(open "RepI1.txt" "a")
								Bubba	(write-line OutL ONam)
								Bubba	(close ONam)
						)
					)
					(setq	OutL		(strcat	(PadCharL SNam 8)
											(PadCharL (nth 0 Itm) 10)
											" ["
											(nth 1 Itm)
											"] ["
											(nth 2 Itm)
											"] "
											(rtos (car (nth 4 Itm)) 2 2)
											","
											(rtos (cadr (nth 4 Itm)) 2 2)
											" {"
											(PadCharL (nth 3 Itm) 8)
											"} UnMatched!"
									)
							ONam		(open "RepI2.txt" "a")
							Bubba	(write-line OutL ONam)
							Bubba	(close ONam)
					)
				)
		)
	)
	(if (and CirGot (nth 2 Lst1))
		(princ (strcat "\nProcessing " (itoa (length (nth 2 Lst1))) " Circle Errors"))
	)
	(if (and CirGot (nth 2 Lst1))
		(foreach	Itm
				(nth 2 Lst1)
				(setq	Good		nil
						Fixd		nil
						Cntr		0
				)
				(while (< Cntr (length CirGot))
					(setq	Tst	(nth Cntr CirGot))
					(if	(= (nth 1 Itm) (nth 1 Tst))				; if Current Layer Match
						(if (equal (nth 4 Itm) (nth 3 Tst) Fuzz)	; and Point List Match
							(setq	Good		Cntr)			; then its good to be ReLayered!
						)
						(if	(= (nth 2 Itm) (nth 1 Tst))				; if Fixed Layer Match
							(if (equal (nth 4 Itm) (nth 3 Tst) Fuzz)	; and Point List Match
								(setq	Good		Cntr				; then its been Fixed!
										Fixd		T
								)
							)
						)
					)
					(if Good
						(setq	Cntr		(1+ (length CirGot)))
						(setq	Cntr		(1+ Cntr))
					)
				)
				(if Good
					(if Fixd
						(setq	OutL		(strcat	(PadCharL SNam 8)
												(PadCharL (nth 0 Itm) 10)
												" ["
												(nth 1 Itm)
												"] ["
												(nth 2 Itm)
												"] "
												(rtos (car (nth 4 Itm)) 2 2)
												","
												(rtos (cadr (nth 4 Itm)) 2 2)
												" Fixed!"
										)
								ONam		(open "RepC0.txt" "a")
								Bubba	(write-line OutL ONam)
								Bubba	(close ONam)
						)
						(setq	OutL		(strcat	(PadCharL SNam 8)
												(PadCharL (nth 0 Itm) 10)
												" ["
												(nth 1 Itm)
												"] ["
												(nth 2 Itm)
												"] "
												(rtos (car (nth 4 Itm)) 2 2)
												","
												(rtos (cadr (nth 4 Itm)) 2 2)
												" ReLayered!"
										)
								FixLst	(BldLayChg FixLst (nth 2 Itm) (last (nth Good CirGot)))
								CirRCnt	(1+ CirRCnt)
								ONam		(open "RepC1.txt" "a")
								Bubba	(write-line OutL ONam)
								Bubba	(close ONam)
						)
					)
					(setq	OutL		(strcat	(PadCharL SNam 8)
											(PadCharL (nth 0 Itm) 10)
											" ["
											(nth 1 Itm)
											"] ["
											(nth 2 Itm)
											"] "
											(rtos (car (nth 4 Itm)) 2 2)
											","
											(rtos (cadr (nth 4 Itm)) 2 2)
											" UnMatched!"
									)
							ONam		(open "RepC2.txt" "a")
							Bubba	(write-line OutL ONam)
							Bubba	(close ONam)
					)
				)
		)
	)
	(if (and PlyGot (nth 3 Lst1))
		(princ (strcat "\nProcessing " (itoa (length (nth 3 Lst1))) " x " (itoa (length PlyGot)) " PolyLine Errors"))
	)
	(if (and PlyGot (nth 3 Lst1))
		(foreach	Itm
				(nth 3 Lst1)
				(setq	Good		nil
						Fixd		nil
						Cntr		0
				)
				(while (< Cntr (length PlyGot))
					(setq	Tst	(nth Cntr PlyGot))
					(if	(= (nth 1 Itm) (nth 1 Tst))
						(if (PlyPtTst (cdddr Itm) (cdddr Tst) Fuzz)
							(setq	Good		Cntr)
						)
						(if	(= (nth 2 Itm) (nth 1 Tst))
							(if (PlyPtTst (cdddr Itm) (cdddr Tst) Fuzz)
								(setq	Good		Cntr
										Fixd		T
								)
							)
						)
					)
					(if Good
						(setq	Cntr		(1+ (length PlyGot)))
						(setq	Cntr		(1+ Cntr))
					)
				)
				(if Good
					(if Fixd
						(setq	OutL		(strcat	(PadCharL SNam 8)
												(PadCharL (nth 0 Itm) 10)
												" ["
												(nth 1 Itm)
												"] ["
												(nth 2 Itm)
												"] "
												(rtos (car (nth 4 Itm)) 2 2)
												","
												(rtos (cadr (nth 4 Itm)) 2 2)
												" Fixed!"
										)
								ONam		(open "RepP0.txt" "a")
								Bubba	(write-line OutL ONam)
								Bubba	(close ONam)
						)
						(setq	OutL		(strcat	(PadCharL SNam 8)
												(PadCharL (nth 0 Itm) 10)
												" ["
												(nth 1 Itm)
												"] ["
												(nth 2 Itm)
												"] "
												(rtos (car (nth 4 Itm)) 2 2)
												","
												(rtos (cadr (nth 4 Itm)) 2 2)
												" ReLayered!"
										)
								FixLst	(BldLayChg FixLst (nth 2 Itm) (nth 2 (nth Good PlyGot)))
								PlyRCnt	(1+ PlyRCnt)
								ONam		(open "RepP1.txt" "a")
								Bubba	(write-line OutL ONam)
								Bubba	(close ONam)
						)
					)
					(setq	OutL		(strcat	(PadCharL SNam 8)
											(PadCharL (nth 0 Itm) 10)
											" ["
											(nth 1 Itm)
											"] ["
											(nth 2 Itm)
											"] "
											(rtos (car (nth 4 Itm)) 2 2)
											","
											(rtos (cadr (nth 4 Itm)) 2 2)
											" UnMatched!"
									)
							ONam		(open "RepP2.txt" "a")
							Bubba	(write-line OutL ONam)
							Bubba	(close ONam)
					)
				)
		)
	)
	(if TxtRCnt
		(princ (strcat "\nReLayered " (itoa TxtRCnt) " Text Items in Drawing:" SNam))
	)
	(if InsRCnt
		(princ (strcat "\nReLayered " (itoa InsRCnt) " Insert Items in Drawing:" SNam))
	)
	(if CirRCnt
		(princ (strcat "\nReLayered " (itoa CirRCnt) " Circle Items in Drawing:" SNam))
	)
	(if PlyFCnt
		(princ (strcat "\nFixed " (itoa PlyFCnt) " PolyLine Items in Drawing:" SNam))
	)
	(if PlyRCnt
		(princ (strcat "\nReLayered " (itoa PlyRCnt) " PolyLine Items in Drawing:" SNam))
	)
	(if PlyUCnt
		(princ (strcat "\nUnMatched " (itoa PlyUCnt) " PolyLine Items in Drawing:" SNam))
	)
	FixLst
)

(defun C:GetBoth ( / )						; Performs WhatIDo, LayPhChg, WhatIDo, CompLst
	(if DoBoth
		(setq	DoBoth	nil)
	)
	(if (not Div)
		(DivPretend nil)
	)
	(if (not LayPhChg)
		(load "UTILS")
	)
	(if (not Bld_T_Ph)
		(load "Tables")
	)
	(if (not Lst_Fdr_C)
		(Tables)
	)
	(setq	Bubba1	nil
			Bubba2	nil
			WhatThe	nil
			WhatHo	nil
			DNam		nil
			FNam		nil
			Bubba1	(WhatIDo)
	)
	(LayPhChg)
	(setq	Bubba2	(WhatIDo))
	(setq	WhatThe	(CompLst Bubba1 Bubba2))
	(setq	DNam		(strcase (getvar "DWGNAME"))
			FNam		(strcat "c:\\data\\zip\\" DNam)
	)
	(if AutoMat
		(setq	DoCrank	T)
	)
	(RWav 10)
	(if (findfile FNam)
		(if (> (getvar "DBMOD") 0)
			(command "_.OPEN" "Y" FNam)
			(command "_.OPEN" FNam)
		)
	)
;	CompLst returns WhatThe, equivalent to GoodLst
;	WhatThe	=	TxtLst	0	Type
;						1	Old Layer
;						2	New Layer
;						3	Justified/Unjustified Point List
;						4	Group Point taken from (10 or 11)
;				InsLst	0	Type
;						1	Old Layer
;						2	New Layer
;						3	Block Name
;						4	Insertion Point List
;				CirLst	0	Type
;						1	Old Layer
;						2	New Layer
;						3	Radius
;						4	Center Point List
;				PlyLst	0	Type
;						1	Old Layer
;						2	New Layer
;						3	Vertex Point List
;	WhatIGot returns WhatHo, an unfiltered object list
;	RepComp	accepts Whatthe and WhatHo, generates these object lists:
;				TxtGot	0	Type
;						1	Old Layer
;						2	New Layer
;						3	Justified/Unjustified Point List
;						4	Group Point taken from (10 or 11)
;						5	Ename
;				InsGot	0	Type
;						1	Old Layer
;						2	New Layer
;						3	Block Name
;						4	Insertion Point List
;						5	Ename
;				CirGot	0	Type
;						1	Old Layer
;						2	New Layer
;						3	Radius
;						4	Center Point List
;						5	Ename
;				PlyGot	0	Type
;						1	Old Layer
;						2	New Layer
;						3	Vertex Point List
;						4	Unknown length list of vertex points...
;						nth	Ename
	(princ)
)

(defun C:Cranky (	/	Whaf Bubba MyLst )		; Performs WhatIGot, RepComp, MakLayChg
	(if DoCrank
		(setq	DoCrank	nil)
	)
	(if EndLst
		(if (> (length EndLst) 0)
			(setq	Whaf		(strcat "c:\\data\\phased\\" (car EndLst))
					EndLst	(cdr EndLst)
					Bubba	(StatLin StrtNum EndNum)
			)
			(setq	Whaf		nil)
		)
		(setq	Whaf		nil)
	)
	(setq	WhatHo	nil
			WhatHo	(WhatIGot)
			MyLst	nil
			MyLst	(RepComp WhatThe WhatHo)
	)
	(if MyLst
		(MakLayChg MyLst)
	)
	(RWav nil)
	(if Whaf
		(progn
			(if AutoMat
				(setq	DoBoth	T)
			)
			(if (findfile Whaf)
				(if (> (getvar "DBMOD") 0)
					(command "_.OPEN" "N" Whaf)
					(command "_.OPEN" Whaf)
				)
			)
		)
		(if (> (getvar "DBMOD") 0)
			(progn
				(command "_.QSAVE")
				(setq	DoBoth	nil)
			)
			(setq	DoBoth	nil)
		)
	)
	(princ)
)

(defun C:GetNex (	/	Whaf )				; Patch Dwg Stepper
	(setq	Whaf	(getfiled	"Patch Dwg File"
						"c:/data/phased/"
						"dwg"
						0
				)
	)
	(if (findfile Whaf)
		(if (> (getvar "DBMOD") 0)
			(command "_.OPEN" "N" Whaf)
			(command "_.OPEN" Whaf)
		)
	)
	(princ)
)

(defun C:ColPhas ( / )						; Simple Color-By-Phase Layer command
	(command "_.LAYER" "T" "*" "U" "*" "ON" "*" "S" "0" "F" "*" "T" "???O???*" "C" "7" "???O??-0*" "C" "1" "???O??-1*" "C" "2" "???O??-2*" "C" "3" "???O??-3*" "C" "4" "???O??-4*,???O??-5*,???O??-6*" "")
	(princ)
)

(defun PlyPtTst (	Lst1 Lst2 Fuzz /	Flag )	; Checks for union of list of points
	(setq	Flag		nil)
	(foreach	PtALst
			Lst1
			(foreach	PtBLst
					Lst2
					(if (not Flag)
						(if (equal PtALst PtBLst Fuzz)
							(setq	Flag		T)
						)
					)
			)
	)
	Flag
)

(defun BldLayChg ( FixLst LayN EntN /	WrkLst	; Builds Layer Changes List
								Bubba EntI )
	(if (not (LayChk LayN))
		(if FixLst
			(if (nth 0 FixLst)
				(if (not (member LayN (nth 1 FixLst)))
					(setq	FixLst	(list	(append (nth 0 FixLst) (ForceLay LayN))
											(cons LayN (nth 1 FixLst))
											(cons EntN (nth 2 FixLst))
									)
					)
					(setq	FixLst	(list	(nth 0 FixLst)
											(cons LayN (nth 1 FixLst))
											(cons EntN (nth 2 FixLst))
									)
					)
				)
				(if (not (member LayN (nth 1 FixLst)))
					(setq	FixLst	(list	(ForceLay LayN)
											(cons LayN (nth 1 FixLst))
											(cons EntN (nth 2 FixLst))
									)
					)
					(setq	FixLst	(list	nil
											(cons LayN (nth 1 FixLst))
											(cons EntN (nth 2 FixLst))
									)
					)
				)
			)
			(setq	FixLst	(list	(ForceLay LayN)
									(list LayN)
									(list EntN)
							)
			)
		)
		(if FixLst
			(if (nth 0 FixLst)
				(setq	FixLst	(list	(nth 0 FixLst)
										(cons LayN (nth 1 FixLst))
										(cons EntN (nth 2 FixLst))
								)
				)
				(setq	FixLst	(list	nil
										(cons LayN (nth 1 FixLst))
										(cons EntN (nth 2 FixLst))
								)
				)
			)
			(setq	FixLst	(list	nil
									(list LayN)
									(list EntN)
							)
			)
		)
	)
	FixLst
)

(defun MakLayChg (	FixLst /	WrkLst Cntr EntI	; Performs Layer Change List
						EntN LayN Bubba )
	(if (nth 0 FixLst)
		(setq	WrkLst	(nth 0 FixLst))
	)
	(setq	Cntr		0)
	(if WrkLst
		(progn
			(princ (strcat "\nExecuting " (itoa (length WrkLst)) " Layer Changes..."))
			(setq	WrkLst	(cons "" (reverse WrkLst))
					WrkLst	(cons "_.LAYER" (reverse WrkLst))
			)
			(mapcar (quote command) WrkLst)
		)
	)
	(if (and (nth 1 FixLst) (nth 2 FixLst))
		(if (= (length (nth 1 FixLst)) (length (nth 2 FixLst)))
			(foreach	EntN
					(nth 2 FixLst)
					(setq	EntI		(entget EntN)
							LayN		(nth Cntr (nth 1 FixLst))
							Cntr		(1+ Cntr)
					)
					(if EntI
						(if (/= (strcase LayN) (strcase (cdr (assoc 8 EntI))))
							(setq	EntI		(subst	(cons 8 LayN)
													(assoc 8 EntI)
													EntI
											)
									Bubba	(entmod EntI)
							)
						)
					)
					(if EntI
						(if	(or	(= (cdr (assoc 0 EntI)) "INSERT")
								(= (cdr (assoc 0 EntI)) "POLYLINE")
							)
							(entupd EntN)
						)
					)
			)
			(princ "\nFixLst not equal portions!")
		)
		(princ "\nFixLst halves non-existent!")
	)
	(princ)
)

(defun C:GetBadWid ( /	ssPoly Fuzz TstDef		; Fixes Circuit Phase Based on Width!
					TstSff TWid0 TWid1 TWid4 Cnt HiC Ent1 Ent2 PWid PLay F0 F1 F4
					T0 T1 T4 Bubba )
	(setvar	"CMDECHO"	0)
	(command "_.LAYER" "T" "*" "U" "*" "ON" "*" "S" "0" "" "_.ZOOM" "E")
	(setq	ssPoly	(ssget "X"	(list	(cons -4 "<AND")
											(cons 0 "POLYLINE")
											(cons -4 "<OR")
												(cons 8 "???OCK-???")
												(cons 8 "???OFL-???")
											(cons -4 "OR>")
										(cons -4 "AND>")
								)
					)
			FixLst	nil
			Fuzz		1.0
			TstDef	(ssget "X" (list (cons 0 "ATTDEF") (cons 8 "----SC----")))
	)
	(if (not Div)
		(DivPretend nil)
	)
	(princ (strcat "Div:" Div " Dwg:" (strcase (getvar "DWGNAME"))))
	(if (not Lst_Ph_W)
		(progn
			(load "Tables")
			(Tables)
		)
	)
	(if TstDef
		(setq	TstSff	(atoi (cdr (assoc 1 (entget (ssname TstDef 0))))))
		(setq	TstSff	nil)
	)
	(if TstSff
		(setq	sff		TstSff
				sf		(* sff 0.3048)
				TWid0	(* SF (nth 0 Lst_Ph_W))
				TWid1	(* SF (nth 1 Lst_Ph_W))
				TWid4	(* SF (nth 4 Lst_Ph_W))
				Bubba	(princ (strcat "\nScale: " (rtos sff 2 0)))
		)
		(princ "\nNo Scale Found!")
	)
	(if TstSff
		(princ	(strcat	"\nTWid0="	(rtos TWid0 2 4)
						"\nTWid1="	(rtos TWid1 2 4)
						"\nTWid4="	(rtos TWid4 2 4)
				)
		)
	)
	(if (and ssPoly TstSff)
		(progn
			(setq	Cnt		0
					F0		0
					F1		0
					F4		0
					T0		0
					T1		0
					T4		0
					BubLst	nil
					HiC		(sslength ssPoly)
			)
			(repeat HiC
				(setq	Ent1		(ssname ssPoly Cnt)
						Ent2		(entget Ent1)
						PWid		(cdr (assoc 40 (entget (entnext Ent1))))
						PLay		(cdr (assoc 8 Ent2))
						Bubba	nil
						Cnt		(1+ Cnt)
				)
				(if (assoc 39 Ent2)
					(setq	PThk		(cdr (assoc 39 Ent2))
							PWid0	(* (* PThk 0.3048) (nth 0 Lst_Ph_W))
							PWid1	(* (* PThk 0.3048) (nth 1 Lst_Ph_W))
							PWid4	(* (* PThk 0.3048) (nth 4 Lst_Ph_W))
					)
					(setq	PThk		0.0
							PWid0	TWid0
							PWid1	TWid1
							PWid4	TWid4
					)
				)
				(cond
					((equal PWid PWid0 Fuzz)
						(setq	PNew		(strcat	(substr PLay 1 7)
												"0"
												(substr PLay 9 2)
										)
						)
						(if (/= (substr PLay 8 1) "0")
							(if FixLst
								(setq	FixLst	(BldLayChg FixLst PNew Ent1)
										Bubba	(strcat PLay "=>" PNew)
										F0		(1+ F0)
								)
								(setq	FixLst	(BldLayChg nil PNew Ent1)
										Bubba	(strcat PLay "=>" PNew)
										F0		(1+ F0)
								)
							)
							(setq	T0	(1+ T0))
						)
					)
					((equal PWid PWid1 Fuzz)
						(setq	PNew		(strcat	(substr PLay 1 7)
												"1"
												(substr PLay 9 2)
										)
						)
						(if (/= (substr PLay 8 1) "1")
							(if FixLst
								(setq	FixLst	(BldLayChg FixLst PNew Ent1)
										Bubba	(strcat PLay "=>" PNew)
										F1		(1+ F1)
								)
								(setq	FixLst	(BldLayChg nil PNew Ent1)
										Bubba	(strcat PLay "=>" PNew)
										F1		(1+ F1)
								)
							)
							(setq	T1	(1+ T1))
						)
					)
					((equal PWid PWid4 Fuzz)
						(setq	PNew		(strcat	(substr PLay 1 7)
												"4"
												(substr PLay 9 2)
										)
						)
						(if (/= (substr PLay 8 1) "4")
							(if FixLst
								(setq	FixLst	(BldLayChg FixLst PNew Ent1)
										Bubba	(strcat PLay "=>" PNew)
										F4		(1+ F4)
								)
								(setq	FixLst	(BldLayChg nil PNew Ent1)
										Bubba	(strcat PLay "=>" PNew)
										F4		(1+ F4)
								)
							)
							(setq	T4	(1+ T4))
						)
					)
					(T
						(princ (strcat "\nObject " (itoa Cnt) " on layer >" PLay "< Width:" (rtos PWid 2 4) " Thick:" (rtos PThk 2 4) " slipped thru"))
					)
				)
				(if Bubba
					(if BubLst
						(if (not (member Bubba BubLst))
							(setq	BubLst	(cons Bubba BubLst)
									Bubba2	(princ (strcat "\nChange " Bubba))
							)
						)
						(setq	BubLst	(list Bubba)
								Bubba2	(princ (strcat "\nChange " Bubba))
						)
					)
				)
			)
			(princ (strcat "\nFound " (itoa HiC) " Polylines..."))
			(if (> F0 0)
				(princ (strcat "\nFixed " (itoa F0) " 3-Phase Circuits," (itoa T0) " unaffected."))
			)
			(if (> F1 0)
				(princ (strcat "\nFixed " (itoa F1) " 2-Phase Circuits," (itoa T1) " unaffected."))
			)
			(if (> F4 0)
				(princ (strcat "\nFixed " (itoa F4) " 1-Phase Circuits," (itoa T4) " unaffected."))
			)
			(setq	ssPoly	nil)
		)
	)
	(if FixLst
		(progn
			(MakLayChg FixLst)
			(command "_.QSAVE")
		)
	)
	;	Cleanup
	(if ssPoly 	(setq ssPoly nil))
	(if TstDef	(setq TstDef nil))
	(gc)
	
	(princ)
)

(defun RepLst ( Lst New Num / LLen NLst Cnt )	; Replace in List function
	(if Lst
		(if (= (type Lst) (quote LIST))
			(setq	LLen	(length Lst))
			(setq	LLen	nil)
		)
		(setq	LLen	nil)
	)
	(if (and LLen New Num)
		(cond	((= Num 0)
					(setq	NLst	(cdr Lst)
							NLst	(append (list New) NLst)
					)
				)
				((= Num (1- LLen))
					(setq	NLst	(reverse (cdr (reverse Lst)))
							NLst	(append NLst (list New))
					)
				)
				((and (> Num 0) (< Num LLen))
					(setq	NLst	(list (car Lst))
							Cnt		1
					)
					(repeat (1- Num)
						(setq	NLst	(append NLst (list (nth Cnt Lst)))
								Cnt		(1+ Cnt)
						)
					)
					(setq	NLst	(append NLst (list New))
							Cnt		(1+ Cnt)
					)
					(repeat (1- (- LLen Num))
						(setq	NLst	(append NLst (list (nth Cnt Lst)))
								Cnt		(1+ Cnt)
						)
					)
				)
				(T
					(setq	NLst	Lst)
				)
		)
		(setq	NLst	Lst)
	)
	NLst
)

(defun LodMarkR ( Whuf /	LodNamLst			; Loaded Lisp & Arx File ListUpdater
						LodPos LodGet )
	(if Bug (princ "\n{ LodMarkR Entered"))
	(if LodLst
		(setq	LodNamLst		(mapcar (quote car) LodLst))
	)
	(if (and LodNamLst Whuf)
		(if (member (strcase Whuf) (mapcar (quote strcase) LodNamLst))
			(setq	LodPos		(-	(length LodNamLst)
									(length (member (strcase Whuf) (mapcar (quote strcase) LodNamLst)))
								)
					LodNamLst		(RemNumLst LodPos LodNamLst)
					LodLst		(RemNumLst LodPos LodLst)
			)
		)
	)
	(setq	LodGet	(LodStage Whuf))
	(if LodGet
		(if LodLst
			(setq	LodLst	(cons LodGet LodLst)
					Bubba	(if Bug (princ (strcat "\nBug: LodMarkR loads {" (car LodGet) "}\n")))
			)
			(setq	LodLst	(list (list LodGet))
					Bubba	(if Bug (princ (strcat "\nBug: LodMarkR loads {" (car LodGet) "}\n")))
			)
		)
	)
	(if Bug (princ "\n{ LodMarkR Exited"))
	LodGet
)
;;;	ReadListFile - Purpose to read command file and pass back a list of command for batch plotting.
(defun ReadListFile (FileName / scrfile tmpList ln)
	(if Bug 
		(progn
			(princ "\n Acad.lsp ReadCmdFile - Entered\n   Parameter FileName: ")
			(prin1 FileName)
			(princ "\n")
		)
	)
	(setq tmpList (list))
	(if (findfile FileName)
		(if (setq scrfile (open FileName "R"))
			(progn
				(while (setq ln (read-line scrfile))
					(setq tmpList (cons (read ln) tmpList))
				)
				(close scrfile)
			)
		)
	)
	(if Bug 
		(progn
			(princ "\n Acad.Lsp!ReadListFile - Done\n")
			(setq tmpList (reverse tmpList))
			(princ tmpList)
		)
		(reverse tmpList)
	)
)


(defun LodStage2 (LispFile / application path paths foundFlag )
	(if Bug 
		(progn
			(princ "\n Acad.Lsp!LodStage2 - Entered\n   Parameter LispFile: ")
			(prin1 LispFile)
			(princ "\n")
		)
	)
	(setq	application (StpDot AppNam)
			foundFlag	nil
	)
	;	Check for Application to determine source of search paths to read.
	(cond 
		((= application "ADDS")
			(setq    paths 	(ReadListFile "C:/Div_Map/Adds/FilePathsLisp.txt"))
		)
		((= application "ADDSPLOT")
			(setq    paths 	(ReadListFile "C:/Div_Map/AddsPlot/FilePathsLisp.txt"))
		)
		((= application "CADET")
			(setq    paths 	(ReadListFile "C:/Div_Map/Cadet/FilePathsLisp.txt"))
		)
	)
	(if paths
		;	For each path found start to look for passed in LispFile name if found load it into AutoCAD
		(foreach path paths
			(if	(or 	(and DevMark 		(or (= (nth 1 path) 7) 	(= (nth 1 path) 8) 	(= (nth 1 path) 9)))
					(and (not DevMark) 	(or (= (nth 1 path) 10) 	(= (nth 1 path) 11) (= (nth 1 path) 12)))
				)
				(setq processFlag nil)
				(setq processFlag T)
			)
			(cond
				((and (not foundFlag) processFlag ( findfile (strcat (nth 1 path) "\\" LispFile ".arx")))
					(if (member (strcase (strcat LispFile ".Arx") T))
						(arxunload (strcase (strcat LispFile ".Arx") T) (arx))
					)
					(setq	LodLev	(nth 0 path)
							LodVer	(arxload (strcat (nth 1 path) "\\" LispFile ".arx"))
							foundFlag T
					)
				)
				((and (not foundFlag) processFlag ( findfile (strcat (nth 1 path) "\\" LispFile ".lsp")))
					(setq	LodLev	(nth 0 path)
							LodVer	(load (strcat (nth 1 path) "\\" LispFile ".lsp"))
							foundFlag T
					)
				)
				((and (not foundFlag) processFlag ( findfile (strcat (nth 1 path) "\\" LispFile ".vlx")))
					(setq	LodLev	(nth 0 path)
							LodVer	(load (strcat (nth 1 path) "\\" LispFile ".vlx"))
							foundFlag T
					)
				)
			)
		)
		(alert (strcat "***" AppNam " Error ***\nAcad.lsp!LodStage2 cannot find paths for checking locations of files to load."))
	)
	;	Used in debugging checks to find where file was loaded from base on LodLev variable.
	(if Bug
		(if (and LispFile LodLev LodVer)
			(cond
				((= (type LodVer) (quote STR))
					(princ (strcat "\nBug:LodStage2=" LispFile ":" (itoa LodLev) ":" LodVer))
				)
				((= (type LodVer) (quote REAL))
					(princ (strcat "\nBug:LodStage2=" LispFile ":" (itoa LodLev) ":" (rtos LodVer 2 4)))
				)
				((= (type LodVer) (quote INT))
					(princ (strcat "\nBug:LodStage2=" LispFile ":" (itoa LodLev) ":" (itoa LodVer)))
				)
				(T
					(princ (strcat "\nBug:LodStage2=" LispFile ":" (itoa LodLev) ":Unknown Type"))
				)
			)
			(princ "\nMissing some load data!")
		)
	)
	(if Bug (princ "\n{Acad.Lsp!LodStage2 - Done\n"))
	(list LispFile LodLev LodVer)
)

(defun LodStage ( Whuf /	Loded LodLev )		; Staged Lisp & Arx File Loader
	(if Bug (princ "\n{ LodStage Entered"))

;;;	FileTypes:	Arx
;;;				Lsp
;;;				Vlx
;;;
;;;	RootPaths:	Root
;;;				Root\\%AppNam%\\Lisp
;;;				Root\\Common
;;;				Root\\ADDS\\User
;;;
;;;	LodLevs:		"C:\\DIV_MAP\\"
;;;				"H:\\DIV_MAP\\"
;;;				"S:\\Workgroups\\APC Power Delivery\\Division Mapping Test\\"
;;;				"S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMapRC\\"
;;;				"S:\\Workgroups\\APC Power Delivery\\Division Mapping\\"
;;;				"S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\"
;;;
;;;	(if DevMark		;Test!
;;;		(if AppNam	
;;;			(cond	;Test & AppNam!
;;;			)
;;;			(cond	;Test & Vanilla!
;;;			)
;;;		)
;;;		(if AppNam
;;;			(cond	;Prod & AppNam!
;;;			)
;;;			(cond	;Prod & Vanilla!
;;;			)
;;;		)
;;;	)

	(if DevMark
		(if AppNam
			(cond
				((findfile (strcat "C:\\DIV_MAP\\Common\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	0
							Loded	(arxload (strcat "C:\\DIV_MAP\\Common\\" Whuf ".arx"))
					)
				)
				((findfile (strcat "C:\\DIV_MAP\\Common\\" Whuf ".lsp"))
					(setq	LodLev	0
							LodVer	(load (strcat "C:\\DIV_MAP\\Common\\" Whuf ".lsp"))
					)
				)
				((findfile (strcat "C:\\DIV_MAP\\Common\\" Whuf ".vlx"))
					(setq	LodLev	0
							LodVer	(load (strcat "C:\\DIV_MAP\\Common\\" Whuf ".vlx"))
					)
				)
				((findfile (strcat "C:\\DIV_MAP\\" (StpDot AppNam) "\\LISP\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	1
							Loded	(arxload (strcat "C:\\DIV_MAP\\" (StpDot AppNam) "\\LISP\\" Whuf ".arx"))
					)
				)
				((findfile (strcat "C:\\DIV_MAP\\" (StpDot AppNam) "\\LISP\\" Whuf ".lsp"))
					(setq	LodLev	1
							LodVer	(load (strcat "C:\\DIV_MAP\\" (StpDot AppNam) "\\LISP\\" Whuf ".lsp"))
					)
				)
				((findfile (strcat "C:\\DIV_MAP\\" (StpDot AppNam) "\\LISP\\" Whuf ".vlx"))
					(setq	LodLev	1
							LodVer	(load (strcat "C:\\DIV_MAP\\" (StpDot AppNam) "\\LISP\\" Whuf ".vlx"))
					)
				)
				((findfile (strcat "H:\\DIV_MAP\\Common\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	2
							Loded	(arxload (strcat "H:\\DIV_MAP\\Common\\" Whuf ".arx"))
					)
				)
				((findfile (strcat "H:\\DIV_MAP\\Common\\" Whuf ".lsp"))
					(setq	LodLev	2
							LodVer	(load (strcat "H:\\DIV_MAP\\Common\\" Whuf ".lsp"))
					)
				)
				((findfile (strcat "H:\\DIV_MAP\\Common\\" Whuf ".vlx"))
					(setq	LodLev	2
							LodVer	(load (strcat "H:\\DIV_MAP\\Common\\" Whuf ".vlx"))
					)
				)
				((findfile (strcat "H:\\DIV_MAP\\" (StpDot AppNam) "\\LISP\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	3
							Loded	(arxload (strcat "H:\\DIV_MAP\\" (StpDot AppNam) "\\LISP\\" Whuf ".arx"))
					)
				)
				((findfile (strcat "H:\\DIV_MAP\\" (StpDot AppNam) "\\LISP\\" Whuf ".vlx"))
					(setq	LodLev	3
							LodVer	(load (strcat "H:\\DIV_MAP\\" (StpDot AppNam) "\\LISP\\" Whuf ".vlx"))
					)
				)
				((findfile (strcat "H:\\DIV_MAP\\" (StpDot AppNam) "\\LISP\\" Whuf ".lsp"))
					(setq	LodLev	3
							LodVer	(load (strcat "H:\\DIV_MAP\\" (StpDot AppNam) "\\LISP\\" Whuf ".lsp"))
					)
				)			   
				((findfile (strcat PrmRootPath "Common\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	4
							Loded	(arxload (strcat PrmRootPath "Common\\" Whuf ".arx"))
					)
				)
				((findfile (strcat PrmRootPath "Common\\" Whuf ".lsp"))
					(setq	LodLev	4
							LodVer	(load (strcat PrmRootPath "Common\\" Whuf ".lsp"))
					)
				)
				((findfile (strcat PrmRootPath "Common\\" Whuf ".vlx"))
					(setq	LodLev	4
							LodVer	(load (strcat PrmRootPath "Common\\" Whuf ".vlx"))
					)
				)
				((findfile (strcat PrmRootPath (StpDot AppNam) "\\LISP\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	5
							Loded	(arxload (strcat PrmRootPath (StpDot AppNam) "\\LISP\\" Whuf ".arx"))
					)
				)
				((findfile (strcat PrmRootPath (StpDot AppNam) "\\LISP\\" Whuf ".vlx"))
					(setq	LodLev	5
							LodVer	(load (strcat PrmRootPath (StpDot AppNam) "\\LISP\\" Whuf ".vlx"))
					)
				)
				((findfile (strcat PrmRootPath (StpDot AppNam) "\\LISP\\" Whuf ".lsp"))
					(setq	LodLev	5
							LodVer	(load (strcat PrmRootPath (StpDot AppNam) "\\LISP\\" Whuf ".lsp"))
					)
				)
				((findfile (strcat TestPrmRootPath "Common\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	4
							Loded	(arxload (strcat TestPrmRootPath "Common\\" Whuf ".arx"))
					)
				)
				((findfile (strcat TestPrmRootPath "Common\\" Whuf ".lsp"))
					(setq	LodLev	4
							LodVer	(load (strcat TestPrmRootPath "Common\\" Whuf ".lsp"))
					)
				)
				((findfile (strcat TestPrmRootPath "Common\\" Whuf ".vlx"))
					(setq	LodLev	4
							LodVer	(load (strcat TestPrmRootPath "Common\\" Whuf ".vlx"))
					)
				)
				((findfile (strcat TestPrmRootPath (StpDot AppNam) "\\LISP\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	5
							Loded	(arxload (strcat TestPrmRootPath (StpDot AppNam) "\\LISP\\" Whuf ".arx"))
					)
				)
				((findfile (strcat TestPrmRootPath (StpDot AppNam) "\\LISP\\" Whuf ".vlx"))
					(setq	LodLev	5
							LodVer	(load (strcat TestPrmRootPath (StpDot AppNam) "\\LISP\\" Whuf ".vlx"))
					)
				)
				((findfile (strcat TestPrmRootPath (StpDot AppNam) "\\LISP\\" Whuf ".lsp"))
					(setq	LodLev	5
							LodVer	(load (strcat TestPrmRootPath (StpDot AppNam) "\\LISP\\" Whuf ".lsp"))
					)
				)
				((findfile (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\Common\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	6
							Loded	(arxload (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\Common\\" Whuf ".arx"))
					)
				)
				((findfile (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\Common\\" Whuf ".vlx"))
					(setq	LodLev	6
							LodVer	(load (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\Common\\" Whuf ".vlx"))
					)
				)
				((findfile (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\Common\\" Whuf ".lsp"))
					(setq	LodLev	6
							LodVer	(load (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\Common\\" Whuf ".lsp"))
					)
				)
				((findfile (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\" (StpDot AppNam) "\\LISP\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	7
							Loded	(arxload (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\" (StpDot AppNam) "\\LISP\\" Whuf ".arx"))
					)
				)
				((findfile (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\" (StpDot AppNam) "\\LISP\\" Whuf ".vlx"))
					(setq	LodLev	7
							LodVer	(load (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\" (StpDot AppNam) "\\LISP\\" Whuf ".vlx"))
					)
				)
				((findfile (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\" (StpDot AppNam) "\\LISP\\" Whuf ".lsp"))
					(setq	LodLev	7
							LodVer	(load (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\" (StpDot AppNam) "\\LISP\\" Whuf ".lsp"))
					)
				) 
				((findfile (strcat PrmRootPath "Common\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	8
							Loded	(arxload (strcat PrmRootPath "Common\\" Whuf ".arx"))
					)
				)
				((findfile (strcat PrmRootPath "Common\\" Whuf ".lsp"))
					(setq	LodLev	8
							LodVer	(load (strcat PrmRootPath "Common\\" Whuf ".lsp"))
					)
				)
				((findfile (strcat PrmRootPath "Common\\" Whuf ".vlx"))
					(setq	LodLev	8
							LodVer	(load (strcat PrmRootPath "Common\\" Whuf ".vlx"))
					)
				)
				((findfile (strcat PrmRootPath (StpDot AppNam) "\\LISP\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	9
							Loded	(arxload (strcat PrmRootPath (StpDot AppNam) "\\LISP\\" Whuf ".arx"))
					)
				)
				((findfile (strcat PrmRootPath (StpDot AppNam) "\\LISP\\" Whuf ".lsp"))
					(setq	LodLev	9
							LodVer	(load (strcat PrmRootPath (StpDot AppNam) "\\LISP\\" Whuf ".lsp"))
					)
				)
				((findfile (strcat PrmRootPath (StpDot AppNam) "\\LISP\\" Whuf ".vlx"))
					(setq	LodLev	9
							LodVer	(load (strcat PrmRootPath (StpDot AppNam) "\\LISP\\" Whuf ".vlx"))
					)
				)
				((findfile (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\" (StpDot AppNam) "\\User\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	10
							Loded	(arxload (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\" (StpDot AppNam) "\\User\\" Whuf ".arx"))
					)
				)
				((findfile (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\" (StpDot AppNam) "\\User\\" Whuf ".lsp"))
					(setq	LodLev	10
							LodVer	(load (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\" (StpDot AppNam) "\\User\\" Whuf ".lsp"))
					)
				)
				((findfile (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\" (StpDot AppNam) "\\User\\" Whuf ".vlx"))
					(setq	LodLev	10
							LodVer	(load (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\" (StpDot AppNam) "\\User\\" Whuf ".vlx"))
					)
				)
				((findfile (strcat TestPrmRootPath  (StpDot AppNam) "\\User\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	10
							Loded	(arxload (strcat TestPrmRootPath (StpDot AppNam) "\\User\\" Whuf ".arx"))
					)
				)
				((findfile (strcat TestPrmRootPath (StpDot AppNam) "\\User\\" Whuf ".lsp"))
					(setq	LodLev	10
							LodVer	(load (strcat TestPrmRootPath (StpDot AppNam) "\\User\\" Whuf ".lsp"))
					)
				)
				((findfile (strcat TestPrmRootPath (StpDot AppNam) "\\User\\" Whuf ".vlx"))
					(setq	LodLev	10
							LodVer	(load (strcat TestPrmRootPath (StpDot AppNam) "\\User\\" Whuf ".vlx"))
					)
				)
				((findfile (strcat _Path-User Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	10
							Loded	(arxload (strcat _Path-User Whuf ".arx"))
					)
				)
				((findfile (strcat _Path-User Whuf ".lsp"))
					(setq	LodLev	10
							LodVer	(load (strcat _Path-User Whuf ".lsp"))
					)
				)
				((findfile (strcat _Path-User Whuf ".vlx"))
					(setq	LodLev	10
							LodVer	(load (strcat _Path-User Whuf ".vlx"))
					)
				)
				((or (= (StpDot AppNam) "ADDSPLOT") (= (StpDot AppNam) "ADDS"))
					(if (findfile (strcat PrmRootPath "Adds\\User\\" Whuf ".arx"))
						(progn
							(if (member (strcase (strcat Whuf ".Arx") T) (arx))
								(arxunload (strcase (strcat Whuf ".Arx") T))
							)
							(setq	LodLev	10
									Loded	(arxload (strcat PrmRootPath "Adds\\User\\" Whuf ".arx"))
							)
						)
						(if (findfile (strcat PrmRootPath "User\\" Whuf ".lsp"))
							(setq	LodLev	10
									LodVer	(load (strcat PrmRootPath "Adds\\User\\" Whuf ".lsp"))
							)
							(if (findfile (strcat PrmRootPath "Adds\\User\\" Whuf ".vlx"))
								(setq	LodLev	10
										LodVer	(load (strcat PrmRootPath "Adds\\User\\" Whuf ".vlx"))
								)
								(alert (strcat "*" AppNam " Test Warning!*\nLaunch code not found!\nCheck network paths!"))
							)
						)
					)
				)
				((or	(findfile (strcat PrmRootPath "Adds\\User\\" Whuf ".lsp"))
					(findfile (strcat PrmRootPath "Adds\\User\\" Whuf ".vlx"))
					(findfile (strcat PrmRootPath "Adds\\User\\" Whuf ".arx"))
				 )
					(if (findfile (strcat PrmRootPath "Adds\\User\\" Whuf ".arx"))
						(progn
							(if (member (strcase (strcat Whuf ".Arx") T) (arx))
								(arxunload (strcase (strcat Whuf ".Arx") T))
							)
							(setq	LodLev	11
									Loded	(arxload (strcat PrmRootPath "Adds\\User\\" Whuf ".arx"))
							)
						)
						(if (findfile (strcat PrmRootPath "Adds\\User\\" Whuf ".lsp"))
							(setq	LodLev	11
									LodVer	(load (strcat PrmRootPath "Adds\\User\\" Whuf ".lsp"))
							)
							(if (findfile (strcat PrmRootPath "Adds\\User\\" Whuf ".vlx"))
								(setq	LodLev	11
										LodVer	(load (strcat PrmRootPath "Adds\\User\\" Whuf ".vlx"))
								)
								(alert (strcat "*" AppNam " Test Warning!*\nLaunch code not found!\nCheck network paths!"))
							)
						)
					)
				)
				((or	(findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".lsp"))
					(findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".vlx"))
					(findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".arx"))
				 )
					(if (findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".arx"))
						(progn
							(if (member (strcase (strcat Whuf ".Arx") T) (arx))
								(arxunload (strcase (strcat Whuf ".Arx") T))
							)
							(setq	LodLev	12
									Loded	(arxload (strcat TestPrmRootPath "Adds\\User\\" Whuf ".arx"))
							)
						)
						(if (findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".lsp"))
							(setq	LodLev	12
									LodVer	(load (strcat TestPrmRootPath "Adds\\User\\" Whuf ".lsp"))
							)
							(if (findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".vlx"))
								(setq	LodLev	12
										LodVer	(load (strcat TestPrmRootPath "Adds\\User\\" Whuf ".vlx"))
								)
								(alert (strcat "*" AppNam " Test Warning!*\nLaunch code not found!\nCheck network paths!"))
							)
						)
					)
				)
				((or	(findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".lsp"))
					(findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".vlx"))
					(findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".arx"))
				 )
					(if (findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".arx"))
						(progn
							(if (member (strcase (strcat Whuf ".Arx") T) (arx))
								(arxunload (strcase (strcat Whuf ".Arx") T))
							)
							(setq	LodLev	13
									Loded	(arxload (strcat TestPrmRootPath "Adds\\User\\" Whuf ".arx"))
							)
						)
						(if (findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".lsp"))
							(setq	LodLev	13
									LodVer	(load (strcat TestPrmRootPath "Adds\\User\\" Whuf ".lsp"))
							)
							(if (findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".vlx"))
								(setq	LodLev	13
										LodVer	(load (strcat TestPrmRootPath "Adds\\User\\" Whuf ".vlx"))
								)
								(alert (strcat "*" AppNam " Test Warning!*\nLaunch code not found!\nCheck network paths!"))
							)
						)
					)
				)
				(T
					(alert (strcat "*" AppNam " Test Warning!*\nLaunch code not found!\nCheck network paths!"))
				)
			)
			(cond
				((findfile (strcat "C:\\DIV_MAP\\Common\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	0
							Loded	(arxload (strcat "C:\\DIV_MAP\\Common\\" Whuf ".arx"))
					)
				)
				((findfile (strcat "C:\\DIV_MAP\\Common\\" Whuf ".lsp"))
					(setq	LodLev	0
							LodVer	(load (strcat "C:\\DIV_MAP\\Common\\" Whuf ".lsp"))
					)
				)
				((findfile (strcat "C:\\DIV_MAP\\Common\\" Whuf ".vlx"))
					(setq	LodLev	0
							LodVer	(load (strcat "C:\\DIV_MAP\\Common\\" Whuf ".vlx"))
					)
				)
				((findfile (strcat "H:\\DIV_MAP\\Common\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	2
							Loded	(arxload (strcat "H:\\DIV_MAP\\Common\\" Whuf ".arx"))
					)
				)
				((findfile (strcat "H:\\DIV_MAP\\Common\\" Whuf ".lsp"))
					(setq	LodLev	3
							LodVer	(load (strcat "H:\\DIV_MAP\\Common\\" Whuf ".lsp"))
					)
				)
				((findfile (strcat "H:\\DIV_MAP\\Common\\" Whuf ".vlx"))
					(setq	LodLev	3
							LodVer	(load (strcat "H:\\DIV_MAP\\Common\\" Whuf ".vlx"))
					)
				)
				((findfile (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\Common\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	4
							Loded	(arxload (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\Common\\" Whuf ".arx"))
					)
				)
				((or (findfile (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\Common\\" Whuf ".lsp")) (findfile (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\Common\\" Whuf ".vlx")))
					(setq	LodLev	4
							LodVer	(load (strcat "S:\\Workgroups\\SCS Information Resources\\AppSvcs\\APC_Projects\\DivMap10\\Common\\" Whuf))
					)
				)
				((findfile (strcat TestPrmRootPath "Common\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	6
							Loded	(arxload (strcat TestPrmRootPath "Common\\" Whuf ".arx"))
					)
				)
				((or (findfile (strcat TestPrmRootPath "Common\\" Whuf ".lsp")) (findfile (strcat TestPrmRootPath "Common\\" Whuf ".vlx")))
					(setq	LodLev	6
							LodVer	(load (strcat TestPrmRootPath "Common\\" Whuf))
					)
				)
				((findfile (strcat PrmRootPath "Common\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	8
							Loded	(arxload (strcat PrmRootPath "Common\\" Whuf ".arx"))
					)
				)
				((or (findfile (strcat PrmRootPath "Common\\" Whuf ".lsp")) (findfile (strcat PrmRootPath "Common\\" Whuf ".vlx")))
					(setq	LodLev	8
							LodVer	(load (strcat PrmRootPath "Common\\" Whuf))
					)
				)
				((findfile (strcat _Path-User Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	10
							Loded	(arxload (strcat _Path-User Whuf ".arx"))
					)
				)
				((or (findfile (strcat _Path-User Whuf ".lsp")) (findfile (strcat _Path-User Whuf ".vlx")))
					(setq	LodLev	10
							LodVer	(load (strcat _Path-User Whuf))
					)
				)
				((or	(findfile (strcat PrmRootPath "Adds\\User\\" Whuf ".lsp"))
					(findfile (strcat PrmRootPath "Adds\\User\\" Whuf ".vlx"))
					(findfile (strcat PrmRootPath "Adds\\User\\" Whuf ".arx"))
				 )
					(if (findfile (strcat PrmRootPath "Adds\\User\\" Whuf ".arx"))
						(progn
							(if (member (strcase (strcat Whuf ".Arx") T) (arx))
								(arxunload (strcase (strcat Whuf ".Arx") T))
							)
							(setq	LodLev	11
									Loded	(arxload (strcat PrmRootPath "Adds\\User\\" Whuf ".arx"))
							)
						)
						(if (or (findfile (strcat PrmRootPath "Adds\\User\\" Whuf ".lsp")) (findfile (strcat PrmRootPath "ADDS\\User\\" Whuf ".vlx")))
							(setq	LodLev	11
									LodVer	(load (strcat PrmRootPath "Adds\\User\\" Whuf))
							)
							(alert (strcat "*" AppNam " Test Warning!*\nLaunch code not found!\nCheck network paths!"))
						)
					)
				)
				((or	(findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".lsp"))
					(findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".vlx"))
					(findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".arx"))
				 )
					(if (findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".arx"))
						(progn
							(if (member (strcase (strcat Whuf ".Arx") T) (arx))
								(arxunload (strcase (strcat Whuf ".Arx") T))
							)
							(setq	LodLev	12
									Loded	(arxload (strcat TestPrmRootPath "Adds\\User\\" Whuf ".arx"))
							)
						)
						(if (or (findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".lsp")) (findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".vlx")))
							(setq	LodLev	12
									LodVer	(load (strcat TestPrmRootPath "Adds\\User\\" Whuf))
							)
							(alert (strcat "*" AppNam " Test Warning!*\nLaunch code not found!\nCheck network paths!"))
						)
					)
				)
				((or	(findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".lsp"))
					(findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".vlx"))
					(findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".arx"))
				 )
					(if (findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".arx"))
						(progn
							(if (member (strcase (strcat Whuf ".Arx") T) (arx))
								(arxunload (strcase (strcat Whuf ".Arx") T))
							)
							(setq	LodLev	13
									Loded	(arxload (strcat TestPrmRootPath "Adds\\User\\" Whuf ".arx"))
							)
						)
						(if (or (findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".lsp")) (findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".vlx")))
							(setq	LodLev	13
									LodVer	(load (strcat TestPrmRootPath "Adds\\User\\" Whuf))
							)
							(alert (strcat "*" AppNam " Test Warning!*\nLaunch code not found!\nCheck network paths!"))
						)
					)
				)
				(T
					(alert "*Test Warning!*\nLaunch code not found!\nCheck network paths!")
				)
			)
		)
		(if AppNam
			(cond
				((findfile (strcat PrmRootPath "Common\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	8
							Loded	(arxload (strcat PrmRootPath "Common\\" Whuf ".arx"))
					)
				)
				((or (findfile (strcat PrmRootPath "Common\\" Whuf ".lsp")) 
					(findfile (strcat PrmRootPath "Common\\" Whuf ".vlx")))
					(setq	LodLev	8
							LodVer	(load (strcat PrmRootPath "Common\\" Whuf))
					)
				)
				((findfile (strcat PrmRootPath (StpDot AppNam) "\\LISP\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	9
							Loded	(arxload (strcat PrmRootPath (StpDot AppNam) "\\LISP\\" Whuf ".arx"))
					)
				)
				((or (findfile (strcat PrmRootPath (StpDot AppNam) "\\LISP\\" Whuf ".lsp")) (findfile (strcat PrmRootPath (StpDot AppNam) "\\LISP\\" Whuf ".vlx")))
					(setq	LodLev	9
							LodVer	(load (strcat PrmRootPath (StpDot AppNam) "\\LISP\\" Whuf))
					)
				)
				((findfile (strcat PrmRootPath (StpDot AppNam) "\\User\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	10
							Loded	(arxload (strcat PrmRootPath (StpDot AppNam) "\\User\\" Whuf ".arx"))
					)
				)
				((or (findfile (strcat PrmRootPath (StpDot AppNam) "\\User\\" Whuf ".lsp")) (findfile (strcat PrmRootPath (StpDot AppNam) "\\User\\" Whuf ".vlx")))
					(setq	LodLev	10
							LodVer	(load (strcat PrmRootPath (StpDot AppNam) "\\User\\" Whuf))
					)
				)
				((findfile (strcat _Path-User Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	10
							Loded	(arxload (strcat _Path-User Whuf ".arx"))
					)
				)
				((or (findfile (strcat _Path-User Whuf ".lsp")) (findfile (strcat _Path-User Whuf ".vlx")))
					(setq	LodLev	10
							LodVer	(load (strcat _Path-User Whuf))
					)
				)
				((= (StpDot AppNam) "ADDSPLOT")
					(if (findfile (strcat PrmRootPath "ADDS\\User\\" Whuf ".arx"))
						(progn
							(if (member (strcase (strcat Whuf ".Arx") T) (arx))
								(arxunload (strcase (strcat Whuf ".Arx") T))
							)
							(setq	LodLev	10
									Loded	(arxload (strcat PrmRootPath "ADDS\\User\\" Whuf ".arx"))
							)
						)
						(if (or (findfile (strcat PrmRootPath "ADDS\\User\\" Whuf ".lsp")) (findfile (strcat PrmRootPath "ADDS\\User\\" Whuf ".vlx")))
							(setq	LodLev	10
									LodVer	(load (strcat PrmRootPath "ADDS\\User\\" Whuf))
							)
							(alert (strcat "*" AppNam " Test Warning!*\nLaunch code not found!\nCheck network paths!"))
						)
					)
				)
				((or	(findfile (strcat PrmRootPath "ADDS\\User\\" Whuf ".lsp"))
					(findfile (strcat PrmRootPath "ADDS\\User\\" Whuf ".vlx"))
					(findfile (strcat PrmRootPath "ADDS\\User\\" Whuf ".arx"))
				 )
					(if (findfile (strcat PrmRootPath "ADDS\\User\\" Whuf ".arx"))
						(progn
							(if (member (strcase (strcat Whuf ".Arx") T) (arx))
								(arxunload (strcase (strcat Whuf ".Arx") T))
							)
							(setq	LodLev	11
									Loded	(arxload (strcat PrmRootPath "ADDS\\User\\" Whuf ".arx"))
							)
						)
						(if (or (findfile (strcat PrmRootPath "ADDS\\User\\" Whuf ".lsp")) (findfile (strcat PrmRootPath "ADDS\\User\\" Whuf ".vlx")))
							(setq	LodLev	11
									LodVer	(load (strcat PrmRootPath "ADDS\\User\\" Whuf))
							)
							(alert (strcat "*" AppNam " Test Warning!*\nLaunch code not found!\nCheck network paths!"))
						)
					)
				)
				((or	(findfile (strcat TestPrmRootPath "ADDS\\User\\" Whuf ".lsp"))
					(findfile (strcat TestPrmRootPath "ADDS\\User\\" Whuf ".vlx"))
					(findfile (strcat TestPrmRootPath "ADDS\\User\\" Whuf ".arx"))
				 )
					(if (findfile (strcat TestPrmRootPath "ADDS\\User\\" Whuf ".arx"))
						(progn
							(if (member (strcase (strcat Whuf ".Arx") T) (arx))
								(arxunload (strcase (strcat Whuf ".Arx") T))
							)
							(setq	LodLev	12
									Loded	(arxload (strcat TestPrmRootPath "ADDS\\User\\" Whuf ".arx"))
							)
						)
						(if (or (findfile (strcat TestPrmRootPath "ADDS\\User\\" Whuf ".lsp")) (findfile (strcat TestPrmRootPath "ADDS\\User\\" Whuf ".vlx")))
							(setq	LodLev	12
									LodVer	(load (strcat TestPrmRootPath "ADDS\\User\\" Whuf))
							)
							(alert (strcat "*" AppNam " Test Warning!*\nLaunch code not found!\nCheck network paths!"))
						)
					)
				)
				((or	(findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".lsp"))
					(findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".vlx"))
					(findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".arx"))
				 )
					(if (findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".arx"))
						(progn
							(if (member (strcase (strcat Whuf ".Arx") T) (arx))
								(arxunload (strcase (strcat Whuf ".Arx") T))
							)
							(setq	LodLev	13
									Loded	(arxload (strcat TestPrmRootPath "Adds\\User\\" Whuf ".arx"))
							)
						)
						(if (or (findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".lsp")) (findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".vlx")))
							(setq	LodLev	13
									LodVer	(load (strcat TestPrmRootPath "Adds\\User\\" Whuf))
							)
							(alert (strcat "*" AppNam " Test Warning!*\nLaunch code not found!\nCheck network paths!"))
						)
					)
				)
				(T
					(alert (strcat "*" AppNam " Test Warning!*\nLaunch code not found!\nCheck network paths!"))
				)
			)
			(cond
				((findfile (strcat PrmRootPath "Common\\" Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	8
							Loded	(arxload (strcat PrmRootPath "Common\\" Whuf ".arx"))
					)
				)
				((or (findfile (strcat PrmRootPath "Common\\" Whuf ".lsp")) (findfile (strcat PrmRootPath "Common\\" Whuf ".vlx")))
					(setq	LodLev	8
							LodVer	(load (strcat PrmRootPath "Common\\" Whuf))
					)
				)
				((findfile (strcat _Path-User Whuf ".arx"))
					(if (member (strcase (strcat Whuf ".Arx") T) (arx))
						(arxunload (strcase (strcat Whuf ".Arx") T))
					)
					(setq	LodLev	10
							Loded	(arxload (strcat _Path-User Whuf ".arx"))
					)
				)
				((or (findfile (strcat _Path-User Whuf ".lsp")) (findfile (strcat _Path-User Whuf ".vlx")))
					(setq	LodLev	10
							LodVer	(load (strcat _Path-User Whuf))
					)
				)
				((or	(findfile (strcat PrmRootPath "ADDS\\User\\" Whuf ".lsp"))
					(findfile (strcat PrmRootPath "ADDS\\User\\" Whuf ".vlx"))
					(findfile (strcat PrmRootPath "ADDS\\User\\" Whuf ".arx"))
				 )
					(if (findfile (strcat PrmRootPath "ADDS\\User\\" Whuf ".arx"))
						(progn
							(if (member (strcase (strcat Whuf ".Arx") T) (arx))
								(arxunload (strcase (strcat Whuf ".Arx") T))
							)
							(setq	LodLev	11
									Loded	(arxload (strcat PrmRootPath "ADDS\\User\\" Whuf ".arx"))
							)
						)
						(if (or (findfile (strcat PrmRootPath "ADDS\\User\\" Whuf ".lsp")) (findfile (strcat PrmRootPath "ADDS\\User\\" Whuf ".vlx")))
							(setq	LodLev	11
									LodVer	(load (strcat PrmRootPath "ADDS\\User\\" Whuf))
							)
							(alert (strcat "*" AppNam " Test Warning!*\nLaunch code not found!\nCheck network paths!"))
						)
					)
				)
				((or	(findfile (strcat TestPrmRootPath "ADDS\\User\\" Whuf ".lsp"))
					(findfile (strcat TestPrmRootPath "ADDS\\User\\" Whuf ".vlx"))
					(findfile (strcat TestPrmRootPath "ADDS\\User\\" Whuf ".arx"))
				 )
					(if (findfile (strcat TestPrmRootPath "ADDS\\User\\" Whuf ".arx"))
						(progn
							(if (member (strcase (strcat Whuf ".Arx") T) (arx))
								(arxunload (strcase (strcat Whuf ".Arx") T))
							)
							(setq	LodLev	12
									Loded	(arxload (strcat TestPrmRootPath "ADDS\\User\\" Whuf ".arx"))
							)
						)
						(if (or (findfile (strcat TestPrmRootPath "ADDS\\User\\" Whuf ".lsp")) (findfile (strcat TestPrmRootPath "ADDS\\User\\" Whuf ".vlx")))
							(setq	LodLev	12
									LodVer	(load (strcat TestPrmRootPath "ADDS\\User\\" Whuf))
							)
							(alert (strcat "*" AppNam " Test Warning!*\nLaunch code not found!\nCheck network paths!"))
						)
					)
				)
				((or	(findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".lsp"))
					(findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".vlx"))
					(findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".arx"))
				 )
					(if (findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".arx"))
						(progn
							(if (member (strcase (strcat Whuf ".Arx") T) (arx))
								(arxunload (strcase (strcat Whuf ".Arx") T))
							)
							(setq	LodLev	13
									Loded	(arxload (strcat TestPrmRootPath "Adds\\User\\" Whuf ".arx"))
							)
						)
						(if (or (findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".lsp")) (findfile (strcat TestPrmRootPath "Adds\\User\\" Whuf ".vlx")))
							(setq	LodLev	13
									LodVer	(load (strcat TestPrmRootPath "Adds\\User\\" Whuf))
							)
							(alert (strcat "*" AppNam " Test Warning!*\nLaunch code not found!\nCheck network paths!"))
						)
					)
				)
				(T
					(alert "*Test Warning!*\nLaunch code not found!\nCheck network paths!")
				)
			)
		)
	)
	(if (and LodLev DevLev)
		(if (< LodLev DevLev)
			(cond
				((= LodLev 0)
					(setvar "USERS5" " {*Test-MyDevC*}")
					(setq	DevLev	LodLev)
				)
				((= LodLev 1)
					(setvar "USERS5" " {*Test-MyDevC*}")
					(setq	DevLev	LodLev)
				)
				((= LodLev 2)
					(setvar "USERS5" " {*Test-MyDevH*}")
					(setq	DevLev	LodLev)
				)
				((= LodLev 3)
					(setvar "USERS5" " {*Test-MyDevH*}")
					(setq	DevLev	LodLev)
				)
				((= LodLev 4)
					(setvar "USERS5" " {*Test-DevRC*}")
					(setq	DevLev	LodLev)
				)
				((= LodLev 5)
					(setvar "USERS5" " {*Test-DevRC*}")
					(setq	DevLev	LodLev)
				)
				((= LodLev 6)
					(setvar "USERS5" " {*Test-DevGold*}")
					(setq	DevLev	LodLev)
				)
				((= LodLev 7)
					(setvar "USERS5" " {*Test-DevGold*}")
					(setq	DevLev	LodLev)
				)
			)
		)
	)
	(if Bug
		(if (and Whuf LodLev LodVer)
			(cond
				((= (type LodVer) (quote STR))
					(princ (strcat "\nBug:LodStage=" Whuf ":" (itoa LodLev) ":" LodVer))
				)
				((= (type LodVer) (quote REAL))
					(princ (strcat "\nBug:LodStage=" Whuf ":" (itoa LodLev) ":" (rtos LodVer 2 4)))
				)
				((= (type LodVer) (quote INT))
					(princ (strcat "\nBug:LodStage=" Whuf ":" (itoa LodLev) ":" (itoa LodVer)))
				)
				(T
					(princ (strcat "\nBug:LodStage=" Whuf ":" (itoa LodLev) ":Unknown Type"))
				)
			)
			(princ "\nMissing some load data!")
		)
	)
	(if Bug (princ "\n{ LodStage Exited"))
	(list Whuf LodLev LodVer)
)

(defun C:Lod ( / LodBub LodWhut )				; Legacy Code (updated) Loads other routines-CL
	(if Whut
		(setq LodWhut (getstring (strcat "\nName of Lisp file to load? <" Whut ">: ")))
		(setq LodWhut (getstring "\nName of Lisp file to load? "))
	)
	(if LodWhut
		(if (> (strlen LodWhut) 0)
			(setq	Whut	LodWhut)
		)
	)
	(if Whut
		(setq	LodBub	(LodStage Whut))
	)
	(if (and LodBub LodLst)
		(setq	LodLst	(UpdLodLst LodBub LodLst))
	)
	(princ)
)

(defun UpdLodLst ( NewItm LodLst /	MemLst	; Updates LodLst
								XCnt x )
	(if LodLst
		(setq	MemLst	(mapcar (quote (lambda (x) (strcase (car x)))) LodLst))
	)
	(if MemLst
		(if (setq	XCnt	(member (strcase (car NewItm)) MemLst))
			(setq	LodLst	(RepLst LodLst NewItm (- (length LodLst) (length XCnt))))
			(setq	LodLst	(cons NewItm LodLst))
		)
	)
	LodLst
)

(defun C:SelOddCol ( / )					; Finds and lists circuit objects not colored by Layer
	(setq	ssP		nil
			ssP		(ssget "X"	(list	(cons 8 "????CK*")
										(cons -4 "<AND")
											(cons -4 ">=")
											(cons 62 1)
											(cons -4 "<=")
											(cons 62 254)
										(cons -4 "AND>")
								)
					)
	)
	(if ssP
		(princ (strcat "\nFound " (itoa (sslength ssP)) " items with specified color!"))
	)
	(command "_.LIST" ssP "")
	;	Cleanup
	(if ssP
		(progn
			(setq ssP nil)
			(gc)
		)
	)
	(princ)
)

(defun NewGlobals ( /	NewGlobalsList			; Global Symbol/Function Lister
					AllGlobalsList )
	(if (not SCSB_OldGlobalsList)
		(setq	SCSB_OldGlobalsList	(atoms-family 0))
	)
	(foreach	GlobalSymbol
			(setq	AllGlobalsList		(atoms-family 0))
			(if (not (member GlobalSymbol SCSB_OldGlobalsList))
				(setq	NewGlobalsList		(cons GlobalSymbol NewGlobalsList))
			)
	)
	(setq	SCSB_OldGlobalsList	AllGlobalsList)
	NewGlobalsList
)

(defun CP_Lst2 ( Pnt1 Pnt2 Lent /	A1 A2 A3 A4	; Returns List of Points Squarely surrounding a Point
							L1 P1 P2 P3 P4 PtLst )
	(setq	A1		(angle Pnt1 Pnt2)
			A2		(+ A1 (/ pi 2.0))
			A3		(+ A2 (/ pi 2.0))
			A4		(+ A3 (/ pi 2.0))
			L1		(distance Pnt1 Pnt2)
			P1		(polar PtA A3 Lent)
			P1		(polar P1 A4 Lent)
			P2		(polar P1 A1 (+ L1 Lent Lent))
			P3		(polar P2 A2 (+ Lent Lent))
			P4		(polar P3 A3 (+ L1 Lent Lent))
			PtLst	(list P1 P2 P3 P4)
	)
	(if (and P1 P2 P3 P4 Bug)
		(progn
			(grdraw P1 P2 1 1)
			(grdraw P2 P3 1 1)
			(grdraw P3 P4 1 1)
			(grdraw P4 P1 1 1)
		)
	)
	PtLst
)

(defun CP_Lst6 ( Pnt Lent /	Pa Pb Pc Pd Pe Pf	; Returns List of Points Hexagonally surrounding a Point
						PtLst )
	(setq	Pa		(polar Pnt 0.0 (/ Lent 2.0))
			Pb		(polar Pa (/ (* pi 2.0) 3.0) (/ Lent 2.0))
			Pc		(polar Pb pi (/ Lent 2.0))
			Pd		(polar Pc (/ (* pi 4.0) 3.0) (/ Lent 2.0))
			Pe		(polar Pd (/ (* pi 5.0) 3.0) (/ Lent 2.0))
			Pf		(polar Pe 0.0 (/ Lent 2.0))
			PtLst	(list Pa Pb Pc Pd Pe Pf)
	)
	(if (and Pa Pb Pc Pd Pe Pf Bug)
		(progn
			(grdraw Pa Pb 1 1)
			(grdraw Pb Pc 1 1)
			(grdraw Pc Pd 1 1)
			(grdraw Pd Pe 1 1)
			(grdraw Pe Pf 1 1)
			(grdraw Pf Pa 1 1)
		)
	)
	PtLst
)

(defun LstDivLckd ( DNum Act / Whut )			; Returns a list of locked/unlocked shared panels
	(if (and All_Lck_Lst DNum)		; if Act=T, returns list of locked shared panels, else unlocked
		(foreach	DLst
				All_Lck_Lst
				(if (nth DNum DLst)
					(if (equal Act (nth (+ 6 DNum) DLst))
						(if Whut
							(setq	Whut		(cons (car DLst) Whut))
							(setq	Whut		(list (car DLst)))
						)
					)
				)
		)
		(setq	Whut		nil)
	)
	(if Whut
		(setq	Whut		(acad_strlsort Whut))
	)
	Whut
)

(defun C:MakXCopFils ( / bubba1 bubba2 bubba3 )	; Create XCopy CMD files to populate Shared Folder
	(if (not GotPath)
		(GetPathPanel DevMark)
	)
	(if	(or	BShrLst
			EShrLst
			MShrLst
			SShrLst
			SEShrLst
			WShrLst
		)
		(setq	bubba1	(open (strcat (nth 6 GotPath) "Data\\XCop.cmd") "w"))
		(progn
			(alert (strcat "**Error!**\nMissing (x)ShrLsts"))
			(exit)
		)
	)
	(setq	BigShrLst		(list (list (car BShrLst) 1 0 0 0 0 0)))
	(foreach	Imp
			BShrLst
			(if (not (assoc Imp BigShrLst))
				(setq	BigShrLst	(cons (list Imp 1 0 0 0 0 0) BigShrLst))
			)
	)
	(foreach	Imp
			EShrLst
			(if (not (assoc Imp BigShrLst))
				(setq	BigShrLst	(cons (list Imp 0 1 0 0 0 0) BigShrLst))
				(setq	BigShrLst	(subst	(list	(nth 0 (assoc Imp BigShrLst))
												(nth 1 (assoc Imp BigShrLst))
												1
												(nth 3 (assoc Imp BigShrLst))
												(nth 4 (assoc Imp BigShrLst))
												(nth 5 (assoc Imp BigShrLst))
												(nth 6 (assoc Imp BigShrLst))
										)
										(assoc Imp BigShrLst)
										BigShrLst
								)
				)
			)
	)
	(foreach	Imp
			MShrLst
			(if (not (assoc Imp BigShrLst))
				(setq	BigShrLst	(cons (list Imp 0 0 1 0 0 0) BigShrLst))
				(setq	BigShrLst	(subst	(list	(nth 0 (assoc Imp BigShrLst))
												(nth 1 (assoc Imp BigShrLst))
												(nth 2 (assoc Imp BigShrLst))
												1
												(nth 4 (assoc Imp BigShrLst))
												(nth 5 (assoc Imp BigShrLst))
												(nth 6 (assoc Imp BigShrLst))
										)
										(assoc Imp BigShrLst)
										BigShrLst
								)
				)
			)
	)
	(foreach	Imp
			SShrLst
			(if (not (assoc Imp BigShrLst))
				(setq	BigShrLst	(cons (list Imp 0 0 0 1 0 0) BigShrLst))
				(setq	BigShrLst	(subst	(list	(nth 0 (assoc Imp BigShrLst))
												(nth 1 (assoc Imp BigShrLst))
												(nth 2 (assoc Imp BigShrLst))
												(nth 3 (assoc Imp BigShrLst))
												1
												(nth 5 (assoc Imp BigShrLst))
												(nth 6 (assoc Imp BigShrLst))
										)
										(assoc Imp BigShrLst)
										BigShrLst
								)
				)
			)
	)
	(foreach	Imp
			SEShrLst
			(if (not (assoc Imp BigShrLst))
				(setq	BigShrLst	(cons (list Imp 0 0 0 0 1 0) BigShrLst))
				(setq	BigShrLst	(subst	(list	(nth 0 (assoc Imp BigShrLst))
												(nth 1 (assoc Imp BigShrLst))
												(nth 2 (assoc Imp BigShrLst))
												(nth 3 (assoc Imp BigShrLst))
												(nth 4 (assoc Imp BigShrLst))
												1
												(nth 6 (assoc Imp BigShrLst))
										)
										(assoc Imp BigShrLst)
										BigShrLst
								)
				)
			)
	)
	(foreach	Imp
			WShrLst
			(if (not (assoc Imp BigShrLst))
				(setq	BigShrLst	(cons (list Imp 0 0 0 0 0 1) BigShrLst))
				(setq	BigShrLst	(subst	(list	(nth 0 (assoc Imp BigShrLst))
												(nth 1 (assoc Imp BigShrLst))
												(nth 2 (assoc Imp BigShrLst))
												(nth 3 (assoc Imp BigShrLst))
												(nth 4 (assoc Imp BigShrLst))
												(nth 5 (assoc Imp BigShrLst))
												1
										)
										(assoc Imp BigShrLst)
										BigShrLst
								)
				)
			)
	)
	(if BigShrLst
		(setq	bubba4	(open (strcat (nth 6 GotPath) "Data\\BgShrUse.txt") "w")
				bubba5	(mapcar	(quote (lambda (x)
									(write-line	(strcat	"\042"
														(nth 0 x)
														"\042"
														(if (= (nth 1 x) 1)
															" 0 1"
															" 0 0"
														)
														(if (= (nth 2 x) 1)
															" 0 1"
															" 0 0"
														)
														(if (= (nth 3 x) 1)
															" 0 1"
															" 0 0"
														)
														(if (= (nth 4 x) 1)
															" 0 1"
															" 0 0"
														)
														(if (= (nth 5 x) 1)
															" 0 1"
															" 0 0"
														)
														(if (= (nth 6 x) 1)
															" 0 1"
															" 0 0"
														)
														" 1 7"
												)
												bubba4
									)
								 ))
								 BigShrLst
						)
				bubba6	(close bubba4)
		)
	)
	(if (and BShrLst bubba1)
		(if (> (length BShrLst) 1)
				(setq	bubba2	(mapcar (quote (lambda (x) (write-line (strcat "xcopy \042" (nth 0 GotPath) x ".dwg\042 \042" (nth 6 GotPath) "\042 \057I \057D \057F \076\076\042" (nth 6 GotPath) "Data\\XCop.log\042") bubba1))) BShrLst))
		)
	)
	(if (and EShrLst bubba1)
		(if (> (length EShrLst) 1)
				(setq	bubba2	(mapcar (quote (lambda (x) (write-line (strcat "xcopy \042" (nth 2 GotPath) x ".dwg\042 \042" (nth 6 GotPath) "\042 \057I \057D \057F \076\076\042" (nth 6 GotPath) "Data\\XCop.log\042") bubba1))) EShrLst))
		)
	)
	(if (and MShrLst bubba1)
		(if (> (length MShrLst) 1)
				(setq	bubba2	(mapcar (quote (lambda (x) (write-line (strcat "xcopy \042" (nth 4 GotPath) x ".dwg\042 \042" (nth 6 GotPath) "\042 \057I \057D \057F \076\076\042" (nth 6 GotPath) "Data\\XCop.log\042") bubba1))) MShrLst))
		)
	)
	(if (and SShrLst bubba1)
		(if (> (length SShrLst) 1)
				(setq	bubba2	(mapcar (quote (lambda (x) (write-line (strcat "xcopy \042" (nth 3 GotPath) x ".dwg\042 \042" (nth 6 GotPath) "\042 \057I \057D \057F \076\076\042" (nth 6 GotPath) "Data\\XCop.log\042") bubba1))) SShrLst))
		)
	)
	(if (and SEShrLst bubba1)
		(if (> (length SEShrLst) 1)
				(setq	bubba2	(mapcar (quote (lambda (x) (write-line (strcat "xcopy \042" (nth 5 GotPath) x ".dwg\042 \042" (nth 6 GotPath) "\042 \057I \057D \057F \076\076\042" (nth 6 GotPath) "Data\\XCop.log\042") bubba1))) SEShrLst))
		)
	)
	(if (and WShrLst bubba1)
		(if (> (length WShrLst) 1)
				(setq	bubba2	(mapcar (quote (lambda (x) (write-line (strcat "xcopy \042" (nth 1 GotPath) x ".dwg\042 \042" (nth 6 GotPath) "\042 \057I \057D \057F \076\076\042" (nth 6 GotPath) "Data\\XCop.log\042") bubba1))) WShrLst)) ; (nth 6 GotPath) x ".dwg\042
		)
	)
	(if (and BShrLst bubba1)
		(if (> (length BShrLst) 1)
				(setq	bubba2	(mapcar (quote (lambda (x) (write-line (strcat "del \042" (nth 0 GotPath) x ".dwg\042 \057F \057Q \076\076\042" (nth 6 GotPath) "Data\\XCop.log\042") bubba1))) BShrLst)
						bubba2	(mapcar (quote (lambda (x) (write-line (strcat "if exist \042" (nth 0 GotPath) "Locked\\" x ".lck\042 del \042" (nth 0 GotPath) "Locked\\" x ".lck\042 \057F \057Q \076\076\042" (nth 6 GotPath) "Data\\XCop.log\042") bubba1))) BShrLst)
						bubba7	(open (strcat (nth 6 GotPath) "Data\\BHDivUse.txt") "w")
						bubba8	(mapcar (quote (lambda (x) (write-line (strcat "\042" x "\042 1 0 0 0 0 0 0 0 0 0 0 0 0 1") bubba7))) BLstF)
						bubba9	(close bubba7)
				)
		)
	)
	(if (and EShrLst bubba1)
		(if (> (length EShrLst) 1)
				(setq	bubba2	(mapcar (quote (lambda (x) (write-line (strcat "del \042" (nth 2 GotPath) x ".dwg\042 \057F \057Q \076\076\042" (nth 6 GotPath) "Data\\XCop.log\042") bubba1))) EShrLst)
						bubba2	(mapcar (quote (lambda (x) (write-line (strcat "if exist \042" (nth 2 GotPath) "Locked\\" x ".lck\042 del \042" (nth 2 GotPath) "Locked\\" x ".lck\042 \057F \057Q \076\076\042" (nth 6 GotPath) "Data\\XCop.log\042") bubba1))) EShrLst)
						bubba7	(open (strcat (nth 6 GotPath) "Data\\E_DivUse.txt") "w")
						bubba8	(mapcar (quote (lambda (x) (write-line (strcat "\042" x "\042 0 0 1 0 0 0 0 0 0 0 0 0 0 2") bubba7))) ELstF)
						bubba9	(close bubba7)
				)
		)
	)
	(if (and MShrLst bubba1)
		(if (> (length MShrLst) 1)
				(setq	bubba2	(mapcar (quote (lambda (x) (write-line (strcat "del \042" (nth 4 GotPath) x ".dwg\042 \057F \057Q \076\076\042" (nth 6 GotPath) "Data\\XCop.log\042") bubba1))) MShrLst)
						bubba2	(mapcar (quote (lambda (x) (write-line (strcat "if exist \042" (nth 4 GotPath) "Locked\\" x ".lck\042 del \042" (nth 4 GotPath) "Locked\\" x ".lck\042 \057F \057Q \076\076\042" (nth 6 GotPath) "Data\\XCop.log\042") bubba1))) MShrLst)
						bubba7	(open (strcat (nth 6 GotPath) "Data\\M_DivUse.txt") "w")
						bubba8	(mapcar (quote (lambda (x) (write-line (strcat "\042" x "\042 0 0 0 0 1 0 0 0 0 0 0 0 0 5") bubba7))) MLstF)
						bubba9	(close bubba7)
				)
		)
	)
	(if (and SShrLst bubba1)
		(if (> (length SShrLst) 1)
				(setq	bubba2	(mapcar (quote (lambda (x) (write-line (strcat "del \042" (nth 3 GotPath) x ".dwg\042 \057F \057Q \076\076\042" (nth 6 GotPath) "Data\\XCop.log\042") bubba1))) SShrLst)
						bubba2	(mapcar (quote (lambda (x) (write-line (strcat "if exist \042" (nth 3 GotPath) "Locked\\" x ".lck\042 del \042" (nth 3 GotPath) "Locked\\" x ".lck\042 \057F \057Q \076\076\042" (nth 6 GotPath) "Data\\XCop.log\042") bubba1))) SShrLst)
						bubba7	(open (strcat (nth 6 GotPath) "Data\\S_DivUse.txt") "w")
						bubba8	(mapcar (quote (lambda (x) (write-line (strcat "\042" x "\042 0 0 0 0 0 0 1 0 0 0 0 0 0 3") bubba7))) SLstF)
						bubba9	(close bubba7)
				)
		)
	)
	(if (and SEShrLst bubba1)
		(if (> (length SEShrLst) 1)
				(setq	bubba2	(mapcar (quote (lambda (x) (write-line (strcat "del \042" (nth 5 GotPath) x ".dwg\042 \057F \057Q \076\076\042" (nth 6 GotPath) "Data\\XCop.log\042") bubba1))) SEShrLst)
						bubba2	(mapcar (quote (lambda (x) (write-line (strcat "if exist \042" (nth 5 GotPath) "Locked\\" x ".lck\042 del \042" (nth 5 GotPath) "Locked\\" x ".lck\042 \057F \057Q \076\076\042" (nth 6 GotPath) "Data\\XCop.log\042") bubba1))) SEShrLst)
						bubba7	(open (strcat (nth 6 GotPath) "Data\\SEDivUse.txt") "w")
						bubba8	(mapcar (quote (lambda (x) (write-line (strcat "\042" x "\042 0 0 0 0 0 0 0 0 1 0 0 0 0 6") bubba7))) SELstF)
						bubba9	(close bubba7)
				)
		)
	)
	(if (and WShrLst bubba1)
		(if (> (length WShrLst) 1)
				(setq	bubba2	(mapcar (quote (lambda (x) (write-line (strcat "del \042" (nth 1 GotPath) x ".dwg\042 \057F \057Q \076\076\042" (nth 6 GotPath) "Data\\XCop.log\042") bubba1))) WShrLst)
						bubba2	(mapcar (quote (lambda (x) (write-line (strcat "if exist \042" (nth 1 GotPath) "Locked\\" x ".lck\042 del \042" (nth 1 GotPath) "Locked\\" x ".lck\042 \057F \057Q \076\076\042" (nth 6 GotPath) "Data\\XCop.log\042") bubba1))) WShrLst)
						bubba7	(open (strcat (nth 6 GotPath) "Data\\W_DivUse.txt") "w")
						bubba8	(mapcar (quote (lambda (x) (write-line (strcat "\042" x "\042 0 0 0 0 0 0 0 0 0 0 1 0 0 4") bubba7))) WLstF)
						bubba9	(close bubba7)
				)
		)
	)
	(if bubba1
		(close bubba1)
	)
	(princ)
)

(defun PanLocaTst ( IsTest /	dSiz dBlip dEcho	; Draw All Panels for Adds Panel Status Dwg
						UnqCnt )
;;;						dFilB BLst LFilB BLstL
;;;						dFilW WLst LFilW WLstL
;;;						dFilE ELst LFilE ELstL
;;;						dFilS SLst LFilS SLstL
;;;						dFilM MLst LFilM MLstL
;;;						dFilSE SELst LFilSE SELstL )
	(if Bug (princ "\n{ PanLocaTst entered\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			ColWas	(getvar "CECOLOR")
			LtWas	(getvar "CELTYPE")
			LayWas	(getvar "CLAYER")
			CmdWas	(getvar "CMDDIA")
			EchWas	(getvar "CMDECHO")
			FilWas	(getvar "FILEDIA")
			OsWas	(getvar "OSMODE")
	)
	
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
		)
	)
	(command "_.UNDO" "_BE")
	(setq	BigShrLst		nil
			BgShrLst		nil
			N1ShLst		nil
			O1ShLst		nil
			N2ShLst		nil
			O2ShLst		nil
			N3ShLst		nil
			O3ShLst		nil
			N4ShLst		nil
			O4ShLst		nil
	)
	(setq	dSiz		800.0				; (getreal "\nInput size of text <800>: ")
			UnqCnt	0
	)
	(if (not GotPath)
		(GetPathPanel IsTest)
	)
	(setq	dFilB	(dos_dir (strcat (nth 0 GotPath) "*.dwg"))
			BLst		(mapcar (quote (lambda (x) (substr x 1 7))) dFilB)
			LFilB	(dos_dir (strcat (nth 0 GotPath) "Locked\\*.lck"))
			BLstL	(mapcar (quote (lambda (x) (substr x 1 7))) LFilB)
			dFilW	(dos_dir (strcat (nth 1 GotPath) "*.dwg"))
			WLst		(mapcar (quote (lambda (x) (substr x 1 7))) dFilW)
			LFilW	(dos_dir (strcat (nth 1 GotPath) "Locked\\*.lck"))
			WLstL	(mapcar (quote (lambda (x) (substr x 1 7))) LFilW)
			dFilE	(dos_dir (strcat (nth 2 GotPath) "*.dwg"))
			ELst		(mapcar (quote (lambda (x) (substr x 1 7))) dFilE)
			LFilE	(dos_dir (strcat (nth 2 GotPath) "Locked\\*.lck"))
			ELstL	(mapcar (quote (lambda (x) (substr x 1 7))) LFilE)
			dFilS	(dos_dir (strcat (nth 3 GotPath) "*.dwg"))
			SLst		(mapcar (quote (lambda (x) (substr x 1 7))) dFilS)
			LFilS	(dos_dir (strcat (nth 3 GotPath) "Locked\\*.lck"))
			SLstL	(mapcar (quote (lambda (x) (substr x 1 7))) LFilS)
			dFilM	(dos_dir (strcat (nth 4 GotPath) "*.dwg"))
			MLst		(mapcar (quote (lambda (x) (substr x 1 7))) dFilM)
			LFilM	(dos_dir (strcat (nth 4 GotPath) "Locked\\*.lck"))
			MLstL	(mapcar (quote (lambda (x) (substr x 1 7))) LFilM)
			dFilSE	(dos_dir (strcat (nth 5 GotPath) "*.dwg"))
			SELst	(mapcar (quote (lambda (x) (substr x 1 7))) dFilSE)
			LFilSE	(dos_dir (strcat (nth 5 GotPath) "Locked\\*.lck"))
			SELstL	(mapcar (quote (lambda (x) (substr x 1 7))) LFilSE)
			dFilSH	(dos_dir (strcat (nth 6 GotPath) "*.dwg"))
			SHLst	(mapcar (quote (lambda (x) (substr x 1 7))) dFilSH)
			LFilSH	(dos_dir (strcat (nth 6 GotPath) "Locked\\*.lck"))
			SHLstL	(mapcar (quote (lambda (x) (substr x 1 7))) LFilSH)
			LckLst	(list BLstL WLstL ELstL SLstL MLstL SELstL SHLstL)
	)
	;Shared Folder
	(if IsTest
		(if (findfile (strcat TestPrmRootPath "Shared Panels\\Data\\BgShrUse.txt"))
			(setq	BigShrFil	(open (strcat TestPrmRootPath "Shared Panels\\Data\\BgShrUse.txt") "r")
					Bubba	(if BigShrFil
								(while (setq InData (read-line BigShrFil))
									(if InData
										(if BigShrLst
											(setq	BigShrLst	(cons (read (strcat "(" InData ")")) BigShrLst))
											(setq	BigShrLst	(list (read (strcat "(" InData ")"))))
										)
									)
								)
							)
					BgShrLst	(mapcar (quote car) BigShrLst)
					Bubba	(if BigShrFil
								(close BigShrFil)
							)
			)
		)
		(if (findfile PrmRootPath (strcat PrmRootPath "Shared Panels\\Data\\BgShrUse.txt"))
			(setq	BigShrFil	(open (strcat PrmRootPath "Shared Panels\\Data\\BgShrUse.txt") "r")
					Bubba	(if BigShrFil
								(while (setq InData (read-line BigShrFil))
									(if InData
										(if BigShrLst
											(setq	BigShrLst	(cons (read (strcat "(" InData ")")) BigShrLst))
											(setq	BigShrLst	(list (read (strcat "(" InData ")"))))
										)
									)
								)
							)
					BgShrLst	(mapcar (quote car) BigShrLst)
					Bubba	(if BigShrFil
								(close BigShrFil)
							)
			)
		)
	)
	(foreach	PanNam
			ShLst
			(if (not (member PanNam BgShrLst))
				(if N1ShLst
					(setq	N1ShLst	(cons PanNam N1ShLst))
					(setq	N1ShLst	(list PanNam))
				)
				(if O1ShLst
					(setq	O1ShLst	(cons PanNam O1ShLst))
					(setq	O1ShLst	(list PanNam))
				)
			)
	)
	(if N1ShLst
		(princ (strcat "\nFound {" (itoa (length N1ShLst)) "} panels in Shared Folder not in Shared List..."))
		(princ "\nFound No panels in Shared Folder not in Shared List...")
	)
	(foreach	PanNam
			BgShrLst
			(if (not (member PanNam ShLst))
				(if N2ShLst
					(setq	N2ShLst	(cons PanNam N2ShLst))
					(setq	N2ShLst	(list PanNam))
				)
				(if O2ShLst
					(setq	O2ShLst	(cons PanNam O2ShLst))
					(setq	O2ShLst	(list PanNam))
				)
			)
	)
	(if N2ShLst
		(princ (strcat "\nFound {" (itoa (length N2ShLst)) "} panels in Shared List not in Shared Folder..."))
		(princ "\nFound No panels in Shared List not in Shared Folder...")
	)
	;Birmingham Folder
	(if IsTest
		(if (findfile (strcat TestPrmRootPath "Shared Panels\\Data\\BHDivUse.txt"))
			(setq	BhmShrFil	(open (strcat TestPrmRootPath "Shared Panels\\Data\\BHDivUse.txt") "r")
					Bubba	(if BhmShrFil
								(while (setq InData (read-line BhmShrFil))
									(if InData
										(if BhmShrLst
											(setq	BhmShrLst	(cons (read (strcat "(" InData ")")) BhmShrLst))
											(setq	BhmShrLst	(list (read (strcat "(" InData ")"))))
										)
									)
								)
							)
					BhShrLst	(mapcar (quote car) BhmShrLst)
					Bubba	(if BhmShrFil
								(close BhmShrFil)
							)
			)
		)
		(if (findfile (strcat PrmRootPath "Shared Panels\\Data\\BHDivUse.txt"))
			(setq	BhmShrFil	(open (strcat PrmRootPath "Shared Panels\\Data\\BHDivUse.txt") "r")
					Bubba	(if BhmShrFil
								(while (setq InData (read-line BhmShrFil))
									(if InData
										(if BhmShrLst
											(setq	BhmShrLst	(cons (read (strcat "(" InData ")")) BhmShrLst))
											(setq	BhmShrLst	(list (read (strcat "(" InData ")"))))
										)
									)
								)
							)
					BhShrLst	(mapcar (quote car) BhmShrLst)
					Bubba	(if BhmShrFil
								(close BhmShrFil)
							)
			)
		)
	)
	(foreach	PanNam
			BLst
			(if (not (member PanNam BhShrLst))
				(if N3ShLst
					(setq	N3ShLst	(cons PanNam N3ShLst))
					(setq	N3ShLst	(list PanNam))
				)
				(if O3ShLst
					(setq	O3ShLst	(cons PanNam O3ShLst))
					(setq	O3ShLst	(list PanNam))
				)
			)
	)
	(if N3ShLst
		(princ (strcat "\nFound {" (itoa (length N3ShLst)) "} panels in Bham Folder not in Bham List..."))
		(princ "\nFound No panels in Bham Folder not in Bham List...")
	)
	(foreach	PanNam
			BhShrLst
			(if (not (member PanNam BLst))
				(if N4ShLst
					(setq	N4ShLst	(cons PanNam N4ShLst))
					(setq	N4ShLst	(list PanNam))
				)
				(if O4ShLst
					(setq	O4ShLst	(cons PanNam O4ShLst))
					(setq	O4ShLst	(list PanNam))
				)
			)
	)
	(if N4ShLst
		(princ (strcat "\nFound {" (itoa (length N4ShLst)) "} panels in Bham List not in Bham Folder..."))
		(princ "\nFound No panels in Bham List not in Bham Folder...")
	)
	;Eastern Folder
	(if IsTest
		(if (findfile (strcat TestPrmRootPath "Shared Panels\\Data\\E_HDivUse.txt"))
			(setq	E__ShrFil	(open (strcat TestPrmRootPath "Shared Panels\\Data\\E_HDivUse.txt") "r")
					Bubba	(if E__ShrFil
								(while (setq InData (read-line E__ShrFil))
									(if InData
										(if E__ShrLst
											(setq	E__ShrLst	(cons (read (strcat "(" InData ")")) E__ShrLst))
											(setq	E__ShrLst	(list (read (strcat "(" InData ")"))))
										)
									)
								)
							)
					E_ShrLst	(mapcar (quote car) E__ShrLst)
					Bubba	(if E__ShrFil
								(close E__ShrFil)
							)
			)
		)
		(if (findfile (strcat PrmRootPath "Shared Panels\\Data\\E_DivUse.txt"))
			(setq	E__ShrFil	(open (strcat PrmRootPath "Shared Panels\\Data\\E_DivUse.txt") "r")
					Bubba	(if E__ShrFil
								(while (setq InData (read-line E__ShrFil))
									(if InData
										(if E__ShrLst
											(setq	E__ShrLst	(cons (read (strcat "(" InData ")")) E__ShrLst))
											(setq	E__ShrLst	(list (read (strcat "(" InData ")"))))
										)
									)
								)
							)
					E_ShrLst	(mapcar (quote car) E__ShrLst)
					Bubba	(if E__ShrFil
								(close E__ShrFil)
							)
			)
		)
	)
	(foreach	PanNam
			ELst
			(if (not (member PanNam E_ShrLst))
				(if N05ShLst
					(setq	N05ShLst	(cons PanNam N05ShLst))
					(setq	N05ShLst	(list PanNam))
				)
				(if O05ShLst
					(setq	O05ShLst	(cons PanNam O05ShLst))
					(setq	O05ShLst	(list PanNam))
				)
			)
	)
	(if N05ShLst
		(princ (strcat "\nFound {" (itoa (length N05ShLst)) "} panels in Eastern Folder not in Eastern List..."))
		(princ "\nFound No panels in Eastern Folder not in Eastern List...")
	)
	(foreach	PanNam
			E_ShrLst
			(if (not (member PanNam ELst))
				(if N06ShLst
					(setq	N06ShLst	(cons PanNam N06ShLst))
					(setq	N06ShLst	(list PanNam))
				)
				(if O06ShLst
					(setq	O06ShLst	(cons PanNam O06ShLst))
					(setq	O06ShLst	(list PanNam))
				)
			)
	)
	(if N06ShLst
		(princ (strcat "\nFound {" (itoa (length N06ShLst)) "} panels in Eastern List not in Eastern Folder..."))
		(princ "\nFound No panels in Eastern List not in Eastern Folder...")
	)
	;Southern Folder
	(if IsTest
		(if (findfile (strcat TestPrmRootPath "Shared Panels\\Data\\S_DivUse.txt"))
			(setq	S__ShrFil	(open (strcat TestPrmRootPath "Shared Panels\\Data\\S_DivUse.txt") "r")
					Bubba	(if S__ShrFil
								(while (setq InData (read-line S__ShrFil))
									(if InData
										(if S__ShrLst
											(setq	S__ShrLst	(cons (read (strcat "(" InData ")")) S__ShrLst))
											(setq	S__ShrLst	(list (read (strcat "(" InData ")"))))
										)
									)
								)
							)
					S_ShrLst	(mapcar (quote car) S__ShrLst)
					Bubba	(if S__ShrFil
								(close S__ShrFil)
							)
			)
		)
		(if (findfile (strcat PrmRootPath "Shared Panels\\Data\\S_DivUse.txt"))
			(setq	S__ShrFil	(open (strcat PrmRootPath "Shared Panels\\Data\\S_DivUse.txt") "r")
					Bubba	(if S__ShrFil
								(while (setq InData (read-line S__ShrFil))
									(if InData
										(if S__ShrLst
											(setq	S__ShrLst	(cons (read (strcat "(" InData ")")) S__ShrLst))
											(setq	S__ShrLst	(list (read (strcat "(" InData ")"))))
										)
									)
								)
							)
					S_ShrLst	(mapcar (quote car) S__ShrLst)
					Bubba	(if S__ShrFil
								(close S__ShrFil)
							)
			)
		)
	)
	(foreach	PanNam
			SLst
			(if (not (member PanNam S_ShrLst))
				(if N07ShLst
					(setq	N07ShLst	(cons PanNam N07ShLst))
					(setq	N07ShLst	(list PanNam))
				)
				(if O07ShLst
					(setq	O07ShLst	(cons PanNam O07ShLst))
					(setq	O07ShLst	(list PanNam))
				)
			)
	)
	(if N07ShLst
		(princ (strcat "\nFound {" (itoa (length N07ShLst)) "} panels in Southern Folder not in Southern List..."))
		(princ "\nFound No panels in Southern Folder not in Southern List...")
	)
	(foreach	PanNam
			S_ShrLst
			(if (not (member PanNam SLst))
				(if N08ShLst
					(setq	N08ShLst	(cons PanNam N08ShLst))
					(setq	N08ShLst	(list PanNam))
				)
				(if O08ShLst
					(setq	O08ShLst	(cons PanNam O08ShLst))
					(setq	O08ShLst	(list PanNam))
				)
			)
	)
	(if N08ShLst
		(princ (strcat "\nFound {" (itoa (length N08ShLst)) "} panels in Southern List not in Southern Folder..."))
		(princ "\nFound No panels in Southern List not in Southern Folder...")
	)
	;Western Folder
	(if IsTest
		(if (findfile (strcat TestPrmRootPath "Shared Panels\\Data\\W_DivUse.txt"))
			(setq	W__ShrFil	(open (strcat TestPrmRootPath "Shared Panels\\Data\\W_DivUse.txt") "r")
					Bubba	(if W__ShrFil
								(while (setq InData (read-line W__ShrFil))
									(if InData
										(if W__ShrLst
											(setq	W__ShrLst	(cons (read (strcat "(" InData ")")) W__ShrLst))
											(setq	W__ShrLst	(list (read (strcat "(" InData ")"))))
										)
									)
								)
							)
					W_ShrLst	(mapcar (quote car) W__ShrLst)
					Bubba	(if W__ShrFil
								(close W__ShrFil)
							)
			)
		)
		(if (findfile (strcat PrmRootPath "Shared Panels\\Data\\W_DivUse.txt"))
			(setq	W__ShrFil	(open (strcat PrmRootPath "Shared Panels\\Data\\W_DivUse.txt") "r")
					Bubba	(if W__ShrFil
								(while (setq InData (read-line W__ShrFil))
									(if InData
										(if W__ShrLst
											(setq	W__ShrLst	(cons (read (strcat "(" InData ")")) W__ShrLst))
											(setq	W__ShrLst	(list (read (strcat "(" InData ")"))))
										)
									)
								)
							)
					W_ShrLst	(mapcar (quote car) W__ShrLst)
					Bubba	(if W__ShrFil
								(close W__ShrFil)
							)
			)
		)
	)
	(foreach	PanNam
			WLst
			(if (not (member PanNam W_ShrLst))
				(if N09ShLst
					(setq	N09ShLst	(cons PanNam N09ShLst))
					(setq	N09ShLst	(list PanNam))
				)
				(if O09ShLst
					(setq	O09ShLst	(cons PanNam O09ShLst))
					(setq	O09ShLst	(list PanNam))
				)
			)
	)
	(if N09ShLst
		(princ (strcat "\nFound {" (itoa (length N09ShLst)) "} panels in Western Folder not in Western List..."))
		(princ "\nFound No panels in Western Folder not in Western List...")
	)
	(foreach	PanNam
			W_ShrLst
			(if (not (member PanNam WLst))
				(if N10ShLst
					(setq	N10ShLst	(cons PanNam N10ShLst))
					(setq	N10ShLst	(list PanNam))
				)
				(if O10ShLst
					(setq	O10ShLst	(cons PanNam O10ShLst))
					(setq	O10ShLst	(list PanNam))
				)
			)
	)
	(if N10ShLst
		(princ (strcat "\nFound {" (itoa (length N10ShLst)) "} panels in Western List not in Western Folder..."))
		(princ "\nFound No panels in Western List not in Western Folder...")
	)
	;Mobile Folder
	(if IsTest
		(if (findfile (strcat TestPrmRootPath "Shared Panels\\Data\\M_DivUse.txt"))
			(setq	M__ShrFil	(open (strcat TestPrmRootPath "Shared Panels\\Data\\M_DivUse.txt") "r")
					Bubba	(if M__ShrFil
								(while (setq InData (read-line M__ShrFil))
									(if InData
										(if M__ShrLst
											(setq	M__ShrLst	(cons (read (strcat "(" InData ")")) M__ShrLst))
											(setq	M__ShrLst	(list (read (strcat "(" InData ")"))))
										)
									)
								)
							)
					M_ShrLst	(mapcar (quote car) M__ShrLst)
					Bubba	(if M__ShrFil
								(close M__ShrFil)
							)
			)
		)
		(if (findfile (strcat PrmRootPath "Shared Panels\\Data\\M_DivUse.txt"))
			(setq	M__ShrFil	(open (strcat PrmRootPath "Shared Panels\\Data\\M_DivUse.txt") "r")
					Bubba	(if M__ShrFil
								(while (setq InData (read-line M__ShrFil))
									(if InData
										(if M__ShrLst
											(setq	M__ShrLst	(cons (read (strcat "(" InData ")")) M__ShrLst))
											(setq	M__ShrLst	(list (read (strcat "(" InData ")"))))
										)
									)
								)
							)
					M_ShrLst	(mapcar (quote car) M__ShrLst)
					Bubba	(if M__ShrFil
								(close M__ShrFil)
							)
			)
		)
	)
	(foreach	PanNam
			MLst
			(if (not (member PanNam M_ShrLst))
				(if N11ShLst
					(setq	N11ShLst	(cons PanNam N11ShLst))
					(setq	N11ShLst	(list PanNam))
				)
				(if O11ShLst
					(setq	O11ShLst	(cons PanNam O11ShLst))
					(setq	O11ShLst	(list PanNam))
				)
			)
	)
	(if N11ShLst
		(princ (strcat "\nFound {" (itoa (length N11ShLst)) "} panels in Mobile Folder not in Mobile List..."))
		(princ "\nFound No panels in Mobile Folder not in Mobile List...")
	)
	(foreach	PanNam
			M_ShrLst
			(if (not (member PanNam MLst))
				(if N12ShLst
					(setq	N12ShLst	(cons PanNam N12ShLst))
					(setq	N12ShLst	(list PanNam))
				)
				(if O12ShLst
					(setq	O12ShLst	(cons PanNam O12ShLst))
					(setq	O12ShLst	(list PanNam))
				)
			)
	)
	(if N12ShLst
		(princ (strcat "\nFound {" (itoa (length N12ShLst)) "} panels in Mobile List not in Mobile Folder..."))
		(princ "\nFound No panels in Mobile List not in Mobile Folder...")
	)
	;SouthEast Folder
	(if IsTest
		(if (findfile (strcat TestPrmRootPath "Shared Panels\\Data\\SEDivUse.txt"))
			(setq	SE_ShrFil	(open (strcat TestPrmRootPath "Shared Panels\\Data\\SEDivUse.txt") "r")
					Bubba	(if SE_ShrFil
								(while (setq InData (read-line SE_ShrFil))
									(if InData
										(if SE_ShrLst
											(setq	SE_ShrLst	(cons (read (strcat "(" InData ")")) SE_ShrLst))
											(setq	SE_ShrLst	(list (read (strcat "(" InData ")"))))
										)
									)
								)
							)
					SEShrLst	(mapcar (quote car) SE_ShrLst)
					Bubba	(if SE_ShrFil
								(close SE_ShrFil)
							)
			)
		)
		(if (findfile (strcat PrmRootPath "Shared Panels\\Data\\SEDivUse.txt"))
			(setq	SE_ShrFil	(open (strcat PrmRootPath "Shared Panels\\Data\\SEDivUse.txt") "r")
					Bubba	(if SE_ShrFil
								(while (setq InData (read-line SE_ShrFil))
									(if InData
										(if SE_ShrLst
											(setq	SE_ShrLst	(cons (read (strcat "(" InData ")")) SE_ShrLst))
											(setq	SE_ShrLst	(list (read (strcat "(" InData ")"))))
										)
									)
								)
							)
					SEShrLst	(mapcar (quote car) SE_ShrLst)
					Bubba	(if SE_ShrFil
								(close SE_ShrFil)
							)
			)
		)
	)
	(foreach	PanNam
			SELst
			(if (not (member PanNam SEShrLst))
				(if N13ShLst
					(setq	N13ShLst	(cons PanNam N13ShLst))
					(setq	N13ShLst	(list PanNam))
				)
				(if O13ShLst
					(setq	O13ShLst	(cons PanNam O13ShLst))
					(setq	O13ShLst	(list PanNam))
				)
			)
	)
	(if N13ShLst
		(princ (strcat "\nFound {" (itoa (length N13ShLst)) "} panels in SouthEast Folder not in SouthEast List..."))
		(princ "\nFound No panels in SouthEast Folder not in SouthEast List...")
	)
	(foreach	PanNam
			SEShrLst
			(if (not (member PanNam SELst))
				(if N14ShLst
					(setq	N14ShLst	(cons PanNam N14ShLst))
					(setq	N14ShLst	(list PanNam))
				)
				(if O14ShLst
					(setq	O4ShLst	(cons PanNam O4ShLst))
					(setq	O4ShLst	(list PanNam))
				)
			)
	)
	(if N14ShLst
		(princ (strcat "\nFound {" (itoa (length N14ShLst)) "} panels in SouthEast List not in SouthEast Folder..."))
		(princ "\nFound No panels in SouthEast List not in SouthEast Folder...")
	)


	(if Bug (princ "\n{ PanLocaTst exited\n"))
	(princ)
)

(defun GetShrLst ( DivT IsTest /	Bubba InData	; Reads in Share Panel Data
							DivN DivR BigShrFil RetShrLst )
	(if BigShrLst
		(setq	BigShrLst		nil)
	)
	(if IsTest
		(if (findfile (strcat TestPrmRootPath "Shared Panels\\Data\\BgShrUse.txt"))
			(setq	BigShrFil	(open (strcat TestPrmRootPath "Shared Panels\\Data\\BgShrUse.txt") "r")
					Bubba	(if BigShrFil
								(while (setq InData (read-line BigShrFil))
									(if InData
										(if BigShrLst
											(setq	BigShrLst	(cons (read (strcat "(" InData ")")) BigShrLst))
											(setq	BigShrLst	(list (read (strcat "(" InData ")"))))
										)
									)
								)
							)
					Bubba	(if BigShrFil
								(close BigShrFil)
							)
			)
		)
		(if (findfile (strcat PrmRootPath "Shared Panels\\Data\\BgShrUse.txt"))
			(setq	BigShrFil	(open (strcat PrmRootPath "Shared Panels\\Data\\BgShrUse.txt") "r")
					Bubba	(if BigShrFil
								(while (setq InData (read-line BigShrFil))
									(if InData
										(if BigShrLst
											(setq	BigShrLst	(cons (read (strcat "(" InData ")")) BigShrLst))
											(setq	BigShrLst	(list (read (strcat "(" InData ")"))))
										)
									)
								)
							)
					Bubba	(if BigShrFil
								(close BigShrFil)
							)
			)
		)
	)
	(if (not DivT)
		(if Div (setq DivN Div))
	)
	(if BigShrLst
		(cond
			((or (= DivT "BH") (= DivT 1))
				(setq	DivN		2
						DivR		nil
				)
			)
			((or (= DivT "E_") (= DivT 2))
				(setq	DivN		4
						DivR		nil
				)
			)
			((or (= DivT "M_") (= DivT 5))
				(setq	DivN		6
						DivR		nil
				)
			)
			((or (= DivT "S_") (= DivT 3))
				(setq	DivN		8
						DivR		nil
				)
			)
			((or (= DivT "SE") (= DivT 6))
				(setq	DivN		10
						DivR		nil
				)
			)
			((or (= DivT "W_") (= DivT 4))
				(setq	DivN		12
						DivR		nil
				)
			)
			((or (= DivT "SH") (= DivT 7))
				(setq	DivN		13
						DivR		nil
				)
			)
			((or (= DivT "N_") (= DivT 8))
				(setq	DivN		2
						Div2N	4
						Div3N	12
						DivR		2
				)
			)
			((or (= DivT "NE") (= DivT 9))
				(setq	DivN		2
						Div2N	4
						DivR		1
				)
			)
			(T
				(setq	DivN		nil)
			)
		)
	)
	(if (and BigShrLst DivN)
		(cond
			((= DivR 2)
				(foreach	Pan
						BigShrLst
						(if (or (= (nth DivN Pan) 1) (= (nth Div2N Pan) 1) (= (nth Div3N Pan) 1))
							(if RetShrLst
								(setq	RetShrLst	(cons (car Pan) RetShrLst))
								(setq	RetShrLst	(list (car Pan)))
							)
						)
				)
			)
			((= DivR 1)
				(foreach	Pan
						BigShrLst
						(if (or (= (nth DivN Pan) 1) (= (nth Div2N Pan) 1))
							(if RetShrLst
								(setq	RetShrLst	(cons (car Pan) RetShrLst))
								(setq	RetShrLst	(list (car Pan)))
							)
						)
				)
			)
			(T
				(foreach	Pan
						BigShrLst
						(if (= (nth DivN Pan) 1)
							(if RetShrLst
								(setq	RetShrLst	(cons (car Pan) RetShrLst))
								(setq	RetShrLst	(list (car Pan)))
							)
						)
				)
			)
		)
	)
	RetShrLst
)

(defun C:ShrLstComp ( / )					; Calls ShrLstComp - CL
	(ShrLstComp)
	(princ)
)

(defun C:DrawAllPan ( /	RetVal )				; Draw All Panels for Adds Panel Status Dwg
	(setq	RetVal	(DrawAllPan nil))
	(princ "\nNormal Exit")
	(princ)
)

(defun AddsUpGatherAll ( /	DatLst DatLen Cntr	; Collects Data Files into Adds_Up files
						DatFil DatGet		; ChkLst CP_Lst BlkLst SW_Lst MstrFdrLst
						InData FdrTxt FdrNam MinX MinY MaxX MaxY Lent FdrNod OutStat
						ChkFil ChkItm SwFil SW_Itm FdrFil MstrFdrItm BlkFil BlkItm CP_Fil CP_Itm
						ints isecs outs osecs elss Bubba )
	(if (not Twaddle) (load "Utils"))
	(setq	ColWas	(getvar "CECOLOR")
			LtWas	(getvar "CELTYPE")
			LayWas	(getvar "CLAYER")
			CmdWas	(getvar "CMDDIA")
			EchWas	(getvar "CMDECHO")
			ExWas	(getvar "EXPERT")
			FilWas	(getvar "FILEDIA")
			OsWas	(getvar "OSMODE")
			TmdWas	(getvar "TILEMODE")
	)
	(setvar "CMDDIA" 0)
	(setvar "CMDECHO" 0)
	(setvar "EXPERT" 5)
	(setvar "FILEDIA" 0)
	(setvar "OSMODE" 0)
	(if (not GotPath)
		(GetPathPanel DevMark)
	)
	(if (not BigShrLst)
		(GetShrLst 1 nil)
	)
	(setq	DatLst0		(dos_dir (strcat (nth 0 GotPath) "Data\\*.dat"))
			DatLst1		(dos_dir (strcat (nth 1 GotPath) "Data\\*.dat"))
			DatLst2		(dos_dir (strcat (nth 2 GotPath) "Data\\*.dat"))
			DatLst3		(dos_dir (strcat (nth 3 GotPath) "Data\\*.dat"))
			DatLst4		(dos_dir (strcat (nth 4 GotPath) "Data\\*.dat"))
			DatLst5		(dos_dir (strcat (nth 5 GotPath) "Data\\*.dat"))
			DatLst6		(dos_dir (strcat (nth 6 GotPath) "Data\\*.dat"))
			ChkLst		nil
			CP_Lst		nil
			BlkLst		nil
			SW_Lst		nil
			MstrFdrLst	nil
			OutStat		nil
			ints			(getvar "date")
			isecs		(* 86400.0 (- ints (fix ints)))
			Bubba		(if (and Bug isecs) (princ (strcat "\nStart: " (rtos isecs 2 2))))
	)
	(if DatLst0
		(setq	DatLst0	(mapcar (quote (lambda (x) (substr x 1 (- (strlen x) 4)))) DatLst0))
	)
	(if DatLst1
		(setq	DatLst1	(mapcar (quote (lambda (x) (substr x 1 (- (strlen x) 4)))) DatLst1))
	)
	(if DatLst2
		(setq	DatLst2	(mapcar (quote (lambda (x) (substr x 1 (- (strlen x) 4)))) DatLst2))
	)
	(if DatLst3
		(setq	DatLst3	(mapcar (quote (lambda (x) (substr x 1 (- (strlen x) 4)))) DatLst3))
	)
	(if DatLst4
		(setq	DatLst4	(mapcar (quote (lambda (x) (substr x 1 (- (strlen x) 4)))) DatLst4))
	)
	(if DatLst5
		(setq	DatLst5	(mapcar (quote (lambda (x) (substr x 1 (- (strlen x) 4)))) DatLst5))
	)
	(if DatLst6
		(setq	DatLst6	(mapcar (quote (lambda (x) (substr x 1 (- (strlen x) 4)))) DatLst6))
	)
	(if (and DatLst0 DatLst1 DatLst2 DatLst3 DatLst4 DatLst5 DatLst6)
		(setq	DatLst0	(acad_strlsort DatLst0)
				DatLst1	(acad_strlsort DatLst1)
				DatLst2	(acad_strlsort DatLst2)
				DatLst3	(acad_strlsort DatLst3)
				DatLst4	(acad_strlsort DatLst4)
				DatLst5	(acad_strlsort DatLst5)
				DatLst6	(acad_strlsort DatLst6)
				DatLen	(+ (length DatLst0) (length DatLst1) (length DatLst2) (length DatLst3) (length DatLst4) (length DatLst5) (length DatLst6))
				Cntr		0
				LCntr	-1
		)
	)
	(if (and DatLen (not Bug))
		(princ "\nNow gathering Adds_Up data for reporting...")
		(if DatLen
			(princ (strcat "\nNow starting foreach on {" (itoa DatLen) "} DAT files..."))
		)
	)
	(if DatLen
		(while (<= LCntr 6)
			(setq	LCntr	(1+ LCntr)
					DatLst	(nth LCntr (list DatLst0 DatLst1 DatLst2 DatLst3 DatLst4 DatLst5 DatLst6))
			)
			(foreach	DatFil
					DatLst
					(if (not Bug)
						(Twaddle Cntr DatLen)
						(princ ".")
					)
					(setq	DatGet	(open (strcat (nth LCntr GotPath) "Data\\" DatFil ".dat") "r")
							Cntr		(1+ Cntr)
					)
					(if (= LCntr 6)
						(if (assoc DatFil BigShrLst)
							(setq	WhoOwn	(last (assoc DatFil BigShrLst)))
							(setq	WhoOwn	0)
						)
						(setq	WhoOwn	0)
					)
					(if DatGet
						(setq	InData	(read-line DatGet))
						(setq	InData	nil)
					)
					(while InData
						(if InData
							(cond
								((equal (substr InData 1 5) "[CHK]")
									(if ChkLst
										(setq	ChkLst	(cons (substr InData 11) ChkLst))
										(setq	ChkLst	(list (substr InData 11)))
									)
								)
								((equal (substr InData 1 5) "[CP] ")
									(if CP_Lst
										(setq	CP_Lst	(cons (substr InData 11) CP_Lst))
										(setq	CP_Lst	(list (substr InData 11)))
									)
								)
								((equal (substr InData 1 5) "[BLK]")
									(if BlkLst
										(setq	BlkLst	(cons (substr InData 11) BlkLst))
										(setq	BlkLst	(list (substr InData 11)))
									)
								)
								((equal (substr InData 1 5) "[SW] ")
									(if SW_Lst
										(setq	SW_Lst	(cons (substr InData 11) SW_Lst))
										(setq	SW_Lst	(list (substr InData 11)))
									)
								)
								((equal (substr InData 1 5) "[SUB]")
									(setq	FdrTxt	(substr InData 11)
											FdrNam	(substr FdrTxt 1 3)
											SubNam	(substr FdrTxt 1 2)
											MinX		(atof (substr FdrTxt 11 10))
											MinY		(atof (substr FdrTxt 21 10))
											MaxX		(atof (substr FdrTxt 31 10))
											MaxY		(atof (substr FdrTxt 41 10))
											LentOne	(atof (substr FdrTxt 51 12))
											LentTwo	(atof (substr FdrTxt 63 12))
											LentThr	(atof (substr FdrTxt 75 12))
											LentFor	(atof (substr FdrTxt 87 12))
											LentFiv	(atof (substr FdrTxt 99 12))
											LentSix	(atof (substr FdrTxt 111 12))
											LentSvn	(atof (substr FdrTxt 123 12))
											FdrNod	(list FdrNam MinX MinY MaxX MaxY LentOne LentTwo LentThr LentFor LentFiv LentSix LentSvn)
											SubNod	(list SubNam MinX MinY MaxX MaxY LentOne LentTwo LentThr LentFor LentFiv LentSix LentSvn)
									)
									(if MstrFdrLst
										(if (assoc FdrNam MstrFdrLst)
											(setq	MstrFdrLst	(subst	(AddsUpMerge FdrNod (assoc FdrNam MstrFdrLst))
																		(assoc FdrNam MstrFdrLst)
																		MstrFdrLst
																)
											)
											(setq	MstrFdrLst	(cons FdrNod MstrFdrLst))
										)
										(setq	MstrFdrLst	(list FdrNod))
									)
									(if MstrSubLst
										(if (assoc SubNam MstrSubLst)
											(setq	MstrSubLst	(subst	(AddsUpMerge SubNod (assoc SubNam MstrSubLst))
																		(assoc SubNam MstrSubLst)
																		MstrSubLst
																)
											)
											(setq	MstrSubLst	(cons SubNod MstrSubLst))
										)
										(setq	MstrSubLst	(list SubNod))
									)
								)
							)
						)
						(setq	InData	(read-line DatGet))
					)
					(if DatGet (close DatGet))
			)
		)
	)
	(if (and DatLen (not Bug))
		(Twaddle (- 0 Cntr) DatLen)
		(if (and DatLen Bug)
			(princ ".\nDone with foreach\n")
		)
	)
	(if (or ChkLst SW_Lst MstrFdrLst MstrSubLst BlkLst CP_Lst)
		(setq	DatLen	(+	(if ChkLst	(length ChkLst) 0)
							(if SW_Lst	(length SW_Lst) 0)
							(if MstrFdrLst	(length MstrFdrLst) 0)
							(if MstrSubLst	(length MstrSubLst) 0)
							(if BlkLst	(length BlkLst) 0)
							(if CP_Lst	(length CP_Lst) 0)
						)
				Cntr		0
		)
	)
	(if (and DatLen (not Bug))
		(princ "\nNow outputting Adds_Up data: ...")
		(if DatLen
			(princ "\nCreating Adds_Up files: [CHK],[SW],[SUB],[BLK],[CP],[LEN]")
		)
	)
	(if (and DatLen ChkLst)
		(if OutStat
			(setq	OutStat	(strcat OutStat ",[CHK]")
					Bubba	(StatTxt OutStat)
			)
			(setq	OutStat	"AddsUp Processing: [CHK]"
					Bubba	(StatTxt OutStat)
			)
		)
	)
	(if (and DatLen ChkLst)
		(progn
			(setq	ChkFil	(open (strcat (nth 6 GotPath) "Data\\Adds_Up_All.CHK") "w")
					ChkLst	(reverse ChkLst)
			)
			(foreach	ChkItm
					ChkLst
					(setq	Cntr		(1+ Cntr))
					(if (not Bug)
						(Twaddle Cntr DatLen)
						(princ "+")
					)
					(write-line ChkItm ChkFil)
			)
			(close ChkFil)
		)
	)
	(if (and DatLen SW_Lst)
		(if OutStat
			(setq	OutStat	(strcat OutStat ",[SW]")
					Bubba	(StatTxt OutStat)
			)
			(setq	OutStat	"AddsUp Processing: [SW]"
					Bubba	(StatTxt OutStat)
			)
		)
	)
	(if (and DatLen SW_Lst)
		(progn
			(setq	SwFil	(open (strcat (nth 6 GotPath) "Data\\Adds_Up_All.SW") "w")
					CorSwFil	(open (strcat (nth 6 GotPath) "Data\\All_Switch.COR") "w")
					SW_Lst	(reverse SW_Lst)
			)
			(foreach	SW_Itm
					SW_Lst
					(setq	Cntr		(1+ Cntr))
					(if (not Bug)
						(Twaddle Cntr DatLen)
						(princ "*")
					)
					(write-line SW_Itm SwFil)
					(write-line	(strcat	(substr SW_Itm 11 20)
										(substr SW_Itm 11 20)
										(StpSpac (substr SW_Itm 1 10))
								)
								CorSwFil
					)
			)
			(close CorSwFil)
			(close SwFil)
		)
	)
	(if (and DatLen MstrFdrLst)
		(if OutStat
			(setq	OutStat	(strcat OutStat ",[COR]")
					Bubba	(StatTxt OutStat)
			)
			(setq	OutStat	"AddsUp Processing: [COR]"
					Bubba	(StatTxt OutStat)
			)
		)
	)
	(if (and DatLen MstrFdrLst)
		(progn
			(setq	FdrFil		(open (strcat (nth 6 GotPath) "Data\\Adds_Up_All.TMP") "w")
					LenFil		(open (strcat (nth 6 GotPath) "Data\\Adds_Up_All.LEN") "w")
					CorFdrFil		(open (strcat (nth 6 GotPath) "Data\\All_Feeder.COR") "w")
					CorSubFil		(open (strcat (nth 6 GotPath) "Data\\All_Sub.COR") "w")
					MstrFdrLst	(LstSort MstrFdrLst (quote (lambda (x y) (< (car x) (car y)))))
					MstrSubLst	(LstSort MstrSubLst (quote (lambda (x y) (< (car x) (car y)))))
			)
			(foreach	MstrFdrItm
					MstrFdrLst
					(setq	Cntr		(1+ Cntr))
					(if (not Bug)
						(Twaddle Cntr DatLen)
						(princ "&")
					)
					(write-line	(strcat	(PadCharR (rtos (nth 1 MstrFdrItm) 2 0) 10)
										(PadCharR (rtos (nth 2 MstrFdrItm) 2 0) 10)
										(PadCharR (rtos (nth 3 MstrFdrItm) 2 0) 10)
										(PadCharR (rtos (nth 4 MstrFdrItm) 2 0) 10)
										(nth 0 MstrFdrItm)
								)
								CorFdrFil
					)
					(write-line	(strcat	(nth 0 MstrFdrItm)
										(rtos (nth 1 MstrFdrItm) 2 0)
										" "
										(rtos (nth 2 MstrFdrItm) 2 0)
										" "
										(rtos (nth 3 MstrFdrItm) 2 0)
										" "
										(rtos (nth 4 MstrFdrItm) 2 0)
										" "
								)
								FdrFil
					)
					(write-line	(strcat	(nth 0 MstrFdrItm)
										(PadCharL (rtos (nth 5 MstrFdrItm) 2 2) 12)
										(PadCharL (rtos (nth 6 MstrFdrItm) 2 2) 12)
										(PadCharL (rtos (nth 7 MstrFdrItm) 2 2) 12)
										(PadCharL (rtos (nth 8 MstrFdrItm) 2 2) 12)
										(PadCharL (rtos (nth 9 MstrFdrItm) 2 2) 12)
										(PadCharL (rtos (nth 10 MstrFdrItm) 2 2) 12)
										(PadCharL (rtos (nth 11 MstrFdrItm) 2 2) 12)
								)
								LenFil
					)
			)
			(foreach	MstrSubItm
					MstrSubLst
					(setq	Cntr		(1+ Cntr))
					(if (not Bug)
						(Twaddle Cntr DatLen)
						(princ "@")
					)
					(write-line	(strcat	(PadCharR (rtos (nth 1 MstrSubItm) 2 0) 10)
										(PadCharR (rtos (nth 2 MstrSubItm) 2 0) 10)
										(PadCharR (rtos (nth 3 MstrSubItm) 2 0) 10)
										(PadCharR (rtos (nth 4 MstrSubItm) 2 0) 10)
										(nth 0 MstrSubItm)
								)
								CorSubFil
					)
			)
			(close FdrFil)
			(close LenFil)
			(close CorFdrFil)
			(close CorSubFil)
		)
	)
	(if (and DatLen BlkLst)
		(if OutStat
			(setq	OutStat	(strcat OutStat ",[BLK]")
					Bubba	(StatTxt OutStat)
			)
			(setq	OutStat	"AddsUp Processing: [BLK]"
					Bubba	(StatTxt OutStat)
			)
		)
	)
	(if (and DatLen BlkLst)
		(progn
			(setq	BlkFil	(open (strcat (nth 6 GotPath) "Data\\Adds_Up_All.BLK") "w")
					BlkLst	(reverse BlkLst)
			)
			(foreach	BlkItm
					BlkLst
					(setq	Cntr		(1+ Cntr))
					(if (not Bug)
						(Twaddle Cntr DatLen)
						(princ "%")
					)
					(write-line BlkItm BlkFil)
			)
			(close BlkFil)
		)
	)
	(if (and DatLen CP_Lst)
		(if OutStat
			(setq	OutStat	(strcat OutStat ",[CP]")
					Bubba	(StatTxt OutStat)
			)
			(setq	OutStat	"AddsUp Processing: [CP]"
					Bubba	(StatTxt OutStat)
			)
		)
	)
	(if (and DatLen CP_Lst)
		(progn
			(setq	CP_Fil	(open (strcat (nth 6 GotPath) "Data\\Adds_Up_All.CP") "w")
					CP_Lst	(reverse CP_Lst)
			)
			(foreach	CP_Itm
					CP_Lst
					(setq	Cntr		(1+ Cntr))
					(if (not Bug)
						(Twaddle Cntr DatLen)
						(princ "#")
					)
					(write-line CP_Itm CP_Fil)
			)
			(close CP_Fil)
		)
	)
	(if (and DatLen (not Bug))
		(Twaddle (- 0 Cntr) DatLen)
		(if (and DatLen Bug)
			(princ "\nDone with file writing\n\n")
		)
	)
	(if (and DatLen DevMark)
		(setq	outs		(getvar "date")
				osecs	(* 86400.0 (- outs (fix outs)))
				elss		(itoa (fix (- (* osecs 1000.0) (* isecs 1000.0))))
				Bubba	(if (and Bug osecs) (princ (strcat "\nFinish: " (rtos osecs 2 2))))
				Bubba	(princ (strcat "\nElapsed Milliseconds for AddsUpGather: " elss))
		)
	)
	(setvar "CMDDIA" CmdWas)
	(setvar "CMDECHO" EchWas)
	(setvar "EXPERT" ExWas)
	(setvar "FILEDIA" FilWas)
	(setvar "OSMODE" OsWas)
	(princ)
)

(defun BldXCopCmd ( DivT / )					; DivN DivShrLst DivDwgLst
	(if DivT
		(cond
			((or (= DivT "BH") (= DivT 1))
				(setq	DivN		0
						DivT		"BH"
				)
			)
			((or (= DivT "E_") (= DivT 2))
				(setq	DivN		2
						DivT		"E_"
				)
			)
			((or (= DivT "M_") (= DivT 5))
				(setq	DivN		4
						DivT		"M_"
				)
			)
			((or (= DivT "S_") (= DivT 3))
				(setq	DivN		3
						DivT		"S_"
				)
			)
			((or (= DivT "SE") (= DivT 6))
				(setq	DivN		5
						DivT		"SE"
				)
			)
			((or (= DivT "W_") (= DivT 4))
				(setq	DivN		1
						DivT		"W_"
				)
			)
			(T
				(setq	DivN		nil)
			)
		)
	)
	(if (not GotPath)
		(GetPathPanel DevMark)
	)
	(if (and GotPath83 GotPath DivN DivT (or (member (strcase "DosLib14.arx" T) (arx)) (member (strcase "DosLib17.arx" T) (arx))))
		(progn
			(setq	DivShrLst	(GetShrLst DivT nil)
					DivDwgLst	(dos_dir (strcat (nth DivN GotPath) "*.dwg"))
					DivDwgLst	(mapcar (quote (lambda (x) (substr x 1 7))) DivDwgLst)
					CurDrv	(dos_drive)
					CurDir	(dos_pwdir)
					DirLst	(dos_subdir "C:\\")
					DirLst	(mapcar (quote strcase) DirLst)
					Bubba	(if (not (member "QUERYMAP" DirLst))
								(progn
									(dos_drive "C:")
									(dos_chdir "C:\\")
									(dos_mkdir "C:\\QueryMap")
									(dos_chdir "C:\\QueryMap")
									(dos_drive CurDrv)
									(dos_chdir CurDir)
								)
							)
					FilNam	(open (strcat "C:\\QueryMap\\GetQuery_" DivT ".cmd") "w")
					Bubba	(write-line "C:" FilNam)
					Bubba	(write-line "cd \\" FilNam)
					Bubba	(write-line "if not exist QueryM~1. md QueryM~1" FilNam)
					Bubba	(write-line "if exist QueryM~1. cd QueryM~1" FilNam)
					Bubba	(write-line "echo +++++++++++++++++++ >>c:\\querym~1\\UpdQuery.log" FilNam)
					Bubba	(write-line "date /t >>c:\\querym~1\\UpdQuery.log" FilNam)
					Bubba	(write-line "time /t >>c:\\querym~1\\UpdQuery.log" FilNam)
					Bubba	(write-line (strcat "xcopy " (nth DivN GotPath83) "*.dwg C:\\QueryM~1\\*.dwg /D /F >>c:\\querym~1\\UpdQuery.log") FilNam)
			)
			(if DivShrLst
				(foreach	DName
						DivShrLst
						(write-line (strcat "xcopy " (nth 6 GotPath83) DName ".dwg C:\\QueryM~1 /I /D /F >>c:\\querym~1\\UpdQuery.log") FilNam)
				)
			)
			(if (findfile "C:\\Program Files\\AutoDesk\\AcadMap2\\Acad.exe")
				(write-line "C:\\Program Files\\AutoDesk\\AcadMap2\\Acad.exe /p Acad" FilNam)
			)
			(if FilNam (close FilNam))
		)
	)
	(princ)
)

(defun GetPathPanel ( IsTest /	MapQ	)		; Sets Globals GotPath & GotPath83
	(if Bug (princ "\n{GetPathPanel entered\n"))
	(setq	MapQ		(getenv "MapQry"))
	(if IsTest
		(if (and EdsLocal MapQ)
			(setq	GotPath	(list	(strcat MapQ "\\MapQry\\Adds_BH\\")
									(strcat MapQ "\\MapQry\\Adds_W_\\")
									(strcat MapQ "\\MapQry\\Adds_E_\\")
									(strcat MapQ "\\MapQry\\Adds_S_\\")
									(strcat MapQ "\\MapQry\\Adds_M_\\")
									(strcat MapQ "\\MapQry\\Adds_SE\\")
									(strcat MapQ "\\MapQry\\Adds_SH\\")
									(strcat MapQ "\\MapQry\\Cadet_UG\\Clean_BH\\")
									(strcat MapQ "\\MapQry\\Cadet_UG\\Clean_E\\")
									(strcat MapQ "\\MapQry\\Cadet_UG\\Clean_M\\")
									(strcat MapQ "\\MapQry\\Cadet_UG\\Clean_S\\")
									(strcat MapQ "\\MapQry\\Cadet_UG\\Clean_W\\")
							)
					GotPath83	(list	(strcat MapQ "\\MapQry\\Adds_BH\\")
									(strcat MapQ "\\MapQry\\Adds_W_\\")
									(strcat MapQ "\\MapQry\\Adds_E_\\")
									(strcat MapQ "\\MapQry\\Adds_S_\\")
									(strcat MapQ "\\MapQry\\Adds_M_\\")
									(strcat MapQ "\\MapQry\\Adds_SE\\")
									(strcat MapQ "\\MapQry\\Adds_SH\\")
									(strcat MapQ "\\MapQry\\Cadet_UG\\Clean_BH\\")
									(strcat MapQ "\\MapQry\\Cadet_UG\\Clean_E\\")
									(strcat MapQ "\\MapQry\\Cadet_UG\\Clean_M\\")
									(strcat MapQ "\\MapQry\\Cadet_UG\\Clean_S\\")
									(strcat MapQ "\\MapQry\\Cadet_UG\\Clean_W\\")
							)
			)
			(setq	GotPath	(list	(strcat TestPrmRootPath "DivData\\Birmingham\\Adds\\Panel\\")
									(strcat TestPrmRootPath "DivData\\Western\\Adds\\Panel\\")
									(strcat TestPrmRootPath "DivData\\Eastern\\Adds\\Panel\\")
									(strcat TestPrmRootPath "DivData\\Southern\\Adds\\Panel\\")
									(strcat TestPrmRootPath "DivData\\Mobile\\Adds\\Panel\\")
									(strcat TestPrmRootPath "DivData\\SouthEast\\Adds\\Panel\\")
									(strcat TestPrmRootPath "Shared Panels\\")
									"S:\\Workgroups\\APC Birmingham Division\\Division Mapping\\UnderGround\\"
									"S:\\Workgroups\\APC Eastern Division\\Division Mapping\\UnderGround\\"
									"S:\\Workgroups\\APC Mobile Division\\Division Mapping\\UnderGround\\"
									"S:\\Workgroups\\APC Southern Division\\Division Mapping\\UnderGround\\"
									"S:\\Workgroups\\APC Western Division\\Division Mapping\\UnderGround\\"
							)
					GotPath83	(list	"S:\\Workgr~1\\APCPow~1\\Divisi~2\\DivData\\Birmin~1\\Adds\\Panel\\"
									"S:\\Workgr~1\\APCPow~1\\Divisi~2\\DivData\\Western\\Adds\\Panel\\"
									"S:\\Workgr~1\\APCPow~1\\Divisi~2\\DivData\\Eastern\\Adds\\Panel\\"
									"S:\\Workgr~1\\APCPow~1\\Divisi~2\\DivData\\Southe~1\\Adds\\Panel\\"
									"S:\\Workgr~1\\APCPow~1\\Divisi~2\\DivData\\Mobile\\Adds\\Panel\\"
									"S:\\Workgr~1\\APCPow~1\\Divisi~2\\DivData\\SouthE~2\\Adds\\Panel\\"
									"S:\\Workgr~1\\APCPow~1\\Divisi~2\\Shared~1\\"
									"S:\\Workgroups\\APC Birmingham Division\\Division Mapping\\UnderGround\\"
									"S:\\Workgroups\\APC Eastern Division\\Division Mapping\\UnderGround\\"
									"S:\\Workgroups\\APC Mobile Division\\Division Mapping\\UnderGround\\"
									"S:\\Workgroups\\APC Southern Division\\Division Mapping\\UnderGround\\"
									"S:\\Workgroups\\APC Western Division\\Division Mapping\\UnderGround\\"
							)
			)
		)
		(setq	GotPath	(list	"S:\\WorkGroups\\APC Birmingham Division\\Division Mapping\\Adds\\Panel\\"
								"S:\\WorkGroups\\APC Western Division\\Division Mapping\\Adds\\Panel\\"
								"S:\\WorkGroups\\APC Eastern Division\\Division Mapping\\Adds\\Panel\\"
								"S:\\WorkGroups\\APC Southern Division\\Division Mapping\\Adds\\Panel\\"
								"S:\\WorkGroups\\APC Mobile Division\\Division Mapping\\Adds\\Panel\\"
								"S:\\WorkGroups\\APC SouthEast Division\\Division Mapping\\Adds\\Panel\\"
								(strcat PrmRootPath "Shared Panels\\")
								"S:\\Workgroups\\APC Birmingham Division\\Division Mapping\\UnderGround\\"
								"S:\\Workgroups\\APC Eastern Division\\Division Mapping\\UnderGround\\"
								"S:\\Workgroups\\APC Mobile Division\\Division Mapping\\UnderGround\\"
								"S:\\Workgroups\\APC Southern Division\\Division Mapping\\UnderGround\\"
								"S:\\Workgroups\\APC Western Division\\Division Mapping\\UnderGround\\"
						)
				GotPath83	(list	"S:\\WorkGr~1\\APCBir~1\\Divisi~1\\Adds\\Panel\\"
								"S:\\WorkGr~1\\APCWes~1\\Divisi~1\\Adds\\Panel\\"
								"S:\\WorkGr~1\\APCEas~1\\Divisi~1\\Adds\\Panel\\"
								"S:\\WorkGr~1\\APCSou~1\\Divisi~1\\Adds\\Panel\\"
								"S:\\WorkGr~1\\APCMob~1\\Divisi~1\\Adds\\Panel\\"
								"S:\\WorkGr~1\\APCSou~2\\Divisi~1\\Adds\\Panel\\"
								"S:\\Workgr~1\\APCPow~1\\Divisi~1\\Shared~1\\"
								"S:\\Workgroups\\APC Birmingham Division\\Division Mapping\\UnderGround\\"
								"S:\\Workgroups\\APC Eastern Division\\Division Mapping\\UnderGround\\"
								"S:\\Workgroups\\APC Mobile Division\\Division Mapping\\UnderGround\\"
								"S:\\Workgroups\\APC Southern Division\\Division Mapping\\UnderGround\\"
								"S:\\Workgroups\\APC Western Division\\Division Mapping\\UnderGround\\"
						)
		)
	)
	(if Bug (princ "\nGetPathPanel exited}\n"))
	(princ)
)

(defun C:DetPanLck ( / )					; CL - Detects number of Locked Panels in each Division
	(DetLck)
	(princ)
)

(defun DetLck ( /	Cntr CntDiv Lck			; Detects number of Locked Panels in each Division
				FN_Lck FN_R FN_Inp )
	(setq	LckLst	nil
			GotPath	nil
	)
	(if DevMark
		(BldLckLst T)
		(BldLckLst nil)
	)
	(if (and LckLst GotPath)
		(progn
			(setq	Cntr		0)
			(while (<= Cntr 6)
				(cond
					((= Cntr 0) (setq CntDiv "Birmingham"))
					((= Cntr 1) (setq CntDiv "Western"))
					((= Cntr 2) (setq CntDiv "Eastern"))
					((= Cntr 3) (setq CntDiv "Southern"))
					((= Cntr 4) (setq CntDiv "Mobile"))
					((= Cntr 5) (setq CntDiv "SouthEastern"))
					((= Cntr 6) (setq CntDiv "Shared"))
				)
				(if (nth Cntr LckLst)
					(princ (strcat "\nPanels Locked in " CntDiv " Division:\n"))
				)
				(if (nth Cntr LckLst)
					(foreach	Lck
							(nth Cntr LckLst)
							(setq	FN_Lck	(strcat (nth Cntr GotPath) "Locked\\" Lck ".lck")
									FN_R		(open FN_Lck "r")
									FN_Inp	(read-line FN_R)
									Bubba	(close FN_R)
									Bubba	(princ (strcat FN_Inp "\n"))
							)
					)
				)
				(setq	Cntr		(1+ Cntr))
			)
		)
	)
	(princ)
)

(defun C:LastAddsUp ( / )					; CL - Detects Last Adds_Up in each Division
	(LstUp)
	(princ)
)

(defun LstUp ( /	Cntr CntDiv Lck			; Detects Last Adds_Up in each Division
				FN_Lck FN_R FN_Inp )
	(if (not GotPath)
		(if DevMark
			(BldLckLst T)
			(BldLckLst nil)
		)
	)
	(if (not PadCharL)
		(lod "Utils")
	)
	(setq	Cntr		0)
	(princ "\nAdds_Up (date, time & size of Adds_Up_Blk shown) Last Run:")
	(while (<= Cntr 6)
		(cond
			((= Cntr 0)
				(setq	CntDiv	"Birmingham"
						FN_Up	(strcat (nth Cntr GotPath) "Adds_Up.Blk")
						FN_Dat	(dos_file FN_Up)
						FN_Siz	(nth 1 FN_Dat)
						FN_Lst	(nth 2 FN_Dat)
						FN_Tim	(nth 3 FN_Dat)
						Bubba	(princ	(strcat	"\n"
												CntDiv
												":\t"
												FN_Lst
												(PadCharL FN_Tim 10)
												(PadCharL FN_Siz 12)
										)
								)
				)
			)
			((= Cntr 1)
				(setq	CntDiv	"Western"
						FN_Up	(strcat (nth Cntr GotPath) "Adds_Up.Blk")
						FN_Dat	(dos_file FN_Up)
						FN_Siz	(nth 1 FN_Dat)
						FN_Lst	(nth 2 FN_Dat)
						FN_Tim	(nth 3 FN_Dat)
						Bubba	(princ	(strcat	"\n"
												CntDiv
												":\t"
												FN_Lst
												(PadCharL FN_Tim 10)
												(PadCharL FN_Siz 12)
										)
								)
				)
			)
			((= Cntr 2)
				(setq	CntDiv	"Eastern"
						FN_Up	(strcat (nth Cntr GotPath) "Adds_Up.Blk")
						FN_Dat	(dos_file FN_Up)
						FN_Siz	(nth 1 FN_Dat)
						FN_Lst	(nth 2 FN_Dat)
						FN_Tim	(nth 3 FN_Dat)
						Bubba	(princ	(strcat	"\n"
												CntDiv
												":\t"
												FN_Lst
												(PadCharL FN_Tim 10)
												(PadCharL FN_Siz 12)
										)
								)
				)
			)
			((= Cntr 3)
				(setq	CntDiv	"Southern"
						FN_Up	(strcat (nth Cntr GotPath) "Adds_Up.Blk")
						FN_Dat	(dos_file FN_Up)
						FN_Siz	(nth 1 FN_Dat)
						FN_Lst	(nth 2 FN_Dat)
						FN_Tim	(nth 3 FN_Dat)
						Bubba	(princ	(strcat	"\n"
												CntDiv
												":\t"
												FN_Lst
												(PadCharL FN_Tim 10)
												(PadCharL FN_Siz 12)
										)
								)
				)
			)
			((= Cntr 4)
				(setq	CntDiv	"Mobile"
						FN_Up	(strcat (nth Cntr GotPath) "Adds_Up.Blk")
						FN_Dat	(dos_file FN_Up)
						FN_Siz	(nth 1 FN_Dat)
						FN_Lst	(nth 2 FN_Dat)
						FN_Tim	(nth 3 FN_Dat)
						Bubba	(princ	(strcat	"\n"
												CntDiv
												":\t"
												FN_Lst
												(PadCharL FN_Tim 10)
												(PadCharL FN_Siz 12)
										)
								)
				)
			)
			((= Cntr 5)
				(setq	CntDiv	"SouthEastern"
						FN_Up	(strcat (nth Cntr GotPath) "Adds_Up.Blk")
						FN_Dat	(dos_file FN_Up)
						FN_Siz	(nth 1 FN_Dat)
						FN_Lst	(nth 2 FN_Dat)
						FN_Tim	(nth 3 FN_Dat)
						Bubba	(princ	(strcat	"\n"
												CntDiv
												":\t"
												FN_Lst
												(PadCharL FN_Tim 10)
												(PadCharL FN_Siz 12)
										)
								)
				)
			)
			((= Cntr 6)
				(setq	CntDiv	"Shared"
						FN_Up	(strcat (nth Cntr GotPath) "Data\\Adds_Up_All.Blk")
						FN_Dat	(dos_file FN_Up)
						FN_Siz	(nth 1 FN_Dat)
						FN_Lst	(nth 2 FN_Dat)
						FN_Tim	(nth 3 FN_Dat)
						Bubba	(princ	(strcat	"\n"
												CntDiv
												":\t"
												FN_Lst
												(PadCharL FN_Tim 10)
												(PadCharL FN_Siz 12)
										)
								)
				)
			)
		)
		(setq	Cntr		(1+ Cntr))
	)
	(princ)
)

(defun BldLckLst ( IsTest / )				; Builds List of Locked Panels
	(if (not LckLst)
		(progn
			(if (not GotPath)
				(GetPathPanel IsTest)
			)
			(setq	LFilB	(dos_dir (strcat (nth 0 GotPath) "Locked\\*.lck"))
					BLstL	(mapcar (quote (lambda (x) (substr x 1 7))) LFilB)
					LFilW	(dos_dir (strcat (nth 1 GotPath) "Locked\\*.lck"))
					WLstL	(mapcar (quote (lambda (x) (substr x 1 7))) LFilW)
					LFilE	(dos_dir (strcat (nth 2 GotPath) "Locked\\*.lck"))
					ELstL	(mapcar (quote (lambda (x) (substr x 1 7))) LFilE)
					LFilS	(dos_dir (strcat (nth 3 GotPath) "Locked\\*.lck"))
					SLstL	(mapcar (quote (lambda (x) (substr x 1 7))) LFilS)
					LFilM	(dos_dir (strcat (nth 4 GotPath) "Locked\\*.lck"))
					MLstL	(mapcar (quote (lambda (x) (substr x 1 7))) LFilM)
					LFilSE	(dos_dir (strcat (nth 5 GotPath) "Locked\\*.lck"))
					SELstL	(mapcar (quote (lambda (x) (substr x 1 7))) LFilSE)
					LFilSH	(dos_dir (strcat (nth 6 GotPath) "Locked\\*.lck"))
					SHLstL	(mapcar (quote (lambda (x) (substr x 1 7))) LFilSH)
					LckLst	(list BLstL WLstL ELstL SLstL MLstL SELstL SHLstL)
			)
		)
	)
)

(defun DrawAllPan ( IsTest /	dSiz dBlip dEcho	; Draw All Panels for Adds Panel Status Dwg
						UnqCnt
						Jul_j Jul_cdate Jul_c Jul_y Jul_m Jul_d Jul_hh Jul_mm Jul_ss Jul_msec Jul_dow Jul_moy Jul_Txt
						dFilB BLst LFilB BLstL
						dFilW WLst LFilW WLstL
						dFilE ELst LFilE ELstL
						dFilS SLst LFilS SLstL
						dFilM MLst LFilM MLstL
						dFilSE SELst LFilSE SELstL )
	(if Bug (princ "\n{DrawAllPan entered\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			ColWas	(getvar "CECOLOR")
			LtWas	(getvar "CELTYPE")
			LayWas	(getvar "CLAYER")
			CmdWas	(getvar "CMDDIA")
			EchWas	(getvar "CMDECHO")
			FilWas	(getvar "FILEDIA")
			OsWas	(getvar "OSMODE")
	)
	
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
		)
	)
	(command "_.UNDO" "_BE")
	(if (not Jtod)
		(load "Julian")
	)
	(setq	dSiz		800.0				; (getreal "\nInput size of text <800>: ")
			UnqCnt	0
	)
	(setq	Jul_j		(getvar "date"))
	(setq	Jul_cdate		(jtod Jul_j)
			Jul_c		(fix Jul_cdate)
			Jul_y		(/ Jul_c 10000)			; Get year
			Jul_m		(rem (/ Jul_c 100) 100)		; Get month
			Jul_d		(rem Jul_c 100)			; Get day
			Jul_c		(- Jul_cdate (fix Jul_cdate))	; Strip date from date/time
			Jul_c		(fix (* Jul_c 1000000000))	; Scale time to get HHMMSSmmm integer
			Jul_hh		(/ Jul_c 10000000)			; Get hours
			Jul_mm		(rem (/ Jul_c 100000) 100)	; Get minutes
			Jul_ss		(rem (/ Jul_c 1000) 100)		; Get seconds
			Jul_msec		(rem Jul_c 1000)			; Get milliseconds
			Jul_dow		(nth (jtow Jul_j) (list "Sun" "Mon" "Tue" "Wed" "Thu" "Fri" "Sat"))
			Jul_moy		(nth Jul_m (list "NotAMonth" "January" "February" "March" "April" "May" "June" "July" "August" "September" "October" "November" "December"))
			Jul_Txt		(strcat	Jul_moy
								" "
								(itoa Jul_d)
								", "
								(itoa Jul_y)
						)
	)
	(if (not dSiz)
		(setq	dSiz		800.0)
		(if (< dSiz 1.0)
			(setq	dSiz		800.0)
		)
	)
	(if (not GotPath)
		(GetPathPanel IsTest)
	)
	(setq	dFilB	(dos_dir (strcat (nth 0 GotPath) "*.dwg"))
			BLst		(mapcar (quote (lambda (x) (substr x 1 7))) dFilB)
			LFilB	(dos_dir (strcat (nth 0 GotPath) "Locked\\*.lck"))
			BLstL	(mapcar (quote (lambda (x) (substr x 1 7))) LFilB)
			dFilW	(dos_dir (strcat (nth 1 GotPath) "*.dwg"))
			WLst		(mapcar (quote (lambda (x) (substr x 1 7))) dFilW)
			LFilW	(dos_dir (strcat (nth 1 GotPath) "Locked\\*.lck"))
			WLstL	(mapcar (quote (lambda (x) (substr x 1 7))) LFilW)
			dFilE	(dos_dir (strcat (nth 2 GotPath) "*.dwg"))
			ELst		(mapcar (quote (lambda (x) (substr x 1 7))) dFilE)
			LFilE	(dos_dir (strcat (nth 2 GotPath) "Locked\\*.lck"))
			ELstL	(mapcar (quote (lambda (x) (substr x 1 7))) LFilE)
			dFilS	(dos_dir (strcat (nth 3 GotPath) "*.dwg"))
			SLst		(mapcar (quote (lambda (x) (substr x 1 7))) dFilS)
			LFilS	(dos_dir (strcat (nth 3 GotPath) "Locked\\*.lck"))
			SLstL	(mapcar (quote (lambda (x) (substr x 1 7))) LFilS)
			dFilM	(dos_dir (strcat (nth 4 GotPath) "*.dwg"))
			MLst		(mapcar (quote (lambda (x) (substr x 1 7))) dFilM)
			LFilM	(dos_dir (strcat (nth 4 GotPath) "Locked\\*.lck"))
			MLstL	(mapcar (quote (lambda (x) (substr x 1 7))) LFilM)
			dFilSE	(dos_dir (strcat (nth 5 GotPath) "*.dwg"))
			SELst	(mapcar (quote (lambda (x) (substr x 1 7))) dFilSE)
			LFilSE	(dos_dir (strcat (nth 5 GotPath) "Locked\\*.lck"))
			SELstL	(mapcar (quote (lambda (x) (substr x 1 7))) LFilSE)
			dFilSH	(dos_dir (strcat (nth 6 GotPath) "*.dwg"))
			SHLst	(mapcar (quote (lambda (x) (substr x 1 7))) dFilSH)
			LFilSH	(dos_dir (strcat (nth 6 GotPath) "Locked\\*.lck"))
			SHLstL	(mapcar (quote (lambda (x) (substr x 1 7))) LFilSH)
			LckLst	(list BLstL WLstL ELstL SLstL MLstL SELstL SHLstL)
	)
	(command "_.LAYER" "M" (strcat "PanLst-" "Bham") "C" "7" "" "")
	(PanMak BLst dSiz)
	(setq	BTxt		(strcat	(itoa (length BLst))
							" Panels"
					)
	)
	(if BLstL
		(progn
			(command "_.LAYER" "M" (strcat "PanLst-" "Bham" "-Lock") "C" "7" "" "")
			(PSldMak BLstL 7)
			(setq	BTxt		(strcat	(itoa (length BLstL))
									" Locked, "
									BTxt
							)
			)
		)
	)
	(if BTxt
		(command	"_.TEXT"	"J" "MR"
						(list 577000.0 3390000.0)
						(* dSiz 2.0) "0"
						BTxt
				"_.TEXT"	"J" "ML"
						(list 587000.0 3390000.0)
						(* dSiz 2.0) "0"
						"Birmingham Division"
		)
	)
	(if BTxt
		(PanMak (list "5793388") 0.0)
	)
	(command "_.LAYER" "M" (strcat "PanLst-" "Bham" "-Fill") "C" "11" "" "")
	(PSldMak BLst 6)
	(PSldMak (list "5793388") 6)
	;==========================================================================
	(command "_.LAYER" "M" (strcat "PanLst-" "West") "C" "7" "" "")
	(PanMak WLst dSiz)
	(setq	WTxt		(strcat	(itoa (length WLst))
							" Panels"
					)
	)
	(if WLstL
		(progn
			(command "_.LAYER" "M" (strcat "PanLst-" "West" "-Lock") "C" "7" "" "")
			(PSldMak WLstL 8)
			(setq	WTxt		(strcat	(itoa (length WLstL))
									" Locked, "
									WTxt
							)
			)
		)
	)
	(command	"_.TEXT"	"J" "M"
					(list 577000.0 3396000.0)
					(* dSiz 2.0) "0"
					(strcat	"There are "
							(itoa	(+	(length SHLst)
										(length BLst)
										(length ELst)
										(length MLst)
										(length SELst)
										(length SLst)
										(length WLst)
									)
							)
							" Panels Statewide and "
							(itoa (length SHLst))
							" of them are Shared."
					)
	)
	(if WTxt
		(command	"_.TEXT"	"J" "MR"
						(list 577000.0 3360000.0)
						(* dSiz 2.0) "0"
						WTxt
				"_.TEXT"	"J" "ML"
						(list 587000.0 3360000.0)
						(* dSiz 2.0) "0"
						"Western Division"
				"_.TEXT"	"J" "M"
						(list 582000.0 3348000.0)
						(* dSiz 4.0) "0"
						"ADDS Data Coverage"
				"_.TEXT"	"J" "M"
						(list 582000.0 3342000.0)
						(* dSiz 4.0) "0"
						(strcat "Current as of: " Jul_Txt)
		)
	)
	(if WTxt
		(PanMak (list "5793358") 0.0)
	)
	(command "_.LAYER" "M" (strcat "PanLst-" "West" "-Fill") "C" "41" "" "")
	(PSldMak WLst 6)
	(PSldMak (list "5793358") 6)
	;==========================================================================
	(command "_.LAYER" "M" (strcat "PanLst-" "East") "C" "7" "" "")
	(PanMak ELst dSiz)
	(setq	ETxt		(strcat	(itoa (length ELst))
							" Panels"
					)
	)
	(if ELstL
		(progn
			(command "_.LAYER" "M" (strcat "PanLst-" "East" "-Lock") "C" "7" "" "")
			(PSldMak ELstL 9)
			(setq	ETxt		(strcat	(itoa (length ELstL))
									" Locked, "
									ETxt
							)
			)
		)
	)
	(if ETxt
		(command	"_.TEXT"	"J" "MR"
						(list 577000.0 3384000.0)
						(* dSiz 2.0) "0"
						ETxt
				"_.TEXT"	"J" "ML"
						(list 587000.0 3384000.0)
						(* dSiz 2.0) "0"
						"Eastern Division"
		)
	)
	(if ETxt
		(PanMak (list "5793382") 0.0)
	)
	(command "_.LAYER" "M" (strcat "PanLst-" "East" "-Fill") "C" "81" "" "")
	(PSldMak ELst 6)
	(PSldMak (list "5793382") 6)
	;==========================================================================
	(command "_.LAYER" "M" (strcat "PanLst-" "Mobile") "C" "7" "" "")
	(PanMak MLst dSiz)
	(setq	MTxt		(strcat	(itoa (length MLst))
							" Panels"
					)
	)
	(if MLstL
		(progn
			(command "_.LAYER" "M" (strcat "PanLst-" "Mobile" "-Lock") "C" "7" "" "")
			(PSldMak MLstL 10)
			(setq	MTxt		(strcat	(itoa (length MLstL))
									" Locked, "
									MTxt
							)
			)
		)
	)
	(if MTxt
		(command	"_.TEXT"	"J" "MR"
						(list 577000.0 3378000.0)
						(* dSiz 2.0) "0"
						MTxt
				"_.TEXT"	"J" "ML"
						(list 587000.0 3378000.0)
						(* dSiz 2.0) "0"
						"Mobile Division"
		)
	)
	(if MTxt
		(PanMak (list "5793376") 0.0)
	)
	(command "_.LAYER" "M" (strcat "PanLst-" "Mobile" "-Fill") "C" "121" "" "")
	(PSldMak MLst 6)
	(PSldMak (list "5793376") 6)
	;==========================================================================
	(command "_.LAYER" "M" (strcat "PanLst-" "South") "C" "7" "" "")
	(PanMak SLst dSiz)
	(setq	STxt		(strcat	(itoa (length SLst))
							" Panels"
					)
	)
	(if SLstL
		(progn
			(command "_.LAYER" "M" (strcat "PanLst-" "South" "-Lock") "C" "7" "" "")
			(PSldMak SLstL 11)
			(setq	STxt		(strcat	(itoa (length SLstL))
									" Locked, "
									STxt
							)
			)
		)
	)
	(if STxt
		(command	"_.TEXT"	"J" "MR"
						(list 577000.0 3372000.0)
						(* dSiz 2.0) "0"
						STxt
				"_.TEXT"	"J" "ML"
						(list 587000.0 3372000.0)
						(* dSiz 2.0) "0"
						"Southern Division"
		)
	)
	(if STxt
		(PanMak (list "5793370") 0.0)
	)
	(command "_.LAYER" "M" (strcat "PanLst-" "South" "-Fill") "C" "171" "" "")
	(PSldMak SLst 6)
	(PSldMak (list "5793370") 6)
	;==========================================================================
	(command "_.LAYER" "M" (strcat "PanLst-" "SEast") "C" "7" "" "")
	(PanMak SELst dSiz)
	(setq	SETxt		(strcat	(itoa (length SELst))
								" Panels"
					)
	)
	(if SELstL
		(progn
			(command "_.LAYER" "M" (strcat "PanLst-" "SEast" "-Lock") "C" "7" "" "")
			(PSldMak SELstL 12)
			(setq	SETxt		(strcat	(itoa (length SELstL))
										" Locked, "
										SETxt
								)
			)
		)
	)
	(if SETxt
		(command	"_.TEXT"	"J" "MR"
						(list 577000.0 3366000.0)
						(* dSiz 2.0) "0"
						SETxt
				"_.TEXT"	"J" "ML"
						(list 587000.0 3366000.0)
						(* dSiz 2.0) "0"
						"SouthEastern Division"
		)
	)
	(if SETxt
		(PanMak (list "5793364") 0.0)
	)
	(command "_.LAYER" "M" (strcat "PanLst-" "SEast" "-Fill") "C" "211" "" "")
	(PSldMak SELst 6)
	(PSldMak (list "5793364") 6)
	;==========================================================================
	(command "_.LAYER" "M" (strcat "PanLst-" "Shared") "C" "7" "" "")
	(PanMak SHLst dSiz)
	(setq	SHTxt		(strcat	(itoa (length SHLst))
							" Panels"
					)
	)
	(if SHLstL
		(progn
			(command "_.LAYER" "M" (strcat "PanLst-" "Shared" "-Lock") "C" "7" "" "")
			(PSldMak SHLstL 8)
			(setq	SHTxt		(strcat	(itoa (length SHLstL))
									" Locked, "
									SHTxt
							)
			)
		)
	)
	(if SHTxt
		(command	"_.TEXT"	"J" "MR"
						(list 577000.0 3354000.0)
						(* dSiz 2.0) "0"
						SHTxt
				"_.TEXT"	"J" "ML"
						(list 587000.0 3354000.0)
						(* dSiz 2.0) "0"
						"Shared Panels"
		)
	)
	(if SHTxt
		(PanMak (list "5793352") 0.0)
	)
	(command "_.LAYER" "M" (strcat "PanLst-" "Shared" "-Fill") "C" "254" "" "")
	(PSldMak SHLst 6)
	(PSldMak (list "5793352") 6)
	;==========================================================================
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CELTYPE" LtWas)
	(setvar "CLAYER" LayWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CMDECHO" EchWas)
	(setvar "FILEDIA" FilWas)
	(setvar "OSMODE" OsWas)
	(if Bug (princ "\nDrawAllPan exited}\n"))
)

(defun PanMak ( ImpLst dSiz /	Imp LX LY		; Panel Maker for Adds Panel Status Dwg
							UX UY )
	(foreach	Imp
			ImpLst
			(setq	LX	(* 1000.0 (atof (substr Imp 1 3)))
					LY	(* 1000.0 (atof (substr Imp 4 4)))
					UX	(+ LX 6000.0)
					UY	(+ LY 4000.0)
			)
			(command "_.PLINE"	(list LX LY)
							"W" "0.0" "0.0"
							(list UX LY)
							(list UX UY)
							(list LX UY)
							"C"
			)
			(if (> dSiz 1.0)
				(if Lst_Pan_ID
					(if (setq	Pan_ID (assoc Imp Lst_Pan_ID))
						(progn
							(command "_.TEXT"	"J" "M"
											(list (+ LX 3000.0) (+ LY 1333.3))
											dSiz "0"
											Imp
							)
							(setq	ColWas	(getvar "CECOLOR"))
							(setvar "CECOLOR" "5")
							(command "_.TEXT"	"J" "M"
											(list (+ LX 3000.0) (+ LY 2666.6))
											dSiz "0"
											(itoa (cadr Pan_ID))
							)
							(setvar "CECOLOR" ColWas)
						)
						(command "_.TEXT"	"J" "M"
										(list (+ LX 3000.0) (+ LY 2000.0))
										dSiz "0"
										Imp
						)
					)
					(command "_.TEXT"	"J" "M"
									(list (+ LX 3000.0) (+ LY 2000.0))
									dSiz "0"
									Imp
					)
				)
			)
	)
)

(defun PSldMak ( ImpLst Act /	Imp LX LY		; Partial Solid Maker for Adds Panel Status Dwg
							UX UY MX MY CPt Pt1 Pt2 Pt3 Pt4 Pt5 Pt6 Pt7 Pt8 Pt9
							Pt0 PtA PtB PtC PtD PtE PtF PtG PtH )
	(foreach	Imp
			ImpLst
			(setq	LX	(* 1000.0 (atof (substr Imp 1 3)))
					LY	(* 1000.0 (atof (substr Imp 4 4)))
					UX	(+ LX 6000.0)
					UY	(+ LY 4000.0)
					MX	(+ LX 3000.0)
					MY	(+ LY 2000.0)
					CPt	(list MX MY)
					Pt1	(list (+ LX 500.0) UY)
					Pt2	(list (- MX 500.0) UY)
					Pt3	(list (+ MX 500.0) UY)
					Pt4	(list (- UX 500.0) UY)
					Pt5	(list UX (- UY 500.0))
					Pt6	(list UX (+ LY 500.0))
					Pt7	(list (- UX 500.0) LY)
					Pt8	(list (+ MX 500.0) LY)
					Pt9	(list (- MX 500.0) LY)
					Pt0	(list (+ LX 500.0) LY)
					PtA	(list LX (+ LY 500.0))
					PtB	(list LX (- UY 500.0))
					PtC	(list LX UY)
					PtD	(list LX LY)
					PtE	(list UX LY)
					PtF	(list UX UY)
					PtG	(list MX UY)
					PtH	(list MX LY)
			)
			(cond
				((= Act 0)	; Birmingham Share
					(command "_.SOLID"	PtC
									CPt
									PtG
									""
									""
					)
				)
				((= Act 1)	; Western Share
					(command "_.SOLID"	PtD
									CPt
									PtC
									""
									""
					)
				)
				((= Act 2)	; Eastern Share
					(command "_.SOLID"	CPt
									PtF
									PtG
									""
									""
					)
				)
				((= Act 3)	; Mobile Share
					(command "_.SOLID"	PtE
									CPt
									PtF
									""
									""
					)
				)
				((= Act 4)	; Southern Share
					(command "_.SOLID"	PtH
									CPt
									PtE
									""
									""
					)
				)
				((= Act 5)	; SouthEastern Share
					(command "_.SOLID"	PtD
									CPt
									PtH
									""
									""
					)
				)
				((= Act 6)	; Complete Fill
					(command "_.SOLID"	(list LX LY)
									(list UX LY)
									(list LX UY)
									(list UX UY)
									""
					)
				)
				((= Act 7)	; Birmingham Lock
					(command "_.SOLID"	Pt1
									(inters Pt1 CPt PtB Pt5)
									Pt2
									(inters Pt2 CPt PtB Pt5)
									""
					)
				)
				((= Act 8)	; Western Lock
					(command "_.SOLID"	PtA
									(inters Pt1 Pt0 PtA CPt)
									PtB
									(inters Pt1 Pt0 PtB CPt)
									""
					)
				)
				((= Act 9)	; Eastern Lock
					(command "_.SOLID"	Pt3
									(inters Pt3 CPt PtB Pt5)
									Pt4
									(inters Pt4 CPt PtB Pt5)
									""
					)
				)
				((= Act 10)	; Mobile Lock
					(command "_.SOLID"	Pt5
									(inters Pt4 Pt7 Pt5 CPt)
									Pt6
									(inters Pt4 Pt7 Pt6 CPt)
									""
					)
				)
				((= Act 11)	; Southern Lock
					(command "_.SOLID"	Pt8
									(inters Pt8 CPt PtA Pt6)
									Pt7
									(inters Pt7 CPt PtA Pt6)
									""
					)
				)
				((= Act 12)	; SouthEastern Lock
					(command "_.SOLID"	Pt0
									(inters Pt0 CPt PtA Pt6)
									Pt9
									(inters Pt9 CPt PtA Pt6)
									""
					)
				)
				((= Act 13)	; Bad Locks Fill!
					(command "_.SOLID"	PtD
									(inters PtD CPt PtA Pt6)
									PtE
									(inters PtE CPt PtA Pt6)
									""
					)
					(command "_.SOLID"	PtC
									(inters PtC CPt PtB Pt5)
									PtF
									(inters PtF CPt PtB Pt5)
									""
					)
					(command "_.SOLID"	PtE
									(inters PtE CPt Pt4 Pt7)
									PtF
									(inters PtF CPt Pt4 Pt7)
									""
					)
					(command "_.SOLID"	PtC
									(inters PtC CPt Pt1 Pt0)
									PtD
									(inters PtD CPt Pt1 Pt0)
									""
					)
				)
			)
	)
)

(defun C:AddSclTxt ( /	ssPanTxt )			; Removes the Pan_ID and draws the Panel Scale in Div_Map
	(if Bug (princ "\n{C:AddSclTxt entered\n"))
	(setq	AttWas	(getvar "ATTREQ")
			BlpWas	(getvar "BLIPMODE")
			ColWas	(getvar "CECOLOR")
			LtWas	(getvar "CELTYPE")
			LayWas	(getvar "CLAYER")
			CmdWas	(getvar "CMDDIA")
			EchWas	(getvar "CMDECHO")
			FilWas	(getvar "FILEDIA")
			OsWas	(getvar "OSMODE")
	)
	
	(if (not Bug)
		(progn
			(setvar "ATTREQ" 0)
			(setvar "BLIPMODE" 0)
			(setvar "CELTYPE" "BYLAYER")
			(setvar "CMDDIA" 0)
			(setvar "CMDECHO" 0)
			(setvar "FILEDIA" 0)
			(setvar "OSMODE" 0)
		)
	)
	(command "_.UNDO" "_BE")
	(command "_.Layer" "T" "*" "On" "*" "U" "*" "S" "0" "F" "Org*fill" "" "_.Zoom" "E")
	(setvar "CECOLOR" "5")
	(setq	ssPanTxt	(ssget "X" (list (cons 0 "TEXT") (cons 62 5))))
	(if ssPanTxt
		(command "_.Erase" ssPanTxt "")
	)
	(if ChkLst
		(mapcar (quote (lambda (x) (command "_.TEXT" "J" "M" (list (+ (* (atoi (substr x 8 3)) 1000.0) 3000.0) (+ (* (atoi (substr x 11 4)) 1000.0) 2666.6)) 800.0 "0" (substr x 25 4)))) ChkLst)
	)
	(setvar "CECOLOR" "BYLAYER")
	(command "_.UNDO" "_EN")
	(setvar "ATTREQ" AttWas)
	(setvar "BLIPMODE" BlpWas)
	(setvar "CECOLOR" ColWas)
	(setvar "CELTYPE" LtWas)
	(setvar "CLAYER" LayWas)
	(setvar "CMDDIA" CmdWas)
	(setvar "CMDECHO" EchWas)
	(setvar "FILEDIA" FilWas)
	(setvar "OSMODE" OsWas)
	(if Bug (princ "\nC:AddSclTxt exited}\n"))

	;	Cleanup
	(if ssPanTxt	(setq ssPanTxt nil))
	(gc)

	(princ)
)

(defun DupLstRem ( ALst BLst /	NLst Imp )	; Duplicate Listing Remover
	(foreach	Imp
			ALst
			(if (not (member Imp BLst))
				(if NLst
					(setq	NLst		(cons Imp NLst))
					(setq	NLst		(list Imp))
				)
			)
	)
	NLst
)

(defun ShrLstComp ( /	PanLst PanNam ExtCnt	; Compares Panel Share Lists, tests for bad lock situation
					LckCnt )
	(setq	All_Lck_Lst	nil
			Bad_Lck_Lst	nil
			RepBadLckLst	nil
	)
	(if BShrLst
		(setq	All_Lck_Lst	(BldLstComp BShrLst All_Lck_Lst))
	)
	(if EShrLst
		(setq	All_Lck_Lst	(BldLstComp EShrLst All_Lck_Lst))
	)
	(if MShrLst
		(setq	All_Lck_Lst	(BldLstComp MShrLst All_Lck_Lst))
	)
	(if SShrLst
		(setq	All_Lck_Lst	(BldLstComp SShrLst All_Lck_Lst))
	)
	(if SEShrLst
		(setq	All_Lck_Lst	(BldLstComp SEShrLst All_Lck_Lst))
	)
	(if WShrLst
		(setq	All_Lck_Lst	(BldLstComp WShrLst All_Lck_Lst))
	)
	(if All_Lck_Lst
		(princ (strcat "\nTotal of " (itoa (length All_Lck_Lst)) " Panels in Share List"))
	)
	(foreach	PanLst
			All_Lck_Lst
			(setq	PanNam	(nth 0 PanLst)
					ExtCnt	0
					LckCnt	0
			)
			(if (nth 1 PanLst) (setq ExtCnt (1+ ExtCnt)))
			(if (nth 2 PanLst) (setq ExtCnt (1+ ExtCnt)))
			(if (nth 3 PanLst) (setq ExtCnt (1+ ExtCnt)))
			(if (nth 4 PanLst) (setq ExtCnt (1+ ExtCnt)))
			(if (nth 5 PanLst) (setq ExtCnt (1+ ExtCnt)))
			(if (nth 6 PanLst) (setq ExtCnt (1+ ExtCnt)))
			(if (nth 7 PanLst) (setq LckCnt (1+ LckCnt)))
			(if (nth 8 PanLst) (setq LckCnt (1+ LckCnt)))
			(if (nth 9 PanLst) (setq LckCnt (1+ LckCnt)))
			(if (nth 10 PanLst) (setq LckCnt (1+ LckCnt)))
			(if (nth 11 PanLst) (setq LckCnt (1+ LckCnt)))
			(if (nth 12 PanLst) (setq LckCnt (1+ LckCnt)))
			(if (< LckCnt (1- ExtCnt))
				(if Bad_Lck_Lst
					(setq	Bad_Lck_Lst	(append (list PanNam) Bad_Lck_Lst))
					(setq	Bad_Lck_Lst	(list PanNam))
				)
			)
	)
	(if Bad_Lck_Lst
		(if (> (length Bad_Lck_Lst) 1)
			(progn
				(setq	RepBadLckLst	(car Bad_Lck_Lst))
				(foreach	RepNam
						(cdr Bad_Lck_Lst)
						(setq	RepBadLckLst	(strcat RepBadLckLst ", " RepNam))
				)
			)
			(setq	RepBadLckLst	(car Bad_Lck_Lst))
		)
	)
	(if Bad_Lck_Lst
		(princ (strcat "\nTotal of " (itoa (length Bad_Lck_Lst)) " Badly Locked Panels in Share List"))
	)
)

(defun BldLstComp (	Lst1 Lst2 /	Pan 		; Tests Lists of Panels & Locks, returns complex list
								Ret_Lst E1 E2 E3 E4 E5 E6 L1 L2 L3 L4 L5 L6 Lck_Lst )
	(if Lst2
		(setq	Tst_Lst	(mapcar (quote car) Lst2)
				Ret_Lst	Lst2
		)
		(setq	Tst_Lst	nil)
	)
	(if Lst1
		(foreach	Pan
				Lst1
				(if BShrLst
					(if (member Pan BShrLst)
						(setq	E1	T)
						(setq	E1	nil)
					)
					(setq	E1	nil)
				)
				(if EShrLst
					(if (member Pan EShrLst)
						(setq	E2	T)
						(setq	E2	nil)
					)
					(setq	E2	nil)
				)
				(if MShrLst
					(if (member Pan MShrLst)
						(setq	E3	T)
						(setq	E3	nil)
					)
					(setq	E3	nil)
				)
				(if SShrLst
					(if (member Pan SShrLst)
						(setq	E4	T)
						(setq	E4	nil)
					)
					(setq	E4	nil)
				)
				(if SEShrLst
					(if (member Pan SEShrLst)
						(setq	E5	T)
						(setq	E5	nil)
					)
					(setq	E5	nil)
				)
				(if WShrLst
					(if (member Pan WShrLst)
						(setq	E6	T)
						(setq	E6	nil)
					)
					(setq	E6	nil)
				)
				(if BLstL
					(if (member Pan BLstL)
						(setq	L1	T)
						(setq	L1	nil)
					)
					(setq	L1	nil)
				)
				(if ELstL
					(if (member Pan ELstL)
						(setq	L2	T)
						(setq	L2	nil)
					)
					(setq	L2	nil)
				)
				(if MLstL
					(if (member Pan MLstL)
						(setq	L3	T)
						(setq	L3	nil)
					)
					(setq	L3	nil)
				)
				(if SLstL
					(if (member Pan SLstL)
						(setq	L4	T)
						(setq	L4	nil)
					)
					(setq	L4	nil)
				)
				(if SELstL
					(if (member Pan SELstL)
						(setq	L5	T)
						(setq	L5	nil)
					)
					(setq	L5	nil)
				)
				(if WLstL
					(if (member Pan WLstL)
						(setq	L6	T)
						(setq	L6	nil)
					)
					(setq	L6	nil)
				)
				(setq	Lck_Lst	(list	Pan E1 E2 E3 E4 E5 E6
										L1 L2 L3 L4 L5 L6
								)
				)
				(if Tst_Lst
					(if (not (member Pan Tst_Lst))
						(if Ret_Lst
							(setq	Ret_Lst	(cons Lck_Lst Ret_Lst))
							(setq	Ret_Lst	(list Lck_Lst))
						)
					)
					(if Ret_Lst
						(setq	Ret_Lst	(cons Lck_Lst Ret_Lst))
						(setq	Ret_Lst	(list Lck_Lst))
					)
				)
		)
	)
	Ret_Lst
)

(defun BldActLst ( WINllur /	ADDllur LLx LLy	; Build ActLst
						NUMx NUMy TMPy fn minX minY maxX maxY )
; local: NUMx   Number of panels to insert on x axis
;        NUMy   Number of panels to insert on y axis
;        LLx    Base point for panel insertion on x axis
;        LLy    Base point for panel insertion on y axis
; BUILDS: ACTlst
	(if Bug 
		(progn
			(princ "\nBldActLst entered \n parameters: "))
			(prin1 WINllur)	
		)
	(setq	ACTlst	(list ))
	(if (= Div "AL")					; [TEST] Transmission 
		(setq XPanel 60000.0
			 YPanel 40000.0
		)
	)
	(setq	ADDllur	(list	(* (fix (/ (nth 0 WINllur) XPanel)) XPanel)
							(* (fix (/ (nth 1 WINllur) YPanel)) YPanel)
							(* (1+ (fix (/ (nth 2 WINllur) XPanel))) XPanel)
							(* (1+ (fix (/ (nth 3 WINllur) YPanel))) YPanel)
					)
	)
	(setq	NUMx		(fix (/ (- (nth 2 ADDllur) (nth 0 ADDllur)) XPanel))
			NUMy		(fix (/ (- (nth 3 ADDllur) (nth 1 ADDllur)) YPanel))
	)
	(setq	LLx		(nth 0 ADDllur)
			LLy		(nth 1 ADDllur)
			TMPy		LLy
	)
	(repeat NUMx
		(repeat NUMy
			(setq	ACTlst	(cons (BldFn LLx LLy) ACTlst)
					LLy		(+ LLy YPanel)
			)
		)
		(setq	LLx	(+ LLx XPanel)
				LLy	TMPy
		)
	)
	(if Bug (princ "\nBldActLst exited"))
	(princ)
)

(defun BldFn ( a b / )						; Build fname from x & y coords
;   Function: build filename by converting the x and y coordinate values
;             of the bottom right of the panel to a string
;   Author:   Bob Ralston
;   Date:     April, 1996
	(if Bug (princ "\nBldFn routine"))
; projection is in UTM 83 Feet (Remove 10,000,000 from Y for tile name.)
	(if (= Project "NAD83F")
		(setq	a	(substr (rtos a) 1 4)
				b	(substr (rtos (- b 10000000)) 1 4)
		)
; else the default is UTM 27 Meters
		(setq	a	(substr (rtos a) 1 3)
				b	(substr (rtos b) 1 4)
		)
	)
	(strcat a b)
)

(defun ViewCnt ( / Cnt BubbaView )			; Counts Named Views
	(if Bug (princ "\n{ViewCnt entered\n"))
	(setq	Cnt		1
			BubbaView	(tblnext "VIEW" T)
	)
	(while	(setq	BubbaView	(tblnext "VIEW"))
		(setq	Cnt	(1+ Cnt))
	)
	(princ (strcat "\nFound {" (itoa Cnt) "} Named Views"))
	(if Bug (princ "\nViewCnt exited}\n"))
	(princ)
)

(defun BSearch (	Look4 Fn KeyPos KeyLen /		; Binary Search
				_FIRST _LAST _MID _S GotIT Fpt )
	(setq	Look4	(strcase Look4))
	(if (= (substr (getvar "ACADVER") 1 2) "12")			;	AutoCAD r12 June 1992
		(progn
			(if (not filesize)
				(xload (strcat _PATH-LISP "FILEDATA"))
			)
			(setq	_FIRST	1
					_LAST	(filesize Fn)
			)
			(while (< _FIRST _LAST)
				(setq	_MID	(fix (/ (+ _FIRST _LAST) 2)))
				(setq	_S	(filerecord Fn _MID))
				(if (< (substr _S KeyPos KeyLen) LOOK4)
					(setq	_FIRST	(1+ _MID))
					(setq	_LAST	_MID)
				)
			)
			(setq	_S	(filerecord Fn _FIRST))
			(if (= (substr _S KeyPos KeyLen) Look4)
				(eval _S)
				(eval NIL)
			)
		)
		(progn
			(setq	GotIT	nil
					Fpt		(open Fn "r")
					_S		(read-line Fpt)
			)
			(while (and _S (not GotIT))
				(if (= Look4 (substr _S KeyPos KeyLen))
					(setq	GotIT	T)
					(setq	_S		(read-line Fpt))
				)
			)
			(close Fpt)
			(if GotIT
				(eval _S)
				(eval nil)
			)
		)
	)
)

(defun JimSave ( /	FilSNam )					; Specialty Save routine for Jim Smith
	(if (/= (strcase (getvar "DWGNAME")) "DRAWING.DWG")
		(command "_.SaveAs" "R14" (strcat "S:/Workgroups/APC Western Division/Division Mapping/Work in progress/" (getvar "DWGNAME")))
		(progn
			(setq	FilSNam	(getfiled "Jim\'s Save As" "S:/Workgroups/APC Western Division/Division Mapping/Work in progress/" "dwg" 1))
			(if FilSNam
				(command "_.SaveAs" "R14" FilSNam)
			)
		)
	)
	(princ)
)

(defun JimOpen ( /	FilONam )					; Specialty Open routine for Jim Smith
	(setq	FilONam	(getfiled "Jim\'s Get One" "S:/Workgroups/APC Western Division/Division Mapping/Work in progress/" "dwg" 2))
	(if FilONam
		(if (findfile FilONam)
			(if (>= (getvar "DBMOD") 1)
				(progn
					(JimSave)
					(command "_.Open" FilONam)
				)
				(command "_.Open" FilONam)
			)
			(princ "\nNo File by that name found...")
		)
	)
	(princ)
)

(defun NexAscVal ( LastAsc Dir /	AscVal		; Generates Next Asc Val, Ascending or Descending
							NexAsc )
	(if Bug (princ "\n{NexAscVal entered\n"))
	(if (= (strlen LastAsc) 1)
		(setq	AscVal	(ascii LastAsc))
	)
	(if (not Dir)
		(setq	Dir	"+")
	)
	(cond
		((and (equal Dir "+") (= AscVal 57))
			(setq	NexAsc	65)
		)
		((and (equal Dir "+") (= AscVal 90))
			(setq	NexAsc	48)
		)
		((and (equal Dir "-") (= AscVal 48))
			(setq	NexAsc	90)
		)
		((and (equal Dir "-") (= AscVal 65))
			(setq	NexAsc	57)
		)
		((and (equal Dir "+") (>= AscVal 48) (<= AscVal 56))
			(setq	NexAsc	(1+ AscVal))
		)
		((and (equal Dir "+") (>= AscVal 65) (<= AscVal 89))
			(setq	NexAsc	(1+ AscVal))
		)
		((and (equal Dir "-") (>= AscVal 49) (<= AscVal 57))
			(setq	NexAsc	(1- AscVal))
		)
		((and (equal Dir "-") (>= AscVal 66) (<= AscVal 90))
			(setq	NexAsc	(1- AscVal))
		)
	)
	(if Bug (princ "\nNexAscVal exited}\n"))
	(chr NexAsc)
)

(defun C:AutoDGN ( /	FilNam FstDGN _Path-DGN	; Builds and runs an automated process for building DGN files
					DGN_Lst DGN )
	(if (> (getvar "PLINETYPE") 0) (setvar "PLINETYPE" 0))
	(setq	FstDGN	(getfiled "DGN File" "" "dgn" 2))
	(if (findfile FstDGN)
		(setq	_Path-DGN		(dos_splitpath FstDGN)
				_Path-DGN		(strcat (nth 0 _Path-DGN) (nth 1 _Path-DGN))
				DGN_Lst		(dos_dir (strcat _Path-DGN "*.DGN"))
				DGN_Lst		(mapcar (quote (lambda (x) (substr x 1 (- (strlen x) 4)))) DGN_Lst)
				_Path-Temp	(getenv "TEMP")
		)
		(setq	DGN_Lst		nil)
	)
	(if DGN_Lst
		(progn
			(setq	FilNam		(open (strcat _Path-Temp "\\AutoDGN.scr") "w")
					S::StartUp	nil
			)
			(foreach	DGN
					DGN_Lst
					(write-line (strcat "(command \"_MapImport\" \"DGN\" \"" DGN ".dgn\" \"N\" \"N\" \"N\" \"N\" \"N\" \"N\")") FilNam)
					(write-line (strcat "(command \"_.Zoom\" \"E\")") FilNam)
					(write-line (strcat "(command \"_.SaveAs\" \"R14\" \"" DGN "\")") FilNam)
					(if (/= DGN (last DGN_Lst))
						(write-line (strcat "(command \"_.New\" \"acad.dwt\")") FilNam)
						(write-line (strcat "(command \"_.Quit\")") FilNam)
					)
			)
			(close FilNam)
		)
	)
	(if (findfile (strcat _Path-Temp "\\AutoDGN.scr"))
		(command "_.Script" (strcat _Path-Temp "\\AutoDGN.scr"))
	)
	(princ)
)

(defun ResetPick ( / MyPick CurPick )			; Re-creates PickBox keys in Acad14.cfg
	(if Bug (princ "\n{ResetPick Entered"))
	(setq	CurPick	(getvar "PICKBOX"))
	(initget 1)
	(setq	MyPick	(getint (strcat "\nWhat would you like to set your permanent PickBox setting to? <" (itoa CurPick) ">: ")))
	(if (>= MyPick 1)
		(progn
			(if (not (equal (dos_getini "Common" "PickTest" (strcat _Path-Person "DIV_MAP.INI")) "1"))
				(dos_setini "Common" "PickTest" "1" (strcat _Path-Person "DIV_MAP.INI"))
			)
			(dos_setini "Common" "PickVal" (itoa MyPick) (strcat _Path-Person "DIV_MAP.INI"))
			(if (and Bug (>= MyPick 1))
				(princ (strcat "\nIt's a Pick the size of <" (itoa MyPick) ">!"))
			)
			(setvar "PICKBOX" MyPick)
		)
		(progn
			(setq	MyPick	CurPick)
			(princ "\nPickBox choice cancelled!")
		)
	)
	(if Bug (princ "\nResetPick Exited}\n"))
	MyPick
)

(defun VFrst ( BlkNam /	VScl TmpSS FrstOne )	; Views First insert of named block
	(if Bug (princ "\n{ VFrst Entered"))
	(if (not BlkNam)
		(progn
			(initget 1)
			(setq	BlkNam	(getstring "\nWhat Block/Insert do you want to look at? ")
					VScl		(getreal "\nWhat Screen Height on the zoom? ")
			)
		)
		(setq	VScl		250.0)
	)
	(if BlkNam
		(setq	TmpSS	(ssget "X"	(list	(cons 0 "INSERT")
											(cons 2 BlkNam)
									)
						)
		)
		(setq	TmpSS	nil)
	)
	(if TmpSS
		(setq	FrstOne	(entget (ssname TmpSS 0) (list "*"))
				Bubba	(command "_.Zoom" "C" (cdr (assoc 10 FrstOne)) VScl)
		)
	)
	;	Cleanup
	(if TmpSS	(setq TmpSS nil))
	(gc)

	(if Bug (princ "\n VFrst Exited}\n"))
	(princ)
)

(defun C:KipUp ( / )						; Copies Kip Driver files as Installer
	(if (not dos_version)
		(if (<> (getvar "ACADVER") "14.0")
			(if (not (member (strcase "DosLib17.Arx" T) (arx)))
				(if (findfile "DosLib17.Arx")
					(arxload "DosLib17")
					(princ "\n*Buttons Error*: DosLIB Arx file not found on this system!")
				)
			)
			(if (not (member (strcase "DosLib14.arx" T) (arx)))
				(if (findfile "doslib14.arx")
					(arxload "doslib14")
					(princ "\n*Buttons Error*: DosLIB Arx file not found on this system!")
				)
			)
		)
	)
	(if (findfile "C:\\Program Files\\Autodesk\\ACADMAP2\\ACAD.EXE")
		(if (and (findfile "\\\\GEWILLY1\\PUBLIC\\KIPPER\\PLKIP14.DLL") (not (findfile "C:\\Program Files\\Autodesk\\ACADMAP2\\DRV\\PLKIP14.DLL")))
			(progn
				(dos_copy "\\\\GEWILLY1\\PUBLIC\\KIPPER\\KIPCON.ARX" "C:\\Program Files\\Autodesk\\ACADMAP2\\SUPPORT\\KIPCON.ARX")
				(dos_copy "\\\\GEWILLY1\\PUBLIC\\KIPPER\\KIPCON.DCL" "C:\\Program Files\\Autodesk\\ACADMAP2\\SUPPORT\\KIPCON.DCL")
				(dos_copy "\\\\GEWILLY1\\PUBLIC\\KIPPER\\PLKIP14.DLL" "C:\\Program Files\\Autodesk\\ACADMAP2\\DRV\\PLKIP14.DLL")
				(dos_copy "\\\\GEWILLY1\\PUBLIC\\KIPPER\\PLKIP14.HLP" "C:\\Program Files\\Autodesk\\ACADMAP2\\DRV\\PLKIP14.HLP")
				(dos_copy "\\\\GEWILLY1\\PUBLIC\\KIPPER\\PLKIP14.INI" "C:\\Program Files\\Autodesk\\ACADMAP2\\DRV\\PLKIP14.INI")
				(princ "\nKip Driver for AutoCad 14 files copied across...")
			)
			(princ "\nKip Driver for AutoCad 14 files already present...")
		)
	)
	(princ)
)

;;;==== Load KIP plotter driver configuration utility [0/00/00 00:00:00] ====
(if (= (getvar "ACADVER") "14.0") (autoarxload "c:/program files/autodesk/acadmap2/support/kipcon" '("kipconfig")))

(setq	LodVer	SCS_A_Ver)
(princ "\nAcad.Lsp - loaded")
