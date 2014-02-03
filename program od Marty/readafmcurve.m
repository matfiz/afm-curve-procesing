function [s,t_do,z_do,F_do,t_od,z_od,F_od]=readafmcurve(fname)

s=1;
try
    [t_do,z_do,F_do,t_od,z_od,F_od]=textread(fname,'%f %f %f %f %f %f','headerlines',12);
catch
    ws=['File' fname 'not found or in bad format'];
    uiwait(warndlg(ws,'Warning','modal'));
    t_do=0;z_do=0;F_do=0;t_od=0;z_od=0;F_od=0;
    s=0;
end



