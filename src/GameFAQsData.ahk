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
    Gui, Add, DDL, W%edit_width% XP+%button_width% YP Vpublisher Choose%entry%, %publisher_list%

    ; =============================== Developer ================================
    Gui, Add, Button, W%button_width% X10 GDeveloper, Developer
    Gui, Add, Edit, W%edit_width% XP+%button_width% YP Vdeveloper, %developer%

    ; =========================== Rating Categories ============================
    Gui, Add, Button, W%button_width% X10 GRatingCategories, Rating Categories
    Gui, Add, DDL, W%edit_width% XP+%button_width% YP Vrating Choose%entry%, %rating_list%

    ; ============================= Release date ===============================
    Gui, Add, Button, W%button_width% X10 GReleaseDate, Release date
    Gui, Add, DDL, W%date_width% XP+%button_width% YP Vregion Choose%entry%, %region_list%
    Gui, Add, DDL, W%date_width% XP+%date_width% YP Vday Choose%entry%, %day_list%
    Gui, Add, DDL, W%date_width% XP+%date_width% YP Vmonth Choose%entry%, %month_list%
    Gui, Add, DDL, W%date_width% XP+%date_width% YP Vyear Choose%entry%, %year_list%

    ; ================================= Genre ==================================
    Gui, Add, Button, W%button_width% X10 GGenre, Genre
    Gui, Add, Edit, W%edit_width% XP+%button_width% YP Vgenre, %genre%

    ; ============================= Select Entry ===============================
    Gui, Add, Button, W%button_width% X10 GEntry, Select Entry
    Gui, Add, DDL, W%edit_width% XP+%button_width% YP Ventry Choose%entry%, %entries%

    Gui, Show
Return
; ==============================================================================
;                                  IsValidURL
; ==============================================================================
IsValidURL(url)
{
    RegExMatch(url, "gamefaqs.+?/data", match)
    If (match == "")
        Return False

    Return True
}
; ==============================================================================
;                                Scrape GameFAQs
; ==============================================================================
ScrapeGameFAQs:
    Gui, Submit

    If (!IsValidURL(source))
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

    ;@AHK++AlignAssignmentOn
    publisher_list :=
    region_list    :=
    rating_list    :=
    day_list       :=
    month_list     :=
    year_list      :=
    pos            := 1
    entries        :=
    entry          := 1
    ;@AHK++AlignAssignmentOff

    pos := RegExMatch(source_string, "(?<=genre&quot;:&quot;).+?(?=&quot;,&quot;)", genre, pos)
    genre := StrReplace(genre, "Miscellaneous,Edutainment", "Educational")
    genre := StrReplace(genre, "Miscellaneous,Compilation", "Compilation")

    pos := RegExMatch(source_string, "(?<=<a href=""/games/company/).*?"">(.+?)(?=</a>)", developer, pos)
    developer := developer1

    pos := RegExMatch(source_string, "(?<=<td colspan=""6"" class=""bold"">).+?(?=</td>)", title, pos)

    pos := 1
    While (pos := RegExMatch(source_string, "(?:<td><a href=""\/games\/company\/.+?>)(.+?)(?=</a></td>)", match, pos + StrLen(match1)))
    {
        publisher_list := publisher_list . match1 . "|"

        RegExMatch(source_string, "(?<=<td>)\w+(?=</td>)", match, pos - 20)
        region_list := region_list . match . "|"

        pos := RegExMatch(source_string, "\d{2}\/\d{2}\/\d{2}", match, pos + StrLen(match))
        date_array := StrSplit(match, "/")

        Switch date_array[1]
        {
        case 01: date_array[1] := "Jan"
        case 02: date_array[1] := "Feb"
        case 03: date_array[1] := "Mar"
        case 04: date_array[1] := "Apr"
        case 05: date_array[1] := "May"
        case 06: date_array[1] := "June"
        case 07: date_array[1] := "July"
        case 08: date_array[1] := "Aug"
        case 09: date_array[1] := "Sep"
        case 10: date_array[1] := "Oct"
        case 11: date_array[1] := "Nov"
        case 12: date_array[1] := "Dec"
        }
        date_array[3] := "20" . date_array[3]

        month_list := month_list . date_array[1] . "|"
        day_list := day_list . date_array[2] . "|"
        year_list := year_list . date_array[3] . "|"

        RegExMatch(source_string, "(?<=<td>).+?(?=</td>)", match, pos + StrLen(match))
        Switch match
        {
        case "A": match := "CERO" . ":" . match
        case "B": match := "CERO" . ":" . match
        case "C": match := "CERO" . ":" . match
        case "D": match := "CERO" . ":" . match
        case "Z": match := "CERO" . ":" . match
        case "E": match := "ESRB" . ":" . match
        case "3+": match := "PEGI" . ":" . "3"
        }
        rating_list := rating_list . match . "|"

        entries := entries . A_Index . "|"
    }

    Gosub, GameGUI
Return
; ==============================================================================
;                                 Check Window
; ==============================================================================
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
; =============================== Release Date =================================
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
; ==============================================================================
;                                     Entry
; ==============================================================================
Entry:
    Gui, Submit
    Gosub, GameGUI
Return
