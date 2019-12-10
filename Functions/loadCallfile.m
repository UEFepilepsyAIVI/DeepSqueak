function [Calls,audiodata,ClusteringData] = loadCallfile(filename,handles)
audiodata = {};

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
if isempty(audiodata)

    [filepath,name,ext] = fileparts(filename); 
    audiofile_name = regexp(name, '(\s+)(?=[\w.-]+[\s]+[\w.-]+[\s]+[\w.-]+$)','split');
    audiofile_name = audiofile_name{1};

    for i=1:length(handles.audiofilesnames) 

        if ~isempty(regexp(handles.audiofilesnames{i}, strcat('^',audiofile_name, '[.]'),'match'))
            audiodata.AudioFile  = handles.audiofilesnames{i}; 
        end
    end

    %If matching audiofile cannot be found, show an error message
    if isempty(audiodata)
        errordlg(sprintf('Audio file for "%s" not found. Please make sure the audio files are located within the "Audio" folder, and re-run the analysis using the Screener.',filename),'File Error');
        return;
    end    
    
end

audiodata = loadAudioData(handles.data.settings.audiofolder,audiodata.AudioFile,audiodata);

