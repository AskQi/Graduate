function [res]=ReadEntiall_514(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 壳实体，在国标P405
res.type=type;

res.name='壳实体';
res.original=1;
res.superior=1;

n=Pvec(2);
res.n=n;


point=2;

for j=1:n
   thisFaceEntiall.face=Pvec(point+1);
   thisFaceEntiall.of=Pvec(point+2);
   point=point+2;
   res.FaceEntiall(j)=thisFaceEntiall;
end

res.formNo=formNo;
res.clrnmbr=colorNo;
res.trnsfrmtnmtrx=transformationMatrixPtr;
res.well=true;
end