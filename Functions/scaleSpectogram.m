function values = scaleSpectogram(values, hObject, handles)

    contents = cellstr(get(handles.spectogramScalePopup,'String'));
    scale = contents{get(handles.spectogramScalePopup,'Value')};
    
    if strcmp(scale,'log10')
        values =  log10(abs(values));
    end
    if strcmp(scale,'absolute')
        values =  abs(values);       
    end
  
    
end

