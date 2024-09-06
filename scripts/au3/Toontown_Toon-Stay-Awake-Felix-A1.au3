
; ------------------------------------------------------------------------------
;   Robbie Hatley's Nifty Toontown Keep-Awake Script
;   Keeps a toon awake in Toontown.
;   ("Felix" Variant)
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
Global $CurTitle       = ""

; Functions:

Func Scram()
   Send("."&@LF)
   Exit
EndFunc

; Scram Hot Key (Note:   ^ = Ctrl   + = Shift   ! = Alt):
HotKeySet ( "+!1" , "Scram" )

Func Prate()
   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".I'm Felix the cat, the wonderful wonderful cat{!}"&@LF)
   WinActivate($CurTitle)
   Sleep(6000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".Whenever I get in a fix, I reach into my bag of tricks{!}"&@LF)
   WinActivate($CurTitle)
   Sleep(6000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".The Professor and Rock Bottom are no match for me{!}"&@LF)
   WinActivate($CurTitle)
   Sleep(6000)
EndFunc

; Script body:
While (1)
   Prate()
Wend
