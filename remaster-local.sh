#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

GIT_BRANCH=`git rev-parse --abbrev-ref HEAD`

bin/welcome

sudo bin/provision-apt-get-update

if [ "$GIT_BRANCH" = 'main' ]; then
  sudo bin/provision-apt-get-upgrade
else
  echo 'Skipping apt-get upgrade (executed only in the main branch)'
fi

sudo bin/provision-apt-get-install

bin/download-iso

sudo bin/mount-iso

sudo bin/copy-iso

sudo bin/mount-compressed-fs

sudo bin/copy-squashfs

sudo bin/chroot-mounts

sudo bin/chroot-update

if [ "$GIT_BRANCH" = 'main' ]; then
  sudo bin/chroot-upgrade
  sudo bin/chroot-keepassxc
else
  echo 'Skipping chroot apt-get upgrade (executed only in the main branch)'
  echo 'Skipping chroot installation of KeePassXC (executed only in the main branch)'
fi

sudo bin/chroot-unmount

sudo bin/chroot-cleanup

sudo bin/edit-iso

sudo bin/make-squashfs

bin/make-iso
