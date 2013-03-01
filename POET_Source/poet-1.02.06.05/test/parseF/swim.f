C ** Version modified for SPEC Benchmark suite - see Comments below
C ***
      PROGRAM SHALOW 
C     BENCHMARK WEATHER PREDICTION PROGRAM FOR COMPARING THE
C     PREFORMANCE OF CURRENT SUPERCOMPUTERS. THE MODEL IS
C     BASED OF THE PAPER - THE DYNAMICS OF FINITE-DIFFERENCE
C     MODELS OF THE SHALLOW-WATER EQUATIONS, BY ROBERT SADOURNY
C     J. ATM. SCIENCES, VOL 32, NO 4, APRIL 1975.
C
C     CODE BY PAUL N. SWARZTRAUBER, NATIONAL CENTER FOR
C     ATMOSPHERIC RESEARCH, BOULDER, CO,  OCTOBER 1984.
C
C     MODIFIED BY R. K. SATO, NCAR, APRIL 7, 1986 FOR MULTITASKING.
C     MODIFIED FOR SPEC to run longer: ITMAX inCremented from 120 to
C                                      1200 - J.Lo 7/19/90
C     Modified by Bodo Parady for the SPECpar suite.  Various
C     compilation sizes added.  Iterations reduced to orginal
C     problem, but size increased 4x in each dimension.
C
C     Further modified by Reinhold Weicker (Siemens Nixdorf) for the
C     SPEC CFP95 suite:
C     Changed back to the form with PARAMETER statements for
C     N1 and N2, set N1 = N2 = 513.
C     The execution time is determined by these values and the
C     variable ITMAX (number of iterations) read from the input file.
C     Execution time is linear in ITMAX.

      IMPLICIT INTEGER	(I-N)
      IMPLICIT REAL	(A-H, O-Z)

      PARAMETER (N1=1025, N2=1025)

      COMMON  U(N1,N2), V(N1,N2), P(N1,N2),
     *        UNEW(N1,N2), VNEW(N1,N2),
     *        PNEW(N1,N2), UOLD(N1,N2),
     *        VOLD(N1,N2), POLD(N1,N2),
     *        CU(N1,N2), CV(N1,N2),
     *        Z(N1,N2), H(N1,N2), PSI(N1,N2)
C
      COMMON /CONS/ DT,TDT,DX,DY,A,ALPHA,ITMAX,MPRINT,M,N,MP1,
     1              NP1,EL,PI,TPI,DI,DJ,PCF

C

      WRITE(6,*) 'SPEC benchmark 102.swim'

      WRITE(6,*) ' '

C       REQUEST PROCESSORS FOR MICROTASKING
C SPEC removed CMIC$ GETCPUS 4
C
C
C       INITIALIZE CONSTANTS AND ARRAYS
C
      CALL INITAL
C
C     PRINT INITIAL VALUES
C
      WRITE(6,390) N,M,DX,DY,DT,ALPHA,ITMAX
  390 FORMAT(' NUMBER OF POINTS IN THE X DIRECTION', I8/
     1       ' NUMBER OF POINTS IN THE Y DIRECTION', I8/
     2       ' GRID SPACING IN THE X DIRECTION    ', F8.0/
     3       ' GRID SPACING IN THE Y DIRECTION    ', F8.0/
     4       ' TIME STEP                          ', F8.0/
     5       ' TIME FILTER PARAMETER              ', F8.3/
     6       ' NUMBER OF ITERATIONS               ', I8)
      MNMIN = MIN0(M,N)
C initial data writes removed for SPEC
C      WRITE(6,391) (POLD(I,I),I=1,MNMIN)
C  391 FORMAT(/' INITIAL DIAGONAL ELEMENTS OF P ', //(8E15.7))
C      WRITE(6,392) (UOLD(I,I),I=1,MNMIN)
C  392 FORMAT(/' INITIAL DIAGONAL ELEMENTS OF U ', //(8E15.7))
C      WRITE(6,393) (VOLD(I,I),I=1,MNMIN)
C  393 FORMAT(/' INITIAL DIAGONAL ELEMENTS OF V ', //(8E15.7))
C        DETERMINE OVERHEAD OF TIMING CALLS

C  6/22/95 for SPEC: JWR: Initialization of TIME

      TIME = 0
      NCYCLE = 0
   90 NCYCLE = NCYCLE + 1
C
C     COMPUTE CAPITAL  U, CAPITAL V, Z AND H
C
      CALL CALC1
C
C     COMPUTE NEW VALUES U,V AND P
C
      CALL CALC2
C
      TIME = TIME + DT
      IF(MOD(NCYCLE,MPRINT) .NE. 0) GO TO 370
      PTIME = TIME/3600.
C
C *** modified for SPEC results verification
C *** We want to ensure that all calculations were done
C *** so we "use" all of the computed results.
C ***
C *** Since all of the comparisons of the individual diagnal terms
C *** often differ in the smaller values, the check we have selected
C *** is to add the absolute values of all terms and print these results
C
      WRITE(6,350) NCYCLE,PTIME
  350 FORMAT(/' CYCLE NUMBER',I5,' MODEL TIME IN  HOURS', F6.2)
C      WRITE(6,355) (PNEW(I,I),I=1,MNMIN)
C  355 FORMAT(/' DIAGONAL ELEMENTS OF P ', //(8E15.7))
C      WRITE(6,360) (UNEW(I,I),I=1,MNMIN)
C  360 FORMAT(/' DIAGONAL ELEMENTS OF U ', //(8E15.7))
C      WRITE(6,365) (VNEW(I,I),I=1,MNMIN)
C  365 FORMAT(/' DIAGONAL ELEMENTS OF V ', //(8E15.7))
C ***
        PCHECK = 0.0
        UCHECK = 0.0
        VCHECK = 0.0
        
        DO 3500 ICHECK = 1, MNMIN
         DO 3500 JCHECK = 1, MNMIN
         PCHECK = PCHECK + ABS(PNEW(ICHECK,JCHECK))
         UCHECK = UCHECK + ABS(UNEW(ICHECK,JCHECK))
         VCHECK = VCHECK + ABS(VNEW(ICHECK,JCHECK))
 3500   CONTINUE
C ***
C ***
        WRITE(6,366) PCHECK, UCHECK, VCHECK
 366    FORMAT(/,
     *         ' Pcheck = ',E12.4,/,
     *         ' Ucheck = ',E12.4,/,
     *         ' Vcheck = ',E12.4,/)

370   CONTINUE
C        TEST FOR END OF RUN
      IF(NCYCLE .GE. ITMAX) THEN
      STOP
      ENDIF
C
C     TIME SMOOTHING AND UPDATE FOR NEXT CYCLE
C

      IF(NCYCLE .LE. 1) THEN
         CALL CALC3Z
      ELSE
         CALL CALC3
      ENDIF
C
      GO TO 90

      END
      SUBROUTINE INITAL
C        INITIALIZE CONSTANTS AND ARRAYS
C           R. K. SATO 4/7/86
C
C //@; BEGIN(decl1=DeclStmt)
      PARAMETER (N1=1025, N2=1025)

      COMMON  U(N1,N2), V(N1,N2), P(N1,N2),
     *        UNEW(N1,N2), VNEW(N1,N2),
     1        PNEW(N1,N2), UOLD(N1,N2),
     *        VOLD(N1,N2), POLD(N1,N2),
     2        CU(N1,N2), CV(N1,N2),
     *        Z(N1,N2), H(N1,N2), PSI(N1,N2)
C
      COMMON /CONS/ DT,TDT,DX,DY,A,ALPHA,ITMAX,MPRINT,M,N,MP1,
     1              NP1,EL,PI,TPI,DI,DJ,PCF
C
C     NOTE BELOW THAT TWO DELTA T (TDT) IS SET TO DT ON THE FIRST
C     CYCLE AFTER WHICH IT IS RESET TO DT+DT.
C
C The following code  was in SWM256, however, it was replaced by 
C		READ statements to avoid calculations to be done during
C		compile time.
C
C      DT = 20.
C
C      DX = .25E5
C      DY = .25E5
C      A = 1.E6
C      ALPHA = .001
C      ITMAX = 1200
C      MPRINT = 1200
C      M = N1 - 1
C      N = N2 - 1
      READ (5,*) DT
      READ (5,*) DX
      READ (5,*) DY
      READ (5,*) A
      READ (5,*) ALPHA
      READ (5,*) ITMAX
      READ (5,*) MPRINT
      READ (5,*) M
      READ (5,*) N
      TDT = DT
      MP1 = M+1
      NP1 = N+1
      EL = FLOAT(N)*DX
      PI = 4.*ATAN(1.)
      TPI = PI+PI
      DI = TPI/FLOAT(M)
      DJ = TPI/FLOAT(N)
      PCF = PI*PI*A*A/(EL*EL)
C
C     INITIAL VALUES OF THE STREAM FUNCTION AND P
C
C //@; BEGIN(looplist1=LoopNestList)
      DO 50 J=1,NP1
      DO 50 I=1,MP1
      PSI(I,J) = A*SIN((FLOAT(I)-0.5)*DI)*SIN((FLOAT(J)-0.5)*DJ)
      P(I,J) = PCF*(COS(2.*FLOAT(I-1)*DI)
     1                +COS(2.*FLOAT(J-1)*DJ))+50000.
   50 CONTINUE
C
C     INITIALIZE VELOCITIES
C
      DO 60 J=1,N
      DO 60 I=1,M
      U(I+1,J) = -(PSI(I+1,J+1)-PSI(I+1,J))/DY
      V(I,J+1) = (PSI(I+1,J+1)-PSI(I,J+1))/DX
   60 CONTINUE
C
C     PERIODIC CONTINUATION
C
      DO 70 J=1,N
      U(1,J) = U(M+1,J)
      V(M+1,J+1) = V(1,J+1)
   70 CONTINUE
      DO 75 I=1,M
      U(I+1,N+1) = U(I+1,1)
      V(I,1) = V(I,N+1)
   75 CONTINUE
      U(1,N+1) = U(M+1,1)
      V(M+1,1) = V(1,N+1)
      DO 86 J=1,NP1
      DO 86 I=1,MP1
      UOLD(I,J) = U(I,J)
      VOLD(I,J) = V(I,J)
      POLD(I,J) = P(I,J)
   86 CONTINUE
C        END OF INITIALIZATION
      RETURN
      END
C SPEC removed CCMIC$ MICRO
      SUBROUTINE CALC1
C
C        COMPUTE CAPITAL  U, CAPITAL V, Z AND H
C
C //@; BEGIN(decl2=DeclStmt)
      PARAMETER (N1=1025, N2=1025)

      COMMON  U(N1,N2), V(N1,N2), P(N1,N2),
     *        UNEW(N1,N2), VNEW(N1,N2),
     1        PNEW(N1,N2), UOLD(N1,N2),
     *        VOLD(N1,N2), POLD(N1,N2),
     2        CU(N1,N2), CV(N1,N2),
     *        Z(N1,N2), H(N1,N2), PSI(N1,N2)
C
      COMMON /CONS/ DT,TDT,DX,DY,A,ALPHA,ITMAX,MPRINT,M,N,MP1,
     1              NP1,EL,PI,TPI,DI,DJ,PCF
C
      FSDX = 4./DX
      FSDY = 4./DY

C SPEC removed CCMIC$ DO GLOBAL
C //@; BEGIN(looplist2=LoopNestList)
      DO 100 J=1,N
      DO 100 I=1,M
      CU(I+1,J) = 0.5*(P(I+1,J)+P(I,J))*U(I+1,J)
      CV(I,J+1) = 0.5*(P(I,J+1)+P(I,J))*V(I,J+1)
      Z(I+1,J+1) = (FSDX*(V(I+1,J+1)-V(I,J+1))-FSDY*(U(I+1,J+1)
     1          -U(I+1,J)))/(P(I,J)+P(I+1,J)+P(I+1,J+1)+P(I,J+1))
      H(I,J) = P(I,J)+.25*(U(I+1,J)*U(I+1,J)+U(I,J)*U(I,J)
     1               +V(I,J+1)*V(I,J+1)+V(I,J)*V(I,J))
  100 CONTINUE

C
C     PERIODIC CONTINUATION
C
      DO 110 J=1,N
      CU(1,J) = CU(M+1,J)
      CV(M+1,J+1) = CV(1,J+1)
      Z(1,J+1) = Z(M+1,J+1)
      H(M+1,J) = H(1,J)
  110 CONTINUE
      DO 115 I=1,M
      CU(I+1,N+1) = CU(I+1,1)
      CV(I,1) = CV(I,N+1)
      Z(I+1,1) = Z(I+1,N+1)
      H(I,N+1) = H(I,1)
  115 CONTINUE
      CU(1,N+1) = CU(M+1,1)
      CV(M+1,1) = CV(1,N+1)
      Z(1,1) = Z(M+1,N+1)
      H(M+1,N+1) = H(1,1)
C        END OF LOOP 100 CALCULATIONS
      RETURN
      END
C SPEC removed CCMIC$ MICRO
      SUBROUTINE CALC2
C
C        COMPUTE NEW VALUES OF U,V,P
C
C //@; BEGIN(decl3=DeclStmt)
      PARAMETER (N1=1025, N2=1025)

      COMMON  U(N1,N2), V(N1,N2), P(N1,N2),
     *        UNEW(N1,N2), VNEW(N1,N2),
     1        PNEW(N1,N2), UOLD(N1,N2),
     *        VOLD(N1,N2), POLD(N1,N2),
     2        CU(N1,N2), CV(N1,N2),
     *        Z(N1,N2), H(N1,N2), PSI(N1,N2)
C
      COMMON /CONS/ DT,TDT,DX,DY,A,ALPHA,ITMAX,MPRINT,M,N,MP1,
     1              NP1,EL,PI,TPI,DI,DJ,PCF
      TDTS8 = TDT/8.
      TDTSDX = TDT/DX
      TDTSDY = TDT/DY

C SPEC removed CCMIC$ DO GLOBAL
C //@; BEGIN(looplist3=LoopNestList)
      DO 200 J=1,N
      DO 200 I=1,M
      UNEW(I+1,J) = UOLD(I+1,J)+
     1    TDTS8*(Z(I+1,J+1)+Z(I+1,J))*(CV(I+1,J+1)+CV(I,J+1)+CV(I,J)
     2       +CV(I+1,J))-TDTSDX*(H(I+1,J)-H(I,J))
      VNEW(I,J+1) = VOLD(I,J+1)-TDTS8*(Z(I+1,J+1)+Z(I,J+1))
     1       *(CU(I+1,J+1)+CU(I,J+1)+CU(I,J)+CU(I+1,J))
     2       -TDTSDY*(H(I,J+1)-H(I,J))
      PNEW(I,J) = POLD(I,J)-TDTSDX*(CU(I+1,J)-CU(I,J))
     1       -TDTSDY*(CV(I,J+1)-CV(I,J))
  200 CONTINUE

C
C     PERIODIC CONTINUATION
C
      DO 210 J=1,N
      UNEW(1,J) = UNEW(M+1,J)
      VNEW(M+1,J+1) = VNEW(1,J+1)
      PNEW(M+1,J) = PNEW(1,J)
  210 CONTINUE
      DO 215 I=1,M
      UNEW(I+1,N+1) = UNEW(I+1,1)
      VNEW(I,1) = VNEW(I,N+1)
      PNEW(I,N+1) = PNEW(I,1)
  215 CONTINUE
      UNEW(1,N+1) = UNEW(M+1,1)
      VNEW(M+1,1) = VNEW(1,N+1)
      PNEW(M+1,N+1) = PNEW(1,1)
C
      RETURN
      END
      SUBROUTINE CALC3Z
C
C         TIME SMOOTHER FOR FIRST ITERATION
C
      PARAMETER (N1=1025, N2=1025)

      COMMON  U(N1,N2), V(N1,N2), P(N1,N2),
     *        UNEW(N1,N2), VNEW(N1,N2),
     1        PNEW(N1,N2), UOLD(N1,N2),
     *        VOLD(N1,N2), POLD(N1,N2),
     2        CU(N1,N2), CV(N1,N2),
     *        Z(N1,N2), H(N1,N2), PSI(N1,N2)
C
      COMMON /CONS/ DT,TDT,DX,DY,A,ALPHA,ITMAX,MPRINT,M,N,MP1,
     1              NP1,EL,PI,TPI,DI,DJ,PCF
C
      TDT = TDT+TDT
      DO 400 J=1,NP1
      DO 400 I=1,MP1
      UOLD(I,J) = U(I,J)
      VOLD(I,J) = V(I,J)
      POLD(I,J) = P(I,J)
      U(I,J) = UNEW(I,J)
      V(I,J) = VNEW(I,J)
      P(I,J) = PNEW(I,J)
  400 CONTINUE
      RETURN
      END
C SPEC removed CCMIC$ MICRO
      SUBROUTINE CALC3
C
C         TIME SMOOTHER
C
C //@; BEGIN(decl4=DeclStmt)
      PARAMETER (N1=1025, N2=1025)

      COMMON  U(N1,N2), V(N1,N2), P(N1,N2),
     *        UNEW(N1,N2), VNEW(N1,N2),
     1        PNEW(N1,N2), UOLD(N1,N2),
     *        VOLD(N1,N2), POLD(N1,N2),
     2        CU(N1,N2), CV(N1,N2),
     *        Z(N1,N2), H(N1,N2), PSI(N1,N2)
C
      COMMON /CONS/ DT,TDT,DX,DY,A,ALPHA,ITMAX,MPRINT,M,N,MP1,
     1              NP1,EL,PI,TPI,DI,DJ,PCF
C
C        TIME SMOOTHING AND UPDATE FOR NEXT CYCLE
C

C SPEC removed CCMIC$ DO GLOBAL
C //@; BEGIN(looplist4=LoopNestList)
      DO 300 J=1,N
      DO 300 I=1,M
      UOLD(I,J) = U(I,J)+ALPHA*(UNEW(I,J)-2.*U(I,J)+UOLD(I,J))
      VOLD(I,J) = V(I,J)+ALPHA*(VNEW(I,J)-2.*V(I,J)+VOLD(I,J))
      POLD(I,J) = P(I,J)+ALPHA*(PNEW(I,J)-2.*P(I,J)+POLD(I,J))
      U(I,J) = UNEW(I,J)
      V(I,J) = VNEW(I,J)
      P(I,J) = PNEW(I,J)
  300 CONTINUE

C
C     PERIODIC CONTINUATION
C
      DO 320 J=1,N
      UOLD(M+1,J) = UOLD(1,J)
      VOLD(M+1,J) = VOLD(1,J)
      POLD(M+1,J) = POLD(1,J)
      U(M+1,J) = U(1,J)
      V(M+1,J) = V(1,J)
      P(M+1,J) = P(1,J)
  320 CONTINUE
      DO 325 I=1,M
      UOLD(I,N+1) = UOLD(I,1)
      VOLD(I,N+1) = VOLD(I,1)
      POLD(I,N+1) = POLD(I,1)
      U(I,N+1) = U(I,1)
      V(I,N+1) = V(I,1)
      P(I,N+1) = P(I,1)
  325 CONTINUE
      UOLD(M+1,N+1) = UOLD(1,1)
      VOLD(M+1,N+1) = VOLD(1,1)
      POLD(M+1,N+1) = POLD(1,1)
      U(M+1,N+1) = U(1,1)
      V(M+1,N+1) = V(1,1)
      P(M+1,N+1) = P(1,1)
C
      RETURN
      END

