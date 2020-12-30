; !=Alt, ^=Ctrl and +=Shift
;Globals
;----------

global minDelay = 700, maxDelay = 1000

;Init
;----------

Loop{
  SendKeys()
  Sleep 18000
}
return
	
;Functions
;------

SendKeys()
{
	Random, Rng , minDelay, maxDelay
	Sleep %Rng%
	
	Send, 1
  Sleep %Rng%
  Send, 2
  Sleep %Rng%
  Send, 3
  Sleep %Rng%
  Send, 4
}
