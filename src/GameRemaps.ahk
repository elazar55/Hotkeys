; ==============================================================================
;                                  Pix The Cat
; ==============================================================================
#IfWinActive ahk_exe PixTheCat.exe
Space::Enter

; Restart
^r::
    SetKeyDelay, 25, 25
    Send, {Escape}
    Send, {Down}
    Send, {Enter}
    ; Default key delay
    SetKeyDelay, 10, -1
Return
; ==============================================================================
;                                Absolute Drift
; ==============================================================================
#IfWinActive ahk_exe AbsoluteDrift.exe
w::Up
a::Left
r::Down
s::Right
BackSpace::Enter
; ==============================================================================
;                              Battleblock Theater
; ==============================================================================
#IfWinActive ahk_exe BattleBlockTheater.exe
w::Up
a::Left
r::Down
s::Right
; ==============================================================================
;                                  Greed Corp
; ==============================================================================
#IfWinActive ahk_class GREED_CORP_CLASSNAME
r::s
s::d
; ==============================================================================
;                       PAC-MAN Championship Edition DX+
; ==============================================================================
#IfWinActive, ahk_exe PAC-MAN.exe
w::Up
a::Left
r::Down
s::Right
Space::Enter
; ==============================================================================
;                                      Fez
; ==============================================================================
#IfWinActive ahk_exe FEZ.exe
r::s
s::d
; ==============================================================================
;                                      Fly
; ==============================================================================
v::
    ; Releases jump in case previous trigger left it down
    Send {Space Up}

    SetKeyDelay, 25, 25
    Send wwww
    Send {Space Down}

    ; Default key delay
    SetKeyDelay, 10, -1
Return
; ==============================================================================
;                        Wraps mouse around game window
; ==============================================================================
~LButton::
    While, (GetKeyState("LButton", "p"))
    {
        MouseGetPos, mouse_x, mouse_y, , ,
        WinGetPos, window_x, window_y, window_width, window_height, A, , ,
        ToolTip, %mouse_x% `n %mouse_y%, , ,

        If (mouse_x > window_width)
            MouseMove, window_x, mouse_y, 0
        If (mouse_y > window_height)
            MouseMove, mouse_x, window_y, 0
        If (mouse_x < window_x + 5)
            MouseMove, window_width, mouse_y, 0
        If (mouse_y - 1 < window_y)
            MouseMove, mouse_x, window_height, 0
    }
    ToolTip, , , ,
Return
