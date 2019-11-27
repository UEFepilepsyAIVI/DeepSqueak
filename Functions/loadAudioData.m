function [samples, duration ,sample_rate] = loadAudioData(file_name)
    [samples,Fs] = audioread( file_name );   
    info = audioinfo(file_name);
    duration = info.Duration;
    sample_rate = info.SampleRate;
end

