classdef OffsetSurfaceUtil
    %OFFSETSURFACEUTIL 处理偏置曲面的类
    
    properties
        
    end
    
    methods
        function obj = OffsetSurfaceUtil()
            %OFFSETSURFACEUTIL 构造此类的实例
            %   此处显示详细说明
            
        end
        
        function ParameterData = handleOffsetSurface(ParameterData,i)
            %handleOffsetSurface 处理偏置曲面
            if ParameterData{i}.type==140
                entiall=ParameterData{i}.de;
                ParameterData{entiall}.superior=1;
                if ParameterData{entiall}.type==108
                    if ParameterData{entiall}.a*ParameterData{i}.nx+ParameterData{entiall}.b*ParameterData{i}.ny+ParameterData{entiall}.c*ParameterData{i}.nz>0
                        signdist=ParameterData{i}.d;
                    else
                        signdist=-ParameterData{i}.d;
                    end
                    
                    ParameterData{i}.type=108;
                    
                    ParameterData{i}.name='平面';
                    ParameterData{i}.original=0;
                    ParameterData{i}.previous_type=140;
                    ParameterData{i}.previous_name='偏置曲面';
                    
                    ParameterData{i}.a=ParameterData{entiall}.a;
                    ParameterData{i}.b=ParameterData{entiall}.b;
                    ParameterData{i}.c=ParameterData{entiall}.c;
                    ParameterData{i}.d=ParameterData{entiall}.d+signdist*norm(ParameterData{entiall}.normal);
                    
                    ParameterData{i}.ptr=ParameterData{entiall}.ptr;
                    
                    ParameterData{i}.x=ParameterData{entiall}.x+signdist*ParameterData{entiall}.a/norm(ParameterData{entiall}.normal);
                    ParameterData{i}.y=ParameterData{entiall}.y+signdist*ParameterData{entiall}.b/norm(ParameterData{entiall}.normal);
                    ParameterData{i}.z=ParameterData{entiall}.z+signdist*ParameterData{entiall}.c/norm(ParameterData{entiall}.normal);
                    ParameterData{i}.size=ParameterData{entiall}.size;
                    
                    ParameterData{i}.normal=ParameterData{entiall}.normal;
                    
                    ParameterData{i}.isplane=true;
                    ParameterData{i}.ulinear=1;
                    ParameterData{i}.vlinear=1;
                    
                elseif ParameterData{entiall}.type==128
                    
                    ParameterData{i}.type=128;
                    
                    ParameterData{i}.name='B-NURBS曲面';
                    ParameterData{i}.original=0;
                    ParameterData{i}.previous_type=140;
                    ParameterData{i}.previous_name='偏置曲面';
                    
                    ParameterData{i}.k1=ParameterData{entiall}.k1;
                    ParameterData{i}.k2=ParameterData{entiall}.k2;
                    ParameterData{i}.m1=ParameterData{entiall}.m1;
                    ParameterData{i}.m2=ParameterData{entiall}.m2;
                    
                    ParameterData{i}.prop1=ParameterData{entiall}.prop1;
                    ParameterData{i}.prop2=ParameterData{entiall}.prop2;
                    ParameterData{i}.prop3=ParameterData{entiall}.prop3;
                    ParameterData{i}.prop4=ParameterData{entiall}.prop4;
                    ParameterData{i}.prop5=ParameterData{entiall}.prop5;
                    
                    ParameterData{i}.s=ParameterData{entiall}.s;
                    ParameterData{i}.v=ParameterData{entiall}.t;
                    
                    ParameterData{i}.w=ParameterData{entiall}.w;
                    ParameterData{i}.p=ParameterData{entiall}.p;
                    
                    ParameterData{i}.u=ParameterData{entiall}.u;
                    ParameterData{i}.v=ParameterData{entiall}.v;
                    
                    ParameterData{i}.isplane=ParameterData{entiall}.isplane;
                    ParameterData{i}.ulinear=ParameterData{entiall}.ulinear;
                    ParameterData{i}.vlinear=ParameterData{entiall}.vlinear;
                    
                    % NURBS曲面
                    
                    NURBSorg=ParameterData{entiall}.nurbs;
                    dNURBSorg=ParameterData{entiall}.dnurbs;
                    d2NURBSorg=ParameterData{entiall}.d2nurbs;
                    
                    UVm=[mean(ParameterData{entiall}.u);mean(ParameterData{entiall}.v)];
                    [~,Pmu,Pmv]=nrbevalIGES(ParameterData{entiall}.nurbs,UVm,ParameterData{entiall}.dnurbs,ParameterData{entiall}.d2nurbs);
                    
                    Nm=cross(Pmu,Pmv);
                    if Nm(1)*ParameterData{i}.nx+Nm(2)*ParameterData{i}.ny+Nm(3)*ParameterData{i}.nz>0
                        signdist=ParameterData{i}.d;
                    else
                        signdist=-ParameterData{i}.d;
                    end
                    
                    [NURBSoffset,coefsOffset,wghsOffset]=offsetNURBSsurface(signdist,NURBSorg,dNURBSorg,d2NURBSorg);
                    [dNURBSoffset,d2NURBSoffset]=nrbDerivativesIGES(NURBSoffset);
                    
                    ParameterData{i}.w=wghsOffset;
                    ParameterData{i}.p=coefsOffset;
                    
                    ParameterData{i}.nurbs=NURBSoffset;
                    ParameterData{i}.dnurbs=dNURBSoffset;
                    ParameterData{i}.d2nurbs=d2NURBSoffset;
                    
                else
                    
                    disp('警告: 无法正确处理该文件中的140实体（偏置曲面）');
                    
                end
            end
        end
    end
end

