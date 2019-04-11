function [res]=ReadEntiall_100(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 相关资料在国标P67
% 缺省参数表表达式：
% C(t) = (X1+R*cost,Y1+R*sint,Z1)
% R = sqrt((X1-X2)^2+(Y1-Y2)^2)；
res.type=type;
res.name='圆弧';
res.original=0;

zt=Pvec(2);
x1=Pvec(3);
y1=Pvec(4);
x2=Pvec(5);
y2=Pvec(6);
x3=Pvec(7);
y3=Pvec(8);
% 求得半径
R=0.5*(sqrt((x2-x1)^2+(y2-y1)^2)+sqrt((x3-x1)^2+(y3-y1)^2));

vmin=atan2(y2-y1,x2-x1);
vmax=atan2(y3-y1,x3-x1);

if vmin<0
    vmin=vmin+2*pi;
end
if vmax<0
    vmax=vmax+2*pi;
end
if vmax<vmin
    vmax=vmax+2*pi;
end
if (vmax-vmin)<1e-12
    vmax=vmax+2*pi;
end

res.zt=zt;
res.x1=x1;
res.y1=y1;
res.x2=x2;
res.y2=y2;
res.x3=x3;
res.y3=y3;
res.R=R;

res.vmin=vmin;
res.vmax=vmax;

res.well=true;
end