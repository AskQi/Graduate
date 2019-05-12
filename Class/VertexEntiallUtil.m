classdef VertexEntiallUtil
    % 用于处理顶点实体转换为点实体
    methods(Static)
        function [ParameterData,new_noent] = handleVertexEntiallUtil(ParameterData,noent)
            new_noent=noent;
            for i=1:noent
                if ParameterData{i}.well==0
                    continue;
                end
                if ParameterData{i}.type==502
                    thisEntiall=ParameterData{i};
                    thisVertexEntiallStruct=thisEntiall.VertexEntiall;
                    for j=1:thisEntiall.n
                        thisVertexEntiall=thisVertexEntiallStruct(j);
                        x=thisVertexEntiall.x;
                        y=thisVertexEntiall.y;
                        z=thisVertexEntiall.z;
                        trnsfrmtnmtrx=thisEntiall.trnsfrmtnmtrx;
                        clrnmbr=thisVertexEntiall.clrnmbr;
                        pointEntiall=VertexEntiallUtil.newPointEntiall...
                            (x,y,z,trnsfrmtnmtrx,clrnmbr);
                        new_noent=new_noent+1;
                        ParameterData{new_noent}=pointEntiall;
                    end
                end
            end
        end
        function pointEntiall=newPointEntiall(x,y,z,trnsfrmtnmtrx,clrnmbr)
            pointEntiall.type=116;
            pointEntiall.name='点';
            pointEntiall.previous_type=502;
            pointEntiall.previous_name='顶点实体';
            pointEntiall.p=[x;y;z];
            pointEntiall.x=x;
            pointEntiall.y=y;
            pointEntiall.z=z;
            pointEntiall.ptr=0;
            pointEntiall.original=1;
            pointEntiall.trnsfrmtnmtrx=trnsfrmtnmtrx;
            pointEntiall.clrnmbr=clrnmbr; 
            pointEntiall.color=[0,0,0];
            pointEntiall.well=true;
        end
        
    end
end

