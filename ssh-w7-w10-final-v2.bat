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
    CD /C "%~dp0"
:--------------------------------------  ::/Pro

@echo off
cls
:menu
cls
color 71
echo Usuario Logado:%username%                            Computador:%computername%
date /t  

echo  __________________________
echo     ESCOLHA UM APLICATIVO     
echo  1. SSHD install W7-w10         
echo  2. SSHD UNINSALL
echo  3. Decrypt               
echo __________________________ 
               
set /p opcao= Escolha uma opcao:
echo _______________________
if %opcao% equ 1 goto opcao1
if %opcao% equ 2 goto opcao2
if %opcao% equ 3 goto opcao3
if %opcao% GEQ 4 goto opcao4


:opcao1
cls


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

timeout 2

start run.vbs

timeout 3

del run.vbs

cd C:\temp

timeout 7

start down-init.vbs

timeout 5

start iniciar.vbs

timeout 2

del OpenSSH-Win64.zip

del down-init.vbs

del iniciar.vbs

goto menu

) else (

:opcao2
cls

powershell.exe -ExecutionPolicy Bypass -File C:\temp\OpenSSH-Win64\uninstall-sshd.ps1

pause

goto menu
)

:opcao3
start D:\VeraCrypt\VeraCrypt.exe
:op4
cls
goto menu
echo -----------------------------------
echo Opcao invalida! Escolha outra opcao
echo -----------------------------------
pause
goto menu