function [prefix,lista]=makelist()

ButtonName=questdlg('Use mask?','List','Yes','No','No');


if strcmp(ButtonName,'No')
    [FileName1,PathName] = uigetfile('*.*','Get first curve');
    if (FileName1)
        [FileName2,PathName] = uigetfile('*.*','Get last curve',[PathName '*.*']);
        if (~FileName2) 
            prefix=0; lista=0;
            return; 
        end    
    else
        prefix=0;
        lista=0;
        return;
    end
    prefix1=strtok(FileName1,'_');
    prefix2=strtok(FileName2,'_');
    if  not(strcmp(prefix1,prefix2))
        uiwait(errordlg('Try again: prefixes are not same','','modal') )
        prefix=0;lista=0;
        return;
    end
    snum1=FileName1(length(prefix1)+2:end);
    snum2=FileName2(length(prefix2)+2:end);
    num1=str2num(snum1);
    num2=str2num(snum2);

    lista=num1:num2;
    prefix=[PathName prefix1 '_'];
    
else  %strcmp(ButtonName,'Yes')
    
    p0=inputdlg({'Input mask:'},'List',[1 20]);
    prefix0=p0{1};
    
    [FileName1,PathName] = uigetfile([prefix0 '*.*'],'Get first curve');
    if (FileName1)
        [FileName2,PathName] = uigetfile([PathName prefix0 '*.*'],'Get last curve');
        if (~FileName2) 
            prefix=0; lista=0;
            return; 
        end    
    else
        prefix=0;
        lista=0;
        return;
    end 
    
    snum1=FileName1(length(prefix0)+1:end);
    snum2=FileName2(length(prefix0)+1:end);
    num1=str2num(snum1);
    num2=str2num(snum2);

    lista=num1:num2
    prefix=[PathName prefix0]
    
end
    
    
