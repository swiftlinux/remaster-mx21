#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

PARAM1='taylorswift'
PARAM2='Taylor Swift Linux'

bash set-params.sh "$PARAM1" "$PARAM2"

mkdir -p log
TIME_STAMP_LOCAL=`date -u +%Y-%m%d-%H%M%S`
LOG_FILE="log/$PARAM1-$TIME_STAMP_LOCAL.txt"
bash remaster-local.sh 2>&1 | tee "$LOG_FILE"
