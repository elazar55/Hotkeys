; ==============================================================================
;                                 Screenscraper
; ==============================================================================
#g::
GameGUI:
    ;@AHK++AlignAssignmentOn
    button_width := 96
    edit_width   := 320
    date_width   := edit_width / 4
    ;@AHK++AlignAssignmentOff
    Gui, Destroy
    Gui, +AlwaysOnTop

    ; ================================= Title ==================================
    Gui, Add, Button, W%button_width% X10 GTitle, Title
    Gui, Add, DDL, W%edit_width% XP+%button_width% YP Vtitle Choose%entry%, %title_list%

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

    ; ============================= Local Players ==============================
    Gui, Add, Button, W%button_width% X10 GLocalPlayers, Local Players
    Gui, Add, Edit, W%edit_width% XP+%button_width% YP Vlocal_players, %local_players%

    ; ============================= Select Media ===============================
    Gui, Add, Button, W%button_width% X10 GSelectMedia, Select Media
    Gui, Add, DDL, W%edit_width% XP+%button_width% YP Vmedia Choose1, Case : Back|Case : Front

    ; ================================ Images ==================================
    Gui, Add, Button, W%button_width% X10 GImages, Select Images
    Gui, Add, DDL, W%edit_width% XP+%button_width% YP Vimage, %images_list%

    ; ============================= Select Entry ===============================
    Gui, Add, Button, W%button_width% X10 GEntry, Select Entry
    Gui, Add, DDL, W%edit_width% XP+%button_width% YP Ventry AltSubmit Choose%entry%, %entries%

    Gui, Show
Return

UrlDownloadWrapper(url, file)
{
    UrlDownloadToFile, %url%, %file%
    If (ErrorLevel)
    {
        MsgBox, UrlDownloadToFile Error: %ErrorLevel%
        Exit
    }
    FileRead, file_as_string, %file%
    Return file_as_string
}
; ==============================================================================
;                                  IsValidURL
; ==============================================================================
CheckIfValidURL(url)
{
    RegExMatch(url, "gamefaqs.+?/data", match)
    If (match == "")
    {
        MsgBox, Wrong URL
        Exit
    }
}
; ==============================================================================
;                                Scrape GameFAQs
; ==============================================================================
ScrapeGameFAQs:
    Gui, Submit

    CheckIfValidURL(source)
    source_string := UrlDownloadWrapper(source, "Game_Data.html")

    ;@AHK++AlignAssignmentOn
    title_list     :=
    publisher_list :=
    region_list    :=
    rating_list    :=
    day_list       :=
    month_list     :=
    year_list      :=
    images_list    :=
    pos            := 1
    entries        :=
    entry          := 1
    ;@AHK++AlignAssignmentOff

    ; ================================= Genre ==================================
    pos := RegExMatch(source_string, "(?<=genre&quot;:&quot;).+?(?=&quot;,&quot;)", genre, pos)
    genre := TransformGenre(genre)

    ; =============================== Developer ================================
    pos := RegExMatch(source_string, "(?<=<a href=""/games/company/).*?"">(.+?)(?=</a>)", developer, pos)
    developer := developer1

    ; ============================ Regeional Data ==============================
    pos := 1
    While (pos := RegExMatch(source_string, "(?<=<td colspan=""6"" class=""bold"">).+?(?=</td>)", match, pos + StrLen(match)))
    {
        ; =============================== Title ================================
        title_list := title_list . match . "|"

        ; ============================== Entries ===============================
        entries := entries . A_Index . " - " . match . "|"

        ; ============================== Region ================================
        pos := RegExMatch(source_string, "(?<=<td>)\w+(?=</td>)", match, pos + StrLen(match))
        region_list := region_list . match . "|"

        ; ============================= Publisher ==============================
        pos := RegExMatch(source_string, "(?:<td><a href=""\/games\/company\/.+?>)(.+?)(?=</a></td>)", match, pos)
        publisher_list := publisher_list . match1 . "|"

        ; =============================== Date =================================
        pos := RegExMatch(source_string, "\d{2}\/\d{2}\/\d{2}", match, pos + StrLen(match))
        date_array := StrSplit(match, "/")

        If (date_array[3] > 24)
            date_array[3] := "19" . date_array[3]
        Else
            date_array[3] := "20" . date_array[3]

        month_list := month_list . MonthDateToName(date_array[1]) . "|"
        day_list := day_list . date_array[2] . "|"
        year_list := year_list . date_array[3] . "|"

        ; ============================== Rating ================================
        RegExMatch(source_string, "(?<=<td>).+?(?=</td>)", match, pos + StrLen(match))
        rating_list := rating_list . RatingShortToFull(match) . "|"

        ; =========================== Local Players ============================
        RegExMatch(source_string, "`n)(?<=<span>).+?(?= Players?</span>)", local_players)
    }

    ; =================================== Boxes ====================================
    boxes_url := StrReplace(source, "data", "boxes")
    boxes_src_as_string := UrlDownloadWrapper(boxes_url, "Boxes_Data.html")

    pos := 1
    While (pos := RegExMatch(boxes_src_as_string, "`n)(?<=<a href="")\/.+\/boxes\/(\d+)", match, pos + StrLen(match)))
    {
        boxshot_url := boxes_url . "/" . match1
        boxshot_src_as_string := UrlDownloadWrapper(boxshot_url, "Boxshot_Data.html")
        RegExMatch(boxes_src_as_string, "`n)(?<=<div class=""meta"">).+(?=<br/>)", image_title, pos + StrLen(match))

        cover_pos := 1
        While (cover_pos := RegExMatch(boxshot_src_as_string, "(?<=data-img="").+?(?="")", cover_match, cover_pos + StrLen(cover_match)))
        {
            images_list := images_list . image_title . " " . cover_match . "|"
        }
    }

    Gosub, GameGUI
Return
; ==============================================================================
;                                Transform Genre
; ==============================================================================
TransformGenre(genre)
{
    Switch genre
    {
    case "Miscellaneous,Edutainment": Return "Educational"
    case "Miscellaneous,Compilation": Return "Compilation"
    case "Simulation,Virtual,Pet": Return "Simulation"
    case "Adventure,Visual Novel": Return "Adventure / Visual Novel"
    case "Action,Fighting,2D": Return "Fight / 2D"
    case "Action,Rhythm,Music": Return "Rhythm"
    Default: Return genre
    }
}
; ==============================================================================
;                               ParseRatingString
; ==============================================================================
RatingShortToFull(abbreviation)
{
    Switch abbreviation
    {
    case "A": Return "CERO" . ":" . abbreviation
    case "B": Return "CERO" . ":" . abbreviation
    case "C": Return "CERO" . ":" . abbreviation
    case "D": Return "CERO" . ":" . abbreviation
    case "Z": Return "CERO" . ":" . abbreviation
    case "E": Return "ESRB" . ":" . abbreviation
    case "E10+": Return "ESRB" . ":" . "E10"
    case "G": Return "ACB" . ":" . abbreviation
    case "ALL": Return "GRB" . ":" . abbreviation
    case "3+": Return "PEGI" . ":" . "3"
    Default: Return abbreviation
    }
}
; ==============================================================================
;                                MonthDateToName
; ==============================================================================
MonthDateToName(month_num)
{
    Switch month_num
    {
    case 01: Return "Jan"
    case 02: Return "Feb"
    case 03: Return "Mar"
    case 04: Return "Apr"
    case 05: Return "May"
    case 06: Return "June"
    case 07: Return "July"
    case 08: Return "Aug"
    case 09: Return "Sep"
    case 10: Return "Oct"
    case 11: Return "Nov"
    case 12: Return "Dec"
    Default: Return "Invalid"
    }
}
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
        Beep(500, 25)
        Exit
    }
}
; ==============================================================================
;                                    Search
; ==============================================================================
Search(text)
{
    Send, {CtrlDown}f{CtrlUp}
    Paste(text)
    Send, {Enter}
}
; ==============================================================================
;                                     Paste
; ==============================================================================
Paste(text)
{
    Clipboard := text
    Send, {CtrlDown}v{CtrlUp}
}
; ==============================================================================
;                                     Title
; ==============================================================================
Title:
    CheckWindow()

    Search("New information proposal : Game name (by Region)")
    Send, {Escape}{Tab}%region%{Tab}
    Paste(title)
    Send, {Tab}{Tab}
    Paste(source)
    Send, {ShiftDown}{Tab}{ShiftUp}
    Beep(1200, 25)
Return
; ==============================================================================
;                                     Genre
; ==============================================================================
Genre:
    CheckWindow()

    Search("New information proposal : Genre(s)")
    Send, {Escape}{Tab}%genre%{Tab}{Tab}
    Paste(source)
    Send, {ShiftDown}{Tab}{ShiftUp}
    Beep(1200, 25)
Return
; ==============================================================================
;                                   Publisher
; ==============================================================================
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
; ==============================================================================
;                                   Developer
; ==============================================================================
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
; ==============================================================================
;                               Rating Categories
; ==============================================================================
RatingCategories:
    CheckWindow()

    Search("New information proposal : Rating Categories")
    Send, {Escape}{Tab}%rating%{Tab}{Tab}
    Paste(source)
    Send, {ShiftDown}{Tab}{ShiftUp}
    Beep(1200, 25)
Return
; ==============================================================================
;                                 Release Date
; ==============================================================================
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
;                                 Select Media
; ==============================================================================
SelectMedia:
    CheckWindow()

    Search("Info type :")
    Send, {Enter}{Escape}{Tab}%media%{Tab}

    If (region != "EU")
        Send, ->

    Send, %region%
    Search("Support Number :")
    Send, {Escape}{Tab}uni{Tab}{Tab}{Tab}
    Paste(StrReplace(source, "data", "boxes"))
    Send, {ShiftDown}{Tab}{Tab}{ShiftUp}
Return
; ==============================================================================
;                                    Images
; ==============================================================================
Images:
    Gui, Submit
    FileDelete, C:\Users\Elazar\Downloads\*.jpg
    FileDelete, C:\Users\Elazar\Downloads\*.png
    RegExMatch(image, "\/.+", image)
    RegExMatch(image, "[^\/]*$", filename)

    UrlDownloadToFile, https://gamefaqs.gamespot.com%image%, C:/Users/Elazar/Downloads/%filename%
    If (ErrorLevel)
    {
        MsgBox, UrlDownloadToFile Error: %ErrorLevel%
        Exit
    }
    Run, DS_Resize.bat, C:\Users\Elazar\Downloads\, ,
Return
; ==============================================================================
;                                 Local Players
; ==============================================================================
LocalPlayers:
    CheckWindow()
    Search("New information proposal : Number of Players")
    Send, {Escape}{Tab}%local_players%{Tab}{Tab}
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
