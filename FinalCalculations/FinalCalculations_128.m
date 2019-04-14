function [thisEntiall]=FinalCalculations_128(thisEntiall)
meanLengthCrv=0;

num143=entty(143);
num144=entty(144);
meanLengthCrv=max(meanLengthCrv/max(num143+num144,1),1);

if num143+num144<20
    if num143+num144<5
        meanLengthCrv=meanLengthCrv/4;
    elseif num143+num144<13
        meanLengthCrv=meanLengthCrv/3;
    else
        meanLengthCrv=meanLengthCrv/2;
    end
end
numPnt=101;
nu=numPnt;
nv=numPnt;
P=nrbSrfRegularEvalIGES(thisEntiall.nurbs,thisEntiall.u(1),thisEntiall.u(2),nu,thisEntiall.v(1),thisEntiall.v(2),nv);

for j=1:numPnt
    thisEntiall.ratio(1)=max(sum(sqrt(sum((P(:,(2+(j-1)*numPnt):(j*numPnt))-P(:,(1+(j-1)*numPnt):(j*numPnt-1))).^2,1))),thisEntiall.ratio(1));
end

for j=1:numPnt
    thisEntiall.ratio(2)=max(sum(sqrt(sum((P(:,(numPnt+j):numPnt:((numPnt-1)*numPnt+j))-P(:,j:numPnt:((numPnt-2)*numPnt+j))).^2,1))),thisEntiall.ratio(2));
end

thisEntiall.ratio=thisEntiall.ratio*(4/meanLengthCrv);

ctrlPnts=thisEntiall.p(:,:);
meaP=mean(ctrlPnts,2);

singVals=svd(ctrlPnts*ctrlPnts'-(size(ctrlPnts,2)*meaP)*meaP');

if 1e6*singVals(3)<singVals(2)
    thisEntiall.isplane=true;
end
end