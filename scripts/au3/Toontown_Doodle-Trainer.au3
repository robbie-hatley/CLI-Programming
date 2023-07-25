
; ------------------------------------------------------------------------------
;
;   Robbie Hatley's Nifty Doodle Trainer
;
; ------------------------------------------------------------------------------


;===============================================================================
; User Settings:

; VERY, VERY, IMPORTANT:  $PetsPosNum BELOW *MUST* BE SET TO THE 1-INDEXED
; POSITION OF "PETS" IN THE SPEEDCHAT MENU FOR CURRENT TOON AT CURRENT TIME.
; THIS IS USUALLY 3 OR 4.  THIS WILL VARY DEPENDING ON WHETHER OR NOT TOON HAS 
; ANY UNITES, AND POSSIBLY ON OTHER FACTORS.  FAILURE TO SET THIS VARIABLE 
; CORRECTLY MAY RESULT IN YOUR TOON USING UP ALL OF ITS UNITES!
; ALSO, THE DOODLE TRAINER WILL SIMPLY NOT WORK IF THIS VARIABLE IS SET WRONG.
; YOU MUST CHECK THE POSITIONS OF "PETS" ON YOUR SPEEDCHAT MENU, AND THE VALUE
; OF THIS VARIABLE, EVERY SINGLE TIME YOU USE THIS SCRIPT.  THIS VARIABLE CAN
; *NOT* JUST BE SET ONCE!  CHECK THE VALUE BEFORE EVERY USE!

; ALSO VERY, VERY IMPORTANT: THIS VERSION WILL ONLY WORK WITH 1280X1024 
; MONITOR RESOLUTION.   FOR OTHER RESOLUTIONS, THIS SCRIPT MUST BE ALTERED.

; 1-indexed downward vertical position of "Pets" on speedchat menu:
Global $PetsPosNum = 4

; Number of doodles on estate:
Global $NumDood = 6

; Number of tricks in toon's repertoire:
Global $NumTricks = 7


;===============================================================================
; Options:
AutoItSetOption ( "SendAttachMode"     ,    0 )
AutoItSetOption ( "WinTitleMatchMode"  ,    3 )

;===============================================================================
; Hotkeys:
HotKeySet       ( "q", "Scram"                )
HotKeySet       ( "+q","Scram"                )

;===============================================================================
; Menu Variables:

; Vertical Base Positions For Menus:
Global $PetsBase   =  27  ; base vertical position for pets
Global $MenuIncr   =  33  ; menu increment

; From above, calculate vertical positions of EMOTIONS and PETS in pixels:
Global $EmotPosi = $PetsBase + $MenuIncr
Global $PetsPosi = $PetsBase + $PetsPosNum * $MenuIncr

; Pet Commands:
Global $HerePosi = $PetsPosi + 1 * $MenuIncr
Global $StayPosi = $PetsPosi + 3 * $MenuIncr
Global $GoodPosi = $PetsPosi + 4 * $MenuIncr
Global $NicePosi = $PetsPosi + 6 * $MenuIncr

; Horizontal Positions:
Global $BttnCol  = 97   ; SpeedChat Button   Column
Global $SchtCol  = 170  ; SpeedChat Commands Column
Global $PcomCol  = 350  ; Pet       Commands Column
Global $TrixCol  = 445  ; Pet       Tricks   Column


;===============================================================================
; Pet List Variables:

Global $PnamBase   =  197 ; vertical  base      for pet names
Global $PnamIncr   =   23 ; vertical  increment for pet names 
Global $PnamCol    = 1100 ; Horizonal position  for pet names


;===============================================================================
; Misc. Variables:

; Generic loop variable:
Global $i


;===============================================================================
; Utility Functions:

Func Scram()
   Exit
EndFunc

Func CloseFriendInfo()
   MouseMove (1245, 475, 0)   ; Close "Friend Info" panel (if any)
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(125)
EndFunc

Func ClosePetInfo()
   MouseMove (1245, 338, 0)   ; Close "Pet Info" panel (if any)
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(125)
EndFunc

Func OpenFriends()
   MouseMove (1219, 84, 0)    ; Open "Friends" panel
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(125)
EndFunc

Func OpenPetsMenu()
   CloseFriendInfo()
   ClosePetInfo()
   CloseFriendInfo()
   OpenFriends()
   MouseMove (1100, 446, 0)   ; Left Arrow
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(500)
   MouseClick("Left")         ; click
   Sleep(500)
   MouseClick("Left")         ; click
   Sleep(500)
   MouseClick("Left")         ; click
   Sleep(500)
EndFunc

Func Init()
   MouseMove   ($BttnCol, $EmotPosi, 0) ; Speedchat Button
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(350)
   MouseClick("Left")         ; click
   Sleep(350)
   MouseClick("Left")         ; click
   Sleep(350)
   OpenPetsMenu()
EndFunc


;===============================================================================
; Pet Commands

Func PetCommands()
   MouseMove   ( $BttnCol, $EmotPosi, 0) ; Speedchat Button
   Sleep(125)
   MouseClick("Left")                    ; click
   Sleep(125)
   MouseMove   ( $SchtCol, $EmotPosi, 0) ; Emotions
   Sleep(125)
   MouseMove   ( $SchtCol, $PetsPosi, 0) ; Pets
   Sleep(250)
   MouseMove   ( $PcomCol, $PetsPosi, 0) ; Tricks (top of Pet Commands)
   Sleep(125)
EndFunc

Func HereBoy($Reps)
   Local $j
   For $j = 1 to $Reps
      PetCommands()
      MouseMove   ( $PcomCol, $HerePosi, 0) ; Here boy
      Sleep(125)
      MouseClick("Left")         ; click
      Sleep(125)
   Next
EndFunc

Func Stay($Reps)
   Local $j
   For $j = 1 to $Reps
      PetCommands()
      MouseMove   ( $PcomCol, $StayPosi, 0) ; Stay
      Sleep(125)
      MouseClick("Left")         ; click
      Sleep(125)
   Next
EndFunc


;===============================================================================
; Pet Tricks:

Func PetTricks()
   PetCommands()
   Sleep(125)
   MouseMove   ( $TrixCol, $PetsPosi, 0); Jump
   Sleep(125)
EndFunc

Func Trick($TrickNum, $Reps)
   Local $j
   Local $TrixPosi
   $TrixPosi = $PetsPosi + ( ( $TrickNum - 1 ) * $MenuIncr )
   For $j = 1 to $Reps
      PetTricks()
      MouseClick("Left", $TrixCol, $TrixPosi, 1, 2)
   Next
EndFunc

;===============================================================================
; Pet Rewards

Func GoodBoy()
   PetCommands()
   MouseMove   ( $PcomCol, $GoodPosi, 0) ; Good boy
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(125)
EndFunc

Func NiceDoodle()
   PetCommands()
   MouseMove   ( $PcomCol, $NicePosi, 0) ; Nice doodle
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(125)
EndFunc

Func PraiseDoodles($Reps)
   Local $j
   For $j = 1 to $Reps
      GoodBoy()
      NiceDoodle()
   Next
EndFunc

Func FeedDoodle($Doodle)
   Local $PnamPosi = $PnamBase + $Doodle * $PnamIncr
   MouseMove ($PnamCol, $PnamPosi, 0) ; move to doodle name
   Sleep(125)
   MouseClick("Left")                 ; click doodle name
   Sleep(250)
   MouseMove (1118, 204, 0)           ; move to "Feed" button
   Sleep(125)
   MouseClick("Left")                 ; click "Feed" button
   Sleep(125)
   ClosePetInfo()                     ; close pets-info box
EndFunc

Func ScratchDoodle($Doodle)
   Local $PnamPosi = $PnamBase + $Doodle * $PnamIncr
   MouseMove ($PnamCol, $PnamPosi, 0) ; move to doodle name
   Sleep(125)
   MouseClick("Left")                 ; click doodle name
   Sleep(250)
   MouseMove (1118, 245, 0)           ; move to "Scratch" button
   Sleep(125)
   MouseClick("Left")                 ; click "Scratch" button
   Sleep(125)
   ClosePetInfo()                     ; close pets-info box
EndFunc

Func FeedAndScratchDoodles()
   Local $j
   For $j = 1 to $NumDood
      HereBoy(2)
      FeedDoodle($j)
      PraiseDoodles(2)
      HereBoy(2)
      ScratchDoodle($j)
      PraiseDoodles(2)
   Next
EndFunc


;===============================================================================
; Doodle Training Function:

; Now that we've defined a "doodle training language", lets define the main 
; doodle-training function:

Func TrainDoodles()
   Local $i
   WinActivate("Toontown")
   Init()
   HereBoy(3)
   While (1)
      WinActivate("Toontown")
      For $i = 1 to $NumTricks
         HereBoy(3)
         Stay(1)
         Trick($i, 6)
         PraiseDoodles(4)
      Next
      FeedAndScratchDoodles()
      Sleep(120000) ; Let doodles rest for 2 minutes.
   Wend
EndFunc


;===============================================================================
; Script Body:

TrainDoodles()
