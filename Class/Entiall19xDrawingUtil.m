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
                    deloc=thisEntiall.deloc;
                    x0=deloc(1);y0=deloc(2);z0=deloc(3);
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
                    % Բ����ʵ��
                    
            end
        end
    end
end

