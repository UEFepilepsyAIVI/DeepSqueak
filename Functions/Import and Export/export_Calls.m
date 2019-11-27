function export_Calls(loop_function, file_postfix, hObject, eventdata, handles)
% hObject    handle to excel (see GCBO)
% This function xports selected call files to excel sheets with stats for each call

%% Select Files
% Select the files
[fname, fpath] = uigetfile([char(handles.data.settings.detectionfolder) '/*.mat'],'Select Files to Export:','MultiSelect', 'on');
if isnumeric(fname); return; end
fname = cellstr(fname);

% Do we include calls that were rejected?
includereject = questdlg('Include Rejected Calls?','Export','Yes','No','No');
if isempty(includereject); return; end
includereject = strcmp(includereject,'Yes');

% Specifiy the output folder
PathName = uigetdir(handles.data.settings.detectionfolder,'Select Output Folder');
if isnumeric(PathName); return; end

%% Make the output tables
hc = waitbar(0,'Initializing');
for j = 1:length(fname) % Do this for each file
    currentfile = fullfile(fpath,fname{j});
    Calls = loadCallfile(currentfile);
    
    t = loop_function(Calls,hc,includereject,['Exporting calls from file ' num2str(j) ' of ' num2str(length(fname))],handles);
    
    % Name the output file. If the file already exists, delete it so that
    % writetable overwrites the data instead of appending it to the table.
    [~,FileName]=fileparts(currentfile);
    outputName = fullfile(PathName,[FileName file_postfix]);
    if exist(outputName, 'file')==2
        delete(outputName);
    end
    
    writetable(t,outputName,'WriteVariableNames',0');
    
end
close(hc);
guidata(hObject, handles);