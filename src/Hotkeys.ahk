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
#Include, Amazon.ahk
#Include, Orders.ahk
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
;                                    Hotkeys
; ==============================================================================
!Space::Send _
#d::Reload
#+z::^NumpadAdd
; ==============================================================================
;                                Byte Converter
; ==============================================================================
ByteConverter:
    width := 96
    x_offset := width + 2
    y_offset := 3

    Gui, Destroy
    Gui, +AlwaysOnTop

    Gui, Add, Button, gByte X10, Go
    Gui, Add, Edit, vb_byte w%width% XP+30
    Gui, Add, Text, w%width% XP+%x_offset% YP+%y_offset%, Byte

    Gui, Add, Button, gKByte X10, Go
    Gui, Add, Edit, vk_byte w%width% XP+30
    Gui, Add, Text, w%width% XP+%x_offset% YP+%y_offset%, KB

    Gui, Add, Button, gMByte X10, Go
    Gui, Add, Edit, vm_byte w%width% XP+30
    Gui, Add, Text, w%width% XP+%x_offset% YP+%y_offset%, MB

    Gui, Add, Button, gGByte X10, Go
    Gui, Add, Edit, vg_byte w%width% XP+30
    Gui, Add, Text, w%width% XP+%x_offset% YP+%y_offset%, GB

    Gui, Add, Button, X10 gClear, Clear

    Gui, Show
Return

TrimNumber(number)
{
    fract := (number) - Floor(number)
    Return fract ? Round(number, 3) : Round(number)
}

Byte:
    Gui, Submit, NoHide
    GuiControl, , k_byte, % TrimNumber(b_byte / 1024 ** 1)
    GuiControl, , m_byte, % TrimNumber(b_byte / 1024 ** 2)
    GuiControl, , g_byte, % TrimNumber(b_byte / 1024 ** 3)
Return

KByte:
    Gui, Submit, NoHide
    GuiControl, , b_byte, % TrimNumber(k_byte * 1024 ** 1)
    GuiControl, , m_byte, % TrimNumber(k_byte / 1024 ** 1)
    GuiControl, , g_byte, % TrimNumber(k_byte / 1024 ** 2)
Return

MByte:
    Gui, Submit, NoHide
    GuiControl, , b_byte, % TrimNumber(m_byte * 1024 ** 2)
    GuiControl, , k_byte, % TrimNumber(m_byte * 1024 ** 1)
    GuiControl, , g_byte, % TrimNumber(m_byte / 1024 ** 1)
Return

GByte:
    Gui, Submit, NoHide
    GuiControl, , b_byte, % TrimNumber(g_byte * 1024 ** 3)
    GuiControl, , k_byte, % TrimNumber(g_byte * 1024 ** 2)
    GuiControl, , m_byte, % TrimNumber(g_byte * 1024 ** 1)

Return
Clear:
    GuiControl, , b_byte,
    GuiControl, , k_byte,
    GuiControl, , m_byte,
    GuiControl, , g_byte,
Return
; ==============================================================================
;                                Time Converter
; ==============================================================================
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
;                                  Text Tools
; ==============================================================================
TextTools:
    Gui, Destroy

    width := StrLen(Trim(Clipboard)) * 6
    if (width < 240 )
        width := 240

    Gui, Add, Edit, W%width% Vinput,
    Gui, Add, DDL, W60 XP+%width% Vcasing Choose1, Space|Snake|Dot|Kebab
    Gui, Add, Button, XP+60 gParseText, ParseText
    Gui, Add, Edit, X10 W%width% Voutput
    Gui, Add, DDL, W60 XP+%width% Vcasing_out Choose1, Space|Sentence|Title|Snake|Dot|Kebab|Pascal|Camel|Uppercase|Lowercase
    GuiControl,, input, % Trim(Clipboard)
    Gui, Show
Return
; ==============================================================================
;                                  Parse Text
; ==============================================================================
ParseText:
    Gui, Submit, NoHide
    output := ""

    ; ================================= Input ==================================
    switch casing
    {
        ;@AHK++AlignAssignmentOn
        case "Space": words := StrSplit(input, " ")
        case "Snake": words := StrSplit(input, "_")
        case "Kebab": words := StrSplit(input, "-")
        case "Dot" : words  := StrSplit(input, ".")
        ;@AHK++AlignAssignmentOff
    }

    ; ================================ Output ==================================
    For key, value in words
    {
        If (casing_out == "Space")
        {
            output := output . value . " "
        }
        Else If (casing_out == "Sentence")
        {
            If (A_Index == 1)
                StringLower, value, value, T
            Else
                StringLower, value, value

            output := output . value . " "
        }
        Else If (casing_out == "Title")
        {
            StringLower, value, value, T
            output := output . value . " "
        }
        Else If (casing_out == "Snake")
        {
            If (A_Index == 1)
            {
                output := output . value
                Continue
            }
            output := output . "_" . value
        }
        Else If (casing_out == "Dot")
        {
            output := output . value . "."
        }
        Else If (casing_out == "Kebab")
        {
            If (A_Index == 1)
            {
                output := output . value
                Continue
            }
            output := output . "-" . value
        }
        Else If (casing_out == "Pascal")
        {
            StringUpper, value, value, T
            output := output . value
        }
        Else If (casing_out == "Camel")
        {
            If (A_Index == 1)
                StringLower, value, value
            Else
                StringUpper, value, value, T

            output := output . value
        }
        Else If (casing_out == "Uppercase")
        {
            StringUpper, value, value
            output := output . value . " "
        }
        Else If (casing_out == "Lowercase")
        {
            StringLower, value, value
            output := output . value . " "
        }
    }
    GuiControl,, output, % Trim(output)
    Clipboard := Trim(output)
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
; #IfWinNotActive, ahk_exe Code.exe
; +9::
;     old_clip := Clipboard
;     Clipboard :=
;     Send, ^c
;     ClipWait, 0.01
;     Clipboard := "(" . Trim(Clipboard, " ") . ")"
;     Send, ^v
;     If (Clipboard == "()")
;     {
;         Send, {Left}
;     }
;     Beep(1200, 20)
;     Clipboard := old_clip
; Return
; ==============================================================================
;                           Surround with quotes
; ==============================================================================
; #IfWinNotActive, ahk_exe Code.exe
;     ; +'::
;     old_clip := Clipboard
;     Clipboard := ""
;     Send, ^c
;     ClipWait, 0.02
;     Clipboard := """" . Trim(Clipboard, " ") . """"
;     Send, ^v
;     If (Clipboard == """""")
;     {
;         Send, {Left}
;     }
;     Beep(1200, 20)
;     Clipboard := old_clip
; Return
