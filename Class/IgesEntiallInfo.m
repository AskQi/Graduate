classdef IgesEntiallInfo
    properties
        iges_entiall_types;
        iges_entiall_names;
    end
    methods
        % ��ʼ��
        % Warming:�޸����ﲻ����Ч���谡��play���޸���ش��롣
        function obj = IgesEntiallInfo(iges_entiall_file_name)
            [obj.iges_entiall_types,obj.iges_entiall_names]=xlsread(iges_entiall_file_name);
        end
        % ����type��ȡʵ�������
        function entiall_name=getNameByType(obj,entiall_type)
            entiall_id=obj.iges_entiall_types == entiall_type;
            if sum(entiall_id)==0
                entiall_name='δ֪ʵ�� ('+entiall_type+')';
            else
                entiall_name=char(obj.iges_entiall_names(entiall_id));
            end
            
        end
        % ����ʵ�壬��ȡʵ�����Ϣ��֧�ֶ�ȡԭʼ��ʵ����Ϣ��
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
                name='δ��ת����ʵ��';
            end
        end
    end
end