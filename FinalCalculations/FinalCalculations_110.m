function [thisEntiall]=FinalCalculations_110(thisEntiall)

if thisEntiall.length==0
    [~,le,~]=crvPntsSrfNURBS(1,thisEntiall.p1,thisEntiall.p2);
    thisEntiall.length=le;
end
end