function [res]=ReadEntiall_104(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=type;
% 在国标P71
A=Pvec(2);
B=Pvec(3);
C=Pvec(4);
D=Pvec(5);
E=Pvec(6);
F=Pvec(7);
ZT=Pvec(8);
X1=Pvec(9);
Y1=Pvec(10);
X2=Pvec(11);
Y2=Pvec(12);

Q=[A 0.5*B;0.5*B C];

[P,Dig] = eig(Q);

if and(Dig(1,1)>1e-6,Dig(2,2)>1e-6)
    
    iDig=[1/Dig(1,1) 0;0 1/Dig(2,2)];
    
    R2=0.25*[D E]*P*iDig*P'*[D;E]-F;
    
    sqD11=sqrt(Dig(1,1));
    sqD22=sqrt(Dig(2,2));
    
    t=0.5*iDig*P'*[D;E];
    
    if det(P)>0
        pst=P'*[X1;Y1]+t;
        pen=P'*[X2;Y2]+t;
    else
        pen=P'*[X1;Y1]+t;
        pst=P'*[X2;Y2]+t;
    end
    
    pst(1)=pst(1)*sqD11;
    pst(2)=pst(2)*sqD22;
    
    pen(1)=pen(1)*sqD11;
    pen(2)=pen(2)*sqD22;
    
    if det([pst pen])<=0
        beta=2*pi-acos(dot(pst,pen)/R2);
    else
        beta=acos(dot(pst,pen)/R2);
    end
    
    if beta<1e-12
        beta=2*pi;
    end
    
    wodd=cos(beta/6);
    
    P0=pst;
    
    P1=[cos(beta/6) -sin(beta/6);sin(beta/6) cos(beta/6)]*pst/wodd;
    
    P2=[cos(beta/3) -sin(beta/3);sin(beta/3) cos(beta/3)]*pst;
    
    P3=[cos(beta/2) -sin(beta/2);sin(beta/2) cos(beta/2)]*pst/wodd;
    
    P4=[cos(2*beta/3) -sin(2*beta/3);sin(2*beta/3) cos(2*beta/3)]*pst;
    
    P5=[cos(5*beta/6) -sin(5*beta/6);sin(5*beta/6) cos(5*beta/6)]*pst/wodd;
    
    P6=pen;
    
    PP=[P0 P1 P2 P3 P4 P5 P6;ZT*ones(1,7)];
    
    PP(1,:)=PP(1,:)/sqD11-t(1);
    PP(2,:)=PP(2,:)/sqD22-t(2);
    PP(1:2,:)=P*PP(1:2,:);
    
    res.type=126;
    
    res.name='B-NURBS CRV';
    res.original=0;
    res.previous_type=104;
    res.previous_name='圆锥曲线弧';
    
    res.k=6;
    res.m=2;
    
    res.prop1=1;
    res.prop2=0;
    res.prop3=0;
    res.prop4=0;
    
    res.t=[0 0 0 1 1 2 2 3 3 3];
    
    res.w=[1 wodd 1 wodd 1 wodd 1];
    
    res.p=PP;
    
    res.v=[0 3];
    
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
    
    res.nurbs.knots=[0 0 0 1 1 2 2 3 3 3];
    
    [res.dnurbs,res.d2nurbs]=nrbDerivativesIGES(res.nurbs);
    
    res.length=0;
    
    res.trnsfrmtnmtrx=transformationMatrixPtr;
    
    res.clrnmbr=colorNo;
    res.color=[0,0,0];
    
    res.numcrv=1;
    
    res.evalmthd=0;
    
    res.well=true;
    
    clear PP nup p len iDig
    
else
    
    p1=[X1;Y1;ZT];
    p2=[X2;Y2;ZT];
    
    res.type=110;
    
    res.name='直线';
    res.original=0;
    res.previous_type=104;
    res.previous_name='圆锥曲线弧';
    
    res.p1=p1;
    res.x1=p1(1);
    res.y1=p1(2);
    res.z1=p1(3);
    
    res.p2=p2;
    res.x2=p2(1);
    res.y2=p2(2);
    res.z2=p2(3);
    
    res.length=0;
    
    res.trnsfrmtnmtrx=transformationMatrixPtr;
    
    res.clrnmbr=colorNo;
    res.color=[0,0,0];
    
    res.numcrv=1;
    
    res.evalmthd=0;
    
    res.well=false;
    
end

res.a=A;
res.b=B;
res.c=C;
res.d=D;
res.e=E;
res.f=F;
res.zt=ZT;
res.x1=X1;
res.y1=Y1;
res.x2=X2;
res.y2=Y2;

end