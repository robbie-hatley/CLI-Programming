
; ------------------------------------------------------------------------------------------------------------
;   Wizard101_Launch-And-Log-On.au3
;   Launches, logs-on, and plays Wizard101.
; ------------------------------------------------------------------------------------------------------------

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

; Launch program:
Run ( $App )

; Log on:
WinWait        ( $GameTitle , "" ,   15                ) ; Wait till W101 window exists.
WinActivate    ( $GameTitle                            ) ; Activate W101 window.
WinWaitActive  ( $GameTitle , "" ,   15                ) ; Wait til active.
ControlSetText ( $GameTitle , "" , 1014 , "Argonto"    ) ; Set user-id.
ControlSetText ( $GameTitle , "" , 1015 , "Esquelda78" ) ; Set PW.
ControlClick   ( $GameTitle , "" , 1012                ) ; Click "Login" button.

; Play when ready:
Do
  Sleep(1500)                                                         ; Wait 1.5 seconds.
  $Ready = ControlCommand ( $GameTitle , "" , 1012, "IsEnabled", "" ) ; Are we ready yet?
Until $Ready                                                          ; Yes, we're ready now.
ControlClick   ( $GameTitle , "" , 1012                )              ; Click "Play!" button.
