function [res]=ReadEntiall_314(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
global defaultColor
% ���˵����V6��׼P386

res.type=type;
res.name='��ɫ';

inn=find(or(Pstr==44,Pstr==59));
% ��ԭɫ�ٷֱȣ�����ֵ�������������ɫ
res.cc1=str2num(char(Pstr((inn(1)+1):(inn(2)-1))));
res.cc2=str2num(char(Pstr((inn(2)+1):(inn(3)-1))));
res.cc3=str2num(char(Pstr((inn(3)+1):(inn(4)-1))));
res.color=[res.cc1 res.cc2 res.cc3]/100;

defaultColor=res.color;
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
fprintf("type��%d��name��%s\ncc1��%s��cc2��%s��cc3��%s\ncname��%s\n",...
    res.type,res.name,res.cc1,...
    res.cc2,res.cc3,res.cname);

end