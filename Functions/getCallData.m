function [call] = getCallData(tag,handles)

    call = [];

    for i=1:size(handles.data.calls,1)
        current_tag = num2str(handles.data.calls{i,'Tag'});
        if strcmp(current_tag,tag)
            call = handels.data.calls{i,:};
        end
    end

end

