; ============================================================
; == Script attributes ==
; ============================================================
#NoEnv
#SingleInstance, Force
SetTitleMatchMode, 2
SendMode, Event

; ============================================================
; == Beep Subroutine ==
; ============================================================
Beep(frequency, volume)
{
    SoundGet, master_volume
    SoundSet, volume
    SoundBeep, %frequency%
    SoundSet, %master_volume%
}

; ============================================================
; == Excluded windows from surround with hotkeys ==
; ============================================================
GroupAdd, excluded_windows, Visual Studio Code
GroupAdd, excluded_windows, cmd.exe
GroupAdd, excluded_windows, MINGW64

; ============================================================
; == Include files for specific programs or games ==
; ============================================================
#Include, Hearthstone.ahk
#Include, PacmanDX.ahk
#Include, PicrossTouch.ahk
; == Unset due to includes setting it ==
#IfWinActive

; ============================================================
; == Triple click paste ==
; ============================================================
#v::
    Send, {LButton}
    Send, {LButton}
    Send, {LButton}
    Send, ^v
Return

; ============================================================
; == Double click copy ==
; ============================================================
#c::
    Send, {LButton}
    Send, {LButton}
    Send, ^c
Return

; ============================================================
; == Repeat tab then space ==
; ============================================================
#Space::
    delay = 100

    while (GetKeyState("Space", "p") AND GetKeyState("LWin", "p"))
    {
        Send, {Tab}
        Sleep, %delay%
        Send, {Space}
        Sleep, %delay%
    }
Return

; ============================================================
; == Surround with quotes ==
; ============================================================
#IfWinNotActive, ahk_group excluded_windows
"::
    clip_content := Clipboard
    Clipboard := ""
    Send ^c
    ClipWait, 0.05
    Clipboard := """" Clipboard """"
    Send ^v
    Clipboard := clip_content
    Beep(1500, 25)
Return

; ============================================================
; == Surround with parenthesis ==
; ============================================================
+9::
    clip_content := Clipboard
    Clipboard := ""
    Send ^c
    ClipWait, 0.05
    Clipboard := "(" Clipboard ")"
    Send ^v
    Clipboard := clip_content
    Beep(1500, 25)
Return