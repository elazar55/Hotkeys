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
