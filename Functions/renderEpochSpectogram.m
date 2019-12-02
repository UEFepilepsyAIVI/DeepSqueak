function  renderEpochSpectogram(hObject, handles)
    %Plot current spectogram window
    axes(handles.spectogramWindow);

    windowsize = round(handles.data.audiodata.sample_rate * 0.01);
    noverlap = round(handles.data.audiodata.sample_rate * 0.005);
    nfft = round(handles.data.audiodata.sample_rate * 0.01);    

    window_start = max(round(handles.data.windowposition*handles.data.audiodata.sample_rate),1);
    window_stop = min(round(window_start+handles.data.audiodata.sample_rate*handles.data.settings.windowSize),length(handles.data.audiodata.samples));
    audio = handles.data.audiodata.samples(window_start:window_stop); 

    [zoomed_s, zoomed_f, zoomed_t] = spectrogram(audio,windowsize,noverlap,nfft,handles.data.audiodata.sample_rate,'yaxis');
    zoomed_t = zoomed_t + handles.data.windowposition;
    [spectogram_y_lims, zoomed_s,zoomed_f] = cutSpectogramFrequency(zoomed_s, zoomed_f,handles);
    
    % Plot Spectrogram
    cla(handles.spectogramWindow);
    handles.epochSpect = imagesc([],[],handles.background,'Parent', handles.spectogramWindow);

    colormap(handles.spectogramWindow,handles.data.cmap);
    set(handles.epochSpect,'ButtonDownFcn',@epoch_window_Callback)
      
    cb=colorbar(handles.spectogramWindow);
    cb.Label.String = 'Amplitude';
    cb.Color = [1 1 1];
    cb.FontSize = 12;

    set(handles.spectogramWindow,'YDir', 'normal','YColor',[1 1 1],'XColor',[1 1 1],'Clim',[0 get_spectogram_max(hObject,handles)]);

    set(handles.spectogramWindow,'Parent',handles.hFig);
    set(handles.epochSpect,'Parent',handles.spectogramWindow);
    set(handles.epochSpect,'CData',imgaussfilt(scaleSpectogram(zoomed_s, hObject, handles)),'XData',  zoomed_t,'YData',zoomed_f/1000);
  

    set(handles.spectogramWindow,'Xlim',[handles.epochSpect.XData(1) handles.epochSpect.XData(end)]);
    set(handles.spectogramWindow,'ylim',[spectogram_y_lims(1)/1000 spectogram_y_lims(2)/1000]);

    set_tick_timestamps(handles.spectogramWindow, false);
    
    % Box Creation
    render_call_boxes(handles.spectogramWindow, handles, hObject,false,false);

    spectogram_axes_ylim = ylim(handles.spectogramWindow);
    focus_axes_x_lim = xlim(handles.axes1);

    focus_area_rectangle = rectangle(handles.spectogramWindow,'Position',[focus_axes_x_lim(1),spectogram_axes_ylim(1), focus_axes_x_lim(2) - focus_axes_x_lim(1), spectogram_axes_ylim(2) ],'EdgeColor',[0,0,1], 'LineWidth',1);

    set(handles.spectogramWindow, 'YLimSpec', 'Tight');
    set(handles.spectogramWindow, 'XLimSpec', 'Tight');

    guidata(hObject, handles);
end

