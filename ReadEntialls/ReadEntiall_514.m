function [res]=ReadEntiall_514(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=type;
% ��ʵ�壬�ڹ���P405

res.name='��ʵ��';
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
res.transformationMatrixPtr=transformationMatrixPtr;
res.well=true;
end