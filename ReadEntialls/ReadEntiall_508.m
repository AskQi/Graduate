function [res]=ReadEntiall_508(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=type;
% 环实体，在国标P402

res.name='环实体';
res.original=1;
res.superior=1;

n=Pvec(2);
res.n=n;

point=2;

for j=1:n
   thisLoopEntity.type=Pvec(point+1);
   thisLoopEntity.edge=Pvec(point+2);
   thisLoopEntity.ndx=Pvec(point+3);
   thisLoopEntity.of=Pvec(point+4);
   k=Pvec(point+5);
   thisLoopEntity.k=k;
   thisLoopEntity.ISOP_CURV=Pvec(point+6:point+k*2+5);
   point=point+k*2+5;
   res.LoopEntity(j)=thisLoopEntity;
end
res.clrnmbr=colorNo;
res.transformationMatrixPtr=transformationMatrixPtr;
res.well=false;
end