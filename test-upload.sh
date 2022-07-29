#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

TYPE='rsa'
FILENAME="id_$TYPE"
PATHNAME=~/.ssh/$FILENAME

if [ ! -f "$PATHNAME" ]
then
  # Use default path name for SSH key files.
  # Use no password for the SSH key files.
  # Piping in the newline character means automatically pressing enter.
  echo 'STEP 1: generating SSH key'
  ssh-keygen -t "$TYPE" -N '' -C 'jhsu802701@shell.sf.net' <<<$'\n'

  # No password needed to log in.
  echo 'STEP 2: ssh-keyscan'  
  ssh-keyscan -H frs.sourceforge.net >> ~/.ssh/known_hosts
else
  echo "Skipping SSH key generation (already present at $PATHNAME)"
fi

mkdir -p tmp1
TIME_STAMP=`date -u +%Y%m%d-%H%M%S`
echo "$TIME_STAMP" > tmp1/timestamp.txt

echo 'STEP 3: Go to https://sourceforge.net/auth/shell_services .'
echo "Copy the contents of $PATHNAME.pub to SSH Public Keys and"
echo 'click on "Save".'
echo 'Press Enter when finished.'
read

echo 'STEP 4: uploading tmp1/timestamp.txt'
rsync -avPz -e ssh "tmp1/timestamp.txt" jhsu802701@frs.sourceforge.net:/home/frs/p/swiftlinux/test-upload-manual/$MX_VERSION/

# The second iteration of this script should be fully automatic.
