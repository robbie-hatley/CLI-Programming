
; ------------------------------------------------------------------------------
;   Robbie Hatley's Nifty Toontown Keep-Awake Script, A1
;   Keeps a toon awake in Toontown.
;   ("Talk" Variant)
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
   Send("Fried rice tastes good."&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("What is the meaning of life?"&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("I'm feeling rather confused right now."&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("Yellow jellybeans taste better than orange jellybeans."&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("Business suits are itchy to wear, don't you think?"&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("Organic matter in soil helps grow healthier flowers{!}"&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("Hmm."&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("I love the taste of stir fried chicken."&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("My doodles can do lots of tricks."&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("Look out{!}  The sky is falling{!}"&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("ooo"&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("She fished in the pond for bass, but caught perch."&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("No, that's not true{!}  Trust me on that{!}"&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("Understanding does not necessarily earn you dollars."&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("DUCK{!}{!}{!}"&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("Watch the sun set with me."&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("The sun also rises."&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("Misty moonlit meadows gleam in silvery moonlight."&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("You can swim under the bridge if you like."&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("I'd rather be lord and master than scullery maid."&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("She sells sea shells on the sea shore."&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("Do you feel incomplete?"&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("Are you looking for your missing piece?"&@LF)
   WinActivate($CurTitle)
   Sleep(7000)

   $CurTitle = WinGetTitle("")
   WinActivate($GameTitle2)
   Send("Finally, I came home."&@LF)
   WinActivate($CurTitle)
   Sleep(7000)
EndFunc

; Script body:
While (1)
   Prate()
Wend
