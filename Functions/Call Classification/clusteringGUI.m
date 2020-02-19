function [NewclusterName, NewRejected, NewFinished, NewClustAssign] = clusteringGUI(clustAssign1,ClusteringData1,JustLooking)
% I know I shouldn't use global variables, but they are so convenient, and I was in a hurry.

clearvars -global
global k clustAssign clusters rejected ClusteringData minfreq maxfreq d ha ColorData txtbox totalCount count clusterName handle_image page pagenumber finished thumbnail_size call_id_text call_file_text
clustAssign = clustAssign1;
%Image, Lower freq, delta time, Time points, Freq points, File path, Call ID in file, power, RelBox
ClusteringData = ClusteringData1;
thumbnail_size = [60*2 100*2];
rejected = zeros(1,length(clustAssign));

minfreq = floor(min([ClusteringData{:,2}]))-1;
maxfreq = ceil(max([ClusteringData{:,2}] + [ClusteringData{:,9}]));
mfreq = cellfun(@mean,(ClusteringData(:,4)));
ColorData = jet(maxfreq - minfreq); % Color by mean frequency
if iscategorical(clustAssign)
    clusterName =unique(clustAssign);
    clusters = unique(clustAssign);
else
    clusterName = categorical(unique(clustAssign(~isnan(clustAssign))));
    clusters = (unique(clustAssign(~isnan(clustAssign))));
end
       
d = dialog('Visible','off','Position',[360,500,600,600],'WindowStyle','Normal','resize', 'on','WindowState','maximized' );
d.CloseRequestFcn = @windowclosed;
set(d,'color',[.1, .1, .1]);
k = 1;
page = 1;

movegui(d,'center');
set(d,'WindowButtonMotionFcn', @mouse_over_Callback);

txt = uicontrol('Parent',d,...
'BackgroundColor',[.1 .1 .1],...
'ForegroundColor','w',...
'Style','text',...
'Position',[120 565 80 30],...
'String','Name:');

txtbox = uicontrol('Parent',d,...
    'BackgroundColor',[.149 .251 .251],...
    'ForegroundColor','w',...
    'Style','edit',...
    'String','',...
    'Position',[120 550 80 30],...
    'Callback',@txtbox_Callback);


totalCount = uicontrol('Parent',d,...
    'BackgroundColor',[.1 .1 .1],...
    'ForegroundColor','w',...
    'Style','text',...
    'String','',...
    'Position',[330 542.5 200 30],...
    'HorizontalAlignment','left');


back = uicontrol('Parent',d,...
    'BackgroundColor',[.149 .251 .251],...
    'ForegroundColor','w',...
    'Position',[20 550 80 30],...
    'String','Back',...
    'Callback',@back_Callback);

next = uicontrol('Parent',d,...
    'BackgroundColor',[.149 .251 .251],...
    'ForegroundColor','w',...
    'Position',[220 550 80 30],...
    'String','Next',...
    'Callback',@next_Callback);

apply = uicontrol('Parent',d,...
    'BackgroundColor',[.149 .251 .251],...
    'ForegroundColor','w',...
    'Position',[440 550 60 30],...
    'String','Save',...
    'Callback',@apply_Callback);

if nargin == 2
    redo = uicontrol('Parent',d,...
        'BackgroundColor',[.149 .251 .251],...
        'ForegroundColor','w',...
        'Position',[510 550 60 30],...
        'String','Redo',...
        'Callback',@redo_Callback);
else
    redo = uicontrol('Parent',d,...
        'BackgroundColor',[.149 .251 .251],...
        'ForegroundColor','w',...
        'Position',[510 550 60 30],...
        'String','Cancel',...
        'Callback',@redo_Callback);
end
%% Paging
nextpage = uicontrol('Parent',d,...
    'BackgroundColor',[.149 .251 .251],...
    'ForegroundColor','w',...
    'Position',[220 517 80 30],...
    'String','Next Page',...
    'Callback',@nextpage_Callback);

backpage = uicontrol('Parent',d,...
    'BackgroundColor',[.149 .251 .251],...
    'ForegroundColor','w',...
    'Position',[20 517 80 30],...
    'String','Previous Page',...
    'Callback',@backpage_Callback);

pagenumber = uicontrol('Parent',d,...
    'BackgroundColor',[.1 .1 .1],...
    'ForegroundColor','w',...
    'Style','text',...
    'String','',...
    'Position',[118 509 80 30],...
    'HorizontalAlignment','center');


call_id_text = uicontrol('Parent',d,...
    'BackgroundColor',[.1 .1 .1],...
    'ForegroundColor','w',...
    'Style','text',...
    'String','',...
    'FontSize',12,...
    'Position',[200 484 200 12],...
    'HorizontalAlignment','center');

call_file_text = uicontrol('Parent',d,...
    'BackgroundColor',[.1 .1 .1],...
    'ForegroundColor','w',...
    'Style','text',...
    'String','',...
    'FontSize',12,...
    'Position',[200 472 200 12],...
    'HorizontalAlignment','center');



render_GUI(d)

% Wait for d to close before running to completion
set( findall(d, '-property', 'Units' ), 'Units', 'Normalized');
d.Visible = 'on';
uiwait(d);
NewclusterName = clusterName;
NewRejected = rejected;
NewFinished = finished;
NewClustAssign = clustAssign;
clearvars -global



end

function mouse_over_Callback(hObject, eventdata, handles)
    global ha d call_file_text call_id_text ClusteringData page clustIndex k clustAssign clusters

    call_file = '';
    call_id = '';
    
    clustIndex = find(clustAssign==clusters(k));
    
    if sum(clustAssign==clusters(k)) == 0
       return; 
    end

    for i=1:length(ha)
      
        if i <= length(clustIndex) - (page - 1)*length(ha)
            
            callID = i + (page - 1)*length(ha);
            call_index = clustIndex(callID);
            cursor_point = get(d,'currentpoint');

            axis_position = get(ha(i),'Position');

            if cursor_point(1)>axis_position(1) && cursor_point(2)>axis_position(2) && cursor_point(1) < (axis_position(1)+axis_position(3)) && cursor_point(2)<(axis_position(2)+axis_position(4))
                [~,name,~] = fileparts(ClusteringData{call_index,6});
                call_file = name ;
                call_id = num2str(ClusteringData{call_index,7});
            end
        end     
    end
        
    set(call_file_text, 'String',call_file);
    set(call_id_text, 'String',call_id);
    
end

function txtbox_Callback(hObject, eventdata, handles)
    global k clusterName
    clusterName(k) = get(hObject,'String');
end

function redo_Callback(hObject, eventdata, handles)
global finished
finished = 0;
delete(gcf)
end

function apply_Callback(hObject, eventdata, handles)
global finished
finished = 1;
delete(gcf)
end


function render_GUI(d)
global k clustAssign clusters rejected ClusteringData minfreq maxfreq d ha ColorData txtbox totalCount count clusterName handle_image page pagenumber finished thumbnail_size
  
    % Number of calls in each cluster
    for cl = 1:length(clusterName)
        count(cl) = sum(clustAssign==clusters(cl));
    end

    clustIndex = find(clustAssign==clusters(k));
      
    set(d,'name',['Cluster ' num2str(k) ' of ' num2str(length(count))]);
    set(txtbox,'String',string(clusterName(k)));
    set(totalCount,'String',['total count:' char(string(count(k)))]); 
    set(pagenumber,'String',['Page ' char(string(page)) ' of ' char(string(ceil(count(k) / length(ha) )))]);

    
    %% Colormap
    xdata = minfreq:.3:maxfreq;
    color = jet(length(xdata));
    caxis = axes(d,'Units','Normalized','Position',[.88 .05 .04 .8]);
    cm(:,:,1) = color(:,1);
    cm(:,:,2) = color(:,2);
    cm(:,:,3) = color(:,3);
    image(1,xdata,cm,'parent',caxis)
    caxis.YDir = 'normal';
    set(caxis,'YColor','w','box','off','YAxisLocation','right');
    ylabel(caxis, 'Frequency (kHz)')  

    % Number of calls in each cluster
    for cl = 1:length(clusterName)
        count(cl) = sum(clustAssign==clusters(cl));
    end

    %% Make the axes
    ypos = .05:.15:.70;
    xpos = .02:.22:.78;
    xpos = fliplr(xpos);
    c = 0;
    for i = 1:length(ypos)
        for j = 1:length(xpos)
            c = c+1;
            pos(c,:) = [ypos(i), xpos(j)];
        end
    end
    pos = flipud(pos);
    
    for i=1:i*j
        if i <= length(clustIndex) - (page - 1)*length(ha)
            callID = i + (page - 1)*length(ha);
            [colorIM, rel_x, rel_y] = create_thumbnail(ClusteringData,clustIndex,thumbnail_size,callID,minfreq,ColorData);     
            ha(i) = axes(d,'Units','Normalized','Position',[pos(i,2),pos(i,1),.18,.12]);
            handle_image(i) = image(colorIM + .5 .* rejected(clustIndex(i)),'parent',ha(i));
            set(handle_image(i), 'ButtonDownFcn',{@clicked,clustIndex(i),i,i});

            config_axis(ha(i),clustIndex(callID), rel_x, rel_y);
            add_cluster_context_menu(handle_image(i),clustIndex(callID));
        else   
            im = zeros(thumbnail_size(1),thumbnail_size(2));
            im(:,:) = 0.1;
            colorIM(:,:,1) = im;
            colorIM(:,:,2) = im;
            colorIM(:,:,3) = im;            
            ha(i) = axes(d,'Units','Normalized','Position',[pos(i,2),pos(i,1),.18,.12]);
            handle_image(i) = image(colorIM,'parent',ha(i));
            set(ha(i),'Visible','off')
            set(get(ha(i),'children'),'Visible','off');
        end
    end    

end


function config_axis(axis_handles,i, rel_x, rel_y)
global ha ClusteringData
        set(axis_handles,'xcolor','w');
        set(axis_handles,'ycolor','w');

        x_lim = xlim(axis_handles);
        x_span = x_lim(2) - x_lim(1);
        xtick_positions = linspace(x_span*rel_x(1)+x_lim(1), x_span*rel_x(2)+x_lim(1),4);            
        x_ticks = linspace(0,ClusteringData{i,3},4);
        x_ticks = arrayfun(@(x) sprintf('%.3f',x),x_ticks(2:end),'UniformOutput',false);
        
        y_lim = ylim(axis_handles);
        y_span = y_lim(2) - y_lim(1);
        ytick_positions = linspace(y_span*rel_y(1)+y_lim(1), y_span*rel_y(2)+y_lim(1),3);


        
        y_ticks = linspace(ClusteringData{i,2},ClusteringData{i,2}+ClusteringData{i,9},3);
        y_ticks = arrayfun(@(x) sprintf('%.1f',x),y_ticks(1:end),'UniformOutput',false);
        y_ticks = flip(y_ticks);

        yticks(axis_handles,ytick_positions);
        xticks(axis_handles,xtick_positions(2:end));
        xticklabels(axis_handles,x_ticks);
        yticklabels(axis_handles,y_ticks);
end

function plotimages
    global k clustAssign clusters rejected ClusteringData minfreq d ha ColorData handle_image page thumbnail_size
    clustIndex = find(clustAssign==clusters(k));

    for i=1:length(ha)
        if i <= length(clustIndex) - (page - 1)*length(ha)
           % set(ha(i),'Visible','off')
           
            set(get(ha(i),'children'),'Visible','on');
  
            callID = i + (page - 1)*length(ha);
            [colorIM, rel_x, rel_y] = create_thumbnail(ClusteringData,clustIndex,thumbnail_size,callID,minfreq,ColorData);
            set(handle_image(i), 'ButtonDownFcn',{@clicked,clustIndex(callID),i,callID});
            add_cluster_context_menu(handle_image(i),clustIndex(callID));
            if rejected(clustIndex(callID))
                colorIM(:,:,1) = colorIM(:,:,1) + .5;
            end

            set(handle_image(i),'CData',colorIM);

            config_axis(ha(i),clustIndex(callID), rel_x, rel_y);

            set(ha(i),'Visible','on')

        else
            set(ha(i),'Visible','off')
            set(get(ha(i),'children'),'Visible','off');
        end

    end

end

function add_cluster_context_menu(hObject, i)
global clustAssign clusterName
        unique_clusters = unique(clusterName);

        c = uicontextmenu;
        for ci=1:length(unique_clusters)
            uimenu(c,'Label',string(clusterName(ci)),'Callback',{@assign_cluster,i,unique_clusters(ci)});    
        end

        set(hObject, 'UIContextMenu',c);
end

function assign_cluster(hObject,eventdata,i, clusterLabel)
    global clustAssign d
    clustAssign(i) = clusterLabel;
    
    set(d, 'pointer', 'watch');     
    gui_components = allchild(d);

    for i=1:length(gui_components)
        if ~strcmp(gui_components(i).Type,'uicontrol')
            delete( gui_components(i));
        end
    end

    render_GUI(d);
    drawnow;

    set(d, 'pointer', 'arrow');
end

function clicked(hObject,eventdata,i,plotI,callID)
global k clustAssign clusters rejected ClusteringData minfreq d ha ColorData handle_image thumbnail_size k page

if( eventdata.Button ~= 1 )
    return
end

clustIndex = find(clustAssign==clusters(k));

rejected(i) = ~rejected(i);

[colorIM, rel_x, rel_y] = create_thumbnail(ClusteringData,clustIndex,thumbnail_size,callID,minfreq,ColorData);

if rejected(i)
    colorIM(:,:,1) = colorIM(:,:,1) + .5;
else 
    colorIM(:,:,1) = colorIM(:,:,1) - .5;
end

set(handle_image(plotI),'CData',colorIM);
set(handle_image(plotI), 'ButtonDownFcn',{@clicked,i,plotI,callID});

end

function next_Callback(hObject, eventdata, handles)
global k d txtbox totalCount count clusterName pagenumber page ha
clusterName(k) = get(txtbox,'String');
if k < length(clusterName)
    k = k+1;
    page = 1;
    pagenumber.String = ['Page ' char(string(page)) ' of ' char(string(ceil(count(k) / length(ha))))];
    plotimages
end

set(txtbox,'string',string(clusterName(k)))
set(totalCount,'string',['total count:' char(string(count(k)))])
set(d,'name',['Cluster ' num2str(k) ' of ' num2str(length(count))])
end

function back_Callback(hObject, eventdata, handles)
global k d txtbox totalCount count clusterName pagenumber page ha
clusterName(k) = get(txtbox,'String');
if k > 1
    k = k-1;
    page = 1;
    pagenumber.String = ['Page ' char(string(page)) ' of ' char(string(ceil(count(k) / length(ha))))];
    plotimages
end

set(txtbox,'string',string(clusterName(k)))
set(totalCount,'string',['total count:' char(string(count(k)))])
set(d,'name',['Cluster ' num2str(k) ' of ' num2str(length(count))])
end

function nextpage_Callback(hObject, eventdata, handles)
global page pagenumber count k ha
if page < ceil(count(k) / length(ha))
    page = page + 1;
    pagenumber.String = ['Page ' char(string(page)) ' of ' char(string(ceil(count(k) / length(ha))))];
    plotimages
end
end

function backpage_Callback(hObject, eventdata, handles)
global page pagenumber count k ha
if page > 1
    page = page - 1;
    pagenumber.String = ['Page ' char(string(page)) ' of ' char(string(ceil(count(k) / length(ha))))];
    plotimages
end
end

function windowclosed(hObject, eventdata, handles)
global finished
finished = 2;
delete(hObject)
end

function [colorIM, rel_x, rel_y] = create_thumbnail(ClusteringData,clustIndex,thumbnail_size,callID,minfreq,ColorData)
    im = zeros(thumbnail_size(1),thumbnail_size(2));
    im(:,:) = 0.1;
    
    rel_x = [0 1];
    rel_y = [0 1];   
    
    if size(ClusteringData{clustIndex(callID),1},1) < size(ClusteringData{clustIndex(callID),1},2)
        aspect_ratio = size(ClusteringData{clustIndex(callID),1},1) / size(ClusteringData{clustIndex(callID),1},2);
        scaled_heigth = round(thumbnail_size(1) * aspect_ratio);
        offset = round((thumbnail_size(1) - scaled_heigth )/2);
        resized = imresize(ClusteringData{clustIndex(callID),1},[scaled_heigth thumbnail_size(2)]);
        start_index = offset;
        end_index = offset+scaled_heigth-1;
        if offset
            im(start_index:end_index,:) = resized;  
            rel_y = [start_index / size(im,1) end_index / size(im,1)]; 
        else
            im = resized;
        end
    else 
        aspect_ratio = size(ClusteringData{clustIndex(callID),1},1) / size(ClusteringData{clustIndex(callID),1},2);
        scaled_width = round(thumbnail_size(2) / aspect_ratio);
        offset = round((thumbnail_size(2) - scaled_width )/2);
        resized = imresize(ClusteringData{clustIndex(callID),1},[thumbnail_size(1) scaled_width]);
        start_index = max(offset,1);
        end_index = offset+scaled_width-1;
        if offset 
            im(:,start_index:end_index) = resized;  
            rel_x = [start_index / size(im,2) end_index / size(im,2)]; 
        else
            im = resized;
        end
    end   
    

    
    freqdata = round(linspace(ClusteringData{clustIndex(callID),2} + ClusteringData{clustIndex(callID),9},ClusteringData{clustIndex(callID),2},thumbnail_size(1)));
    colorIM(:,:,1) =  single(im).*.0039.*ColorData(freqdata - minfreq,1);
    colorIM(:,:,2) =  single(im).*.0039.*ColorData(freqdata - minfreq,2);
    colorIM(:,:,3) =  single(im).*.0039.*ColorData(freqdata - minfreq,3);    

end