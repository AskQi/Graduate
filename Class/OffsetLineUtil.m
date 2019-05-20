classdef OffsetLineUtil
    %OffsetLineUtil 处理偏置曲线的类
    methods(Static)
        function ParameterData = handleOffsetLine(ParameterData,i)
            %handleOffsetSurface 处理偏置曲面
            if ParameterData{i}.type==130
                entiall=ParameterData{i}.del1;
                ParameterData{entiall}.superior=1;
            end
        end
    end
end

