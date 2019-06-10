function [handlePlot]=playIGES(igsfile,isDebugMode,srf,subd,fine_flag)
global support_read_fcn_types support_read_fcns...
    support_convert_fcn_types support_convert_fcns...
    support_final_calculation_fcn_types support_final_calculation_fcns...
    mat3x3

%如果使用调试模式就现实所有输出信息
printInfo=isDebugMode;
% 将当前文件夹下的所有文件夹都包括进调用函数的目录
addpath(genpath(pwd));
fprintf('文件名：%s\n',igsfile);
[fid,msg]=fopen(igsfile);
if fid==-1
    error(msg);
end
c = fread(fid,'uint8=>uint8')';
fclose(fid);
% 加载IGES实体信息类
% iges_entiall_file='iges_entiall_info.xlsx';
% igesEntiallInfo=IgesEntiallInfo(iges_entiall_file);
% 加快速度
load 'igesEntiallInfo.mat';

nwro=sum((c((81:82))==10))+sum((c((81:82))==13));%第81，82个数据为10的个数和为13的个数
%第81、82个数为iges文件中第一行末尾的换行符和第二行第一个字符的ascii码（换行符（10），回车键（13））
edfi=nwro-sum(c(((end-1):end))==10)-sum(c(((end-1):end))==13);%nwro-最后两个数中为10和13的个数
siz=length(c);
ro=round((siz+edfi)/(80+nwro));
if rem((siz+edfi),(80+nwro))~=0 %如果最后一行没有换行符的话则加上与第一行相同的换行符或回车键作为总字符数
    error('该文件可能不是IGES文件!');
end
%分子为字符总个数，分母为每行的字符个数，IGES文件每行字符数目相同

roind=1:ro;%ro为文件行数
SGDPT=c(roind*(80+nwro)-7-nwro);%每行的第73个字符代表所属区段

%S部分直接显示即可
Sfind=SGDPT==double('S');%得到的为布尔值，判断第几个行末字符为S
Gfind=SGDPT==double('G');
Dfind=SGDPT==double('D');
Pfind=SGDPT==double('P');
% T部分没有必要弄
Tfind=SGDPT==double('T');

sumSfind=sum(Sfind);%S段一共有几行
sumGfind=sum(Gfind);
sumDfind=sum(Dfind);
sumPfind=sum(Pfind);
sumTfind=sum(Tfind);

%用于处理偏置曲面
offsetExists=false;
%用于处理变换矩阵
transformationExists=false;
mat3x3=zeros(3);

% 这里加载读取各个实体的模块
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

% 这里加载转换各个实体的模块
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

% 这里加载需要最终计算的各个实体的模块
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
%------S 部分的信息---------
%S部分都是注释，可以直接输出
fprintf('\n正在加载S部分\n');
if printInfo
    for i=roind(Sfind)%直接输出S段信息
        fprintf(char(c(((i-1)*(80+nwro)+1):(i*(80+nwro)-8-nwro))));
        fprintf('\n');
    end
end
%------G 部分的信息---------
%G部分记录了25个信息，默认使用“,”进行分割。
%在这里将其全部信息合并
fprintf('\n正在加载G部分\n');
G=cell(1,25);%全局段定义25个参数
%记录G部分有效部分合并为一行后的结果
Gstr=zeros(1,72*sumGfind);%每行72个有效字符
j=1;
for i=roind(Gfind)
    Gstr(((j-1)*72+1):(j*72))=c(((i-1)*(80+nwro)+1):(i*(80+nwro)-8-nwro));
    j=j+1;
end%j最终为G段的行数+1
%识别预设分隔符,st为当前指针
if and(Gstr(1)==double('1'),Gstr(2)==double('H'))%前两个字符为1，H
    G{1}=Gstr(3);%第三个字符为参数分隔符
    st=4;
else
    G{1}=double(',');%参数分隔符为缺省值“，”
    st=1;
end

if and(Gstr(st+1)==double('1'),Gstr(st+2)==double('H'))
    G{2}=Gstr(st+3);
    st=st+4;
else
    G{2}=double(';');%记录分界符为缺省值“；”
    st=st+1;
end

le=length(Gstr);
for i=3:25
    for j=(st+1):le
        if or(Gstr(j)==G{1},Gstr(j)==G{2})%取到某一个j时遇到“，”或“；”跳出此for循环，给当前G{i}赋值
            break
        end
    end
    G{i}=Gstr((st+1):(j-1));%此处j当前参数后的分隔符
    st=j;
end

for i=[3 4 5 6 12 15 18 21 22 25]%string,这些参数为字符串形式，排除每个参数中的空格和H
    %确定开始位置
    stind=1;
    for j=1:length(G{i})
        if G{i}(j)~=double(' ')%第i个参数第j个字符不是空格
            stind=j;%从第一个
            break
        end
    end
    for j=stind:length(G{i})
        if G{i}(j)==double('H')%第j个字符是H
            stind=j+1;%H之后的字符为实际参数
            break
        end
    end
    %确定结束位置
    endind=length(G{i});
    for j=length(G{i}):-1:1
        if G{i}(j)~=double(' ')
            endind=j;%G{i}的最后一个字符不能是空格
            break
        end
    end
    G{i}=G{i}(stind:endind);%第i个字符串参数的实际字符段
end
if printInfo
    G_Description={'参数分隔符','记录分隔符','发送系统产品ID','文件名',...
        '系统ID','前置处理器版本','整数的二进制表示位数',...
        '发送系统单精度浮点数十进制最大幂次','发送系统单精度浮点数有效位数',...
        '发送系统双精度浮点数十进制最大幂次','发送系统双精度浮点数有效位数',...
        '接收系统产品ID','模型空间比例','单位标志','单位','直线线宽的最大等级',...
        '最大直线线宽','交换文件生成的日期和时间','用户设定的模型等级的最小值',...
        '模型的近似最大坐标值','作者名','作者单位',...
        '对应于创建本文件的IGES标准版本号的整数','绘图标准',...
        '创建或最近修改模型的日期和时间'};
    for j=1:length(G_Description)
        fprintf('(%d)%s：%s\n',j,G_Description{j},G{j});
    end
end
%到这里，G已经获取了所有关于G的数据
for i=[7 8 9 10 11 13 14 16 17 19 20 23 24]   %num
    G{i}=str2num(char(G{i}));
end
fprintf('\nG部分加载完成\n');

%------D 部分的信息---------
%元素个数
fprintf('\n正在加载D部分和P部分\n');
noent=round(sumDfind/2);%目录条目段每个实体占两行

% 预分配ParameterData的空间以加快速度
ParameterData=cell(1,noent);

% 用于存储D中186实体所在的i
indexOfMSBOEntty=[];

roP=sumSfind+sumGfind+sumDfind;%参数段的起始位置-1

entty=zeros(1,520);

% Default color
defaultColor=[0.8,0.8,0.9];
% 存储颜色
colorMap=containers.Map('KeyType','int32','ValueType','any');

% 开始读取数据
entiall=0;
startD=sumSfind+sumGfind+1;
endD=sumSfind+sumGfind+sumDfind-1;
for i=startD:2:endD
    %i从D段开始行数计，到D段结束行
    entiall=entiall+1;
    Dstr1=c(((i-1)*(80+nwro)+1):(i*(80+nwro)-8-nwro));%该实体第一行除去最后八个字符之外的所有字符
    Dstr2=c((i*(80+nwro)+1):((i+1)*(80+nwro)-8-nwro));%第二行
    
    % 当前行在D中的位置（两行中的第一行）
    thisLineNumberOfD=i-startD+1;
    
    type=str2num(char(Dstr1(1:8)));%把ascii码转换为对应的字符
    transformationMatrixPtr=str2num(char(Dstr1(49:56)));%转换矩阵指针域(转换矩阵用于坐标变换)
    if isempty(transformationMatrixPtr)
        transformationMatrixPtr=0;
    end
    colorNo=str2num(char(Dstr2(17:24)));%实体的颜色号
    if isempty(colorNo)
        colorNo=0;
    end
    formNo=str2num(char(Dstr2(33:40)));%实体的格式号
    if isempty(formNo)
        formNo=0;
    end
    
    if transformationMatrixPtr>0
        transformationMatrixPtr=round((transformationMatrixPtr+1)/2);
    end
    
    if printInfo
        D1_Description={'元素类型号','参数指针','版本',...
            '线型','图层','视图','变换矩阵',...
            '标号显示','状态号'};
        D2_Description={'元素类型号','直线的权号','颜色号',...
            '参数记录数','形式号','留作将来使用','留作将来使用',...
            '元素标号','元素下标号'};
        fprintf('=> D部分信息如下：\n');
        for j=1:length(D1_Description)
            fprintf('(%d)%s：%d\n',j,D1_Description{j},str2num(char(Dstr1(j*8-7:j*8))));
        end
        for j=1:length(D2_Description)
            fprintf('(%d)%s：%d\n',j+10,D2_Description{j},str2num(char(Dstr2(j*8-7:j*8))));
        end
    end
    % P部分开始
    Pstart=str2num(char(Dstr1(9:16)))+roP;
    %该实体在P段的起始行数+P段起始行数-1=该实体所在行数
    if i==roP-1%该实体为最后一个实体
        Pend=ro-sumTfind;%则该实体最后一行就是T段前一行
    else
        Pend=str2num(char(c(((i+1)*(80+nwro)+9):((i+1)*(80+nwro)+16))))+roP-1;
        %下一个实体在P段的起始行数+SGD段行数之和-1=该实体P段结束行数
    end
    
    Pstr=zeros(1,64*(Pend-Pstart+1));%每行的有效信息为前8个域共64个字符
    j=1;
    for k=Pstart:Pend
        Pstr(((j-1)*64+1):(j*64))=c(((k-1)*(80+nwro)+1):(k*(80+nwro)-16-nwro));
        j=j+1;
    end
    
    Pstr(Pstr==G{1})=44;
    Pstr(Pstr==G{2})=59;
    %P段的分隔符和分界符统一为“，”和“；”，方便给Pvec赋值时自动以“，”分隔参数
    Pvec=str2num(char(Pstr));%该实体的全部参数信息ascii码转为数字, 遇到“，”会自动分开存储
    if printInfo
        fprintf('=> P部分信息如下：\n');
    end
    % 存储实体
    entty(type)=entty(type)+1;
    % 因为P部分的格式是不固定的，所以要根据不同的元素进行不同的数据解析
    % 这里使用模块化技术，添加相应的文件即可解析相关实体
    position=find(support_read_fcn_types==type);
    if position>0
        isread='成功读取';
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
            %颜色实体相关处理。
            thisColor=ParameterData{entiall}.color;
            thisColorNumber=-thisLineNumberOfD;
            colorMap(thisColorNumber)=thisColor;
%             colorDict.(strcat('c',num2str(thisColorNumber)))=thisColor;
            fprintf('添加颜色（%d）\n',thisColorNumber);
            if isempty(ParameterData{entiall}.cname)
                ParameterData{entiall}.cname=num2str(thisColorNumber);
            end
            
        end
    else
        isread='无法读取';
        entty(type)=entty(type)-1;
        ParameterData{entiall}.type=type;
        ParameterData{entiall}.unknown=char(Pstr);
        ParameterData{entiall}.well=false;
        ParameterData{entiall}.original=1;
        ParameterData{entiall}.length=0;
    end
    
    if ~isfield(ParameterData{entiall},'name')
        %没有设置名字就按照标准给定名字
        ParameterData{entiall}.name=igesEntiallInfo.getNameByType(type);
    end
    
    if printInfo
        fprintf('类型：%d，名称：%s\n是否能够读取：%s\n\n',...
            ParameterData{entiall}.type,ParameterData{entiall}.name,isread);
    end
    
end

% 将其他类型实体转换为NURBS实体
fprintf('\n开始处理实体类型转换\n');
noentI=noent;
for i=1:noent
    if ParameterData{i}.well==0
        continue;
    end
    type=ParameterData{i}.type;
    position=find(support_convert_fcn_types==type);
    if position>0
        % 该类型需要转换
        thisFcn=support_convert_fcns{position};
        [ParameterData,enttyCut,noentI]=thisFcn(ParameterData,i,noentI);
        entty(ParameterData{i}.type)=entty(ParameterData{i}.type)+enttyCut;
        if printInfo
            fprintf('类型：%d，名称：%s\n成功转化为NURBS实体\n\n',...
                ParameterData{entiall}.type,ParameterData{entiall}.name);
        end
    end
end
noent=noentI;
% 处理偏置曲线和曲面
if offsetExists
    fprintf('\n开始处理偏置曲线和曲面\n');
    for i=1:noent
        if ParameterData{i}.type==130
            ParameterData=OffsetLineUtil.handleOffsetLine(ParameterData,i);
        end
        if ParameterData{i}.type==140
            ParameterData=OffsetSurfaceUtil.handleOffsetSurface(ParameterData,i);
        end
    end
end

% 对于存在186实体的使各个实体的颜色各不相同
if entty(186)>0
    fprintf('\n开始转换186相关实体颜色\n');
    % TODO:186相关实体处理
    for j=1:entty(186)
        thisIndex=indexOfMSBOEntty(j);
        ParameterData=MSBOEntiallUtil.handleMSBOEntiall(ParameterData,thisIndex,j);        
    end
end

% 处理顶点实体，将其转换为一个个点。
[ParameterData,noentII]=VertexEntiallUtil.handleVertexEntiallUtil(ParameterData,noent);

fprintf('\n开始配置实体颜色\n');
% 修改实体颜色
mIgesColorUtil=IgesColorUtil(colorMap,defaultColor);
for i=1:noentII
    if printInfo
        entiallInfo=igesEntiallInfo.getEntiallInfo(ParameterData{i});
    end
    if ParameterData{i}.well==0
        if printInfo
            fprintf('不可用实体：%s\n',entiallInfo);
        end
        continue;
    else
        if printInfo
            fprintf('正在修改实体颜色：%s\n',entiallInfo);
        end
    end
    if mIgesColorUtil.isNeedHandleColor(ParameterData{i}.type)
        ParameterData{i}=mIgesColorUtil.handleParameterDataColor(ParameterData{i});
    end
end

fprintf('\n开始计算实体数据\n');
% 计算length、ratio等参数（最后一步计算）
for i=1:noentII
    if printInfo
        entiallInfo=igesEntiallInfo.getEntiallInfo(ParameterData{i});
    end
    if ParameterData{i}.well==0
        if printInfo
            fprintf('不可用实体：%s\n',entiallInfo);
        end
        continue;
    else
        if printInfo
            fprintf('正在计算实体数据：%s\n',entiallInfo);
        end
    end
    type=ParameterData{i}.type;
    position=find(support_final_calculation_fcn_types==type);
    if position>0
        % 该类型需要进行最终计算
        thisFcn=support_final_calculation_fcns{position};
        ParameterData{i}=thisFcn(ParameterData{i},numPnt,nu,nv);
        if printInfo
            fprintf('%s\n成功进行最终计算\n\n',entiallInfo);
        end
    end
end
fprintf('\n开始绘图\n');
if printInfo
    handlePlot=plotIGES(ParameterData,srf,1,subd,1,fine_flag,1,0,igesEntiallInfo);
else
    handlePlot=plotIGES(ParameterData,srf,1,subd,1,fine_flag,1,0);
end
fprintf('\n绘图完成\n');
end