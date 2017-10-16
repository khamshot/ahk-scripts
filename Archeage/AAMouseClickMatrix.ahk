global i := 0

LButton::
i += 1
MouseGetPos, X, Y
Click
if not i = 1
	FileAppend , %X% %Y%`n, New.txt
Sleep 40
return

Esc::
ExitApp

