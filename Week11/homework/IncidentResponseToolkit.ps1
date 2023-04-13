# Storyline: Incident response toolkit that retrieves a variety of information that can be optionally saved and zipped to a folder


function checkDir() {
    # Testing to see if destination folder exists before attempting to create data within it
    $Folder = 'C:\Users\champuser\Desktop\IncidentResponseToolkit_Results'
    if (Test-Path -Path $Folder) {
        Write-Host -BackgroundColor Green -ForegroundColor White "Checking to see if destination folder exists. DONE"
    } else {
        # Creating destination folder if it does not exists"
        Write-Host -BackgroundColor Red -ForegroundColor White "Checking destination to see if it exists. FAILED"
        "Creating destination folder 'IncidentResponseToolkit_Results' in desktop now. Please wait"
        sleep 2
        New-Item -Path 'C:\Users\champuser\Desktop\IncidentResponseToolkit_Results' -ItemType Directory
        "**DONE** Opening menu."
    }


}
function setDir() {
     $global:readDir = Read-Host -Prompt "**This menu is used to capture and save data about the local system to the users computer. What destination would you like to save these files to? (MUST BE IN SYSTEM PATH FORMAT)"

     if (Test-Path -Path $global:readDir) {
         Write-Host -BackgroundColor Green -ForegroundColor White "Checking to see if destination folder exists. DONE"
     } else {
         Write-Host -BackgroundColor Red -ForegroundColor White "Checking destination folder to see if it exists. FAILED"
         "Creating specified destination directory now. Please wait."
         New-Item -Path $global:readDir -ItemType Directory
     
     }
}
setDir
function menu() {
    do {
    Write-Host "`n**************Incident Response Toolkit Menu*************"
    Write-Host "`nChoose one of the options below:"
    Write-Host "`t1. List all running processes and the path for each process"
    Write-Host "`t2. List all registered services and the executable's path"
    Write-Host "`t3. List all tcp network sockets"
    Write-Host "`t4. List all user account information"
    Write-Host "`t5. List all NetworkAdapterConfiguration information"
    Write-Host "`t6. Get the Event Log of the system"
    Write-Host "`t7. List all of the services installed on the system"
    Write-Host "`t8. Get the execution policies for the current session"
    Write-Host "`t9. Get list of hotfixes that have been applied to the system"
    Write-Host "`t10. Creates a checksum csv file that contains checksums of all files in the destination folder"
    Write-Host "`t11. Creates a .zip file of data folder and creates the checksum of .zip file/save it to a file"
    Write-Host "`t12. Type 'q' or 'Q' to Quit"
    Write-Host "`n******************************************************"
    $choice = Read-Host "`nEnter Choice"
    } until (($choice -eq '1') -or ($choice -eq '2') -or ($choice -eq '3') -or ($choice -eq '4') -or ($choice -eq '5') -or ($choice -eq '6') -or ($choice -eq '7') -or ($choice -eq '8') -or ($choice -eq '9') -or ($choice -eq '10' ) -or ($choice -eq '11' ) -or ($choice -eq 'q' ) )
    switch ($choice) {
       '1'{
           Write-Host "`nListing all running processes and their paths."
           sleep 2
           $runningProcess = Get-Process | select Name, Path
           $runningProcess | Out-Host
           sleep 2
           # Return to main menu when 'm' key is pressed
           $readKey = Read-Host -Prompt "Would you like to save these results to a .csv file?"
           
           

           if ($readKey -match "^[yY]$") {
                   # Save the results to a csv file.
                   Write-Host "Saving contents to your desktop.."
                   sleep 3
                   $runningProcess | Export-Csv -Path $readDir\processes.csv
                   Write-Host "Data has been saved."
           
           }
       menu
       }
       '2'{
          Write-Host "`nListing all registered services and the executable's path."
          sleep 2
          $services = Get-WmiObject win32_service | select Name, PathName
          $services | Out-Host
          sleep 2

          $readKey = Read-Host -Prompt "Would you like to save these results to a .csv file?"

           if ($readKey -match "^[yY]$") {
                   # Save the results to a csv file.
                   Write-Host "Saving contents to the Incident Response Toolkit folder on your desktop."
                   sleep 3
                   $services | Export-Csv -Path $readDir\services.csv
                   Write-Host "Data has been saved."
           
           }
       menu
       }
       '3'{
           Write-Host "`nListing all of the tcp network sockets."
           sleep 2
           $tcpSockets = Get-NetTCPConnection
           $tcpSockets | Out-Host
           sleep 2

           $readKey = Read-Host -Prompt "Would you like to save these results to a .csv file?"

           if ($readKey -match "^[yY]$") {
                   # Save the results to a csv file.
                   Write-Host "Saving contents to the Incident Response Toolkit folder on your desktop."
                   sleep 3
                   $tcpSockets | Export-Csv -Path $readDir\tcpsockets.csv
                   Write-Host "Data has been saved."
           
           }
        menu
        }
        '4'{
           Write-Host "`nListing all user account information."
           sleep 2
           $userInfo = Get-LocalUser
           $userInfo | Out-Host
           sleep 2

           $readKey = Read-Host -Prompt "Would you like to save these results to a .csv file?"

           if ($readKey -match "^[yY]$") {
                   # Save the results to a csv file.
                   Write-Host "Saving contents to the Incident Response Toolkit folder on your desktop."
                   sleep 2
                   $userInfo | Export-Csv -Path $readDir\userinfo.csv
                   Write-Host "Data has been saved."
                   sleep 2
           }
        menu
        }
        '5'{
           Write-Host "`nListing all visible network adapter information."
           sleep 2
           $netAdapter = Get-NetAdapter -Name *
           $netAdapter | Out-Host
           sleep 2

           $readKey = Read-Host -Prompt "Would you like to save these results to a .csv file?"

           if ($readKey -match "^[yY]$") {
                   # Save the results to a csv file.
                   Write-Host "Saving contents to the Incident Response Toolkit folder on your desktop."
                   sleep 2
                   $netAdapter | Export-Csv -Path $readDir\netadapterinfo.csv
                   Write-Host "Data has been saved."
                   sleep 2
           
           }
        menu
        }
        '6'{
           # Selected Get-EventLog cmdlet because it can give you the events of what happened on a system should you need to look and cipher through them to check for any malicious activity.
           Write-Host "`nGetting the system event log of the local system."
           sleep 2
           $eventLog = Get-EventLog -LogName System -Newest 10
           $eventLog | Out-Host
           sleep 2

           $readKey = Read-Host -Prompt "Would you like to save these results to a .csv file?"

           if ($readKey -match "^[yY]$") {
                   # Save the results to a csv file.
                   Write-Host "Saving contents to the Incident Response Toolkit folder on your desktop."
                   sleep 2
                   $eventLog | Export-Csv -Path $readDir\systemeventlog.csv
                   Write-Host "Data has been saved."
                   sleep 2
           
           }
        menu
        }
        '7'{
           # Selected this cmdlet because it allows you to see all of the serivces that should and shouldn't be installed.
           Write-Host "`nListing all services installed on the system."
           sleep 2
           $services2 = Get-WmiObject win32_service | select Name
           $services2 | Out-Host
           sleep 2

           $readKey = Read-Host -Prompt "Would you like to save these results to a .csv file?"

           if ($readKey -match "^[yY]$") {
                   # Save the results to a csv file.
                   Write-Host "Saving contents to the Incident Response Toolkit folder on your desktop."
                   sleep 2
                   $services2 | Export-Csv -Path $readDir\all_services.csv
                   Write-Host "Data has been saved."
                   sleep 2
           
           }
        menu
        }
        '8'{
           # Selected Get-Execution policy cmdlet because it allows you to see what execution policies are in place and what shouldn't be in place.
           Write-Host "`nGetting the execution policies for this session."
           sleep 2
           $executionPolicy = Get-ExecutionPolicy -List
           $executionPolicy | Out-Host
           sleep 2

           $readKey = Read-Host -Prompt "Would you like to save these results to a .csv file?"

           if ($readKey -match "^[yY]$") {
                   # Save the results to a csv file.
                   Write-Host "Saving contents to the Incident Response Toolkit folder on your desktop."
                   sleep 2
                   $executionPolicy | Export-Csv -Path $readDir\executionPolicies.csv
                   Write-Host "Data has been saved."
                   sleep 2
           
           }
        menu
        }
        '9'{
           # Selected Hotfixes cmdlet because this shows you a list of all of the installed updates for a system. This is useful if you want to see what updates are installed on a system and to see what shouldn't be installed on a system.
           Write-Host "`nGetting the hotfixes that have been applied to this system."
           sleep 2
           $getHotfix = Get-Hotfix
           $getHotfix | Out-Host
           sleep 2

           $readKey = Read-Host -Prompt "Would you like to save these results to a .csv file?"

           if ($readKey -match "^[yY]$") {
                   # Save the results to a csv file.
                   Write-Host "Saving contents to the Incident Response Toolkit folder on your desktop."
                   sleep 2
                   $getHotfix | Export-Csv -Path $readDir\hotfixes.csv
                   Write-Host "Data has been saved."
                   sleep 2
           
           }
        menu
        }
        '10'{
            Write-Host -BackgroundColor Red -ForegroundColor White "WARNING: This feature won't work if there are no files in the destination folder."
            sleep 2
            $ready = Read-Host -Prompt "Find checksums of each file in the folder and save to a new file?"

            if ($ready -match "^[yY]$") {
                    Write-Host "Creating checksums for each existing file in the folder."
                    sleep 2
                    $checkSums = Get-FileHash -Algorithm MD5 -Path (Get-ChildItem $readDir\*.*)
                    $checkSums | Export-Csv -Path $readDir\checksums.csv
                    Write-Host "File containing checksums has been created in the folder"
			  sleep 2
            
            }
            
        menu
        }
        '11'{
            Write-Host -BackgroundColor Red -ForegroundColor White "WARNING: This feature won't work if there are no files in the target folder."
            sleep 3
            $ready = Read-Host -Prompt "Do you want to create a .zip file of the folder containing the system data and find checksum of the zip file?"

            if ($ready -match "^[yY]$") {
                    $zipdir = Read-Host -Prompt "What directory would you like the zip file saved to?"
                    Write-Host "Creating .zip file using Incident Response Toolkit data folder."
                    sleep 2
                    Compress-Archive -Path $global:readDir -DestinationPath $zipdir\IncidentResponseToolkit_DATA
                    Write-Host ".Zip file created. Now finding checksum for the .zip file and saving it to a file on the desktop."
                    sleep 2
                    $checkSumDir = Read-Host -Prompt "What directory would you like the checksum file saved to?"
                    $zipcheck = Get-FileHash -path $zipdir\IncidentResponseToolkit_DATA.zip
                    $zipcheck | Export-Csv -Path $checkSumDir\IncidentResponseZIPCHECKSUM.csv
                    Write-Host "New .zip file and checksum successfully created. Checksum is located at: C:\Users\champuser\Desktop\IncidentResponseZIPCHECKSUM.csv"
			        sleep 2
            
            }
            
        menu
        }
        'Q'{
          Write-Host -BackgroundColor Green -ForegroundColor White "Thank you for using this program. Goodbye."
          sleep 2
       }
    }

}
menu

# 3. I didn't find this assignment to be challenging.
# 4. I liked that we used the cmdlets that we found to be useful for an investigations and that this script is useful should be find ourselves in situations where we need to see what's installed, what happened, and what important information we need to extract from systems when using this script.