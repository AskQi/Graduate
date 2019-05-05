function [res]=ReadEntiall_314(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 颜色实体，在国标P256
% 如果在实际使用中发现颜色号为一个负数，说明使用的是自定义颜色。
% 负数的值为这个颜色所在的目录行号
res.type=type;
res.name='颜色实体';

inn=find(or(Pstr==44,Pstr==59));
% 三原色百分比，三个值组合起来就是颜色
res.cc1=str2num(char(Pstr((inn(1)+1):(inn(2)-1))));
res.cc2=str2num(char(Pstr((inn(2)+1):(inn(3)-1))));
res.cc3=str2num(char(Pstr((inn(3)+1):(inn(4)-1))));
res.color=[res.cc1 res.cc2 res.cc3]/100;

if length(inn)>4
    inn2=find(Pstr(1:(inn(5)-1))==72);
    if isempty(inn2)
        res.cname='';
    else
        res.cname=char(Pstr((inn2(1)+1):(inn(5)-1)));
    end
else
    res.cname='';
end

res.original=1;
res.well=true;
fprintf('类型：%d，名称：%s\ncc1：%s，cc2：%s，cc3：%s\ncname：%s\n',...
    res.type,res.name,res.cc1,...
    res.cc2,res.cc3,res.cname);

end