function [x, y, z] = sph2rect( azi, elev )
%Converts a vector from spherical to rectangular coords
%   vIn = (azimuth, elevation) ; vOut = (x, y, z)
   
x = sin(azi * (pi/180)) * sin(elev * (pi/180));
y = cos(azi * (pi/180)) * sin(elev * (pi/180));
z = cos(elev * (pi/180));
end