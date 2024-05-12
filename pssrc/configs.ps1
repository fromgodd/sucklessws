# Function to check if PowerShell from Microsoft Store is already installed
function Test-PowerShellInstallation {
    $installedVersion = (Get-Command pwsh).Version
    if ($installedVersion) {
        Write-Host "PowerShell is already installed. Version: $($installedVersion)"
        return $true
    } else {
        Write-Host "PowerShell is not installed."
        return $false
    }
}

# Function to download and install PowerShell from GitHub
function Install-PowerShellFromGitHub {
    Write-Host "Downloading PowerShell from GitHub..."
    $url = "https://github.com/PowerShell/PowerShell/releases/download/v7.4.2/PowerShell-7.4.2-win-x64.msi"
    $outputFile = "$env:TEMP\PowerShell-7.4.2-win-x64.msi"
    Invoke-WebRequest -Uri $url -OutFile $outputFile

    Write-Host "Installing PowerShell..."
    Start-Process -FilePath msiexec.exe -ArgumentList "/i `"$outputFile`" /quiet /norestart" -Wait
    Write-Host "PowerShell has been installed."
    Remove-Item $outputFile -Force
}

# Function to create PowerShell profile if not exists and configure Starship
function Create-PowerShellProfile {
    if (!(Test-Path -Path $PROFILE)) {
        New-Item -ItemType File -Path $PROFILE -Force
        Write-Host "PowerShell profile created."

        # Add configuration for Starship
        Add-Content -Path $PROFILE -Value "Invoke-Expression (& starship init powershell)"
        Write-Host "Starship configuration added to PowerShell profile."
    } else {
        # Check if Starship configuration already exists
        $profileContent = Get-Content -Path $PROFILE
        if ($profileContent -notmatch "Invoke-Expression \(& starship init powershell\)") {
            Add-Content -Path $PROFILE -Value "`nInvoke-Expression (& starship init powershell)"
            Write-Host "Starship configuration added to existing PowerShell profile."
        } else {
            Write-Host "Starship configuration already exists in PowerShell profile."
        }
    }
}


# Main script
if (-not (Test-PowerShellInstallation)) {
    Install-PowerShellFromGitHub
}

Write-Host "Checking and creating PowerShell config..."
Create-PowerShellProfile
