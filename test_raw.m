file_name = fullfile('dane_JPK', 'force-save-2013.05.09-13.57.58.jpk-force');
mkdir('dane_JPK','curve');
t = unzip(file_name,'./tmp/curve');
folder = './tmp/curve';
%read param test
numberOfSegments = jpk_read_param(fullfile(folder, 'header.properties'),'force-scan-series.force-segments.count');
fid = fopen('tmp\curve\segments\0\channels\height.dat');
height = fread(fid,[8192 1],'integer*4','ieee-be');
fclose(fid);
heightV = 57.1792650133159 + height.*2.6631795341761734E-8;
heightM = 1.499841584421559E-5 + heightV.*1.3113872387508985E-7*(-1);
%fid2 = fopen('tmp\curve\segments\0\channels\vDeflection.dat');
%dfl = fread(fid2,[8192 1],'integer*4','ieee-be');
%fclose(fid2);
%dflV = 0.0049143712581164595 + dfl.*5.585170186197703E-9;
%dflN = 0.0 + dflV.*3.53E-8;
%rmdir('tmp/curve','s');
[h d] = jpk_read_segment_raw(folder,0,8192);



