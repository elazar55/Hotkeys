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
            Send {RButton down}
            KeyWait LButton
            Send {RButton up}
        }
        Else
        {
            Send {LButton down}
            KeyWait LButton
            Send {LButton up}
        }
    Return

    RButton::
        If (toggle)
        {
            Send {LButton down}
            KeyWait RButton
            Send {LButton up}
        }
        Else
        {
            Send {RButton down}
            KeyWait RButton
            Send {RButton up}
        }
    Return

    ; ------------------------------------------------------------
    ; -- Cross out row -> --
    ; ------------------------------------------------------------
    s::
        WinGetPos, , , width, height, A, , ,
        MouseGetPos, xpos, ypos, , ,
        old_x := xpos
        MouseClickDragCustom("RButton", xpos, ypos, width * 0.87, ypos, 40, 3)
        Sleep 150
        MouseMove, old_x, ypos, 0,
    Return

    ; ------------------------------------------------------------
    ; -- Cross out row <- --
    ; ------------------------------------------------------------
    a::
        WinGetPos, , , width, height, A, , ,
        MouseGetPos, xpos, ypos, , ,
        old_x := xpos
        MouseClickDragCustom("RButton", xpos, ypos, width * 0.3, ypos, 40, 3)
        Sleep 150
        MouseMove, old_x, ypos, 0,
    Return

    ; ------------------------------------------------------------
    ; -- Cross out column V --
    ; ------------------------------------------------------------
    r::
        WinGetPos, , , width, height, A, , ,
        MouseGetPos, xpos, ypos, , ,
        old_y := ypos
        MouseClickDragCustom("RButton", xpos, ypos, xpos, height * 0.95, 40, 3)
        Sleep 150
        MouseMove, xpos, old_y, 0,
    Return

    ; ------------------------------------------------------------
    ; -- Cross out column ^ --
    ; ------------------------------------------------------------
    w::
        WinGetPos, , , width, height, A, , ,
        MouseGetPos, xpos, ypos, , ,
        old_y := ypos
        MouseClickDragCustom("RButton", xpos, ypos, xpos, height * 0.3, 40, 3)
        Sleep 150
        MouseMove, xpos, old_y, 0,
    Return