* ================= RH2001���飺������������_���ʽ����ת����ʽ���� ��140213��������ceb_y.

*** ע������������·ݣ����õ�������ڱ������յ�������Ϊȫ��������ͱ�����������䡣 .

GET  FILE='D:\BPYdata_SPSS\Wide_data.sav'.

*** ע1�������������к�������δ�����ߣ�code=500��568��580��������δ��code����.

SORT CASES BY  code (A) .                                 /* ����Ů����������.

VARSTOCASES                                               /*  ��4�Σ�����3������
   /MAKE byear  FROM q204_1_y q204_2_y q204_3_y q204_4_y      /*  byear  Ϊ������
   /MAKE bmonth FROM q204_1_m q204_2_m q204_3_m q204_4_m      /*  bmonth Ϊ������
   /MAKE result FROM q204_1_b q204_2_b q204_3_b q204_4_b      /*  result Ϊ�������
   /INDEX = Index1(4)                  /* ����ͬ������1-4������codeΪid����ӹ̶�����
   /KEEP =  code q101_y q101_m ceb            /* ���±�ʾδָ����������Ϊ�̶�����
   /NULL = KEEP.             
        
*** ע2������Ҫ�ڳ������б�����δ�����ߣ�������������Ļ��(2) .
* -------�����״�����ʱ���Ϊ������ֵ2002����������ΪRH2001���飩.

DO IF (Index1=1 & sysmis(byear)=1) .
+ COMPUTE byear=2002.
+ COMPUTE result=2.
END IF.
EXE.

* ------------ ɾ����Щû�С������ꡱ ��  ���н�����ǻ����Ӥ(1)��ŮӤ(2)�İ���.
FILTER OFF.
USE ALL.
SELECT IF(result = 1 | result = 2).
EXECUTE .

SORT CASES BY  code (A) byear (A) .              /* �Ȱ� id �� byear ������.

SAVE OUTFILE='D:\BPYdata_SPSS\Long_data.sav'.    /* ���γ��м������̴���.

* ====================  ���´򿪿����ݣ�ͨ��ѭ������������ =============.

GET  FILE='D:\BPYdata_SPSS\Wide_data.sav'.

DELETE VARIABLES q204_1_y TO q204_4_b .   /* ɾȥ�����õı���.

VECTOR year(35).                /* ����������35�����������Ȼ���������ת��Ϊ���갸��.
VARSTOCASES  /MAKE trans1 FROM 
   year1 year2 year3 year4 year5 year6 year7 year8 year9 year10 year11 year12 year13
   year14 year15 year16 year17 year18 year19 year20 year21 year22 year23 year24 
   year25 year26 year27 year28 year29 year30 year31  year32 year33 year34 year35
 /INDEX = Index1(35)
 /KEEP =  code q101_y q101_m ceb
 /NULL = KEEP.

RENAME VARIABLES trans1=fertyear.          /* ������ת������Ϊ�������.

LOOP #i=1 TO 35.                           /* ѭ������ÿ����Ů����������.
+  COMPUTE fertyear=2002- Index1 .            /* ������������.
+  COMPUTE fertage =fertyear-q101_y.          /* �������������.
END LOOP.
EXECUTE .

FILTER OFF.                                /* ѡȡ15�꼰���ϵ���������.
USE ALL.
SELECT IF(fertage >= 15).
EXECUTE .

SORT CASES BY  code (A) fertyear (A) .     /* ����Ů��������������������.

ADD FILES /FILE=*                          /* ��ǰ���м������뵱ǰ�������ݺϲ�.
 /FILE='D:\BPYdata_SPSS\Long_data.sav'
 /IN=source01.
VARIABLE LABELS source01.
EXECUTE.

DO IF source01=1.                          /* ����������ݼ�¼�����������ݺ�����.
+  COMPUTE fertyear=byear.
+  COMPUTE fertage =fertyear-q101_y.
END IF.
EXE.

SORT CASES BY  code (A) fertyear (A) source01 (D) .    /* ��������ݺ���Դ��������.

* -------------------------Ϊ���������¼���Ǻ�--------------------------.
COMPUTE index1=( ~ (code=LAG(code) & fertyear=LAG(fertyear) & fertage=LAG(fertage))).
SELECT IF (index1=1 | $casenum=1).                     /* ɾȥ���������¼.
EXECUTE .

FILTER OFF.
USE ALL.
SELECT IF(fertyear < 2002).                /* ɾȥ2002�꼰�Ժ�ķǷ������¼.
EXECUTE .

DO REPEAT b=bt b1 b2 b3 ceb_y .            /* �½�����µ������������ã�����ֵ0.
+ COMPUTE b=0.
END REPEAT.
EXE.

SORT CASES BY  code (A) fertyear (A) .     /* ����Ů��������������������.

* ---------- ѭ������ÿ����Ů���������������ֵ -----------.
LOOP.                             
+   IF fertage>15 ceb_y = LAG(ceb_y).
+   DO IF result>=1.    
-     COMPUTE  bt = 1.
-     COMPUTE ceb_y = LAG(ceb_y) + 1 .
-     DO IF ceb_y=1.
-       COMPUTE  b1 = 1.
-     ELSE IF ceb_y=2.
-       COMPUTE  b2 = 1.
-     ELSE .
-       COMPUTE  b3 = 1.
-     END IF.
+   END IF.
END LOOP IF code~=LAG(code).
EXE.

* -------------- ��������������ǩ���ʽ ---------------.
VARIABLE LABELS fertyear '�������' /fertage '��������'
  /bt '����������' /b1 'һ������' /b2 '��������' /b3 '3+������'
  /ceb_y '����CEB' .
VALUE LABELS  bt b1 b2 b3   0 "δ�� "  1 "���" .
FORMATS ALL (F5.0).

* -------------- �������������ļ���ɾȥ���ñ��� ----------------.

SAVE OUTFILE='D:\BPYdata_SPSS\Final fertility person-year data.sav'
  /DROP=Index1 byear bmonth result source01.



