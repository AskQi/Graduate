function handlePlot=plotIGES(ParameterData,srf,fignr,subd,holdoff_flag,fine_flag,plotCrvPnts,srfClr)
% PLOTIGES 绘制IGES文件中的曲面，曲线和点
%
% 简单用法:
%
% handlePlot=plotIGES(ParameterData)
%
% 或者
%
% handlePlot=plotIGES(ParameterData,1)
%
% 普通用法:
%
% plotIGES(ParameterData,srf,fignr,subd,holdoff_flag)
% plotIGES(ParameterData, 2, 1, 100, 1, 0, 1, 0)
% 输入:
%
% ParameterData - 来自IGES文件的参数数据. ParameterData
%                 是IGES2MATLAB的输出
% srf - 表面绘图的标志 (0,1,2)
%        0 (default), 不绘制曲面,
%        1 表面绘制为三角形贴片(patch)
%        2 表面绘制为三角形网格(mesh)
% fignr -  图的编号. 默认为1
% subd - 绘制曲线时细分的Nuber
%        SubD是绘制曲面时每个参数的细分的nubmer 默认100
% holdoff_flag - 布尔值(1/0). 如果是1，则在绘图完成后暂停绘图。默认1
% fine_flag - 0 表面粗糙 (default)
%             1 表面会精细
%             2 表面会更精细
%             3 表面会最精细
% plotCrvPnts - 曲线和点绘图的标志 (1/0)
%        0, 不绘制曲线和点,
%        1  绘制曲线和点(default)
% srfClr - 表面颜色
%
% 输出:
%
% handlePlot - plothandle


if nargin<8
    usrDefClr=false;
    if nargin<7
        plotCrvPnts=1;
        if nargin<6
            fine_flag=0;
            if nargin<5
                holdoff_flag=1;
                if nargin<4
                    subd=100;
                    if nargin<3
                        fignr=1;
                        if nargin<2
                            srf=0;
                            if nargin<1
                                error('绘图函数没输入参数！');
                            end
                        end
                    end
                end
            end
        end
    end
else
    if isempty(srfClr)
        usrDefClr=false;
    elseif isscalar(srfClr)
        usrDefClr=false;
    else
        usrDefClr=true;
    end
end

if isempty(ParameterData)
    error('ParameterData为空');
elseif not(iscell(ParameterData))
    error('ParameterData内容必须是cell数组!');
end

if isempty(srf)
    srf=0;
elseif not(srf==0 | srf==1 | srf==2)
    srf=0;
end

srf0not=not(srf==0);
srf1=srf==1;

if isempty(fignr)
    fignr=1;
else
    fignr=round(fignr);
end

if isempty(subd)
    subd=100;
else
    subd=round(subd);
end

if subd<10
    subd=10;
end

if isempty(holdoff_flag)
    holdoff_flag=1;
elseif not(holdoff_flag==0 | holdoff_flag==1)
    holdoff_flag=1;
end

if isempty(fine_flag)
    fine_flag=0;
end

if isempty(plotCrvPnts)
    plotCrvPnts=1;
elseif not(plotCrvPnts==0 | plotCrvPnts==1)
    plotCrvPnts=1;
end

subd=subd+1;  % subd当前的点数,不是间隔数

siz=length(ParameterData);

if usrDefClr
    clr=srfClr;
else
    clr=[0.8,0.8,0.9];
end
lsclclr=0.5;
pntsclclr=0.25;

if fignr>0
    figure(fignr),hold on
end


if nargout>0
    
    handlePlot=cell(1,3);
    
    for i=1:siz
        if ParameterData{i}.well==0
            fprintf("不支持绘制：%s(%d)\n",ParameterData{i}.name,ParameterData{i}.type);
            continue;
        else
            fprintf("正在绘制：%s(%d)\n",ParameterData{i}.name,ParameterData{i}.type);
        end
        [P,isSCP,isSup]=retSrfCrvPnt(2,ParameterData,1,i,subd,3);
        
        if and(isSCP,not(isSup))
            
            if plotCrvPnts
                
                if not(usrDefClr)
                    clr(:)=ParameterData{i}.color;
                end
                
                hl=plot3(P(1,:),P(2,:),P(3,:),'Color',lsclclr*clr,'LineWidth',1);
                handlePlot{1}=[handlePlot{1},hl];
                
            end
            
        elseif not(isSCP)
            
            [P,isSCP]=retSrfCrvPnt(3,ParameterData,1,i);
            
            if isSCP
                
                if plotCrvPnts
                    
                    if not(usrDefClr)
                        clr(:)=ParameterData{i}.color;
                    end
                    
                    hp=plot3(ParameterData{i}.x,ParameterData{i}.y,ParameterData{i}.z,'.','color',pntsclclr*clr);
                    handlePlot{2}=[handlePlot{2},hp];
                    
                end
                
            elseif srf0not
                
                if fine_flag
                    [P,isSCP,isSup,TRI]=retSrfCrvPnt(1,ParameterData,1,i,subd,fine_flag);
                else
                    [P,isSCP,isSup,TRI]=retSrfCrvPnt(1,ParameterData,1,i,subd);
                end
                
                if and(isSCP,not(isSup))
                    if srf1%patch
                        if not(usrDefClr)
                            clr(:)=ParameterData{i}.color;
                        end
                        if fine_flag
                            hs=patch('faces',TRI,'vertices',P','FaceColor',clr,'EdgeColor','none','FaceAlpha',1,'EdgeColor','none','EdgeLighting','none','FaceLighting','phong');
                        else
                            hs=patch('faces',TRI,'vertices',P','FaceColor',clr,'EdgeColor','none','FaceAlpha',1,'EdgeColor','none','EdgeLighting','none','FaceLighting','gouraud');
                        end
                    else
                        hs=patch('faces',TRI,'vertices',P','FaceColor','none','EdgeColor','b');
                    end
                    
                    handlePlot{3}=[handlePlot{3},hs];
                end
                
            end
        end
        
    end
    
else
    
    for i=1:siz
        if ParameterData{i}.well==0
            continue;
        end
        [P,isSCP,isSup]=retSrfCrvPnt(2,ParameterData,1,i,subd,3);
        
        if and(isSCP,not(isSup))
            
            if plotCrvPnts
                
                if not(usrDefClr)
                    clr(:)=ParameterData{i}.color;
                end
                
                plot3(P(1,:),P(2,:),P(3,:),'Color',lsclclr*clr,'LineWidth',1);
                
            end
            
        elseif not(isSCP)
            
            [P,isSCP]=retSrfCrvPnt(3,ParameterData,1,i);
            
            if isSCP
                
                if plotCrvPnts
                    
                    if not(usrDefClr)
                        clr(:)=ParameterData{i}.color;
                    end
                    
                    plot3(ParameterData{i}.x,ParameterData{i}.y,ParameterData{i}.z,'.','color',pntsclclr*clr);
                    
                end
                
            elseif srf0not
                
                if fine_flag
                    [P,isSCP,isSup,TRI]=retSrfCrvPnt(1,ParameterData,1,i,subd,fine_flag);
                else
                    [P,isSCP,isSup,TRI]=retSrfCrvPnt(1,ParameterData,1,i,subd);
                end
                
                if and(isSCP,not(isSup))
                    if srf1
                        if not(usrDefClr)
                            clr(:)=ParameterData{i}.color;
                        end
                        if fine_flag
                            patch('faces',TRI,'vertices',P','FaceColor',clr,'EdgeColor','none','FaceAlpha',1,'EdgeColor','none','EdgeLighting','none','FaceLighting','phong');
                        else
                            patch('faces',TRI,'vertices',P','FaceColor',clr,'EdgeColor','none','FaceAlpha',1,'EdgeColor','none','EdgeLighting','none','FaceLighting','gouraud');
                        end
                    else
                        patch('faces',TRI,'vertices',P','FaceColor','none','EdgeColor','b');
                    end
                end
                
            end
        end
        
    end
    
end

axis image

sc=0.2;

xl=xlim;
dx=xl(2)-xl(1);
xl(1)=xl(1)-sc*dx;
xl(2)=xl(2)+sc*dx;
xlim(xl);

yl=ylim;
dy=yl(2)-yl(1);
yl(1)=yl(1)-sc*dy;
yl(2)=yl(2)+sc*dy;
ylim(yl);

zl=zlim;
dz=zl(2)-zl(1);
zl(1)=zl(1)-sc*dz;
zl(2)=zl(2)+sc*dz;
zlim(zl);

if holdoff_flag
    hold off;
end
