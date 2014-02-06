%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Author: Matthew Brukman, Engineering Physics Department, University of
%Wisconsin-Madison, 1500 Engineering Dr., Madison, WI 53706.
%This function/script is authorized for use in government and academic
%research laboratories and non-profit institutions only. Though this
%function has been tested prior to its posting, it may contain mistakes or
%require improvements. In exchange for use of this free product, we 
%request that its use and any issues that may arise be reported to us. 
%Comments and suggestions are therefore welcome and should be sent to 
%Prof. Robert Carpick <carpick@engr.wisc.edu>, Engineering Physics 
%Department, UW-Madison.
%Date posted: Jan 6, 2005
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% [version] = DI_version(file_name);
%
% Function DI_version looks for '@Sens. Zscan' in file name. If found,
% version = 5, if not then looks for '\@Sens. Zsens'. If that is found,
% then version = 6
% Example 
% [version] = DI_version('file_prefix.001')

function [version] = DI_version(file_name);

% Define End of file identifier
% Open the file given in argument and reference as
% fid. Also if there was an error output error
% number and error message to screen

fid = fopen(file_name,'r');
[message,errnum] = ferror(fid);
if(errnum)
   fprintf(1,'I/O Error %d \t %s',[errnum,message]);
%   break
end

header_end=0;
eof = 0;
counter = 1;

byte_location = 0;

while( and( ~eof, ~header_end ) )
   
   byte_location = ftell(fid);
   line = fgets(fid);
   if( (-1)~=line)
       version = 5;
   end
   
   if( (-1)==line )
      eof  = 1;
      break
   end
    
   if( length( findstr(line,'\@Sens. Zscan') ) )
      position(counter) = byte_location;
      counter = counter + 1;
   end
         
   if length( findstr( line, '\*File list end' ) )
      header_end = 1;
   end
         
end

if (counter==1)
    header_end=0;
    eof = 0;
    counter = 1;
    byte_location = 0;

   while( and( ~eof, ~header_end ) )
   byte_location = ftell(fid);
   line = fgets(fid);
   if( (-1)~=line)
       version = 6;
   end
   
   if( (-1)==line )
      eof  = 1;
      break
   end
    
   if(length(findstr(line,'\@Sens. Zsens')))
      position(counter) = byte_location;
      counter = counter + 1;
   end
         
   if length( findstr( line, '\*File list end' ) )
      header_end = 1;
   end
         
end
end    
fclose(fid);
