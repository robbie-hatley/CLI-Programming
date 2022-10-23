
; ------------------------------------------------------------------------------
;
;   Robbie Hatley's Nifty Doodle Trainer
;   Rev 1.02 Sun Sep 02, 2007.
;
; ------------------------------------------------------------------------------

; WARNING: You MUST carefully set the value of $PetsPosNum below to match the
;          position of "PETS" in your speedchat menu, or BAD THINGS will happen!

; Hotkeys:
HotKeySet("q", "Scram")
HotKeySet("+q","Scram")

; Define any global variables we need here:

Global $i ; generic loop variable

; Horizontal Positions:
Global $BttnCol  = 97   ; SpeedChat Button   Column
Global $SchtCol  = 170  ; SpeedChat Commands Column
Global $PcomCol  = 350  ; Pet       Commands Column
Global $TrixCol  = 445  ; Pet       Tricks   Column

; Vertical Base Positions:
Global $PetsPosNum = 4   ; position of "PETS" in menu (usually 2, 3, or 4)
Global $PetsBase   = 27  ; base vertical position for pets
Global $MenuIncr   = 33  ; menu increment

; From above, calculate vertical positions of EMOTIONS and PETS in pixels:
Global $EmotPosi = $PetsBase + $MenuIncr
Global $PetsPosi = $PetsBase + $PetsPosNum * $MenuIncr

; Pet Commands:
Global $HerePosi = $PetsPosi + 1 * $MenuIncr
Global $StayPosi = $PetsPosi + 3 * $MenuIncr
Global $GoodPosi = $PetsPosi + 4 * $MenuIncr
Global $NicePosi = $PetsPosi + 6 * $MenuIncr

; Pet Tricks:
Global $JumpPosi = $PetsPosi + 0 * $MenuIncr
Global $RollPosi = $PetsPosi + 1 * $MenuIncr
Global $BackPosi = $PetsPosi + 2 * $MenuIncr
Global $PlayPosi = $PetsPosi + 3 * $MenuIncr
Global $DancPosi = $PetsPosi + 4 * $MenuIncr
Global $Spk_Posi = $PetsPosi + 5 * $MenuIncr
Global $Beg_Posi = $PetsPosi + 6 * $MenuIncr

; Now define the functions that will do all the work.

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

Func PetTricks()
   PetCommands()
   Sleep(125)
   MouseMove   ( $TrixCol, $PetsPosi, 0); Jump
   Sleep(125)
EndFunc

Func HereBoy()
   PetCommands()
   MouseMove   ( $PcomCol, $HerePosi, 0) ; Here boy
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(125)
EndFunc

Func Stay()
   PetCommands()
   MouseMove   ( $PcomCol, $StayPosi, 0) ; Stay
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(125)
EndFunc

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

Func Jump()
   PetTricks()
   MouseMove   ( $TrixCol, $JumpPosi, 0); Jump
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(125)
EndFunc()

Func Rollover()
   PetTricks()
   MouseMove   ( $TrixCol, $RollPosi, 0) ; Roll over
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(125)
EndFunc

Func Backflip()
   PetTricks()
   MouseMove   ( $TrixCol, $BackPosi, 0) ; Backflip
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(125)
EndFunc

Func PlayDead()
   PetTricks()
   MouseMove   ( $TrixCol, $PlayPosi, 0) ; Play dead
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(125)
EndFunc

Func Dance()
   PetTricks()
   MouseMove   ( $TrixCol, $DancPosi, 0) ; Dance
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(125)
EndFunc

Func Speak()
   PetTricks()
   MouseMove   ( $TrixCol, $Spk_Posi, 0) ; Speak
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(125)
EndFunc

Func Beg()
   PetTricks()
   MouseMove   ( $TrixCol, $Beg_Posi, 0) ; Beg
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(125)
EndFunc

Func ScratchFirstDoodle()
   MouseMove (1134, 224, 0)   ; First doodle
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(250)
   MouseMove (1118, 245, 0)   ; Scratch
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(125)
   ClosePetInfo()
EndFunc

Func FeedFirstDoodle()
   MouseMove (1134, 224, 0)   ; First doodle
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(250)
   MouseMove (1118, 204, 0)   ; Feed
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(125)
   ClosePetInfo()
EndFunc

Func ScratchSecondDoodle()
   MouseMove (1134, 240, 0)   ; Second doodle
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(250)
   MouseMove (1118, 245, 0)   ; Scratch
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(125)
   ClosePetInfo()
EndFunc

Func FeedSecondDoodle()
   MouseMove (1134, 240, 0)   ; Second doodle
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(250)
   MouseMove (1118, 204, 0)   ; Feed
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(125)
   ClosePetInfo()
EndFunc

Func ScratchThirdDoodle()
   MouseMove (1134, 258, 0)   ; Third doodle
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(250)
   MouseMove (1118, 245, 0)   ; Scratch
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(125)
   ClosePetInfo()
EndFunc

Func FeedThirdDoodle()
   MouseMove (1134, 258, 0)   ; Third doodle
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(250)
   MouseMove (1118, 204, 0)   ; Feed
   Sleep(125)
   MouseClick("Left")         ; click
   Sleep(125)
   ClosePetInfo()
EndFunc

Func PraiseDoodles()
   dim $j
   For $j = 1 to 4
      GoodBoy()
      NiceDoodle()
   Next
EndFunc

Func ScratchDoodles()
   ScratchFirstDoodle()
   PraiseDoodles()
   ScratchSecondDoodle()
   PraiseDoodles()
   ScratchThirdDoodle()
   PraiseDoodles()
EndFunc

Func FeedDoodles()
   FeedFirstDoodle()
   PraiseDoodles()
   FeedSecondDoodle()
   PraiseDoodles()
   FeedThirdDoodle()
   PraiseDoodles()
EndFunc

Func Scram()
   Exit
EndFunc


; Now that we've defined a "doodle training language",
; the main body of script can begin.

Init()

For $i = 1 to 10
   HereBoy()
Next

Stay()

While (1)

   For $i = 1 to 8
      Jump()
      GoodBoy()
      NiceDoodle()
   Next

   FeedDoodles()

   For $i = 1 to 8
      Speak()
      GoodBoy()
      NiceDoodle()
   Next

   ScratchDoodles()

   For $i = 1 to 8
      Dance()
      GoodBoy()
      NiceDoodle()
   Next

   FeedDoodles()

   For $i = 1 to 8
      PlayDead()
      GoodBoy()
      NiceDoodle()
   Next

   ScratchDoodles()

   For $i = 1 to 8
      Rollover()
      GoodBoy()
      NiceDoodle()
   Next

   FeedDoodles()

   For $i = 1 to 8
      Backflip()
      GoodBoy()
      NiceDoodle()
   Next

   ScratchDoodles()

   For $i = 1 to 8
      Beg()
      GoodBoy()
      NiceDoodle()
   Next

   FeedDoodles()

Wend
