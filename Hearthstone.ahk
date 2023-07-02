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
        Send, {Blind}{Space}
        Sleep, %repeat_delay%
    }
Return

; ==============================================================================
;                                   End Turn
; ==============================================================================
Space::
    WinGetPos, , , win_width, win_height, A, , ,

    x := win_width * 0.9
    y := win_height * 0.45
    click_count := 1
    speed := 0

    MouseClick, Left, x, y, click_count, speed, ,
Return

Space Up:: ; Re-center
    x := win_width / 2
    y := win_height * 0.8

    MouseMove, x, y, speed,
Return

; ==============================================================================
;                                 Turbo LButton
; ==============================================================================
!LButton::
    while (GetKeyState("LButton", "p"))
    {
        Send {Blind}{LButton}
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
    WinGetPos, , , win_width, win_height, A, , ,

    x := win_width * 0.82
    y := win_height * 0.8
    click_count := 1
    speed := 0

    MouseClick, Left, x, y, click_count, speed, ,
Return

; ==============================================================================
;                                    Concede
; ==============================================================================
#c::
    WinGetPos, , , win_width, win_height, A, , ,

    x := win_width * 0.96
    y := win_height * 0.96
    click_count := 1
    speed := 2

    MouseClick, Left, x, y, click_count, speed, ,

    x := win_width * 0.5
    y := win_height * 0.38
    MouseClick, Left, x, y, click_count, speed, ,
Return

; ==============================================================================
;                                    Squelch
; ==============================================================================
#s::
    WinGetPos, , , win_width, win_height, A, , ,

    x := win_width * 0.5
    y := win_height * 0.2
    click_count := 1
    speed := 0

    MouseClick, Right, x, y, click_count, speed, ,

    x := win_width * 0.4
    y := win_height * 0.12
    speed := 2
    MouseClick, Left, x, y, click_count, speed, ,
Return
