###Install OSDCloud module if not present
if (Get-InstalledModule -Name OSD -ErrorAction SilentlyContinue) {
    Import-Module OSD
} else {
    Write-Host " ***************************"
    Write-Host " *         OSDCloud        *"
    Write-Host " ***************************"
    Write-Host
    Write-Host " Installing OSDCloud Module"
    Install-Module OSD -force
}

$MainMenu = {
    Write-Host " ***************************"
    Write-Host " *         OSDCloud        *"
    Write-Host " ***************************"
    Write-Host
    Write-Host " 1.) OSDCloud Local (WinPE)"
    Write-Host " 2.) OSDCloud Azure (WinPE)"
    Write-Host " 3.) OSDCloud Azure Sandbox (WinPE)"
    Write-Host " 4.) Autopilot (Windows)"
    Write-Host " 5.) Install/Update OSDCloudUSB (Windows)"
    Write-Host " Q.) Exit Menu"
    Write-Host
    Write-Host " Select an option and press Enter: "  -nonewline
}
Clear-Host
Do {
    Clear-Host
    Invoke-Command $MainMenu
    $Select = Read-Host
    Switch ($Select)
        {
        1 {
            Start-OSDCloudGUI
        }
        2 {
            Start-OSDCloudAzure
        }
        3 {
            iex (irm az.osdcloud.com)
        }
        4 {
            Clear-Host
            Write-Host " ***************************"
            Write-Host " *         Autopilot       *"
            Write-Host " ***************************"
            Write-Host
            try {
                Get-WindowsAutopilotInfo.ps1 -online
            } Catch {
                Write-Host "Autopilot script not found, installing script"
                install-script -Name Get-WindowsAutoPilotInfo -Force | Out-Null
                Get-WindowsAutopilotInfo.ps1 -online
            }
        }
        5 {
            Invoke-WebPSScript 'https://raw.githubusercontent.com/JeffWantsToBattle/OSD/main/OSDCloudUpdateMenu.ps1'
        }
        Q {
            Exit
        }
    }
}
While ($Select -ne "Z")
