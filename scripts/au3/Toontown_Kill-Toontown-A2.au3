
; ---------------------------------------------------------------------------------
;   Robbie Hatley's Toontown Process Killer
;   First kills ToontownLauncher, then kills Toontown.
;   (This prevents the launcher from launching Firefox to display an error message.)
; ---------------------------------------------------------------------------------

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

; Body of script:
While            (ProcessExists($LaunchProcess)             )
ProcessClose     ( $LaunchProcess                           )
Wend
While            (ProcessExists($GameProcess)               )
ProcessClose     ( $GameProcess                             )
Wend
Exit
