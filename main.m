clc
clear;

% 调试模式下自动选择默认文件
isDebugMode=1;

if isDebugMode
    % 加载要绘制的实体，测试时取消注释
    igsfile = 'C:\Users\QiDa\Desktop\自由女神维纳斯.igs';
    printInfo=true;
else
    printInfo=false;
    % 选择要绘制的IGES文件
    workingdir = pwd ;
    igesdir = dir('IGESfiles*') ;
    if ~isempty(igesdir.name), cd(igesdir.name), end
    
    [igsfile,igesdir] = uigetfile('*.igs;*.iges','请选择要加载的IGES文件') ;
    if ~igsfile
        cd(workingdir);
        return
    else
        cd(igesdir);
    end
    cd(workingdir);
    igsfile=strcat(igesdir,igsfile);
end


h=playIGES(igsfile,isDebugMode,1,100,0);