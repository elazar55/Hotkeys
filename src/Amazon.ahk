; ==============================================================================
;                                      GUI
; ==============================================================================
#F1::
AmazonGUI:
    width := 320
    Gui, Destroy
    Gui, add, Text,, ASIN
    Gui, add, Edit, W%width% Vasin, B01BKKKVP
    Gui, add, Text,, Title
    Gui, add, Edit, W%width% Vtitle
    Gui, Add, Button, Default GAmazonScrape, Scrape
    Gui, Show
Return
; ==============================================================================
;                                 AmazonScrape
; ==============================================================================
AmazonScrape:
    Gui, Submit
Return
