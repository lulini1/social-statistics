* ================= RH2001调查：生育人年生成_宽格式数据转长格式数据 ：140213加入人年ceb_y.

*** 注：本程序忽略月份，简单用调查对象在本年生日的年龄作为全人年年龄和本年的生育年龄。 .

GET  FILE='D:\BPYdata_SPSS\Wide_data.sav'.

*** 注1：该试验数据中含三例从未生育者（code=500、568和580），并且未按code排序。.

SORT CASES BY  code (A) .                                 /* 按妇女编码正排序.

VARSTOCASES                                               /*  共4段，各含3个变量
   /MAKE byear  FROM q204_1_y q204_2_y q204_3_y q204_4_y      /*  byear  为生育年
   /MAKE bmonth FROM q204_1_m q204_2_m q204_3_m q204_4_m      /*  bmonth 为生育月
   /MAKE result FROM q204_1_b q204_2_b q204_3_b q204_4_b      /*  result 为生育结果
   /INDEX = Index1(4)                  /* 新增同案例号1-4。以下code为id，后接固定变量
   /KEEP =  code q101_y q101_m ceb            /* 以下表示未指定变量将作为固定变量
   /NULL = KEEP.             
        
*** 注2：以下要在长数据中保留从未生育者，将其生育结果改活产(2) .
* -------将其首次生育时间改为不可能值2002（所用数据为RH2001调查）.

DO IF (Index1=1 & sysmis(byear)=1) .
+ COMPUTE byear=2002.
+ COMPUTE result=2.
END IF.
EXE.

* ------------ 删除那些没有“生育年” 和  怀孕结果不是活产男婴(1)或女婴(2)的案例.
FILTER OFF.
USE ALL.
SELECT IF(result = 1 | result = 2).
EXECUTE .

SORT CASES BY  code (A) byear (A) .              /* 先按 id 和 byear 正排序.

SAVE OUTFILE='D:\BPYdata_SPSS\Long_data.sav'.    /* 将形成中间结果存盘待用.

* ====================  重新打开宽数据，通过循环来产生人年 =============.

GET  FILE='D:\BPYdata_SPSS\Wide_data.sav'.

DELETE VARIABLES q204_1_y TO q204_4_b .   /* 删去已无用的变量.

VECTOR year(35).                /* 建立生育期35年人年变量，然后将人年变量转换为人年案例.
VARSTOCASES  /MAKE trans1 FROM 
   year1 year2 year3 year4 year5 year6 year7 year8 year9 year10 year11 year12 year13
   year14 year15 year16 year17 year18 year19 year20 year21 year22 year23 year24 
   year25 year26 year27 year28 year29 year30 year31  year32 year33 year34 year35
 /INDEX = Index1(35)
 /KEEP =  code q101_y q101_m ceb
 /NULL = KEEP.

RENAME VARIABLES trans1=fertyear.          /* 重命名转换变量为人年年份.

LOOP #i=1 TO 35.                           /* 循环处理每名妇女的生育人年.
+  COMPUTE fertyear=2002- Index1 .            /* 计算人年的年份.
+  COMPUTE fertage =fertyear-q101_y.          /* 计算人年的年龄.
END LOOP.
EXECUTE .

FILTER OFF.                                /* 选取15岁及以上的生育人年.
USE ALL.
SELECT IF(fertage >= 15).
EXECUTE .

SORT CASES BY  code (A) fertyear (A) .     /* 按妇女编码和人年年份重新排序.

ADD FILES /FILE=*                          /* 将前存中间数据与当前工作数据合并.
 /FILE='D:\BPYdata_SPSS\Long_data.sav'
 /IN=source01.
VARIABLE LABELS source01.
EXECUTE.

DO IF source01=1.                          /* 给插入的数据记录计算人年的年份和年龄.
+  COMPUTE fertyear=byear.
+  COMPUTE fertage =fertyear-q101_y.
END IF.
EXE.

SORT CASES BY  code (A) fertyear (A) source01 (D) .    /* 按人年年份和来源重新排序.

* -------------------------为多余人年记录做记号--------------------------.
COMPUTE index1=( ~ (code=LAG(code) & fertyear=LAG(fertyear) & fertage=LAG(fertage))).
SELECT IF (index1=1 | $casenum=1).                     /* 删去多余人年记录.
EXECUTE .

FILTER OFF.
USE ALL.
SELECT IF(fertyear < 2002).                /* 删去2002年及以后的非法人年记录.
EXECUTE .

DO REPEAT b=bt b1 b2 b3 ceb_y .            /* 新建五个新的生育变量待用，均赋值0.
+ COMPUTE b=0.
END REPEAT.
EXE.

SORT CASES BY  code (A) fertyear (A) .     /* 按妇女编码和人年年份重新排序.

* ---------- 循环计算每名妇女各人年的生育变量值 -----------.
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

* -------------- 设置生育变量标签与格式 ---------------.
VARIABLE LABELS fertyear '人年年份' /fertage '人年年龄'
  /bt '人年生育数' /b1 '一孩生育' /b2 '二孩生育' /b3 '3+孩生育'
  /ceb_y '人年CEB' .
VALUE LABELS  bt b1 b2 b3   0 "未生 "  1 "活产" .
FORMATS ALL (F5.0).

* -------------- 保存最终数据文件并删去无用变量 ----------------.

SAVE OUTFILE='D:\BPYdata_SPSS\Final fertility person-year data.sav'
  /DROP=Index1 byear bmonth result source01.



