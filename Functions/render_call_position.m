function  render_call_position(hObject,handles, all_calls)

CallTime = handles.data.calls.Box(:,1);
if all_calls

    line([0 max(CallTime)],[0 0],'LineWidth',1,'Color','w','Parent', handles.detectionAxes);
    line([0 max(CallTime)],[1 1],'LineWidth',1,'Color','w','Parent', handles.detectionAxes);
    set(handles.detectionAxes,'XLim',[0 handles.data.audiodata.duration]);
    set(handles.detectionAxes,'YLim',[0 1]);

    set(handles.detectionAxes,'Color',[.1 .1 .1],'YColor',[.1 .1 .1],'XColor',[.1 .1 .1],'Box','off','Clim',[0 1]);
    set(handles.detectionAxes,'YTickLabel',[]);

    set(handles.detectionAxes,'YTick',[]);
    set(handles.detectionAxes,'XTick',[]);
    set(handles.detectionAxes,'XColor','none');

    guidata(hObject, handles);
    handles = guidata(hObject);

    cla(handles.detectionAxes);

    screen_size = get(0,'screensize');
    min_call_render_difference = 2*handles.data.audiodata.duration / (screen_size(3));
    for i=1:length(CallTime)
        color = [0,1,0];

        if i +1 < length(CallTime)
           if  CallTime(i+1) - CallTime(i) < min_call_render_difference
               continue
           end
        end

        if ~handles.data.calls.Accept(i)
           color = [1,0,0];
        end    

       line([CallTime(i) CallTime(i)], [0,1],'Parent', handles.detectionAxes,'Color',color, 'PickableParts','none') ;
    end
end
% Call position
 hText = findobj(handles.detectionAxes,'Type','Text');
 for i=1:length(hText)
     delete(hText(i));         
 end

sec = floor(CallTime(1));
min = floor(sec / 60);
milliseconds = CallTime(1) - sec;
 
handles.CurrentCallLineLext=  text((CallTime(1)),20,[num2str(min,'%.0f'),':', num2str(sec,'%.0f'), '.',num2str(milliseconds,'%.0f') ],'Color','W', 'HorizontalAlignment', 'center','Parent',handles.detectionAxes);

% Call position
 hLine = findobj(handles.detectionAxes,'Type','Line', '-and', 'LineWidth',3 );
 for i=1:length(hLine)
     delete(hLine(i));         
 end
 
handles.CurrentCallLinePosition = line([CallTime(1) CallTime(1)],[0 1],'LineWidth',3,'Color','g','Parent', handles.detectionAxes,'PickableParts','none');


if isfield(handles, 'data') 
    
        calltime = handles.data.calls.Box(handles.data.currentcall, 1);   

        if handles.data.calls.Accept(handles.data.currentcall)
            handles.CurrentCallLinePosition.Color = [0,1,0];
        else
            handles.CurrentCallLinePosition.Color = [1,0,0];
        end
        
        
        sec = floor(calltime);
        min = floor(sec / 60);
        milliseconds = floor((calltime - sec)*1000);
        sec = sec - (min * 60);
        call_time_label = [num2str(min,'%.0f'),':', num2str(sec,'%.0f'), '.',num2str(milliseconds,'%.0f') ];
        set(handles.CurrentCallLineLext,'Position',[calltime,1.4,0],'String',call_time_label);
        set(handles.CurrentCallLinePosition,'XData',[calltime(1) calltime(1)]);   
        set(handles.CurrentCallLinePosition,'YData',[0 1]);  
    hRectangle = findobj(handles.detectionAxes,'Type','Rectangle');
     for i=1:length(hRectangle)
         delete(hRectangle(i));         
     end
     handles.CurrentCallWindowRectangle = rectangle('Position',[  handles.data.windowposition 0 handles.data.settings.windowSize  1], 'Parent',handles.detectionAxes,'LineWidth',2,'EdgeColor','b' );      
end

guidata(hObject,handles);
end

