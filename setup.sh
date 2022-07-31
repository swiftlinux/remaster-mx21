#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

# Creating the test file to upload
mkdir -p tmp0
TIME_STAMP=`date -u +%Y%m%d-%H%M%S`
echo "$TIME_STAMP" > tmp0/timestamp.txt

TYPE='ed25519'
FILENAME="id_$TYPE"
PATHNAME_PRIVATE="$HOME/.ssh/$FILENAME"
PATHNAME_PUBLIC="$PATHNAME_PRIVATE.pub"
PATHNAME_KNOWN_HOSTS="$HOME/.ssh/known_hosts"

# Use default path name for SSH key files.
# Use no password for the SSH key files.
# Piping in the newline character means automatically pressing enter.
echo 'STEP 1: generating the SSH key'
ssh-keygen -t "$TYPE" -N '' -f "$PATHNAME_PRIVATE" -C 'jhsu802701@shell.sf.net' <<<$'\n'

# No password needed to log in.
echo 'STEP 2: ssh-keyscan'  
ssh-keyscan -H frs.sourceforge.net >> "$HOME/.ssh/known_hosts"

echo 'STEP 3: Go to https://sourceforge.net/auth/shell_services .'
echo "Copy the contents of $PATHNAME_PUBLIC to SSH Public Keys and"
echo 'click on "Save".'
echo 'Press Enter when finished.'
read

echo ''
echo 'STEP 4: uploading tmp0/timestamp.txt'
rsync -avPz -e ssh "tmp0/timestamp.txt" jhsu802701@frs.sourceforge.net:/home/frs/p/swiftlinux/test-upload-manual/$MX_VERSION/

echo ''
echo "If all went well, the last step (uploading tmp0/timestamp.txt)"
echo 'proceeded without any input from you.'
echo ''
echo 'STEP 5: Configuring GitHub.'
echo '*  Go to this repository in GitHub.'
echo '   Go to Settings -> Secrets -> Actions'
echo '* Copy and paste the contents from your SSH files into the repository secrets.'
echo '   *  Add any required repository secrets that are not already present.'
echo '   *  For the repository secrets that are already present, you must update them.'
echo '   *  Use the chart below as a reference.'
echo ''
echo 'Repository Secret | File Contents'
echo '------------------|----------------------'
echo "SSH_KNOWN_HOSTS   | $PATHNAME_KNOWN_HOSTS"
echo '-----------------------------------------'
echo "SSH_PRIVATE_KEY   | $PATHNAME_PRIVATE"
echo '-----------------------------------------'
echo "SSH_PUBLIC_KEY    | $PATHNAME_PUBLIC"
echo '-----------------------------------------'
echo ''
echo 'STEP 6: Run the GitHub Workflow.  If all goes well, the initial test upload works,'
echo 'which means that you have completed the SSH configuration.'
echo ''
