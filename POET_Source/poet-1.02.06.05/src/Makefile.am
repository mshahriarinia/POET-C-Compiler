
bin_PROGRAMS = pcg
pcg_SOURCES=  poetAST.cpp main.cpp codegen.cpp parse.cpp evalAST.cpp evalOp.cpp driver.cpp timing.cpp poet_yacc.y poet_lex.l 

noinst_LIBRARIES = libpoet.a
libpoet_a_SOURCES=poetAST.cpp codegen.cpp  parse.cpp evalAST.cpp evalOp.cpp driver.cpp timing.cpp poet_yacc.c poet_lex.c

EXTRA_DIST = poet_yacc.y poet_lex.l ASTfactory.h SymbolTable.h poetAST.h ASTvisitor.h error_config.h poet_config.h ASTeval.h timing.h

files = $(EXTRA_DIST) $(pcg_SOURCES)

AM_YFLAGS=-d -v
AM_CPPFLAGS = -DPOET_LIB_DIR=\"$(DESTDIR)/$(libdir)/\"

include ${top_srcdir}/Make.inc
