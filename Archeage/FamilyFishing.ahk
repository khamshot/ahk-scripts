; !=Alt, ^=Ctrl and +=Shift
;Globals
;----------

global charName := "Kham", minDelay = 100, maxDelay = 300, Clients, Clients1, Clients2, Clients3, Clients4

;Init
;----------

FindAllPrograms()
CreateGui()
return

;Lables
;----------

GuiClose:
	ExitApp
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
	Gui, Add, Button, x10 y30 gRefreshAccounts, RefreshAccounts
	
	Gui, Show, x50 y700 w300 h60, FamilyFishing
}

FindAllPrograms()
{
	WinGet id, List
	Clients := 0
	Loop %id%
	{
		this_id := id%A_Index%
		WinGetClass wt, ahk_id %this_id%
		IfInString, wt, ArcheAge
		{
			Clients := Clients + 1
			Clients%Clients% := id%A_Index%
		}
	}
	return 
}

;Binds
;----------

$1::
	WinGet, winid ,, A
	ControlSend,, 1, ahk_id %winid%
	Loop %Clients%
	{
		Random, Rng , minDelay, maxDelay
		Sleep %Rng%
		id := Clients%A_Index%
		if (id <> winid)
			ControlSend,, 1, ahk_id %id%
	}
	return
	
$2::
	WinGet, winid ,, A
	ControlSend,, 2, ahk_id %winid%
	Loop %Clients%
	{
		Random, Rng , minDelay, maxDelay
		Sleep %Rng%
		id := Clients%A_Index%
		if (id <> winid)
			ControlSend,, 2, ahk_id %id%
	}
	return	
	
$3::
	WinGet, winid ,, A
	ControlSend,, 3, ahk_id %winid%
	Loop %Clients%
	{
		Random, Rng , minDelay, maxDelay
		Sleep %Rng%
		id := Clients%A_Index%
		if (id <> winid)
			ControlSend,, 3, ahk_id %id%
	}
	return	
	
$4::
	WinGet, winid ,, A
	ControlSend,, 4, ahk_id %winid%
	Loop %Clients%
	{
		Random, Rng , minDelay, maxDelay
		Sleep %Rng%
		id := Clients%A_Index%
		if (id <> winid)
			ControlSend,, 4, ahk_id %id%
	}
	return	
	
$5::
	WinGet, winid ,, A
	ControlSend,, 5, ahk_id %winid%
	Loop %Clients%
	{
		Random, Rng , minDelay, maxDelay
		Sleep %Rng%
		id := Clients%A_Index%
		if (id <> winid)
			ControlSend,, 5, ahk_id %id%
	}
	return	
  
;usespam for fast hand in

*f::
	Send,f
	MouseClick, left, 475, 479
	Sleep 2
	Loop{
		GetKeyState,state,f,P
		if state = U
			break
		Send,f
		MouseClick, left, 475, 479
		Sleep,20
	}
return
  
$p::
  WinGet, winid ,, A 
  MouseGetPos, winX, winY
  Setkeydelay, 10
  
	Loop %Clients%
	{
		Random, Rng , minDelay, maxDelay
		Sleep %Rng%
		id := Clients%A_Index%
		if (id <> winid)
    {
      WinGetPos,,, W, H, ahk_id %id%
      WinActivate, ahk_id %id%
      W := W/2
       
      Send, {Enter}
			Send, {shift down}
      Send, 7
      Send, {shift up}
      Send, target{space}
      Send, %charName%
      Send, {Enter}
      
      MouseClick,,%W%, 40
    }
	}
  Sleep, 50
  WinActivate, ahk_id %winid%
  MouseMove, winX, winY
return
