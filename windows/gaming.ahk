#Requires AutoHotkey v2.0

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
        return false
    }
}

; Function to check if swaps should be active (considering both target exe and manual toggle)
ShouldSwapKeys() {
    return manualToggle && IsTargetExeActive(targetExes)
}

ShouldSwapKeysForQWERTY() {
    return manualToggle && IsTargetExeActive(targetQWERTYExes)
}

; Hotkey definitions
#HotIf ShouldSwapKeys()
    Backspace::Space
    Delete::Enter
#HotIf

#HotIf ShouldSwapKeysForQWERTY()
    ; Basic function keys
    Backspace::Space
    Delete::Enter
    
    ; Letter and punctuation remapping
    SC027::t  ; semicolon to t
    ,::z      ; comma to z
    .::x      ; dot to x
    p::c      ; p to c
    y::v      ; y to v
    a::LShift ; a to left shift
    o::a      ; o to a
    e::w      ; e to w
    u::d      ; u to d
    i::f      ; i to f
    LShift::m ; left shift to m
    j::s      ; j to s
    k::e      ; k to e
    x::r      ; x to r
    Left::g   ; left arrow to g
    Right::b  ; right arrow to b
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

; Optional: Add a hotkey to reload the script (Ctrl+Alt+R)
^!r::Reload()
