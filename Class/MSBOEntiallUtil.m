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
                    thisLineAndEdgeEntiallStruct(:)=thisLoopEntiall.LineAndEdgeEntiall;
                    for jjj=1:thisLoopEntiall.n
                        curv=thisLineAndEdgeEntiallStruct(jjj).CURV;
                        edge=thisLineAndEdgeEntiallStruct(jjj).edge;
                        ndx=thisLineAndEdgeEntiallStruct(jjj).ndx;
                        if ~isempty(curv)
                            thisLineEntiallIndex=(curv+1)/2;
                            ParameterData{thisLineEntiallIndex}.clrnmbr=clrnmbr;
                        end
                        if ~isempty(edge)
                            thisEdgeEntiallIndex=(edge+1)/2;
                            
                            ParameterData{thisEdgeEntiallIndex}.clrnmbr=clrnmbr;
                            
                            thisEdgeEntiall=ParameterData{thisEdgeEntiallIndex};
                            thisEdgeEntiallStruct(:)=thisEdgeEntiall.EdgeEntiall;
                            for jjjj=1:thisEdgeEntiall.n
                                % 曲线的DE指针
                                curv=thisEdgeEntiallStruct(jjjj).curv;
                                % 顶点列表实体（502）的DE指针
                                svp=thisEdgeEntiallStruct(jjjj).svp;
                                % 顶点列表实体第一个起始顶点的DE指针
                                sv=thisEdgeEntiallStruct(jjjj).sv;
                                % 顶点列表实体第一个终止顶点的DE指针
                                tvp=thisEdgeEntiallStruct(jjjj).tvp;
                                % 顶点列表实体中指定i的那的列表索引
                                tv=thisEdgeEntiallStruct(jjjj).tv;
                                
                                thisCurvEntiallIndex=(curv+1)/2;
                                ParameterData{thisCurvEntiallIndex}.clrnmbr=clrnmbr;
                                % 顶点实体(502)
                                % TODO:完成顶点部分。
                                thisSvpEntiallIndex=(svp+1)/2;
                                ParameterData{thisSvpEntiallIndex}.clrnmbr=clrnmbr;

                                thisSvEntiallIndex=(sv+1)/2;
                                thisTvpEntiallIndex=(tvp+1)/2;
                                thisTvEntiallIndex=(tv+1)/2;
                                % 顶点实体结束
                                
                            end
                        end
                        
                    end
                end
            end
            
        end
    end
end

