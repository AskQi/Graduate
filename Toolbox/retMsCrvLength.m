function [ParameterData,le,numcrv]=retMsCrvLength(ParameterData,ind,n)

if ParameterData{ind}.type==142
    
    ind=ParameterData{ind}.cptr;
    
    if ParameterData{ind}.type==102
        le=0;
        numcrv=0;
        for i=1:(ParameterData{ind}.n)
            if ParameterData{ParameterData{ind}.de(i)}.type==126
                [~,le2,evmethd]=crvPntsSrfNURBS(n,ParameterData{ParameterData{ind}.de(i)}.nurbs,ParameterData{ParameterData{ind}.de(i)}.v(1),ParameterData{ParameterData{ind}.de(i)}.v(2));
                ParameterData{ParameterData{ind}.de(i)}.length=le2;
                ParameterData{ParameterData{ind}.de(i)}.evalmthd=evmethd;
                numcrv2=1;
            elseif ParameterData{ParameterData{ind}.de(i)}.type==110
                [~,le2,~]=crvPntsSrfNURBS(1,ParameterData{ParameterData{ind}.de(i)}.p1,ParameterData{ParameterData{ind}.de(i)}.p2);
                ParameterData{ParameterData{ind}.de(i)}.length=le2;
                numcrv2=1;
            else
                [ParameterData,le2,numcrv2]=retMsCrvLength(ParameterData,ParameterData{ind}.de(i),n);
            end
            ParameterData{ind}.lengthcnt(i)=le2;
            ParameterData{ind}.numcrvcnt(i)=numcrv2;
            le=le+le2;
            numcrv=numcrv+numcrv2;
        end
    elseif ParameterData{ind}.type==126
        [~,le,evmethd]=crvPntsSrfNURBS(n,ParameterData{ind}.nurbs,ParameterData{ind}.v(1),ParameterData{ind}.v(2));
        ParameterData{ind}.evalmthd=evmethd;
        numcrv=1;
    else
        [ParameterData,le,numcrv]=retMsCrvLength(ParameterData,ind,n);
    end
    
    ParameterData{ind}.length=le;
    ParameterData{ind}.numcrv=numcrv;
    
elseif ParameterData{ind}.type==141
    
    le=0;
    numcrv=0;
    for i=1:ParameterData{ind}.n
        if ParameterData{ParameterData{ind}.crvpt(i)}.type==126
            [~,le2,evmethd]=crvPntsSrfNURBS(n,ParameterData{ParameterData{ind}.crvpt(i)}.nurbs,ParameterData{ParameterData{ind}.crvpt(i)}.v(1),ParameterData{ParameterData{ind}.crvpt(i)}.v(2));
            ParameterData{ParameterData{ind}.crvpt(i)}.length=le2;
            ParameterData{ParameterData{ind}.crvpt(i)}.evalmthd=evmethd;
            numcrv2=1;
        elseif ParameterData{ParameterData{ind}.crvpt(i)}.type==110
            [~,le2,~]=crvPntsSrfNURBS(1,ParameterData{ParameterData{ind}.crvpt(i)}.p1,ParameterData{ParameterData{ind}.crvpt(i)}.p2);
            ParameterData{ParameterData{ind}.crvpt(i)}.length=le2;
            numcrv2=1;
        else
            [ParameterData,le2,numcrv2]=retMsCrvLength(ParameterData,ParameterData{ind}.crvpt(i),n);
        end
        ParameterData{ind}.msclength(i)=le2;
        le=le+le2;
        numcrv=numcrv+numcrv2;
    end
    
elseif ParameterData{ind}.type==102
    
    le=0;
    numcrv=0;
    for i=1:(ParameterData{ind}.n)
        if ParameterData{ParameterData{ind}.de(i)}.type==126
            [~,le2,evmethd]=crvPntsSrfNURBS(n,ParameterData{ParameterData{ind}.de(i)}.nurbs,ParameterData{ParameterData{ind}.de(i)}.v(1),ParameterData{ParameterData{ind}.de(i)}.v(2));
            ParameterData{ParameterData{ind}.de(i)}.length=le2;
            ParameterData{ParameterData{ind}.de(i)}.evalmthd=evmethd;
            numcrv2=1;
        elseif ParameterData{ParameterData{ind}.de(i)}.type==110
            [~,le2,~]=crvPntsSrfNURBS(n,ParameterData{ParameterData{ind}.de(i)}.p1,ParameterData{ParameterData{ind}.de(i)}.p2);
            ParameterData{ParameterData{ind}.de(i)}.length=le2;
            numcrv2=1;
        else
            [ParameterData,le2,numcrv2]=retMsCrvLength(ParameterData,ParameterData{ind}.de(i),n);
        end
        ParameterData{ind}.lengthcnt(i)=le2;
        ParameterData{ind}.numcrvcnt(i)=numcrv2;
        le=le+le2;
        numcrv=numcrv+numcrv2;
    end
    ParameterData{ind}.length=le;
    ParameterData{ind}.numcrv=numcrv;
    
elseif ParameterData{ind}.type==126
    
    [~,le,evmethd]=crvPntsSrfNURBS(n,ParameterData{ind}.nurbs,ParameterData{ind}.v(1),ParameterData{ind}.v(2));
    ParameterData{ind}.length=le;
    ParameterData{ind}.evalmthd=evmethd;
    numcrv=1;
    
elseif ParameterData{ind}.type==110
    
    [~,le,~]=crvPntsSrfNURBS(n,ParameterData{ind}.p1,ParameterData{ind}.p2);
    ParameterData{ind}.length=le;
    numcrv=1;
    
else
    
    le=0;
    numcrv=0;
    
end