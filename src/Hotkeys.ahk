﻿; ==============================================================================
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
    Gui, Show
Return
; ==============================================================================
;                                  Gui Destroy
; ; ==============================================================================
; ~Escape::
;     Gui, Destroy
; Return
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
;                                 Sentence Case
; ==============================================================================
!#t::
    CopyToClipboard()

    StringLower, Clipboard, Clipboard
    Clipboard := RegExReplace(Clipboard, "(?<=^|\.|\. |】)(\w)", "$U0")
    Clipboard := RegExReplace(Clipboard, "\bi\b", "$U0")

    ; Append full stop
    if (SubStr(Clipboard, 0, 1) != "." && SubStr(Clipboard, 0, 1) != "!")
        Clipboard := Clipboard . "."

    Send, ^v
    Beep(1200, 20)
Return
; ==============================================================================
;                                  Title Case
; ==============================================================================
#t::
    CopyToClipboard()

    StringLower, Clipboard, % Trim(Clipboard)

    ;@AHK++AlignAssignmentOn
    title_case    := "(?<!')\b\w"
    prepositions  := "i)(?<!(^)|(: )|(\. ))\b(The|Is|To|And|On|In|A|An|As|Or|But|For|Of|Vs|With)\b"
    abbreviations := "i)\bMIDI|USB|PC\b"
    ;@AHK++AlignAssignmentOff

    Clipboard := RegExReplace(Clipboard, title_case, "$U0")
    Clipboard := RegExReplace(Clipboard, prepositions, "$L0")
    Clipboard := RegExReplace(Clipboard, abbreviations, "$U0")
    Send, ^v
    Beep(1200, 20)
Return
; ==============================================================================
;                                  Snake Case
; ==============================================================================
SpaceToSnake:
    CopyToClipboard()

    Clipboard := StrReplace(Clipboard, " ", "_")
    Send, ^v
    Beep(1200, 20)
Return
; ==============================================================================
;                           Camel Case to Snake Case
; ==============================================================================
CamelToSnake:
    CopyToClipboard()

    Clipboard := RegExReplace(Clipboard, "(?<!^)[A-Z_](?![A-Z_])", "_$L0")
    StringLower, Clipboard, Clipboard
    Send, ^v
    Beep(1200, 20)
Return
; ==============================================================================
;                           Snake Case to Camel Case
; ==============================================================================
SnakeToCamnel:
    CopyToClipboard()

    Clipboard := RegExReplace(Clipboard, "_(\w)", "$U1")
    Send, ^v
    Beep(1200, 20)
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
