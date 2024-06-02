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
            Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 | Format-Table -Property Id, ProcessName, CPU -AutoSize
        }
        2 {
            Display-FileSystems
        }
        3 {
            # Get the largest file in a filesystem or disk
            $path = Read-Host "Enter the path to the filesystem or disk"
            Write-Output "Path entered: $path"
            try {
                $largestFile = Get-ChildItem -Path $path -Recurse | Sort-Object -Property Length -Descending | Select-Object -First 1
                if ($largestFile) {
                    Write-Output "The largest file is: $($largestFile.FullName) with size $($largestFile.Length) bytes"
                } else {
                    Write-Output "No files found in the specified path."
                }
            } catch {
                Write-Output "An error occurred: $_"
            }
        }
        4 {
            # Obtener información de memoria y espacio de intercambio
            $memoria = Get-WmiObject Win32_OperatingSystem
            $memoriaTotal = $memoria.TotalVisibleMemorySize
            $memoriaLibre = $memoria.FreePhysicalMemory
            $memoriaSwapTotal = $memoria.TotalSwapSpaceSize
            $memoriaSwapLibre = $memoria.FreeSpaceInPagingFiles

            # Calcular porcentaje de memoria utilizada y de espacio de intercambio utilizado
            $porcentajeMemoriaUsada = ($memoriaTotal - $memoriaLibre) / $memoriaTotal * 100
            $porcentajeSwapUsado = ($memoriaSwapTotal - $memoriaSwapLibre) / $memoriaSwapTotal * 100

            # Mostrar resultados
            Write-Host "Free Space:: $memoriaLibre bytes"
            Write-Host "Percentage of used memory: $porcentajeMemoriaUsada%"
            Write-Host "Used swap memory: $memoriaSwapLibre bytes"
            Write-Host "Used swap percentage: $porcentajeSwapUsado%"
        }
        5 {
            # Obtener el número de conexiones de red activas en estado ESTABLISHED
            $establecidas = (Get-NetTCPConnection | Where-Object {$_.State -eq "Established"}).Count

            # Mostrar el resultado
            Write-Host "Number of active connections ESTABLISHED: $establecidas"

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
