function [res]=ReadEntiall_186(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 流形实体B-Rep对象实体，在国标P158
res.type=type;

res.name='流形实体B-Rep对象实体';
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