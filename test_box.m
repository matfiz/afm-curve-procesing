list = OpenFileFilter;

[selection,button] = listdlg('PromptString','Select files type:',...
                'Name','File type selection',...
                'SelectionMode','single',...
                'ListSize',[250 100],...
                'ListString',list(:,2));
FilterIndex = selection
OpenFileFilter(FilterIndex)