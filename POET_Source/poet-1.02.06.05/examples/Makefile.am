
POET_LIB=$(top_srcdir)/lib
pcg = ${top_builddir}/src/pcg
debug=
inputfile=
outputfile=
comp=diff


files = IdentityTranslator.pt StringTranslator.pt C2C.pt C2F.pt Parse.pt CFG.pt BNFexp.code applyopt.pt

EXTRA_DIST = $(files) dgemm_orig.c gemm1.pt gemm2.pt dgemm.f.save gemm-orig.pt parse.out av1.input exp.input poet_mgrid.f.save cfg.out


all:  


check :
	$(pcg) $(debug) -L$(POET_LIB) -pinputFile="$(srcdir)/av1.input" -pinputLang="$(srcdir)/AVstack.code" -poutputFile="av1.output" -poutputLang="$(srcdir)/AVstack.code" $(srcdir)/IdentityTranslator.pt 
	$(comp) av1.output $(srcdir)/av1.input
	rm av1.output
	$(pcg) $(debug) -L$(POET_LIB) -pinputFile="$(srcdir)/gemm-orig.pt" -poutputFile="gemm.pt" $(srcdir)/IdentityTranslator.pt 
	$(comp) gemm.pt $(srcdir)/gemm-orig.pt
	rm gemm.pt
	$(pcg) $(debug) -L$(POET_LIB) -pinputFile="$(srcdir)/gemm-orig.pt" -poutputFile="gemm.pt" -pinputString="(car cdr)" -poutputString="(HEAD TAIL)" $(srcdir)/StringTranslator.pt 
	$(comp) gemm.pt $(srcdir)/gemm1.pt
	rm gemm.pt
	$(pcg) $(debug) -L$(POET_LIB) -pinputFile="$(srcdir)/dgemm_orig.c" -poutputFile="dgemm.c" $(srcdir)/C2C.pt
	$(comp) dgemm.c $(srcdir)/dgemm_orig.c
	rm dgemm.c
	$(pcg) $(debug) -L$(POET_LIB) -pinputFile="$(srcdir)/dgemm_orig.c" -poutputFile="dgemm.f" $(srcdir)/C2F.pt 
	$(comp) dgemm.f $(srcdir)/dgemm.f.save
	rm dgemm.f
	make parseExp inputfile="$(srcdir)/exp.input" outputfile=out
	$(comp) out $(srcdir)/parse.out
	rm out
	make analysis outputfile=out
	$(comp) out $(srcdir)/cfg.out
	rm out
	make gridopt
	rm poet_mgrid.f

gridopt:
	$(pcg) $(debug) -L$(POET_LIB) -pinputFile=$(top_srcdir)/test/parseF/mgrid.f  -poutputFile=poet_mgrid.f $(srcdir)/applyopt.pt
	diff poet_mgrid.f $(srcdir)/poet_mgrid.f.save

C2F: 
	$(pcg) $(debug) -L$(POET_LIB) -pinputFile=$(inputfile) -poutputFile=$(outputfile) $(srcdir)/C2F.pt


analysis:
	$(pcg) $(debug) -L$(POET_LIB) -pinputFile="$(srcdir)/dgemm_orig.c" -pinputLang="Cfront.code" -poutputFile=$(outputfile) $(srcdir)/CFG.pt

parseExp:
	$(pcg) $(debug) -L$(POET_LIB) -L$(srcdir) -pinputFile=$(inputfile) $(debug) -poutputFile=$(outputfile) $(srcdir)/Parse.pt

include ../Make.inc
