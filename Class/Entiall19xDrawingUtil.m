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
                    % ƽ��������ʵ��
                case 192
                    % ��Բ����ʵ��
                case 194
                    % ��Բ׶��ʵ��
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
            CO(:,:,1) = ones(size(zs))*clr(1); % red
            CO(:,:,2) = ones(size(zs))*clr(2); % green
            CO(:,:,3) = ones(size(zs))*clr(3); % blue
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

