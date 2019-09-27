function updateWindowPosition(hObject,handles)
    [positiondata] = calculatePositionData(handles);
    if handles.data.windowposition  + handles.data.settings.windowSize < positiondata.current_call_start || handles.data.windowposition  + handles.data.settings.windowSize > positiondata.current_call_start
        jumps = floor(positiondata.current_call_start / handles.data.settings.windowSize);  
        handles.data.windowposition = jumps*handles.data.settings.windowSize;
    end
      
    guidata(hObject, handles);
    
   
end