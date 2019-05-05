function [res]=ReadEntiall_504(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=type;
% 边实体，在国标P400

res.name='边实体';
res.original=1;
res.superior=1;

n=Pvec(2);
res.n=n;

point=2;
for j=1:n
   thisEdgeEntity.curv=Pvec(point+1);
   thisEdgeEntity.svp=Pvec(point+2);
   thisEdgeEntity.tvp=Pvec(point+3);
   thisEdgeEntity.tv=Pvec(point+4);
   point=point+4;
   res.EdgeEntity(j)=thisEdgeEntity;
end
res.formNo=formNo;
res.clrnmbr=colorNo;
res.transformationMatrixPtr=transformationMatrixPtr;
res.well=true;
end