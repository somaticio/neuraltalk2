#!/bin/bash

IMG_FOLDER="/data/input"
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
    shift
    ;;
    --model_folder)
    MODEL_FOLDER="$2"
    shift
    ;;

    *)
esac

done

# set which trained model to use
if [ $GPU = -1 ]; then
    MODEL="$(find $MODEL_FOLDER -name '*.t7_cpu.t7')"
else
    MODEL="$(find $MODEL_FOLDER -not -name '*.t7_cpu.t7' -type f)"
fi

cd /home/ubuntu/experiment
# main image processing
/home/ubuntu/torch/install/bin/th /home/ubuntu/experiment/eval.lua \
    -model        $MODEL \
    -image_folder $IMG_FOLDER \
    -temperature  $TEMPERATURE \
    -num_images   -1 \
    -gpuid        $GPU

OUTPUT="$(date +%s)"

jq --raw-output .[].caption /home/ubuntu/experiment/vis/vis.json > /home/ubuntu/$OUTPUT.txt
# cleanup for next image upload
rm /home/ubuntu/experiment/vis/vis.json
rm /data/input/*

cat /home/ubuntu/$OUTPUT.txt
echo /home/ubuntu/$OUTPUT.txt
