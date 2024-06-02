#!/bin/bash

get_consumming_processes () {
    ps aux --sort %cpu | head -6
}

get_largest_file () {
    read -p "Ingrese el path del disco o filesystem: " path
    find "$path" -type f -exec ls -s {} + | sort -n -r | head -n 1
}


print_menu () {
    clear
    echo "1. Show the 5 processes that are consuming the most CPU"
    echo "2. Display the connected filesystems and disks"
    echo "3. Get the largest file in a filesystem or disk"
    echo "4. Get empty memory space and percentage of used swap space"
    echo "5. Get number of active network connections"
    echo "9. Exit program"
}

execute_operation () {
    #$1 is the operation to perform. Int, possible values 1,2,3,4,5,9
    (( operation = $1 ))
    case $operation in
        1)  get_consumming_processes;;
        2)  echo "2";;
        3)  get_largest_file;;
        4)  echo "4";;
        5)  echo "5";;
        9)  echo "Admin session finished successfully.";;
        *)  echo "Not a valid option. Try again.";;
    esac
	read -p "Presione cualquier tecla para continuar..." -n1 -s
}

(( option=0 ))
while (( $option!=9 ))
do
    print_menu
    read option
    execute_operation option
done
