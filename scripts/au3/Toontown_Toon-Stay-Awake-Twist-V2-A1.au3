
; ------------------------------------------------------------------------------
;   Robbie Hatley's Nifty Toontown "Twist" Keep-Awake Script, V2, A1
;   Keeps a toon awake in Toontown.
;   (Twists toon left and right.)
; ------------------------------------------------------------------------------

; Options:
AutoItSetOption ( "SendAttachMode"      ,   1 ) ; buffered IO
AutoItSetOption ( "WinTitleMatchMode"   ,   3 ) ; exact window title match
AutoItSetOption ( "MouseCoordMode"      ,   0 ) ; coordinates relative to window

; Global Variables:
Global $LauncherFile   = "C:\Programs\Games\Toontown-Rewritten-A1\Launcher.exe"
Global $LauncherTitle  = "Toontown Rewritten Launcher"
Global $LauncherTitle2 = "Toontown Rewritten Launcher 1"
Global $LaunchProcess  = "Launcher.exe"
Global $GameTitle      = "Toontown Rewritten"
Global $GameTitle2     = "Toontown Rewritten 1"
Global $GameProcess    = "TTREngine.exe"
Global $UserID         = "^aLoneWolfiNTj"                 ; ctrl-A for "select all" (to over-write prev text)
Global $Password       = "^a73CuriousToons"               ; ctrl-A for "select all" (to over-write prev text)

; Functions:

Func Scram()
   Send         ( "{LEFT up}"                 )
   Send         ( "{RIGHT up}"                )
   Exit
EndFunc

; Scram Hot Key (Note:   ^ = Ctrl   + = Shift   ! = Alt):
HotKeySet ( "+!1" , "Scram" )

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
   WinActivate  ( $GameTitle2                 ) ; Activate Toontown window.
   TwistLeft    (                             ) ; Twist left.
   Sleep        ( 50000                       ) ; Wait 50 seconds.

   WinActivate  ( $GameTitle2                 ) ; Activate Toontown window.
   TwistRight   (                             ) ; Twist right.
   Sleep        ( 50000                       ) ; Wait 50 seconds.
Wend
