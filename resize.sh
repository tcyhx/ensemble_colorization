#!/usr/bin/env /bin/bash
#
# resize.sh
#
# Resizes the all the JPG images in the given directory to the required size
# for the recolorization CNN, 256x256.

# Exit the script on error or an undefined variable
set -e
set -u
set -o pipefail

# Program usage, number of parallel processes to spawn, and output image size
USAGE="./resize.sh <image_dir> <output_dir>"
NUM_JOBS=1024
IMAGE_SIZE=256x256

# Check that the number of command line arguments is valid
num_args=$#
if [ ${num_args} -ne 2 ]; then
    printf "Error: Improper number of command line arguments.\n"
    printf "${USAGE}\n"
    exit 1
fi

# Parse the command line arguments
image_dir=$1
output_dir=$2

# Make the output directory if it doesn't exist
if [ ! -e ${output_dir} ]; then
    mkdir ${output_dir}
fi

# Convert images in parallel, using as many processes as possible
find ${image_dir} -type f | parallel --dryrun -j ${NUM_JOBS} --progress \
    convert -resize ${IMAGE_SIZE}\! {} ${output_dir}/{/}
