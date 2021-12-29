
/*VAR模型*

/*
VAR模型：缩减型VAR  SVAR
**内生变量的*跨期*相关性
**未考虑*同期相关性*
**注重变量之间的“因果关系”分析；至于谁是原因，谁是结果，我们也不清楚

**step1:描述性分析
**step2:单位根检验
**step3:选择最优滞后阶数
**step4:估计模型
	*step4.1:正交脉冲响应图形（内生变量的外部冲击，对其自身和其他内生变量的影响）
	*step4.2:包含假设外生变量的VAR模型
**step5:平稳性检验
**step6:残差检验
	*step6.1:正太分布检验
	*step6.2:序列自相关检验
**step7:格兰杰因果检验

egen t=group(time)
tsset t   //告诉stata我们的数据是时间序列数据
**step2:单位根检验
dfuller NEER 
dfuller CPI
dfuller W
gen dNEER=d.NEER
dfuller dNEER 
gen dCPI=d.CPI
dfuller dCPI
gen dW=d.W
dfuller dW 

**step3:选择最优滞后阶数 
varsoc dNEER dCPI dW
**step4:估计模型
varbasic ln_NEER ln_CPI ln_W,nograph 

var dNEER dCPI dW,lag(1/3) dfk small
**检验滞后阶数的显著性
varwle
constraint define 1 [dW]L1.dNEER=0
constraint define 2 [dW]L1.dCPI=0
constraint define 3 [dW]L1.dW=0
constraint define 4 [dW]L3.dNEER=0
constraint define 5 [dW]L3.dCPI=0
constraint define 6 [dW]L3.dW=0
constraint define 7 [dCPI]L1.dNEER=0
constraint define 8 [dCPI]L1.dCPI=0
constraint define 9 [dCPI]L1.dW=0

var dNEER dCPI dW,lag(1/3) constraint(1/9) dfk small

*step4:正交脉冲响应图形
varbasic dNEER dCPI W,irf

**step5:平稳性检验
var ln_NEER ln_CPI ln_W,lag(1/4)
varstable
varstable,graph

**step6:残差检验
var ln_NEER ln_CPI ln_W,lag(1/4)

**step7:格兰杰因果检验（一种动态相关关系，也就是一个变量对另一个变量的预测能力）
var ln_NEER ln_CPI ln_W,lag(1/4) constraint(1/9)
vargranger









