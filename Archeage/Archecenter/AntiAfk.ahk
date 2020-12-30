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
  
gui, Add, Button, x5 y5 gStopAntiAfk, Stop AntiAfk
gui, show, x%WindowX% y%WindowY% w90 h35

Loop
{
  ControlSend,, w, ahk_id %ProcessID%
  Sleep, 30000
}

StopAntiAfk:
  Exitapp  
return

;Keybinds
;----------