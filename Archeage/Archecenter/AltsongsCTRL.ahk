; !=Alt, ^=Ctrl and +=Shift
;Globals
;----------

global minDelay = 700, maxDelay = 1000,ProcessID

;Init
;----------

FindArcheageProcess()
Loop{
  SendKeys()
  Sleep 15000
}
return
	
;Functions
;------

SendKeys()
{
	Random, Rng , minDelay, maxDelay
	Sleep %Rng%
	
	ControlSend,, 1, ahk_id %ProcessID%
  Sleep %Rng%
  ControlSend,, 2, ahk_id %ProcessID%
  Sleep %Rng%
  ControlSend,, 3, ahk_id %ProcessID%
  Sleep %Rng%
  ControlSend,, 4, ahk_id %ProcessID%
}


FindArcheageProcess()
{
	WinGet, ProcessIDs, List
	
	Loop %ProcessIDs%
	{
		CurrentID := ProcessIDs%A_Index%
		WinGetClass wt, ahk_id %CurrentID%
		IfInString, wt, ArcheAge
		{
      ProcessID := ProcessIDs%A_Index%
		}
	}
}