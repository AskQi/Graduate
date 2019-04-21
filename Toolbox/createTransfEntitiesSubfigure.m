function [numEntities,ParameterData]=createTransfEntitiesSubfigure(ParameterData,i,numEntities,R,T)

if ParameterData{i}.type==128
    
    numEntities=numEntities+1;
    
    ParameterData{numEntities}=ParameterData{i};
    
    for j=1:(ParameterData{numEntities}.k1+1)
        for k=1:(ParameterData{numEntities}.k2+1)
            ParameterData{numEntities}.p(:,j,k)=R*ParameterData{numEntities}.p(:,j,k)+T;
        end
    end
    
    ParameterData{numEntities}.nurbs.coefs(1:3,:,:)=repmat(ParameterData{numEntities}.nurbs.coefs(4,:,:),3,1).*ParameterData{numEntities}.p;
    [ParameterData{numEntities}.dnurbs,ParameterData{numEntities}.d2nurbs]=nrbDerivativesIGES(ParameterData{numEntities}.nurbs);
    
elseif ParameterData{i}.type==108
    
    numEntities=numEntities+1;
    
    ParameterData{numEntities}=ParameterData{i};
    
    ParameterData{numEntities}.d=ParameterData{numEntities}.d+dot(ParameterData{numEntities}.normal,R'*T);
    
    ParameterData{numEntities}.normal=R*ParameterData{numEntities}.normal;
    
    ParameterData{numEntities}.a=ParameterData{numEntities}.normal(1);
    ParameterData{numEntities}.b=ParameterData{numEntities}.normal(2);
    ParameterData{numEntities}.c=ParameterData{numEntities}.normal(3);
    
    X=R*[ParameterData{numEntities}.x;ParameterData{numEntities}.y;ParameterData{numEntities}.z]+T;
    
    ParameterData{numEntities}.x=X(1);
    ParameterData{numEntities}.y=X(2);
    ParameterData{numEntities}.z=X(3);
    
elseif ParameterData{i}.type==144
    
    numEntities=numEntities+1;
    
    thisEntity=numEntities;
    
    ParameterData{thisEntity}=ParameterData{i};
    
    entiall=ParameterData{i}.pts;
    
    ParameterData{thisEntity}.pts=numEntities+1;
    [numEntities,ParameterData]=createTransfEntitiesSubfigure(ParameterData,entiall,numEntities,R,T);
    
    if ParameterData{thisEntity}.n1
        ParameterData{thisEntity}.pto=numEntities+1;
        [numEntities,ParameterData]=createTransfEntitiesSubfigure(ParameterData,ParameterData{i}.pto,numEntities,R,T);
    end
    for j=1:ParameterData{thisEntity}.n2
        ParameterData{thisEntity}.pti(j)=numEntities+1;
        [numEntities,ParameterData]=createTransfEntitiesSubfigure(ParameterData,ParameterData{i}.pti(j),numEntities,R,T);
    end
    
elseif ParameterData{i}.type==126
    
    if not(ParameterData{i}.superior)
        
        numEntities=numEntities+1;
        
        ParameterData{numEntities}=ParameterData{i};
        
        for j=1:(ParameterData{numEntities}.k+1)
            ParameterData{numEntities}.p(:,j)=R*(ParameterData{numEntities}.p(:,j))+T;
        end
        
        ParameterData{numEntities}.nurbs.coefs(1:3,:)=repmat(ParameterData{numEntities}.nurbs.coefs(4,:),3,1).*ParameterData{numEntities}.p;
        [ParameterData{numEntities}.dnurbs,ParameterData{numEntities}.d2nurbs]=nrbDerivativesIGES(ParameterData{numEntities}.nurbs);
        
    end
    
elseif ParameterData{i}.type==102
    
    numEntities=numEntities+1;
    
    thisEntity=numEntities;
    
    ParameterData{thisEntity}=ParameterData{i};
    
    for j=1:ParameterData{thisEntity}.n
        ParameterData{thisEntity}.de(j)=numEntities+1;
        [numEntities,ParameterData]=createTransfEntitiesSubfigure(ParameterData,ParameterData{i}.de(j),numEntities,R,T);
    end
    
elseif ParameterData{i}.type==141
    
    numEntities=numEntities+1;
    
    thisEntity=numEntities;
    
    ParameterData{thisEntity}=ParameterData{i};
    
    for j=1:ParameterData{i}.n
        for jj=1:ParameterData{i}.k(j)
            ParameterData{thisEntity}.pscpt{j}(jj)=numEntities+1;
            [numEntities,ParameterData]=createTransfEntitiesSubfigure(ParameterData,ParameterData{i}.pscpt{j}(jj),numEntities,R,T);
        end
    end
    
elseif ParameterData{i}.type==142
    
    numEntities=numEntities+1;
    
    thisEntity=numEntities;
    
    ParameterData{thisEntity}=ParameterData{i};
    
    ParameterData{thisEntity}.cptr=numEntities+1;
    [numEntities,ParameterData]=createTransfEntitiesSubfigure(ParameterData,ParameterData{i}.cptr,numEntities,R,T);
    
elseif ParameterData{i}.type==143
    
    numEntities=numEntities+1;
    
    thisEntity=numEntities;
    
    ParameterData{thisEntity}=ParameterData{i};
    
    ParameterData{thisEntity}.sptr=numEntities+1;
    [numEntities,ParameterData]=createTransfEntitiesSubfigure(ParameterData,ParameterData{i}.sptr,numEntities,R,T);
    
    for j=1:ParameterData{thisEntity}.n
        ParameterData{thisEntity}.bdpt(j)=numEntities+1;
        [numEntities,ParameterData]=createTransfEntitiesSubfigure(ParameterData,ParameterData{i}.bdpt(j),numEntities,R,T);
    end
    
elseif ParameterData{i}.type==110
    
    if not(ParameterData{i}.superior)
        
        numEntities=numEntities+1;
        
        ParameterData{numEntities}=ParameterData{i};
        
        ParameterData{numEntities}.p1=R*ParameterData{numEntities}.p1+T;
        ParameterData{numEntities}.x1=ParameterData{numEntities}.p1(1);
        ParameterData{numEntities}.y1=ParameterData{numEntities}.p1(2);
        ParameterData{numEntities}.z1=ParameterData{numEntities}.p1(3);
        
        ParameterData{numEntities}.p2=R*ParameterData{numEntities}.p2+T;
        ParameterData{numEntities}.x2=ParameterData{numEntities}.p2(1);
        ParameterData{numEntities}.y2=ParameterData{numEntities}.p2(2);
        ParameterData{numEntities}.z2=ParameterData{numEntities}.p2(3);
        
    end
    
elseif ParameterData{i}.type==116
    
    numEntities=numEntities+1;
    
    ParameterData{numEntities}=ParameterData{i};
    
    ParameterData{numEntities}.p=R*ParameterData{numEntities}.p+T;
    ParameterData{numEntities}.x=ParameterData{numEntities}.p(1);
    ParameterData{numEntities}.y=ParameterData{numEntities}.p(2);
    ParameterData{numEntities}.z=ParameterData{numEntities}.p(3);
    
end