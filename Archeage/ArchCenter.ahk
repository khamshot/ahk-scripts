; !=Alt, ^=Ctrl and +=Shift

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

;Functions
;----------

CreateGui(){
  Gui, Font, cWhite
  Gui, Color, Black

  Gui, Add, Button, x20 y10 , Record Leftclicks
  Gui, Add, Button, x170 y10 , Playback Leftclicks
  
  Gui, Show, x500 y500 w300 h300, ArchCenter
}

DestroyGui(){
  Gui, 1: Destroy
}
