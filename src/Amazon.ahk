; ==============================================================================
;                                      GUI
; ==============================================================================
#F1::
AmazonGUI:
    Gui, Destroy

    width := 320
    Gui, add, Edit, X10 W%width% Vasin, B08LKTXYNQ
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
    DownloadImages(src, image_path, title, asin)
    Beep(1200, 50)
Return
; ==============================================================================
;                                DownloadSource
; ==============================================================================
DownloadSource(asin, region)
{
    site := "https://www.amazon.co.uk/dp"
    if (region == "DE")
        site := "https://www.amazon.de/dp"
    else if (region == "AU")
        site := "https://www.amazon.com.au/dp"

    src_filename := "amazon_source"

    FileDelete, FilePattern %src_filename%
    UrlDownloadToFile, %site%/%asin%, %src_filename%
    FileReadLine, first_line, %src_filename%, 1

    If (InStr(first_line, "‹"))
    {
        RunWait, "7z.exe" x -y %src_filename%
        FileMove, %src_filename%~, %src_filename%, 1
    }
    FileRead, src_str, %src_filename%

    ; TODO: Page not found.
    Return src_str
}
; ==============================================================================
;                                   GetTitle
; ==============================================================================
GetTitle(ByRef src)
{
    RegExMatch(src, "(?<=<title>).+?(?=\s?: Amazon)", title)
    title := StrReplace(title, ",", " ")
    title := StrReplace(title, "[", " ")
    title := StrReplace(title, "]", " ")
    title := StrReplace(title, "(", " ")
    title := StrReplace(title, ")", " ")
    title := StrReplace(title, "-", " ")
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
DownloadImages(ByRef src, path, title, asin)
{
    title := SubStr(title, 1, 30)
    title := StrReplace(title, "/", "_")
    title := StrReplace(title, ".", "_")
    title := RTrim(title)
    path := RTrim(path, "/\")

    FileCreateDir, %path%\%title%
    If (!FileExist(path))
    {
        MsgBox, Invalid directory.
        Return
    }

    RegExMatch(src, "(""[\w+\.\s\\\/\(\)]+?""):\{""asin"":(""" . asin . """)\}", match)
    ; MsgBox, %match1% - %match2%

    pos := InStr(src, match1 . ":[") + StrLen(match1)
    ; MsgBox, %pos%
    while (pos := RegExMatch(src, "(?<=""hiRes"":"")(https:\/\/m\.media-amazon\.com\/images\/I\/.+?\.jpg)|(""[\w\.\s\\\/\(\)]+?"":\[)", image, pos + StrLen(image)))
    {
        ; MsgBox, %image1% : %image2%
        If (image1 == "")
        {
            break
        }
        UrlDownloadToFile, %image1%, %path%\%title%\%A_Index%.jpg
        ; MsgBox, %path%\%title%\%A_Index%.jpg
    }
    ;TODO Fallback branch
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
