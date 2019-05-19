function [res]=ReadEntiall_128(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% ����B�������棬�ڹ���P109
res.type=type;
global mat3x3
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
ulinear=1;
for k=1:(res.k2+1)%k��ʾ��k�п��Ƶ�
    meaP=mean(res.p(:,:,k),2);%��dim=2���ֱ����������������ֵ��ƽ��ֵ����1������
    Si=svd(res.p(:,:,k)*res.p(:,:,k)'-((res.k1+1)*meaP)*meaP');
    %������ֵ����
    if Si(2)*1e6>Si(1)
        ulinear=0;
        break
    end
end
if ulinear
    vlinear=0;
else
    vlinear=1;
    for j=1:(res.k1+1)
        meaP(:)=0;
        mat3x3(:)=0;
        for k=1:(res.k2+1)
            meaP=meaP+res.p(:,j,k);
            mat3x3=mat3x3+res.p(:,j,k)*res.p(:,j,k)';
        end
        Si=svd((res.k2+1)*mat3x3-meaP*meaP');
        if Si(2)*1e6>Si(1)
            vlinear=0;
            break
        end
    end
end
res.isplane=false;
res.ulinear=ulinear;
res.vlinear=vlinear;

% NURBS ����

res.nurbs.form='B-NURBS';

res.nurbs.dim=4;
%�����͵��ϱ�
res.nurbs.number=zeros(1,2);
res.nurbs.number(1)=Pvec(2)+1;
res.nurbs.number(2)=Pvec(3)+1;

res.nurbs.coefs=zeros(4,Pvec(2)+1,Pvec(3)+1);
res.nurbs.coefs(4,:,:)=reshape(Pvec((13+A+B):(12+A+B+C)),Pvec(2)+1,Pvec(3)+1);%���������ĸ�ֵ��ΪȨֵ
res.nurbs.coefs(1:3,:,:)=res.p;

res.nurbs.coefs(1:3,:,:)=repmat(res.nurbs.coefs(4,:,:),3,1).*res.nurbs.coefs(1:3,:,:);
%Ȩֵ����������ѿ���������˵õ��������
res.nurbs.knots=cell(1,2);
res.nurbs.knots{1}=Pvec(11:(11+A));
res.nurbs.knots{2}=Pvec((12+A):(12+A+B));

%����������Ľ�
res.nurbs.order=zeros(1,2);
res.nurbs.order(1)=Pvec(4)+1;
res.nurbs.order(2)=Pvec(5)+1;

[res.dnurbs,res.d2nurbs]=nrbDerivativesIGES(res.nurbs);

res.ratio=[0,0];

res.trnsfrmtnmtrx=transformationMatrixPtr;

res.clrnmbr=colorNo;
res.color=[0,0,0];

res.well=true;
end