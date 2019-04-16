classdef IgesEntiallInfo
    properties
        iges_entiall_types;
        iges_entiall_names;
    end
    methods
        function obj = IgesEntiallInfo(iges_entiall_file_name)
            [obj.iges_entiall_types,obj.iges_entiall_names]=xlsread(iges_entiall_file_name);
        end
        function entiall_name=getNameByType(obj,entiall_type)
            entiall_id=obj.iges_entiall_types == entiall_type;
            if sum(entiall_id)==0
                entiall_name='Ξ΄ΦªΚµΜε ('+entiall_type+')';
            else
                entiall_name=char(obj.iges_entiall_names(entiall_id));
            end
            
        end
    end
end