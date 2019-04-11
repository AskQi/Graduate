function [res]=DrawingEntiall_100(thisEntiall)
% 相关资料在国标P67
% 端点的排序对应于按逆时针方向划出该弧所需的顺序
fprintf("绘制类型：%s(%d)\n",thisEntiall.name,thisEntiall.type);
linespace=0.05;

% p1=thisEntiall.p1;
% p2=thisEntiall.p2;
% fprintf("p1:%d,%d,%d\np2:%d,%d,%d\nlength:%d\n",p1,p2,thisEntiall.length);
% plot3([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)]);
zt=thisEntiall.zt;
x1=thisEntiall.x1;
x2=thisEntiall.x2;
x3=thisEntiall.x3;
y1=thisEntiall.y1;
y2=thisEntiall.y2;
y3=thisEntiall.y3;
R=thisEntiall.R;
t=thisEntiall.vmin:linespace:thisEntiall.vmax+linespace;

x=x1+R*cos(t);
y=y1+R*sin(t);
z=zeros(length(t));
plot3(x,y,z);
% plot3(p(1,:),p(2,:),p(3,:));
res=true;
end