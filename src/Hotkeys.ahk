﻿; ==============================================================================
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

    StringLower, Clipboard, Clipboard, T
    needle := "(?<!(^)|(: ))\b(The|Is|To|And|On|In|A|An|Or|But|For|Of|Vs)\b"
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
#F1::
    Gui, Destroy
    Gui, +AlwaysOnTop
    Gui, Add, Button, W96 X10 GScrapeGameFAQs, Scrape Source
    Gui, Add, Edit, W192 XP+96 YP Vsource, %source%

    Gui, Add, Button, W96 X10 GPublisher, Publisher
    Gui, Add, Edit, W192 XP+96 YP Vpublisher, %publisher%

    Gui, Add, Button, W96 X10 GDeveloper, Developer
    Gui, Add, Edit, W192 XP+96 YP Vdeveloper, %developer%

    Gui, Add, Button, W96 X10 GRatingCategories, Rating Categories
    Gui, Add, Edit, W192 XP+96 YP Vrating, %rating%

    Gui, Add, Button, W96 X10 GReleaseDate, Release date
    Gui, Add, Edit, W48 XP+96 YP Vregion, %region%
    Gui, Add, Edit, W48 XP+48 YP Vday, %day%
    Gui, Add, Edit, W48 XP+48 YP Vmonth, %month%
    Gui, Add, Edit, W48 XP+48 YP Vyear, %year%

    Gui, Show
Return

ScrapeGameFAQs:
    Gui, Submit
    UrlDownloadToFile, %source%, Game_Data.html

    If (ErrorLevel)
    {
        MsgBox, UrlDownloadToFile Error: %ErrorLevel%
        Exit
    }

    FileRead, source_string, Game_Data.html

    pos := 1
    pos := RegExMatch(source_string, "(?<=\t\t\t\t<td>)\w+", region)
    pos := RegExMatch(source_string, "(?<=datePublished"":"")\d+", year, pos)
    pos := RegExMatch(source_string, "\d+", month, pos + 4)
    pos := RegExMatch(source_string, "\d+", day, pos + 2)
    pos := RegExMatch(source_string, "(?<=""publisher"":"")(.+?)(?="",)", publisher, pos)
    pos := RegExMatch(source_string, "(?<=<a href=""/games/company/).*?"">(.+?)(?=</a>)", developer)
    developer := developer1
    pos := RegExMatch(source_string, "(?<=rating=).+?(?=&amp|%2C)", rating)
    rating := StrReplace(rating, "-", ":")

    Switch month
    {
    case 01: month = Jan
    case 02: month = Feb
    case 03: month = Mar
    case 04: month = Apr
    case 05: month = May
    case 06: month = June
    case 07: month = July
    case 08: month = Aug
    case 09: month = Sep
    case 10: month = Oct
    case 11: month = Nov
    case 12: month = Dec
    }

; MsgBox, %region%
; MsgBox, %year%
; MsgBox, %month%
; MsgBox, %day%
; MsgBox, %publisher%
; MsgBox, %developer%
; MsgBox, %rating%
Return

CheckWindow()
{
    Gui, Submit
    Sleep, 1000
    WinGetTitle, title, A, , ,
    If (!InStr(title, "Google Chrome", 1))
    {
        SoundBeep, 600, 192
        SoundBeep, 500, 192
        Exit
    }
}

Publisher:
    CheckWindow()

    Send, {CtrlDown}f{CtrlUp}
    Send, New information proposal : Publisher
    Send, {Escape}{Tab}
    Send, %publisher%
    Send, {Tab}{Tab}
    Send, %source%
Return

Developer:
    CheckWindow()

    Send, {CtrlDown}f{CtrlUp}
    Send, New information proposal : Developer
    Send, {Escape}{Tab}
    Send, %developer%
    Send, {Tab}{Tab}
    Send, %source%
Return

RatingCategories:
    CheckWindow()

    Send, {CtrlDown}f{CtrlUp}
    Send, New information proposal : Rating Categories
    Send, {Escape}{Tab}
    Send, %rating%
    Send, {Tab}{Tab}
    Send, %source%
Return

ReleaseDate:
    CheckWindow()

    Send, {CtrlDown}f{CtrlUp}
    Send, New information proposal : Release date
    Send, {Escape}{Tab}
    Send, %region%{Tab}

    If (day == 22)
        Send, 2

    Send, %day%{Tab}
    Send, %month%{Tab}
    Send, %year%{Tab}
    Send, {Tab}
    Send, %source%
Return
