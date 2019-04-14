function ParameterData=makeContinous(ParameterData,ii)

if ii>0
    
    if ParameterData{ii}.type==102
        
        allLines=false;
        
        if ParameterData{ii}.n>1
            
            [stPp,endPp,isLine,isKnown]=endPoints(ParameterData,ParameterData{ii}.de(1));
            if isKnown
                allLines=isLine;
                [stP,endP,isLine,isKnown]=endPoints(ParameterData,ParameterData{ii}.de(2));
                if isKnown
                    if allLines
                        allLines=isLine;
                    end
                    
                    [~,miind]=min([norm(stP-endPp),norm(endP-endPp),norm(stP-stPp),norm(endP-stPp)]);
                    
                    switch miind
                        case 1
                            endPp=endP;
                        case 2
                            ParameterData=mkreverse(ParameterData,ParameterData{ii}.de(2));
                            endPp=stP;
                        case 3
                            ParameterData=mkreverse(ParameterData,ParameterData{ii}.de(1));
                            endPp=endP;
                        case 4
                            ParameterData=mkreverse(ParameterData,ParameterData{ii}.de(1));
                            ParameterData=mkreverse(ParameterData,ParameterData{ii}.de(2));
                            endPp=stP;
                    end
                    
                    for k=3:ParameterData{ii}.n
                        [stP,endP,isLine,isKnown]=endPoints(ParameterData,ParameterData{ii}.de(k));
                        if allLines
                            allLines=isLine;
                        end
                        if isKnown
                            if norm(endP-endPp)<norm(stP-endPp)
                                ParameterData=mkreverse(ParameterData,ParameterData{ii}.de(k));
                                endPp=stP;
                            else
                                endPp=endP;
                            end
                        else
                            allLines=false;
                            break
                        end
                    end
                    
                else
                    allLines=false;
                end
                
            end
            
        end
        
        ParameterData{ii}.allLines=allLines;
        
    end
    
end