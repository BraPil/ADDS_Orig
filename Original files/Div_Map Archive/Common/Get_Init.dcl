dcl_settings : default_dcl_settings { audit_level = 3; }
////////////////////////////////////////////////////////
INIEditCadet : dialog {
	label     = "INI Settings";
	alignment = centered;
	initial_focus = "Str3";
	: spacer { height = 1; }
	: row {
		: boxed_row { 
			label = "Hard Drive: ";
			: popup_list {
				key = "Lst1";
				label = " ";
				edit_width = 7;
				fixed_width = true;
			}
		}
		: boxed_row {
			label = "Net Drive:";
			: popup_list {
				key = "Lst2";
				label = " ";
				edit_width = 7;
				fixed_width = true;
			}
		}
	}
	: edit_box {
		key = "Str3";
		label = "User Name: ";
		edit_width = 25;
		fixed_width = true;
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
		}
		: spacer {
			width = 1;
		}
		: button {
			label       = "Cancel";
			key         = "cancel_button";
			mnemonic    = "C";
			width       = 8;
			fixed_width = true;
			is_cancel   = true;
		}
	}
	: spacer { height = 0.5; }
}
////////////////////////////////////////////////////////
INIPathCadet : dialog {
	label     = "INI Paths";
	alignment = centered;
	initial_focus = "Pth1";
	: spacer { height = 1; }
	: column {
		: boxed_row { 
			label = "Personal Drive Path: ";
			: edit_box {
				key = "Pth1";
				edit_width = 85;
				fixed_width = true;
			}
		}
		: boxed_row { 
			label = "Local Drive Path:    ";
			: edit_box {
				key = "Pth2";
				edit_width = 85;
				fixed_width = true;
			}
		}
		: boxed_row { 
			label = "Drawing Path: ";
			: edit_box {
				key = "Pth3";
				edit_width = 85;
				fixed_width = true;
			}
		}
		: boxed_row { 
			label = "Plotting Path:";
			: edit_box {
				key = "Pth4";
				edit_width = 85;
				fixed_width = true;
			}
		}
		: boxed_row { 
			label = "User Path:    ";
			: edit_box {
				key = "Pth5";
				edit_width = 85;
				fixed_width = true;
			}
		}
		: boxed_row { 
			label = "Lisp Path:    ";
			: edit_box {
				key = "Pth6";
				edit_width = 85;
				fixed_width = true;
			}
		}
		: boxed_row { 
			label = "LookUp Path:  ";
			: edit_box {
				key = "Pth7";
				edit_width = 85;
				fixed_width = true;
			}
		}
		: boxed_row { 
			label = "Menu Path:    ";
			: edit_box {
				key = "Pth8";
				edit_width = 85;
				fixed_width = true;
			}
		}
		: boxed_row { 
			label = "Symbol Path:  ";
			: edit_box {
				key = "Pth9";
				edit_width = 85;
				fixed_width = true;
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
		}
		: spacer {
			width = 1;
		}
		: button {
			label       = "Cancel";
			key         = "cancel_button";
			mnemonic    = "C";
			width       = 8;
			fixed_width = true;
			is_cancel   = true;
		}
	}
	: spacer { height = 0.5; }
}
////////////////////////////////////////////////////////
INIEditAdds : dialog {
	label     = "INI Settings";
	alignment = centered;
	initial_focus = "Str3";
	: spacer { height = 1; }
	: row {
		: boxed_row { 
			label = "Hard Drive: ";
			: popup_list {
				key = "Lst1";
				label = " ";
				edit_width = 7;
				fixed_width = true;
			}
		}
		: boxed_row {
			label = "Net Drive:";
			: popup_list {
				key = "Lst2";
				label = " ";
				edit_width = 7;
				fixed_width = true;
			}
		}
	}
	: edit_box {
		key = "Str3";
		label = "User Name: ";
		edit_width = 45;
		fixed_width = true;
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
		}
		: spacer {
			width = 1;
		}
		: button {
			label       = "Cancel";
			key         = "cancel_button";
			mnemonic    = "C";
			width       = 8;
			fixed_width = true;
			is_cancel   = true;
		}
	}
	: spacer { height = 0.5; }
}
////////////////////////////////////////////////////////
INIMult : dialog {
	label     = "INI Multipliers";
	alignment = centered;
	initial_focus = "TM_SLDR";
	: spacer { height = 1; }
	: boxed_row {
		label	= "Text Multiplier:";
		: edit_box {
			key			= "TM_EDIT";
			default		= "100";
			edit_width	= 6;
			fixed_width	= true;
		}
		: slider {
			key			= "TM_SLDR";
			default		= 100;
			min_value		= 0;
			max_value		= 500;
		}
	}
	: spacer { height = 1; }
	: boxed_row {
		label	= "Symbol Multiplier:";
		: edit_box {
			key			= "SM_EDIT";
			default		= "100";
			edit_width	= 6;
			fixed_width	= true;
		}
		: slider {
			key			= "SM_SLDR";
			default		= 100;
			min_value		= 0;
			max_value		= 500;
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
		}
		: spacer {
			width = 1;
		}
		: button {
			label       = "Cancel";
			key         = "cancel_button";
			mnemonic    = "C";
			width       = 8;
			fixed_width = true;
			is_cancel   = true;
		}
	}
	: spacer { height = 0.5; }
}
////////////////////////////////////////////////////////
INIPathAdds : dialog {
	label     = "INI Paths";
	alignment = centered;
	initial_focus = "Pth1";
	: spacer { height = 1; }
	: row {
		: column {
			: boxed_row { 
				label = "Personal Drive Path: ";
				: edit_box {
					key = "Pth1";
					edit_width = 85;
					fixed_width = true;
				}
			}
			: boxed_row { 
				label = "Templete Path:    ";
				: edit_box {
					key = "Pth12";
					edit_width = 85;
					fixed_width = true;
				}
			}
			: boxed_row { 
				label = "Drawing Path: ";
				: edit_box {
					key = "Pth3";
					edit_width = 85;
					fixed_width = true;
				}
			}
			: boxed_row { 
				label = "DWF Path:  ";
				: edit_box {
					key = "Pth11";
					edit_width = 85;
					fixed_width = true;
				}
			}
			: boxed_row { 
				label = "User Path:    ";
				: edit_box {
					key = "Pth5";
					edit_width = 85;
					fixed_width = true;
				}
			}
			: boxed_row { 
				label = "Plotting Path:";
				: edit_box {
					key = "Pth4";
					edit_width = 85;
					fixed_width = true;
				}
			}
			: boxed_row { 
				label = "Lisp Path:    ";
				: edit_box {
					key = "Pth6";
					edit_width = 85;
					fixed_width = true;
				}
			}
			: boxed_row { 
				label = "Lookup Path:    ";
				: edit_box {
					key = "Pth7";
					edit_width = 85;
					fixed_width = true;
				}
			}
			: boxed_row { 
				label = "Menu Path:  ";
				: edit_box {
					key = "Pth8";
					edit_width = 85;
					fixed_width = true;
				}
			}
			: boxed_row { 
				label = "Symbol Path:  ";
				: edit_box {
					key = "Pth9";
					edit_width = 85;
					fixed_width = true;
				}
			}
			: boxed_row { 
				label = "DLG Path:  ";
				: edit_box {
					key = "Pth10";
					edit_width = 85;
					fixed_width = true;
				}
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
		}
		: spacer {
			width = 1;
		}
		: button {
			label       = "Cancel";
			key         = "cancel_button";
			mnemonic    = "C";
			width       = 8;
			fixed_width = true;
			is_cancel   = true;
		}
	}
	: spacer { height = 0.5; }
}
////////////////////////////////////////////////////////
INIPathAddsPlot : dialog {
	label     = "AddsPlot INI Paths";
	alignment = centered;
	initial_focus = "Pth1";
	: spacer { height = 1; }
	: row {
		: column {
			: boxed_row { 
				label = "Personal Drive Path: ";
				: edit_box {
					key = "Pth1";
					edit_width = 85;
					fixed_width = true;
				}
			}
			: boxed_row { 
				label = "Local Drive Path:    ";
				: edit_box {
					key = "Pth2";
					edit_width = 85;
					fixed_width = true;
				}
			}
			: boxed_row { 
				label = "Drawing Templete Path:  ";
				: edit_box {
					key = "Pth12";
					edit_width = 85;
					fixed_width = true;
				}
			}
			: boxed_row { 
				label = "Drawing Path: ";
				: edit_box {
					key = "Pth3";
					edit_width = 85;
					fixed_width = true;
				}
			}
			: boxed_row { 
				label = "DWF Path:  ";
				: edit_box {
					key = "Pth11";
					edit_width = 85;
					fixed_width = true;
				}
			}
			: boxed_row { 
				label = "Plotting Path:";
				: edit_box {
					key = "Pth4";
					edit_width = 85;
					fixed_width = true;
				}
			}
			: boxed_row { 
				label = "User Path:    ";
				: edit_box {
					key = "Pth5";
					edit_width = 85;
					fixed_width = true;
				}
			}
			: boxed_row { 
				label = "Lisp Path:    ";
				: edit_box {
					key = "Pth6";
					edit_width = 85;
					fixed_width = true;
				}
			}
			: boxed_row { 
				label = "LookUp Path:  ";
				: edit_box {
					key = "Pth7";
					edit_width = 85;
					fixed_width = true;
				}
			}
			: boxed_row { 
				label = "Menu Path:    ";
				: edit_box {
					key = "Pth8";
					edit_width = 85;
					fixed_width = true;
				}
			}
			: boxed_row { 
				label = "Symbol Path:  ";
				: edit_box {
					key = "Pth9";
					edit_width = 85;
					fixed_width = true;
				}
			}
			: boxed_row { 
				label = "DLG Path:  ";
				: edit_box {
					key = "Pth10";
					edit_width = 85;
					fixed_width = true;
				}
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
		}
		: spacer {
			width = 1;
		}
		: button {
			label       = "Cancel";
			key         = "cancel_button";
			mnemonic    = "C";
			width       = 8;
			fixed_width = true;
			is_cancel   = true;
		}
	}
	: spacer { height = 0.5; }
}
////////////////////////////////////////////////////////
DivPath : dialog {
	label     = "Div Paths";
	alignment = centered;
	initial_focus = "Pth0";
	: spacer { height = 1; }
	: column {
		: boxed_row { 
			label = "Birmingham Division Path: ";
			: edit_box {
				key = "Pth0";
				edit_width = 90;
				fixed_width = true;
				default = " ";
			}
			: toggle {
				label = "";
				key = "Ch0";
			}
		}
		: boxed_row { 
			label = "Eastern Division Path:";
			: edit_box {
				key = "Pth3";
				edit_width = 90;
				fixed_width = true;
				default = " ";
			}
			: toggle {
				label = "";
				key = "Ch3";
			}
		}
		: boxed_row { 
			label = "Mobile Division Path:    ";
			: edit_box {
				key = "Pth4";
				edit_width = 90;
				fixed_width = true;
				default = " ";
			}
			: toggle {
				label = "";
				key = "Ch4";
			}
		}
		: boxed_row { 
			label = "Southern Division Path:    ";
			: edit_box {
				key = "Pth1";
				edit_width = 90;
				fixed_width = true;
				default = " ";
			}
			: toggle {
				label = "";
				key = "Ch1";
			}
		}
		: boxed_row { 
			label = "SouthEastern Division Path:    ";
			: edit_box {
				key = "Pth5";
				edit_width = 90;
				fixed_width = true;
				default = " ";
			}
			: toggle {
				label = "";
				key = "Ch5";
			}
		}
		: boxed_row { 
			label = "Western Division Path: ";
			: edit_box {
				key = "Pth2";
				edit_width = 90;
				fixed_width = true;
				default = " ";
			}
			: toggle {
				label = "";
				key = "Ch2";
			}
		}
		: boxed_row { 
			label = "Transmission ACC Path: ";
			: edit_box {
				key = "Pth6";
				edit_width = 90;
				fixed_width = true;
				default = " ";
			}
			: toggle {
				label = "";
				key = "Ch6";
			}
		}
		: boxed_row { 
			label = "Transmission GCC Path: ";
			: edit_box {
				key = "Pth7";
				edit_width = 90;
				fixed_width = true;
				default = " ";
			}
			: toggle {
				label = "";
				key = "Ch7";
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
		}
		: spacer {
			width = 1;
		}
		: button {
			label       = "Cancel";
			key         = "cancel_button";
			mnemonic    = "C";
			width       = 8;
			fixed_width = true;
			is_cancel   = true;
		}
	}
	: spacer { height = 0.5; }
}
////////////////////////////////////////////////////////
