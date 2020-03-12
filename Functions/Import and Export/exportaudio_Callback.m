function exportaudio_Callback(hObject, eventdata, handles)
%% Save the audio within user defined time smapn to a WAV file. The
%% default span is the span of the currently selected call.

current_box = handles.data.calls.Box(handles.data.currentcall,:);

n_decimals = 16;
% Get the relative playback rate
answer = inputdlg({'Choose Playback Rate:', 'Audio start (s):','Audio stop (s):'},...
                   'Save Audio',...
                   [1 40],...
                   {num2str(handles.data.settings.playback_rate), num2str(current_box(1),n_decimals), num2str(current_box(1)+current_box(3),n_decimals)}...
                   );
if isempty(answer)
    disp('Cancelled by User');
    return
end

start_sec = str2num(answer{2});
stop_sec = str2num(answer{3});

if round(start_sec,n_decimals) ~= current_box(1) | stop_sec ~= current_box(1) + current_box(3)
    
    if isempty(start_sec) | isempty(stop_sec)
       errordlg('Please define valid audio start and stop time','Invalid audio range');
       return; 
    end
    
    audio_start = max(round(start_sec*handles.data.audiodata.sample_rate),1);
    audio_stop = min(round(stop_sec*handles.data.audiodata.sample_rate), length(handles.data.audiodata.samples));
    
    audio = handles.data.audiodata.samples(audio_start:audio_stop);
    audio = [mean(audio - mean(audio,1) ,2)]; 
    
else
    audio = handles.data.calls.Audio{handles.data.currentcall};  
end

% Convert audio to double

if ~isfloat(audio)
    audio = double(audio) / (double(intmax(class(audio)))+1);
elseif ~isa(audio,'double')
    audio = double(audio);
end

% Convert relative rate to samples/second
rate = str2double(answer{1}) * handles.data.calls.Rate(handles.data.currentcall);

% Get the output file name
[~,detectionName] = fileparts(handles.current_detection_file);
audioname=[detectionName ' Call ' num2str(handles.data.currentcall) '.WAV'];
[FileName,PathName] = uiputfile(audioname,'Save Audio');
if isnumeric(FileName)
    return
end

% Save the file
audiowrite(fullfile(PathName,FileName),audio,rate);
