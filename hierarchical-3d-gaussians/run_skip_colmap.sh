#!/bin/bash

echo "Starting preprocessing..."

# Preprocessing
echo "Running auto reorientation..."
python preprocess/auto_reorient.py --input_path ${DATASET_DIR}/camera_calibration/rectified/sparse --output_path ${DATASET_DIR}/camera_calibration/aligned/sparse/0

echo "Generating chunks..."
python preprocess/generate_chunks.py --project_dir ${DATASET_DIR}

echo "Generating depth..."
python preprocess/generate_depth.py --project_dir ${DATASET_DIR}

echo "Starting optimization..."

# Optimization
python scripts/full_train.py --project_dir ${DATASET_DIR}

echo "Process completed."