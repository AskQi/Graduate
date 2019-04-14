classdef IgesColorUtil
    properties
        entities2color;
        defaultColor;
    end
    methods
        function obj = IgesColorUtil(defaultColor)
            obj.entities2color=[102 110 116 126 128];
            obj.defaultColor=defaultColor;
        end
        function isNeedHandle=isNeedHandleColor(obj,thisEntiall)
            if any(thisEntiall.type==obj.entities2color)
                isNeedHandle=true;
            else
                isNeedHandle=false;
            end
        end
        function thisEntiall=handleParameterDataColor(obj,ParameterData,i)
            if any(ParameterData{i}.type==obj.entities2color)
                if ParameterData{i}.well
                    if ParameterData{i}.clrnmbr>0
                        
                        % Color代码
                        if ParameterData{i}.clrnmbr==2
                            ParameterData{i}.color(1)=1;
                        elseif ParameterData{i}.clrnmbr==3
                            ParameterData{i}.color(2)=1;
                        elseif ParameterData{i}.clrnmbr==4
                            ParameterData{i}.color(3)=1;
                        elseif ParameterData{i}.clrnmbr==5
                            ParameterData{i}.color(1)=1;
                            ParameterData{i}.color(2)=1;
                        elseif ParameterData{i}.clrnmbr==6
                            ParameterData{i}.color(1)=1;
                            ParameterData{i}.color(3)=1;
                        elseif ParameterData{i}.clrnmbr==7
                            ParameterData{i}.color(2)=1;
                            ParameterData{i}.color(3)=1;
                        elseif ParameterData{i}.clrnmbr==8
                            ParameterData{i}.color(:)=1;
                        end
                        
                    elseif ParameterData{i}.clrnmbr==0
                        
                        % 默认颜色
                        ParameterData{i}.color(:)=obj.defaultColor;
                        
                    else
                        
                        % 314实体中的颜色
                        ParameterData{i}.color(:)=ParameterData{-ParameterData{i}.clrnmbr}.color;
                        
                    end
                    thisEntiall=ParameterData{i};
                end
            end
        end
    end
end