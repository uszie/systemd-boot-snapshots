PKGNAME ?= systemd-boot-snapshots
PREFIX ?= /usr

SHARE_DIR = $(DESTDIR)/$(PREFIX)/share
SBIN_DIR = $(DESTDIR)/$(PREFIX)/sbin
LIB_DIR = $(DESTDIR)/$(PREFIX)/lib

.PHONY: build install uninstall help

build:

install:
	@install -Dm644 -t "$(DESTDIR)/etc/default/" systemd-boot-snapshots.conf
	@install -Dm755 -t "$(SBIN_DIR)/" update-systemd-boot-snapshots
	@install -Dm755 -t "$(LIB_DIR)/initramfs-tools/bin/" systemd-boot-mount-snapshot-modules
	@install -Dm755 -t "$(LIB_DIR)/initramfs-tools/bin/" systemd-boot-snapshots-notify
	@install -Dm755 -t "$(SHARE_DIR)/initramfs-tools/scripts/init-bottom/" initramfs-tools/scripts/init-bottom/systemd-boot-snapshots
	@install -Dm755 -t "$(SHARE_DIR)/initramfs-tools/hooks/" initramfs-tools/hooks/systemd-boot-snapshots
	@install -Dm755 -t "$(LIB_DIR)/dracut/modules.d/90systemd-boot-snapshots/" dracut/90systemd-boot-snapshots/*
	@install -Dm755 -T systemd-boot-mount-snapshot-modules "$(LIB_DIR)/dracut/modules.d/90systemd-boot-snapshots/systemd-boot-mount-snapshot-modules.sh"
	@install -Dm755 -t "$(LIB_DIR)/dracut/modules.d/90systemd-boot-snapshots/" systemd-boot-snapshots-notify
	@install -Dm644 -t "$(LIB_DIR)/systemd/system/" update-systemd-boot-snapshots.service
	@install -Dm644 -t "$(LIB_DIR)/systemd/system/" systemd-boot-entries.path
	@install -Dm644 -t "$(LIB_DIR)/systemd/system/" snapper-snapshots.path
	@install -Dm644 -t "$(LIB_DIR)/systemd/system/" timeshift-snapshots.path
	@install -Dm644 -t "$(SHARE_DIR)/doc/$(PKGNAME)/" LICENSE
	@install -Dm644 -t "$(SHARE_DIR)/doc/$(PKGNAME)/" README.md
	@systemctl daemon-reload
	@systemctl enable --now timeshift-snapshots.path snapper-snapshots.path systemd-boot-entries.path

uninstall:
	@systemctl disable --now timeshift-snapshots.path snapper-snapshots.path systemd-boot-entries.path
	@systemctl daemon-reload
	@rm -f  "$(DESTDIR)/etc/default/systemd-boot-snapshots.conf"
	@rm -f  "$(SBIN_DIR)/update-systemd-boot-snapshots"
	@rm -f  "$(LIB_DIR)/initramfs-tools/bin/systemd-boot-mount-snapshot-modules"
	@rm -f  "$(LIB_DIR)/initramfs-tools/bin/systemd-boot-snapshots-notify"
	@rm -f  "$(SHARE_DIR)/initramfs-tools/scripts/init-bottom/systemd-boot-snapshots"
	@rm -f  "$(SHARE_DIR)/initramfs-tools/hooks/systemd-boot-snapshots"
	@rm -rf "$(LIB_DIR)/dracut/modules.d/90systemd-boot-snapshots"
	@rm -f  "$(LIB_DIR)/systemd/system/update-systemd-boot-snapshots.service"
	@rm -f  "$(LIB_DIR)/systemd/system/systemd-boot-entries.path"
	@rm -f  "$(LIB_DIR)/systemd/system/snapper-snapshots.path"
	@rm -f  "$(LIB_DIR)/systemd/system/timeshift-snapshots.path"
	@rm -f  "$(SHARE_DIR)/doc/$(PKGNAME)/README.md"
	@rm -f  "$(SHARE_DIR)/doc/$(PKGNAME)/LICENSE"
	@rmdir --ignore-fail-on-non-empty "$(SHARE_DIR)/doc/$(PKGNAME)/" || :

help:
	@echo
	@echo "Usage: $(MAKE) [ <parameter>=<value> ... ] [ <action> ]"
	@echo
	@echo "  actions: install"
	@echo "           uninstall"
	@echo "           help"
	@echo
	@echo "  parameter | type | description                    | defaults"
	@echo "  ----------+------+--------------------------------+----------------------------"
	@echo "  DESTDIR   | path | install destination            | <unset>"
	@echo "  PREFIX    | path | system tree prefix             | '/usr'"
	@echo "  SHARE_DIR | path | shared data location           | '\$$(DESTDIR)\$$(PREFIX)/share'"
	@echo "  LIB_DIR   | path | system libraries location      | '\$$(DESTDIR)\$$(PREFIX)/lib'"
	@echo "  PKGNAME   | name | name of the ditributed package | 'systemd-boot-snapshots'"
	@echo
