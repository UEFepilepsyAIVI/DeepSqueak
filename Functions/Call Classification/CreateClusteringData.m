%% This function prepares data for clustering

function [ClusteringData, clustAssign]= CreateClusteringData(handles, forClustering)
% For each file selected, create a cell array with the image, and contour
% of calls where Calls.Accept == 1

data = handles.data;
cd(data.squeakfolder);
if forClustering
    prompt = 'Select detection file(s) for clustering AND/OR extracted contours';
else
    prompt = 'Select detection file(s) for viewing';
end

[fileName, filePath] = uigetfile(fullfile(data.settings.detectionfolder,'*.mat'),prompt,'MultiSelect', 'on');
if isnumeric(fileName);return;end

% If one file is selected, turn it into a cell
fileName = cellstr(fileName);

h = waitbar(0,'Initializing');

ClusteringData = {};
clustAssign = [];
xFreq = [];
xTime = [];
stats.Power = [];
stats.DeltaTime = [];

%% For Each File
for j = 1:length(fileName)
    file = load(fullfile(filePath,fileName{j}));
     [Calls,audiodata,loaded_ClusteringData] = loadCallfile(fullfile(filePath,fileName{j}),handles);
     
     if isfield(audiodata,'AudioFile') & ~audiodata.AudioFile
        errordlg(sprintf('File %s not found in folder %s',fileName{j},filePath ),'Audio File Error');    
     end
     
     handles.data.audiodata = audiodata;

    % If the files is extracted contours, rather than a detection file
    if forClustering & ~isempty(loaded_ClusteringData)
        ClusteringData = [ClusteringData; loaded_ClusteringData];
    elseif ~isempty(Calls)
        
        % for each call in the file, calculate stats for clustering
        for i = 1:height(Calls)
            waitbar(i/height(Calls),h,['Loading File ' num2str(j) ' of '  num2str(length(fileName))]);
            
            % Skip if not accepted
            if ~Calls.Accept(i) || ismember(Calls.Type(i),'Noise')
                continue
            end
            
            call = Calls(i,:);

            [I,wind,noverlap,nfft,rate,box,~] = CreateFocusSpectrogram(call,handles,true);
            im = mat2gray(flipud(I),[0 max(max(I))/4]); % Set max brightness to 1/4 of max
            
            if forClustering
                stats = CalculateStats(I,wind,noverlap,nfft,rate,box,data.settings.EntropyThreshold,data.settings.AmplitudeThreshold);
                spectrange = call.Rate / 2000; % get frequency range of spectrogram in KHz
                FreqScale = spectrange / (1 + floor(nfft / 2)); % size of frequency pixels
                TimeScale = (wind - noverlap) / call.Rate; % size of time pixels
                xFreq = FreqScale * (stats.ridgeFreq_smooth) + call.Box(2);
                xTime = stats.ridgeTime * TimeScale;
            end
            
            ClusteringData = [ClusteringData
                [{uint8(im .* 256)} % Image
                {call.RelBox(2)} % Lower freq
                {stats.DeltaTime} % Delta time
                {xFreq} % Time points
                {xTime} % Freq points
                {[filePath fileName{j}]} % File path
                {i} % Call ID in file
                {stats.Power}
                {call.RelBox(4)}              
                ]'];
            
            clustAssign = [clustAssign; file.Calls.Type(i)];
        end
    else
        fprintf(1, 'Skipping empty file: %s\n', fileName{j})
    end
end
close(h)
end