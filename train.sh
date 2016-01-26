#!/bin/bash

INPUT_JSON='testtraining/raw.json'
IMAGES_ROOT='testimages/'
NUM_VAL=5000
NUM_TEST=5000
CHECKPOINT_PATH='checkpoints'

# check if training model is present
# if not, download it
if [ ! -e model/VGG_ILSVRC_16_layers.caffemodel ]; then
    mkdir -p model
    axel -n 12 -o model/ http://www.robots.ox.ac.uk/~vgg/software/very_deep/caffe/VGG_ILSVRC_16_layers.caffemodel
fi

# get arguments from command line
while [[ $# > 1 ]]
do
key="$1"

case $key in
    -r|--input)
    INPUT="$2"
    shift # past argument
    ;;
    -j|--input_json)
    INPUT_JSON="$2"
    shift # past argument
    ;;
    -i|--images_root)
    IMAGES_ROOT="$2"
    shift # past argument
    ;;
    -v|--num_val)
    NUM_VAL="$2"
    shift # past argument
    ;;
    -t|--num_test)
    NUM_TEST="$2"
    shift # past argument
    ;;
    -c|--checkpoint_path)
    CHECKPOINT_PATH="$2"
    shift # past argument
    ;;
    -g|--gpuid)
    GPUID="$2"
    shift # past argument
    ;;
    *)

    ;;
esac
shift # past argument or value
done

if [ ! -z $INPUT ]; then
    INPUT_JSON="$INPUT/coco_raw.json"
    IMAGES_ROOT="$INPUT"
fi

NEW_JSON='testtraining/output.json'
NEW_H5='testtraining/output.h5'

# first we must preprocess raw json file of images/captions
# creates an hd5 and json
/usr/bin/python /home/ubuntu/experiment/prepro.py \
    --input_json $INPUT_JSON \
    --num_val $NUM_VAL \
    --num_test $NUM_TEST \
    --images_root $IMAGES_ROOT \
    --word_count_threshold 5 \
    --output_h5 $NEW_H5 \
    --output_json $NEW_JSON
# look at bottom of prepro.py for all options

echo 'before torch training'
# now actually train on the newly created json and h5 files
/home/ubuntu/torch/install/bin/th train.lua  \
    -input_h5 $NEW_H5 \
    -input_json $NEW_JSON \
    -gpuid $GPUID \
    -checkpoint_path $CHECKPOINT_PATH
# look inside train.lua for all options
# TODO: figure out how to easily pass all available parameters
# to the two above scripts
