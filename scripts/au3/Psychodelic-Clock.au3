
; Psychedelic Clock

;==============================================================================
; Files to include:

#include <GuiConstants.au3>
#Include <Date.au3>

;==============================================================================
; Set Options:

; Set GUI Mode To "On Event":
AutoItSetOption ( "GUIOnEventMode", 1 )

;==============================================================================
; Declare Global Variables:

Global $WinHandle    ; window handle
Global $i            ; loop variable
Global $WinColor     ; window bg color
Global $WinRed       ; window bg color red
Global $WinGrn       ; window bg color green
Global $WinBlu       ; window bg color blue
Global $TimColor     ; time color
Global $TimRed       ; time color red
Global $TimGrn       ; time color green
Global $TimBlu       ; time color blue
Global $Time         ; time
Global $OldTime      ; previous timestamp
Global $TimeID       ; time control ID
Global $DofW         ; day of week
Global $DofWID       ; day of week control ID
Global $Date         ; date
Global $DateID       ; date control ID

;==============================================================================
; Define Utility Functions:

Func Scram()
   GuiDelete($WinHandle)
   Exit
EndFunc

;==============================================================================
; Body of script:

; Create The Window: 
$WinHandle = GUICreate("Psychodelic Clock", 750, 200, 300, 250, $WS_OVERLAPPEDWINDOW)

; When user clicks the "X" in the upper-right corner, event "$GUI_EVENT_CLOSE" 
; will occur. So here we tell AutoIt that when that event happens, it should 
; run function "Scram" (defined above) which will delete the window and exit 
; the program:
GuiSetOnEvent ( $GUI_EVENT_CLOSE, "Scram", $WinHandle )

; Create controls:
$TimeID = GUICtrlCreateLabel ( "   ", 175,  25, 500,  65 )
$DateID = GUICtrlCreateLabel ( "   ",  25, 100, 700,  65 )

; Set font sizes:
GUICtrlSetFont ( $TimeID, 36 )
GUICtrlSetFont ( $DateID, 36 )

; Show The Window:
GuiSetState ( @SW_SHOW, $WinHandle )

; Loop each 1/10 second, checking time each loop:
$i = 0 ; time in deciseconds
While 1
   ; Each time timer gets up to 10,000 deciseconds, reset it to 0:
   If $i >= 10000 Then
      $i = 0
   Endif
   ; Get time and date:
   $Time = _NowTime()
   $Date = _DateTimeFormat(_NowCalc(), 1)
   ; Each time the clock clicks over to the next second, 
	; update displays and colors:
   If Not($Time = $OldTime) Then
      GuiCtrlSetData ( $TimeID, $Time )
      GuiCtrlSetData ( $DateID, $Date )
      ; First, get a random color for use as background color:
      $WinColor = Random ( 0x000000, 0xFFFFFF, 1 )
      ; Then, generate a color who's red, green, and blue values are all
      ; guaranteed to differ substantially from those of $WinColor, so that
      ; we will never have low contrast between foreground and background:
      $WinRed   = BitShift(BitAND(0xFF0000, $WinColor), 16)
      $WinGrn   = BitShift(BitAND(0x00FF00, $WinColor),  8)
      $WinBlu   =          BitAND(0x0000FF, $WinColor)
      $TimRed   = Mod(($WinRed + 128), 256)
      $TimGrn   = Mod(($WinGrn + 128), 256)
      $TimBlu   = Mod(($WinBlu + 128), 256)
      $TimColor = BitShift($TimRed, -16) + BitShift($TimGrn, -8) + $TimBlu
      ; Set the background and foreground using the colors we just made:
      GUISetBkColor   ( $WinColor , $WinHandle )
      GUICtrlSetColor ( $TimeID   , $TimColor  )
      GUICtrlSetColor ( $DateID   , $TimColor  )
   Endif
   $OldTime = $Time ; Set $OldTime to $Time
   $i += 1          ; Increment decisecond timer
   Sleep ( 100 )    ; Wait 100ms (1ds) before continuing loop
Wend
