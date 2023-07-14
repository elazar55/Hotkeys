; ==============================================================================
;                             Auto Exexcute section
; ==============================================================================
; Script attributes
#NoEnv
#SingleInstance, Force
SetTitleMatchMode, 2
SetBatchLines, 10
SendMode, Event

; Excluded windows
GroupAdd, excluded_windows, ahk_exe code.exe
GroupAdd, excluded_windows, ahk_exe cmd.exe
GroupAdd, excluded_windows, ahk_exe mintty.exe

; Included files will auto execute as well
#Include, Helpers.ahk
#Include, Hearthstone.ahk
#Include, Misc.ahk
#Include, PicrossTouch.ahk

; Unset due to includes setting it
#IfWinActive
; ==============================================================================
;                                      GUI
; ==============================================================================
#m::
    ; Gui, +AlwaysOnTop
    Gui, Add, Button, W320 GScrape, Scrape
    Gui, Add, Button, W320 GTileWindows, Tile Windows
    Gui, Add, Button, W320 GClean, Clean
    Gui, Show
Return
; ==============================================================================
;                                     Clean
; ==============================================================================
Clean:
    FileRemoveDir, images, 1
Return
; ==============================================================================
;                                   Set Price
; ==============================================================================
#p::
    Clipboard =
    Send, ^c
    ClipWait, 1
    increment := 0.40

    If (Clipboard >= 15)
        increment := 4
    Else If (Clipboard >= 5)
        increment := 2
    Else If (Clipboard >= 2)
        increment := 1

    Clipboard := Format("{:.2f}", Clipboard + increment + 0.01)
    ; MsgBox, % Format("{:.2f}", Clipboard + increment + 0.01)
    Send, ^v
    Beep(1200, 20)
Return
; ==============================================================================
;                                 Sentence Case
; ==============================================================================
#s::
    Send, ^c
    ClipWait, 1

    StringLower, Clipboard, Clipboard
    Clipboard := RegExReplace(Clipboard, "(?<=^|\.|\. |】)(\w)", "$U0")

    Send, ^v
    Beep(1200, 20)
Return
; ==============================================================================
;                                  Title Case
; ==============================================================================
#t::
    Send, ^c
    ClipWait, 1

    StringLower, Clipboard, Clipboard
    Clipboard := RegExReplace(Clipboard, "(?<=\w)(\.)(?=\w)", " ")
    Clipboard := RegExReplace(Clipboard, "(\b\w(?=\w{3,}))", "$U0")

    Send, ^v
    Beep(1200, 20)
Return
; ==============================================================================
;                                 Tile Windows
; ==============================================================================
TileWindows:
    SetTitleMatchMode Regex
    WinGet, window_count, List, .+, , Start Menu|Program Manager|Chrome|Code|Hotkeys|Window Spy

    ; @AHK++AlignAssignmentOn
    rows          := Min(Ceil(window_count / 2), 2)
    columns       := Ceil(window_count / rows)
    slots         := rows * columns
    carry         := slots - window_count
    left_offset   := 7
    top_offset    := 7
    screen_width  := 1920
    screen_height  = 1050
    window_width  := (screen_width / columns) + (left_offset * 2)
    window_height := (screen_height / rows) + (top_offset)
    ; @AHK++AlignAssignmentOff

    Loop, %window_count%
    {
        ; @AHK++AlignAssignmentOn
        id      := window_count%A_Index%
        x_index := Floor((A_Index - 1) / rows)
        y_index := Mod(A_Index - 1, rows)
        x_pos   := ((window_width - left_offset * 2) * x_index) - left_offset
        y_pos   := (window_height - top_offset) * y_index
        ; @AHK++AlignAssignmentOff
        MsgBox, %id%
        If (carry && A_Index = window_count)
            window_height := ((screen_height / rows) * (carry + 1)) + (top_offset)

        WinActivate, ahk_id %id%
        WinMove, ahk_id %id%,, x_pos, y_pos, window_width, window_height
        ; MsgBox, X: %x_index%`nY: %y_index%
    }

    SetTitleMatchMode 1
Return
; ==============================================================================
;                                    Reload
; ==============================================================================
#r::
    Reload
Return
; ==============================================================================
;                                Jobalots Scrape
; ==============================================================================
Scrape:
    ; @AHK++AlignAssignmentOn
    urls        := []
    titles      := []
    prices      := []
    order_html  := "order.html"
    images      := []
    skus        := []
    weights     := []
    output_file := "output.csv"
    asins       := []
    seperator   := ","
    ; @AHK++AlignAssignmentOff

    FileDelete, %output_file%

    ; Gather SKUs / links to each product from the order
    If (!ScrapeOrderLinks(order_html, urls, titles, prices))
    {
        MsgBox Error scraping %order_html%.
        Return
    }

    ; CSV column headers
    FileAppend
        , % "Image" . seperator
        . "Title" . seperator
        . "Price" . seperator
        . "Weight" . seperator
        . "SKU" . seperator
        . "ASIN" . "`n"
        , %output_file%

    ; Loop through and scrape data about each product
    For index, url in urls
    {
        If (!ScrapeProduct(url, images, skus, weights, asins))
        {
            MsgBox Error scraping data.
            Return
        }

        ; Smoke test. Nothing should be blank
        If (images[index] = "")
            images[index] := "Blank"
        If (titles[index] = "")
            titles[index] := "Blank"
        If (prices[index] = "")
            prices[index] := "Blank"
        If (weights[index] = "")
            weights[index] := "Blank"
        If (skus[index] = "")
            skus[index] := "Blank"
        If (asins[index] = "")
            asins[index] := "Blank"

        ; Write out to the file
        FileAppend
            , % images[index] . seperator
            . """" . titles[index] . """" . seperator
            . prices[index] . seperator
            . weights[index] . seperator
            . """=HYPERLINK(""eu.jobalots.com/products/" . skus[index] . """, """ . skus[index] . """)""" . seperator
            . """=HYPERLINK(""amazon.de/dp/" . asins[index] . """, """ . asins[index] . """)""`n"
            , %output_file%

        ; A progress indicator
        ToolTip, % titles[index]
    }
    Beep(1200, 25)
    ToolTip
Return
; ==============================================================================
;                         Scrape data from product page
; ==============================================================================
ScrapeProduct(address, images, skus, weights, asins)
{
    source_file := "item.html"
    UrlDownloadToFile, %address%, %source_file%

    If (ErrorLevel)
        Return False

    FileRead, source_string, %source_file%

    If (InStr(source_string, "404 Not Found"))
    {
        images.Push("ND")
        skus.Push("ND")
        weights.Push("ND")
        asins.Push("ND")

        Return true
    }

    RegExMatch(source_string, "(?<=<td><img src="").+?(?=""><\/td>)", image)
    RegExMatch(source_string, "(?<=\Q<meta property=""og:url"" content=""https://eu.jobalots.com/products/\E)\w+", sku)
    RegExMatch(source_string, "(?<=\Q><strong>Weight:</strong>\E\s)\d+\.\d+", weight)
    RegExMatch(source_string, "â‚¬\d+\.\d+ (\w+)", asin)

    images.Push(image)
    skus.Push(sku)
    weights.Push(weight)
    asins.Push(asin1)

    ; Download product images
    dl_path := "images/" . sku
    If (!FileExist(dl_path))
        FileCreateDir, %dl_path%

    match_pos := 1
    While (match_pos := RegExMatch(source_string, "(?<=<a href="")//eu.jobalots.com/cdn/shop/products/.+?.jpg.*?(?="" class=)", match, match_pos + StrLen(match)))
    {
        UrlDownloadToFile, https:%match%, %dl_path%/%A_Index%.jpg
        If (ErrorLevel)
        {
            MsgBox, Error downloading https:%match% to %dl_path%/%A_Index%.jpg
            Return
        }
    }

    Return true
}
; ==============================================================================
;                               Scrape Order URLs
; ==============================================================================
ScrapeOrderLinks(order_html, urls, titles, prices)
{
    FileRead, file_string, %order_html%

    If (ErrorLevel)
        Return False

    match_pos := 1
    While (match_pos)
    {
        match_pos := RegExMatch(file_string, "(?<=https:\/\/jobalots.com\/products\/)\w+", url_match, match_pos + StrLen(price_match))
        match_pos := RegExMatch(file_string, "s)(?<=Jobalots auction - ).+?(?=<\/a>)", title_match, match_pos + StrLen(url_match))
        match_pos := RegExMatch(file_string, "s)data-label=""Price"">.*?translate=""no"">â‚¬(\d+),(\d+)", price_match, match_pos + StrLen(title_match))

        If (match_pos)
        {
            urls.Push("https://eu.jobalots.com/products/" . url_match)

            title_match := StrReplace(title_match, "`r`n")
            title_match := RegExReplace(title_match, "\s{2,}")
            title_match := Trim(title_match)
            titles.Push(title_match)

            prices.Push(price_match1 . "." . price_match2)
        }
    }

    Return True
}
