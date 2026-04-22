PropA : dialog
{
	label     = "Properties";
	key       = "title_bar";
	alignment = centered;
	: boxed_column
	{
		label = "Property Selection:";
		: row
		{
			: spacer
			{
				width = 0.125;
			}
			: row
			{
				: radio_row
				{
					: radio_button
					{
						label    = "Overhead";
						key      = "oh_radio";
						value    = "0";
						mnemonic = "O";
					}
				}
				: radio_row
				{
					: radio_button
					{
						label    = "Underground";
						key      = "ug_radio";
						value    = "0";
						mnemonic = "U";
					}
				}
				: radio_row
				{
					: radio_button
					{
						label    = "Transmission";
						key      = "tm_radio";
						value    = "0";
						mnemonic = "O";
					}
				}
			}
		}
		: popup_list
		{
			label		= "Voltage:  ";
			key			= "vt_popup";
			mnemonic	= "V";
			edit_width	= 35;
		}
		: popup_list
		{
			label		= "Feeder:   ";
			key			= "fd_popup";
			mnemonic	= "F";
			edit_width	= 40;
		}
		: popup_list
		{
			label		= "Phasing:  ";
			key			= "ph_popup";
			mnemonic	= "P";
			edit_width	= 35;
		}
		: spacer
		{
			height = 0.125;
		}
	   :boxed_column
	   {
	   label = "Wire Details";
		alignment = centered;
			:boxed_column
			{
				label = "Primary";
				alignment = centered;
				: row
				{
					: popup_list
					{
						label           = "Size: ";
						key             = "Pri_S_popup";
						edit_width      = 6;
					}
					: popup_list
					{
						label           = "Type: ";
						key             = "Pri_T_popup";
						mnemonic        = "T";
						edit_width      = 10;
					}
				}
			}
			:boxed_column
			{
				label = "Neutral";
				alignment = centered;
				: row
				{
					: popup_list
					{
						label           = "Size: ";
						key             = "Neu_S_popup";
						mnemonic        = "S";
						edit_width      = 6;
					}
					: popup_list
					{
						label           = "Type: ";
						key             = "Neu_T_popup";
						mnemonic        = "T";
						edit_width      = 10;
					}
				}
			}
		}
	}
	: row
	{
		alignment   = centered;
		fixed_width = true;
		: button
		{
			label       = "OK";
			key         = "ok_button";
			mnemonic    = "O";
			width       = 8;
			fixed_width = true;
		}
		: spacer
		{
			width = 1;
		}
		: button
		{
			label       = "Cancel";
			key         = "cancel_button";
			mnemonic    = "C";
			width       = 8;
			fixed_width = true;
			is_cancel   = true;
		}
	}
	: spacer
	{
		height = 0.125;
	}
}

Prop1 : dialog
{
	label         = "Which Property";
	alignment     = centered;
	initial_focus = "add_button";
	: boxed_column
	{
		label = "Property Selection:";
		: spacer
		{
			height = 0.125;
		}
		: row
		{
			alignment   = centered;
			fixed_width = true;
			: button
			{
				label       = "Add";
				key         = "add_button";
				mnemonic    = "A";
				width       = 8;
				fixed_width = true;
				is_default  = true;
			}
			: spacer
			{
				width = 1;
			}
			: button
			{
				label       = "Query";
				key         = "query_button";
				mnemonic    = "Q";
				width       = 8;
				fixed_width = true;
			}
			: spacer
			{
				width = 1;
			}
			: button
			{
				label       = "Edit";
				key         = "edit_button";
				mnemonic    = "E";
				width       = 8;
				fixed_width = true;
			}
		}
		: spacer
		{
			height = 0.125;
		}
	}
	: spacer
	{
		height = 0.125;
	}
}

Prop4 : dialog
{
	label     = "Properties";
	key       = "title_bar";
	alignment = centered;
	: boxed_row
	{
		label = "Property Selection:";
		: boxed_radio_column
		{
			label = "Mode to Apply:";
			key   = "mode_radio";
			: radio_button
			{
				label = "Existing";
				key   = "ME_radio";
				value = "0";
			}
			: radio_button
			{
				label = "Install";
				key   = "MI_radio";
				value = "0";
			}
			: radio_button
			{
				label = "Change";
				key   = "MC_radio";
				value = "0";
			}
			: radio_button
			{
				label = "Remove";
				key   = "MR_radio";
				value = "0";
			}
		}
		: boxed_column
		{
			label = "Elevation:";
			: column
			{
				: radio_button
				{
					label    = "Overhead";
					key      = "oh_radio";
					value    = "0";
					mnemonic = "O";
				}
				: radio_button
				{
					label    = "Underground";
					key      = "ug_radio";
					value    = "0";
					mnemonic = "U";
				}
			}
		}
	}
	: boxed_column
	{
		: popup_list
		{
			label    	= "Voltage:  ";
			key      	= "vt_popup";
			mnemonic 	= "V";
			edit_width	= 35;
		}
		: popup_list
		{
			label		= "Feeder:   ";
			key			= "fd_popup";
			mnemonic	= "F";
			edit_width	= 35;
		}
		: popup_list
		{
			label		= "Phasing:  ";
			key			= "ph_popup";
			mnemonic	= "P";
			edit_width	= 35;
		}
		: spacer
		{
			height = 0.125;
		}
	   :boxed_column
	   {
			label = "Wire Details";
			alignment = centered;
			:boxed_column
			{
				label = "Primary";
				alignment = centered;
				: row
				{
					: popup_list
					{
						label           = "Size: ";
						key             = "Pri_S_popup";
						mnemonic        = "S";
						edit_width      = 6;
					}
					: popup_list
					{
						label           = "Type: ";
						key             = "Pri_T_popup";
						mnemonic        = "T";
						edit_width      = 10;
					}
				}
			}
			:boxed_column
			{
				label = "Neutral";
				alignment = centered;
				: row
				{
					: popup_list
					{
						label           = "Size: ";
						key             = "Neu_S_popup";
						mnemonic        = "S";
						edit_width      = 6;
					}
					: popup_list
					{
						label           = "Type: ";
						key             = "Neu_T_popup";
						mnemonic        = "T";
						edit_width      = 10;
					}
				}
			}
		}
	}
	: row
	{
		alignment   = centered;
		fixed_width = true;
		: button
		{
			label       = "OK";
			key         = "ok_button";
			mnemonic    = "O";
			width       = 8;
			fixed_width = true;
		}
		: spacer
		{
			width = 1;
		}
		: button
		{
			label       = "Cancel";
			key         = "cancel_button";
			mnemonic    = "C";
			width       = 8;
			fixed_width = true;
			is_cancel   = true;
		}
	}
	: spacer
	{
		height = 0.125;
	}
}
