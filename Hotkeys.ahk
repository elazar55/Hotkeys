; ==============================================================================
;                             Auto Exexcute section
; ==============================================================================
; Script attributes
#NoEnv
#SingleInstance, Force
SetTitleMatchMode, 2
SetBatchLines, 10
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
    Gui, Add, Button, W320 GScrape, Scrape
    Gui, Add, Button, W320 GTileWindows, Tile Windows
    Gui, Add, Button, W320 GGridWindows, Grid Windows
    Gui, Add, Button, W320 GClean, Clean
    Gui, Show
Return
; ==============================================================================
;                                     Clean
; ==============================================================================
Clean:
    FileRemoveDir, Orders, 1
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
    Send, ^v
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

    StringLower, Clipboard, Clipboard
    Clipboard := RegExReplace(Clipboard, "(?<=\w)(\.)(?=\w)", " ")
    Clipboard := RegExReplace(Clipboard, "(\b\w(?=\w{3,}))", "$U0")

    Send, ^v
    Beep(1200, 20)
Return
; ==============================================================================
;                                    Reload
; ==============================================================================
#r::
    Reload
Return
