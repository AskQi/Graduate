classdef IgesColorUtil
    properties
        entities2color;
        defaultColor;
        ParameterData;
    end
    methods
        function obj = IgesColorUtil(ParameterData,defaultColor)
            obj.entities2color=[102 110 116 126 128];
            obj.defaultColor=defaultColor;
            obj.ParameterData=ParameterData;
        end
        function isNeedHandle=isNeedHandleColor(obj,type)
            if any(type==obj.entities2color)
                isNeedHandle=true;
            else
                isNeedHandle=false;
            end
        end
        function thisEntiall=handleParameterDataColor(obj,i)
            if any(obj.ParameterData{i}.type==obj.entities2color)
                if obj.ParameterData{i}.well
                    if obj.ParameterData{i}.clrnmbr>0
                        % Color代码
                        if obj.ParameterData{i}.clrnmbr==2
                            obj.ParameterData{i}.color(1)=1;
                        elseif obj.ParameterData{i}.clrnmbr==3
                            obj.ParameterData{i}.color(2)=1;
                        elseif obj.ParameterData{i}.clrnmbr==4
                            obj.ParameterData{i}.color(3)=1;
                        elseif obj.ParameterData{i}.clrnmbr==5
                            obj.ParameterData{i}.color(1)=1;
                            obj.ParameterData{i}.color(2)=1;
                        elseif obj.ParameterData{i}.clrnmbr==6
                            obj.ParameterData{i}.color(1)=1;
                            obj.ParameterData{i}.color(3)=1;
                        elseif obj.ParameterData{i}.clrnmbr==7
                            obj.ParameterData{i}.color(2)=1;
                            obj.ParameterData{i}.color(3)=1;
                        elseif obj.ParameterData{i}.clrnmbr==8
                            obj.ParameterData{i}.color(:)=1;
                        end
                    elseif obj.ParameterData{i}.clrnmbr==0
                        % 默认颜色
                        obj.ParameterData{i}.color(:)=obj.defaultColor;
                    else
                        % 314实体中的颜色
                        obj.ParameterData{i}.color(:)=obj.ParameterData{-obj.ParameterData{i}.clrnmbr}.color;
                    end
                end
            end
			thisEntiall=obj.ParameterData{i};
        end
    end
end