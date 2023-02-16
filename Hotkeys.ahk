; ============================================================
; == Script attributes ==
; ============================================================
#NoEnv
#SingleInstance, Force
SetTitleMatchMode, 2
SendMode, Event
#Include, Hearthstone.ahk
#Include, PacmanDX.ahk
#Include, PicrossTouch.ahk
#IfWinActive ; Unset due to includes setting

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
#IfWinNotActive, Visual Studio Code
    "::
        clip_content := Clipboard
        Clipboard := ""
        Send ^c
        ClipWait, 0.05
        Clipboard := """" Clipboard """"
        Send ^v
        Clipboard := clip_content
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
    Return