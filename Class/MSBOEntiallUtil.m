classdef MSBOEntiallUtil
    % ���ڴ�������MSBOʵ�弰����ʵ�����ɫ
    methods(Static)
        function ParameterData = handleMSBOEntiall(ParameterData,...
                thisMSBOEntiallIndex,clrnmbr)
            % ��ø�186ʵ�����Ϣ
            thisMSBOEntiall=ParameterData{thisMSBOEntiallIndex};
            % ���ø�186ʵ�����ɫ
            ParameterData{thisMSBOEntiallIndex}.clrnmbr=clrnmbr;
            % ��186ʵ��ָ��ǵ�ָ��
            thisShellEntiallIndex=(thisMSBOEntiall.shell+1)/2;
            ParameterData=MSBOEntiallUtil.handleShellEntiall(ParameterData,...
                thisShellEntiallIndex,clrnmbr);
            
            % ˵����������ڶ��ǵĴ�����ܲ������ʣ���Ϊû���ҵ����ʵ�ʵ��
            if thisMSBOEntiall.n>0
                warning('���ֶ��ǣ���ش�����������⣬�뼰ʱ����');
                thisVoidShellEntityStruct=thisMSBOEntiall.VoidShellEntity;
                for j=1:thisMSBOEntiall.n
                    % ���ﴦ����
                    thisShellEntiallIndex=(thisVoidShellEntityStruct(j).void+1)/2;
                    ParameterData=MSBOEntiallUtil.handleShellEntiall(ParameterData,...
                        thisShellEntiallIndex,clrnmbr);
                end
            end
        end
        
        function ParameterData = handleShellEntiall(ParameterData,...
                thisShellEntiallIndex,clrnmbr)
            
            % ���øÿǵ���ɫ
            ParameterData{thisShellEntiallIndex}.clrnmbr=clrnmbr;
            % ��ÿ�ʵ��
            thisShellEntiall=ParameterData{thisShellEntiallIndex};
            
            % ��ÿǵĲ������ݣ�face��of��
            thisFaceEntiallStruct(:)=thisShellEntiall.FaceEntiall;
            for j=1:length(thisFaceEntiallStruct)
                % ��õ�ǰ���ָ��
                thisFaceEntiallIndex=(thisFaceEntiallStruct(j).face+1)/2;
                % �޸ĵ�ǰ�����ɫ
                ParameterData{thisFaceEntiallIndex}.clrnmbr=clrnmbr;
                % ��õ�ǰ��ʵ��
                thisFaceEntiall=ParameterData{thisFaceEntiallIndex};
                % ��û�ʵ���ָ������
                thisLoopEntiallIndexs=(thisFaceEntiall.loop+1)/2;
                for jj=1:thisFaceEntiall.n
                    % ��ǰ��ʵ���ָ��
                    thisLoopEntiallIndex=thisLoopEntiallIndexs(jj);
                    % �޸ĵ�ǰ��ʵ�����ɫ
                    ParameterData{thisLoopEntiallIndex}.clrnmbr=clrnmbr;
                    % ��õ�ǰ��ʵ��
                    thisLoopEntiall=ParameterData{thisLoopEntiallIndex};
                    % ��ȡ��ǰ���е��ߺͱ�ʵ��Ľṹ
                    thisLineAndEdgeEntiallStruct(:)=...
                        thisLoopEntiall.LineAndEdgeEntiall;
                    for jjj=1:thisLoopEntiall.n
                        % ��
                        curv=thisLineAndEdgeEntiallStruct(jjj).CURV;
                        % ��
                        edge=thisLineAndEdgeEntiallStruct(jjj).edge;
                        ndx=thisLineAndEdgeEntiallStruct(jjj).ndx;
                        if ~isempty(curv)
                            % �޸��ߵ���ɫ
                            thisLineEntiallIndex=(curv+1)/2;
                            ParameterData{thisLineEntiallIndex}.clrnmbr=clrnmbr;
                        end
                        if ~isempty(edge)
                            % �޸ıߵ���ɫ
                            thisEdgeEntiallIndex=(edge+1)/2;
                            
                            ParameterData{thisEdgeEntiallIndex}.clrnmbr=clrnmbr;
                            % ��ñ�ʵ��
                            thisEdgeEntiall=ParameterData{thisEdgeEntiallIndex};
                            % ��ñ�ʵ��Ľṹ��
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
                                ParameterData{thisCurvEntiallIndex}.clrnmbr=...
                                    clrnmbr;
                                % ����ʵ��(502)
                                % TODO:��ɶ��㲿�֡�
                                thisSvpEntiallIndex=(svp+1)/2;
                                thisTvpEntiallIndex=(tvp+1)/2;
                                % �޸ĸö������ɫ
                                ParameterData{thisSvpEntiallIndex}.VertexEntiall...
                                    (sv).clrnmbr=clrnmbr;
                                ParameterData{thisTvpEntiallIndex}.VertexEntiall...
                                    (tv).clrnmbr=clrnmbr;
                                
                                
                                
                                % ����ʵ�����
                                
                            end
                        end
                    end
                end
            end
        end
    end
end

