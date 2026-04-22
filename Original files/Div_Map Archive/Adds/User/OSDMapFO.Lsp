(if AppNam								; Code Version Indicator
	(princ (strcat "\n" AppNam " OsdMapFO Loading."))
	(princ "\nAddsPlot OsdMapFO Loading.")
)

(defun OsdMapFO ( / )
	(if Bug (princ "\n{OsdMapFO entered\n"))
	(if (= (getvar "ACADVER") "15.0")
		(if (not (member (strcase "DosLib2k.arx" T) (arx)))
			(if (findfile "doslib2k.arx")
				(arxload "doslib2k")
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
	(if (= Div "M_")
		(if Desc_1
			(progn
				(load (strcat _PATH-USER "SymColor"))
				(setq	Desc_1	nil)
			)
		)
		(setq	WhoDerLst	(list
							(list 21 -85.8217 33.5796 "Wayne Smith" "2506 Fitzgerald Road" "Anniston" "36203-3606" 609348.8157 3715961.5662)
							(list 20 -86.7373 33.5125 "Bryan Horner" "1113 Kingsbury Avenue" "Birmingham" "35213-2633" 524397.0030 3707931.4378)
							(list 19 -86.6529 33.4230 "Robin Hurst" "4078 Greystone Drive" "Birmingham" "35242-6468" 532268.5422 3698031.6756)
							(list 18 -86.7658 33.4371 "Mark Swindall" "2620 Southminster Road" "Birmingham" "35243-2156" 521768.9325 3699565.5815)
							(list 17 -86.6337 33.4232 "Bob Waters" "345 North Lake Road" "Birmingham" "35242-7015" 534048.0404 3698066.7154)
							(list 16 -86.6346 33.6563 "Ed Williams" "2619 Carmel Road" "Birmingham" "35235-2201" 533878.9507 3723903.4600)
							(list 15 -86.7281 33.3600 "Mike Smith" "5205 Parkside Circle" "Birmingham" "35242-3538" 525295.5425 3691026.1695)
							(list 14 -86.6349 33.4219 "Rodney Self" "6105 Terrace Hills Drive" "Birmingham" "35242-7360" 533942.3995 3697915.4492)
							(list 13 -86.8147 33.3375 "Bob Ralston" "2022 Baneberry Drive" "Hoover" "35244-6402" 517243.1352 3688513.9448)
							(list 12 -86.6952 33.4024 "Bill Mintz" "3629 Cheshire Road" "Birmingham" "35242-3103" 528342.6648 3695735.4543)
							(list 11 -86.8566 33.3650 "Tom Merrill" "1042 Valley Crest Drive" "Birmingham" "35226-5029" 513339.7944 3691556.6173)
							(list 10 -86.8865 33.3363 "Clyde Herring" "3664 Guyton Road" "Hoover" "35244-4300" 510561.6609 3688371.2934)
							(list 9 -86.9926 33.4987 "Phoebe Hall" "1247 4th Place" "Pleasant Grove" "35127-1350" 500686.8340 3706370.4226)
							(list 8 -86.7009 33.3005 "Cindy Frost" "60 Nichols Road" "Chelsea" "35043-9768" 527844.9840 3684436.5050)
							(list 7 -86.7093 33.6359 "Robert Foster" "905 18th Avenue NW" "Birmingham" "35215-4321" 526959.2145 3721619.6924)
							(list 6 -86.6323 33.4199 "Bob Duke" "6035 Mill Creek Drive" "Birmingham" "35242-7346" 534184.9029 3697694.5625)
							(list 5 -86.8257 33.3923 "Dan Davis" "909 Colesbury Circle" "Pelham" "35124" 516209.3567 3694587.7030)
							(list 4 -86.5850 33.7564 "Michael Cleland" "6885 Deer Haven Road" "Pinson" "35126-2424" 538433.2911 3735019.1830)
							(list 3 -86.8248 33.4185 "Larry Clark" "924 Mountain Branch Drive" "Birmingham" "35226-1810" 516288.1827 3697492.5872)
							(list 2 -86.5961 33.8150 "Wayne Boone" "91 Lakeshore Drive" "Remlap" "35133-3605" 537379.9141 3741512.2469)
							(list 1 -86.8336 33.4598 "John Bowen" "535 Edgeknoll Lane" "Homewood" "35209-5913" 515462.7217 3702070.1120)
							(list 0 -86.8060 33.4440 "Walter Appling" "1749 Shades Crest Road" "Vestavia" "35216-1738" 518030.8078 3700322.8518)
						)
						;WhoDerLst item 0 - Unique Number
						;WhoDerLst item 1 - Longtitude 
						;WhoDerLst item 2 - Lattitude
						;WhoDerLst item 3 - Name
						;WhoDerLst item 4 - Street Address
						;WhoDerLst item 5 - City Name
						;WhoDerLst item 6 - Zip+4
						;WhoDerLst item 7 - UTM27-16 X-Coord
						;WhoDerLst item 8 - UTM27-16 Y-Coord
				WhrDeyAt	(mapcar (quote (lambda (x) (list (nth 7 x) (nth 8 x)))) WhoDerLst)
		)
	)
	(load (strcat _path-user "View4SwL"))
	(load (strcat _path-user "View4Cap"))
	(load (strcat _path-user "AddURL"))
	(load (strcat _path-user "Fdr_Only"))
	(load (strcat _path-user "NoFills"))
	(load (strcat _path-user "Quads"))
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
	(if RepLChar
		(setq	Bubba	T)
		(progn
			(princ "\nLoading *My* Utils...")
			(load "h:/div_map/common/Utils") 		;(strcat _Path-Common "utils"))
		)
	)
	(if Div
		(cond
			((= Div "BH")
				(setq	OsdDir	(strcat "C:\\ADDS25\\OnSite\\" "Bham" "\\"))
			)
			((= Div "E_")
				(setq	OsdDir	(strcat "C:\\ADDS25\\OnSite\\" "East" "\\"))
			)
			((= Div "M_")
				(setq	OsdDir	(strcat "C:\\ADDS25\\OnSite\\" "Mobile" "\\"))
			)
			((= Div "S_")
				(setq	OsdDir	(strcat "C:\\ADDS25\\OnSite\\" "South" "\\"))
			)
			((= Div "SE")
				(setq	OsdDir	(strcat "C:\\ADDS25\\OnSite\\" "SoEast" "\\"))
			)
			((= Div "W_")
				(setq	OsdDir	(strcat "C:\\ADDS25\\OnSite\\" "West" "\\"))
			)
		)
		(progn
			(alert (strcat "**" AppNam "** Error!\nNo Division info loaded!"))
			(exit)
		)
	)
	(if OsdDir
		(setq	PutFile	(strcat OsdDir pldname))
		(progn
			(setq	PutFile	(getfiled	"Name of Osd File" OsdDir "dwg" 1))
		)
	)
	(if OsdDir
		(progn
			(command "_.Undo" "C" "ALL" "_.Undo" "BE")
			(if (/= 0 (getvar "tilemode"))
				(command "_.tilemode" 0)
			)
			(if (= 1 (getvar "cvport"))
				(command "_.MSpace")
			)
			(setq	MinX		(car (nth 8 ViewD))
					MaxX		(car (nth 9 ViewD))
					MinY		(cadr (nth 8 ViewD))
					MaxY		(cadr (nth 9 ViewD))
					Fuzz		10.0
					DCntr		0
			)
			(command "_.Zoom" (list MinX MinY) (list MaxX MaxY))
			(command "_.Zoom" "0.8x")
			(foreach	LocR
					WhrDeyAt
					(if	(and	(and (>= (car LocR) MinX) (<= (car LocR) MaxX))
								(and (>= (cadr LocR) MinY) (<= (cadr LocR) MaxY))
						)
						(setq	Bubba	(command "Insert" (strcat _Path-Sym "_bldg") (list (car LocR) (cadr LocR)) "100" "100" "0" (nth 3 (nth DCntr WhoDerLst)))
								BubOutP	(princ (strcat "\nOsdMap puts {" (nth 3 (nth DCntr WhoDerLst)) "} in his/her place, on OSD {" pldname "}.\n"))
								Bubba	(strcat "_" (RepLChar (nth 3 (nth DCntr WhoDerLst)) " " "_" 0))
								vdist	500.0
								Bubba	(command "_.VIEW" "W" Bubba (list (- (car LocR) vdist) (- (cadr LocR) vdist)) (list (+ (car LocR) vdist) (+ (cadr LocR) vdist)))
						)
					)
					(setq	DCntr	(1+ DCntr))
			)
			(setq	cmD			(getvar "CMDDIA")
					ssBrk		(ssget "C" (list (- MinX Fuzz) (- MinY Fuzz)) (list (+ MaxX Fuzz) (+ MaxY Fuzz)))
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
			(Map_DwgBreakObj ssBrk Elast 0 1)
			(command "_.ERASE" Elast "")
			(setq	ssBrk	nil
					Fuzz		(/ Fuzz 2.0)
					ssGood	(ssget "C" (list (- MinX Fuzz) (- MinY Fuzz)) (list (+ MaxX Fuzz) (+ MaxY Fuzz)))
			)
			(command "_.Zoom" "_E" "_.ERASE" "All" "R" ssGood "" "_.Zoom" "_E")
			(if (findfile (strcat PutFile ".dwg"))
				(dos_delete (strcat PutFile ".dwg"))
			)
			(setvar "TILEMODE" 1)
			(command "_.Zoom" (list wlx wly) (list wux wuy))
			(command "_.SAVEAS" "" PutFile)
			(setvar "TILEMODE" 0)
			(command "_.Undo" "_E")
		)
	)
	(setvar "CMDDIA" cmD)
	(if Bug (princ "\nOsdMapFO exited}\n"))
	(princ)
)

(if (= (substr (strcase AppNam) 1 5) "ADDSP")
	(OsdMapFO)
	(setq	LodVer	"1.50")
)
