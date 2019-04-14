function [thisEntiall]=FinalCalculations_126(thisEntiall)

if thisEntiall.length==0
    [~,le,evmtd]=crvPntsSrfNURBS(90,thisEntiall.nurbs,thisEntiall.v(1),thisEntiall.v(2));
    thisEntiall.length=le;
    thisEntiall.evalmthd=evmtd;
end
end