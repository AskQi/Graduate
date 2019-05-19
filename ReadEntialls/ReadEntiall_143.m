function [res]=ReadEntiall_143(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 有界曲面实体，在国标P136
res.type=type;
res.name='有界曲面实体';

res.original=1;

res.trimmed=1;

res.ratio=[0,0];

res.boundarytype=Pvec(2);

res.sptr=round((Pvec(3)+1)/2);

res.n=Pvec(4);

res.bdpt=round((Pvec(5:(4+Pvec(4)))+1)/2);

res.mlcrv=0;

res.nument=0;

res.clrnmbr=colorNo;
res.color=[0,0,0];

if Pvec(2)==1
    res.well=true;
else
    res.well=false;
end

end