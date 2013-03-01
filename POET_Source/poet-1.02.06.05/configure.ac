AC_INIT([POET], 1.02.06.05, qingyi@cs.utsa.edu)
AC_PROG_RANLIB
AC_PROG_CXX
AC_PROG_CC
AC_DECL_YYTEXT
AC_PROG_YACC
AM_PROG_LEX
AC_CONFIG_FILES([Makefile])
AC_CONFIG_FILES([src/Makefile])
AC_CONFIG_FILES([lib/Makefile])
AC_CONFIG_FILES([doc/Makefile])
AC_CONFIG_FILES([test/Makefile])
AC_CONFIG_FILES([examples/Makefile])
AC_CONFIG_FILES([test/gemmATLAS/Makefile])
AC_CONFIG_FILES([test/gemvATLAS/Makefile])
AC_CONFIG_FILES([test/gerATLAS/Makefile])
AC_CONFIG_FILES([test/gemm/Makefile])
AC_CONFIG_FILES([test/autoScripts/Makefile])
AC_CONFIG_FILES([test/commands/Makefile])
AC_CONFIG_FILES([test/timerGeneration/Makefile])
AC_CONFIG_FILES([test/parseF/Makefile])
AC_CONFIG_FILES([test/tune/Makefile])

test -n "$atlas_obj" || atlas_obj="";
test -n "$atlas_exe" || atlas_exe=xdmmtst;
test -e "$atlas_obj" && atlas_inc="${atlas_obj}/Make.inc";

testdirs="commands gemmATLAS gemvATLAS gerATLAS gemm autoScripts timerGeneration parseF tune"; 

AC_SUBST(atlas_obj)
AC_SUBST(atlas_exe)
AC_SUBST(atlas_inc)
AC_SUBST(testdirs)
AM_INIT_AUTOMAKE
AC_OUTPUT
