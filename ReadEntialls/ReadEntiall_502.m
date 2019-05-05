function [res]=ReadEntiall_502(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=type;
% 顶点实体，在国标P399

res.name='顶点实体';
res.original=1;
res.superior=1;

n=Pvec(2);
res.n=n;

point=2;
for j=1:n
   thisVertexEntity.x=Pvec(point+1);
   thisVertexEntity.y=Pvec(point+2);
   thisVertexEntity.z=Pvec(point+3);
   point=point+3;
   res.VertexEntity(j)=thisVertexEntity;
end
res.colorNo=colorNo;
res.transformationMatrixPtr=transformationMatrixPtr;
res.well=false;
end