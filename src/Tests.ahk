; ==============================================================================
;                                  Regex Tool
; ==============================================================================
RegexTool:
    Gui, Destroy
    Gui, Add, Edit, vmyText w960 gChangeText,
    Gui, Add, Edit, voutput w960,
    Gui, Show
Return

ChangeText:
    Gui, Submit, NoHide
    ; myText := RegExReplace(myText, "\b(\w+)\b(?=.*?\b\1\b)")
    ; myText := RegExReplace(myText, "\s{2,}", " ")
    ; myText := RegExReplace(myText, "\s+,", ",")
    ; myText := RegExReplace(myText, "\s+\.", ".")
    ; myText := RegExReplace(myText, ",\.", ".")
    ; myText := Trim(myText, " ,-")

    match_pos := 1
    dupes :=
    While (match_pos := RegExMatch(myText, "\b(\w+)\b(?=.*?\b\1\b)", match, match_pos + StrLen(match)))
    {
        dupes := match . " " . dupes
    }
    GuiControl,, output, % dupes
Return
; ==============================================================================
;                                 Barcode Mode
; ==============================================================================
barcodeMode := false
#If, %barcodeMode%
f::e
p::r
g::t
j::y
l::u
u::i
y::o
`;::p
r::s
s::d
t::f
d::g
n::j
e::k
i::l
o::`;
k::n
#If
; ==============================================================================
;                                Write Clone Games
; ==============================================================================
FBClones:
    SetBatchLines, -1
    datFile := "W:\Games\fbneo\FBNeoDatafile.dat"

    FileDelete, clones.txt

    Loop, Read, %datFile%, clones.txt
    {
        if (RegExMatch(A_LoopReadLine, "game name=""(.+?)""\s?cloneof=""(.+?)""", match))
            FileAppend, %match1%.zip`n
    }
    Beep(1200, 20)
    SetBatchLines, 1
; ==============================================================================
;                                New C++ Project
; ==============================================================================
NewCppProject:

    InputBox, title,,,,,,,,,
    FileSelectFolder, selectedFolder,, 3

    If (ErrorLevel)
        Return

    FileCreateDir, %selectedFolder%/%title%/src
    FileCreateDir, %selectedFolder%/%title%/build

    FileCopy, ../res/CPPBoilerPlate.cpp, %selectedFolder%/%title%/src/Main.cpp
    FileCopy, ../res/makefile, %selectedFolder%/%title%

Return
; ==============================================================================
;                              Triple click paste
; ==============================================================================
#v::
    Send, {LButton}
    Send, {LButton}
    Send, {LButton}
    Send, ^v
Return
; ==============================================================================
;                               Double click copy
; ==============================================================================
#c::
    Send, {LButton}
    Send, {LButton}
    Send, ^c
Return
; ==============================================================================
;                             Repeat tab then space
; ==============================================================================
#Space::
    delay = 100

    while (GetKeyState("Space", "p") AND GetKeyState("LWin", "p"))
    {
        Send, {Tab}
        Sleep, %delay%
        Send, {Space}
        Sleep, %delay%
    }
Return
; ==============================================================================

; ==============================================================================
#c::
    SetBatchLines, -1
    developers := []
    publishers := []

    FileRead, file_as_string, Games.csv
    StrReplace(file_as_string, "`n", "`n", num_lines)
    file_as_string := StrReplace(file_as_string, """", "")

    Gui, Add, Text, w500 h50 vtext, 0 / %num_lines%
    Gui, Add, Progress, w500 h20 Range0-%num_lines% vprogress_value
    Gui, show

    Loop, Parse, file_as_string, `n, `r
    {
        RegExMatch(A_LoopField, "(.+),(.*),(.*)", match)
        developers.Push(match2)
        publishers.Push(match3)

        GuiControl, , text, %match1%`n%match2%`n%match3%`n%A_Index%/%num_lines%
        GuiControl, , progress_value, %A_Index%
    }
    Gui, Destroy
    SetBatchLines, 1
Return
; ------------------------------------------------------------------------------

; ------------------------------------------------------------------------------
#d::
    SetBatchLines, -1
    Titles :=
    devs :=
    publishers :=

    Loop, Read, Games.csv
    {
        RegExMatch(A_LoopReadLine, "O)(?:("".+?"")|(.+?)),(?:("".*?"")|(.*?)),(?:("".*"")|(.*))", match)
        Loop, % match.Count()
        {
            If (match.Value(A_Index) == "")
                Continue

            matched := Trim(match.Value(A_Index), """")
            matched := Trim(matched, " ")

            If (A_Index >= 5)
            {
                Loop, Parse, matched, CSV, " "
                {
                    varname := RegExReplace(A_LoopField, "[^a-zA-Z0-9]", "_")
                    If (!InStr(publishers, varname))
                        publishers := publishers . varname . "`n"
                    %varname%++
                }
                Continue
            }
            If (A_Index >= 3)
            {
                Loop, Parse, matched, CSV, " "
                {
                    varname := RegExReplace(A_LoopField, "[^a-zA-Z0-9]", "_")
                    If (!InStr(devs, varname))
                        devs := devs . varname . "`n"
                    %varname%++
                }
            }
            ; MsgBox, % matched
        }
    }
    publishers := StrReplace(publishers, ",", "`n")
    FileDelete, devs.txt
    FileDelete, publishers.txt
    ; FileAppend, %devs%, devs.txt
    ; FileAppend, %publishers%, publishers.txt
    Loop, Parse, devs, `n
    {
        FileAppend, % %A_LoopField% . "`t" . A_LoopField . "`n", devs.txt
    }
    Loop, Parse, publishers, `n
    {
        FileAppend, % %A_LoopField% . "`t" . A_LoopField . "`n", publishers.txt
    }
    Beep(1200, 25)
    SetBatchLines, 1
Return
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
