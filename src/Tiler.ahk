; ==============================================================================
;                             Auto Exexcute Section
; ==============================================================================
#IfWinActive
; @AHK++AlignAssignmentOn
global screen_width  := 1920
global screen_height := 1050
global pos_x         :=
global pos_y         :=
global alignment     := 60
global window_width  :=
global window_height :=
; @AHK++AlignAssignmentOff
CoordMode, ToolTip, Screen
CoordMode, Mouse, Screen
Return
; ==============================================================================
;                                    Update
; ==============================================================================
Update()
{
    ; @AHK++AlignAssignmentOn
    global left_offset := 7
    global top_offset  := 7
    global min_width   := 320 ; alignment * Round((screen_width / min_width_factor) / alignment)
    ; @AHK++AlignAssignmentOff

    WinGet, is_maximized, MinMax, A
    if (is_maximized)
        WinRestore, A

    WinGetPos, pos_x, pos_y, window_width, window_height, A, , ,
    WinGet, title, ProcessName, A, , ,

    If (RegExMatch(title, "(Code.exe)|(Playnite.*.exe)"))
    {
        ; @AHK++AlignAssignmentOn
        left_offset      := 0
        top_offset       := 0
        global min_width := 400
        ; @AHK++AlignAssignmentOff
    }
    else If (RegExMatch(title, "Afterburner"))
    {
        global min_width := 240
    }
    else If (RegExMatch(title, "chrome"))
    {
        global min_width := 502
    }
}
; ==============================================================================
;                                      GUI
; ==============================================================================
DockerGUI:
    Update()

    Gui, Destroy
    InputBox, alignment, Alignment, Alignment, , , , , , , , %alignment%
    min_width := alignment * Round((screen_width / 3) / alignment)
Return
; ==============================================================================
;                                Remove ToolTip
; ==============================================================================
RemoveToolTip:
    ToolTip
return
; ==============================================================================
;                                 Dock Function
; ==============================================================================
Dock(x, y, width, height)
{
    global left_offset
    global top_offset

    tip_x := x + left_offset
    If (x == -left_offset)
        tip_x := width - left_offset * 2
    ToolTip, % width - left_offset * 2 . "x" . height - top_offset, tip_x, y
    SetTimer, RemoveTooltip, -1000

    WinMove, A, , x, y, width, height, ,
}
; ==============================================================================
;                                  Align Width
; ==============================================================================
AlignWidth(resize)
{
    ; @AHK++AlignAssignmentOn
    global left_offset
    global alignment
    global min_width
    global screen_width
    global window_width
    ; @AHK++AlignAssignmentOff

    ; Undersize
    If (window_width - left_offset * 2 == min_width && resize < 0)
    {
        new_width := screen_width
    }
    Else If ((window_width - left_offset * 2) - alignment < min_width && resize < 0)
    {
        new_width := min_width
    }
    ; Oversize
    Else If (window_width - left_offset * 2 >= screen_width && resize > 0)
        new_width := min_width ; (Ceil((min_width - left_offset * 2) / alignment)) * alignment
    ; Resize
    Else
        new_width := (Round((window_width - left_offset * 2) / alignment) + resize) * alignment

    Return new_width + left_offset * 2
}
; ==============================================================================
;                                     Left
; ==============================================================================
#a::
    Update()

    ; Resize if the window is already docked to the left.
    If (pos_x == -left_offset && (pos_y == 0 || pos_y + window_height - top_offset == screen_height))
        new_width := AlignWidth(-1)

    ; Otherwise, place it on the left, resize it to the nearest alignment, and
    ; stretch it vertically.
    Else
    {
        ; @AHK++AlignAssignmentOn
        new_width     := AlignWidth(0)
        window_height := screen_height + top_offset
        pos_y         := 0
        ; @AHK++AlignAssignmentOff
    }
    Dock(-left_offset, pos_y, new_width, window_height)
Return
; ==============================================================================
;                                 Left Reverse
; ==============================================================================
$+#a::
    Update()
    If (pos_x == -left_offset && (pos_y == 0 || pos_y + window_height - top_offset == screen_height))
        new_width := AlignWidth(1)
    Else
    {
        new_width := AlignWidth(0)
        window_height := screen_height + top_offset
        pos_y := 0
    }

    Dock(-left_offset, pos_y, new_width, window_height)
Return
; ==============================================================================
;                                     Right
; ==============================================================================
#s::
    Update()
    If (pos_x == screen_width - window_width + left_offset && (pos_y == 0 || pos_y + window_height - top_offset == screen_height))
        new_width := AlignWidth(-1)
    Else
    {
        new_width := AlignWidth(0)
        window_height := screen_height + top_offset
        pos_y := 0
    }

    Dock(screen_width - new_width + left_offset, pos_y, new_width, window_height)
Return
; ==============================================================================
;                             Right Reverse
; ==============================================================================
+#s::
    Update()
    If (pos_x == screen_width - window_width + left_offset && (pos_y == 0 || pos_y + window_height - top_offset == screen_height))
        new_width := AlignWidth(1)
    Else
    {
        new_width := AlignWidth(0)
        window_height := screen_height + top_offset
        pos_y := 0
    }

    Dock(screen_width - new_width + left_offset, pos_y, new_width, window_height)
Return
; ==============================================================================
;                                      Up
; ==============================================================================
#w::
    Update()

    If (window_height < screen_height)
        Dock(pos_x, 0, window_width, screen_height + top_offset)
    Else
        Dock(pos_x, 0, window_width, Round(window_height / 2 + top_offset / 2))
Return
; ==============================================================================
;                                     Down
; ==============================================================================
#r::
    Update()

    If (window_height < screen_height)
        Dock(pos_x, 0, window_width, screen_height + top_offset)
    Else
        Dock(pos_x, screen_height / 2, window_width, Round(screen_height / 2 + top_offset))
Return
; ==============================================================================
;                                   Top-Left
; ==============================================================================
#q::
    Update()
    Dock(-left_offset, 0, window_width, window_height)
Return
; ==============================================================================
;                                   Top-Right
; ==============================================================================
#f::
    Update()
    Dock(screen_width - window_width + left_offset, 0, window_width, window_height)
Return
; ==============================================================================
;                                   Bottom-Left
; ==============================================================================
#z::
    Update()
    Dock(-left_offset, screen_height - window_height + top_offset, window_width, window_height)
Return
; ==============================================================================
;                                   Bottom-Right
; ==============================================================================
#c::
    Update()
    Dock(screen_width - window_width + left_offset, screen_height - window_height + top_offset, window_width, window_height)
Return
; ==============================================================================
;                                Move Along Grid
; ==============================================================================
MoveAlongGrid:
#x::
    Update()
    ;@AHK++AlignAssignmentOn
    cells := 16
    index := (pos_x + left_offset) / (screen_width / cells)
    ;@AHK++AlignAssignmentOff

    If (window_height - top_offset <= screen_height / 2)
    {
        If (pos_y < screen_height / 2)
            pos_y := 0
        Else
            pos_y := screen_height / 2
    }
    Else
    {
        pos_y := 0
    }

    if (pos_x >= screen_width - window_width + left_offset)
    {
        index := -1

        If (pos_y < screen_height / 2 && window_height - top_offset <= screen_height / 2)
            pos_y := screen_height / 2
        Else
            pos_y := 0
    }
    Dock(screen_width * ((Floor(index) + 1) / cells) - left_offset, pos_y, window_width, window_height)
Return
; ==============================================================================
;                            Move Along Grid Reverse
; ==============================================================================
MoveAlongGridReverse:
+#x::
    Update()
    ;@AHK++AlignAssignmentOn
    cells := 16
    index := (pos_x + left_offset) / (screen_width / cells)
    ;@AHK++AlignAssignmentOff

    If (window_height - top_offset <= screen_height / 2)
    {
        If (pos_y < screen_height / 2)
            pos_y := 0
        Else
            pos_y := screen_height / 2
    }
    Else
    {
        pos_y := 0
    }

    if (pos_x <= 0)
    {
        cell_width := screen_width / cells
        last_cell := Floor((window_width - left_offset) / cell_width)
        index := cells - last_cell + 1

        If (pos_y < screen_height / 2 && window_height - top_offset <= screen_height / 2)
            pos_y := screen_height / 2
        Else
            pos_y := 0
    }
    Dock(screen_width * ((Floor(index) - 1) / cells) - left_offset, pos_y, window_width, window_height)
Return
; ==============================================================================
;                                    Move Along Width
; ==============================================================================
MoveAlongWidth:
    Update()
    ;@AHK++AlignAssignmentOn
    cells := screen_width / (window_width - left_offset * 2)
    index := (pos_x + left_offset) / (window_width - left_offset * 2)
    ;@AHK++AlignAssignmentOff

    If (window_height - top_offset <= screen_height / 2)
    {
        If (pos_y < screen_height / 2)
            pos_y := 0
        Else
            pos_y := screen_height / 2
    }
    Else
    {
        pos_y := 0
    }

    if (pos_x >= screen_width - window_width + left_offset)
    {
        index := -1

        If (pos_y < screen_height / 2 && window_height - top_offset <= screen_height / 2)
            pos_y := screen_height / 2
        Else
            pos_y := 0
    }
    Dock(screen_width * ((Floor(index) + 1) / cells) - left_offset, pos_y, window_width, window_height)
Return
; ==============================================================================
;                            Move Along Width Reverse
; ==============================================================================
MoveAlongWidthReverse:
    Update()
    ;@AHK++AlignAssignmentOn
    cells := screen_width / (window_width - left_offset * 2)
    index := (pos_x + left_offset) / (window_width - left_offset * 2)
    ;@AHK++AlignAssignmentOff

    If (window_height - top_offset <= screen_height / 2)
    {
        If (pos_y < screen_height / 2)
            pos_y := 0
        Else
            pos_y := screen_height / 2
    }
    Else
    {
        pos_y := 0
    }

    if (index <= 0)
    {
        cell_width := screen_width / cells
        last_cell := Floor((window_width - left_offset) / cell_width)
        index := cells - last_cell + 1

        If (pos_y < screen_height / 2 && window_height - top_offset <= screen_height / 2)
            pos_y := screen_height / 2
        Else
            pos_y := 0
    }
    Dock(screen_width * ((Floor(index) - 1) / cells) - left_offset, pos_y, window_width, window_height)
Return
; ==============================================================================

; ==============================================================================
; ~LButton::
;     Update()
;     while (GetKeyState("LButton", "p"))
;     {
;         MouseGetPos, pos_x, pos_y, , ,
;         pos_x := (Round((pos_x) / alignment)) * alignment
;         pos_y := (Round((pos_y) / alignment)) * alignment
;         ToolTip, %pos_x% : %pos_y%, , ,
;         ; WinMove, A, , pos_x - window_width / 2, pos_y - window_height / 2, , , ,
;     }
;     ToolTip
; Return
