function [ParameterData,enttyCut,noentI]=ConvertEntiall_196(ParameterData,i,noentI)
% 球面实体，在国标P169
enttyCut=0;

% 这里获得了球面实体的圆心
deloc=ParameterData{i}.deloc;
index=(deloc+1)/2;
pointEntaill=ParameterData{index};
ParameterData{i}.p=pointEntaill.p;

end