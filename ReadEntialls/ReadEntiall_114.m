function [res]=ReadEntiall_114(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 参数样条曲面，在国标P90
res.type=type;
global mat3x3
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
% 转化成NURBS曲面
res.type=128;
res.name='B-NURBS曲面';
res.original=1;

res.previous_type=114;
res.previous_name='参数样条曲面';

res.k1=2*res.m+1;
res.k2=2*res.n+1;
res.m1=3;
res.m2=3;

res.prop1=0;
res.prop2=0;
res.prop3=1;
res.prop4=0;
res.prop5=0;

res.superior=0;

res.s=zeros(1,8+2*(res.m-1));
res.s(1:4)=res.tu(1);
res.s((5+2*(res.m-1)):(8+2*(res.m-1)))=res.tu(res.m+1);

res.t=zeros(1,8+2*(res.n-1));
res.t(1:4)=res.tv(1);
res.t((5+2*(res.n-1)):(8+2*(res.n-1)))=res.tv(res.n+1);

for ii=2:res.m
    res.s(2*ii+1)=res.tu(ii);
    res.s(2*ii+2)=res.tu(ii);
end
for ii=2:res.n
    res.t(2*ii+1)=res.tv(ii);
    res.t(2*ii+2)=res.tv(ii);
end

CP=zeros(3,2*res.m+2,2*res.n+2);
splinePoints=zeros(3,16);

if res.m==1
    
    len=res.tu(2)-res.tu(1);
    
    if res.n==1
        
        [scaleV,scaleU]=meshgrid((res.tv(2)-res.tv(1)).^(0:3),len.^(0:3));
        scaling=(scaleV(:).*scaleU(:))';
        
        splinePoints(:,:)=res.a2s(:,:,1,1);
        splinePoints(1,:)=splinePoints(1,:).*scaling;
        splinePoints(2,:)=splinePoints(2,:).*scaling;
        splinePoints(3,:)=splinePoints(3,:).*scaling;
        
        splinePoints(:,:)=splinePoints*spline2BezierSrfMat;
        
        CP(:,:)=splinePoints;
        
    else
        
        [scaleV,scaleU]=meshgrid((res.tv(2)-res.tv(1)).^(0:3),len.^(0:3));
        scaling=(scaleV(:).*scaleU(:))';
        
        splinePoints(:,:)=res.a2s(:,:,1,1);
        splinePoints(1,:)=splinePoints(1,:).*scaling;
        splinePoints(2,:)=splinePoints(2,:).*scaling;
        splinePoints(3,:)=splinePoints(3,:).*scaling;
        
        splinePoints(:,:)=splinePoints*spline2BezierSrfMat;
        
        CP(:,1:12)=splinePoints(:,1:12);
        
        for jj=2:(res.n-1)
            
            [scaleV,scaleU]=meshgrid((res.tv(jj+1)-res.tv(jj)).^(0:3),len.^(0:3));
            scaling=(scaleV(:).*scaleU(:))';
            
            splinePoints(:,:)=res.a2s(:,:,1,jj);
            splinePoints(1,:)=splinePoints(1,:).*scaling;
            splinePoints(2,:)=splinePoints(2,:).*scaling;
            splinePoints(3,:)=splinePoints(3,:).*scaling;
            
            splinePoints(:,:)=splinePoints*spline2BezierSrfMat;
            
            CP(:,(8*jj-3):(8*jj+4))=splinePoints(:,5:12);
            
        end
        
        [scaleV,scaleU]=meshgrid((res.tv(res.n+1)-res.tv(res.n)).^(0:3),len.^(0:3));
        scaling=(scaleV(:).*scaleU(:))';
        
        splinePoints(:,:)=res.a2s(:,:,1,res.n);
        splinePoints(1,:)=splinePoints(1,:).*scaling;
        splinePoints(2,:)=splinePoints(2,:).*scaling;
        splinePoints(3,:)=splinePoints(3,:).*scaling;
        
        splinePoints(:,:)=splinePoints*spline2BezierSrfMat;
        
        CP(:,(8*res.n-3):(8*res.n+8))=splinePoints(:,5:16);
        
    end
    
elseif res.n==1
    
    len=res.tv(2)-res.tv(1);
    
    [scaleV,scaleU]=meshgrid(len.^(0:3),(res.tu(2)-res.tu(1)).^(0:3));
    scaling=(scaleV(:).*scaleU(:))';
    
    splinePoints(:,:)=res.a2s(:,:,1,1);
    splinePoints(1,:)=splinePoints(1,:).*scaling;
    splinePoints(2,:)=splinePoints(2,:).*scaling;
    splinePoints(3,:)=splinePoints(3,:).*scaling;
    
    splinePoints(:,:)=splinePoints*spline2BezierSrfMat;
    
    CP(:,1:3,1)=splinePoints(:,1:3);
    CP(:,1:3,2)=splinePoints(:,5:7);
    CP(:,1:3,3)=splinePoints(:,9:11);
    CP(:,1:3,4)=splinePoints(:,13:15);
    
    for ii=2:(res.m-1)
        
        [scaleV,scaleU]=meshgrid(len.^(0:3),(res.tu(ii+1)-res.tu(ii)).^(0:3));
        scaling=(scaleV(:).*scaleU(:))';
        
        splinePoints(:,:)=res.a2s(:,:,ii,1);
        splinePoints(1,:)=splinePoints(1,:).*scaling;
        splinePoints(2,:)=splinePoints(2,:).*scaling;
        splinePoints(3,:)=splinePoints(3,:).*scaling;
        
        splinePoints(:,:)=splinePoints*spline2BezierSrfMat;
        
        CP(:,(2*ii):(2*ii+1),1)=splinePoints(:,2:3);
        CP(:,(2*ii):(2*ii+1),2)=splinePoints(:,6:7);
        CP(:,(2*ii):(2*ii+1),3)=splinePoints(:,10:11);
        CP(:,(2*ii):(2*ii+1),4)=splinePoints(:,14:15);
        
    end
    
    [scaleV,scaleU]=meshgrid(len.^(0:3),(res.tu(res.m+1)-res.tu(res.m)).^(0:3));
    scaling=(scaleV(:).*scaleU(:))';
    
    splinePoints(:,:)=res.a2s(:,:,res.m,1);
    splinePoints(1,:)=splinePoints(1,:).*scaling;
    splinePoints(2,:)=splinePoints(2,:).*scaling;
    splinePoints(3,:)=splinePoints(3,:).*scaling;
    
    splinePoints(:,:)=splinePoints*spline2BezierSrfMat;
    
    CP(:,(2*res.m):(2*res.m+2),1)=splinePoints(:,2:4);
    CP(:,(2*res.m):(2*res.m+2),2)=splinePoints(:,6:8);
    CP(:,(2*res.m):(2*res.m+2),3)=splinePoints(:,10:12);
    CP(:,(2*res.m):(2*res.m+2),4)=splinePoints(:,14:16);
    
else
    
    disp('警告: 处理114实体时出现异常');
    
end

res.w=ones(2*res.m+2,2*res.n+2);
res.p=CP;

res.u=[res.tu(1),res.tu(res.m+1)];
res.v=[res.tv(1),res.tv(res.n+1)];

ulinear=1;
for k=1:(res.k2+1)
    meaP=mean(res.p(:,:,k),2);
    Si=svd(res.p(:,:,k)*res.p(:,:,k)'-((res.k1+1)*meaP)*meaP');
    if Si(2)*1e6>Si(1)
        ulinear=0;
        break
    end
end
if ulinear
    vlinear=0;
else
    vlinear=1;
    for j=1:(res.k1+1)
        meaP(:)=0;
        mat3x3(:)=0;
        for k=1:(res.k2+1)
            meaP=meaP+res.p(:,j,k);
            mat3x3=mat3x3+res.p(:,j,k)*res.p(:,j,k)';
        end
        Si=svd((res.k2+1)*mat3x3-meaP*meaP');
        if Si(2)*1e6>Si(1)
            vlinear=0;
            break
        end
    end
end
res.isplane=false;
res.ulinear=ulinear;
res.vlinear=vlinear;

% NURBS surface

res.nurbs.form='B-NURBS';

res.nurbs.dim=4;

res.nurbs.number=[2*res.m+2,2*res.n+2];

res.nurbs.coefs=zeros(4,2*res.m+2,2*res.n+2);
res.nurbs.coefs(4,:,:)=1;
res.nurbs.coefs(1:3,:,:)=CP;

res.nurbs.knots=cell(1,2);
res.nurbs.knots{1}=res.s;
res.nurbs.knots{2}=res.t;

res.nurbs.order=[4,4];

[res.dnurbs,res.d2nurbs]=nrbDerivativesIGES(res.nurbs);

res.ratio=[0,0];


res.trnsfrmtnmtrx=transformationMatrixPtr;

res.clrnmbr=colorNo;
res.color=[0,0,0];

res.well=false;
end