MAIN=presentation.tex

all: compile

.PHONY: all compile force cleanmk clean

compile:
	latexmk --shell-escape -file-line-error -pdflua ${MAIN}

force: cleanmk minted compile

# Add custom lexers like:
# sha256sum LEXER.py | awk '{print "\"LEXER.py\": \"" $$1  "\","}' >> .latexminted_config
minted:
	echo '{"custom_lexers": {' > .latexminted_config
	echo "}}" >> .latexminted_config

cleanmk:
	latexmk -C

clean: cleanmk
	rm -rf _minted/
	rm -f *.nav *.snm *.vrb **.aux *.bbl* *.lol *.xmpdata pdfa.xmpi
