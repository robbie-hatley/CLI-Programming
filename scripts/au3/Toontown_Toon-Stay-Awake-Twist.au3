
; ------------------------------------------------------------------------------
;   Robbie Hatley's Nifty Toontown "Twist" Keep-Awake Script, generic version
;   Keeps a toon awake in Toontown.
;   (Twists toon left and right.)
; ------------------------------------------------------------------------------

; Global Variables:
Global $GameTitle      = "Toontown Rewritten"
Global $CurTitle       = ""

; Functions:

Func Scram()
   Send         ( "{LEFT up}"    )
   Send         ( "{RIGHT up}"   )
   Exit
EndFunc

; Scram Hot Key (Note:   ^ = Ctrl   + = Shift   ! = Alt):
HotKeySet ( "+!1" , "Scram" )

Func TwistLeft()
   Send         ( "{LEFT down}"  )
   Sleep        ( 100            )
   Send         ( "{LEFT up}"    )
EndFunc

Func TwistRight()
   Send         ( "{RIGHT down}" )
   Sleep        ( 100            )
   Send         ( "{RIGHT up}"   )
EndFunc

; Script body:
While (1)
   $CurTitle = WinGetTitle("")                  ; Get title of currently-active window.
   WinActivate  ( $GameTitle     ) ; Activate Toontown window.
   TwistLeft    (                ) ; Twist left.
   WinActivate  ( $CurTitle      ) ; Revert to previous window.
   Sleep        ( 50000          ) ; Wait 50 seconds.

   $CurTitle = WinGetTitle("")                  ; Get title of currently-active window.
   WinActivate  ( $GameTitle     ) ; Activate Toontown window.
   TwistRight   (                ) ; Twist right.
   WinActivate  ( $CurTitle      ) ; Revert to previous window.
   Sleep        ( 50000          ) ; Wait 50 seconds.
Wend
