function [trimCRVS,uInterval,vInterval,numCrv,allLines,domainIsRectangle]=findBoundaryInNURBSParameterSpace(ParameterData,ind,bCptr)

entiall=ParameterData{ind}.pts;

nu=150;
nv=150;
[Pcomp,UVcomp]=nrbSrfRegularEvalIGES(ParameterData{entiall}.nurbs,ParameterData{entiall}.u(1),ParameterData{entiall}.u(2),nu,ParameterData{entiall}.v(1),ParameterData{entiall}.v(2),nv);

uInterval=[ParameterData{entiall}.u(2),ParameterData{entiall}.u(1)];
vInterval=[ParameterData{entiall}.v(2),ParameterData{entiall}.v(1)];

dU=abs(uInterval(2)-uInterval(1));
dV=abs(vInterval(2)-vInterval(1));
pspaceD=dU^2+dV^2;

numSplineVal=20;
splinePnts=zeros(2,numSplineVal);

nrbDeg=2;

if ParameterData{bCptr}.type==102
    
    numCrv=ParameterData{bCptr}.n;
    
    trimCRVS=cell(1,numCrv);
    
    numPnt=501;
    
    UV0=zeros(2,numPnt);
    PouterCrv=zeros(3,numPnt);
    
    numCtrlPnts=30;
    
    knots=zeros(1,nrbDeg+numCtrlPnts+1);
    knots((numCtrlPnts+1):end)=1;
    
    pntCrvPrms=zeros(1,numPnt);
    
    CP=zeros(4,numCtrlPnts);
    CP(4,:)=1;
    
    allLines=true;
    
    for jj=1:numCrv
        
        PouterCrv(:,:)=retSrfCrvPnt(2,ParameterData,1,ParameterData{bCptr}.de(jj),numPnt,3);
        
        for j=1:numPnt
            [~,miind]=min((Pcomp(1,:)-PouterCrv(1,j)).^2+(Pcomp(2,:)-PouterCrv(2,j)).^2+(Pcomp(3,:)-PouterCrv(3,j)).^2);
            UV0(:,j)=UVcomp(:,miind);
        end
        
        [~,UV]=closestNrbLinePointIGES(ParameterData{entiall}.nurbs,ParameterData{entiall}.dnurbs,ParameterData{entiall}.d2nurbs,UV0,PouterCrv);
        
        uInterval(1)=min(uInterval(1),min(UV(1,:)));
        uInterval(2)=max(uInterval(2),max(UV(1,:)));
        
        vInterval(1)=min(vInterval(1),min(UV(2,:)));
        vInterval(2)=max(vInterval(2),max(UV(2,:)));
        
        meaUV=mean(UV,2);
        
        singVals=svd(UV*UV'-(numPnt*meaUV)*meaUV');
        
        if or(1e6*singVals(2)<singVals(1),1e6*singVals(1)<pspaceD)
            
            trimCRVS{jj}.type=110;
            
            trimCRVS{jj}.name='LINE';
            trimCRVS{jj}.original=0;
            
            trimCRVS{jj}.superior=1;
            
            trimCRVS{jj}.form=0;
            
            trimCRVS{jj}.p1=[UV(:,1);0];
            trimCRVS{jj}.x1=UV(1,1);
            trimCRVS{jj}.y1=UV(2,1);
            trimCRVS{jj}.z1=0;
            
            trimCRVS{jj}.p2=[UV(:,numPnt);0];
            trimCRVS{jj}.x2=UV(1,numPnt);
            trimCRVS{jj}.y2=UV(2,numPnt);
            trimCRVS{jj}.z2=0;
            
            trimCRVS{jj}.length=0;
            
            trimCRVS{jj}.evalmthd=0;
            
            trimCRVS{jj}.well=true;
            
        else
            
            allLines=false;
            
            pp = spline(1:numPnt,UV);
            
            for j=2:numPnt
                splinePnts(:,:)=ppval(pp,linspace(j-1,j,numSplineVal));
                pntCrvPrms(j)=sum(sqrt((splinePnts(1,2:numSplineVal)-splinePnts(1,1:(numSplineVal-1))).^2+(splinePnts(2,2:numSplineVal)-splinePnts(2,1:(numSplineVal-1))).^2));
            end
            pntCrvPrms=cumsum(pntCrvPrms);
            pntCrvPrms=pntCrvPrms/pntCrvPrms(numPnt);
            
            ppParams = pchip(linspace(0,1,numPnt),pntCrvPrms);
            
            knots((nrbDeg+2):numCtrlPnts)=ppval(ppParams,(1:(numCtrlPnts-nrbDeg-1))/(numCtrlPnts-nrbDeg));
            
            [NTN,R]=LScrvApp(UV,nrbDeg,numCtrlPnts,pntCrvPrms,knots);
            
            CP(1:2,1)=UV(:,1);
            CP(1:2,numCtrlPnts)=UV(:,numPnt);
            CP(1:2,2:(numCtrlPnts-1))=(NTN\R)';
            
            trimCRVS{jj}.type=126;
            trimCRVS{jj}.name='B-NURBS CRV';
            trimCRVS{jj}.original=0;
            trimCRVS{jj}.superior=1;
            trimCRVS{jj}.k=numCtrlPnts-1;
            trimCRVS{jj}.m=nrbDeg;
            
            trimCRVS{jj}.prop1=1;
            trimCRVS{jj}.prop2=1;
            trimCRVS{jj}.prop3=1;
            trimCRVS{jj}.prop4=1;
            
            trimCRVS{jj}.t=knots;
            trimCRVS{jj}.w=CP(4,:);
            trimCRVS{jj}.p=CP(1:3,:);
            
            trimCRVS{jj}.v=[0,1];
            
            trimCRVS{jj}.xnorm=0;
            trimCRVS{jj}.ynorm=0;
            trimCRVS{jj}.znorm=1;
            
            trimCRVS{jj}.nurbs.form='B-NURBS';
            trimCRVS{jj}.nurbs.dim=4;
            trimCRVS{jj}.nurbs.number=numCtrlPnts;
            trimCRVS{jj}.nurbs.coefs=CP;
            trimCRVS{jj}.nurbs.order=nrbDeg+1;
            trimCRVS{jj}.nurbs.knots=knots;
            
            [trimCRVS{jj}.dnurbs,trimCRVS{jj}.d2nurbs]=nrbDerivativesIGES(trimCRVS{jj}.nurbs);
            
            trimCRVS{jj}.length=0;
            
            trimCRVS{jj}.evalmthd=0;
            
            trimCRVS{jj}.well=true;
            
        end
        
    end
    
else
    
    numCrv=1;
    trimCRVS=cell(1,numCrv);
    
    numPnt=1001;
    
    UV0=zeros(2,numPnt);
    PouterCrv=zeros(3,numPnt);
    
    numCtrlPnts=75;
    
    knots=zeros(1,nrbDeg+numCtrlPnts+1);
    knots((numCtrlPnts+1):end)=1;
    
    pntCrvPrms=zeros(1,numPnt);
    
    CP=zeros(4,numCtrlPnts);
    CP(4,:)=1;
    
    allLines=false;
    
    PouterCrv(:,:)=retSrfCrvPnt(2,ParameterData,1,bCptr,numPnt,3);
    
    for j=1:numPnt
        [~,miind]=min((Pcomp(1,:)-PouterCrv(1,j)).^2+(Pcomp(2,:)-PouterCrv(2,j)).^2+(Pcomp(3,:)-PouterCrv(3,j)).^2);
        UV0(:,j)=UVcomp(:,miind);
    end
    
    [~,UV]=closestNrbLinePointIGES(ParameterData{entiall}.nurbs,ParameterData{entiall}.dnurbs,ParameterData{entiall}.d2nurbs,UV0,PouterCrv);
    
    uInterval(1)=min(uInterval(1),min(UV(1,:)));
    uInterval(2)=max(uInterval(2),max(UV(1,:)));
    
    vInterval(1)=min(vInterval(1),min(UV(2,:)));
    vInterval(2)=max(vInterval(2),max(UV(2,:)));
    
    pp = spline(1:numPnt,UV);
    
    for j=2:numPnt
        splinePnts(:,:)=ppval(pp,linspace(j-1,j,numSplineVal));
        pntCrvPrms(j)=sum(sqrt((splinePnts(1,2:numSplineVal)-splinePnts(1,1:(numSplineVal-1))).^2+(splinePnts(2,2:numSplineVal)-splinePnts(2,1:(numSplineVal-1))).^2));
    end
    pntCrvPrms=cumsum(pntCrvPrms);
    pntCrvPrms=pntCrvPrms/pntCrvPrms(numPnt);
    
    ppParams = pchip(linspace(0,1,numPnt),pntCrvPrms);
    
    knots((nrbDeg+2):numCtrlPnts)=ppval(ppParams,(1:(numCtrlPnts-nrbDeg-1))/(numCtrlPnts-nrbDeg));
    
    [NTN,R]=LScrvApp(UV,nrbDeg,numCtrlPnts,pntCrvPrms,knots);
    
    CP(1:2,1)=UV(:,1);
    CP(1:2,numCtrlPnts)=UV(:,numPnt);
    CP(1:2,2:(numCtrlPnts-1))=(NTN\R)';
    
    trimCRVS{1}.type=126;
    trimCRVS{1}.name='B-NURBS CRV';
    trimCRVS{1}.original=0;
    trimCRVS{1}.superior=1;
    trimCRVS{1}.k=numCtrlPnts-1;
    trimCRVS{1}.m=nrbDeg;
    
    trimCRVS{1}.prop1=1;
    trimCRVS{1}.prop2=1;
    trimCRVS{1}.prop3=1;
    trimCRVS{1}.prop4=1;
    
    trimCRVS{1}.t=knots;
    trimCRVS{1}.w=CP(4,:);
    trimCRVS{1}.p=CP(1:3,:);
    
    trimCRVS{1}.v=[0,1];
    
    trimCRVS{1}.xnorm=0;
    trimCRVS{1}.ynorm=0;
    trimCRVS{1}.znorm=1;
    
    trimCRVS{1}.nurbs.form='B-NURBS';
    trimCRVS{1}.nurbs.dim=4;
    trimCRVS{1}.nurbs.number=numCtrlPnts;
    trimCRVS{1}.nurbs.coefs=CP;
    trimCRVS{1}.nurbs.order=nrbDeg+1;
    trimCRVS{1}.nurbs.knots=knots;
    
    [trimCRVS{1}.dnurbs,trimCRVS{1}.d2nurbs]=nrbDerivativesIGES(trimCRVS{1}.nurbs);
    
    trimCRVS{1}.length=0;
    
    trimCRVS{1}.evalmthd=0;
    
    trimCRVS{1}.well=true;
    
end

if allLines
    
    domainIsRectangle=true;
    
    for jj=1:numCrv
        
        if and(abs(trimCRVS{jj}.x2-trimCRVS{jj}.x1)>1e-4*dU,abs(trimCRVS{jj}.y2-trimCRVS{jj}.y1)>1e-4*dV)
            domainIsRectangle=false;
            break
        elseif and(and((trimCRVS{jj}.x1-uInterval(1))>1e-4*dU,(uInterval(2)-trimCRVS{jj}.x1)>1e-4*dU),and((trimCRVS{jj}.y1-vInterval(1))>1e-4*dV,(vInterval(2)-trimCRVS{jj}.y1)>1e-4*dV))
            domainIsRectangle=false;
            break
        elseif and(and((trimCRVS{jj}.x2-uInterval(1))>1e-4*dU,(uInterval(2)-trimCRVS{jj}.x2)>1e-4*dU),and((trimCRVS{jj}.y2-vInterval(1))>1e-4*dV,(vInterval(2)-trimCRVS{jj}.y2)>1e-4*dV))
            domainIsRectangle=false;
            break
        end
        
    end
    
else
    
    domainIsRectangle=false;
    
end