function callBoxDeleteCallback(rectangle,evt)
    hObject = get(rectangle,'Parent');
    handles = guidata(hObject);
    clicked_tag = get(rectangle, 'Tag');

    if( strcmp(evt.SelectionType,'right') )
        for i=1:size(handles.data.calls,1)

             current_tag = num2str(handles.data.calls{i, 'Tag'});
             if strcmp(current_tag,clicked_tag )
                 handles.data.calls(i,:) = [];

                 delete(rectangle);
                 next_tag = max(str2double(current_tag)-1,1);     

                 guidata(hObject,handles);
                               
                 calls_within_window = list_calls_within_window(handles, xlim(handles.spectogram));
                 SortCalls(hObject, [], handles, 'time', 0, next_tag);
                 
                 guidata(hObject,handles);
                 handles = guidata(hObject);
                 update_fig(hObject, [], handles)
                 return;
             end
        end        

    end

    if  strcmp(evt.SelectedPart, 'face') && strcmp(evt.SelectionType,'ctrl')
        choosedialog(rectangle,handles);
    end

    if  strcmp(evt.SelectedPart, 'face') && strcmp(evt.SelectionType,'left')
        if str2double(clicked_tag) ~= handles.data.currentcall        
             handles.data.currentcall =  str2double(clicked_tag);
             handles.data.current_call_tag = clicked_tag;  
             handles = guidata(hObject);
             update_fig(hObject, [], handles)
        end
    end
end  

function choice = choosedialog(rectangle,handles)

    figure = handles.figure1;
    hObject = get(rectangle,'Parent');
    axes_position = get(hObject, 'Position');

    axes_x_lim = xlim(hObject);
    axes_y_lim = ylim(hObject);
    position = get(rectangle, 'Position');
    tag = get(rectangle, 'Tag');

    rect_x_relative_to_axes = (position(1)-axes_x_lim(1) + position(3)) / (axes_x_lim(2)-axes_x_lim(1));
    rect_y_relative_to_axes = (position(2) + position(4)) / (axes_y_lim(2)-axes_y_lim(1));
    
    set(figure,'Units','Pixels');
    fig_pos = get(figure, 'Position');
    
    x_position = (axes_position(1) + axes_position(3)*rect_x_relative_to_axes)*fig_pos(3);
    y_position = (axes_position(2) + axes_position(4)*rect_y_relative_to_axes)*fig_pos(4) - 150;
       
    d = dialog('Position',[x_position y_position 200 40],'Name',['Call ' tag],'Units','normal');

    popup = uicontrol('Parent',d,...
           'Style','popup',...
           'Position',[10 10 100 25],...
           'String',handles.data.settings.labels,...
           'Callback',@popup_callback);
    
    %Set the currently selected type as default
    i = find_call_by_tag(handles.data.calls,tag);     
    current_type = handles.data.calls{i,'Type'};
    type_index = find(strcmp(popup.String, cellstr(current_type)));
    
    if isempty(type_index)
        type_index = size(popup.String,1)+1;
        popup_values = get(popup,'String');
        popup_values(type_index,1) = cellstr(current_type);
        set(popup,'String',popup_values);
    end
    
    popup.Value = type_index;
    label = uicontrol('Parent',d,...
           'Position',[120 12 70 25],...
           'String','Label',...
           'Callback',@label_callback,...
           'BackgroundColor',[0.302,0.502,0.302],...
           'ForegroundColor',[1.0 1.0 1.0]);      
              
    uiwait(d);

    function popup_callback(popup,event)
        idx = popup.Value;
        popup_items = popup.String;
        choice = char(popup_items(idx,:));
    end

    function label_callback(hObject,event)
        i = find_call_by_tag(handles.data.calls,tag);
        if ~isempty(i)
                idx = popup.Value;
                popup_items = popup.String;
                choice = char(popup_items(idx,:));
                handles.data.calls{i,'Type'} = {choice};
                guidata(figure,handles);
                handles = guidata(figure); 
                guidata(figure,handles);
                delete(gcf);  
                update_fig(figure, [], handles)
        end
    end

end