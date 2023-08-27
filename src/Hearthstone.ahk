; ==============================================================================
;                             Auto Exexcute section
; ==============================================================================
#IfWinActive, ahk_exe Hearthstone.exe
; ==============================================================================
;                                  Turbo Space
; ==============================================================================
#Space::
    Send, {Space}
Return
; ==============================================================================
;                                   End Turn
; ==============================================================================
Space::
    WinGetPos, , , win_width, win_height, A

    ;@AHK++AlignAssignmentOn
    x           := win_width * 0.9
    y           := win_height * 0.45
    click_count := 1
    speed       := 0
    ;@AHK++AlignAssignmentOff

    while (GetKeyState("Space", "p"))
        MouseClick, Left, x, y, click_count, speed

    ; Move to neutral
    x := win_width / 2
    y := win_height * 0.8
    MouseMove, x, y, speed
Return
; ==============================================================================
;                                 Turbo LButton
; ==============================================================================
#LButton::
    while (GetKeyState("LButton", "p"))
        Send {Blind}{LButton}
Return
; ==============================================================================
;                                     Back
; ==============================================================================
#BackSpace::
    WinGetPos, , , win_width, win_height, A

    ;@AHK++AlignAssignmentOn
    x           := win_width * 0.91
    y           := win_height * 0.91
    click_count := 1
    speed       := 0
    ;@AHK++AlignAssignmentOff

    while (GetKeyState("Backspace", "p"))
        MouseClick, Left, x, y, click_count, speed
Return
; ==============================================================================
;                                     Play
; ==============================================================================
#p::
    WinGetPos, , , win_width, win_height, A

    ;@AHK++AlignAssignmentOn
    x           := win_width * 0.82
    y           := win_height * 0.8
    click_count := 1
    speed       := 0
    ;@AHK++AlignAssignmentOff

    while (GetKeyState("p", "p"))
        MouseClick, Left, x, y, click_count, speed
Return
; ==============================================================================
;                                    Concede
; ==============================================================================
#c::
    WinGetPos, , , win_width, win_height, A

    ;@AHK++AlignAssignmentOn
    x           := win_width * 0.96
    y           := win_height * 0.96
    click_count := 1
    speed       := 0
    delay       := 150
    ;@AHK++AlignAssignmentOff

    MouseClick, Left, x, y, click_count, speed
    Sleep, %delay%

    x := win_width * 0.5
    y := win_height * 0.38
    MouseClick, Left, x, y, click_count, speed
Return
; ==============================================================================
;                                    Squelch
; ==============================================================================
#s::
    WinGetPos, , , win_width, win_height, A

    ;@AHK++AlignAssignmentOn
    x           := win_width * 0.5
    y           := win_height * 0.2
    click_count := 1
    speed       := 0
    delay       := 150
    ;@AHK++AlignAssignmentOff

    MouseClick, Right, x, y, click_count, speed
    Sleep, %delay%

    ;@AHK++AlignAssignmentOn
    x     := win_width * 0.4
    y     := win_height * 0.12
    speed := 0
    ;@AHK++AlignAssignmentOff

    MouseClick, Left, x, y, click_count, speed

    ; Move to neutral
    x := win_width / 2
    y := win_height * 0.8
    MouseMove, x, y, speed
Return
