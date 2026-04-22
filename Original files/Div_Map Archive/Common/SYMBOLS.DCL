dcl_settings : default_dcl_settings { audit_level = 3; }
////////////////////////////////////////////////////////
//CLASS : dialog {
//      label     = "CLASS";
//      alignment = centered;
//      : popup_list {
//              label = "Device Type:";
//              key = "lst1";
//              width = 40;
//              fixed_width = true;
//      }
//      : spacer { height = 1.0; }
//      ok_cancel;
//      : spacer { height = 0.50; }
//}
////////////////////////////////////////////////////////
CAPACTR : dialog {
	label     = "CAPACITOR";
	alignment = centered;
	initial_focus = "val1";
	: edit_box {
		is_enabled = false;
		key = "_Fdr";
		width = 40;
	}
	: row {
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_ou";
			width = 15;
		}
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_level";
			width = 15;
		}
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_Ph";
			width = 4;
		}
	}
	: spacer { height = 1; }
	: row { 
		: edit_box {
			key = "val1";
			label = "Location #:";
			edit_width = 8;
			edit_limit = 8;
			fixed_width = true;
		}
		: spacer { width = 1; }
		: popup_list {
			key = "lst2";
			label = "Size:";
			width = 20;
			fixed_width = true;
		}
	}
	: spacer { height = 1; }
	: popup_list {
		key = "lst1";
		label = "Device:";
		width = 30;
	}
	: spacer { height = 1; }
	ok_cancel;
	: spacer { height = 0.5; }
}
////////////////////////////////////////////////////////
CONSTRU : dialog {
	label     = "CONSTRUCTION";
	alignment = centered;
	initial_focus = "val1";
	: edit_box {
		is_enabled = false;
		key = "_Fdr";
		width = 40;
	}
	: row {
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_ou";
			width = 15;
		}
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_level";
			width = 15;
		}
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_Ph";
			width = 4;
		}
	}
	: spacer { height = 1; }
	: row { 
		: edit_box {
			key = "val1";
			label = "Location or Text:";
			edit_width = 8;
			edit_limit = 8;
			fixed_width = true;
		}
	}
	: spacer { height = 1; }
	: popup_list {
		key = "lst1";
		label = "Device:";
		width = 30;
	}
	: spacer { height = 1; }
	ok_cancel;
	: spacer { height = 0.5; }
}
////////////////////////////////////////////////////////
GUY : dialog {
	label     = "GUY";
	alignment = centered;
	initial_focus = "lst1";
	: edit_box {
		is_enabled = false;
		key = "_Fdr";
		width = 40;
	}
	: row {
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_ou";
			width = 15;
		}
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_level";
			width = 15;
		}
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_Ph";
			width = 4;
		}
	}
	: spacer { height = 1; }
 	: popup_list {
 		fixed_width = true;
 		key = "lst1";
 		label = "Type:";
 		width = 20;
 	}
	: spacer { height = 1; }
	ok_cancel;
	: spacer { height = 0.5; }
}
////////////////////////////////////////////////////////
LAND : dialog {
	label     = "Miscellanous  Landbase";
	alignment = centered;
	initial_focus = "lst1";
	: popup_list {
 		fixed_width = true;
		key = "lst1";
		label = "Device type:   ";
		width = 40;
	}
	: spacer { height = 1; }
	: edit_box {
		key = "val1";
		label = "Number/Name:";
		edit_width = 20;
		edit_limit = 20;
		fixed_width = true;
	}
	: spacer { height = 1; }
	: edit_box {
		key = "val2";
		label = "Description:   ";
		edit_width = 20;
		edit_limit = 20;
		fixed_width = true;
	}
	: spacer { height = 1; }
	ok_cancel;
	: spacer { height = 0.5; }
}
////////////////////////////////////////////////////////
LIGHT : dialog {
	label     = "STREET LIGHT";
	alignment = centered;
	initial_focus = "val1";
	: edit_box {
		is_enabled = false;
		key = "_Fdr";
		width = 40;
	}
	: row {
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_ou";
			width = 15;
		}
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_level";
			width = 15;
		}
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_Ph";
			width = 4;
		}
	}
	: spacer { height = 1; }
	: row { 
		: edit_box {
			key = "val1";
			label = "Location #:";
			edit_width = 8;
			edit_limit = 8;
			fixed_width = true;
		}
		: spacer { width = 1; }
		: popup_list {
			key = "lst2";
			label = "Size:";
			width = 20;
			fixed_width = true;
		}
	}
	: spacer { height = 1; }
	: popup_list {
		key = "lst1";
		label = "Device:";
		width = 30;
	}
	: spacer { height = 1; }
	ok_cancel;
	: spacer { height = 0.5; }
}
////////////////////////////////////////////////////////
MISC : dialog {
	label     = "Miscellanous  Electrical";
	alignment = centered;
	initial_focus = "val1";
	: edit_box {
		is_enabled = false;
		key = "_Fdr";
		width = 40;
	}
	: row {
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_ou";
			width = 15;
		}
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_level";
			width = 15;
		}
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_Ph";
			width = 4;
		}
	}
	: spacer { height = 1; }
	: popup_list {
 		fixed_width = true;
		key = "lst1";
		label = "Device type:   ";
		width = 40;
	}
	: spacer { height = 1; }
	: edit_box {
		key = "val1";
		label = "Number/Name:";
		edit_width = 20;
		edit_limit = 20;
		fixed_width = true;
	}
	: spacer { height = 1; }
	: edit_box {
		key = "val2";
		label = "Description:   ";
		edit_width = 20;
		edit_limit = 20;
		fixed_width = true;
	}
	: spacer { height = 1; }
	ok_cancel;
	: spacer { height = 0.5; }
}
////////////////////////////////////////////////////////
POLE : dialog {
	label     = "POLE";
	alignment = centered;
	initial_focus = "lst2";
	: edit_box {
		is_enabled = false;
		key = "_Fdr";
		width = 50;
	}
	: row {
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_ou";
			width = 15;
		}
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_level";
			width = 15;
		}
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_Ph";
			width = 4;
		}
	}
	: spacer { height = 1; }
	: row {
		: popup_list {
			fixed_width = true;
			key = "lst1";
			label = "Type:";
			width = 30;
		}
		: spacer { width = 1; }
		: popup_list {
			fixed_width = true;
			key = "lst2";
			label = "Height:";
			width = 10;
		}
		: spacer { width = 1; }
		: popup_list {
			fixed_width = true;
			key = "lst3";
			label = "Class:";
			width = 10;
		}
	}
	: spacer { height = 1; }
	ok_cancel;
	: spacer { height = 0.5; }
}
////////////////////////////////////////////////////////
RECLOSER : dialog {
	label     = "RECLOSER";
	alignment = centered;
	initial_focus = "val1";
	: edit_box {
		is_enabled = false;
		key = "_Fdr";
		width = 40;
	}
	: row {
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_ou";
			width = 15;
		}
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_level";
			width = 15;
		}
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_Ph";
			width = 4;
		}
	}
	: spacer { height = 1; }
	: row {
		: edit_box {
			key = "val1";
			label = "Location #:";
			edit_width = 8;
			edit_limit = 8;
			fixed_width = true;
		}
		: popup_list {
			key = "lst2";
			label = "Size:";
			width = 19;
			fixed_width = true;
		}
	}
	: spacer { height = 1; }
	: popup_list {
		key = "lst1";
		label = "Bank Type:";
		width = 35;
 	}
	: spacer { height = 1.0; }
//	: row {
		: edit_box {
			key = "val2";
			label = "Source: ";
			edit_width = 8;
			edit_limit = 8;
			fixed_width = true;
		}
		: spacer { height = 1.0; }
		: edit_box {
			key = "val3";
			label = "Bypass:";
			edit_width = 8;
			edit_limit = 8;
			fixed_width = true;
		}
		: spacer { height = 1.0; }
		: edit_box {
			key = "val4";
			label = "Load:    ";
			edit_width = 8;
			edit_limit = 8;
			fixed_width = true;
		}
//	}
	: spacer { height = 1.0; }
	ok_cancel;
	: spacer { height = 0.5; }
}
////////////////////////////////////////////////////////
REGLATOR : dialog {
	label     = "REGULATOR";
	alignment = centered;
	initial_focus = "val1";
	: edit_box {
		is_enabled = false;
		key = "_Fdr";
		width = 40;
	}
	: row {
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_ou";
			width = 15;
		}
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_level";
			width = 15;
		}
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_Ph";
			width = 4;
		}
	}
	: spacer { height = 1; }
	: row { 
		: edit_box {
			key = "val1";
			label = "Location #:";
			edit_width = 8;
			edit_limit = 8;
			fixed_width = true;
		}
		: spacer { width = 1; }
		: popup_list {
			key = "lst2";
			label = "Size:";
			width = 20;
			fixed_width = true;
		}
	}
	: spacer { height = 1; }
	: popup_list {
		key = "lst1";
		label = "Device:";
		width = 30;
	}
	: spacer { height = 1; }
	ok_cancel;
	: spacer { height = 0.5; }
}
////////////////////////////////////////////////////////
SWITCH : dialog {
	label     = "SWITCH";
	alignment = centered;
	initial_focus = "val1";
	: edit_box {
		is_enabled = false;
		key = "_Fdr";
		width = 40;
	}
	: row {
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_ou";
			width = 15;
		}
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_level";
			width = 15;
		}
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_Ph";
			width = 4;
		}
	}
	: spacer { height = 1; }
	: row { 
		: edit_box {
			key = "val1";
			label = "Location #:";
			edit_width = 8;
			edit_limit = 8;
			fixed_width = true;
		}
		: spacer { width = 1; }
		: popup_list {
			key = "lst2";
			label = "Fuse Size:";
			width = 8;
			fixed_width = true;
		}
	}
	: spacer { height = 1; }
	: popup_list {
		key = "lst1";
		label = "Type:";
		width = 30;
	}
	: spacer { height = 1; }
	ok_cancel;
	: spacer { height = 0.5; }
}
////////////////////////////////////////////////////////
CHSWITCH : dialog {
	label     = "CHANGE SWITCH TO";
	alignment = centered;
	initial_focus = "val1";
	: edit_box {
		is_enabled = false;
		key = "_Fdr";
		width = 40;
	}
	: row {
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_ou";
			width = 15;
		}
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_level";
			width = 15;
		}
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_Ph";
			width = 4;
		}
	}
	: spacer { height = 1; }
	: popup_list {
		key = "lst1";
		label = "Type:";
		width = 30;
	}
	: spacer { height = 1; }
	ok_cancel;
	: spacer { height = 0.5; }
}

////////////////////////////////////////////////////////
TRANSFRM : dialog {
	label     = "TRANSFORMER";
	alignment = centered;
	initial_focus = "val1";
	: edit_box {
		is_enabled = false;
		key = "_Fdr";
		width = 40;
	}
	: row {
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_ou";
			width = 15;
		}
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_level";
			width = 15;
		}
		: edit_box {
			fixed_width = true;
			is_enabled = false;
			key = "_Ph";
			width = 4;
		}
	}
	: spacer { height = 1; }
	: row {
		: edit_box {
			key = "val1";
			label = "Location #:";
			allow_accept = true;
			edit_width = 8;
			edit_limit = 8;
			fixed_width = true;
		}
		: spacer { width = 1; }
		: popup_list {
			key = "lst1";
			label = "Bank Type:";
			width = 35;
			fixed_width = true;
		}
	}
	: spacer { height = 1.0; }
	: row {
		: popup_list {
			key = "lst2";
			label = "Ph. A:";
			width = 4;
			fixed_width = true;
		}
		: spacer { width = 3; }
		: popup_list {
			key = "lst3";
			label = "Ph. B:";
			width = 4;
			fixed_width = true;
		}
		: spacer { width = 3; }
		: popup_list {
			key = "lst4";
			label = "Ph. C:";
			width = 4;
			fixed_width = true;
		}
	}
	: spacer { height = 1.0; }
	ok_cancel;
	: spacer { height = 0.5; }
}
////////////////////////////////////////////////////////
TXTDO : dialog {
	label     = "Text Entry";
	alignment = centered;
	initial_focus = "val1";
	: spacer { height = 1; }
	: row { 
		: edit_box {
			key			= "val1";
			label		= "Text:";
			edit_width	= 40;
			fixed_width	= true;
			allow_accept	= true;
		}
	}
	: spacer { height = 1; }
	ok_cancel;
	: spacer { height = 0.5; }
}
////////////////////////////////////////////////////////
TPH : dialog
{
	label       = "Phase Labels";
	key         = "title_bar";
	alignment   = centered;
 	fixed_width = true;
	: spacer {
		height = 0.125;
	}
	: boxed_row {
		: column {
			: popup_list {
				label		= "Top Left";
				key			= "TL_popup";
	  			edit_width	=5;
			}
			: popup_list {
				label		= "Middle Left";
				key			= "ML_popup";
	  			edit_width	=5;
			}
			: popup_list {
				label		= "Bottom Left";
				key			= "BL_popup";
				edit_width	=5;
			}
			: spacer {
				height = 0.125;
			}
		}
		: column {
			: popup_list {
				label		= "Top Middle";
				key			= "TM_popup";
				edit_width	=5;
			}
			: popup_list {
				label		= "Middle";
				key			= "MM_popup";
				edit_width	=5;
			}
			: popup_list {
				label		= "Bottom Middle";
				key			= "BM_popup";
				edit_width	=5;
			}
			: spacer {
				height = 0.125;
			}
		}
		: column {
			: popup_list {
				label		= "Top Right";
				key			= "TR_popup";
				edit_width	=5;
			}
			: popup_list {
				label		= "Middle Right";
				key			= "MR_popup";
				edit_width	=5;
			}
			: popup_list {
				label		= "Bottom Right";
				key			= "BR_popup";
				edit_width	=5;
			}
			: spacer {
				height = 0.125;
			}
		}
	}
	: spacer {
		height = 0.125;
	}
	: row {
		alignment	= centered;
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
	: spacer {
		height = 0.125;
	}
}
////////////////////////////////////////////////////////
LISTXT : dialog {
	label     = "Text from List";
	alignment = centered;
	initial_focus = "lst1";
	: popup_list {
		key = "lst1";
		label = "Choose Text:";
		width = 60;
	}
	: spacer { height = 1; }
	ok_cancel;
	: spacer { height = 0.5; }
}
//////////////////////////////////////////////////////
