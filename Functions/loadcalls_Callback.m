% --- Executes on button press in LOAD CALLS.
function loadcalls_Callback(hObject, eventdata, handles)
h = waitbar(0,'Loading Calls Please wait...');
update_folders(hObject, eventdata, handles);
handles = guidata(hObject);
if nargin == 3 % if "Load Calls" button pressed
    handles.current_file_id = get(handles.popupmenuDetectionFiles,'Value');
    handles.current_detection_file = handles.detectionfiles(handles.current_file_id).name;
end

handles.data.calls = [];
handles.data.audiodata = [];
[handles.data.calls, handles.data.audiodata] = loadCallfile(fullfile(handles.detectionfiles(handles.current_file_id).folder,  handles.current_detection_file));

audiofile_name = regexp(handles.current_detection_file, '(\s+)(?=[\w.-]+[\s]+[\w.-]+[\s]+[\w.-]+$)','split');
audiofile_name = audiofile_name{1};

%For compatibility with the save format of original DeepSqueak, the
%calls are resaved with the audiodata if necessary.
update_audiodata = isempty(handles.data.audiodata);

for i=1:length(handles.audiofilesnames) 
    if ~isempty(regexp(handles.audiofilesnames{i}, strcat('^',audiofile_name, '[.]'),'match'))
        handles.data.audiodata.AudioFile  = handles.audiofilesnames{i}; 
    end
end

audio_file_path =  strcat(handles.data.settings.audiofolder,filesep, handles.data.audiodata.AudioFile);
[samples, duration,sample_rate] = loadAudioData(audio_file_path);

handles.data.audiodata.samples = samples;
handles.data.audiodata.duration = duration;
handles.data.audiodata.sample_rate = sample_rate;

if update_audiodata
    audiodata = handles.data.audiodata;
    save(fullfile(handles.detectionfiles(handles.current_file_id).folder,  handles.current_detection_file),'audiodata','-append')
end

tag_column_exists = strcmp('Tag',handles.data.calls.Properties.VariableNames);
if  ~tag_column_exists
    handles.data.calls.Tag =  [1:size(handles.data.calls,1)]';
end
handles.data.currentcall=1;
handles.data.current_call_tag = 1;
handles.data.current_call_valid = true;

handles.data.windowposition = 1;

handles.update_position_axes = 0;

cla(handles.axes7);
cla(handles.detectionAxes);
cla(handles.axes1);
cla(handles.spectogramWindow);
cla(handles.axes4);
cla(handles.axes3);
%% Create plots for update_fig to update

% Waveform
handles.Waveform = line(handles.axes3,1,1,'Color',[.1 .75 .75]);
handles.SNR = surface(handles.axes3,[],[],[],[],...
    'facecol','r',...
    'edgecol','interp',...
    'linew',2);
set(handles.axes3,'YTickLabel',[]);
set(handles.axes3,'XTickLabel',[]);
set(handles.axes3,'XTick',[]);
set(handles.axes3,'YTick',[]);
set(handles.axes3,'Color',[.1 .1 .1],'YColor',[1 1 1],'XColor',[1 1 1],'Box','off','Ylim',[-1 0],'Clim',[0 1]);

% Contour
handles.ContourScatter = scatter(1:5,1:5,'LineWidth',1.5,'Parent',handles.axes7,'XDataSource','x','YDataSource','y');
set(handles.axes7,'Color',[.1 .1 .1],'YColor',[1 1 1],'XColor',[1 1 1],'Box','off');
set(handles.axes7,'YTickLabel',[]);
set(handles.axes7,'XTickLabel',[]);
set(handles.axes7,'XTick',[]);
set(handles.axes7,'YTick',[]);
handles.ContourLine = line(handles.axes7,[1,5],[1,5],'LineStyle','--','Color','y');

% Focus spectogram
handles.spect = imagesc([],[],handles.background,'Parent', handles.axes1);
cb=colorbar(handles.axes1);
cb.Label.String = 'Amplitude';
cb.Color = [1 1 1];
cb.FontSize = 12;
ylabel(handles.axes1,'Frequency (kHz)','Color','w');
%xlabel(handles.axes1,'Time (s)','Color','w');
set(handles.axes1,'Color',[.1 .1 .1]);
handles.box=rectangle('Position',[1 1 1 1],'Curvature',0.2,'EdgeColor','g',...
    'LineWidth',3,'Parent', handles.axes1);

% Epoch spectogram
handles.epochSpect = imagesc([],[],handles.background,'Parent', handles.spectogramWindow);
cb=colorbar(handles.spectogramWindow);
cb.Label.String = 'Amplitude';
cb.Color = [1 1 1];
cb.FontSize = 12;
ylabel(handles.spectogramWindow,'Frequency (kHz)','Color','w');
xlabel(handles.spectogramWindow,'Time (s)','Color','w');
set(handles.spectogramWindow,'Color',[.1 .1 .1]);
set(handles.spectogramWindow,'Visible', 'on');
set(handles.epochSpect,'Visible', 'on');
set(handles.epochSpect,'ButtonDownFcn',@epoch_window_Callback);


% Filtered image
handles.filtered_image_plot = imagesc([],'Parent', handles.axes4);
set(handles.axes4,'Color',[.1 .1 .1],'YColor',[1 1 1],'XColor',[1 1 1],'Box','off');
set(handles.axes4,'YTickLabel',[]);
set(handles.axes4,'XTickLabel',[]);
set(handles.axes4,'XTick',[]);
set(handles.axes4,'YTick',[]);


%Make the top scroll button visible
set(handles.topRightButton, 'Visible', 'on');
set(handles.topLeftButton, 'Visible', 'on');

guidata(hObject,handles);
handles = guidata(hObject);



% Plot Call Position
render_call_position(hObject,handles,true);

colormap(handles.axes1,handles.data.cmap);
colormap(handles.axes4,handles.data.cmap);
close(h);

callPositionAxesXLim = xlim(handles.detectionAxes);
callPositionAxesXLim(1) = 0;
callPositionAxesXLim(2) = handles.data.audiodata.duration;
xlim(handles.detectionAxes,callPositionAxesXLim);
handles.currentWindowRectangle = rectangle(handles.detectionAxes,'Position',[0 0 0 0]);
guidata(hObject,handles);
handles = guidata(hObject);

handles.current_focus_position = [];


guidata(hObject, handles);
handles = guidata(hObject);

updateWindowPosition(hObject,handles);

popupmenuColorMap_Callback(hObject, eventdata, handles);
focusWindowSizePopup_Callback(hObject, eventdata, handles);
epochWindowSizePopup_Callback(hObject, eventdata, handles);




update_fig(hObject, eventdata, handles);


