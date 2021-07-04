; !=Alt, ^=Ctrl and +=Shift
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

ProcessID = %1%
WindowX = %2%
WindowY = %3%

gui, +AlwaysOnTop
gui, Font, cWhite
gui, Color, Black
gui, -SysMenu
  
gui, Add, Button, x5 y5 gStopFarming, Stop Farming
gui, show, x%WindowX% y%WindowY% w90 h35

Loop
{
  ControlSend,, 1, ahk_id %ProcessID%
  ControlSend,, 2, ahk_id %ProcessID%s
  ControlSend,, f, ahk_id %ProcessID%
  ControlSend,, {Right Down}, ahk_id %ProcessID%
  Sleep, 200
  ControlSend,, {Right Up}, ahk_id %ProcessID%
}

StopFarming:
  ControlSend,, {Right Up}, ahk_id %ProcessID%
  Exitapp  
return

;Keybinds
;----------