; ============================================================
; == Greed Corp
; ============================================================
#IfWinActive ahk_class GREED_CORP_CLASSNAME

r::s
s::d

Return

; ============================================================
; == PAC-MAN Championship Edition DX+
; ============================================================
#IfWinActive, ahk_exe PAC-MAN.exe

w::Up
a::Left
r::Down
s::Right
Space::Enter

Return

; ============================================================
; == Fez
; ============================================================
#IfWinActive ahk_exe FEZ.exe

w::Up
a::Left
r::Down
s::Right