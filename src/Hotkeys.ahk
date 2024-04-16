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
; ==============================================================================
~Escape::
    Gui, Destroy
Return
; ==============================================================================
;                                  GUI Submit
; ==============================================================================
GUISubmit:
    Gui, Submit
Return
; ==============================================================================
;                                   Set Price
; ==============================================================================
#p::
    Clipboard =
    Send, ^c
    ClipWait, 0.1
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
sentence_case:
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

    StringLower, Clipboard, % Trim(Clipboard)

    ;@AHK++AlignAssignmentOn
    title_case    := "(?<!')\b\w"
    prepositions  := "i)(?<!(^)|(: )|(\. ))\b(The|Is|To|And|On|In|A|An|As|Or|But|For|Of|Vs)\b"
    abbreviations := "i)\bMIDI|USB|PC\b"
    ;@AHK++AlignAssignmentOff

    Clipboard := RegExReplace(Clipboard, title_case, "$U0")
    Clipboard := RegExReplace(Clipboard, prepositions, "$L0")
    Clipboard := RegExReplace(Clipboard, abbreviations, "$U0")

    Send, ^v
    Beep(1200, 20)
Return
; ==============================================================================
;                                    Remaps
; ==============================================================================
!Space::Send _
; ==============================================================================
;                                  Snake Case
; ==============================================================================
space_to_snake:
    Send, ^c
    ClipWait, 1
    Clipboard := StrReplace(Clipboard, " ", "_")
    Send, ^v
    Beep(1200, 20)
Return
; ==============================================================================
;                           camelCase to Snake Case
; ==============================================================================
camel_to_snake:
    Send, ^c
    ClipWait, 1

    Clipboard := RegExReplace(Clipboard, "(?<!^)[A-Z_](?![A-Z_])", "_$L0")
    StringLower, Clipboard, Clipboard

    Send, ^v
    Beep(1200, 20)
Return
; ==============================================================================
;                           Snake Case to camelCase
; ==============================================================================
snake_to_camnel:
    Send, ^c
    ClipWait, 1
    Clipboard := RegExReplace(Clipboard, "_(\w)", "$U1")
    Send, ^v
    Beep(1200, 20)
Return
; ==============================================================================
;                                 Surround With
; ==============================================================================
#IfWinActive, ahk_exe chrome.exe
paren:
    Clipboard :=
    Send, ^c
    ClipWait, 0.1
    Clipboard := "(" . Clipboard . ")"
    Send, ^v
    Beep(1200, 20)
Return
; ==============================================================================
#IfWinActive, ahk_exe chrome.exe
quotes:
    Clipboard :=
    Send, ^c
    ClipWait, 0.1
    Clipboard := """" . Clipboard . """"
    Send, ^v
    Beep(1200, 20)
Return
; ==============================================================================
;                                    Reload
; ==============================================================================
#d::
    Reload
Return
