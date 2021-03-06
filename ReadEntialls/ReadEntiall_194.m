function [res]=ReadEntiall_194(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 正圆锥面实体，在国标P167
res.type=type;

res.name='正圆锥面实体';
res.original=1;
res.superior=1;

res.form=formNo;

res.deloc=Pvec(2);
res.deaxis=Pvec(3);
res.radius=Pvec(4);
res.sangle=Pvec(5);
% 国标中有错误，此处参考V6
if formNo==1
    res.derefd=Pvec(6);
end

res.clrnmbr=colorNo;
res.color=[0,0,0];
res.trnsfrmtnmtrx=transformationMatrixPtr;
res.well=true;
end