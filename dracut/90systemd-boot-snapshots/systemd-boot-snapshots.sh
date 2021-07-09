#!/bin/sh

# shellcheck disable=SC2154
root_fstype="$fstype"
root_flags="$rflags"
root_mount="$NEWROOT"
root_device="${root#block:}"

systemd-boot-mount-snapshot-modules.sh "$root_device" "$root_mount" "$root_flags" "$root_fstype" > /dev/null
