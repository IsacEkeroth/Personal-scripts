#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
CoordMode, Mouse, Client
#SingleInstance, force
#Persistent
#InstallKeybdHook

Menu, Tray, NoIcon

; kill capslock
SetCapsLockState, AlwaysOff
SetScrollLockState, off
CapsLock::Escape

; better alt f4
^!F4::
    WinGet, Active_Window, ProcessName, A
    Parsed_Active_Window := StrSplit(Active_Window, ".")
    If Not (Parsed_Active_Window[1] = "Explorer") {
        WinGet, active_id, PID, A
        run, taskkill /PID %active_id% /F,,Hide
    }
return

;allways ontop
ScrollLock:: Winset, Alwaysontop, , A

#IfWinActive ahk_exe csgo.exe
    CapsLock::CapsLock
    #IfWinActived

#IfWinActive ahk_exe Discord.exe
    SC028::ä
    SC01A::å
    SC027::ö
    +SC028::Ä
    +SC01A::Å
    +SC027::Ö
    ^SC028::SendRaw, `'`
    ^SC01A::sendRaw `[`
    ^SC027::send `;`
    ^+SC028::SendRaw `"`
    ^+SC01A::SendRaw `{`
        ^+SC027::SendRaw, `:`
    #IfWinActive