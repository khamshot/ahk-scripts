; !=Alt, ^=Ctrl and +=Shift
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

;Globals

global ProcessID, WindowX := 300, WindowY := 300, IsFishing := false, FirmLeftX, FirmLeftY, FirmRightX, FirmRightY, SlackX, SlackY, ReelX, ReelY, BigReelX, BigReelY

;Init
;----------

LoadFishingSkills(false)
LoadWindowPosition()
FindArcheageProcess(false)

Loop
{
  RngSleep()
  If IsFishing
  {
    MinX := FirmLeftX-3
    MaxX := FirmLeftX+3
    MinY := FirmLeftY-3
    MaxY := FirmLeftY+3
    PixelSearch, X, Y, %MinX%, %MinY%, %MaxX%, %MaxY%, 0xf9994a , 20, Fast RGB
    if !Errorlevel
    {
      send,1
      SkillHoldSleep()
    }
    
    MinX := FirmRightX-3
    MaxX := FirmRightX+3
    MinY := FirmRightY-3
    MaxY := FirmRightY+3
    PixelSearch, X, Y, %MinX%, %MinY%, %MaxX%, %MaxY%, 0xf9994a , 20, Fast RGB
    if !Errorlevel
    {
      send,2
      SkillHoldSleep()
    }
    
    MinX := SlackX-3
    MaxX := SlackX+3
    MinY := SlackY-3
    MaxY := SlackY+3
    PixelSearch, X, Y, %MinX%, %MinY%, %MaxX%, %MaxY%, 0xf9994a , 20, Fast RGB
    if !Errorlevel
    {
      send,3
      SkillHoldSleep()
    }
    
    MinX := ReelX-3
    MaxX := ReelX+3
    MinY := ReelY-3
    MaxY := ReelY+3
    PixelSearch, X, Y, %MinX%, %MinY%, %MaxX%, %MaxY%, 0xf9994a , 20, Fast RGB
    if !Errorlevel
    {
      send,4
      SkillHoldSleep()
    }
    
    MinX := BigReelX-3
    MaxX := BigReelX+3
    MinY := BigReelY-3
    MaxY := BigReelY+3
    PixelSearch, X, Y, %MinX%, %MinY%, %MaxX%, %MaxY%, 0xf9994a , 20, Fast RGB
    if !Errorlevel
    {
      send,5
      SkillHoldSleep()
    }
    
  }else
  {
    sleep, 10000
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

  gui, Add, Picture, x20 y10 w30 h30 gSetPosFirmLeft, Firmleft.png
  gui, Add, Picture, x60 y10 w30 h30 gSetPosFirmRight, Firmright.png
  gui, Add, Picture, x100 y10 w30 h30 gSetPosSlack, Slack.png
  gui, Add, Picture, x140 y10 w30 h30 gSetPosReel, Reel.png
  gui, Add, Picture, x180 y10 w30 h30 gSetPosBigreel, BigReel.png
  
  gui, Add, Button, x20 y50 w190 h20 gLoadFishingSkills, Apply Fishing Skill Positions
  
  gui, Add, Button, x20 y80 w190 h20 gFindArcheageProcess, Find Archeage Process
  
  gui, Add, Text, x20 y110, Archeage Process ID:
  gui, Add, Text, x135 y110, %ProcessID%
  
  gui, Add, Button, x20 y140 w80 h20 gStartFishing, Start Fishing
  gui, Add, Button, x130 y140 w80 h20 gStopFishing, Stop Fishing
  
  gui, Add, Button, x20 y170 w190 h20 gTestSkillPositions, Test Skill Positions
  
  gui, Show, x%WindowX% y%WindowY% w230 h200, ArchCenter
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

gLoadFishingSkills:
  LoadFishingSkills(true)
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

StoreFishingSkillPosition(FishingSkill)
{
  if !IsValidProcess()
  {
    msgbox, Archeage process not found!
    return
  }
  PopUpX := WindowX
  PopUpY := WindowY + 200
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
    msgbox, Fishing skill positions applied!
  }
}

LoadWindowPosition()
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

SkillHoldSleep()
{
  Sleep, 5000
}