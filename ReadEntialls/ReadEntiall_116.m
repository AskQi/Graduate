function [res]=ReadEntiall_112(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=type;
% ��ʵ�壬�ڹ���P116
res.name='��';

res.p=Pvec(2:4)';

res.x=res.p(1);
res.y=res.p(2);
res.z=res.p(3);

try
    res.ptr=round((Pvec(5)+1)/2);
catch
    res.ptr=0;
end

res.original=1;

res.trnsfrmtnmtrx=transformationMatrixPtr;

res.clrnmbr=colorNo;
res.color=[0,0,0];

res.well=true;
end