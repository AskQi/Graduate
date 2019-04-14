function [res]=ReadEntiall_126(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=type;
% 有理B样条曲线，在国标P107
A=1+Pvec(2)+Pvec(3);

res.name='有理B样条曲线';
res.original=1;
res.superior=0;

res.k=Pvec(2);
res.m=Pvec(3);

res.prop1=Pvec(4);
res.prop2=Pvec(5);
res.prop3=Pvec(6);
res.prop4=Pvec(7);

res.t=Pvec(8:(8+A));
res.w=Pvec((9+A):(9+A+Pvec(2)));
res.p=reshape(Pvec((10+A+Pvec(2)):(12+A+4*Pvec(2))),3,Pvec(2)+1);

res.v=zeros(1,2);
res.v(1)=Pvec(13+A+4*Pvec(2));
res.v(2)=Pvec(14+A+4*Pvec(2));

if Pvec(4)
    res.xnorm=Pvec(15+A+4*Pvec(2));
    res.ynorm=Pvec(16+A+4*Pvec(2));
    res.znorm=Pvec(17+A+4*Pvec(2));
else
    res.xnorm=0;
    res.ynorm=0;
    res.znorm=0;
end
%NURBS曲线
res.nurbs.form='B-NURBS';

res.nurbs.dim=4;

res.nurbs.number=Pvec(2)+1;

res.nurbs.coefs=zeros(4,Pvec(2)+1);
res.nurbs.coefs(4,:)=Pvec((9+A):(9+A+Pvec(2)));

res.nurbs.coefs(1:3,:)=res.p;

res.nurbs.coefs(1:3,:)=repmat(res.nurbs.coefs(4,:),3,1).*res.nurbs.coefs(1:3,:);

res.nurbs.order=Pvec(3)+1;

res.nurbs.knots=Pvec(8:(8+A));

[res.dnurbs,res.d2nurbs]=nrbDerivativesIGES(res.nurbs);

res.length=0;

res.trnsfrmtnmtrx=transformationMatrixPtr;

res.clrnmbr=colorNo;
res.color=[0,0,0];

res.numcrv=1;

res.evalmthd=0;

res.well=true;
end