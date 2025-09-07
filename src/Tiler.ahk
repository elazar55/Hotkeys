; ==============================================================================
;                                     To Do
; ==============================================================================
/*
* Dock by mouse edge screen.
*/

; ==============================================================================
;                             Auto Exexcute Section
; ==============================================================================
#IfWinActive
; @AHK++AlignAssignmentOn
; Defaults
global screen_width  := 1920
global screen_height := 1050
global left_offset   := 3
global top_offset    := 3
global alignment     := 80
global dock_left     := "#a"
global dock_right    := "#s"
global dock_up       := "#w"
global dock_down     := "#r"
global rows          := 2
global cols          := 3
global ini_file      := "tiler.ini"
global min_width     := 320
global factors       :=
global stackables    :=
; Window attributes
global pos_x         :=
global pos_y         :=
global window_width  :=
global window_height :=
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
    If (!FileExist(ini_file))
        WriteConfig()

    ReadConfig(ini_file)
    factors := FactorizeAlignment()

    SetTitleMatchMode Regex
    Loop, Parse, stackables, %A_Space%
    {
        GroupAdd, stackables, ahk_class %A_LoopField%
    }
    SetTitleMatchMode 1
}
; ==============================================================================
;                                  Load Config
; ==============================================================================
ReadConfig(ini_file)
{
    IniRead, alignment, %ini_file%, settings, alignment, %alignment%

    SysGet, mon, MonitorWorkArea
    IniRead, screen_width, %ini_file%, settings, screen_width, %monRight%
    IniRead, screen_height, %ini_file%, settings, screen_height, %monBottom%

    IniRead, left_offset, %ini_file%, settings, left_offset, %left_offset%
    IniRead, top_offset, %ini_file%, settings, top_offset, %top_offset%
    IniRead, min_width, %ini_file%, settings, min_width, %min_width%

    IniRead, dock_left, %ini_file%, settings, dock_left, #a
    IniRead, dock_right, %ini_file%, settings, dock_right, #s
    IniRead, dock_up, %ini_file%, settings, dock_up, #w
    IniRead, dock_down, %ini_file%, settings, dock_down, #r

    IniRead, rows, %ini_file%, settings, rows
    IniRead, cols, %ini_file%, settings, cols
    IniRead, stackables, %ini_file%, settings, stackables

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
WriteConfig()
{
    Gui, Submit
    IniWrite, %alignment%, %ini_file%, settings, alignment
    IniWrite, %screen_width%, %ini_file%, settings, screen_width
    IniWrite, %screen_height%, %ini_file%, settings, screen_height

    IniWrite, %left_offset%, %ini_file%, settings, left_offset
    IniWrite, %top_offset%, %ini_file%, settings, top_offset
    IniWrite, %min_width%, %ini_file%, settings, min_width

    IniWrite, %dock_left%, %ini_file%, settings, dock_left
    IniWrite, %dock_right%, %ini_file%, settings, dock_right
    IniWrite, %dock_up%, %ini_file%, settings, dock_up
    IniWrite, %dock_down%, %ini_file%, settings, dock_down

    IniWrite, %rows%, %ini_file%, settings, rows
    IniWrite, %cols%, %ini_file%, settings, cols
    IniWrite, %stackables%, %ini_file%, settings, stackables
}
; ==============================================================================
;                              FactorizeAlignment
; ==============================================================================
FactorizeAlignment()
{
    factors := 0
    Loop
    {
        If (Mod(screen_width, A_Index) == 0)
        {
            factors .= "|" . A_Index . "|" . Round(screen_width / A_Index)
        }
    } Until A_Index >= Sqrt(screen_width)

    Sort, factors, D| N
    Return factors
}
; ==============================================================================
;                                   FindIndex
; ==============================================================================
FindIndex()
{
    Loop, Parse, factors, |
        If (alignment == A_LoopField)
            Return A_Index
}
; ==============================================================================
;                                      GUI
; ==============================================================================
DockerGUI:
    Gui, Destroy
    width := 100
    padding := 4

    idx := FindIndex()
    Gui, Add, DDL, W%width% Valignment Choose%idx%, %factors%
    Gui, Add, Text, % "XP+" . width + padding . " YP+4", Alignment

    Gui, Add, Edit, W%width% Vrows X8, %rows%
    Gui, Add, Text, % "XP+" . width + padding . " YP+4", Rows

    Gui, Add, Edit, W%width% Vcols X8, %cols%
    Gui, Add, Text, % "XP+" . width + padding . " YP+4", Columns

    Gui, Add, Button, Default W%width% X8 GWriteConfig, Submit

    WinGet, exe_name, ProcessName, A
    WinGet, win_id, ID, A
    Update(win_id)

    Gui, Add, Edit, W%width% Vexe_name X8, %exe_name%
    Gui, Add, Text, % "XP+" . width + padding . " YP+4", exe_name

    Gui, Add, Edit, W%width% Vleft_offset X8, %left_offset%
    Gui, Add, Text, % "XP+" . width + padding . " YP+4", left_offset

    Gui, Add, Edit, W%width% Vtop_offset X8, %top_offset%
    Gui, Add, Text, % "XP+" . width + padding . " YP+4", top_offset

    Gui, Add, Edit, W%width% Vmin_width X8, %min_width%
    Gui, Add, Text, % "XP+" . width + padding . " YP+4", min_width

    Gui, Add, Button, Default W%width% X8 GAddExe, Add exe
    Gui, Add, Button, Default W%width% X8 GRemoveExe, Remove exe

    Gui, +DelimiterSpace
    Gui, Add, DDL, W%width% Choose1, %stackables%
    Gui, Add, Text, % "XP+" . width + padding . " YP+4", Stackables

    Gui, Show
Return

AddExe:
    Gui, Submit
    If (Trim(left_offset) != "")
        IniWrite, %left_offset%, %ini_file%, %exe_name%, left_offset
    If (Trim(top_offset) != "")
        IniWrite, %top_offset%, %ini_file%, %exe_name%, top_offset
    If (Trim(min_width) != "")
        IniWrite, %min_width%, %ini_file%, %exe_name%, min_width
Return

RemoveExe:
    Gui, Submit
    IniDelete, %ini_file%, %exe_name%
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
    WinGetPos, pos_x, pos_y, window_width, window_height, ahk_id %win_id%
    WinGet, proc_name, ProcessName, ahk_id %win_id%

    IniRead, left_offset_default, %ini_file%, settings, left_offset
    IniRead, top_offset_default, %ini_file%, settings, top_offset
    IniRead, min_width_default, %ini_file%, settings, min_width

    IniRead, left_offset, %ini_file%, %proc_name%, left_offset, %left_offset_default%
    IniRead, top_offset, %ini_file%, %proc_name%, top_offset, %top_offset_default%
    IniRead, min_width, %ini_file%, %proc_name%, min_width, %min_width_default%

    global window_width -= left_offset * 2
}
; ==============================================================================
;                                 Dock Function
; ==============================================================================
Dock(x, y, width, height, id := "A")
{
    WinGet, is_maximized, MinMax, %id%
    if (is_maximized)
        WinRestore, %id%

    ;@AHK++AlignAssignmentOn
    global left_offset
    global top_offset
    win_left   := x + left_offset
    win_height := height - top_offset
    tooltip_x  := x + left_offset
    ;@AHK++AlignAssignmentOff

    If (win_left == 0)
        tooltip_x := x + width

    ToolTip, % width . "x" . Round(win_height) . "`nx: "
        . Round(win_left) . " y: " Round(y), tooltip_x, y

    SetTimer, RemoveTooltip, -1000

    WinMove, %id%, , x, y, width + left_offset * 2, height, ,
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

    ; Undersize left
    If (window_width == min_width && resize < 0)
        new_width := screen_width
    ; Undersize right
    Else If (window_width - alignment < min_width && resize < 0)
        new_width := min_width
    ; Oversize
    Else If (window_width >= screen_width && resize > 0)
        new_width := min_width
    ; Resize
    Else
        new_width := Round(window_width / alignment + resize) * alignment

    Return new_width
}
; ==============================================================================
;                                     Left
; ==============================================================================
Left(direction)
{
    WinGet, win_id, ID, A
    Update(win_id)
    ; Resize if the window is already docked to the left.
    If (pos_x == -left_offset && (pos_y == 0 || pos_y + window_height - top_offset == screen_height))
        new_width := AlignWidth(direction)
    ; Otherwise, place it on the left, resize it to the nearest alignment, and
    ; stretch it vertically if it's over half the screen height.
    Else
    {
        new_width := AlignWidth(0)
        {
            window_height := screen_height + top_offset
            pos_y := 0
        }
    }
    Dock(-left_offset, pos_y, new_width, window_height)
}
DockLeft:
    Left(-1)
Return
DockLeftReverse:
    Left(1)
Return
; ==============================================================================
;                                     Right
; ==============================================================================
Right(direction)
{
    WinGet, win_id, ID, A
    Update(win_id)
    If (pos_x + left_offset == screen_width - window_width && (pos_y == 0 || pos_y + window_height - top_offset == screen_height))
        new_width := AlignWidth(direction)
    Else
    {
        new_width := AlignWidth(0)
        {
            window_height := screen_height + top_offset
            pos_y := 0
        }
    }
    Dock(screen_width - new_width - left_offset, pos_y, new_width, window_height)
}
DockRight:
    Right(-1)
Return
DockRightReverse:
    Right(1)
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
    Dock(screen_width - window_width - left_offset, 0, window_width, window_height)
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
    Dock(screen_width - window_width - left_offset, screen_height - window_height + top_offset, window_width, window_height)
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
MoveAlongGrid(dir)
{
    WinGet, win_id, ID, A
    Update(win_id)

    ;@AHK++AlignAssignmentOn
    cells := screen_width / (window_width / 2) ; alignment or window_width
    index := (pos_x + left_offset) / (screen_width / cells)
    ;@AHK++AlignAssignmentOff

    If (window_height - top_offset <= screen_height / 2)
    {
        window_height := (screen_height / 2) + top_offset

        If (pos_y < screen_height * 0.25)
            pos_y := 0
        Else
            pos_y := screen_height / 2
    }
    Else
    {
        pos_y := 0
        window_height := screen_height + top_offset
    }

    if (pos_x + left_offset >= screen_width - window_width && dir == 1)
    {
        index := -1

        If (pos_y < screen_height / 2 && window_height - top_offset <= screen_height / 2)
            pos_y := screen_height / 2
        Else
            pos_y := 0
    }
    else if (pos_x + left_offset <= 0 && dir == -1)
    {
        index := cells

        If (pos_y < screen_height / 2 && window_height - top_offset <= screen_height / 2)
            pos_y := screen_height / 2
        Else
            pos_y := 0
    }
    Dock(screen_width * ((Round(index) + dir) / cells) - left_offset, pos_y, window_width, window_height)
}
#x::MoveAlongGrid(1)
+#x::MoveAlongGrid(-1)
; ==============================================================================
;                                    AltJump
; ==============================================================================
#F1::AltJump(1)
AltJump(dir)
{
    SetTitleMatchMode Regex
    WinGet, win_handles, List, .+, , \d+x\d+|Start Menu|Program Manager|Window Spy,
    Update(win_id)
    SetTitleMatchMode 1
    active_left  := pos_x + left_offset
    active_width := window_width

    x_list := []
    Loop, %win_handles%
    {
        id := win_handles%A_Index%
        Update(id)
        WinGetTitle, title, ahk_id %id%
        win_left  := pos_x + left_offset
        win_right := pos_x + left_offset + window_width

        x_list[win_left]                 .= "`n" . title . "`n"
        x_list[win_right]                .= "`n" . title . "`n"
        x_list[win_left - active_width]  .= "`n" . title . "`n"
        x_list[win_right - active_width] .= "`n" . title . "`n"
    }
    For k, v in x_list
    {
        msgbox [%k%] = %v%
    }
}
; ==============================================================================
;                              Snap window to Next Window
; ==============================================================================
Jump(dir)
{
    SetTitleMatchMode Regex
    WinGet, win_handles, List, .+, , \d+x\d+|Start Menu|Program Manager|Window Spy,
    SetTitleMatchMode 1
    WinGet, win_id, ID, A
    Update(win_id)
    active_width := window_width

    x_list :=
    Loop, %win_handles%
    {
        id := win_handles%A_Index%
        If (win_id == id)
            Continue

        WinGet, minmax, MinMax, ahk_id %id%
        If (minmax != 0)
            Continue

        Update(id)
        win_left  := pos_x + left_offset
        win_right := pos_x + left_offset + window_width

        If (win_left < screen_width)
            x_list .= win_left . ","
        If (win_right < screen_width)
            x_list .= win_right . ","
        If (win_left - active_width > 0)
            x_list .= win_left - active_width . ","
        If (win_right - active_width > 0)
            x_list .= win_right - active_width . ","
    }
    x_list := Trim(x_list, ",")
    If (dir == 1)
        Sort, x_list, N U D,
    Else If (dir == -1)
        Sort, x_list, R N U D,
    x_list := StrSplit(x_list, ",")

    WinGet, win_id, ID, A
    Update(win_id)

    For k, v in x_list
    {
        If ((dir == 1 && v > pos_x + left_offset) || (dir == -1 && v < pos_x + left_offset))
        {
            Dock(v - left_offset, pos_y, window_width, window_height)
            Return
        }
    }
    Dock(x_list[1] - left_offset, pos_y, window_width, window_height)
    Return
}
#VKE2::Jump(1)
+#VKE2::Jump(-1)
; ==============================================================================
;                                 Tile Windows
; ==============================================================================
TileWindows:
#t::
    WinGet, win_count, List, ahk_group stackables, ,

    ; @AHK++AlignAssignmentOn
    _rows      := Min(Ceil(win_count / 2), rows)
    columns    := Ceil(win_count / _rows)
    slots      := _rows * columns
    carry      := slots - win_count
    win_width  := (screen_width / columns) + (left_offset * 2)
    win_height := (screen_height / _rows) + (top_offset)
    ; @AHK++AlignAssignmentOff
    Loop, %win_count%
    {
        Update(id)
        ; @AHK++AlignAssignmentOn
        id      := win_count%A_Index%
        x_index := Floor((A_Index - 1) / _rows)
        y_index := Mod(A_Index - 1, _rows)
        x_pos   := ((win_width - left_offset * 2) * x_index) - left_offset
        y_pos   := (win_height - top_offset) * y_index
        ; @AHK++AlignAssignmentOff

        If (carry && A_Index = win_count)
            win_height := ((screen_height / _rows) * (carry + 1)) + (top_offset)

        WinActivate, ahk_id %id%
        Dock(x_pos, y_pos, win_width - left_offset * 2, win_height, "ahk_id" . " " . id)
    }

Return
; ==============================================================================
;                                 Grid Windows
; ==============================================================================
GridWindows:
#g::
    WinGet, win_count, List, ahk_group stackables, ,

    ; @AHK++AlignAssignmentOna
    win_width  := (screen_width / cols) + (left_offset * 2)
    win_height := (screen_height / rows) + (top_offset)
    ; @AHK++AlignAssignmentOff

    Loop, %win_count%
    {
        ; @AHK++AlignAssignmentOn
        Update(id)
        id      := win_count%A_Index%
        x_index := Floor((A_Index - 1) / rows)
        y_index := Mod(A_Index - 1, rows)
        x_pos   := ((win_width - left_offset * 2) * x_index) - left_offset
        y_pos   := (win_height - top_offset) * y_index
        ; @AHK++AlignAssignmentOffa

        WinActivate, ahk_id %id%
        Dock(x_pos, y_pos, win_width - left_offset * 2, win_height)
        Send, ^{NumpadAdd} ; Size columns to fit.
    }
Return
