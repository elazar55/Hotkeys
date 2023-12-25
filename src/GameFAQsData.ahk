; ==============================================================================
;                                 Screenscraper
; ==============================================================================
#g::
GameGUI:
    ;@AHK++AlignAssignmentOn
    button_width := 96
    edit_width   := 400
    ;@AHK++AlignAssignmentOff
    Gui, Destroy
    Gui, +AlwaysOnTop

    ; ================================= Title ==================================
    Gui, Add, Button, W%button_width% X10 GTitle, Title
    Gui, Add, DDL, W%edit_width% XP+%button_width% YP Vtitle Choose%entry%, %title_list%

    ; ============================= Scrape Source ==============================
    Gui, Add, Button, W%button_width% X10 Default GScrapeGameFAQs, Scrape Source
    Gui, Add, Edit, R1 W%edit_width% XP+%button_width% YP Vsource GScrapeGameFAQs, %source%
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
    Gui, Add, DDL, % "W" . edit_width / 4 . " XP+" . button_width . " YP Vregion Choose" . entry, %region_list%
    Gui, Add, DDL, % "W" . edit_width / 4 . " XP+" . edit_width / 4 . " YP Vday Choose" . entry, %day_list%
    Gui, Add, DDL, % "W" . edit_width / 4 . " XP+" . edit_width / 4 . " YP Vmonth Choose" . entry, %month_list%
    Gui, Add, DDL, % "W" . edit_width / 4 . " XP+" . edit_width / 4 . " YP Vyear Choose" . entry, %year_list%

    ; ================================= Genre ==================================
    Gui, Add, Button, W%button_width% X10 GGenre, Genre
    Gui, Add, Edit, W%edit_width% XP+%button_width% YP Vgenre, %genre%

    ; ============================= Local Players ==============================
    Gui, Add, Button, W%button_width% X10 GLocalPlayers, Local Players
    Gui, Add, Edit, W%edit_width% XP+%button_width% YP Vlocal_players, %local_players%

    ; ============================= Select Media ===============================
    Gui, Add, Button, W%button_width% X10 GSelectMedia, Select Media
    Gui, Add, DDL, W%edit_width% XP+%button_width% YP Vmedia Choose1, Case : Back|Case : Front|Case : Spine

    ; ================================ Images ==================================
    Gui, Add, Button, % "W" . button_width / 4 . " X10 GPickFolder", ...
    If (dl_folder == "")
        dl_folder = C:\Users\%A_UserName%\Downloads
    Gui, Add, Button, % "W" . button_width / 4 * 3 . " XP+" . button_width / 4 . " GImages", Images
    image_rows := StrSplit(images_list, "|").Length() - 1
    Gui, Add, ListBox, % "W" . edit_width . " XP+" . button_width / 4 * 3 . " YP Vimage AltSubmit Multi R" . image_rows . " Choose" . image, %images_list%

    ; ============================= Select Entry ===============================
    Gui, Add, Button, W%button_width% X10 GEntry, Select Entry
    Gui, Add, DDL, W%edit_width% XP+%button_width% YP Ventry AltSubmit Choose%entry%, %entries%

    ; =============================== Checklist ================================
    Gui, Add, Edit, % "Vchecklist Y6 R25 XP+" . edit_width + 2, %checklist%

    Gui, Show
    Send, ^a
Return
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
    local_players  :=
    images_list    :=
    product_ID     :=
    pos            := 1
    entries        :=
    entry          := 1
    checklist      :=
    ;@AHK++AlignAssignmentOff

    ; =============================== Platform =================================
    ; Line 23
    RegExMatch(source, "`(?<=https://gamefaqs.gamespot.com/)\w+(?=/)", platform)

    ; ================================= Genre ==================================
    ; Line 27
    pos := RegExMatch(source_string, "(?<=genre&quot;:&quot;).+?(?=&quot;,&quot;)", genre, pos)
    genre := TransformGenre(genre)

    ; =============================== Developer ================================
    ; Line 233
    pos := RegExMatch(source_string, "(?<=<a href=""/games/company/).*?"">(.+?)(?=</a>)", developer, pos)
    developer := developer1

    ; =========================== Local Players ============================
    ; Line 246
    RegExMatch(source_string, "`n)(?<=<span>).+?(?= Players?</span>)", local_players)

    ; ============================ Regeional Data ==============================
    start := InStr(source_string, "<div class=""pod gdata"" data-pid=""")
    end := InStr(source_string, "<div class=""pod gdata hide"" data-pid=""", 0, start)
    If (end == 0)
        end := StrLen(source_string)
    source_string := SubStr(source_string, start, end - start)

    pos := 1
    ; Line 292
    While (pos := RegExMatch(source_string, "(?<=<td colspan=""6"" class=""bold"">).+?(?=</td>)", match, pos + StrLen(match)))
    {
        ; =============================== Title ================================
        title := match
        title_list := title_list . match . "|"

        ; ============================== Region ================================
        pos := RegExMatch(source_string, "(?<=<td>)\w+(?=</td>)", match, pos + StrLen(match))
        region_list := region_list . match . "|"

        ; ============================= Publisher ==============================
        pos := RegExMatch(source_string, "(?:<td><a href=""\/games\/company\/.+?>)(.+?)(?=</a></td>)", match, pos)
        publisher_list := publisher_list . match1 . "|"

        ; ============================== Product ID ================================
        pos := RegExMatch(source_string, "(?<=<td>).*?(?=</td>)", match, pos + StrLen(match))
        product_ID := match

        ; ======================= !!Barcode Stub ===============================
        pos := RegExMatch(source_string, "(?<=<td>).*?(?=</td>)", match, pos + StrLen(match))

        ; ============================== Entries ===============================
        entries := entries . A_Index . " - " . title . " (" . product_ID . ") |"

        ; =============================== Date =================================
        pos := RegExMatch(source_string, "(?<=<td>).*?(?=</td>)", match, pos + StrLen(match))

        RegExMatch(match, "\d{2}\/\d{2}\/\d{2}", date_format)
        If (date_format == "")
            date_array := [00, 00, 25]
        Else
            date_array := StrSplit(match, "/")

        If (date_array[3] > 24)
            date_array[3] := "19" . date_array[3]
        Else
            date_array[3] := "20" . date_array[3]

        month_list := month_list . MonthDateToName(date_array[1]) . "|"
        day_list := day_list . date_array[2] . "|"
        year_list := year_list . date_array[3] . "|"

        ; ============================== Rating ================================
        pos := RegExMatch(source_string, "(?<=<td>).+?(?=</td>)", match, pos + StrLen(match))
        rating_list := rating_list . RatingShortToFull(match) . "|"
    }

    ; =================================== Boxes ====================================
    boxes_url := StrReplace(source, "data", "boxes")
    boxes_src_as_string := UrlDownloadWrapper(boxes_url, "Boxes_Data.html")

    pos := 1
    While (pos := RegExMatch(boxes_src_as_string, "`n)(?<=<a href="")\/.+\/boxes\/(\d+)", match, pos + StrLen(match)))
    {
        RegExMatch(boxes_src_as_string, "`n)(?<=<div class=""meta"">).+(?=<br/>)", image_title, pos + StrLen(match))
        RegExMatch(image_title, "\w+", title_platform)
        If (title_platform != platform)
            continue

        boxshot_url := boxes_url . "/" . match1
        boxshot_src_as_string := UrlDownloadWrapper(boxshot_url, "Boxshot_Data.html")

        cover_pos := 1
        While (cover_pos := RegExMatch(boxshot_src_as_string, "(?<=data-img="").+?(?="")", cover_match, cover_pos + StrLen(cover_match)))
        {
            images_list := images_list . image_title . " " . cover_match . "|"
        }
    }

    Gosub, GameGUI
Return
; ==============================================================================
;                              UrlDownloadWrapper
; ==============================================================================
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
    case "Simulation,Virtual,Virtual Life": Return "Simulation / Life"
    case "Sports,Individual,Horse Racing": Return "Horses Race"
    case "Sports,Team,Baseball,Arcade": Return "Sports / Baseball"
    Default: Return genre
    }
}
; ==============================================================================
;                               ParseRatingString
; ==============================================================================
RatingShortToFull(abbreviation)
{
    ratings_board := "Not Found"

    Switch abbreviation
    {
        ;@AHK++AlignAssignmentOn
        case "A": ratings_board    := "CERO"
        case "B": ratings_board    := "CERO"
        case "C": ratings_board    := "CERO"
        case "D": ratings_board    := "CERO"
        case "Z": ratings_board    := "CERO"
        case "E": ratings_board    := "ESRB"
        case "E10+": ratings_board := "ESRB"
        case "G": ratings_board    := "ACB"
        case "PG": ratings_board   := "ACB"
        case "ALL": ratings_board  := "GRB"
        case "3+": ratings_board   := "PEGI"
        case "7+": ratings_board   := "PEGI"
        case "12+": ratings_board  := "PEGI"
        ;@AHK++AlignAssignmentOff
    }

    abbreviation := StrReplace(abbreviation, "+")
    Return ratings_board . ":" . abbreviation
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

    checklist := checklist . region . " Title`n"
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

    checklist := checklist . "Genre`n"
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

    checklist := checklist . "Publisher`n"
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

    checklist := checklist . "Developer`n"
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

    checklist := checklist . rating . "`n"
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
    checklist := checklist . region . " Release Date`n"

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

    checklist := checklist . region . " " . media . "`n"
Return
; ==============================================================================
;                                  Pick Folder
; ==============================================================================
PickFolder:
    Gui, hide
    FileSelectFolder, dl_folder, *%dl_folder%, 3
    Gui, Show
Return
; ==============================================================================
;                                    Images
; ==============================================================================
Images:
    Gui, Submit

    list := StrSplit(images_list, "|")

    FileDelete, %dl_folder%\*.jpg
    FileDelete, %dl_folder%\*.png

    Loop, Parse, image, |,
    {
        loop_field := list[A_LoopField]
        RegExMatch(loop_field, "^(\w+)(?: - )(\w+)(?: )(.+\/(\d+)_)(.+(?=\.))(.+)", match)

        ;@AHK++AlignAssignmentOn
        platform  := match1
        region    := match2
        side      := match5
        image_url := match3 . match5 . match6
        filename  := match4 . "_" . region . "_" . side . match6
        ;@AHK++AlignAssignmentOff

        UrlDownloadToFile, https://gamefaqs.gamespot.com%image_url%, %dl_folder%/%filename%
        If (ErrorLevel)
        {
            MsgBox, UrlDownloadToFile Error: %ErrorLevel%
            Exit
        }
        If (platform == "DS")
            if (side == "front" || side == "back")
                Run, magick.exe %filename% -resize 513x458! -set filename:f `%t `%[filename:f].png, %dl_folder%\, ,
            else if (side == "side")
                Run, magick.exe %filename% -rotate 90 -resize 63x458! -set filename:f `%t `%[filename:f].png, %dl_folder%\, ,
    }
    Gosub, GameGUI
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

    checklist := checklist . "Local Players`n"
Return
; ==============================================================================
;                                     Entry
; ==============================================================================
Entry:
    Gui, Submit
    Gosub, GameGUI
Return
