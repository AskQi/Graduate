function [res]=ReadEntiall_120(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 回转曲面，相关资料在国标P97
res.type=type;
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

res.well=false;
%TODO:转换为NURBS曲面
end