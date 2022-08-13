#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

mkdir -p tmp-edition
echo "EDITION_SHORT='EDITION_SHORT_1'" > tmp-edition/definitions.sh
echo "EDITION_LONG='EDITION_LONG_1'" >> tmp-edition/definitions.sh

bin/replace_sif 'EDITION_SHORT_1' "$EDITION_SHORT_CI" "tmp-edition/definitions.sh"
bin/replace_sif 'EDITION_LONG_1' "$EDITION_LONG_CI" "tmp-edition/definitions.sh"
