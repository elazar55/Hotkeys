; ==============================================================================
;                             Auto Exexcute Section
; ==============================================================================
#IfWinActive
; @AHK++AlignAssignmentOn
global screen_width  := 1920
global screen_height := 1050
global alignment     := 2**6
global min_width     := alignment * Round((screen_width / 3) / alignment)
global left_offset   := 7
global top_offset    := 7
; @AHK++AlignAssignmentOff
Return
; ==============================================================================
;                                    Docker
; ==============================================================================
; ==============================================================================
;                                    Update
; ==============================================================================
Update()
{
    ; @AHK++AlignAssignmentOn
    global left_offset   := 7
    global top_offset    := 7
    global pos_x         :=
    global pos_y         :=
    global window_width  :=
    global window_height :=
    ; @AHK++AlignAssignmentOff
    WinGetPos, pos_x, pos_y, window_width, window_height, A, , ,
    WinGet, title, ProcessName, A, , ,

    If (RegExMatch(title, "(Code.exe)|(Playnite.*.exe)"))
    {
        ; @AHK++AlignAssignmentOn
        left_offset := 0
        top_offset  := 0
        ; @AHK++AlignAssignmentOff
    }
}
; ==============================================================================
;                                      GUI
; ==============================================================================
DockerGUI:
    Update()

    Gui, Destroy
    InputBox, alignment, Alignment, Alignment, , , , , , , , %alignment%
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

    CoordMode, ToolTip, Screen

    tip_x := x + left_offset
    If (x == -left_offset)
        tip_x := width - left_offset * 2
    ToolTip, % width - left_offset * 2 . "x" . height - top_offset, tip_x, y
    SetTimer, RemoveTooltip, -1000

    WinMove, A, , x, y, width, height, ,
}
; ==============================================================================
;                                     Left
; ==============================================================================
#a::
    Update()
    ; Resize if the window is already on the left.
    If (pos_x == -left_offset)
    {
        If (window_width - left_offset * 2 <= min_width)
            Dock(-left_offset, pos_y, screen_width + left_offset * 2, window_height)
        Else
        {
            new_width := (Round((window_width - left_offset * 2) / alignment) - 1) * alignment
            Dock(-left_offset, pos_y, new_width + left_offset * 2, window_height)
        }
    }
    ; Otherwise, place it on the left, resize it to the nearest alignment,
    ; and stretch it vertically
    Else
    {
        If (window_width - left_offset * 2 < min_width)
            new_width := min_width
        Else
            new_width := (Round(window_width / alignment)) * alignment
        Dock(-left_offset, pos_y, new_width + left_offset * 2, window_height)
    }
Return
; ==============================================================================
;                                 Left Reverse
; ==============================================================================
$+#a::
    Update()
    If (pos_x == -left_offset)
    {
        If (window_width >= screen_width)
            Dock(-left_offset, pos_y, min_width + left_offset * 2, window_height)
        Else
        {
            new_width := (Round((window_width - left_offset * 2) / alignment) + 1) * alignment
            Dock(-left_offset, pos_y, new_width + left_offset * 2, window_height)
        }
    }
    Else
    {
        If (window_width - left_offset * 2 < min_width)
            new_width := min_width
        Else
            new_width := (Round(window_width / alignment)) * alignment
        Dock(-left_offset, pos_y, new_width + left_offset * 2, window_height)
    }
Return
; ==============================================================================
;                                     Right
; ==============================================================================
#s::
    Update()

    If (pos_x == screen_width - window_width + left_offset)
    {
        If (window_width - left_offset * 2 <= min_width)
            Dock(-left_offset, pos_y, screen_width + left_offset * 2, window_height)
        Else
        {
            new_width := (Round((window_width - left_offset * 2) / alignment) - 1) * alignment
            Dock(screen_width - new_width - left_offset, pos_y, new_width + left_offset * 2, window_height)
        }
    }
    Else
    {
        If (window_width - left_offset * 2 < min_width)
            new_width := min_width
        Else
            new_width := (Round(window_width / alignment)) * alignment

        Dock(screen_width - new_width - left_offset, pos_y, new_width + left_offset * 2, window_height)
    }
Return
; ==============================================================================
;                             Right Reverse
; ==============================================================================
+#s::
    Update()

    If (pos_x == screen_width - window_width + left_offset)
    {
        If (window_width >= screen_width)
            Dock(screen_width - min_width - left_offset, pos_y, min_width + left_offset * 2, window_height)
        Else
        {
            new_width := (Round((window_width - left_offset * 2) / alignment) + 1) * alignment
            Dock(screen_width - new_width - left_offset, pos_y, new_width + left_offset * 2, window_height)
        }
    }
    Else
    {
        If (window_width - left_offset * 2 < min_width)
            new_width := min_width
        Else
            new_width := (Round(window_width / alignment)) * alignment
        Dock(screen_width - new_width - left_offset, pos_y, new_width + left_offset * 2, window_height)
    }
Return
; ==============================================================================
;                                      Up
; ==============================================================================
#w::
    Update()

    If (window_height <= screen_height * 0.6)
        Dock(pos_x, 0, window_width, screen_height + top_offset)
    Else
        Dock(pos_x, 0, window_width, Round(window_height / 2 + top_offset / 2))
Return
; ==============================================================================
;                                     Down
; ==============================================================================
#r::
    Update()

    If (window_height <= screen_height * 0.6)
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
;                                    Center
; ==============================================================================
#x::
    Update()
    Dock((screen_width / 2) - (window_width / 2) , (screen_height / 2) - (window_height / 2) + (top_offset / 2), window_width, window_height)
Return
