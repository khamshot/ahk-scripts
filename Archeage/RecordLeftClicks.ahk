﻿; !=Alt, ^=Ctrl and +=Shift
; make sure to run as Admin

SetWorkingDir %A_ScriptDir%
TrayTip ,Info ,Once you are done press Esc., 10, 33 
i := 0
clickString := ""

;Keybinds
;----------

LButton::
  Click
  IfWinActive, ahk_class ArcheAge
  {
    i += 1
    MouseGetPos, X, Y
    clickString = %clickString%%X%,%Y%`n
  }
  Sleep 100
return

Esc::
  FileSelectFile, fileName, S24
  if ErrorLevel
    ExitApp
  FileAppend , %clickString%, %fileName%
  ExitApp
return

