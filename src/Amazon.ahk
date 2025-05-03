; ==============================================================================
;                                      GUI
; ==============================================================================
#F1::
AmazonGUI:
    Gui, Destroy

    width := 320
    Gui, add, Edit, X10 W%width% Vasin, B0C665CS9G
    Gui, add, Button, XP+%width% Default GStartScrape, Go
    Gui, add, DDL, XP+28 W42 Vregion Choose1, UK|DE|AU

    Gui, add, Edit, X10 W%width% Vtitle, Title
    Gui, add, Button, XP+%width% GCopyTitle, Copy

    Gui, add, Edit, X10 W%width% Vdescription, Description
    Gui, add, Button, XP+%width% GCopyDescription, Copy

    Gui, add, Edit, X10 W%width% Vprice, Price
    Gui, add, Edit, X10 W%width% Vimage_path, C:\Users\Elazar\Downloads\AmazonPhotos
    Gui, add, Button, XP+%width% GPickImagePath, ...
    Gui, Show
Return
; ==============================================================================
;                                 StartScrape
; ==============================================================================
StartScrape:
    Gui, Submit, NoHide
    src := DownloadSource(asin, region)

    GuiControl, , title, % GetTitle(src)
    GuiControl, , description, % GetDescription(src)
    GuiControl, , price, % GetPrice(src)

    Gui, Submit, NoHide
    DownloadImages(src, image_path, StrReplace(RTrim(title), "/", "_"))
    Beep(1200, 50)
Return
; ==============================================================================
;                                DownloadSource
; ==============================================================================
DownloadSource(asin, region)
{
    site := "https://www.amazon.co.uk/dp/" . asin
    if (region == "DE")
        site := "https://www.amazon.de/dp/" . asin
    else if (region == "AU")
        site := "https://www.amazon.com.au/dp/" . asin

    UrlDownloadToFile, %site%/%asin%, amazon_source.html
    FileRead, src_str, amazon_source.html

    ; TODO: Page not found.
    Return src_str
}
; ==============================================================================
;                                   GetTitle
; ==============================================================================
GetTitle(ByRef src)
{
    RegExMatch(src, "(?<=<title>).+?(?=\s?: Amazon)", title)
    ; title := StrReplace(title, ",", " ")
    ; title := StrReplace(title, "[", " ")
    ; title := StrReplace(title, "]", " ")
    ; title := StrReplace(title, "(", " ")
    ; title := StrReplace(title, ")", " ")
    ; title := StrReplace(title, "-", " ")
    title := StrReplace(title, "&amp;", " & ")
    title := StrReplace(title, "  ", " ")

    Return title
}
; ==============================================================================
;                                GetDescription
; ==============================================================================
GetDescription(ByRef src)
{
    pos := 1
    pos := RegExMatch(src, "<table class=""a-normal a-spacing-micro.+?<\/table>", desc)
    pos := RegExMatch(src, "<ul class=""a-unordered-list a-vertical a-spacing-mini"".+?<\/ul>", match, pos + StrLen(desc))
    desc .= "<hr>" . match . "<hr><style>table { width: 30em; } .a-text-bold { font-weight: 700; }</style>"
    desc := StrReplace(desc, "ã€", "[")
    desc := StrReplace(desc, "ã€‘", "]")
    Return desc
}
; ==============================================================================
;                                   GetPrice
; ==============================================================================
GetPrice(ByRef src)
{
    RegExMatch(src, "(?<=<span class=""a-price-whole"">)\d+", price)
    RegExMatch(src, "(?<=<span class=""a-price-fraction"">)\d+", match)
    price .= "." . match
    Return price
}
; ==============================================================================
;                                DownloadImages
; ==============================================================================
DownloadImages(ByRef src, path, sub_dir)
{
    RTrim(path, "/\")
    FileCreateDir, %path%\%sub_dir%

    If (!FileExist(path))
    {
        MsgBox, Invalid directory.
        Return
    }

    ;@AHK++AlignAssignmentOn
    pos    := 1
    needle := "(?<=""hiRes"":"")https:\/\/m.media-amazon.com\/images\/I\/(.+?_SL\d{4}_\.jpg)"
    ;@AHK++AlignAssignmentOff

    While (pos := RegExMatch(src, needle, match, pos + StrLen(match)))
        UrlDownloadToFile, %match%, %path%\%sub_dir%\%match1%
}

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
