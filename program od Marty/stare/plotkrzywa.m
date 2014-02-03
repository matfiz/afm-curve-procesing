function plotkrzywa(hObject,handles)



axprev=gca;
axes(handles.axes1);

krzywe=handles.krzywe;
i=handles.currkrzywa;
j=handles.referenceno;
switch handles.viewmode
    case 1  % view both
        z_data=[krzywe.z_do(i,:); krzywe.z_od(i,:)]';
        plot_data=[krzywe.F_do(i,:)*1e9; krzywe.F_od(i,:)*1e9]';
        pcol(1)='r';
        pcol(2)='b';
        
        if (handles.reference)
            z_data=[krzywe.z_do(i,:); krzywe.z_od(i,:);krzywe.z_do(j,:); krzywe.z_od(j,:)]';
            plot_data=[krzywe.F_do(i,:)*1e9; krzywe.F_od(i,:)*1e9;krzywe.F_do(j,:)*1e9; krzywe.F_od(j,:)*1e9]';
            pcol(1)='r';
            pcol(2)='b';
            pcol(3)='k';
            pcol(4)='g';
        end
        
    case 2   % view approach
        z_data=[krzywe.z_do(i,:)]';
        plot_data=[krzywe.F_do(i,:)*1e9];
        pcol(1)='r';
        if (handles.reference)
            z_data=[krzywe.z_do(i,:);krzywe.z_do(j,:)]';
            plot_data=[krzywe.F_do(i,:)*1e9;krzywe.F_do(j,:)*1e9];
            pcol(1)='r';
            pcol(2)='k';
        end    
    case 3   % view retract 
        z_data=[krzywe.z_od(i,:)]';
        plot_data=[krzywe.F_od(i,:)*1e9];
        myColororder=[0 0 0];
        pcol(1)='b';
        if (handles.reference)
            z_data=[krzywe.z_od(i,:);krzywe.z_od(j,:)]';
            plot_data=[krzywe.F_od(i,:)*1e9;krzywe.F_od(j,:)*1e9]';
            pcol(1)='b';
            pcol(2)='g';    
        end
end
    
hplot=plot(z_data,plot_data);
for ii=1:length(pcol);
     set(hplot(ii),'Color',pcol(ii));
end
   
  
  set(handles.filetext,'String',krzywe.fname{i});
  set(handles.curvetext,'String',['Curve No. ' num2str(i) ' of ' num2str(krzywe.n)]);
  xlabel('z [\mu m]');
  ylabel('F [nN]');

  
 switch handles.scaling
     case 0
        minvalF=min(min(min(plot_data)));
        maxvalF=max(max(max(plot_data)));
        minvalz=min(min(min(z_data)));
        maxvalz=max(max(max(z_data)));  
    case 1
        minvalF=1e9*min([min(min(krzywe.F_od)) min(min(krzywe.F_do))]);
        maxvalF=1e9*max([max(min(krzywe.F_od)) max(max(krzywe.F_do))]);
        minvalz=min([min(min(krzywe.z_od)) min(min(krzywe.z_do))]);
        maxvalz=max([max(min(krzywe.z_od)) max(max(krzywe.z_do))]);
    case 2
        minvalF=handles.userminF;
        maxvalF=handles.usermaxF;
        minvalz=handles.userminz;
        maxvalz=handles.usermaxz;
end

  
 axis([minvalz maxvalz minvalF maxvalF]);
 grid on
 
 set(gca,'Tag','axes1');
 axes(axprev);
 guidata(hObject, handles);


