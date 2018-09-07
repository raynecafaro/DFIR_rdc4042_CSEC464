# Set-Location
Set-Location $HOME

$HashTable = @{}

# Time Information
$HashTable.Time = Get-Date
$HashTable.TimeZone = Get-TimeZone
$HashTable.UpTime = (Get-Date) - (gcim Win32_OperatingSystem).LastBootUpTime

# Operating System Information
$HashTable.OSVersion = [System.Environment]::OSVersion

# System Hardware Specs
$HashTable.CPUInfo = Get-WmiObject Win32_Processor
$HashTable.TotalRam = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | ForEach {"{0:N2}" -f ([math]::round(($_.Sum / 1GB),2))}
$HashTable.HDDSpace = Get-WmiObject Win32_LogicalDisk | Select-Object DeviceID, Size
$HashTable.MountedFileSystems = Get-WmiObject Win32_LogicalDisk

# Hostname and domain
$HashTable.Hostname = $ENV:COMPUTERNAME
$HashTable.Domain = $env:USERDOMAIN

# List of Users
$HashTable.LocalUsers = Get-LocalUser | Select-Object Name,SID,LastLogon

# List Scheduled Tasks
$HashTable.ScheduledTasks = Get-ScheduledTask | findstr Ready

# Networking
$HashTable.ArpTable = Get-NetNeighbor
$HashTable.Interfaces = Get-NetAdapter | Select-Object Name, InterfaceDescription, MacAddress
$HashTable.RoutingTable = Get-NetRoute

$HashTable.DHCPServer = ipconfig /all | findstr DHCP
$HashTable.DNSServers = ipconfig /all | findstr DNS

$HashTable.ListeningServices = Get-NetTCPConnection | findstr List
$HashTable.EstablishedConnections = Get-NetTCPConnection | findstr Est

# Processes
$HashTable.ProcessesList = Get-WmiObject Win32_Process | Select-Object ProcessName,ProcessID,ParentProcessID
$HashTable.ProcessesPath = Get-Process | Select-Object Path

# Drivers
$HashTable.Drivers = Get-WindowsDriver -Online -All | Select-Object Driver, BootCritical, OriginalFileName, Version, Date, ProviderName

# Export to CSV
$HashTable.Time | Format-Table | Export-Csv -NoTypeInformation -Path time.csv
$HashTable.TimeZone | Export-Csv -NoTypeInformation -Path timezone.csv
$HashTable.UpTime | Format-Table | Export-Csv -NoTypeInformation -Path uptime.csv
$HashTable.OSVersion | Export-Csv -NoTypeInformation -Path osversion.csv
$HashTable.CPUInfo | Export-Csv -NoTypeInformation -Path cpuinfo.csv
$HashTable.TotalRam | Export-Csv -NoTypeInformation -Path ram.csv
$HashTable.HDDSpace | Export-Csv -NoTypeInformation -Path hdd.csv
$HashTable.MountedFileSystems | Export-Csv -NoTypeInformation -Path mounted.csv
$HashTable.Hostname | Export-Csv -NoTypeInformation -Path hostname.csv
$HashTable.Domain | Export-Csv -NoTypeInformation -Path domain.csv
$HashTable.LocalUsers | Export-Csv -NoTypeInformation -Path users.csv
$HashTable.ScheduledTasks | Export-Csv -NoTypeInformation -Path tasks.csv
$HashTable.ArpTable | Export-Csv -NoTypeInformation -Path arp.csv
$HashTable.Interfaces | Export-Csv -NoTypeInformation -Path interfaces.csv
$HashTable.RoutingTable | Export-Csv -NoTypeInformation -Path routing.csv
$HashTable.DHCPServer | Export-Csv -NoTypeInformation -Path dhcp.csv
$HashTable.DNSServers | Export-Csv -NoTypeInformation -Path dns.csv
$HashTable.ListeningServices | Export-Csv -NoTypeInformation -Path listening.csv
$HashTable.EstablishedConnections | Export-Csv -NoTypeInformation -Path established.csv
$HashTable.ProcessesList | Export-Csv -NoTypeInformation -Path plist.csv
$HashTable.ProcessesPath | Export-Csv -NoTypeInformation -Path ppaths.csv
$HashTable.Drivers | Export-Csv -NoTypeInformation -Path drivers.csv

# Combine CSV Files
Get-ChildItem -Path $HOME -Filter *.csv | ForEach-Object {
    [System.IO.File]::AppendAllText("$HOME/artifacts.csv", [System.IO.File]::ReadAllText($_.FullName))
    Remove-Item $_
}
