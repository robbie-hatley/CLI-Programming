
; ------------------------------------------------------------------------------
;   Robbie Hatley's Nifty Wizard101 Twist Keep-Awake Script
;   Keeps a wizard awake in Wizard101.
; ------------------------------------------------------------------------------

; Options:
AutoItSetOption ( "SendAttachMode"      ,   1 ) ; buffered IO
AutoItSetOption ( "WinTitleMatchMode"   ,   1 ) ; partial window title match at beginning
AutoItSetOption ( "MouseCoordMode"      ,   0 ) ; coordinates relative to window
AutoItSetOption ( "WinWaitDelay"        , 500 ) ; delay 500ms between windows operations
AutoItSetOption ( "MouseClickDownDelay" ,  25 ) ; make mouse clicks 25ms long
AutoItSetOption ( "MouseClickDelay"     ,  25 ) ; delay 25ms between mouse clicks
AutoItSetOption ( "SendKeyDownDelay"    ,  25 ) ; make key strokes 25ms long
AutoItSetOption ( "SendKeyDelay"        ,  25 ) ; delay 25ms between key strokes

; Global Variables:
Global $GameTitle = "Wizard101"                                 ; window title
Global $App       = "C:\Programs\Games\Wizard101\Wizard101.exe" ; app path
Global $Ready     = 0                                           ; ready to play yet?
Global $CurTitle  = ""                                          ; current window title

Func Scram()
   Exit
EndFunc

; HotKey notes:  ^ = Ctrl   + = Shift   ! = Alt

; "Scram" HotKey:
HotKeySet ( "^q" , "Scram" )

Func TwistLeft()
   Send         ( "{LEFT down}"               )
   Sleep        ( 500                         )
   Send         ( "{LEFT up}"                 )
EndFunc

Func TwistRight()
   Send         ( "{RIGHT down}"              )
   Sleep        ( 500                         )
   Send         ( "{RIGHT up}"                )
EndFunc

; Script body:
While (1)
   WinActivate  ( $GameTitle                  ) ; Activate Wizard101 window.
   TwistLeft    (                             ) ; Twist left.
   Sleep        ( 50000                       ) ; Wait 50 seconds.

   WinActivate  ( $GameTitle                  ) ; Activate Wizard101 window.
   TwistRight   (                             ) ; Twist right.
   Sleep        ( 50000                       ) ; Wait 50 seconds.
Wend
