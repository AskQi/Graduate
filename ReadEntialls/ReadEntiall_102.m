function [res]=ReadEntiall_102(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=100;
% �ڹ���P68
res.name='��������';

res.n=Pvec(2);
res.de=round((Pvec(3:(2+Pvec(2)))+1)/2);

res.lengthcnt=zeros(1,Pvec(2));
res.length=0;

res.clrnmbr=colorNo;
res.color=[0,0,0];

res.numcrvcnt=zeros(1,Pvec(2));
res.numcrv=0;

res.well=true;
end