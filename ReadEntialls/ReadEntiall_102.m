function [res]=ReadEntiall_102(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 复合曲线实体，在国标P68
res.type=type;
res.name='复合曲线';

res.n=Pvec(2);
res.de=round((Pvec(3:(2+Pvec(2)))+1)/2);

res.lengthcnt=zeros(1,Pvec(2));
res.length=0;

res.clrnmbr=colorNo;
res.color=[0,0,0];

res.numcrvcnt=zeros(1,Pvec(2));
res.numcrv=0;

res.trnsfrmtnmtrx=transformationMatrixPtr;
res.well=true;
end