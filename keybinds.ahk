#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, Client 
#SingleInstance, force
#Persistent
Menu, Tray, NoIcon

; kill capslock
SetCapsLockState, AlwaysOff
SetScrollLockState, off

; better alt f4
^!F4::
WinGet, Active_Window, ProcessName, A
Parsed_Active_Window := StrSplit(Active_Window, ".")
If Not (Parsed_Active_Window[1] = "Explorer") {
    WinGet, active_id, PID, A
    run, taskkill /PID %active_id% /F,,Hide 
}
return

/*
#o:: ; Win+O
Sleep 1000  ; Give user a chance to release keys (in case their release would wake up the monitor again).
; Turn Monitor Off:
SendMessage, 0x0112, 0xF170, 2,, Program Manager  ; 0x0112 is WM_SYSCOMMAND, 0xF170 is SC_MONITORPOWER.
; Note for the above: Use -1 in place of 2 to turn the monitor on.
; Use 1 in place of 2 to activate the monitor's low-power mode.
return
*/

;allways ontop
ScrollLock:: Winset, Alwaysontop, , A 

;soundrestart
^f24::send, {f23}
/*
send, #d
Sleep, 500
MouseClick, Right, 3681, 1057
Sleep, 500
MouseClick, Left, 1782, -128
send, #d
Return
*/

;minecraft fix
#IfWinActive ahk_exe javaw.exe
/*
*XButton2::p
*XButton1::o
*/
