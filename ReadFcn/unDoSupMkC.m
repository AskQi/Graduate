% Recursive define function

function ParameterData=unDoSupMkC(ParameterData,ii)

if ParameterData{ii}.type==126
    ParameterData{ii}.superior=0;
elseif ParameterData{ii}.type==110
    ParameterData{ii}.superior=0;
elseif ParameterData{ii}.type==102
    for k=1:ParameterData{ii}.n
        ParameterData=unDoSupMkC(ParameterData,ParameterData{ii}.de(k));
    end
elseif ParameterData{ii}.type==141
    for k=1:ParameterData{ii}.n
        ParameterData=unDoSupMkC(ParameterData,ParameterData{ii}.crvpt(k));
        %ParameterData=makeContinous(ParameterData,ParameterData{ii}.crvpt(k));
    end
    %ParameterData=makeContinous(ParameterData,ii);
elseif ParameterData{ii}.type==142
    % only cptr, not bptr
    ParameterData=unDoSupMkC(ParameterData,ParameterData{ii}.cptr);
    
    ParameterData=makeContinous(ParameterData,ParameterData{ii}.bptr);
    ParameterData=makeContinous(ParameterData,ParameterData{ii}.cptr);
end
