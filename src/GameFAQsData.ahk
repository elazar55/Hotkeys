; ==============================================================================
;                                 Screenscraper
; ==============================================================================
#F1::
GameGUI:
    ;@AHK++AlignAssignmentOn
    button_width := 96
    edit_width   := 320
    date_width   := edit_width / 4
    ;@AHK++AlignAssignmentOff

    Gui, Destroy
    Gui, +AlwaysOnTop

    ; ================================= Title ==================================
    Gui, Add, Button, W%button_width% X10, Title
    Gui, Add, Edit, W%edit_width% XP+%button_width% YP Vtitle, %title%

    ; ============================= Scrape Source ==============================
    Gui, Add, Button, W%button_width% X10 Default GScrapeGameFAQs, Scrape Source
    Gui, Add, Edit, R1 W%edit_width% XP+%button_width% YP Vsource, %source%
    GuiControl, Focus, source

    ; =============================== Publisher ================================
    Gui, Add, Button, W%button_width% X10 GPublisher, Publisher
    Gui, Add, Edit, W%edit_width% XP+%button_width% YP Vpublisher, %publisher%

    ; =============================== Developer ================================
    Gui, Add, Button, W%button_width% X10 GDeveloper, Developer
    Gui, Add, Edit, W%edit_width% XP+%button_width% YP Vdeveloper, %developer%

    ; =========================== Rating Categories ============================
    Gui, Add, Button, W%button_width% X10 GRatingCategories, Rating Categories
    Gui, Add, DDL, W%edit_width% XP+%button_width% YP Vrating Choose1, %rating_list%

    ; ============================= Release date ===============================
    Gui, Add, Button, W%button_width% X10 GReleaseDate, Release date
    Gui, Add, Edit, W%date_width% XP+%button_width% YP Vregion, %region%
    Gui, Add, Edit, W%date_width% XP+%date_width% YP Vday, %day%
    Gui, Add, Edit, W%date_width% XP+%date_width% YP Vmonth, %month%
    Gui, Add, Edit, W%date_width% XP+%date_width% YP Vyear, %year%

    ; ================================= Genre ==================================
    Gui, Add, Button, W%button_width% X10 GGenre, Genre
    Gui, Add, Edit, W%edit_width% XP+%button_width% YP Vgenre, %genre%

    Gui, Show
Return
; ============================== Scrape GameFAQs ===============================
ScrapeGameFAQs:
    Gui, Submit

    RegExMatch(source, "gamefaqs.+?/data", match)
    If (match == "")
    {
        MsgBox, Wrong URL
        Exit
    }

    UrlDownloadToFile, %source%, Game_Data.html

    If (ErrorLevel)
    {
        MsgBox, UrlDownloadToFile Error: %ErrorLevel%
        Exit
    }

    FileRead, source_string, Game_Data.html

    pos := 1
    pos := RegExMatch(source_string, "(?<=genre&quot;:&quot;).+?(?=&quot;,&quot;)", genre, pos)
    genre := StrReplace(genre, "Miscellaneous,Edutainment", "Educational")

    pos := RegExMatch(source_string, "(?<=rating=).+?(?=&amp;publisher)", rating_list, pos)
    rating_list := StrReplace(rating_list, "%2C", "|")
    rating_list := StrReplace(rating_list, "-", ":")

    pos := RegExMatch(source_string, "(?<=<a href=""/games/company/).*?"">(.+?)(?=</a>)", developer, pos)
    developer := developer1

    pos := RegExMatch(source_string, "(?<=<td colspan=""6"" class=""bold"">).+?(?=</td>)", title, pos)

    pos := RegExMatch(source_string, "(?<=\t\t\t\t<td>)\w+", region, pos)
    region := StrReplace(region, "JP", "Japan")

    pos := RegExMatch(source_string, "(?<=datePublished"":"")\d+", year, pos)
    pos := RegExMatch(source_string, "\d+", month, pos + 4)
    pos := RegExMatch(source_string, "\d+", day, pos + 2)
    pos := RegExMatch(source_string, "(?<=""publisher"":"")(.+?)(?="",)", publisher, pos)

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
    Gosub, GameGUI
Return
; =============================== Check Window =================================
CheckWindow()
{
    Gui, Submit
    Sleep, 20
    WinGetTitle, title, A, , ,
    If (!InStr(title, "Google Chrome", 1))
    {
        SoundBeep, 600, 192
        SoundBeep, 500, 192
        Exit
    }
}
; ================================== Search ====================================
Search(text)
{
    Send, {CtrlDown}f{CtrlUp}
    Paste(text)
}
; =================================== Paste ====================================
Paste(text)
{
    Clipboard := text
    Send, {CtrlDown}v{CtrlUp}
}
; =================================== Genre ====================================
Genre:
    CheckWindow()

    Search("New information proposal : Genre(s)")
    Send, {Escape}{Tab}%genre%{Tab}{Tab}
    Paste(source)
    Send, {ShiftDown}{Tab}{ShiftUp}
    Beep(1200, 25)
Return
; ================================= Publisher ==================================
Publisher:
    CheckWindow()

    Search("New information proposal : Publisher")
    Send, {Escape}{Tab}
    Paste(publisher)
    Send, {Tab}{Tab}
    Paste(source)
    Send, {ShiftDown}{Tab}{ShiftUp}
    Beep(1200, 25)
Return
; ================================= Developer ==================================
Developer:
    CheckWindow()

    Search("New information proposal : Developer")
    Send, {Escape}{Tab}
    Paste(developer)
    Send, {Tab}{Tab}
    Paste(source)
    Send, {ShiftDown}{Tab}{ShiftUp}
    Beep(1200, 25)
Return
; ============================= Rating Categories ==============================
RatingCategories:
    CheckWindow()

    Search("New information proposal : Rating Categories")
    Send, {Escape}{Tab}%rating%{Tab}{Tab}
    Paste(source)
    Send, {ShiftDown}{Tab}{ShiftUp}
    Beep(1200, 25)
Return
; =============================== Releas eDate =================================
ReleaseDate:
    CheckWindow()

    Search("New information proposal : Release date(s)")
    Send, {Escape}{Tab}%region%{Tab}

    If (day == 22)
        Send, 2

    Send, %day%{Tab}%month%{Tab}%year%{Tab}{Tab}
    Paste(source)
    Send, {ShiftDown}{Tab}{ShiftUp}
    Beep(1200, 25)
Return
