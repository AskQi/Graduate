function [res]=ReadEntiall_186(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% ����ʵ��B-Rep����ʵ�壬�ڹ���P158
res.type=type;

res.name='����ʵ��B-Rep����ʵ��';
res.original=1;
res.superior=1;

res.shell=Pvec(2);
res.sof=Pvec(3);

n=Pvec(4);
res.n=n;

point=4;
for j=1:n
   thisVoidShellEntity.void=Pvec(point+1);
   thisVoidShellEntity.vof=Pvec(point+2);
   point=point+2;
   res.VoidShellEntity(j)=thisVoidShellEntity;
end

res.clrnmbr=colorNo;
res.color=[0,0,0];
res.trnsfrmtnmtrx=transformationMatrixPtr;
res.well=true;
end