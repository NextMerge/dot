#Requires AutoHotkey v2.0
SendMode("Event")

; List of executable names (without .exe extension) where the key swaps should be active
global targetExes := ["notepad"
    ,"TOTClient" ;The Outlast Trials
    ,"Yakisoba" ;Starship Troopers Extermination
    ,"Lethal Company"
    ,"DeadByDaylight"
    ,"notepad"]

global targetQWERTYExes := ["RobloxPlayer"
    ,"RobloxPlayerBeta"]

global exeAppendices := ["-Win64-Shipping", "-WinGDK-Shipping"]

; Global variable to store the manual toggle state
global manualToggle := true

global forceQWERTY := false

; Function to check if the active window belongs to one of the target executables
IsTargetExeActive(exesToCheck) {
    try {
        activeExe := WinGetProcessName("A")
        SplitPath(activeExe, , , , &activeExeNameNoExt)
        for exe in exesToCheck {
            if (activeExeNameNoExt = exe) {
                return true
            }

            for appendix in exeAppendices {
                if (activeExeNameNoExt = exe . appendix) {
                    return true
                }
            }
        }
        return false
    } catch {
        ; Force hotkey reevaluation
        Suspend(true)
        Suspend(false)
        ToolTip("Error getting active window - reevaluating hotkeys")
        SetTimer(() => ToolTip(), -1000)
        return false
    }
}

; Function to check if swaps should be active (considering both target exe and manual toggle)
ShouldSwapKeys() {
    return manualToggle && IsTargetExeActive(targetExes)
}

ShouldSwapKeysForQWERTY() {
    return forceQWERTY || (manualToggle && IsTargetExeActive(targetQWERTYExes))
}

; Hotkey definitions
#HotIf ShouldSwapKeys()
    Backspace::Space
    Delete::Enter
#HotIf

#HotIf ShouldSwapKeysForQWERTY()
    Backspace::Space
    Delete::Enter
    
    SC027::t
    *o::a
    *e::w
    *u::d
    *j::s
    *i::f
    *,::z
    *.::x
    *p::c
    *y::v
    *a::LShift
    *LShift::m
    *k::e
    *x::r
    *Left::g
    *Right::b
#HotIf

; Toggle hotkey (Ctrl+Alt+T)
^!t:: {
    global manualToggle
    manualToggle := !manualToggle
    if (manualToggle) {
        ToolTip("Key swaps enabled")
    } else {
        ToolTip("Key swaps disabled")
    }
    SetTimer(() => ToolTip(), -1000)
}

; Toggle forcing QWERTY (Ctrl+Alt+Q)
^!q:: {
    global forceQWERTY
    forceQWERTY := !forceQWERTY
    ToolTip("QWERTY mode: " . (forceQWERTY ? "ON" : "OFF"))
    SetTimer(() => ToolTip(), -1000)
}

; Add a hotkey to reload the script (Ctrl+Alt+R)
^!r::Reload()
