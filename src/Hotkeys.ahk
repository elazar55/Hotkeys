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
    width := 320
    Gui, Destroy
    Gui, +AlwaysOnTop
    Gui, Add, Button, W%width% GScrape, Scrape
    Gui, Add, Button, W%width% GOpenOrder, Open order.html
    Gui, Add, Button, W%width% GOpenLatest, Open latest output
    Gui, Add, Button, W%width% GDockerGUI, Docker
    Gui, Add, Button, W%width% GTextTools, Text Tools
    Gui, Add, Button, W%width% GByteConverter, Byte Converter
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
;                                Byte Converter
; ==============================================================================
ByteConverter:
    width := 64
    Gui, Destroy
    Gui, +AlwaysOnTop

    Gui, Add, Edit, vbyte w%width% X10
    Gui, Add, Text, w%width% XP+%width% YP+5, Byte

    Gui, Add, Edit, vKByte w%width% X10
    Gui, Add, Text, w%width% XP+%width% YP+5, KB

    Gui, Add, Edit, vMByte w%width% X10
    Gui, Add, Text, w%width% XP+%width% YP+5, MB

    Gui, Add, Edit, vGByte w%width% X10
    Gui, Add, Text, w%width% XP+%width% YP+5, GB

    Gui, Add, Button, GByte X10, Go

    Gui, Show
Return
Byte:
    Gui, Submit, NoHide
    GuiControl, , KByte, % byte / 1024
    GuiControl, , MByte, % byte / (1024 ** 2)
    GuiControl, , GByte, % byte / (1024 ** 3)
Return
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

    width := 240

    Gui, Add, Edit, W%width% Vinput,
    Gui, Add, Edit, W%width% Voutput
    GuiControl,, input, %Clipboard%

    Gui, Add, Button, W%width% GSpaceToSentence, Space to Sentence
    Gui, Add, Button, W%width% GSpaceToTitle, Space to Title
    Gui, Add, Button, W%width% GSpaceToSnake, Space to Snake
    Gui, Add, Button, W%width% GSpaceToKebab, Space to Kebab
    Gui, Add, Button, W%width% GSnakeToCamnel, Snake to Camel
    Gui, Add, Button, W%width% GSnakeToTitle, Snake to Title
    Gui, Add, Button, W%width% GSnakeToSentence, Snake to Sentence
    Gui, Add, Button, W%width% GCamelToSnake, Camel to Snake
    Gui, Add, Button, W%width% GDotToTitle, Dot to Title
    Gui, Add, Button, W%width% GUppercase, Upper Case
    Gui, +AlwaysOnTop
    Gui, Show
Return
; ==============================================================================
;                            Space to Sentence Case
; ==============================================================================
SpaceToSentence:
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
;                              Space to Title Case
; ==============================================================================
SpaceToTitle:
    Gui, Submit, NoHide

    StringLower, input, % Trim(input)

    ;@AHK++AlignAssignmentOn
    title_case    := "(?<!')\b\w"
    prepositions  := "i)(?<!(^)|(: )|(\. ))\b(The|Is|To|And|On|In|A|An|As|Or|But|For|Of|Vs|With)\b"
    abbreviations := "i)\bMIDI|USB|PC\b"
    ;@AHK++AlignAssignmentOff

    input := RegExReplace(Trim(input), title_case, "$U0")
    input := RegExReplace(input, prepositions, "$L0")
    input := RegExReplace(input, abbreviations, "$U0")

    ; Update GUI and Clipboard with result
    GuiControl,, output, %input%
    Clipboard := input
Return
; ==============================================================================
;                              Space to Snake Case
; ==============================================================================
SpaceToSnake:
    Gui, Submit, NoHide

    input := StrReplace(Trim(input), " ", "_")

    ; Update GUI and Clipboard with result
    GuiControl,, output, %input%
    Clipboard := input
Return
; ==============================================================================
;                                  Upper Case
; ==============================================================================
Uppercase:
    Gui, Submit, NoHide

    StringUpper, input, % Trim(input)

    ; Update GUI and Clipboard with result
    GuiControl,, output, %input%
    Clipboard := input
Return
; ==============================================================================
;                              Space to kebab-case
; ==============================================================================
SpaceToKebab:
    Gui, Submit, NoHide

    input := StrReplace(Trim(input), " ", "-")

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
    StringLower, input, % Trim(input)
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
;                                 Always on Top
; ==============================================================================
#v::
    WinSet, AlwaysOnTop, Toggle, A, , ,
    WinGet, style, ExStyle, A, ,
    If (style & 0x8)
        Beep(1200, 25)
    Else
        Beep(600, 25)
Return
; ==============================================================================
;                           Surround with parentheses
; ==============================================================================
#IfWinActive, ahk_exe chrome.exe
+^9::
    CopyToClipboard()

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
