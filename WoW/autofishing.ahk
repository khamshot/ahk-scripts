; WoW AutoFishing - Fishing Line Lowest-Pixel Detection
; Cast -> find lowest pixel of line color -> baseline
; Fish bites -> line dips -> lowest pixel drops -> click
; Run as Admin!

#NoEnv
#SingleInstance Force
SetBatchLines, -1
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
SendMode Input
SetMouseDelay, 10

; === CONFIGURATION ===
FishingKey    := "1"       ; Your fishing keybind
CastDelay     := 2500      ; ms after casting before scanning
MaxWaitTime   := 30000     ; ms to wait for a bite
DipThreshold  := 5        ; px the lowest pixel must drop to count as a bite
LineColor     := 0x4A8FFF  ; bright blue fishing line - use F7 to recapture if off
LineVariation := 25        ; color tolerance
ScanWidth     := 600       ; horizontal scan area (centered)
ScanHeight    := 400       ; vertical scan area (centered, offset up)
ScanOffsetY   := -315      ; shift scan area upward

global Fishing := false
global LineX := 0

ShowInfoScreen()
return

; === HOTKEYS ===
F5::StartFishing()         ; Start
F6::StopFishing()          ; Stop
F7::CaptureLineColor()     ; Hover over fishing line, press F7
F8::ShowScanArea()         ; Flash scan rectangle on screen

ShowInfoScreen() {
    Gui, Info:New, +AlwaysOnTop -Resize +Owner
    Gui, Info:Color, 1a1a2e
    Gui, Info:Font, s13 bold cFFFFFF, Segoe UI
    Gui, Info:Add, Text, x20 y15 w460, WoW AutoFisher - Einrichtung
    Gui, Info:Font, s9 norm cAAAAAA, Segoe UI
    Gui, Info:Add, Text, x20 y40 w460, Bitte vor dem Start alles korrekt einrichten.

    Gui, Info:Font, s10 bold cFFD700, Segoe UI
    Gui, Info:Add, Text, x20 y70 w460, KAMERA  ^  CHARAKTER
    Gui, Info:Font, s9 norm cCCCCCC, Segoe UI
    Gui, Info:Add, Text, x20 y90 w460, - Ego-Perspektive aktivieren (Mausrad rein scrollen)
    Gui, Info:Add, Text, x20 y108 w460, - Kamera so ausrichten dass der Schwimmer im oberen Drittel landet
    Gui, Info:Add, Text, x20 y126 w460, - F8 druecken um den Scan-Bereich anzuzeigen und pruefen ob Schwimmer drin landet

    Gui, Info:Font, s10 bold cFFD700, Segoe UI
    Gui, Info:Add, Text, x20 y156 w460, TASTENBELEGUNG
    Gui, Info:Font, s9 norm cCCCCCC, Segoe UI
    Gui, Info:Add, Text, x20 y176 w460, - Angel-Faehigkeit auf Taste 1 legen (oder FishingKey im Skript aendern)
    Gui, Info:Add, Text, x20 y194 w460, - Keine andere Faehigkeit darf auf Taste 1 liegen

    Gui, Info:Font, s10 bold cFFD700, Segoe UI
    Gui, Info:Add, Text, x20 y224 w460, ANGELSCHNUR-FARBE
    Gui, Info:Font, s9 norm cCCCCCC, Segoe UI
    Gui, Info:Add, Text, x20 y244 w460, - Angel auswerfen, dann F7 druecken solange die Schnur sichtbar ist
    Gui, Info:Add, Text, x20 y262 w460, - Ein Fenster oeffnet sich - einfach auf die Schnur klicken
    Gui, Info:Add, Text, x20 y280 w460, - Mausposition spielt keine Rolle

    Gui, Info:Font, s10 bold cFFD700, Segoe UI
    Gui, Info:Add, Text, x20 y310 w460, HOTKEYS
    Gui, Info:Font, s9 norm cCCCCCC, Segoe UI
    Gui, Info:Add, Text, x20 y330 w460, F5  -  Angeln starten
    Gui, Info:Add, Text, x20 y348 w460, F6  -  Angeln stoppen
    Gui, Info:Add, Text, x20 y366 w460, F7  -  Schnurfarbe per KI erfassen (Schnur muss im Scan-Bereich sichtbar sein)
    Gui, Info:Add, Text, x20 y384 w460, F8  -  Scan-Bereich kurz anzeigen

    Gui, Info:Font, s9 norm c888888, Segoe UI
    Gui, Info:Add, Text, x20 y414 w460, Skript als Administrator ausfuehren fuer beste Ergebnisse.

    Gui, Info:Font, s10 bold cFFFFFF, Segoe UI
    Gui, Info:Add, Button, x175 y440 w150 h30 gCloseInfoScreen, Verstanden
    Gui, Info:Show, w500 h490, WoW AutoFisher
}

CloseInfoScreen:
    Gui, Info:Destroy
return

StartFishing() {
    global Fishing
    Fishing := true
    ToolTip, AutoFishing ON - F6 to stop
    SetTimer, RemoveTooltip, -2000
    FishingLoop()
}

StopFishing() {
    global Fishing
    Fishing := false
    ToolTip, AutoFishing OFF
    SetTimer, RemoveTooltip, -2000
}

CaptureLineColor() {
    global LineColor, ScanWidth, ScanHeight, ScanOffsetY

    ; Calculate scan area bounds (same region used during fishing)
    SysGet, screenW, 0
    SysGet, screenH, 1
    cx := screenW // 2
    cy := screenH // 2 + ScanOffsetY
    x1 := cx - (ScanWidth // 2)
    y1 := cy - (ScanHeight // 2)

    ToolTip, Scan-Bereich wird aufgenommen... klick auf die Schnur im Fenster

    ; Run Python helper - screenshots the scan area and asks Claude vision to find the line
    scriptDir  := A_ScriptDir
    tempFile   := A_Temp . "\ahk_linecolor.txt"
    RunWait, %comspec% /c python "%scriptDir%\find_line_color.py" %x1% %y1% %ScanWidth% %ScanHeight% > "%tempFile%" 2>&1, , Hide

    FileRead, output, %tempFile%
    output := Trim(output)

    ; Expect #RRGGBB back from the script
    if (RegExMatch(output, "i)^#?([0-9A-F]{6})$", m)) {
        hexVal    := "0x" . m1
        LineColor := hexVal
        ToolTip, Farbe gesetzt: %hexVal%
        SetTimer, RemoveTooltip, -3000
        ShowColorPreview(LineColor)
    } else {
        ToolTip, KI-Analyse fehlgeschlagen: %output%
        SetTimer, RemoveTooltip, -6000
    }
}

ShowColorPreview(color) {
    ; Format hex string for display
    hexStr := Format("0x{:06X}", color)

    ; Extract RGB for the swatch background
    r := (color >> 16) & 0xFF
    g := (color >> 8)  & 0xFF
    b :=  color        & 0xFF
    swatchColor := Format("{:02X}{:02X}{:02X}", r, g, b)

    Gui, ColorPreview:Destroy
    Gui, ColorPreview:New, +AlwaysOnTop -Resize +Owner
    Gui, ColorPreview:Color, 1a1a2e
    Gui, ColorPreview:Font, s11 bold cFFFFFF, Segoe UI
    Gui, ColorPreview:Add, Text, x20 y15 w260, Farbe erfasst - stimmt das?
    Gui, ColorPreview:Font, s9 norm cAAAAAA, Segoe UI
    Gui, ColorPreview:Add, Text, x20 y38 w260, Erkannte Farbe:
    Gui, ColorPreview:Font, s10 bold cFFFFFF, Segoe UI
    Gui, ColorPreview:Add, Text, x20 y55 w260, %hexStr%

    ; Color swatch
    Gui, ColorPreview:Add, Progress, x20 y80 w260 h40 Background%swatchColor% -Smooth, 0

    Gui, ColorPreview:Font, s9 norm c888888, Segoe UI
    Gui, ColorPreview:Add, Text, x20 y130 w260, Passt nicht? F7 nochmal und andere Stelle anklicken.
    Gui, ColorPreview:Font, s10 bold cFFFFFF, Segoe UI
    Gui, ColorPreview:Add, Button, x75 y160 w150 h28 gCloseColorPreview, OK, passt!
    Gui, ColorPreview:Show, w300 h205, Schnurfarbe
}

CloseColorPreview:
    Gui, ColorPreview:Destroy
return

RemoveTooltip:
    ToolTip
return

; Flash the scan area as a blue rectangle for 2 seconds
ShowScanArea() {
    global ScanWidth, ScanHeight, ScanOffsetY

    SysGet, screenW, 0
    SysGet, screenH, 1
    cx := screenW // 2
    cy := screenH // 2 + ScanOffsetY

    x1 := cx - (ScanWidth // 2)
    y1 := cy - (ScanHeight // 2)
    x2 := cx + (ScanWidth // 2)
    y2 := cy + (ScanHeight // 2)

    w  := x2 - x1
    h  := y2 - y1
    t  := 3  ; border thickness

    ; 4 thin GUIs forming a rectangle border
    _ScanRect("Top",    x1,      y1,      w, t)
    _ScanRect("Bottom", x1,      y2 - t,  w, t)
    _ScanRect("Left",   x1,      y1,      t, h)
    _ScanRect("Right",  x2 - t,  y1,      t, h)

    SetTimer, HideScanRect, -2000
}

_ScanRect(name, x, y, w, h) {
    Gui, ScanRect%name%:New, +AlwaysOnTop -Caption +ToolWindow +E0x20
    Gui, ScanRect%name%:Color, 0055FF
    Gui, ScanRect%name%:Show, x%x% y%y% w%w% h%h% NA
}

HideScanRect:
    Gui, ScanRectTop:Destroy
    Gui, ScanRectBottom:Destroy
    Gui, ScanRectLeft:Destroy
    Gui, ScanRectRight:Destroy
return

; Full scan - used once after cast to establish baseline.
; Returns the Y of the lowest matching pixel. Sets global LineX to its X.
; Returns -1 if no match found.
FindLowestLinePixel() {
    global LineColor, LineVariation, ScanWidth, ScanHeight, ScanOffsetY, LineX

    SysGet, screenW, 0
    SysGet, screenH, 1
    cx := screenW // 2
    cy := screenH // 2 + ScanOffsetY

    x1 := cx - (ScanWidth // 2)
    y1 := cy - (ScanHeight // 2)
    x2 := cx + (ScanWidth // 2)
    y2 := cy + (ScanHeight // 2)

    lastX := -1
    lastY := -1
    fromY := y1

    Loop {
        PixelSearch, foundX, foundY, %x1%, %fromY%, %x2%, %y2%, %LineColor%, %LineVariation%, Fast RGB
        if (ErrorLevel != 0)
            break
        lastX := foundX
        lastY := foundY
        fromY := foundY + 1
        if (fromY > y2)
            break
    }

    LineX := lastX
    return lastY
}

; Fast scan - only checks a narrow band around the known baseline.
; Much faster than full scan, used during the bite detection loop.
; bandTop/bandBot are absolute Y coords to search between.
; Returns lowest Y found in that band, or -1.
FindLowestInBand(bandTop, bandBot) {
    global LineColor, LineVariation, ScanWidth, ScanOffsetY, LineX

    SysGet, screenW, 0
    cx := screenW // 2
    x1 := cx - (ScanWidth // 2)
    x2 := cx + (ScanWidth // 2)

    lastX := -1
    lastY := -1
    fromY := bandTop

    Loop {
        PixelSearch, foundX, foundY, %x1%, %fromY%, %x2%, %bandBot%, %LineColor%, %LineVariation%, Fast RGB
        if (ErrorLevel != 0)
            break
        lastX := foundX
        lastY := foundY
        fromY := foundY + 1
        if (fromY > bandBot)
            break
    }

    if (lastX != -1)
        LineX := lastX
    return lastY
}

FishingLoop() {
    global Fishing, FishingKey, CastDelay, MaxWaitTime, DipThreshold

    while (Fishing) {
        ; Cast
        Send, %FishingKey%
        Sleep, %CastDelay%

        if (!Fishing)
            return

        ; Establish baseline - find where the line ends after cast settles
        baseline := FindLowestLinePixel()
        if (baseline = -1) {
            ToolTip, Line not found - check color/position (F7 to recapture)
            SetTimer, RemoveTooltip, -3000
            Sleep, 500
            continue
        }

        baselineX := LineX   ; save bobber X at rest for clicking later
        tipX := LineX + 20
        ToolTip, Line found at Y:%baseline% - waiting for bite..., %tipX%, %baseline%

        ; Poll for dip - scan only a narrow band: 15px above to 40px below baseline
        startTime := A_TickCount
        caught := false

        while (Fishing && (A_TickCount - startTime < MaxWaitTime)) {
            currentY := FindLowestInBand(baseline - 15, baseline + 40)
            tipX := LineX + 20

            if (currentY = -1) {
                ToolTip, Line lost - recasting
                SetTimer, RemoveTooltip, -1500
                break
            }

            dip := currentY - baseline
            ToolTip, Y:%currentY%  Base:%baseline%  Dip:%dip%, %tipX%, %currentY%

            if (dip >= DipThreshold) {
                ToolTip, BITE! Dip:%dip%px, %tipX%, %currentY%
                ClickAt(baselineX, baseline)
                caught := true
                Sleep, 300
                break
            }

            ; Slowly drift baseline toward current position to track natural bobbing
            baseline := baseline + (currentY - baseline) * 0.08

            Sleep, 20
        }

        if (!caught && Fishing) {
            ToolTip, Timeout - recasting
            SetTimer, RemoveTooltip, -1000
        }

        Sleep, 400 + RandomDelay()
    }
}

; Click at the baseline bobber position, then move mouse below scan area
ClickAt(targetX, targetY) {
    DllCall("SetCursorPos", "int", targetX, "int", targetY)
    Sleep, 80

    Send, {Shift down}
    Sleep, 30
    DllCall("mouse_event", "UInt", 0x0008)  ; Right down
    Sleep, 50
    DllCall("mouse_event", "UInt", 0x0010)  ; Right up
    Sleep, 50
    Send, {Shift up}

    ; Move mouse below scan area so it doesn't block next cast detection
    global ScanHeight, ScanOffsetY
    SysGet, screenW, 0
    SysGet, screenH, 1
    parkY := (screenH // 2) + ScanOffsetY + (ScanHeight // 2) + 60
    parkX := screenW // 2
    DllCall("SetCursorPos", "int", parkX, "int", parkY)
    ToolTip
}

RandomDelay() {
    Random, delay, 50, 200
    return delay
}
