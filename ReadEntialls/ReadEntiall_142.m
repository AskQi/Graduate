function [res]=ReadEntiall_142(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% ���������ϵ�������ʵ�壬�ڹ���P134
res.type=type;
res.name='���������ϵ�������ʵ��';

res.crtn=Pvec(2);
res.sptr=round((Pvec(3)+1)/2);
res.bptr=round((Pvec(4)+1)/2);
res.cptr=round((Pvec(5)+1)/2);
res.pref=Pvec(6);
res.length=0;

res.mlcrv=0;

res.clrnmbr=colorNo;
res.color=[0,0,0];

res.numcrv=0;

res.well=true;

% POINT
end