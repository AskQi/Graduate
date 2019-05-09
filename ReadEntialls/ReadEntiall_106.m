function [res]=ReadEntiall_106(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 2D路径、3D路径简单封封闭平面曲线，实体在各种iges文件中都没找到
% 11和12在国标P76,61在国标P82
res.type=type;

ip=Pvec(2);
n=Pvec(3);
data=Pvec(4,:);

useableForm=[11 12 63];
if any(formNo==useableForm)
    % TODO:完成转换
    switch type
        case 11
            res.name='数据块实体（2D路径）';
            res.zt=Pvec(4);
            res.x=Pvec(5:2:2*n+4);
            res.y=Pvec(6:2:2*n+4);
        case 12
            res.name='数据块实体（3D路径）';
            res.x=Pvec(4:3:3*n+3);
            res.y=Pvec(5:3:3*n+3);
            res.z=Pvec(6:3:3*n+3);
        case 61
            res.name='数据块实体（简单封闭平面曲线）';
            res.zt=Pvec(4);
            res.x=Pvec(5:2:2*n+4);
            res.y=Pvec(6:2:2*n+4);
    end
    res.well=true;
else
    % 不是我们需要处理的格式
    res.unknown=char(Pstr);
    res.well=false;
end

res.original=1;
res.length=0;
res.ip=ip;
res.n=n;
res.data=data;
res.clrnmbr=colorNo;
res.color=[0,0,0];
res.trnsfrmtnmtrx=transformationMatrixPtr;
end