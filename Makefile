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
	install -Dm 644 doc/$(PKGNAME).8 $(DESTDIR)$(PREFIX)/share/man/man8/$(PKGNAME).8
	install -Dm 644 completions/bash $(DESTDIR)$(PREFIX)/share/bash-completion/completions/$(PKGNAME)
	install -Dm 644 completions/zsh $(DESTDIR)$(PREFIX)/share/zsh/site-functions/_$(PKGNAME)
	install -Dm 644 completions/fish $(DESTDIR)$(PREFIX)/share/fish/vendor_completions.d/$(PKGNAME).fish

.PHONY: uninstall
uninstall:
	rm -rf $(DESTDIR)$(PREFIX)/lib/$(PKGNAME)
	rm -f $(DESTDIR)$(PREFIX)/bin/$(BIN)
	rm -f $(DESTDIR)$(PREFIX)/share/man/man8/$(PKGNAME).8
	rm -f $(DESTDIR)$(PREFIX)/share/bash-completion/completions/$(PKGNAME)
	rm -f $(DESTDIR)$(PREFIX)/share/zsh/site-functions/_$(PKGNAME)
	rm -f $(DESTDIR)$(PREFIX)/share/fish/vendor_completions.d/$(PKGNAME).fish

# Used to set the development version in pacman-venv-git
.PHONY: version
version:
	sed -i '/VERSION="v.*"$$/c\VERSION="v$(VERSION)"' $(DESTDIR)$(PREFIX)/bin/$(BIN)
