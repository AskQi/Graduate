function [res]=ReadEntiall_406(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=type;
% ����ʵ�壬�ڹ���P328-P380
% TODO:����Ҫ��Χ�ڣ���ʱ����˵
res.name='����ʵ�� 406';
res.unknown=char(Pstr);
res.original=1;
res.well=false;
fprintf("type��%d��name��%s\n�������ݲ������������Ҫ�Ļ������\n",...
    res.type,res.name);
end