function param = di_read_param_reduced(fid,name)
    position = di_header_find_by_fid( fid ,  name);
    frewind(fid);
    fseek( fid , position(1), -1 );
    line = fgets(fid);
    line_reduced = regexprep(line,regexptranslate('escape', [name ': ']),'');
    line_reduced = regexprep(line_reduced,'[\[V\s]*[a-zA-Z.\s]*\]\s\([\d.\s]*V\/LSB\)\s','');
    line_reduced = regexprep(line_reduced,'[\sV]*','');
    param = str2num(line_reduced);
  