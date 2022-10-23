
; Who Cares What Time It Is?

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

Global $WinHandle           ; window handle
Global $i                   ; loop variable
Global $WinColor            ; window bg color
Global $WinRed              ; window bg color red
Global $WinGrn              ; window bg color green
Global $WinBlu              ; window bg color blue
Global $TimColor            ; time color
Global $TimRed              ; time color red
Global $TimGrn              ; time color green
Global $TimBlu              ; time color blue
Global $Time                ; time
Global $OldTime             ; previous timestamp
Global $TimeID              ; time control ID
Global $DofW                ; day of week
Global $DofWID              ; day of week control ID
Global $Date                ; date
Global $DateID              ; date control ID

Global $Hou                 ; Hour
Global $Min                 ; Minute
Global $Sec                 ; Second

Global $Ap = "AM"           ; AM, PM, or XM?
Global $MER[7]              ; AM, PM, or XM?
$MER[0] = "AM"              ; AM
$MER[1] = "PM"              ; PM
$MER[2] = "AM"              ; AM
$MER[3] = "PM"              ; PM
$MER[4] = "AM"              ; AM
$MER[5] = "PM"              ; PM
$MER[6] = "XM"              ; XM

Global $Day = "Wed"         ; Day of week.
Global $DOW[8]              ; Days of week.
$DOW[0] = "Sunday"          ; Sunday
$DOW[1] = "Monday"          ; Monday
$DOW[2] = "Tuesday"         ; Tuesday
$DOW[3] = "Wednesday"       ; Wednesday
$DOW[4] = "Thursday"        ; Thursday
$DOW[5] = "Friday"          ; Friday
$DOW[6] = "Saturday"        ; Saturday
$DOW[7] = "Gandalf"         ; Gandalf

Global $Month = "Aug"       ; Month
Global $MTH[13]             ; Months
$MTH[0]  = "January"        ; January
$MTH[1]  = "February"       ; February
$MTH[2]  = "March"          ; March
$MTH[3]  = "April"          ; April
$MTH[4]  = "May"            ; May
$MTH[5]  = "June"           ; June
$MTH[6]  = "July"           ; July
$MTH[7]  = "August"         ; August
$MTH[8]  = "September"      ; September
$MTH[9]  = "October"        ; October
$MTH[10] = "November"       ; November
$MTH[11] = "December"       ; December
$MTH[12] = "Elventide"      ; Elventide

Global $Dom   =    1        ; Day of month
Global $Year  = 1334        ; Year

;==============================================================================
; Define Utility Functions:

Func Scram()
   GuiDelete($WinHandle)
   Exit
EndFunc

;==============================================================================
; Body of script:

; Create The Window: 
$WinHandle = GUICreate("Who Cares What Time It Is?", 800, 200, 300, 250, $WS_OVERLAPPEDWINDOW)

; When user clicks the "X" in the upper-right corner, event "$GUI_EVENT_CLOSE" 
; will occur. So here we tell AutoIt that when that event happens, it should 
; run function "Scram" (defined above) which will delete the window and exit 
; the program:
GuiSetOnEvent ( $GUI_EVENT_CLOSE, "Scram", $WinHandle )

; Create controls:
$TimeID = GUICtrlCreateLabel ( "   ", 200,  25, 500,  65 )
$DateID = GUICtrlCreateLabel ( "   ",  25, 100, 750,  65 )

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
   $Hou   = Random(0,13,1)
   $Min   = Random(0,67,1)
	$Sec   = Random(0,67,1)
	$Ap    = $MER[Random(0,6,1)]
	$Time  = StringFormat("%i:%02i:%02i%2s", $Hou, $Min, $Sec, $Ap)
	$Day   = $DOW[Random(0,7,1)]
	$Month = $MTH[Random(0,12,1)]
	$Dom   = Random(1,37,1)
	$Year  = Random(1000,2999,1)
	$Date  = StringFormat("%3s %3s %i, %4i", $Day, $Month, $Dom, $Year)
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
   $OldTime = $Time ; Set $OldTime to $Time
   $i += 1          ; Increment decisecond timer
   Sleep ( 1753 )   ; Wait 1753ms before continuing loop
Wend
