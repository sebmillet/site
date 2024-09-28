# Makefile

all: index.html
	(cd radios; make)

index.html: index.rst
	rst2html $< > $@

mrproper:
	rm -f index.html
	(cd radios; make mrproper)

