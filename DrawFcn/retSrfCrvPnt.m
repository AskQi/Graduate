
function [P,isSCP,isSup,TRI,UV,srfind]=retSrfCrvPnt(SCP,ParameterData,isSup,ind,n,dim)
% 输入：
% SCP - 1, 表面
%     - 2, 曲线
%     - 3, 点
%
% ParameterData - 来自IGES文件的参数数据
%
% isSup - 1, 如果superior为真，则返回isSup=1
%       - 0, isSup=0 (总为0)%%%%superior???
%
% ind - index
%
% n - 曲线的点数，n ^ 2非修剪曲面的poinst数
%
% dim - [2,3] 2, 域中的曲线, 3, 空间中的曲线

warn=warning;
warning('off','all');

isSCP=0;

if SCP==1           % 表面
    if ParameterData{ind}.type==128
        
        isSCP=1;
        srfind=ind;
        
        if and(isSup,ParameterData{ind}.superior)
            P=zeros(3,0);
            TRI=zeros(0,3);
            UV=zeros(2,0);
        else
            
            isSup=0;
            
            if nargin==6
                if dim==3
                    nu=min(max(ceil(300*ParameterData{ind}.ratio(1)),160),1600);
                    nv=min(max(ceil(300*ParameterData{ind}.ratio(2)),160),1600);
                elseif dim==2
                    nu=min(max(ceil(200*ParameterData{ind}.ratio(1)),80),800);
                    nv=min(max(ceil(200*ParameterData{ind}.ratio(2)),80),800);
                elseif dim==1
                    nu=min(max(ceil(150*ParameterData{ind}.ratio(1)),40),400);
                    nv=min(max(ceil(150*ParameterData{ind}.ratio(2)),40),400);
                else
                    nu=min(max(ceil(80*ParameterData{ind}.ratio(1)),20),200);
                    nv=min(max(ceil(80*ParameterData{ind}.ratio(2)),20),200);
                end
            else
                nu=min(max(ceil(80*ParameterData{ind}.ratio(1)),20),200);
                nv=min(max(ceil(80*ParameterData{ind}.ratio(2)),20),200);
            end
            
            [P,UV,TRI]=nrbSrfRegularEvalIGES(ParameterData{ind}.nurbs,ParameterData{ind}.u(1),ParameterData{ind}.u(2),nu,ParameterData{ind}.v(1),ParameterData{ind}.v(2),nv);
            
        end
        
        
    else%不是各类曲面实体
        
        P=zeros(3,0);
        isSCP=0;
        isSup=1;
        TRI=zeros(0,3);
        UV=zeros(2,0);
        srfind=0;
        
    end
elseif SCP==2       % 曲线
    if isSup
        
        if ParameterData{ind}.type==110
            
            isSCP=1;
            
            if ParameterData{ind}.superior
                P=zeros(dim,0);
                TRI=0;
            else
                P=zeros(dim,n);
                
                tvec=linspace(0,1,n);
                
                P(1,:)=ParameterData{ind}.x1+tvec*(ParameterData{ind}.x2-ParameterData{ind}.x1);
                P(2,:)=ParameterData{ind}.y1+tvec*(ParameterData{ind}.y2-ParameterData{ind}.y1);
                
                if dim>2
                    P(3,:)=ParameterData{ind}.z1+tvec*(ParameterData{ind}.z2-ParameterData{ind}.z1);
                end
                
                isSup=0;
                TRI=0;
            end
            
        elseif ParameterData{ind}.type==126
            
            isSCP=1;
            
            if ParameterData{ind}.superior
                P=zeros(dim,0);
                TRI=0;
            else
                tst=ParameterData{ind}.v(1);
                ten=ParameterData{ind}.v(2);
                
                tvec=linspace(tst,ten,n);
                
                if dim==3
                    P=nrbevalIGES(ParameterData{ind}.nurbs,tvec);
                else
                    P3=nrbevalIGES(ParameterData{ind}.nurbs,tvec);
                    P=P3(1:dim,:);
                end
                isSup=0;
                TRI=0;
            end
        else
            P=zeros(dim,0);
            isSup=1;
            TRI=0;
        end
        
        UV=0;
        
    else%isSup==0
        
        if any(ParameterData{ind}.type==[102 110 126 141 142])
            
            if nargout>3
                [P,TRI,UV]=retCrv(ParameterData,ind,n,dim);
            elseif nargin==6
                if dim<1
                    P=retSpaceCrv(ParameterData,ind,n);
                elseif dim==2
                    P=ret2Crv(ParameterData,ind,n);
                elseif dim==22
                    P=ret2CrvII(ParameterData,ind,n);
                else
                    P=ret3Crv(ParameterData,ind,n);
                end
                TRI=0;
                UV=0;
            else
                P=ret3Crv(ParameterData,ind,n);
                TRI=0;
                UV=0;
            end
            
            if not(isempty(P))
                isSCP=1;
            end
            
        else%不是各种曲线实体
            P=zeros(3,0);
            isSup=1;
            TRI=0;
        end
        
    end
    
    srfind=0;
    
elseif SCP==3       % 点
    
    if ParameterData{ind}.type==116
        P=ParameterData{ind}.p;
        isSCP=1;
        isSup=0;
        TRI=0;
    else
        P=zeros(3,1);
        isSCP=0;
        isSup=1;
        TRI=0;
    end
    
    UV=0;
    srfind=0;
    
end

warning(warn(1).state);
