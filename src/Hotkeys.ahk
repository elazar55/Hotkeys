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
#j::
    ;@AHK++AlignAssignmentOn
    file   := "auctions.html"
    output := "output.html"
    images := []
    titles := []
    skus   := []
    ;@AHK++AlignAssignmentOff

    FileRead, source_string, %file%
    FileDelete, %output%
    FileAppend, % "<html>`n<style>`n`ttable, th, td { border:1px solid black; }`n`timg { width: 150px; }`n</style>`n<head>`n</head>`n<body>`n<table>`n", %output%

    pos := 1
    while (pos := RegExMatch(source_string, "`n)(?<=<img class=""full-width"" src="").+(?=\?v=\d+"">)", match, pos + StrLen(match)))
    {
        FileAppend, `t<tr>`n, %output%

        images.Push(match)

        pos := RegExMatch(source_string, "(?<=<a href=""/products/)\w+(?="" target=""_blank"">)", match, pos + StrLen(match))
        skus.Push(match)

        pos := RegExMatch(source_string, "`n)\\n)", match, pos + StrLen(match))
        titles.Push(match)

        FileAppend, % "`t`t<td><img src=""" . images[images.Length()] . """></br>" . titles[titles.Length()] . "</td>`n", %output%

        If (InStr(match, "Mixed"))
        {
            UrlDownloadToFile, % "https://eu.jobalots.com/products/" . skus[skus.Length()], lot.html
            If (ErrorLevel)
            {
                MsgBox, UrlDownloadToFile Error: %ErrorLevel%
                Exit
            }
            FileRead, lot_string, lot.html

            lot_pos := 1
            while (lot_pos := RegExMatch(lot_string, "`n)(?<=<td><img src="").+(?=""></td>)", lot_match, lot_pos + StrLen(lot_match)))
            {
                FileAppend, `t`t<td><img src="%lot_match%"></td>`n, %output%
            }
        }

        FileAppend, `t</tr>`n, %output%
    }
    FileAppend, </table>`n</body>`n</html>`n, %output%
    Beep(1200, 25)
Return
