function [Calls,audiodata,ClusteringData] = loadCallfile(filename)
audiodata = [];
ClusteringData = [];
load(filename, 'Calls');
load(filename, 'audiodata');
load(filename, 'ClusteringData)');

% Backwards compatibility with struct format for detection files
if isstruct(Calls); Calls = struct2table(Calls, 'AsArray', true); end
if isempty(Calls); disp(['No calls in file: ' filename]); end
