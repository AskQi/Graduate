function [res]=ReadEntiall_196(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% ����ʵ�壬�ڹ���P169
res.type=type;

res.name='����ʵ��';
res.original=1;
res.superior=1;

res.form=formNo;
% ���ĵ��DEָ��
res.deloc=Pvec(2);
% �뾶
res.radius=Pvec(3);
if formNo==1
    %ָ�������DE��ָ��
    res.deaxis=Pvec(4);
    %ָ��ο������DE��ָ��
    res.defefd=Pvec(5);
end

res.clrnmbr=colorNo;
res.color=[0,0,0];
res.trnsfrmtnmtrx=transformationMatrixPtr;
res.well=true;
end