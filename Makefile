VERSION      := 2
LIBRARY_NAME := pam_watchid.so
DESTINATION  := /usr/local/lib/pam
TARGET       := x86_64-apple-macosx10.15

$(LIBRARY_NAME): watchid-pam-extension.swift
	swiftc $^ -o $@ -target $(TARGET) -emit-library

install: $(LIBRARY_NAME)
	mkdir -p $(DESTINATION)
	cp $(LIBRARY_NAME) $(DESTINATION)/$(LIBRARY_NAME).$(VERSION)
	chmod 444 $(DESTINATION)/$(LIBRARY_NAME).$(VERSION)
	chown root:wheel $(DESTINATION)/$(LIBRARY_NAME).$(VERSION)
	if ! grep -q pam_watchid.so /etc/pam.d/sudo; then awk '$$0 !~ /^#/ && !firstblood { firstblood=1; print "auth sufficient pam_watchid.so \"reason=execute a command as root\"" } $$0 ~ /^#/ || firstblood { print }' /etc/pam.d/sudo >/etc/pam.d/sudo.new; mv /etc/pam.d/sudo.new /etc/pam.d/sudo; fi

.PHONY: install
