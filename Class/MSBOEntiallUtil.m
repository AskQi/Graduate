classdef MSBOEntiallUtil
    % 用于处理所有MSBO实体及其子实体的颜色
    methods(Static)
        function ParameterData = handleMSBOEntiall(ParameterData,...
                thisMSBOEntiallIndex,clrnmbr)
            % 获得该186实体的信息
            thisMSBOEntiall=ParameterData{thisMSBOEntiallIndex};
            % 设置该186实体的颜色
            ParameterData{thisMSBOEntiallIndex}.clrnmbr=clrnmbr;
            % 该186实体指向壳的指针
            thisShellEntiallIndex=(thisMSBOEntiall.shell+1)/2;
            ParameterData=MSBOEntiallUtil.handleShellEntiall(ParameterData,...
                thisShellEntiallIndex,clrnmbr);
            
            % 说明：这里对于洞壳的处理可能并不合适，因为没有找到合适的实例
            if thisMSBOEntiall.n>0
                warning('发现洞壳，相关处理可能有问题，请及时处理！');
                thisVoidShellEntityStruct=thisMSBOEntiall.VoidShellEntity;
                for j=1:thisMSBOEntiall.n
                    % 这里处理洞壳
                    thisShellEntiallIndex=(thisVoidShellEntityStruct(j).void+1)/2;
                    ParameterData=MSBOEntiallUtil.handleShellEntiall(ParameterData,...
                        thisShellEntiallIndex,clrnmbr);
                end
            end
        end
        
        function ParameterData = handleShellEntiall(ParameterData,...
                thisShellEntiallIndex,clrnmbr)
            
            % 设置该壳的颜色
            ParameterData{thisShellEntiallIndex}.clrnmbr=clrnmbr;
            % 获得壳实体
            thisShellEntiall=ParameterData{thisShellEntiallIndex};
            
            % 获得壳的参数数据（face和of）
            thisFaceEntiallStruct(:)=thisShellEntiall.FaceEntiall;
            for j=1:length(thisFaceEntiallStruct)
                % 获得当前面的指针
                thisFaceEntiallIndex=(thisFaceEntiallStruct(j).face+1)/2;
                % 修改当前面的颜色
                ParameterData{thisFaceEntiallIndex}.clrnmbr=clrnmbr;
                % 获得当前面实体
                thisFaceEntiall=ParameterData{thisFaceEntiallIndex};
                % 获得环实体的指针数组
                thisLoopEntiallIndexs=(thisFaceEntiall.loop+1)/2;
                for jj=1:thisFaceEntiall.n
                    % 当前环实体的指针
                    thisLoopEntiallIndex=thisLoopEntiallIndexs(jj);
                    % 修改当前环实体的颜色
                    ParameterData{thisLoopEntiallIndex}.clrnmbr=clrnmbr;
                    % 获得当前环实体
                    thisLoopEntiall=ParameterData{thisLoopEntiallIndex};
                    % 获取当前环中的线和边实体的结构
                    thisLineAndEdgeEntiallStruct(:)=...
                        thisLoopEntiall.LineAndEdgeEntiall;
                    for jjj=1:thisLoopEntiall.n
                        % 线
                        curv=thisLineAndEdgeEntiallStruct(jjj).CURV;
                        % 边
                        edge=thisLineAndEdgeEntiallStruct(jjj).edge;
                        ndx=thisLineAndEdgeEntiallStruct(jjj).ndx;
                        if ~isempty(curv)
                            % 修改线的颜色
                            thisLineEntiallIndex=(curv+1)/2;
                            ParameterData{thisLineEntiallIndex}.clrnmbr=clrnmbr;
                        end
                        if ~isempty(edge)
                            % 修改边的颜色
                            thisEdgeEntiallIndex=(edge+1)/2;
                            
                            ParameterData{thisEdgeEntiallIndex}.clrnmbr=clrnmbr;
                            % 获得边实体
                            thisEdgeEntiall=ParameterData{thisEdgeEntiallIndex};
                            % 获得边实体的结构体
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
                                ParameterData{thisCurvEntiallIndex}.clrnmbr=...
                                    clrnmbr;
                                % 顶点实体(502)
                                % TODO:完成顶点部分。
                                thisSvpEntiallIndex=(svp+1)/2;
                                thisTvpEntiallIndex=(tvp+1)/2;
                                % 修改该顶点的颜色
                                ParameterData{thisSvpEntiallIndex}.VertexEntiall...
                                    (sv).clrnmbr=clrnmbr;
                                ParameterData{thisTvpEntiallIndex}.VertexEntiall...
                                    (tv).clrnmbr=clrnmbr;
                                
                                
                                
                                % 顶点实体结束
                                
                            end
                        end
                    end
                end
            end
        end
    end
end

