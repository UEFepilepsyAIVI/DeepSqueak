function epoch_window_Callback(hObject, eventdata, handles)
    
    handles = guidata(hObject);
    padding_value_index = get(handles.focusWindowSizePopup,'Value');
    padding_values =  get(handles.focusWindowSizePopup,'String');
    seconds = regexp(padding_values{padding_value_index},'([\d*.])*','match');
    seconds = str2num(seconds{1});

    click_position = eventdata.IntersectionPoint;
    
    window_min = click_position(1) - seconds/2;
    window_max = click_position(1) + seconds/2;
    calls_within_window = list_calls_within_window(handles,[window_min, window_max]);

    if ~isempty(calls_within_window)
        handles.data.currentcall = calls_within_window(1);
        handles.data.current_call_valid = true;
        handles.data.current_call_tag = num2str(handles.data.calls{handles.data.currentcall,'Tag'});  
    else
        handles.data.current_call_valid = false;    
    end
    
    handles.current_focus_position = [window_min 0 seconds 0 ];
    
    parent = get(hObject,'parent');
    guidata(parent, handles);
    handles = guidata(parent);

    update_fig(parent, eventdata, handles)
end

