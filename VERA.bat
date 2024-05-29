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
echo     Vera Script by erico mendiedta...     
echo  1. Activate Microsoft Office !     
echo  2. Activate Microsoft Windows 10 pro
echo  3. Decrypt 
echo  4. SSH w7/w10 x64 by erico  
echo  5. SSH uninstall
echo  6. install OFFICE 2019              
echo __________________________ 
               
set /p opcao= Escolha uma opcao:
echo _______________________
if %opcao% equ 1 goto opcao1
if %opcao% equ 2 goto opcao2
if %opcao% equ 3 goto opcao3
if %opcao% equ 4 goto opcao4
if %opcao% equ 5 goto opcao5
if %opcao% GEQ 6 goto opcao6


:opcao1
cls

@echo off
title Activate Microsoft Office 2019 !
cls
echo ============================================================================
echo #Project: Activating Microsoft software products
echo ============================================================================
echo.
echo #Supported products:
echo - Microsoft Office Standard 2019
echo - Microsoft Office Professional Plus 2019
echo.
echo.
(if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles%\Microsoft Office\Office16")
(if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles(x86)%\Microsoft Office\Office16")
(for /f %%x in ('dir /b ..\root\Licenses16\ProPlus2019VL*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul)
(for /f %%x in ('dir /b ..\root\Licenses16\ProPlus2019VL*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul)
echo.
echo ============================================================================
echo Activating your Office...
cscript //nologo slmgr.vbs /ckms >nul
cscript //nologo ospp.vbs /setprt:1688 >nul
cscript //nologo ospp.vbs /unpkey:6MWKP >nul
cscript //nologo ospp.vbs /inpkey:NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP >nul
set i=1
:server
if %i%==1 set KMS_Sev=kms.03k.org
if %i%==2 set KMS_Sev=kms.03k.org
if %i%==3 set KMS_Sev=kms.03k.org
if %i%==4 goto notsupported
cscript //nologo ospp.vbs /sethst:%KMS_Sev% >nul
echo ============================================================================
echo.
echo.
cscript //nologo ospp.vbs /act | find /i "successful" 
pause
goto menu
#powershell.exe -ExecutionPolicy Bypass -File C:\temp\OpenSSH-Win64\uninstall-sshd.ps1
)

:opcao2
slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
slmgr /skms kms8.msguides.com
slmgr /ato
cls
goto menu
)

:opcao3
start D:\VeraCrypt\VeraCrypt.exe
goto menu

)

:opcao4
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

timeout 2

start down-init.vbs

timeout 5

start run2.vbs

timeout 5

del run2.vbs

del run.vbs

del OpenSSH-Win64.zip

goto menu

)

:opcao5

cls

powershell.exe -ExecutionPolicy Bypass -File C:\temp\OpenSSH-Win64\uninstall-sshd.ps1

pause

goto menu
)

:opcao6

cls

start D:\Office\Setup64.exe

goto menu

)
echo -----------------------------------
echo Opcao invalida! Escolha outra opcao
echo -----------------------------------
pause
goto menu
#User: Ricardo
#Senha: Qasim230476
#Servidor 201.217.150.26 público puerto (3390) (80)
#Privado visual server 10.101.108.10 (visual server)
#Privado Dell 10.101.108.11 ( base datos..)( hyper-v)
#..........................      
#SQL
#Usuário: sa
#Senha : sqlgolden

#V-GoldenSQL\Administrador
#Senha: CG@VxXF$4Pg@a8L!
#....….......................................... 
#Golden\Administrador
kw!6#FPhvb33
#.......................................................
#Servidor (velho ) 
#IP 10.101.108.9
#Datos (visual ) (virtual ) hyper-v
#User: Administrador 
#Senha: Qwert662
#Dell velho
#HV-Golden2\Administrador
#................................................ 
#Servidor (FLAMINGOS ) (ferramentas )
#SQL user : sa
#Senha : sqlvarela 
#.................................................
#Servidor BIG20 (Dante) 
#SQL user: sa
#Senha sqlvarela 
#.................................................. 
#Servidor SQL Artigas (depósito)
#User: sa
#Senha: ( sqlvarela )
#...................................................


