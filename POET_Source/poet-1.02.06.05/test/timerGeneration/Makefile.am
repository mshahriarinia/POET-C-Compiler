
files=timerGeneration.pt timerGeneration.incl specification.code timerCodeTemplates.code

EXTRA_DIST=$(files) gemm.spec gemm1.spec gemv.spec ger.spec gemm_timer_1_1_Pentium.c gemm_timer_1_1_generic.c gemm_timer_1_1_x86.c gemm_timer_10_1_generic.c gemm_timer_10_500_generic.c gemv_timer_1_100_generic.c ger_timer_5_100_generic.c

FLUSHMETHOD=generic
FLUSHSZ=4098
arch=generic
mhz=2160
mt=10
nrep=500
UseWallTime=1
debug=
comp=diff


input=gemm
WF=GetCycleCount.S

all : 

check:

	make timer_c input=gemm1 mt=1 nrep=1 arch="Pentium"
	$(comp) gemm1_timer.c $(srcdir)/gemm_timer_1_1_Pentium.c
	rm gemm1_timer.c
	make timer_c input=gemm1 mt=1 nrep=1 arch="generic"
	$(comp) gemm1_timer.c $(srcdir)/gemm_timer_1_1_generic.c
	rm gemm1_timer.c
	make timer_c input=gemm1 mt=1 nrep=1 arch="x86"
	$(comp) gemm1_timer.c $(srcdir)/gemm_timer_1_1_x86.c
	rm gemm1_timer.c
	rm GetCycleCount.S
	make timer_c input=gemm1 mt=10 nrep=1 
	$(comp) gemm1_timer.c $(srcdir)/gemm_timer_10_1_generic.c
	rm gemm1_timer.c
	make timer_c input=gemm mt=10 nrep=500 
	$(comp) gemm_timer.c $(srcdir)/gemm_timer_10_500_generic.c
	rm gemm_timer.c
	make timer_c input=gemv mt=1 nrep=100 arch="generic"
	$(comp) gemv_timer.c $(srcdir)/gemv_timer_1_100_generic.c
	rm gemv_timer.c
	make timer_c input=ger mt=5 nrep=100 arch="generic"
	$(comp) ger_timer.c $(srcdir)/ger_timer_5_100_generic.c
	rm ger_timer.c


timer_gemm :
	$(CC) -O -o $@ gemm_timer.c dgemm_kernel.c 

timer_gemv :
	$(CC) -O -o $@ gemv_timer.c dgemv_kernel.c -DBETAX

#makes the timer source from the input specification

timer_c:
	$(top_builddir)/src/pcg -L$(top_srcdir)/lib -L$(srcdir) $(debug) -md -pCacheFlushMethod=$(FLUSHMETHOD) -pCacheKB=$(FLUSHSZ) -pISA=$(arch) -pMHZ=$(mhz) -pNREP=$(nrep) -pUseWallTime=$(UseWallTime) -pMT=$(mt) -pinputFile=$(srcdir)/$(input).spec -poutputFile=$(input)_timer.c -poutputLang="Cfront.code" $(srcdir)/timerGeneration.pt 


clean:
	rm -rfv *.o *.S *~ *_timer.c 

include ../../Make.inc
