#IfWinActive
; ==============================================================================
;                                 Tile Windows
; ==============================================================================
TileWindows:
    Gui, Destroy
    SetTitleMatchMode Regex
    WinGet, window_count, List, .+, , Start Menu|Program Manager|Chrome|Code|Hotkeys|Window Spy|RetroArch

    ; @AHK++AlignAssignmentOn
    rows          := Min(Ceil(window_count / 2), 2)
    columns       := Ceil(window_count / rows)
    slots         := rows * columns
    carry         := slots - window_count
    left_offset   := 7
    top_offset    := 7
    screen_width  := 1920
    screen_height  = 1050
    window_width  := (screen_width / columns) + (left_offset * 2)
    window_height := (screen_height / rows) + (top_offset)
    ; @AHK++AlignAssignmentOff

    Loop, %window_count%
    {
        ; @AHK++AlignAssignmentOn
        id      := window_count%A_Index%
        x_index := Floor((A_Index - 1) / rows)
        y_index := Mod(A_Index - 1, rows)
        x_pos   := ((window_width - left_offset * 2) * x_index) - left_offset
        y_pos   := (window_height - top_offset) * y_index
        ; @AHK++AlignAssignmentOff

        If (carry && A_Index = window_count)
            window_height := ((screen_height / rows) * (carry + 1)) + (top_offset)

        WinActivate, ahk_id %id%
        WinMove, ahk_id %id%,, x_pos, y_pos, window_width, window_height
        ; MsgBox, X: %x_index%`nY: %y_index%
    }

    SetTitleMatchMode 1
Return
; ==============================================================================
;                                 Grid Windows
; ==============================================================================
GridWindows:
    Gui, Destroy
    SetTitleMatchMode Regex
    WinGet, window_count, List, .+, , Start Menu|Program Manager|Chrome|Code|Hotkeys|Window Spy|RetroArch

    ; @AHK++AlignAssignmentOn
    rows          := 2
    columns       := 3
    screen_width  := 1920
    screen_height  = 1050
    left_offset   := 7
    top_offset    := 7
    window_width  := (screen_width / columns) + (left_offset * 2)
    window_height := (screen_height / rows) + (top_offset)
    ; @AHK++AlignAssignmentOff

    Loop, %window_count%
    {
        ; @AHK++AlignAssignmentOn
        id      := window_count%A_Index%
        x_index := Floor((A_Index - 1) / rows)
        y_index := Mod(A_Index - 1, rows)
        x_pos   := ((window_width - left_offset * 2) * x_index) - left_offset
        y_pos   := (window_height - top_offset) * y_index
        ; @AHK++AlignAssignmentOff

        WinActivate, ahk_id %id%
        WinMove, ahk_id %id%,, x_pos, y_pos, window_width, window_height
    }
    SetTitleMatchMode 1
Return
; ==============================================================================
;                                   Dock
; ==============================================================================
Globals()
{
    ; @AHK++AlignAssignmentOn
    global screen_width  := 1920
    global screen_height := 1050
    global min_width     := screen_width * 0.35
    global max_width     := screen_width * 0.8
    global decrement     := screen_width * 0.05
    global left_offset   := 7
    global top_offset    := 7
    ; @AHK++AlignAssignmentOff
}
#a::
    Globals()

    WinGetPos, pos_x, , window_width, , A, , ,

    WinMove, A, , -left_offset,

    If (pos_x == -left_offset)
    {
        If (window_width < min_width)
            WinMove, A, , , , max_width, , ,
        Else
            WinMove, A, , , , window_width - decrement, , ,
    }
Return

#s::
    Globals()

    WinGetPos, pos_x, , window_width, , A, , ,

    WinMove, A, , screen_width - window_width + left_offset,

    If (pos_x == screen_width - window_width + left_offset)
    {
        If (window_width < min_width)
            WinMove, A, , screen_width - window_width + decrement + left_offset, , max_width, , ,
        Else
            WinMove, A, , screen_width - window_width + decrement + left_offset, , window_width - decrement, , ,
    }
Return

#w::
    Globals()

    WinGetPos, , , , window_height, A, , ,

    If (window_height <= screen_height * 0.6)
        WinMove, A, , , 0, , screen_height + top_offset, ,
    Else
        WinMove, A, , , 0, , window_height / 2 + top_offset / 2, ,
Return

#r::
    Globals()

    WinGetPos, , , , window_height, A, , ,

    If (window_height <= screen_height * 0.6)
        WinMove, A, , , 0, , screen_height + top_offset, ,
    Else
        WinMove, A, , , screen_height / 2, , screen_height / 2 + top_offset, ,
Return
