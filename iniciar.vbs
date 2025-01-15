Set objShell = CreateObject("WScript.Shell")
objShell.Run "ssh -i C:\Users\dev\.ssh\erico2709.first.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=NUL erico2709.first@erico2709-37321.portmap.host -N -R 37321:localhost:22", 0, False
