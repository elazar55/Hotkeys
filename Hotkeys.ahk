; ============================================================
; == Script attributes ==
; ============================================================
#NoEnv
#SingleInstance, Force
SendMode, Event
#Include, Hearthstone.ahk
#Include, PacmanDX.ahk
#Include, PicrossTouch.ahk
#IfWinActive ; Unset due to includes setting

; ============================================================
; == Click drag mouse with pause ==
; ============================================================
MouseClickDragCustom(key, x, y, x2, y2, delay, speed)
{
    MouseMove, x, y, speed,
    Send, {%key% down}
    Sleep delay
    MouseMove, x2, y2, speed,
    Send, {%key% up}
}

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