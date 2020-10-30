function ms_duplicate_filtering_Callback(hObject, eventdata, handles)

    [statsFileName, statsFilePath] = uigetfile({'*.xlsx'},'Select call statistics file','MultiSelect', 'off');

    if ~statsFilePath
       return; 
    end
    
    offset = str2double(inputdlg({'Overlap offset (ms)'},...
                    'Overlap offset',[1,40],{'100'}));
    if isempty(offset)
       return; 
    end
    
    if isnan(offset)
       errordlg('Overlap offset must be a number');
       return; 
    end

    offset = offset / 1000;

    call_stats = readtable(fullfile(statsFilePath,statsFileName));
    call_stats = sortrows(call_stats,'BeginTime_s_');

    ids = unique(call_stats.File);
    n_streams = length(ids);
    if n_streams == 1
       errordlg("Input contains single stream.");
       return;
    end
    overlapping = {};
    %For each audio stream
    for i=1:n_streams-1
        %Retrieve call from stream i

        i_call_indexes = find(strcmp(call_stats.File, ids(i,1)));

        indexes = ones(1,n_streams-i);
        %For each call in stream i
        for i_c = i_call_indexes'
            i_c_overlapping = [];
            %For each stream other than i
            for j=i+1:n_streams
               j_call_indexes = find(strcmp(call_stats.File, ids(j,1)))';
               j_c = indexes(j-i);
               %Calls that end before query call starts cannot overlap with the
               %query call
               while j_c < length(j_call_indexes) ...
                       & table2array(call_stats(i_c, 'BeginTime_s_')) >= table2array(call_stats(j_call_indexes(j_c), 'EndTime_s_')) +offset
                    j_c = min(j_c +1,length(j_call_indexes));  
               end
               %Calls are sorted, no need to start from the beginning next time
               indexes(j-i) = j_c;           
               while j_c <= length(j_call_indexes) ...
                       & table2array(call_stats(i_c, 'EndTime_s_')) <= table2array(call_stats(j_call_indexes(j_c), 'BeginTime_s_')) +offset
                   %Check if the the call from i overlaps with the call from j
                   if (...
                       table2array(call_stats(i_c,'BeginTime_s_')) < table2array(call_stats(j_call_indexes(j_c),'BeginTime_s_')) + offset ...
                      &( table2array(call_stats(i_c,'EndTime_s_')) > table2array(call_stats(j_call_indexes(j_c),'BeginTime_s_')) - offset...
                      | table2array(call_stats(i_c,'EndTime_s_')) > table2array(call_stats(j_call_indexes(j_c),'EndTime_s_')) - offset)...   
                      )...
                     |(...
                       table2array(call_stats(i_c,'BeginTime_s_')) > table2array(call_stats(j_call_indexes(j_c),'BeginTime_s_')) - offset ...
                      & (table2array(call_stats(i_c,'BeginTime_s_')) < table2array(call_stats(j_call_indexes(j_c),'EndTime_s_')) + offset...
                      | table2array(call_stats(i_c,'EndTime_s_')) < table2array(call_stats(j_call_indexes(j_c),'EndTime_s_')) + offset)...
                      )...                            
                        i_c_overlapping = [ i_c_overlapping j_call_indexes(j_c)];
                   end
                   j_c = j_c +1; 
               end
            end
            if ~isempty(i_c_overlapping)
               i_c_overlapping = [i_c_overlapping, i_c]; 
            end
            overlapping = vertcat(overlapping, i_c_overlapping);
        end
    end
    removed_rows = [];
    for o_i=1:length(overlapping)
        compared_rows = overlapping{o_i};
        [~,I] = sort(table2array(call_stats( compared_rows,'MeanPower_dB_Hz_')));
        removed_rows = [removed_rows compared_rows(I(1:end-1))];
    end
    call_stats(removed_rows,:) = [];
    [~,file_name,ext] = fileparts(statsFileName);
    writetable(call_stats, [statsFilePath, file_name, '_filtered',ext]);    
    msgbox(['Results saved as:', [file_name, '_filtered',ext] ],'Completed','help');
end
