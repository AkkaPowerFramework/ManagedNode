$excutable = "pwsh"
if (-not($psversiontable.PSEdition -eq "Core")) {
  $pwsh = &$excutable -Version
  if (-Not ($pwsh -eq "")) {
    $excutable = "powershell"
    Write-Output "You are running this script in a normal Windows PowerShell session. This script is developed and tested for PowerShell Core. If you encounter unusual errors executing this script, consider installing and running it in PowerShell Core. You can get more information about it at <https://aka.ms/pscore6>."
  }
}

# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments + " -NoProfile -NoLogo"
    Start-Process -FilePath $excutable -Verb Runas -ArgumentList $CommandLine
    Exit
  }
}
$ofs = "`n"

$VmName = "AkkaPowerNode"
# $VmName = "srv"

$ISO = (Get-ChildItem -File -Filter *.iso).FullName

Write-Output "Found following ISO: `n`t$ISO`n"

Write-Output "Checking for existing VMs..."

$VMs = (Get-VM -Name "*$VmName*")
$VMsNames = ($VMs).Name
$VMsCount = $VMsNames.Length

$ofs = "`n`t"

Write-Output "VmName: $VmName (found $VMsCount times)`n"
if ($VMsCount -gt 0) {
  Write-Output "`t$VMsNames`n"
}

$ofs = "`n"

$VMsCount += 1
$NewVMName = "$VmName-" + ([String]$VMsCount).PadLeft(3, "0")
$NewVMSwitch = (Get-VMHost).ExternalNetworkAdapters[0].SwitchName
$NewVHDName = $NewVMName + "-System.vhdx"
$NewVHDSize = "5GB"
$NewVHDDataSize = "50GB"
$NewRamSize = "4GB"
Write-Output "Next VM `n`tNode-Name: `t$NewVMName`n`tVHD:`t`t$NewVHDName ($NewVHDSize)`n`tRam-Size: `t$NewRamSize`n`tSwitch:`t`t$NewVMSwitch`n`tData-VHD:`t$NewVHDData ($NewVHDDataSize)`n`n"


$NewVHDData = (Get-VMHost).VirtualHardDiskPath + $NewVMName + "-Data.vhdx"
Write-Output "Creating new Node ...`n"
New-VM -Name $NewVMName -NewVHDPath $NewVHDName -NewVHDSizeBytes $NewVHDSize -Generation 2 -SwitchName $NewVMSwitch -MemoryStartupBytes $NewRamSize -BootDevice VHD
Write-Output "Creating new Data VHDX ..."
New-VHD $NewVHDData -SizeBytes $NewVHDDataSize
Write-Output "Attatching Data VHDX ..."
Add-VMHardDiskDrive -VMName $NewVMName -ControllerType SCSI -ControllerLocation 1 -Path $NewVHDData

Write-Output "Attatching ISO ..."
Add-VMDvdDrive -VMName $NewVMName  -ControllerLocation 2 -Path $ISO
Write-Output "Setting up new NodeVM"
Set-VMProcessor -VMName $NewVMName -Count ((Get-VMHost).LogicalProcessorCount)

$VMDrives = Get-VMHardDiskDrive -VMName $NewVMName
$VMDVDs = (Get-VMDvdDrive -VMName $NewVMName)[0]

Set-VMFirmware -VMName $NewVMName -EnableSecureBoot Off -BootOrder $VMDrives[0], $VMDrives[1], $VMDVDs

# Enable-VMIntegrationService -VMName $NewVMName -Name 'Guest Service Interface'

# apt-get update
# apt-get install linux-azure

# Copy-VMFile

Write-Output "Press Enter to start the configured Node ..."

Start-VM -Name $NewVMName

Write-Output "The Node has now started. Please procede to Configure-Ubuntu.md"
Pause




