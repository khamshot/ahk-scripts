; !=Alt, ^=Ctrl and +=Shift
SetWorkingDir %A_ScriptDir%

;Keybinds
;----------

^+!f9::
  if guiEnabled{
    DestroyGui()
    guiEnabled = 0
  }
  else{
    CreateGui()
    guiEnabled = 1
  }
return

;Lables
;----------

RecordClicks:
  Run *RunAs RecordClicks.ahk
return

ReplayClicks:
  Run *RunAs ReplayClicks.ahk
return

;Functions
;----------

CreateGui(){
  Gui, Font, cWhite
  Gui, Color, Black

  Gui, Add, Button, x20 y10 gRecordClicks, Record Clicks
  Gui, Add, Button, x20 y50 gReplayClicks, Replay Clicks
  
  Gui, Show, x500 y500 w120 h150, ArchCenter
}

DestroyGui(){
  Gui, 1: Destroy
}
