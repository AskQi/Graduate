function [ParameterData,enttyCut]=ConvertEntiall_118(ParameterData,i)
% 直纹面，相关资料在国标P

enttyCut=0;
numPnt=301;
PouterCrv=zeros(3,numPnt);
pntCrvPrms=zeros(1,numPnt);

numSplineVal=25;
splinePnts=zeros(3,numSplineVal);

nrbDeg=2;
numCtrlPnts=40;

knots=zeros(1,nrbDeg+numCtrlPnts+1);
knots((numCtrlPnts+1):end)=1;

CP1=zeros(3,numCtrlPnts);
CP2=zeros(3,numCtrlPnts);

% 第一个曲线
ind=ParameterData{i}.de1;
hasLength=true;

if ParameterData{ind}.type==110
    pntCrvPrms(:)=linspace(0,1,numPnt);
    PouterCrv(1,:)=linspace(ParameterData{ind}.x1,ParameterData{ind}.x2,numPnt);
    PouterCrv(2,:)=linspace(ParameterData{ind}.y1,ParameterData{ind}.y2,numPnt);
    PouterCrv(3,:)=linspace(ParameterData{ind}.z1,ParameterData{ind}.z2,numPnt);
elseif ParameterData{ind}.type==126
    pntCrvPrms(:)=linspace(ParameterData{ind}.v(1),ParameterData{ind}.v(2),numPnt);
    PouterCrv=nrbevalIGES(ParameterData{ind}.nurbs,pntCrvPrms);
    pntCrvPrms=pntCrvPrms-pntCrvPrms(1);
    pntCrvPrms=pntCrvPrms/pntCrvPrms(end);
elseif ParameterData{ind}.type==116
    pntCrvPrms(:)=linspace(0,1,numPnt);
    PouterCrv(1,:)=ParameterData{ind}.x;
    PouterCrv(2,:)=ParameterData{ind}.y;
    PouterCrv(3,:)=ParameterData{ind}.z;
    hasLength=false;
else
    pntCrvPrms(:)=linspace(0,1,numPnt);
    PouterCrv(:)=0;
    hasLength=false;
    ParameterData{i}.well=false;
end

if and(ParameterData{i}.form==0,hasLength)
    pp = spline(1:numPnt,PouterCrv);
    for j=2:numPnt
        splinePnts(:,:)=ppval(pp,linspace(j-1,j,numSplineVal));
        pntCrvPrms(j)=sum(sqrt((splinePnts(1,2:numSplineVal)-splinePnts(1,1:(numSplineVal-1))).^2+(splinePnts(2,2:numSplineVal)-splinePnts(2,1:(numSplineVal-1))).^2));
    end
    pntCrvPrms=cumsum(pntCrvPrms);
    pntCrvPrms=pntCrvPrms/pntCrvPrms(numPnt);
end

ppParams = pchip(linspace(0,1,numPnt),pntCrvPrms);
knots((nrbDeg+2):numCtrlPnts)=ppval(ppParams,(1:(numCtrlPnts-nrbDeg-1))/(numCtrlPnts-nrbDeg));

[NTN,R]=LScrvApp(PouterCrv,nrbDeg,numCtrlPnts,pntCrvPrms,knots);

CP1(:,1)=PouterCrv(:,1);
CP1(:,numCtrlPnts)=PouterCrv(:,numPnt);
CP1(:,2:(numCtrlPnts-1))=(NTN\R)';

% 第二个曲线
ind=ParameterData{i}.de2;
hasLength=true;

if ParameterData{i}.dirflg==1
    if ParameterData{ind}.type==110
        pntCrvPrms(:)=linspace(0,1,numPnt);
        PouterCrv(1,:)=linspace(ParameterData{ind}.x2,ParameterData{ind}.x1,numPnt);
        PouterCrv(2,:)=linspace(ParameterData{ind}.y2,ParameterData{ind}.y1,numPnt);
        PouterCrv(3,:)=linspace(ParameterData{ind}.z2,ParameterData{ind}.z1,numPnt);
    elseif ParameterData{ind}.type==126
        pntCrvPrms(:)=linspace(ParameterData{ind}.v(2),ParameterData{ind}.v(1),numPnt);
        PouterCrv=nrbevalIGES(ParameterData{ind}.nurbs,pntCrvPrms);
        pntCrvPrms(:)=linspace(ParameterData{ind}.v(1),ParameterData{ind}.v(2),numPnt);
        pntCrvPrms=pntCrvPrms-pntCrvPrms(1);
        pntCrvPrms=pntCrvPrms/pntCrvPrms(end);
    elseif ParameterData{ind}.type==116
        pntCrvPrms(:)=linspace(0,1,numPnt);
        PouterCrv(1,:)=ParameterData{ind}.x;
        PouterCrv(2,:)=ParameterData{ind}.y;
        PouterCrv(3,:)=ParameterData{ind}.z;
        hasLength=false;
    else
        pntCrvPrms(:)=linspace(0,1,numPnt);
        PouterCrv(:)=0;
        hasLength=false;
        ParameterData{i}.well=false;
    end
else
    if ParameterData{ind}.type==110
        pntCrvPrms(:)=linspace(0,1,numPnt);
        PouterCrv(1,:)=linspace(ParameterData{ind}.x1,ParameterData{ind}.x2,numPnt);
        PouterCrv(2,:)=linspace(ParameterData{ind}.y1,ParameterData{ind}.y2,numPnt);
        PouterCrv(3,:)=linspace(ParameterData{ind}.z1,ParameterData{ind}.z2,numPnt);
    elseif ParameterData{ind}.type==126
        pntCrvPrms(:)=linspace(ParameterData{ind}.v(1),ParameterData{ind}.v(2),numPnt);
        PouterCrv=nrbevalIGES(ParameterData{ind}.nurbs,pntCrvPrms);
        pntCrvPrms=pntCrvPrms-pntCrvPrms(1);
        pntCrvPrms=pntCrvPrms/pntCrvPrms(end);
    elseif ParameterData{ind}.type==116
        pntCrvPrms(:)=linspace(0,1,numPnt);
        PouterCrv(1,:)=ParameterData{ind}.x;
        PouterCrv(2,:)=ParameterData{ind}.y;
        PouterCrv(3,:)=ParameterData{ind}.z;
        hasLength=false;
    else
        pntCrvPrms(:)=linspace(0,1,numPnt);
        PouterCrv(:)=0;
        hasLength=false;
        ParameterData{i}.well=false;
    end
end

if and(ParameterData{i}.form==0,hasLength)
    pp = spline(1:numPnt,PouterCrv);
    for j=2:numPnt
        splinePnts(:,:)=ppval(pp,linspace(j-1,j,numSplineVal));
        pntCrvPrms(j)=sum(sqrt((splinePnts(1,2:numSplineVal)-splinePnts(1,1:(numSplineVal-1))).^2+(splinePnts(2,2:numSplineVal)-splinePnts(2,1:(numSplineVal-1))).^2));
    end
    pntCrvPrms=cumsum(pntCrvPrms);
    pntCrvPrms=pntCrvPrms/pntCrvPrms(numPnt);
end

[NTN,R]=LScrvApp(PouterCrv,nrbDeg,numCtrlPnts,pntCrvPrms,knots);

CP2(:,1)=PouterCrv(:,1);
CP2(:,numCtrlPnts)=PouterCrv(:,numPnt);
CP2(:,2:(numCtrlPnts-1))=(NTN\R)';


ParameterData{i}.type=128;

ParameterData{i}.name='B-NURBS SRF';
ParameterData{i}.original=0;
ParameterData{i}.previous_type=118;
ParameterData{i}.previous_name='RULED SURFACE';

ParameterData{i}.superior=0;

ParameterData{i}.k1=numCtrlPnts-1;
ParameterData{i}.k2=1;

ParameterData{i}.m1=nrbDeg;
ParameterData{i}.m2=1;

ParameterData{i}.prop1=0;
ParameterData{i}.prop2=0;
ParameterData{i}.prop3=0;
ParameterData{i}.prop4=0;
ParameterData{i}.prop5=0;

ParameterData{i}.s=knots;
ParameterData{i}.t=[0 0 1 1];

ParameterData{i}.w=ones(numCtrlPnts,2);
ParameterData{i}.p=zeros(3,numCtrlPnts,2);
ParameterData{i}.p(:,:,1)=CP1;
ParameterData{i}.p(:,:,2)=CP2;

ParameterData{i}.u=[0,1];
ParameterData{i}.v=[0,1];

ParameterData{i}.isplane=false;


% NURBS曲面

ParameterData{i}.nurbs.form='B-NURBS';
ParameterData{i}.nurbs.dim=4;
ParameterData{i}.nurbs.number=[numCtrlPnts 2];
ParameterData{i}.nurbs.coefs=zeros(4,numCtrlPnts,2);

ParameterData{i}.nurbs.coefs(1:3,:,1)=CP1;
ParameterData{i}.nurbs.coefs(1:3,:,2)=CP2;
ParameterData{i}.nurbs.coefs(4,:,:)=1;

ParameterData{i}.nurbs.knots=cell(1,2);
ParameterData{i}.nurbs.knots{1}=knots;
ParameterData{i}.nurbs.knots{2}=[0 0 1 1];

ParameterData{i}.nurbs.order=[nrbDeg+1 2];

[ParameterData{i}.dnurbs,ParameterData{i}.d2nurbs]=nrbDerivativesIGES(ParameterData{i}.nurbs);

end