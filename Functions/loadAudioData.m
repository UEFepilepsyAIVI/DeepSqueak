function [audiodata] = loadAudioData(audio_folder,file_name,audiodata)

    if nargin < 3
       audiodata = {}; 
    end
    
    if isempty(file_name)     
        return;
    end    

    file_name = [audio_folder,'/',file_name];
    file_name = strrep(file_name,'\','/');
    if ~isfile(file_name)   
        return;
    end
    
    [samples,Fs] = audioread( file_name );   
    info = audioinfo(file_name);


    audiodata.samples = samples;
    audiodata.duration = info.Duration;
    audiodata.sample_rate = info.SampleRate;    
end

