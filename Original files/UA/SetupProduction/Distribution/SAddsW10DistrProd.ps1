[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

#	*** Checks to see if Div_Map.ini file exist in local users computer, if not gets a copy of default ini. ***
$sourceFile = "S:\Workgroups\APC Power Delivery\Division Mapping Test\Test Distribution\Setup\div_map.ini"
$targetFile = "C:\Div_Map\div_map.ini" 
if(!(Test-Path -path C:\Div_Map\div_map.ini))        {Copy-Item "$sourceFile" -Destination "$targetFile" }


#	***	Creates C:\Div and subdirectories & Copies updated files to Local/User computer	***
$sourceDir = "S:\Workgroups\APC Power Delivery\Division Mapping\AddsW10"
$targetDir = "C:\Div_Map\Adds"
robocopy $sourceDir $targetDir /S /XO /SEC /np /nfl		# S~Copies subdirectories excludes empty directories 
														# XO~Excludes older files  
														# SEC~Copies files with security 

$targetDir = "C:\Div_Map\Common"
$sourceDir = "S:\Workgroups\APC Power Delivery\Division Mapping\CommonW10"
robocopy $sourceDir $targetDir /lev:0 /XO /SEC /np /nfl

$sourceDir = "S:\Workgroups\APC Power Delivery\Division Mapping\DosLib"
$targetDir = "C:\Div_Map\DosLib"
robocopy $sourceDir $targetDir /lev:0 /XO /SEC /np /nfl

$sourceDir = "S:\Workgroups\APC Power Delivery\Division Mapping\Icon_Collection"
$targetDir = "C:\Div_Map\Icon_Collection"
robocopy $sourceDir $targetDir /S /XO /SEC /np /nfl

$sourceDir = "S:\Workgroups\APC Power Delivery\Division Mapping\LookUpTable"
$targetDir = "C:\Div_Map\LookUpTable"
robocopy $sourceDir $targetDir /S /XO /SEC /np /nfl

$sourceDir = "S:\Workgroups\APC Power Delivery\Division Mapping\Utils"
$targetDir = "C:\Div_Map\Utils"
robocopy $sourceDir $targetDir /S /XO /SEC /np /nfl


#	**** Checks to see if AUTODESK Map 3D 2016 is installed if not it will install it. ***
$bkey = (Get-ItemProperty "HKLM:\SOFTWARE\Autodesk\AutoCAD\R20.1\ACAD-F002:409").ProductID
if($bkey -eq "F002")
	{
 	#	[System.Windows.Forms.MessageBox]::Show(“AutoCAD Map 3D 2016 has been installed.", "ADDS", 
 	#		[System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)::OK
	}
	else
	{
		[System.Windows.Forms.MessageBox]::Show(“AutoCAD Map 3D 2016 has NOT been installed.", "ADDS", 
			[System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)::OK
		#	MH  shortcut to install AutoCAD Map3 2016
		$pathvargs = {\\southernco.com\dfsroot\Software\Components\AutoIt\AutoIt3.exe "\\southernco.com\dfsroot\Software\InstallPackages\Autodesk Map3D 2016\Map3D2016.au3"}
        Invoke-Command -ScriptBlock $pathvargs  
	}

#	***	Check Registy to see if Adds_T profile exists	****
$key = "HKCU:\SOFTWARE\Autodesk\AutoCAD\R20.1\ACAD-F002:409\Profiles\ADDS"
$profileExists = Test-Path $key
If($profileExists -eq $True)
{
	Start-Process -FilePath "C:\Program Files\Autodesk\AutoCAD 2016\acad.exe" -ArgumentList "/nologo /p ADDS"
}
else
{
    Start-Process -FilePath "C:\Program Files\Autodesk\AutoCAD 2016\acad.exe" -ArgumentList "/nologo /b C:\Div_Map\Common\AddProfSAdds.Scr"
}