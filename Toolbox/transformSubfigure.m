function ParameterData=transformSubfigure(ParameterData,i,R,T)

if ParameterData{i}.type==128
    
    for j=1:(ParameterData{i}.k1+1)
        for k=1:(ParameterData{i}.k2+1)
            ParameterData{i}.p(:,j,k)=R*ParameterData{i}.p(:,j,k)+T;
        end
    end
    
    ParameterData{i}.nurbs.coefs(1:3,:,:)=repmat(ParameterData{i}.nurbs.coefs(4,:,:),3,1).*ParameterData{i}.p;
    [ParameterData{i}.dnurbs,ParameterData{i}.d2nurbs]=nrbDerivativesIGES(ParameterData{i}.nurbs);
    
elseif ParameterData{i}.type==108
    
    ParameterData{i}.d=ParameterData{i}.d+dot(ParameterData{i}.normal,R'*T);
    
    ParameterData{i}.normal=R*ParameterData{i}.normal;
    
    ParameterData{i}.a=ParameterData{i}.normal(1);
    ParameterData{i}.b=ParameterData{i}.normal(2);
    ParameterData{i}.c=ParameterData{i}.normal(3);
    
    X=R*[ParameterData{i}.x;ParameterData{i}.y;ParameterData{i}.z]+T;
    
    ParameterData{i}.x=X(1);
    ParameterData{i}.y=X(2);
    ParameterData{i}.z=X(3);
    
elseif ParameterData{i}.type==144
    
    entiall=ParameterData{i}.pts;
    
    ParameterData=transformSubfigure(ParameterData,entiall,R,T);
    
    if ParameterData{i}.n1
        ParameterData=transformSubfigure(ParameterData,ParameterData{i}.pto,R,T);
    end
    for j=1:ParameterData{i}.n2
        ParameterData=transformSubfigure(ParameterData,ParameterData{i}.pti(j),R,T);
    end
    
elseif ParameterData{i}.type==126
    
    if not(ParameterData{i}.superior)
        
        for j=1:(ParameterData{i}.k+1)
            ParameterData{i}.p(:,j)=R*(ParameterData{i}.p(:,j))+T;
        end
        
        ParameterData{i}.nurbs.coefs(1:3,:)=repmat(ParameterData{i}.nurbs.coefs(4,:),3,1).*ParameterData{i}.p;
        [ParameterData{i}.dnurbs,ParameterData{i}.d2nurbs]=nrbDerivativesIGES(ParameterData{i}.nurbs);
        
    end
    
elseif ParameterData{i}.type==102
    
    for j=1:ParameterData{i}.n
        ParameterData=transformSubfigure(ParameterData,ParameterData{i}.de(j),R,T);
    end
    
elseif ParameterData{i}.type==141
    
    for j=1:ParameterData{i}.n
        for jj=1:ParameterData{i}.k(j)
            ParameterData=transformSubfigure(ParameterData,ParameterData{i}.pscpt{j}(jj),R,T);
        end
    end
    
elseif ParameterData{i}.type==142
    
    ParameterData=transformSubfigure(ParameterData,ParameterData{i}.cptr,R,T);
    
elseif ParameterData{i}.type==143
    
    ParameterData=transformSubfigure(ParameterData,ParameterData{i}.sptr,R,T);
    for j=1:ParameterData{i}.n
        ParameterData=transformSubfigure(ParameterData,ParameterData{i}.bdpt(j),R,T);
    end
    
elseif ParameterData{i}.type==110
    
    if not(ParameterData{i}.superior)
        
        ParameterData{i}.p1=R*ParameterData{i}.p1+T;
        ParameterData{i}.x1=ParameterData{i}.p1(1);
        ParameterData{i}.y1=ParameterData{i}.p1(2);
        ParameterData{i}.z1=ParameterData{i}.p1(3);
        
        ParameterData{i}.p2=R*ParameterData{i}.p2+T;
        ParameterData{i}.x2=ParameterData{i}.p2(1);
        ParameterData{i}.y2=ParameterData{i}.p2(2);
        ParameterData{i}.z2=ParameterData{i}.p2(3);
        
    end
    
elseif ParameterData{i}.type==116
    
    ParameterData{i}.p=R*ParameterData{i}.p+T;
    ParameterData{i}.x=ParameterData{i}.p(1);
    ParameterData{i}.y=ParameterData{i}.p(2);
    ParameterData{i}.z=ParameterData{i}.p(3);
    
end