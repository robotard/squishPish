#!/bin/bash

###########
#
# pibackup.sh
# Rob Hendricks
# February 2020
# Opensource license
#
###########
#
# This script has been created in order to allow you to:
#   1) select the drive you wish to backup normally mmcblk (SD Card)
#   2) decide whether to shrink the writiable partition (I would recommend doing this)
#   3) Use parted to shrink the partition (we'll leave the system-boot partition)
#   4) choose path to write our image out to
#   5) resize the shrunk partition either to:
#     i) original size
#     ii) fill the space of the drive
#
###########

main() 
{
    welcome
    local alldisks=$(getAllDisks)
    local selection=$(selectDisk)


}

welcome()
{
    echo -e "WELCOME TO PIBACKUP\n"
    echo -e "Please select the disk to backup from the available disks:\n "
}

getAllDisks()
{
    echo=($(lsblk | grep disk  | awk '{print $1}'))

}

selectDisk()
{
for ((i = 0; i < ${#alldisks[@]}; ++i)); do
    # bash alldiskss are 0-indexed
    #position=$(( $i + 1 ))
    echo "$(( $i + 1 )), ${alldisks[$i]}"
done

read -p "Type the number of your disk: " diskchoiceno
}



main "$@"