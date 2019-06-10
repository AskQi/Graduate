clc
clear;

% ����ģʽ���Զ�ѡ��Ĭ���ļ�
isDebugMode=1;

if isDebugMode
    % ����Ҫ���Ƶ�ʵ�壬����ʱȡ��ע��
    igsfile = 'C:\Users\QiDa\Desktop\����Ů��ά��˹.igs';
    printInfo=true;
else
    printInfo=false;
    % ѡ��Ҫ���Ƶ�IGES�ļ�
    workingdir = pwd ;
    igesdir = dir('IGESfiles*') ;
    if ~isempty(igesdir.name), cd(igesdir.name), end
    
    [igsfile,igesdir] = uigetfile('*.igs;*.iges','��ѡ��Ҫ���ص�IGES�ļ�') ;
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