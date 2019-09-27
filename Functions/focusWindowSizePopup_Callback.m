function focusWindowSizePopup_Callback(hObject, eventdata, handles)
    hObject = handles.focusWindowSizePopup;
    padding = cellstr(get(hObject,'String')); 
    seconds = regexp(padding{get(hObject,'Value')},'([\d*.])*','match');
    seconds = str2num(seconds{1});
    handles.data.settings.focus_window_size = seconds;
     
    %set(handles.slider1,  'SliderStep', [seconds/handles.data.audiodata.duration, 0.1]);
    
    update_fig(hObject, eventdata, handles);
    guidata(hObject, handles);
end