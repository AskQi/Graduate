function [res]=ReadEntiall_186(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=type;
% ����ʵ��B-Rep����ʵ�壬�ڹ���P158

res.name='����ʵ��B-Rep����ʵ��';
res.original=1;
res.superior=1;

res.shell=Pvec(2);
res.sof=Pvec(3);

n=Pvec(4);
res.n=n;

point=4;
for j=1:n
   thisMSBOEntity.void=Pvec(point+1);
   thisMSBOEntity.vof=Pvec(point+2);
   point=point+2;
   res.MSBOEntity(j)=thisMSBOEntity;
end

res.clrnmbr=colorNo;
res.color=[0,0,0];
res.transformationMatrixPtr=transformationMatrixPtr;
res.well=true;
end