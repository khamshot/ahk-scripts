;Globals
;----------

global X, Y, Keys, Liste := 0, Liste1, Liste2, Liste3, Liste4, Liste5, Liste6
;Gui Layout
;----------

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
	
	Gui, Add, Text, x10 y10, make sure your fishing skills are on 1,2,3,4,5 !!!!
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

$1::
	WinGet, winid ,, A
	ControlSend,, 1, ahk_id %winid%
	Loop %Liste%
	{
		Random, Rng , 100, 300
		Sleep %Rng%
		id := Liste%A_Index%
		if (id <> winid)
			ControlSend,, 1, ahk_id %id%
	}
	return
	
$2::
	WinGet, winid ,, A
	ControlSend,, 2, ahk_id %winid%
	Loop %Liste%
	{
		Random, Rng , 100, 300
		Sleep %Rng%
		id := Liste%A_Index%
		if (id <> winid)
			ControlSend,, 2, ahk_id %id%
	}
	return	
	
$3::
	WinGet, winid ,, A
	ControlSend,, 3, ahk_id %winid%
	Loop %Liste%
	{
		Random, Rng , 100, 300
		Sleep %Rng%
		id := Liste%A_Index%
		if (id <> winid)
			ControlSend,, 3, ahk_id %id%
	}
	return	
	
$4::
	WinGet, winid ,, A
	ControlSend,, 4, ahk_id %winid%
	Loop %Liste%
	{
		Random, Rng , 100, 300
		Sleep %Rng%
		id := Liste%A_Index%
		if (id <> winid)
			ControlSend,, 4, ahk_id %id%
	}
	return	
	
$5::
	WinGet, winid ,, A
	ControlSend,, 5, ahk_id %winid%
	Loop %Liste%
	{
		Random, Rng , 100, 300
		Sleep %Rng%
		id := Liste%A_Index%
		if (id <> winid)
			ControlSend,, 5, ahk_id %id%
	}
	return	
	