#Requires AutoHotkey v2.0
SendMode("Event") ; Without this keys sometimes get stuck in Roblox

global listOfExeNamesFileName := "game exes.txt"
global targetExes := []
global targetQWERTYExes := []

ReadExeNamesFromTxt(listOfExeNamesFileName)

global exeAppendices := ["-Win64-Shipping", "-WinGDK-Shipping"]

global disableGlobal := true
global forceGaming := false
global forceQWERTY := false

ReadExeNamesFromTxt(fileName) {
    scriptDir := A_ScriptDir
    filePath := scriptDir . "\" . fileName
    if !FileExist(filePath) {
        MsgBox("File not found: " . filePath)
        return
    }

    gettingQwertyExes := false

    for line in StrSplit(FileRead(filePath), "`n") {
        line := Trim(line)
        if (line = "") {
            continue
        }
        if InStr(line, ";") {
            if (line = ";QWERTY;") {
                gettingQwertyExes := true
                continue
            }
            line := Trim(StrSplit(line, ";")[1])
        }
        if (line != "") {
            if (gettingQwertyExes) {
                targetQWERTYExes.Push(line)
            } else {
                targetExes.Push(line)
            }
        }
    }
}

ShouldSwapKeys() {
    return (forceGaming && !forceQWERTY) || (disableGlobal && IsTargetExeActive(targetExes))
}

ShouldSwapKeysForQWERTY() {
    return forceQWERTY || (disableGlobal && IsTargetExeActive(targetQWERTYExes))
}

IsTargetExeActive(exesToCheck) {
    try {
        activeExe := WinGetProcessName("A")
        SplitPath(activeExe, , , , &activeExeNameNoExt)
        for exe in exesToCheck {
            if (StrLower(activeExeNameNoExt) = StrLower(exe)) {
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

IsMegaVPNRunning() {
    try {
        megaVPNProcessName := "MEGA VPN.exe"
        megaVPNProcessCount := 0
        for proc in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process") {
            if (proc.Name = megaVPNProcessName) {
                megaVPNProcessCount++
            }
        }

        return megaVPNProcessCount >= 2 ; 1 for the actual process, 1 for the VPN tunnel
    }

    return false
}

SetTimer(WarningOnVPNActive, 1000)

WarningOnVPNActive() {
    isTargetExe := IsTargetExeActive(targetExes)
    isTargetQWERTYExe := IsTargetExeActive(targetQWERTYExes)

    if ((isTargetExe || isTargetQWERTYExe) && IsMegaVPNRunning()) {
        ToolTip("Warning: Game launched with MEGA VPN running")
        SetTimer(() => ToolTip(), -1000)
    }
}

; Hotkey definitions
#HotIf ShouldSwapKeys()
Backspace::Space
Delete::Enter
#HotIf

#HotIf ShouldSwapKeysForQWERTY()
Backspace::Space
Delete::Enter

*SC027::t ; semicolon key
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
*SC028::m ; apostrophe key
*k::e
*x::r
*Left::g
*Right::b
#HotIf

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

ToggleQWERTY() {
    global forceQWERTY
    forceQWERTY := !forceQWERTY
    ToolTip("QWERTY mode: " . (forceQWERTY ? "ON" : "OFF"))
    SetTimer(() => ToolTip(), -1000)
}

CopyExeNameToClipboardAndOpenFile() {
    try {
        activeExe := WinGetProcessName("A")
        activeExe := RegExReplace(activeExe, "\.exe$", "")
        A_Clipboard := "`n" . activeExe
        ToolTip("Copied exe name to clipboard: " . activeExe)
        SetTimer(() => ToolTip(), -1000)
        Run("notepad.exe " . A_ScriptDir . "\" . listOfExeNamesFileName)
    } catch {
        ToolTip("Error copying exe name to clipboard")
        SetTimer(() => ToolTip(), -1000)
    }
}

CheckVpnStatus() {
    if (IsMegaVpnRunning()) {
        ToolTip("MEGA VPN Tunnel is running")
    } else {
        ToolTip("MEGA VPN Tunnel is NOT running")
    }
    SetTimer(() => ToolTip(), -1000)
}

ShowTextMacroInput() {
    textToType := NormalizeText(A_Clipboard)
    if (textToType = "") {
        return
    }

    SetTimer(TypeText.Bind(textToType), -1000)
}

NormalizeText(text) {
    text := RegExReplace(text, "\n", " ")
    text := RegExReplace(text, "\r", " ")
    text := RegExReplace(text, "\t", " ")
    text := RegExReplace(text, "\s+", " ")
    text := RegExReplace(text, "!", "")
    return text
}

TypeText(text) {
    ToolTip()
    Send(text)
}

OpenDiscord() {
    if WinExist("ahk_exe discord.exe") {
        WinActivate("ahk_exe discord.exe")
    } else {
        Run("C:\Users\markj\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Discord Inc\Discord.lnk")
        WinWait("ahk_exe discord.exe")
    }
}

^+!g:: ToggleKeySwaps()
^+!q:: ToggleQWERTY()
^+!r:: Reload()
^+!y:: CopyExeNameToClipboardAndOpenFile()
^+!v:: CheckVpnStatus()
^+!i:: ShowTextMacroInput()

; ^+!h:: OpenVivaldi()
; ^+!t:: OpenDiscord()
; ^+!n:: OpenAppleMusic()
; #i:: Rizz() win+i

