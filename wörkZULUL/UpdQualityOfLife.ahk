;Globals
;----------

global GuiEnabled = 0

;Keybinds
;----------

^+!f9::
  if GuiEnabled{
    DestroyGui()
    GuiEnabled = 0
  }
  else{
    CreateGui()
    GuiEnabled = 1
  }
return

;Lables
;----------

GuiClose:
  ExitApp
return

QFset:
  InputBox, CompanyTag, Eingabe: , Kundentag eingeben
  SkypeText := " wegen Update gesperrt. Nutzer werden gebeten die Datenbank zu verlassen."
  PostInSkypeChat(CompanyTag,SkypeText,"MSU chat")
return

QFdismiss:
  InputBox, CompanyTag, Eingabe:, Kundentag eingeben
  SkypeText := " Update wurde durgeführt. Die Datenbank kann somit wieder genutzt werden."
  PostInSkypeChat(CompanyTag,SkypeText,"MSU chat")
return

SetVersionTagSlow:
  MsgBox, Alle zu taggenden Objekte im GitExt markieren und volle Pfade kopieren!!!
  SetVersionTags(250)
return

SetVersionTagFast:
  MsgBox, Alle zu taggenden Objekte im GitExt markieren und volle Pfade kopieren!!!
  SetVersionTags(125)
return

;Functions
;----------

CreateGui(){
  Gui, Font, cWhite
  Gui, Color, Black

  Gui, Add, Text, x10 y15, UpdSperre / Skype :
  Gui, Add, Button, x160 y10 gQFset, setzen
  Gui, Add, Button, x210 y10 gQFdismiss, aufheben
  
  Gui, Add, Text, x10 y55, VersionTag setzen / GitExt :
  Gui, Add, Button, x160 y50 gSetVersionTagSlow, Slow
  Gui, Add, Button, x210 y50 gSetVersionTagFast, Fast
  
  Gui, Show, x500 y500 w300 h300, UpdateZULUL
}

DestroyGui(){
  Gui, 1: Destroy
}

PostInSkypeChat(CompanyTag,SkypeText,SkypeChannel){
  if ErrorLevel
    return
  IfWinExist, ahk_exe Skype.exe
  {
    WinActivate  
    Loop
      {
        IfWinActive, ahk_exe Skype.exe
        {
          Send, {alt down}1{alt up}
          Send, {shift down}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{shift up}
          Send, %SkypeChannel%
          Send, {Enter}
          Send, %CompanyTag%%SkypeText%
          ;Send, {Enter}
          break
        }
     }
  }  
}

SetVersionTags(Speed){
  if ErrorLevel
    return

  InputBox, VersionTag, Eingabe, Versiontag eingeben:
  if ErrorLevel
    return

  SetKeyDelay, %Speed%
  Sleep, 200
  ; Auslesen des Zwischenspeichers von Anfang bis Zeilenumbruch wobei CR als Ausschlusszeichen (OmitChar deklariert sein muss!)
  ; ACHTUNG geht nicht mit ' sondern nur mit `
  Loop, parse, clipboard, `n, `r
  {
    ; Mit dem Pfad aus der Zwischenablage die Datei öffnen
    filereadline, LINETEXT, %A_LoopField%, 7
    IfNotInString, LINETEXT, %VersionTag%
    {
      Run, notepad++.exe %A_LoopField%
      Loop
      {
        IfWinActive, ahk_exe notepad++.exe
        {
          Sleep (%Speed%*2)
          SendEvent {Down 6}
          SendEvent {End}
          SendEvent {Left}
          SendEvent {,}
          Send %VersionTag%
          SendEvent ^s
          SendEvent ^w
          SendEvent !{F4}
          Sleep, (%Speed%)
          break
        }
      }
    }
  }
}