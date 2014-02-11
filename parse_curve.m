function curve=parse_curve(pathname,fname,filterIndex)
%parameters:
%   params
%       xPos
%       yPos
%       mode(constant-height,...)
%       closedLoop (true/false)
%       sensitivity
%       springConstant
%       extendTime
%       retractTime
%       extendPauseTime
%   data
%       height
%       deflection
%       time

success_flag=1;
curve = Curve; %initiate Curve object from class
switch filterIndex
    case 1 %JPK txt file
        curve = parse_curve_jpk_ascii(pathname,fname);
    case 2 %native MultiMode curve
        curve = parse_raw_curve_multi_mode(pathname,fname);
end
