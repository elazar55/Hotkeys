; ==============================================================================
;                         Append CSV Headers to a File
; ==============================================================================
AppendHeaderToFile(file)
{
    seperator := ","
    FileDelete, %file%
    FileAppend
        , % "Image" . seperator
        . "Title" . seperator
        . "Price" . seperator
        . "Weight" . seperator
        . "SKU" . seperator
        . "ASIN" . "`n"
        , %file%
}
; ==============================================================================
;                                Write Out Data
; ==============================================================================
WriteOutData(image, title, price, weight, sku, asin, output_file)
{
    seperator := ","

    FileAppend
        , % image . seperator
        . """" . title . """" . seperator
        . price . seperator
        . weight . seperator
        . """=HYPERLINK(""eu.jobalots.com/products/" . sku . """, """ . sku . """)""" . seperator
        . """=HYPERLINK(""amazon.de/dp/" . asin . """, """ . asin . """)""`n"
        , %output_file%
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

    ; @AHK++AlignAssignmentOn
    urls       := []
    titles     := []
    prices     := []
    order_html := "../res/order.html"
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

    AppendHeaderToFile(output_file)
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
        WriteOutData(images[index], titles[index], prices[index], weights[index], skus[index], asins[index], output_file)

        ; Lots and mini lots extra data
        If (extra_data.Length() / 7 > 1)
            Loop % (extra_data.Length() / 7)
            {
                j := (7 * (A_Index - 1))

                ; Clean up tags from extra_data images
                extra_data[j + 1] := StrReplace(extra_data[j + 1], "<img src=""")
                extra_data[j + 1] := StrReplace(extra_data[j + 1], """>")
                WriteOutData(extra_data[j + 1], extra_data[j + 3] . " x " extra_data[j + 2], "-", "-", skus[index], extra_data[j + 6], output_file)
            }
        ; Update progress bar
        GuiControl, , textbox, % titles[index]
        GuiControl, , progress, % index / urls.Length() * 100
    }
    GuiControl, , textbox, Finished
    SetBatchLines, 1

    ; Open output
    editor := "C:\Users\Elazar\AppData\Local\Programs\Microsoft VS Code\code.exe"
    RunWait, %editor% %output_file%

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
    ; ---------------------------------- GUI -----------------------------------
    global textbox
    Gui, Add, Text, w500 h40 vtextbox
    Gui, show
    ; --------------------------------------------------------------------------

    RegExMatch(file_string, "jleu\w+", jleu)

    match_pos := 1
    While (match_pos)
    {
        match_pos := RegExMatch(file_string, "(?<=jobalots.com\/products\/)\w+", url_match, match_pos + StrLen(price_match))
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
    source_file := "../res/item.html"
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
    RegExMatch(source_string, "(?<=\Q<meta property=""og:url"" content=""https://eu.jobalots.com/products/\E)\w+", sku)
    RegExMatch(source_string, "(?<=\Q><strong>Weight:</strong>\E\s)\d+\.\d+", weight)
    RegExMatch(source_string, "â‚¬\d+\.\d+ (\w+)", asin)

    images.Push(image)
    weights.Push(weight)
    asins.Push(asin1)

    ; Extra data
    RegexMatchAll(source_string, extra_data, "(?<=<td>).+?(?=<\/td>)")

    ; Download product images
    subfolder_name := "../" . "Orders" . "/" . jleu . "/" . sku . "/" . "images"
    DownloadImagesFromString(source_string, subfolder_name)
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
DownloadImagesFromString(source_string, subfolder_name)
{
    ; Create directory if it doesn't exist
    If (!FileExist(subfolder_name))
        FileCreateDir, %subfolder_name%

    image_urls := []
    RegexMatchAll(source_string, image_urls, "(?<=<a href="")//eu.jobalots.com/cdn/shop/\w+/.+?.jpg.*?(?="" class=)")
    For i, url in image_urls
    {
        file_path = %subfolder_name%/%i%.jpg

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
    Run, notepad.exe ..\res\order.html, , ,
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
    }
    Run, %editor% ../Orders/%latest%/output.csv
Return
