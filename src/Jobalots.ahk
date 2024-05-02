; ==============================================================================
;                                   Jobalots
; ==============================================================================
#F1::
    SetBatchLines, -1
    ;@AHK++AlignAssignmentOn
    file      := "auctions.html"
    output    := "output.html"
    img_width := 384
    border    := "1px solid black"
    font_size := "12px"
    ;@AHK++AlignAssignmentOff

    FileRead, source_string, %file%
    FileDelete, %output%

    FileAppend, % "<html>`n", %output%
    FileAppend, % "<style>`n`", %output%
    ; ============================= table, th, td ==============================
    FileAppend, % "`ttable, th, td`n", %output%
    FileAppend, % "`t{`n", %output%
    FileAppend, % "`t`tborder: " . border . ";`n", %output%
    FileAppend, % "`t`tfont-size: " . font_size . ";`n", %output%
    FileAppend, % "`t}`n", %output%
    FileAppend, % "`timg`n", %output%
    FileAppend, % "`t{`n", %output%
    FileAppend, % "`t`twidth: " . img_width . "px;`n", %output%
    FileAppend, % "`t}`n", %output%
    ; ================================= span ===================================
    FileAppend, % "`tspan`n", %output%
    FileAppend, % "`t{`n", %output%
    FileAppend, % "`t`tbackground: Yellow;`n", %output%
    FileAppend, % "`t}`n", %output%
    ; ================================ .timer ==================================
    FileAppend, % "`t.timer`n", %output%
    FileAppend, % "`t{`n", %output%
    FileAppend, % "`t`tpadding: 2px 22px;`n", %output%
    FileAppend, % "`t`tdisplay: inline-block;`n", %output%
    FileAppend, % "`t`tborder: 1px solid rgba(204, 204, 204, 1);`n", %output%
    FileAppend, % "`t}`n", %output%

    FileAppend, % "</style>`n", %output%
    FileAppend, % "<head>`n", %output%
    FileAppend, % "</head>`n", %output%
    FileAppend, % "<body>`n", %output%
    FileAppend, % "<table>`n", %output%

    pos := 1
    while (pos := RegExMatch(source_string, "`n)(?<=<img class=""full-width"" src="").+(?=\?v=\d+"">)", match, pos + StrLen(match)))
    {
        FileAppend, `t<tr>`n, %output%

        image := match

        pos := RegExMatch(source_string, "(?<=<a href=""/products/)\w+(?="" target=""_blank"">)", match, pos + StrLen(match))
        sku := match

        pos := RegExMatch(source_string, "`n)\d+.+(?=\n)", match, pos + StrLen(match))
        title := RegExReplace(match, "i)\bOf\b|\bAnd\b|\bWith\b|\bFor\b|\bBrand\b|\bNew\b|\bRAW\b|\bCustomer\b|\bReturns\b|( - RRP .+)")

        ; RegExMatch(title, "i)Twitch|Electronic|Computer", match)
        ; if (match)
        ;     title := "<span>" . title "</span>"

        pos := RegExMatch(source_string, "(?<=""pa-theme-color"">)(\d{2})(?:<\/span>)(\w)", match, pos + StrLen(match))
        time := match1 . match2 . match3 . ":"
        pos := RegExMatch(source_string, "(?<=""pa-theme-color"">)(\d{2})(?:<\/span>)(\w)", match, pos + StrLen(match))
        time := time . match1 . match2 . match3 . ":"
        pos := RegExMatch(source_string, "(?<=""pa-theme-color"">)(\d{2})(?:<\/span>)(\w)", match, pos + StrLen(match))
        time := time . match1 . match2 . match3

        pos := RegExMatch(source_string, "(?<=<div><strong>)(\w+ Bid:)(?:</strong><span>)( EUR \d+\.\d{2})", match, pos + StrLen(match))
        ; MsgBox, %match%
        if (InStr(match, "Start Bid:</strong><span> EUR 0.10"))
        {
            title := "<span>" . title "</span>"
        }
        ToolTip, %title%, , ,

        FileAppend, % "`t`t<td><a href=""https://eu.jobalots.com/products/" . sku . """ target=""_blank""><img src=""" . image . """></a><div>" . title . "</div><div class=timer>" . time . "</div><div><strong>" . match1 . "</strong>" . match2 . "</div></td>`n", %output%

        If (InStr(title, "Mixed"))
        {
            UrlDownloadToFile, % "https://eu.jobalots.com/products/" . sku, lot.html
            If (ErrorLevel)
            {
                MsgBox, UrlDownloadToFile Error: %ErrorLevel%
                Exit
            }
            FileRead, lot_string, lot.html

            lot_pos := 1
            while (lot_pos := RegExMatch(lot_string, "`n)(?<=<td><img src="").+(?=""></td>)", lot_match, lot_pos + StrLen(lot_match)))
            {
                img := lot_match

                lot_pos := RegExMatch(lot_string, "`n)(?<=<td>).+(?=</td>)", lot_match, lot_pos + StrLen(lot_match))
                title := RegExReplace(lot_match, "i)\bOf\b|\bAnd\b|\bWith\b|\bFor\b|\bBrand\b|\bNew\b|\bRAW\b|\bCustomer\b|\bReturns\b|( - RRP .+)")

                FileAppend, `t`t<td><a href="https://eu.jobalots.com/products/%sku%"target="_blank"><img src="%img%"></a></br>%title%</td>`n, %output%
            }
        }

        FileAppend, `t</tr>`n, %output%
    }
    FileAppend, </table>`n</body>`n</html>`n, %output%
    ToolTip
    Beep(1200, 25)
    SetBatchLines, 20ms
Return
