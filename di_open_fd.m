%Output:
%1st column: Z_pos_extend [nm]
%2nd column: Z_pos_retract [nm]
%3rd column: Defl_extend [V]
%4th column: Defl_retract [V]

function Output = open_fd(file_name)

%These commands find the line numbers in the header file that contain
%the important information
pos_spl = di_header_find(file_name,'\Samps/line');
pos_data = di_header_find(file_name,'\Data offset');
scal_data = di_header_find(file_name,'\@4:Z scale: V [Sens.');
pos_senszscan =  di_header_find(file_name,'\@Sens. Zsens');
pos_ramp = di_header_find(file_name,'Ramp size Zsweep');
pos_sensdef = di_header_find(file_name,'\@Sens. DeflSens');

%Open the DI file, move to the various line numbers, and read the numbers
%therein to extact the values mentioned above.

fid = fopen(file_name,'r');
fseek( fid , pos_spl(2), -1 );
line = fgets(fid);
spl = extract_num(line);
line = fgets(fid);
linno = extract_num(line);
fseek(fid, pos_senszscan, -1);
line = fgets(fid);
senszscan = extract_num( line );
fseek(fid, pos_ramp, -1);
line = fgets(fid);
ramp = extract_num( line );
fseek(fid,pos_data(1),-1);
line = fgets(fid);
imag_pos = extract_num(line);   
fseek(fid,scal_data(1),-1);
line = fgets(fid);
scaling = extract_num(line); 
hscale = senszscan*ramp*2^16/spl;

% Go to 1st pixel data and start reading
fseek(fid,imag_pos,-1);
% Convert to PSD (normal force) volts
A = scaling*fread(fid,[1 8192] ,'int16');

%Split extend/retract data and convert to nm  
va = A(1:spl);%approach
vr = A( (spl+1) : (2*spl) );%retract
B = hscale*[1:spl]; 

%I reduce no o points because of the noise at the end
reduced_spl = ceil(0.8*spl);

%plot(B(1:reduced_spl),va(1:reduced_spl),'b')
%%% approach curve
%hold on
%plot(B(reduced_spl:-1:1),vr(reduced_spl:-1:1),'r')
%%% retract curve
%disp(spl)

%Output = [-B(1:reduced_spl)' -B(reduced_spl:-1:1)' va(1:reduced_spl)' vr(reduced_spl:-1:1)'];
Output = [B(reduced_spl:-1:1)' B(1:reduced_spl)' va(reduced_spl:-1:1)' vr(1:reduced_spl)'];

end
