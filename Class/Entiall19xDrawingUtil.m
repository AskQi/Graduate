classdef Entiall19xDrawingUtil
    % 19xʵ����ƹ��߰�
    %   ֻ��19xʵ����������л���
    properties(Constant)
        support_19x_types=[190 192 194 196 198];
    end
    
    methods(Static)
        function hl = drawing(thisEntiall,srf,clr,fine_flag)
            if thisEntiall.well==false
                return;
            end
            hold on;
            switch thisEntiall.type
                case 190
                    % ƽ��ʵ��
                    % ƽ����һ��
                    p=thisEntiall.p;
                    x0=p(1);y0=p(2);z0=p(3);
                    % �ᾭ��������
                    p1=thisEntiall.p1;
                    p2=thisEntiall.p2;
                    % ������
                    n=p2-p1;
                    A=n(1);B=n(2);C=n(3);
                    if fine_flag
                       space=0.1;
                    else
                       space=0.5;
                    end
                    [X,Y]=meshgrid(-5:space:5);
                    Z=z0-A/C*(X-x0)-B/C*(Y-y0);
                    hl = painting(X,Y,Z,srf,clr,fine_flag);
                    
                case 192
                    % ��Բ����ʵ�壬�ڹ���P165
                    %�ᾭ��������
                    p1=thisEntiall.p1;
                    p2=thisEntiall.p2;
                    %��С�뾶
                    radius=thisEntiall.radius;
                    
                    R=radius;%�뾶
                    a=0;%ԭ��x����
                    b=0;%ԭ��y����
                    h=2;%Բ���߶�
                    m=100;%�ָ��ߵ�����
                    [x,y,z]=cylinder(R,m);%������(0,0)ΪԲ�ģ��߶�Ϊ[0,1]���뾶ΪR��Բ��
                    X=x+a;%ƽ��x��
                    Y=y+b;%ƽ��y�ᣬ��Ϊ(a,b)Ϊ��Բ��Բ��
                    Z=h*z;%�߶ȷŴ�h��
                    
                    hl = painting(X,Y,Z,srf,clr,fine_flag);
                case 194
                    % ��Բ׶��ʵ�壬�ڹ���P167
                    % ����
                    p=thisEntiall.p;
                    x0=p(1);y0=p(2);z0=p(3);
                    %�ᾭ��������
                    p1=thisEntiall.p1;
                    p2=thisEntiall.p2;
                    %��С�뾶
                    sangle=thisEntiall.sangle;
                    radius=thisEntiall.radius;
                    
                    t = 0 :0.01:tan(sangle/180*pi);%����tan(25/180*pi)=tan25��.��������ı�Ƕ�
                    [X,Y,Z] = cylinder(t);
                    
                    hl = painting(X,Y,Z,srf,clr,fine_flag);
                case 196
                    % ����ʵ�壬�ڹ���P169
                    % ����
                    p=thisEntiall.p;
                    x0=p(1);y0=p(2);z0=p(3);
                    %�뾶
                    r=thisEntiall.radius;
                    [x,y,z]=sphere(50);
                    X=r*x-x0;
                    Y=r*y-y0;
                    Z=r*z-z0;
                    hl = painting(X,Y,Z,srf,clr,fine_flag);

                    
                case 198
                    % Բ����ʵ��
                    % ����
                    p=thisEntiall.p;
                    x0=p(1);y0=p(2);z0=p(3);
                    %�ᾭ��������
                    p1=thisEntiall.p1;
                    p2=thisEntiall.p2;
                    %��С�뾶
                    majrad=thisEntiall.majrad;
                    minrad=thisEntiall.minrad;
                    
                    
                    r=(majrad-minrad)/2;	% Բ�İ뾶
                    
                    d=majrad-r;	% Բ�������ĵľ���
                    
                    phi=(0:pi/16:2*pi)';	% points of small circle
                    
                    alpha=(0:pi/32:2*pi)';	% points of big circle
                    
                    X2=[d+r*cos(phi) r*sin(phi)];	% small circle
                    
                    Z=X2(:,2)';Z=Z(ones(1,length(alpha)),:);
                    
                    X=Z;Y=Z;
                    
                    for i=1:length(alpha)
                        
                        X(i,:)=cos(alpha(i))*X2(:,1)';
                        Y(i,:)=sin(alpha(i))*X2(:,1)';
                        
                    end
                    % TODO:����任
                    hl = painting(X,Y,Z,srf,clr,fine_flag);
            end
        end
        
        function hl = painting(X,Y,Z,srf,clr,fine_flag)
            CO(:,:,1) = ones(size(Z))*clr(1); % red
            CO(:,:,2) = ones(size(Z))*clr(2); % green
            CO(:,:,3) = ones(size(Z))*clr(3); % blue
            if srf==1
                % patch
                if fine_flag
                    hl=surf(X,Y,Z,CO);
                else
                    hl=surf(X,Y,Z,CO);
                end
                
            elseif srf==2
                % mesh
                hl=mesh(X,Y,Z,CO);
            end
        end
    end
end

