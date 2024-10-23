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
