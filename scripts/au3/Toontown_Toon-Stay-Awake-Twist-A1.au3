
; ------------------------------------------------------------------------------
;   Robbie Hatley's Nifty Toontown "Twist" Keep-Awake Script, A1
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
Global $CurTitle       = ""

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
   Sleep        ( 250                         )
   Send         ( "{LEFT up}"                 )
EndFunc

Func TwistRight()
   Send         ( "{RIGHT down}"              )
   Sleep        ( 250                         )
   Send         ( "{RIGHT up}"                )
EndFunc

; Script body:
While (1)
   $CurTitle = WinGetTitle("")                   ; Get title of currently-active window.
	If Not WinActive ( $GameTitle2         ) Then ; If Toontown window not active,
	   WinActivate   ( $GameTitle2         )      ; activate Toontown window.
		WinWaitActive ( $GameTitle2, "", 10 )      ; Wait up to 10 seconds for window to activate.
	EndIf

	Sleep            ( 250                 )      ; Sleep 250ms.
   TwistLeft        (                     )      ; Twist left.
	Sleep            ( 250                 )      ; Sleep 250ms.

	If Not WinActive ( $CurTitle           ) Then ; If previous current window not active,
	   WinActivate   ( $CurTitle           )      ; activate previous current window.
		WinWaitActive ( $CurTitle,   "", 10 )      ; Wait up to 10 seconds for window to activate.
	EndIf

   Sleep            ( 50000               )      ; Sleep 50000ms.

   $CurTitle = WinGetTitle("")                   ; Get title of currently-active window.
	If Not WinActive ( $GameTitle2         ) Then ; If Toontown window not active,
	   WinActivate   ( $GameTitle2         )      ; activate Toontown window.
		WinWaitActive ( $GameTitle2, "", 10 )      ; Wait up to 10 seconds for window to activate.
	EndIf

	Sleep            ( 250                 )      ; Sleep 250ms.
   TwistRight       (                     )      ; Twist left.
	Sleep            ( 250                 )      ; Sleep 250ms.

	If Not WinActive ( $CurTitle           ) Then ; If previous current window not active,
	   WinActivate   ( $CurTitle           )      ; activate previous current window.
		WinWaitActive ( $CurTitle,   "", 10 )      ; Wait up to 10 seconds for window to activate.
	EndIf

   Sleep            ( 50000               )      ; Sleep 50000ms.

Wend
