function [ParameterData,enttyCut]=ConvertEntiall_122(ParameterData,i)
% 列表柱面，相关资料在国标P98

fprintf('转换类型：%s(%d)\n',thisEntiall.name,thisEntiall.type);
enttyCut=0;
if ParameterData{ParameterData{i}.de}.type==110
    
    CRVk=1;
    CRVm=1;
    CRVt=[0 0 1 1];
    CRVw=[1 1];
    CRVp=[ParameterData{ParameterData{i}.de}.p1 ParameterData{ParameterData{i}.de}.p2];
    
    isplane=true;
    boool=true;
    
elseif ParameterData{ParameterData{i}.de}.type==126
    
    CRVk=ParameterData{ParameterData{i}.de}.k;
    CRVm=ParameterData{ParameterData{i}.de}.m;
    CRVt=ParameterData{ParameterData{i}.de}.t;
    CRVt=CRVt-CRVt(1);
    CRVt=CRVt/CRVt(end);
    CRVw=ParameterData{ParameterData{i}.de}.w;
    CRVp=ParameterData{ParameterData{i}.de}.p;
    
    meaP=mean(CRVp,2);
    Si=svd(CRVp*CRVp'-((CRVk+1)*meaP)*meaP');
    if Si(2)*1e6<Si(1)
        isplane=true;
    else
        isplane=false;
    end
    
    boool=true;
    
else
    
    disp(['警告：无法正确处理该文件中的122实体','.']);
    boool=false;
    
end

if boool
    
    ParameterData{i}.type=128;
    
    ParameterData{i}.name='B-NURBS SRF';
    ParameterData{i}.original=0;
    ParameterData{i}.previous_type=122;
    ParameterData{i}.previous_name='TABULATED CYLINDER';
    
    ParameterData{i}.superior=0;
    
    ParameterData{i}.k1=CRVk;
    ParameterData{i}.k2=1;
    
    ParameterData{i}.m1=CRVm;
    ParameterData{i}.m2=1;
    
    ParameterData{i}.prop1=0;
    ParameterData{i}.prop2=0;
    ParameterData{i}.prop3=0;
    ParameterData{i}.prop4=0;
    ParameterData{i}.prop5=0;
    
    ParameterData{i}.s=CRVt;
    ParameterData{i}.t=[0 0 1 1];
    
    ParameterData{i}.w=[CRVw;CRVw]';
    ParameterData{i}.p=zeros(3,CRVk+1,2);
    ParameterData{i}.p(:,:,1)=CRVp;
    ParameterData{i}.p(:,:,2)=CRVp;
    ParameterData{i}.p(1,:,2)=ParameterData{i}.p(1,:,2)+(ParameterData{i}.lx-CRVp(1,1));
    ParameterData{i}.p(2,:,2)=ParameterData{i}.p(2,:,2)+(ParameterData{i}.ly-CRVp(2,1));
    ParameterData{i}.p(3,:,2)=ParameterData{i}.p(3,:,2)+(ParameterData{i}.lz-CRVp(3,1));
    
    ParameterData{i}.u=[0 1];
    ParameterData{i}.v=[0 1];
    
    ParameterData{i}.isplane=isplane;
    
    
    % NURBS surface
    
    ParameterData{i}.nurbs.form='B-NURBS';
    ParameterData{i}.nurbs.dim=4;
    ParameterData{i}.nurbs.number=[CRVk+1 2];
    ParameterData{i}.nurbs.coefs=zeros(4,CRVk+1,2);
    
    for ii=1:2
        ParameterData{i}.nurbs.coefs(4,:,ii)=ParameterData{i}.w(:,ii)';
        
        ParameterData{i}.nurbs.coefs(1,:,ii)=ParameterData{i}.nurbs.coefs(4,:,ii).*ParameterData{i}.p(1,:,ii);
        ParameterData{i}.nurbs.coefs(2,:,ii)=ParameterData{i}.nurbs.coefs(4,:,ii).*ParameterData{i}.p(2,:,ii);
        ParameterData{i}.nurbs.coefs(3,:,ii)=ParameterData{i}.nurbs.coefs(4,:,ii).*ParameterData{i}.p(3,:,ii);
    end
    
    ParameterData{i}.nurbs.knots=cell(1,2);
    ParameterData{i}.nurbs.knots{1}=CRVt;
    ParameterData{i}.nurbs.knots{2}=[0 0 1 1];
    
    ParameterData{i}.nurbs.order=[CRVm+1 2];
    
    [ParameterData{i}.dnurbs,ParameterData{i}.d2nurbs]=nrbDerivativesIGES(ParameterData{i}.nurbs);
    
else
    enttyCut=-1;
    
    ParameterData{i}.well=false;
    
end
end