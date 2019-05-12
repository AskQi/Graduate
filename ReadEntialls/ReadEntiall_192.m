function [res]=ReadEntiall_192(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 正圆柱面实体，在国标P165
res.type=type;

res.name='正圆柱面实体';
res.original=1;
res.superior=1;

res.form=formNo;

res.deloc=Pvec(2);
res.deaxis=Pvec(3);
res.radius=Pvec(4);

if formNo==1
    res.derefd=Pvec(5);
end

res.clrnmbr=colorNo;
res.color=[0,0,0];
res.trnsfrmtnmtrx=transformationMatrixPtr;
res.well=true;
end