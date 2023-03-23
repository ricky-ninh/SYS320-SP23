# Storyline: Using the Get-Process and Get-Service
#Get-Process | Select-Object ProcessName, Path, ID | `
#Export-Csv -Path "C:\Users\champuser\Desktop\myProcesses.csv" -NoTypeInformation
#Get-Process | Get-Member
#Get-Service | Where {$_.Status -eq "Stopped"}


# Use the Get-WMI cmdlet
# Get-WmiObject -Class Win32_process | select Name, PathName, ProcessId
# Get-WmiObject -list | Where { $_.Name -ilike "Win32_[p-s]*" } | Sort-Object
# Get-WmiObject -Class Win32_Account | Get-Member


# Task: Grab the network adapter information using the WMI class
# Get the IP address, Default gateway, DHCP server, and the DNS servers.
Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Select IPAddress, DefaultIPGateway, DHCPServer, DNSDomain
# Export list of running processes and running services into separate files
Get-WmiObject -Class Win32_Service | Select Name, PathName, ProcessID | Export-Csv -Path "C:\Users\champuser\Desktop\myServices.csv" -NoTypeInformation
Get-WmiObject -Class Win32_Process | Select Name, PathName, ProcessID | Export-Csv -Path "C:\Users\champuser\Desktop\myProcesses.csv" -NoTypeInformation


# Start and Stop Windows Calculator (calc.exe)
Start-Process calc
Sleep 5
Stop-Process -Name "Win32Calc"