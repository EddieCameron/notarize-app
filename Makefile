PACKAGE_TARNAME = notarize-app

prefix = /usr/local
exec_prefix = ${prefix}
bindir = ${exec_prefix}/bin
datarootdir = ${prefix}/share
datadir = ${datarootdir}
libdir = ${prefix}/lib

INSTALL = install
INSTALL_PROGRAM = $(INSTALL)

.PHONY: install uninstall

install: notarize-app
	$(INSTALL) -d $(DESTDIR)$(bindir)
	$(INSTALL_PROGRAM) $(PACKAGE_TARNAME) $(DESTDIR)$(bindir)/$(PACKAGE_TARNAME)
	$(INSTALL) -d $(DESTDIR)$(datadir)/$(PACKAGE_TARNAME)
	cp -R support $(DESTDIR)$(datadir)/$(PACKAGE_TARNAME)
	$(INSTALL) -d $(DESTDIR)$(libdir)/$(PACKAGE_TARNAME)
	cp -R lib/create-dmg $(DESTDIR)$(libdir)/$(PACKAGE_TARNAME)

uninstall:
	rm -f $(DESTDIR)$(bindir)/$(PACKAGE_TARNAME)
	rm -rf $(DESTDIR)$(datadir)/$(PACKAGE_TARNAME)
	rm -rf $(DESTDIR)$(libdir)/$(PACKAGE_TARNAME)