# Storyline: Review the Security Event Log

# Directory to save files:

$myDir = "C:\Users\champuser\Desktop\"

# List all the available Windows Event Logs
Get-EventLog -List 

# Create a prompt to allow the user to select the Log to view
$readLog = Read-Host -Prompt "Please select a log to review from the list above"

# Print the results for the log
Get-EventLog -LogName $readLog -Newest 40 | where {$_.Message -ilike "*$readPhrase*" } | Export-Csv -NoTypeInformation `
-Path "$myDir\securityLogs.csv"