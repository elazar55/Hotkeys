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
