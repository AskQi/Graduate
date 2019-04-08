function [res]=ReadEntiall_406(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=type;

% TODO:还不知道怎么弄
res.name='未处理类型 406';
res.unknown=char(Pstr);
res.original=1;
res.well=false;
fprintf("type：%d，name：%s\n该类型还不知道该怎么处理\n",...
    res.type,res.name);
end