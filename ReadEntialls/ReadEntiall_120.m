function [res]=ReadEntiall_120(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% ��ת���棬��������ڹ���P97
res.type=type;
res.name='��ת����';

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
%TODO:ת��ΪNURBS����
end