function [ParameterData,enttyCut,noentI]=ConvertEntiall_190(ParameterData,i,noentI)
% 平面内曲面实体，在国标P163
enttyCut=0;

% 平面上一点的圆心
deloc=ParameterData{i}.deloc;
deloc_index=(deloc+1)/2;
pointEntaill=ParameterData{deloc_index};
ParameterData{i}.p=pointEntaill.p;

% 平面的法线
denrml=ParameterData{i}.deloc;
denrml_index=(denrml+1)/2;
lineEntaill=ParameterData{denrml_index};
ParameterData{i}.p1=lineEntaill.p1;
ParameterData{i}.p2=lineEntaill.p2;

end