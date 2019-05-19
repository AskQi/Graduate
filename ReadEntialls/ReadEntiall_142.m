function [res]=ReadEntiall_142(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 参数曲面上的曲线上实体，在国标P134
res.type=type;
res.name='参数曲面上的曲线上实体';

res.crtn=Pvec(2);
res.sptr=round((Pvec(3)+1)/2);
res.bptr=round((Pvec(4)+1)/2);
res.cptr=round((Pvec(5)+1)/2);
res.pref=Pvec(6);
res.length=0;

res.mlcrv=0;

res.clrnmbr=colorNo;
res.color=[0,0,0];

res.numcrv=0;

res.well=true;

% POINT
end