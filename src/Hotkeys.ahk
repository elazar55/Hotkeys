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
    Gui, Add, DDL, W60 XP+%width% Vcasing Choose1, Space|Snake|Dot|Kebab
    Gui, Add, Button, XP+60 gGo, Go
    Gui, Add, Edit, X10 W%width% Voutput
    Gui, Add, DDL, W60 XP+%width% Vcasing_out Choose1, Sentence|Title|Snake|Dot|Kebab|Pascal|Camel
    GuiControl,, input, % Trim(Clipboard)
    Gui, Show
Return

Go:
    Gui, Submit, NoHide
    output := ""
    ; ==========================================================================
    ;                                   Input
    ; ==========================================================================
    switch casing
    {
        ;@AHK++AlignAssignmentOn
        case "Space": words := StrSplit(input, " ")
        case "Snake": words := StrSplit(input, "_")
        case "Kebab": words := StrSplit(input, "-")
        case "Dot": words   := StrSplit(input, ".")
        ;@AHK++AlignAssignmentOff
    }
    ; ==========================================================================
    ;                                  Output
    ; ==========================================================================
    For key, value in words
    {
        If (casing_out == "Sentence")
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
            output := output . value . "_"
        }
        Else If (casing_out == "Dot")
        {
            output := output . value . "."
        }
        Else If (casing_out == "Kebab")
        {
            output := output . value . "-"
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
    }
    GuiControl,, output, %output%
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
;                           Exclude VS Code from Here
; ==============================================================================
#IfWinNotActive, ahk_exe Code.exe
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
    ; #IfWinActive, ahk_exe chrome.exe
    ; +9::
    ;     CopyToClipboard()

    ;     Clipboard := "(" . Clipboard . ")"
    ;     Send, ^v
    ;     Beep(1200, 20)
    Return
    ; ==============================================================================
    ;                             Surround with quotes
    ; ==============================================================================
    ; #IfWinActive, ahk_exe chrome.exe
    ; +'::
    ;     CopyToClipboard()

    ;     Clipboard := """" . Clipboard . """"
    ;     Send, ^v
    ;     Beep(1200, 20)
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
; ==============================================================================
;                                   Golf Test
; ==============================================================================
; #IfWinActive
; `::
;     SetKeyDelay, -1, 60
;     Send, {Blind}{Space}
;     Sleep, 430
;     Send, {Blind}{Space}
;     Sleep, 190
;     Send, {Blind}{Space}
; Return
