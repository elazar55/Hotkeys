; ============================================================
; == Auto Exexcute
; ============================================================

; ------------------------------------------------------------
; -- Script attributes
; ------------------------------------------------------------
#NoEnv
#SingleInstance, Force
SetTitleMatchMode, 2
SendMode, Event

; ------------------------------------------------------------
; -- Excluded windows from surround with hotkeys
; ------------------------------------------------------------
GroupAdd, excluded_windows, Visual Studio Code
GroupAdd, excluded_windows, cmd.exe
GroupAdd, excluded_windows, MINGW64

; ------------------------------------------------------------
; -- Include files for specific programs or games
; -- Included files will auto execute as well
; ------------------------------------------------------------
#Include, Hearthstone.ahk
#Include, PacmanDX.ahk
#Include, PicrossTouch.ahk
; == Unset due to includes setting it
#IfWinActive

; ============================================================
; == Global hotkeys
; ============================================================

; ============================================================
; == Beep Subroutine
; ============================================================
Beep(frequency, volume)
{
    SoundGet, master_volume
    SoundSet, volume
    SoundBeep, %frequency%
    SoundSet, %master_volume%
}

; ============================================================
; == Triple click paste
; ============================================================
#v::
    Send, {LButton}
    Send, {LButton}
    Send, {LButton}
    Send, ^v
Return

; ============================================================
; == Double click copy
; ============================================================
#c::
    Send, {LButton}
    Send, {LButton}
    Send, ^c
Return

; ============================================================
; == Repeat tab then space
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
; == Surround with quotes
; == Exclude VS Code and apps which don't use CTRL+V to paste
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
; == Surround with parenthesis
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