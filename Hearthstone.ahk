; ============================================================
; == Hearthstone
; ============================================================
#IfWinActive, ahk_exe Hearthstone.exe

; ------------------------------------------------------------
; -- Turbo space
; ------------------------------------------------------------
Space::
    delay = 100

    Beep(1500, 25)
    while (GetKeyState("Space", "p"))
    {
        Send, {Space}
        Sleep, %delay%
    }
Return

; ------------------------------------------------------------
; -- End turn
; ------------------------------------------------------------
x::
    WinGetPos, , , width, height, A, , ,
    MouseClick, Left, % width * 0.9, % height * 0.45, 1, 0, ,
    MouseMove, % width / 2, height * 0.8, 0,
Return

; ------------------------------------------------------------
; -- Turbo LButton
; ------------------------------------------------------------
#LButton::
    delay = 100

    while (GetKeyState("LButton", "p"))
    {
        Send {LButton}
        Sleep, %delay%
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
    Sleep, 200
    MouseClick, Left, % width * 0.5, % height * 0.38, 1, 0, ,
Return

; ------------------------------------------------------------
; -- Squelch
; ------------------------------------------------------------
c::
    WinGetPos, , , width, height, A, , ,
    MouseClick, Right, % width * 0.5, % height * 0.2, 1, 0, ,
    MouseClick, Left, % width * 0.4, % height * 0.1, 1, 0, ,
Return