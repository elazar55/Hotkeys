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
global screen_width  := 1920
global screen_height := 1050
global pos_x         :=
global pos_y         :=
global left_offset   := 3
global top_offset    := 3
global alignment     := 80
global window_width  :=
global window_height :=
global ini_file      := "tiler.ini"
global dock_left     := "#a"
global dock_right    := "#s"
global dock_up       := "#w"
global dock_down     := "#r"
global rows          := 2
global cols          := 3
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
        WriteNewConfig(ini_file)

    ReadConfig(ini_file)
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

    IniRead, left_offset, %ini_file%, settings, left_offset, 3
    IniRead, top_offset, %ini_file%, settings, top_offset, 3

    IniRead, dock_left, %ini_file%, settings, dock_left, #a
    IniRead, dock_right, %ini_file%, settings, dock_right, #s
    IniRead, dock_up, %ini_file%, settings, dock_up, #w
    IniRead, dock_down, %ini_file%, settings, dock_down, #r

    IniRead, rows, %ini_file%, settings, rows
    IniRead, cols, %ini_file%, settings, cols

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
WriteNewConfig(ini_file)
{
    ; IniWrite, ${Value}, ${Filename}, ${Section}, ${Key}
    IniWrite, %alignment%, %ini_file%, settings, alignment
    IniWrite, %screen_width%, %ini_file%, settings, screen_width
    IniWrite, %screen_height%, %ini_file%, settings, screen_height

    IniWrite, %left_offset%, %ini_file%, settings, left_offset
    IniWrite, %top_offset%, %ini_file%, settings, top_offset

    IniWrite, %dock_left%, %ini_file%, settings, dock_left
    IniWrite, %dock_right%, %ini_file%, settings, dock_right
    IniWrite, %dock_up%, %ini_file%, settings, dock_up
    IniWrite, %dock_down%, %ini_file%, settings, dock_down

    IniWrite, %rows%, %ini_file%, settings, rows
    IniWrite, %cols%, %ini_file%, settings, cols
}
; ==============================================================================
;                                      GUI
; ==============================================================================
DockerGUI:
    WinGet, win_id, ID, A
    Update(win_id)
    Gui, Destroy

    factors := 0
    Loop
    {
        If (Mod(screen_width, A_Index) == 0)
        {
            factors .= "|" . A_Index . "|" . Round(screen_width / A_Index)
        }
    } Until A_Index >= Sqrt(screen_width)

    Sort, factors, D| N
    factors = %alignment%|%factors%

    Gui, Add, DDL, W64 Valignment Choose1, %factors%
    Gui, Add, Text, XP+68 YP+4, Alignment
    Gui, Add, Edit, W64 Vrows X8, %rows%
    Gui, Add, Text, XP+68 YP+4, Rows
    Gui, Add, Edit, W64 Vcols X8, %cols%
    Gui, Add, Text, XP+68 YP+4, Columns
    Gui, Add, Button, W64 X8 GSubmitAll, Submit

    Gui, Show
Return

SubmitAll:
    Gui, Submit
    IniWrite, %rows%, %ini_file%, settings, rows
    IniWrite, %cols%, %ini_file%, settings, cols
    IniWrite, %alignment%, %ini_file%, settings, alignment
Return

SubmitAlignment:
    Gui, Submit
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
    ; WinGet, is_maximized, MinMax, ahk_id %win_id%
    ; if (is_maximized)
    ;     WinRestore, A

    WinGetPos, pos_x, pos_y, window_width, window_height, ahk_id %win_id%
    WinGet, title, ProcessName, ahk_id %win_id%

    IniRead, left_offset, %ini_file%, settings, left_offset, 3
    IniRead, top_offset, %ini_file%, settings, top_offset, 3
    global min_width := 320

    ; Program specifics
    If (RegExMatch(title, "(Code.exe)|(Playnite.*.exe)"))
    {
        ; @AHK++AlignAssignmentOn
        global left_offset := 0
        global top_offset  := 0
        global min_width   := 400
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

    global window_width := window_width - left_offset * 2
}
; ==============================================================================
;                                 Dock Function
; ==============================================================================
Dock(x, y, width, height, id := "A")
{
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
    If (pos_x + left_offset == screen_width - window_width && (pos_y == 0 || pos_y + window_height - top_offset == screen_height))
        new_width := AlignWidth(-1)
    Else
    {
        new_width := AlignWidth(0)
        {
            window_height := screen_height + top_offset
            pos_y := 0
        }
    }
    Dock(screen_width - new_width - left_offset, pos_y, new_width, window_height)
Return
; ==============================================================================
;                             Right Reverse
; ==============================================================================
DockRightReverse:
    WinGet, win_id, ID, A
    Update(win_id)
    If (pos_x + left_offset == screen_width - window_width && (pos_y == 0 || pos_y + window_height - top_offset == screen_height))
        new_width := AlignWidth(1)
    Else
    {
        new_width := AlignWidth(0)
        {
            window_height := screen_height + top_offset
            pos_y := 0
        }
    }

    Dock(screen_width - new_width - left_offset, pos_y, new_width, window_height)
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
    cells := screen_width / (alignment)
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

    ; MsgBox, % pos_x + left_offset
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
    Dock(screen_width * ((Floor(index) + dir) / cells) - left_offset, pos_y, window_width, window_height)
}
#x::MoveAlongGrid(1)
+#x::MoveAlongGrid(-1)
; ==============================================================================
;                              Snap window to Next Window
; ==============================================================================
Jump:
#F1::
    WinGet, win_id, ID, A
    Update(win_id)

    _x := pos_x
    _y := pos_y
    _id := win_id
    _w := window_width
    _h := window_height
    _left_off := left_offset
    _top_off := top_offset

    SetTitleMatchMode Regex
    WinGet, win_handles, List, .+, , \d+x\d+|Start Menu|Program Manager|Window Spy,

    x_list :=
    Loop, %win_handles%
    {
        id := win_handles%A_Index%
        If (id == _id)
            Continue

        WinGet, minmax, MinMax, ahk_id %id%
        If (minmax != 0)
            Continue

        ; WinGet, proc_name, ProcessName, ahk_id %id%
        ; WinGetTitle, title, ahk_id %id%
        ; MsgBox, % title . " -> " . pos_x + left_offset . "," . pos_x + window_width + left_offset

        Update(id)
        x_list .= pos_x + left_offset . "," . pos_x + window_width + left_offset . ","
    }
    x_list := Trim(x_list, ",")
    Sort, x_list, N U D,
    ; MsgBox, %x_list%
    x_list := StrSplit(x_list, ",")

    For k, v in x_list
    {
        If (v >= screen_width)
            Break

        If (v - (_x + _left_off) > 0)
        {
            Dock(v - _left_off, _y, _w, _h)
            SetTitleMatchMode 1
            Return
        }
    }
    Dock(0 - _left_off, _y, _w, _h)
    SetTitleMatchMode 1
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
; ==============================================================================
;                                 Tile Windows
; ==============================================================================
TileWindows:
#t::
    Gui, Destroy
    SetTitleMatchMode Regex
    WinGet, window_count, List, ahk_class CabinetWClass, , Start Menu|Program Manager|Chrome|Thorium|Code|Hotkeys|Window Spy|RetroArch

    ; @AHK++AlignAssignmentOn
    rows       := Min(Ceil(window_count / 2), rows)
    columns    := Ceil(window_count / rows)
    slots      := rows * columns
    carry      := slots - window_count
    win_width  := (screen_width / columns) + (left_offset * 2)
    win_height := (screen_height / rows) + (top_offset)
    ; @AHK++AlignAssignmentOff

    Loop, %window_count%
    {
        ; @AHK++AlignAssignmentOn
        id      := window_count%A_Index%
        x_index := Floor((A_Index - 1) / rows)
        y_index := Mod(A_Index - 1, rows)
        x_pos   := ((win_width - left_offset * 2) * x_index) - left_offset
        y_pos   := (win_height - top_offset) * y_index
        ; @AHK++AlignAssignmentOff
        Update(id)

        If (carry && A_Index = window_count)
            win_height := ((screen_height / rows) * (carry + 1)) + (top_offset)

        WinActivate, ahk_id %id%
        ; WinMove, ahk_id %id%,, x_pos, y_pos, win_width, win_height
        Dock(x_pos, y_pos, win_width - left_offset * 2, win_height)
        ; MsgBox, X: %x_index%`nY: %y_index%
    }

    SetTitleMatchMode 1
Return
; ==============================================================================
;                                 Grid Windows
; ==============================================================================
GridWindows:
#g::
    Gui, Destroy
    SetTitleMatchMode Regex
    WinGet, window_count, List, ahk_class CabinetWClass, , Start Menu|Program Manager|Chrome|Code|Hotkeys|Window Spy|RetroArch

    ; @AHK++AlignAssignmentOna
    win_width  := (screen_width / cols) + (left_offset * 2)
    win_height := (screen_height / rows) + (top_offset)
    ; @AHK++AlignAssignmentOff

    Loop, %window_count%
    {
        Update(id)
        ; @AHK++AlignAssignmentOn
        id      := window_count%A_Index%
        x_index := Floor((A_Index - 1) / rows)
        y_index := Mod(A_Index - 1, rows)
        x_pos   := ((win_width - left_offset * 2) * x_index) - left_offset
        y_pos   := (win_height - top_offset) * y_index
        ; @AHK++AlignAssignmentOff

        WinActivate, ahk_id %id%
        ; WinMove, ahk_id %id%,, x_pos, y_pos, win_width, win_height
        Dock(x_pos, y_pos, win_width - left_offset * 2, win_height)
    }
    SetTitleMatchMode 1
Return
