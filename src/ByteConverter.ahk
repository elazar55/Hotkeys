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
    Gui, Add, Text, XP+%x_offset%, Byte

    Gui, Add, Button, gBit XP+24, Go
    Gui, Add, Edit, vb_bit  w%width% XP+28
    Gui, Add, Text, XP+%x_offset%, Bits

    Gui, Add, Button, gKByte X10, Go
    Gui, Add, Edit, vk_byte w%width% XP+28
    Gui, Add, Text, XP+%x_offset%, KB

    Gui, Add, Button, gKBit XP+24, Go
    Gui, Add, Edit, vk_bit  w%width% XP+28
    Gui, Add, Text, XP+%x_offset%, Kb

    Gui, Add, Button, gMByte X10, Go
    Gui, Add, Edit, vm_byte w%width% XP+28
    Gui, Add, Text, XP+%x_offset%, MB

    Gui, Add, Button, gMBit XP+24, Go
    Gui, Add, Edit, vm_bit  w%width% XP+28
    Gui, Add, Text, XP+%x_offset%, Mb

    Gui, Add, Button, gGByte X10, Go
    Gui, Add, Edit, vg_byte w%width% XP+28
    Gui, Add, Text, XP+%x_offset%, GB

    Gui, Add, Button, gGBit XP+24, Go
    Gui, Add, Edit, vg_bit  w%width% XP+28
    Gui, Add, Text, XP+%x_offset%, Gb

    Gui, Add, Button, X10 gClear, Clear

    Gui, Show
Return
; ==============================================================================
;                                 Convert Bytes
; ==============================================================================
Bit:
    Gui, Submit, NoHide
    GuiControl, , k_bit, % TrimNumber(b_bit / 1024)
    GuiControl, , m_bit, % TrimNumber(b_bit / 1024 ** 2)
    GuiControl, , g_bit, % TrimNumber(b_bit / 1024 ** 3)

    GuiControl, , b_byte, % TrimNumber(b_bit / 8)
    GuiControl, , k_byte, % TrimNumber(b_bit / 8 / 1024)
    GuiControl, , m_byte, % TrimNumber(b_bit / 8 / 1024 ** 2)
    GuiControl, , g_byte, % TrimNumber(b_bit / 8 / 1024 ** 3)
Return
KBit:
    Gui, Submit, NoHide
    GuiControl, , b_bit, % TrimNumber(k_bit * 1024)
    GuiControl, , m_bit, % TrimNumber(k_bit / 1024)
    GuiControl, , g_bit, % TrimNumber(k_bit / 1024 ** 2)

    GuiControl, , b_byte, % TrimNumber(k_bit / 8 * 1024)
    GuiControl, , k_byte, % TrimNumber(k_bit / 8)
    GuiControl, , m_byte, % TrimNumber(k_bit / 8 / 1024)
    GuiControl, , g_byte, % TrimNumber(k_bit / 8 / 1024 ** 2)
Return
MBit:
    Gui, Submit, NoHide
    GuiControl, , b_bit, % TrimNumber(m_bit * 1024 ** 2)
    GuiControl, , k_bit, % TrimNumber(m_bit * 1024)
    GuiControl, , g_bit, % TrimNumber(m_bit / 1024)

    GuiControl, , b_byte, % TrimNumber(m_bit / 8 * 1024 ** 2)
    GuiControl, , k_byte, % TrimNumber(m_bit / 8 * 1024)
    GuiControl, , m_byte, % TrimNumber(m_bit / 8)
    GuiControl, , g_byte, % TrimNumber(m_bit / 8 / 1024)
Return
GBit:
    Gui, Submit, NoHide
    GuiControl, , b_bit, % TrimNumber(g_bit * 1024 ** 3)
    GuiControl, , k_bit, % TrimNumber(g_bit * 1024 ** 2)
    GuiControl, , m_bit, % TrimNumber(g_bit * 1024)

    GuiControl, , b_byte, % TrimNumber(g_bit / 8 * 1024 ** 3)
    GuiControl, , k_byte, % TrimNumber(g_bit / 8 * 1024 ** 2)
    GuiControl, , m_byte, % TrimNumber(g_bit / 8 * 1024)
    GuiControl, , g_byte, % TrimNumber(g_bit / 8)
Return

Byte:
    Gui, Submit, NoHide
    GuiControl, , b_bit, % TrimNumber(b_byte * 8)
    GuiControl, , k_bit, % TrimNumber(b_byte * 8 / 1024)
    GuiControl, , m_bit, % TrimNumber(b_byte * 8 / 1024 ** 2)
    GuiControl, , g_bit, % TrimNumber(b_byte * 8 / 1024 ** 3)

    GuiControl, , k_byte, % TrimNumber(b_byte / 1024)
    GuiControl, , m_byte, % TrimNumber(b_byte / 1024 ** 2)
    GuiControl, , g_byte, % TrimNumber(b_byte / 1024 ** 3)
Return
KByte:
    Gui, Submit, NoHide
    GuiControl, , b_bit, % TrimNumber(k_byte * 8 * 1024)
    GuiControl, , k_bit, % TrimNumber(k_byte * 8)
    GuiControl, , m_bit, % TrimNumber(k_byte * 8 / 1024)
    GuiControl, , g_bit, % TrimNumber(k_byte * 8 / 1024 ** 2)

    GuiControl, , b_byte, % TrimNumber(k_byte * 1024)
    GuiControl, , m_byte, % TrimNumber(k_byte / 1024)
    GuiControl, , g_byte, % TrimNumber(k_byte / 1024 ** 2)
Return
MByte:
    Gui, Submit, NoHide
    GuiControl, , b_bit, % TrimNumber(m_byte * 8 * 1024 ** 2)
    GuiControl, , k_bit, % TrimNumber(m_byte * 8 * 1024)
    GuiControl, , m_bit, % TrimNumber(m_byte * 8)
    GuiControl, , g_bit, % TrimNumber(m_byte * 8 / 1024)

    GuiControl, , b_byte, % TrimNumber(m_byte * 1024 ** 2)
    GuiControl, , k_byte, % TrimNumber(m_byte * 1024)
    GuiControl, , g_byte, % TrimNumber(m_byte / 1024)
Return
GByte:
    Gui, Submit, NoHide
    GuiControl, , b_bit, % TrimNumber(g_byte * 8 * 1024 ** 3)
    GuiControl, , k_bit, % TrimNumber(g_byte * 8 * 1024 ** 2)
    GuiControl, , m_bit, % TrimNumber(g_byte * 8 * 1024)
    GuiControl, , g_bit, % TrimNumber(g_byte * 8)

    GuiControl, , b_byte, % TrimNumber(g_byte * 1024 ** 3)
    GuiControl, , k_byte, % TrimNumber(g_byte * 1024 ** 2)
    GuiControl, , m_byte, % TrimNumber(g_byte * 1024)
Return
Clear:
    GuiControl, , b_byte,
    GuiControl, , k_byte,
    GuiControl, , m_byte,
    GuiControl, , g_byte,
    GuiControl, , b_bit,
    GuiControl, , k_bit,
    GuiControl, , m_bit,
    GuiControl, , g_bit,
Return
