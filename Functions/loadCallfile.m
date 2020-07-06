function [Calls,audiodata,ClusteringData] = loadCallfile(filename,handles)
audiodata = struct;

ClusteringData = [];
load(filename, 'Calls');
load(filename, 'audiodata');
load(filename, 'ClusteringData)');

% Backwards compatibility with struct format for detection files
if isstruct(Calls); Calls = struct2table(Calls, 'AsArray', true); end
if isempty(Calls); 
    disp(['No calls in file: ' filename]); 
else
   invalid_calls = [];
   for i=1:size(Calls,1)
       call_box = Calls{i,'Box'};
       if call_box(3) == 0 | call_box(4) == 0
          invalid_calls = [invalid_calls, i]; 
       end
   end
   Calls(invalid_calls,:) = [];
end

%Handles are required for audiodata. When hanles are missing, return only
%the calls
if isempty(handles)
    return;
end

if  ~exist('audiodata') | ~isfield(audiodata,'AudioFile') | ~isfile(filename) | ~isfield(audiodata,'duration')
    [~, file_part] = fileparts(filename); 
    [file,path] = uigetfile({'*.wav'; '*.ogg'; '*.flac'; '*.au'; '*.aiff'; '*.aif'; '*.aifc'; '*.mp3'; '*.m4a';'*.mp4';}, sprintf('Importing from standard DeepSquek. Select audio matching the detection file %s',file_part));  
    
    audiodata = struct;
    info = audioinfo([path,file]);
    audiodata.duration = info.Duration;
    
    audiodata.AudioFile = file;
    save(filename,'Calls','ClusteringData','audiodata','-v7.3');
    
end  

audiodata = loadAudioData(handles.data.settings.audiofolder,audiodata.AudioFile,audiodata);

