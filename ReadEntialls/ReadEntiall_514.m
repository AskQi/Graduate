function [res]=ReadEntiall_514(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=type;
% 壳实体，在国标P405

res.name='壳实体';
res.original=1;
res.superior=1;

n=Pvec(2);
res.n=n;


point=2;

for j=1:n
   thisShellEntity.face=Pvec(point+1);
   thisShellEntity.of=Pvec(point+2);
   point=point+2;
   res.ShellEntity(j)=thisShellEntity;
end

res.formNo=formNo;
res.clrnmbr=colorNo;
res.transformationMatrixPtr=transformationMatrixPtr;
res.well=false;
end