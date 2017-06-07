Bhop:
*~$Space::
Send, {Blind}{Space}
Sleep 2
Loop
{
	GetKeyState, state, Space, P
	If state = U
		Send, {Blind}{LShift up}
	If state = D
		Send, {Blind}{LShift down}
}
