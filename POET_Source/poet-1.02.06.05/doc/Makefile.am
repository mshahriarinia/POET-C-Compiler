EXTRA_DIST = manual.tex appendix.sty tutorial-compiler.tex

doc: manual.pdf tutorial-compiler.pdf

.tex.pdf : 
	pdflatex $<
	pdflatex $<

.tex.dvi : 
	latex $<

.dvi.ps :
	dvips -o $@ $<

clean :
	rm -f *.aux
	rm -f *.dvi
	rm -f *.idx	
	rm -f *.log
	rm -f *.out
	rm -f *.pdf
	rm -f *.ps
	rm -f *.toc
