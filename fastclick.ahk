

XButton1::suspend, toggle



*~$LButton::

Sleep 2
Loop
{
GetKeyState,LButtonState, LButton, P
If LButtonState = U
	break
Sleep 4
Send, {Blind}{LButton}
}

