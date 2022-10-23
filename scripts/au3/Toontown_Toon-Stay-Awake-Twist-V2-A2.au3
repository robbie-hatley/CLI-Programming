
; ------------------------------------------------------------------------------
;   Robbie Hatley's Nifty Toontown "Twist" Keep-Awake Script, V2, A2
;   Keeps a toon awake in Toontown.
;   (Twists toon left and right.)
; ------------------------------------------------------------------------------

; Options:
AutoItSetOption ( "SendAttachMode"      ,   1 ) ; buffered IO
AutoItSetOption ( "WinTitleMatchMode"   ,   3 ) ; exact window title match
AutoItSetOption ( "MouseCoordMode"      ,   0 ) ; coordinates relative to window

; Global Variables:
Global $LauncherFile   = "C:\Programs\Games\Toontown-Rewritten-A2\Launcher.exe"
Global $LauncherTitle  = "Toontown Rewritten Launcher"
Global $LauncherTitle2 = "Toontown Rewritten Launcher 2"
Global $LaunchProcess  = "Launcher.exe"
Global $GameTitle      = "Toontown Rewritten"
Global $GameTitle2     = "Toontown Rewritten 2"
Global $GameProcess    = "TTREngine.exe"
Global $UserID         = "^aLittle Freckles Twiddletooth" ; ctrl-A for "select all" (to over-write prev text)
Global $Password       = "^a86NaughtyDogs<>"              ; ctrl-A for "select all" (to over-write prev text)
Global $CurTitle       = ""

; Functions:

Func Scram()
   Send         ( "{LEFT up}"                 )
   Send         ( "{RIGHT up}"                )
   Exit
EndFunc

; Scram Hot Key (Note:   ^ = Ctrl   + = Shift   ! = Alt):
HotKeySet ( "+!2" , "Scram" )

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
   $CurTitle = WinGetTitle("")                  ; Get title of currently-active window.
   WinActivate  ( $GameTitle2                 ) ; Activate Toontown window.
   TwistLeft    (                             ) ; Twist left.
   WinActivate  ( $CurTitle                   ) ; Revert to previous window.
   Sleep        ( 50000                       ) ; Wait 50 seconds.

   $CurTitle = WinGetTitle("")                  ; Get title of currently-active window.
   WinActivate  ( $GameTitle2                 ) ; Activate Toontown window.
   TwistRight   (                             ) ; Twist right.
   WinActivate  ( $CurTitle                   ) ; Revert to previous window.
   Sleep        ( 50000                       ) ; Wait 50 seconds.
Wend
