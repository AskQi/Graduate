function [res]=ReadEntiall_128(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
res.type=type;
% ����B�������棬�ڹ���P109
res.name='����B��������';

A=1+Pvec(2)+Pvec(4);%1+K1+M1��u��ڵ����
B=1+Pvec(3)+Pvec(5);
C=(Pvec(2)+1)*(Pvec(3)+1);%(K1+1)*(K2+1), ���Ƶ���������Ȩֵ�ĸ���

res.name='B-NURBS����';
res.original=1;

res.superior=0;

res.k1=Pvec(2);
res.k2=Pvec(3);
res.m1=Pvec(4);
res.m2=Pvec(5);

res.prop1=Pvec(6);
res.prop2=Pvec(7);
res.prop3=Pvec(8);
res.prop4=Pvec(10);
res.prop5=Pvec(11);

res.s=Pvec(11:(11+A));
res.t=Pvec((12+A):(12+A+B));

res.w=reshape(Pvec((13+A+B):(12+A+B+C)),Pvec(2)+1,Pvec(3)+1);%Ȩֵ
res.p=reshape(Pvec((13+A+B+C):(12+A+B+4*C)),3,Pvec(2)+1,Pvec(3)+1);%���Ƶ�

res.u=zeros(1,2);
res.u(1)=Pvec(13+A+B+4*C);
res.u(2)=Pvec(14+A+B+4*C);

res.v=zeros(1,2);
res.v(1)=Pvec(15+A+B+4*C);
res.v(2)=Pvec(16+A+B+4*C);

%TODO:������ݼ���
res.trnsfrmtnmtrx=transformationMatrixPtr;

res.clrnmbr=colorNo;
res.color=[0,0,0];

res.well=false;
end