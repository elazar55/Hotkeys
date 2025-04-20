; ==============================================================================
;                                      GUI
; ==============================================================================
#F1::
AmazonGUI:
    Gui, Destroy

    width := 320
    Gui, add, Edit, X10 W%width% Vasin, B0CPPTFN4L
    Gui, add, Button, XP+%width% Default GStartScrape, Go

    Gui, add, Edit, X10 W%width% Vtitle, Title
    Gui, add, Button, XP+%width% GCopyTitle, Copy

    Gui, add, Edit, X10 W%width% Vdescription, Description
    Gui, add, Button, XP+%width% GCopyDescription, Copy

    Gui, add, Edit, X10 W%width% Vprice, Price
    Gui, add, Edit, X10 W%width% Vimage_path, C:\Users\Elazar\Downloads
    Gui, add, Button, XP+%width% GPickImagePath, ...
    Gui, Show
Return
; ==============================================================================
;                                 PickImagePath
; ==============================================================================
PickImagePath:
    FileSelectFolder, dir
    GuiControl, , image_path, %dir%
Return
; ==============================================================================
;                                  CopyTitle
; ==============================================================================
CopyTitle:
    Clipboard := title
Return
; ==============================================================================
;                               CopyDescription
; ==============================================================================
CopyDescription:
    Clipboard := description
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

    Gui, Submit, NoHide
    RegExMatch(title, "(\w+\s){5}", title_match)
    DownloadImages(src, image_path, RTrim(title_match))
    Beep(1200, 50)
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
GetTitle(ByRef src)
{
    RegExMatch(src, "(?<=<title>).+?(?=\s?: Amazon)", title)
    title := StrReplace(title, ",", "")
    title := StrReplace(title, "[", "")
    title := StrReplace(title, "]", "")
    title := StrReplace(title, "(", "")
    title := StrReplace(title, ")", "")
    title := StrReplace(title, "-", "")
    title := StrReplace(title, "  ", " ")

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
;                                DownloadImages
; ==============================================================================
DownloadImages(ByRef src, path, sub_dir)
{
    RTrim(path, "/\")

    If (!FileExist(path))
    {
        MsgBox, Invalid directory.
        Return
    }
    FileCreateDir, %path%\%sub_dir%

    ;@AHK++AlignAssignmentOn
    pos    := 1
    needle := "(?<=""hiRes"":"")https:\/\/m.media-amazon.com\/images\/I\/(.+?_AC_SL\d{4}_\.jpg)"
    ;@AHK++AlignAssignmentOff

    While (pos := RegExMatch(src, needle, match, pos + StrLen(match)))
        UrlDownloadToFile, %match%, %path%\%sub_dir%\%match1%
}
