
*================== ��SPSS��CanCorr�������������ط��� ==================.

*  1�����д�Ҫ���е�����ط�����SPSS�����ļ�����FP_SE.sav.
*  2����SPSS����ڼ�������������õ�����غ��������ģ�Ͳ�����.
*  3��ע�⣺��һ��������밴���û�SPSS�����ʵ���ļ��м�����Ӧ�޸�.
*     ������SPSS18��ʱ��������һ��������������Ĭ�ϰ�װ�ļ����ҵ�.
*     C:\Program Files\SPSSInc\PASWStatistics18\Samples\English\    .
*  4��ע�⣺CANCORR�����еı����������Ӧ���������еı�����.

INCLUDE 'C:\Program Files\SPSS\Canonical correlation.sps'.

CANCORR SET1=x1 x2
 /SET2=x3 x4 x5 .

* ���к��ϰ�SPSS���ݴ��ڽ�ԭ��������ͱ����ϲ�Ϊ��ʱ����CC__TMP1.SAV.
* ���°�SPSS���ݴ�����ԭ�����ϸ��ӵ��ͱ�������ԭ�����ļ�������.


*================== ��SPSS��MANOVA������������ط��� ==================.

* ���д򿪹��������ļ�����FP_SE.sav.
* ��SPSS����ڼ�����������.
* ���ɾ��ALPHA(1)ѡ�Ĭ��ִ��0.25������׼�������ά�Ȳ������.

MANOVA
  x1 x2  WITH x3 x4 x5
 /PRINT=SIGNIF (MULTIV EIGEN DIMENR)
 /DISCRIM RAW STAN COR ALPHA(1)
 /ERROR=WR
 /DESIGN=CONSTANT.

