CR = chr(10)
Set objArgs = WScript.Arguments
if objArgs.count > 0 then parm = objArgs(0) else parm="the program"
msgbox "This file cannot be opened through the shell. " & CR _
 & "Please launch " & parm & " manually, specify the action to be performed," & CR _
 & "then navigate to the file from within " & parm & ".", 16, _
 "I'm afraid I can't do that."
