function [res]=DrawingEntiall_102(thisEntiall)
% 相关资料在国标P67
% 端点的排序对应于按逆时针方向划出该弧所需的顺序
fprintf('绘制类型：%s(%d)\n',thisEntiall.name,thisEntiall.type);

fprintf('复合曲线用于表示多个实体之间的逻辑关系，不绘制。\n');

res=true;
end