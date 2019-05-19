function [res]=ReadEntiall_141(Pstr,Pvec,type,colorNo,formNo,transformationMatrixPtr)
% 边界实体，在国标P131
res.type=type;
res.name='边界实体';

res.boundarytype=Pvec(2);

res.pref=Pvec(3);

res.sptr=round((Pvec(4)+1)/2);

res.n=Pvec(5);

res.crvpt=zeros(1,res.n);
res.sense=zeros(1,res.n);
res.k=zeros(1,res.n);
res.pscpt=cell(1,res.n);

res.msclength=zeros(1,res.n);
res.pscclctnlength=cell(1,res.n);
res.psclength=zeros(1,res.n);

res.numcrv=0;
res.numpscrv=zeros(1,res.n);
res.numpscrvc=cell(1,res.n);

stind=5;

for ii=1:res.n
    
    res.crvpt(ii)=round((Pvec(stind+1)+1)/2);
    res.sense(ii)=Pvec(stind+2);
    res.k(ii)=Pvec(stind+3);
    
    res.pscpt{ii}=round((Pvec((stind+4):(stind+3+res.k(ii)))+1)/2);
    res.pscclctnlength{ii}=zeros(1,res.k(ii));
    res.numpscrvc{ii}=zeros(1,res.k(ii));
    
    stind=stind+3+res.k(ii);
    
end

res.length=0;

res.mlcrv=0;

res.clrnmbr=colorNo;
res.color=[0,0,0];

res.well=true;
end