function [trimCRVS,numCrv,cInterval,aInterval,anglInterval,allLines,domainIsRectangle]=findBoundaryInParameterSpace120(ParameterData,ind,bCptr)

srfind=ParameterData{ind}.pts;

miA=ParameterData{srfind}.ta;
maA=ParameterData{srfind}.sa;

miR=ParameterData{srfind}.revolution.rnurbs.knots(end);
maR=ParameterData{srfind}.revolution.rnurbs.knots(1);

miC=ParameterData{srfind}.revolution.cnurbs.knots(end);
maC=ParameterData{srfind}.revolution.cnurbs.knots(1);

numPntComp=401;

ccpar=linspace(maC,miC,numPntComp);
compPnts=nrbevalIGES(ParameterData{srfind}.revolution.cnurbs,ccpar);
planeConstComp=ParameterData{srfind}.revolution.v'*compPnts;
compDist=zeros(1,numPntComp);

for i=1:numPntComp
    compDist(i)=norm(cross(ParameterData{srfind}.revolution.v,compPnts(:,i)-ParameterData{srfind}.revolution.p));
end

numSplineVal=50;
splinePnts=zeros(2,numSplineVal);

nrbDeg=2;

vmin=ParameterData{srfind}.sa;
vmax=ParameterData{srfind}.ta;
vdiff=vmax-vmin;
vdiffCh=max((2*pi-vdiff)/2,1e-6);


if ParameterData{bCptr}.type==102
    
    numPnt=251;
    
    numCrv=ParameterData{bCptr}.n;
    angl=zeros(1,numPnt);
    cparams0=zeros(1,numPnt);
    UV=zeros(2,numPnt);
    rPoints=zeros(3,numPnt);
    
    planeConst=zeros(1,numPnt);
    pntLdist=zeros(1,numPnt);
    
    numCtrlPnts=15;
    
    knots=zeros(1,nrbDeg+numCtrlPnts+1);
    knots((numCtrlPnts+1):end)=1;
    
    pntCrvPrms=zeros(1,numPnt);
    
    CP=zeros(4,numCtrlPnts);
    CP(4,:)=1;
    
    trimCRVS=cell(1,numCrv);
    
    allLines=true;
    
    if vdiff>6.28
        
        cnotclosed=false;
        
        relAnglDiff=0;
        anglMin=zeros(1,numCrv);
        anglMax=zeros(1,numCrv);
        
        for jj=1:numCrv
            
            PouterCrv=retSrfCrvPnt(2,ParameterData,1,ParameterData{bCptr}.de(jj),numPnt,3);
            
            for i=1:numPnt
                pntLdist(i)=norm(cross(ParameterData{srfind}.revolution.v,PouterCrv(:,i)-ParameterData{srfind}.revolution.p));
            end
            
            [maDist,iind]=max(pntLdist);
            
            P1=ParameterData{srfind}.revolution.R*PouterCrv(:,iind)+ParameterData{srfind}.revolution.T;
            angl(iind)=atan2(P1(2),P1(1));
            
            for i=(iind+1):numPnt
                if pntLdist(i)>maDist*1e-6
                    P1=ParameterData{srfind}.revolution.R*PouterCrv(:,i)+ParameterData{srfind}.revolution.T;
                    a1=atan2(P1(2),P1(1));
                    if a1-angl(i-1)>pi
                        angl(i)=a1-2*pi;
                    elseif a1-angl(i-1)<-pi
                        angl(i)=a1+2*pi;
                    else
                        angl(i)=a1;
                    end
                else
                    angl(i)=angl(i-1);
                end
            end
            
            for i=(iind-1):-1:1
                if pntLdist(i)>maDist*1e-6
                    P1=ParameterData{srfind}.revolution.R*PouterCrv(:,i)+ParameterData{srfind}.revolution.T;
                    a1=atan2(P1(2),P1(1));
                    if a1-angl(i+1)>pi
                        angl(i)=a1-2*pi;
                    elseif a1-angl(i+1)<-pi
                        angl(i)=a1+2*pi;
                    else
                        angl(i)=a1;
                    end
                else
                    angl(i)=angl(i+1);
                end
            end
            
            if jj>1
                [~,iind]=min(abs([angl(1)-2*pi-anglEnd,angl(1)-anglEnd,angl(1)+2*pi-anglEnd]));
                relAnglDiff=relAnglDiff+angl(1)+(iind-2)*2*pi-anglEnd;
            end
            
            adiff=angl(numPnt)-angl(1);
            anglMin(jj)=relAnglDiff+min(angl)-angl(1);
            anglMax(jj)=relAnglDiff+max(angl)-angl(1);
            relAnglDiff=relAnglDiff+adiff;
            anglEnd=angl(numPnt);
            
        end
        
        a1=max(anglMax);
        a2=min(anglMin);
        adiff=(a1-a2)*1e-3;
        isAmax=anglMax>(a1-adiff);
        isAmin=anglMin<(a2+adiff);
        
    else
        cnotclosed=true;
    end
    
    for jj=1:numCrv
        
        PouterCrv=retSrfCrvPnt(2,ParameterData,1,ParameterData{bCptr}.de(jj),numPnt,3);
        planeConst(:)=ParameterData{srfind}.revolution.v'*PouterCrv;
        
        for i=1:numPnt
            pntLdist(i)=norm(cross(ParameterData{srfind}.revolution.v,PouterCrv(:,i)-ParameterData{srfind}.revolution.p));
            [~,iind]=min(abs(compDist-pntLdist(i))+2*abs(planeConstComp-planeConst(i)));
            cparams0(i)=ccpar(iind);
        end
        
        [maDist,iind]=max(pntLdist);
        
        [cPoints,UV(1,:)]=closestNrbLinePointIGES(ParameterData{srfind}.revolution.cnurbs,ParameterData{srfind}.revolution.dcnurbs,ParameterData{srfind}.revolution.d2cnurbs,cparams0,planeConst,ParameterData{srfind}.revolution.v);
        
        miC=min(miC,min(UV(1,:)));
        maC=max(maC,max(UV(1,:)));
        
        if cnotclosed
            
            P1=ParameterData{srfind}.revolution.R*PouterCrv(:,iind)+ParameterData{srfind}.revolution.T;
            PC=ParameterData{srfind}.revolution.R*cPoints(:,iind)+ParameterData{srfind}.revolution.T;
            
            a1=atan2(P1(2),P1(1));
            a2=atan2(PC(2),PC(1));
            adiff=a1-a2;
            
            while adiff<vmin-vdiffCh
                adiff=adiff+2*pi;
            end
            while adiff>vmax+vdiffCh
                adiff=adiff-2*pi;
            end
            
            angl(iind)=adiff;
            
            for i=(iind+1):numPnt
                if pntLdist(i)>maDist*1e-6
                    
                    P1=ParameterData{srfind}.revolution.R*PouterCrv(:,i)+ParameterData{srfind}.revolution.T;
                    PC=ParameterData{srfind}.revolution.R*cPoints(:,i)+ParameterData{srfind}.revolution.T;
                    
                    a1=atan2(P1(2),P1(1));
                    a2=atan2(PC(2),PC(1));
                    adiff=a1-a2;
                    
                    while adiff<vmin-vdiffCh
                        adiff=adiff+2*pi;
                    end
                    while adiff>vmax+vdiffCh
                        adiff=adiff-2*pi;
                    end
                    
                    if adiff-angl(i-1)>pi
                        angl(i)=adiff-2*pi;
                    elseif adiff-angl(i-1)<-pi
                        angl(i)=adiff+2*pi;
                    else
                        angl(i)=adiff;
                    end
                    
                else
                    angl(i)=angl(i-1);
                end
            end
            
            for i=(iind-1):-1:1
                if pntLdist(i)>maDist*1e-6
                    
                    P1=ParameterData{srfind}.revolution.R*PouterCrv(:,i)+ParameterData{srfind}.revolution.T;
                    PC=ParameterData{srfind}.revolution.R*cPoints(:,i)+ParameterData{srfind}.revolution.T;
                    
                    a1=atan2(P1(2),P1(1));
                    a2=atan2(PC(2),PC(1));
                    adiff=a1-a2;
                    
                    while adiff<vmin-vdiffCh
                        adiff=adiff+2*pi;
                    end
                    while adiff>vmax+vdiffCh
                        adiff=adiff-2*pi;
                    end
                    
                    if adiff-angl(i+1)>pi
                        angl(i)=adiff-2*pi;
                    elseif adiff-angl(i+1)<-pi
                        angl(i)=adiff+2*pi;
                    else
                        angl(i)=adiff;
                    end
                    
                else
                    angl(i)=angl(i+1);
                end
            end
            
        else
            
            P1=ParameterData{srfind}.revolution.R*PouterCrv(:,iind)+ParameterData{srfind}.revolution.T;
            PC=ParameterData{srfind}.revolution.R*cPoints(:,iind)+ParameterData{srfind}.revolution.T;
            
            a1=atan2(P1(2),P1(1));
            a2=atan2(PC(2),PC(1));
            adiff=a1-a2;
            
            while adiff<vmin-vdiffCh
                adiff=adiff+2*pi;
            end
            while adiff>vmax+vdiffCh
                adiff=adiff-2*pi;
            end
            
            if abs(adiff-vmin)<1e-5
                if isAmax(jj)
                    angl(iind)=adiff+2*pi;
                else
                    angl(iind)=adiff;
                end
            elseif abs(adiff-vmax)<1e-5
                if isAmin(jj)
                    angl(iind)=adiff-2*pi;
                else
                    angl(iind)=adiff;
                end
            else
                angl(iind)=adiff;
            end
            
            for i=(iind+1):numPnt
                if pntLdist(i)>maDist*1e-6
                    P1=ParameterData{srfind}.revolution.R*PouterCrv(:,i)+ParameterData{srfind}.revolution.T;
                    PC=ParameterData{srfind}.revolution.R*cPoints(:,i)+ParameterData{srfind}.revolution.T;
                    
                    a1=atan2(P1(2),P1(1));
                    a2=atan2(PC(2),PC(1));
                    adiff=a1-a2;
                    
                    while adiff<vmin-vdiffCh
                        adiff=adiff+2*pi;
                    end
                    while adiff>vmax+vdiffCh
                        adiff=adiff-2*pi;
                    end
                    
                    if adiff-angl(i-1)<-pi
                        angl(i)=adiff+2*pi;
                    elseif adiff-angl(i-1)>pi
                        angl(i)=adiff-2*pi;
                    else
                        angl(i)=adiff;
                    end
                else
                    angl(i)=angl(i-1);
                end
            end
            
            for i=(iind-1):-1:1
                if pntLdist(i)>maDist*1e-6
                    P1=ParameterData{srfind}.revolution.R*PouterCrv(:,i)+ParameterData{srfind}.revolution.T;
                    PC=ParameterData{srfind}.revolution.R*cPoints(:,i)+ParameterData{srfind}.revolution.T;
                    
                    a1=atan2(P1(2),P1(1));
                    a2=atan2(PC(2),PC(1));
                    adiff=a1-a2;
                    
                    while adiff<vmin-vdiffCh
                        adiff=adiff+2*pi;
                    end
                    while adiff>vmax+vdiffCh
                        adiff=adiff-2*pi;
                    end
                    
                    if adiff-angl(i+1)<-pi
                        angl(i)=adiff+2*pi;
                    elseif adiff-angl(i+1)>pi
                        angl(i)=adiff-2*pi;
                    else
                        angl(i)=adiff;
                    end
                else
                    angl(i)=angl(i+1);
                end
            end
            
            if isAmax(jj)
                if anglMax(jj)-anglMin(jj)>1e-3
                    a2=max(angl);
                    if a2>vmax+vdiffCh
                        a1=min(angl);
                        if a1>vmax-vdiffCh
                            a1=a1-2*pi;
                            if a1>vmin-vdiffCh
                                if a2-vmax>vmin-a1
                                    angl=angl-2*pi;
                                end
                            end
                        end
                    end
                elseif isAmin(jj)
                    a1=min(angl)-2*pi;
                    if a1>vmin-vdiffCh
                        a2=max(angl);
                        if a2-vmax>vmin-a1
                            angl=angl-2*pi;
                        end
                    end
                end
            end
            if isAmin(jj)
                if anglMax(jj)-anglMin(jj)>1e-3
                    a1=min(angl);
                    if a1<vmin-vdiffCh
                        a2=max(angl);
                        if a2<vmin+vdiffCh
                            a2=a2+2*pi;
                            if a2<vmax+vdiffCh
                                if vmin-a1>a2-vmax
                                    angl=angl+2*pi;
                                end
                            end
                        end
                    end
                elseif isAmax(jj)
                    a2=max(angl)+2*pi;
                    if a2<vmax+vdiffCh
                        a1=min(angl);
                        if vmin-a1>a2-vmax
                            angl=angl+2*pi;
                        end
                    end
                end
            end
            
        end
        
        miA=min(miA,min(angl));
        maA=max(maA,max(angl));
        
        rPoints(1,:)=cos(angl);
        rPoints(2,:)=sin(angl);
        
        [~,UV(2,:)]=closestNrbLinePointIGES(ParameterData{srfind}.revolution.rnurbs,ParameterData{srfind}.revolution.drnurbs,ParameterData{srfind}.revolution.d2rnurbs,angl,rPoints);
        
        miR=min(miR,min(UV(2,:)));
        maR=max(maR,max(UV(2,:)));
        
        meaUV=mean(UV,2);
        
        singVals=svd(UV*UV'-(numPnt*meaUV)*meaUV');
        
        if 1e6*singVals(2)<singVals(1)
            
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
    
    numPnt=451;
    numCrv=1;
    
    angl=zeros(1,numPnt);
    cparams0=zeros(1,numPnt);
    UV=zeros(2,numPnt);
    rPoints=zeros(3,numPnt);
    
    pntLdist=zeros(1,numPnt);
    
    numCtrlPnts=30;
    
    knots=zeros(1,nrbDeg+numCtrlPnts+1);
    knots((numCtrlPnts+1):end)=1;
    
    pntCrvPrms=zeros(1,numPnt);
    
    CP=zeros(4,numCtrlPnts);
    CP(4,:)=1;
    
    trimCRVS=cell(1,numCrv);
    
    PouterCrv=retSrfCrvPnt(2,ParameterData,1,bCptr,numPnt,3);
    planeConst=ParameterData{srfind}.revolution.v'*PouterCrv;
    
    for i=1:numPnt
        pntLdist(i)=norm(cross(ParameterData{srfind}.revolution.v,PouterCrv(:,i)-ParameterData{srfind}.revolution.p));
        [~,iind]=min(abs(compDist-pntLdist(i))+2*abs(planeConstComp-planeConst(i)));
        cparams0(i)=ccpar(iind);
    end
    
    [maDist,iind]=max(pntLdist);
    
    [cPoints,UV(1,:)]=closestNrbLinePointIGES(ParameterData{srfind}.revolution.cnurbs,ParameterData{srfind}.revolution.dcnurbs,ParameterData{srfind}.revolution.d2cnurbs,cparams0,planeConst,ParameterData{srfind}.revolution.v);
    
    miC=min(miC,min(UV(1,:)));
    maC=max(maC,max(UV(1,:)));
    
    
    P1=ParameterData{srfind}.revolution.R*PouterCrv(:,iind)+ParameterData{srfind}.revolution.T;
    PC=ParameterData{srfind}.revolution.R*cPoints(:,iind)+ParameterData{srfind}.revolution.T;
    
    a1=atan2(P1(2),P1(1));
    a2=atan2(PC(2),PC(1));
    adiff=a1-a2;
    
    while adiff<vmin-vdiffCh
        adiff=adiff+2*pi;
    end
    while adiff>vmax+vdiffCh
        adiff=adiff-2*pi;
    end
    
    angl(iind)=adiff;
    
    for i=(iind+1):numPnt
        if pntLdist(i)>maDist*1e-6
            
            P1=ParameterData{srfind}.revolution.R*PouterCrv(:,i)+ParameterData{srfind}.revolution.T;
            PC=ParameterData{srfind}.revolution.R*cPoints(:,i)+ParameterData{srfind}.revolution.T;
            
            a1=atan2(P1(2),P1(1));
            a2=atan2(PC(2),PC(1));
            adiff=a1-a2;
            
            while adiff<vmin-vdiffCh
                adiff=adiff+2*pi;
            end
            while adiff>vmax+vdiffCh
                adiff=adiff-2*pi;
            end
            
            if adiff-angl(i-1)>pi
                angl(i)=adiff-2*pi;
            elseif adiff-angl(i-1)<-pi
                angl(i)=adiff+2*pi;
            else
                angl(i)=adiff;
            end
            
        else
            angl(i)=angl(i-1);
        end
    end
    
    for i=(iind-1):-1:1
        if pntLdist(i)>maDist*1e-6
            
            P1=ParameterData{srfind}.revolution.R*PouterCrv(:,i)+ParameterData{srfind}.revolution.T;
            PC=ParameterData{srfind}.revolution.R*cPoints(:,i)+ParameterData{srfind}.revolution.T;
            
            a1=atan2(P1(2),P1(1));
            a2=atan2(PC(2),PC(1));
            adiff=a1-a2;
            
            while adiff<vmin-vdiffCh
                adiff=adiff+2*pi;
            end
            while adiff>vmax+vdiffCh
                adiff=adiff-2*pi;
            end
            
            if adiff-angl(i+1)>pi
                angl(i)=adiff-2*pi;
            elseif adiff-angl(i+1)<-pi
                angl(i)=adiff+2*pi;
            else
                angl(i)=adiff;
            end
            
        else
            angl(i)=angl(i+1);
        end
    end
    
    miA=min(miA,min(angl));
    maA=max(maA,max(angl));
    
    rPoints(1,:)=cos(angl);
    rPoints(2,:)=sin(angl);
    
    [~,UV(2,:)]=closestNrbLinePointIGES(ParameterData{srfind}.revolution.rnurbs,ParameterData{srfind}.revolution.drnurbs,ParameterData{srfind}.revolution.d2rnurbs,angl,rPoints);
    
    miR=min(miR,min(UV(2,:)));
    maR=max(maR,max(UV(2,:)));
    
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

anglInterval=[miA,maA];
cInterval=[miC,maC];
aInterval=[miR,maR];

dC=maC-miC;
dA=maR-miR;

if allLines
    
    domainIsRectangle=true;
    
    for jj=1:numCrv
        
        if and(abs(trimCRVS{jj}.x2-trimCRVS{jj}.x1)>dC*1e-4,abs(trimCRVS{jj}.y2-trimCRVS{jj}.y1)>dA*1e-4)
            domainIsRectangle=false;
            break
        elseif and(and((trimCRVS{jj}.x1-cInterval(1))>dC*1e-4,(cInterval(2)-trimCRVS{jj}.x1)>dC*1e-4),and((trimCRVS{jj}.y1-aInterval(1))>dA*1e-4,(aInterval(2)-trimCRVS{jj}.y1)>dA*1e-4))
            domainIsRectangle=false;
            break
        elseif and(and((trimCRVS{jj}.x2-cInterval(1))>dC*1e-4,(cInterval(2)-trimCRVS{jj}.x2)>dC*1e-4),and((trimCRVS{jj}.y2-aInterval(1))>dA*1e-4,(aInterval(2)-trimCRVS{jj}.y2)>dA*1e-4))
            domainIsRectangle=false;
            break
        end
        
    end
    
else
    
    domainIsRectangle=false;
    
end