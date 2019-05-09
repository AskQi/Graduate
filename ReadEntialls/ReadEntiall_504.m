function [res]=ReadEntiall_504(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 边实体，在国标P400
res.type=type;

res.name='边实体';
res.original=1;
res.superior=1;

n=Pvec(2);
res.n=n;

point=2;
for j=1:n
   thisEdgeEntiall.curv=Pvec(point+1);
   thisEdgeEntiall.svp=Pvec(point+2);
   thisEdgeEntiall.sv=Pvec(point+3);
   thisEdgeEntiall.tvp=Pvec(point+4);
   thisEdgeEntiall.tv=Pvec(point+5);
   point=point+5;
   res.EdgeEntiall(j)=thisEdgeEntiall;
end
res.formNo=formNo;
res.clrnmbr=colorNo;
res.trnsfrmtnmtrx=transformationMatrixPtr;
res.well=true;
end