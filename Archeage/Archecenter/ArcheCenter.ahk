; !=Alt, ^=Ctrl and +=Shift
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

;Globals

global ProcessID, WindowX := 300, WindowY := 300, IsFishing := false, CurrentSkill := 0, FirmLeftX, FirmLeftY, FirmRightX, FirmRightY, SlackX, SlackY, ReelX, ReelY, BigReelX, BigReelY

;Init
;----------

LoadFishingSkills(false)
LoadSettings()
FindArcheageProcess(false)

Loop
{
  RngSleep()
  
  If IsFishing
  {
    ;FirmLeft
    If (CurrentSkill != 1)
    {
      MinX := FirmLeftX-3
      MaxX := FirmLeftX+3
      MinY := FirmLeftY-3
      MaxY := FirmLeftY+3
      PixelSearch, X, Y, %MinX%, %MinY%, %MaxX%, %MaxY%, 0xf9994a , 20, Fast RGB
      if !Errorlevel
      {
        ControlSend,, 1, ahk_id %ProcessID%
        CurrentSkill := 1
      }
    }
    
    ;FirmRight
    If (CurrentSkill != 2)
    {
      MinX := FirmRightX-3
      MaxX := FirmRightX+3
      MinY := FirmRightY-3
      MaxY := FirmRightY+3
      PixelSearch, X, Y, %MinX%, %MinY%, %MaxX%, %MaxY%, 0xf9994a , 20, Fast RGB
      if !Errorlevel
      {
        ControlSend,, 2, ahk_id %ProcessID%
        CurrentSkill := 2
      }
    }
    
    ;Slack
    If (CurrentSkill != 3)
    {
      MinX := SlackX-3
      MaxX := SlackX+3
      MinY := SlackY-3
      MaxY := SlackY+3
      PixelSearch, X, Y, %MinX%, %MinY%, %MaxX%, %MaxY%, 0xf9994a , 20, Fast RGB
      if !Errorlevel
      {
        ControlSend,, 3, ahk_id %ProcessID%
        CurrentSkill := 3
      }
    }
    
    ;Reel
    If (CurrentSkill != 4)
    {
      MinX := ReelX-3
      MaxX := ReelX+3
      MinY := ReelY-3
      MaxY := ReelY+3
      PixelSearch, X, Y, %MinX%, %MinY%, %MaxX%, %MaxY%, 0xf9994a , 20, Fast RGB
      if !Errorlevel
      {
        ControlSend,, 4, ahk_id %ProcessID%
        CurrentSkill := 4
      }
    }
    
    ;BigReel
    If (CurrentSkill != 5)
    {
      MinX := BigReelX-3
      MaxX := BigReelX+3
      MinY := BigReelY-3
      MaxY := BigReelY+3
      PixelSearch, X, Y, %MinX%, %MinY%, %MaxX%, %MaxY%, 0xf9994a , 20, Fast RGB
      if !Errorlevel
      {
        ControlSend,, 5, ahk_id %ProcessID%
        CurrentSkill := 5
      }
    }
    
  }else
  {
    sleep, 1000
  }
}

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
 
;GUI
;----------

CreateGui()
{
  gui, +AlwaysOnTop
  gui, Font, cWhite
  gui, Color, Black
  gui, -SysMenu
  
  gui, Add, Picture, x20 y10 w30 h30 gSetPosFirmLeft, Firmleft.png
  gui, Add, Picture, x60 y10 w30 h30 gSetPosFirmRight, Firmright.png
  gui, Add, Picture, x100 y10 w30 h30 gSetPosSlack, Slack.png
  gui, Add, Picture, x140 y10 w30 h30 gSetPosReel, Reel.png
  gui, Add, Picture, x180 y10 w30 h30 gSetPosBigreel, BigReel.png
  
  gui, Add, Button, x20 y50 w190 h20 gApplyFishingSkills, Apply Fishing Settings
  
  gui, Add, Button, x20 y80 w190 h20 gTestSkillPositions, Test Skill Positions
  
  gui, Add, Button, x20 y110 w80 h20 gStartFishing, Start Fishing
  gui, Add, Button, x130 y110 w80 h20 gStopFishing, Stop Fishing
  
  gui, Add, Button, x20 y140 w190 h20 gFindArcheageProcess, Find Archeage Process
  gui, Add, Text, x20 y170, Archeage Process ID:
  gui, Add, Text, x135 y170, %ProcessID%
  
  gui, Add, Button, x20 y200 w80 h20 gStartAntiAfk, Start AntiAfk
  
  gui, Show, x%WindowX% y%WindowY% w230 h230, ArchCenter
}

DestroyGui()
{
  WinGetPos, WindowX, WindowY,,, ArchCenter
  IniWrite, %WindowX%, UserSettings.ini, General, WindowX
  IniWrite, %WindowY%, UserSettings.ini, General, WindowY
  Gui, 1: Destroy
}

SetPosFirmLeft:
  StoreFishingSkillPosition("FirmLeft")
return

SetPosFirmRight:
  StoreFishingSkillPosition("FirmRight")
return

SetPosSlack:
  StoreFishingSkillPosition("Slack")
return

SetPosReel:
  StoreFishingSkillPosition("Reel")
return

SetPosBigReel:
  StoreFishingSkillPosition("BigReel")
return

ApplyFishingSkills:
  LoadFishingSkills(true)
  gui, Submit, NoHide
return

FindArcheageProcess:
  FindArcheageProcess(true)
return
 
StartFishing:
  WinActivate, ahk_id %ProcessID%
  IsFishing := True
return

StopFishing:
  WinActivate, ahk_id %ProcessID%
  IsFishing := False
return

TestSkillPositions:
  TestSkillPositions()
return
 
StartAntiAfk:
  StartAntiAfk()
return 
 
;Functions
;----------

FindArcheageProcess(WithConfirm)
{
	WinGet, ProcessIDs, List
	
	Loop %ProcessIDs%
	{
		CurrentID := ProcessIDs%A_Index%
		WinGetClass wt, ahk_id %CurrentID%
		IfInString, wt, ArcheAge
		{
      ProcessID := ProcessIDs%A_Index%
		}
	}
   
  if WithConfirm
  {
    DestroyGui()
    CreateGui()
    if !IsValidProcess()
    {
      msgbox, Archeage process not found!
      return
    }else
    {
      msgbox, Archeage process found!
    }
  }
}

IsValidProcess()
{
  if (ProcessID = "")
  {
    return false
  }
  return true
}

StartAntiAfk()
{
  if !IsValidProcess()
  {
    msgbox, Archeage process not found!
    return
  }
  PopUpX := WindowX
  PopUpY := WindowY + 230
  run, *RunAs AntiAfk.ahk %ProcessID% %PopUpX% %PopUpY% 
}

StoreFishingSkillPosition(FishingSkill)
{
  if !IsValidProcess()
  {
    msgbox, Archeage process not found!
    return
  }
  PopUpX := WindowX
  PopUpY := WindowY + 230
  run, *RunAs SkillPosition.ahk UserSettings.ini %FishingSkill% %ProcessID% %PopUpX% %PopUpY% 
}

LoadFishingSkills(WithConfirm)
{
  IniRead, FirmLeftX, UserSettings.ini, General, FirmLeftX
  IniRead, FirmLeftY, UserSettings.ini, General, FirmLeftY
  IniRead, FirmRightX, UserSettings.ini, General, FirmRightX
  IniRead, FirmRightY, UserSettings.ini, General, FirmRightY
  IniRead, SlackX, UserSettings.ini, General, SlackX
  IniRead, SlackY, UserSettings.ini, General, SlackY
  IniRead, ReelX, UserSettings.ini, General, ReelX
  IniRead, ReelY, UserSettings.ini, General, ReelY
  IniRead, BigReelX, UserSettings.ini, General, BigReelX
  IniRead, BigReelY, UserSettings.ini, General, BigReelY
  
  If WithConfirm
  {
    msgbox, Fishing settings applied!
  }
}

LoadSettings()
{
  IniRead, WindowX, UserSettings.ini, General, WindowX
  IniRead, WindowY, UserSettings.ini, General, WindowY
}

TestSkillPositions()
{
  WinActivate, ahk_id %ProcessID%
  
  MouseMove, FirmLeftX, FirmLeftY
  Sleep 1000
  MouseMove, FirmRightX, FirmRightY
  Sleep 1000
  MouseMove, SlackX, SlackY
  Sleep 1000
  MouseMove, ReelX, ReelY
  Sleep 1000
  MouseMove, BigReelX, BigReelY
}

RngSleep()
{
  Random,Rng, 150, 300
  Sleep, %Rng%
}