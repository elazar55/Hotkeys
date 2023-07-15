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
        ; An activity indicator
        ToolTip, % titles[index]

        extra_data := []
        If (!ScrapeProduct(url, images, skus, weights, asins, extra_data))
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

        ; Lots and mini lots extra data
        If (extra_data.Length() / 7 > 1)
            Loop % (extra_data.Length() / 7)
            {
                j := (7 * (A_Index - 1))

                ; Clean up tags from extra_data images
                extra_data[j + 1] := StrReplace(extra_data[j + 1], "<img src=""")
                extra_data[j + 1] := StrReplace(extra_data[j + 1], """>")

                FileAppend, % extra_data[j + 1] . seperator
                    . """" . extra_data[j + 2] . """" . seperator
                    . "-" . seperator
                    . "-" . seperator
                    . """=HYPERLINK(""eu.jobalots.com/products/" . skus[index] . """, """ . skus[index] . """)""" . seperator
                    . """=HYPERLINK(""amazon.de/dp/" . extra_data[j + 6] . """, """ . extra_data[j + 6] . """)"""
                    . "`n"
                    , %output_file%
            }
    }
    Beep(1200, 25)
    ToolTip
Return
; ==============================================================================
;                         Scrape data from product page
; ==============================================================================
ScrapeProduct(address, images, skus, weights, asins, extra_data)
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

    ; Extra data
    RegexMatchAll(source_string, extra_data, "(?<=<td>).+?(?=<\/td>)")

    ; Download product images
    DownloadImagesFromString(source_string, asin1)
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
    dl_path := "images/" . subfolder_name
    If (!FileExist(dl_path))
        FileCreateDir, %dl_path%

    image_urls := []
    RegexMatchAll(source_string, image_urls, "(?<=<a href="")//eu.jobalots.com/cdn/shop/products/.+?.jpg.*?(?="" class=)")

    For i, url in image_urls
    {
        file_path = %dl_path%/%i%.jpg

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
;                               Scrape Order URLs
; ==============================================================================
ScrapeOrderLinks(order_html, urls, titles, prices)
{
    FileRead, file_string, %order_html%

    If (ErrorLevel)
    {
        MsgBox, Error reading %order_html%
        Return False
    }
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
