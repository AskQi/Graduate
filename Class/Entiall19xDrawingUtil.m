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
                    xs=r*x-x0;
                    ys=r*y-y0;
                    zs=r*z-z0;
                    if srf==1
                        % patch
                        CO(:,:,1) = ones(size(zs))*clr(1); % red
                        CO(:,:,2) = ones(size(zs))*clr(2); % green
                        CO(:,:,3) = ones(size(zs))*clr(3); % blue
                        if fine_flag
                            hl=surf(xs,ys,zs,CO);
                        else
                            hl=surf(r*x-x0,r*y-y0,r*z-z0,CO);
                        end
                        
                    elseif srf==2
                        % mesh
                        CO(:,:,1) = zeros(size(zs)); % red
                        CO(:,:,2) = zeros(size(zs)); % green
                        CO(:,:,3) = ones(size(zs)); % blue
                        hl=mesh(r*x-x0,r*y-y0,r*z-z0,CO);
                    end
                    
                case 198
                    % 圆环面实体
                    
            end
        end
    end
end

