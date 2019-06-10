function [handlePlot]=playIGES(igsfile,isDebugMode,srf,subd,fine_flag)
global support_read_fcn_types support_read_fcns...
    support_convert_fcn_types support_convert_fcns...
    support_final_calculation_fcn_types support_final_calculation_fcns...
    mat3x3

%���ʹ�õ���ģʽ����ʵ���������Ϣ
printInfo=isDebugMode;
% ����ǰ�ļ����µ������ļ��ж����������ú�����Ŀ¼
addpath(genpath(pwd));
fprintf('�ļ�����%s\n',igsfile);
[fid,msg]=fopen(igsfile);
if fid==-1
    error(msg);
end
c = fread(fid,'uint8=>uint8')';
fclose(fid);
% ����IGESʵ����Ϣ��
% iges_entiall_file='iges_entiall_info.xlsx';
% igesEntiallInfo=IgesEntiallInfo(iges_entiall_file);
% �ӿ��ٶ�
load 'igesEntiallInfo.mat';

nwro=sum((c((81:82))==10))+sum((c((81:82))==13));%��81��82������Ϊ10�ĸ�����Ϊ13�ĸ���
%��81��82����Ϊiges�ļ��е�һ��ĩβ�Ļ��з��͵ڶ��е�һ���ַ���ascii�루���з���10�����س�����13����
edfi=nwro-sum(c(((end-1):end))==10)-sum(c(((end-1):end))==13);%nwro-�����������Ϊ10��13�ĸ���
siz=length(c);
ro=round((siz+edfi)/(80+nwro));
if rem((siz+edfi),(80+nwro))~=0 %������һ��û�л��з��Ļ���������һ����ͬ�Ļ��з���س�����Ϊ���ַ���
    error('���ļ����ܲ���IGES�ļ�!');
end
%����Ϊ�ַ��ܸ�������ĸΪÿ�е��ַ�������IGES�ļ�ÿ���ַ���Ŀ��ͬ

roind=1:ro;%roΪ�ļ�����
SGDPT=c(roind*(80+nwro)-7-nwro);%ÿ�еĵ�73���ַ�������������

%S����ֱ����ʾ����
Sfind=SGDPT==double('S');%�õ���Ϊ����ֵ���жϵڼ�����ĩ�ַ�ΪS
Gfind=SGDPT==double('G');
Dfind=SGDPT==double('D');
Pfind=SGDPT==double('P');
% T����û�б�ҪŪ
Tfind=SGDPT==double('T');

sumSfind=sum(Sfind);%S��һ���м���
sumGfind=sum(Gfind);
sumDfind=sum(Dfind);
sumPfind=sum(Pfind);
sumTfind=sum(Tfind);

%���ڴ���ƫ������
offsetExists=false;
%���ڴ���任����
transformationExists=false;
mat3x3=zeros(3);

% ������ض�ȡ����ʵ���ģ��
read_entialls_dir = dir('ReadEntialls*');
if ~isempty(read_entialls_dir.name), cd(read_entialls_dir.name), end
read_entialls_fcn_file=dir('ReadEntiall_*.m');
expression='\d{3,4}';
[read_fcn_names_number,~]=size(read_entialls_fcn_file);

for j=1:read_fcn_names_number
    read_fcn_name=read_entialls_fcn_file(j).name;
    this_num=cellstr(regexp(read_fcn_name,expression,'match'));
    support_read_fcn_types(j)=transpose(str2num(cell2mat(this_num)));
    support_read_fcn_name=strcat('ReadEntiall_',char(this_num));
    support_read_fcns{j} = str2func(support_read_fcn_name);
end
cd ..

% �������ת������ʵ���ģ��
convert_entialls_dir = dir('ConvertEntialls*');
if ~isempty(convert_entialls_dir.name), cd(convert_entialls_dir.name), end
convert_entialls_fcn_file=dir('ConvertEntiall_*.m');
expression='\d{3,4}';
[convert_fcn_names_number,~]=size(convert_entialls_fcn_file);

for j=1:convert_fcn_names_number
    convert_fcn_name=convert_entialls_fcn_file(j).name;
    this_num= cellstr(regexp(convert_fcn_name,expression,'match'));
    support_convert_fcn_types(j)=transpose(str2num(cell2mat(this_num)));
    support_convert_fcn_name=strcat('ConvertEntiall_',char(this_num));
    support_convert_fcns{j} = str2func(support_convert_fcn_name);
end
cd ..

% ���������Ҫ���ռ���ĸ���ʵ���ģ��
final_calculation_entialls_dir = dir('FinalCalculations*');
if ~isempty(final_calculation_entialls_dir.name), cd(final_calculation_entialls_dir.name), end
final_calculation_entialls_fcn_file=dir('FinalCalculation_*.m');
expression='\d{3,4}';
[final_calculation_fcn_names_number,~]=size(final_calculation_entialls_fcn_file);

for j=1:final_calculation_fcn_names_number
    final_calculation_fcn_name=final_calculation_entialls_fcn_file(j).name;
    this_num= cellstr(regexp(final_calculation_fcn_name,expression,'match'));
    support_final_calculation_fcn_types(j)=transpose(str2num(cell2mat(this_num)));
    support_final_calculation_fcn_name=strcat('FinalCalculation_',char(this_num));
    support_final_calculation_fcns{j} = str2func(support_final_calculation_fcn_name);
end
cd ..
%------S ���ֵ���Ϣ---------
%S���ֶ���ע�ͣ�����ֱ�����
fprintf('\n���ڼ���S����\n');
if printInfo
    for i=roind(Sfind)%ֱ�����S����Ϣ
        fprintf(char(c(((i-1)*(80+nwro)+1):(i*(80+nwro)-8-nwro))));
        fprintf('\n');
    end
end
%------G ���ֵ���Ϣ---------
%G���ּ�¼��25����Ϣ��Ĭ��ʹ�á�,�����зָ
%�����ｫ��ȫ����Ϣ�ϲ�
fprintf('\n���ڼ���G����\n');
G=cell(1,25);%ȫ�ֶζ���25������
%��¼G������Ч���ֺϲ�Ϊһ�к�Ľ��
Gstr=zeros(1,72*sumGfind);%ÿ��72����Ч�ַ�
j=1;
for i=roind(Gfind)
    Gstr(((j-1)*72+1):(j*72))=c(((i-1)*(80+nwro)+1):(i*(80+nwro)-8-nwro));
    j=j+1;
end%j����ΪG�ε�����+1
%ʶ��Ԥ��ָ���,stΪ��ǰָ��
if and(Gstr(1)==double('1'),Gstr(2)==double('H'))%ǰ�����ַ�Ϊ1��H
    G{1}=Gstr(3);%�������ַ�Ϊ�����ָ���
    st=4;
else
    G{1}=double(',');%�����ָ���Ϊȱʡֵ������
    st=1;
end

if and(Gstr(st+1)==double('1'),Gstr(st+2)==double('H'))
    G{2}=Gstr(st+3);
    st=st+4;
else
    G{2}=double(';');%��¼�ֽ��Ϊȱʡֵ������
    st=st+1;
end

le=length(Gstr);
for i=3:25
    for j=(st+1):le
        if or(Gstr(j)==G{1},Gstr(j)==G{2})%ȡ��ĳһ��jʱ�����������򡰣���������forѭ��������ǰG{i}��ֵ
            break
        end
    end
    G{i}=Gstr((st+1):(j-1));%�˴�j��ǰ������ķָ���
    st=j;
end

for i=[3 4 5 6 12 15 18 21 22 25]%string,��Щ����Ϊ�ַ�����ʽ���ų�ÿ�������еĿո��H
    %ȷ����ʼλ��
    stind=1;
    for j=1:length(G{i})
        if G{i}(j)~=double(' ')%��i��������j���ַ����ǿո�
            stind=j;%�ӵ�һ��
            break
        end
    end
    for j=stind:length(G{i})
        if G{i}(j)==double('H')%��j���ַ���H
            stind=j+1;%H֮����ַ�Ϊʵ�ʲ���
            break
        end
    end
    %ȷ������λ��
    endind=length(G{i});
    for j=length(G{i}):-1:1
        if G{i}(j)~=double(' ')
            endind=j;%G{i}�����һ���ַ������ǿո�
            break
        end
    end
    G{i}=G{i}(stind:endind);%��i���ַ���������ʵ���ַ���
end
if printInfo
    G_Description={'�����ָ���','��¼�ָ���','����ϵͳ��ƷID','�ļ���',...
        'ϵͳID','ǰ�ô������汾','�����Ķ����Ʊ�ʾλ��',...
        '����ϵͳ�����ȸ�����ʮ��������ݴ�','����ϵͳ�����ȸ�������Чλ��',...
        '����ϵͳ˫���ȸ�����ʮ��������ݴ�','����ϵͳ˫���ȸ�������Чλ��',...
        '����ϵͳ��ƷID','ģ�Ϳռ����','��λ��־','��λ','ֱ���߿�����ȼ�',...
        '���ֱ���߿�','�����ļ����ɵ����ں�ʱ��','�û��趨��ģ�͵ȼ�����Сֵ',...
        'ģ�͵Ľ����������ֵ','������','���ߵ�λ',...
        '��Ӧ�ڴ������ļ���IGES��׼�汾�ŵ�����','��ͼ��׼',...
        '����������޸�ģ�͵����ں�ʱ��'};
    for j=1:length(G_Description)
        fprintf('(%d)%s��%s\n',j,G_Description{j},G{j});
    end
end
%�����G�Ѿ���ȡ�����й���G������
for i=[7 8 9 10 11 13 14 16 17 19 20 23 24]   %num
    G{i}=str2num(char(G{i}));
end
fprintf('\nG���ּ������\n');

%------D ���ֵ���Ϣ---------
%Ԫ�ظ���
fprintf('\n���ڼ���D���ֺ�P����\n');
noent=round(sumDfind/2);%Ŀ¼��Ŀ��ÿ��ʵ��ռ����

% Ԥ����ParameterData�Ŀռ��Լӿ��ٶ�
ParameterData=cell(1,noent);

% ���ڴ洢D��186ʵ�����ڵ�i
indexOfMSBOEntty=[];

roP=sumSfind+sumGfind+sumDfind;%�����ε���ʼλ��-1

entty=zeros(1,520);

% Default color
defaultColor=[0.8,0.8,0.9];
% �洢��ɫ
colorMap=containers.Map('KeyType','int32','ValueType','any');

% ��ʼ��ȡ����
entiall=0;
startD=sumSfind+sumGfind+1;
endD=sumSfind+sumGfind+sumDfind-1;
for i=startD:2:endD
    %i��D�ο�ʼ�����ƣ���D�ν�����
    entiall=entiall+1;
    Dstr1=c(((i-1)*(80+nwro)+1):(i*(80+nwro)-8-nwro));%��ʵ���һ�г�ȥ���˸��ַ�֮��������ַ�
    Dstr2=c((i*(80+nwro)+1):((i+1)*(80+nwro)-8-nwro));%�ڶ���
    
    % ��ǰ����D�е�λ�ã������еĵ�һ�У�
    thisLineNumberOfD=i-startD+1;
    
    type=str2num(char(Dstr1(1:8)));%��ascii��ת��Ϊ��Ӧ���ַ�
    transformationMatrixPtr=str2num(char(Dstr1(49:56)));%ת������ָ����(ת��������������任)
    if isempty(transformationMatrixPtr)
        transformationMatrixPtr=0;
    end
    colorNo=str2num(char(Dstr2(17:24)));%ʵ�����ɫ��
    if isempty(colorNo)
        colorNo=0;
    end
    formNo=str2num(char(Dstr2(33:40)));%ʵ��ĸ�ʽ��
    if isempty(formNo)
        formNo=0;
    end
    
    if transformationMatrixPtr>0
        transformationMatrixPtr=round((transformationMatrixPtr+1)/2);
    end
    
    if printInfo
        D1_Description={'Ԫ�����ͺ�','����ָ��','�汾',...
            '����','ͼ��','��ͼ','�任����',...
            '�����ʾ','״̬��'};
        D2_Description={'Ԫ�����ͺ�','ֱ�ߵ�Ȩ��','��ɫ��',...
            '������¼��','��ʽ��','��������ʹ��','��������ʹ��',...
            'Ԫ�ر��','Ԫ���±��'};
        fprintf('=> D������Ϣ���£�\n');
        for j=1:length(D1_Description)
            fprintf('(%d)%s��%d\n',j,D1_Description{j},str2num(char(Dstr1(j*8-7:j*8))));
        end
        for j=1:length(D2_Description)
            fprintf('(%d)%s��%d\n',j+10,D2_Description{j},str2num(char(Dstr2(j*8-7:j*8))));
        end
    end
    % P���ֿ�ʼ
    Pstart=str2num(char(Dstr1(9:16)))+roP;
    %��ʵ����P�ε���ʼ����+P����ʼ����-1=��ʵ����������
    if i==roP-1%��ʵ��Ϊ���һ��ʵ��
        Pend=ro-sumTfind;%���ʵ�����һ�о���T��ǰһ��
    else
        Pend=str2num(char(c(((i+1)*(80+nwro)+9):((i+1)*(80+nwro)+16))))+roP-1;
        %��һ��ʵ����P�ε���ʼ����+SGD������֮��-1=��ʵ��P�ν�������
    end
    
    Pstr=zeros(1,64*(Pend-Pstart+1));%ÿ�е���Ч��ϢΪǰ8����64���ַ�
    j=1;
    for k=Pstart:Pend
        Pstr(((j-1)*64+1):(j*64))=c(((k-1)*(80+nwro)+1):(k*(80+nwro)-16-nwro));
        j=j+1;
    end
    
    Pstr(Pstr==G{1})=44;
    Pstr(Pstr==G{2})=59;
    %P�εķָ����ͷֽ��ͳһΪ�������͡������������Pvec��ֵʱ�Զ��ԡ������ָ�����
    Pvec=str2num(char(Pstr));%��ʵ���ȫ��������Ϣascii��תΪ����, �������������Զ��ֿ��洢
    if printInfo
        fprintf('=> P������Ϣ���£�\n');
    end
    % �洢ʵ��
    entty(type)=entty(type)+1;
    % ��ΪP���ֵĸ�ʽ�ǲ��̶��ģ�����Ҫ���ݲ�ͬ��Ԫ�ؽ��в�ͬ�����ݽ���
    % ����ʹ��ģ�黯�����������Ӧ���ļ����ɽ������ʵ��
    position=find(support_read_fcn_types==type);
    if position>0
        isread='�ɹ���ȡ';
        thisFcn=support_read_fcns{position};
        ParameterData{entiall}=thisFcn(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr);
        if ParameterData{entiall}.type==124
            transformationExists=true;
        elseif ParameterData{entiall}.type==130
            offsetExists=true;
        elseif ParameterData{entiall}.type==140
            offsetExists=true;
        elseif ParameterData{entiall}.type==186
            indexOfMSBOEntty=[indexOfMSBOEntty,entiall];
        elseif ParameterData{entiall}.type==314
            %��ɫʵ����ش���
            thisColor=ParameterData{entiall}.color;
            thisColorNumber=-thisLineNumberOfD;
            colorMap(thisColorNumber)=thisColor;
%             colorDict.(strcat('c',num2str(thisColorNumber)))=thisColor;
            fprintf('�����ɫ��%d��\n',thisColorNumber);
            if isempty(ParameterData{entiall}.cname)
                ParameterData{entiall}.cname=num2str(thisColorNumber);
            end
            
        end
    else
        isread='�޷���ȡ';
        entty(type)=entty(type)-1;
        ParameterData{entiall}.type=type;
        ParameterData{entiall}.unknown=char(Pstr);
        ParameterData{entiall}.well=false;
        ParameterData{entiall}.original=1;
        ParameterData{entiall}.length=0;
    end
    
    if ~isfield(ParameterData{entiall},'name')
        %û���������־Ͱ��ձ�׼��������
        ParameterData{entiall}.name=igesEntiallInfo.getNameByType(type);
    end
    
    if printInfo
        fprintf('���ͣ�%d�����ƣ�%s\n�Ƿ��ܹ���ȡ��%s\n\n',...
            ParameterData{entiall}.type,ParameterData{entiall}.name,isread);
    end
    
end

% ����������ʵ��ת��ΪNURBSʵ��
fprintf('\n��ʼ����ʵ������ת��\n');
noentI=noent;
for i=1:noent
    if ParameterData{i}.well==0
        continue;
    end
    type=ParameterData{i}.type;
    position=find(support_convert_fcn_types==type);
    if position>0
        % ��������Ҫת��
        thisFcn=support_convert_fcns{position};
        [ParameterData,enttyCut,noentI]=thisFcn(ParameterData,i,noentI);
        entty(ParameterData{i}.type)=entty(ParameterData{i}.type)+enttyCut;
        if printInfo
            fprintf('���ͣ�%d�����ƣ�%s\n�ɹ�ת��ΪNURBSʵ��\n\n',...
                ParameterData{entiall}.type,ParameterData{entiall}.name);
        end
    end
end
noent=noentI;
% ����ƫ�����ߺ�����
if offsetExists
    fprintf('\n��ʼ����ƫ�����ߺ�����\n');
    for i=1:noent
        if ParameterData{i}.type==130
            ParameterData=OffsetLineUtil.handleOffsetLine(ParameterData,i);
        end
        if ParameterData{i}.type==140
            ParameterData=OffsetSurfaceUtil.handleOffsetSurface(ParameterData,i);
        end
    end
end

% ���ڴ���186ʵ���ʹ����ʵ�����ɫ������ͬ
if entty(186)>0
    fprintf('\n��ʼת��186���ʵ����ɫ\n');
    % TODO:186���ʵ�崦��
    for j=1:entty(186)
        thisIndex=indexOfMSBOEntty(j);
        ParameterData=MSBOEntiallUtil.handleMSBOEntiall(ParameterData,thisIndex,j);        
    end
end

% ������ʵ�壬����ת��Ϊһ�����㡣
[ParameterData,noentII]=VertexEntiallUtil.handleVertexEntiallUtil(ParameterData,noent);

fprintf('\n��ʼ����ʵ����ɫ\n');
% �޸�ʵ����ɫ
mIgesColorUtil=IgesColorUtil(colorMap,defaultColor);
for i=1:noentII
    if printInfo
        entiallInfo=igesEntiallInfo.getEntiallInfo(ParameterData{i});
    end
    if ParameterData{i}.well==0
        if printInfo
            fprintf('������ʵ�壺%s\n',entiallInfo);
        end
        continue;
    else
        if printInfo
            fprintf('�����޸�ʵ����ɫ��%s\n',entiallInfo);
        end
    end
    if mIgesColorUtil.isNeedHandleColor(ParameterData{i}.type)
        ParameterData{i}=mIgesColorUtil.handleParameterDataColor(ParameterData{i});
    end
end

fprintf('\n��ʼ����ʵ������\n');
% ����length��ratio�Ȳ��������һ�����㣩
for i=1:noentII
    if printInfo
        entiallInfo=igesEntiallInfo.getEntiallInfo(ParameterData{i});
    end
    if ParameterData{i}.well==0
        if printInfo
            fprintf('������ʵ�壺%s\n',entiallInfo);
        end
        continue;
    else
        if printInfo
            fprintf('���ڼ���ʵ�����ݣ�%s\n',entiallInfo);
        end
    end
    type=ParameterData{i}.type;
    position=find(support_final_calculation_fcn_types==type);
    if position>0
        % ��������Ҫ�������ռ���
        thisFcn=support_final_calculation_fcns{position};
        ParameterData{i}=thisFcn(ParameterData{i},numPnt,nu,nv);
        if printInfo
            fprintf('%s\n�ɹ��������ռ���\n\n',entiallInfo);
        end
    end
end
fprintf('\n��ʼ��ͼ\n');
if printInfo
    handlePlot=plotIGES(ParameterData,srf,1,subd,1,fine_flag,1,0,igesEntiallInfo);
else
    handlePlot=plotIGES(ParameterData,srf,1,subd,1,fine_flag,1,0);
end
fprintf('\n��ͼ���\n');
end