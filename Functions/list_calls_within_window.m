function [call_indexes] = list_calls_within_window(handles, limits)

    callStarts = handles.data.calls.Box(:,1);

    call_indexes = [];

    for i = 1:length(callStarts)
        if callStarts(i) > limits(1) & callStarts(i) < limits(2)
            call_indexes = [ call_indexes, i];
        end
    end

end

