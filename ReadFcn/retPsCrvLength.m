function [ParameterData,le,numcrv]=retPsCrvLength(srfind,ParameterData,ind,n)

if ParameterData{ind}.type==142
    
    ind0=ind;
    
    ind=ParameterData{ind}.bptr;
    
    if ParameterData{ind}.type==102
        le=0;
        numcrv=0;
        for i=1:(ParameterData{ind}.n)
            if ParameterData{ParameterData{ind}.de(i)}.type==126
                [~,le2,evmethd]=crvPntsSrfNURBS(n,ParameterData{srfind}.nurbs,ParameterData{ParameterData{ind}.de(i)}.nurbs,ParameterData{ParameterData{ind}.de(i)}.v(1),ParameterData{ParameterData{ind}.de(i)}.v(2));
                ParameterData{ParameterData{ind}.de(i)}.length=le2;
                ParameterData{ParameterData{ind}.de(i)}.evalmthd=evmethd;
                numcrv2=1;
            elseif ParameterData{ParameterData{ind}.de(i)}.type==110
                [~,le2,evmethd]=crvPntsSrfNURBS(n,ParameterData{srfind}.nurbs,ParameterData{ParameterData{ind}.de(i)}.p1,ParameterData{ParameterData{ind}.de(i)}.p2);
                ParameterData{ParameterData{ind}.de(i)}.length=le2;
                ParameterData{ParameterData{ind}.de(i)}.evalmthd=evmethd;
                numcrv2=1;
            else
                [ParameterData,le2,numcrv2]=retPsCrvLength(srfind,ParameterData,ParameterData{ind}.de(i),n);
            end
            ParameterData{ind}.lengthcnt(i)=le2;
            ParameterData{ind}.numcrvcnt(i)=numcrv2;
            le=le+le2;
            numcrv=numcrv+numcrv2;
        end
    elseif ParameterData{ind}.type==126
        [~,le,evmethd]=crvPntsSrfNURBS(n,ParameterData{srfind}.nurbs,ParameterData{ind}.nurbs,ParameterData{ind}.v(1),ParameterData{ind}.v(2));
        ParameterData{ind}.evalmthd=evmethd;
        numcrv=1;
    else
        [ParameterData,le,numcrv]=retPsCrvLength(srfind,ParameterData,ind,n);
    end
    
    ParameterData{ind}.length=le;
    ParameterData{ind}.numcrv=numcrv;
    ParameterData{ind0}.length=le;
    ParameterData{ind0}.numcrv=numcrv;
    
elseif ParameterData{ind}.type==141
    
    le=0;
    numcrv=0;
    for i=1:ParameterData{ind}.n
        le2=0;
        numcrv2=0;
        for j=1:ParameterData{ind}.k(i)
            if ParameterData{ParameterData{ind}.pscpt{i}(j)}.type==126
                [~,le3,evmethd]=crvPntsSrfNURBS(n,ParameterData{srfind}.nurbs,ParameterData{ParameterData{ind}.pscpt{i}(j)}.nurbs,ParameterData{ParameterData{ind}.pscpt{i}(j)}.v(1),ParameterData{ParameterData{ind}.pscpt{i}(j)}.v(2));
                ParameterData{ParameterData{ind}.pscpt{i}(j)}.length=le3;
                ParameterData{ParameterData{ind}.pscpt{i}(j)}.evalmthd=evmethd;
                numcrv3=1;
            elseif ParameterData{ParameterData{ind}.pscpt{i}(j)}.type==110
                [~,le3,evmethd]=crvPntsSrfNURBS(n,ParameterData{srfind}.nurbs,ParameterData{ParameterData{ind}.pscpt{i}(j)}.p1,ParameterData{ParameterData{ind}.pscpt{i}(j)}.p2);
                ParameterData{ParameterData{ind}.pscpt{i}(j)}.length=le3;
                ParameterData{ParameterData{ind}.pscpt{i}(j)}.evalmthd=evmethd;
                numcrv3=1;
            else
                [ParameterData,le3,numcrv3]=retPsCrvLength(srfind,ParameterData,ParameterData{ind}.pscpt{i}(j),n);
            end
            ParameterData{ind}.pscclctnlength{i}(j)=le3;
            ParameterData{ind}.numpscrvc{i}(j)=numcrv3;
            le2=le2+le3;
            numcrv2=numcrv2+numcrv3;
        end
        ParameterData{ind}.psclength(i)=le2;
        ParameterData{ind}.numpscrv(i)=numcrv2;
        le=le+le2;
        numcrv=numcrv+numcrv2;
    end
    ParameterData{ind}.length=le;
    ParameterData{ind}.numcrv=numcrv;
    
elseif ParameterData{ind}.type==102
    
    le=0;
    numcrv=0;
    for i=1:(ParameterData{ind}.n)
        if ParameterData{ParameterData{ind}.de(i)}.type==126
            [~,le2,evmethd]=crvPntsSrfNURBS(n,ParameterData{srfind}.nurbs,ParameterData{ParameterData{ind}.de(i)}.nurbs,ParameterData{ParameterData{ind}.de(i)}.v(1),ParameterData{ParameterData{ind}.de(i)}.v(2));
            ParameterData{ParameterData{ind}.de(i)}.length=le2;
            ParameterData{ParameterData{ind}.de(i)}.evalmthd=evmethd;
            numcrv2=1;
        elseif ParameterData{ParameterData{ind}.de(i)}.type==110
            [~,le2,evmethd]=crvPntsSrfNURBS(n,ParameterData{srfind}.nurbs,ParameterData{ParameterData{ind}.de(i)}.p1,ParameterData{ParameterData{ind}.de(i)}.p2);
            ParameterData{ParameterData{ind}.de(i)}.length=le2;
            ParameterData{ParameterData{ind}.de(i)}.evalmthd=evmethd;
            numcrv2=1;
        else
            [ParameterData,le2,numcrv2]=retPsCrvLength(srfind,ParameterData,ParameterData{ind}.de(i),n);
        end
        ParameterData{ind}.lengthcnt(i)=le2;
        ParameterData{ind}.numcrvcnt(i)=numcrv2;
        le=le+le2;
        numcrv=numcrv+numcrv2;
    end
    ParameterData{ind}.length=le;
    ParameterData{ind}.numcrv=numcrv;
    
elseif ParameterData{ind}.type==126
    
    [~,le,evmethd]=crvPntsSrfNURBS(n,ParameterData{srfind}.nurbs,ParameterData{ind}.nurbs,ParameterData{ind}.v(1),ParameterData{ind}.v(2));
    ParameterData{ind}.length=le;
    ParameterData{ind}.evalmthd=evmethd;
    numcrv=1;
    
elseif ParameterData{ind}.type==110
    
    [~,le,evmethd]=crvPntsSrfNURBS(n,ParameterData{srfind}.nurbs,ParameterData{ind}.p1,ParameterData{ind}.p2);
    ParameterData{ind}.length=le;
    ParameterData{ind}.evalmthd=evmethd;
    numcrv=1;
    
else
    
    le=0;
    numcrv=0;
    
end