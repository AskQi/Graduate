function [ParameterData,enttyCut,noentI]=ConvertEntiall_198(ParameterData,i,noentI)
% Բ����ʵ�壬�ڹ���P170
enttyCut=0;

% ���ĵ�
deloc=ParameterData{i}.deloc;
deloc_index=(deloc+1)/2;
pointEntaill=ParameterData{deloc_index};
ParameterData{i}.p=pointEntaill.p;

% ��
deaxis=ParameterData{i}.deloc;
deaxis_index=(deaxis+1)/2;
lineEntaill=ParameterData{deaxis_index};
ParameterData{i}.p1=lineEntaill.p1;
ParameterData{i}.p2=lineEntaill.p2;

end