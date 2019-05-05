classdef MSBOEntiallUtil
    % ���ڴ�������MSBOʵ�弰����ʵ�����ɫ
    
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
                                % ���ߵ�DEָ��
                                curv=thisEdgeEntiallStruct(jjjj).curv;
                                % �����б�ʵ�壨502����DEָ��
                                svp=thisEdgeEntiallStruct(jjjj).svp;
                                % �����б�ʵ���һ����ʼ�����DEָ��
                                sv=thisEdgeEntiallStruct(jjjj).sv;
                                % �����б�ʵ���һ����ֹ�����DEָ��
                                tvp=thisEdgeEntiallStruct(jjjj).tvp;
                                % �����б�ʵ����ָ��i���ǵ��б�����
                                tv=thisEdgeEntiallStruct(jjjj).tv;
                                
                                thisCurvEntiallIndex=(curv+1)/2;
                                ParameterData{thisCurvEntiallIndex}.clrnmbr=clrnmbr;
                                % ����ʵ��(502)
                                % TODO:��ɶ��㲿�֡�
                                thisSvpEntiallIndex=(svp+1)/2;
                                ParameterData{thisSvpEntiallIndex}.clrnmbr=clrnmbr;

                                thisSvEntiallIndex=(sv+1)/2;
                                thisTvpEntiallIndex=(tvp+1)/2;
                                thisTvEntiallIndex=(tv+1)/2;
                                % ����ʵ�����
                                
                            end
                        end
                        
                    end
                end
            end
            
        end
    end
end

