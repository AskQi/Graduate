function [res]=ReadEntiall_110(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 相关资料在国标P85
% 缺省参数表表达式：
% C(t) = P1 + t*(P2-P1) , t∈[0,1]
res.type=type;
res.name='直线';
res.original=1;
p1=Pvec(2:4)';
p2=Pvec(5:7)';

res.p1=p1;
res.x1=p1(1);
res.y1=p1(2);
res.z1=p1(3);

res.p2=p2;
res.x2=p2(1);
res.y2=p2(2);
res.z2=p2(3);

res.length=norm(p1-p2);
% D部分记录的颜色编号
res.clrnmbr=colorNo;
res.color=[0,0,0];
fprintf("type：%d，name：%s\np1:%d,%d,%d\np2%d,%d,%d\n",...
    res.type,res.name,res.p1,res.p2);

res.well=true;
end