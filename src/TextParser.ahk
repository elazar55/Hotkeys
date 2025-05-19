; ==============================================================================
;                                  Text Tools
; ==============================================================================
TextTools:
    Gui, Destroy

    width := StrLen(Trim(Clipboard)) * 6
    if (width < 240)
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
    ; ==========================================================================
    ;                                   Input
    ; ==========================================================================
    switch casing
    {
        ;@AHK++AlignAssignmentOn
        case "Space": words := StrSplit(input, " ")
        case "Snake": words := StrSplit(input, "_")
        case "Kebab": words := StrSplit(input, "-")
        case "Dot" : words  := StrSplit(input, ".")
        ;@AHK++AlignAssignmentOff
    }
    ; ==========================================================================
    ;                                  Output
    ; ==========================================================================
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
