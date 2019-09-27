function [nextEvent] = findNextEvent(handles, direction)

    [positiondata] = calculatePositionData(handles);
    
    n_calls = size(handles.data.calls,1);
    
    nextEvent = handles.data.currentcall;
    calls = table2array(handles.data.calls(:,2));  
    while nextEvent <= n_calls

        eventStart = calls( nextEvent,1);     
        
        if eventStart > positiondata.windowStart && direction > 0
            break;
        end
        
        if eventStart < positiondata.windowStart + handles.data.settings.windowSize && direction < 0
            break;  
        end 
        
        nextEvent = nextEvent + direction;
                
    end
    nextEvent = max(nextEvent,1);
end

