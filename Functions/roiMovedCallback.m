function  roiMovedCallback(rectangle,evt)
    hObject = get(rectangle,'Parent');
    handles = guidata(hObject);
    tag = get(rectangle,'Tag');
    
    for i=1:size(handles.data.calls,1)
        if handles.data.calls{i,'Tag'} == str2double(tag)
            handles.data.calls{i,'Box'} = rectangle.Position;
            handles.data.calls{i,'RelBox'} = calculateRelativeBox(rectangle.Position, handles.axes1);         
            WindL=round( ( rectangle.Position(1)-rectangle.Position(3) )* handles.data.audio.samplerate);
            WindR=round( WindL + 2*rectangle.Position(3) * handles.data.audio.samplerate);
            handles.data.calls{i, 'Audio'} = mergeAudio(handles.data.audio.samples, [WindL WindR])
        end
    end
    delete(rectangle)
    guidata(hObject,handles);
    handles = guidata(hObject);    
    SortCalls(hObject, [], handles, 'time', 0, str2double(tag));
    guidata(hObject,handles);
    update_fig(hObject, [], handles)
end

