
*================== 用SPSS的CanCorr宏程序做典型相关分析 ==================.

*  1．先行打开要进行典型相关分析的SPSS数据文件，如FP_SE.sav.
*  2．在SPSS命令窗口键入以下命令，调用典型相关宏程序，设置模型并运行.
*  3．注意：第一句命令必须按照用户SPSS软件的实际文件夹加以相应修改.
*     比如在SPSS18版时这个宏程序一般可以在其下面的默认安装文件夹找到.
*     C:\Program Files\SPSSInc\PASWStatistics18\Samples\English\    .
*  4．注意：CANCORR命令中的变量名必须对应工作数据中的变量名.

INCLUDE 'C:\Program Files\SPSS\Canonical correlation.sps'.

CANCORR SET1=x1 x2
 /SET2=x3 x4 x5 .

* 运行后，老版SPSS数据窗口将原数据与典型变量合并为临时数据CC__TMP1.SAV.
* 而新版SPSS数据窗口在原数据上附加典型变量，但原数据文件名不变.


*================== 用SPSS的MANOVA命令做典型相关分析 ==================.

* 先行打开工作数据文件，如FP_SE.sav.
* 在SPSS命令窗口键入下列命令.
* 如果删除ALPHA(1)选项，默认执行0.25显著标准，不达标维度不再输出.

MANOVA
  x1 x2  WITH x3 x4 x5
 /PRINT=SIGNIF (MULTIV EIGEN DIMENR)
 /DISCRIM RAW STAN COR ALPHA(1)
 /ERROR=WR
 /DESIGN=CONSTANT.

