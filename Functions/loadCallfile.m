function [Calls,audiodata,ClusteringData] = loadCallfile(filename,handles)
audiodata = struct;

ClusteringData = [];
load(filename, 'Calls');
load(filename, 'audiodata');
load(filename, 'ClusteringData)');

% Backwards compatibility with struct format for detection files
if isstruct(Calls); Calls = struct2table(Calls, 'AsArray', true); end
if isempty(Calls); disp(['No calls in file: ' filename]); end

%Handles are required for audiodata. When hanles are missing, return only
%the calls
if isempty(handles)
    return;
end

%Try to match the detections to a file in the Audio folder
if ~exist('audiodata') | ~isfield(audiodata,'AudioFile')

    [filepath,name,ext] = fileparts(filename); 
    audiofile_name = regexp(name, '(\s+)(?=[\w.-]+[\s]+[\w.-]+[\s]+[\w.-]+$)','split');
    audiofile_name = audiofile_name{1};

    for i=1:length(handles.audiofilesnames) 

        if ~isempty(regexp(handles.audiofilesnames{i}, strcat('^',audiofile_name, '[.]'),'match'))
            audiodata.AudioFile  = handles.audiofilesnames{i}; 
        end
    end  
end

%If matching audiofile cannot be found, show file selection dialog
if  ~exist('audiodata') | ~isfield(audiodata,'AudioFile') | ~isfile(filename)
    [~, file_part] = fileparts(filename); 
    [file,path] = uigetfile({'*.wav'; '*.ogg'; '*.flac'; '*.au'; '*.aiff'; '*.aif'; '*.aifc'; '*.mp3'; '*.m4a';'*.mp4';}, sprintf('Select audio matching the detection file %s',file_part));   
    audiodata.AudioFile = file;
    save(filename,'Calls','ClusteringData','audiodata','-v7.3');
    
end  

audiodata = loadAudioData(handles.data.settings.audiofolder,audiodata.AudioFile,audiodata);

