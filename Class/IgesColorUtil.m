classdef IgesColorUtil
    properties
        entities2color;
        colorMap;
        defaultColor;
    end
    methods
        function obj = IgesColorUtil(colorMap,defaultColor)
            obj.entities2color=[102 104 110 112 114 116 118 120 122 124 ...
                126 128 130 140 186 502 504 508 510 514];
            obj.colorMap=colorMap;
            obj.defaultColor=defaultColor;
        end
        function isNeedHandle=isNeedHandleColor(obj,type)
            if any(type==obj.entities2color)
                isNeedHandle=true;
            else
                isNeedHandle=false;
            end
        end
        function thisEntiall=handleParameterDataColor(obj,thisEntiall)
            if any(thisEntiall.type==obj.entities2color)
                if thisEntiall.well
                    clrnmbr=thisEntiall.clrnmbr;
                    if clrnmbr>0
                        % Color代码
                        if clrnmbr==1
                            thisEntiall.color(:)=0;
                        elseif clrnmbr==2
                            thisEntiall.color(1)=1;
                        elseif clrnmbr==3
                            thisEntiall.color(2)=1;
                        elseif clrnmbr==4
                            thisEntiall.color(3)=1;
                        elseif clrnmbr==5
                            thisEntiall.color(1)=1;
                            thisEntiall.color(2)=1;
                        elseif clrnmbr==6
                            thisEntiall.color(1)=1;
                            thisEntiall.color(3)=1;
                        elseif clrnmbr==7
                            thisEntiall.color(2)=1;
                            thisEntiall.color(3)=1;
                        elseif clrnmbr==8
                            thisEntiall.color(:)=1;
                        end
                    elseif clrnmbr==0
                        % 默认颜色
                        thisEntiall.color(:)=obj.defaultColor;
                    else
                        if any(clrnmbr==cell2mat(keys(obj.colorMap)))
                            % 314实体中的颜色
                            thisEntiall.color(:)=obj.colorMap(clrnmbr);
                        end
                    end
                end
            end
        end
    end
end