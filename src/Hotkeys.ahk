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
;                                      GUI
; ==============================================================================
#m::
    ; Gui, +AlwaysOnTop
    Gui, Destroy
    Gui, Add, Button, W320 GScrape, Scrape
    Gui, Add, Button, W320 GTileWindows, Tile Windows
    Gui, Add, Button, W320 GGridWindows, Grid Windows

    ; Gui, Add, Edit, W320 r20 veditField, TestText
    ; Gui, Submit
    ; FileRead, orderHtml, order.html
    ; GuiControl,, editField, %orderHtml%
    ; MsgBox, %editField%

    Gui, Show
; OnMessage(0x0201, "WM_LBUTTONDOWN")
Return
; ==============================================================================
;                            WM_LBUTTONDOWN Callback
; ==============================================================================
WM_LBUTTONDOWN(wParam, lParam)
{
    if A_GuiControl
        Gui, Destroy
}
; ==============================================================================
;                                  Gui Destroy
; ==============================================================================
~Escape::
    Gui, Destroy
Return
; ==============================================================================
;                                Duplicate Words
; ==============================================================================
#D::
    Gui, Destroy
    Gui, Add, Edit, vmyText w960 gChangeText,
    Gui, Add, Edit, voutput w960,
    Gui, Show
Return

ChangeText:
    Gui, Submit, NoHide
    myText := RegExReplace(myText, "\b(\w+)\b(?=.*?\b\1\b)")
    myText := RegExReplace(myText, "\s{2,}", " ")
    myText := RegExReplace(myText, "\s+,", ",")
    myText := RegExReplace(myText, "\s+\.", ".")
    myText := RegExReplace(myText, ",\.", ".")
    myText := Trim(myText)
    GuiControl,, output, % myText
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
    ; MsgBox, % Format("{:.2f}", Clipboard + increment + 0.01)
    ; Send, {Tab}
    ; Send, ^v
    Beep(1200, 20)
Return
; ==============================================================================
;                                 Sentence Case
; ==============================================================================
#s::
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
#t::
    Send, ^c
    ClipWait, 1

    StringLower, Clipboard, Clipboard, T
    ; Clipboard := RegExReplace(Clipboard, "(?<=\w)(\.)(?=\w)", " ")
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
