function [res]=ReadEntiall_406(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=type;

% TODO:����֪����ôŪ
res.name='δ�������� 406';
res.unknown=char(Pstr);
res.original=1;
res.well=false;
fprintf("type��%d��name��%s\n�����ͻ���֪������ô����\n",...
    res.type,res.name);
end