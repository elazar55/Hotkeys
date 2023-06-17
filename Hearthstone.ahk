; ==============================================================================
;                             Auto Exexcute section
; ==============================================================================
repeat_delay = 50
#IfWinActive, ahk_exe Hearthstone.exe

; ==============================================================================
;                                  Turbo Space
; ==============================================================================
#Space::
    while (GetKeyState("Space", "p"))
    {
        Send, {Space}
        Sleep, %repeat_delay%
    }
Return

; ==============================================================================
;                                   End Turn
; ==============================================================================
Space::
    WinGetPos, , , width, height, A, , ,
    MouseClick, Left, % width * 0.9, % height * 0.45, 1, 0, ,
Return

Space Up::
    ; Re-center
    MouseMove, % width / 2, height * 0.8, 0,
Return

; ==============================================================================
;                                 Turbo LButton
; ==============================================================================
!LButton::
    while (GetKeyState("LButton", "p"))
    {
        Send {LButton}
        Sleep, %repeat_delay%`
    }
Return

; ==============================================================================
;                                     Back
; ==============================================================================
#BackSpace::
    WinGetPos, , , width, height, A, , ,
    MouseClick, Left, % width * 0.91, % height * 0.91, 1, 0, ,
Return

; ==============================================================================
;                                     Play
; ==============================================================================
#p::
    WinGetPos, , , width, height, A, , ,
    MouseClick, Left, % (width * 0.82), % (height * 0.8), 1, 0, ,
Return

; ==============================================================================
;                                    Concede
; ==============================================================================
#c::
    WinGetPos, , , width, height, A, , ,
    MouseClick, Left, % width * 0.96, % height * 0.96, 1, 0, ,
    MouseClick, Left, % width * 0.5, % height * 0.38, 1, 2, ,
Return

; ==============================================================================
;                                    Squelch
; ==============================================================================
#s::
    WinGetPos, , , width, height, A, , ,
    MouseClick, Right, % width * 0.5, % height * 0.2, 1, 0, ,
    MouseClick, Left, % width * 0.4, % height * 0.12, 1, 2, ,
Return