PREFIX ?= /usr/local

install:
	install -Dm755 lfv $(DESTDIR)$(PREFIX)/bin/lfv
	install -Dm755 previewer $(DESTDIR)$(PREFIX)/share/lfv/previewer
	install -Dm755 cleaner $(DESTDIR)$(PREFIX)/share/lfv/cleaner

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/lfv
	rm -rf $(DESTDIR)$(PREFIX)/share/lfv

.PHONY: install uninstall
