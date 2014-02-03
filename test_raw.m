%t = unzip('raw_format.jpk-force','./demo');
fid = fopen('demo\segments\0\channels\height.dat');
binary = fread(fid,'single','ieee-be');
X=1:8151;
plot(X,binary)