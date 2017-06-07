;Globals
;----------

global X, Y, Liste, ListeTxt, TxtFile := "None", Prozess := "None", ChOnOff = 1,StopScript = false

;Gui Layout
;----------

FindAllPrograms()
FindAllTxT()
CreateGui()
return

;Lables
;----------

GuiClose:
	ExitApp
	return

BeginHaxx:
	Magixx()
	return
	
SaveProcessName:
	InputBox, Prozess, Prozess Name, Enter your Archeage Process Name., , 300, 150
	Gui Submit, NoHide
	Gui, Destroy
	CreateGui()
	CrossHairOff()
	return
	
SaveTxtFile:
	InputBox, TxtFile, Txt File Name, Enter Txt File Name., , 300, 150
	Gui Submit, NoHide
	Gui, Destroy
	CreateGui()
	CrossHairOff()
	return

ApplyCrossHair:
	if ChOnOff = 0
		CrossHairOn()
	else
		CrossHairOff()
	return
	
	
;Functions
;----------
Magixx()
{	
	StopScript = false
	PosX := 0, PosY := 0
	LenX := 0, LenY := 0
	blank := " "
	WinActivate, ahk_id %Prozess%
	Loop, read, %TxtFile%			
	{
		Loop, parse, A_LoopReadLine, `n				
		{
			StringGetPos, LenX, A_LoopReadLine, %blank%  
			StringLen, LenY, A_LoopReadLine
			PosX := SubStr(A_LoopReadLine,1,LenX)
			PosY := SubStr(A_LoopReadLine,LenX+1,LenY-LenX)
			Sleep 40
			Send 1
			MouseMove, %PosX%,%PosY%
			Sleep 1100
			Click %PosX%,%PosY%
			Sleep 50
			Click right
			Sleep 2200
			if StopScript = true
				break
			}
		if StopScript = true
			break
	}
}

CreateGui()
{
	Gui, Add, Edit , x10 y10 w480 h120, %Liste%
	Gui, Add, Edit , x10 y280 w480 h120, %ListeTxt%
	Gui, Font, cWhite
	Gui, Color, Black
	
	Gui, Add, Button, x10 y140 gSaveProcessName, SelectProcess
	Gui, Add, Text, x10 y170, currently selected Archeage instance:
	Gui, Add, Text, x10 y200, %Prozess%
	
	Gui, Add, Button, x10 y410 gSaveTxtFile, SelectTxt
	Gui, Add, Text, x10 y440, currently selected Txt File:
	Gui, Add, Text, x10 y470, %TxtFile%
	
	Gui, Add, Button, x350 y470 gApplyCrossHair, Align On/Off
	Gui, Add, Button, x430 y470 gBeginHaxx, Start Script
	Gui, Show, x500 y500 w500 h500, L33tHaxx0rMan
}

CrossHairOn()
{
	ChOnOff := 1
	
	;WinGetTitle wt, ahk_id %Prozess%
	WinGetPos, X, Y, W, H, ahk_id %Prozess%
	
	Gui, 2: +Toolwindow -Caption +Lastfound +AlwaysOnTop
    Gui, 2: Color, black 
    Gui, 2: Show, % "x" . x+(w/2)-1 . "y" . y . "w" . 3 . "h" . h, Overlay
	Gui, 3: +Toolwindow -Caption +Lastfound +AlwaysOnTop
    Gui, 3: Color, black 
    Gui, 3: Show, % "x" . x . "y" . y+(h/2)-1 . "w" . w . "h" . 3, Overlay
}

CrossHairOff()
{	
	ChOnOff := 0
	Gui, 2: Destroy
	Gui, 3: Destroy
}

FindAllPrograms()
{
	WinGet windows, List
	Loop %windows%
	{
		id := windows%A_Index%
		WinGetTitle wt, ahk_id %id%
		IfInString, wt, ArcheAge
		{
			Liste := Liste . windows%A_Index% . "`n"
		}
	}
	return 
}

FindAllTxT()
{
	ListeTxt =
	Loop *.*
	{
		ListeTxt = %ListeTxt%`n%A_LoopFileName%
	}
	return
}

$Escape::
	StopScript = true
	Send, {Escape}
	return
	