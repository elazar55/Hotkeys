; ==============================================================================
;                                      GUI
; ==============================================================================
#F1::
AmazonGUI:
    Gui, Destroy
    LoadLast(asin, region)

    width := 512
    Gui, add, Edit, X10 W%width% Vasin, %asin%
    Gui, add, Button, XP+%width% Default GStartScrape, Go
    Gui, add, DDL, AltSubmit XP+28 W42 Vregion Choose%region%, UK|DE|AU

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
;                                    loadINI
; ==============================================================================
LoadLast(ByRef asin, ByRef region)
{
    IniRead, asin, amazon_scraper.ini, last, asin, Emptykey
    IniRead, region, amazon_scraper.ini, last, region, 1
}
WriteLast(asin, region)
{
    IniWrite, %asin%, amazon_scraper.ini, last, asin
    IniWrite, %region%, amazon_scraper.ini, last, region
}
; ==============================================================================
;                                 StartScrape
; ==============================================================================
StartScrape:
    Gui, Submit, NoHide
    WriteLast(asin, region)

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
    if (region == 2)
        site := "https://www.amazon.de/dp"
    else if (region == 3)
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
    title := StrReplace(title, "&quot;", """")
    title := StrReplace(title, "&#x27;", "'")
    title := StrReplace(title, "&amp;", " & ")
    title := StrReplace(title, "â€", """")
    title := StrReplace(title, "ã€", "【")
    title := StrReplace(title, "", "")
    title := StrReplace(title, "Â®", "®")
    title := StrReplace(title, "  ", " ")

    Return title
}
; ==============================================================================
;                                GetDescription
; ==============================================================================
GetDescription(ByRef src)
{
    RegExMatch(src, "<table class=""a-normal a-spacing-micro.+?<\/table>", desc)
    RegExMatch(src, "<ul class=""a-unordered-list a-vertical a-spacing-\w+?"".+?<\/ul>", match)
    style := "<hr><style>table { width: 30em; } .a-text-bold { font-weight: 700; }</style>"

    desc .= "<hr>" . match . style
    desc := StrReplace(desc, "ã€", "[")
    desc := StrReplace(desc, "ã€‘", "]")
    desc := StrReplace(desc, "Î©", "Ω")
    desc := StrReplace(desc, "â€“", "-")
    desc := StrReplace(desc, "âœ”", "✔")
    desc := StrReplace(desc, "â€Ž", "")
    desc := StrReplace(desc, "Â°", "°")

    FileDelete, description.html
    FileAppend, %desc%, description.html

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
    title := SubStr(title, 1, 10)
    title := StrReplace(title, "/", "_")
    title := StrReplace(title, ".", "_")
    title := RTrim(title)
    path  := RTrim(path, "/\")

    FileRemoveDir, %path%, 1
    FileCreateDir, %path%\%title%
    If (!FileExist(path))
    {
        MsgBox, Invalid directory.
        Return
    }

    ;@AHK++AlignAssignmentOn
    str_start := InStr(src, "{""dataInJson"":")
    str_end   := InStr(src, "');", , str_start)
    sub_src   := SubStr(src, str_start, str_end - str_start)
    ;@AHK++AlignAssignmentOff
    FileDelete, var_json.json
    FileAppend, %sub_src%, var_json.json

    RegExMatch(src, "(""[-\w+\.\s:\\\/\(\)&]+?""):\{""asin"":(""" . asin . """)\}", match)

    If (match1 == "")
    {
        pos := 1
        while (pos := RegExMatch(src, "(?<=""hiRes"":"")https:\/\/m\.media-amazon\.com\/images\/I\/([\w+-]+?)L\._AC_SL1\d\d\d_\.jpg", image, pos + StrLen(image)))
        {
            UrlDownloadToFile, %image%, %path%\%title%\%image1%.jpg
        }
        Return
    }

    pos := InStr(src, match1 . ":[") + StrLen(match1)
    while (pos := RegExMatch(src, "(?<=""hiRes"":"")(https:\/\/m\.media-amazon\.com\/images\/I\/.+?\.jpg)|(\],""[\w :\.&\\\/+]+?"":\[\{""large"":"")", image, pos + StrLen(image)))
    {
        ; MsgBox, %image2%
        If (image1 == "")
        {
            break
        }
        UrlDownloadToFile, %image1%, %path%\%title%\%A_Index%.jpg
    }
    Return
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
; ==============================================================================
;                                   WriteCSV
; ==============================================================================
WriteCSV(data)
{

}
