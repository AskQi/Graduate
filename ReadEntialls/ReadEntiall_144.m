function [res]=ReadEntiall_144(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% �ü�������)����ʵ�壬�ڹ���P137
res.type=type;
res.name='�ü�������)����ʵ��';

res.original=1;

res.trimmed=1;

res.ratio=[0,0];

res.pts=round((Pvec(2)+1)/2);

res.n1=Pvec(3);
res.n2=Pvec(4);

if Pvec(5)~=0
    res.pto=round((Pvec(5)+1)/2);
else
    res.pto=0;
end

res.pti=round((Pvec(6:(5+Pvec(4)))+1)/2);

res.mlcrv=0;

res.nument=0;

res.clrnmbr=colorNo;
res.color=[0,0,0];

res.well=true;
end