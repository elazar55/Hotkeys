; ==============================================================================
;                                      GUI
; ==============================================================================
#F1::
AmazonGUI:
    Gui, Destroy

    width := 320
    Gui, add, Edit, X10 W%width% Vasin, B0CLQWN1CV
    Gui, add, Button, XP+%width% Default GAmazonScrape, Go
    Gui, add, Edit, X10 W%width% Vtitle, Title
    Gui, add, Edit, X10 W%width% Vdescription, Description
    Gui, add, Edit, X10 W%width% Vprice, Price
    Gui, add, Edit, X10 W%width% Vimage_path, Image Path
    Gui, add, Button, XP+%width% GPickImagePath, ...
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
    GuiControl, , price, % GetPrice(source)
    GetImages(source, image_path)
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
    Return 0
}
; ==============================================================================
;                                GetDescription
; ==============================================================================
GetDescription(ByRef source)
{
    Return 0
}
; ==============================================================================
;                                   GetPrice
; ==============================================================================
GetPrice(ByRef source)
{
    Return 0
}
; ==============================================================================
;                                   GetImages
; ==============================================================================
GetImages(ByRef source, path)
{
    If (!FileExist(path))
    {
        MsgBox, Invalid directory.
        Return
    }

    pos := 1
    While (pos := RegExMatch(source, "(?<=""hiRes"":"")https:\/\/m.media-amazon.com\/images\/I\/(.+?_AC_SL\d{4}_.jpg)", match, pos + StrLen(match)))
    {
        If (!FileExist(match1))
        {
            UrlDownloadToFile, %match%, %path%\%match1%
            MsgBox, %match1%
        }
    }
}
; ==============================================================================
;                                 PickImagePath
; ==============================================================================
PickImagePath()
{
    FileSelectFolder, dir
    GuiControl, , image_path, %dir%
}
