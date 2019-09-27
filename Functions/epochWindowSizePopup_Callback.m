function  epochWindowSizePopup_Callback(hObject, eventdata, handles)

hObject = handles.epochWindowSizePopup;
padding = cellstr(get(hObject,'String')); 
seconds = regexp(padding{get(hObject,'Value')},'([\d*.])*','match');
seconds = str2num(seconds{1});
handles.data.settings.windowSize = seconds;
update_fig(hObject, eventdata, handles);

guidata(hObject, handles);
end

