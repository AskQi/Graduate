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
                    %
                case 192
                    %
                case 194
                    %
                case 196
                    % 球面实体，在国标P169
                    deloc=thisEntiall.deloc;
                    x0=deloc(1);y0=deloc(2);z0=deloc(3);
                    r=thisEntiall.radius;
                    [x,y,z]=sphere(50);
                    
                    
                    
                    if srf==1
                        % patch
                        if fine_flag
                            hl=patch(r*x-x0,r*y-y0,r*z-z0,'FaceColor',clr,'EdgeColor','none','FaceAlpha',1,'EdgeColor','none','EdgeLighting','none','FaceLighting','phong');
                        else
                            hl=patch(r*x-x0,r*y-y0,r*z-z0,'FaceColor',clr,'EdgeColor','none','FaceAlpha',1,'EdgeColor','none','EdgeLighting','none','FaceLighting','gouraud');
                        end
                        
                    elseif srf==2
                        % mesh
                        hl=patch(r*x-x0,r*y-y0,r*z-z0,'FaceColor','none','EdgeColor','b');
                    end
                    
                case 198
                    %
                    
            end
        end
    end
end

