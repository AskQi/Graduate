function [res]=ReadEntiall_124(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=type;
% 在国标P100

res.name='变换矩阵';

res.r=zeros(3);
res.t=zeros(3,1);

res.r(1,1)=Pvec(2);
res.r(1,2)=Pvec(3);
res.r(1,3)=Pvec(4);

res.t(1)=Pvec(5);

res.r(2,1)=Pvec(6);
res.r(2,2)=Pvec(7);
res.r(2,3)=Pvec(8);

res.t(2)=Pvec(9);

res.r(3,1)=Pvec(10);
res.r(3,2)=Pvec(11);
res.r(3,3)=Pvec(12);

res.t(3)=Pvec(13);

res.original=1;

res.trnsfrmtnmtrx=transformationMatrixPtr;

myEye=res.r*eye(3);
myEye(1,:)=myEye(1,:)+res.t(1);
myEye(2,:)=myEye(2,:)+res.t(2);
myEye(3,:)=myEye(3,:)+res.t(3);
myEye=myEye-eye(3);

if norm(myEye,'fro')<1e-8
    res.isidentity=true;
else
    res.isidentity=false;
end

res.well=true;
end