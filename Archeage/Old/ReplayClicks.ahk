; !=Alt, ^=Ctrl and +=Shift
; make sure to run as Admin
SetWorkingDir %A_ScriptDir%

global AAClients := ""
global AAClientsCount := 0
global AANumber := 1

ListAAInstances()

Loop, Parse, AAClients, `,
{
  MarkInstances(A_Index,A_Loopfield)
}

if(AAClientsCount != 1)
{
  InputBox, AANumber, Input, Enter ArcheAge Instance Number (TopLeft of your Archeage Clients)
  if ErrorLevel
    ExitApp
}
AANumber += 0 

Loop, Parse, AAClients, `,
{
  DestroyMarks(A_Index)
  if AANumber = %A_Index%
    AAClient = %A_LoopField%
}

FileSelectFile, fileName, 3, , choose File
if ErrorLevel
  ExitApp
  
Playback(AAClient,fileName)

MsgBox, Done!
ExitApp


;Functions
;----------

Playback(AAClient,fileName)
{
  WinActivate, ahk_id %AAClient%
  posX := 0, posY := 0
  Loop, read, %fileName%
  {
    Loop, parse, A_LoopReadLine, `,
    {
      if A_Index = 1 
        posX = %A_LoopField%
      else
        posY = %A_LoopField%
    }
    Sleep 40
    Send 3
    Send 2
    Send 1
    MouseMove, %posX%,%posY%
    Sleep 1100
    Click %posX%,%posY%
    Click %posX%,%posY%
    Sleep 50
    Click right
    Sleep 2200
  }
}

MarkInstances(instanceNumber,instanceID)
{
  WinGetPos, X, Y, W, H, ahk_id %instanceID%
  Gui, num%instanceNumber%: +Toolwindow +AlwaysOnTop -Caption
  Gui, num%instanceNumber%: Font, cWhite
  Gui, num%instanceNumber%: Color, black 
  Gui, num%instanceNumber%: Add, Text, x5 y2, %instanceNumber%
  Gui, num%instanceNumber%: Show, % "x" . X . "y" . Y . "w20" . "h20", Overlay
}

DestroyMarks(instanceNumber)
{
  Gui, num%instanceNumber%: Destroy
}

ListAAInstances()
{
  WinGet windows, List, ahk_class ArcheAge
  Loop %windows%
  {
    id := windows%A_Index%
    AAClients := AAClients . windows%A_Index% . "," 
    AAClientsCount += 1
  } 
  AAClients := SubStr(AAClients,1,(StrLen(AAClients)-1))
}

Esc::
  ExitApp
return
