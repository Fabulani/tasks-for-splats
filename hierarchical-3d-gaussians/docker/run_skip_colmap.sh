#!/bin/bash

# Execute the script only from inside the docker container (repo root)

echo -e "\n- Usage: ./run_all.sh <project_dir>"
echo -e "- See README.md for project structure.\n"

echo "Starting preprocessing on $1..."

# Preprocessing
echo "Running auto reorientation..."
python preprocess/auto_reorient.py --input_path $1/camera_calibration/rectified/sparse --output_path $1/camera_calibration/aligned/sparse/0

echo "Generating chunks..."
python preprocess/generate_chunks.py --project_dir $1

echo "Generating depth..."
python preprocess/generate_depth.py --project_dir $1

echo "Starting optimization..."

# Optimization
python scripts/full_train.py --project_dir $1

echo "Process completed."