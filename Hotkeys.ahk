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
GroupAdd, excluded_windows, ahk_exe code.exe
GroupAdd, excluded_windows, ahk_exe cmd.exe
GroupAdd, excluded_windows, ahk_exe mintty.exe

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
; == Surround with ... etc
; == Exclude VS Code and apps which don't use CTRL+V to paste
; ============================================================
#IfWinNotActive, ahk_group excluded_windows
SurroundWith(open, close)
{
    clip_content := Clipboard
    Clipboard := ""
    Send ^c
    ClipWait, 0.05
    Clipboard := open Clipboard close
    Send ^v
    Clipboard := clip_content
}

; ============================================================
; == Surround with parenthesis
; ============================================================
"::
    SurroundWith("""", """")
    Beep(1500, 25)
Return

; ============================================================
; == Surround with parenthesis
; ============================================================
+9::
    SurroundWith("(", ")")
    Beep(1500, 25)
Return
