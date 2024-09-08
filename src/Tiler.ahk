; ==============================================================================
;                             Auto Exexcute Section
; ==============================================================================
#IfWinActive
; @AHK++AlignAssignmentOn
global screen_width  := 1920
global screen_height := 1050
global pos_x         :=
global pos_y         :=
global alignment     := 80
global window_width  :=
global window_height :=
global ini_file      := "tiler.ini"
global dock_left     :=
global dock_right    :=
global dock_up       :=
global dock_down     :=
; @AHK++AlignAssignmentOff
CoordMode, ToolTip, Screen
CoordMode, Mouse, Screen
Init()
Return
; ==============================================================================
;                                     Init
; ==============================================================================
Init()
{
    ReadConfig(ini_file)

    If (!FileExist(ini_file))
        WriteConfig(ini_file)

}
; ==============================================================================
;                                  Load Config
; ==============================================================================
ReadConfig(ini_file)
{
    IniRead, alignment, %ini_file%, settings, alignment, %alignment%

    SysGet, mon, MonitorWorkArea
    ; IniRead, OutputVar, Filename, Section, Key [, Default]
    IniRead, screen_width, %ini_file%, settings, screen_width, %monRight%
    IniRead, screen_height, %ini_file%, settings, screen_height, %monBottom%

    IniRead, dock_left, %ini_file%, settings, dock_left, #a
    IniRead, dock_right, %ini_file%, settings, dock_right, #s
    IniRead, dock_up, %ini_file%, settings, dock_up, #w
    IniRead, dock_down, %ini_file%, settings, dock_down, #r

    Hotkey, IfWinActive
    Hotkey, %dock_left%, DockLeft
    Hotkey, %dock_right%, DockRight
    Hotkey, %dock_up%, DockUp
    Hotkey, %dock_down%, DockDown
    Hotkey, +%dock_left%, DockLeftReverse
    Hotkey, +%dock_right%, DockRightReverse
}
; ==============================================================================
;                                 Write Config
; ==============================================================================
WriteConfig(ini_file)
{
    ; IniWrite, Value, Filename, Section, Key
    IniWrite, %alignment%, %ini_file%, settings, alignment
    IniWrite, %screen_width%, %ini_file%, settings, screen_width
    IniWrite, %screen_height%, %ini_file%, settings, screen_height
    IniWrite, %dock_left%, %ini_file%, settings, dock_left
    IniWrite, %dock_right%, %ini_file%, settings, dock_right
    IniWrite, %dock_up%, %ini_file%, settings, dock_up
    IniWrite, %dock_down%, %ini_file%, settings, dock_down
}
; ==============================================================================
;                                      GUI
; ==============================================================================
DockerGUI:
    WinGet, win_id, ID, A
    Update(win_id)

    Gui, Destroy
    InputBox, alignment, Alignment, Alignment, , , , , , , , %alignment%

    ; IniWrite, Value, Filename, Section, Key
    IniWrite, %alignment%, %ini_file%, settings, alignment
Return
; ==============================================================================
;                                Remove ToolTip
; ==============================================================================
RemoveToolTip:
    ToolTip
return
; ==============================================================================
;                                    Update
; ==============================================================================
Update(win_id)
{
    WinGet, is_maximized, MinMax, ahk_id %win_id%
    if (is_maximized)
        WinRestore, A

    WinGetPos, pos_x, pos_y, window_width, window_height, ahk_id %win_id%
    WinGet, title, ProcessName, ahk_id %win_id%

    ; @AHK++AlignAssignmentOn
    global left_offset := 7
    global top_offset  := 7
    global min_width   := 320 ; alignment * Round((screen_width / min_width_factor) / alignment)
    ; @AHK++AlignAssignmentOff

    ; Program specifics
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
;                                 Dock Function
; ==============================================================================
Dock(x, y, width, height)
{
    ;@AHK++AlignAssignmentOn
    global left_offset
    global top_offset
    win_left   := x + left_offset
    win_width  := width - left_offset * 2
    win_height := height - top_offset
    tooltip_x  := x + left_offset
    ; win_right := x + window_width + left_offset
    ;@AHK++AlignAssignmentOff

    If (win_left == 0)
        tooltip_x := x + win_width

    ToolTip, % Round(win_width) . "x" . Round(win_height) . "`nx: "
        . Round(win_left) . " y: " Round(y), tooltip_x, y

    SetTimer, RemoveTooltip, -1000

    WinMove, A, , x, y, width, height, ,
}
; ==============================================================================
;                                  Align Width
; ==============================================================================
AlignWidth(resize)
{
    global left_offset
    global alignment
    global min_width
    global screen_width
    global window_width
    win_width := window_width - left_offset * 2

    ; Undersize left
    If (win_width == min_width && resize < 0)
        new_width := screen_width
    ; Undersize right
    Else If (win_width - alignment < min_width && resize < 0)
        new_width := min_width
    ; Oversize
    Else If (win_width >= screen_width && resize > 0)
        new_width := min_width
    ; Resize
    Else
        new_width := Round(win_width / alignment + resize) * alignment

    Return new_width + left_offset * 2
}
; ==============================================================================
;                                     Left
; ==============================================================================
DockLeft:
    WinGet, win_id, ID, A
    Update(win_id)
    ; Resize if the window is already docked to the left.
    If (pos_x == -left_offset && (pos_y == 0 || pos_y + window_height - top_offset == screen_height))
        new_width := AlignWidth(-1)

    ; Otherwise, place it on the left, resize it to the nearest alignment, and
    ; stretch it vertically if it's over half the screen height.
    Else
    {
        new_width := AlignWidth(0)

        If (window_height - top_offset <= screen_height / 2)
        {
            window_height := (screen_height / 2 + top_offset)
            If (pos_y >= screen_height * 0.25)
                pos_y := (screen_height / 2)
            Else
                pos_y := 0
        }
        Else
        {
            window_height := screen_height + top_offset
            pos_y := 0
        }
    }
    Dock(-left_offset, pos_y, new_width, window_height)
Return
; ==============================================================================
;                                 Left Reverse
; ==============================================================================
DockLeftReverse:
    WinGet, win_id, ID, A
    Update(win_id)
    If (pos_x == -left_offset && (pos_y == 0 || pos_y + window_height - top_offset == screen_height))
        new_width := AlignWidth(1)
    Else
    {
        new_width := AlignWidth(0)

        If (window_height - top_offset <= screen_height / 2)
        {
            window_height := (screen_height / 2 + top_offset)
            If (pos_y >= screen_height * 0.25)
                pos_y := (screen_height / 2)
            Else
                pos_y := 0
        }
        Else
        {
            window_height := screen_height + top_offset
            pos_y := 0
        }
    }
    Dock(-left_offset, pos_y, new_width, window_height)
Return
; ==============================================================================
;                                     Right
; ==============================================================================
DockRight:
    WinGet, win_id, ID, A
    Update(win_id)
    If (pos_x == screen_width - window_width + left_offset && (pos_y == 0 || pos_y + window_height - top_offset == screen_height))
        new_width := AlignWidth(-1)
    Else
    {
        new_width := AlignWidth(0)

        If (window_height - top_offset <= screen_height / 2)
        {
            window_height := (screen_height / 2 + top_offset)
            If (pos_y >= screen_height * 0.25)
                pos_y := (screen_height / 2)
            Else
                pos_y := 0
        }
        Else
        {
            window_height := screen_height + top_offset
            pos_y := 0
        }
    }
    Dock(screen_width - new_width + left_offset, pos_y, new_width, window_height)
Return
; ==============================================================================
;                             Right Reverse
; ==============================================================================
DockRightReverse:
    WinGet, win_id, ID, A
    Update(win_id)
    If (pos_x == screen_width - window_width + left_offset && (pos_y == 0 || pos_y + window_height - top_offset == screen_height))
        new_width := AlignWidth(1)
    Else
    {
        new_width := AlignWidth(0)

        If (window_height - top_offset <= screen_height / 2)
        {
            window_height := (screen_height / 2 + top_offset)
            If (pos_y >= screen_height * 0.25)
                pos_y := (screen_height / 2)
            Else
                pos_y := 0
        }
        Else
        {
            window_height := screen_height + top_offset
            pos_y := 0
        }
    }

    Dock(screen_width - new_width + left_offset, pos_y, new_width, window_height)
Return
; ==============================================================================
;                                      Up
; ==============================================================================
DockUp:
    WinGet, win_id, ID, A
    Update(win_id)

    If (window_height < screen_height)
        Dock(pos_x, 0, window_width, screen_height + top_offset)
    Else
        Dock(pos_x, 0, window_width, (window_height / 2 + top_offset / 2))
Return
; ==============================================================================
;                                     Down
; ==============================================================================
DockDown:
    WinGet, win_id, ID, A
    Update(win_id)

    If (window_height < screen_height)
        Dock(pos_x, 0, window_width, screen_height + top_offset)
    Else
        Dock(pos_x, screen_height / 2, window_width, (screen_height / 2 + top_offset))
Return
; ==============================================================================
;                                   Top-Left
; ==============================================================================
#q::
    WinGet, win_id, ID, A
    Update(win_id)
    Dock(-left_offset, 0, window_width, window_height)
Return
; ==============================================================================
;                                   Top-Right
; ==============================================================================
#f::
    WinGet, win_id, ID, A
    Update(win_id)
    Dock(screen_width - window_width + left_offset, 0, window_width, window_height)
Return
; ==============================================================================
;                                   Bottom-Left
; ==============================================================================
#z::
    WinGet, win_id, ID, A
    Update(win_id)
    Dock(-left_offset, screen_height - window_height + top_offset, window_width, window_height)
Return
; ==============================================================================
;                                   Bottom-Right
; ==============================================================================
#c::
    WinGet, win_id, ID, A
    Update(win_id)
    Dock(screen_width - window_width + left_offset, screen_height - window_height + top_offset, window_width, window_height)
Return
; ==============================================================================
;                                 Minimum Size
; ==============================================================================
MinSize:
    WinGet, win_id, ID, A
    Update(win_id)
    Dock(pos_x, pos_y, 1, 1)
Return
; ==============================================================================
;                                Move Along Grid
; ==============================================================================
#x::
MoveAlongGrid:
    WinGet, win_id, ID, A
    Update(win_id)
    ;@AHK++AlignAssignmentOn
    cells := screen_width / alignment
    index := (pos_x + left_offset) / (screen_width / cells)
    ;@AHK++AlignAssignmentOff

    If (window_height - top_offset <= screen_height / 2)
    {
        If (pos_y < screen_height * 0.25)
            pos_y := 0
        Else
            pos_y := (screen_height / 2)
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
+#x::
MoveAlongGridReverse:
    WinGet, win_id, ID, A
    Update(win_id)
    ;@AHK++AlignAssignmentOn
    cells := screen_width / alignment
    index := (pos_x + left_offset) / (screen_width / cells)
    ;@AHK++AlignAssignmentOff

    If (window_height - top_offset <= screen_height / 2)
    {
        If (pos_y < screen_height * 0.25)
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
    WinGet, win_id, ID, A
    Update(win_id)
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
    WinGet, win_id, ID, A
    Update(win_id)
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
;                              Jump to Next Window
; ==============================================================================
; JumpRight:
;     WinGet, win_id, ID, A
;     Update(win_id)
;     SetTitleMatchMode Regex
;     WinGet, win_handles, List, .+, , Start Menu|Program Manager|Chrome|Code|Hotkeys|Window Spy|RetroArch

;     positions := []
;     Loop, %win_handles%
;     {
;         Update(win_handles%A_Index%)

;         ;@AHK++AlignAssignmentOn
;         win_left  := pos_x + left_offset
;         win_right := pos_x + window_width - left_offset
;         win_top   := pos_y
;         win_bot   := pos_y + window_height - left_offset
;         ;@AHK++AlignAssignmentOff

;         positions.Push(win_left)
;         positions.Push(win_right)
;         positions.Push(win_top)
;         positions.Push(win_bot)
;     }
;     Loop, % positions.Length() / 4
;     {
;         MsgBox, % positions[((A_Index - 1) * 4 + 0) + 1]
;             . "`n" . positions[((A_Index - 1) * 4 + 1) + 1]
;             . "`n" . positions[((A_Index - 1) * 4 + 2) + 1]
;             . "`n" . positions[((A_Index - 1) * 4 + 3) + 1]
;     }
;     SetTitleMatchMode 1
; Return
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
