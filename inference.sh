#!/bin/bash

IMG_FOLDER="/data/images"
MODEL_FOLDER="/data/models"
MODEL="$(find /data/models -name '*_cpu.t7')"
TEMPERATURE=1 # default is 1
: ${GPU:=-1}

# get the command arguments
while [[ $# > 1 ]]
do
key="$1"

case $key in
    -image)
    IMG_PATH="$2"
    shift
    ;;
    -t|--temperature)
    TEMPERATURE="$2"
    shift
    ;;

    *)
esac

done
# move inputted file to image folder
mv $IMG_PATH $IMG_FOLDER

# main process thing
th /home/ubuntu/experiment/eval.lua \
    -model        $MODEL \
    -image_folder $IMG_FOLDER \
    -temperature  $TEMPERATURE \
    -num_images   -1 \
    -gpuid        $GPU

