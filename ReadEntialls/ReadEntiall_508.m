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
   thisLineEntiall.type=Pvec(point+1);
   thisLineEntiall.edge=Pvec(point+2);
   thisLineEntiall.ndx=Pvec(point+3);
   thisLineEntiall.of=Pvec(point+4);
   k=Pvec(point+5);
   thisLineEntiall.k=k;
   thisLineEntiall.ISOP=Pvec(point+6:2:point+k*2+5);
   thisLineEntiall.CURV=Pvec(point+7:2:point+k*2+5);
   point=point+k*2+5;
   res.LineEntiall(j)=thisLineEntiall;
end
res.clrnmbr=colorNo;
res.transformationMatrixPtr=transformationMatrixPtr;
res.well=true;
end