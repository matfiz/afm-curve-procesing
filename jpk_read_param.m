function param = jpk_read_param(file,name)
    tfile = fopen(file, 'r');
    file_content_array = textscan(tfile,'%s','delimiter', '\n', 'whitespace', '');
    lines = file_content_array{1};
    fclose(tfile);
    IndexC = strfind(lines, [name '=']);
    Index = find(~cellfun('isempty', IndexC), 1);
    param = sscanf(lines{Index},[name '=%s']);
    