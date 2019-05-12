function [ParameterData,enttyCut]=ConvertEntiall_120(ParameterData,i)
% 回转曲面，相关资料在国标P97

fprintf('转换类型：%s(%d)\n',thisEntiall.name,thisEntiall.type);
enttyCut=0;
CRVclosed=false;

if ParameterData{ParameterData{i}.c}.type==110
    
    CRVk=1;
    CRVm=1;
    CRVt=[0 0 1 1];
    CRVw=[1 1];
    CRVp=[ParameterData{ParameterData{i}.c}.p1 ParameterData{ParameterData{i}.c}.p2];
    CRVv=[0 1];
    
    cl=norm(CRVp(:,1)-CRVp(:,2))*1e-8;
    ulinear=1;
    
    boool=true;
    
elseif ParameterData{ParameterData{i}.c}.type==126
    
    CRVk=ParameterData{ParameterData{i}.c}.k;
    CRVm=ParameterData{ParameterData{i}.c}.m;
    CRVt=ParameterData{ParameterData{i}.c}.t;
    CRVw=ParameterData{ParameterData{i}.c}.w;
    CRVp=ParameterData{ParameterData{i}.c}.p;
    CRVv=ParameterData{ParameterData{i}.c}.v;
    
    cl=norm(CRVp(:,1)-CRVp(:,2))*1e-8;
    
    if norm(CRVp(:,1)-CRVp(:,end))<cl
        CRVclosed=true;
    end
    
    meaP=mean(CRVp,2);
    Si=svd(CRVp*CRVp'-((CRVk+1)*meaP)*meaP');
    if Si(2)*1e6>Si(1)
        ulinear=0;
    else
        ulinear=1;
    end
    
    boool=true;
    
else
    
    disp(['警告：无法正确该文件中的处理120类型实体','.']);
    ulinear=0;
    boool=false;
    
end

if boool
    
    p1=ParameterData{ParameterData{i}.l}.p1;
    rotDir=ParameterData{ParameterData{i}.l}.p2-p1;
    rotDir=rotDir/norm(rotDir);
    
    CRVp(1,:)=CRVp(1,:)-p1(1);
    CRVp(2,:)=CRVp(2,:)-p1(2);
    CRVp(3,:)=CRVp(3,:)-p1(3);
    
    Psonaxis=norm(cross(rotDir,CRVp(:,1)))<cl;
    Ptonaxis=norm(cross(rotDir,CRVp(:,end)))<cl;
    
    ind=1;
    maval=-1;
    
    for j=1:size(CRVp,2)
        tmp=norm(cross(rotDir,CRVp(:,j)));
        if tmp>maval
            maval=tmp;
            ind=j;
        end
    end
    
    cDir=CRVp(:,ind);
    cDir=cDir-dot(cDir,rotDir)*rotDir;
    cDir=cDir/norm(cDir);
    
    iRot=[cDir cross(rotDir,cDir) rotDir];
    
    CRVp=iRot'*CRVp;
    
    R=iRot';
    T=-iRot'*p1;
    
    vmin=ParameterData{i}.sa;
    vmax=ParameterData{i}.ta;
    
    ParameterData{i}.type=128;
    
    ParameterData{i}.name='B-NURBS SRF';
    ParameterData{i}.original=0;
    ParameterData{i}.previous_type=120;
    ParameterData{i}.previous_name='SURFACE OF REVOLUTION';
    
    ParameterData{i}.superior=0;
    
    ParameterData{i}.k1=CRVk;
    ParameterData{i}.k2=6;
    
    ParameterData{i}.m1=CRVm;
    ParameterData{i}.m2=2;
    
    ParameterData{i}.prop1=0;
    ParameterData{i}.prop2=0;
    ParameterData{i}.prop3=0;
    ParameterData{i}.prop4=0;
    ParameterData{i}.prop5=0;
    
    ParameterData{i}.s=CRVt;
    ParameterData{i}.t=[0 0 0 1/3 1/3 2/3 2/3 1 1 1]*(vmax-vmin)+vmin;
    
    ParameterData{i}.ulinear=ulinear;
    
    wodd=cos((vmax-vmin)/6);
    
    ParameterData{i}.w=[CRVw;wodd*(CRVw);CRVw;wodd*(CRVw);CRVw;wodd*(CRVw);CRVw]';
    ParameterData{i}.p=zeros(3,CRVk+1,7);
    
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
        
        ParameterData{i}.p(1,:,ii)=cob*CRVp(1,:)-sib*CRVp(2,:)-T(1);
        ParameterData{i}.p(2,:,ii)=sib*CRVp(1,:)+cob*CRVp(2,:)-T(2);
        ParameterData{i}.p(3,:,ii)=CRVp(3,:)-T(3);
        ParameterData{i}.p(:,:,ii)=R'*ParameterData{i}.p(:,:,ii);
        
    end
    
    ParameterData{i}.u=CRVv;
    ParameterData{i}.v=[vmin vmax];
    
    ParameterData{i}.isplane=false;
    
    
    % NURBS surface
    
    ParameterData{i}.nurbs.form='B-NURBS';
    ParameterData{i}.nurbs.dim=4;
    ParameterData{i}.nurbs.number=[ParameterData{i}.k1+1 ParameterData{i}.k2+1];
    ParameterData{i}.nurbs.coefs=zeros(4,CRVk+1,7);
    
    for ii=1:7
        ParameterData{i}.nurbs.coefs(4,:,ii)=ParameterData{i}.w(:,ii)';
        
        ParameterData{i}.nurbs.coefs(1,:,ii)=ParameterData{i}.nurbs.coefs(4,:,ii).*ParameterData{i}.p(1,:,ii);
        ParameterData{i}.nurbs.coefs(2,:,ii)=ParameterData{i}.nurbs.coefs(4,:,ii).*ParameterData{i}.p(2,:,ii);
        ParameterData{i}.nurbs.coefs(3,:,ii)=ParameterData{i}.nurbs.coefs(4,:,ii).*ParameterData{i}.p(3,:,ii);
    end
    
    ParameterData{i}.nurbs.knots=cell(1,2);
    ParameterData{i}.nurbs.knots{1}=CRVt;
    ParameterData{i}.nurbs.knots{2}=ParameterData{i}.t;
    
    ParameterData{i}.nurbs.order=[ParameterData{i}.m1+1 ParameterData{i}.m2+1];
    
    [ParameterData{i}.dnurbs,ParameterData{i}.d2nurbs]=nrbDerivativesIGES(ParameterData{i}.nurbs);
    
    
    % Revolution data
    
    ParameterData{i}.revolution.cclosed=CRVclosed;
    ParameterData{i}.revolution.psonaxis=Psonaxis;
    ParameterData{i}.revolution.ptonaxis=Ptonaxis;
    
    % NURBS curve
    
    ParameterData{i}.revolution.rnurbs.form='B-NURBS';
    ParameterData{i}.revolution.rnurbs.dim=4;
    ParameterData{i}.revolution.rnurbs.number=7;
    ParameterData{i}.revolution.rnurbs.coefs=[cos(betavec);sin(betavec);zeros(1,7);[1,wodd,1,wodd,1,wodd,1]];
    ParameterData{i}.revolution.rnurbs.order=3;
    ParameterData{i}.revolution.rnurbs.knots=ParameterData{i}.t;
    
    [ParameterData{i}.revolution.drnurbs,ParameterData{i}.revolution.d2rnurbs]=nrbDerivativesIGES(ParameterData{i}.revolution.rnurbs);
    
    if ParameterData{i}.trnsfrmtnmtrx>0
        
        if not(ParameterData{ParameterData{i}.trnsfrmtnmtrx}.isidentity)
            
            Rt=ParameterData{ParameterData{i}.trnsfrmtnmtrx}.r;
            Tt=ParameterData{ParameterData{i}.trnsfrmtnmtrx}.t;
            
            ParameterData{i}.revolution.p=Rt*p1+Tt;
            ParameterData{i}.revolution.v=Rt*rotDir;
            ParameterData{i}.revolution.R=R*Rt';
            ParameterData{i}.revolution.T=T-R*Rt'*Tt;
            
            % NURBS curve
            
            if ParameterData{ParameterData{i}.c}.type==110
                
                ParameterData{i}.revolution.cnurbs.form='B-NURBS';
                ParameterData{i}.revolution.cnurbs.dim=4;
                ParameterData{i}.revolution.cnurbs.number=2;
                ParameterData{i}.revolution.cnurbs.coefs=ones(4,2);
                ParameterData{i}.revolution.cnurbs.coefs(1:3,1)=Rt*ParameterData{ParameterData{i}.c}.p1+Tt;
                ParameterData{i}.revolution.cnurbs.coefs(1:3,2)=Rt*ParameterData{ParameterData{i}.c}.p2+Tt;
                ParameterData{i}.revolution.cnurbs.order=2;
                ParameterData{i}.revolution.cnurbs.knots=CRVt;
                
            elseif ParameterData{ParameterData{i}.c}.type==126
                
                ParameterData{i}.revolution.cnurbs=ParameterData{ParameterData{i}.c}.nurbs;
                ParameterData{i}.revolution.cnurbs.coefs(1,:)=(Rt(1,:)*ParameterData{ParameterData{i}.c}.p+Tt(1)).*ParameterData{ParameterData{i}.c}.w;
                ParameterData{i}.revolution.cnurbs.coefs(2,:)=(Rt(2,:)*ParameterData{ParameterData{i}.c}.p+Tt(2)).*ParameterData{ParameterData{i}.c}.w;
                ParameterData{i}.revolution.cnurbs.coefs(3,:)=(Rt(3,:)*ParameterData{ParameterData{i}.c}.p+Tt(3)).*ParameterData{ParameterData{i}.c}.w;
                
            end
            
        else
            
            ParameterData{i}.revolution.p=p1;
            ParameterData{i}.revolution.v=rotDir;
            ParameterData{i}.revolution.R=R;
            ParameterData{i}.revolution.T=T;
            
            % NURBS curve
            
            if ParameterData{ParameterData{i}.c}.type==110
                
                ParameterData{i}.revolution.cnurbs.form='B-NURBS';
                ParameterData{i}.revolution.cnurbs.dim=4;
                ParameterData{i}.revolution.cnurbs.number=2;
                ParameterData{i}.revolution.cnurbs.coefs=ones(4,2);
                ParameterData{i}.revolution.cnurbs.coefs(1:3,1)=ParameterData{ParameterData{i}.c}.p1;
                ParameterData{i}.revolution.cnurbs.coefs(1:3,2)=ParameterData{ParameterData{i}.c}.p2;
                ParameterData{i}.revolution.cnurbs.order=2;
                ParameterData{i}.revolution.cnurbs.knots=CRVt;
                
            elseif ParameterData{ParameterData{i}.c}.type==126
                
                ParameterData{i}.revolution.cnurbs=ParameterData{ParameterData{i}.c}.nurbs;
                
            end
            
        end
        
    else
        
        ParameterData{i}.revolution.p=p1;
        ParameterData{i}.revolution.v=rotDir;
        ParameterData{i}.revolution.R=R;
        ParameterData{i}.revolution.T=T;
        
        % NURBS curve
        
        if ParameterData{ParameterData{i}.c}.type==110
            
            ParameterData{i}.revolution.cnurbs.form='B-NURBS';
            ParameterData{i}.revolution.cnurbs.dim=4;
            ParameterData{i}.revolution.cnurbs.number=2;
            ParameterData{i}.revolution.cnurbs.coefs=ones(4,2);
            ParameterData{i}.revolution.cnurbs.coefs(1:3,1)=ParameterData{ParameterData{i}.c}.p1;
            ParameterData{i}.revolution.cnurbs.coefs(1:3,2)=ParameterData{ParameterData{i}.c}.p2;
            ParameterData{i}.revolution.cnurbs.order=2;
            ParameterData{i}.revolution.cnurbs.knots=CRVt;
            
        elseif ParameterData{ParameterData{i}.c}.type==126
            
            ParameterData{i}.revolution.cnurbs=ParameterData{ParameterData{i}.c}.nurbs;
            
        end
        
    end
    
    [ParameterData{i}.revolution.dcnurbs,ParameterData{i}.revolution.d2cnurbs]=nrbDerivativesIGES(ParameterData{i}.revolution.cnurbs);
    
else
    
    entty(ParameterData{i}.type)=entty(ParameterData{i}.type)-1;
    enttyCut=-1;
    ParameterData{i}.well=false;
    
end
end