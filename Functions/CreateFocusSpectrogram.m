function [I,windowsize,noverlap,nfft,rate,box,s,fr,ti,audio,AudioRange,window_start] = CreateFocusSpectrogram(call,handles, call_only)
%% Extract call features for CalculateStats and display

if nargin < 3
    call_only = false;
end

rate = call.Rate;
box = call.Box;

if ~isfield(handles,'current_focus_position')
    handles.current_focus_position = [];
end

if ~isempty(handles.current_focus_position) & ~call_only
    box = handles.current_focus_position;   
end

if ~isempty(handles.current_focus_position) & handles.current_focus_position(1) < 0
   handles.current_focus_position(1) = 0; 
end

padding_value_index = get(handles.focusWindowSizePopup,'Value');
windowsize_value =  get(handles.focusWindowSizePopup,'String');
seconds = regexp(windowsize_value{padding_value_index},'([\d*.])*','match');
seconds = str2num(seconds{1});

window_width = round(handles.data.audiodata.sample_rate*seconds);

call_box_in_samples = round( handles.data.audiodata.sample_rate*box);
call_box_start = call_box_in_samples(1);
call_box_end = call_box_in_samples(1) + call_box_in_samples(3);
call_box_width =   call_box_in_samples(3);

if call_only
    call_box_offset = 0;
    window_width = call_box_in_samples(3);
else
    call_box_offset = (window_width - call_box_width )/2;
end

window_start = max(call_box_start -call_box_offset,1);
window_stop = min(call_box_end + call_box_offset, length(handles.data.audiodata.samples));

if window_start == 1
    window_stop = window_start + seconds* handles.data.audiodata.sample_rate;
end

audio = handles.data.audiodata.samples(window_start:window_stop); 

rel_pos_start = (call_box_start - window_start ) / window_width; 
rel_pos_stop = (call_box_end-window_start) / window_width; 

if ~isfloat(audio)
    audio = double(audio) / (double(intmax(class(audio)))+1);
elseif ~isa(audio,'double')
    audio = double(audio);
end

windowsize = round(rate * 0.0032);
noverlap = round(rate * 0.0028);
nfft = round(rate * 0.0032);



% Spectrogram
[s, fr, ti] = spectrogram(audio,windowsize,noverlap,nfft,rate,'yaxis');


%% Get the part of the spectrogram within the box

if ~isempty(handles.current_focus_position) | call_only
   rel_pos_start = 0;
   rel_pos_stop = 1;
end


x1 = max(round(length(ti)*rel_pos_start),1);

x2 = min( length(ti),round(length(ti)*rel_pos_stop));
if isempty(x2)
   x2=length(ti); 
end

if ~isempty(handles.current_focus_position)
   x1 = 1;
   x2=length(ti);
end
y1=find(fr./1000>=round(call.Box(2)),1);
y2=find(fr./1000>=round(call.Box(2)+call.Box(4)),1);

I=abs(s(:,x1:x2));

if call_only
    y1=find(fr./1000>=round(call.Box(2)),1);
    y2=find(fr./1000>=round(call.Box(2)+call.Box(4)),1);
    I=abs(s(y1:y2,x1:x2));
end


box_f = [rel_pos_start,box(2),rel_pos_stop - rel_pos_start,box(4)];

% Audio range of box, for display
AudioRange = round([rel_pos_start,rel_pos_stop] * (window_stop - window_start));
window_start = max(box(1) - ( seconds - (box(3)))/2,0);

end