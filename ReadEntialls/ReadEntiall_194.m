function [res]=ReadEntiall_194(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% ��Բ׶��ʵ�壬�ڹ���P167
res.type=type;

res.name='��Բ׶��ʵ��';
res.original=1;
res.superior=1;

res.form=formNo;

res.deloc=Pvec(2);
res.deaxis=Pvec(3);
if formNo==0
    res.radius=Pvec(4);
elseif formNo==1
    res.sangle=Pvec(4);
end
res.derefd=Pvec(5);

res.clrnmbr=colorNo;
res.color=[0,0,0];
res.trnsfrmtnmtrx=transformationMatrixPtr;
res.well=true;
end