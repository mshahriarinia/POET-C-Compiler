DRIVER=project.pt
GRAMMAR=C.code
INPUT=test.c
OUTPUT=test.out
PCG=pcg
DEBUG=-dp

all: $(INPUT) $(GRAMMAR) $(DRIVER)
	$(PCG) $(DEBUG) \
	  -pinputFile=$(INPUT) \
	  -psyntaxFile=$(GRAMMAR) \
	  $(DRIVER)
