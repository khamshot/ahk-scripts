; WoW Classic TBC AutoFishing - Sound + Pixel Tracking
; Sound detectiert den Splash, Pixel findet den Bobber
; Run as Admin!

#NoEnv
#SingleInstance Force
SetBatchLines, -1
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
SendMode Input
SetMouseDelay, 10

; === CONFIGURATION ===
FishingKey := "1"              ; Your fishing keybind
CastDelay := 2500              ; Delay after casting (ms)
MaxWaitTime := 30000           ; Max wait for bite (ms)
SoundThreshold := 3            ; Audio spike threshold (0-100)

; Bobber detection settings
BobberColor := 0x49313B        ; Red feather color (adjust if needed)
BobberColor2 := 0x49313B       ; Alternate red
ColorVariation := 25           ; Color tolerance
ScanWidth := 500               ; Scan area width
ScanHeight := 350              ; Scan area height

; === HOTKEYS ===
F5::StartFishing()             ; Start
F6::StopFishing()              ; Stop
F7::CaptureBobberColor()       ; Capture color under mouse

global Fishing := false
global BobberX := 0
global BobberY := 0


StartFishing() {
    global Fishing
    Fishing := true
    ToolTip, AutoFishing AN - F6 zum Stoppen
    SetTimer, RemoveTooltip, -2000
    FishingLoop()
}

StopFishing() {
    global Fishing
    Fishing := false
    ToolTip, AutoFishing AUS
    SetTimer, RemoveTooltip, -2000
}

CaptureBobberColor() {
    MouseGetPos, mx, my
    PixelGetColor, color, %mx%, %my%, RGB
    Clipboard := color
    ToolTip, Farbe kopiert: %color%`nIn Script bei BobberColor eintragen!
    SetTimer, RemoveTooltip, -3000
}

RemoveTooltip:
    ToolTip
return

FishingLoop() {
    global Fishing, FishingKey, CastDelay

    while (Fishing) {
        ; Cast fishing line
        Send, %FishingKey%
        Sleep, %CastDelay%

        if (!Fishing)
            return

        ; Find the bobber position
        if (FindBobber()) {
            ; Wait for splash sound
            if (WaitForSplash()) {
                ClickBobber()
            }
        } else {
            ToolTip, Bobber nicht gefunden! Kamera anpassen.
            SetTimer, RemoveTooltip, -2000
        }

        ; Delay before next cast
        Sleep, 400 + RandomDelay()
    }
}

FindBobber() {
    global BobberColor, BobberColor2, ColorVariation, ScanWidth, ScanHeight
    global BobberX, BobberY

    ; Get center of screen for scan area
    SysGet, screenW, 0
    SysGet, screenH, 1
    centerX := screenW // 2
    centerY := screenH // 2

    ; Define search area (upper-center of screen where bobber usually lands)
    x1 := centerX - (ScanWidth // 2)
    y1 := centerY - (ScanHeight // 2) - 100  ; Offset up a bit
    x2 := centerX + (ScanWidth // 2)
    y2 := centerY + (ScanHeight // 2) - 100

    ; Search for bobber's red feather
    PixelSearch, foundX, foundY, %x1%, %y1%, %x2%, %y2%, %BobberColor%, %ColorVariation%, Fast RGB
    if (ErrorLevel = 0) {
        BobberX := foundX
        BobberY := foundY
        return true
    }

    ; Try alternate color
    PixelSearch, foundX, foundY, %x1%, %y1%, %x2%, %y2%, %BobberColor2%, %ColorVariation%, Fast RGB
    if (ErrorLevel = 0) {
        BobberX := foundX
        BobberY := foundY
        return true
    }

    return false
}

WaitForSplash() {
    global Fishing, MaxWaitTime
    global BobberX, BobberY, BobberColor, ColorVariation

    startTime := A_TickCount
    searchRadius := 50
    baselineY := BobberY          ; Ausgangsposition merken
    dipThreshold := 4            ; Pixel die der Bobber nach unten springen muss
    dipCount := 0
    requiredDips := 1             ; 2x erkannt = Biss

    ; Ignore first second (casting animation)
    Sleep, 1000

    while (Fishing && (A_TickCount - startTime < MaxWaitTime)) {
        ; Search for bobber in larger area
        x1 := BobberX - searchRadius
        y1 := BobberY - searchRadius
        x2 := BobberX + searchRadius
        y2 := BobberY + searchRadius

        PixelSearch, foundX, foundY, %x1%, %y1%, %x2%, %y2%, %BobberColor%, %ColorVariation%, Fast RGB

        if (ErrorLevel = 0) {
            ; Calculate how much bobber moved down from baseline
            dipAmount := foundY - baselineY

            ; Tooltip direkt rechts neben dem Bobber
            tipX := foundX + 40
            tipY := foundY
            ToolTip, ← BOBBER | Y:%foundY% Base:%baselineY% Dip:%dipAmount%, %tipX%, %tipY%

            if (dipAmount > dipThreshold) {
                dipCount++
                ToolTip, ← BISS! Dip:%dipAmount%px (%dipCount%/%requiredDips%), %tipX%, %tipY%

                if (dipCount >= requiredDips) {
                    BobberX := foundX
                    BobberY := foundY
                    ToolTip
                    return true
                }
            } else {
                baselineY := baselineY + (foundY - baselineY) * 0.1
                dipCount := 0
            }

            BobberX := foundX
            BobberY := foundY
        } else {
            ; Bobber nicht gefunden
            ToolTip, BOBBER VERLOREN!, %BobberX%, %BobberY%
        }

        Sleep, 50
    }
    ToolTip
    return false
}

UpdateBobberPosition() {
    global BobberColor, ColorVariation, BobberX, BobberY

    ; Search in small area around last known position
    searchRadius := 40
    x1 := BobberX - searchRadius
    y1 := BobberY - searchRadius
    x2 := BobberX + searchRadius
    y2 := BobberY + searchRadius

    PixelSearch, foundX, foundY, %x1%, %y1%, %x2%, %y2%, %BobberColor%, %ColorVariation%, Fast RGB
    if (ErrorLevel = 0) {
        BobberX := foundX
        BobberY := foundY
    }
}

ClickBobber() {
    global BobberX, BobberY

    ; Hardware-level mouse move
    DllCall("SetCursorPos", "int", BobberX, "int", BobberY)
    Sleep, 100

    ; Shift runter
    Send, {Shift down}
    Sleep, 30

    ; Hardware-level right click
    DllCall("mouse_event", "UInt", 0x0008)  ; Right down
    Sleep, 50
    DllCall("mouse_event", "UInt", 0x0010)  ; Right up

    Sleep, 50
    ; Shift hoch
    Send, {Shift up}
    Sleep, 100
}

GetSystemVolumePeak() {
    try {
        static mmde := ComObjCreate("{BCDE0395-E52F-467C-8E3D-C4579291692E}", "{A95664D2-9614-4F35-A746-DE8DB63617E6}")

        DllCall(NumGet(NumGet(mmde+0)+16), "Ptr", mmde, "UInt", 0, "UInt", 1, "Ptr*", dev)
        DllCall(NumGet(NumGet(dev+0)+12), "Ptr", dev, "Ptr", GUID(IID,"{C02216F6-8C67-4B5B-9D00-D008E73E0064}"), "UInt", 23, "Ptr", 0, "Ptr*", meter)
        DllCall(NumGet(NumGet(meter+0)+12), "Ptr", meter, "Float*", peak)

        ObjRelease(meter)
        ObjRelease(dev)

        return Round(peak * 100)
    } catch {
        return 0
    }
}

GUID(ByRef GUID, sGUID) {
    VarSetCapacity(GUID, 16)
    return DllCall("ole32\CLSIDFromString", "WStr", sGUID, "Ptr", &GUID) >= 0 ? &GUID : ""
}

RandomDelay() {
    Random, delay, 50, 200
    return delay
}
