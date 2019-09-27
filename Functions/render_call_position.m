function  render_call_position(hObject,handles, all_calls)

CallTime = handles.data.calls.Box(:,1);

line([0 max(CallTime)],[0 0],'LineWidth',1,'Color','w','Parent', handles.detectionAxes);
line([0 max(CallTime)],[1 1],'LineWidth',1,'Color','w','Parent', handles.detectionAxes);
set(handles.detectionAxes,'XLim',[0 max(CallTime)]);
set(handles.detectionAxes,'YLim',[0 1]);

set(handles.detectionAxes,'Color',[.1 .1 .1],'YColor',[.1 .1 .1],'XColor',[.1 .1 .1],'Box','off','Clim',[0 1]);
set(handles.detectionAxes,'YTickLabel',[]);

set(handles.detectionAxes,'YTick',[]);
set(handles.detectionAxes,'XTick',[]);
set(handles.detectionAxes,'XColor','none');

guidata(hObject, handles);
handles = guidata(hObject);

cla(handles.detectionAxes);

for i=1:length(CallTime)
    color = [0,1,0];
    if ~handles.data.calls.Accept(i)
       color = [1,0,0];
    end    
    
   line([CallTime(i) CallTime(i)], [0,1],'Parent', handles.detectionAxes,'Color',color, 'PickableParts','none') ;
end

% Call position

handles.CurrentCallLinePosition = line([CallTime(1) CallTime(1)],[0 1],'LineWidth',3,'Color','g','Parent', handles.detectionAxes,'PickableParts','none');
handles.CurrentCallLineLext=  text((CallTime(1)),20,[num2str(1,'%.1f') ' s'],'Color','W', 'HorizontalAlignment', 'center','Parent',handles.detectionAxes);

if isfield(handles, 'data') 
    calltime = handles.data.calls.Box(handles.data.currentcall, 1);    
    if handles.data.calls.Accept(handles.data.currentcall)
        handles.CurrentCallLinePosition.Color = [0,1,0];
    else
        handles.CurrentCallLinePosition.Color = [1,0,0];
    end
    set(handles.CurrentCallLineLext,'Position',[calltime,1.4,0],'String',[num2str(calltime(1),'%.1f') ' s']);
    set(handles.CurrentCallLinePosition,'XData',[calltime(1) calltime(1)]);   
    set(handles.CurrentCallLinePosition,'YData',[0 1]);     
    
   
    rectangle('Position',[  handles.data.windowposition 0 handles.data.settings.windowSize  1], 'Parent',handles.detectionAxes,'LineWidth',2,'EdgeColor','b' );
    
end

guidata(hObject,handles);
end

