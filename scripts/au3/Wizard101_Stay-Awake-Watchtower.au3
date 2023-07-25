
; ----------------------------------------------------------------------------
;   Robbie Hatley's Nifty Wizard101 Watchtower Stay-Awake Script
;   Keeps a toon awake in Wizard101.
; ----------------------------------------------------------------------------

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

Func Prate()
   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("""There must be some way out of here"","&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("said the joker to the thief."&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("""There's too much confusion;"&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("I can't get no relief."&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("Businessmen, they drink my wine,"&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("plowmen dig my earth;"&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("none of them along the line"&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("know what any of it is worth."""&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("""No reason to get excited"","&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("the thief, he kindly spoke."&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("""There are many here among us"&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("who feel that life is but a joke."&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("But you and I, we've been through that,"&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("and this is not our fate;"&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("so let us not talk falsely now;"&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("the hour is getting late."""&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("All along the watch tower,"&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("princes kept the view,"&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("while all the women came and went,"&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("barefoot servants, too."&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("Outside in the distance,"&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("a wildcat did growl."&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("Two riders were approaching;"&@CR)
   WinActivate($CurTitle)
   Sleep(3001)

   $CurTitle = WinGetTitle("")
   WinActivate("Wizard101")
   Send("the wind began to howl."&@CR)
   WinActivate($CurTitle)
   Sleep(30000)
EndFunc

While (1)
   Prate()
Wend
