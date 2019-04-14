function [res]=ReadEntiall_406(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=type;
% 特性实体，在国标P328-P380
% TODO:不在要求范围内，有时间再说
res.name='特性实体 406';
res.unknown=char(Pstr);
res.original=1;
res.well=false;
fprintf("type：%d，name：%s\n该类型暂不处理，后边有需要的话再添加\n",...
    res.type,res.name);
end