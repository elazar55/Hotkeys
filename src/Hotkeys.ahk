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
#Include, Amazon.ahk
#Include, Orders.ahk
#Include, TextParser.ahk
#Include, ByteConverter.ahk
; #Include, Jobalots.ahk
; ==============================================================================
;                                Beep Subroutine
; ==============================================================================
Beep(frequency, volume)
{
    SoundGet, master_volume
    SoundSet, volume
    SoundBeep, %frequency%
    SoundSet, %master_volume%
}
; ==============================================================================
;                                      GUI
; ==============================================================================
#m::
    width := 320
    Gui, Destroy
    Gui, +AlwaysOnTop
    Gui, Add, Button, W%width% GScraperGUI, Scraper
    Gui, Add, Button, W%width% GAmazonGUI, Amazon
    Gui, Add, Button, W%width% GDockerGUI, Docker
    Gui, Add, Button, W%width% GTextTools, Text Tools
    Gui, Add, Button, W%width% GByteConverter, Byte Converter
    Gui, Show
Return
; ==============================================================================
;                                    Hotkeys
; ==============================================================================
#Escape::Gui, Destroy
#+z::^NumpadAdd
!Space::Send _
#d::Reload
; ==============================================================================
;                                   Set Price
; ==============================================================================
#p::
    old_clip := Clipboard
    Clipboard :=

    Send, ^c
    ClipWait, 0.01

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
;                                 Surround with
; ==============================================================================
; #IfWinNotActive, ahk_exe Code.exe
; +9::SurroundWith("(", ")")
; +'::SurroundWith("""", """")

SurroundWith(left_char, right_char)
{
    old_clip := Clipboard
    Clipboard := ""
    Send, ^c
    ClipWait, 0.02
    Clipboard := left_char . Trim(Clipboard, " ") . right_char
    Send, ^v

    If (Clipboard == left_char . right_char)
    {
        Send, {Left}
    }
    Beep(1200, 20)
    Clipboard := old_clip
}
