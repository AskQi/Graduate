function [res]=DrawingEntiall_112(thisEntiall)
% ��������ڹ���P87
% ȱʡ��������ʽ��
% C(t) = P1 + t*(P2-P1) , t��[0,1]
fprintf('�������ͣ�%s(%d)\n',thisEntiall.name,thisEntiall.type);

p1=thisEntiall.p1;
p2=thisEntiall.p2;
fprintf('p1:%d,%d,%d\np2:%d,%d,%d\nlength:%d\n',p1,p2,thisEntiall.length);
plot3([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)]);

res=true;
end