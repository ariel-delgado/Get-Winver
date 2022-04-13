$StartTime = Get-Date
New-Item C:\ClusterInfo -Type directory 	#Create the workbench directory
New-Item C:\ClusterInfo\ScriptTime.txt -ItemType file
Add-Content C:\ClusterInfo\ScriptTime.txt "Started:  $StartTime"
Write-Progress -activity "Obtaining Cluster Information..." -status "Getting Cluster and Cluster Nodes Details..." -percentcomplete 5
Get-ClusterNode | SELECT Name | Export-Csv -LiteralPath C:\ClusterInfo\ClusterNodes1.Csv -Force -NoTypeInformation 	#Get all nodes of the cluster
(Get-Content C:\ClusterInfo\ClusterNodes1.Csv) | ForEach-Object {$_ -replace '"', ""} | Out-File -FilePath C:\ClusterInfo\ClusterNodes2.CSV -Force	#Remove Quotation Marks from above created file
(Get-Content C:\ClusterInfo\ClusterNodes2.Csv) | ForEach-Object {$_ -replace 'Name', ""} | Out-File -FilePath C:\ClusterInfo\ClusterNodes.CSV -Force	#Remove column title for above created file
Remove-Item C:\ClusterInfo\ClusterNodes1.Csv  
Remove-Item C:\ClusterInfo\ClusterNodes2.CSV

Rename-Item -Path C:\ClusterInfo\ClusterNodes.CSV -NewName C:\ClusterInfo\ClusterNodes.BAK
Select-String -Pattern "\w" -Path C:\ClusterInfo\ClusterNodes.BAK | ForEach-Object {$_.Line} | Set-Content -Path C:\ClusterInfo\ClusterNodes.CSV


Remove-Item C:\ClusterInfo\ClusterNodes.BAK

Write-Progress -activity "Obtaining Cluster Information..." -status "Getting Network Adapters Details..." -percentcomplete 10

Get-Content -Path C:\ClusterInfo\ClusterNodes.CSV | ForEach-Object {`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
"Broadcom NIC Devices and Drivers Info for NODE:  $_ ";`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
Invoke-Command -ComputerName $_  {Get-WmiObject -Class Win32_PnPSignedDriver | WHERE {$_.Manufacturer -like "*Broadcom*"}} | Sort-Object -Property FriendlyName | ft -AutoSize PSComputerName, DeviceName, DriverVersion, DriverDate, InfName, isSigned, FriendlyName} | Out-File C:\ClusterInfo\BroadcomNICsDriversVersions.txt -Encoding ascii -Width 7000

Get-Content -Path C:\ClusterInfo\ClusterNodes.CSV | ForEach-Object {`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
"Qlogic NIC Devices and Drivers Info for NODE:  $_ ";`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
Invoke-Command -ComputerName $_  {Get-WmiObject -Class Win32_PnPSignedDriver | WHERE {$_.Manufacturer -like "*Qlogic*"}} | Sort-Object -Property FriendlyName | ft -AutoSize PSComputerName, DeviceName, DriverVersion, DriverDate, InfName, isSigned, FriendlyName} | Out-File C:\ClusterInfo\QlogicNICsDriversVersions.txt -Encoding ascii -Width 7000

Get-Content -Path C:\ClusterInfo\ClusterNodes.CSV | ForEach-Object {`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
"Intel NIC Devices and Drivers Info for NODE:  $_ ";`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
Invoke-Command -ComputerName $_  {Get-WmiObject -Class Win32_PnPSignedDriver | WHERE {$_.Manufacturer -like "*Intel*" -and $_.DeviceClass -like "*NET*"}} | Sort-Object -Property FriendlyName | ft -AutoSize PSComputerName, DeviceName, DriverVersion, DriverDate, InfName, isSigned, FriendlyName} | Out-File C:\ClusterInfo\IntelNICsDriversVersions.txt -Encoding ascii -Width 7000

Get-Content -Path C:\ClusterInfo\ClusterNodes.CSV | ForEach-Object {`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
"Mellanox NIC Devices and Drivers Info for NODE:  $_ ";`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
Invoke-Command -ComputerName $_  {Get-WmiObject -Class Win32_PnPSignedDriver | WHERE {$_.Manufacturer -like "*Mellanox*"}} | Sort-Object -Property FriendlyName | ft -AutoSize PSComputerName, DeviceName, DriverVersion, DriverDate, InfName, isSigned, FriendlyName} | Out-File C:\ClusterInfo\MellanoxNICsDriversVersions.txt -Encoding ascii -Width 7000

Get-Content -Path C:\ClusterInfo\ClusterNodes.CSV | ForEach-Object {`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
"Summary of All NIC Devices and Drivers Info for NODE:  $_ ";`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
Invoke-Command -ComputerName $_  {Get-WmiObject -Class Win32_PnPSignedDriver | WHERE {$_.DeviceClass -like "*NET*"}} | Sort-Object -Property FriendlyName | ft -AutoSize PSComputerName, DeviceName, DriverVersion, DriverDate, InfName, isSigned, FriendlyName} | Out-File C:\ClusterInfo\AllNICsDriversVersions.txt -Encoding ascii -Width 7000


Write-Progress -activity "Obtaining Cluster Information..." -status "Getting Network Configuration Details..." -percentcomplete 25

New-Item C:\ClusterInfo\NodesNetworkSettings.txt -ItemType file


Get-Content -Path C:\ClusterInfo\ClusterNodes.CSV | ForEach-Object {`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
"-                      NETWORK ADAPTERS IN CLUSTER NODE:  $_ `r`n";`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`

Get-WmiObject -Class win32_NetworkAdapterSetting -ComputerName $_ |
Foreach-object `
{
  If( ([wmi]$_.element).netconnectionstatus -eq 2)
    {
     [wmi]$_.element | fl @{N='Label';E={$_.NetconnectionID}}, @{N='Device Name    ';E={$_.ProductName}} #NetworkAdapter
     [wmi]$_.setting | fl IPAddress, IPSubnet, DHCPEnabled, @{N='Gateway';E={$_.DefaultIPGateway}}, @{N='DNS Servers    ';E={$_.DNSServerSearchOrder}}, MACAddress #NetworkAdapterConfiguration
     [wmi]$_.element | fl @{N='Manufacturer   ';E={$_.Manufacturer}}, @{N='Speed (Gb/s)';E={"{0:N1}" -f ($_.Speed/1000000000)}}
     "_`r`n_`r`n" ;
    } #end if  
 } 
 } | Out-File C:\ClusterInfo\NodesNetworkSettings.txt -Append -Encoding ascii
Rename-Item -Path C:\ClusterInfo\NodesNetworkSettings.txt -NewName C:\ClusterInfo\NodesNetworkSettings.BAK
Select-String -Pattern "\w" -Path C:\ClusterInfo\NodesNetworkSettings.BAK | ForEach-Object {$_.Line} | Set-Content -Path C:\ClusterInfo\NodesNetworkSettings.txt

Remove-Item C:\ClusterInfo\NodesNetworkSettings.BAK

Get-Content -Path C:\ClusterInfo\ClusterNodes.CSV | ForEach-Object {`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
"-                      Winver Information Report for NODE:  $_ ";`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
Invoke-Command -ComputerName $_ {Get-Item -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion'}} `
| Out-File C:\ClusterInfo\Winver_Info.txt -Encoding ascii

Get-Content -Path C:\ClusterInfo\ClusterNodes.CSV | ForEach-Object {`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
"-                      WindowsUpdate Information Report for NODE:  $_ ";`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
Invoke-Command -ComputerName $_ {Get-ChildItem -Path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows' -Recurse}} `
| Out-File C:\ClusterInfo\WindowsUpdate_Reg_Info.txt -Encoding ascii

Get-Content -Path C:\ClusterInfo\ClusterNodes.CSV | ForEach-Object {Get-WinEvent -ComputerName $_ -FilterHashTable @{LogName='System'; Id=6008,41,1074} |  Select LevelDisplayName, TimeCreated, ProviderName, Id, MachineName, @{n='Message';e={$_.Message -replace '\s+', " "}} | Export-Csv -Path C:\ClusterInfo\UptimeHistory_$_.txt -NoTypeInformation }
Get-childItem "C:\ClusterInfo\UptimeHistory*.txt" | foreach {[System.IO.File]::AppendAllText("C:\ClusterInfo\CombinedUptimeHistory.csv", [System.IO.File]::ReadAllText($_.FullName))}


Write-Progress -activity "Obtaining Cluster Information..." -status "Getting FS MiniFilter Drivers..." -percentcomplete 94

Get-Content -Path C:\ClusterInfo\ClusterNodes.CSV | ForEach-Object {`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
"-                      FS MiniFilter Drivers Report for NODE:  $_ ";`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
Invoke-Command -ComputerName $_ {fltmc}} `
| Out-File C:\ClusterInfo\fltmc_Info.txt -Encoding ascii

Write-Progress -activity "Obtaining Cluster Information..." -status "Getting Verifier.exe Settings..." -percentcomplete 95

Get-Content -Path C:\ClusterInfo\ClusterNodes.CSV | ForEach-Object {`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
"-                      Verifier.EXE settings Report for NODE:  $_ ";`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
Invoke-Command -ComputerName $_ {verifier /query}} `
| Out-File C:\ClusterInfo\Verifier_Info.txt -Encoding ascii

Write-Progress -activity "Obtaining Cluster Information..." -status "Getting TCPIP Info..." -percentcomplete 96

Get-Content -Path C:\ClusterInfo\ClusterNodes.CSV | ForEach-Object {`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
"-                      Routing Table Report for NODE:  $_ ";`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
Invoke-Command -ComputerName $_ {route print} ;
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
"-                      Netstat NATO Report for NODE:  $_ ";`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
Invoke-Command -ComputerName $_ {netstat -nato} ;
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
"-                      Netsh tcp show global Report for NODE:  $_ ";`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
Invoke-Command -ComputerName $_ {netsh int tcp show global} ;
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
"-                      arp -a Report for NODE:  $_ ";`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
Invoke-Command -ComputerName $_ {arp -a} ;
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
"-                      IPConfig /All Report for NODE:  $_ ";`
"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_`r`n";`
Invoke-Command -ComputerName $_ {ipconfig /all}} `
| Out-File C:\ClusterInfo\TCPIP_Netsh_Info.txt -Encoding ascii

Write-Progress -activity "Obtaining Cluster Information..." -status "Getting Registry Information..." -percentcomplete 97
Write-Progress -activity "Obtaining Cluster Information..." -status "Wrapping up..." -percentcomplete 99
Start-Sleep -s 5


$EndTime = Get-Date
Add-Content C:\ClusterInfo\ScriptTime.txt "Finished:  $EndTime"
