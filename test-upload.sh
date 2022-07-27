#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

TYPE='rsa'
FILENAME="id_rsa"
PATHNAME=~/.ssh/$FILENAME

if [ ! -f "$PATHNAME" ]
then
  echo 'STEP 1: generating SSH key'
  ssh-keygen -t "$TYPE" -N '' -C 'jhsu802701@shell.sf.net' <<<$'\ny\n\n'
  # ssh-keygen -t "$TYPE" -f "$PATHNAME" -N '' -C 'jhsu802701@shell.sf.net' -q
  # echo 'ssh-keyscan'
  # ssh-keyscan -H frs.sf.net >> ~/.ssh/known_hosts
  # echo 'ssh-copy-id'
  # ssh-copy-id -i "$PATHNAME" 'jhsu802701@shell.sourceforge.net'
else
  echo "Skipping SSH key generation (already present at $PATHNAME)"
fi

mkdir -p tmp1
TIME_STAMP=`date -u +%Y%m%d-%H%M%S`
echo "$TIME_STAMP" > tmp1/timestamp.txt

echo 'STEP 2: Go to https://sourceforge.net/auth/shell_services .'
echo "Copy the contents of $PATHNAME.pub to SSH Public Keys and"
echo 'click on "Save".'
echo 'Press Enter when finished.'
read

echo 'STEP 3: uploading tmp1/timestamp.txt'
rsync -avPz -e ssh "tmp1/timestamp.txt" jhsu802701@frs.sourceforge.net:/home/frs/p/swiftlinux/test-upload-manual/$MX_VERSION/
