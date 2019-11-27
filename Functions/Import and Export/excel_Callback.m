function excel_Callback(hObject, eventdata, handles)

    function t = loop_calls(Calls, hc,includereject,waitbar_text,handles)

        exceltable = [{'ID'} {'Label'} {'Accepted'} {'Score'}  {'Begin Time (s)'} {'End Time (s)'} {'Call Length (s)'} {'Principal Frequency (kHz)'} {'Low Freq (kHz)'} {'High Freq (kHz)'} {'Delta Freq (kHz)'} {'Frequency Standard Deviation (kHz)'} {'Slope (kHz/s)'} {'Sinuosity'} {'Mean Power (dB/Hz)'} {'Tonality'}];
        for i = 1:height(Calls) % Do this for each call
            waitbar(i/height(Calls),hc,waitbar_text);

            if includereject || Calls.Accept(i)
                % Get spectrogram data
                 [I,windowsize,noverlap,nfft,rate,box,window_start] = CreateFocusSpectrogram(Calls(i, :),handles,true);
                % Calculate statistics
                stats = CalculateStats(I,windowsize,noverlap,nfft,rate,box,handles.data.settings.EntropyThreshold,handles.data.settings.AmplitudeThreshold);

                ID = i;
                Label = Calls.Type(i);
                Score = Calls.Score(i);
                accepted = Calls.Accept(i);
                exceltable = [exceltable; {ID} {Label} {accepted} {Score} {stats.BeginTime} {stats.EndTime} {stats.DeltaTime} {stats.PrincipalFreq} {stats.LowFreq} {stats.HighFreq} {stats.DeltaFreq} {stats.stdev} {stats.Slope} {stats.Sinuosity} {stats.MaxPower} {stats.SignalToNoise}];
            end

        end
        t = cell2table(exceltable);

    end

    export_Calls(@loop_calls,'_Stats.xlsx',hObject, eventdata, handles);
close(hc);
guidata(hObject, handles);
end