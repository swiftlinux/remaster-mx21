#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

source definitions.sh

sudo bin/provision
bin/download-iso
sudo bin/mount-iso
sudo bin/copy-iso
sudo bin/mount-compressed-fs
sudo bin/copy-squashfs
sudo bin/chroot-mounts
sudo bin/chroot-update
sudo bin/chroot-upgrade
sudo bin/chroot-keepassxc
sudo bin/chroot-unmount
sudo bin/chroot-cleanup
