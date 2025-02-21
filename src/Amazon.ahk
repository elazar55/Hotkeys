; ==============================================================================
;                                      GUI
; ==============================================================================
#F1::
AmazonGUI:
    width := 320
    Gui, Destroy
    Gui, add, Edit, W%width% Vasin, B01BKKKVP
    Gui, add, Text, % "YP+6 XP+" . width + 5, ASIN
    Gui, add, Edit, X10 W%width% Vtitle
    Gui, add, Text, % "YP+6 XP+" . width + 5, Title
    Gui, Add, Button, Default GAmazonScrape, Scrape
    Gui, Show
Return
; ==============================================================================
;                                 AmazonScrape
; ==============================================================================
AmazonScrape:
    Gui, Submit
Return
