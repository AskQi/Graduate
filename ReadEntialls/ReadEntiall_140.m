function [res]=ReadEntiall_140(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=type;
% 偏置曲面，在国标P130
res.name='偏置曲面';

res.original=1;

res.nx=Pvec(2);
res.ny=Pvec(3);
res.nz=Pvec(4);
res.d=Pvec(5);
res.de=round((Pvec(6)+1)/2);

res.superior=0;

res.trnsfrmtnmtrx=transformationMatrixPtr;

res.clrnmbr=colorNo;
res.color=[0,0,0];

res.ratio=[0,0];

res.isplane=false;
res.ulinear=0;
res.vlinear=0;

res.well=true;
end