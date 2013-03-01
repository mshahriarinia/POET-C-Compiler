debug=
comp=diff

files=gen_searchInfo.pt auto_poet.code search_spec_pseat.code search_spec.code

EXTRA_DIST= $(files)  dgemm_test.tune_save dger.tune_save dgemvT.pseat_save dgetrf.tune_save dgemvT.tune_save

PCG=${top_builddir}/src/pcg
PFLAGS=$(debug) -L$(top_srcdir)/lib -L$(srcdir)

target=

all: 

tune: 
	$(PCG) $(PFLAGS) -pinputFile=$(top_srcdir)/test/autoScripts/$(target).pt -poutputFile=$(target).tune $(srcdir)/gen_searchInfo.pt

check: 
	make tune target=dgemm_test
	$(comp) dgemm_test.tune $(srcdir)/dgemm_test.tune_save	
	rm dgemm_test.tune
	make tune target=dger
	$(comp) dger.tune $(srcdir)/dger.tune_save	
	rm dger.tune
	make tune target=dgemvT
	$(comp) dgemvT.tune $(srcdir)/dgemvT.tune_save	
	rm dgemvT.tune
	make tune target=dgetrf
	$(comp) dgetrf.tune $(srcdir)/dgetrf.tune_save	
	rm dgetrf.tune
	make pseat
	$(comp) dgemvT.pseat $(srcdir)/dgemvT.pseat_save
	rm dgemvT.pseat

pseat:
	$(PCG) $(PFLAGS) -pinputFile=$(top_srcdir)/test/autoScripts/dgemvT.pt  -poutputFile=dgemvT.pseat -poutputSyntax=search_spec_pseat.code $(srcdir)/gen_searchInfo.pt

include ../../Make.inc
