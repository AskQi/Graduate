function [res]=ReadEntiall_502(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 顶点实体，在国标P399
res.type=type;

res.name='顶点实体';
res.original=1;
res.superior=1;

n=Pvec(2);
res.n=n;

point=2;
for j=1:n
   thisVertexEntiall.x=Pvec(point+1);
   thisVertexEntiall.y=Pvec(point+2);
   thisVertexEntiall.z=Pvec(point+3);
   point=point+3;
   res.VertexEntiall(j)=thisVertexEntiall;
end
res.clrnmbr=colorNo;
res.color=[0,0,0];
res.transformationMatrixPtr=transformationMatrixPtr;
res.well=true;
end