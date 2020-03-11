function update_fig(hObject, ~, handles)

set(handles.hFig, 'pointer', 'watch')
drawnow;

if isempty(handles.data.calls)
    return
end

set(0,'defaultFigureVisible','off');
if ( handles.data.current_call_valid | ~isempty(handles.current_focus_position) )
    update_focus_display(hObject,handles);
end
handles = guidata(hObject);
renderEpochSpectogram(hObject,handles);
handles = guidata(hObject);

% Plot Call Position
render_call_position(hObject,handles,handles.update_position_axes);
set(groot,'defaultFigureVisible','on');
set(handles.hFig, 'pointer', 'arrow')
guidata(hObject, handles);


