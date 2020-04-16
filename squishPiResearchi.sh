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


echo -e "WELCOME TO PIBACKUP\n"
echo -e "Please select the disk to backup from the available disks:\n "

#Grab all disk names
alldisks=($(lsblk | grep disk  | awk '{print $1}'))
# ${#alldisks[@]} is the number of elements in the alldisks
for ((i = 0; i < ${#alldisks[@]}; ++i)); do
    # bash alldiskss are 0-indexed
    #position=$(( $i + 1 ))
    echo "$(( $i + 1 )), ${alldisks[$i]}"
done

read -p "Type the number of your disk: " diskchoiceno

# while ! [[ "$diskchoiceno"=~"^[0-9]+$" ]]  # && [[ "$diskchoiceno" < 0 || ! "$diskchoiceno" < ${#alldisks[@]} ]]
# do
#    echo "BROKE"
#    read -p "Type the number of your disk: " diskchoiceno
#    echo "$diskchoiceno"
# done

#echo "WORKED"

#Yea standard array shit... General debuggery...
((diskchoiceno -=1 )) # $((diskchoiceno -1))
echo 

diskchoice="${alldisks[$diskchoiceno]}"
echo "diskchoice = $diskchoice"
echo
#Grab all disk names

#DISPLAYING STUFF LATER - Haha, not even here yet... 
#headersArray=("NAME" "LABEL" "PATH" "MOUNTPOINT")

#WE'RE GONNA BUILD SOME IMPORTANT ARRAYS HERE
allpartitions=($(lsblk | grep "$diskchoice" | awk '{print $1}'))

echo "The disk $diskchoice contains the following partitions:"

# ${#alldisks[@]} is the number of elements in the alldisks
#declare -A thedrive=${allpartitions[0]}

#We are fudging this... 0 element in array for this is entire disk... (t gives shitty characters to look nice for displasy after for what we need "|-"   
# Skip 0 from array and make our names kinda sensible ... 
for ((i = 1; i < ${#allpartitions[@]}; ++i)); do
    #We've trimmed off the first 2 characters, bnecause they look silly in our usage, and don't need it
    echo "${allpartitions[$i]:2}"
done

echo

for ((i = 1; i < ${#allpartitions[@]}; ++i)); do
    #We've trimmed off the first 2 characters, bnecause they look silly in our usage, and don't need it
    currentpartition="${allpartitions[$i]:2}"

    echo "CURRENT PARTITION $currentpartition"
    echo
    pName="$currentpartition"
    #Showing current partition as pName variable
    echo "pName $pName" 
    pLabel="$(lsblk -o NAME,LABEL,PATH,MOUNTPOINT | grep $currentpartition | awk ' { print $2}')"
    #Showing the partition name that we see as the mounted name
    echo "pLabel $pLabel"

    pPath="$(lsblk -o NAME,LABEL,PATH,MOUNTPOINT | grep $currentpartition | awk ' { print $3}')"
    echo "pPath $pPath"

    pMount="$(lsblk -o NAME,LABEL,PATH,MOUNTPOINT | grep $currentpartition | awk ' { print $4}')"
    echo "pMount $pMount"
    echo
    echo "pName -> pLabel"
    echo "$pName -> $pLabel"
    echo

    #pAllInfo="$(lsblk -o NAME,LABEL,PATH,MOUNTPOINT | grep $currentpartition| awk '{ print $1 " " print $2 }')"
    #pAllInfo="$(lsblk -o NAME,LABEL,PATH,MOUNTPOINT | grep $currentpartition| awk '{ print $1; print $2; print $3; print $4; }')"
    echo "pAllInfo $pAllInfo"

    #Hmmm, we're gonna wanna add more info to the end of this line from parted to figure what to resize later... We need to figure these assoiative/dynamic arrays............,
    thedrive[currentpartition]="$(lsblk -o NAME,LABEL,PATH,MOUNTPOINT | grep $currentpartition| awk '{ print $1; print $2; print $3; print $4; }')"

    # eval "declare -a ${currentpartition}"
  #allpartitions=($(lsblk -o NAME,LABEL,PATH,MOUNTPOINT | grep $currentpartition | awk '{ print $1:2 " " $2 " " $3 " " $4 }'))
  #declare -a "$currentpartition=(test tester testest)" 
  #declare -n curArrayFolder=arrayFolder$var1
  #($(lsblk -o NAME,LABEL,PATH,MOUNTPOINT | grep $currentpartition | awk '{ print $1:2 " " $2 " " $3 " " $4 }')))
  
  #eval echo $currentpartition - ${thedrive[currentpartition]}
  #echo df --block-size=1 | grep ${thedrive[currentpartition]}
    #What we'll do here is start to concatenate some useful information on our partitionms
done