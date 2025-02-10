; ==============================================================================
;                                      GUI
; ==============================================================================
AmazonGUI:
    width := 320
    Gui, Destroy
    Gui, add, Edit, R9 W%width% Vasin, B01BKKKVPW`nB0BPB7NCPZ
    Gui, Add, Button, Default W32 XP+%width% GAmazonScrape, Scrape
    Gui, Show
Return

; ==============================================================================
;                                 AmazonScrape
; ==============================================================================
AmazonScrape:
    Gui, Submit

    output_file := "C:\\Users\\Elazar\\Downloads\\amazon_drafts.csv"
    output_buf  :=

    ; ============================== CSV Header ===============================
    output_buf := "#INFO,Version=0.0.2,Template= eBay-draft-listings-template_IE,,,,,,,,`n"

    ; ========================= 2nd Line Headers ===========================
    Loop, Parse, asin, `n
    {
        data := ScrapeData(A_LoopField)

        If (data == "")
            Continue

        For k, v in data
            output_buf := output_buf . k . ","

        Break
    }

    ; ====================== Scrape data for each entry ========================
    Loop, Parse, asin, `n
    {
        data := ScrapeData(A_LoopField)

        If (data == "")
            Continue

        ; ===================== Add data to output buffer ======================
        output_buf := output_buf . "`n"

        For k, v in data
            output_buf := output_buf . v . ","
    }

    ; ========================= Write buffer to file ===========================
    FileDelete, %output_file%
    FileAppend, %output_buf%, %output_file%

    Beep(1500, 25)
Return
; ==============================================================================
;                                 Scrape Data
; ==============================================================================
ScrapeData(asin)
{
    data := []
    ; ========================= Download Product Page ==========================
    UrlDownloadToFile, https://www.amazon.co.uk/dp/%asin%, amazon_source.html
    FileRead, src_str, amazon_source.html

    If (!IsValidPage(src_str))
    {
        MsgBox, %asin% not found.
        Return
    }
    ; =============================== Quantity =================================
    data["Quantity"] := 1

    ; ============================= Template Type ==============================
    data["Action(SiteID=Ireland|Country=IE|Currency=EUR|Version=1193|CC=UTF-8)`"] := "Draft"

    ; ========================== Custom label (SKU) ============================
    data["Custom label (SKU)"] := asin

    ; ==================================== UPC =====================================
    data["UPC"] := ""

    ; ================================= Title ==================================
    RegExMatch(src_str, "(?<=a-size-large product-title-word-break"">).+?(?=<\/span>)", match)
    data["Title"] := """" . StrReplace(Trim(match),  "&#34;", """""") . """"

    ; ================================ Images ==================================
    data["Item photo URL"] := GetProductImages(src_str)

    ; =============================== Quantity =================================
    data["Quantity"] := ""

    ; ============================= Condition ID ===============================
    data["Condition ID"] := "NEW"

    ; ============================= Format ===============================
    data["Format"] := "FixedPrice"

    ; ============================== Category ID ===============================
    data["Category ID"] := 47140

    ; ============================== Description ===============================
    ;@AHK++AlignAssignmentOn
    start               := "<table class=""a-normal a-spacing-micro"">"
    mid                 := ".+?"
    ending              := "</table>"
    pos                 := RegExMatch(src_str, start . mid . ending, match)
    data["Description"] := match

    start               := "<ul class=""a-unordered-list a-vertical a-spacing-mini"">"
    mid                 := ".+?"
    ending              := "</ul>"
    pos                 := RegExMatch(src_str, start . mid . ending, match, pos)
    data["Description"] := data["Description"] . match
    ;@AHK++AlignAssignmentOff

    ; RegExMatch(src_str, "<ul class=""a-unordered-list a-vertical a-spacing-mini"">.+?<\/ul>", match)
    ; data["Description"] := data["Description"] . match
    ; RegExMatch(src_str, "<div id=""aplus_feature_div"".+?(?=Compare with similar items)", match)
    ; data["Description"] := data["Description"] . match
    data["Description"] := StrReplace(data["Description"], "<noscript>", "")
    data["Description"] := StrReplace(data["Description"], "</noscript>", "")
    data["Description"] := StrReplace(data["Description"], "`n", "")
    data["Description"] := StrReplace(data["Description"], "`r", "")
    FileDelete, C:/Users/Elazar/Downloads/Description_%asin%.html
    FileAppend, % data["Description"], C:/Users/Elazar/Downloads/Description_%asin%.html
    data["Description"] := StrReplace(data["Description"], """", """""")
    data["Description"] := """" . data["Description"] . """"

    ; ================================= Price ==================================
    RegExMatch(src_str, "(?<=a-price-whole"">)\d+", whole)
    RegExMatch(src_str, "(?<=a-price-fraction"">)\d+", fract)
    data["Price"] := whole . "." . fract
    If (data["Price"] == ".")
        data["Price"] := ""

    return data
}
; ==============================================================================
;                                  IsValidPage
; ==============================================================================
IsValidPage(html_str)
{
    If (InStr(html_str, "Page Not Found"))
        Return False

    Return true
}
; ==============================================================================
;                              Get Product Images
; ==============================================================================
GetProductImages(ByRef file_string)
{
    ;@AHK++AlignAssignmentOn
    needle := "(?<=""hiRes"":"")https://m.media-amazon.com/images/I/.+?jpg"
    pos    := RegExMatch(file_string, needle, first_match)
    images := first_match
    ;@AHK++AlignAssignmentOff

    while (pos := RegExMatch(file_string, needle, match, pos + StrLen(first_match)))
    {
        If (match == first_match)
            Break

        images := images . "|" . match
    }
    Return images
}
; ==============================================================================
;                                Get Description
; ==============================================================================
; GetDescription(src, pattern, ByRef pos = 1)
; {
;     pos := RegExMatch(src, pattern, match, pos)
;     Return match
; }
