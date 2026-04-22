dcl_settings : default_dcl_settings { audit_level = 3; }
////////////////////////////////////////////////////////
FdLstR : dialog {
	label     = "Choose Feeder";
	alignment = centered;
	initial_focus = "Lst1";
	: spacer { height = 1; }
	: row { 
		: popup_list {
			key = "Lst1";
			label = "Feeder:";
			edit_width = 40;
			fixed_width = true;
		}
	}
	: spacer { height = 1; }
	ok_cancel;
	: spacer { height = 0.5; }
}
////////////////////////////////////////////////////////
SbLstR : dialog {
	label     = "Choose Substation";
	alignment = centered;
	initial_focus = "Lst1";
	: spacer { height = 1; }
	: row { 
		: popup_list {
			key = "Lst1";
			label = "Substation:";
			edit_width = 40;
			fixed_width = true;
		}
	}
	: spacer { height = 1; }
	ok_cancel;
	: spacer { height = 0.5; }
}
////////////////////////////////////////////////////////
sclfactor : dialog {
	label     = "Set Scale";
	alignment = centered;
	: boxed_radio_column {
		label = "Symbol Scale:";
		key   = "scale_radio";
		: radio_button {
			label = "250 Feet/Inch";
			key   = "scl_250_radio";
			value = "0";
		}
		: radio_button {
			label = "500 Feet/Inch";
			key   = "scl_500_radio";
			value = "0";
		}
		: radio_button {
			label = "1000 Feet/Inch";
			key   = "scl_1000_radio";
			value = "0";
		}
		: radio_button {
			label = "2000 Feet/Inch";
			key   = "scl_2000_radio";
			value = "0";
		}
		: radio_button {
			label = "By Panel";
			key   = "scl_BYPAN_radio";
			value = "0";
		}
	}
	: spacer {
		height = 0.125;
	}
	ok_cancel;
	: spacer {
		height = 0.125;
	}
}
////////////////////////////////////////////////////////
SrchName : dialog {
	initial_focus	= "SrchInp";
	: edit_box {
		label		= "Switch Name:";
		key		= "SrchInp";
		width		= 12;
		allow_accept	= true;
	}
	ok_cancel;
}
//////////////////////////////////////////////////////////////
Save : dialog {
	label = "Adds 3.0.0";
	: column {
		:	text {
			label = "Do you wish to Save Changes?";
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
//////////////////////////////////////////////////////////////
SaveAll : dialog {
	label = "Adds 3.0.0";
	: column {
		:	text {
			label = "Do you wish to Save All Panels?";
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
//////////////////////////////////////////////////////////////
CloseAll : dialog {
	label = "Adds 3.0.0";
	: column {
		:	text {
			label = "Do you wish to Close All Panels?";
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
//////////////////////////////////////////////////////////////
SavCloseAll : dialog {
	label = "Adds 3.0.0";
	: column {
		:	text {
			label = "Do you wish to Save + Close All Panels?";
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
DigSet : dialog {
	label = "Digitizer / Mouse Settings";
	: column {
		:	row {
			:	boxed_radio_column {
				label = "Pointing Device";
				alignment = centered;
				:	radio_button {
					label = "Mouse    ";
					value = "1";
					key = "MouseKey";
				}
				:	radio_button {
					label = "Digitizer";
					value = "0";
					key = "DigiKey";
				}
			}
		}
		spacer_1;
		:	row {
			:	boxed_radio_column {
				label = "Digitizer Sizes";
				alignment = centered;
				:	radio_button {
					label = "11\" x 17\"";
					value = "1";
					key = "1117Key";
				}
				:	radio_button {
					label = "20\" x 30\"";
					value = "0";
					key = "2030Key";
				}
				:	radio_button {
					label = "30\" x 40\"";
					value = "0";
					key = "3040Key";
				}
			}
		}
		spacer_1;
		:	row {
			:	button {
				label = "Ok";
				is_default = true;
				key = "Ok_Button";
			}
			:	button {
				label = "Cancel";
				is_cancel = true;
				key = "Cancel_Button";
			}
		}
	}
}
////////////////////////////////////////////////////////
PropFdr : dialog {
	label     = "Sub Getaway Properties";
	key       = "title_bar";
	alignment = centered;
	: boxed_column {
		label = "Getaway Property Selection:";
		: popup_list {
			label		= "Voltage:  ";
			key			= "vt_popup";
			mnemonic	= "V";
			edit_width	= 35;
		}
		: popup_list {
			label		= "Feeder:   ";
			key			= "fd_popup";
			mnemonic	= "F";
			edit_width	= 35;
		}
		: spacer {
			height = 0.125;
		}
	}
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
	: spacer {
		height = 0.125;
	}
}
////////////////////////////////////////////////////////
PropSub : dialog {
	label     = "SubStation Properties";
	key       = "title_bar";
	alignment = centered;
	: boxed_column {
		label = "SubStation Property Selection:";
		: popup_list {
			label		= "Voltage:  ";
			key			= "vt_popup";
			mnemonic	= "V";
			edit_width	= 35;
		}
		: popup_list {
			label		= "SubStation:   ";
			key			= "sb_popup";
			mnemonic	= "S";
			edit_width	= 35;
		}
		: spacer {
			height = 0.125;
		}
	}
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
	: spacer {
		height = 0.125;
	}
}
//////////////////////////////////////////////////////////////
AddsUp : dialog {
	label = "Adds Up 3.0.0";
	: column {
		:	text {
			label = "Do you wish to Run Adds Up?";
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
