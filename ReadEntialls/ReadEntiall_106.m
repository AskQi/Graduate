function [res]=ReadEntiall_106(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 2D·����3D·���򵥷���ƽ�����ߣ�ʵ���ڸ���iges�ļ��ж�û�ҵ�
% 11��12�ڹ���P76,61�ڹ���P82
res.type=type;

ip=Pvec(2);
n=Pvec(3);
data=Pvec(4,:);

useableForm=[11 12 63];
if any(formNo==useableForm)
    % TODO:���ת��
    switch type
        case 11
            res.name='���ݿ�ʵ�壨2D·����';
            res.zt=Pvec(4);
            res.x=Pvec(5:2:2*n+4);
            res.y=Pvec(6:2:2*n+4);
        case 12
            res.name='���ݿ�ʵ�壨3D·����';
            res.x=Pvec(4:3:3*n+3);
            res.y=Pvec(5:3:3*n+3);
            res.z=Pvec(6:3:3*n+3);
        case 61
            res.name='���ݿ�ʵ�壨�򵥷��ƽ�����ߣ�';
            res.zt=Pvec(4);
            res.x=Pvec(5:2:2*n+4);
            res.y=Pvec(6:2:2*n+4);
    end
    res.well=true;
else
    % ����������Ҫ����ĸ�ʽ
    res.unknown=char(Pstr);
    res.well=false;
end

res.original=1;
res.length=0;
res.ip=ip;
res.n=n;
res.data=data;
res.clrnmbr=colorNo;
res.color=[0,0,0];
res.trnsfrmtnmtrx=transformationMatrixPtr;
end