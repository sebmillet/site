all: index.html

index.html: radios.md
	pandoc -s -t html -f markdown -o $@ $<

mrproper:
	rm -f index.html

