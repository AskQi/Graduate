function [res]=ReadEntiall_406(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=type;

% TODO:还不知道怎么弄
res.name='特性实体 406';
res.unknown=char(Pstr);
res.original=1;
res.well=false;
fprintf("type：%d，name：%s\n该类型暂不处理，后边有需要的话再添加\n",...
    res.type,res.name);
end