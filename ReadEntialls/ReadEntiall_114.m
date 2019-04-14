function [res]=ReadEntiall_114(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=type;
% 参数样条曲面，在国标P90
res.name='参数样条曲面';

res.original=1;

res.ctype=Pvec(2);
res.ptype=Pvec(3);

res.m=Pvec(4);
res.n=Pvec(5);

res.tu=Pvec(6:(6+res.m));
res.tv=Pvec((7+res.m):(7+res.m+res.n));

res.a2s=zeros(3,16,res.m,res.n);

ind=8+res.m+res.n;

for ii=1:res.m
    for jj=1:res.n
        res.a2s(1,:,ii,jj)=Pvec(ind:(ind+15));
        res.a2s(2,:,ii,jj)=Pvec((ind+16):(ind+31));
        res.a2s(3,:,ii,jj)=Pvec((ind+32):(ind+47));
        ind=ind+48;
    end
    ind=ind+48;
end
%TODO:转化成NURBS曲面
res.trnsfrmtnmtrx=transformationMatrixPtr;

res.clrnmbr=colorNo;
res.color=[0,0,0];

res.well=false;
end