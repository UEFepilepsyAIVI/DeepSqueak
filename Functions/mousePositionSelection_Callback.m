function  mousePositionSelection_Callback(hObject,eventdata, handles)   


    click_position = eventdata.IntersectionPoint;
    
    window_min = click_position(1) - handles.data.settings.focus_window_size/2;

        
    handles.current_focus_position =  [window_min, 0, handles.data.settings.focus_window_size,0];    
    handles.data.windowposition =  click_position(1) - handles.data.settings.windowSize/2;
    handles.data.windowposition =  min(handles.data.windowposition,handles.data.audiodata.duration- handles.data.settings.windowSize/2);
    handles.data.windowposition =  max(handles.data.windowposition,handles.data.settings.windowSize/2);    
    guidata(hObject, handles);     
    epoch_window_Callback(hObject, eventdata, handles)    
    

    update_fig(hObject, eventdata, handles);
    guidata(hObject, handles);
    

end

