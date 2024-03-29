#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

DIR_MAIN="$PWD"

source "tmp-edition/definitions.sh"

QUOTE2='"'
STR64='_x64'

MX_VERSION=`cat $DIR_MAIN/parameters/MX-version.txt`

MX_DATE=`cat $DIR_MAIN/parameters/MX-date.txt`

MX_CODE_NAME=`cat $DIR_MAIN/parameters/MX-code-name.txt`

SWIFT_LETTER=`cat $DIR_MAIN/parameters/Swift-letter.txt`

MX_CONKY_1=`cat $DIR_MAIN/parameters/MX-conky-1.txt`

MX_CONKY_2=`cat $DIR_MAIN/parameters/MX-conky-2.txt`

SWIFT_VERSION="$MX_VERSION$SWIFT_LETTER"

DIR_ISO_INPUT="$DIR_MAIN/iso-downloaded"

CD_VIRTUAL="$DIR_ISO_INPUT/mx-linux-$MX_VERSION.iso"

SHA256_CD_VIRTUAL="$CD_VIRTUAL.sha256.txt"

DIR_REMASTER="$DIR_MAIN/remaster"

DIR_ISO_ORIG="$DIR_REMASTER/iso-orig"

DIR_ISO_NEW="$DIR_REMASTER/iso-$EDITION_SHORT"

if [ ! -f "$DIR_MAIN/tmp/timestamp.txt" ]
then
  TIME_STAMP=`date -u +%Y-%m%d-%H%M%S`
  mkdir -p "$DIR_MAIN/tmp"
  echo "$TIME_STAMP" > "$DIR_MAIN/tmp/timestamp.txt"
fi

TIME_STAMP=`cat tmp/timestamp.txt`

GIT_MAIN_BRANCH=''

if [ `git rev-parse --abbrev-ref HEAD` = 'main' ]; then
  GIT_MAIN_BRANCH='true'
fi

FILE_SQUASHFS_ORIG=''

if [ -f "$DIR_MAIN/tmp/path_squashfs.txt" ]
then
  FILE_SQUASHFS_ORIG=`cat $DIR_MAIN/tmp/path_squashfs.txt`
fi

DIR_SQUASHFS_ORIG="$DIR_REMASTER/squashfs-orig"

DIR_SQUASHFS_NEW="$DIR_REMASTER/squashfs-$EDITION_SHORT"

FILE_MX_LOGO_1A=`cat $DIR_MAIN/parameters/MX-logo-1A.txt` # Original location of MX Linux logo
FILE_MX_LOGO_1B=`cat $DIR_MAIN/parameters/MX-logo-1B.txt` # New location of MX Linux logo
FILE_MX_LOGO_2A=`cat $DIR_MAIN/parameters/MX-logo-2A.txt` # Original location of rounded MX Linux logo
FILE_MX_LOGO_2B=`cat $DIR_MAIN/parameters/MX-logo-2B.txt` # New location of rounded MX Linux logo

FILE_MX_WALLPAPER_DESKTOP_SHORT=`cat $DIR_MAIN/parameters/MX-wallpaper-desktop.txt` # Name of file used for Xfce background

DIR_ISO_OUTPUT="$DIR_MAIN/iso-output"

ISO_OUTPUT_SHORT="swiftlinux-$EDITION_SHORT-x64-$SWIFT_VERSION-$TIME_STAMP.iso"

ISO_OUTPUT_FULL="$DIR_ISO_OUTPUT/$ISO_OUTPUT_SHORT"

SHA256_ISO_OUTPUT_FULL="$ISO_OUTPUT_FULL.sha256.txt"
