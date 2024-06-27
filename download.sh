#!/bin/bash

# Base URL where files are located
BASE_URL="https://downloads.psl.noaa.gov/Datasets/ncep.reanalysis2/gaussian_grid/"

# Directory to save downloaded files
DOWNLOAD_DIR="./downloads/dados_temperatura"

# Create download directory if it doesn't exist
mkdir -p "$DOWNLOAD_DIR"

# Loop through the years from 1979 to 2024
for YEAR in {1979..2024}
do
  # Construct the file name and URL
  FILE_NAME="skt.sfc.gauss.${YEAR}.nc"
  FILE_URL="${BASE_URL}/${FILE_NAME}"

  # Download the file
  echo "Downloading ${FILE_NAME} from ${FILE_URL}..."
  wget -O "${DOWNLOAD_DIR}/${FILE_NAME}" "${FILE_URL}"

  # Check if download was successful
  if [ $? -eq 0 ]; then
    echo "Downloaded ${FILE_NAME} successfully."
  else
    echo "Failed to download ${FILE_NAME}."
  fi

done

echo "All downloads completed."

