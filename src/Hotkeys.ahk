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

    Gui, Add, Button, W96 X10, Source
    Gui, Add, Edit, W192 XP+96 YP Vsource, %source%

    Gui, Show
Return

CheckWindow()
{
    Gui, Submit
    Gui, Destroy
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
