Clear-Host
Write-Host " ***************************"
Write-Host " *    WinPE Installation   *"
Write-Host " ***************************"
Write-Host

New-OSDCloudUSB -fromIsoUrl 'https://jvdosd.blob.core.windows.net/bootimage/OSDCloud_NoPrompt.iso'
New-Item -ItemType Directory -Path $location\Automate | Out-Null
Invoke-WebRequest -Uri https://raw.githubusercontent.com/JeffWantsToBattle/OSD/main/Update/Automate/Start-OSDCloudGUI.json -OutFile $location\Automate\Start-OSDCloudGUI.json
New-Item -Path $location -Name "$file" -ItemType "file" -Value $version -Force | Out-Null
New-Item -Path $location -Name "$fileWinPE" -ItemType "file" -Value $versionWinPE -Force | Out-Null
New-Item -Path $location -Name "Start-Menu.ps1" -ItemType "file" -Value "iex (irm osd.jevede.nl)" -Force | Out-Null


$MainMenu = {
    Write-Host " ***************************"
    Write-Host " *    WinPE Installation   *"
    Write-Host " ***************************"
    Write-Host
    Write-Host " WinPE Installation complete"
    Write-Host " Install one more WinPE to a USB drive?"
    Write-Host
    Write-Host " 1.) Yes (insert new USB drive before continuing)"
    Write-Host " 2.) No (delete downloaded ISO)"
    Write-Host " Q.) Back (keeps ISO in Download folder (not recommanded))"
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
            Invoke-WebPSScript 'https://raw.githubusercontent.com/JeffWantsToBattle/OSD/main/OSDCloudInstallWinPE.ps1'
        }
        2 {
            $ISOPath = (New-Object -ComObject Shell.Application).Namespace('shell:Downloads').Self.Path
            Dismount-DiskImage -ImagePath "$ISOPath\OSDCloud_NoPrompt.iso" -ErrorAction SilentlyContinue | Out-Null
            Remove-Item $ISOPath\OSDCloud_NoPrompt.iso -ErrorAction SilentlyContinue | Out-Null
        }
    }
}
While ($Select -ne "Q")
