
from=
to=
file=

copy: 
	for file in $(files); do cp $$file save/$$file; done;

repl1: 
	$(top_builddir)/src/pcg -L$(top_srcdir)/lib -pinputFile=$(file) -poutputFile=$(file) -pinputString=$(from) -poutputString="$(to)"  $(top_srcdir)/examples/StringTranslator.pt

repl: 
	for file in $(files); do $(top_builddir)/src/pcg -L$(top_srcdir)/lib -pinputFile=$$file -poutputFile=$$file -pinputString=$(from) -poutputString="$(to)"  $(top_srcdir)/examples/StringTranslator.pt;  done

trans:
	for file in $(files); do $(top_builddir)/src/pcg -L$(top_srcdir)/lib -pinputFile=$$file -poutputFile=$$file -pxformFile="$(top_srcdir)/examples/xform1.pt" $(top_srcdir)/examples/TranslatorDriver.pt; done
