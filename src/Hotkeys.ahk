; ==============================================================================
;                             Auto Exexcute section
; ==============================================================================
; Script attributes
#NoEnv
#SingleInstance, Force
SetTitleMatchMode, 2
SetBatchLines, 1
SendMode, Event

; Excluded windows
GroupAdd, excluded_windows, ahk_exe code.exe
GroupAdd, excluded_windows, ahk_exe cmd.exe
GroupAdd, excluded_windows, ahk_exe mintty.exe

; Included files will auto execute as well
#Include, Fez.ahk
#Include, Hearthstone.ahk
#Include, Helpers.ahk
#Include, Misc.ahk
#Include, PicrossTouch.ahk
#Include, Scraper.ahk
#Include, Tiler.ahk

; Unset due to includes setting it
#IfWinActive
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
;                                      GUI
; ==============================================================================
#m::
    Gui, Destroy
    ; Gui, +AlwaysOnTop
    Gui, Add, Button, W320 GScrape, Scrape
    Gui, Add, Button, W320 GOpenOrder, Open order.html
    Gui, Add, Button, W320 GOpenLatest, Open latest output
    Gui, Add, Button, W320 GTileWindows, Tile Windows
    Gui, Add, Button, W320 GGridWindows, Grid Windows
    Gui, Show
Return
; ==============================================================================
;                                  Gui Destroy
; ==============================================================================
~Escape::
    Gui, Destroy
Return
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
;                                   Set Price
; ==============================================================================
#p::
    Clipboard =
    Send, ^c
    ClipWait, 1
    increment := 0.40

    If (Clipboard >= 15)
        increment := 4
    Else If (Clipboard >= 5)
        increment := 2
    Else If (Clipboard >= 2)
        increment := 1

    Clipboard := Format("{:.2f}", Clipboard + increment + 0.01)
    Beep(1200, 20)
Return
; ==============================================================================
;                                 Sentence Case
; ==============================================================================
SentenceCase:
    Send, ^c
    ClipWait, 1

    StringLower, Clipboard, Clipboard
    Clipboard := RegExReplace(Clipboard, "(?<=^|\.|\. |】)(\w)", "$U0")

    Send, ^v
    Beep(1200, 20)
Return
; ==============================================================================
;                                  Title Case
; ==============================================================================
TitleCase:
    Send, ^c
    ClipWait, 1

    StringLower, Clipboard, Clipboard, T
    Clipboard := RegExReplace(Clipboard, "(?<!^)\b(The|Is|To|And|On|In|A|An|Or|But|For|Of)\b", "$L0")

    Send, ^v
    Beep(1200, 20)
Return
; ==============================================================================
;                                    Reload
; ==============================================================================
#r::
    Reload
Return
