# SAFE DNS SETUP

# Define DNS providers
$YandexDNS = @("77.88.8.8", "77.88.8.1")
$AdGuardDNS = @("94.140.14.14", "94.140.15.15")

# Define network adapters
$EthernetAdapter = "Ethernet"
$WiFiAdapter = "Wi-Fi"

function Set-DnsServerAddress {
    param(
        [string]$InterfaceAlias,
        [array]$DnsAddresses
    )

    try {
        # Attempt to set DNS server address
        Set-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -ServerAddresses $DnsAddresses -ErrorAction Stop
        Write-Host "· Successfully set DNS server addresses for interface $InterfaceAlias."
    }
    catch {
        # Handle errors
        Write-Host "· Failed to set DNS server addresses: $($_.Exception.Message)"
        if($_.Exception.Message -match "Access to a CIM resource was not available to the client.") {
            Write-Host "· Please run this script as an administrator to set DNS server addresses."
        }
    }
}

# Function to prompt user for DNS selection
function Select-DnsProvider {
    Write-Host "Select DNS Provider:`n1. Yandex DNS`n2. AdGuard DNS"
    $choice = Read-Host "Enter your choice (1 or 2):"
    switch ($choice) {
        1 { return $YandexDNS }
        2 { return $AdGuardDNS }
        default {
            Write-Host "Invalid choice. Defaulting to Yandex DNS."
            return $YandexDNS
        }
    }
}

# Function to prompt user for network adapter selection
function Select-NetworkAdapter {
    Write-Host "Select Network Adapter:`n1. Ethernet`n2. Wi-Fi"
    $choice = Read-Host "Enter your choice (1 or 2):"
    switch ($choice) {
        1 { return $EthernetAdapter }
        2 { return $WiFiAdapter }
        default {
            Write-Host "Invalid choice. Defaulting to Ethernet adapter."
            return $EthernetAdapter
        }
    }
}

# Main script
$selectedDns = Select-DnsProvider
$selectedAdapter = Select-NetworkAdapter
Set-DnsServerAddress -InterfaceAlias $selectedAdapter -DnsAddresses $selectedDns

# Verify configuration
Write-Host "· Type " -NoNewline
Write-Host "Get-DnsClientServerAddress" -ForegroundColor Green -NoNewline
Write-Host " to verify and view DNS configuration."

# todo - ipconfig /all | findstr "DNS Servers"
