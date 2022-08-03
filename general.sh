#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

mkdir -p log

rm -rf tmp

sudo rm -rf remaster

TIME_STAMP=`date -u +%Y%m%d-%H%M%S`

LOG_GENERAL="log/general-$TIME_STAMP.txt"
bash exec-general.sh 2>&1 | tee "$LOG_GENERAL"
