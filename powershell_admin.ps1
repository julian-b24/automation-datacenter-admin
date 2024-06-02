function Display-FileSystems {
    gdr -PSProvider 'FileSystem' | 
    ft name, 
       @{n='Free (GB)'; e={[Math]::round($_.Free / 1GB, 2 )} },
       @{n='Size (MB)'; e={[Math]::round($_.Free + $_.Used, 2 )} }
}

function Print-Menu {
    Write-Output "1. Show the 5 processes that are consuming the most CPU"
    Write-Output "2. Display the connected filesystems and disks"
    Write-Output "3. Get the largest file in a filesystem or disk"
    Write-Output "4. Get empty memory space and percentage of used swap space"
    Write-Output "5. Get number of active network connections"
    Write-Output "9. Exit program"
}

function Execute-Operation {
    param (
        [int]$Operation
    )
    switch ($Operation) {
        1 {
            # Show the 5 processes that are consuming the most CPU
            Get-Process | sort CPU -Descending | select -First 5 | ft -Property Id, ProcessName, CPU -AutoSize
        }
        2 {
            Display-FileSystems
        }
        3 {
            Write-Output "3"
        }
        4 {
            Write-Output "4"
        }
        5 {
            Write-Output "5"
        }
        9 {
            Write-Output "Admin session finished successfully."
        }
        default {
            Write-Output "Not a valid option. Try again."
        }
    }
}

$option = 0
while ($option -ne 9) {
    Print-Menu
    $input = Read-Host "Enter your option"
    if ([int]::TryParse($input, [ref]$option)) {
        Execute-Operation -Operation $option
    } else {
        Write-Output "Not a valid option. Try again."
    }
}
