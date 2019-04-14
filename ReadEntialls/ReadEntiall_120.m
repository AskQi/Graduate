function [res]=ReadEntiall_120(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=type;
% 相关资料在国标P97
res.name='回转曲面';

res.original=1;

res.l=round((Pvec(2)+1)/2);
res.c=round((Pvec(3)+1)/2);
res.sa=Pvec(4);
res.ta=Pvec(5);

res.superior=0;

res.trnsfrmtnmtrx=transformationMatrixPtr;

res.clrnmbr=colorNo;
res.color=[0,0,0];

res.ratio=[0,0];

res.well=true;

res.isplane=false;
res.ulinear=0;
res.vlinear=0;
end