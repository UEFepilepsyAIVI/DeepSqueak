% --- Executes on selection change in popupmenuColorMap.
function popupmenuColorMap_Callback(hObject, eventdata, handles)
    hObject = handles.popupmenuColorMap;
    handles.data.cmapName=get(hObject,'String');
    handles.data.cmapName=handles.data.cmapName(get(hObject,'Value'));
    if strcmp(handles.data.cmapName{1,1},'black&white')
        handles.data.cmap=flipud(gray(256));
    else
        handles.data.cmap=feval(handles.data.cmapName{1,1},256);
    end
    colormap(handles.axes1,handles.data.cmap);
    colormap(handles.axes4,handles.data.cmap);
    colormap(handles.spectogramWindow,handles.data.cmap);
end
