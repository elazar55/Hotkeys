﻿global data_buffer := ""
; ==============================================================================
;                                      GUI
; ==============================================================================
ScraperGUI:
    width := 320
    Gui, Destroy
    Gui, Add, Button, W%width% GScrape, Scrape
    Gui, Add, Button, W%width% GOpenOrder, Open order.html
    Gui, Add, Button, W%width% GOpenLatest, Open latest output
    Gui, Show
Return
; ==============================================================================
;                                Write Out Data
; ==============================================================================
WriteOutData(image, title, price, weight, sku, asin, output_file, rrp)
{
    seperator := ","
    if (sku != "SKU")
        sku := """=HYPERLINK(""eu.jobalots.com/products/" . sku . """, """ . sku . """)"""
    if (asin != "" && asin != "ASIN")
        asin := """=HYPERLINK(""amazon.de/dp/" . asin . """, """ . asin . """)"""

    global data_buffer
    data_buffer = % data_buffer
        . image . seperator
        . """" . title . """" . seperator
        . price . seperator
        . weight . seperator
        . sku . seperator
        . asin . seperator
        . rrp . "`n"
}
; ==============================================================================
;                              Create Progress Bar
; ==============================================================================
CreateProgressBar()
{
    global progress
    Gui, Add, Progress, w500 h20 cBlue vprogress
    Gui, show, AutoSize
}
; ==============================================================================
;                                Jobalots Scrape
; ==============================================================================
Scrape:
    Gui, Destroy
    SetBatchLines, -1
    global data_buffer := ""

    ; @AHK++AlignAssignmentOn
    urls       := []
    titles     := []
    prices     := []
    order_html := "orders_order.html"
    images     := []
    skus       := []
    weights    := []
    asins      := []
    seperator  := ","
    jleu       :=
    ; @AHK++AlignAssignmentOff

    ; Gather SKUs / links to each product from the order
    If (!ScrapeOrderLinks(order_html, urls, titles, prices, skus, jleu))
    {
        MsgBox Error scraping %order_html%.
        Return
    }
    outputFolder := "../" . "Orders" . "/" . jleu
    output_file := outputFolder . "/" . "output.csv"

    ; Create directory if it doesn't exist
    If (!FileExist(outputFolder))
        FileCreateDir, %outputFolder%

    ; Results header
    FileDelete, %output_file%
    WriteOutData("Image", "Title", "Price", "Weight", "SKU", "ASIN", output_file, "RRP")
    CreateProgressBar()

    ; Loop through and scrape data about each product
    For index, url in urls
    {
        extra_data := []
        If (!ScrapeProduct(url, images, skus, weights, asins, extra_data, jleu))
        {
            MsgBox Error scraping data.
            Return
        }

        ; Assert
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

        ; Lots and mini lots
        If (extra_data.Length() / 7 > 1)
        {
            ; Write out to the file
            ; If the page has multiple items, exclude the parent ASIN
            WriteOutData(images[index], titles[index], prices[index], weights[index], skus[index], "", output_file, "-")

            ; Condition of sub-items
            RegExMatch(titles[index], "Brand New |Customer Returns ", match)

            Loop % (extra_data.Length() / 7)
            {
                j := (7 * (A_Index - 1))

                ; Clean up tags from extra_data images
                extra_data[j + 1] := StrReplace(extra_data[j + 1], "<img src=""")
                extra_data[j + 1] := StrReplace(extra_data[j + 1], """>")
                WriteOutData(extra_data[j + 1], extra_data[j + 3] . " x " . match . extra_data[j + 2], "-", "-", skus[index], extra_data[j + 6], output_file, extra_data[j + 4])
            }
        }
        else
        {
            ; If the item is single, include ASIN
            WriteOutData(images[index], titles[index], prices[index], weights[index], skus[index], asins[index], output_file, extra_data[4])
        }
        ; Update progress bar
        GuiControl, , textbox, % titles[index]
        GuiControl, , progress, % index / urls.Length() * 100
    }
    ; Write to file
    FileAppend, %data_buffer%, %output_file%

    GuiControl, , textbox, Finished
    SetBatchLines, 1

    ; Open output
    editor := "C:\Users\Elazar\AppData\Local\Programs\Microsoft VS Code\code.exe"
    Run, %editor% %output_file%

    Gui, Destroy
    Beep(1200, 25)
Return
; ==============================================================================
;                               Scrape Order URLs
; ==============================================================================
ScrapeOrderLinks(order_html, urls, titles, prices, skus, ByRef jleu)
{
    FileRead, file_string, %order_html%

    If (ErrorLevel)
    {
        MsgBox, Error reading %order_html%
        Return False
    }
    ; ================================== GUI ===================================
    global textbox
    Gui, Add, Text, w500 h40 vtextbox
    Gui, show
    ; ==========================================================================

    RegExMatch(file_string, "jleu\w+", jleu)

    match_pos := 1
    While (match_pos)
    {
        match_pos := RegExMatch(file_string, "(?<=jobalots.com\/products\/).+?(?="")", url_match, match_pos + StrLen(price_match))
        match_pos := RegExMatch(file_string, "s)(?<=Jobalots auction - ).+?(?=<\/a>)", title_match, match_pos + StrLen(url_match))
        match_pos := RegExMatch(file_string, "s)data-label=""Price"">.*?translate=""no"">â‚¬(\d+),(\d+)", price_match, match_pos + StrLen(title_match))

        If (match_pos)
        {
            urls.Push("https://eu.jobalots.com/products/" . url_match)
            skus.Push(url_match)

            title_match := StrReplace(title_match, "`r`n")
            title_match := RegExReplace(title_match, "\s{2,}")
            title_match := Trim(title_match)
            titles.Push(title_match)
            prices.Push(price_match1 . "." . price_match2)

            GuiControl,, textbox, %title_match%
        }
    }
    Return True
}
; ==============================================================================
;                              Scrape product page
; ==============================================================================
ScrapeProduct(address, images, skus, weights, asins, extra_data, jleu)
{
    source_file := "orders_item.html"
    UrlDownloadToFile, %address%, %source_file%

    If (ErrorLevel)
        Return False

    FileRead, source_string, %source_file%

    If (InStr(source_string, "404 Not Found"))
    {
        images.Push("ND")
        weights.Push("ND")
        asins.Push("ND")

        Return true
    }

    RegExMatch(source_string, "(?<=<td><img src="").+?(?=""><\/td>)", image)
    RegExMatch(source_string, "(?<=\Q<meta property=""og:url"" content=""https://eu.jobalots.com/products/\E).+?(?="">)", sku)
    RegExMatch(source_string, "(?<=\Q><strong>Weight:</strong>\E\s)\d+\.\d+", weight)
    RegExMatch(source_string, "â‚¬\d+\.\d+ (\w+)", asin)

    ; No image
    If (InStr(image, "AVAILABLE.png"))
        images.Push("N/A")
    Else
        images.Push(image)

    weights.Push(weight)
    asins.Push(asin1)

    ; Extra data
    RegexMatchAll(source_string, extra_data, "(?<=<td>).+?(?=<\/td>)")

    ; Download product images
    subfolder_name := "../" . "Orders" . "/" . jleu . "/" . sku . "/"
    DownloadImagesFromString(source_string, subfolder_name, sku)
    Return true
}
; ==============================================================================
;                                Regex Match All
; ==============================================================================
RegexMatchAll(haystack, results, pattern)
{
    match_pos := 1
    While (match_pos := RegExMatch(haystack, pattern, match, match_pos + StrLen(match)))
        results.Push(match)
}
; ==============================================================================
;                          Download Images From String
; ==============================================================================
DownloadImagesFromString(source_string, subfolder_name, sku)
{
    ; Create directory if it doesn't exist
    If (!FileExist(subfolder_name))
        FileCreateDir, %subfolder_name%

    image_urls := []
    RegexMatchAll(source_string, image_urls, "(?<=<a href="")//eu.jobalots.com/cdn/shop/\w+/.+?.jpg.*?(?="" class=)")
    For i, url in image_urls
    {
        file_path = %subfolder_name%/%sku%_%i%.jpg

        If (!FileExist(file_path))
        {
            UrlDownloadToFile, https:%url%, %file_path%

            If (ErrorLevel)
            {
                MsgBox, Error downloading https:%url% to %file_path%
                Return
            }
        }
    }
}
; ==============================================================================
;                                Open order.html
; ==============================================================================
OpenOrder:
    Run, notepad.exe orders_order.html, , ,
Return
; ==============================================================================
;                                Open Latest
; ==============================================================================
OpenLatest:
    latest :=
    editor := "C:\Users\Elazar\AppData\Local\Programs\Microsoft VS Code\code.exe"

    Loop, Files, ../Orders/*, D
    {
        latest := A_LoopFileName
        MsgBox, %latest%
    }
    Run, %editor% ../Orders/%latest%/output.csv
Return
