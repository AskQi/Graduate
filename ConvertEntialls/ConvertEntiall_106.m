function [ParameterData,enttyCut,noentI]=ConvertEntiall_106(ParameterData,i,noentI)
% ���ݿ�ʵ�壬��������ڹ���P76
enttyCut=0;

thisEntiall=ParameterData{i};
n=thisEntiall.n;
% ip=thisEntiall.ip;

trnsfrmtnmtrx=thisEntiall.trnsfrmtnmtrx;
clrnmbr=thisEntiall.clrnmbr;

form=thisEntiall.form;
useableForm=[11 12 63];
if any(form==useableForm)
    switch form
        case 11
            %���ݿ�ʵ�壨2D·����
            zt=thisEntiall.zt;
            xs=thisEntiall.x;
            ys=thisEntiall.y;
            for j=1:n-1
                x1=xs(j);y1=ys(j);z1=zt;
                x2=xs(j+1);y2=ys(j+1);z2=zt;
                lineEntiall=newLineEntiall(x1,y1,z1,x2,y2,z2,trnsfrmtnmtrx,clrnmbr);
                noentI=noentI+1;
                ParameterData{noentI}=lineEntiall;
            end
            
        case 12
            %���ݿ�ʵ�壨3D·����
            zs=thisEntiall.z;
            xs=thisEntiall.x;
            ys=thisEntiall.y;
            for j=1:n-1
                x1=xs(j);y1=ys(j);z1=zs(j);
                x2=xs(j+1);y2=ys(j+1);z2=zs(j+1);
                lineEntiall=newLineEntiall(x1,y1,z1,x2,y2,z2,trnsfrmtnmtrx,clrnmbr);
                noentI=noentI+1;
                ParameterData{noentI}=lineEntiall;
            end
        case 61
            %���ݿ�ʵ�壨�򵥷��ƽ�����ߣ�
            zt=thisEntiall.zt;
            xs=thisEntiall.x;
            ys=thisEntiall.y;
            for j=1:n-1
                x1=xs(j);y1=ys(j);z1=zt;
                x2=xs(j+1);y2=ys(j+1);z2=zt;
                lineEntiall=newLineEntiall(x1,y1,z1,x2,y2,z2,trnsfrmtnmtrx,clrnmbr);
                noentI=noentI+1;
                ParameterData{noentI}=lineEntiall;
            end
    end
else
    % ����������Ҫ����ĸ�ʽ
    enttyCut=-1;
end
    function lineEntiall=newLineEntiall(x1,y1,z1,x2,y2,z2,trnsfrmtnmtrx,clrnmbr)
        lineEntiall.type=110;
        lineEntiall.name='ֱ��';
        lineEntiall.previous_type=106;
        lineEntiall.previous_name='���ݿ�ʵ��';
        lineEntiall.p1=[x1 y1 z1];
        lineEntiall.x1=x1;
        lineEntiall.y1=y1;
        lineEntiall.z1=z1;
        
       lineEntiall.p2=[x2 y2 z2];
        lineEntiall.x2=x2;
        lineEntiall.y2=y2;
        lineEntiall.z2=z2;
        
        lineEntiall.length=0;
        lineEntiall.original=1;
        lineEntiall.superior=0;
        
        lineEntiall.trnsfrmtnmtrx=trnsfrmtnmtrx;
        lineEntiall.clrnmbr=clrnmbr;
        lineEntiall.color=[0,0,0];
        lineEntiall.well=true;
    end

end