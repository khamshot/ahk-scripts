; !=Alt, ^=Ctrl and +=Shift
;Globals
;----------

global minDelay = 700, maxDelay = 1000, Clients, Clients1, Clients2, Clients3, Clients4

;Init
;----------

FindAllPrograms()
Loop{
  SendKeys()
  Sleep 18000
}
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

SendKeys()
{
  WinGet, winid ,, A
	Loop %Clients%
	{
		Random, Rng , minDelay, maxDelay
		Sleep %Rng%
		id := Clients%A_Index%
		if (id <> winid)
    {
			ControlSend,, 1, ahk_id %id%
      Sleep %Rng%
      ControlSend,, 2, ahk_id %id%
      Sleep %Rng%
      ControlSend,, 3, ahk_id %id%
      Sleep %Rng%
    }
	}
}
