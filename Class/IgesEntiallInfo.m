classdef IgesEntiallInfo
    properties
        iges_entiall_types;
        iges_entiall_names;
    end
    methods
        % 初始化
        % Warming:修改这里不会生效，需啊到play里修改相关代码。
        function obj = IgesEntiallInfo(iges_entiall_file_name)
            [obj.iges_entiall_types,obj.iges_entiall_names]=xlsread(iges_entiall_file_name);
        end
        % 根据type获取实体的名字
        function entiall_name=getNameByType(obj,entiall_type)
            entiall_id=obj.iges_entiall_types == entiall_type;
            if sum(entiall_id)==0
                entiall_name='未知实体 ('+entiall_type+')';
            else
                entiall_name=char(obj.iges_entiall_names(entiall_id));
            end
            
        end
        % 根据实体，获取实体的信息（支持读取原始的实体信息）
        function [info]=getEntiallInfo(obj,thisEntiall)
            [flag,previous_type,previous_name]=getPreviousTypeAndName(obj,thisEntiall);
            type=thisEntiall.type;
            name=getNameByType(obj,type);
            if flag
                info=sprintf('%s(%d)[%s(%d)]',name,type,previous_name,previous_type);
            else
                info=sprintf('%s(%d)',name,type);
            end
            
        end
        function [flag,type,name]=getPreviousTypeAndName(obj,thisEntiall)
            if isfield(thisEntiall,'previous_type')
                flag=true;
                type=thisEntiall.previous_type;
                name=obj.getNameByType(type);
            else
                flag=false;
                type=0;
                name='未经转换的实体';
            end
        end
    end
end