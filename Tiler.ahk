; ==============================================================================
;                                 Tile Windows
; ==============================================================================
TileWindows:
    SetTitleMatchMode Regex
    WinGet, window_count, List, .+, , Start Menu|Program Manager|Chrome|Code|Hotkeys|Window Spy

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
        MsgBox, %id%
        If (carry && A_Index = window_count)
            window_height := ((screen_height / rows) * (carry + 1)) + (top_offset)

        WinActivate, ahk_id %id%
        WinMove, ahk_id %id%,, x_pos, y_pos, window_width, window_height
        ; MsgBox, X: %x_index%`nY: %y_index%
    }

    SetTitleMatchMode 1
Return
