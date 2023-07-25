Global $windows_list = WinList()
Global $visible_list = ""
Func IsVisible($handle)
  If BitAnd( WinGetState($handle), 2 ) Then 
    Return 1
  Else
    Return 0
  EndIf
EndFunc

For $i = 1 to $windows_list[0][0]
  ; Display only visible windows that have a title:
  If $windows_list[$i][0] <> "" AND IsVisible($windows_list[$i][1]) Then
    $visible_list = $visible_list & "Title=" & $windows_list[$i][0] & @LF & "Handle=" & $windows_list[$i][1] & @LF & @LF
  EndIf
Next

MsgBox(0, "Open, Visible Windows:", $visible_list)



