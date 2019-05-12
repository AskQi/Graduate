function [res]=ReadEntiall_198(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 圆环面实体，在国标P170
res.type=type;

res.name='圆环面实体';
res.original=1;
res.superior=1;

res.form=formNo;

res.deloc=Pvec(2);
res.deaxis=Pvec(3);
res.majrad=Pvec(4);
res.minrad=Pvec(5);
if formNo==1
    res.defefd=Pvec(6);
end

res.clrnmbr=colorNo;
res.color=[0,0,0];
res.trnsfrmtnmtrx=transformationMatrixPtr;
res.well=true;
end