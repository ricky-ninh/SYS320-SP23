# Array of websites containing threat intell
$drop_urls = @('https://rules.emergingthreats.net/blockrules/emerging-botcc.rules',
'https://rules.emergingthreats.net/blockrules/compromised-ips.txt')

# Loop through the URLs for the rule list
foreach ($u in $drop_urls) {

    # Extract the filename
    $temp = $u.split("/")
        
    # The last element in the array is plucked off in the filename
    $file_name = $temp[-1]

    if (Test-Path $file_name) {
        
        continue
    
    } else {

        # Download the rules list
        Invoke-WebRequest -Uri $u -OutFile $file_name

    } # close the if statement
} # close the foreach loop

# Array containing the filename
$input_paths = @('.\compromised-ips.txt','.\emerging-botcc.rules')

# Extract the IP addresses
# 108.190.109.107
# 108.191.2.72
$regex_drop = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

# Append the IP addresses to the temporary IP list
Select-String -Path $input_paths -Pattern $regex_drop | `
ForEach-Object { $_.Matches } | `
ForEach-Object { $_.Value } | Sort-Object | Get-Unique | `
Out-File -FilePath "ips-bad.tmp"


# Get the IP addresses discovered, loop through and replace the beginning of the line with the IPTables syntax
# After the IP address, add the remaining IPTables syntax and save the results to a file
# iptables -A INPUT -s 108.191.2.72 -j DROP
(Get-Content -Path ".\ips-bad.tmp") | % `
{ $_ -replace "^","iptables -A INPUT -s " -replace "$", " -j DROP"} | `
Out-File -FilePath "iptables.bash"



# Create variable for the prompt
$userCreds = Get-Credential champuser
$var = Read-host -Prompt "Please enter 'Windows' or 'IPTables'"

switch ($var) {
    'IPTables' {
        (Get-Content -Path "C:\Users\champuser\ips-bad.tmp") | % `
        { $_ -replace "^", "iptables -A INPUT -s " -replace "$", " -j DROP"} | `
        Out-File -FilePath "C:\Users\champuser\iptables.bash"
        Set-SCPItem -ComputerName '192.168.1.20' -Credential ($userCreds) `
        -Destination 'C:\Users\champuser' -Path 'C:\Users\champuser\iptables.bash'
        # Create new SSH session and check for the file existing or not
        New-SSHSession -ComputerName '192.168.1.20' -Credential ($userCreds)
        (Invoke-SSHCommand -index 0 "ls").Output
    }
    'Windows' {
    # Create executable list of firewall rules to run against the list of bad IPs
    (Get-Content -Path "C:\Users\champuser\ips-bad.tmp") | % `
    { $_ -replace "^", "New-NetFirewallRule -DisplayName 'Block IPs' -Direction Outbound -LocalPort Any -Protocol TCP -Action Block -RemoteAddress " -replace "$"} | `
    Out-File -FilePath "C:\Users\champuser\FirewallRules.ps1"
    }
}