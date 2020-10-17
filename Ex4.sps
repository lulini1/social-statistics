DATA LIST NOTABLE FILE='C:\EHA_SPSS\EX4.DAT' RECORDS=2 FIXED
  /2 D1 TO D60 (60F1.0).

FLIP VARIABLES=D1 TO D60.
DO REPEAT R=VAR001 TO VAR004 / D=CASE1 TO CASE4.
COMPUTE D=0.
DO IF (R NE 0).
COMPUTE D=$CASENUM.
END IF.
END REPEAT.

FLIP VARIABLES=CASE1 TO CASE4.
COMPUTE ID=$CASENUM.
WRITE FORMATS ID (F2.0) / D1 TO D60 (F3.0).
WRITE OUTFILE='C:\EHA_SPSS\OUT1'
  /  ID 1-3 D1 TO D60 (T5 60F3.0).
EXECUTE.

INPUT PROGRAM.
DATA LIST NOTABLE FILE='C:\EHA_SPSS\OUT1'
  / ID 1-3 #D1 TO #D60 (T5 60F3.0).

LEAVE ID.

COMPUTE #D61=-99.
VECTOR V=#D1 TO #D61.
LOOP #I=1 TO 61.
IF (V(#I) NE 0) TIME=V(#I).
END CASE.
END LOOP.

END INPUT PROGRAM.

SELECT IF NOT SYSMIS(TIME).

COMPUTE EVENT=1.
IF (TIME=-99) EVENT=0.

COMPUTE DURA=TIME.
IF (ID=LAG(ID,1) AND TIME NE -99) DURA=DURA-LAG(TIME,1).
IF (TIME=-99 AND ID=LAG(ID,1)) DURA=61-LAG(TIME,1).
IF (DURA=-99 AND ID NE LAG(ID,1)) DURA=61.

SAVE OUTFILE='C:\EHA_SPSS\TEM1' /DROP=TIME.

DATA LIST NOTABLE FILE='C:\EHA_SPSS\EX4.DAT' RECORDS=2
  /1 ID 1-3 SEX 5 AGE 7-8 RACE 10 EDU 12
  /2 D1 TO D60 (60F1.0).

COUNT #N=D1 TO D60 (1).
COMPUTE NUMSPELL=#N+1.

SAVE OUTFILE='C:\EHA_SPSS\TEM2' /DROP=D1 TO D60.

GET FILE='C:\EHA_SPSS\TEM2'.
MATCH FILES TABLE=* /FILE='C:\EHA_SPSS\TEM1' /BY=ID.

LIST VAR=ALL.