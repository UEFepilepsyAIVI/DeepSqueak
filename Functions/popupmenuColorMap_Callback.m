% --- Executes on selection change in popupmenuColorMap.
function popupmenuColorMap_Callback(hObject, eventdata, handles)
    hObject = handles.popupmenuColorMap;
    handles.data.cmapName=get(hObject,'String');
    handles.data.cmapName=handles.data.cmapName(get(hObject,'Value'));
    switch handles.data.cmapName{1,1}
        case 'magma'
            handles.data.cmap=magma;
        case 'inferno'
            handles.data.cmap=inferno;
        case 'viridis'
            handles.data.cmap=viridis;
        case 'plasma'
            handles.data.cmap=plasma;
        case 'hot'
            handles.data.cmap=hot;
        case 'cubehelix'
            handles.data.cmap=cubehelix;
        case 'parula'
            handles.data.cmap=parula;
        case 'jet'
            handles.data.cmap=jet;
        case 'hsv'
            handles.data.cmap=hsv;
        case 'cool'
            handles.data.cmap=cool;
        case 'spring'
            handles.data.cmap=spring;
        case 'summer'
            handles.data.cmap=summer;
        case 'autumn'
            handles.data.cmap=autumn;
        case 'winter'
            handles.data.cmap=winter;
        case 'gray'
            handles.data.cmap=gray;
        case 'black&white'
            handles.data.cmap=colormap(flipud(gray));
        case 'bone'
            handles.data.cmap=bone;
        case 'copper'
            handles.data.cmap=copper;
        case 'pink'
            handles.data.cmap=pink;
    end
    colormap(handles.axes1,handles.data.cmap);
    colormap(handles.axes4,handles.data.cmap);
    colormap(handles.spectogramWindow,handles.data.cmap);
end
