;Globals
;----------

global GuiEnabled = false

;Keybinds
;----------

^+!f9::
  if GuiEnabled{
    DestroyGui()
    GuiEnabled = false
  }
  else{
    CreateGui()
    GuiEnabled = true
  }
return

;Lables
;----------

GuiClose:
  ExitApp
return

QFset:
  CompanyTag := GetInput("Kundentag eingeben")
  if (ErrorLevel == 0)
  {
    IfWinExist, ahk_exe Skype.exe
    {
      WinActivate  
      Send, {alt down}1{alt up}
      Send, {shift down}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{shift up}
      Send, msu allgemein
      Send, {Enter}
      Send, %CompanyTag% Datenbank wegen QuickFixStopp gesperrt. Benutzer werden gebeten die Datenbank zu verlassen.
      Send, {Enter}
    }
  }
return

QFdismiss:
  CompanyTag := GetInput("Kundentag eingeben")
  if (ErrorLevel == 0)
  {
    IfWinExist, ahk_exe Skype.exe
    {
      WinActivate  
      Send, {alt down}1{alt up}
      Send, {shift down}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{shift up}
      Send, msu allgemein
      Send, {Enter}
      Send, %CompanyTag% Update erfolgreich durgeführt. Die Datenbank kann wieder genutzt werden.
      Send, {Enter}
    }
  }
return


;Functions
;----------

CreateGui(){
  Gui, Font, cWhite
  Gui, Color, Black

  Gui, Add, Button, x10 y10 gQFset, QF setzen / Skype
  Gui, Add, Button, x130 y10 gQFdismiss, QF aufheben / Skype
  
  Gui, Show, x500 y500 w500 h500, UpdateZULUL
}

DestroyGui(){
  Gui, 1: Destroy
}

GetInput(RequestText){
  InputBox, InString, Input String, %RequestText%, , 300, 150
  return InString
}