; ==============================================================================
;                             Auto Exexcute Section
; ==============================================================================
; Script attributes
#NoEnv
#SingleInstance, Force
SetTitleMatchMode, 2
SetBatchLines, 20ms
SendMode, Event
; ==============================================================================
;                                   Includes
; ==============================================================================
; #Include, Fez.ahk
; #Include, Hearthstone.ahk
; #Include, GameRemaps.ahk
; #Include, PicrossTouch.ahk
#Include, Tiler.ahk
#Include, Scraper.ahk
#Include, Helpers.ahk
#Include, GameFAQsData.ahk
; ==============================================================================
;                                      GUI
; ==============================================================================
#m::
    Gui, Destroy
    Gui, +AlwaysOnTop
    Gui, Add, Button, W320 GScrape, Scrape
    Gui, Add, Button, W320 GOpenOrder, Open order.html
    Gui, Add, Button, W320 GOpenLatest, Open latest output
    Gui, Add, Button, W320 GDockerGUI, Docker
    Gui, Show
Return
; ==============================================================================
;                                  Gui Destroy
; ==============================================================================
~Escape::
    Gui, Destroy
Return
; ==============================================================================
;                                  GUI Submit
; ==============================================================================
GUISubmit:
    Gui, Submit
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
    Beep(1200, 20)
Return
; ==============================================================================
;                                 Sentence Case
; ==============================================================================
SentenceCase:
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
TitleCase:
    Send, ^c
    ClipWait, 1

    StringLower, Clipboard, % Trim(Clipboard), T
    needle := "(?<!(^)|(: ))\b(The|Is|To|And|On|In|A|An|As|Or|But|For|Of|Vs)\b"
    Clipboard := RegExReplace(Clipboard, needle, "$L0")

    Send, ^v
    Beep(1200, 20)
Return
; ==============================================================================
;                                    Reload
; ==============================================================================
#d::
    Reload
Return
; ==============================================================================
;                                   Jobalots
; ==============================================================================
#F1::
    ;@AHK++AlignAssignmentOn
    file      := "auctions.html"
    output    := "output.html"
    img_width := 128
    border    := "1px solid black"
    font_size := "12px"
    ;@AHK++AlignAssignmentOff

    FileRead, source_string, %file%
    FileDelete, %output%
    FileAppend, % "<html>`n", %output%
    FileAppend, % "<style>`n`", %output%
    FileAppend, % "`ttable, th, td`n", %output%
    FileAppend, % "`t{`n", %output%
    FileAppend, % "`t`tborder: " . border . ";`n", %output%
    FileAppend, % "`t`tfont-size: " . font_size . ";`n", %output%
    FileAppend, % "`t}`n", %output%
    FileAppend, % "`timg`n", %output%
    FileAppend, % "`t{`n", %output%
    FileAppend, % "`t`twidth: " . img_width . "px;`n", %output%
    FileAppend, % "`t}`n", %output%
    FileAppend, % "`tspan`n", %output%
    FileAppend, % "`t{`n", %output%
    FileAppend, % "`t`tbackground: Yellow;`n", %output%
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

        RegExMatch(title, "i)Twitch|Electronic", match)
        if (match)
            title := "<span>" . title "</span>"

        pos := RegExMatch(source_string, "(?<=""pa-theme-color"">)(\d{2})(?:<\/span>)(\w)", match, pos + StrLen(match))
        time := match1 . match2 . match3 . ":"
        pos := RegExMatch(source_string, "(?<=""pa-theme-color"">)(\d{2})(?:<\/span>)(\w)", match, pos + StrLen(match))
        time := time . match1 . match2 . match3 . ":"
        pos := RegExMatch(source_string, "(?<=""pa-theme-color"">)(\d{2})(?:<\/span>)(\w)", match, pos + StrLen(match))
        time := time . match1 . match2 . match3

        ToolTip, %title%, , ,

        FileAppend, % "`t`t<td><a href=""https://eu.jobalots.com/products/" . sku . """ target=""_blank""><img src=""" . image . """></a><p>" . title . "</p><p>" . time . "</p></td>`n", %output%

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
Return
