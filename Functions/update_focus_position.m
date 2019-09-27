function  update_focus_position(hObject, handles)


    padding_value_index = get(handles.focusPaddingPopup,'Value');
    padding_values =  get(handles.focusPaddingPopup,'String');
    seconds = regexp(padding_values{padding_value_index},'([\d*.])*','match');
    seconds = str2num(seconds{1});    
    calls = table2array(handles.data.calls(:,2));
    current_call_start = calls( handles.data.currentcall,1);
    current_call_duration = calls( handles.data.currentcall,3);
    
    current_call_offset = (seconds - current_call_duration )/2;
    handles.current_focus_position = [];
   
    guidata(hObject,handles);
end

