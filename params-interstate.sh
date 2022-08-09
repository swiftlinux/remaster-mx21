#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

source definitions.sh

EDITION_SHORT_NAME='interstate'
EDITION_LONG_NAME='Interstate Swift Linux'

if [ ! -f $DIR_MAIN/tmp/edition-short-name.txt ]
then
  echo "$EDITION_SHORT_NAME" > $DIR_MAIN/tmp/edition-short-name.txt
fi

if [ ! -f $DIR_MAIN/tmp/edition-long-name.txt ]
then
  echo "$EDITION_LONG_NAME" > $DIR_MAIN/tmp/edition-long-name.txt
fi