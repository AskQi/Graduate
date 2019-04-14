function ParameterData=mkreverse(ParameterData,ii)

if ParameterData{ii}.type==110
    
    p1=[ParameterData{ii}.x1;ParameterData{ii}.y1;ParameterData{ii}.z1];
    p2=[ParameterData{ii}.x2;ParameterData{ii}.y2;ParameterData{ii}.z2];
    
    ParameterData{ii}.p1=p2;
    ParameterData{ii}.p2=p1;
    
    ParameterData{ii}.x1=p2(1);
    ParameterData{ii}.y1=p2(2);
    ParameterData{ii}.z1=p2(3);
    
    ParameterData{ii}.x2=p1(1);
    ParameterData{ii}.y2=p1(2);
    ParameterData{ii}.z2=p1(3);
    
elseif ParameterData{ii}.type==126
    
    tsum=ParameterData{ii}.t(1)+ParameterData{ii}.t(end);
    
    t=tsum-ParameterData{ii}.t;
    
    ParameterData{ii}.t=t(end:(-1):1);
    ParameterData{ii}.w=ParameterData{ii}.w(end:(-1):1);
    ParameterData{ii}.p=ParameterData{ii}.p(:,end:(-1):1);
    
    ParameterData{ii}.v=[tsum-ParameterData{ii}.v(2) tsum-ParameterData{ii}.v(1)];
    
    ParameterData{ii}.nurbs.coefs=ParameterData{ii}.nurbs.coefs(:,end:(-1):1);
    
    ParameterData{ii}.nurbs.knots=ParameterData{ii}.t;
    
elseif ParameterData{ii}.type==102
    
    de=ParameterData{ii}.de;
    for k=1:ParameterData{ii}.n
        ParameterData{ii}.de(k)=de(ParameterData{ii}.n+1-k);
        ParameterData=mkreverse(ParameterData,ParameterData{ii}.de(k));
    end
    
elseif ParameterData{ii}.type==142
    
    ParameterData=mkreverse(ParameterData,ParameterData{ii}.bptr);
    ParameterData=mkreverse(ParameterData,ParameterData{ii}.cptr);
    
end