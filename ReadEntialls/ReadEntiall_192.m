function [res]=ReadEntiall_192(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% ��Բ����ʵ�壬�ڹ���P165
res.type=type;

res.name='��Բ����ʵ��';
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