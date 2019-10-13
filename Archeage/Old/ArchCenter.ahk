; !=Alt, ^=Ctrl and +=Shift
SetWorkingDir %A_ScriptDir%

;Keybinds
;----------

global windowX := 50,windowY := 700

^+!f1::
  if guiEnabled{
    DestroyGui()
    guiEnabled = 0
  }
  else{
    CreateGui(windowX,windowY)
    guiEnabled = 1
  }
return

;Lables
;----------

FamilyFishing:
  Run *RunAs FamilyFishing.ahk
return
  
RecordClicks:
  Run *RunAs RecordClicks.ahk
return

ReplayClicks:
  Run *RunAs ReplayClicks.ahk
return

;Functions
;----------

CreateGui(xPos,yPos){
  Gui, Font, cWhite
  Gui, Color, Black

  Gui, Add, Button, x20 y10 gRecordClicks, Record Clicks
  Gui, Add, Button, x20 y50 gReplayClicks, Replay Clicks
  Gui, Add, Button, x140 y10 gFamilyFishing, Family Fishing
  
  Gui, Show, x%xPos% y%yPos% w250 h100, ArchCenter
}

DestroyGui(){
  WinGetPos, windowX, windowY,,, ArchCenter
  Gui, 1: Destroy
}
