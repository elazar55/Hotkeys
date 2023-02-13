; ============================================================
; == Beep subroutine ==
; ============================================================
Beep(frequency, volume)
{
    SoundGet, master_volume
    SoundSet, volume
    SoundBeep, %frequency%
    SoundSet, %master_volume%
}

; ============================================================
; == Click drag mouse with pause ==
; ============================================================
MouseClickDragCustom(key, x, y, x2, y2, delay, speed)
{
    MouseMove, x, y, speed,
    SendInput, {%key% down}
    Sleep delay
    MouseMove, x2, y2, speed,
    SendInput, {%key% up}
}

; ============================================================
; == Triple click paste ==
; ============================================================
#v::
    SendInput, {LButton}
    SendInput, {LButton}
    SendInput, {LButton}
    SendInput, ^v
Return

; ============================================================
; == Double click copy ==
; ============================================================
#c::
    SendInput, {LButton}
    SendInput, {LButton}
    SendInput, ^c
Return

; ============================================================
; == Repeat tab then space ==
; ============================================================
#Space::
    delay = 100

    while (GetKeyState("Space", "p") AND GetKeyState("LWin", "p"))
    {
        SendInput, {Tab}
        Sleep, %delay%
        SendInput, {Space}
        Sleep, %delay%
    }
Return

; ============================================================
; == Game specific remapping ==
; ============================================================

; ============================================================
; == PAC-MAN Championship Edition DX+ ==
; ============================================================
#IfWinActive, PAC-MAN Championship Edition DX+
    w::Up
    a::Left
    r::Down
    s::Right
    Space::Enter
    Return

; ============================================================
; == Hearthstone ==
; ============================================================
#IfWinActive, Hearthstone

    ; ------------------------------------------------------------
    ; -- Turbo space --
    ; ------------------------------------------------------------
    Space::
        delay = 100

        Beep(1500, 25)
        while (GetKeyState("Space", "p"))
        {
            SendInput, {Space}
            Sleep, %delay%
        }
    Return

    ; ------------------------------------------------------------
    ; -- End turn --
    ; ------------------------------------------------------------
    x::
        WinGetPos, , , width, height, A, , ,
        MouseClick, Left, % width * 0.9, % height * 0.45, 1, 0, ,
        MouseMove, % width / 2, height * 0.8, 0,
    Return

    ; ------------------------------------------------------------
    ; -- Turbo LButton --
    ; ------------------------------------------------------------
    #LButton::
        delay = 100

        while (GetKeyState("LButton", "p"))
        {
            SendInput {LButton}
            Sleep, %delay%
        }
    Return

    ; ------------------------------------------------------------
    ; -- Back --
    ; ------------------------------------------------------------
    BackSpace::
        WinGetPos, , , width, height, A, , ,
        MouseClick, Left, % width * 0.91, % height * 0.91, 1, 0, ,
    Return

    ; ------------------------------------------------------------
    ; -- Concede --
    ; ------------------------------------------------------------
    #z::
        WinGetPos, , , width, height, A, , ,
        MouseClick, Left, % width * 0.96, % height * 0.96, 1, 0, ,
        Sleep, 200
        MouseClick, Left, % width * 0.5, % height * 0.38, 1, 0, ,
    Return

    ; ------------------------------------------------------------
    ; -- Squelch --
    ; ------------------------------------------------------------
    c::
        WinGetPos, , , width, height, A, , ,
        MouseClick, Right, % width * 0.5, % height * 0.2, 1, 0, ,
        MouseClick, Left, % width * 0.4, % height * 0.1, 1, 0, ,
    Return

; ============================================================
; == Picross Touch ==
; ============================================================
#IfWinActive Picross Touch

    ; ------------------------------------------------------------
    ; -- Toggle RMB --
    ; ------------------------------------------------------------
    MButton::
        if (toggle := !toggle)
        {
            Beep(1500, 25)
        }
        Else
        {
            Beep(1000, 25)
        }
    Return

    LButton::
        If (toggle)
        {
            SendInput {RButton down}
            KeyWait LButton
            SendInput {RButton up}
        }
        Else
        {
            SendInput {LButton down}
            KeyWait LButton
            SendInput {LButton up}
        }
    Return

    RButton::
        If (toggle)
        {
            SendInput {LButton down}
            KeyWait RButton
            SendInput {LButton up}
        }
        Else
        {
            SendInput {RButton down}
            KeyWait RButton
            SendInput {RButton up}
        }
    Return

    ; ------------------------------------------------------------
    ; -- Cross out row --
    ; ------------------------------------------------------------
    z::
        WinGetPos, , , width, height, A, , ,
        MouseGetPos, xpos, ypos, , ,
        old_x := xpos
        MouseClickDragCustom("RButton", xpos, ypos, width * 0.85, ypos, 25, 0)
        Sleep 150
        MouseMove, old_x, ypos, 0,
    Return

    ; ------------------------------------------------------------
    ; -- Cross out column --
    ; ------------------------------------------------------------
    x::
        WinGetPos, , , width, height, A, , ,
        MouseGetPos, xpos, ypos, , ,
        old_y := ypos
        MouseClickDragCustom("RButton", xpos, ypos, xpos, height * 0.95, 25, 0)
        Sleep 150
        MouseMove, xpos, old_y, 0,
    Return