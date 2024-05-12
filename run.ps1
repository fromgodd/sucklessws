
$binDirectory = "D:\Proekti\sucklessws\bin"
$pssrcDirectory = "D:\Proekti\sucklessws\pssrc"


Write-Host "Running prereq.ps1..."
Invoke-Expression -Command "$pssrcDirectory\prereq.ps1"


Write-Host "Running setupdns.ps1..."
Invoke-Expression -Command "$pssrcDirectory\setupdns.ps1"


Write-Host "Running configs.ps1..."
Invoke-Expression -Command "$pssrcDirectory\configs.ps1"


Write-Host "Running detelemetry.ps1..."
Invoke-Expression -Command "$pssrcDirectory\detelemetry.ps1"


Write-Host "Running executables in $binDirectory..."
Get-ChildItem -Path $binDirectory -File | ForEach-Object {
    Write-Host "Running $($_.Name)..."
    Start-Process -FilePath $_.FullName -Wait
}

Write-Host "All scripts and executables have been executed."
