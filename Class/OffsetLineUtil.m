classdef OffsetLineUtil
    %OffsetLineUtil ����ƫ�����ߵ���
    methods(Static)
        function ParameterData = handleOffsetLine(ParameterData,i)
            %handleOffsetSurface ����ƫ������
            if ParameterData{i}.type==130
                entiall=ParameterData{i}.del1;
                ParameterData{entiall}.superior=1;
            end
        end
    end
end

