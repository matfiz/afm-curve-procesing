function param = di_read_param(fid,name)
    position = di_header_find_by_fid( fid ,  name);
    frewind(fid);
    fseek( fid , position(1), -1 );
    line = fgets(fid);
    line_reduced = regexprep(line,regexptranslate('escape', [name ': ']),'');
    numb_param = extract_num(line_reduced);
    if isempty(numb_param)
        param = line_reduced;
    else
        param = numb_param;
    end