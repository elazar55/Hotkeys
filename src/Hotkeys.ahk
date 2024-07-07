; ==============================================================================
;                             Auto Exexcute Section
; ==============================================================================
; Script attributes
#NoEnv
#SingleInstance, Force
SetTitleMatchMode, 2
SetBatchLines, 20ms
SendMode, Event
; ==============================================================================
;                                   Includes
; ==============================================================================
; #Include, Fez.ahk
; #Include, Hearthstone.ahk
; #Include, GameRemaps.ahk
; #Include, PicrossTouch.ahk
#Include, Tiler.ahk
#Include, Scraper.ahk
#Include, Helpers.ahk
#Include, GameFAQsData.ahk
; #Include, Jobalots.ahk
; ==============================================================================
;                                      GUI
; ==============================================================================
#m::
    Gui, Destroy
    Gui, +AlwaysOnTop
    Gui, Add, Button, W320 GScrape, Scrape
    Gui, Add, Button, W320 GOpenOrder, Open order.html
    Gui, Add, Button, W320 GOpenLatest, Open latest output
    Gui, Add, Button, W320 GDockerGUI, Docker
    Gui, Add, Button, W320 GTextTools, Text Tools
    Gui, Show
Return
; ==============================================================================
;                                  Gui Destroy
; ==============================================================================
#Escape::
    Gui, Destroy
Return
; ==============================================================================
;                                  GUI Submit
; ==============================================================================
GUISubmit:
    Gui, Submit
Return
; ==============================================================================
;                                    Hotkeys
; ==============================================================================
!Space::Send _
#d::Reload
; ==============================================================================
;                           Exclude VS Code from Here
; ==============================================================================
#IfWinNotActive, ahk_exe Code.exe
; ==============================================================================
;                                CopyToClipboard
; ==============================================================================
CopyToClipboard()
{
    Clipboard :=
    Send, ^c
    ClipWait, 1

    If (Clipboard = "")
    {
        Beep(800, 20)
        Exit
    }

    Clipboard := Trim(Clipboard, " ")
}
; ==============================================================================
;                                   Set Price
; ==============================================================================
#p::
    CopyToClipboard()

    if Clipboard is not float
    {
        Beep(800, 20)
        Return
    }

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
;                                  Text Tools
; ==============================================================================
TextTools:
    Gui, Destroy
    Gui, Add, Edit, W800 Vinput,
    Gui, Add, Edit, W800 Voutput
    Gui, Add, Button, W800 GSentenceCase, Sentence Case
    Gui, Add, Button, W800 GTitleCase, Title Case
    Gui, Add, Button, W800 GSpaceToSnake, Snake Case
    Gui, Add, Button, W800 GCamelToSnake, Camel Case to Snake Case
    Gui, Add, Button, W800 GSnakeToCamnel, Snake Case to Camel Case
    Gui, Add, Button, W800 GSnakeToTitle, Snake Case to Title Case
    Gui, Add, Button, W800 GSnakeToSentence, Snake Case to Sentence Case
    Gui, Add, Button, W800 GDotToTitle, Dot Case to Title Case
    Gui, Show
Return
; ==============================================================================
;                                 Sentence Case
; ==============================================================================
SentenceCase:
    Gui, Submit, NoHide

    StringLower, input, input
    input := RegExReplace(input, "(?<=^|\.|\. |】)(\w)", "$U0")
    input := RegExReplace(input, "\bi\b", "$U0")

    ; Append full stop
    if (SubStr(input, 0, 1) != "." && SubStr(input, 0, 1) != "!")
        input := input . "."

    ; Update GUI and Clipboard with result
    GuiControl,, output, %input%
    Clipboard := input
Return
; ==============================================================================
;                                  Title Case
; ==============================================================================
TitleCase:
    Gui, Submit, NoHide

    StringLower, input, % Trim(input)

    ;@AHK++AlignAssignmentOn
    title_case    := "(?<!')\b\w"
    prepositions  := "i)(?<!(^)|(: )|(\. ))\b(The|Is|To|And|On|In|A|An|As|Or|But|For|Of|Vs|With)\b"
    abbreviations := "i)\bMIDI|USB|PC\b"
    ;@AHK++AlignAssignmentOff

    input := RegExReplace(input, title_case, "$U0")
    input := RegExReplace(input, prepositions, "$L0")
    input := RegExReplace(input, abbreviations, "$U0")

    ; Update GUI and Clipboard with result
    GuiControl,, output, %input%
    Clipboard := input
Return
; ==============================================================================
;                                  Snake Case
; ==============================================================================
SpaceToSnake:
    Gui, Submit, NoHide

    input := StrReplace(input, " ", "_")

    ; Update GUI and Clipboard with result
    GuiControl,, output, %input%
    Clipboard := input
Return
; ==============================================================================
;                           Camel Case to Snake Case
; ==============================================================================
CamelToSnake:
    Gui, Submit, NoHide

    input := RegExReplace(input, "(?<!^)[A-Z_](?![A-Z_])", "_$L0")
    StringLower, input, input

    ; Update GUI and Clipboard with result
    GuiControl,, output, %input%
    Clipboard := input
Return
; ==============================================================================
;                           Snake Case to Camel Case
; ==============================================================================
SnakeToCamnel:
    Gui, Submit, NoHide

    input := RegExReplace(input, "(?<=^|\.|\. |】)(\w)", "$U0")
    input := RegExReplace(input, "\bi\b", "$U0")
    input := RegExReplace(input, "_(\w)", "$U1")

    ; Update GUI and Clipboard with result
    GuiControl,, output, %input%
    Clipboard := input
Return
; ==============================================================================
;                           Snake Case to Title Case
; ==============================================================================
SnakeToTitle:
    Gui, Submit, NoHide

    input := StrReplace(input, "_", " ")

    StringLower, input, % Trim(input)

    ;@AHK++AlignAssignmentOn
    title_case    := "(?<!')\b\w"
    prepositions  := "i)(?<!(^)|(: )|(\. ))\b(The|Is|To|And|On|In|A|An|As|Or|But|For|Of|Vs|With)\b"
    abbreviations := "i)\bMIDI|USB|PC\b"
    ;@AHK++AlignAssignmentOff

    input := RegExReplace(input, title_case, "$U0")
    input := RegExReplace(input, prepositions, "$L0")
    input := RegExReplace(input, abbreviations, "$U0")

    ; Update GUI and Clipboard with result
    GuiControl,, output, %input%
    Clipboard := input
Return
; ==============================================================================
;                           Snake Case to Sentence Case
; ==============================================================================
SnakeToSentence:
    Gui, Submit, NoHide

    input := StrReplace(input, "_", " ")

    StringLower, input, % Trim(input)
    input := RegExReplace(input, "(?<=^|\.|\. |】)(\w)", "$U0")
    input := RegExReplace(input, "\bi\b", "$U0")

    ; Append full stop
    if (SubStr(input, 0, 1) != "." && SubStr(input, 0, 1) != "!")
        input := input . "."

    ; Update GUI and Clipboard with result
    GuiControl,, output, %input%
    Clipboard := input
Return
; ==============================================================================
;                           Dot Case to Title Case
; ==============================================================================
DotToTitle:
    Gui, Submit, NoHide

    ;@AHK++AlignAssignmentOn
    title_case    := "(?<!')\b\w"
    prepositions  := "i)(?<!(^)|(: )|(\. ))\b(The|Is|To|And|On|In|A|An|As|Or|But|For|Of|Vs|With)\b"
    abbreviations := "i)\bMIDI|USB|PC\b"
    ;@AHK++AlignAssignmentOff

    input := RegExReplace(input, "\b\.\b", " ")
    input := RegExReplace(input, title_case, "$U0")
    input := RegExReplace(input, prepositions, "$L0")
    input := RegExReplace(input, abbreviations, "$U0")

    ; Update GUI and Clipboard with result
    GuiControl,, output, %input%
    Clipboard := input
Return
; ==============================================================================
;                                  Cursor Keys
; ==============================================================================
#^a:: MouseMove, -1, 0, , R
#^s:: MouseMove, 1, 0, , R
#^w:: MouseMove, 0, -1, , R
#^r:: MouseMove, 0, 1, , R
#^Space::
    if (toggle := !toggle)
    {
        Send {LButton down}
        Beep(1200, 25)
    }
    Else
    {
        Send {LButton up}
        Beep(1000, 25)
    }
Return
; ==============================================================================
;                           Surround with parentheses
; ==============================================================================
#IfWinActive, ahk_exe chrome.exe
+^9::
    CopyToClipboard()

    ClipWait, 1
    Clipboard := "(" . Clipboard . ")"
    Send, ^v
    Beep(1200, 20)
Return
; ==============================================================================
;                             Surround with quotes
; ==============================================================================
#IfWinActive, ahk_exe chrome.exe
+^'::
    CopyToClipboard()

    Clipboard := """" . Clipboard . """"
    Send, ^v
    Beep(1200, 20)
Return
; ==============================================================================
;                          Pearls of Atlantis The Cove
; ==============================================================================
#IfWinActive, ahk_exe PearlsOfAtlantisTheCove.exe
a::MouseMove, -1, 0, 0, R
+a::MouseMove, -10, 0, 0, R
s::MouseMove, 1, 0, 0, R
+s::MouseMove, 10, 0, 0, R
Space::MouseClick
