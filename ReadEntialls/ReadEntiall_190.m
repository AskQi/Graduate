function [res]=ReadEntiall_190(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 平面内曲面实体，在国标P163
res.type=type;

res.name='平面实体';
res.original=1;
res.superior=1;

res.form=formNo;

res.deloc=Pvec(2);
res.denrml=Pvec(3);
if formNo==1
    res.derefd=Pvec(4);
end

res.clrnmbr=colorNo;
res.color=[0,0,0];
res.trnsfrmtnmtrx=transformationMatrixPtr;
res.well=true;
end