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

        SoundBeep, 1500
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
        MouseClick, Left, 1200, 500, 1, 0, ,
        MouseMove, 600, 1000, 0,
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
        MouseClick, Left, 1300, 950, 1, 0, ,
    Return

    ; ------------------------------------------------------------
    ; -- Concede --
    ; ------------------------------------------------------------
    #z::
        MouseClick, Left, 1330, 1020, 1, 0, ,
        Sleep, 150
        MouseClick, Left, 700, 400, 1, 0, ,
    Return

    ; ------------------------------------------------------------
    ; -- Squelch --
    ; ------------------------------------------------------------
    c::
        MouseClick, Right, 684, 225, 1, 0, ,
        ; Sleep, 150
        MouseClick, Left, 550, 135, 1, 0, ,
    Return

; ============================================================
; == Picross Touch ==
; ============================================================
#IfWinActive, Picross Touch

    ; ------------------------------------------------------------
    ; -- Toggle RMB --
    ; ------------------------------------------------------------
    MButton::
        if (toggle := !toggle)
        {
            SoundSet, 25
            SoundBeep, 1500
            SoundSet, 100
        }
        Else
        {
            SoundSet, 25
            SoundBeep, 1000
            SoundSet, 100
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