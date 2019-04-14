function [res]=ReadEntiall_112(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=type;
% 在国标P87
res.name='参数样条曲线';
res.original=1;
res.superior=0;

res.ctype=Pvec(2);
res.h=Pvec(3);
res.ndim=Pvec(4);
res.n=Pvec(5);
res.t=Pvec(6:(6+res.n));

res.a2d=zeros(3,4,res.n);

ind=7+res.n;
for jj=1:res.n
    res.a2d(1,:,jj)=Pvec(ind:(ind+3));
    res.a2d(2,:,jj)=Pvec((ind+4):(ind+7));
    res.a2d(3,:,jj)=Pvec((ind+8):(ind+11));
    ind=ind+12;
end
res.tp=Pvec(ind:(ind+11));

breakPointsPP=res.t;

% 将参数样条曲线转换为NURBS曲线
res.type=126;
res.name='B-NURBS曲线';
res.original=0;
res.previous_type=112;
res.previous_name='参数样条曲线';

res.k=2*res.n+1;
res.m=3;

res.prop1=0;
res.prop2=0;
res.prop3=1;
res.prop4=0;

res.t=zeros(1,8+2*(res.n-1));
res.t(1:4)=breakPointsPP(1);
res.t((5+2*(res.n-1)):(8+2*(res.n-1)))=breakPointsPP(res.n+1);

for ii=2:res.n
    res.t(2*ii+1)=breakPointsPP(ii);
    res.t(2*ii+2)=breakPointsPP(ii);
end

res.w=ones(1,2*res.n+2);

CP=zeros(3,2*res.n+2);
splinePoints=zeros(3,4);

if res.n==1
    
    scaling=(breakPointsPP(2)-breakPointsPP(1)).^(0:3);
    
    splinePoints(:,:)=res.a2d(:,:,1);
    splinePoints(1,:)=splinePoints(1,:).*scaling;
    splinePoints(2,:)=splinePoints(2,:).*scaling;
    splinePoints(3,:)=splinePoints(3,:).*scaling;
    
    splinePoints(:,:)=splinePoints*spline2BezierCrvMat;
    
    CP(:,:)=splinePoints;
    
else
    
    scaling=(breakPointsPP(2)-breakPointsPP(1)).^(0:3);
    
    splinePoints(:,:)=res.a2d(:,:,1);
    splinePoints(1,:)=splinePoints(1,:).*scaling;
    splinePoints(2,:)=splinePoints(2,:).*scaling;
    splinePoints(3,:)=splinePoints(3,:).*scaling;
    
    splinePoints(:,:)=splinePoints*spline2BezierCrvMat;
    
    CP(:,1:3)=splinePoints(:,1:3);
    
    for ii=2:(res.n-1)
        
        scaling=(breakPointsPP(ii+1)-breakPointsPP(ii)).^(0:3);
        
        splinePoints(:,:)=res.a2d(:,:,ii);
        splinePoints(1,:)=splinePoints(1,:).*scaling;
        splinePoints(2,:)=splinePoints(2,:).*scaling;
        splinePoints(3,:)=splinePoints(3,:).*scaling;
        
        splinePoints(:,:)=splinePoints*spline2BezierCrvMat;
        
        CP(:,(2*ii):(2*ii+1))=splinePoints(:,2:3);
        
    end
    
    scaling=(breakPointsPP(res.n+1)-breakPointsPP(res.n)).^(0:3);
    
    splinePoints(:,:)=res.a2d(:,:,res.n);
    splinePoints(1,:)=splinePoints(1,:).*scaling;
    splinePoints(2,:)=splinePoints(2,:).*scaling;
    splinePoints(3,:)=splinePoints(3,:).*scaling;
    
    splinePoints(:,:)=splinePoints*spline2BezierCrvMat;
    
    CP(:,(2*res.n):(2*res.n+2))=splinePoints(:,2:4);
    
end

res.p=CP;

res.v=[breakPointsPP(1), breakPointsPP(res.n+1)];

res.xnorm=0;
res.ynorm=0;
res.znorm=1;


% NURBS曲线

res.nurbs.form='B-NURBS';

res.nurbs.dim=4;

res.nurbs.number=2*res.n+2;

res.nurbs.coefs=zeros(4,2*res.n+2);
res.nurbs.coefs(4,:)=1;

res.nurbs.coefs(1:3,:)=CP;

res.nurbs.order=4;

res.nurbs.knots=res.t;

[res.dnurbs,res.d2nurbs]=nrbDerivativesIGES(res.nurbs);

res.length=0;

res.trnsfrmtnmtrx=transformationMatrixPtr;

res.clrnmbr=colorNo;
res.color=[0,0,0];

res.numcrv=1;

res.evalmthd=0;

res.well=true;
end