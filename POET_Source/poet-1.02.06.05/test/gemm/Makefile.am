alpha=0
beta = 1
orig=0
mb=60
nb=60
kb=60
cpA=1
cpB=1
rdC=1
kernel=0
threeAddress=1
mu=12
nu=1
ku=$(kb)
PF=1
SP=1
SSENO=16
SSELEN=16
pre="d"
debug=
permute1=(1,2,3,4)
permute2=(1,2)
POET_LIB=$(top_srcdir)/lib
cleanup=0
cleanupUnroll=1
comp=diff

min=60
max=1800
incr=120

files=gemm_block.pt
EXTRA_DIST= $(files) dgemm.c.save dgemm_k_c_noAsm.c.save dgemm_k-mb50.c.save dgemm_k-nb50.c.save dgemm_c.c.save dgemm_k_c.c.save

all: 

block:
	${top_builddir}/src/pcg ${debug} -L${POET_LIB} -L$(srcdir)/../gemmATLAS -pMB=$(mb) -pNB=$(nb) -pKB=$(kb) -porig=${orig} -pcpA=$(cpA) -pcpB=$(cpB) -pkernel=${kernel} -pthreeAddress=${threeAddress} ${debug} -porig=${orig} -pmu=${mu} -pnu=${nu} -pku=${ku} -ppre=${pre} -pSSELEN=${SSELEN} -pSSENO=${SSENO} -palpha=${alpha} -pSP=${SP} -pPF=${PF} -psel=${sel} -ppermuteReg="${permute1}" -ppermuteUnroll="${permute2}" -pcleanup=$(cleanup) -pcleanupUnroll=$(cleanupUnroll) -prdC=$(rdC) $(srcdir)/gemm_block.pt

now:
	make block kernel=1 cleanup=1 ku=12 kb=12 nu=1 mu=1 SSENO=0 PF=0

check : 
	make block
	$(comp) dgemm.c $(srcdir)/dgemm.c.save
	make block kernel=1 cleanup=1 SSENO=0 PF=0
	$(comp) dgemm.c $(srcdir)/dgemm_k_c_noAsm.c.save
	make block kernel=1 mb=50
	$(comp) dgemm.c $(srcdir)/dgemm_k-mb50.c.save
	make block kernel=1 nb=50
	$(comp) dgemm.c $(srcdir)/dgemm_k-nb50.c.save
	make block cleanup=1
	$(comp) dgemm.c $(srcdir)/dgemm_c.c.save
	make block kernel=1 cleanup=1
	$(comp) dgemm.c $(srcdir)/dgemm_k_c.c.save
	rm dgemm.c

include $(atlas_inc)

test:	
	$(ICC) $(ICCFLAGS) -I${top_srcdir}/include -o dgemm.o -c dgemm.c || exit
	cd ${atlas_obj}/bin;  make xdmmtst; ./xdmmtst -b 1 $(beta) -N $(min) $(max) $(incr); 

time:	
	$(ICC) $(ICCFLAGS) -I${top_srcdir}/include -o dgemm.o -c dgemm.c || exit
	cd ${atlas_obj}/bin;  make xdmmtst; ./xdmmtst -b 1 $(beta) -N $(min) $(max) $(incr) -A 2 n n > ./ex.out; ./xstattime -# 2 -fd ex.out > ./ex.csv
	cp $(atlas_obj)/bin/ex.csv $(srcdir)


include ../../Make.inc
