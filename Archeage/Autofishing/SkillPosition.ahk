; !=Alt, ^=Ctrl and +=Shift
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

FileName = %1%
Key = %2%
ProcessID = %3%
WindowX = %4%
WindowY = %5%

gui, +AlwaysOnTop
gui, Font, cWhite
gui, Color, Black
  
gui, add, text, ,Click close to the outside edge area of the %Key% skill
gui, show, x%WindowX% y%WindowY%

WinActivate, ahk_id %ProcessID%


;Keybinds
;----------

LButton::
{
  
  MouseGetPos, X, Y
  IniWrite, %X%, %FileName%, General, %Key%X
  IniWrite, %Y%, %FileName%, General, %Key%Y
  Exitapp
}
