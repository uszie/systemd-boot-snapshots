#!/bin/bash

check() {
    return 0
}

depends() {
    # We do not depend on any modules - just some root
    return 0
}

# called by dracut
installkernel() {
    return 0
}

install() {
    # shellcheck disable=SC2154
    inst_hook pre-pivot 90 "$moddir/systemd-boot-snapshots.sh"
    inst_script "$moddir/systemd-boot-mount-snapshot-modules.sh" /sbin/systemd-boot-mount-snapshot-modules.sh
    inst_script "$moddir/systemd-boot-snapshots-notify" /sbin/systemd-boot-snapshots-notify
}
