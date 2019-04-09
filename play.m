clc;
clear;
global support_read_fcn_type support_read_fcns support_drawing_fcn_type...
    support_drawing_fcns defaultColor
igsfile = 'igesToolBox/IGESfiles/circular_arc_full.igs';

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


% 这里加载读取各个实体的模块
read_entialls_dir = dir('ReadEntialls*');
if ~isempty(read_entialls_dir.name), cd(read_entialls_dir.name), end
read_entialls_fcn_file=dir('ReadEntiall_*.m');
expression='\d{3,4}';
[read_fcn_names_number,~]=size(read_entialls_fcn_file);

for j=1:read_fcn_names_number
    read_fcn_name=read_entialls_fcn_file(j).name;
    this_num= cellstr(regexp(read_fcn_name,expression,'match'));
    support_read_fcn_type(j)=transpose(str2num(cell2mat(this_num)));
    support_read_fcn_name="ReadEntiall_"+this_num;
    support_read_fcns{j} = str2func(support_read_fcn_name);
end
cd ..

% 这里加载读取各个实体的模块
drawing_entialls_dir = dir('DrawingEntialls*');
if ~isempty(drawing_entialls_dir.name), cd(drawing_entialls_dir.name), end
drawing_entialls_fcn_file=dir('drawingEntiall_*.m');
expression='\d{3,4}';
[drawing_fcn_names_number,~]=size(drawing_entialls_fcn_file);

for j=1:drawing_fcn_names_number
    drawing_fcn_name=drawing_entialls_fcn_file(j).name;
    this_num= cellstr(regexp(drawing_fcn_name,expression,'match'));
    support_drawing_fcn_type(j)=transpose(str2num(cell2mat(this_num)));
    support_drawing_fcn_name="DrawingEntiall_"+this_num;
    support_drawing_fcns{j} = str2func(support_drawing_fcn_name);
end
cd ..

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
    
    fprintf("=> P部分信息如下：\n");
    % 存储实体
    entty(type)=entty(type)+1;
    % 因为P部分的格式是不固定的，所以要根据不同的元素进行不同的数据解析
    % 这里使用模块化技术，添加相应的文件即可解析相关实体
    position=find(support_read_fcn_type==type);
    if position>0
        thisFcn=support_read_fcns{position};
        ParameterData{entiall}=thisFcn(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr);
    else
        ParameterData{entiall}.name='未知类型';
        ParameterData{entiall}.unknown=char(Pstr);
        ParameterData{entiall}.well=false;
        ParameterData{entiall}.type=type;
    end
    
    fprintf("\n\n");
end

% 关闭所有图像窗口
close all;
figure
hold on;
grid on;
axis equal
title('IGES文件浏览器');
x1=xlabel('X轴');        %x轴标题
x2=ylabel('Y轴');        %y轴标题
x3=zlabel('Z轴');        %z轴标题

fprintf("\n开始绘图\n");
for j=1:length(ParameterData)
    thisEntiall = ParameterData{j};
    type = thisEntiall.type;
    if thisEntiall.well~=true
        fprintf("该类型暂时无法处理：%d\n",type);
        fprintf("\n");
        continue;
    end
    position=find(support_drawing_fcn_type==type);
    if position>0
        thisFcn=support_drawing_fcns{position};
        thisFcn(thisEntiall);
    else
        fprintf("该类型实体绘制文件缺失：%d\n",type);
    end
    fprintf("\n");
    
end
