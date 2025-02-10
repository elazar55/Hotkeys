; ==============================================================================
;                                  TrimNumber
; ==============================================================================
TrimNumber(number)
{
    fract := (number) - Floor(number)
    Return fract ? Round(number, 3) : Round(number)
}
; ==============================================================================
;                                Byte Converter
; ==============================================================================
ByteConverter:
    ;@AHK++AlignAssignmentOn
    width    := 96
    x_offset := width + 2
    y_offset := 3
    ;@AHK++AlignAssignmentOff

    Gui, Destroy
    Gui, +AlwaysOnTop

    Gui, Add, Button, gByte X10, Go
    Gui, Add, Edit, vb_byte w%width% XP+30
    Gui, Add, Text, XP+%x_offset% YP+%y_offset%, Byte

    Gui, Add, Button, gKByte X10, Go
    Gui, Add, Edit, vk_byte w%width% XP+30
    Gui, Add, Text, XP+%x_offset% YP+%y_offset%, KB

    Gui, Add, Button, gMByte X10, Go
    Gui, Add, Edit, vm_byte w%width% XP+30
    Gui, Add, Text, XP+%x_offset% YP+%y_offset%, MB

    Gui, Add, Button, gGByte X10, Go
    Gui, Add, Edit, vg_byte w%width% XP+30
    Gui, Add, Text, XP+%x_offset% YP+%y_offset%, GB

    Gui, Add, Button, X10 gClear, Clear

    Gui, Show
Return
; ==============================================================================
;                                 Convert Bytes
; ==============================================================================
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
