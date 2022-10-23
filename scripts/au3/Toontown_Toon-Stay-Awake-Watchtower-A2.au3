
; ------------------------------------------------------------------------------
;   Robbie Hatley's Nifty Toontown Keep-Awake Script, A2
;   Keeps a toon awake in Toontown.
;   ("Watchtower" Variant)
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
   Send("."&@LF)
   Exit
EndFunc

; Scram Hot Key (Note:   ^ = Ctrl   + = Shift   ! = Alt):
HotKeySet ( "+!2" , "Scram" )

Func Prate()
   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".There must be some way out of here,"&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".said the joker to the thief,"&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".There's too much confusion,"&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".I can't get no relief."&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".Business men, they drink my vine,"&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".plows men dig my earth,"&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".none of them along the line"&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".know what any of it is worth."&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".No reason to get excited,"&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".the thief, he kindly spoke,"&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".There are many here among us"&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".who feel that life is but a joke."&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".But you and I, we've been through that,"&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".and this is not our fate,"&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".So let us not talk falsely now,"&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".the our is getting late."&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".All along the watch tower,"&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".princes kept the view,"&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".while all the women came and went,"&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".barefoot servants, too."&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".Outside in the distance,"&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".a wildcat did growl."&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".Too riders were approaching,"&@LF)
   WinActivate($CurTitle)
   Sleep(5000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send(".the wind began to howl."&@LF)
   WinActivate($CurTitle)
   Sleep(6000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("."&@LF)
   WinActivate($CurTitle)
   Sleep(12000)
EndFunc

; Script body:
While (1)
   Prate()
Wend
