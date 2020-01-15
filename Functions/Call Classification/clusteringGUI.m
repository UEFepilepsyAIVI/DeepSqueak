function [NewclusterName, NewRejected, NewFinished, NewClustAssign] = clusteringGUI(clustAssign1,ClusteringData1,JustLooking)
% I know I shouldn't use global variables, but they are so convenient, and I was in a hurry.
clearvars -global
global k clustAssign clusters rejected ClusteringData minfreq maxfreq d ha ColorData txtbox totalCount count clusterName handle_image page pagenumber finished thumbnail_size
clustAssign = clustAssign1;
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


        
d = dialog('Visible','off','Position',[360,500,600,600],'WindowStyle','Normal','resize', 'on' );
d.CloseRequestFcn = @windowclosed;
set(d,'color',[.1, .1, .1]);
k = 1;
page = 1;

movegui(d,'center');

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
  
    clustIndex = find(clustAssign==clusters(k));
    
    if length(clustIndex) == 0
      k = 1
      valid_clusters = unique(clustAssign);

      if length(valid_clusters) == 0
          return;
      end 
      
      k = valid_clusters(1)
      page = k
      clustIndex = find(clustAssign==clusters(k))           
    end

    % Number of calls in each cluster
    for cl = 1:length(clusterName)
        count(cl) = sum(clustAssign==clusters(cl));
    end
    set(d,'name',['Cluster ' num2str(k) ' of ' num2str(length(count))])
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
    ypos = .05:.1:.75;
    xpos = .02:.14:.8;
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


            colorIM = create_thumbnail(ClusteringData,clustIndex,thumbnail_size,i,minfreq,ColorData);     
            ha(i) = axes(d,'Units','Normalized','Position',[pos(i,2),pos(i,1),.13,.09]);
            handle_image(i) = image(colorIM + .5 .* rejected(clustIndex(i)),'parent',ha(i));
            set(handle_image(i), 'ButtonDownFcn',{@clicked,clustIndex(i),i,i});
            axis(ha(i),'off');

            add_cluster_context_menu(handle_image(i),clustIndex(i));
        else
            ha(i) = axes(d,'Units','Normalized','Position',[pos(i,2),pos(i,1),.13,.09]);
            handle_image(i) = image(colorIM,'parent',ha(i));
            set(ha(i),'Visible','off')
            set(get(ha(i),'children'),'Visible','off');
            axis(ha(i),'off');

        end



    end
    

end

function plotimages
global k clustAssign clusters rejected ClusteringData minfreq d ha ColorData handle_image page thumbnail_size
clustIndex = find(clustAssign==clusters(k));


for i=1:length(ha)
    if i <= length(clustIndex) - (page - 1)*length(ha)
        set(ha(i),'Visible','off')
        set(get(ha(i),'children'),'Visible','on');
        callID = i + (page - 1)*length(ha);
        colorIM = create_thumbnail(ClusteringData,clustIndex,thumbnail_size,callID,minfreq,ColorData);

        set(handle_image(i), 'ButtonDownFcn',{@clicked,clustIndex(callID),i,callID});
        add_cluster_context_menu(handle_image(i),clustIndex(i));
        if rejected(clustIndex(callID))
            colorIM(:,:,1) = colorIM(:,:,1) + .5;
        end
     
        set(handle_image(i),'CData',colorIM);
    else
        set(ha(i),'Visible','off')
        set(get(ha(i),'children'),'Visible','off');
    end
    
end

end

function add_cluster_context_menu(hObject, i)
global clustAssign clusterName
        unique_clusters = unique(clustAssign);

        c = uicontextmenu;
        for ci=1:length(unique_clusters)
            uimenu(c,'Label',string(clusterName(ci)),'Callback',{@assign_cluster,i,unique_clusters(ci)});    
        end

        set(hObject, 'UIContextMenu',c);
end

function assign_cluster(hObject,eventdata,i, clusterIndex)
    global clustAssign d
    clustAssign(i) = clusterIndex;
    
    set(d, 'pointer', 'watch')     
    gui_components = allchild(d);

    for i=1:length(gui_components)
        if ~strcmp(gui_components(i).Type,'uicontrol')
            delete( gui_components(i));
        end
    end

    render_GUI(d)
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

colorIM = create_thumbnail(ClusteringData,clustIndex,thumbnail_size,callID,minfreq,ColorData);

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

function colorIM = create_thumbnail(ClusteringData,clustIndex,thumbnail_size,callID,minfreq,ColorData)
    im = zeros(thumbnail_size(1),thumbnail_size(2));
    im(:,:) = 0.1;
    if size(ClusteringData{clustIndex(callID),1},1) < size(ClusteringData{clustIndex(callID),1},2)
        aspect_ratio = size(ClusteringData{clustIndex(callID),1},1) / size(ClusteringData{clustIndex(callID),1},2);
        scaled_heigth = round(thumbnail_size(1) * aspect_ratio);
        offset = round((thumbnail_size(1) - scaled_heigth )/2);
        resized = imresize(ClusteringData{clustIndex(callID),1},[scaled_heigth thumbnail_size(2)]);
        start_index = offset;
        end_index = offset+scaled_heigth-1;
        if offset
            im(start_index:end_index,:) = resized;  
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
        else
            im = resized;
        end
    end       
    
    freqdata = round(linspace(ClusteringData{clustIndex(callID),2} + ClusteringData{clustIndex(callID),9},ClusteringData{clustIndex(callID),2},thumbnail_size(1)));
    colorIM(:,:,1) =  single(im).*.0039.*ColorData(freqdata - minfreq,1);
    colorIM(:,:,2) =  single(im).*.0039.*ColorData(freqdata - minfreq,2);
    colorIM(:,:,3) =  single(im).*.0039.*ColorData(freqdata - minfreq,3);    

end