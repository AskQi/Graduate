classdef MSBOEntiallUtil
    % 用于处理所有MSBO实体及其子实体的颜色
    
    methods(Static)
        function ParameterData = handleMSBOEntiall(ParameterData,...
                thisMSBOEntiallIndex,clrnmbr)
            
            thisMSBOEntiall=ParameterData{thisMSBOEntiallIndex};
            
            ParameterData{thisMSBOEntiallIndex}.clrnmbr=clrnmbr;
            
            thisShellEntiallIndex=(thisMSBOEntiall.shell+1)/2;
            
            ParameterData{thisShellEntiallIndex}.clrnmbr=clrnmbr;
            
            thisShellEntiall=ParameterData{thisShellEntiallIndex};
            thisFaceEntiallStruct(:)=thisShellEntiall.FaceEntiall;
            for j=1:length(thisFaceEntiallStruct)
                thisFaceEntiallIndex=(thisFaceEntiallStruct(j).face+1)/2;
                
                ParameterData{thisFaceEntiallIndex}.clrnmbr=clrnmbr;
                
                thisFaceEntiall=ParameterData{thisFaceEntiallIndex};
                thisLoopEntiallIndexs=(thisFaceEntiall.loop+1)/2;
                for jj=1:thisFaceEntiall.n
                    thisLoopEntiallIndex=thisLoopEntiallIndexs(jj);
                    
                    ParameterData{thisLoopEntiallIndex}.clrnmbr=clrnmbr;
                    
                    thisLoopEntiall=ParameterData{thisLoopEntiallIndex};
                    thisLineEntiallStruct(:)=thisLoopEntiall.LineEntiall;
                    for jjj=1:thisLoopEntiall.n
                        thisLineEntiallIndex=(thisLineEntiallStruct(jjj).CURV+1)/2;
                        ParameterData{thisLineEntiallIndex}.clrnmbr=clrnmbr;
                    end
                end
            end
            
        end
    end
end

