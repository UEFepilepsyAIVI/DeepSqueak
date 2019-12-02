function set_tick_timestamps(axes,milliseconds)
   
    x_tick_seconds = xticks(axes);
    x_tick_minutes = x_tick_seconds / 60;
    x_tick_seconds = (x_tick_minutes - floor(x_tick_minutes))*60;

    x_tick_minutes = strsplit(sprintf('%.0f ', floor(x_tick_minutes))); 
    x_tick_milliseconds = strsplit(sprintf('%.0f ',(x_tick_seconds - floor(x_tick_seconds))*1000));
    x_tick_seconds = strsplit(sprintf('%.0f ',floor(x_tick_seconds)));
    if milliseconds
        labels = char(strcat( x_tick_minutes,':',x_tick_seconds,'.',x_tick_milliseconds));       
    else
        labels = char(strcat( x_tick_minutes,':',x_tick_seconds));
    end    
    xticklabels(axes,labels);
end

