set objshell = createobject ("wscript.shell")
objShell.Run "C:\temp\ngrok tcp 22", vbhide -force
objShell.Run "C:\temp\ngrok tcp 22", vbhide 