function [positiondata] = calculatePositionData(handles)
    positiondata = struct;
    calls = table2array(handles.data.calls(:,2));
    positiondata.current_call_start =  calls( handles.data.currentcall,1);
    positiondata.current_call_duration = calls( handles.data.currentcall,3);
end

