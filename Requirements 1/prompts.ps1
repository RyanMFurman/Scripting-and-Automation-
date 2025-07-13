# XXXXXXX XXXXXXXX

try {
    do {
        # Display the menu
        Write-Host "`nPlease select an option:"
        Write-Host "1. List .log files in Requirements1 folder"
        Write-Host "2. List files in Requirements1 folder in alphabetical order"
        Write-Host "3. Show current CPU and memory usage"
        Write-Host "4. List running processes sorted by virtual size"
        Write-Host "5. Exit"

        # Prompt user input
        $choice = Read-Host "`nSelect your choice (1-5)"

        switch ($choice) {
            1 {
                # B1: Append .log file names to DailyLog.txt with timestamp, no overwrite
                $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                $logFiles = Get-ChildItem "." -Filter "*.log"

                Add-Content ".\DailyLog.txt" "`nLog Date: $timestamp"
                foreach ($file in $logFiles) {
                    Add-Content ".\DailyLog.txt" $file.Name
                }

                Write-Host "Log files listed and saved to DailyLog.txt"
            }

            2 {
                # B2: List files in alphabetical order and save in tabular format
                Get-ChildItem "." |
                    Sort-Object Name |
                    Format-Table Name -AutoSize |
                    Out-File ".\C916contents.txt" -Width 120

                Write-Host "Contents saved to C916contents.txt."
            }

            3 {
                # B3: Show current CPU and memory usage
                $cpuUsage = Get-CimInstance -Class Win32_Processor | Select-Object -ExpandProperty LoadPercentage
                $mem = Get-CimInstance Win32_OperatingSystem | Select-Object FreePhysicalMemory, TotalVisibleMemorySize

                Write-Host "CPU Load: $cpuUsage%"
                Write-Host "Free Physical Memory: $($mem.FreePhysicalMemory) KB"
                Write-Host "Total Memory: $($mem.TotalVisibleMemorySize) KB"
            }

            4 {
                # B4: List running processes sorted by virtual memory size in grid view
                Get-Process |
                    Sort-Object VM |
                    Select-Object Name, ID, VM |
                    Out-GridView -Title "Processes Sorted by Virtual Size"
            }

            5 {
                # B5: Exit the script
                Write-Host "Exiting script..."
                break
            }

            default {
                Write-Host "Invalid choice. Please select a number between 1-5"
            }
        }

    } while ($choice -ne "5")

} catch [System.OutOfMemoryException] {
    # D: Exception handling for memory errors
    Write-Host "OutOfMemoryException: Operation could not be completed due to memory limits."
}

# E: Take screenshots manually and save them in Requirements1 folder
# - CPU and Memory output (Option 3)
# - Running processes grid view (Option 4)

# F: Zip the Requirements1 folder and generate a hash
# Compress-Archive -Path "Requirements1" -DestinationPath "Requirements1.zip"
# Get-FileHash "Requirements1.zip"
