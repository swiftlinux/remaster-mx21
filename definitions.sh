#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

DIR_MAIN=$PWD

MX_VERSION=`cat $DIR_MAIN/parameters/MX-version.txt`

SWIFT_VERSION=`cat $DIR_MAIN/parameters/MX-version.txt`

DIR_ISO_INPUT=$DIR_MAIN/iso-downloaded

CD_VIRTUAL=$DIR_ISO_INPUT/linux.iso

DIR_REMASTER=$DIR_MAIN/remaster

DIR_ISO_ORIG=$DIR_REMASTER/iso-orig

DIR_ISO_NEW=$DIR_REMASTER/iso-new

if [ ! -f $DIR_MAIN/tmp/timestamp.txt ]
then
  TIME_STAMP=`date -u +%Y%m%d-%H%M%S`
  mkdir -p $DIR_MAIN/tmp
  echo "$TIME_STAMP" > $DIR_MAIN/tmp/timestamp.txt
fi

TIME_STAMP=`cat tmp/timestamp.txt`

# Get the name of the current branch
GIT_HEAD=`cat $DIR_MAIN/.git/HEAD`
STR_TO_REMOVE='ref: refs/heads/'
GIT_BRANCH_CURRENT=${GIT_HEAD#"$STR_TO_REMOVE"}

GIT_MAIN_BRANCH=''

if [ "$GIT_BRANCH_CURRENT" = 'main' ]; then
  GIT_MAIN_BRANCH='true'
fi

FILE_SQUASHFS_ORIG=''

if [ -f $DIR_MAIN/tmp/path_squashfs.txt ]
then
  FILE_SQUASHFS_ORIG=`cat $DIR_MAIN/tmp/path_squashfs.txt`
fi

DIR_SQUASHFS_ORIG=$DIR_REMASTER/squashfs-orig

DIR_SQUASHFS_NEW=$DIR_REMASTER/squashfs-new
