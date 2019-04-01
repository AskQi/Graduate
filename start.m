clc;
clear;

igsfile = 'igesToolBox/IGESfiles/point.igs';

fprintf("�ļ�����%s\n",igsfile);
[fid,msg]=fopen(igsfile);
if fid==-1
    error(msg);
end
c = fread(fid,'uint8=>uint8')';
fclose(fid);

nwro=sum((c((81:82))==10))+sum((c((81:82))==13));
edfi=nwro-sum(c(((end-1):end))==10)-sum(c(((end-1):end))==13);
siz=length(c);
ro=round((siz+edfi)/(80+nwro));
if rem((siz+edfi),(80+nwro))~=0
    error('���ļ����ܲ���IGES�ļ�!');
end

roind=1:ro;
SGDPT=c(roind*(80+nwro)-7-nwro);

%S����ֱ����ʾ����
Sfind=SGDPT==double('S');

Gfind=SGDPT==double('G');
Dfind=SGDPT==double('D');
Pfind=SGDPT==double('P');
% T����û�б�ҪŪ
Tfind=SGDPT==double('T');

sumSfind=sum(Sfind);
sumGfind=sum(Gfind);
sumDfind=sum(Dfind);
sumPfind=sum(Pfind);
sumTfind=sum(Tfind);

%------S ���ֵ���Ϣ---------
%S���ֶ���ע�ͣ�����ֱ�����
fprintf("=> S������Ϣ���£�\n");
for i=roind(Sfind)
    fprintf(char(c(((i-1)*(80+nwro)+1):(i*(80+nwro)-8-nwro))));
    fprintf("\n");
end


%------G ���ֵ���Ϣ---------
%G���ּ�¼��25����Ϣ��Ĭ��ʹ�á�,�����зָ
%�����ｫ��ȫ����Ϣ�ϲ�
G=cell(1,25);
%��¼G������Ч���ֺϲ�Ϊһ�к�Ľ��
Gstr=zeros(1,72*sumGfind);
j=1;
for i=roind(Gfind)
    Gstr(((j-1)*72+1):(j*72))=c(((i-1)*(80+nwro)+1):(i*(80+nwro)-8-nwro));
    j=j+1;
end
%ʶ��Ԥ��ָ���,stΪ��ǰָ��
if and(Gstr(1)==double('1'),Gstr(2)==double('H'))
    G{1}=Gstr(3);
    st=4;
else
    G{1}=double(',');
    st=1;
end

if and(Gstr(st+1)==double('1'),Gstr(st+2)==double('H'))
    G{2}=Gstr(st+3);
    st=st+4;
else
    G{2}=double(';');
    st=st+1;
end

le=length(Gstr);
for i=3:25
    for j=(st+1):le
        if or(Gstr(j)==G{1},Gstr(j)==G{2})
            break
        end
    end
    G{i}=Gstr((st+1):(j-1));
    st=j;
end

for i=[3 4 5 6 12 15 18 21 22 25]   %string
    stind=1;
    for j=1:length(G{i})
        if G{i}(j)~=double(' ')
            stind=j;
            break
        end
    end
    for j=stind:length(G{i})
        if G{i}(j)==double('H')
            stind=j+1;
            break
        end
    end
    endind=length(G{i});
    for j=length(G{i}):-1:1
        if G{i}(j)~=double(' ')
            endind=j;
            break
        end
    end
    G{i}=G{i}(stind:endind);
end

% for i=[7 8 9 10 11 13 14 16 17 19 20 23 24]   %num
%     G{i}=str2num(char(G{i}));
% end
%�����G�Ѿ���ȡ�����й���G������
G_Description={"�����ָ���","��¼�ָ���","����ϵͳ��ƷID","�ļ���",...
    "ϵͳID","ǰ�ô������汾","�����Ķ����Ʊ�ʾλ��",...
    "����ϵͳ�����ȸ�����ʮ��������ݴ�","����ϵͳ�����ȸ�������Чλ��",...
    "����ϵͳ˫���ȸ�����ʮ��������ݴ�","����ϵͳ˫���ȸ�������Чλ��",...
    "����ϵͳ��ƷID","ģ�Ϳռ����","��λ��־","��λ","ֱ���߿�����ȼ�",...
    "���ֱ���߿�","�����ļ����ɵ����ں�ʱ��","�û��趨��ģ�͵ȼ�����Сֵ",...
    "ģ�͵Ľ����������ֵ","������","���ߵ�λ",...
    "��Ӧ�ڴ������ļ���IGES��׼�汾�ŵ�����","��ͼ��׼",...
    "����������޸�ģ�͵����ں�ʱ��"};
fprintf("=> G������Ϣ���£�\n");
for j=1:length(G_Description)
    fprintf("(%d)%s��%s\n",j,G_Description{j},G{j});
end


%------D ���ֵ���Ϣ---------
%Ԫ�ظ���
noent=round(sumDfind/2);
ParameterData=cell(1,noent);
roP=sumSfind+sumGfind+sumDfind;

entty=zeros(1,520);
entunk=zeros(1,520);

% Default color
defaultColor=[0.8,0.8,0.9];

subfiguresExists=false;
transformationExists=false;
offsetsurfaceExists=false;

%[spline2BezierCrvMat,spline2BezierSrfMat]=matrixSpline2Bezier();

mat3x3=zeros(3);

% ��ʼ��ȡ����

entiall=0;
startD=sumSfind+sumGfind+1;
endD=sumSfind+sumGfind+sumDfind-1;
for i=startD:2:endD
    
    entiall=entiall+1;
    Dstr1=c(((i-1)*(80+nwro)+1):(i*(80+nwro)-8-nwro));
    Dstr2=c((i*(80+nwro)+1):((i+1)*(80+nwro)-8-nwro));
    
    type=str2num(char(Dstr1(1:8)));
    transformationMatrixPtr=str2num(char(Dstr1(49:56)));
    if isempty(transformationMatrixPtr)
        transformationMatrixPtr=0;
    end
    colorNo=str2num(char(Dstr2(17:24)));
    if isempty(colorNo)
        colorNo=0;
    end
    formNo=str2num(char(Dstr2(33:40)));
    if isempty(formNo)
        formNo=0;
    end
    
    if transformationMatrixPtr>0
        transformationMatrixPtr=round((transformationMatrixPtr+1)/2);
    end
    if colorNo<0
        colorNo=-round((-colorNo+1)/2);
    end
    D1_Description={"Ԫ�����ͺ�","����ָ��","�汾",...
        "����","ͼ��","��ͼ","�任����",...
        "�����ʾ","״̬��"};
    D2_Description={"Ԫ�����ͺ�","ֱ�ߵ�Ȩ��","��ɫ��",...
        "������¼��","��ʽ��","��������ʹ��","��������ʹ��",...
        "Ԫ�ر��","Ԫ���±��"};
    fprintf("=> D������Ϣ���£�\n");
    for j=1:length(D1_Description)
        fprintf("(%d)%s��%d\n",j,D1_Description{j},str2num(char(Dstr1(j*8-7:j*8))));
    end
    for j=1:length(D2_Description)
        fprintf("(%d)%s��%d\n",j+10,D2_Description{j},str2num(char(Dstr2(j*8-7:j*8))));
    end
    
    % P���ֿ�ʼ
    Pstart=str2num(char(Dstr1(9:16)))+roP;
    
    if i==roP-1
        Pend=ro-sumTfind;
    else
        Pend=str2num(char(c(((i+1)*(80+nwro)+9):((i+1)*(80+nwro)+16))))+roP-1;
    end
    
    Pstr=zeros(1,64*(Pend-Pstart+1));
    j=1;
    for k=Pstart:Pend
        Pstr(((j-1)*64+1):(j*64))=c(((k-1)*(80+nwro)+1):(k*(80+nwro)-16-nwro));
        j=j+1;
    end
    
    Pstr(Pstr==G{1})=44;
    Pstr(Pstr==G{2})=59;
    
    Pvec=str2num(char(Pstr));
    
    % �洢ʵ��
    
    ParameterData{entiall}.type=type;
    
    entty(type)=entty(type)+1;
    
    fprintf("=> P������Ϣ���£�\n");
    % ��ΪP���ֵĸ�ʽ�ǲ��̶��ģ�����Ҫ���ݲ�ͬ��Ԫ�ؽ��в�ͬ�����ݽ���
    switch type
        case 314 % ��ɫ���壨Color Definition��
            % ���˵����V6��׼P386
            ParameterData{entiall}.name='��ɫ';
            
            inn=find(or(Pstr==44,Pstr==59));
            % ��ԭɫ�ٷֱȣ�����ֵ�������������ɫ
            ParameterData{entiall}.cc1=str2num(char(Pstr((inn(1)+1):(inn(2)-1))));
            ParameterData{entiall}.cc2=str2num(char(Pstr((inn(2)+1):(inn(3)-1))));
            ParameterData{entiall}.cc3=str2num(char(Pstr((inn(3)+1):(inn(4)-1))));
            ParameterData{entiall}.color=[ParameterData{entiall}.cc1 ParameterData{entiall}.cc2 ParameterData{entiall}.cc3]/100;
            
            defaultColor=ParameterData{entiall}.color;
            if length(inn)>4
                inn2=find(Pstr(1:(inn(5)-1))==72);
                if isempty(inn2)
                    ParameterData{entiall}.cname='';
                else
                    ParameterData{entiall}.cname=char(Pstr((inn2(1)+1):(inn(5)-1)));
                end
            else
                ParameterData{entiall}.cname='';
            end
            
            ParameterData{entiall}.original=1;
            ParameterData{entiall}.well=true;
            fprintf("type��%d��name��%s\ncc1��%s��cc2��%s��cc3��%s\ncname��%s\n",...
                ParameterData{entiall}.type,ParameterData{entiall}.name,ParameterData{entiall}.cc1,...
                ParameterData{entiall}.cc2,ParameterData{entiall}.cc3,ParameterData{entiall}.cname);
    end
end


