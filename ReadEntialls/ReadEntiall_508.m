function [res]=ReadEntiall_508(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 环实体，在国标P402
res.type=type;

res.name='环实体';
res.original=1;
res.superior=1;

n=Pvec(2);
res.n=n;

point=2;

for j=1:n
   thisLineAndEdgeEntiall.type=Pvec(point+1);
   thisLineAndEdgeEntiall.edge=Pvec(point+2);
   thisLineAndEdgeEntiall.ndx=Pvec(point+3);
   thisLineAndEdgeEntiall.of=Pvec(point+4);
   k=Pvec(point+5);
   thisLineAndEdgeEntiall.k=k;
   thisLineAndEdgeEntiall.ISOP=Pvec(point+6:2:point+k*2+5);
   thisLineAndEdgeEntiall.CURV=Pvec(point+7:2:point+k*2+5);
   point=point+k*2+5;
   res.LineAndEdgeEntiall(j)=thisLineAndEdgeEntiall;
end
res.clrnmbr=colorNo;
res.trnsfrmtnmtrx=transformationMatrixPtr;
res.well=true;
end