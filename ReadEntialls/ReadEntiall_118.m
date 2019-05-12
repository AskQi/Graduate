function [res]=ReadEntiall_118(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 直纹面实体，相关资料在国标P94，采用格式1（相对参数值）
res.type=type;
res.name='直纹面';

res.original=1;

res.de1=round((Pvec(2)+1)/2);
res.de2=round((Pvec(3)+1)/2);
res.dirflg=Pvec(4);
res.devflg=Pvec(5);

res.superior=0;

res.trnsfrmtnmtrx=transformationMatrixPtr;

res.clrnmbr=colorNo;
res.color=[0,0,0];

res.form=formNo;

res.ratio=[0,0];

res.isplane=false;
res.ulinear=0;
res.vlinear=1;

res.well=true;
end