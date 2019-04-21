function [stP,endP,isLine,isKnown]=endPoints(ParameterData,ii)

if ParameterData{ii}.type==126
    stP=nrbevalIGES(ParameterData{ii}.nurbs,ParameterData{ii}.v(1));
    endP=nrbevalIGES(ParameterData{ii}.nurbs,ParameterData{ii}.v(2));
    isLine=false;
    isKnown=true;
elseif ParameterData{ii}.type==110
    stP=ParameterData{ii}.p1;
    endP=ParameterData{ii}.p2;
    isLine=true;
    isKnown=true;
else
    stP=[0;0;0];
    endP=[0;0;0];
    isLine=false;
    isKnown=false;
end