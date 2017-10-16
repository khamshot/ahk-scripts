Bhop:
*~$Space::
Send, {Blind}{Space}
Sleep 2
Loop{
	GetKeyState,state,space,P
		if state = U
			break
		Send,{space}
		Sleep,20
	}
	return
	