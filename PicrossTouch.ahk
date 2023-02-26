; ============================================================
; == Click drag mouse with pause
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
; == Picross Touch
; ============================================================
#IfWinActive ahk_exe picross.exe

; ------------------------------------------------------------
; -- Toggle RMB
; ------------------------------------------------------------
MButton::
    if (toggle := !toggle)
    {
        Send {RButton down}
        Beep(1500, 25)
    }
    Else
    {
        Send {RButton up}
        Beep(1000, 25)
    }
Return

LButton::
    If (toggle)
    {
        toggle = 0
        Send {RButton up}
        Beep(1000, 25)
    }
    Else
    {
        Send {LButton Down}
        KeyWait, LButton
        Send {LButton Up}
    }
Return

~RButton::
    If (toggle)
    {
        toggle = 0
        Send {RButton up}
        Beep(1000, 25)
    }
Return

; ------------------------------------------------------------
; -- Cross out row ->
; ------------------------------------------------------------
s::
    WinGetPos, , , width, height, A, , ,
    MouseGetPos, xpos, ypos, , ,
    old_x := xpos
    MouseClickDragCustom("RButton", xpos, ypos, width * 0.87, ypos, 40, 3)
    MouseMove, old_x, ypos, 0,
Return

; ------------------------------------------------------------
; -- Cross out row <-
; ------------------------------------------------------------
a::
    WinGetPos, , , width, height, A, , ,
    MouseGetPos, xpos, ypos, , ,
    old_x := xpos
    MouseClickDragCustom("RButton", xpos, ypos, width * 0.3, ypos, 40, 3)
    MouseMove, old_x, ypos, 0,
Return

; ------------------------------------------------------------
; -- Cross out column V
; ------------------------------------------------------------
r::
    WinGetPos, , , width, height, A, , ,
    MouseGetPos, xpos, ypos, , ,
    old_y := ypos
    MouseClickDragCustom("RButton", xpos, ypos, xpos, height * 0.95, 40, 3)
    MouseMove, xpos, old_y, 0,
Return

; ------------------------------------------------------------
; -- Cross out column ^
; ------------------------------------------------------------
w::
    WinGetPos, , , width, height, A, , ,
    MouseGetPos, xpos, ypos, , ,
    old_y := ypos
    MouseClickDragCustom("RButton", xpos, ypos, xpos, height * 0.3, 40, 3)
    MouseMove, xpos, old_y, 0,
Return