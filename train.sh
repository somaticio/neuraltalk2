#!/bin/bash

INPUT_JSON='testtraining/raw.json'
IMAGES_ROOT='testimages/'
NUM_VAL=20
CHECKPOINT_PATH='checkpoints'

# check if training model is present
# if not, download it
if [ ! -a model/VGG_ILSVRC_16_layers.caffemodel ]; then
    mkdir -p model
    wget http://www.robots.ox.ac.uk/~vgg/software/very_deep/caffe/VGG_ILSVRC_16_layers.caffemodel -P model
fi

# get arguments from command line
while [[ $# > 1 ]]
do
key="$1"

case $key in
    -j|--input_json)
    INPUT_JSON="$2"
    shift # past argument
    ;;
    -i|--images_root)
    IMAGES_ROOT="$2"
    shift # past argument
    ;;
    -n|--num_val)
    NUM_VAL="$2"
    shift # past argument
    ;;
    -c|--checkpoint_path)
    CHECKPOINT_PATH="$2"
    shift # past argument
    ;;
    *)

    ;;
esac
shift # past argument or value
done

NEW_JSON='testtraining/output.json'
NEW_H5='testtraining/output.h5'

# first we must preprocess raw json file of images/captions
# creates an hd5 and json
/usr/bin/python /home/ubuntu/experiment/prepro.py \
    --input_json $INPUT_JSON \
    --num_val $NUM_VAL \
    --images_root $IMAGES_ROOT \
    --word_count_threshold 5 \
    --output_h5 $NEW_H5 \
    --output_json $NEW_JSON
# look at bottom of prepro.py for all options

# now actually train on the newly created json and h5 files
/home/ubuntu/torch/install/bin/th /home/ubuntu/experiment/train.lua  \
    -input_h5 $NEW_H5 \
    -input_json $NEW_JSON \
    -checkpoint_path $CHECKPOINT_PATH
# look inside train.lua for all options
# TODO: figure out how to easily pass all available parameters
# to the two above scripts
