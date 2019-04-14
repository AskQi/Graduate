function numEntities=countEntitiesSubfigure(ParameterData,i,numEntities)

if ParameterData{i}.type==128
    
    numEntities=numEntities+1;
    
elseif ParameterData{i}.type==108
    
    numEntities=numEntities+1;
    
elseif ParameterData{i}.type==144
    
    numEntities=numEntities+1;
    
    numEntities=countEntitiesSubfigure(ParameterData,ParameterData{i}.pts,numEntities);
    
    if ParameterData{i}.n1
        numEntities=countEntitiesSubfigure(ParameterData,ParameterData{i}.pto,numEntities);
    end
    for j=1:ParameterData{i}.n2
        numEntities=countEntitiesSubfigure(ParameterData,ParameterData{i}.pti(j),numEntities);
    end
    
elseif ParameterData{i}.type==126
    
    if not(ParameterData{i}.superior)
        numEntities=numEntities+1;
    end
    
elseif ParameterData{i}.type==102
    
    numEntities=numEntities+1;
    
    for j=1:ParameterData{i}.n
        numEntities=countEntitiesSubfigure(ParameterData,ParameterData{i}.de(j),numEntities);
    end
    
elseif ParameterData{i}.type==141
    
    numEntities=numEntities+1;
    
    for j=1:ParameterData{i}.n
        for jj=1:ParameterData{i}.k(j)
            numEntities=countEntitiesSubfigure(ParameterData,ParameterData{i}.pscpt{j}(jj),numEntities);
        end
    end
    
elseif ParameterData{i}.type==142
    
    numEntities=numEntities+1;
    
    numEntities=countEntitiesSubfigure(ParameterData,ParameterData{i}.cptr,numEntities);
    
elseif ParameterData{i}.type==143
    
    numEntities=numEntities+1;
    
    numEntities=countEntitiesSubfigure(ParameterData,ParameterData{i}.sptr,numEntities);
    for j=1:ParameterData{i}.n
        numEntities=countEntitiesSubfigure(ParameterData,ParameterData{i}.bdpt(j),numEntities);
    end
    
elseif ParameterData{i}.type==110
    
    if not(ParameterData{i}.superior)
        numEntities=numEntities+1;
    end
    
elseif ParameterData{i}.type==116
    
    numEntities=numEntities+1;
    
end