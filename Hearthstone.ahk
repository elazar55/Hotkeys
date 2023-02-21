; ============================================================
; == Auto Exexcute section
; ============================================================
repeat_delay = 50

; ============================================================
; == Hearthstone
; ============================================================
#IfWinActive, ahk_exe Hearthstone.exe

; ------------------------------------------------------------
; -- Turbo space
; ------------------------------------------------------------
x::
    Beep(1500, 25)
    while (GetKeyState("Space", "p"))
    {
        Send, {Space}
        Sleep, %repeat_delay%
    }
Return

; ------------------------------------------------------------
; -- End turn
; ------------------------------------------------------------
Space::
    WinGetPos, , , width, height, A, , ,

    While, GetKeyState("x", "P") ; -- Keeps clicking until you let go
    {
        MouseClick, Left, % width * 0.9, % height * 0.45, 1, 0, ,
        Sleep, %repeat_delay%
    }
    MouseMove, % width / 2, height * 0.8, 0,
Return

; ------------------------------------------------------------
; -- Turbo LButton
; ------------------------------------------------------------
!LButton::
    while (GetKeyState("LButton", "p"))
    {
        Send {LButton}
        Sleep, %repeat_delay%`
    }
Return

; ------------------------------------------------------------
; -- Back
; ------------------------------------------------------------
BackSpace::
    WinGetPos, , , width, height, A, , ,
    MouseClick, Left, % width * 0.91, % height * 0.91, 1, 0, ,
Return

; ------------------------------------------------------------
; -- Concede
; ------------------------------------------------------------
#z::
    WinGetPos, , , width, height, A, , ,
    MouseClick, Left, % width * 0.96, % height * 0.96, 1, 0, ,
    MouseClick, Left, % width * 0.5, % height * 0.38, 1, 2, ,
Return

; ------------------------------------------------------------
; -- Squelch
; ------------------------------------------------------------
c::
    WinGetPos, , , width, height, A, , ,
    MouseClick, Right, % width * 0.5, % height * 0.2, 1, 0, ,
    MouseClick, Left, % width * 0.4, % height * 0.1, 1, 0, ,
Return