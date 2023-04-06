# Storyline: View the registered services and print the results 

function select_service {


    cls
    
    # Prompt the user for the service to view or quit.
    $choice = read-host -Prompt "Do you want to view all, stopped, or running services or 'q' to quit the program"


    # Checks for all services
    if ($choice -match "^[aA]ll$") {
        Get-Service | Out-Host
        sleep 4
        select_service
    }

    
    # Checks for running services
    if ($choice -match "^[rR]unning$") {
        Get-Service | Where { $_.Status -eq "Running" } | Out-Host
        sleep 4
        select_service
    
    }


    # Checks for stopped services
    if ($choice -match "^[sS]topped$") {
        Get-Service | Where {$_.Status -eq "Stopped" } | Out-Host
        sleep 4 
        select_service
    
    }


    # Check if the user wants to quit
    if ($choice -match "^[qQ]$") {
        # Stop executing the program and close the script
        break

        } else {

            Write-Host -BackgroundColor Red -ForegroundColor White "The service specified doesn't exist, please try again."       
            sleep 5
            select_service
    }

    
}

select_service