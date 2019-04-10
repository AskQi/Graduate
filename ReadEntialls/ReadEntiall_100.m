function [res]=ReadEntiall_100(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 相关资料在国标P67
% 缺省参数表表达式：
% C(t) = (X1+R*cost,Y1+R*sint,Z1)
% R = sqrt((X1-X2)^2+(Y1-Y2)^2)；
res.type=type;

zt=Pvec(2);
x1=Pvec(3);
y1=Pvec(4);
x2=Pvec(5);
y2=Pvec(6);
x3=Pvec(7);
y3=Pvec(8);

R=0.5*(sqrt((x2-x1)^2+(y2-y1)^2)+sqrt((x3-x1)^2+(y3-y1)^2));

vmin=atan2(y2-y1,x2-x1);
vmax=atan2(y3-y1,x3-x1);

if vmin<0
    vmin=vmin+2*pi;
end
if vmax<0
    vmax=vmax+2*pi;
end
if vmax<vmin
    vmax=vmax+2*pi;
end
if (vmax-vmin)<1e-12
    vmax=vmax+2*pi;
end

PP=zeros(3,7);

wodd=cos((vmax-vmin)/6);

betavec=linspace(vmin,vmax,7);

eve=true;

for ii=1:7
    
    if eve
        cob=cos(betavec(ii));
        sib=sin(betavec(ii));
        eve=false;
    else
        cob=cos(betavec(ii))/wodd;
        sib=sin(betavec(ii))/wodd;
        eve=true;
    end
    
    PP(1,ii)=R*cob+x1;
    PP(2,ii)=R*sib+y1;
    PP(3,ii)=zt;
    
end

res.name='B-NURBS CRV';
res.original=0;
res.previous_type=100;
res.previous_name='圆弧';

res.zt=zt;
res.x1=x1;
res.y1=y1;
res.x2=x2;
res.y2=y2;
res.x3=x3;
res.y3=y3;

res.k=6;
res.m=2;

res.prop1=1;
res.prop2=0;
res.prop3=0;
res.prop4=0;

res.t=[0 0 0 1/3 1/3 2/3 2/3 1 1 1]*(vmax-vmin)+vmin;

res.w=[1 wodd 1 wodd 1 wodd 1];

res.p=PP;

res.v=[vmin vmax];

res.xnorm=0;
res.ynorm=0;
res.znorm=1;

% NURBS curve

res.nurbs.form='B-NURBS';

res.nurbs.dim=4;

res.nurbs.number=7;

res.nurbs.coefs=zeros(4,7);
res.nurbs.coefs(4,:)=[1 wodd 1 wodd 1 wodd 1];

res.nurbs.coefs(1:3,:)=PP;

res.nurbs.coefs(1:3,:)=repmat(res.nurbs.coefs(4,:),3,1).*res.nurbs.coefs(1:3,:);

res.nurbs.order=3;

res.nurbs.knots=[0 0 0 1/3 1/3 2/3 2/3 1 1 1]*(vmax-vmin)+vmin;

[res.dnurbs,res.d2nurbs]=nrbDerivativesIGES(res.nurbs);

res.length=0;

res.trnsfrmtnmtrx=transformationMatrixPtr;

res.clrnmbr=colorNo;
res.color=[0,0,0];

res.numcrv=1;

res.evalmthd=0;

res.well=true;
end