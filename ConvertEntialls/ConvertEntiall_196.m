function [ParameterData,enttyCut,noentI]=ConvertEntiall_196(ParameterData,i,noentI)
% ����ʵ�壬�ڹ���P169
enttyCut=0;

% ������������ʵ���Բ��
deloc=ParameterData{i}.deloc;
index=(deloc+1)/2;
pointEntaill=ParameterData{index};
ParameterData{i}.p=pointEntaill.p;

end