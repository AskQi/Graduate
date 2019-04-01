clc;
clear;

igsfile = 'igesToolBox/IGESfiles/point.igs';

fprintf("文件名：%s\n",igsfile);
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
    error('该文件可能不是IGES文件!');
end

roind=1:ro;
SGDPT=c(roind*(80+nwro)-7-nwro);

%S部分直接显示即可
Sfind=SGDPT==double('S');

Gfind=SGDPT==double('G');
Dfind=SGDPT==double('D');
Pfind=SGDPT==double('P');
% T部分没有必要弄
Tfind=SGDPT==double('T');

sumSfind=sum(Sfind);
sumGfind=sum(Gfind);
sumDfind=sum(Dfind);
sumPfind=sum(Pfind);
sumTfind=sum(Tfind);

%------S 部分的信息---------
%S部分都是注释，可以直接输出
fprintf("=> S部分信息如下：\n");
for i=roind(Sfind)
    fprintf(char(c(((i-1)*(80+nwro)+1):(i*(80+nwro)-8-nwro))));
    fprintf("\n");
end


%------G 部分的信息---------
%G部分记录了25个信息，默认使用“,”进行分割。
%在这里将其全部信息合并
G=cell(1,25);
%记录G部分有效部分合并为一行后的结果
Gstr=zeros(1,72*sumGfind);
j=1;
for i=roind(Gfind)
    Gstr(((j-1)*72+1):(j*72))=c(((i-1)*(80+nwro)+1):(i*(80+nwro)-8-nwro));
    j=j+1;
end
%识别预设分隔符,st为当前指针
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
%到这里，G已经获取了所有关于G的数据
G_Description={"参数分隔符","记录分隔符","发送系统产品ID","文件名",...
    "系统ID","前置处理器版本","整数的二进制表示位数",...
    "发送系统单精度浮点数十进制最大幂次","发送系统单精度浮点数有效位数",...
    "发送系统双精度浮点数十进制最大幂次","发送系统双精度浮点数有效位数",...
    "接收系统产品ID","模型空间比例","单位标志","单位","直线线宽的最大等级",...
    "最大直线线宽","交换文件生成的日期和时间","用户设定的模型等级的最小值",...
    "模型的近似最大坐标值","作者名","作者单位",...
    "对应于创建本文件的IGES标准版本号的整数","绘图标准",...
    "创建或最近修改模型的日期和时间"};
fprintf("=> G部分信息如下：\n");
for j=1:length(G_Description)
    fprintf("(%d)%s：%s\n",j,G_Description{j},G{j});
end


%------D 部分的信息---------
%元素个数
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

% 开始读取数据

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
    D1_Description={"元素类型号","参数指针","版本",...
        "线型","图层","视图","变换矩阵",...
        "标号显示","状态号"};
    D2_Description={"元素类型号","直线的权号","颜色号",...
        "参数记录数","形式号","留作将来使用","留作将来使用",...
        "元素标号","元素下标号"};
    fprintf("=> D部分信息如下：\n");
    for j=1:length(D1_Description)
        fprintf("(%d)%s：%d\n",j,D1_Description{j},str2num(char(Dstr1(j*8-7:j*8))));
    end
    for j=1:length(D2_Description)
        fprintf("(%d)%s：%d\n",j+10,D2_Description{j},str2num(char(Dstr2(j*8-7:j*8))));
    end
    
    % P部分开始
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
    
    % 存储实体
    
    ParameterData{entiall}.type=type;
    
    entty(type)=entty(type)+1;
    
    fprintf("=> P部分信息如下：\n");
    % 因为P部分的格式是不固定的，所以要根据不同的元素进行不同的数据解析
    switch type
        case 314 % 颜色定义（Color Definition）
            % 相关说明在V6标准P386
            ParameterData{entiall}.name='颜色';
            
            inn=find(or(Pstr==44,Pstr==59));
            % 三原色百分比，三个值组合起来就是颜色
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
            fprintf("type：%d，name：%s\ncc1：%s，cc2：%s，cc3：%s\ncname：%s\n",...
                ParameterData{entiall}.type,ParameterData{entiall}.name,ParameterData{entiall}.cc1,...
                ParameterData{entiall}.cc2,ParameterData{entiall}.cc3,ParameterData{entiall}.cname);
    end
end


