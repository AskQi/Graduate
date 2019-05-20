classdef Entiall19xDrawingUtil
    % 19x实体绘制工具包
    %   只有19x实体在这里进行绘制
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
                    % 平面内曲面实体
                case 192
                    % 正圆柱面实体
                case 194
                    % 正圆锥面实体
                case 196
                    % 球面实体，在国标P169
                    % 球心
                    p=thisEntiall.p;
                    x0=p(1);y0=p(2);z0=p(3);
                    %半径
                    r=thisEntiall.radius;
                    [x,y,z]=sphere(50);
                    X=r*x-x0;
                    Y=r*y-y0;
                    Z=r*z-z0;
                    hl = painting(X,Y,Z,srf,clr,fine_flag);

                    
                case 198
                    % 圆环面实体
                    % 环心
                    p=thisEntiall.p;
                    x0=p(1);y0=p(2);z0=p(3);
                    %轴经过的两点
                    p1=thisEntiall.p1;
                    p2=thisEntiall.p2;
                    %大小半径
                    majrad=thisEntiall.majrad;
                    minrad=thisEntiall.minrad;
                    
                    
                    r=(majrad-minrad)/2;	% 圆的半径
                    
                    d=majrad-r;	% 圆到环中心的距离
                    
                    phi=(0:pi/16:2*pi)';	% points of small circle
                    
                    alpha=(0:pi/32:2*pi)';	% points of big circle
                    
                    X2=[d+r*cos(phi) r*sin(phi)];	% small circle
                    
                    Z=X2(:,2)';Z=Z(ones(1,length(alpha)),:);
                    
                    X=Z;Y=Z;
                    
                    for i=1:length(alpha)
                        
                        X(i,:)=cos(alpha(i))*X2(:,1)';
                        Y(i,:)=sin(alpha(i))*X2(:,1)';
                        
                    end
                    % TODO:坐标变换
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

