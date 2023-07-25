
; ------------------------------------------------------------------------------------------------------------
;   Robbie Hatley's Disk Usage Report Script
;   Sends email about disk use upon system start.
; ------------------------------------------------------------------------------------------------------------

; First, set some options:
AutoItSetOption ( "SendAttachMode"    ,    1 ) ; buffered IO
AutoItSetOption ( "WinTitleMatchMode" ,    3 ) ; exact window title match
AutoItSetOption ( "MouseCoordMode"    ,    0 ) ; coordinates relative to window
AutoItSetOption ( "WinWaitDelay"      , 1000 ) ; delay 1000ms between windows operations

; Global variables:
Global $ConsoleFile   = "C:\cygwin\bin\mintty.exe -i /Cygwin-Terminal.ico -"
Global $ConsoleTitle  = "~"
Global $DiskScript    = "/rhe/scripts/util/disk-space-test.sh{ENTER}"

; Body of script:
Sleep           ( 90000                      )
Run             ( $ConsoleFile               )
WinWait         ( $ConsoleTitle, "", 60      )
WinActivate     ( $ConsoleTitle              )
WinWaitActive   ( $ConsoleTitle, "", 60      )
Send            ( $DiskScript                )
Exit
