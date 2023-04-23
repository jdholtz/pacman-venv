BIN := pacman-venv
DESTDIR :=
PKGNAME := pacman-venv
PREFIX := ${HOME}/.local

.PHONY: install
install:
	install -d -m 755 $(DESTDIR)$(PREFIX)/lib/$(PKGNAME)/{activation,output,shims}
	install -Dm 755 lib/$(PKGNAME)/$(BIN) $(DESTDIR)$(PREFIX)/bin/$(BIN)
	install -m 644 lib/$(PKGNAME)/activation/* -t $(DESTDIR)$(PREFIX)/lib/$(PKGNAME)/activation
	install -m 644 lib/$(PKGNAME)/output/* -t $(DESTDIR)$(PREFIX)/lib/$(PKGNAME)/output
	install -m 755 lib/$(PKGNAME)/shims/* -t $(DESTDIR)$(PREFIX)/lib/$(PKGNAME)/shims
	install -Dm 644 doc/$(PKGNAME).8 $(DESTDIR)$(PREFIX)/lib/man/man8/$(PKGNAME).8

.PHONY: uninstall
uninstall:
	rm -rf $(DESTDIR)$(PREFIX)/lib/$(PKGNAME)
	rm -f $(DESTDIR)$(PREFIX)/lib/man/man8/$(PKGNAME).8
	rm -f $(DESTDIR)$(PREFIX)/bin/$(BIN)
