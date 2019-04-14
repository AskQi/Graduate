function [res]=ReadEntiall_122(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=type;
% 相关资料在国标P98
res.name='列表柱面';

res.original=1;

res.de=round((Pvec(2)+1)/2);
res.lx=Pvec(3);
res.ly=Pvec(4);
res.lz=Pvec(5);

res.superior=0;

res.trnsfrmtnmtrx=transformationMatrixPtr;

res.clrnmbr=colorNo;
res.color=[0,0,0];

res.ratio=[0,0];

res.well=true;

res.isplane=false;
res.ulinear=0;
res.vlinear=1;
end