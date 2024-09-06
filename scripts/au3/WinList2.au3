
; WinList2.au3
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

Global $WinHandle                 ; window handle
Global $i                         ; loop variable
Global $ListID                    ; list control ID
Global $windows_list = WinList()  ; list of ALL open windows
Global $visible_list = ""         ; list of open, visible windows
Global $list_item                 ; an item for the list

;==============================================================================
; Define Utility Functions:

Func Scram()
   GuiDelete($WinHandle)
   Exit
EndFunc

Func IsVisible($handle)
  If BitAnd( WinGetState($handle), 2 ) Then 
    Return 1
  Else
    Return 0
  EndIf
EndFunc

;==============================================================================
; Body of script:

; Create The Window: 
$WinHandle = GUICreate("Open, Visible Windows:", 1400, 700, 50, 50, $WS_OVERLAPPEDWINDOW)

; Show The Window:
GuiSetState ( @SW_SHOW, $WinHandle )

; When user clicks the "X" in the upper-right corner, event "$GUI_EVENT_CLOSE" 
; will occur. So here we tell AutoIt that when that event happens, it should 
; run function "Scram" (defined above) which will delete the window and exit 
; the program:
GuiSetOnEvent ( $GUI_EVENT_CLOSE, "Scram", $WinHandle )

; Create controls:
$ListID = GUICtrlCreateList ( "", 20, 20, 1360, 660, -1, -1 )

; Set font sizes:
GUICtrlSetFont ( $ListID, 12 )

; Load the list:
For $i = 1 to $windows_list[0][0]
  ; Display only visible windows that have a title:
  If $windows_list[$i][0] <> "" AND IsVisible($windows_list[$i][1]) Then
    ; $visible_list = $visible_list & "Title=" & $windows_list[$i][0] & @LF & "Handle=" & $windows_list[$i][1] & @LF & @LF
	 $list_item = "Title = " & $windows_list[$i][0] & "  Handle = " & $windows_list[$i][1] & "|"
    GUICtrlSetData($ListID, $list_item)
  EndIf
Next

; Loop until user closes window:
while 1
   Sleep(100);
wend
