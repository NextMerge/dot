#Requires AutoHotkey v2.0
SendMode("Event")

; List of executable names (without .exe extension) where the key swaps should be active
global targetExes := ["notepad"
    ,"TOTClient" ;The Outlast Trials
    ,"Yakisoba" ;Starship Troopers Extermination
    ,"Lethal Company"
    ,"DeadByDaylight"
    ,"ProjectBorealis"
    ,"Subterranauts"
    ,"NuclearNightmare"
    ,"left4dead"
    ,"notepad"]

global targetQWERTYExes := ["RobloxPlayer"
    ,"RobloxPlayerBeta"]

global exeAppendices := ["-Win64-Shipping", "-WinGDK-Shipping"]

global disableGlobal := true
global forceGaming := false
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
        return false
    }
}

; Function to check if swaps should be active (considering both target exe and manual toggle)
ShouldSwapKeys() {
    return forceGaming || (disableGlobal && IsTargetExeActive(targetExes))
}

ShouldSwapKeysForQWERTY() {
    return forceQWERTY || (disableGlobal && IsTargetExeActive(targetQWERTYExes))
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
^!t::ToggleKeySwaps()
ToggleKeySwaps() {
    global disableGlobal
    disableGlobal := !disableGlobal
    if (disableGlobal) {
        ToolTip("Key swaps enabled")
    } else {
        ToolTip("Key swaps disabled")
    }
    SetTimer(() => ToolTip(), -1000)
}

; Toggle forcing gaming (Ctrl+Alt+F)
^!f::ToggleGaming()
ToggleGaming() {
    global forceGaming
    forceGaming := !forceGaming
    ToolTip("Gaming mode: " . (forceGaming ? "ON" : "OFF"))
    SetTimer(() => ToolTip(), -1000)
}

; Toggle forcing QWERTY (Ctrl+Alt+Q)
^!q::ToggleQWERTY()
ToggleQWERTY() {
    global forceQWERTY
    forceQWERTY := !forceQWERTY
    ToolTip("QWERTY mode: " . (forceQWERTY ? "ON" : "OFF"))
    SetTimer(() => ToolTip(), -1000)
}

; Add a hotkey to reload the script (Ctrl+Alt+R)
^!r::Reload()

; Copy current exe name to clipboard
^!c::CopyExeNameToClipboard()
CopyExeNameToClipboard() {
    try {
        activeExe := WinGetProcessName("A")
        activeExe := RegExReplace(activeExe, "\.exe$", "")
        A_Clipboard := "`n    ,`"" . activeExe . "`""
        ToolTip("Copied exe name to clipboard: " . activeExe)
        SetTimer(() => ToolTip(), -1000)
        Run("cmd.exe /c cursor `"C:\Users\markj\Desktop\fold\literally my entire gaming script.ahk`"", , "Hide")
    } catch {
        ToolTip("Error copying exe name to clipboard")
        SetTimer(() => ToolTip(), -1000)
    }
}
