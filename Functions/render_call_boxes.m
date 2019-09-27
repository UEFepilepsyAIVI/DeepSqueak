function render_call_boxes(current_axes,handles, hObject,roi, fill_heigth)


    axis_xlim = get(current_axes,'Xlim');
    axis_ylim = get(current_axes,'Ylim');    

    
    call_start=1;
    call_stop=size(handles.data.calls,1);
    
    if roi
        if isfield(handles,'current_roi_list')
            for i=1:length(handles.current_roi_list)
                if isvalid(handles.current_roi_list{i})
                    delete(handles.current_roi_list{i});
                end
            end
        end
        handles.current_roi_list = {};
    end
    
    spectogramWindowContent = allchild(current_axes);    
    for i=1:length(spectogramWindowContent)

        if isa(spectogramWindowContent(i),'images.roi.Rectangle')
            delete( spectogramWindowContent(i));
        end   
    end    


    spectogramWindowContent = allchild(handles.spectogramWindow);    
    for i=1:length(spectogramWindowContent)

        if isa(spectogramWindowContent(i),'Rectangle')
            delete( spectogramWindowContent(i));
        end   
    end
   guidata(hObject,handles);
   refresh(handles.hFig);
    c = uicontextmenu;

    % Loop through all calls
    for i=call_start:call_stop
        current_box = handles.data.calls{i, 'Box'};
        current_tag = num2str(handles.data.calls{i,'Tag'});
        box_y = current_box(2);
        box_heigth = current_box(4);        
        if fill_heigth
           box_y = axis_ylim(1);
           box_heigth = axis_ylim(2);
        end
        % If the call is within current focus window
        if (current_box(1) >= axis_xlim(1) & current_box(1) < axis_xlim(2)) ...
           | ( current_box(1) + current_box(3)  >= axis_xlim(1) & current_box(1) + current_box(3) <= axis_xlim(2))...
           | (current_box(1) <=  axis_xlim(1) & current_box(1) + current_box(3) >=  axis_xlim(2)  )
            line_width = 0.5;
            box_color = 'r';    
            line_style = '-';
            if handles.data.calls.Accept(i)
                box_color = [0 1 0];  
            end
            if strcmp(current_tag, handles.data.current_call_tag)
                line_width = 2;   
                line_style = '-';                
            end
            
            if roi
                current_box = drawrectangle('Position',...
                                            [current_box(1), ...
                                            box_y,...
                                            current_box(3),...
                                            box_heigth],...
                                            'Parent',...
                                            current_axes,...
                                            'Color',...
                                            box_color,...
                                            'FaceAlpha',...
                                            0,...
                                            'LineWidth',...
                                            line_width,...
                                            'Tag',...
                                           current_tag);
                handles.current_roi_list{end+1} = current_box;
                set(current_box,'uicontextmenu',uicontextmenu);
                addlistener(current_box,'ROIClicked',@callBoxDeleteCallback);
                addlistener(current_box,'ROIMoved', @roiMovedCallback);                
                
            else
                currentZSpectogramWindowRectangle = rectangle(current_axes,'Position',[current_box(1), box_y,current_box(3), box_heigth],'LineWidth',line_width,'LineStyle',line_style);
                currentZSpectogramWindowRectangle.EdgeColor = box_color;     
            end
        end
    end
    guidata(hObject, handles);
end

