# PREREQUISTIES and SOFT
# Function to check if Scoop is already installed
function Test-ScoopInstallation {
    if (Test-Path $env:USERPROFILE\scoop) {
        Write-Host "Scoop is already installed."
        return $true
    } else {
        Write-Host "Scoop is not installed."
        return $false
    }
}

# Function to install Scoop
function Install-Scoop {
    Write-Host "Installing Scoop..."
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
    Write-Host "Scoop has been installed."
}

# Function to install software using Scoop
function Install-Software {
    param(
        [string[]]$SoftwareList
    )
    
    Write-Host "Installing software using Scoop..."
    foreach ($software in $SoftwareList) {
        scoop install $software
    }
    Write-Host "Software installation using Scoop completed."
}

if (-not (Test-ScoopInstallation)) {
    Install-Scoop
}

$SoftwareToInstall = @(
    "git",
    "curl",
    "wget",
    "7zip",
    "vcredist",
    "sudo",
    "starship"
)

Install-Software -SoftwareList $SoftwareToInstall
