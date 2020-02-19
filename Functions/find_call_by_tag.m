function [call_index] = find_call_by_tag(calls, tag)
    call_index = [];
    for i=1:size(calls,1)
        if calls{i,'Tag'} == str2double(tag)
            call_index =i;
            break;
        end
    end
end

