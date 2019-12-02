function update_focus_display(hObject, handles )


[I_f,windowsize_f,noverlap_f,nfft_f,rate_f,box_f,s_f,fr_f,ti_f,audio_f,AudioRange_f, window_start] = CreateFocusSpectrogram(handles.data.calls(handles.data.currentcall,:),handles);


[spectogram_y_lims, s_f,fr_f] = cutSpectogramFrequency(s_f, fr_f,handles);

% Plot Spectrogram
set(handles.axes1,'YDir', 'normal','YColor',[1 1 1],'XColor',[1 1 1],'Clim',[0 get_spectogram_max(hObject,handles)]);
set(handles.axes1,'Parent',handles.hFig);
set(handles.spect,'Parent',handles.axes1);
set(handles.spect,'CData',imgaussfilt(scaleSpectogram(s_f, hObject, handles)),'XData',  window_start + ti_f,'YData',fr_f/1000);


if handles.data.settings.DisplayTimePadding ~= 0
    meantime = box_f(1) + box_f(3) / 2;
    set(handles.axes1,'Xlim',[meantime - (handles.data.settings.DisplayTimePadding / 2), meantime + (handles.data.settings.DisplayTimePadding / 2)], 'color', 'k')
else
    set(handles.axes1,'Xlim',[handles.spect.XData(1) handles.spect.XData(end)]);
end


%Update spectogram ticks and transform labels to
%minutes:seconds.milliseconds
x_min_max = xlim(handles.axes1);
x_ticks = linspace(x_min_max(1), x_min_max(2),handles.data.settings.spectogram_ticks);
xticks(handles.axes1, x_ticks(2:end-1) );
set_tick_timestamps(handles.axes1,true);

set(handles.axes1,'ylim',[spectogram_y_lims(1)/1000 spectogram_y_lims(2)/1000]);

[I_f,windowsize_f,noverlap_f,nfft_f,rate_f,box_f,s_f,fr_f,ti_f,audio_f,AudioRange_f, window_start] = CreateFocusSpectrogram(handles.data.calls(handles.data.currentcall,:),handles,true);
stats = CalculateStats(I_f,windowsize_f,noverlap_f,nfft_f,rate_f,box_f,handles.data.settings.EntropyThreshold,handles.data.settings.AmplitudeThreshold);

handles.data.calls.Power(handles.data.currentcall) = stats.MaxPower;


guidata(hObject,handles);
handles = guidata(hObject);
% Box Creation
render_call_boxes(handles.axes1, handles,hObject, true,false);



if stats.FilteredImage
    % Blur Box
    set(handles.filtered_image_plot,'CData',flipud(stats.FilteredImage))
    set(handles.axes4,'Color',[.1 .1 .1],'YColor',[1 1 1],'XColor',[1 1 1],'Box','off','Clim',[.2*min(min(stats.FilteredImage)) .2*max(max(stats.FilteredImage))],'XLim',[1 size(stats.FilteredImage,2)],'YLim',[1 size(stats.FilteredImage,1)]);
    set(handles.axes4,'YTickLabel',[]);
    set(handles.axes4,'XTickLabel',[]);
    set(handles.axes4,'XTick',[]);
    set(handles.axes4,'YTick',[]);
end
% plot Ridge Detection
set(handles.ContourScatter,'XData',stats.ridgeTime','YData',stats.ridgeFreq_smooth);
set(handles.axes7,'Xlim',[1 size(I_f,2)],'Ylim',[1 size(I_f,1)]);

% Plot Slope
X = [ones(size(stats.ridgeTime)); stats.ridgeTime]';
ls = X \ (stats.ridgeFreq_smooth);
handles.ContourLine.XData = [1 size(I_f,2)];
handles.ContourLine.YData = [ls(1), ls(1) + ls(2) * size(I_f,2)];


% Update call statistics text
set(handles.Ccalls,'String',['Call: ' num2str(handles.data.currentcall) '/' num2str(height(handles.data.calls))]);
set(handles.score,'String',['Score: ' num2str(handles.data.calls.Score(handles.data.currentcall))]);
if handles.data.calls.Accept(handles.data.currentcall)
    set(handles.status,'String','Accepted');
    set(handles.status,'ForegroundColor',[0,1,0]); 
else
    set(handles.status,'String','Rejected');
    set(handles.status,'ForegroundColor',[1,0,0])       
end
set(handles.text19,'String',['Label: ' char(handles.data.calls.Type(handles.data.currentcall))]);
set(handles.freq,'String',['Frequency: ' num2str(stats.PrincipalFreq,'%.1f') ' kHz']);
set(handles.slope,'String',['Slope: ' num2str(stats.Slope,'%.3f') ' kHz/s']);
set(handles.duration,'String',['Duration: ' num2str(stats.DeltaTime*1000,'%.0f') ' ms']);
set(handles.sinuosity,'String',['Sinuosity: ' num2str(stats.Sinuosity,'%.4f')]);
set(handles.powertext,'String',['Avg. Power: ' num2str(handles.data.calls.Power(handles.data.currentcall)) ' dB/Hz'])
set(handles.tonalitytext,'String',['Avg. Tonality: ' num2str(stats.SignalToNoise,'%.4f')]);

% Waveform
PlotAudio = audio_f(max(AudioRange_f(1),1):AudioRange_f(2));
set(handles.Waveform,...
    'XData', length(stats.Entropy) * ((1:length(PlotAudio)) / length(PlotAudio)),...
    'YData', (.5*PlotAudio/max(PlotAudio)-.5))


% SNR
y = 0-stats.Entropy;
x = 1:length(stats.Entropy);
z = zeros(size(x));
col = double(stats.Entropy < 1-handles.data.settings.EntropyThreshold);  % This is the color, vary with x in this case.
set(handles.SNR, 'XData', [x;x], 'YData', [y;y], 'ZData', [z;z], 'CData', [col;col]);
colormap(handles.axes3,parula);
set(handles.axes3, 'XLim', [x(1), x(end)]);

guidata(hObject, handles);
end

