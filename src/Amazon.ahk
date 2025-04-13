; ==============================================================================
;                                      GUI
; ==============================================================================
#F1::
AmazonGUI:
    Gui, Destroy

    width := 320
    Gui, add, Edit, X10 W%width% Vasin, B0CLQWN1CV
    Gui, add, Button, XP+%width% Default GStartScrape, Go
    Gui, add, Edit, X10 W%width% Vtitle, Title
    Gui, add, Edit, X10 W%width% Vdescription, Description
    Gui, add, Edit, X10 W%width% Vprice, Price
    Gui, add, Edit, X10 W%width% Vimage_path, C:\Users\Elazar\Downloads
    Gui, add, Button, XP+%width% GPickImagePath, ...
    Gui, Show
Return
; ==============================================================================
;                                 StartScrape
; ==============================================================================
StartScrape:
    Gui, Submit, NoHide
    src := DownloadSource(asin)

    GuiControl, , title, % GetTitle(src)
    GuiControl, , description, % GetDescription(src)
    GuiControl, , price, % GetPrice(src)
    GetImages(src, image_path, asin)

    Beep(1200, 50)
Return
; ==============================================================================
;                                DownloadSource
; ==============================================================================
DownloadSource(asin)
{
    UrlDownloadToFile, https://www.amazon.de/dp/%asin%, amazon_source.html
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
GetTitle(ByRef src)
{
    RegExMatch(src, "(?<=<title>).+?(?=\s?: Amazon)", title)
    Return title
}
; ==============================================================================
;                                GetDescription
; ==============================================================================
GetDescription(ByRef src)
{
    Return 0
}
; ==============================================================================
;                                   GetPrice
; ==============================================================================
GetPrice(ByRef src)
{
    Return 0
}
; ==============================================================================
;                                   GetImages
; ==============================================================================
GetImages(ByRef src, path, asin)
{
    RTrim(path, "/\")

    If (!FileExist(path))
    {
        MsgBox, Invalid directory.
        Return
    }
    FileCreateDir, %path%\%asin%

    pos := 1
    While (pos := RegExMatch(src, "(?<=""hiRes"":"")https:\/\/m.media-amazon.com\/images\/I\/(.+?_AC_SL\d{4}_.jpg)", match, pos + StrLen(match)))
    {
        UrlDownloadToFile, %match%, %path%\%asin%\%match1%
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
