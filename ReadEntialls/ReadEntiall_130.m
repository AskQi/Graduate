function [res]=ReadEntiall_130(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 偏置曲线，在国标P111
res.type=type;
res.name='偏置曲线';

del1=Pvec(2);
flag=Pvec(3);
del2=Pvec(4);
ndim=Pvec(5);
ptype=Pvec(6);
d1=Pvec(7);
td1=Pvec(8);
d2=Pvec(9);
td2=Pvec(10);
vx=Pvec(11);
vy=Pvec(12);

vz=Pvec(13);
tt1=Pvec(14);
tt2=Pvec(15);

%TODO:根据原曲面生成新曲面

res.del1=del1;
res.flag=flag;
res.del2=del2;
res.ndim=ndim;
res.ptype=ptype;
res.d1=d1;
res.td1=td1;
res.d2=d2;
res.td2=td2;
res.vx=vx;
res.vy=vy;
res.vz=vz;
res.tt1=tt1;
res.tt2=tt2;


res.clrnmbr=colorNo;
res.color=[0,0,0];
res.trnsfrmtnmtrx=transformationMatrixPtr;

res.original=1;
res.length=0;
res.well=false;
end