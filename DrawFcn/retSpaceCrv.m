function rCrv=retSpaceCrv(ParameterData,ind,n)

if ParameterData{ind}.type==142
    
    rCrv=ret3Crv(ParameterData,ParameterData{ind}.cptr,n);
    
elseif ParameterData{ind}.type==141
    
    nvecF=(n/sum(ParameterData{ind}.msclength))*(ParameterData{ind}.msclength);
    nvecI=allocateNumCrvParams(nvecF,n);
    
    rCrv=zeros(3,n);
    
    stind=0;
    for i=1:ParameterData{ind}.n
        if nvecI(i)>0
            endind=stind+nvecI(i);
            rCrv(:,(stind+1):endind)=ret3Crv(ParameterData,ParameterData{ind}.crvpt(i),nvecI(i));
            stind=endind;
        end
    end
    
else
    
    rCrv=ret3Crv(ParameterData,ind,n);
    
end