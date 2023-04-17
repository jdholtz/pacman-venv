BIN := pacman-venv
DESTDIR :=
PKGNAME := pacman-venv
PREFIX := /usr/local

.PHONY: install
install:
	install -d -m 755 $(DESTDIR)$(PREFIX)/share/$(PKGNAME)/{activation,output,shims}
	install -m 755 src/$(BIN) $(DESTDIR)$(PREFIX)/share/$(PKGNAME)/$(BIN)
	install -m 644 src/activation/* $(DESTDIR)$(PREFIX)/share/$(PKGNAME)/activation/
	install -m 644 src/output/* $(DESTDIR)$(PREFIX)/share/$(PKGNAME)/output/
	install -m 755 src/shims/* $(DESTDIR)$(PREFIX)/share/$(PKGNAME)/shims/
	install -Dm 644 doc/$(PKGNAME).8 $(DESTDIR)$(PREFIX)/share/man/man8/$(PKGNAME).8
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	ln -s $(DESTDIR)$(PREFIX)/share/$(PKGNAME)/$(BIN) $(DESTDIR)$(PREFIX)/bin/$(BIN)

.PHONY: uninstall
uninstall:
	rm -rf $(DESTDIR)$(PREFIX)/share/$(PKGNAME)
	rm -f $(DESTDIR)$(PREFIX)/share/man/man8/$(PKGNAME).8
	rm -f $(DESTDIR)$(PREFIX)/bin/$(BIN)
