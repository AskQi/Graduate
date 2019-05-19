function [res]=ReadEntiall_196(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 球面实体，在国标P169
res.type=type;

res.name='球面实体';
res.original=1;
res.superior=1;

res.form=formNo;
% 中心点的DE指针
res.deloc=Pvec(2);
% 半径
res.radius=Pvec(3);
if formNo==1
    %指向轴向的DE的指针
    res.deaxis=Pvec(4);
    %指向参考方向的DE的指针
    res.defefd=Pvec(5);
end

res.clrnmbr=colorNo;
res.color=[0,0,0];
res.trnsfrmtnmtrx=transformationMatrixPtr;
res.well=true;
end