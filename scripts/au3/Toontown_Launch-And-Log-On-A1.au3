
; ------------------------------------------------------------------------------------------------------------
;   Robbie Hatley's Toontown Acct 1 Launch-and-Log-On Script
;   Runs Launcher 1 and signs into Acct 1.
;   (Doesn't interfere with launcher or game on Account 2.)
; ------------------------------------------------------------------------------------------------------------

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

; Body of script:






Run              ( $LauncherFile                            )
WinWait          ( $LauncherTitle , ""                      )
Sleep            ( 5000                                     )
If WinExists     ( $LauncherTitle                           ) Then
WinSetTitle      ( $LauncherTitle , "", $LauncherTitle2     )
EndIf
WinActivate      ( $LauncherTitle2                          )
WinWaitActive    ( $LauncherTitle2, ""                      )
MouseMove        ( 573, 269                                 )
MouseClick       ( "left"                                   )
Send             ( $UserID                                  ) 
MouseMove        ( 573, 302                                 )
MouseClick       ( "left"                                   )
Send             ( $Password                                )
MouseMove        ( 625, 302                                 )
MouseClick       ( "left"                                   )
WinWait          ( $GameTitle     , ""                      )
WinActivate      ( $GameTitle                               )
WinWaitActive    ( $GameTitle     , ""                      )
Sleep            ( 1500                                     )
WinSetState      ( $GameTitle     , "", @SW_MAXIMIZE        )
Sleep            ( 1500                                     )
WinSetTitle      ( $GameTitle     , "", $GameTitle2         )
Sleep            ( 1500                                     )
MouseMove        ( 956, 497                                 )
MouseClick       ( "left"                                   )
Exit
