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
