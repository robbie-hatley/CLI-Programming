
; ------------------------------------------------------------------------------------------------------------
;   Robbie Hatley's "Easy" Script
; ------------------------------------------------------------------------------------------------------------

; First, set some options:
AutoItSetOption ( "WinTitleMatchMode" ,   2 ) ; substring match
AutoItSetOption ( "MouseCoordMode"    ,   0 ) ; coordinates relative to window

; Global variables:
Global $FFTitle  = "Firefox Developer Edition"
Global $Password = "^a12345" ; ctrl-A for "select all" (to over-write prev text)

; Body of script:
WinActivate    ( $FFTitle           )
WinWaitActive  ( $FFTitle, "", 10   )
MouseMove      ( 185, 285           )
MouseClick     ( "left"             )
Sleep          ( 1000               )
MouseMove      ( 230, 250           )
MouseClick     ( "left"             )
Send           ( $Password          ) 
MouseMove      ( 180, 290           )
MouseClick     ( "left"             )
Sleep          ( 1000               )
MouseMove      ( 275, 275           )
MouseClick     ( "left"             )
Exit
