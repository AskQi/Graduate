function rCrv=ret3Crv(ParameterData,ind,n)

if ParameterData{ind}.type==110
    
    if n>1
        rCrv=zeros(3,n);
        
        tvec=linspace(0,(1-1/n),n);
        
        rCrv(1,:)=ParameterData{ind}.x1+tvec*(ParameterData{ind}.x2-ParameterData{ind}.x1);
        rCrv(2,:)=ParameterData{ind}.y1+tvec*(ParameterData{ind}.y2-ParameterData{ind}.y1);
        rCrv(3,:)=ParameterData{ind}.z1+tvec*(ParameterData{ind}.z2-ParameterData{ind}.z1);
    elseif n==1
        rCrv=ParameterData{ind}.p1;
    else
        rCrv=zeros(3,0);
    end
    
elseif ParameterData{ind}.type==126
    
    if n>1
        tst=ParameterData{ind}.v(1);
        ten=ParameterData{ind}.v(2);
        
        tvec=linspace(tst,ten-(ten-tst)/n,n);
        
        rCrv=nrbevalIGES(ParameterData{ind}.nurbs,tvec);
    elseif n==1
        rCrv=ParameterData{ind}.p(:,1);
    else
        rCrv=zeros(3,0);
    end
    
elseif ParameterData{ind}.type==142
    
    rCrv=ret3Crv(ParameterData,ParameterData{ind}.bptr,n);
    
elseif ParameterData{ind}.type==141
    
    nvecF=(n/(ParameterData{ind}.length))*(ParameterData{ind}.psclength);
    nvecI=allocateNumCrvParams(nvecF,n);
    
    rCrv=zeros(3,n);
    
    stind=0;
    for i=1:ParameterData{ind}.n
        if nvecI(i)>0
            nvecI2=allocateNumCrvParams((nvecI(i)/ParameterData{ind}.psclength(i))*ParameterData{ind}.pscclctnlength{i},nvecI(i));
            for j=1:ParameterData{ind}.k(i)
                if nvecI2(j)>0
                    endind=stind+nvecI2(j);
                    rCrv(:,(stind+1):endind)=ret3Crv(ParameterData,ParameterData{ind}.pscpt{i}(j),nvecI2(j));
                    stind=endind;
                end
            end
        end
    end
    
elseif ParameterData{ind}.type==102
    
    nvecF=(n/(ParameterData{ind}.length))*(ParameterData{ind}.lengthcnt);
    nvecI=allocateNumCrvParams(nvecF,n);
    
    rCrv=zeros(3,n);
    
    stind=1;
    for i=1:(ParameterData{ind}.n)
        if nvecI(i)>0
            endind=stind+nvecI(i)-1;
            rCrv(:,stind:endind)=ret3Crv(ParameterData,ParameterData{ind}.de(i),nvecI(i));
            stind=endind+1;
        end
    end
    
else
    
    rCrv=zeros(3,n);
    
end