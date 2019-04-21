function [rCrv,crvind,crvindred]=retCrv(ParameterData,ind,n,dim)

if ParameterData{ind}.type==142
    
    if nargout>1
        [rCrv,crvind,crvindred]=retCrv(ParameterData,ParameterData{ind}.bptr,n,dim);
    else
        rCrv=retCrv(ParameterData,ParameterData{ind}.bptr,n,dim);
    end
    
elseif ParameterData{ind}.type==141
    
    nvecF=(n/(ParameterData{ind}.length))*(ParameterData{ind}.psclength);
    nvecI=allocateNumCrvParams(nvecF,n);
    
    rCrv=zeros(dim,n);
    
    if nargout==1
        
        stind=0;
        for i=1:ParameterData{ind}.n
            if nvecI(i)>0
                nvecI2=allocateNumCrvParams((nvecI(i)/ParameterData{ind}.psclength(i))*ParameterData{ind}.pscclctnlength{i},nvecI(i));
                for j=1:ParameterData{ind}.k(i)
                    if nvecI2(j)>0
                        endind=stind+nvecI2(j);
                        rCrv(:,(stind+1):endind)=retCrv(ParameterData,ParameterData{ind}.pscpt{i}(j),nvecI2(j),dim);
                        stind=endind;
                    end
                end
            end
        end
        
    else
        
        crvind=zeros(1,n);
        crvindred=zeros(1,0);
        
        stind=0;
        for i=1:ParameterData{ind}.n
            if nvecI(i)>0
                nvecI2=allocateNumCrvParams((nvecI(i)/ParameterData{ind}.psclength(i))*ParameterData{ind}.pscclctnlength{i},nvecI(i));
                for j=1:ParameterData{ind}.k(i)
                    if nvecI2(j)>0
                        crvindred=[crvindred,ParameterData{ind}.pscpt{i}(j)];
                        endind=stind+nvecI2(j);
                        rCrv(:,(stind+1):endind)=retCrv(ParameterData,ParameterData{ind}.pscpt{i}(j),nvecI2(j),dim);
                        crvind((stind+1):endind)=ParameterData{ind}.pscpt{i}(j);
                        stind=endind;
                    end
                end
            end
        end
        
    end
    
elseif ParameterData{ind}.type==102
    
    nvecF=(n/(ParameterData{ind}.length))*(ParameterData{ind}.lengthcnt);
    nvecI=allocateNumCrvParams(nvecF,n);
    
    rCrv=zeros(dim,n);
    
    if nargout==1
        
        stind=1;
        for i=1:(ParameterData{ind}.n)
            if nvecI(i)>0
                endind=stind+nvecI(i)-1;
                rCrv(:,stind:endind)=retCrv(ParameterData,ParameterData{ind}.de(i),nvecI(i),dim);
                stind=endind+1;
            end
        end
        
    else
        
        crvind=zeros(1,n);
        crvindred=ParameterData{ind}.de;
        stind=1;
        for i=1:(ParameterData{ind}.n)
            if nvecI(i)>0
                endind=stind+nvecI(i)-1;
                [rCrv(:,stind:endind),crvind(stind:endind)]=retCrv(ParameterData,ParameterData{ind}.de(i),nvecI(i),dim);
                stind=endind+1;
            end
        end
        
    end
    
elseif ParameterData{ind}.type==110
    
    rCrv=zeros(dim,n);
    
    if nargout==1
        tvec=linspace(0,(1-1/n),n);
    else
        tvec=linspace(0,1,n);
    end
    
    rCrv(1,:)=ParameterData{ind}.x1+tvec*(ParameterData{ind}.x2-ParameterData{ind}.x1);
    rCrv(2,:)=ParameterData{ind}.y1+tvec*(ParameterData{ind}.y2-ParameterData{ind}.y1);
    
    if dim>2
        rCrv(3,:)=ParameterData{ind}.z1+tvec*(ParameterData{ind}.z2-ParameterData{ind}.z1);
    end
    
    if nargout>1
        crvind=ind*ones(1,n);
        crvindred=ind;
    end
    
elseif ParameterData{ind}.type==126
    
    tst=ParameterData{ind}.v(1);
    ten=ParameterData{ind}.v(2);
    
    if nargout==1
        tvec=linspace(tst,ten-(ten-tst)/n,n);
    else
        tvec=linspace(tst,ten,n);
    end
    
    if dim==3
        rCrv=nrbevalIGES(ParameterData{ind}.nurbs,tvec);
    else
        P3=nrbevalIGES(ParameterData{ind}.nurbs,tvec);
        rCrv=P3(1:dim,:);
    end
    
    if nargout>1
        crvind=ind*ones(1,n);
        crvindred=ind;
    end
    
else
    rCrv=zeros(dim,n);
    
    if nargout>1
        crvind=ind*ones(1,0);
        crvindred=ind;
    end
end