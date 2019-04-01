function []=start(reCompile)
if nargin >0
    if reCompile>0
        makeIGESmex;
    end
end
fileName = 'IGESfiles/example.igs';
% Load parameter data from IGES-file.
[ParameterData,EntityType,numEntityType,unknownEntityType,numunknownEntityType]=iges2matlab(fileName);

% Plot the IGES object
plotIGES(ParameterData,0);
end