function ImportFromSonicVisualizer_Callback(hObject, eventdata, handles)

HZ_IN_KHZ = 1000;

[svname, svpath] = uigetfile('*.csv','Select Sonic visualizer box layer');
sv_table = readtable([svpath svname],'Delimiter', ',');

[audioname, audiopath] = uigetfile({'*.wav;*.wmf;*.flac;*.UVD' 'Audio File';'*.wav' 'WAV (*.wav)'; '*.wmf' 'WMF (*.wmf)'; '*.flac' 'FLAC (*.flac)'; '*.UVD' 'Ultravox File (*.UVD)'},['Select Audio File for ' svname],handles.data.settings.audiofolder);



info = audioinfo([audiopath audioname]);
if info.NumChannels > 1
    warning('Audio file contains more than one channel. Use channel 1...')
end

rate = info.SampleRate;
Calls  = cell2table(cell(0,9), 'VariableNames', {'Rate', 'Box', 'RelBox', 'Score', 'Audio', 'Accept', 'Type', 'Power', 'Tag'});
hc = waitbar(0,'Importing Calls from Sonic Visualizer');
n_rows = size(sv_table,1);
for i=1:n_rows
    waitbar(i/n_rows,hc);
    call_start = sv_table{i,1};
    call_duration = sv_table{i,2} - call_start;
    call_frequency_start = sv_table{i,3};
    call_frequency_length = sv_table{i,4} - call_frequency_start;
    call_label = 'USV';
    if size(sv_table,2) == 5
       call_label = cellstr(sv_table{i,5});     
    end

    box = [call_start,call_frequency_start/HZ_IN_KHZ, call_duration, call_frequency_length/HZ_IN_KHZ];
    relbox =[ 0 0 0 0];
    windL = box(1) - box(3);
    windR = box(1) + 2*box(3); 
    audio = mergeAudio([audiopath audioname], round([windL windR]*rate));
    
    new_call = {rate,box,relbox,1,audio,1,categorical(call_label),1,i};
    Calls = [Calls;new_call];
    
end
[~, box_file_name] = fileparts(svname);
[~, audio_file_name] = fileparts(audioname);

[samples, duration,sample_rate] = loadAudioData([audiopath audioname]);

audiodata.samples = samples;
audiodata.duration = duration;
audiodata.sample_rate = sample_rate;
audiodata.AudioFile = audioname;

% FileName = [audio_file_name, datestr(datetime('now'),'mmm-dd-yyyy hh_MM AM'), ' ',box_file_name, '.mat'];
% FilePath = [handles.data.settings.detectionfolder, FileName];
[FileName, PathName] = uiputfile(fullfile(handles.data.settings.detectionfolder, [box_file_name '.mat']),'Save Call File');
FilePath = [handles.data.settings.detectionfolder, FileName];
save(FilePath,'Calls','audiodata','-v7.3');
close(hc);
update_folders(hObject, eventdata, handles);
