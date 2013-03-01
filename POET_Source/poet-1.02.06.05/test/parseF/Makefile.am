
POET_LIB=$(top_srcdir)/lib
pcg = ${top_builddir}/src/pcg
debug=
input=
output=
syntax=$(srcdir)/parseF.pt
comp=diff


files = parseF.pt
EXTRA_DIST = $(files) erlebacher.f poet_erle.f.save poet_erle.out.save \
               swim.f poet_swim.f.save \
               tomcatv.f poet_tomcatv.f.save poet_tomcatv.out.save \
               mgrid.f poet_mgrid.f.save 


all:  


now:


parse:
	$(pcg) $(debug) -L$(POET_LIB) -pinputFile="$(input)" -poutputFile="$(output)" "$(syntax)"

check:
	make parse input=$(srcdir)/erlebacher.f  output=poet_erle.f 2>& 1 | sed '/make/d; /reading/d; /Reading/d; /pcg/d' > out
	$(comp) poet_erle.f $(srcdir)/poet_erle.f.save
	$(comp) out $(srcdir)/poet_erle.out.save
	rm poet_erle.f
	rm out
	make parse input=$(srcdir)/tomcatv.f  output=poet_tomcatv.f 2>& 1 | sed '/make/d; /reading/d; /Reading/d; /pcg/d' > out
	$(comp) poet_tomcatv.f $(srcdir)/poet_tomcatv.f.save
	$(comp) out $(srcdir)/poet_tomcatv.out.save
	rm poet_tomcatv.f
	rm out
	make parse input=$(srcdir)/mgrid.f  output=poet_mgrid.f 2>& 1 | sed '/make/d; /reading/d; /Reading/d; /pcg/d' > out
	$(comp) poet_mgrid.f $(srcdir)/poet_mgrid.f.save
	rm poet_mgrid.f
	make parse input=$(srcdir)/swim.f  output=poet_swim.f 2>&1 | sed '/make/d; /reading/d; /Reading/d; /pcg/d' > out
	$(comp) poet_swim.f $(srcdir)/poet_swim.f.save
	rm poet_swim.f
	rm out

include ../../Make.inc
