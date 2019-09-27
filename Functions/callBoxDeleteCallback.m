function callBoxDeleteCallback(rectangle,evt)
    hObject = get(rectangle,'Parent');
    handles = guidata(hObject);
    clicked_tag = get(rectangle, 'Tag');
    
    if( strcmp(evt.SelectionType,'middle') | strcmp(evt.SelectionType,'shift') )
        for i=1:size(handles.data.calls,1)

             current_tag = num2str(handles.data.calls{i, 'Tag'});
             if strcmp(current_tag,clicked_tag )
                 handles.data.calls(i,:) = [];

                 delete(rectangle);
                 next_tag = max(str2double(current_tag)-1,1);     

                 guidata(hObject,handles);
                               
                 %calls_within_window = list_calls_within_window(handles, xlim(handles.spectogram));
                 SortCalls(hObject, [], handles, 'time', 0, next_tag);
                 


                 guidata(hObject,handles);
                 handles = guidata(hObject);
                 update_fig(hObject, [], handles)
                 return;
             end
        end        

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