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


; Caps to escape
noCapsLockGroup := ["csgo.exe", "cs2.exe", "overwatch.exe", "payday2_win32_release.exe", "Borderlands2.exe", "hl2.exe", "Discovery.exe", "r5apex.exe"]

IsItemInList(item, list){
    for _index, value in list
        if (value = item) {
            Return 1
        }
    Return 0
}


; Itterate through sound outputs
n = 1

; http://www.daveamenta.com/2011-05/programmatically-or-command-line-change-the-default-sound-playback-device-in-windows-7/
Devices := {}
IMMDeviceEnumerator := ComObjCreate("{BCDE0395-E52F-467C-8E3D-C4579291692E}", "{A95664D2-9614-4F35-A746-DE8DB63617E6}")

; IMMDeviceEnumerator::EnumAudioEndpoints
; eRender = 0, eCapture, eAll
; 0x1 = DEVICE_STATE_ACTIVE
DllCall(NumGet(NumGet(IMMDeviceEnumerator+0)+3*A_PtrSize), "UPtr", IMMDeviceEnumerator, "UInt", 0, "UInt", 0x1, "UPtrP", IMMDeviceCollection, "UInt")
ObjRelease(IMMDeviceEnumerator)

; IMMDeviceCollection::GetCount
DllCall(NumGet(NumGet(IMMDeviceCollection+0)+3*A_PtrSize), "UPtr", IMMDeviceCollection, "UIntP", Count, "UInt")
Loop % (Count)
{
    ; IMMDeviceCollection::Item
    DllCall(NumGet(NumGet(IMMDeviceCollection+0)+4*A_PtrSize), "UPtr", IMMDeviceCollection, "UInt", A_Index-1, "UPtrP", IMMDevice, "UInt")

    ; IMMDevice::GetId
    DllCall(NumGet(NumGet(IMMDevice+0)+5*A_PtrSize), "UPtr", IMMDevice, "UPtrP", pBuffer, "UInt")
    DeviceID := StrGet(pBuffer, "UTF-16"), DllCall("Ole32.dll\CoTaskMemFree", "UPtr", pBuffer)

    ; IMMDevice::OpenPropertyStore
    ; 0x0 = STGM_READ
    DllCall(NumGet(NumGet(IMMDevice+0)+4*A_PtrSize), "UPtr", IMMDevice, "UInt", 0x0, "UPtrP", IPropertyStore, "UInt")
    ObjRelease(IMMDevice)

    ; IPropertyStore::GetValue
    VarSetCapacity(PROPVARIANT, A_PtrSize == 4 ? 16 : 24)
    VarSetCapacity(PROPERTYKEY, 20)
    DllCall("Ole32.dll\CLSIDFromString", "Str", "{A45C254E-DF1C-4EFD-8020-67D146A850E0}", "UPtr", &PROPERTYKEY)
    NumPut(14, &PROPERTYKEY + 16, "UInt")
    DllCall(NumGet(NumGet(IPropertyStore+0)+5*A_PtrSize), "UPtr", IPropertyStore, "UPtr", &PROPERTYKEY, "UPtr", &PROPVARIANT, "UInt")
    DeviceName := StrGet(NumGet(&PROPVARIANT + 8), "UTF-16")    ; LPWSTR PROPVARIANT.pwszVal
    DllCall("Ole32.dll\CoTaskMemFree", "UPtr", NumGet(&PROPVARIANT + 8))    ; LPWSTR PROPVARIANT.pwszVal
    ObjRelease(IPropertyStore)

    ObjRawSet(Devices, DeviceName, DeviceID)
}
ObjRelease(IMMDeviceCollection)

return



; Itterate through sound outputs
Pause::
    (n < Count) ? n++ : n := 1

    Devices2 := {}
    For DeviceName, DeviceID in Devices
        List .= "(" . A_Index . ") " . DeviceName . "`n", ObjRawSet(Devices2, A_Index, DeviceID)


    ;IPolicyConfig::SetDefaultEndpoint
    IPolicyConfig := ComObjCreate("{870af99c-171d-4f9e-af0d-e63df40c2bc9}", "{F8679F50-850A-41CF-9C72-430F290290C8}") ;00000102-0000-0000-C000-000000000046 00000000-0000-0000-C000-000000000046
    R := DllCall(NumGet(NumGet(IPolicyConfig+0)+13*A_PtrSize), "UPtr", IPolicyConfig, "Str", Devices2[n], "UInt", 0, "UInt")
    ObjRelease(IPolicyConfig)
return

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


; Caps to escape
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
        Return

    #IfWinActive
    *CapsLock::
        WinGet, Active_Window, ProcessName, A
        if (IsItemInList(Active_Window, noCapsLockGroup)) {
            send, {CapsLock down}
            KeyWait, CapsLock
            SetCapsLockState, AlwaysOff
            send, {CapsLock up}
        }
        else {
            send, {Escape}
        }
    Return

