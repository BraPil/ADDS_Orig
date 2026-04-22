	--------------------------------------------------
	       Readme File for DOSLib Version 5.1.1
		      	    July 2000
        --------------------------------------------------
			
               (C) Robert McNeel & Associates, 2000

This document provides late-breaking or other information that 
supplements the DOSLib 5.1 User's Guide.

-------------------------
How to View This Document
-------------------------
To view the Readme file on-screen, open it in Windows Notepad or 
another word processor. To print the Readme file, click Print on 
the File menu.

--------
CONTENTS
--------

1.  NEW FUNCTIONS
    1.1  DOS_ACITORGB
    1.2  DOS_ADMINP
    1.3  DOS_GETCOLOR
    1.4  DOS_RGBTOACI


=====================
Part 1: NEW FUNCTIONS
=====================

1.1  DOS_ACITORGB

     The DOS_ACITORGB function converts an AutoCAD Color 
     Index (ACI) value to a RGB color value.

     Syntax:
	(dos_acitorgb aci-value)

     Argument:
     *  aci-value - an integer between 1 and 255 that
        represents an ACI color value.

     Returns:
     *  A list of three integers that represent an RGB color value
        if successful.
     *  nil on error.

     Example:
	(dos_acitorgb 1) -> (255 0 0)


1.2  DOS_ADMINP

     The DOS_ADMINP function determines whether the current
     user has administrator rights.  This is done by confirming
     membership in the local Administrators group.

     Syntax:
	(dos_adminp)

     Argument:
	none

     Returns:
     *  T if the current user is member of the local Administrators
	group if successful.
     *  nil if not a member or on error.

     Example:
	(dos_adminp) -> T


1.3  DOS_GETCOLOR

     The DOS_GETCOLOR function displays a Windows common color
     selection dialog box.  This is useful for selecting
     RGB color values.

     Syntax:
	(dos_getcolor title [aci-value/rgb-value])

     Argument:
     *  title - The dialog box title.

     Option:
     *  aci-value/rgb-value - an integer between 1 and 255 that
        represents an ACI color value, or a list of three integers
	that represent an RGB color value.

     Returns:
     *  A list of three integers that represent an RGB color value
        if successful.
     *  nil on error.

     Example:
	(dos_getcolor "Get a color" 1) -> (128 128 128)
	(dos_getcolor "Get a color" '(255 0 0)) -> (128 128 128)


1.4  DOS_RGBTOACI

     The DOS_RGBTOACI function converts an RGB color value to
     the closest AutoCAD Color Index (ACI) value.

     Syntax:
	(dos_rgbtoaci rgb-value)

     Argument:
     *  rgb-value - a list of three integers that represent an
        RGB color value.

     Returns:
     *  An ACI color value if successful.
     *  nil on error.

     Example:
	(dos_rgbtoaci '(255 0 0)) -> 1

