#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

PARAM1='generic'
PARAM2='Generic Swift Linux'

bash set-params.sh "$PARAM1" "$PARAM2"

mkdir -p log
LOG_FILE="log/find-strings-in-squashfs.txt"
bash exec-find-strings.sh 2>&1 | tee "$LOG_FILE"
