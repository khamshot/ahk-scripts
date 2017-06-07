;Globals
;----------

global X, Y, Keys, Liste := 0, Liste1, Liste2, Liste3, Liste4, Liste5, Liste6
;Gui Layout
;----------

CoordMode, Pixel, Screen
FindAllPrograms()
CreateGui()
return

;Lables
;----------

GuiClose:
	ExitApp
	return
	
SuspendKeys:
	Suspend
	return	
	
RefreshAccounts:
	FindAllPrograms()
	return
	
;Functions
;----------
CreateGui()
{
	Gui, Font, cWhite
	Gui, Color, Black
	Gui, Add, Button, x10 y30 gSuspendKeys, On/Off
	Gui, Add, Button, x60 y30 gRefreshAccounts, RefreshAccounts
	Gui, Show, x100 y100 w300 h50, FamilyFishing
}

FindAllPrograms()
{
	WinGet windows, List
	Liste := 0
	Loop %windows%
	{
		id := windows%A_Index%
		WinGetTitle wt, ahk_id %id%
		IfInString, wt, ArcheAge
		{
			Liste := Liste + 1
			Liste%Liste% := windows%A_Index%
		}
	}
	return 
}

AutoFish(FishingIcon){
	ImageSearch, FoundX, FoundY, 0, 0, 1920, 1080, *50 %FishingIcon%
	if Errorlevel = 0
		{
		return "Found"
		}
	else	
		return "NotFound"	
}

SendKey(Key){
	WinGet, winid ,, A
	ControlSend,, %Key%, ahk_id %winid%
	Loop %Liste%
	{
		Random, Rng , 100, 200
		Sleep %Rng%
		id := Liste%A_Index%
		if (id <> winid)
			ControlSend,, %Key%, ahk_id %id%
	}
	return
}

F1::
	toggle=1
	While toggle
		{
		if AutoFish("BigReel.bmp") = "Found"{
			SendKey(5)
			Sleep 2000
			}
		else if AutoFish("Reel.bmp") = "Found"{
			SendKey(4)
			Sleep 2000	
			}
		else if AutoFish("GiveSlack.bmp") = "Found"{
			SendKey(3)
			Sleep 2000	
			}
		else if AutoFish("Right.bmp") = "Found"{
			SendKey(2)
			Sleep 2000	
			}
		else if AutoFish("Left.bmp") = "Found"{
			SendKey(1)
			Sleep 2000		
			}
		else{	
			Sleep 5
			}
		}
	return

F2::
	toggle=0
	return 