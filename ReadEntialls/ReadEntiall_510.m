function [res]=ReadEntiall_510(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=type;
% ��ʵ�壬�ڹ���P403

res.name='��ʵ��';
res.original=1;
res.superior=1;

res.surf=Pvec(2);

n=Pvec(3);
res.n=n;

res.of=Pvec(4);

res.loop=Pvec(5:n+4);

res.colorNo=colorNo;
res.transformationMatrixPtr=transformationMatrixPtr;
res.well=false;
end