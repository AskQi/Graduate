function [ParameterData,enttyCut,noentI]=ConvertEntiall_190(ParameterData,i,noentI)
% ƽ��������ʵ�壬�ڹ���P163
enttyCut=0;

% ƽ����һ���Բ��
deloc=ParameterData{i}.deloc;
deloc_index=(deloc+1)/2;
pointEntaill=ParameterData{deloc_index};
ParameterData{i}.p=pointEntaill.p;

% ƽ��ķ���
denrml=ParameterData{i}.deloc;
denrml_index=(denrml+1)/2;
lineEntaill=ParameterData{denrml_index};
ParameterData{i}.p1=lineEntaill.p1;
ParameterData{i}.p2=lineEntaill.p2;

end