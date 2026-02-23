#!/bin/bash
set -e

CODEMETA_FILE="${1:-codemeta.json}"
OVERWRITE="${2:-false}"
ZENODO_FILE=".zenodo.json"

echo "::group::CodeMeta to Zenodo Converter"
echo "Input file: ${CODEMETA_FILE}"
echo "Overwrite: ${OVERWRITE}"
echo "::endgroup::"

# Check if input file exists
if [ ! -f "${CODEMETA_FILE}" ]; then
    echo "::error::Input file '${CODEMETA_FILE}' not found!"
    exit 1
fi

# Check if output file exists and overwrite is not enabled
if [ -f "${ZENODO_FILE}" ] && [ "${OVERWRITE}" != "true" ]; then
    echo "::error::Output file '${ZENODO_FILE}' already exists! Set 'overwrite: true' to replace it."
    exit 1
fi

# Run the conversion
echo "::group::Running eossr-codemeta2zenodo"
if [ "${OVERWRITE}" = "true" ]; then
    eossr-codemeta2zenodo --input_codemeta_file "${CODEMETA_FILE}" --overwrite
else
    eossr-codemeta2zenodo --input_codemeta_file "${CODEMETA_FILE}"
fi
echo "::endgroup::"

# Check if conversion was successful
if [ ! -f "${ZENODO_FILE}" ]; then
    echo "::error::Conversion failed! ${ZENODO_FILE} was not created."
    exit 1
fi

echo "::notice::Successfully converted ${CODEMETA_FILE} to ${ZENODO_FILE}"
