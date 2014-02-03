function plotkrzywaref(hObject,handles)


axprev=gca;
ax1=findobj(handles.figure1,'Tag','axes1');
axes(ax1);

krzywe=handles.krzywe;

if (handles.viewmode==1) 
    minvalF= min([min(min(krzywe.F_od)) min(min(krzywe.F_do))]);
    maxvalF=max([max(min(krzywe.F_od)) max(max(krzywe.F_do))]);
    minvalz=min([min(min(krzywe.z_od)) min(min(krzywe.z_do))]);
    maxvalz=max([max(min(krzywe.z_od)) max(max(krzywe.z_do))]);
    i=handles.currkrzywa;
    j=handles.referenceno;
    if (handles.scaling==1)
        plot(krzywe.z_do(i,:),krzywe.F_do(i,:));
        hold on
        plot(krzywe.z_od(i,:),krzywe.F_od(i,:),'r');
        plot(krzywe.z_do(j,:),krzywe.F_do(j,:),'g');
        plot(krzywe.z_od(j,:),krzywe.F_od(j,:)'k');
        hold off
        h = findobj(handles.figure1, 'Tag', 'filenametext');
        set(h,'String',krzywe.fname{i});
        h = findobj(handles.figure1, 'Tag', 'nummertext');
        set(h,'String',['Curve No. ' num2str(i) ' of ' num2str(krzywe.n)]);
        xlabel('z [\mu m]');
        ylabel('F [nN]');
        axis([minvalz maxvalz minvalF maxvalF]);
        grid on
    else
        plot(krzywe.z_do(i,:),krzywe.F_do(i,:));
        hold on
        plot(krzywe.z_od(i,:),krzywe.F_od(i,:),'r');
        plot(krzywe.z_do(j,:),krzywe.F_do(j,:),'g');
        plot(krzywe.z_od(j,:),krzywe.F_od(j,:),'k');
        hold off
        h = findobj(handles.figure1, 'Tag', 'filenametext');
        set(h,'String',krzywe.fname{i});
        h = findobj(handles.figure1, 'Tag', 'nummertext');
        set(h,'String',['Curve No. ' num2str(i) ' of ' num2str(krzywe.n)]);
        xlabel('z [\mu m]');
        ylabel('F [nN]');
        grid on
    end    
end    

if (handles.viewmode==2) 
    minvalF=min(min(krzywe.F_do));
    maxvalF=max(max(krzywe.F_do));
    minvalz=min(min(krzywe.z_do));
    maxvalz=max(max(krzywe.z_do));
    i=handles.currkrzywa;
    j=handles.referenceno;
   
    if (handles.scaling==1)
        plot(krzywe.z_do(i,:),krzywe.F_do(i,:),'b');
        hold on
        plot(krzywe.z_do(j,:),krzywe.F_do(j,:),'g');
        hold off
        h = findobj(handles.figure1, 'Tag', 'filenametext');
        set(h,'String',krzywe.fname{i});
        h = findobj(handles.figure1, 'Tag', 'nummertext');
        set(h,'String',['Curve No. ' num2str(i) ' of ' num2str(krzywe.n)]);
        xlabel('z [\mu m]');
        ylabel('F [nN]');
        axis([minvalz maxvalz minvalF maxvalF]);
        grid on
    else
        plot(krzywe.z_do(i,:),krzywe.F_do(i,:),'b');
        hold on
        plot(krzywe.z_do(j,:),krzywe.F_do(j,:),'g');
        hold off
        h = findobj(handles.figure1, 'Tag', 'filenametext');
        set(h,'String',krzywe.fname{i});
        h = findobj(handles.figure1, 'Tag', 'nummertext');
        set(h,'String',['Curve No. ' num2str(i) ' of ' num2str(krzywe.n)]);
        xlabel('z [\mu m]');
        ylabel('F [nN]');
        grid on
    end    
end    


if (handles.viewmode==3) 
    minvalF=min(min(krzywe.F_od));
    maxvalF=max(max(krzywe.F_od));
    minvalz=min(min(krzywe.z_od));
    maxvalz=max(max(krzywe.z_od));
    i=handles.currkrzywa;
    j=handles.referenceno;
   
    if (handles.scaling==1)
        plot(krzywe.z_od(i,:),krzywe.F_od(i,:),'r');
        hold on
        plot(krzywe.z_od(j,:),krzywe.F_od(j,:),'k');
        hold off
        h = findobj(handles.figure1, 'Tag', 'filenametext');
        set(h,'String',krzywe.fname{i});
        h = findobj(handles.figure1, 'Tag', 'nummertext');
        set(h,'String',['Curve No. ' num2str(i) ' of ' num2str(krzywe.n)]);
        xlabel('z [\mu m]');
        ylabel('F [nN]');
        axis([minvalz maxvalz minvalF maxvalF]);
        grid on
    else
        plot(krzywe.z_od(i,:),krzywe.F_od(i,:),'r');
        hold on
        plot(krzywe.z_od(j,:),krzywe.F_od(j,:),'k');
        hold off
        h = findobj(handles.figure1, 'Tag', 'filenametext');
        set(h,'String',krzywe.fname{i});
        h = findobj(handles.figure1, 'Tag', 'nummertext');
        set(h,'String',['Curve No. ' num2str(i) ' of ' num2str(krzywe.n)]);
        xlabel('z [\mu m]');
        ylabel('F [nN]');
        grid on
    end    
end    

set(gca,'Tag','axes1');
axes(axprev);
guidata(hObject, handles);


