; ==============================================================================
;                             Auto Exexcute section
; ==============================================================================
; Script attributes
#NoEnv
#SingleInstance, Force
SetTitleMatchMode, 2
SetBatchLines, 10
SendMode, Event

; Excluded windows
GroupAdd, excluded_windows, ahk_exe code.exe
GroupAdd, excluded_windows, ahk_exe cmd.exe
GroupAdd, excluded_windows, ahk_exe mintty.exe

; Included files will auto execute as well
#Include, Hearthstone.ahk
#Include, Misc.ahk
#Include, PicrossTouch.ahk

#IfWinActive ; Unset due to includes setting it
; ==============================================================================
;                                Beep Subroutine
; ==============================================================================
Beep(frequency, volume)
{
    SoundGet, master_volume
    SoundSet, volume
    SoundBeep, %frequency%
    SoundSet, %master_volume%
}
; ==============================================================================
;                              Triple click paste
; ==============================================================================
#v::
    Send, {LButton}
    Send, {LButton}
    Send, {LButton}
    Send, ^v
Return
; ==============================================================================
;                               Double click copy
; ==============================================================================
#c::
    Send, {LButton}
    Send, {LButton}
    Send, ^c
Return
; ==============================================================================
;                             Repeat tab then space
; ==============================================================================
#Space::
    delay = 100

    while (GetKeyState("Space", "p") AND GetKeyState("LWin", "p"))
    {
        Send, {Tab}
        Sleep, %delay%
        Send, {Space}
        Sleep, %delay%
    }
Return
; ==============================================================================
;                                     Price
; ==============================================================================
#F::
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
    ; MsgBox, % Format("{:.2f}", Clipboard + increment + 0.01)
    Send, ^v
    Beep(1200, 20)
Return
; ==============================================================================
;                                 Sentence Case
; ==============================================================================
#s::
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
    Send, ^c
    ClipWait, 1

    StringLower, Clipboard, Clipboard
    Clipboard := RegExReplace(Clipboard, "(?<=\w)(\.)(?=\w)", " ")
    Clipboard := RegExReplace(Clipboard, "(\b\w(?=\w{3,}))", "$U0")

    Send, ^v
    Beep(1200, 20)
Return
; ==============================================================================
;                                 Tile Windows
; ==============================================================================
#a::
    SetTitleMatchMode Regex

    WinGet, window_count, List, .+, , Start Menu|Program Manager|Chrome|Code

    rows := Min(Ceil(window_count / 2), 2)
    columns := Ceil(window_count / rows)
    slots := rows * columns
    carry := slots - window_count

    left_offset := 7
    top_offset := 7

    screen_width := 1920
    screen_height = 1050

    window_width := (screen_width / columns) + (left_offset * 2)
    window_height := (screen_height / rows) + (top_offset)

    Loop, %window_count%
    {
        x_index := Floor((A_Index - 1) / rows)
        y_index := Mod(A_Index - 1, rows)

        x_pos := ((window_width - left_offset * 2) * x_index) - left_offset
        y_pos := (window_height - top_offset) * y_index

        If (carry && A_Index = window_count)
            window_height := ((screen_height / rows) * (carry + 1)) + (top_offset)

        id := window_count%A_Index%

        WinActivate, ahk_id %id%
        WinMove, ahk_id %id%,, x_pos, y_pos, window_width, window_height
        ; MsgBox, X: %x_index%`nY: %y_index%
    }

    SetTitleMatchMode 1
Return
; ==============================================================================
;                                    Reload
; ==============================================================================
#r::
    Reload
Return
; ==============================================================================
;                                       Jobalots
; ==============================================================================

#d::
    output_file := "output.txt"
    FileDelete, %output_file%

    global urls := []
    global titles := []
    global prices := []
    order_html := "order.html"

    If (!ScrapeOrderHTML(order_html))
    {
        MsgBox Error scraping order HTML.
        Return
    }

    global images := []
    global skus := []
    global weights := []
    global asins := []
    ; MsgBox, % urls[4]

    For index, url in urls
    {
        If (!ScrapeData(url))
        {
            MsgBox Error scraping data.
            Return
        }
        FileAppend, % images[index] . "`t"
            . titles[index] . "`t"
            . prices[index] . "`t"
            . weights[index] . "`t"
            . skus[index] . "`t"
            . asins[index] . "`n"
            , %output_file%

        ToolTip, % titles[index]
    }
    Beep(1200, 25)
    ToolTip
Return
; ==============================================================================
;                                  Scrape Data
; ==============================================================================
ScrapeData(address)
{
    source_file := "item.html"
    UrlDownloadToFile, %address%, %source_file%

    If (ErrorLevel)
        Return False

    FileRead, source_string, %source_file%

    If (InStr(source_string, "404 Not Found"))
    {
        images.Push("")
        skus.Push("No Data")
        weights.Push("0")
        asins.Push("No Data")

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

    Return true
}
; ==============================================================================
;                               Scrape Order URLs
; ==============================================================================
ScrapeOrderHTML(order_html)
{
    FileRead, file_string, %order_html%

    If (ErrorLevel)
        Return False

    match_pos := 1
    While (match_pos := RegExMatch(file_string, "(?<=https:\/\/jobalots.com\/products\/)\w+", match, match_pos + StrLen(match)))
        urls.Push("https://eu.jobalots.com/products/" . match)

    match_pos := 1
    While (match_pos := RegExMatch(file_string, "(?<=Jobalots auction - ).+(?=\s?-\d+-)", match, match_pos + StrLen(match)))
        titles.Push(match)

    match_pos := 1
    While (match_pos := RegExMatch(file_string, "(?<=data-label=""Price""><span class=transcy-money>â‚¬)(\d+),(\d+)(?=<\/span>)", match, match_pos + StrLen(match)))
        prices.Push(match1 . "." match2)

    Return True
}
