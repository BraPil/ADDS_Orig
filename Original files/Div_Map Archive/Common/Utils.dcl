dcl_settings : default_dcl_settings { audit_level = 3; }
//////////////////////////////////////////////////////////////
ChgUnits : dialog {
	label = "Units Choice";
	: column {
		:	text {
			label = "Do you wish to Change Units?";
			alignment = centered;
		}
		:	row {
			:	button {
				label = "Yes";
				is_default = true;
				mnemonic = "Y";
				key = "Yes_Key";
			}
			:	button {
				label = "No";
				mnemonic = "N";
				key = "No_Key";
			}
			:	button {
				label = "Cancel";
				is_cancel = true;
				mnemonic = "C";
				key = "Can_Key";
			}
		}
	}
}
////////////////////////////////////////////////////////
DispTog1 : dialog {
	label     = "Display Toggle";
	key       = "title_bar";
	alignment = centered;
	: boxed_column {
		label = "Property Selection:";
		: row {
			: spacer {
				width = 0.125;
			}
			: row {
				: toggle {
					label	= "Overhead";
					key		= "oh_toggle";
					value	= "0";
					mnemonic	= "O";
				}
				: toggle {
					label	= "Underground";
					key		= "ug_toggle";
					value	= "0";
					mnemonic	= "U";
				}
				: toggle {
					label	= "Apply";
					key		= "aou_tog";
					value	= "0";
				}
			}
		}
		: popup_list {
			label		= "Voltage:  ";
			key			= "vt_vlist";
			mnemonic	= "V";
			edit_width	= 35;
		}
		: popup_list {
			label		= "Feeder:   ";
			key			= "fd_vlist";
			mnemonic	= "F";
			edit_width	= 35;
		}
		: popup_list {
			label		= "Phasing:  ";
			key			= "ph_vlist";
			mnemonic	= "P";
			edit_width	= 35;
		}
		: spacer {
			height = 0.125;
		}
	   :boxed_column {
	   label = "Wire Details";
		alignment = centered;
			:boxed_column {
				label = "Primary";
				alignment = centered;
				: row {
					: popup_list {
						label           = "Size: ";
						key             = "Pri_S_vlist";
						edit_width      = 6;
					}
					: popup_list {
						label           = "Type: ";
						key             = "Pri_T_vlist";
						mnemonic        = "T";
						edit_width      = 10;
					}
				}
			}
			:boxed_column {
				label = "Neutral";
				alignment = centered;
				: row {
					: popup_list {
						label           = "Size: ";
						key             = "Neu_S_vlist";
						mnemonic        = "S";
						edit_width      = 6;
					}
					: popup_list {
						label           = "Type: ";
						key             = "Neu_T_vlist";
						mnemonic        = "T";
						edit_width      = 10;
					}
				}
			}
		}
	}
	: boxed_column {
		label				= "Actions";
		alignment				= centered;
		: row {
			: boxed_row {
				: toggle {
					label		= "Grid";
					key			= "grd_tog";
					value		= "0";
					width		= 10;
					fixed_width	= true;
				}
				: toggle {
					label		= "Apply";
					key			= "agrd_tog";
					value		= "0";
					width		= 10;
					fixed_width	= true;
				}
			}
			: boxed_row {
				: toggle {
					label		= "Fill";
					key			= "fil_tog";
					value		= "0";
					width		= 10;
					fixed_width	= true;
				}
				: toggle {
					label		= "Apply";
					key			= "afil_tog";
					value		= "0";
					width		= 10;
					fixed_width	= true;
				}
			}
		}
		: row {
			: boxed_row {
				: toggle {
					label		= "Circuit";
					key			= "sel_tog";
					value		= "0";
					width		= 10;
					fixed_width	= true;
				}
				: toggle {
					label		= "Apply";
					key			= "asel_tog";
					value		= "0";
					width		= 10;
					fixed_width	= true;
				}
			}
			: boxed_row {
				: toggle {
					label		= "Switch";
					key			= "sws_tog";
					value		= "0";
					width		= 10;
					fixed_width	= true;
				}
				: toggle {
					label		= "Apply";
					key			= "asws_tog";
					value		= "0";
					width		= 10;
					fixed_width	= true;
				}
			}
		}
		: row {
			: boxed_row {
				: toggle {
					label		= "NOpen";
					key			= "no_tog";
					value		= "0";
					width		= 10;
					fixed_width	= true;
				}
				: toggle {
					label		= "Apply";
					key			= "ano_tog";
					value		= "0";
					width		= 10;
					fixed_width	= true;
				}
			}
			: boxed_row {
				: toggle {
					label		= "Attribs";
					key			= "att_tog";
					value		= "0";
					width		= 10;
					fixed_width	= true;
				}
				: toggle {
					label		= "Apply";
					key			= "aatt_tog";
					value		= "0";
					width		= 10;
					fixed_width	= true;
				}
			}
		}
		: row {
			: boxed_row {
				: toggle {
					label		= "ShowAll";
					key			= "swa_tog";
					value		= "0";
					width		= 10;
					fixed_width	= true;
				}
				: toggle {
					label		= "Apply";
					key			= "aswa_tog";
					value		= "0";
					width		= 10;
					fixed_width	= true;
				}
			}
			: boxed_row {
				: toggle {
					label		= "HideAll";
					key			= "hid_tog";
					value		= "0";
					width		= 10;
					fixed_width	= true;
				}
				: toggle {
					label		= "Apply";
					key			= "ahid_tog";
					value		= "0";
					width		= 10;
					fixed_width	= true;
				}
			}
		}
	}
	: row {
		alignment   = centered;
		fixed_width = true;
		: button {
			label		= "OK";
			key			= "ok_button";
			mnemonic		= "O";
			width		= 13;
			fixed_width	= true;
		}
		: spacer {
			width = 1;
		}
		: button {
			label		= "Cancel";
			key			= "cancel_button";
			mnemonic		= "C";
			width		= 13;
			fixed_width	= true;
			is_cancel		= true;
		}
		: spacer {
			width = 1;
		}
		: button {
			label		= "Apply";
			key			= "act_but";
			width		= 13;
			fixed_width	= true;
		}
	}
	: spacer {
		height = 0.125;
	}
}
////////////////////////////////////////////////////////
DispTog2 : dialog {
	label     = "Display Toggle";
	key       = "title_bar";
	alignment = centered;
	: boxed_column {
		label = "Property Selection:";
		: row {
			: spacer {
				width = 0.125;
			}
			: row {
				: toggle {
					label	= "Overhead";
					key		= "oh_toggle";
					value	= "0";
					mnemonic	= "O";
				}
				: toggle {
					label	= "Underground";
					key		= "ug_toggle";
					value	= "0";
					mnemonic	= "U";
				}
				: button {
					label		= "Freeze";
					key			= "fz_but_prop";
					width		= 8;
					fixed_width	= true;
				}
				: button {
					label		= "Thaw";
					key			= "th_but_prop";
					width		= 8;
					fixed_width	= true;
				}
			}
		}
		: popup_list {
			label		= "Voltage:  ";
			key			= "vt_vlist";
			mnemonic	= "V";
			edit_width	= 35;
		}
		: popup_list {
			label		= "Feeder:   ";
			key			= "fd_vlist";
			mnemonic	= "F";
			edit_width	= 35;
		}
		: popup_list {
			label		= "Phasing:  ";
			key			= "ph_vlist";
			mnemonic	= "P";
			edit_width	= 35;
		}
		: spacer {
			height = 0.125;
		}
	}
	: boxed_column {
		label				= "Actions";
		alignment				= centered;
		: row {
			: boxed_row {
				label		= "Grid";
				: button {
					label		= "Freeze";
					key			= "fz_but_gd";
					width		= 10;
					fixed_width	= true;
				}
				: button {
					label		= "Thaw";
					key			= "th_but_gd";
					width		= 10;
					fixed_width	= true;
				}
			}
			: boxed_row {
				label		= "Fill Lines";
				: button {
					label		= "Freeze";
					key			= "fz_but_fl";
					width		= 10;
					fixed_width	= true;
				}
				: button {
					label		= "Thaw";
					key			= "th_but_fl";
					width		= 10;
					fixed_width	= true;
				}
			}
		}
		: row {
			: boxed_row {
				label		= "Computer Point";
				: button {
					label		= "Freeze";
					key			= "fz_but_cp";
					width		= 10;
					fixed_width	= true;
				}
				: button {
					label		= "Thaw";
					key			= "th_but_cp";
					width		= 10;
					fixed_width	= true;
				}
			}
			: boxed_row {
				label		= "Switch";
				: button {
					label		= "Freeze";
					key			= "fz_but_sw";
					width		= 10;
					fixed_width	= true;
				}
				: button {
					label		= "Thaw";
					key			= "th_but_sw";
					width		= 10;
					fixed_width	= true;
				}
			}
		}
		: row {
			: boxed_row {
				label		= "Normal Open";
				: button {
					label		= "Freeze";
					key			= "fz_but_no";
					width		= 10;
					fixed_width	= true;
				}
				: button {
					label		= "Thaw";
					key			= "th_but_no";
					width		= 10;
					fixed_width	= true;
				}
			}
			: boxed_row {
				label		= "Attributes";
				: button {
					label		= "Freeze";
					key			= "fz_but_att";
					width		= 10;
					fixed_width	= true;
				}
				: button {
					label		= "Thaw";
					key			= "th_but_att";
					width		= 10;
					fixed_width	= true;
				}
			}
		}
		: row {
			: boxed_row {
				: button {
					label		= "FreezeAll";
					key			= "fz_but_all";
					width		= 13;
					fixed_width	= true;
				}
				: button {
					label		= "ThawAll";
					key			= "th_but_all";
					width		= 13;
					fixed_width	= true;
				}
			}
		}
	}
	: row {
		alignment   = centered;
		fixed_width = true;
		: button {
			label		= "Close";
			key			= "cancel_button";
			mnemonic		= "C";
			width		= 13;
			fixed_width	= true;
			is_cancel		= true;
		}
	}
	: spacer {
		height = 0.125;
	}
}
////////////////////////////////////////////////////////
DispTog3 : dialog {
	label     = "Display Toggle";
	key       = "title_bar";
	alignment = centered;
	: boxed_column {
		label				= "Actions";
		//alignment				= centered;
		: row {
			: boxed_row {
				label		= "Sectionalized drawing";
				: button {
					label		= "Freeze";
					key			= "fz_but_sc";
					width		= 10;
					fixed_width	= true;
				}
				: button {
					label		= "Thaw";
					key			= "th_but_sc";
					width		= 10;
					fixed_width	= true;
				}
			}
			: boxed_row {
				label		= "Lighting drawing";
				: button {
					label		= "Freeze";
					key			= "fz_but_lt";
					width		= 10;
					fixed_width	= true;
				}
				: button {
					label		= "Thaw";
					key			= "th_but_lt";
					width		= 10;
					fixed_width	= true;
				}
			}
		}
		: row {
			: boxed_row {
				label		= "Primary";
				: button {
					label		= "Freeze";
					key			= "fz_but_pri";
					width		= 10;
					fixed_width	= true;
				}
				: button {
					label		= "Thaw";
					key			= "th_but_pri";
					width		= 10;
					fixed_width	= true;
				}
			}
			: boxed_row {
				label		= "Secondary";
				: button {
					label		= "Fr";
					key			= "fz_but_sec";
					width		= 6;
					fixed_width	= true;
				}
				: button {
					label		= "Col";
					key			= "clr_but_sec";
					width		= 6;
					fixed_width	= true;
				}
				: button {
					label		= "Th";
					key			= "th_but_sec";
					width		= 6;
					fixed_width	= true;
				}
			}
		}
		: row {
			: boxed_row {
				label		= "Service";
				: button {
					label		= "Freeze";
					key			= "fz_but_sv";
					width		= 10;
					fixed_width	= true;
				}
				: button {
					label		= "Thaw";
					key			= "th_but_sv";
					width		= 10;
					fixed_width	= true;
				}
			}
			: boxed_row {
				label		= "Street";
				: button {
					label		= "Fr";
					key			= "fz_but_st";
					width		= 6;
					fixed_width	= true;
				}
				: button {
					label		= "Chg";
					key			= "chg_but_st";
					width		= 6;
					fixed_width	= true;
				}
				: button {
					label		= "Th";
					key			= "th_but_st";
					width		= 6;
					fixed_width	= true;
				}
			}
		}
		: row {
			: boxed_row {
				label		= "Property";
				: button {
					label		= "Fr";
					key			= "fz_but_prop";
					width		= 6;
					fixed_width	= true;
				}
				: button {
					label		= "Chg";
					key			= "chg_but_prop";
					width		= 6;
					fixed_width	= true;
				}
				: button {
					label		= "Th";
					key			= "th_but_prop";
					width		= 6;
					fixed_width	= true;
				}
			}
			: boxed_row {
				label		= "Misc";
				: button {
					label		= "Freeze";
					key			= "fz_but_msc";
					width		= 10;
					fixed_width	= true;
				}
				: button {
					label		= "Thaw";
					key			= "th_but_msc";
					width		= 10;
					fixed_width	= true;
				}
			}
		}
		: row {
			: boxed_row {
				label		= "Switches";
				: button {
					label		= "Freeze";
					key			= "fz_but_sw";
					width		= 10;
					fixed_width	= true;
				}
				: button {
					label		= "Thaw";
					key			= "th_but_sw";
					width		= 10;
					fixed_width	= true;
				}
			}
			: boxed_row {
				label		= "Transformers";
				: button {
					label		= "Freeze";
					key			= "fz_but_xfr";
					width		= 10;
					fixed_width	= true;
				}
				: button {
					label		= "Thaw";
					key			= "th_but_xfr";
					width		= 10;
					fixed_width	= true;
				}
			}
		}
		: row {
			: boxed_row {
				label		= "Lights";
				: button {
					label		= "Freeze";
					key			= "fz_but_lites";
					width		= 10;
					fixed_width	= true;
				}
				: button {
					label		= "Thaw";
					key			= "th_but_lites";
					width		= 10;
					fixed_width	= true;
				}
			}
			: boxed_row {
				label		= "Const_notes";
				: button {
					label		= "Freeze";
					key			= "fz_but_cons";
					width		= 10;
					fixed_width	= true;
				}
				: button {
					label		= "Thaw";
					key			= "th_but_cons";
					width		= 10;
					fixed_width	= true;
				}
			}
		}
	}
	: row {
		alignment   = centered;
		fixed_width = true;
		: button {
			label		= "Close";
			key			= "cancel_button";
			mnemonic		= "C";
			width		= 13;
			fixed_width	= true;
			is_cancel		= true;
		}
	}
	: spacer {
		height = 0.125;
	}
}

////////////////////////////////////////////////////////
ShwPath : dialog {
	label     = "Show Paths";
	alignment = centered;
	initial_focus = "OK";
	: spacer { height = 1; }
	: column {
		: row { 
			: text {
				label = "Path-Common: ";
				key = "Lbl00";
				width = 20;
				fixed_width = true;
			}
			: text {
				key = "Pth00";
				width = 75;
				fixed_width = true;
				default = " ";
			}
		}
		: row { 
			: text {
				label = "Path-DLG: ";
				key = "Lbl01";
				width = 20;
				fixed_width = true;
			}
			: text {
				key = "Pth01";
				width = 75;
				fixed_width = true;
				default = " ";
			}
		}
		: row { 
			: text {
				label = "Path-Div: ";
				key = "Lbl02";
				width = 20;
				fixed_width = true;
			}
			: text {
				key = "Pth02";
				width = 75;
				fixed_width = true;
				default = " ";
			}
		}
		: row { 
			: text {
				label = "Path-DWF: ";
				key = "Lbl03";
				width = 20;
				fixed_width = true;
			}
			: text {
				key = "Pth03";
				width = 75;
				fixed_width = true;
				default = " ";
			}
		}
		: row { 
			: text {
				label = "Path-DWG: ";
				key = "Lbl04";
				width = 20;
				fixed_width = true;
			}
			: text {
				key = "Pth04";
				width = 75;
				fixed_width = true;
				default = " ";
			}
		}
		: row { 
			: text {
				label = "Path-Lisp: ";
				key = "Lbl05";
				width = 20;
				fixed_width = true;
			}
			: text {
				key = "Pth05";
				width = 75;
				fixed_width = true;
				default = " ";
			}
		}
		: row { 
			: text {
				label = "Path-LUT: ";
				key = "Lbl06";
				width = 20;
				fixed_width = true;
			}
			: text {
				key = "Pth06";
				width = 75;
				fixed_width = true;
				default = " ";
			}
		}
		: row { 
			: text {
				label = "Path-Menu: ";
				key = "Lbl07";
				width = 20;
				fixed_width = true;
			}
			: text {
				key = "Pth07";
				width = 75;
				fixed_width = true;
				default = " ";
			}
		}
		: row { 
			: text {
				label = "Path-Panel: ";
				key = "Lbl08";
				width = 20;
				fixed_width = true;
			}
			: text {
				key = "Pth08";
				width = 75;
				fixed_width = true;
				default = " ";
			}
		}
		: row { 
			: text {
				label = "Path-Person: ";
				key = "Lbl09";
				width = 20;
				fixed_width = true;
			}
			: text {
				key = "Pth09";
				width = 75;
				fixed_width = true;
				default = " ";
			}
		}
		: row { 
			: text {
				label = "Path-Plot: ";
				key = "Lbl10";
				width = 20;
				fixed_width = true;
			}
			: text {
				key = "Pth10";
				width = 75;
				fixed_width = true;
				default = " ";
			}
		}
		: row { 
			: text {
				label = "Path-Proto: ";
				key = "Lbl11";
				width = 20;
				fixed_width = true;
			}
			: text {
				key = "Pth11";
				width = 75;
				fixed_width = true;
				default = " ";
			}
		}
		: row { 
			: text {
				label = "Path-Slides: ";
				key = "Lbl12";
				width = 20;
				fixed_width = true;
			}
			: text {
				key = "Pth12";
				width = 75;
				fixed_width = true;
				default = " ";
			}
		}
		: row { 
			: text {
				label = "Path-Support: ";
				key = "Lbl13";
				width = 20;
				fixed_width = true;
			}
			: text {
				key = "Pth13";
				width = 75;
				fixed_width = true;
				default = " ";
			}
		}
		: row { 
			: text {
				label = "Path-Sym: ";
				key = "Lbl14";
				width = 20;
				fixed_width = true;
			}
			: text {
				key = "Pth14";
				width = 75;
				fixed_width = true;
				default = " ";
			}
		}
		: row { 
			: text {
				label = "Path-User: ";
				key = "Lbl15";
				width = 20;
				fixed_width = true;
			}
			: text {
				key = "Pth15";
				width = 75;
				fixed_width = true;
				default = " ";
			}
		}
	}
	: spacer { height = 1; }
	: row {
		alignment   = centered;
		fixed_width = true;
		: button {
			label       = "OK";
			key         = "ok_button";
			mnemonic    = "O";
			width       = 8;
			fixed_width = true;
			is_cancel   = true;
		}
	}
	: spacer { height = 0.5; }
}
////////////////////////////////////////////////////////
