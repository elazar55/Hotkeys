; ==============================================================================
;                                      GUI
; ==============================================================================
#F1::
AmazonGUI:
    width := 320
    Gui, Destroy
    Gui, add, Edit, X10 W%width% Vasin, B0CLQWN1CV
    Gui, add, Button, XP+%width% Default GAmazonScrape, Go
    Gui, add, Edit, X10 W%width% Vtitle, Title
    Gui, add, Edit, X10 W%width% Vdescription, Description
    Gui, Show
Return
; ==============================================================================
;                                 AmazonScrape
; ==============================================================================
AmazonScrape:
    Gui, Submit, NoHide
    source := DownloadSource(asin)

    GuiControl, , title, % GetTitle(source)
    GuiControl, , description, % GetDescription(source)
Return
; ==============================================================================
;                                DownloadSource
; ==============================================================================
DownloadSource(asin)
{
    UrlDownloadToFile, https://www.amazon.co.uk/dp/%asin%, amazon_source.html
    FileRead, src_str, amazon_source.html

    If (InStr(src_str, "Page Not Found"))
    {
        MsgBox, %asin% not found.
        Exit, -1
    }
    Return src_str
}
; ==============================================================================
;                                   GetTitle
; ==============================================================================
GetTitle(ByRef source)
{
    RegExMatch(source, "(?<=a-size-large product-title-word-break"">).+?(?=<\/span>)", match)
    Return Trim(match)
}
; ==============================================================================
;                                GetDescription
; ==============================================================================
GetDescription(ByRef source)
{
    desc := ""

    pos := RegExMatch(source, "<table class=""a-normal a-spacing-micro"">.+?</table>", desc)
    pos := RegExMatch(source, "<ul class=""a-unordered-list a-vertical a-spacing-mini"">.+?</ul>", match, pos + StrLen(desc))
    desc .= match

    desc := StrReplace(desc, "<noscript>", "")
    desc := StrReplace(desc, "</noscript>", "")
    desc := StrReplace(desc, "`n", "")
    desc := StrReplace(desc, "`r", "")

    Return desc
}
