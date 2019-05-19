function [ParameterData,enttyCut,noentI]=ConvertEntiall_198(ParameterData,i,noentI)
% 圆环面实体，在国标P170
enttyCut=0;

% 中心点
deloc=ParameterData{i}.deloc;
deloc_index=(deloc+1)/2;
pointEntaill=ParameterData{deloc_index};
ParameterData{i}.p=pointEntaill.p;

% 轴
deaxis=ParameterData{i}.deloc;
deaxis_index=(deaxis+1)/2;
lineEntaill=ParameterData{deaxis_index};
ParameterData{i}.p1=lineEntaill.p1;
ParameterData{i}.p2=lineEntaill.p2;

end